module Clubhouse
  class BadRequestError < StandardError; end
  class UnauthorizedError < StandardError; end
  class ResourceNotFoundError < StandardError; end
  class UnexpectedError < StandardError; end

  class Client
    API_VERSION='v1'.freeze

    def initialize(token)
      @token = token
    end

    def basepath
      @basepath ||= "https://api.clubhouse.io/api/#{API_VERSION}"
    end

    def get(resource)
      req = Net::HTTP::Get.new(build_uri(resource))
      do_request(req)
    end

    def delete(resource)
      req = Net::HTTP::Delete.new(build_uri(resource))
      do_request(req)
    end

    def post(resource, body = {})
      req = Net::HTTP::Post.new(build_uri(resource))
      req.set_form_data(body.to_json)

      do_request(req)
    end

    def put(resource, body = {})
      req = Net::HTTP::Put.new(build_uri(resource))
      req.set_form_data(body.to_json)

      do_request(req)
    end

    def raise_error_to_user(response)
      code = response.code.to_i

      err = case code
        when 400 then BadRequestError
        when 401, 403 then UnauthorizedError
        when 404 then ResourceNotFoundError
        when 500..503 then UnexpectedError
      end

      raise err, response.body
    end

    private

    def build_uri(resource)
      uri = URI.parse("#{basepath}/#{resource}")
      uri.query = URI.encode_www_form(token: @token)
      uri
    end

    def do_request(request)
      http = Net::HTTP.new(request.uri.host, request.uri.port)
      http.use_ssl = true
      response = http.request(request)

      if [200,201,204].include?(response.code.to_i)
        JSON.parse(response.body)
      else
        raise_error_to_user(response)
      end
    end
  end
end
