#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: virtualbox
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

virtualbox_install "latest" do
  action :install
end

# unless virtualbox_installed?
#   download_virtualbox
#   install_virtualbox
# end
#   
#   case node['platform']
#   when "mac_os_x"
#     # DMG=$(curl -sL $VBOXURL/MD5SUMS | grep dmg | awk 'BEGIN { FS="\*" } ; { print $2 }')
#     # curl -sLO $VBOXURL/$DMG
#   else
#     # Chef::Log.info 'Downloading Virtualbox'
#     # arch = node['kernel']['machine']
#     # 
#     # RPM=$(curl -sL $VBOXURL/MD5SUMS | grep rhel6 | awk 'BEGIN { FS="\*" } ; { print $2 }' | grep $ARCH)
#     # $(curl -sLO $VBOXURL/$RPM)
#     # rpm -i $RPM
#     # rm $RPM
#   end
# end
