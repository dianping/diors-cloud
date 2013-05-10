module Hooks

  class UnsupportMethodWithArgument < StandardError; end

  module Base

    def self.included(klass)
      klass.instance_variable_set(:@__hooks__, {})
      klass.instance_variable_set(:@__binded_hooks__, {})
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def register(method_name, *options, &block)
        if block_given?
          @__hooks__[method_name] ||= []
          @__hooks__[method_name] << [options.extract_options!, block]
          bind_hook(method_name)
        end
      end

      def inherited(klass)
        klass.instance_variable_set(:@__hooks__, {})
        klass.instance_variable_set(:@__binded_hooks__, {})
      end

      def method_added(method_name)
        bind_hook(method_name)
      end

      private
      def bind_hook(method_name)
        method_name = method_name.to_sym
        if @__hooks__[method_name].present? && method_defined?(method_name) && !@__binded_hooks__[method_name]
          raise UnsupportMethodWithArgument.new if instance_method(method_name).arity != 0
          class_eval <<-EOF
            def #{method_name}_with_hook
              __result__ = #{method_name}_without_hook
              self.class.instance_variable_get(:@__hooks__)[:#{method_name}].each do |options, hook|
                unless options.has_key?(:skip_hook_when) && options[:skip_hook_when] == __result__
                  hook.arity == 1 ? hook.call(self) : self.instance_eval(&hook)
                end
              end
              __result__
            end
          EOF
          @__binded_hooks__[method_name] = true
          alias_method_chain method_name, :hook
        end
      end
    end
  end
end
