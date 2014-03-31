#
# Cookbook Name:: app
# Recipe:: default
#
# Copyright (C) 2014 Jason Rikard
# 
# All rights reserved - Do Not Redistribute
#


include_recipe "apt"
include_recipe "ntp"
include_recipe "openssh"
include_recipe "sudo"
include_recipe "app::packages"
include_recipe 'app::apache'
include_recipe 'app::mysql'
include_recipe "ufw"
include_recipe "fail2ban"

#for later
#if node.ssh.attribute?('password_authentication')
#end

#create and configure the single user
group node['server']['group']

user node['server']['user'] do
  supports :manage_home => true
  group node['server']['group']
  system false
  shell '/bin/bash'
  home "/home/#{node['server']['user']}"
  password '$1$ml.LUbgD$hPRLXa2lz.x0.LXVl3YiH1'
  action :create
end

directory "/home/deploy/.ssh/" do
  owner node['server']['user']
  action :create
  recursive true
end

file '/home/deploy/.ssh/authorized_keys' do
	action :delete
end

# create their ssh key
node['server']['authorized_keys'].each do |a_key|
	execute 'add authorized_keys' do
	  user 'deploy'
	  command "echo #{a_key} >> /home/deploy/.ssh/authorized_keys"
	end
end

include_recipe "app::bb_deploy_user"

#define helper aliases
magic_shell_alias node['app']['name'] do
  command "cd #{node['app']['app_root']}"
end

#todo make webserver agnostic
magic_shell_alias 'sites' do
  command "cd /etc/apache2/sites-available"
end


