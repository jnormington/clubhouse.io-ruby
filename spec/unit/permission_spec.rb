require 'spec_helper'

module Clubhouse
  describe Permission do
    describe 'whitelist' do
      let(:valid) do
        [
          :created_at,
          :disabled,
          :email_address,
          :gravatar_hash,
          :id,
          :initials,
          :role,
          :updated_at
        ]
      end

      it 'returns array of symbols' do
        expect(subject.whitelist).to eq valid
      end
    end

    describe '#initialize' do
      subject { Permission.new('name' => 'Blah', 'disabled' => true) }

      it 'assigns whitelisted instance variables' do
        expect(subject.instance_variable_get("@name")).to be_nil
        expect(subject.disabled).to be_truthy
      end
    end
  end
end

