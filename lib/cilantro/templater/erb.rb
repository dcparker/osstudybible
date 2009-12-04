require 'erb'

module Cilantro
  class Template
    class Erb
      def initialize(options={})
        @options = options
      end

      def render(template, context, locals)
        # Set up a proxy object for the binding
        new_context = Object.new
        new_context.send(:instance_variable_set, :@context, context)
        new_context.send(:instance_variable_set, :@locals, locals)
        new_context.instance_eval("
          def method_missing(m, *args)
            @locals.has_key?(m) ? @locals[m] : @context.send(m, *args)
          rescue NoMethodError
            nil
          end
        ")
        context = new_context.instance_eval("binding")
        # Now, use the new context (binding) for rendering
        ::ERB.new(template.last).result(context)
      end
    end
  end
end
