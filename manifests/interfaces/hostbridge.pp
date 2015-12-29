define modulor::interfaces::hostbridge (
  $host_network_name   = $name,
  $host_number         = undef,
  $network_definitions = $::modulor::params::network_definitions,
  $ports               = undef,
  $interface           = undef,
  $use_default_gateway = false,
) {
  if $ports == undef {
    $my_ports = ["${interface}.${network_definitions[$host_network_name]['vlan_id']}"]
  } else {
    $my_ports = $ports
  }
  if $use_default_gateway != false {
    $my_gateway = $network_definitions[$host_network_name]["default_gateway"]
  } else {
    $my_gateway = undef
  }
  debnet::iface::bridge { $network_definitions[$host_network_name]['bridge_name']:
    ports   => $my_ports,
    stp     => false,
    method  => 'static',
    address => "10.${network_definitions[$host_network_name][network_number]}.0.${host_number}",
    gateway => $my_gateway,
    netmask => $network_definitions[$host_network_name]["netmask"],
  }

}