# == Class: eyaml
#
# Module to manage eyaml
#
class eyaml (
  $package_name      = 'hiera-eyaml',
  $package_provider  = 'gem',
  $package_ensure    = 'present',
  $keys_dir          = "${::settings::confdir}/keys",
  $keys_dir_ensure   = 'directory',
  $keys_dir_owner    = $::settings::user,
  $keys_dir_group    = $::settings::group,
  $keys_dir_mode     = '0500',
  $public_key_path   = '/etc/puppet/keys/public_key.pkcs7.pem',
  $private_key_path  = '/etc/puppet/keys/private_key.pkcs7.pem',
  $public_key_mode   = '0644',
  $private_key_mode  = '0400',
  $config_dir        = '/etc/eyaml',
  $config_dir_ensure = 'directory',
  $config_dir_owner  = 'root',
  $config_dir_group  = 'root',
  $config_dir_mode   = '0755',
  $config_ensure     = 'file',
  $config_path       = '/etc/eyaml/config.yaml',
  $config_owner      = 'root',
  $config_group      = 'root',
  $config_mode       = '0644',
  $config_options    = {
    'pkcs7_public_key'  => '/etc/puppet/keys/public_key.pkcs7.pem',
    'pkcs7_private_key' => '/etc/puppet/keys/private_key.pkcs7.pem',
  },
) {

  validate_string($package_name)
  validate_string($package_provider)
  validate_string($package_ensure)
  validate_absolute_path($keys_dir)
  validate_string($keys_dir_ensure)
  validate_string($keys_dir_owner)
  validate_string($keys_dir_group)
  validate_re($keys_dir_mode, '^[0-7]{4}$',
      "eyaml::keys_dir_mode is <${keys_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($public_key_path)
  validate_absolute_path($private_key_path)
  validate_re($public_key_mode, '^[0-7]{4}$',
      "eyaml::public_key_mode is <${public_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_re($private_key_mode, '^[0-7]{4}$',
      "eyaml::private_key_mode is <${private_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_dir)
  validate_string($config_dir_ensure)
  validate_string($config_dir_owner)
  validate_string($config_dir_group)
  validate_re($config_dir_mode, '^[0-7]{4}$',
      "eyaml::config_dir_mode is <${config_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_path)
  validate_string($config_owner)
  validate_string($config_group)
  validate_re($config_mode, '^[0-7]{4}$',
      "eyaml::config_mode is <${config_mode}> and must be a valid four digit mode in octal notation.")
  validate_hash($config_options)

  package { 'eyaml':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
  }

  file { 'eyaml_config_dir':
    ensure  => $config_dir_ensure,
    path    => $config_dir,
    owner   => $config_dir_owner,
    group   => $config_dir_group,
    mode    => $config_dir_mode,
    require => Package['eyaml'],
  }

  file { 'eyaml_config':
    ensure  => $config_ensure,
    path    => $config_path,
    content => template('eyaml/config.yaml'),
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_mode,
    require => File['eyaml_config_dir'],
  }

  file { 'eyaml_keys_dir':
    ensure  => $keys_dir_ensure,
    path    => $keys_dir,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $keys_dir_mode,
    require => Package['eyaml'],
  }

  exec { 'eyaml_createkeys':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "eyaml createkeys --pkcs7-private-key=${private_key_path} --pkcs7-public-key=${public_key_path}",
    creates => $private_key_path,
    require => File['eyaml_keys_dir'],
  }

  file { 'eyaml_publickey':
    ensure  => file,
    path    => $public_key_path,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $public_key_mode,
    require => Exec['eyaml_createkeys'],
  }

  file { 'eyaml_privatekey':
    ensure  => file,
    path    => $private_key_path,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $private_key_mode,
    require => Exec['eyaml_createkeys'],
  }
}
