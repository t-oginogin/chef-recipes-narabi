## Ubuntuにnarabiを構築

VagrantでUbuntuを立ち上げる

    $ vagrant init precise32 http://files.vagrantup.com/precise32.box
    $ vagrant up

タイムゾーン変更

    $ echo "Asia/Tokyo" | sudo tee /etc/timezone
    $ sudo dpkg-reconfigure --frontend noninteractive tzdata

apt-getアップデート

    $ sudo apt-get update

Gitインストール

    $ sudo apt-get install git

chef-soloインストール

    $ sudo gem install chef

recipeダウンロード＆実行
（rbenvもインストールするのでrvmを既にインストールしている場合は注意）

    $ cd /vagrant/
    $ git clone https://github.com/t-oginogin/chef-recipes-narabi.git
    $ cd chef-recipes-narabi
    $ sudo chef-solo -c solo.rb -j ./localhost.json

Gemfile修正

    $ cd ~/narabi/
    $ vi Gemfile

    #gem 'therubyracer', :platform => :ruby
    gem 'therubyracer', :platform => :ruby
    
bundle install

    $ bundle install

narabi起動（developmentモード）

    $ bundle exec rake db:migrate
    $ bundle exec rails s
