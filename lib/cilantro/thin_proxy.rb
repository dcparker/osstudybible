require "thin"
require "rack/content_length"
require "rack/chunked"

module Rack
  module Handler
    class Cilantro
      def self.run(app, options={})
        app = lambda {|env| ::Cilantro::AutoReloaded.app.call(env) }
        server = ::Thin::Server.new(options[:Host] || '0.0.0.0',
                                    options[:Port] || 8080,
                                    app)
        yield server if block_given?
        server.start
      end
    end
  end
end

Rack::Handler.register('thin_cilantro_proxy', 'Rack::Handler::Cilantro')
