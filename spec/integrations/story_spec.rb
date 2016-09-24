module Clubhouse
  RSpec.describe 'Story actions', type: :integration do
    let(:basic_story) {{ name: 'Its a bug', project_id: 18 }}

    describe 'creating' do
      let(:story) {  Story.new(basic_story) }

      before { stub_create_resource_with(:stories, basic_story.to_json, :basic_story) }

      it 'saves and stores the attributes' do
        story.save
        expect(story.id).to eq 694
        expect(story.story_type).to eq 'feature'
        expect(story.requested_by_id).to eq '22c22ddd-ad22-2222-2c2d-222d2222cc2d'
        expect(story.workflow_state_id).to eq 500000011
      end
    end

    describe 'updating' do
      let(:story) {  Story.new(basic_story) }
      let(:request_body) do
        {
            "archived": false,
            "description": "Fix it now",
            "file_ids": [],
            "follower_ids": [
                "22c22ddd-ad22-2222-2c2d-222d2222cc2d"
            ],
            "labels": [],
            "linked_file_ids": [],
            "name": "Its a bug",
            "owner_ids": [],
            "project_id": 18,
            "requested_by_id": "22c22ddd-ad22-2222-2c2d-222d2222cc2d",
            "story_type": "bug",
            "workflow_state_id": 500000011
        }
      end

      before do
        stub_create_resource_with(:stories, basic_story.to_json, :basic_story)
        stub_update_resource_with(:stories, 694, request_body.to_json.gsub('\n', ''), :update_basic_story)
      end

      it 'sends an update and updates the object' do
        story.save
        expect(story.updated_at).to eq '2016-09-14T21:39:55Z'

        story.story_type = 'bug'
        story.description = 'Fix it now'
        story.save

        expect(story.updated_at).to eq '2016-09-15T21:39:55Z'
        expect(story.story_type).to eq 'bug'
        expect(story.description).to eq 'Fix it now'
      end
    end

    describe 'error' do
      let(:story) {  Story.new(basic_story) }
      let(:error) do
        {
          "errors": { "project_id": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, :stories, error.to_json) }

      it 'raises an error with the body content' do
        expect{ story.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
        expect(story.name).not_to be_nil
      end
    end

    describe 'reload' do
      let(:story) { Story.find(694) }

      before { stub_get_resource_with(:stories, 694, :basic_story) }

      it 'reloads the story object' do
        expect(story.story_type).to eq 'feature'

        stub_get_resource_with(:stories, 694, :update_basic_story)
        story.reload

        expect(story.story_type).to eq 'bug'
      end
    end

    describe '.all' do
      it 'raises an exception' do
        expect{ Story.all }.to raise_error NotSupportedByAPIError,
          'Use Story.search(..) to return stories matching your search query'
      end
    end
  end
end
