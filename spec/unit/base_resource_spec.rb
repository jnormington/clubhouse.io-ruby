require 'spec_helper'

class LabelTest < BaseResource
  resource 'labels'

  attributes :name, :project_id, :story_id, :updated_at
  attributes_for_update :name, :updated_at
  attributes_for_create :name, :project_id
end

module Clubhouse
  describe BaseResource do
    subject { LabelTest.new }

    describe '.endpoint' do
      it 'returns the set resource' do
        expect(subject.class.endpoint).to eq 'labels'
      end
    end

    describe '.registered_attributes' do
      it 'defines instance setters and getters' do
        subject.name = 'Bugfix'
        subject.project_id = '123-123'
        expect(subject.name).to eq 'Bugfix'
        expect(subject.project_id).to eq '123-123'
      end
    end

    describe '#attributes_keys' do
      it 'returns the keys from registered_attributes' do
        expect(subject.attribute_keys).to eq([:name, :project_id, :story_id, :updated_at])
      end
    end

    describe '.create_attributes' do
      it 'returns attributes only for create' do
        expect(subject.create_attributes).to eq(name: nil, project_id: nil)
        subject.name = 'UrgentFix'
        subject.project_id = '123'
        expect(subject.create_attributes).to eq(name: 'UrgentFix', project_id: '123')
      end
    end

    describe '.update_attributes' do
      it 'returns attributes only for update' do
        expect(subject.update_attributes).to eq(name: nil, updated_at: nil)
        subject.name = 'UrgentFix'
        expect(subject.update_attributes).to eq(name: 'UrgentFix', updated_at: nil)
      end
    end

    describe '.client' do
      before do
        allow(Clubhouse).to receive(:default_client).and_return('Fake Client')
      end

      it 'returns the Clubhouse.default_client' do
        expect(subject.class.client).to eq 'Fake Client'
      end
    end

    describe '#client' do
      before do
        allow(Clubhouse).to receive(:default_client).and_return('Fake Client')
      end

      it 'returns the user set client' do
        subject.client = "My Client"
        expect(subject.client).to eq 'My Client'
      end

      it 'returns the default client' do
        expect(subject.client).to eq 'Fake Client'
      end
    end

    describe '#update_object_from_payload' do
      let(:payload) do
        {
          'name' => 'My Label Name',
          'project_id' => '123-123-234',
          'story_id' => '321-123'
        }
      end

      it 'updates the object attributes' do
        expect(subject.name).to be_nil
        expect(subject.project_id).to be_nil
        expect(subject.story_id).to be_nil

        subject.update_object_from_payload(payload)

        expect(subject.name).to eq 'My Label Name'
        expect(subject.project_id).to eq '123-123-234'
        expect(subject.story_id).to eq '321-123'
      end
    end
  end
end
