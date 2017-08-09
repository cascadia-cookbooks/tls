default['tls']['packages'] = 'openssl'

default['tls']['container'] = '/etc/ssl'
default['tls']['cert_path'] = "#{node['tls']['container']}/certs"
default['tls']['key_path']  = "#{node['tls']['container']}/private"

default['tls']['dhparams']['bits']  = 2048
default['tls']['dhparams']['files'] = %W(
    #{default['tls']['cert_path']}/dhparams.pem
)

# initialize empty array
default['tls']['certs'] = []
default['tls']['snakeoil']['certs'] = []
