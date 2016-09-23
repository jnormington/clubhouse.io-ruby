module Clubhouse
  class Project < BaseResource
    resource :projects

    attributes :abbreviation, :archived, :color, :created_at, :description, :external_id,
      :follower_ids, :name, :updated_at, readonly: [:archived, :id, :num_points, :num_stories]

    attributes_for_create :abbreviation, :color, :created_at, :description,
      :external_id, :follower_ids, :name, :updated_at

    attributes_for_update :abbreviation, :archived, :color, :description, :follower_ids, :name

    def stories
      return [] if id.nil?

      payload = client.get("projects/#{id}/stories")
      Array(payload).collect{|s| Story.new.update_object_from_payload(s) }
    end
  end
end
