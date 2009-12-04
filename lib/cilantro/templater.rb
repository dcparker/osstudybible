module Cilantro
  class Template < String
    include Cilantro::Application
    class << self
      def options
        @options ||= {
          :default_layout => :default,
          :partial_prefix => '_'
        }
      end

      def get_template(name, namespace='/', ext=nil)
        view_paths(namespace).each do |vp|
          if file = Dir.glob(File.join([vp, "#{name}.#{ext ? ext : '*'}"]))[0]
            return file.match(/\.([^\.]+)$/)[1].to_sym, file, File.read(file)
          end
        end
        nil
      end
      
      def get_partial(name, namespace='/', ext=nil)
        view_paths(namespace).each do |vp|
          if file = Dir.glob(File.join([vp, "#{options[:partial_prefix]}#{name}.#{ext ? ext : '*'}"]))[0]
            return file.match(/\.([^\.]+)$/)[1].to_sym, file, File.read(file)
          end
        end
        nil
      end

      def engine(type)
        @engine ||= {}
        @engine[type] ||= begin
          require File.dirname(__FILE__) + '/templater/' + type.to_s
          Cilantro::Template.const_get(type.to_s.capitalize!).new(options)
        end
      end

      private
        def view_paths(namespace)
          paths = namespace.split('/').reject {|j| j==''}
          view_paths = ["#{APP_ROOT}/app/views"]
          paths.each do |l|
            view_paths.unshift(view_paths.first + '/' + l)
          end
          view_paths
        end
    end

    attr_accessor :name
    attr_reader :locals

    def initialize(controller, name, locals={})
      @controller = controller
      @name = name
      @locals = locals
    end

    def set_namespace(namespace)
      @namespace = namespace[1]
      @layout = Layout.new(@controller, locals.delete(:layout) || self.class.options[:default_layout], @namespace)
      # load view helpers
      if template_helper = Template.get_template(@name, @namespace, 'rb')
        @html = :helper
        instance_eval(template_helper.last)
        @html = :rendering
      end
    end

    def url(*args)
      begin
        @controller.url(*args)
      rescue => e
        raise RuntimeError, e.to_s, caller
      end
    end

    def to_html
      @html ||= begin
        @html = :rendering
        replace @name.inspect + ' in ' + @namespace
        if template = Template.get_template(@name, @namespace)
          content_for_layout = render(template, self, locals)
          @layout ?
            @layout.render!(content_for_layout) :
            content_for_layout
        else
          raise RuntimeError, "Could not find template `#{@name}' from namespace #{@namespace}", caller
        end
      end
      replace @html
      @html
    end
    def to_json
      dependency 'json'
      locals.to_json
    end
    def to_xml
      locals.to_xml
    end

    # These are to make Cilantro Templates work with Sinatra and Rack.
    alias :to_str :to_html
    alias :to_s :to_str
    def bytesize
      to_html.bytesize
    end
    alias :size :bytesize
    def instance_of?(klass)
      return true if klass == String
      super
    end
    # ****

    def partial(name, new_locals={})
      if locals.has_key?(:with)
        partials(name, new_locals)
      else
        # Catch locals set by the partial helper.
        old_locals = @locals
        @locals = {}
        if partial_helper = Template.get_partial(name, @namespace, 'rb')
          @html = :helper
          instance_eval(partial_helper.last)
          @html = :rendering
        end
        new_locals.merge!(@locals)
        @locals = old_locals

        if partl = Template.get_partial(name, @namespace)
          render(partl, self, new_locals)
        else
          raise RuntimeError, "Could not find partial `_#{name}' from namespace #{@namespace}", caller
        end
      end
    end

    def partials(name, new_locals={})
      if new_locals.has_key?(:with)
        looper = new_locals.delete(:with)
        looper_name = new_locals.delete(:as) || name
      elsif new_locals.values.first.is_a?(Enumerable)
        looper_name = new_locals.keys.first
        looper = new_locals.delete(looper_name)
      end

      # Catch things defined by the partial's helper.
      old_locals = @locals
      @locals = {}
      if partial_helper = Template.get_partial(name, @namespace, 'rb')
        @html = :helper
        instance_eval(partial_helper.last)
        @html = :rendering
      end
      new_locals.merge!(@locals)
      @locals = old_locals

      if partl = Template.get_partial(name, @namespace)
        if looper && looper_name
          looper.collect do |single|
            render(partl, self, new_locals.merge(looper_name => single))
          end.join
        else
          render(partl, self, new_locals)
        end
      else
        raise RuntimeError, "Could not find partial `#{name}' from namespace #{@namespace}", caller
      end
    end

    def render(template_package, context, locals)
      self.class.engine(template_package.first).render(template_package, context, locals.merge(:layout => @layout))
    end

    def insert_section(name)
      return [] unless @locals[:"unrendered_#{name}"].is_a?(Array)
      @locals[name.to_sym] = @locals.delete(:"unrendered_#{name}").collect do |section|
        render(section, self, @locals)
      end
      @locals[name.to_sym]
    end

    def method_missing(name, value=nil, *args)
      sign = if name.to_s =~ /^(.*)([\=\?])$/
        name = $1.to_sym
        $2
      else
        ''
      end

      return @locals.has_key?(name) || @locals.has_key?(:"unrendered_#{name}") if sign == '?'
      raise NoMethodError, "no variable or method `#{name}' for template #{self}", caller if @html == :rendering

      if sign == '='
        @locals[name] = value
      else
        if value
          @locals[name] = value
        else
          return insert_section(name) if !@locals.has_key?(name) && @locals.has_key?(:"unrendered_#{name}")
          return @locals[name]
        end
      end

      return self
    end
  end

  class Layout < Template
    class << self
      def get_layout(name, ext=nil)
        if file = Dir.glob("#{APP_ROOT}/app/views/layouts/#{name}.#{ext ? ext : '*'}")[0]
          return file.match(/\.([^\.]+)$/)[1].to_sym, file, File.read(file)
        end
      end
    end

    def initialize(controller, name, namespace='/')
      @controller = controller
      @name = name
      @locals = {}
      @namespace = namespace
      # load template helper if present
      if layout_helper = Layout.get_layout(@name, 'rb')
        @html = :helper
        instance_eval(layout_helper.last)
        @html = :rendering
      end
      @layout = Layout.get_layout(@name)
    end

    def render!(content_for_layout)
      render(@layout, self, locals.merge(:content_for_layout => content_for_layout))
    end
  end

  class FormatResponder
    def format_proc=(value)
      @format_proc = value
    end

    def to_s
      @to_s ||= @format_proc.call.to_s
    end
    alias :to_str :to_s

    def bytesize
      to_s.bytesize
    end
    alias :size :bytesize
  end

  module Templater
    # Method: layout
    def layout(name)
      @layout_name = name
    end

    # Method: template
    # Inputs: optionally, name and locals
    # Output: a template object, and whenever a name is given, set the name. Default to :default template if none given.
    def template(name=nil, locals={})
      @template ||= Template.new(self, name || :default, {:layout => @layout_name}.merge(locals))
      @template.name = name if name
      # Set the namespace into the template as soon as we seem to be inside of the action code.
      @template.set_namespace(self.class.namespaces[caller[0].match(/`(.*?)'/)[1]]) if caller[0] =~ /[A-Z]+ /
      if block_given?
        yield @template
      end
      return @template
    end

    # Method: respond_to
    # Inputs: type, &block
    # Output: The cumulative best chosen format will be returned each time this is called, so
    #          when called to render, it will run the block associated with that format and
    #          the result of the block is the response. The content_type header is also set up.
    def respond_to(type, &block)
      @respond_to ||= FormatResponder.new

      (@response_formats ||= []) << type
      preferred_format = accepts.each {|a| break a if @response_formats.include?(a) }
      content_type preferred_format
      @respond_to.format_proc = block if type == preferred_format

      @respond_to
    end
  end
end

Application.send(:include, Cilantro::Templater) if ::Object.const_defined?(:Application)
