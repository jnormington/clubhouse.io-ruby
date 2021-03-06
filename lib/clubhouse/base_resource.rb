module Clubhouse
  class InvalidKeyAssignment < StandardError; end
  class ClientNotSetup < StandardError; end

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

      def find(id)
        client.find(self, self.endpoint, id)
      end

      def delete(id)
        client.delete("#{self.endpoint}/#{id}")
      end

      def all
        payload = client.get(self.endpoint)
        payload.collect{|h| self.new.update_object_from_payload(h) }
      end
    end

    def initialize(attr = {})
      attr.each do |key, value|
        begin
          send("#{key}=", value)
        rescue NoMethodError
          raise InvalidKeyAssignment, "You can't assign value to #{key}"
        end
      end
    end

    def self.attributes(*keys, **opts)
      readonly = Array(opts[:readonly])

      class_eval do
        define_method(:attribute_keys) { (keys + readonly) }

        (keys + readonly).each do |key|
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
          keys.reduce({}) do |h, k|
            h.merge(k => instance_variable_get("@#{k}"))
          end.reject{|k,v| v.nil?}
        end
      end
    end

    def self.attributes_for_create(*keys)
      class_eval do
        define_method :create_attributes do
          keys.reduce({}) do |h, k|
            h.merge(k => instance_variable_get("@#{k}"))
          end.reject{|k,v| v.nil?}
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

      self
    end

    def reload
      payload = client.get("#{self.class.endpoint}/#{id}")
      update_object_from_payload(payload)
    end

    def save
      raise ClientNotSetup, "A default client or instance client is not setup" unless client

      payload = if id
                  client.put("#{self.class.endpoint}/#{id}", update_attributes)
                else
                  client.post(self.class.endpoint, create_attributes)
                end

      update_object_from_payload(payload)
    end
  end
end
