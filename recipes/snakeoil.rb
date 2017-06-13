#
# Cookbook Name:: cop_tls
# Recipe:: snakeoil
#

include_recipe 'cop_tls::common'

certs = node['tls']['snakeoil']['certs']

unless certs.nil? || certs.nil?
    certs.each do |file,data|
        cert = "#{node['tls']['cert_path']}/#{file}.crt"
        key  = "#{node['tls']['key_path']}/#{file}.key"
        bits = data['bits'] || '2048'
        days = data['days'] || '365'

        file "#{file} TLS config" do
            path    "/tmp/tls.conf"
            content "
[req]
x509_extensions = v3_req
distinguished_name = dn
default_bits = 2048
prompt = no
default_md = sha256

[dn]
C = #{data['country']}
ST = #{data['state']}
L = #{data['city']}
O = #{data['company']}
OU = #{data['section']}
CN = #{data['hostname']}

[v3_req]
authorityKeyIdentifier= keyid,issuer
basicConstraints= CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = #{data['hostname']}"
        end

        execute "generating #{file}" do
            command "
/usr/bin/openssl req -x509 \
    -sha256                \
    -newkey rsa:#{bits}    \
    -keyout #{key}         \
    -nodes                 \
    -days #{days}          \
    -config /tmp/tls.conf  \
    -out #{cert}"
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
