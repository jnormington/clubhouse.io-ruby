module Clubhouse
  class User < BaseResource
    resource :users

    attributes :name, readonly: [ :deactivated, :id, :name, :permissions,
                                  :two_factor_auth_activated, :username]

    Permission = Struct.new(:created_at, :disabled, :email_address,
                            :gravatar_hash, :id, :initials, :role, :updated_at)

    def save
      raise NotSupportedByAPIError, "You can't create users over the API, please use clubhouse web"
    end

    def self.delete(id = nil)
      raise NotSupportedByAPIError, "You can't delete users over the API, please use clubhouse web"
    end

    def permissions
      @_permissions ||= Array(@permissions).collect do |p|
        Permission.new(
          p['created_at'],
          p['disabled'],
          p['email_address'],
          p['gravatar_hash'],
          p['id'],
          p['initials'],
          p['role'],
          p['updated_at']
        )
      end
    end
  end
end
