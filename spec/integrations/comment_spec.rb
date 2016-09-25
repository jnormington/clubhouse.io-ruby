require 'spec_helper'

module Clubhouse
  RSpec.describe 'Comment actions', type: :integration do

    let(:comment_attr) {{ author_id: '12345678-9012-3456-7890-123456789012', text: 'My comment!' }}
    let(:comment_attrs) { comment_attr.merge(story_id: 694) }
    let(:endpoint) { "stories/694/comments" }

    describe 'creating' do
      let(:comment) { Comment.new(comment_attrs) }

      before { stub_create_resource_with(endpoint, comment_attr.to_json, :comment) }

      context 'with a story_id' do
        it 'saves and stores the attributes' do
          comment.save

          expect(comment.id).to eq 123
          expect(comment.created_at).to eq '2016-09-11T12:30:00Z'
          expect(comment.author_id).to eq '12345678-9012-3456-7890-123456789012'
          expect(comment.text).to eq 'My comment!'
        end
      end

      context 'without a story_id' do
        subject { Comment.new(text: 'Comment') }

        it 'raises an argument error' do
          expect{ subject.save }.to raise_error MissingStoryIDError,
            "story_id is required to create/update comments"
        end
      end
    end

    describe 'updating' do
      let(:comment) {  Comment.new(comment_attrs) }
      let(:request_body) {{ text: 'Editted me comment' }}

      before do
        stub_create_resource_with(endpoint, comment_attr.to_json, :comment)
        stub_update_resource_with(endpoint, 123, request_body.to_json, :update_comment)
      end

      it 'sends an update and updates the object' do
        comment.save

        expect(comment.updated_at).to eq '2016-09-11T12:30:00Z'

        comment.text = 'Editted me comment'
        comment.save

        expect(comment.updated_at).to eq '2016-09-14T22:44:00Z'
        expect(comment.story_id).to eq 694
        expect(comment.position).to eq 123
      end
    end

    describe 'error' do
      let(:comment) {  Comment.new(story_id: 694) }
      let(:error) do
        {
          "errors": { "description": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, endpoint, error.to_json) }

      it 'raises an error with the body content' do
        expect{ comment.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
      end
    end

    describe 'find and reload' do
      let(:comment) { Comment.find(694, 123) }

      before { stub_get_resource_with(endpoint, 123, :comment) }

      it 'reloads the comment object' do
        expect(comment.updated_at).to eq '2016-09-11T12:30:00Z'

        stub_get_resource_with(endpoint, 123, :update_comment)
        comment.reload

        expect(comment.updated_at).to eq '2016-09-14T22:44:00Z'
      end
    end

    describe '.all' do
      it 'raises an exception' do
        expect{ Comment.all }.to raise_error NotSupportedByAPIError,
          "You can get all comments associated directly from the story model"
      end
    end

    describe '.delete' do
      subject { Comment.new(comment_attrs) }

      before { stub_delete_resource_with("#{endpoint}/123") }

      it 'successfully deletes with story and comment id' do
        expect(Comment.delete(694,123)).to eq({})
      end
    end
  end
end
