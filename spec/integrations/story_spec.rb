module Clubhouse
  RSpec.describe 'Story actions', type: :integration do
    let(:basic_project) {{ name: 'Its a bug', project_id: 18 }}

    before { stub_create_story_with('{"name":"Its a bug","project_id":18}', :create_basic_story) }

    describe 'saving' do
      let(:story) {  Story.new(basic_project) }

      it 'saves and stores the attributes' do
        story.save!
        expect(story.id).to eq 694
        expect(story.story_type).to eq 'feature'
        expect(story.requested_by_id).to eq '22c22ddd-ad22-2222-2c2d-222d2222cc2d'
        expect(story.workflow_state_id).to eq 500000011
      end
    end
  end
end
