require 'command'
require 'plist'

class Defaults
  attr_reader :bundle_id

  def initialize(bundle_id, &block)
    @bundle_id = bundle_id
    instance_eval(&block) if block_given?
  end

  def read(key)
    capture '/usr/bin/defaults', 'read', bundle_id, key
  end

  def write(key, value)
    command '/usr/bin/defaults', 'write', bundle_id, key, *args(value)
  end

  def delete(*args)
    command '/usr/bin/defaults', 'delete', bundle_id, *args
  end

  private

  def args(value)
    case value
    when true, false
      ['-bool', value.to_s]
    when Float
      ['-float', value.to_s]
    when ->(v) { v.respond_to?(:to_int) }
      ['-int', value.to_int.to_s]
    when String
      ['-string', value]
    when Hash
      ['-dict-add', *value.flat_map { |k, v| [k.to_str, args(v)] }]
    when Array
      ['-array', value.to_plist(false)]
    end
  end
end

def defaults(bundle_id, &block)
  Defaults.new(bundle_id, &block)
end
