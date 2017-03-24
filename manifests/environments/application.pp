class modulor::environments::application {
  group {"app":
    gid     => 2000,    
  }
  user {"app":
    comment => "Application User",
    uid     => 2000,
    gid     => 2000,
    home    => "/srv/app",
    managehome => true,
    require => Group['app'],
  }
}