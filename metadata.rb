# encoding: UTF-8
#
# Cookbook Name:: mumble_server
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

name 'mumble_server'
maintainer 'Xabier de Zuazo'
maintainer_email 'xabier@zuazo.org'
license 'Apache 2.0'
description 'Installs and configures a Mumble server (called Murmur).'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0' # WiP

if respond_to?(:source_url)
  source_url "https://github.com/zuazo/#{name}-cookbook"
end
if respond_to?(:issues_url)
  issues_url "https://github.com/zuazo/#{name}-cookbook/issues"
end

supports 'debian'
supports 'fedora'
supports 'ubuntu'

depends 'runit', '~> 1.4'

recipe 'mumble_server::default', 'Installs and configures Mumble server.'

provides 'mumble_server_supw'

# attributes/default.rb

attribute 'mumble_server/packages',
          display_name: 'mumble server packages',
          description: 'Mumble server required packages as array.',
          type: 'array',
          required: 'optional',
          default: '["mumble-server"]'

attribute 'mumble_server/service_name',
          display_name: 'mumble server service',
          description: 'Mumble server service name.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'mumble_server/service_supports',
          display_name: 'mumble service supports',
          description: 'Mumble service supported actions Hash.',
          type: 'hash',
          required: 'optional',
          calculated: true

attribute 'mumble_server/service_type',
          display_name: 'mumble server service type',
          description: 'Mumble server service type.',
          type: 'string',
          choice: %w("service" "runit_service"),
          required: 'optional',
          default: '"service"'

attribute 'mumble_server/service_timeout',
          display_name: 'mumble server service timeout',
          description:
            'Mumble server service timeout in seconds. Only for runit.',
          type: 'string',
          required: 'optional',
          default: '60'

attribute 'mumble_server/service_runit_packages',
          display_name: 'mumble server service runit packages',
          description:
            'Mumble server packages required for runit service.',
          type: 'string',
          required: 'optional',
          default: '["lsof"]'

attribute 'mumble_server/config_file',
          display_name: 'mumble server config file',
          description: 'Mumble server configuration file.',
          type: 'string',
          required: 'optional',
          default: '"/etc/murmur/murmur.ini"'

attribute 'mumble_server/config_file_links',
          display_name: 'mumble server config file links',
          description:
            'Mumble server file links to create pointing to the configuration '\
            'file.',
          type: 'array',
          required: 'optional',
          default: '["/etc/mumble-server.ini"]'

attribute 'mumble_server/pid_file',
          display_name: 'mumble server pid file',
          description: 'Mumble server pidfile path.',
          type: 'string',
          required: 'optional',
          default: '"/var/run/mumble-server/mumble-server.pid"'

attribute 'mumble_server/pid_file_links',
          display_name: 'mumble server pid file links',
          description:
            'Mumble server file links to create pointing to the pidfile.',
          type: 'array',
          required: 'optional',
          default: '["/run/mumble-server/mumble-server.pid"]'

attribute 'mumble_server/user',
          display_name: 'mumble server user',
          description: 'Mumble server system user.',
          type: 'string',
          required: 'optional',
          default: '"mumble-server"'

attribute 'mumble_server/group',
          display_name: 'mumble server group',
          description: 'Mumble server system group.',
          type: 'string',
          required: 'optional',
          default: '"mumble-server"'

attribute 'mumble_server/verbose',
          display_name: 'mumble server verbose',
          description:
            'Mumble server service verbose mode. Only for runit.',
          choice: %w(true false),
          type: 'string',
          required: 'optional',
          calculated: true

# attributes/config.rb

attribute 'mumble_server/config',
          display_name: 'mumble server config',
          description:
            'Mumble server configuration Hash. There is no need to escape '\
            'values.',
          type: 'hash',
          required: 'optional',
          calculated: true
