class as{
  file { '/tmp/wso2as-5.2.1.zip':
    source => '/home/vagrant/provision/wso2as-5.2.1.zip',
  }

  file { '/opt/wso2as-5.2.1':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 0644,
  }

  exec { 'Extract WSO2 AS':
    command => '/usr/bin/unzip /tmp/wso2as-5.2.1.zip',
    cwd     => '/opt',
    creates => '/opt/wso2as-5.2.1/bin/wso2server.sh',
    user    => 'vagrant',
    group   => 'vagrant',
    require => File['/tmp/wso2as-5.2.1.zip', '/opt/wso2as-5.2.1'],
    timeout => 0,
  }->
  file { '/etc/init.d/wso2as':
    owner  => root,
    group  => root,
    mode   => 755,
    source => '/vagrant/provision/esb/puppet/modules/as/files/wso2as',
  }->
  service { 'wso2as':
    ensure => true,
    enable => true
  }  
  
  file { '/opt/wso2as-5.2.1/repository/conf/carbon.xml':
    source  => '/vagrant/provision/esb/puppet/modules/as/files/carbon.xml',
    require => Exec['Extract WSO2 AS'],
    notify  => Service['wso2as'],
  }
}
