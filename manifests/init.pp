# == Class: eyaml
#
# Module to manage eyaml
#
class eyaml (
  $package_name         = 'hiera-eyaml',
  $package_provider     = undef,
  $package_ensure       = 'present',
  $keys_dir             = undef,
  $keys_dir_owner       = 'root',
  $keys_dir_group       = 'root',
  $keys_dir_mode        = '0500',
  $public_key_path      = undef,
  $private_key_path     = undef,
  $public_key_mode      = '0644',
  $private_key_mode     = '0400',
  $config_dir           = '/etc/eyaml',
  $config_dir_owner     = 'root',
  $config_dir_group     = 'root',
  $config_dir_mode      = '0755',
  $config_path          = '/etc/eyaml/config.yaml',
  $config_owner         = 'root',
  $config_group         = 'root',
  $config_mode          = '0644',
  $config_options       = undef,
  $eyaml_path           = '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
  $manage_eyaml_config  = true,
  $manage_keys_creation = true,
) {

  if versioncmp("${::puppetversion}", '3.0') > 0 { # lint:ignore:only_variable_string
    # puppet v4
    $default_package_provider = 'puppet_gem'
    $default_keys_dir         = '/etc/puppetlabs/keys'
    $default_public_key_path  = '/etc/puppetlabs/keys/public_key.pkcs7.pem'
    $default_private_key_path = '/etc/puppetlabs/keys/private_key.pkcs7.pem'
    $default_config_options   = {
      'pkcs7_public_key'  => '/etc/puppetlabs/keys/public_key.pkcs7.pem',
      'pkcs7_private_key' => '/etc/puppetlabs/keys/private_key.pkcs7.pem',
    }
  } else {
    # puppet v3
    $default_package_provider = 'gem'
    $default_keys_dir         = '/etc/puppet/keys'
    $default_public_key_path  = '/etc/puppet/keys/public_key.pkcs7.pem'
    $default_private_key_path = '/etc/puppet/keys/private_key.pkcs7.pem'
    $default_config_options   = {
      'pkcs7_public_key'  => '/etc/puppet/keys/public_key.pkcs7.pem',
      'pkcs7_private_key' => '/etc/puppet/keys/private_key.pkcs7.pem',
    }
  }

  if $package_provider == undef {
    $package_provider_real = $default_package_provider
  } else {
    $package_provider_real = $package_provider
  }

  if $keys_dir == undef {
    $keys_dir_real = $default_keys_dir
  } else {
    $keys_dir_real = $keys_dir
  }

  if $public_key_path == undef {
    $public_key_path_real = $default_public_key_path
  } else {
    $public_key_path_real = $public_key_path
  }

  if $private_key_path == undef {
    $private_key_path_real = $default_private_key_path
  } else {
    $private_key_path_real = $private_key_path
  }

  if $config_options == undef {
    $config_options_real = $default_config_options
  } else {
    $config_options_real = $config_options
  }

  validate_string($package_name)
  validate_string($package_provider_real)
  validate_string($package_ensure)
  validate_absolute_path($keys_dir_real)
  validate_string($keys_dir_owner)
  validate_string($keys_dir_group)
  validate_re($keys_dir_mode, '^[0-7]{4}$',
      "eyaml::keys_dir_mode is <${keys_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($public_key_path_real)
  validate_absolute_path($private_key_path_real)
  validate_re($public_key_mode, '^[0-7]{4}$',
      "eyaml::public_key_mode is <${public_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_re($private_key_mode, '^[0-7]{4}$',
      "eyaml::private_key_mode is <${private_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_dir)
  validate_string($config_dir_owner)
  validate_string($config_dir_group)
  validate_re($config_dir_mode, '^[0-7]{4}$',
      "eyaml::config_dir_mode is <${config_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_path)
  validate_string($config_owner)
  validate_string($config_group)
  validate_re($config_mode, '^[0-7]{4}$',
      "eyaml::config_mode is <${config_mode}> and must be a valid four digit mode in octal notation.")
  validate_hash($config_options_real)
  validate_string($eyaml_path)

  if is_string($manage_eyaml_config) == true {
    $manage_eyaml_config_bool = str2bool($manage_eyaml_config)
  } else {
    $manage_eyaml_config_bool = $manage_eyaml_config
  }
  validate_bool($manage_eyaml_config_bool)

  if is_string($manage_keys_creation) == true {
    $manage_keys_creation_bool = str2bool($manage_keys_creation)
  } else {
    $manage_keys_creation_bool = $manage_keys_creation
  }
  validate_bool($manage_keys_creation_bool)

  package { 'eyaml':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider_real,
  }

  file { 'eyaml_config_dir':
    ensure  => 'directory',
    path    => $config_dir,
    owner   => $config_dir_owner,
    group   => $config_dir_group,
    mode    => $config_dir_mode,
    require => Package['eyaml'],
  }

  if $manage_eyaml_config_bool == true {
    file { 'eyaml_config':
      ensure  => 'file',
      path    => $config_path,
      content => template('eyaml/config.yaml'),
      owner   => $config_owner,
      group   => $config_group,
      mode    => $config_mode,
      require => File['eyaml_config_dir'],
    }
  }

  file { 'eyaml_keys_dir':
    ensure  => 'directory',
    path    => $keys_dir_real,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $keys_dir_mode,
    require => Package['eyaml'],
  }

  if $manage_keys_creation_bool == true {
    exec { 'eyaml_createkeys':
      path    => $eyaml_path,
      command => "eyaml createkeys --pkcs7-private-key=${private_key_path_real} --pkcs7-public-key=${public_key_path_real}",
      creates => $private_key_path_real,
      require => File['eyaml_keys_dir'],
    }
  }

  file { 'eyaml_publickey':
    ensure  => file,
    path    => $public_key_path_real,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $public_key_mode,
    require => Exec['eyaml_createkeys'],
  }

  file { 'eyaml_privatekey':
    ensure  => file,
    path    => $private_key_path_real,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $private_key_mode,
    require => Exec['eyaml_createkeys'],
  }
}
