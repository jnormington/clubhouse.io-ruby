module WebmocksHelper
  def fixture_path(fixture)
    File.expand_path("../../fixtures/#{fixture}", __FILE__)
  end

  def url_for(path)
    "https://api.clubhouse.io/api/v1/#{path}?token=11aa1a1c-11a1-1a1a-aaaa-1afa1111111a"
  end

  def stub_create_story_with(request_body, response_body)
    body = File.read(fixture_path("#{response_body}.json"))
    stub_request(:post, url_for(:stories)).with(body: request_body).and_return({status: 200, body: body})
  end

  def stub_update_story_with(id, request_body, response_body)
    body = File.read(fixture_path("#{response_body}.json"))
    stub_request(:put, url_for("stories/#{id}")).with(body: request_body).and_return({status: 200, body: body})
  end

  def stub_error_response_for(verb, path, resp)
    stub_request(verb, url_for(path)).and_return(status: 400, body: resp)
  end

  def stub_get_story_with(id, response_body)
    body = File.read(fixture_path("#{response_body}.json"))
    puts body
    stub_request(:get, url_for("stories/#{id}")).and_return({status: 200, body: body})
  end
end
