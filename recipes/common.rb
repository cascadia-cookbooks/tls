#
# Cookbook Name:: cop_tls
# Recipe:: common
#

directory node['tls']['container'] do
    owner  'root'
    group  'root'
    mode   0755
    action :create
end

dirs = %w(
    certs
    private
)

dirs.each do |dir|
    directory "#{node['tls']['container']}/#{dir}" do
        owner  'root'
        group  'root'
        mode   0755
        action :create
    end
end
