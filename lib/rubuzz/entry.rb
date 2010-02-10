# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

module Rubuzz

  # The Entry class is used by Buzz and Comment classes for general tasks
  class Entry

    attr_reader :author, :author_url, :content, :created_at, :id, :title,
                :updated_at

    # Initializes a new Buzz object with the given XML data
    #
    # +data+: The XML data from the update feed
    def initialize(data)
      @author     = data.elements['author/name'].text
      @author_url = data.elements['author/uri'].text
      @content    = data.elements['content'].text
      @created_at = (data.elements['published'].nil?) ? nil : Time.parse(data.elements['published'].text)
      @id         = data.elements['id'].text.split('/').last
      @title      = data.elements['title'].text
      @updated_at = Time.parse(data.elements['updated'].text)
    end

  end

end
