# == Class: hiera
#
# TODO
#
class hiera (
  $backends                   = {'yaml' => {'datadir' => '/etc/puppet/hieradata'} },
  $hierarchy                  = [],
  $merge_behavior             = '',
  $logger                     = '',
  $config_link                = true,
  $config_path                = '/etc/puppet/hiera.yaml',
  $config_owner               = 'root',
  $config_group               = 'root',
  $config_mode                = '0640',
  $package_name               = $hiera::params::package_name,
  $ensure                     = 'present',
  $install_options            = undef,
  $provider                   = undef,
  $deep_merge_package_name    = $hiera::params::deep_merge_package_name,
  $deep_merge_ensure          = 'present',
  $deep_merge_install_options = undef,
  $eyaml_package_name         = $hiera::params::eyaml_package_name,
  $eyaml_ensure               = 'present',
  $eyaml_install_options      = undef,
  $eyaml_gpg_package_name     = $hiera::params::eyaml_gpg_package_name,
  $eyaml_gpg_ensure           = 'present',
  $eyaml_gpg_install_options  = undef,
  $hiera_gpg_package_name     = $hiera::params::hiera_gpg_package_name,
  $hiera_gpg_ensure           = 'present',
  $hiera_gpg_install_options  = undef,
) inherits hiera::params {

  if $backends { validate_hash($backends) }
  if $hierarchy { validate_array($hierarchy) }
  validate_bool($config_link)

  if $merge_behavior {
    $merge_behavior_options = ['native', 'deep', 'deeper']
    validate_re($merge_behavior, $merge_behavior_options)
  }

  include hiera::package

  file { $config_path:
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_mode,
    content => template("${module_name}/hiera.yaml.erb"),
  }

  if $config_link {
    file { '/etc/hiera.yaml':
      ensure => link,
      target => $config_path,
    }
  }
}
