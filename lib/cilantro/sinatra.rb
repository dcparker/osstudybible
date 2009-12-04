require_with_auto_install 'rack', :gem => 'rack'
require_with_auto_install 'thin', :gem => 'thin'
require_with_auto_install 'eventmachine', :gem => 'eventmachine'
require_with_auto_install 'daemons', :gem => 'daemons'
require_with_auto_install 'sinatra/base', :gem => 'sinatra'
Sinatra.send(:remove_const, :Templates)
class Application < Sinatra::Base
  include Cilantro::Application
  enable :sessions
end
