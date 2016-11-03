class {'nubis_users::setup':
  global_admins => ['global-admins'],
  sudo_users    => ['sudo-users'],
  nubis_users   => ['users'],
}
