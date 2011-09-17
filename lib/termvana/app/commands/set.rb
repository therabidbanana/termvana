module Termvana
  class SetCommand < Command
    type :builtin
    response :none
    name "set"
    def call
      key, val = request[1].match(/(.+)=(.+)/) do |matches|
        [matches[1], matches[2]]
      end
      environment.env[key] = val
      finish
    end
  end
end

Termvana::CommandProcessor.register(Termvana::SetCommand)

