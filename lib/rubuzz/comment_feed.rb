# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rubuzz/abstract_feed'
require 'rubuzz/comment'

module Rubuzz

  # The CommentFeed class represents a Google Buzz update feed for comments on
  # a single Buzz
  class CommentFeed < AbstractFeed

    attr_reader :buzz_id, :comments

    def initialize(user, buzz_id)
      super(user)

      @buzz_id = buzz_id
      @url     = "http://buzz.googleapis.com/feeds/#{user}/comments/#{buzz_id}"
    end

    # Fetches the data from the update feed
    def fetch
      feed_data = super

      @comments = []
      feed_data.elements.each('entry') do |comment_data|
        @comments << Comment.new(user, comment_data)
      end

      true
    end

  end

end
