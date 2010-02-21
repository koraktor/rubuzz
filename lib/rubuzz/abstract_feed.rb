# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'open-uri'
require 'rexml/document'

module Rubuzz

  # The AbstractFeed class is used by Feed and CommentFeed classes for general
  # tasks
  class AbstractFeed

    attr_reader :id, :hub_url, :title, :updated_at, :url, :user

    # Sets the user this feed belongs to
    #
    # +user+: The update feed is loaded for this user
    def initialize(user)
      @user = user
    end

    # Fetches the data of a feed
    def fetch
      feed_data = REXML::Document.new(open(@url, :proxy => true)).root
      parse(feed_data)
    end

    # Parses general feed data for both, BuzzFeed and CommentFeed
    def parse(feed_data)
      @hub_url    = REXML::XPath.first(feed_data, 'link[@rel="hub"]').attributes['href']
      @id         = feed_data.elements['id'].text
      @title      = feed_data.elements['title'].text
      @updated_at = Time.parse(feed_data.elements['updated'].text)
      @url        = REXML::XPath.first(feed_data, 'link[@rel="self"]').attributes['href']

      feed_data
    end

  end

end
