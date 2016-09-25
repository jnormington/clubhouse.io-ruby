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


    def comments
      @_comments ||= Array(@comments).collect {|c| Comment.new.update_object_from_payload(c) }
    end

    def tasks
      @_tasks ||= Array(@tasks).collect {|t| Task.new.update_object_from_payload(t) }
    end

    def add_comment(text)
      add_resource(:comment) do
        comment = Comment.new(text: text, story_id: id)
        comment.save
        comments << comment
      end
    end

    def add_task(desc)
      add_resource(:task) do
        task = Task.new(description: desc, story_id: id)
        task.save
        tasks << task
      end
    end

    def update_object_from_payload(attr = {})
      super
      instance_variable_set("@_comments", nil)
      instance_variable_set("@_tasks", nil)
      self
    end

    class << self
      def all
        raise NotSupportedByAPIError,
          'Use Story.search(..) to return stories matching your search query'
      end

      def search(attr = {})
        payload = client.post("#{endpoint}/search", attr)
        payload.collect {|s| new.update_object_from_payload(s) }
      end
    end

    private

    def add_resource(type)
      raise StoryNotSavedError, "Please save the story to use the add #{type} method" unless id
      yield
    end
  end
end
