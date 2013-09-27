name             'ktc-database'
maintainer       'KT Cloudware'
maintainer_email 'wil.reichert@kt.com'
license          'All rights reserved'
description      'Application / role cookbook for stackforge os-ops-database cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ centos ubuntu }.each do |os|
  supports os
end

depends "ktc-utils", "~> 0.3.1"
depends "openstack-common", "~> 0.4.3"
depends "openstack-ops-database", "~> 7.0.0"
depends "services", "~> 1.0.6"
depends "galera", "~> 0.4.1"
depends "simple_iptables", "~> 0.3.0"
