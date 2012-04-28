$:.unshift File.join(File.dirname(__FILE__))
$stdout.sync = true

require 'mixlib/cli'
require 'etc'
require 'fileutils'

module Kindness
  VERSION = File.open(File.join(File.dirname(__FILE__), '..', 'VERSION')).read
end

require 'kindness/util'
require 'kindness/application'
