module Termvana
  class Command
    attr_accessor :request, :environment
    def initialize(environment, request)
      @request = request
      @environment = environment
    end

    def finish
      if !self.class.response || self.class.response == :none
        respond_with :null
      end
    end

    def respond_with(opts = {})
      if opts == :null
        environment.send_message Termvana::Response.new
      elsif data = opts.delete(:text)
        environment.send_message Termvana::Response.new(:message => data)
      elsif data = opts.delete(:error)
        environment.send_message Termvana::Response.new(:message => data, :type => :error)
      end
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
