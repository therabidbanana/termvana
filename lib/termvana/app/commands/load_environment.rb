module Termvana
  class LoadEnvironmentCommand < Command
    type :builtin
    response :system
    name "load_environment"
    def call
      respond_with(:data => {:environment => environment})
      respond_with(:null)
    end
  end
end

Termvana::CommandProcessor.register(Termvana::LoadEnvironmentCommand)


