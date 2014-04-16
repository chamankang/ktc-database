#
# Cookbook Name:: ktc-database
# Recipe:: default
#
# Copyright 2013, KT Cloudware
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'services'
include_recipe 'ktc-utils'

iface = KTC::Network.if_lookup 'management'
ip = KTC::Network.address 'management'

Services::Connection.new run_context: run_context
member = Services::Member.new node['fqdn'],
                              service: 'mysql',
                              port: 3306,
                              proto: 'tcp',
                              ip: ip
member.save

node.default['openstack']['db']['bind_interface'] = iface

include_recipe 'openstack-common'
include_recipe 'openstack-common::logging'

if node['ha_disabled']
  include_recipe 'openstack-ops-database::server'
else
  include_recipe 'ktc-openstack-ha::mysql'
  include_recipe 'galera::server'
end

%w(
  compute
  dashboard
  identity
  image
  metering
  network
  volume
).each do |s|
  node.default['openstack']['db'][s]['host'] = ip
end

include_recipe 'openstack-ops-database::openstack-db'

# UCLOUDNG-1185 : Test & validate vms-cluster (HA) setup
# Rewind package resources, which install mysql-client and its dependencies,
# to have options that makes mysql-client and its dependencies to use my.cnf
# created by galera::server recipe, not to ask whether to use it or not.
unless node['ha_disabled']
  chef_gem 'chef-rewind'
  require 'chef/rewind'

  options = "-o Dpkg::Options::='--force-confold'"
  options += " -o Dpkg::Options::='--force-confdef'"
  node['mysql']['client']['packages'].each do |pkg|
    rewind package: pkg do
      options options
    end
  end
end

# process monitoring and sensu-check config
processes = node['openstack']['db']['service_processes']

processes.each do |process|
  sensu_check "check_process_#{process['name']}" do
    command "check-procs.rb -c 10 -w 10 -C 1 -W 1 -p #{process['name']}"
    handlers ['default']
    standalone true
    interval 30
  end
end

ktc_collectd_processes 'database-processes' do
  input processes
end
