module Termvana
  class Response
    include Virtus
    attribute :message, String, :default => ""
    attribute :type, Symbol, :default => :output

    def to_s
      attributes.to_json
    end
  end
end
