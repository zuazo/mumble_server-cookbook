# encoding: UTF-8
#
# Cookbook Name:: mumble_server
# Library:: conf
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

module MumbleServer
  # Method helpers to be used from configuration templates
  module Conf
    def self.key(k)
      k.to_s
    end

    def self.value_to_s(v)
      # * Use True and False as booleans
      case v
      when TrueClass, FalseClass
        v.to_s.capitalize
      else
        v.to_s
      end
    end

    # * Make sure to escape special characters like '\' or '"' correctly
    def self.value_escape(v)
      # NOT regex = \w* BUT regex = \\w*
      r = v.gsub(/([\\"])/) { "\\#{Regexp.last_match(0)}" }
      # NOT variable = """ BUT variable = "\""
      r = "\"#{r[2..-3]}\"" if v[0] == '"' && v[-1] == '"'
      r
    end

    # * Make sure to quote the value when using commas in strings or passwords.
    def self.value_quote(v)
      # NOT variable = super,secret BUT variable = "super,secret"
      v.include?(',') && v[0] != '"' && v[-1] != '"' ? "\"#{v}\"" : v
    end

    def self.value(v)
      r = value_to_s(v)
      r = value_escape(r)
      value_quote(r)
    end

    def self.key_value(k, v)
      "#{key(k)}=#{value(v)}"
    end

    def self.sort(values)
      # Ice section has to be last in the configuration file:
      values = values.to_hash
      ice = values.delete('Ice')
      values['Ice'] = ice
      values
    end
  end
end
