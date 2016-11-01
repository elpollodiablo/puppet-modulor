define modulor::lxcuser($ensure = present) {
  lxc::unprivileged::user_and_group{$name:
    user      => $name,
    group     => $modulor::params::user_definitions[$name]['group'],
    uid       => $modulor::params::user_definitions[$name]['uid'],
    gid       => $modulor::params::user_definitions[$name]['gid'],
    home      => $modulor::params::user_definitions[$name]['home'],
  }
}