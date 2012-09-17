#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: virtualbox
# Provider:: install
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

require 'open-uri'
require 'timeout'
require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :install do
  
  install_version = nil
  if @new_resource.version
    install_version ||= @new_resource.version
  else
    install_version ||= candidate_version
  end
  
  # Set the timeout (units in seconds)
  timeout = 900
  if @new_resource.timeout
    timeout = @new_resource.timeout
  end
  
  next unless latest_virtualbox_version
  next if (install_version == current_virtualbox_version)
  Chef::Log.info "Installing Virtualbox Version: #{install_version}"
  install_virtualbox(install_version)
end

action :remove do
  # Set the timeout (units in seconds)
  timeout = 900
  if @new_resource.timeout
    timeout = @new_resource.timeout
  end
end

def candidate_version
  @candidate_version ||= begin
    @new_resource.version || latest_virtualbox_version
  end
end

def virtualbox_location
  p = shell_out('which virtualbox')
  p.stdout.to_s.strip
end

def virtualbox_installed?
  !virtualbox_location.empty?
end

def current_virtualbox_version
  if virtualbox_installed?
    p = shell_out!('VBoxManage --version').stdout
    p.to_s.split("r").first.to_s.strip
  else
    ''
  end
end

def latest_virtualbox_version
  return @latest_version if @latest_version
  Timeout::timeout(2) {
    @latest_version ||= open(
      'http://download.virtualbox.org/virtualbox/LATEST.TXT').read.strip
  }
rescue Timeout::Error
  @latest_version ||= nil
end

def virtualbox_download_folder(version)
  "http://download.virtualbox.org/virtualbox/#{version}"
end

# Creates a list of the current md5sums and their associated files
def virtualbox_md5sum_list(version)
  md5_url = "#{virtualbox_download_folder(version)}/MD5SUMS"
  vbox_md5list = open(md5url).read.split("\n")
  vbox_md5list.map do |line|
    md5, file = line.split(' *')
    { 'md5' => md5, 'file' => file }
  end
end

# Takes a list of arguments and runs them as  a filter against the md5list
def virtualbox_for_platform(version, *args)
  md5list = virtualbox_md5sum_list(version)
  args.each { |arg| md5list.select! { |h| h['file'].downcase =~ /#{arg}/ } }
  md5list
end

def install_virtualbox(version)
  case node['platform']
  when "mac_os_x"
    install_osx(version)
  else
  end
end


def install_osx(version)
  vbox_source = virtualbox_for_platform(version, 'osx').first
  
  dmg_package "Virtualbox" do
    source "#{virtualbox_download_folder(version)}/#{vbox_source['file']}"
    checksum vbox_source['md5']
    type "mpkg"
    action :upgrade
  end
end
