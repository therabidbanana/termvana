class Environment
  include Virtus
  attribute :cwd, String
  def messenger
    @messenger = Proc.new
  end
  def send_message(response)
    @messenger[response]
  end
end

