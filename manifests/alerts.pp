# Class: prometheus::alerts
#
# This module manages prometheus alerts for prometheus
#
#  [*location*]
#  Whether to create the alert file for prometheus
#
#  [*alerts*]
#  Array of alerts (see README)
#
#  [*alertfile_name*]
#  The name of the file
class prometheus::alerts (
  $location,
  $alerts = [],
  $alertfile_name  = 'alert.rules'
) inherits prometheus::params {

    if $alerts != [] {
        file { "${location}/${alertfile_name}":
                ensure  => 'file',
                owner   => $prometheus::user,
                group   => $prometheus::group,
                content => template('prometheus/alerts.erb'),
        }
    }
}
