require './lib/status_object'

class ExampleStatus
  VALUES = {
    not_ready: 0,
    ready: 1,
    done: 2
  }

  include StatusObject
end



# CLASS METHODS
# -------------

# helpers:

all            = ExampleStatus.all                 # => [#<ExampleStatus:0x007f87f28e2750 @id=0, @name="not_ready">, #<ExampleStatus:0x007f87f28e26d8 @id=1, @name="ready">, #<ExampleStatus:0x007f87f28e2688 @id=2, @name="done">] # !> assigned but unused variable - all
ids            = ExampleStatus.ids                 # => [0, 1, 2] # !> assigned but unused variable - ids
names          = ExampleStatus.names               # => ["not_ready", "ready", "done"] # !> assigned but unused variable - names

values         = ExampleStatus.values              # => {:not_ready=>0, :ready=>1, :done=>2} # !> assigned but unused variable - values

# constants:

ExampleStatus::VALUES                              # => {:not_ready=>0, :ready=>1, :done=>2}

ExampleStatus::NOT_READY                           # => 0
ExampleStatus::READY                               # => 1
ExampleStatus::DONE                                # => 2

# constructor:

not_ready      = ExampleStatus.new(0)              # => #<ExampleStatus:0x007f87f28d9a38 @id=0, @name="not_ready">
    ready      = ExampleStatus.new(1)              # => #<ExampleStatus:0x007f87f28d9038 @id=1, @name="ready">
     done      = ExampleStatus.new(2)              # => #<ExampleStatus:0x007f87f28d8a70 @id=2, @name="done">

# factory:

not_ready      = ExampleStatus.not_ready           # => #<ExampleStatus:0x007f87f28d84d0 @id=0, @name="not_ready">
    ready      = ExampleStatus.ready               # => #<ExampleStatus:0x007f87f28d3ef8 @id=1, @name="ready">
     done      = ExampleStatus.done                # => #<ExampleStatus:0x007f87f28d3818 @id=2, @name="done">

# grab an id:

not_ready      = ExampleStatus.not_ready_id        # => 0
    ready      = ExampleStatus.ready_id            # => 1
     done      = ExampleStatus.done_id             # => 2

# by_id:

not_ready      = ExampleStatus.by_id(0)            # => #<ExampleStatus:0x007f87f28d1f68 @id=0, @name="not_ready">
    ready      = ExampleStatus.by_id(1)            # => #<ExampleStatus:0x007f87f28d1978 @id=1, @name="ready">
     done      = ExampleStatus.by_id(2)            # => #<ExampleStatus:0x007f87f28d13b0 @id=2, @name="done">

# by_name:

not_ready      = ExampleStatus.by_name(:not_ready) # => #<ExampleStatus:0x007f87f28d0e10 @id=0, @name="not_ready">
    ready      = ExampleStatus.by_name(:ready)     # => #<ExampleStatus:0x007f87f28d0898 @id=1, @name="ready">
     done      = ExampleStatus.by_name(:done)      # => #<ExampleStatus:0x007f87f28d0320 @id=2, @name="done">

# id_for:

not_ready      = ExampleStatus.id_for(:not_ready)  # => 0
    ready      = ExampleStatus.id_for(:ready)      # => 1
     done      = ExampleStatus.id_for(:done)       # => 2

# name_for:

not_ready      = ExampleStatus.name_for(0)         # => "not_ready"
    ready      = ExampleStatus.name_for(1)         # => "ready"
     done      = ExampleStatus.name_for(2)         # => "done"

# display_for:

not_ready      = ExampleStatus.display_for(0)      # => "Not Ready"
    ready      = ExampleStatus.display_for(1)      # => "Ready"
     done      = ExampleStatus.display_for(2)      # => "Done"


# INSTANCE METHODS
# ----------------

not_ready      = ExampleStatus.not_ready           # => #<ExampleStatus:0x007f87f28b1df8 @id=0, @name="not_ready">
    ready      = ExampleStatus.ready               # => #<ExampleStatus:0x007f87f28ab4f8 @id=1, @name="ready">
     done      = ExampleStatus.done                # => #<ExampleStatus:0x007f87f28a91a8 @id=2, @name="done">

not_ready.class                                    # => ExampleStatus

ExampleStatus.not_ready.id                         # => 0
ExampleStatus.not_ready.name                       # => "not_ready"
ExampleStatus.not_ready.display                    # => "Not Ready"

not_ready.id                                       # => 0
    ready.id                                       # => 1
     done.id                                       # => 2

not_ready.name                                     # => "not_ready"
    ready.name                                     # => "ready"
     done.name                                     # => "done"

not_ready.display                                  # => "Not Ready"
    ready.display                                  # => "Ready"
     done.display                                  # => "Done"

not_ready.not_ready?                               # => true
    ready.not_ready?                               # => false
     done.not_ready?                               # => false

not_ready.ready?                                   # => false
    ready.ready?                                   # => true
     done.ready?                                   # => false

not_ready.done?                                    # => false
    ready.done?                                    # => false
     done.done?                                    # => true

not_ready.is? 0                                    # => true
not_ready.is? :not_ready                           # => true
not_ready.is? 'not_ready'                          # => true
not_ready.is? 1                                    # => false
not_ready.is? :ready                               # => false
not_ready.is? 'ready'                              # => false
not_ready.is? 2                                    # => false
not_ready.is? :done                                # => false
not_ready.is? 'done'                               # => false

    ready.is? 0                                    # => false
    ready.is? :not_ready                           # => false
    ready.is? 'not_ready'                          # => false
    ready.is? 1                                    # => true
    ready.is? :ready                               # => true
    ready.is? 'ready'                              # => true
    ready.is? 2                                    # => false
    ready.is? :done                                # => false
    ready.is? 'done'                               # => false

     done.is? 0                                    # => false
     done.is? :not_ready                           # => false
     done.is? 'not_ready'                          # => false
     done.is? 1                                    # => false
     done.is? :ready                               # => false
     done.is? 'ready'                              # => false
     done.is? 2                                    # => true
     done.is? :done                                # => true
     done.is? 'done'                               # => true

