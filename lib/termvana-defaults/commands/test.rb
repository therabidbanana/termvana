class TestTermvanaCommand < Termvana::Command
  type :builtin
  name "termvana-test"
  def call
    respond_with(:text => "Ran termvana-test comand")
  end
end
