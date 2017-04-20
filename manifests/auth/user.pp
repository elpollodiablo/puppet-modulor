define modulor::auth::user ($ensure="present") {
  group {$name:
    ensure     => $ensure,
    gid        => $::modulor::params::user_definitions[$name][gid],
  } -> user {$name:
    ensure     => $ensure,
    uid        => $modulor::params::user_definitions[$name]["uid"],
    gid        => $modulor::params::user_definitions[$name]["gid"],
    home       => $modulor::params::user_definitions[$name]["home"],
    shell      => $modulor::params::user_definitions[$name]["shell"],
  } -> file {["${modulor::params::user_definitions[$name]['home']}", "${modulor::params::user_definitions[$name]['home']}/.ssh"]:
    owner      => $name,
    ensure     => directory,
  } -> file {"${modulor::params::user_definitions[$name]['home']}/.ssh/authorized_keys":
    content    => $modulor::params::user_definitions[$name]["ssh"]["authorized_keys"],
  }
}
