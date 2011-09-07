require 'stringio'
require 'escape_utils'

module Termvana
  module Util
    extend self

    def capture_stdout
      out = StringIO.new
      $stdout = out
      yield
      return out.string
    ensure
      $stdout = STDOUT
    end

    def capture_stderr
      out = StringIO.new
      $stderr = out
      yield
      return out.string
    ensure
      $stderr = STDERR
    end

    def capture_all
      stdout, stderr, result = nil
      stderr = capture_stderr do
        stdout = capture_stdout do
          result = yield
        end
      end
      [stdout, stderr, result]
    end

    def format_output(response, code = false)
      if code && response.is_a?(Array)
        new_response = ""
        response.each do |line|
          new_response << "\n"
        end
        response = "<code><pre>"+EscapeUtils.escape_html(new_response)+"</pre></code>"
      end
      EscapeUtils.escape_html(response).gsub("\n", "<br>").gsub("\t", "    ").gsub(" ", "&nbsp;")
    end
  end
end
