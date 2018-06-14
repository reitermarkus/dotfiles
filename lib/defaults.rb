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

  def write(key, value, add: false)
    command '/usr/bin/defaults', 'write', bundle_id, key, *args(value, add: add)
  end

  def delete(*args)
    command '/usr/bin/defaults', 'delete', bundle_id, *args
  end

  private

  def args(value, add: false)
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
      [
        add ? '-dict-add' : '-dict',
        *value.flat_map { |k, v| [k.to_str, to_arg(v)] },
      ]
    when Array
      [
        add ? '-array-add' : '-array',
        *value.map { |v| to_arg(v) },
      ]
    when StringIO
      ['-data', value.read]
    end
  end

  def to_arg(value)
    value.respond_to?(:to_plist) ? value.to_plist(false) : args(value)
  end
end

def defaults(bundle_id, &block)
  Defaults.new(bundle_id, &block)
end
