Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/mumble_server.svg?style=flat)](https://supermarket.getchef.com/cookbooks/mumble_server)
[![Dependency Status](http://img.shields.io/gemnasium/onddo/mumble_server-cookbook.svg?style=flat)](https://gemnasium.com/onddo/mumble_server-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/onddo/mumble_server-cookbook.svg?style=flat)](https://codeclimate.com/github/onddo/mumble_server-cookbook)
[![Build Status](http://img.shields.io/travis/onddo/mumble_server-cookbook/0.1.0.svg?style=flat)](https://travis-ci.org/onddo/mumble_server-cookbook)

Installs and configures a [Mumble](http://wiki.mumble.info/wiki/Main_Page) server (called Murmur).

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* Debian
* Fedora
* Ubuntu

Please, [let us know](https://github.com/onddo/mumble_server-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [runit](https://supermarket.getchef.com/cookbooks/runit)

## Required Applications

* Chef `>= 11`
* Ruby `>= 1.9.3`

Attributes
==========

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><code>node['mumble_server']['service_type']</code></td>
    <td>Mumble server service type. Possible values are: <code>'service'</code>, <code>'runit_service'</code>.</td>
    <td><code>'service'</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['service_timeout']</code></td>
    <td>Mumble server service timeout in seconds. Only for runit.</td>
    <td><code>60</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['config']</code></td>
    <td>Mumble server configuration Hash. <strong>There is no need to escape values.</strong> See the <a href="#server-configuration-example">example below</a>.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['verbose']</code></td>
    <td>Mumble server verbose mode. Only for runit.</td>
    <td><em>calculated</em></td>
  </tr>
</table>

## Platform Support Related Attributes

Some cookbook attributes are used internally to support the different platforms. Surely you want to change them if you want to support new platforms or want to improve the support of some platforms already supported.

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><code>node['mumble_server']['packages']</code></td>
    <td>Mumble server required packages as Array.</td>
    <td><code>['mumble-server']</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['service_runit_packages']</code></td>
    <td>Mumble server required packages for runit.</td>
    <td><code>['lsof']</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['service_name']</code></td>
    <td>Mumble server service name.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['service_supports']</code></td>
    <td>Mumble server service supported actions Hash.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['config_file']</code></td>
    <td>Mumble server configuration file path.</td>
    <td><code>'/etc/murmur/murmur.ini'</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['config_file_links']</code></td>
    <td>Mumble server file links to create pointing to the configuration file.</td>
    <td><code>['/etc/mumble-server.ini']</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['pid_file']</code></td>
    <td>Mumble server pidfile path.</td>
    <td><code>'/var/run/mumble-server/mumble-server.pid'</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['pid_file_links']</code></td>
    <td>Mumble server file links to create pointing to the pidfile.</td>
    <td><code>['/run/mumble-server/mumble-server.pid']</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['user']</code></td>
    <td>Mumble server system use.</td>
    <td><code>'mumble-server'</code></td>
  </tr>
  <tr>
    <td><code>node['mumble_server']['group']</code></td>
    <td>Mumble server system group.</td>
    <td><code>'mumble-server'</code></td>
  </tr>
</table>

Recipes
=======

## mumble_server::default

Installs and configures Mumble server.

Resources
=========

## mumble_server_supw[password]

Changes Mumur SuperUser password.

### mumble_server_supw[password] Actions

* `change` (default)

### mumble_server_supw[password] Parameters

<table>
  <tr>
    <th>Parameter</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>password</td>
    <td>SuperUser password.</td>
    <td><em>name</em></td>
  </tr>
</table>

Usage Examples
==============

## Including in a Cookbook Recipe

Running it from a recipe:

```ruby
include_recipe 'mumble_server'
```

Don't forget to include the `mumble_server` cookbook as a dependency in the metadata.

```ruby
# metadata.rb
[...]

depends 'mumble_server'
```

## Including in the Run List

Another alternative is to include the default recipe in your *Run List*.

```json
{
  "name": "mumble.onddo.com",
  [...]
  "run_list": [
    [...]
    "recipe[mumble_server]"
  ]
}
```

## Setting SuperUser Password

```ruby
include_recipe 'mumble_server'

# Set SuperUser password
mumble_server_supw 'PUzcoHohsDiFECHyX0PP'
```

## Server Configuration Example

This is the default configuration:

```ruby
# Path to database. If blank, will search for
# murmur.sqlite in default locations or create it if not found.
node.default['mumble_server']['config']['database'] =
  '/var/lib/mumble-server/mumble-server.sqlite'

# If you wish to use something other than SQLite, you'll need to set the name
# of the database above, and also uncomment the below.
# Sticking with SQLite is strongly recommended, as it's the most well tested
# and by far the fastest solution.
#
# node.default['mumble_server']['config']['dbDriver'] = ' 'QMYSQL''
# node.default['mumble_server']['config']['dbUsername'] = nil
# node.default['mumble_server']['config']['dbPassword'] = nil
# node.default['mumble_server']['config']['dbHost'] = nil
# node.default['mumble_server']['config']['dbPort'] = nil
# node.default['mumble_server']['config']['dbPrefix'] = 'murmur_'
# node.default['mumble_server']['config']['dbOpts'] = nil

# Murmur defaults to not using D-Bus. If you wish to use dbus, which is one of
# the RPC methods available in Murmur, please specify so here.
#
# node.default['mumble_server']['config']['dbus'] = 'system'

# Alternate D-Bus service name. Only use if you are running distinct
# murmurd processes connected to the same D-Bus daemon.
# node.default['mumble_server']['config']['dbusservice'] =
#   'net.sourceforge.mumble.murmur'

# If you want to use ZeroC Ice to communicate with Murmur, you need
# to specify the endpoint to use. Since there is no authentication
# with ICE, you should only use it if you trust all the users who have
# shell access to your machine.
# Please see the ICE documentation on how to specify endpoints.
node.default['mumble_server']['config']['ice'] = 'tcp -h 127.0.0.1 -p 6502'

# Ice primarily uses local sockets. This means anyone who has a
# user account on your machine can connect to the Ice services.
# You can set a plaintext "secret" on the Ice connection, and
# any script attempting to access must then have this secret
# (as context with name "secret").
# Access is split in read (look only) and write (modify)
# operations. Write access always includes read access,
# unless read is explicitly denied (see note below).
#
# Note that if this is uncommented and with empty content,
# access will be denied.
# node.default['mumble_server']['config']['icesecretread'] = nil
# node.default['mumble_server']['config']['icesecretwrite'] = nil

# How many login attempts do we tolerate from one IP
# inside a given timeframe before we ban the connection?
# Note that this is global (shared between all virtual servers), and that
# it counts both successfull and unsuccessfull connection attempts.
# Set either Attempts or Timeframe to 0 to disable.
# node.default['mumble_server']['config']['autobanAttempts '] = ' 10'
# node.default['mumble_server']['config']['autobanTimeframe '] = ' 120'
# node.default['mumble_server']['config']['autobanTime '] = ' 300'

# Specifies the file Murmur should log to. By default, Murmur
# logs to the file 'murmur.log'. If you leave this field blank
# on Unix-like systems, Murmur will force itself into foreground
# mode which logs to the console.
node.default['mumble_server']['config']['logfile'] =
  '/var/log/mumble-server/mumble-server.log'

# If set, Murmur will write its process ID to this file
# when running in daemon mode (when the -fg flag is not
# specified on the command line). Only available on
# Unix-like systems.
node.default['mumble_server']['config']['pidfile'] =
  '/var/run/mumble-server/mumble-server.pid'

# The below will be used as defaults for new configured servers.
# If you're just running one server (the default), it's easier to
# configure it here than through D-Bus or Ice.
#
# Welcome message sent to clients when they connect.
node.default['mumble_server']['config']['welcometext'] =
  '<br />Welcome to this server running <b>Murmur</b>.<br />'\
  'Enjoy your stay!<br />'

# Port to bind TCP and UDP sockets to.
node.default['mumble_server']['config']['port'] = 64_738

# Specific IP or hostname to bind to.
# If this is left blank (default), Murmur will bind to all available addresses.
# node.default['mumble_server']['config']['host'] = nil

# Password to join server.
node.default['mumble_server']['config']['serverpassword'] = nil

# Maximum bandwidth (in bits per second) clients are allowed
# to send speech at.
node.default['mumble_server']['config']['bandwidth'] = 72_000

# Maximum number of concurrent clients allowed.
node.default['mumble_server']['config']['users'] = 100

# Amount of users with Opus support needed to force Opus usage, in percent.
# node.default['mumble_server']['config']['0 '] =
#   ' Always enable Opus, 100 = enable Opus if it's supported by all clients.'
# node.default['mumble_server']['config']['opusthreshold'] = 100

# Maximum depth of channel nesting. Note that some databases like MySQL using
# InnoDB will fail when operating on deeply nested channels.
# node.default['mumble_server']['config']['channelnestinglimit'] = 10

# Regular expression used to validate channel names.
# (Note that you don't have to escape backslashes with \ )
# node.default['mumble_server']['config']['channelname'] =
#  '[ \-=\w\#\[\]\{\}\(\)\@\|]+'

# Regular expression used to validate user names.
# (Note that you don't have to escape backslashes with \ )
# node.default['mumble_server']['config']['username'] =
#  '[-=\w\[\]\{\}\(\)\@\|\.]+'

# Maximum length of text messages in characters. 0 for no limit.
# node.default['mumble_server']['config']['textmessagelength'] = 5_000

# Maximum length of text messages in characters, with image data. 0 for no
# limit.
# node.default['mumble_server']['config']['imagemessagelength'] = 131_072

# Allow clients to use HTML in messages, user comments and channel descriptions?
# node.default['mumble_server']['config']['allowhtml'] = 'true'

# Murmur retains the per-server log entries in an internal database which
# allows it to be accessed over D-Bus/ICE.
# How many days should such entries be kept?
# Set to 0 to keep forever, or -1 to disable logging to the DB.
# node.default['mumble_server']['config']['logdays'] = 31

# To enable public server registration, the serverpassword must be blank, and
# this must all be filled out.
# The password here is used to create a registry for the server name; subsequent
# updates will need the same password. Don't lose your password.
# The URL is your own website, and only set the registerHostname for static IP
# addresses.
# Only uncomment the 'registerName' parameter if you wish to give your "Root"
# channel a custom name.
#
# node.default['mumble_server']['config']['registerName'] = 'Mumble Server'
# node.default['mumble_server']['config']['registerPassword'] = 'secret'
# node.default['mumble_server']['config']['registerUrl'] =
#  'http://mumble.sourceforge.net/'
# node.default['mumble_server']['config']['registerHostname'] = nil

# If this option is enabled, the server will announce its presence via the
# bonjour service discovery protocol. To change the name announced by bonjour
# adjust the registerName variable.
# See http://developer.apple.com/networking/bonjour/index.html for more
# information about bonjour.
# node.default['mumble_server']['config']['bonjour'] = true

# If you have a proper SSL certificate, you can provide the filenames here.
# Otherwise, Murmur will create it's own certificate automatically.
# node.default['mumble_server']['config']['sslCert'] = nil
# node.default['mumble_server']['config']['sslKey'] = nil

# If Murmur is started as root, which user should it switch to?
# This option is ignored if Murmur isn't started with root privileges.
node.default['mumble_server']['config']['uname'] = node['mumble_server']['user']

# If this options is enabled, only clients which have a certificate are allowed
# to connect.
# node.default['mumble_server']['config']['certrequired'] = false

# If enabled, clients are sent information about the servers version and
# operating system.
# node.default['mumble_server']['config']['sendversion'] = true

# You can configure any of the configuration options for Ice here. We recommend
# leave the defaults as they are.
# Please note that this section has to be last in the configuration file.
#
node.default['mumble_server']['config']['Ice']['Warn.UnknownProperties'] = 1
node.default['mumble_server']['config']['Ice']['MessageSizeMax'] = 65_536

include_recipe 'mumble_server'
```

Testing
=======

See [TESTING.md](TESTING.md).

Contributing
============

Please do not hesitate to [open an issue](https://github.com/onddo/mumble_server-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](CONTRIBUTING.md).

TODO
====

See [TODO.md](TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Copyright:**       | Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
