module Clubhouse
  RSpec.describe 'Project actions', type: :integration do
    let(:project_attr) {{ description: 'All Burrito project work, yo!', name: 'Burrito' }}

    describe 'creating' do
      let(:project) {  Project.new(project_attr) }

      before { stub_create_resource_with(:projects, project_attr.to_json, :project) }

      it 'saves and stores the attributes' do
        project.save
        expect(project.id).to eq 17
        expect(project.created_at).to eq '2016-09-06T21:01:17Z'
        expect(project.color).to eq '#7ce8cf'
      end
    end

    describe 'updating' do
      let(:project) {  Project.new(project_attr) }
      let(:request_body) do
        {
          abbreviation: "BRT",
          archived: false,
          color: "#7ce8cf",
          description: "Burrito stuff",
          follower_ids: [],
          name: "Burrito"
        }
      end

      before do
        stub_create_resource_with(:projects, project_attr.to_json, :project)
        stub_update_resource_with(:projects, 17, request_body.to_json, :update_project)
      end

      it 'sends an update and updates the object' do
        project.save
        expect(project.abbreviation).to be_empty
        expect(project.updated_at).to eq '2016-09-06T21:01:17Z'

        project.abbreviation = 'BRT'
        project.description = 'Burrito stuff'
        project.save

        expect(project.updated_at).to eq '2016-09-06T23:11:17Z'
        expect(project.abbreviation).to eq 'BRT'
      end
    end

    describe 'error' do
      let(:project) {  Project.new(description: 'Blah') }
      let(:error) do
        {
          "errors": { "name": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, :projects, error.to_json) }

      it 'raises an error with the body content' do
        expect{ project.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
        expect(project.description).not_to be_nil
      end
    end

    describe 'reload' do
      let(:project) { Project.find(17) }

      before { stub_get_resource_with(:projects, 17, :project) }

      it 'reloads the project object' do
        expect(project.abbreviation).to be_empty

        stub_get_resource_with(:projects, 17, :update_project)
        project.reload

        expect(project.abbreviation).to eq 'BRT'
      end
    end

    describe '.all' do
      before { stub_all_resource_with(:projects, :projects) }

      let(:projects) { Project.all }
      let(:project_b) { projects.last }

      it 'returns an array of projects' do
        expect(projects.size).to eq 2
        expect(project_b.name).to eq 'Project X'
        expect(project_b.num_stories).to eq 11
        expect(project_b.archived).to be_falsy
      end
    end

    describe 'stories' do
      let(:project) { Project.find(17) }
      let(:stories) { project.stories }
      let(:story_b) { stories[1] }

      before do
        stub_get_resource_with(:projects, 17, :project)
        stub_all_resource_with("projects/17/stories", :stories)
      end

      it 'returns an array of stories' do
        expect(story_b.id).to eq 678
        expect(story_b.name).to eq 'Card created just now'
        expect(story_b.deadline).to be_nil
        expect(story_b.follower_ids).to eq ["57c75ddd-ad27-4531-8c7d-368d8702cc0d"]
      end

      it 'returns an empty array without an id' do
        expect(Project.new.stories).to eq []
      end
    end
  end
end
