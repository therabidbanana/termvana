module Termvana
  class CommandProcessor < EventMachine::Connection
    include EventMachine::Deferrable
    attr_accessor :environment, :command
    # https://gist.github.com/535644
    #
    def self.register(command_klass)
      @command_list ||=[]
      @command_list << command_klass
    end

    def self.parse(environment, request)
      @command_list ||= []
      command_klass = @command_list.detect{|klass| klass.match?(request)}
      if command_klass
        command_klass.new(environment, request)
      else
        # Simple case - popen and set a timeout
        lambda do 
          process = EM.popen3(environment.runnable(request), self, environment)
          process.callback do |data|
            environment.send_message Termvana::Response.new(:message => data)
          end
          process.errback do |data|
            environment.send_message Termvana::Response.new(:message => "Command timed out.", :type => :error)
          end
          process.timeout(10)
        end
      end
    end

    def initialize(environment)
      @environment = environment
      # @command = command
      environment.setup
    end

    # In the command processor, we are sending/recieving data over an
    # I/O pipe to a command
    def prepare_and_run
      # send_data "cd #{environment.cwd}\n"
      # send_data command.full_command
      # send_data "\n"
      # send_data "exit\n"
    end


    def receive_data data
      environment.send_message(Response.new(:message => data))
    end

    def receive_stderr data
      data.gsub!(/^env:\s+/, '')
      environment.send_message(Response.new(:message => data, :type => :error))
    end

    def unbind
      cancel_timeout
      # puts "exit status: #{get_status.exitstatus}"
    end
    
  end
end
