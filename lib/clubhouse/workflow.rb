module Clubhouse
  class Workflow < BaseResource
    resource :workflows

    attributes :default_state_id, readonly: [:id, :created_at, :states, :updated_at]

    State = Struct.new(:color, :created_at, :description, :id, :name,
                        :num_stories, :position, :type, :updated_at, :verb)

    def save
      raise NotImplementedError, "You can't manage workflows over the API, please use clubhouse web"
    end

    def self.delete(id = nil)
      raise NotImplementedError, "You can't delete workflows over the API, please use clubhouse web"
    end

    def self.find(id = nil)
      raise NotImplementedError, "You can only list all workflows, please use Clubhouse::Workflow.all"
    end

    def states
      @_states ||= Array(@states).collect do |s|
        State.new(
          s['color'],
          s['created_at'],
          s['description'],
          s['id'],
          s['name'],
          s['num_stories'],
          s['position'],
          s['type'],
          s['updated_at'],
          s['verb']
        )
      end
    end
  end
end
