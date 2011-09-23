module Termvana
  class Request
    include Virtus
    attribute :full_command, String
    attribute :cid, String
    attribute :type, Symbol, :default => :standard
    def initialize(*args)
      if args.first.is_a? String
        command = JSON.parse(args.first).symbolize_keys
        super(command)
      else
        super(*args)
      end
    end

    def [](*args)
      @tokens ||= Shellwords.split(full_command)
      @tokens[*args]
    end

    def to_s
      attributes.to_json
    end

  end
end
