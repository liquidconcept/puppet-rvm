class rvm::passenger::nginx::ubuntu::pre {

  # Dependencies
  if ! defined(Package['build-essential'])      { package { build-essential:      ensure => installed } }
  if ! defined(Package['libapr1-dev'])          { package { libapr1-dev:          ensure => installed, alias => 'libapr-dev' } }
  if ! defined(Package['libaprutil1-dev'])      { package { libaprutil1-dev:      ensure => installed, alias => 'libaprutil-dev' } }
  if ! defined(Package['libcurl4-openssl-dev']) { package { libcurl4-openssl-dev: ensure => installed } }

  # echo 'Downloading'
  # wget -qN http://sysoev.ru/nginx/nginx-#{nginx_version}.tar.gz
  exec {"Download nginx ${nginx_version}":
    command => "/usr/bin/wget -qN http://sysoev.ru/nginx/nginx-${nginx_version}.tar.gz",
    creates => "/tmp/nginx-${nginx_version}.tar.gz",
    cwd => "/tmp",
  }

  # echo 'Unpacking'
  exec { "Unpack nginx ${nginx_version}":
    command => "/bin/tar xf nginx-${nginx_version}.tar.gz",
    cwd => "/tmp",
    require => [
      Exec["Download nginx ${nginx_version}"],
    ]
  }

  exec {'Install passenger-nginx':
    command => "passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=/tmp/nginx-${nginx_version} --extra-configure-flags=\"--conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --sbin-path=/usr/sbin/nginx\"",
    path => "/tmp",
    creates => $binpath,
    require => [
      Rvm_gem['passenger'],
      Exec["Unpack nginx ${nginx_version}"],
    ]
  }
}