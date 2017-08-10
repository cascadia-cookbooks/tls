#
# Cookbook Name:: cop_tls
# Recipe:: install_certs
#

include_recipe 'cop_tls::common'

unless node['tls']['certs'].nil?
    # NOTE: only merge when there are preexisting certs to be installed
    #       this should prevent certs being loaded and installed in development
    sensitive_info = begin
                         data_bag_item('tls', node.chef_environment)['certs']
                     rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                         # NOTE: setting to nil will skip the condition below
                         nil
                     end

    # NOTE: merge sensitive values with certs attribute tree
    if sensitive_info
        node.default['tls']['certs'] = node['tls']['certs'].merge(sensitive_info)
    end

    node['tls']['certs'].each do |file,data|
        if data['cert']
            file "#{node['tls']['cert_path']}/#{file}.crt" do
                content data['cert']
                mode 0644
            end
        end

        if data['key']
            file "#{node['tls']['key_path']}/#{file}.key" do
                content data['key']
                mode 0600
            end
        end
    end
end
