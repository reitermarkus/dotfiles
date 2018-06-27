require 'etc'

class << USER = BasicObject.new
  def method_missing(symbol, *args)
    ::Etc.getlogin.public_send(symbol, *args)
  end
end

class << HOME = BasicObject.new
  def method_missing(symbol, *args)
    ::File.expand_path('~').public_send(symbol, *args)
  end
end
