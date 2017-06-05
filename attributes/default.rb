default['tls']['container'] = '/etc/ssl'

default['tls']['dhparams']['bits']  = 2048
default['tls']['dhparams']['files'] = %w(
    /etc/ssl/certs/dhparams.pem
)
