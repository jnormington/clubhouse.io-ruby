require 'spec_helper'

class TestClient < Clubhouse::Client
  include Clubhouse::APIActions
end

module Clubhouse
  describe APIActions do
    subject { TestClient.new('tok123') }

    before do
      allow(Clubhouse).to receive(:constants).and_return([:Story])
    end

    describe '#find' do
      let(:story) { subject.find(:story, 1) }
      it 'calls get and returns resource object' do
        expect(subject).to receive(:get).with('stories/1').and_return({"name" => "Story 1", "id" => 1})
        expect(story).to be_instance_of Story
        expect(story.name).to eq 'Story 1'

      end

      it 'raises an error when resource is unknown' do
        expect{ subject.find(:tester, 1) }.to raise_error NoSuchResourceError, "Available resources are [:story, :stories]"
      end
    end

    describe '#resource' do

      it 'returns object matching the label' do
        expect(subject.known_resources).to eq({
          stories: Clubhouse::Story,
          story: Clubhouse::Story
        })
      end
    end
  end
end
