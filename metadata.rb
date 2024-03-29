maintainer       'Gabor Szelcsanyi'
maintainer_email 'szelcsanyi.gabor@gmail.com'
license          'MIT'
description      'Installs/Configures MySQL server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             'L7-mysql'
version          '1.0.22'

source_url       'https://github.com/szelcsanyi/chef-mysql'
issues_url       'https://github.com/szelcsanyi/chef-mysql/issues'

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'
supports 'ubuntu', '= 18.04'
supports 'ubuntu', '= 20.04'

depends 'cron'
