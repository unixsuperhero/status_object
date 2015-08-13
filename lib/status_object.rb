module StatusObject
  def self.included(base)
    base.extend ClassDefinitions

    base.class_eval do
      attr_reader :id, :name
      def initialize(id)
        @id = id
        @name = self.class.name_for(id)
      end

      def text
        name.tr(*'_ '.chars)
      end

      def display
        text.gsub(/\b\w/,&:upcase)
      end

      def ==(other_status)
        other_status.is_a?(self.class) && other_status.id == self.id rescue false
      end

      def is?(val)
        return true if id == val
        return true if name == val
        return true if name.to_sym == val
        return true if display == val
        return true if self == val
        false
      end

      const_get(:VALUES).each do |name,val|
        define_method(:"#{name}?") { @id == val }
      end
    end
  end

  module ClassDefinitions
    def self.extended(base)
      base.instance_eval do

        def values
          self::VALUES
        end

        values.each do |name, val|
          const_set(name.to_s.upcase.to_sym, val) # => 0, 1, 2, 3, 4
          instance_eval <<-EVAL
            @@#{name} = #{val}

            def #{name}
              new(@@#{name})
            end

            def #{name}_id
              @@#{name}
            end
          EVAL
        end

        def ids
          @ids ||= values.values
        end

        def names
          @names ||= values.keys.map(&:to_s)
        end

        def id_map
          values
        end

        def name_map
          @name_map ||= values.invert #.with_indifferent_access
        end

        def by_id(id=ids.first)
          new(id)
        end

        def id_for(name=names.first)
          id_map.fetch(name, nil)
        end

        def by_name(name=names.first)
          new(id_for name)
        end

        def name_for(id=ids.first)
          name_map.fetch(id, nil).to_s
        end

        def text_for(id=ids.first)
          new(id).text
        end

        def display_for(id=ids.first)
          new(id).display
        end

        def all
          ids.map do |id|
            new id
          end
        end

        def options_for_select
          ids.map do |i|
            [new(i).display, i]
          end
        end
      end
    end
  end
end

