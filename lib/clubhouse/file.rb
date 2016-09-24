module Clubhouse
  class File < BaseResource
    resource :files

    attributes :created_at, :description, :external_id, :name, :updated_at, :uploader_id,
      readonly: [:content_type, :filename, :id, :mention_ids, :size, :story_ids, :thumbnail_url, :url]

    attributes_for_update :description, :external_id, :name, :updated_at, :uploader_id

    def save
      if id.nil?
        raise NotSupportedByAPIError,
          "You can't create a direct file upload, but can create linked files over the API"
      end

      super
    end
  end
end
