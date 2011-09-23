module Termvana
  class Command
    attr_accessor :request, :environment, :cid
    def initialize(environment, request)
      @request = request
      @environment = environment
      @cid = @request.cid
    end

    def finish
      if !self.class.response || self.class.response == :none
        respond_with :null
      end
    end

    def respond_with(*args)
      opts = args.extract_options!
      opts[:cid] = @cid
      opts[:message] ||= args.shift if args.first.is_a? String
      
      if args.first == :null
        opts = {}
      elsif data = opts.delete(:text)
        opts[:message] ||= data
      elsif data = opts.delete(:error)
        opts[:message] ||= data
        opts[:type] = :error
      end
      opts[:type] ||= self.class.response
      environment.send_message(request,Termvana::Response.new(opts))
    end


    def self.type(arg = false)
      @type = arg if arg
      @type
    end
    def self.response(arg = false)
      @response = arg if arg
      @response
    end
    def self.name(arg = false)
      @name = arg if arg
      @name
    end
    def self.match?(request)
      self.name.match(/^#{request[0]}$/)
    end
  end
end
