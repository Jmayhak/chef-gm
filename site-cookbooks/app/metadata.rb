name             'app'
maintainer       'Jason Rikard'
maintainer_email 'jsnrkd@gmail.com'
license          'All rights reserved'
description      'Installs/Configures app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt', '~> 2.3.0'
depends 'ntp', '~> 1.6.2'
depends 'sudo', '~> 2.5.0'
depends 'openssh', '~> 1.3.0'
depends 'ufw', '~> 0.7.0'
depends 'apache2', '~> 1.9.0'
depends 'mysql', '~> 4.1.2'
depends 'database', '~> 1.6.0'
depends 'php', '~> 1.4.0'
depends 'fail2ban', '~> 2.1.0'
depends 'magic_shell', '~> 1.0.0'