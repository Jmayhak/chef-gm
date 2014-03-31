#There are many attributes not listed here.  Check the corresponding cookbook's github repo for details.

#BitBucket
#Provide user info for someone with access to the repo.
#user name is not your email address
default['bitbucket_user'] = ''
default['bitbucket_password'] = ''
#Account name is who owns the repository. It's either your username or the team name.
default['bitbucket_account_name'] = ''
default['bitbucket_repo_name'] = ''

#App
default['app']['hostname'] = 'example'
default['app']['fqdn'] = 'example.dev'
default['app']['name'] = 'example'
default['app']['config'] = 'example.conf'
default['app']['app_root'] = '/srv/www/example'
default['app']['document_root'] = "#{node['app']['app_root']}/current/httpdocs"
default['app']['environment'] = 'development'

#App Database
default['app']['database']['prefix'] = 'example'
default['app']['database']['dbname'] = "#{node['app']['database']['prefix']}_#{node['app']['name']}"
default['app']['database']['migration_user']['username'] = 'migrator'
default['app']['database']['migration_user']['password'] = 'migrator'
default['app']['database']['app_user']['username'] = 'admin'
default['app']['database']['app_user']['password'] = 'admin'

#Server Users
default['server']['user'] = 'deploy'
default['server']['group'] = 'deploy'
default['server']['authorized_keys'] = ['']
default['authorization']['sudo']['users'] = [default['server']['user']]

#OpenSSH
default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'
#default['openssh']['server']['port'] = '3468'

#Firewall
default['firewall']['rules'] = [
	{ 'http' => { 'port' => '80' } }, 
	{ 'http' => { 'port' => '443' } }]

#Apache
default['apache']['contact'] = 'admin@example.com'

#PHP
default['php']['conf_dir'] = '/etc/php5/apache2'
default['php']['ini']['template'] = 'php.ini.erb'
default['php']['ini']['cookbook'] = 'app'
default['php']['display_errors'] = 'Off'

#XDebug
default['php']['xdebug']['enable'] = false
default['php']['xdebug']['zend_extension'] = '/usr/lib/php5/20090626/xdebug.so'
default['php']['xdebug']['remote_enable'] = '1'
default['php']['xdebug']['remote_connect_back'] = '1'
default['php']['xdebug']['remote_host'] = '172.22.22.72'
default['php']['xdebug']['remote_port'] = '9000'
default['php']['xdebug']['remote_handler'] = 'dbgp'
default['php']['xdebug']['profiler_enable'] = '0'
default['php']['xdebug']['profiler_enable_trigger'] = 'true'
default['php']['xdebug']['profiler_output_dir'] = '/var/tmp'
default['php']['xdebug']['profiler_output_name'] = 'cachegrind.out.%R.%t'


#MySQL
default['mysql']['port'] = 3306
default['mysql']['address'] = '127.0.0.1'
default['mysql']['remove_test_database'] = 'yes'
#default['mysql']['server_root_password'] = 'changeme'

#the following should be refactored
default['apache']['env_vars'] = {}

#NTP
#these defaults were found at http://www.pool.ntp.org/zone/north-america
default['ntp']['servers'] = ['0.north-america.pool.ntp.org', '1.north-america.pool.ntp.org', '2.north-america.pool.ntp.org', '3.north-america.pool.ntp.org']