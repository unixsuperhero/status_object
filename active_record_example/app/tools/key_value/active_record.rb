class KeyValue
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
      end
    end
  end
end
