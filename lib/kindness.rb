$stdout.sync = true

require 'mixlib/cli'
require 'etc'
require 'fileutils'

module Kindness
  VERSION = "0.0.1"
end

require 'kindness/util'
require 'kindness/application'
