require 'command'
require 'plist'

class Defaults
  attr_reader :bundle_id

  def initialize(bundle_id = nil, current_host: nil, &block)
    @bundle_id = bundle_id || current_host
    @current_host = '-currentHost' if !current_host.nil?
    @sudo = sudo if @bundle_id.start_with?('/') && !File.writable?(File.dirname(@bundle_id))
    instance_eval(&block) if block_given?
  end

  def read(key = nil)
    capture '/usr/bin/defaults', *@current_host, 'read', bundle_id, *key
  end

  def write(key, value, add: false)
    if add && value.is_a?(Array)
      file = "#{bundle_id}.plist"
      file = File.expand_path("~/Library/Preferences/#{file}") unless file.start_with?('/')

      if File.exist?(file)
        plist = Plist.parse_xml(capture '/usr/bin/plutil', '-convert', 'xml1', '-o', '-', file)
        value = value.reject { |v| plist[key].include?(v) }
      end
    end

    command *@sudo, '/usr/bin/defaults', *@current_host, 'write', bundle_id, key, *args(value, add: add)
  end

  def delete(*args)
    command *@sudo, '/usr/bin/defaults', *@current_host, 'delete', bundle_id, *args
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
