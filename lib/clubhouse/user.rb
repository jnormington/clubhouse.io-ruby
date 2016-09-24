module Clubhouse
  class User < BaseResource
    resource :users

    attributes :name, readonly: [ :deactivated, :id, :name, :permissions,
                                  :two_factor_auth_activated, :username]


    def save
      raise NotSupportedByAPIError, "You can't create users over the API, please use clubhouse web"
    end

    def self.delete(id = nil)
      raise NotSupportedByAPIError, "You can't delete users over the API, please use clubhouse web"
    end

    def permissions
      @_permissions ||= Array(@permissions).collect {|p| Permission.new(p) }
    end
  end
end
