# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
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

require_relative '../spec_helper'

describe 'mumble_server::default' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:node_set) { chef_runner.node.set }
  let(:node_automatic) { chef_runner.node.automatic }
  before do
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:realdirpath).and_call_original

    %w(
      /etc/murmur/murmur.ini
      /etc/mumble-server.ini
      /run/mumble-server/mumble-server.pid
      /var/run/mumble-server/mumble-server.pid
    ).each do |path|
      allow(::File).to receive(:realdirpath).with(path).and_return(path)
    end
    allow(::File).to receive(:exist?).with('/run/mumble-server')
      .and_return(true)
    stub_command(
      "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
      "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
    ).and_return(true)
  end

  it 'does not upgrade new OpenSSL versions' do
    expect(chef_run).to_not upgrade_package('openssl')
  end

  it 'installs mumble-server' do
    expect(chef_run).to install_package('mumble-server')
  end

  it 'creates configuration file directory' do
    allow(::File).to receive(:exist?).with('/etc/murmur').and_return(false)
    expect(chef_run).to create_directory('/etc/murmur')
      .with_recursive(true)
      .with_owner('root')
      .with_group('root')
      .with_mode('00755')
  end

  it 'does not create configuration file directory if already exists' do
    allow(::File).to receive(:exist?).with('/etc/murmur').and_return(true)
    expect(chef_run).to_not create_directory('/etc/murmur')
  end

  it 'creates configuration file' do
    expect(chef_run).to create_template('/etc/murmur/murmur.ini')
      .with_source('config.ini.erb')
      .with_owner('root')
      .with_group('mumble-server')
      .with_mode('00640')
  end

  it 'configuration file notifies mumble restart' do
    resource = chef_run.template('/etc/murmur/murmur.ini')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  it 'creates configuration file link in /etc/mumble-server.ini' do
    allow(::File).to receive(:realdirpath).with('/etc/mumble-server.ini')
      .and_return('/etc/mumble-server.ini')
    expect(chef_run).to create_link('/etc/mumble-server.ini')
      .with_to('/etc/murmur/murmur.ini')
  end

  it 'does not create configuration file link in the path is the same' do
    allow(::File).to receive(:realdirpath).with('/etc/mumble-server.ini')
      .and_return('/etc/murmur/murmur.ini')
    expect(chef_run).to_not create_link('/etc/mumble-server.ini')
  end

  it 'configuration file notifies mumble restart' do
    resource = chef_run.link('/etc/mumble-server.ini')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  it 'creates pidfile link to /run' do
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

  it 'does not create pidfile link if there is no /run' do
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

  it 'does not create pidfile link if the path is the same' do
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

  it 'pidfile link notifies mumble restart' do
    resource = chef_run.link('/run/mumble-server/mumble-server.pid')
    expect(resource).to notify('service[mumble-server]').to(:restart).delayed
  end

  {
    'mumble-server' => %w(debian@7.0 ubuntu@12.04),
    'murmur' => %w(centos@5.10 redhat@5.10 fedora@20 amazon@2014.03)
  }.each do |service_name, platforms|
    platforms.each do |platform_info|
      platform, version = platform_info.split('@', 2)
      context "on #{platform.capitalize}" do
        let(:chef_runner) do
          ChefSpec::SoloRunner.new(platform: platform, version: version)
        end

        it "enables #{service_name} service" do
          expect(chef_run).to enable_service(service_name)
        end

        it "sets #{service_name} service supports" do
          status = %w(centos redhat fedora amazon scientific).include?(platform)
          expect(chef_run).to enable_service(service_name).with_supports(
            Mash.new(restart: true, reload: false, status: status)
          )
        end

        it "starts #{service_name} service" do
          expect(chef_run).to start_service(service_name)
        end
      end # context on #{platform}
    end # platforms each
  end # service, platforms each

  context 'on Fedora (OpenSSL upgrade)' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'fedora', version: '20')
    end

    it 'upgrades old OpenSSL versions' do
      stub_command(
        "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
        "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
      ).and_return(false)
      expect(chef_run).to upgrade_package('openssl')
    end

    it 'does not upgrade new OpenSSL versions' do
      stub_command(
        "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
        "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
      ).and_return(true)
      expect(chef_run).to_not upgrade_package('openssl')
    end
  end # context on Fedora

  context 'with runit' do
    before do
      node_set['mumble_server']['service_type'] = 'runit_service'
    end

    it 'does not enable system service' do
      expect(chef_run).to_not enable_service('mumble-server')
    end

    it 'does not start system service' do
      expect(chef_run).to_not start_service('mumble-server')
    end

    # expected "service[mumble-server]" actions [] to include :stop ???
    # xit 'stops system service' do
    #   expect(chef_run).to stop_service('mumble-server')
    # end

    # expected "service[mumble-server]" actions [] to include :disable ???
    # xit 'disables system service' do
    #   expect(chef_run).to disable_service('mumble-server')
    # end

    it 'installs lsof, required for runit check' do
      expect(chef_run).to install_package('lsof')
    end

    it 'enables runit service' do
      expect(chef_run).to enable_runit_service('mumble-server')
    end

    it 'starts runit service' do
      expect(chef_run).to start_runit_service('mumble-server')
    end

    it 'configures runit service correctly' do
      expect(chef_run).to enable_runit_service('mumble-server')
        .with_cookbook('mumble_server')
        .with_check(true)
        .with_run_template_name('mumble_server')
        .with_log_template_name('mumble_server')
        .with_check_script_template_name('mumble_server')
        .with_restart_on_update(true)
        .with_sv_timeout(60)
    end

    it 'configuration file notifies mumble restart' do
      resource = chef_run.template('/etc/murmur/murmur.ini')
      expect(resource).to notify('runit_service[mumble-server]').to(:restart)
        .delayed
    end

    it 'pidfile link notifies mumble restart' do
      resource = chef_run.link('/run/mumble-server/mumble-server.pid')
      expect(resource).to notify('runit_service[mumble-server]').to(:restart)
        .delayed
    end
  end # context with runit
end
