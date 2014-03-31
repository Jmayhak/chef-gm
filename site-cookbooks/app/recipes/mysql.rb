#
# Cookbook Name:: app
# Recipe:: apache
#
# Copyright (C) 2014 Jason Rikard
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::client"
include_recipe 'mysql::server'
include_recipe "database::mysql"





# Load default database if database dump file existing and database is empty
# Users get tricky if they are different in the dump than configured in the attributes
if File.exist?("#{node['app']['db_dump']}")
    ruby_block "seed #{node['app']['name']} database" do
        block do
            print 'importing database from file'
            %x[mysql -u root -p#{node['mysql']['server_root_password']} < #{node['app']['db_dump']}]
        end
        not_if "mysql -uroot -p#{node['mysql']['server_root_password']} -e \"SHOW DATABASES LIKE '#{node['app']['database']['dbname']}'\" | grep #{node['app']['database']['dbname']}";
        action :create
    end
else
    # Create database if it doesn't exist

    mysql_connection_info = {
      :host => node['mysql']['address'],
      :username => 'root',
      :password => node['mysql']['server_root_password']
    }
    #Create database migration User
    mysql_database_user node['app']['database']['migration_user']['username'] do
      connection mysql_connection_info
      password node['app']['database']['migration_user']['password']
      database_name '*'
      host node['mysql']['address']
      action [:create, :grant]
    end

    #Create general app user
    mysql_database_user node['app']['database']['app_user']['username'] do
      connection mysql_connection_info
      password node['app']['database']['app_user']['password']
      database_name '*'
      host node['mysql']['address']
      action [:create, :grant]
    end

    ruby_block "create_#{node['app']['database']['dbname']}_db" do
        block do
            print 'Creating database'
            %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "CREATE DATABASE #{node['app']['database']['dbname']};"]
        end 
        not_if "mysql -uroot -p#{node['mysql']['server_root_password']} -e \"SHOW DATABASES LIKE '#{node['app']['database']['dbname']}'\" | grep #{node['app']['database']['dbname']}";
        action :create
    end
end


package "mysql-server" do
  action :upgrade
end

#Workaround to fix issue in mysql cookbook preventing autostart on reboot.
# Commit notes https://github.com/opscode-cookbooks/mysql/commit/3a1d9f9b65c1edaeaadc63a41caa2a8c972715a5
# hopefully this is a temporary requirement.
ruby_block "ensure mysql server starts on reboot" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/init/mysql.conf")
    fe.search_file_replace_line(/#start on runlevel \[2345\]/, 'start on runlevel [2345]')
    Chef::Log.warn("Edited /etc/init/mysql.conf to re-enable start on reboot.") if fe.write_file
  end
end
