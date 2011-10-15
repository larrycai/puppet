class tomcat {

  $tomcat_port = 3737
  $tomcat_password = 'badwolf' 
  
  notice("Establishing http://$hostname:$tomcat_port/")

  include apt
  apt::source { "partner":
    location => "http://archive.canonical.com/ubuntu",
    release => "${lsbdistcodename}",
    repos => "partner",
    include_src => false,
  }
  file { "/var/cache/debconf/sun-java6.preseed":
    source => "puppet:///files/sun-java6.preseed",
    ensure => present
  }
  package { "sun-java6-jdk":
    ensure  => installed,
    responsefile => "/var/cache/debconf/sun-java6.preseed",
    require => [ Apt::Source["partner"], File["/var/cache/debconf/sun-java6.preseed"] ],
  }

  Package { # defaults
    ensure => installed,
  }

  package { 'tomcat6':
    require => Package['sun-java6-jdk']
  }

  package { 'tomcat6-user':
    require => Package['tomcat6'],
  }
 
  package { 'tomcat6-admin':
    require => Package['tomcat6'],
  }

  file { "/etc/tomcat6/tomcat-users.xml":
    owner => 'root',
    require => Package['tomcat6'],
    notify => Service['tomcat6'],
    content => template('tomcat/tomcat-users.xml.erb')
  }

  file { '/etc/tomcat6/server.xml':
     owner => 'root',
     require => Package['tomcat6'],
     notify => Service['tomcat6'],
     content => template('tomcat/server.xml.erb'),
  }

  service { 'tomcat6':
    ensure => running,
    require => Package['tomcat6'],
  }   

}

define tomcat::deployment($path) {

  include tomcat
  notice("Establishing http://$hostname:${tomcat::tomcat_port}/$name/")

  file { "/var/lib/tomcat6/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }

}

