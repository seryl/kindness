#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: eclipse
# Recipe:: default
#
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

if node['platform'] == 'mac_os_x'
  bash "install eclipse" do
    cwd "/opt"
    code <<-EOH
    curl -O 'http://mirror.cc.vt.edu/pub/eclipse/technology/epp/downloads/release/indigo/SR2/eclipse-jee-indigo-SR2-macosx-cocoa-x86_64.tar.gz'
    tar -C /opt -zxvf eclipse-jee-indigo-SR2-macosx-cocoa-x86_64.tar.gz
    rm eclipse-jee-indigo-SR2-macosx-cocoa-x86_64.tar.gz
    EOH
    not_if "ls /opt/eclipse | grep Eclipse"
  end
  
  link "/Applications/Eclipse.app" do
    to "/opt/eclipse/Eclipse.app"
  end
else
end
