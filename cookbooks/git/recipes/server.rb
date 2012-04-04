#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: git
# Recipe:: server
#
# Copyright 2011, Josh Toft
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

user "git" do
  comment "Git Repository User"
  shell "/bin/bash"
  home node[:git][:home]
  gid "git"
end

group "git" do
  members ["git"]
  append true
end
  
directory node[:git][:home] do
  owner "git"
  group "git"
  mode 00755
  action :create
end
