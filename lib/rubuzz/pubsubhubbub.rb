require 'eventmachine'
require 'em-http'
require 'thin'
require 'thin/server'

require 'rubuzz/abstract_feed'

module Rubuzz

  class PubSubHubbub

    include EventMachine::Deferrable

    HEADERS = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => "Rubuzz #{::Rubuzz::VERSION}"
    }

    attr_reader :client_thread, :subscribed_feeds

    def initialize(url, public_ip, public_port = 80)
      @public_ip        = public_ip
      @public_port      = public_port
      @subscribed_feeds = {}
      @url              = url

      Thin::Logging.silent = true
      @client = Thin::Server.new('0.0.0.0', public_port, Client.new(self))
      @client_thread = Thread.new { @client.start }
    end

    def subscribe(feed)
      throw ArgumentError.new unless feed.is_a? AbstractFeed

      command('subscribe', feed.url, "http://#{@public_ip}:#{@public_port}/")
      subscribed_feeds[feed.url] = feed
    end

    private

    def command(command, url, callback, options = {})
      EventMachine.run do
        options['hub.verify'] ||= 'sync'

        parameters = []
        params = { 'hub.topic' => url, 'hub.mode' => command, 'hub.callback' => callback}.merge(options).each do |key, value|
          parameters << "#{key}=#{value}"
        end
        request = EventMachine::HttpRequest.new(@url).post :head => HEADERS, :body => params.to_params

        request.callback do
          if request.response_header.status == 204
            succeed request
          else
            fail request
          end
        end

        request.errback { fail }
        request
      end
    end

    class Client

      def initialize(pubsubhubbub)
        @pubsubhubbub = pubsubhubbub
      end

      def call(env)
        if env['REQUEST_METHOD'] == 'GET'
          return verify_subscription(env)
        elsif env['REQUEST_METHOD'] == 'POST' && env['CONTENT_TYPE'] == 'application/atom+xml'
          return update_feed(env)
        end
      end

      def feeds
        @pubsubhubbub.subscribed_feeds
      end

      def update_feed(env)
        feed_data = REXML::Document.new(env['rack.input'].string).root
        feed_url  = REXML::XPath.first(feed_data, 'link[@rel="self"]').attributes['href']
        feeds[feed_url].parse(feed_data)
      end

      def verify_subscription(env)
        query = env['QUERY_STRING'].split('&')
        query = Hash[query.map { |parameter| parameter.split('=') }]

        body = query['hub.challenge']

        headers = {}
        headers['Content-Length'] = body.size.to_s
        headers['Content-Type']   = 'text/plain'

        [200, headers, StringIO.new(body)]
      end

    end

  end

end
