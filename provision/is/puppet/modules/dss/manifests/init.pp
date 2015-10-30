class dss{
  file { '/tmp/wso2dss-3.5.0.zip':
    source => '/home/vagrant/provision/wso2dss-3.5.0.zip',
  }

  file { '/opt/wso2dss-3.5.0':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 0644,
  }

  exec { 'Extract WSO2 Datasource Server':
    command => '/usr/bin/unzip /tmp/wso2dss-3.5.0.zip',
    cwd     => '/opt',
    creates => '/opt/wso2dss-3.5.0/bin/wso2server.sh',
    user    => 'vagrant',
    group   => 'vagrant',
    require => File['/tmp/wso2dss-3.5.0.zip', '/opt/wso2dss-3.5.0'],
    timeout => 0,
  }->
  file { '/etc/init.d/wso2dss':
    owner  => root,
    group  => root,
    mode   => 755,
    source => '/vagrant/provision/is/puppet/modules/dss/files/wso2dss',
  }->
  service { 'wso2dss':
    ensure => true,
    enable => true
  }

  file { '/opt/wso2dss-3.5.0/repository/conf/carbon.xml':
    source  => '/vagrant/provision/is/puppet/modules/dss/files/carbon.xml',
    require => Exec['Extract WSO2 Datasource Server'],
    notify  => Service['wso2dss'],
  }

}
