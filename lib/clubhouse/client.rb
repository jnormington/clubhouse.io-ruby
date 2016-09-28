module Clubhouse
  class BadRequestError < StandardError; end
  class UnauthorizedError < StandardError; end
  class ResourceNotFoundError < StandardError; end
  class UnexpectedError < StandardError; end
  class UnprocessableError < StandardError; end

  class Client
    include APIActions

    API_VERSION='beta'.freeze

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
      req['Content-Type'] = 'application/json'
      req.body = body.to_json

      do_request(req)
    end

    def put(resource, body = {})
      req = Net::HTTP::Put.new(build_uri(resource))
      req['Content-Type'] = 'application/json'
      req.body = body.to_json

      do_request(req)
    end

    def raise_error_to_user(response)
      code = response.code.to_i

      err = case code
        when 400 then BadRequestError
        when 401, 403 then UnauthorizedError
        when 404 then ResourceNotFoundError
        when 422 then UnprocessableError
        else UnexpectedError
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
        # Clubhouse API returns content type as application/json for DELETE request with no body :(
        return {} if response.body.nil?
        JSON.parse(response.body)
      else
        raise_error_to_user(response)
      end
    end
  end
end
