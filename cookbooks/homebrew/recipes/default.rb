#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: homebrew
# Recipe:: default
#
# Copyright 2012, Graeme Mathieson
# Copyright 2012, Josh Toft
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"

if node['platform'] == 'mac_osx_x'
  user node[:homebrew][:user] do
    gid Etc.getgrnam('staff').gid
  end
  
  execute "install homebrew" do
    command "curl -sfL https://github.com/mxcl/homebrew/tarball/master | tar zx -m --strip 1"
    user node[:homebrew][:user]
    cwd "/usr/local"
    not_if { File.exist? '/usr/local/bin/brew' }
  end
  
  execute "chown homebrew Cellar" do
    command "chown -R #{node[:homebrew][:user]}:staff /usr/local/Cellar"
  end
  
  last_updated = "/usr/local/.git/index"
  execute "update homebrew from github" do
    command "/usr/local/bin/brew update || true"
    not_if { File.exists?(last_updated) && File.new(last_updated).mtime > Time.now-60*60 }
  end
end
