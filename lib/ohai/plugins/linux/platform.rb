#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
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
def get_redhatish_version(file)
  contents = File.read(file).chomp
  contents[/Rawhide/] ? "rawhide" : contents[/release ([\d\.]+)/, 1]
end

provides "platform", "platform_version"

require_plugin 'linux::lsb'

if lsb[:id]
  platform lsb[:id].downcase
  platform_version lsb[:release]
elsif File.exists?("/etc/debian_version")
  platform "debian"
  platform_version File.read("/etc/debian_version").chomp
elsif File.exists?("/etc/fedora-release") and File.exists?("/etc/redhat-release")
  platform "fedora"
  platform_version get_redhatish_version("/etc/fedora-release")
elsif File.exists?("/etc/redhat-release")
  platform "redhat"
  platform_version get_redhatish_version("/etc/redhat-release")
elsif File.exists?('/etc/gentoo-release')
  platform "gentoo"
  platform_version IO.read('/etc/gentoo-release').scan(/(\d+|\.+)/).join
elsif File.exists?('/etc/SuSE-release')
  platform "suse"
  platform_version IO.read('/etc/SuSE-release').scan(/\d+\.\d+/)[0]
end
