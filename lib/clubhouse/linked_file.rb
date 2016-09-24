module Clubhouse
  class LinkedFile < BaseResource
    resource 'linked-files'

    attributes :content_type, :description, :name, :size, :story_id, :thumbnail_url,
      :uploader_id, :url, :type, readonly: [:created_at, :id, :mention_ids, :story_ids, :updated_at]

    attributes_for_create :content_type, :description, :name, :size, :story_id,
      :thumbnail_url, :type, :uploader_id, :url

    attributes_for_update :description, :name, :size, :thumbnail_url, :type, :uploader_id, :url
  end
end
