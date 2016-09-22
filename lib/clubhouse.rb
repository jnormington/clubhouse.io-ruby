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
require 'clubhouse/permission'
require 'clubhouse/workflow'

module Clubhouse

  class << self
    attr_accessor :default_client

    def configure
      yield self if block_given?
    end
  end
end
