class modulor::lxchost {
  include lxc
  include lxc::unprivileged
  class {"::lxc::unprivileged::usernet":
    content => template("modulor/lxc-usernet.erb")
  }
  if $::modulor::params::manage_lxc_users_and_groups {
    # notify {"managing users & groups": }
    if $::modulor::params::active_lxc_users == "all" {
      # notify {"managing users & groups all": }
      $my_lxc_users = $::modulor::params::lxc_users
    } else {
      # notify {"managing users & groups active": }
      $my_lxc_users = $::modulor::params::active_lxc_users
    }
    modulor::lxcuser {$my_lxc_users:
      ensure => present,
    }
  }
}
