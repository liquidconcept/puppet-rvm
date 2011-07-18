class rvm::passenger::nginx::ubuntu::post{
  exec {'Install passenger-nginx':
    command => "${binpath}rvm ${ruby_version} exec passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=/tmp/nginx-${nginx_version} --extra-configure-flags=\"--conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --sbin-path=/usr/sbin/nginx\"",
    unless => 'test -f /tmp/nginx-${nginx_version}/objs/nginx',
    require => [
      Rvm_gem['passenger'],
      Exec["Unpack nginx ${nginx_version}"],
    ]
  }

}
