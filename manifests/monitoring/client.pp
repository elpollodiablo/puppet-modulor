class modulor::monitoring::client {
  include apt::backports
  apt::pin { 'jessie-backports-prometheus-node-exporter':
    packages       => ["prometheus-node-exporter"],
    priority       => 600,
    release        => 'jessie-backports',
  }
  case $hostname {
   /hn-.*/: {
      $collectors = ['diskstats','filesystem','loadavg','meminfo','logind','netdev','netstat','stat','time','interrupts','ntp','tcpstat']
      $extra_options = '-collector.ntp.server ts1.univie.ac.at'
   }
   default: {
      $collectors = ['filesystem','loadavg','meminfo','logind','netdev','netstat','stat','time','tcpstat']
      $extra_options =''
   }
  }
  class { 'prometheus::node_exporter':
    collectors     => $collectors,
    extra_options  => $extra_options,
    bin_dir        => '/usr/bin',
    package_name   => 'prometheus-node-exporter',
    install_method => 'package',
    require        => Apt::Pin['jessie-backports-prometheus-node-exporter'],
  }
}
