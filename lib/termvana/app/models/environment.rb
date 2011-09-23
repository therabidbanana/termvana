module Termvana
  class Environment
    include Virtus
    attribute :cwd, String, :default => "~"
    attribute :env, Hash, :default => {}
    def messenger
      @messenger = Proc.new
    end
    def send_message(request, response)
      @messenger[request, response]
    end
    def fullpath(path)
      path.gsub("~", home)
    end
    def home
      env['HOME']
    end
    def setup
      begin
        Dir.chdir(fullpath(cwd))
      rescue
      end
    end
    def envs
      my_envs = env.map do |k, v|
        "#{k.upcase}=#{v}"
      end.join(" ")
    end
    def runnable(request)
      "env -i #{envs} #{request.full_command}"
    end
  end

end
