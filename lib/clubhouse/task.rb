module Clubhouse
  class Task < BaseResource
    resource :tasks

    attributes :complete, :created_at, :description, :external_id, :owner_ids,
      :updated_at, :story_id, readonly: [:completed_at, :id, :mention_ids, :position]

    attributes_for_create :complete, :created_at, :description, :external_id, :owner_ids, :updated_at
    attributes_for_update :after_id, :before_id, :complete, :description, :owner_ids


    def save
      raise MissingStoryIDError, 'story_id is required to create/update tasks' unless story_id
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
      def find(story_id, task_id)
        payload = client.get("stories/#{story_id}/#{endpoint}/#{task_id}")
        new.update_object_from_payload(payload)
      end

      def delete(story_id, task_id)
        client.delete("stories/#{story_id}/tasks/#{task_id}")
      end

      def all
        raise NotSupportedByAPIError, "You can get all tasks associated directly from the story model"
      end
    end
  end
end
