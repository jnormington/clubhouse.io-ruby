module Clubhouse
  class Story < BaseResource
    resource :stories

    attributes :archived, :comments, :created_at, :deadline, :description, :epic_id, :estimate,
      :file_ids, :follower_ids, :labels, :linked_file_ids, :name, :owner_ids,
      :position, :project_id, :requested_by_id, :story_links, :story_type, :tasks,
      :updated_at, :workflow_state_id, readonly: :id

    attributes_for_create :comments, :created_at, :deadline, :description, :epic_id, :estimate,
                          :external_id, :file_ids, :labels, :linked_file_ids, :name, :owner_ids,
                          :project_id, :requested_by_id, :story_links, :story_type, :tasks,
                          :updated_at, :workflow_state_id

    attributes_for_update :after_id, :archived, :before_id, :deadline, :description, :epic_id,
                          :estimate, :file_ids, :follower_ids, :labels, :linked_file_ids, :name,
                          :owner_ids, :project_id, :requested_by_id, :story_type, :workflow_state_id

    def self.all
      raise NotSupportedByAPIError,
        'Use Story.search(..) to return stories matching your search query'
    end
  end
end
