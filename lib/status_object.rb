module StatusObject
  module DSL
    def self.extended(base)
      base.const_set(:VALUES, {}) unless base.const_defined?(:VALUES)

      base.class_eval do
        attr_accessor :id, :name, :text, :display
        def initialize(id)
          @id = id
          @name = self.class::VALUES.invert[id]
          @text = @name.to_s.tr(*'_ '.chars)
          @display = @text.gsub(/\b\w/,&:upcase)
        end

        def self.status_class_base
          base
        end

        def status_class_base
          base
        end

        # def self.add_status(id, name, options={})
        # end
      end
    end

    def add_status(id,name,options={})
      v_const = :VALUES
      vals = const_get(v_const) rescue {}
      remove_const(v_const) if const_defined?(v_const)
      const_set(v_const, vals.merge(name => id))

      tv_const = :TEXT_VALUES
      vals = const_get(tv_const) rescue {}
      remove_const(tv_const) if const_defined?(tv_const)
      const_set(tv_const, vals.merge(id => options[:text]))

      dv_const = :DISPLAY_VALUES
      vals = const_get(dv_const) rescue {}
      remove_const(dv_const) if const_defined?(dv_const)
      const_set(dv_const, vals.merge(id => options[:display]))

      vals = const_get(v_const) rescue {}
      vals.keys.each{|vn| vc = vn.to_s.upcase.to_sym; remove_const(vc) if const_defined?(vc) }

      instance_eval{ include StatusObject::Helpers }
    end
  end

  def self.included(base)
    base.extend DSL

    if base.const_defined?(:VALUES)
      base.include StatusObject::Helpers
    end
  end

  module Helpers
    def self.included(base)
      base.extend ClassDefinitions

      base.class_eval do
        attr_reader :id, :name, :text, :display
        def initialize(id)
          @id = id
          @name = values.invert[id]
          @text = text_values[id] || @name.to_s.tr(*'_ '.chars)
          @display = display_values[id] || @text.gsub(/\b\w/,&:upcase)
        end

        def values
          self.class.const_get(:VALUES) rescue {}
        end

        def text_values
          self.class.const_get(:TEXT_VALUES) rescue {}
        end

        def display_values
          self.class.const_get(:DISPLAY_VALUES) rescue {}
        end

        # def text
        #   name.tr(*'_ '.chars)
        # end

        # def display
        #   text.gsub(/\b\w/,&:upcase)
        # end

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
end

