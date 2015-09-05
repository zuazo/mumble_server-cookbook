# encoding: UTF-8
#
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

require 'spec_helper'

describe process('runsvdir') do
  it { should be_running }
end

describe process('runsv mumble-server') do
  it { should be_running }
end

log_file =
  if ::File.exist?('/etc/service/mumble-server/log/main/current')
    '/etc/service/mumble-server/log/main/current'
  else
    '/etc/service/murmur-server/log/main/current'
  end

describe file(log_file) do
  its(:content) { should match /Murmur .* running on/ }
end
