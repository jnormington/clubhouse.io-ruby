class BaseResource
  attr_writer :client

  class << self
    attr_reader :endpoint

    def resource(name)
      @endpoint = name
    end

    def client
      Clubhouse.default_client
    end
  end

  def self.attributes(*keys, **opts)
    readonly = Array(opts[:readonly])

    class_eval do
      define_method(:attribute_keys) { keys }

      keys.each do |key|
        define_method(:"#{key}")  { instance_variable_get("@#{key}") }

        if !readonly.include?(key)
          define_method(:"#{key}=") {|v| instance_variable_set("@#{key}", v) }
        end
      end
    end
  end

  def self.attributes_for_update(*keys)
    class_eval do
      define_method :update_attributes do
        keys.reduce({}) { |hash, k| hash.merge(k => instance_variable_get("@#{k}")) }
      end
    end
  end

  def self.attributes_for_create(*keys)
    class_eval do
      define_method :create_attributes do
        keys.reduce({}) { |hash, k| hash.merge(k => instance_variable_get("@#{k}")) }
      end
    end
  end

  def client
    @client ||= Clubhouse.default_client
  end

  def update_object_from_payload(payload)
    attribute_keys.each do |k|
      self.instance_variable_set("@#{k}", payload[k.to_s])
    end
  end
end
