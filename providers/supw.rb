# encoding: UTF-8
#
# Cookbook Name:: mumble_server
# Provider:: supw
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

def whyrun_supported?
  true
end

def password
  new_resource.password.delete("'")
end

action :change do
  murmurd = "murmurd -ini '#{node['mumble_server']['config_file']}'"
  converge_by("Change #{new_resource}") do
    execute "#{murmurd} -supw '****'" do
      command "#{murmurd} -supw '#{password}'"
    end
  end
end
