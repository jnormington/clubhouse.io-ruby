module Clubhouse
  RSpec.describe 'LinkedFile actions', type: :integration do
    let(:linked_file_attr) {{
      name: 'attachement 0',
      story_id: 11,
      type: 'url',
      url: 'https://example.com/0_ScreenShot.png'
    }}

    describe 'creating' do
      let(:linked_file) {  LinkedFile.new(linked_file_attr) }

      before { stub_create_resource_with('linked-files', linked_file_attr.to_json, :linked_file) }

      it 'saves and stores the attributes' do
        linked_file.save
        expect(linked_file.id).to eq 375
        expect(linked_file.created_at).to eq '2016-09-07T22:20:07Z'
        expect(linked_file.uploader_id).to eq '57c75ddd-ad27-4531-8c7d-368d8702cc0d'
        expect(linked_file.story_ids).to eq [11]
        expect(linked_file.size).to eq 0
      end
    end

    describe 'updating' do
      let(:linked_file) {  LinkedFile.new(linked_file_attr) }
      let(:request_body) do
        {
          description:"",
          name: "attachement 0",
          size: 10,
          type: "url",
          uploader_id: "57c75ddd-ad27-4531-8c7d-368d8702cc0d",
          url: "https://example.com/0_ScreenShot.png"
        }
      end

      before do
        stub_create_resource_with('linked-files', linked_file_attr.to_json, :linked_file)
        stub_update_resource_with('linked-files', 375, request_body.to_json, :update_linked_file)
      end

      it 'sends an update and updates the object' do
        linked_file.save

        expect(linked_file.description).to be_empty
        expect(linked_file.story_ids).to eq [11]
        expect(linked_file.updated_at).to eq '2016-09-07T22:20:07Z'

        linked_file.size = 10
        linked_file.save

        expect(linked_file.updated_at).to eq '2016-09-17T23:44:07Z'
        expect(linked_file.mention_ids).to be_empty
      end
    end

    describe 'error' do
      let(:linked_file) {  LinkedFile.new(description: 'Blah') }
      let(:error) do
        {
          "errors": { "name": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, 'linked-files', error.to_json) }

      it 'raises an error with the body content' do
        expect{ linked_file.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
        expect(linked_file.description).not_to be_nil
      end
    end

    describe 'reload' do
      let(:linked_file) { LinkedFile.find(375) }

      before { stub_get_resource_with('linked-files', 375, :linked_file) }

      it 'reloads the linked_file object' do
        expect(linked_file.updated_at).to eq '2016-09-07T22:20:07Z'

        stub_get_resource_with('linked-files', 375, :update_linked_file)
        linked_file.reload

        expect(linked_file.updated_at).to eq '2016-09-17T23:44:07Z'
      end
    end

    describe '.all' do
      before { stub_all_resource_with('linked-files', :linked_files) }

      let(:linked_files) { LinkedFile.all }
      let(:linkedfile_b) { linked_files.last }

      it 'returns an array of linked_files' do
        expect(linked_files.size).to eq 2
        expect(linkedfile_b.name).to eq 'attachement 1'
        expect(linkedfile_b.url).to eq 'https://example.com/1_ScreenShot.png'
        expect(linkedfile_b.thumbnail_url).to be_nil
        expect(linkedfile_b.type).to eq 'url'
      end
    end
  end
end
