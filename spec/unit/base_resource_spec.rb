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
  end
end
