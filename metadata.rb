# encoding: UTF-8

name 'mumble_server'
maintainer 'Onddo Labs, SL.'
maintainer_email 'team@onddo.com'
license 'Apache 2.0'
description 'Installs and configures a Mumble server (called Murmur).'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

supports 'debian'
supports 'fedora'
supports 'ubuntu'

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

attribute 'mumble_server/config_file',
          display_name: 'mumble server config file',
          description: 'Mumble server configuration file.',
          type: 'string',
          required: 'optional',
          default: '"/etc/murmur/murmur.ini"'

attribute 'mumble_server/pid_file',
          display_name: 'mumble server pid file',
          description: 'Mumble server pidfile path.',
          type: 'string',
          required: 'optional',
          default: '"/var/run/mumble-server/mumble-server.pid"'

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

# attributes/config.rb

attribute 'mumble_server/config',
          display_name: 'mumble server config',
          description:
            'Mumble server configuration Hash. There is no need to escape '\
            'values.',
          type: 'hash',
          required: 'optional',
          calculated: true
