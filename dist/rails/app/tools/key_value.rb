
# ------- lib/key_value.rb -------

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



# ------- lib/key_value/record.rb -------

class KeyValue
  class Record
    attr_accessor :id, :key, :value, :name
    attr_accessor :display, :title
    attr_accessor :lookup_values

    def initialize(key, value, options={}, &block)
      @id, @key = key, key
      @value, @name = value, value
      @display = value.to_s.tr(*'_ '.chars)
      @title = @display.gsub(/\b\w/) {|match| match.upcase }

      @lookup_values = [@id, @name, @name.to_s, @display, @title] + options.fetch(:lookup_values, [])

      singleton_class.class_eval do
        define_method("#{value}?") { true }
      end

      options.each do |k,v|
        singleton_class.class_eval{ attr_accessor k }
        instance_variable_set("@#{k}", v)
      end

      if block_given?
        singleton_class.class_eval &block # !> `&' interpreted as argument prefix
      end
    end

    def options_for_select
      ALL.map{|record| [record.display, record.id] }
    end

    def matches?(q)
      lookup_values.include? q
    end

    def method_missing(name, *args)
      return false if name.to_s[/[?]$/]
      raise NoMethodError, "Unknown Method: #{name} on #{self.class}"
    end
  end
end



# ------- lib/key_value/active_record.rb -------

class KeyValue
  class UnknownValue < Exception
  end

  module ActiveRecord
    def self.included(base)
      base.class_eval do
        def self.key_value column_name, access_as, value_object
          class_eval <<-CODE
            def #{access_as}
              #{value_object}.for( self.#{column_name} )
            end

            def #{access_as}=(val)
              self.#{column_name} = #{value_object}.for(val).id
            end
          CODE
        end

        def self.handle_key column_name, settings={}
          handle_key_as = settings[:as]
          value_object = settings[:using]

          class_eval <<-CODE
            def #{handle_key_as}
              #{value_object}.for( self.#{column_name} )
            end

            def #{handle_key_as}=(val)
              matching_value = #{value_object}.for(val)

              if matching_value.present?
                self.#{column_name} = matching_value.id
              else
                raise KeyValue::UnknownValue, "Unable to match '\#{val}' with a matching key"
              end
            end
          CODE
        end
        alias_method :handle_column, :handle_key
      end
    end
  end
end

#
# class Car < ActiveRecord::Base
#   include KeyValue::ActiveRecord
#
#   handle_key :report_status_id, as: :report_status, using: ReportStatus
# end
#


