module Clubhouse
  RSpec.describe 'File actions', type: :integration do
    let(:file_json) { JSON.parse(::File.read(fixture_path('file.json'))) }

    describe 'creating' do
      let(:file) { File.new }

      it 'raises an not supported by api error' do
        expect{ file.save }.to raise_error NotSupportedByAPIError,
          "You can't create a direct file upload, but can create linked files over the API"
      end
    end

    describe 'updating' do
      let(:file) { File.new.update_object_from_payload(file_json) }
      let(:request_body) do
        {
          description: "Desc",
          name: "ChoreDisplaysAsStory",
          updated_at: '2016-09-11T12:30:00Z',
          uploader_id: "12345678-9012-3456-7890-123456789012"
        }
      end

      before { stub_update_resource_with(:files, 124, request_body.to_json, :update_file) }

      it 'sends an update and updates the object' do
        expect(file.updated_at).to eq '2016-08-31T12:30:00Z'

        file.name = 'ChoreDisplaysAsStory'
        file.description = "Desc"
        file.updated_at = '2016-09-11T12:30:00Z'
        file.save

        expect(file.updated_at).to eq '2016-09-21T22:10:00Z'
        expect(file.name).to eq 'ChoreDisplaysAsStory'
      end
    end

    describe 'find and reload' do
      let(:file) { File.find(124) }

      before { stub_get_resource_with(:files, 124, :file) }

      it 'reloads the file object' do
        expect(file.size).to eq 2
        expect(file.story_ids).to eq [1,2,3,22]
        expect(file.content_type).to eq 'image/jpg'
        expect(file.uploader_id).to eq '12345678-9012-3456-7890-123456789012'
        expect(file.updated_at).to eq '2016-08-31T12:30:00Z'

        stub_get_resource_with(:files, 124, :update_file)
        file.reload

        expect(file.updated_at).to eq '2016-09-21T22:10:00Z'
      end
    end

    describe '.all' do
      before { stub_all_resource_with(:files, :files) }

      let(:files) { File.all }
      let(:file_b) { files.last }

      it 'returns an array of files' do
        expect(files.size).to eq 2
        expect(file_b.name).to eq 'Chore saved as a bug'
      end
    end
  end
end
