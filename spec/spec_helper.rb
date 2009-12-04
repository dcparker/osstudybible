ENV['RACK_ENV'] = 'test'
require File.dirname(__FILE__)+'/../lib/cilantro'
Cilantro.load_environment

require_with_auto_install 'spec', :gem => 'rspec'
require_with_auto_install 'rack/test', :gem => 'rack-test'

describe 'Tests' do
  it 'should operate properly' do
    true.should eql(true)
  end
end
