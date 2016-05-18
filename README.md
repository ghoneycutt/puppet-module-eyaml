# puppet-module-eyaml
===

[![Build Status](https://travis-ci.org/ghoneycutt/puppet-module-eyaml.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-eyaml)

Manage [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml). Meant to be
associated with a puppet master. It will install the hiera-eyaml gem, create
/etc/puppet/keys, generate keys, and manage /etc/eyaml/config.yaml. It does not
modify your hiera.yaml, which must be done to use eyaml. The module is totally
configurable through parameters.

===

# Compatibility
---------------
This module is built for use with Puppet v3 (with and without the future parse)
and v4 and supports Ruby v1.8.7 (on Puppet v3 only), v1.9.3, v2.0.0 and v2.1.0.

It is supported on the following platforms.

* EL 6
* EL 7

===

# Parameters
------------

package_name
------------
hiera-eyaml requires the hiera-eyaml gem to be installed.

type: string

- *Default*: hiera-eyaml

package_provider
----------------
Package provider to install eyaml.

type: string

- *Default*: 'gem'

package_ensure
--------------
Ensure attribute for package.

type: string

- *Default*: 'present'

keys_dir
--------
Directory containing public and private keys.

type: string

- *Default*: '/etc/puppet/keys'

keys_dir_owner
--------------
Owner of $keys_dir.

type: string

- *Default*: 'root'

keys_dir_group
--------------
Group of $keys_dir

type: string

- *Default*: 'root'

keys_dir_mode
-------------
Mode of $keys_dir in four digit octal notation.

type: string

- *Default*: '0500'

public_key_path
---------------
Absolute path to the public key.

type: string

- *Default*: '/etc/puppet/keys/public_key.pkcs7.pem'

private_key_path
----------------
Absolute path to the private key.

type: string

- *Default*: '/etc/puppet/keys/private_key.pkcs7.pem'

public_key_mode
---------------
Mode of the public key in four digit octal notation.

type: string

- *Default*: '0644'

private_key_mode
----------------
Mode of private key in four digit octal notation.

type: string

- *Default*: '0400'

config_dir
----------
Directory for eyaml configuration.

type: string

- *Default*: '/etc/yaml'

config_dir_owner
----------------
Owner of $config_dir.

type: string

- *Default*: 'root'

config_dir_group
----------------
Group of $config_dir.

type: string

- *Default*: 'root'

config_dir_mode
---------------
Mode of $config_dir in four digit octal notation.

type: string

- *Default*: '0755'

config_path
-----------
hiera-eyaml config file path.

type: string

- *Default*: '/etc/eyaml/config.yaml'

config_owner
------------
Owner of eyaml config file.

type: string

- *Default*: 'root'

config_group
------------
Group of eyaml config file.

type: string

- *Default*: 'root'

config_mode
-----------
Mode of $config_file in four digit octal notation.

type: string

- *Default*: '0644'

config_options
--------------
eyaml custom configurations like (extension, datadir)

type: hash

- *Default*:

```
{
  'pkcs7_public_key'  => '/etc/puppet/keys/public_key.pkcs7.pem',
  'pkcs7_private_key' => '/etc/puppet/keys/private_key.pkcs7.pem',
},
```

manage_eyaml_config
-------------------
Manage eyaml config file.

type: boolean

- *Default*: true


eyaml_path
----------
Path statement to find eyaml command.

type: string

- *Default*: '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin'

manage_keys
-----------
Manage creation of eyaml keys.

type: boolean

- *Default*: true
