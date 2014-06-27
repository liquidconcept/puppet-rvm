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
    unless => "test -d /tmp/nginx-${nginx_version}",
    require => [
      Exec["Download nginx ${nginx_version}"],
    ]
  }

}
