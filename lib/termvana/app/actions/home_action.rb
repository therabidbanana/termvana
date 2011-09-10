class HomeAction < Cramp::Action
  def start
    render File.read(File.join(Termvana::Application.root(:public), 'index.html'))
    finish
  end
end

