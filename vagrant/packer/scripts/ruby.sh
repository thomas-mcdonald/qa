# Install Ruby from source in /opt so that users of Vagrant
# can install their own Rubies using packages or however.

apt-get -y install libyaml-0-2
RUBY_VERSION=2.0.0-p247
wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
tar xvzf ruby-$RUBY_VERSION.tar.gz
cd ruby-$RUBY_VERSION
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-$RUBY_VERSION

# Install RubyGems 1.8.25
#RUBYGEMS_VERSION=1.8.25
#wget http://production.cf.rubygems.org/rubygems/rubygems-$RUBYGEMS_VERSION.tgz
#3tar xzf rubygems-$RUBYGEMS_VERSION.tgz
#cd rubygems-$RUBYGEMS_VERSION
#/opt/ruby/bin/ruby setup.rb
#cd ..
#rm -rf rubygems-$RUBYGEMS_VERSION

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh
