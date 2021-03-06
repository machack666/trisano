
package "libxml2" do
  action :install
end

package "libxml2-dev" do
  action :install
end

package "libxslt1-dev" do
  action :install
end

package "postgresql-contrib" do
  action :install
end

package "libpq-dev" do
  action :install
end

package "postgresql-plperl-8.4" do
  action :install
end

package "libcurl4-openssl-dev" do
  action :install
end

package "tomcat6" do
  action :install
end

package "tomcat6-user" do
  action :install
end

gem_package "passenger"

gem_package "bundler"

bash "make log dir" do
  code "sudo mkdir /var/log/trisano"
  not_if do
    File.exists?("/var/log/trisano")
  end
end

bash "chown log dir" do
  code "sudo chown -R vagrant.vagrant /var/log/trisano"
end

bash "make release dir" do
  code "mkdir -p /opt/csi/TriSano/releases"
  not_if do
    File.exists?("/opt/csi/TriSano/releases")
  end
end 

bash "make release log dir" do
  code "mkdir -p /opt/csi/TriSano/shared/log"
  not_if do
    File.exists?("/opt/csi/TriSano/shared/log")
  end
end 

bash "make shared system dir" do
  code "mkdir -p /opt/csi/TriSano/shared/system"
  not_if { File.exists? "/opt/csi/TriSano/shared/system" }
end

bash "chown application install directory" do
  code "sudo chown -R vagrant.vagrant /opt/csi/TriSano"
end

bash "touch stop file" do
  code "sudo touch /usr/share/postgresql/8.4/tsearch_data/empty.stop"
end

bash "create tomcat instance" do
  code "tomcat6-instance-create /home/vagrant/tomcat6"
  not_if { File.directory? "/home/vagrant/tomcat6" }
end

bash "chown vagrant home" do
  code "sudo chown -R vagrant.vagrant /home/vagrant/"
end

bash "install bundle" do
  cwd "/vagrant/webapp"
  code "bundle install --local"
end

bash "copy database config" do
  cwd "/vagrant/webapp"
  code "cp config/database.yml.sample config/database.yml"
end

template "config.yml" do
  source "config.yml.erb"
  path "/vagrant/distro/config.yml"
end

ruby "create trisano_user" do
  code "system('createuser -s trisano_user')"
  user "postgres"
  timeout 5
  not_if { %x[psql -c "SELECT usename FROM pg_user WHERE usename = 'trisano_user'"].include?("1 row") }
end

ruby "create trisano_admin" do
  code "system('createuser -s trisano_admin')"
  user "postgres"
  timeout 5
  not_if { %x[psql -c "SELECT usename FROM pg_user WHERE usename = 'trisano_admin'"].include?("1 row") }
end

bash "set database user passwords" do
  code "psql -c \"alter role trisano_user password 'password'; alter role trisano_admin password 'password';\""
  user "postgres"
  timeout 5
end
