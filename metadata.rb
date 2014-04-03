name             'ktc-database'
maintainer       'KT Cloudware'
maintainer_email 'wil.reichert@kt.com'
license          'All rights reserved'
description      'Application cookbook for stackforge os-ops-database cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.10'

%w(centos ubuntu).each do |os|
  supports os
end

depends 'ktc-utils', '> 0.3.1'
depends 'openstack-common', '~> 0.4.3'
depends 'openstack-ops-database', '~> 7.0.0'
depends 'services', '> 1.0.6'
depends 'galera'
depends 'simple_iptables'
depends 'ktc-openstack-ha'
depends 'ktc-monitor'
