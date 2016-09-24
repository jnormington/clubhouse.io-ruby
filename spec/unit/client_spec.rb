require 'spec_helper'

module Clubhouse
  describe Client do
    subject { Client.new('toke&1234') }
    let(:basepath) { 'https://api.clubhouse.io/api/v1' }

    describe 'API_VERSION' do
      it 'returns stable api version' do
        expect(Client::API_VERSION).to eq 'v1'
      end
    end

    describe '#basepath' do
      it 'returns the full api path' do
        expect(subject.basepath).to eq basepath
      end
    end

    describe '#get' do
      let(:path) { "#{subject.basepath}/labels" }
      let(:uri) { URI.parse(path) }
      let(:http) { Net::HTTP.new(uri.host,443) }
      let(:good_resp) { Net::HTTPResponse.new('1.0', "200", "OK") }
      let(:bad_resp) { Net::HTTPResponse.new('1.0', "401", "Oh") }

      before do
        expect(URI).to receive(:parse).with(path).and_return(uri)
        expect(uri).to receive(:query=).with("token=toke%261234")
        expect(Net::HTTP).to receive(:new).with(uri.host, 443).and_return(http)
        expect(http).to receive(:use_ssl=).with(true)
      end

      it 'builds uri with user token param and makes request' do
        allow(good_resp).to receive(:body).and_return('{"id": "123-a-123"}')
        expect(http).to receive(:request).and_return(good_resp)
        expect(JSON).to receive(:parse).with('{"id": "123-a-123"}')

        subject.get(:labels)
      end

      it 'calls raise_error_to_user' do
        allow(bad_resp).to receive(:body).and_return('{"error": "ID not valid"}')
        expect(http).to receive(:request).and_return(bad_resp)

        expect(subject).to receive(:raise_error_to_user).once.with(bad_resp)
        subject.get(:labels)
      end
    end

    describe '#delete' do
      let(:uri) { URI.parse(subject.basepath + "/labels/1?token=toke%261234") }
      let(:req) { Net::HTTP::Delete.new(uri) }
      let(:response) { Net::HTTPResponse.new('delete', '200', '') }

      it 'builds and makes request' do
        expect(Net::HTTP::Delete).to receive(:new).with(uri).and_return(req)
        expect(subject).to receive(:do_request).with(req).once

        subject.delete('labels/1')
      end

      it 'successfully returns when response body is nil' do
        # The delete request for clubhouse has no body which previously broke JSON.parse
        allow(response).to receive(:body).and_return(nil)

        expect(Net::HTTP::Delete).to receive(:new).with(uri).and_return(req)
        expect_any_instance_of(Net::HTTP).to receive(:request).and_return(response)

        subject.delete('labels/1')
      end
    end

    describe '#post' do
      let(:uri) { URI.parse(subject.basepath + "/labels?token=toke%261234") }
      let(:body) { {name: 'Label A'} }
      let(:req) { Net::HTTP::Post.new(uri) }

      it 'builds and makes request' do
        expect(Net::HTTP::Post).to receive(:new).with(uri).and_return(req)
        expect(req).to receive(:body=).with(body.to_json)
        expect(subject).to receive(:do_request).with(req).once

        subject.post('labels', body)
      end
    end

    describe '#put' do
      let(:uri) { URI.parse(subject.basepath + "/labels/1?token=toke%261234") }
      let(:body) { {id: 1, name: 'Label Rejected'} }
      let(:req) { Net::HTTP::Put.new(uri) }

      it 'builds and makes request' do
        expect(Net::HTTP::Put).to receive(:new).with(uri).and_return(req)
        expect(req).to receive(:body=).with(body.to_json)
        expect(subject).to receive(:do_request).with(req).once

        subject.put('labels/1', body)
      end
    end

    describe '#raise_error_to_user' do
      let(:response) { Net::HTTPResponse.new('1.0', "", "") }

      before do
        allow(response).to receive(:body).and_return('Body error')
      end

      it 'raises a BadRequestError' do
        allow(response).to receive(:code).and_return('400')
        expect{ subject.raise_error_to_user(response) }.to raise_error BadRequestError
      end

      it 'raises a ResourceNotFoundError' do
        allow(response).to receive(:code).and_return('404')
        expect{ subject.raise_error_to_user(response) }.to raise_error ResourceNotFoundError
      end

      [401, 403].each do |code|
        it "raises an UnauthorizedError for #{code}" do
          allow(response).to receive(:code).and_return(code.to_s)
          expect{ subject.raise_error_to_user(response) }.to raise_error UnauthorizedError
        end
      end

      it "raises an UnprocessableError" do
        allow(response).to receive(:code).and_return('422')
        expect{ subject.raise_error_to_user(response) }.to raise_error UnprocessableError
      end

      (500..503).each do |code|
        it "raises an UnexpectedError for #{code}" do
          allow(response).to receive(:code).and_return(code.to_s)
          expect{ subject.raise_error_to_user(response) }.to raise_error UnexpectedError
        end
      end

      it "raises an UnexpectedError for an unexpected code" do
        allow(response).to receive(:code).and_return('418')
        expect{ subject.raise_error_to_user(response) }.to raise_error UnexpectedError
      end
    end
  end
end
