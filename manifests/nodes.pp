node default {
  include tomcat
  tomcat::deployment { "SimpleServlet":
      path => '/etc/puppet/modules/tomcat/files/war/SimpleServlet.war',
  }

  apache::vhost { 'ubuntu':
    port => 80,
    docroot => '/var/www/ubuntu',
    ssl => false,
    priority => 10,
    serveraliases => 'ubuntu',
  }
}
