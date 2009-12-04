ENV['RACK_ENV'] = 'test'
require File.dirname(__FILE__)+'/../lib/cilantro'
Cilantro.load_environment

dependency 'spec', :gem => 'rspec'
dependency 'rack/test', :gem => 'rack-test'

describe 'Tests' do
  it 'should operate properly' do
    true.should eql(true)
  end
end
