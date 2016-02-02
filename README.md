# L7-mysql cookbook
[![Build Status](https://travis-ci.org/szelcsanyi/chef-mysql.svg?branch=master)](https://travis-ci.org/szelcsanyi/chef-mysql)
[![security](https://hakiri.io/github/szelcsanyi/chef-mysql/master.svg)](https://hakiri.io/github/szelcsanyi/chef-mysql/master)
[![Cookbook Version](https://img.shields.io/cookbook/v/L7-mysql.svg?style=flat)](https://supermarket.chef.io/cookbooks/L7-mysql)

## Description

Installs/Configures [MySQL](https://www.mysql.com/) via Opscode Chef

## Supported Platforms

* Ubuntu 14.04+
* Debian 7.0+

## Providers
* `L7_mysql_server` - Configures mysql instance

## Usage
###Provider parameters:

* `url`: url for mysql binary tgz (default: http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.30-30.1/binary/linux/x86_64/Percona-Server-5.5.30-rel30.1-465.Linux.x86_64.tar.gz)
It is important to define your own binary source address beacause this might be changed in future releases!

* TODO

#### A mysql instance with custom parameters:
```ruby
L7_mysql_server 'mysql-example' do
    port '3306'
    event_scheduler 'on'
    innodb_file_format 'Barracuda'
    log_warnings 1
    bind_address '0.0.0.0'
    default_instance true
    innodb_buffer_pool_populate 1
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

* Freely distributable and licensed under the [MIT license](http://szelcsanyi.mit-license.org/2016/license.html).
* Copyright (c) 2016 Gabor Szelcsanyi

[![image](https://ga-beacon.appspot.com/UA-56493884-1/chef-mysql/README.md)](https://github.com/szelcsanyi/chef-mysql)
