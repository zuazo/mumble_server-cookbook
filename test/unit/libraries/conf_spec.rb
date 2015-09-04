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

require_relative '../spec_helper'
require 'conf'

describe MumbleServer::Conf do
  context '#key' do
    [false, nil, 5, 'String'].each do |k|
      it "returns string value for #{k.inspect}" do
        expect(MumbleServer::Conf.key(k)).to be_a(String)
      end
    end
  end # context #key

  context '#value' do
    {
      true => 'True',
      'super,secret' => '"super,secret"',
      '"""' => '"\""',
      '\\w*' => '\\\\w*'
    }.each do |orig, new|
      it "returns #{new.inspect} for #{orig.inspect}" do
        expect(MumbleServer::Conf.value(orig)).to eq(new)
      end
    end
  end # context #value

  context '#key_value' do
    before do
      allow(MumbleServer::Conf).to receive(:key).with('key')
        .and_return('key1')
      allow(MumbleServer::Conf).to receive(:value).with('value')
        .and_return('value1')
    end

    it 'returns key=value' do
      expect(MumbleServer::Conf.key_value('key', 'value'))
        .to eq('key1=value1')
    end
  end

  context '#sort' do
    it 'runs successfully without "Ice" section' do
      values = {
        'Fire' => 'value1',
        'Wind' => 'value2'
      }
      expect(MumbleServer::Conf.sort(values))
        .to eq(values)
    end

    it 'puts "Ice" section at the end' do
      values = {
        'Fire' => 'value1',
        'Ice' => 'value2',
        'Wind' => 'value3'
      }
      expect(MumbleServer::Conf.sort(values).keys[-1])
        .to eq('Ice')
    end
  end
end
