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

describe 'mumble_server_supw resource' do
  let(:chef_runner) { ChefSpec::Runner.new(step_into: %w(mumble_server_supw)) }
  let(:chef_run) { chef_runner.converge('mumble_server_test') }
  let(:murmurd_cmd) { "murmurd -ini '/etc/murmur/murmur.ini'" }
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

  it 'should run murmurd -supw command with password hidden' do
    expect(chef_run).to run_execute("#{murmurd_cmd} -supw '****'")
  end

  it 'should run the murmurd -supw command with the password' do
    expect(chef_run).to run_execute("#{murmurd_cmd} -supw '****'")
      .with_command("#{murmurd_cmd} -supw 'p4ssw0rd'")
  end

end # describe mumble_server_supw resource
