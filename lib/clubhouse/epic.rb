module Clubhouse
  class Epic < BaseResource
    resource :epics

    attributes :archived, :created_at, :deadline, :description, :external_id,
      :follower_ids, :name, :owner_ids, :state, :updated_at, readonly: [:id, :comments, :position]

    attributes_for_create :created_at, :deadline, :description, :external_id,
      :follower_ids, :name, :owner_ids, :state, :updated_at

    attributes_for_update :after_id, :archived, :before_id, :deadline,
      :description, :follower_ids, :name, :owner_ids, :state

    def comments
      @_comments ||= Array(@comments).collect{|c| Comment.new.update_object_from_payload(c) }
    end

    class Comment < BaseResource
      attributes :text, readonly: [:author_id, :created_at, :updated_at, :deleted, :id, :comments]

      def comments
        @_comments ||= Array(@comments).collect {|c| Comment.new.update_object_from_payload(c) }
      end

      def save
        raise NotImplemented
      end

      def self.find(id = nil)
        raise NotImplemented
      end

      def self.all
        raise NotImplemented
      end
    end
  end
end
