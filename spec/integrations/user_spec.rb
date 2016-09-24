require 'spec_helper'

module Clubhouse
  RSpec.describe 'User actions', type: :integration do

    subject { User.new }

    describe '#save' do
      it 'raises an exception' do
        expect{ subject.save }.to raise_error NotSupportedByAPIError,
          "You can't create users over the API, please use clubhouse web"
      end
    end

    describe '#delete' do
      it 'raises an exception' do
        expect{ User.delete("1234-1234-1234") }.to raise_error NotSupportedByAPIError,
          "You can't delete users over the API, please use clubhouse web"
      end
    end

    describe '.find' do
      before { stub_get_resource_with(:users, id, :user) }

      let(:id) { '12345678-9012-3456-7890-123456789012' }
      let(:user) { User.find(id) }
      let(:perm) { user.permissions.first }

      it 'returns a user' do
        expect(user.name).to eq 'Jon N'
        expect(user.two_factor_auth_activated).to be_truthy
        expect(user.username).to eq 'jondemo'
        expect(user.deactivated).to be_truthy

        expect(perm.role).to eq 'admin'
        expect(perm.disabled).to be_truthy
        expect(perm.email_address).to eq 'foo@example.com'
      end
    end

    describe '.all' do
      before { stub_all_resource_with(:users, :users) }

      let(:users) { User.all }
      let(:user_a) { users.first }
      let(:user_b) { users.last }
      let(:user_b_perm) { user_b.permissions.first }

      it 'returns users array' do
        expect(user_a.name).to eq 'Jon N'
        expect(user_b.name).to eq 'Mia N'

        expect(user_a.id).to eq '12345678-9012-3456-7890-123456789012'
        expect(user_b.id).to eq '02345678-9012-6789-0123-123456789012'

        expect(user_b_perm.role).to eq 'admin'
        expect(user_b_perm.disabled).to be_truthy
        expect(user_b_perm.email_address).to eq 'mia@example.com'
      end
    end
  end
end
