# tls

A collection of common cryptographic recipes.

## Major Attributes
* `default['tls']['dhparams']['files'] = []` Needs to be an hash or array of
  file paths. By default this is `/etc/ssl/certs/dhparams.pem`
* `default['tls']['snakeoil']['certs'] = []` Needs to be an hash or array of
  *named* dictionaries. By default this is empty. You need to create these
attributes in a role or environment file.

## Minor Attributes
* `default['tls']['dhparams']['bits'] = N` Needs to be an integer. This changes
  the bit number used in generation. Defaults to `2048`.
* `default['tls']['snakeoil']['certs'][...]['bits'] = []` Needs to be an
  integer. This changes the bit number used in generation. Defaults to `2048`.
* `default['tls']['snakeoil']['certs'][...]['days'] = []` Needs to be an
  integer. This changes the expiration length, in days, of a certificate. Defaults to
`365` days.

## Usage
The `cop_tls` default recipe is blank on purpose. Add either `dhparams` or
`snakeoil` recipes into the run_list to install either component.

The example below will create a wildcard certificate called `_.localhost.com.crt` in
`/etc/ssl/certs` and its key, `_.localhost.com.key`, in `/etc/ssl/private`.

```ruby
name 'certs'
description 'installs and configures a snakeoil cert with matching dhparams'

override_attributes(
    ...
    'tls' => {
        'dhparams' => {
            'files' => %w{
                /etc/ssl/certs/dhparams.pem
            }
        },
        'snakeoil' => {
            'certs' => {
                '_.localhost.com' => {
                    'country'  => 'US',
                    'state'    => 'OR',
                    'city'     => 'PDX',
                    'company'  => 'Copious',
                    'section'  => 'Sysadmin',
                    'hostname' => '*.localhost.com',
                    'contact'  => 'support@copiousdev.com'
                }
            }
        }
    },
    ...
)

run_list(
    'recipe[cop_tls::dhparams]','recipe[cop_tls::snakeoil]'
)
```
