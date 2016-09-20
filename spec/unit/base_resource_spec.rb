require 'spec_helper'

class LabelTest < Clubhouse::BaseResource
  resource 'labels'

  attributes :id, :name, :project_id, :story_id, :updated_at, readonly: :id
  attributes_for_update :name, :updated_at
  attributes_for_create :name, :project_id
end

module Clubhouse
  describe BaseResource do
    subject { LabelTest.new(name: 'Test') }

    describe '.endpoint' do
      it 'returns the set resource' do
        expect(subject.class.endpoint).to eq 'labels'
      end
    end

    describe '#initialize' do
      it 'assigns values from symbol keys hash' do
        subject = LabelTest.new(name: 'Test', project_id: 1234)

        expect(subject.name).to eq 'Test'
        expect(subject.project_id).to eq 1234
      end

      it 'assigns values from string keys hash' do
        subject = LabelTest.new('name' => 'Test', 'project_id' => 1234)

        expect(subject.name).to eq 'Test'
        expect(subject.project_id).to eq 1234
      end

      it 'raises an error when no matching method' do
        expect{ LabelTest.new(id: 123) }.to raise_error InvalidKeyAssignment
      end
    end

    describe '.registered_attributes' do
      it 'defines instance setters and getters' do
        subject.name = 'Bugfix'
        subject.project_id = '123-123'
        expect(subject.name).to eq 'Bugfix'
        expect(subject.project_id).to eq '123-123'
      end

      it 'doesnt create writer methods for readonly attributes' do
        expect{ subject.id = '1234' }.to raise_error NoMethodError
        expect(subject.id).to be_nil

        subject.instance_variable_set("@id", '123-21')
        expect(subject.id).to eq '123-21'
      end
    end

    describe '#attributes_keys' do
      it 'returns the keys from registered_attributes' do
        expect(subject.attribute_keys).to eq([:id, :name, :project_id, :story_id, :updated_at])
      end
    end

    describe '.create_attributes' do
      it 'returns attributes only for create that are not nil' do
        expect(subject.create_attributes).to eq(name: 'Test')
        subject.name = 'UrgentFix'
        subject.project_id = '123'
        expect(subject.create_attributes).to eq({name: 'UrgentFix', project_id: '123'})
      end
    end

    describe '.update_attributes' do
      it 'returns attributes only for update' do
        expect(subject.update_attributes).to eq(name: 'Test')
        subject.name = 'UrgentFix'
        expect(subject.update_attributes).to eq(name: 'UrgentFix')
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
      subject { LabelTest.new }

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

      describe '.find' do
        let(:client) { Client.new('tok123') }

        before do
          allow(Clubhouse).to receive(:default_client).and_return(client)
          subject.name = 'Label Test'
        end

        it 'calls find on client' do
          expect(client).to receive(:find).with(LabelTest, 'labels', '123')

          LabelTest.find('123')
        end
      end

      describe '.delete' do
        let(:client) { Client.new('tok123') }

        before { allow(Clubhouse).to receive(:default_client).and_return(client) }

        it 'calls delete on client with id' do
          expect(client).to receive(:delete).with('labels/123').and_return(true).once
          LabelTest.delete(123)
        end
      end

      describe '#refresh!' do
        let(:client) { Client.new('tok123') }
        let(:payload) { { 'name' => 'Rewrite'} }

        it 'calls put on client with update_attributes' do
          allow(subject).to receive(:id).and_return('123-123')
          allow(subject).to receive(:class).and_return(LabelTest)
          expect(LabelTest).to receive(:find).with('123-123').and_return(payload).once
          expect(subject).to receive(:update_object_from_payload).with(payload).once

          subject.refresh!
        end
      end

      describe '#save!' do
        let(:client) { Client.new('tok123') }

        before do
          allow(Clubhouse).to receive(:default_client).and_return(client)
          subject.name = 'Label Test'
        end

        it 'raises an error when no client is setup' do
          allow(Clubhouse).to receive(:default_client).and_return(nil)
          expect{ subject.save! }.to raise_error ClientNotSetup, "A default client or instance client is not setup"
        end

        context 'when id exists' do
          let(:body) { {name: 'Label Test'} }

          it 'calls put on client with update_attributes' do
            allow(subject).to receive(:id).and_return('123-123')
            expect(client).to receive(:put).with('labels/123-123', body).and_return({ 'name' => 'Rewrite'}).once
            expect(subject).to receive(:update_object_from_payload).with({'name' => 'Rewrite'}).once


            subject.save!
          end
        end

        context 'when id doesnt exist' do
          let(:body) { {name: 'Label Test'} }

          it 'calls post on client with create_attributes' do
            allow(subject).to receive(:id).and_return(nil)
            expect(client).to receive(:post).with('labels', body).and_return({'id' => 12}).once
            expect(subject).to receive(:update_object_from_payload).with({'id' => 12}).once

            subject.save!
          end
        end
      end
    end
  end
end
