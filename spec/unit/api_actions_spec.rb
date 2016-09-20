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
      let(:story) { subject.find(Story, 'projects/1/stories', 1) }

      it 'calls get and returns resource object' do
        expect(subject).to receive(:get).with('projects/1/stories/1').and_return({"name" => "Story 1", "id" => 1})
        expect(story).to be_instance_of Story

        expect(story.id).to eq 1
        expect(story.name).to eq 'Story 1'
      end
    end
  end
end
