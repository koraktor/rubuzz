# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rubuzz/abstract_feed'
require 'rubuzz/buzz'
require 'rubuzz/pubsubhubbub'

module Rubuzz

  # The BuzzFeed class represents a Google Buzz update feed
  class BuzzFeed < AbstractFeed

    attr_reader :buzzes

    # Initializes a new BuzzFeed object representing a Google Buzz update feed
    # for the given user
    #
    # +user+: The update feed is loaded for this user
    def initialize(user)
      super

      @url = "http://buzz.googleapis.com/feeds/#{user}/public/posted"
    end

    # Parses the data from the update feed
    def parse(feed_data)
      super

      @buzzes = []
      feed_data.elements.each('entry') do |buzz_data|
        @buzzes << Buzz.new(@user, buzz_data)
      end

      true
    end

    # Subscribe to this Buzz feed. This will automatically update this feed
    # once new buzzes are posted
    #
    # +public_ip+:   The IP address the client should bind to
    # +public_port+: The port the client should listen to
    def subscribe(public_ip, public_port = 80)
      fetch if @hub_url.nil?
      hub = PubSubHubbub.new(@hub_url, public_ip, public_port)
      hub.subscribe(self)
      hub.client_thread.join
    end

  end

end
