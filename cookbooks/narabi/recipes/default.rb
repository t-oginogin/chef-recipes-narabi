#
# Cookbook Name:: narabi
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['narabi']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

bash 'setup_db' do
  user 'postgres'

  code <<-EOL
    createuser -a narabi
    createdb -E UTF8 -O narabi narabi_development -T template0 --locale=en_US.UTF-8
    psql -c "alter user postgres with password 'postgres'"
    psql -c "alter user narabi with password 'narabi'"
  EOL
end

cookbook_file "/etc/postgresql/9.1/main/pg_hba.conf" do
  source "pg_hba.conf"
  owner 'postgres'
  group 'postgres'
  mode '0644'
  notifies :restart, "service[postgresql]"
end

bash 'install_narabi' do
  user 'vagrant'

  code <<-EOL
    cd ~/
    git clone https://github.com/usutani/narabi.git
    cd narabi
    bundle install
  EOL
end

cookbook_file "/home/vagrant/narabi/config/database.yml" do
  source "database.yml"
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end
