# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

require 'spec_helper'

describe 'mumble_server::default' do
  let(:chef_runner) { ChefSpec::Runner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:node_set) { chef_runner.node.set }
  let(:node_automatic) { chef_runner.node.automatic }
  before do
    orig_file_exist = ::File.method(:exist?)
    allow(::File).to receive(:exist?) { |*args| orig_file_exist.call(*args) }
    orig_file_realdirpath = ::File.method(:realdirpath)
    allow(::File).to receive(:realdirpath) do
      |*args| orig_file_realdirpath.call(*args)
    end

    %w(
      /etc/murmur/murmur.ini
      /etc/mumble-server.ini
      /run/mumble-server/mumble-server.pid
      /var/run/mumble-server/mumble-server.pid
    ).each do |path|
      allow(::File).to receive(:realdirpath).with(path).and_return(path)
    end
    allow(::File).to receive(:exist?)
      .with('/run/mumble-server').and_return(true)
    stub_command(
      "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
      "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
    ).and_return(true)
  end

  it 'should not upgrade new OpenSSL versions' do
    expect(chef_run).to_not upgrade_package('openssl')
  end

  it 'should install mumble-server' do
    expect(chef_run).to install_package('mumble-server')
  end

  it 'should create configuration file directory' do
    allow(::File).to receive(:exist?).with('/etc/murmur').and_return(false)
    expect(chef_run).to create_directory('/etc/murmur')
      .with_recursive(true)
      .with_owner('root')
      .with_group('root')
      .with_mode('00755')
  end

  it 'should not create configuration file directory if already exists' do
    allow(::File).to receive(:exist?).with('/etc/murmur').and_return(true)
    expect(chef_run).to_not create_directory('/etc/murmur')
  end

  it 'should create configuration file' do
    expect(chef_run).to create_template('/etc/murmur/murmur.ini')
      .with_source('config.ini.erb')
      .with_owner('root')
      .with_group('mumble-server')
      .with_mode('00640')
  end

  it 'configuration file should notify mumble restart' do
    resource = chef_run.template('/etc/murmur/murmur.ini')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  it 'should create configuration file link in /etc/mumble-server.ini' do
    allow(::File).to receive(:realdirpath).with('/etc/mumble-server.ini')
      .and_return('/etc/mumble-server.ini')
    expect(chef_run).to create_link('/etc/mumble-server.ini')
      .with_to('/etc/murmur/murmur.ini')
  end

  it 'should not create configuration file link in the path is the same' do
    allow(::File).to receive(:realdirpath).with('/etc/mumble-server.ini')
      .and_return('/etc/murmur/murmur.ini')
    expect(chef_run).to_not create_link('/etc/mumble-server.ini')
  end

  it 'configuration file should notify mumble restart' do
    resource = chef_run.link('/etc/mumble-server.ini')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  it 'should create pidfile link to /run' do
    allow(::File).to receive(:exist?)
      .with('/run/mumble-server').and_return(true)
    allow(::File).to receive(:realdirpath)
      .with('/run/mumble-server/mumble-server.pid')
      .and_return('/run/mumble-server/mumble-server.pid')
    allow(::File).to receive(:realdirpath)
      .with('/var/run/mumble-server/mumble-server.pid')
      .and_return('/var/run/mumble-server/mumble-server.pid')
    expect(chef_run).to create_link('/run/mumble-server/mumble-server.pid')
      .with_to('/var/run/mumble-server/mumble-server.pid')
  end

  it 'should not create pidfile link if there is no /run' do
    allow(::File).to receive(:exist?)
      .with('/run/mumble-server').and_return(false)
    allow(::File).to receive(:realdirpath)
      .with('/run/mumble-server/mumble-server.pid')
      .and_return('/run/mumble-server/mumble-server.pid')
    allow(::File).to receive(:realdirpath)
      .with('/var/run/mumble-server/mumble-server.pid')
      .and_return('/var/run/mumble-server/mumble-server.pid')
    expect(chef_run).to_not create_link('/run/mumble-server/mumble-server.pid')
  end

  it 'should not create pidfile link if the path is the same' do
    allow(::File).to receive(:exist?)
      .with('/run/mumble-server').and_return(true)
    allow(::File).to receive(:realdirpath)
      .with('/run/mumble-server/mumble-server.pid')
      .and_return('/var/run/mumble-server/mumble-server.pid')
    allow(::File).to receive(:realdirpath)
      .with('/var/run/mumble-server/mumble-server.pid')
      .and_return('/var/run/mumble-server/mumble-server.pid')
    expect(chef_run).to_not create_link('/run/mumble-server/mumble-server.pid')
  end

  it 'pidfile link should notify mumble restart' do
    resource = chef_run.link('/run/mumble-server/mumble-server.pid')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  {
    'mumble-server' => %w(debian ubuntu),
    'murmur' => %w(centos redhat fedora amazon scientific)
  }.each do |service_name, platforms|
    platforms.each do |platform|
      context "on #{platform.capitalize}" do
        before do
          node_automatic['platform'] = platform
          node_automatic['platform_version'] = '7.0'
        end

        it "should enable #{service_name} service" do
          expect(chef_run).to enable_service(service_name)
        end

        it "should set #{service_name} service supports" do
          status = %w(centos redhat fedora amazon scientific).include?(platform)
          expect(chef_run).to enable_service(service_name)
            .with_supports(Mash.new(
              restart: true, reload: false, status: status
            ))
        end

        it "should start #{service_name} service" do
          expect(chef_run).to start_service(service_name)
        end
      end # context on #{platform}
    end # platforms each
  end # service, platforms each

  context 'on Fedora (OpenSSL upgrade)' do
    before do
      node_automatic['platform'] = 'fedora'
      node_automatic['platform_version'] = '19.0'
    end

    it 'should upgrade old OpenSSL versions' do
      stub_command(
        "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
        "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
      ).and_return(false)
      expect(chef_run).to upgrade_package('openssl')
    end

    it 'should not upgrade new OpenSSL versions' do
      stub_command(
        "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
        "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
      ).and_return(true)
      expect(chef_run).to_not upgrade_package('openssl')
    end

  end # context on Fedora

end
