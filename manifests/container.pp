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
  $mac_prefix             = $::modulor::params::mac_prefix,
  $container_dir          = $::modulor::params::container_dir,
  $nameservers            = $::modulor::params::nameservers,
  $container_domain       = $::modulor::params::container_domain,
  $search_domains         = $::modulor::params::search_domains,
  $limit_memory           = $::modulor::params::limit_memory,
  $limit_swap             = $::modulor::params::limit_swap,
  $limit_cpus             = $::modulor::params::limit_cpus,
  $limit_blockio          = $::modulor::params::limit_blockio,
  $limit_cpushares        = $::modulor::params::limit_cpushares,
  $start_on_creation      = true,
  $start_on_boot          = true,
  $puppet                 = true,
  $unprivileged_user      = undef,
  $root_authorized_key    = $::modulor::params::root_authorized_key,
  $manage_resolv_conf     = $::modulor::params::manage_resolv_conf,
){
  include modulor::lxchost
  if $template =~ /.*debian.*/ {
    $distro = "debian"
  }
  if $host_number == undef {
    fail ("host definition lacks a number")
  }
  if !member(keys($network_definitions), $service_network_name) {
    fail ("you're using a service network ${service_network_name} on ${name} that isn't defined in network_definitions")
  }
  if $client_network_names != [] and !member(keys($network_definitions), $client_network_names) {
    fail ("one of the client_network_names ${client_network_names} on ${name} isn't defined in network_definitions")
  }
  if $unprivileged_user {
    $my_container_dir = $modulor::params::user_definitions[$unprivileged_user]['home']
  } else {
    $my_container_dir = $container_dir
  }
  if $puppet and ($ensure == "present" or $ensure == "stopped" or $ensure == "running") {
    $my_packages = ["puppet", "openssh-server"]
  } else{
    $my_packages = ["openssh-server"]
  }
  if $unprivileged_user {
    #notify {$utsname:
    #notify {"client network names ${client_network_names}":}
    $unprivileged_group = $modulor::params::user_definitions[$unprivileged_user]['group']
    $unprivileged_home = $modulor::params::user_definitions[$unprivileged_user]['home']
    $unprivileged_uid = $modulor::params::user_definitions[$unprivileged_user]['uid']
    $unprivileged_gid = $modulor::params::user_definitions[$unprivileged_user]['gid']
  
    lxc::container {$utsname:
      ensure                                 => $ensure,
      unprivileged                           => true,
    	unprivileged_user                      => $unprivileged_user,
    	unprivileged_group                     => $unprivileged_group,
      unprivileged_home                      => $unprivileged_home,
      unprivileged_container_dir             => $my_container_dir,
      template                               => 'lxc-download',
      network_devices_string                 => template('modulor/lxc-network-part.erb'),
      require                                => [
        Modulor::Interfaces::Hostbridge[$service_network_name],
        Modulor::Interfaces::Hostbridge[$client_network_names],
        User[$unprivileged_user],
        Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
      ],
      start_on_creation                      => $start_on_creation,
      start_on_boot                          => $start_on_boot,
      lxc_cgroup_memory_limit_in_bytes       => $limit_memory,
      lxc_cgroup_memory_memsw_limit_in_bytes => $limit_swap,
      lxc_cgroup_cpuset_cpus                 => $limit_cpus,
      lxc_cgroup_cpu_shares                  => $limit_cpu_shares,      
    }
    if $ensure != absent {
      if $manage_resolv_conf {
        lxc::container::file {"${utsname}:/etc/resolv.conf":
          content                => template("modulor/resolv.conf.erb"),
          unprivileged_user      => $unprivileged_user,
          unprivileged_group     => $unprivileged_group,
          container_dir          => $my_container_dir,
          require                => [
            Lxc::Container[$utsname],
            User[$unprivileged_user],
            Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
          ],
        }
        $packages_require = [ Lxc::Container::File["${utsname}:/etc/resolv.conf"], Lxc::Container[$utsname], ]
      } else {
        $packages_require = [ Lxc::Container[$utsname], ]
      }
      if $my_packages {
        lxc::container::additional_packages{$utsname:
          packages      => $my_packages,
          container_dir => $my_container_dir,
          user          => $unprivileged_user,
          distro        => $distro,
          require       => $packages_require
        }
      }
      if $root_authorized_key {
        modulor::auth::root_authorized_key {$utsname:
          public_key             => $root_authorized_key,
          unprivileged_user      => $unprivileged_user,
          unprivileged_group     => $unprivileged_group,
          container_dir          => $my_container_dir,
          require                => [
            Lxc::Container[$utsname],
            User[$unprivileged_user],
            Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
          ],
        }
      }
      if $puppet {
        lxc::container::file {"${utsname}:/etc/puppet/puppet.conf":
          ensure             => present,
          content            => template('modulor/puppet.conf.erb'),
          container_dir      => $my_container_dir,
          unprivileged_user  => $unprivileged_user,
          unprivileged_group => $unprivileged_group,        
          require                => [
            Lxc::Container::Additional_packages[$utsname],
            Lxc::Container[$utsname],
            User[$unprivileged_user],
            Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
          ],
        }
      }
    }
  } else {
    lxc::container {$utsname:
      ensure                                 => $ensure,
      template                               => $template,
      network_devices_string                 => template('modulor/lxc-network-part.erb'),
      require                                => [
        Modulor::Interfaces::Hostbridge[$service_network_name],
        Modulor::Interfaces::Hostbridge[$client_network_names],
      ],
      start_on_creation                      => $start_on_creation,
      start_on_boot                          => $start_on_boot,
      lxc_cgroup_memory_limit_in_bytes       => $limit_memory,
      lxc_cgroup_memory_memsw_limit_in_bytes => $limit_swap,
      lxc_cgroup_cpuset_cpus                 => $limit_cpus,
      lxc_cgroup_cpu_shares                  => $limit_cpu_shares,      
    }
    if $ensure != "absent" {
      if $manage_resolv_conf {
        lxc::container::file {"${utsname}:/etc/resolv.conf":
          content                => template("modulor/resolv.conf.erb"),
          container_dir          => $my_container_dir,
          require                => [
            Lxc::Container[$utsname],
          ],
        }
        $packages_require = [ Lxc::Container::File["${utsname}:/etc/resolv.conf"], Lxc::Container[$utsname], ]
      } else {
        $packages_require = [ Lxc::Container[$utsname], ]
      }
      if $my_packages {
        lxc::container::additional_packages{$utsname:
          packages      => $my_packages,
          container_dir => $my_container_dir,
          distro        => $distro,
          user          => "root",
          require       => $packages_require,
        }
      }
      if $puppet {
        lxc::container::file {"${utsname}:/etc/puppet/puppet.conf":
          ensure => present,
          content => template('modulor/puppet.conf.erb'),
          require => Lxc::Container::Additional_packages[$utsname],
          container_dir => $container_dir,
        }
      }
    }
  }
}
