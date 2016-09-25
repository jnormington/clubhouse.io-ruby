require 'spec_helper'

module Clubhouse
  RSpec.describe 'Task actions', type: :integration do

    let(:task_attr) {{ description: 'Thee task!' }}
    let(:task_attrs) { task_attr.merge(story_id: 694) }
    let(:endpoint) { "stories/694/tasks" }

    describe 'creating' do
      let(:task) { Task.new(task_attrs) }

      before { stub_create_resource_with(endpoint, task_attr.to_json, :task) }

      context 'with a story_id' do
        it 'saves and stores the attributes' do
          task.save

          expect(task.id).to eq 11
          expect(task.created_at).to eq '2016-08-31T23:30:00Z'
          expect(task.complete).to be_falsy
        end
      end

      context 'without a story_id' do
        subject { Task.new(description: 'Blah') }

        it 'raises an argument error' do
          expect{ subject.save }.to raise_error MissingStoryIDError,
            "story_id is required to create/update tasks"
        end
      end
    end

    describe 'updating' do
      let(:task) {  Task.new(task_attrs) }
      let(:request_body) do
        {
          complete: true,
          description: "Add comments resource",
          owner_ids: ["12345678-9012-3456-7890-123456789012"]
        }
      end

      before do
        stub_create_resource_with(endpoint, task_attr.to_json, :task)
        stub_update_resource_with(endpoint, 11, request_body.to_json, :update_task)
      end

      it 'sends an update and updates the object' do
        task.save

        expect(task.complete).to be_falsy
        expect(task.updated_at).to eq '2016-08-31T23:30:00Z'

        task.complete = true
        task.description = 'Add comments resource'
        task.save

        expect(task.updated_at).to eq '2016-09-24T23:30:00Z'
        expect(task.complete).to be_truthy
        expect(task.completed_at).to eq '2016-09-24T23:30:00Z'
        expect(task.description).to eq 'Add comments resource'
      end
    end

    describe 'error' do
      let(:task) {  Task.new(story_id: 694) }
      let(:error) do
        {
          "errors": { "description": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, endpoint, error.to_json) }

      it 'raises an error with the body content' do
        expect{ task.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
      end
    end

    describe 'find and reload' do
      let(:task) { Task.find(694, 11) }

      before { stub_get_resource_with(endpoint, 11, :task) }

      it 'reloads the task object' do
        expect(task.complete).to be_falsy
        expect(task.completed_at).to be_nil

        stub_get_resource_with(endpoint, 11, :update_task)
        task.reload

        expect(task.complete).to be_truthy
        expect(task.completed_at).not_to be_nil
      end
    end

    describe '.all' do
      it 'raises an exception' do
        expect{ Task.all }.to raise_error NotSupportedByAPIError,
          "You can get all tasks associated directly from the story model"
      end
    end

    describe '.delete' do
      subject { Task.new(task_attrs) }

      before { stub_delete_resource_with("#{endpoint}/11") }

      it 'successfully deletes with story and task id' do
        expect(Task.delete(694,11)).to eq({})
      end
    end
  end
end
