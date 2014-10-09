# encoding: UTF-8
#
# Cookbook Name:: mumble_server
# Recipe:: default
#
# Copyright 2014, Onddo Labs, SL.
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

service_name =
  node['mumble_server']['service_type'] +
  "[#{node['mumble_server']['service_name']}]"

# Bugfix: relocation error: proftpd: symbol SSLeay_version, version
# OPENSSL_1.0.1 not defined in file libcrypto.so.10 with link time reference
if platform?('fedora')
  package 'openssl' do
    action :upgrade
    not_if 'file /usr/lib*/libcrypto.so.[0-9]* '\
           "| awk '$2 == \"ELF\" {print $1}' | cut -d: -f1 "\
           "| xargs readelf -s | grep -Fwq 'OPENSSL_'"
  end
end

node['mumble_server']['packages'].each do |pkg|
  package pkg
end

path_dir = ::File.dirname(node['mumble_server']['config_file'])
directory path_dir do
  recursive true
  owner 'root'
  group 'root'
  mode '00755'
  not_if { ::File.exist?(path_dir) }
end

template node['mumble_server']['config_file'] do
  source 'config.ini.erb'
  owner 'root'
  group node['mumble_server']['group']
  mode '00640'
  variables values: node['mumble_server']['config']
  notifies :restart, service_name
end

file node['mumble_server']['pid_file'] do
  owner 'root'
  group node['mumble_server']['group']
  mode '00660'
  notifies :restart, service_name
end

node['mumble_server']['config_file_links'].each do |config_link_to|
  link config_link_to do
    to node['mumble_server']['config_file']
    not_if do
      ::File.realdirpath(config_link_to) ==
        ::File.realdirpath(node['mumble_server']['config_file'])
    end
    notifies :restart, service_name
  end
end

node['mumble_server']['pid_file_links'].each do |pid_link_to|
  link pid_link_to do
    to node['mumble_server']['pid_file']
    only_if { ::File.exist?(::File.dirname(pid_link_to)) }
    not_if do
      ::File.realdirpath(pid_link_to) ==
        ::File.realdirpath(node['mumble_server']['pid_file'])
    end
    notifies :restart, service_name
  end
end

case node['mumble_server']['service_type']
when 'runit_service'
  service node['mumble_server']['service_name'] do
    supports node['mumble_server']['service_supports']
    action [:stop, :disable]
  end

  node['mumble_server']['service_runit_packages'].each do |pkg|
    package pkg
  end

  include_recipe 'runit'

  runit_service node['mumble_server']['service_name'] do
    cookbook 'mumble_server'
    check true
    run_template_name 'mumble_server'
    log_template_name 'mumble_server'
    check_script_template_name 'mumble_server'
    restart_on_update true
    sv_timeout node['mumble_server']['service_timeout']
    options(
      user: node['mumble_server']['user'],
      group: node['mumble_server']['group'],
      config_file: node['mumble_server']['config_file'],
      verbose: node['mumble_server']['verbose'],
      port: node['mumble_server']['config']['port']
    )
    action [:enable, :start]
  end
else
  service node['mumble_server']['service_name'] do
    supports node['mumble_server']['service_supports']
    action [:enable, :start]
  end
end
