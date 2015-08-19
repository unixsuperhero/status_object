
class KeyValue
  module ActiveRecord
    def self.included(base)
      base.extend KeyValue::ActiveRecord::ClassMethods
    end

    module ClassMethods
      def self.key_value(column_name, access_as, value_object)
        singleton_class.class_eval do
          define_method access_as do
            value_object.for(self.send(column_name))
          end

          define_method "#{access_as}=" do |val|
            self.send("#{column_name}=", value_object.for(val))
          end
        end
      end
    end
  end
end
