# encoding: UTF-8

def whyrun_supported?
  true
end

def password
  new_resource.password.gsub("'", '')
end

action :change do
  murmurd = "murmurd -ini '#{node['mumble_server']['config_file']}'"
  converge_by("Change #{new_resource}") do
    execute "#{murmurd} -supw '****'" do
      command "#{murmurd} -supw '#{password}'"
    end
  end
end
