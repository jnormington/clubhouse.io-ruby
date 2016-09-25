module Clubhouse
  class Comment < BaseResource
    resource :comments

    attributes :author_id, :created_at, :external_id, :story_id, :text, :updated_at,
      readonly: [:id, :mention_ids, :position]

    attributes_for_create :author_id, :created_at, :external_id, :text, :updated_at
    attributes_for_update :text

    def save
      raise MissingStoryIDError, 'story_id is required to create/update comments' unless story_id
      raise ClientNotSetup, "A default client or instance client is not setup" unless client

      payload = if id
                  client.put("stories/#{story_id}/#{self.class.endpoint}/#{id}", update_attributes)
                else
                  client.post("stories/#{story_id}/#{self.class.endpoint}", create_attributes)
                end

      update_object_from_payload(payload)
    end

    def reload
      payload = client.get("stories/#{story_id}/#{self.class.endpoint}/#{id}")
      update_object_from_payload(payload)
    end

    class << self
      def find(story_id, comment_id)
        payload = client.get("stories/#{story_id}/#{endpoint}/#{comment_id}")
        new.update_object_from_payload(payload)
      end

      def delete(story_id, comment_id)
        client.delete("stories/#{story_id}/#{endpoint}/#{comment_id}")
      end

      def all
        raise NotSupportedByAPIError,
          "You can get all comments associated directly from the story model"
      end
    end
  end
end
