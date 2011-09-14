class Command
  include Virtus
  attribute :full_command, String
  attribute :type, Symbol, :default => :standard
  def initialize(*args)
    puts "command is #{args.inspect}"
    if args.first.is_a? String
      command = JSON.parse(args.first).symbolize_keys
      super(command)
    else
      super(*args)
    end
  end
  def to_s
    attributes.to_json
  end
end

