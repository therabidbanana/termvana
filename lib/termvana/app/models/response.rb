class Response
  include Virtus
  attribute :message, String
  attribute :type, Symbol, :default => :output

  def to_s
    attributes.to_json
  end
end
