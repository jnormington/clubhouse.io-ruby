module Clubhouse
  class NoSuchResourceError < StandardError; end

  module APIActions
    def find(resource, id)
      res = find_resource(resource)
      payload = get("#{res.endpoint}/#{id}")
      res.new.update_object_from_payload(payload)
    end

    def known_resources
      return @resources if @resources

      @resources = {}

      Clubhouse.constants.each do |c|
        klazz = Clubhouse.const_get(c.to_s)
        if klazz.respond_to?(:endpoint)
          @resources[klazz.name.split('::').last.underscore.to_sym] = klazz
          @resources[klazz.endpoint] = klazz
        end
      end

      @resources
    end

    private

    def find_resource(resource)
      res = known_resources[resource.to_sym]

      return res if res
      raise NoSuchResourceError, "Available resources are #{known_resources.keys}"
    end
  end
end
