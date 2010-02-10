# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rubuzz/abstract_feed'
require 'rubuzz/buzz'

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

    # Fetches the data from the update feed
    def fetch
      feed_data = super

      @buzzes = []
      feed_data.elements.each('entry') do |buzz_data|
        @buzzes << Buzz.new(@user, buzz_data)
      end

      true
    end

  end

end
