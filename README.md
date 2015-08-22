
# Status Object

Quickly/easily create objects associated with an `'*_id` attribute that are more
meaningful that just a bunch of magic numbers.

* Instead of littering your code with magic numbers:
  * `car.status_id = 2`,
  * `car.status_id = 3 if car.status_id == 2`,
* Interact with the `#*_id` attribute using a proxy attribute that is more
  flexible and descriptive:
  * `car.status = :safe if car.status.parked?` actually updates `#status_id`
  * `car.status = 'safe'` also updates `#status_id`

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

    ExampleStatus.for(1)             # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">
    ExampleStatus.for(:ready)        # => #<KeyValue::Record:0x007fe2f29e8b80 @key=2, @id=2, @name=:ready, @value=:ready, @display="ready", @title="Ready", @lookup_values=[2, :ready, "ready", "ready", "Ready"], @initials="R">
    ExampleStatus.for(:not_ready)    # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">

    not_ready = ExampleStatus.for(1) # => #<KeyValue::Record:0x007fe2f29e93a0 @key=1, @id=1, @name=:not_ready, @value=:not_ready, @display="not ready", @title="Not Ready", @lookup_values=[1, :not_ready, "not_ready", "not ready", "Not Ready"], @initials="NR">

    not_ready.id                     # => 1
    not_ready.key                    # => 1

    not_ready.name                   # => :not_ready
    not_ready.value                  # => :not_ready

    not_ready.display                # => "not ready"
    not_ready.title                  # => "Not Ready"

    not_ready.initials               # => "NR"

    not_ready.not_ready?             # => true
    not_ready.ready?                 # => false
    not_ready.pregnant?              # => false

    finished = ExampleStatus.for(3)  # => #<KeyValue::Record:0x007fe2f29e84c8 @key=3, @id=3, @name=:finished, @value=:finished, @display="finished", @title="Finished", @lookup_values=[3, :finished, "finished", "finished", "Finished"], @initials="F">
    finished.id                      # => 3
    finished.name                    # => :finished
    finished.display                 # => "finished"

    finished.custom_method           # => :this_is_a_custom_method


## With the ActiveRecord adapter => `lib/key_value/active_record.rb`


`lib/car_status.rb`:

    class ProgressStatus < KeyValue
      add_record 0, :added
      add_record 1, :started
      add_record 2, :finished
    end


`app/models/car.rb`:

    class SomeObject < ActiveRecord::Base
      include KeyValue::ActiveRecord

      key_value :progress_status_id, :progress_status, ProgressStatus

      # ...or...

      handle_column :progress_status_id, as: :progress_status, using: ProgressStatus
    end

    #
    # Adds #progress_status and #progress_status=
    # -------------------------------------------
    #
    # some_object = SomeObject.first
    # some_object.progress_status_id              # => 1
    #
    # some_object.progress_status.id              # => 1
    # some_object.progress_status.title           # => "Added"
    # some_object.progress_status.name            # => :added
    #
    # some_object.progress_status.added?          # => true
    # some_object.progress_status.finished?       # => false
    #
    # # These do the same thing:
    # some_object.progress_status = 2
    # some_object.progress_status = :finished
    #
    # some_object.progress_status_id              # => 2
    #
    # some_object.progress_status.id              # => 2
    # some_object.progress_status.title           # => "Finished"
    #
    # some_object.progress_status.added?          # => false
    # some_object.progress_status.finished?       # => true
    #





