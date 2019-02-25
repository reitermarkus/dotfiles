# frozen_string_literal: true

require 'command'
require 'plist'

class Defaults
  attr_reader :app, :bundle_id

  def initialize(bundle_id = nil, app: nil, current_host: nil, &block)
    @app = ['-app', app] if app
    @bundle_id = bundle_id || current_host
    @current_host = '-currentHost' unless current_host.nil?
    @sudo = sudo if @bundle_id&.start_with?('/') && !File.writable?(File.dirname(@bundle_id))
    @file = File.expand_path("~/Library/Preferences/#{@bundle_id}.plist")
    instance_eval(&block) if block_given?
  end

  def read(key = nil)
    return nil unless File.exist?(@file)

    plist = Plist.parse_xml(capture '/usr/bin/plutil', '-convert', 'xml1', '-o', '-', @file)
    key.nil? ? plist : plist&.fetch(key, nil)
  end

  def write(key, value, add: false)
    if add && value.is_a?(Array)
      if File.exist?(@file)
        plist = Plist.parse_xml(capture '/usr/bin/plutil', '-convert', 'xml1', '-o', '-', @file)
        value = value.reject { |v| plist.fetch(key, []).include?(v) }
      end
    end

    command *@sudo, '/usr/bin/defaults', *@current_host, 'write', *app, *bundle_id, key, *args(value, add: add)
  end

  def delete(*args)
    command *@sudo, '/usr/bin/defaults', *@current_host, 'delete', *app, *bundle_id, *args
  end

  def format_number(n)
    n = n.round(10)
    (n - n.to_i).zero? ?  n.to_i : n
  end
  private :format_number

  def color(r, g, b, a = 1)
    r = format_number(r / 255.0)
    g = format_number(g / 255.0)
    b = format_number(b / 255.0)
    a = format_number(a)

    data = +"#{r} #{g} #{b}"
    data << " #{a}" unless a == 1
    data << "\x00"

    wrap_data(
      {
        '$class' => { 'CF$UID' => 2 },
        'NSColorSpace' => 1,
        'NSRGB' => StringIO.new(data),
      },
      {
        '$classes' => ['NSColor', 'NSObject'],
        '$classname' => 'NSColor',
      },
    )
  end

  def font(name, size = 11.0)
    wrap_data(
      {
        '$class' => { 'CF$UID' => 3 },
        'NSName' => { 'CF$UID' => 2 },
        'NSSize' => size,
        'NSfFlags' => 16,
      },
      name,
      {
        '$classes' => ['NSFont', 'NSObject'],
        '$classname' => 'NSFont',
      },
    )
  end

  def wrap_data(*objects)
    plist = {
      '$archiver' => 'NSKeyedArchiver',
      '$objects' => ['$null'] + objects,
      '$top' => {
        'root' => { 'CF$UID' => 1 },
      },
      '$version' => 100000,
    }

    StringIO.new(capture('plutil', '-convert', 'binary1', '-o', '-', '-', input: plist.to_plist))
  end
  private :wrap_data

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
      hex = value.read.unpack('C*').map { |i| i.to_s(16).rjust(2, '0') }.join
      ['-data', hex]
    end
  end
  private :args

  def to_arg(value)
    value.respond_to?(:to_plist) ? value.to_plist(false) : args(value)
  end
  private :to_arg
end

def defaults(*args, &block)
  Defaults.new(*args, &block)
end
