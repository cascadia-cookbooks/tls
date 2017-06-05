#
# Cookbook Name:: cop_tls
# Recipe:: dhparams
#

include_recipe 'cop_tls::common'

node['tls']['dhparams']['files'].each do |file|
    execute "generating #{file}" do
        command "openssl dhparam -out #{file} #{node['tls']['dhparams']['bits']}"
        creates file
        # NOTE: 5min timeout should be enough
        timeout 300
    end
end
