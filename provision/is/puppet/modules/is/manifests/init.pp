class is{
  file { '/tmp/wso2is-5.0.0.zip':
    source => '/home/vagrant/provision/wso2is-5.0.0.zip',
  }

  file { '/opt/wso2is-5.0.0':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 0644,
  }

  exec { 'Extract WSO2 Identity Services Server':
    command => '/usr/bin/unzip /tmp/wso2is-5.0.0.zip',
    cwd     => '/opt',
    creates => '/opt/wso2is-5.0.0/bin/wso2server.sh',
    user    => 'vagrant',
    group   => 'vagrant',
    require => File['/tmp/wso2is-5.0.0.zip', '/opt/wso2is-5.0.0'],
    timeout => 0,
  }->
  file { '/etc/init.d/wso2is':
    owner  => root,
    group  => root,
    mode   => 755,
    source => '/vagrant/provision/esb/puppet/modules/is/files/wso2is',
  }->
  file { '/opt/wso2is-5.0.0/repository/components/lib/postgresql-9.4-1201.jdbc41.jar':
    owner  => root,
    group  => root,
    mode   => 755,
    source => '/home/vagrant/provision/postgresql-9.4-1201.jdbc41.jar',
  }->
  service { 'wso2is':
    ensure => true,
    enable => true
  }
}