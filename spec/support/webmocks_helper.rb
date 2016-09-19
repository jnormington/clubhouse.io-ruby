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
end
