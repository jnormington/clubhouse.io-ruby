module Clubhouse
  RSpec.describe 'StoryLink actions', type: :integration do
    let(:attr) {{ object_id: 122, subject_id: 12, verb: 'blocks' }}

    describe 'creating' do
      let(:story_link) { StoryLink.new(attr) }

      before { stub_create_resource_with(:'story-links', attr.to_json, :story_link) }

      it 'saves and stores the attributes' do
        story_link.save

        expect(story_link.id).to eq 18
        expect(story_link.subject_id).to eq 102
        expect(story_link.object_id).to eq 122
        expect(story_link.created_at).to eq '2016-09-21T12:30:00Z'
      end
    end

    describe 'error' do
      let(:error) do
        {
          "errors": { "verb": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, :'story-links', error.to_json) }

      it 'raises an error with the body content' do
        expect{ StoryLink.new.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
      end
    end

    describe 'updating' do
      let(:story_link) { StoryLink.find(18) }
      before { stub_get_resource_with('story-links', 18, :story_link) }

      it 'raises an exception' do
        expect{ story_link.save }.to raise_error NotSupportedByAPIError, "You can't update a story link"
      end
    end

    describe 'find and reload' do
      let(:story_link) { StoryLink.find(18) }

      before { stub_get_resource_with('story-links', 18, :story_link) }

      it 'reloads the story_link object' do
        expect(story_link.object_id).to eq 122
        expect(story_link.subject_id).to eq 102
        expect(story_link.verb).to eq 'blocks'

        stub_get_resource_with('story-links', 18, :update_story_link)
        story_link.reload

        expect(story_link.verb).to eq 'relates to'
      end
    end

    describe '.all' do
      it 'raises an exception' do
        expect{ StoryLink.all }.to raise_error NotSupportedByAPIError, "Not supported by the API"
      end
    end
  end
end
