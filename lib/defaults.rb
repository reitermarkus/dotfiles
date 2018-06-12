require 'command'
require 'plist'

def defaults(bundle_id, key, value = :read)
  action = case value
  when :read
    capture '/usr/bin/defaults', 'read', bundle_id, key
  when nil
    command '/usr/bin/defaults', 'delete', bundle_id, key
  else
    args = case value
    when true, false
      ['-bool', value.to_s]
    when Float
      ['-float', value.to_s]
    when ->(v) { v.respond_to?(:to_int) }
      ['-int', value.to_int.to_s]
    when String
      ['-string', value]
    when Hash
      ['-dicts', value.to_plist(false)]
    when Array
      ['-array', value.to_plist(false)]
    end

    args = ['/usr/bin/defaults', 'write', bundle_id, key, *args]

    command *args
  end
end
