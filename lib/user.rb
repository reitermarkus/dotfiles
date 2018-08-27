require 'etc'
require 'delegate'

class DynamicConstant < Delegator
  def initialize(&callable)
    super(callable)
  end

  def __getobj__
    @__callable__.call
  end

  def __setobj__(callable)
    @__callable__ = callable
  end
end

USER = DynamicConstant.new { Etc.getlogin }
HOME = DynamicConstant.new { File.expand_path('~') }
