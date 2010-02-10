# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

require 'yaml'

require 'rubuzz/feed'

module Rubuzz

  version = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'VERSION.yml'))
  VERSION = "#{version[:major]}.#{version[:minor]}.#{version[:patch]}"

end
