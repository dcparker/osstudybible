require_with_auto_install 'haml'

# Creates the :section haml filter.
# Example usage:
#     :section
#       sidebar
#       %p some links or such...
#   then in some other location, such as the layout:
#     = sidebar
# The content in the sidebar section is then rendered in place.
module Haml::Filters::Section
  include Haml::Filters::Base
  def compile(precompiler, text)
    precompiler.instance_eval do
      section_name, text = text.split(/\n/,2)
      push_silent "(layout.unrendered_#{section_name} ||= []).push(['haml', #{precompiler.options[:filename].inspect}, #{text.inspect}]);"
    end
  end
end

module Cilantro
  class Template
    class Haml
      def initialize(options={})
        @options = options
      end

      def render(template, context, locals)
        # Haml is pretty simple!
        ::Haml::Engine.new(template.last, :filename => template[1]).render(context, locals)
      end
    end
  end
end
