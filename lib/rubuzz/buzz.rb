# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rexml/xpath'

module Rubuzz

  # The Buzz class represents a Google Buzz
  class Buzz

    attr_reader :author, :author_url, :content, :id, :reply_count, :reply_url,
                :title, :updated_at, :url


    # Initializes a new Buzz object with the given XML data
    #
    # +data+: The XML data from the update feed
    def initialize(data)
      @author      = data.elements['author/name'].text
      @author_url  = data.elements['author/uri'].text
      @content     = data.elements['content'].text
      @id          = data.elements['id'].text
      @reply_count = data.elements['thr:total'].text.to_i
      @reply_url   = REXML::XPath.first(data, 'link[@rel="replies"]').attributes['href']
      @title       = data.elements['title'].text
      @updated_at  = Time.parse(data.elements['updated'].text)
      @url         = REXML::XPath.first(data, 'link[@rel="alternate"]').attributes['href']
    end

  end

end
