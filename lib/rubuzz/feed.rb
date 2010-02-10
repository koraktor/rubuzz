# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'open-uri'
require 'rexml/document'

require 'rubuzz/buzz'

module Rubuzz

  # The Feed class represents a Google Buzz update feed
  class Feed

    attr_reader :id, :buzzes, :title, :updated_at, :user

    # Initializes a new Feed object representing a Google Buzz update feed for
    # the given user
    #
    # +user+: The update feed is loaded for this user
    def initialize(user)
      @user = user
    end

    # Fetches the data from the update feed
    def fetch
      feed_url  = "http://buzz.googleapis.com/feeds/#{@user}/public/posted"
      feed_data = REXML::Document.new(open(feed_url, :proxy => true)).root

      @id         = feed_data.elements['id'].text
      @title      = feed_data.elements['title'].text
      @updated_at = Time.parse(feed_data.elements['updated'].text)

      @buzzes = []
      feed_data.elements.each('entry') do |entry_data|
        @buzzes << Buzz.new(entry_data)
      end

      true
    end

  end

end
