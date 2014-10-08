# encoding: UTF-8

default['mumble_server']['packages'] = %w(mumble-server)
default['mumble_server']['service'] =
  case node['platform']
  when 'centos', 'redhat', 'fedora', 'amazon', 'scientific'
    'murmur'
  else
    'mumble-server'
  end
default['mumble_server']['config_file'] = '/etc/murmur/murmur.ini'
default['mumble_server']['pid_file'] =
  '/var/run/mumble-server/mumble-server.pid'
default['mumble_server']['user'] = 'mumble-server'
default['mumble_server']['group'] = node['mumble_server']['user']
default['mumble_server']['service_supports'] =
  case node['platform']
  when 'centos', 'redhat', 'fedora', 'amazon', 'scientific'
    Mash.new(restart: true, reload: false, status: true)
  else
    Mash.new(restart: true, reload: false, status: false)
  end
