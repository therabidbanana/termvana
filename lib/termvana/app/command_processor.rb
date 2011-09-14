class CommandProcessor < EventMachine::Connection
  include EventMachine::Deferrable
  attr_accessor :environment, :command
  # https://gist.github.com/535644
  #

  def initialize(environment, command)
    @environment = environment
    @command = command
  end

  # In the command processor, we are sending/recieving data over an
  # I/O pipe to a command
  def prepare_and_run
    send_data "cd #{environment.cwd}\n"
    send_data command.full_command
    send_data "\n"
  end


  def receive_data data
    environment.send_message(Response.new(:message => data))
  end

  def unbind
    puts "ruby died with exit status: #{get_status.exitstatus}"
  end
  
end
