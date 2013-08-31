#
# Author:: JT giri <jt@nclouds.com>
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
#
# NOTES:
# yum-plugin-security package is required for this plugin to work 

provides "security_updates"
require_plugin "platform"

security_updates Mash.new
cmd = "yum list-security --quiet"

status, stdout, stderr = run_command(:command => cmd)
return "" if stdout.nil? || stdout.empty?

if %w{ rhel fedora suse }.include?(platform_family) or %w{  redhat fedora centos suse }.include?(platform)
  stdout.each_line do |r|
    id,severity,package = r.split
    ## Remove /Sec. from security severity
    severity = severity.gsub(/\/\w+\./, "")
    security_updates[severity] = Array.new unless security_updates[severity].class == Array
    security_updates[severity] << [id,package]
  end
end