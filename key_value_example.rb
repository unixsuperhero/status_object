
require './lib/key_value'


# Example Usage:

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

