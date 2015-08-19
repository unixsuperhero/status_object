
# Status Object

## Example Usage:

    require './lib/key_value'

    class ExampleStatus < KeyValue
      add_record 1, :not_ready, initials: 'NR'

      add_record 2, :ready, initials: 'R'

      add_record 3, :finished, initials: 'F' do
        def custom_method
          :this_is_a_custom_method
        end
      end
    end

    ExampleStatus.for(1) # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">
    ExampleStatus.for(:ready) # => #<KeyValue::Record:0x007fe2f29e8b80 @key=2, @id=2, @name=:ready, @value=:ready, @display="ready", @title="Ready", @lookup_values=[2, :ready, "ready", "ready", "Ready"], @initials="R">
    ExampleStatus.for(:not_ready) # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">

    not_ready = ExampleStatus.for(1) # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">

    not_ready.id # => 1
    not_ready.key # => 1

    not_ready.name # => :not_ready
    not_ready.value # => :not_ready

    not_ready.display # => "not ready"
    not_ready.title # => "Not Ready"

    not_ready.initials # => "NR"

    not_ready.not_ready? # => true
    not_ready.ready? # => false
    not_ready.pregnant? # => false

    finished = ExampleStatus.for(3) # => #<KeyValue::Record:0x007fe2f29e84c8 @key=3, @id=3, @name=:finished, @value=:finished, @display="finished", @title="Finished", @lookup_values=[3, :finished, "finished", "finished", "Finished"], @initials="F">
    finished.id # => 3
    finished.name # => :finished
    finished.display # => "finished"

    finished.custom_method # => :this_is_a_custom_method


## With the ActiveRecord adapter => `lib/key_value/active_record.rb`


`lib/car_report_status.rb`:

    class CarReportStatus < KeyValue
      add_record 0, :walk_report
      add_record 1, :hands_on
      add_record 2, :trade_log
      add_record 3, :work_log
      add_record 4, :completed
      add_record 5, :no_report
      add_record 6, :abandoned
    end


`app/models/car.rb`:

    class Car < ActiveRecord::Base
      include KeyValue::ActiveRecord

      key_value :report_status_id, :report_status, CarReportStatus
    end

    #
    # Adds #report_status and #report_status=
    # ---------------------------------------
    #
    # car = Car.first
    # car.report_status_id     # => 3
    #
    # car.report_status.id     # => 3
    # car.report_status.title  # => "Work Log"
    # car.report_status.name   # => :work_log
    #
    #
    # car.report_status = :completed
    #
    # car.report_status_id     # => 4
    #
    # car.report_status.id     # => 4
    # car.report_status.title  # => "Completed"
    #





