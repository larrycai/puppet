node "puppet3" {
  include tomcat
  tomcat::deployment { "SimpleServlet":
      path => 'puppet:///modules/tomcat/war/SimpleServlet.war',
  }

}
node "puppet1" {
  info "In node for ubuntu"
  include apache
  apache::vhost { 'puppet1':
    port => 80,
    docroot => '/var/www/puppet1',
    ssl => false,
    priority => 10,
    serveraliases => 'puppet1',
  }
}
node "puppet2" {
   
  include tomcat

  tomcat::deployment { "SimpleServlet":
      path => 'puppet:///modules/tomcat/war/SimpleServlet.war',
  }
}
