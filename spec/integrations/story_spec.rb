module Clubhouse
  RSpec.describe 'Story actions', type: :integration do
    let(:story_attr) {{ name: 'Its a bug', project_id: 18 }}

    describe 'creating' do
      let(:story) {  Story.new(story_attr) }

      before { stub_create_resource_with(:stories, story_attr.to_json, :story) }

      it 'saves and stores the attributes' do
        story.save
        expect(story.id).to eq 694
        expect(story.story_type).to eq 'feature'
        expect(story.requested_by_id).to eq '22c22ddd-ad22-2222-2c2d-222d2222cc2d'
        expect(story.workflow_state_id).to eq 500000011
      end
    end

    describe 'updating' do
      let(:story) {  Story.new(story_attr) }
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
        stub_create_resource_with(:stories, story_attr.to_json, :story)
        stub_update_resource_with(:stories, 694, request_body.to_json.gsub('\n', ''), :update_story)
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
      let(:story) {  Story.new(story_attr) }
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

      before { stub_get_resource_with(:stories, 694, :story) }

      it 'reloads the story object' do
        expect(story.story_type).to eq 'feature'

        stub_get_resource_with(:stories, 694, :update_story)
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

    describe '.search' do
      let(:search) {{ project_id: 17, story_type: :bug }}
      let(:stories) { Story.search(search) }
      let(:story) { stories[1] }

      before { stub_create_resource_with("stories/search", search.to_json, :stories) }

      it 'returns an array or story' do
        expect(stories.size).to eq 3
        expect(story.id).to eq 678
        expect(story.story_type).to eq 'bug'
        expect(story.project_id).to eq  17
        expect(story.name).to eq 'Card created just now'
      end
    end

    describe 'comments' do
      let(:story) { Story.find(694) }
      let(:comment) { story.comments.first }

      before { stub_get_resource_with(:stories, 694, :story) }

      it 'returns an array of comment objects' do
        expect(story.comments.size).to eq 2
        expect(comment.class).to eq Comment
        expect(comment.text).to eq 'Comment One'
        expect(comment.story_id).to eq 694
      end

      context 'object is reloaded' do
        it 'refreshes the comments' do
          # Cause it to store the call
          story.comments

          expect(story.comments.first.text).to eq 'Comment One'

          stub_get_resource_with(:stories, 694, :update_story)
          story.reload # This is also the same process for saving
          expect(story.comments.first.text).to eq 'Comment changed'
        end
      end
    end

    describe 'tasks' do
      let(:story) { Story.find(694) }
      let(:task) { story.tasks.first }

      before { stub_get_resource_with(:stories, 694, :story) }

      it 'returns an array of tasks objects' do
        expect(story.tasks.size).to eq 2
        expect(task.class).to eq Task
        expect(task.description).to eq 'Thee task!'
        expect(task.complete).to be_falsey
        expect(task.story_id).to eq 694
      end

      context 'object is reloaded' do
        it 'refreshes the tasks' do
          # Cause it to store the call
          story.tasks

          expect(story.tasks.first.description).to eq 'Thee task!'

          stub_get_resource_with(:stories, 694, :update_story)
          story.reload # This is also the same process for saving
          expect(story.tasks.first.description).to eq 'The task at hand'
        end
      end
    end
  end
end
