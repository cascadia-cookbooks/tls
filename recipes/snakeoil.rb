#
# Cookbook Name:: cop_tls
# Recipe:: snakeoil
#

include_recipe 'cop_tls::common'

if node['tls']['snakeoil']['certs']
    node['tls']['snakeoil']['certs'].each do |file,data|
        cert = "#{node['tls']['cert_path']}/#{file}.crt"
        key  = "#{node['tls']['key_path']}/#{file}.key"
        bits = data['bits'] || '2048'
        days = data['days'] || '365'

        execute "generating #{file}" do
            command "
    answers() {
            echo #{data['country']}
            echo #{data['state']}
            echo #{data['city']}
            echo #{data['company']}
            echo #{data['section']}
            echo #{data['hostname']}
            echo #{data['contact']}
    }

    answers | /usr/bin/openssl req -newkey rsa:#{bits} -keyout #{key} -nodes -x509 -days #{days} -out #{cert}"
            creates cert
        end

        files = [
            cert,
            key
        ]

        files.each do |f|
            file f do
                owner 'root'
                group 'root'
                mode  0700
            end
        end
    end
end
