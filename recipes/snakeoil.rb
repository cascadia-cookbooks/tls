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
[ req ]
prompt = no
default_bits = 2048
encrypt_key = no
default_md = sha256
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[ req_distinguished_name ]
C = #{data['country']}
ST = #{data['state']}
L = #{data['city']}
O = #{data['company']}
OU = #{data['section']}
CN = #{data['hostname']}

[ v3_ca ]
basicConstraints=CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alternate_names

[ alternate_names ]
DNS.1 = #{data['hostname']}"
        end

        execute "generating #{file}" do
            command "
/usr/bin/openssl req -x509 \
    -sha256                \
    -newkey rsa:#{bits}    \
    -keyout #{key}         \
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
