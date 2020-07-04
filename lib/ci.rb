# frozen_string_literal: true

def ci?
  ENV.key?('CI') || travis? || azure?
end

def travis?
  ENV['USER'] == 'travis'
end

def azure?
  ENV['TF_BUILD'] == 'True'
end
