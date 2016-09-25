module Clubhouse
  class StoryLink < BaseResource
    resource 'story-links'

    attributes :object_id, :subject_id, :verb, readonly: [ :created_at, :id, :updated_at ]
    attributes_for_create :object_id, :subject_id, :verb

    def save
      raise NotSupportedByAPIError, "You can't update a story link" if id
      super
    end

    def self.all
      raise NotSupportedByAPIError, "Not supported by the API"
    end
  end
end
