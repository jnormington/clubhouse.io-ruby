module Clubhouse
  RSpec.describe 'Epic actions', type: :integration do
    let(:epic_attr) {{ description: 'Thee epic!', name: 'Trello to Clubhouse migration' }}

    describe 'creating' do
      let(:epic) {  Epic.new(epic_attr) }

      before { stub_create_resource_with(:epics, epic_attr.to_json, :epic) }

      it 'saves and stores the attributes' do
        epic.save
        expect(epic.id).to eq 11
        expect(epic.created_at).to eq '2016-08-31T22:53:47Z'
        expect(epic.state).to eq 'to do'
      end
    end

    describe 'updating' do
      let(:epic) {  Epic.new(epic_attr) }
      let(:request_body) do
        {
          archived: false,
          description: "Milestone 1",
          follower_ids: [],
          name: "Trello to Clubhouse migration",
          owner_ids: [],
          state: "in progress"
        }
      end

      before do
        stub_create_resource_with(:epics, epic_attr.to_json, :epic)
        stub_update_resource_with(:epics, 11, request_body.to_json, :update_epic)
      end

      it 'sends an update and updates the object' do
        epic.save
        expect(epic.state).to eq 'to do'
        expect(epic.updated_at).to eq '2016-08-31T22:53:47Z'

        epic.state = 'in progress'
        epic.description = 'Milestone 1'
        epic.save

        expect(epic.updated_at).to eq '2016-09-11T22:53:47Z'
        expect(epic.state).to eq 'in progress'
      end
    end

    describe 'error' do
      let(:epic) {  Epic.new(description: 'Blah') }
      let(:error) do
        {
          "errors": { "name": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, :epics, error.to_json) }

      it 'raises an error with the body content' do
        expect{ epic.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
        expect(epic.description).not_to be_nil
      end
    end

    describe 'reload' do
      let(:epic) { Epic.find(11) }

      before { stub_get_resource_with(:epics, 11, :epic) }

      it 'reloads the epic object' do
        expect(epic.state).to eq 'to do'

        stub_get_resource_with(:epics, 11, :update_epic)
        epic.reload

        expect(epic.state).to eq 'in progress'
      end
    end

    describe '.all' do
      before { stub_all_resource_with(:epics, :epics) }

      let(:epics) { Epic.all }
      let(:epic_b) { epics.last }

      it 'returns an array of epics' do
        expect(epics.size).to eq 2
        expect(epic_b.name).to eq 'Clubhouse.io ruby gem'
        expect(epic_b.archived).to be_falsy
        expect(epic_b.position).to eq 2
      end
    end

    describe '#comments' do
      let(:epic) { Epic.find(11) }
      let(:comment_a) { epic.comments.first }
      let(:comment_b) { epic.comments[1] }

      before { stub_get_resource_with(:epics, 11, :update_epic) }

      it 'returns comments of comments objects' do
        expect(epic.comments.size).to eq 2

        expect(comment_a.comments.size).to eq 0
        expect(comment_a.text).to eq 'What is this epic ?'
        expect(comment_a.id).to eq 122


        expect(comment_b.comments.size).to eq 1
        expect(comment_b.text).to eq 'A comment on an epic'
        expect(comment_b.id).to eq 123

        # Check the nested comment
        expect(comment_b.comments.first.id).to eq 233
        expect(comment_b.comments.first.author_id).to eq '34567812-5012-5643-9089-123456789012'
        expect(comment_b.comments.first.text).to eq 'A comment inside a comment'
      end
    end
  end
end
