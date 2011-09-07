require 'json'
require 'ripl/completion'

module Termvana
  # Included into Ripl::Shell at runtime
  module Shell
    def web_loop_once(input)
      super
      @eval_error = nil
      @input[/^:AUTOCOMPLETE:/] ? get_completions(@input) : loop_once
    rescue Exception => e
      exit if e.message[/uncaught throw/]
      html_error(e, "Internal #{@name} error of doom: ")
    end

    def print_result(result)
      @eval_error || format_result(@result)
    end

    def before_loop
      @command_mode = :ruby
      @real_buffer  = nil
      super
      # register bond completion
      Ripl.config[:completion][:gems] ||= []
      Ripl.config[:completion][:gems] << 'ripl-fresh'
    end

    # get result (depending on @command_mode)
    def loop_eval(input)
      if input == ''
        @command_mode = :system and return
      end

      case @command_mode
      when :system # generate ruby code to execute the command
        
        @result_storage = "foobarbazquux" if !@result_storage
        @result_operator = "=>" if !@result_operator
        temp_file = "/tmp/ripl-fresh_#{ rand 12345678901234567890 }"
        ruby_command_code = "_ = system '#{ input } 2>&1', :out => '#{ temp_file }'\n"
        
        # assign result to result storage variable
        case @result_operator
        when '=>', '=>>', ':='
          result_literal   = "[]"
          formatted_result = "File.read('#{ temp_file }').split($/)"
          operator = @result_operator == '=>>' ? '+=' : '='
        when '~>', '~>>'
          result_literal = "''"
          formatted_result = "File.read('#{ temp_file }')"
          operator = @result_operator == '~>>' ? '<<' : '='
        end
        ruby_command_code << %Q%
          #{ @result_storage } ||= #{ result_literal }
          #{ @result_storage } #{ operator } #{ formatted_result }
          FileUtils.rm '#{ temp_file }'
          #{ @result_storage }
        %

        # ruby_command_code << "raise( SystemCallError.new $?.exitstatus ) if !_\n" # easy auto indent
        # ruby_command_code << "if !_ then raise( SystemCallError.new $?.exitstatus ) else #{@result_storage} end"
        @stdout, @stderr, result = Util.capture_all { super(@input = ruby_command_code)}
        result
      when :mixed # call the ruby method, but with shell style arguments TODO more shell like (e.g. "")
        method_name, *args = *input.split
        @stdout, @stderr, result = Util.capture_all { super(@input = "#{ method_name }(*#{ args })")}
        result
      else # good old :ruby
        @stdout, @stderr, result = Util.capture_all { super(input) }
        result
      end
    end

    # determine @command_mode
    def get_input
      command_line = super

      # This case statement decides the command mode,
      #  and which part of the input should be used for what...
      #  Note: Regexp match groups are used!
      @result_storage = @result_operator = nil

      @command_mode = case command_line
      # force ruby with a space
      when /^ /
        :ruby
      # regexp match shell commands
      when *Array( Ripl.config[:fresh_patterns] ).compact
        command_line     = $~[:command_line]     if $~.names.include? 'command_line'
        command          = $~[:command]          if $~.names.include? 'command'
        @result_operator = $~[:result_operator]  if $~.names.include? 'result_operator'
        @result_storage  = $~[:result_storage]   if $~.names.include? 'result_storage'
        forced           = !! $~[:force]         if $~.names.include? 'force'

        if forced
          :system
        elsif Ripl.config[:fresh_ruby_commands].include?( command )
          :ruby
        elsif Ripl.config[:fresh_mixed_commands].include?( command )
          :mixed
        elsif Ripl.config[:fresh_system_commands].include?( command )
          :system
        elsif Kernel.respond_to? command.to_sym
          :ruby
        else
          Ripl.config[:fresh_unknown_command_mode]
        end
      else
        Ripl.config[:fresh_default_mode]
      end

      command_line
    end

    def print_eval_error(error)
      @eval_error = html_error(error, '')
    end

    def format_result(result)
      stdout, stderr, output = Util.capture_all { super }
      @stdout << (stdout.empty? ? output : stdout)
      @stderr << stderr
      output = Util.format_output(@stdout, (@command_mode != :ruby))
      output = "<div class='nirvana_warning'>#{@stderr}</div>" + output unless @stderr.to_s.empty?
      output
    end

    protected
    def html_error(error, message)
      "<span class='nirvana_exception'>#{Util.format_output(message + format_error(error))}</span>"
    end

    def get_completions(input)
      arr = completions input.sub(/^:AUTOCOMPLETE:\s*/, '')
      ':AUTOCOMPLETE: ' + JSON.generate(arr)
    end

    def completions(line_buffer)
      input = line_buffer[/([^#{Bond::Readline::DefaultBreakCharacters}]+)$/,1]
      arr = Bond.agent.call(input || line_buffer, line_buffer)
      return [] if arr[0].to_s[/^Bond Error:/] #silence bond debug errors
      return arr if input == line_buffer
      chopped_input = line_buffer.sub(/#{Regexp.quote(input.to_s)}$/, '')
      arr.map {|e| chopped_input + e }
    end
  end
end
