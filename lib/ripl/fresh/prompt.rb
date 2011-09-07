# save current prompt
ripl_prompt = Ripl.config[:prompt] # FIXME currently not working

# setup default prompt
default_prompt = proc{ |path = FileUtils.pwd|
  path.sub!(File.expand_path('~'),'~')
  path + '> '
}

# PS environment variable prompt
ps_prompt = proc{ |prompt_number|
  time = Time.now
  shell_version = `#{ENV['SHELL']} --version`

  prompt = ENV["PS#{prompt_number}"].dup
  prompt.gsub!('\a', '')                              # unsupported
  prompt.gsub!('\d', time.strftime("%a %b %d"))
  prompt.gsub!(/\\D\{([^}]+)\}/){time.strftime($1)}
  prompt.gsub!('\e', "\033")
  prompt.gsub!('\h', ENV['HOSTNAME'].split('.',2).first)
  prompt.gsub!('\H', ENV['HOSTNAME'].chomp)
  prompt.gsub!('\j', '')                              # unsupported
  prompt.gsub!('\l', '')                              # unsupported
  prompt.gsub!('\n', "\n")
  prompt.gsub!('\r', "\r")
  prompt.gsub!('\s', 'fresh')
  prompt.gsub!('\t', time.strftime("%H:%M:%S"))
  prompt.gsub!('\T', time.strftime("%I:%M:%S"))
  prompt.gsub!('\@', time.strftime("%I:%M %p"))
  prompt.gsub!('\A', time.strftime("%H:%M"))
  prompt.gsub!('\u', ENV['USER'])
  prompt.gsub!('\v', shell_version.gsub(/(.*(\d+\.\d+)\..*)/m){$2})
  prompt.gsub!('\V', shell_version.gsub(/(.*(\d+\.\d+\.\d+).*)/m){$2})
  prompt.gsub!('\w', FileUtils.pwd.sub(File.expand_path('~'),'~'))
  prompt.gsub!('\W', File.basename(FileUtils.pwd.sub(File.expand_path('~'), '~')))
  prompt.gsub!('\!', '')                              # unsupported
  prompt.gsub!('\#', '')                              # unsupported
  prompt.gsub!('\$', (Process.uid == 0) ? '#' : '$')

  prompt
}

# feel free to add your own creative one ;)
prompt_collection = {
  :default => default_prompt,
  :ripl    => ripl_prompt,
  :irb     => proc{ IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_I] },
  :simple  => '>> ',
}

# register proc ;)
Ripl.config[:prompt] = proc{
  fp = Ripl.config[:fresh_prompt]

  # transform symbol to valid prompt
  if fp.is_a? Symbol
    fp_known = prompt_collection[fp]
    fp_known ||= case fp.to_s # maybe it's a special symbol
                 when /^PS(\d+)/
                   ps_prompt[ $1 ]
                 else # really unknown
                   Ripl.config[:fresh_prompt] = :default
                   default_prompt
                 end

    fp = fp_known
  end

  # call if proc or return directly
  if fp.respond_to? :call
    fp[ FileUtils.pwd ]
  else
    case fp
    when nil, false
      ''
    when String
      fp
    else
      Ripl.config[:fresh_prompt] = :default
      default_proc.call
    end
  end
}

# J-_-L

