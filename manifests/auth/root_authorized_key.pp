define modulor::auth::root_authorized_key (
  $utsname             = $name,
  $user                = "root",
  $public_key          = undef,
  $unprivileged_user   = undef,
  $unprivileged_group  = undef,
  $container_dir       = undef,
) {
  if $unprivileged_user {
    lxc::container::file {"${utsname}:/${user}/.ssh":
      ensure             => directory,
      container_dir      => $container_dir,
      unprivileged_user  => $unprivileged_user,
      unprivileged_group => $unprivileged_group,    
      require            => [
        Lxc::Container::Additional_packages[$utsname],
        Lxc::Container[$utsname],
        User[$unprivileged_user],
        Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
      ],
    }
    lxc::container::file {"${utsname}:/${user}/.ssh/authorized_keys":
      content            => $public_key,
      ensure             => present,
      container_dir      => $container_dir,
      unprivileged_user  => $unprivileged_user,
      unprivileged_group => $unprivileged_group,    
      require            => [
        Lxc::Container::File["${utsname}:/${user}/.ssh"],
        Lxc::Container::Additional_packages[$utsname],
        Lxc::Container[$utsname],
        User[$unprivileged_user],
        Group[$modulor::params::user_definitions[$unprivileged_user]['group']],
      ],
    }
  }
}