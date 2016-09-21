module Clubhouse
  class Label < BaseResource
    resource :labels

    attributes :name, :external_id, readonly: [
      :id,
      :num_stories_in_progress,
      :num_stories_total,
      :num_stories_completed,
      :created_at,
      :updated_at,
      :num_stories_completed
    ]

    attributes_for_create :name, :external_id
    attributes_for_update :name
  end
end
