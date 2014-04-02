# rubocop:disable LineLength
# database to be used
node.default['openstack']['db']['service_type'] = 'mysql'

# process monitoring
default['openstack']['db']['service_processes'] = [
  { 'name' =>  'mysqld', 'shortname' =>  'mysqld' }
]

# avoid this error:
# WARNING Got mysql server has gone away: (2013, 'Lost connection to MySQL server during query')
# WARNING session.ping_listener Got mysql server has gone away: (2013, 'Lost connection to MySQL server during query')
default['mysql']['tunable']['wait_timeout'] = '4000'
