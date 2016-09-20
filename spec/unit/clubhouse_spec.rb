require 'spec_helper'

describe Clubhouse do

  after do
    Clubhouse.instance_variable_set("@default_client", nil)
  end

  it 'has a version number' do
    expect(Clubhouse::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'yields itself' do
      Clubhouse.configure do |ch|
        ch.default_client = 'Fake'
      end

      expect(Clubhouse.default_client).to eq 'Fake'
    end
  end

  describe '.default_client' do
    it 'returns nil' do
      expect(Clubhouse.default_client).to be_nil
    end

    it 'returns user set value' do
      Clubhouse.default_client = 'Client'
      expect(Clubhouse.default_client).to eq 'Client'
    end
  end
end
