$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'clubhouse'
require 'webmock/rspec'

Dir[File.expand_path('../support/*.rb', __FILE__)].each {|file| require file }

RSpec.configure do |config|
  config.include WebMock::API
  config.include WebmocksHelper
  config.order = :random

  config.before(:suite) do
    WebMock.enable!
  end

  config.before do
    WebMock.disable_net_connect!
  end

  config.before(type: :integration) do
    Clubhouse.default_client = Clubhouse::Client.new('11aa1a1c-11a1-1a1a-aaaa-1afa1111111a')
  end
end
