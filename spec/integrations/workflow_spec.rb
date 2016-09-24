require 'spec_helper'

module Clubhouse
  RSpec.describe 'Workflow actions', type: :integration do

    subject { Workflow.new }

    describe '#save' do
      it 'raises an exception' do
        expect{ subject.save }.to raise_error NotSupportedByAPIError,
          "You can't manage workflows over the API, please use clubhouse web"
      end
    end

    describe '#delete' do
      it 'raises an exception' do
        expect{ Workflow.delete("1234-1234-1234") }.to raise_error NotSupportedByAPIError,
          "You can't delete workflows over the API, please use clubhouse web"
      end
    end

    describe '.find' do
      it 'raises an exception' do
        expect{ Workflow.find("1234-1234-1234") }.to raise_error NotSupportedByAPIError,
          "You can only list all workflows, please use Clubhouse::Workflow.all"
      end
    end

    describe '.all' do
      before { stub_all_resource_with(:workflows, :workflows) }

      let(:workflows) { Workflow.all }
      let(:workflow) { workflows.first }
      let(:state_b) { workflow.states[1] }

      it 'returns workflows array' do
        expect(workflows.size).to eq 1
        expect(workflow.id).to eq 500000009
        expect(workflow.default_state_id).to eq 500000011
        expect(workflow.created_at).to eq '2016-08-31T22:44:45Z'

        expect(workflow.states.size).to eq 3

        expect(state_b.color).to eq 'blue'
        expect(state_b.created_at).to eq '2016-08-31T22:44:45Z'
        expect(state_b.description).to be_empty
        expect(state_b.id).to eq 500000015
        expect(state_b.name).to eq 'In Development'
        expect(state_b.num_stories).to eq 12
        expect(state_b.position).to eq 1
        expect(state_b.type).to eq 'started'
        expect(state_b.updated_at).to eq '2016-08-31T22:44:45Z'
        expect(state_b.verb).to eq 'start'
      end
    end
  end
end
