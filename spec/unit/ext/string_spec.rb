require 'spec_helper'

class TestClient < Clubhouse::Client
  include Clubhouse::APIActions
end

describe String do
  describe 'underscore' do

    [
      {'Story' => 'story'},
      {'StoryLink' => 'story_link'},
      {'Clubhouse::Story' => 'clubhouse/story'}
    ].each do |k|
      from = k.keys.first
      to = k.values.first
      it "converts #{from} to #{to}" do
        expect(from.underscore).to eq to
      end
    end
  end
end

