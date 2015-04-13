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
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3,
2.0.0 and 2.1.0. It is supported on the following platforms.

* EL 6
* EL 7
