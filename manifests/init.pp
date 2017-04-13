class modulor (
  $network_definitions            = {},
  $user_definitions               = {},
  $lxc_users                      = [],
  $everywhere_users               = [],
  $puppetmaster                   = undef,
  $puppetmaster_ip                = undef,
  $mac_prefix                     = '00:16:3e',
  $container_dir                  = '/srv/lxc',
  $manage_lxc_users_and_groups    = true,
  $active_lxc_users               = "all",
  $nameservers                    = ['8.8.8.8', '8.8.4.4'],
  $container_domain               = undef,
  $limit_memory                   = "1024M",
  $limit_swap                     = "1536M",
  $limit_cpus                     = undef,
  $limit_blockio                  = undef,
  $limit_cpushares                = undef,
  $root_authorized_key            = undef,
  $manage_resolv_conf             = true,
  $fix_jessie_pam_sshd            = false,
  $manage_lxc                     = true,
  $manage_unprivileged_lxc        = true,
  $search_domains                 = undef,
) {
  class {"modulor::params":
    network_definitions            => $network_definitions,
    user_definitions               => $user_definitions,
    lxc_users                      => $lxc_users,
    everywhere_users               => $everywhere_users,
    puppetmaster                   => $puppetmaster,
    puppetmaster_ip                => $puppetmaster_ip,
    mac_prefix                     => $mac_prefix,
    container_dir                  => $container_dir,
    manage_lxc_users_and_groups    => $manage_lxc_users_and_groups,
    active_lxc_users               => $active_lxc_users,
    nameservers                    => $nameservers,
    container_domain               => $container_domain,
    limit_memory                   => $limit_memory,
    limit_swap                     => $limit_swap,
    limit_cpus                     => $limit_cpus,
    limit_blockio                  => $limit_blockio,
    limit_cpushares                => $limit_cpushares,
    root_authorized_key            => $root_authorized_key,
    manage_resolv_conf             => $manage_resolv_conf,
    fix_jessie_pam_sshd            => $fix_jessie_pam_sshd,
    search_domains                 => $search_domains
  }
  if $manage_lxc {
    include lxc
  }
  if $manage_unprivileged_lxc {
    include lxc::unprivileged
  }
}
