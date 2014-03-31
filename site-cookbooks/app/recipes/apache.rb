#
# Cookbook Name:: example
# Recipe:: apache
#
# Copyright (C) 2014 Jason Rikard
# 
# All rights reserved - Do Not Redistribute
#

#include_recipe "dotdeb::default"
#include_recipe "dotdeb::php54"
#include_recipe "php"

# apt_repository "dotdeb" do
#   uri "http://packages.dotdeb.org"
#   distribution "squeeze"
#   components ["all"]
#   key "http://www.dotdeb.org/dotdeb.gpg"
# end

#setup apache 
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_expires"

#include_recipe "apache2::mod_env"

remote_file "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb" do
  source 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb'
  mode '0644'
  action :create_if_missing
end

#include_recipe "apache2::mod_pagespeed"
dpkg_package 'mod_pagespeed' do
  source "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb"
  action :install
end

apache_module 'pagespeed' do
  conf true
end

# disable default site
apache_site '000-default' do
  enable false
end

web_app 'example' do
  server_name node['app']['fqdn']
  server_aliases ["www.#{node['app']['fqdn']}"]
  docroot node['app']['document_root']
  cookbook 'app'
  template 'apache2.conf.erb'
end


#Setup php 5.4
# apt_repository "dotdeb-php54" do
#   uri "http://packages.dotdeb.org"
#   distribution "squeeze-php54"
#   components ["all"]
#   key "http://www.dotdeb.org/dotdeb.gpg"
# end

include_recipe "apt"
include_recipe "php"

package 'php5' do
  action :install
  notifies :restart, 'service[apache2]'
end

# Install PHP5 packages
node['app']['php_packages'].each do |a_package|
  package a_package
end

package "apache2" do
  action :upgrade
end

package "php5" do
  action :upgrade
end



# create document root
directory node['app']['app_root'] do
  owner 'deploy'
  group 'deploy'
  action :create
  recursive true
end

directory node['app']['document_root'] do
  owner 'deploy'
  group 'deploy'
  action :create
  recursive true
end


# # write site
# cookbook_file '/srv/www/example/index.html' do
#   mode '0644'
# end

# # enable example
# apache_site "#{node['example']['config']}" do
#   enable true
# end



