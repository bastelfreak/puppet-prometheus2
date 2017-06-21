# Class prometheus::config
# Configuration class for prometheus monitoring system
class prometheus::config(
  $global_config,
  $rule_files,
  $scrape_configs,
  $purge = true,
  $config_source        = $::prometheus::params::config_source,
  $config_template      = $::prometheus::params::config_template,
  $config_type          = $::prometheus::params::config_type,
) {

  case $config_type {
    'template': {
      $_config_template = $config_template
      $_config_source = undef
    }
    'source': {
      $_config_source = $config_source
      $_config_template = undef
    }
    default: {
      fail("Config file type ${config_type} is not supported by this module")
    }
  }

  if $prometheus::init_style {

    case $prometheus::init_style {
      'upstart' : {
        file { '/etc/init/prometheus.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.upstart.erb'),
        }
        file { '/etc/init.d/prometheus':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/etc/systemd/system/prometheus.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.systemd.erb'),
        }
        ~> exec { 'prometheus-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.sysv.erb'),
        }
      }
      'debian' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.debian.erb'),
        }
      }
      'sles' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.sles.erb'),
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.prometheus.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/prometheus.launchd.erb'),
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::init_style}")
      }
    }
  }

  file { $prometheus::config_dir:
    ensure  => 'directory',
    owner   => $prometheus::user,
    group   => $prometheus::group,
    purge   => $purge,
    recurse => $purge,
  }

  if $_config_source != undef {
    file { 'prometheus.yaml':
      ensure  => file,
      path    => "${prometheus::config_dir}/prometheus.yaml",
      owner   => $prometheus::user,
      group   => $prometheus::group,
      mode    => $prometheus::config_mode,
      source  => $_config_source,
      require => File[$prometheus::config_dir],
    }
  }

  if $_config_template != undef {
    file { 'prometheus.yaml':
      ensure  => file,
      path    => "${prometheus::config_dir}/prometheus.yaml",
      owner   => $prometheus::user,
      group   => $prometheus::group,
      mode    => $prometheus::config_mode,
      content => template($_config_template),
      require => File[$prometheus::config_dir],
    }
  }
}
