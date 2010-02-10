# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rexml/xpath'

require 'rubuzz/comment_feed'
require 'rubuzz/entry'

module Rubuzz

  # The Buzz class represents a Google Buzz
  class Buzz < Entry

    attr_reader :comment_count, :url

    # Initializes a new Buzz object with the given XML data
    #
    # +user+: The user this Buzz belongs to
    # +data+: The XML data from the update feed
    def initialize(user, data)
      super(data)

      @comment_count = data.elements['thr:total'].text.to_i
      @comment_feed  = CommentFeed.new(user, @id)
      @url           = REXML::XPath.first(data, 'link[@rel="alternate"]').attributes['href']
      @user          = user
    end

    # Returns an Array of comments to this Buzz
    #
    # If the comments haven't been fetched already, this is done now
    def comments
      if @comment_feed.comments.nil?
        @comment_feed.fetch
      end

      @comment_feed.comments
    end

  end

end
