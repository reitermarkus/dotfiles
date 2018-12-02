task :python => [:'brew:casks_and_formulae'] do
  if which("pip")
    # Install `six` in order not to break LLDB when non-system Python is first in `PATH`.
    installed = begin
      capture("pip", "show", "six")
    rescue NonZeroExit
      false
    end

    unless installed
      command "pip", "install", "six"
    end
  end
end
