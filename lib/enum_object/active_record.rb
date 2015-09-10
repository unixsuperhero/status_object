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

