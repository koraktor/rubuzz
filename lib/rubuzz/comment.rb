# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rubuzz/entry'

module Rubuzz

  # The Comment class represents a comment on a Google Buzz
  class Comment < Entry

    attr_reader :buzz_id, :buzz_url

    # Initializes a new Comment object with the given XML data
    #
    # +buzz_user+: The user that posted the Buzz this comments belongs to
    # +data+:      The XML data from the update feed
    def initialize(buzz_user, data)
      super(data)

      @buzz_id    = data.elements['thr:in-reply-to'].attributes['ref'].split('/').last
      @buzz_url   = data.elements['thr:in-reply-to'].attributes['href']
      @buzz_user  = buzz_user
    end

  end

end
