define modulor::auth::authorizedkey (
  $utsname    = $name,
  $user       = root,
  $public_key = undef
) {
  if $user == 'root' {
    $home_directory = '/root'
  } else {
    $home_directory = "/home/${user}"
  }
  lxc::container::file {"${utsname}:${home_directory}/.ssh":
    ensure => directory,
  }
  lxc::container::file {"${utsname}:${home_directory}/.ssh/authorized_keys":
    content => $public_key,
    ensure => present,
  }
}