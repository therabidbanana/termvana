module Termvana
  class CdCommand < Command
    type :builtin
    response :none
    name "cd"
    def call
      dir = request[1] || "~"
      Dir.chdir(environment.fullpath(dir))
      environment.env["PWD"] = environment.cwd = Dir.pwd
      # Send system env update to JS
      respond_with(:data => {:environment => environment}, :type => :system)
      # Terminate with null message
      finish
    end
  end
end

Termvana::CommandProcessor.register(Termvana::CdCommand)
