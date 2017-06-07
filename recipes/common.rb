#
# Cookbook Name:: cop_tls
# Recipe:: common
#

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
