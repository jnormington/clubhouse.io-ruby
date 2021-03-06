require 'net/http'
require 'json'

require 'clubhouse/version'
require 'clubhouse/ext/string'
require 'clubhouse/api_actions'
require 'clubhouse/client'
require 'clubhouse/base_resource'

require 'clubhouse/story'
require 'clubhouse/label'
require 'clubhouse/user'
require 'clubhouse/workflow'
require 'clubhouse/project'
require 'clubhouse/epic'
require 'clubhouse/file'
require 'clubhouse/linked_file'
require 'clubhouse/task'
require 'clubhouse/comment'
require 'clubhouse/story_link'

module Clubhouse
  class NotSupportedByAPIError < StandardError; end
  class MissingStoryIDError < StandardError; end
  class StoryNotSavedError < StandardError; end

  class << self
    attr_accessor :default_client

    def configure
      yield self if block_given?
    end
  end
end
