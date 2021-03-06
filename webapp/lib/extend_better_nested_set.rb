module SymetrieCom
  module Acts
    module NestedSet
      module InstanceMethods

        def pre_order_walk(&block)
          return if (ret = yield(self)).is_a?(Symbol) && ret == :stop
          children.each { |e| e.pre_order_walk(&block) }
        end 
      end
    end
  end
end

