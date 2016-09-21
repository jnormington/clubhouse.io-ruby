module Clubhouse
  RSpec.describe 'Label actions', type: :integration do
    let(:low_label) {{ name: 'Low Priority' }}
    let(:new_name) { 'Lowest Priority' }

    describe 'creating' do
      let(:label) {  Label.new(low_label) }

      before { stub_create_resource_with(:labels, low_label.to_json, :label) }

      it 'saves and stores the attributes' do
        label.save
        expect(label.id).to eq 123
        expect(label.name).to eq 'Low Priority'
        expect(label.num_stories_in_progress).to eq 101
        expect(label.num_stories_completed).to eq 99
        expect(label.created_at).to eq '2016-09-31T12:30:00Z'
      end
    end

    describe 'updating' do
      let(:label) { Label.new(low_label) }

      before do
        stub_create_resource_with(:labels, low_label.to_json, :label)
        stub_update_resource_with(:labels, 123, '{"name":"Lowest Priority"}', :updated_label)
      end

      it 'sends an update and updates the object' do
        label.save
        expect(label.updated_at).to eq '2016-09-31T12:30:00Z'

        label.name = new_name
        label.save

        expect(label.updated_at).to eq '2016-10-11T10:12:00Z'
        expect(label.name).to eq new_name
      end
    end

    describe 'error' do
      let(:label) {  Label.new }
      let(:error) do
        {
          "errors": { "name": "required attribute" },
          "message": "The request included invalid or missing parameters."
        }
      end

      before { stub_error_response_for(:post, :labels, error.to_json) }

      it 'raises an error with the body content' do
        expect{ label.save }.to raise_error(Clubhouse::BadRequestError, error.to_json)
      end
    end

    describe 'reload' do
      let(:label) { Label.find(123) }

      before { stub_get_resource_with(:labels, 123, :label) }

      it 'reloads the label object' do
        expect(label.name).to eq 'Low Priority'

        stub_get_resource_with(:labels, 123, :updated_label)
        label.reload

        expect(label.name).to eq new_name
      end
    end
  end
end
