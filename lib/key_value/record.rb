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

