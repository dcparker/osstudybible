# Read configuration, if there is any
require 'yaml'
$config = YAML.load_file("#{directory}/config/cilantro.yml") rescue {}

RACK_ENV = (ENV['RACK_ENV'] ||= ($config[:environment] || 'development').to_s).to_sym

require 'lib/cilantro'
Cilantro.database_config $config[:database_config] if $config[:database_config]
Cilantro.load_environment
Cilantro.set_options(
  :run => Proc.new { false },
  :host => $config[:host] || '0.0.0.0',
  :port => $config[:port] || '5000'
)

run Application
