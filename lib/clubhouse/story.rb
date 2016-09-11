module Clubhouse
  class Story < BaseResource
    resource :stories

    attributes :archived, :comments, :created_at, :deadline, :description, :epic_id, :estimate,
      :file_ids, :follower_ids, :id, :labels, :linked_file_ids, :name, :owner_ids,
      :position, :project_id, :requested_by_id, :story_links, :story_type, :tasks,
      :updated_at, :workflow_state_id, readonly: :id

  end
end
