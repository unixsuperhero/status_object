
# Status Object

## TODO

use a block for adding statuses.  this way, constants like VALUES are not
constantly being destroyed and rebuilt over and over

## Open-ended question

Right now I am struggling with the design and implementation of the StatusObject
class/module.  I'm not sure I would even use the words design and
implementation.  Rather, I am struggling with the preferred user
experience/interface.  I am debating between the following styles:

1. A DSL: `add_status(status_id, status_name, options={})`
2. A DSL that uses a single block for configuration (to prevent constantly
   removing and overwriting constants):
   ```
     configure_statuses do |config|
       config.add_status status_id_one, status_name_one
       config.add_status status_id_two, status_name_two, status_options_two
     end
   ```
3. A factory:
   ```
     class ColumnStatus < StatusObject.build(not_ready: 0, ready: 2, finished: 3)`
       # ...
     end
   ```
4. A factory that uses a bunch of static objects to define the rest of it:
  ```
    not_ready = StatusObject::Status.new(1, :not_ready, display: 'Not Ready')
    ready = StatusObject::Status.new(2, :ready, display: 'Ready')
    finished = StatusObject::Status.new(3, :finished, display: 'Finished')

    class ColumnStatus < StatusObject.from_statuses(not_ready, ready, finished)
    end
  ```

I'm also debating a few other things.

1. Should all the instances of an individual status be pre-built at runtime, or
   only build the one with the relevant id at the time that it is being
   requested (initialized).
2. Should all of the question-style methods that return true be statically
   defined and use method-missing to automatically return false for any method
   ending in `?` that isn't defined.  For example, using the previous example of
   `{ not_ready: 1, ready: 2, finished: 3 }` for the `:ready` instance of the
   StatusObject, should it only statically define `#ready?` and have
   `#not_ready?` and `#finished?` be handled by method missing?  That would
   allow the developer to ask for anything `status_obj.pregnant?` and instead of
   erroring it would return false.
3. He/she should also be allowed to define new methods that return custom
   values: `add_status 1, :not_ready, initials: 'NR', lower: 'not ready'`
4. Alias methods `#key` and `#id`

## NEW METHOD: How It Works

When StatusObject is included in a class, it adds an `#add_status` DSL which
ultimately looks a lot cleaner than the original method:

## Example:

This is the same example as the one in OLD METHOD, it was just created using different
styles.

    require './lib/status_object'

    class ExampleStatus
      include StatusObject

      add_status 0, :not_ready
      add_status 1, :ready
      add_status 2, :done
    end



## OLD METHOD: How It Works

Create a class.  Add a constant called `VALUES` and set it to a hash with
symbols for keys and their corresponding integer as the values.  Then, include
the module.

## Example:

    require './lib/status_object'

    class ExampleStatus
      VALUES = {
        not_ready: 0,
        ready: 1,
        done: 2
      }

      include StatusObject
    end

This class will have the following Class Methods:

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

    # text_for:

    not_ready      = ExampleStatus.text_for(0)         # => "not ready"
        ready      = ExampleStatus.text_for(1)         # => "ready"
         done      = ExampleStatus.text_for(2)         # => "done"

    # display_for:

    not_ready      = ExampleStatus.display_for(0)      # => "Not Ready"
        ready      = ExampleStatus.display_for(1)      # => "Ready"
         done      = ExampleStatus.display_for(2)      # => "Done"

This class will have the following Instance Methods:

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

    not_ready.text                                     # => "not ready"
        ready.text                                     # => "ready"
         done.text                                     # => "done"

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

