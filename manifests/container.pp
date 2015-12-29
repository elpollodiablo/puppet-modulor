define modulor::container (
  $utsname                = $name,
  $host_number            = undef,
  $productivity           = undef,
  $project                = undef,
  $service_network_name   = undef,
  $client_network_names   = [],
  $network_definitions    = $::modulor::params::network_definitions,
  $ensure                 = "present",
  $template               = "lxc-debian",
  $mac_prefix             = $::lxc::params::mac_prefix,
  $container_dir          = $::lxc::params::container_dir,
  $limit_memory           = undef,
  $limit_swap             = undef,
  $limit_cpus             = undef,
  $limit_blockio          = undef,
  $limit_cpushares        = undef,
  $start_on_creation      = true,
  $start_on_boot          = true,
  $puppet                 = true,
){
  if $host_number == undef {
    fail ("host definition lacks a number")
  }
  if !member(keys($network_definitions), $service_network_name) {
    fail ("you're using a service network ${service_network_name} on ${name} that isn't defined in network_definitions")
  }
  if $client_network_names != [] and !member(keys($network_definitions), $client_network_names) {
    fail ("one of the client_network_names ${client_network_names} on ${name} isn't defined in network_definitions")
  }
  #$service_network_mac = $mac_prefix + ":" 
  if $puppet {
    $my_packages = ["puppet", "openssh-server"]
    file {"${container_dir}/${utsname}/rootfs/etc/puppet/puppet.conf":
      ensure => present,
      content => template('modulor/puppet.conf.erb'),
      require => Lxc::Container[$utsname],
    }
  } else{
    $my_packages = ["openssh-server"]
  }
  lxc::container {$utsname:
    template               => "lxc-debian",
    packages               => $my_packages,
    network_devices_string => template('modulor/lxc-network-part.erb'),
    ensure                 => $ensure,
    require                => [ Modulor::Interfaces::Hostbridge[$service_network_name], Modulor::Interfaces::Hostbridge[$client_network_names]],
    start_on_creation      => $start_on_creation,
    start_on_boot          => $start_on_boot,
  }
}