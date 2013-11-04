#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_version     = node['rbenv']['ruby_version']

node['rbenv']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

bash 'install_rbenv' do
  not_if "test -e ~/.rbenv"
  user 'vagrant'
  group 'vagrant'

  code <<-EOL
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    cd ~/.rbenv
    git pull
  EOL
end

bash 'install_ruby-build' do
  not_if "test -e ~/.rbenv/plugins/ruby-build"
  user 'vagrant'
  group 'vagrant'

  code <<-EOL
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  EOL
end

bash 'install_ruby' do
  user 'vagrant'
  group 'vagrant'

  code <<-EOL
    source ~/.bashrc
    rbenv install #{ruby_version} 
    rbenv global #{ruby_version}
    rbenv rehash
  EOL
end
