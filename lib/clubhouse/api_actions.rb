module Clubhouse
  class NoSuchResourceError < StandardError; end

  module APIActions
    def find(clazz, path, id)
      payload = get("#{path}/#{id}")
      clazz.new.update_object_from_payload(payload)
    end
  end
end
