# encoding: UTF-8
#
# Cookbook Name:: mumble_server
# Attributes:: default
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

default['mumble_server']['packages'] = %w(mumble-server)
case node['platform_family']
when 'rhel', 'fedora'
  default['mumble_server']['service_name'] = 'murmur'
  default['mumble_server']['service_supports'] =
    Mash.new(restart: true, reload: false, status: true)
else
  default['mumble_server']['service_name'] = 'mumble-server'
  default['mumble_server']['service_supports'] =
    Mash.new(restart: true, reload: false, status: false)
end
default['mumble_server']['service_type'] = 'service'
default['mumble_server']['service_timeout'] = 60
default['mumble_server']['service_runit_packages'] = %w(lsof)
default['mumble_server']['config_file'] = '/etc/murmur/murmur.ini'
default['mumble_server']['config_file_links'] = %w(/etc/mumble-server.ini)
default['mumble_server']['pid_file'] =
  '/var/run/mumble-server/mumble-server.pid'
default['mumble_server']['pid_file_links'] = %w(
  /run/mumble-server/mumble-server.pid
)
default['mumble_server']['user'] = 'mumble-server'
default['mumble_server']['group'] = node['mumble_server']['user']
default['mumble_server']['verbose'] = Chef::Config[:log_level] == :debug
