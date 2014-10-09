# encoding: UTF-8

# Path to database. If blank, will search for
# murmur.sqlite in default locations or create it if not found.
default['mumble_server']['config']['database'] =
  '/var/lib/mumble-server/mumble-server.sqlite'

# If you wish to use something other than SQLite, you'll need to set the name
# of the database above, and also uncomment the below.
# Sticking with SQLite is strongly recommended, as it's the most well tested
# and by far the fastest solution.
#
# default['mumble_server']['config']['dbDriver'] = ' 'QMYSQL''
# default['mumble_server']['config']['dbUsername'] = nil
# default['mumble_server']['config']['dbPassword'] = nil
# default['mumble_server']['config']['dbHost'] = nil
# default['mumble_server']['config']['dbPort'] = nil
# default['mumble_server']['config']['dbPrefix'] = 'murmur_'
# default['mumble_server']['config']['dbOpts'] = nil

# Murmur defaults to not using D-Bus. If you wish to use dbus, which is one of
# the RPC methods available in Murmur, please specify so here.
#
# default['mumble_server']['config']['dbus'] = 'system'

# Alternate D-Bus service name. Only use if you are running distinct
# murmurd processes connected to the same D-Bus daemon.
# default['mumble_server']['config']['dbusservice'] =
#   'net.sourceforge.mumble.murmur'

# If you want to use ZeroC Ice to communicate with Murmur, you need
# to specify the endpoint to use. Since there is no authentication
# with ICE, you should only use it if you trust all the users who have
# shell access to your machine.
# Please see the ICE documentation on how to specify endpoints.
default['mumble_server']['config']['ice'] = 'tcp -h 127.0.0.1 -p 6502'

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
# default['mumble_server']['config']['icesecretread'] = nil
# default['mumble_server']['config']['icesecretwrite'] = nil

# How many login attempts do we tolerate from one IP
# inside a given timeframe before we ban the connection?
# Note that this is global (shared between all virtual servers), and that
# it counts both successfull and unsuccessfull connection attempts.
# Set either Attempts or Timeframe to 0 to disable.
# default['mumble_server']['config']['autobanAttempts '] = ' 10'
# default['mumble_server']['config']['autobanTimeframe '] = ' 120'
# default['mumble_server']['config']['autobanTime '] = ' 300'

# Specifies the file Murmur should log to. By default, Murmur
# logs to the file 'murmur.log'. If you leave this field blank
# on Unix-like systems, Murmur will force itself into foreground
# mode which logs to the console.
default['mumble_server']['config']['logfile'] =
  if node['mumble_server']['service_type'] == 'runit'
    ''
  else
    '/var/log/mumble-server/mumble-server.log'
  end

# If set, Murmur will write its process ID to this file
# when running in daemon mode (when the -fg flag is not
# specified on the command line). Only available on
# Unix-like systems.
default['mumble_server']['config']['pidfile'] =
  '/var/run/mumble-server/mumble-server.pid'

# The below will be used as defaults for new configured servers.
# If you're just running one server (the default), it's easier to
# configure it here than through D-Bus or Ice.
#
# Welcome message sent to clients when they connect.
default['mumble_server']['config']['welcometext'] =
  '<br />Welcome to this server running <b>Murmur</b>.<br />'\
  'Enjoy your stay!<br />'

# Port to bind TCP and UDP sockets to.
default['mumble_server']['config']['port'] = 64_738

# Specific IP or hostname to bind to.
# If this is left blank (default), Murmur will bind to all available addresses.
# default['mumble_server']['config']['host'] = nil

# Password to join server.
default['mumble_server']['config']['serverpassword'] = nil

# Maximum bandwidth (in bits per second) clients are allowed
# to send speech at.
default['mumble_server']['config']['bandwidth'] = 72_000

# Maximum number of concurrent clients allowed.
default['mumble_server']['config']['users'] = 100

# Amount of users with Opus support needed to force Opus usage, in percent.
# default['mumble_server']['config']['0 '] =
#   ' Always enable Opus, 100 = enable Opus if it's supported by all clients.'
# default['mumble_server']['config']['opusthreshold'] = 100

# Maximum depth of channel nesting. Note that some databases like MySQL using
# InnoDB will fail when operating on deeply nested channels.
# default['mumble_server']['config']['channelnestinglimit'] = 10

# Regular expression used to validate channel names.
# (Note that you don't have to escape backslashes with \ )
# default['mumble_server']['config']['channelname'] =
#  '[ \-=\w\#\[\]\{\}\(\)\@\|]+'

# Regular expression used to validate user names.
# (Note that you don't have to escape backslashes with \ )
# default['mumble_server']['config']['username'] =
#  '[-=\w\[\]\{\}\(\)\@\|\.]+'

# Maximum length of text messages in characters. 0 for no limit.
# default['mumble_server']['config']['textmessagelength'] = 5_000

# Maximum length of text messages in characters, with image data. 0 for no
# limit.
# default['mumble_server']['config']['imagemessagelength'] = 131_072

# Allow clients to use HTML in messages, user comments and channel descriptions?
# default['mumble_server']['config']['allowhtml'] = 'true'

# Murmur retains the per-server log entries in an internal database which
# allows it to be accessed over D-Bus/ICE.
# How many days should such entries be kept?
# Set to 0 to keep forever, or -1 to disable logging to the DB.
# default['mumble_server']['config']['logdays'] = 31

# To enable public server registration, the serverpassword must be blank, and
# this must all be filled out.
# The password here is used to create a registry for the server name; subsequent
# updates will need the same password. Don't lose your password.
# The URL is your own website, and only set the registerHostname for static IP
# addresses.
# Only uncomment the 'registerName' parameter if you wish to give your "Root"
# channel a custom name.
#
# default['mumble_server']['config']['registerName'] = 'Mumble Server'
# default['mumble_server']['config']['registerPassword'] = 'secret'
# default['mumble_server']['config']['registerUrl'] =
#  'http://mumble.sourceforge.net/'
# default['mumble_server']['config']['registerHostname'] = nil

# If this option is enabled, the server will announce its presence via the
# bonjour service discovery protocol. To change the name announced by bonjour
# adjust the registerName variable.
# See http://developer.apple.com/networking/bonjour/index.html for more
# information about bonjour.
# default['mumble_server']['config']['bonjour'] = true

# If you have a proper SSL certificate, you can provide the filenames here.
# Otherwise, Murmur will create it's own certificate automatically.
# default['mumble_server']['config']['sslCert'] = nil
# default['mumble_server']['config']['sslKey'] = nil

# If Murmur is started as root, which user should it switch to?
# This option is ignored if Murmur isn't started with root privileges.
default['mumble_server']['config']['uname'] = node['mumble_server']['user']

# If this options is enabled, only clients which have a certificate are allowed
# to connect.
# default['mumble_server']['config']['certrequired'] = false

# If enabled, clients are sent information about the servers version and
# operating system.
# default['mumble_server']['config']['sendversion'] = true

# You can configure any of the configuration options for Ice here. We recommend
# leave the defaults as they are.
# Please note that this section has to be last in the configuration file.
#
default['mumble_server']['config']['Ice']['Warn.UnknownProperties'] = 1
default['mumble_server']['config']['Ice']['MessageSizeMax'] = 65_536
