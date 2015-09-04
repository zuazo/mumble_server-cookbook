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

require 'spec_helper'

describe file('/etc/mumble-server.ini') do
  it { should be_linked_to '/etc/murmur/murmur.ini' }
end

describe file('/etc/murmur/murmur.ini') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'mumble-server' }
  it { should be_readable.by_user('mumble-server') }
  it { should_not be_writable.by_user('mumble-server') }
end

describe file('/var/lib/mumble-server/mumble-server.sqlite') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'mumble-server' }
  it { should be_grouped_into 'mumble-server' }
  it { should be_readable.by_user('mumble-server') }
  it { should be_writable.by_user('mumble-server') }
end

describe file('/var/run/mumble-server/mumble-server.pid') do
  it { should be_file }
  it { should be_mode 660 }
  it { should be_owned_by 'mumble-server' }
  it { should be_grouped_into 'mumble-server' }
  it { should be_readable.by_user('mumble-server') }
  it { should be_writable.by_user('mumble-server') }
end

describe file('/var/log/mumble-server/mumble-server.log') do
  it { should be_file }
  it { should be_mode 660 }
  it { should be_owned_by 'mumble-server' }
  it { should be_grouped_into 'mumble-server' }
  it { should be_readable.by_user('mumble-server') }
  it { should be_writable.by_user('mumble-server') }
end
