require_relative 'key_value/record'
require_relative 'key_value/active_record'

class KeyValue
  ALL = []

  def self.add_record key, val, opts={}, &block
    prepare_record(key, val, opts, &block).tap do |record|
      ALL.push record
      define_record_accessor(val, record)
    end
  end

  def self.prepare_record(key, val, opts={}, &block)
    Record.new(key, val, opts, &block)
  end

  def self.define_record_accessor(val, record)
    singleton_class.instance_eval do
      define_method(val) { record }
    end
  end

  def self.for(value)
    ALL.find do |record|
      record.matches?(value)
    end
  end
end

