require File.dirname(__FILE__)+'/FileMonitor'
require File.dirname(__FILE__)+'/thin_proxy'

module Cilantro
  class AutoReloaded
    def self.app
      (@reloader ||= new).possibly_reloaded_app
    end

    attr_writer :app
    def initialize
      @monitor = FileMonitor.new
      @app = Rack::Chunked.new(Rack::ContentLength.new(Application.new))
      @monitor.add(APP_ROOT) do |file|
        @something_changed = true
      end
      # Gather all of the modtimes for the start
      @monitor.process
      @something_changed = false
    end

    def possibly_reloaded_app
      @monitor.process
      if @something_changed
        # Reload the environment
        Cilantro.reload_environment
        # Remake the app instance that will be used for the request
        @app = Rack::Chunked.new(Rack::ContentLength.new(Application.new))
        @something_changed = false
      end
      @app
    end
  end
end

