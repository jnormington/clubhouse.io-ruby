module Clubhouse
  class Permission
    attr_reader :created_at, :disabled, :email_address, :gravatar_hash,
                :id, :initials, :role, :updated_at

    def initialize(attr = {})
      Hash(attr).each do |k, v|
        if whitelist.include?(k.to_sym)
          instance_variable_set("@#{k}", v)
        end
      end
    end

    def whitelist
      [:created_at, :disabled, :email_address, :gravatar_hash, :id, :initials, :role, :updated_at]
    end
  end
end
