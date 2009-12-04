dependency 'rack'
dependency 'thin'
dependency 'eventmachine'
dependency 'daemons'
dependency 'sinatra/base', :gem => 'sinatra'
Sinatra.send(:remove_const, :Templates)
class Application < Sinatra::Base
  include Cilantro::Application
  enable :sessions
end
