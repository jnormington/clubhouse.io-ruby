class BaseResource
  class << self
    attr_reader :endpoint

    def resource(name)
      @endpoint = name
    end
  end

  def self.attributes(*keys)
    class_eval do
      keys.each do |key|
        define_method(:"#{key}")  { instance_variable_get("@#{key}") }
        define_method(:"#{key}=") {|v| instance_variable_set("@#{key}", v) }
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
end
