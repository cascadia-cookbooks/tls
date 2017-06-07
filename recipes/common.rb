#
# Cookbook Name:: cop_tls
# Recipe:: common
#

package node['tls']['packages'] do
    action :install
end

dirs = [
    node['tls']['container'],
    node['tls']['cert_path'],
    node['tls']['key_path']
]

dirs.each do |dir|
    directory dir do
        owner  'root'
        group  'root'
        mode   0755
        action :create
    end
end
