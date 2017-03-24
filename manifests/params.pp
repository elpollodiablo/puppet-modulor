class modulor::params (
  $network_definitions,
  $user_definitions,
  $lxc_users,
  $everywhere_users,
  $puppetmaster,
  $puppetmaster_ip,
  $mac_prefix,
  $container_dir,
  $manage_lxc_users_and_groups,
  $active_lxc_users,
  $nameservers,
  $container_domain,
  $limit_memory,
  $limit_swap,
  $limit_cpus,
  $limit_blockio,
  $limit_cpushares,
  $root_authorized_key,
  $manage_resolv_conf,
  $fix_jessie_pam_sshd,
) {
  $configured = true
}