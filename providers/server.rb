def whyrun_supported?
  true
end

action :remove do
  service new_resource.name do
    action [:stop, :disable]
  end

  service new_resource.name + '-healthcheck' do
    action [:stop, :disable]
  end

  directory new_resource.home + '/' + new_resource.name do
    action :delete
    recursive true
  end

  %w("/etc/profile.d/#{new_resource.name}" "/etc/init.d/#{new_resource.name}" "/etc/init.d/#{new_resource.name}-healthcheck" "/etc/logrotate.d/#{new_resource.name}-logs" "/tmp/mysql-monitoring-status-#{new_resource.port}" "/tmp/mysql-monitoring-replication-#{new_resource.port}").each do |file|
    file file do
      action :delete
    end
  end

  %w("#{new_resource.name}-binlogcleaner" "#{new_resource.name}-monitoring").each do |cron|
    cron_d cron do
      action :delete
    end
  end
end

action :create do
  Chef::Log.info("Mysql binary: #{new_resource.name}")

  base = new_resource.home + '/' + new_resource.name

  group 'mysql' do
    action :create
    system true
  end

  user 'mysql' do
    gid 'mysql'
    shell '/bin/false'
    home '/tmp'
    system true
    action :create
    only_if do
      ::File.readlines('/etc/passwd').grep(/^mysql/).size <= 0
    end
  end

  directory base do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    recursive true
  end

  unless new_resource.base_device.nil?
    bash "create partition for mysql base (#{new_resource.name})" do
      user 'root'
      code "mkfs.#{new_resource.base_fs} -L mysql #{new_resource.base_device}"
      only_if "test -b #{new_resource.base_device} && ! blkid #{new_resource.base_device}"
    end
    mount base do
      fstype   new_resource.base_fs
      device   new_resource.base_device
      options  new_resource.base_mount_options
      pass     0
      dump     0
      action   [:mount, :enable]
    end
  end

  %w(log binlog translog relaylog data var etc tmp tools).each do |dirname|
    directory base + '/' + dirname do
      owner 'mysql'
      group 'mysql'
      mode '0755'
      action :create
      recursive false
    end

    next if (eval 'new_resource.' + dirname + '_device').nil?

    bash "create partition for mysql #{dirname}" do
      user 'root'
      code 'mkfs.' + (eval 'new_resource.' + dirname + '_fs') + " -L mysql-#{dirname} " + (eval 'new_resource.' + dirname + '_device')
      only_if 'test -b ' + (eval 'new_resource.' + dirname + '_device') + ' && ! blkid ' + (eval 'new_resource.' + dirname + '_device')
    end
    mount base + '/' + dirname do
      fstype   eval 'new_resource.' + dirname + '_fs'
      device   eval 'new_resource.' + dirname + '_device'
      options  eval 'new_resource.' + dirname + '_mount_options'
      pass     0
      dump     0
      action   [:mount, :enable]
    end
  end

  t = template base + '/etc/my.cnf' do
    source 'etc/mysql_server.cnf.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0644'
    variables(name: new_resource.name,
              port: new_resource.port,
              socket: base + '/var/mysqld.sock',
              open_files_limit: new_resource.open_files_limit,
              pid: base + '/var/mysqld.pid',
              basedir: base + '/current',
              datadir: base + '/data',
              default_storage_engine: new_resource.default_storage_engine,
              nice: new_resource.nice,
              log_error: base + '/log/error.log',
              relay_log: base + '/relaylog/relay-bin',
              relay_log_info_file: base + '/relaylog/relay-bin.info',
              relay_log_index: base + '/relaylog/relay-bin.index',
              relay_log_space_limit: '4G',
              transaction_isolation: new_resource.transaction_isolation,
              tmpdir: new_resource.tmpdir,
              slave_load_tmpdir: base + '/tmp',
              tmp_table_size: new_resource.tmp_table_size,
              max_heap_table_size: new_resource.max_heap_table_size,
              slave_net_timeout: new_resource.slave_net_timeout,
              slave_compressed_protocol: new_resource.slave_compressed_protocol,
              skip_slave_start: new_resource.skip_slave_start,
              slave_skip_errors: new_resource.slave_skip_errors,
              slave_parallel_threads: new_resource.slave_parallel_threads,
              skip_name_resolv: new_resource.skip_name_resolv,
              replicate_ignore_table: new_resource.replicate_ignore_table,
              replicate_wild_ignore_table: new_resource.replicate_wild_ignore_table,
              event_scheduler: new_resource.event_scheduler,
              read_only: new_resource.read_only,
              report_host: new_resource.report_host,
              server_id: new_resource.server_id,
              do_binlog: new_resource.do_binlog,
              master_verify_checksum: new_resource.master_verify_checksum,
              log_bin: base + '/binlog/mysql-bin',
              log_bin_index: base + '/binlog/mysql-bin.index',
              sync_binlog: new_resource.sync_binlog,
              binlog_format: new_resource.binlog_format,
              max_binlog_size: new_resource.max_binlog_size,
              expire_logs_days: new_resource.expire_logs_days,
              log_slave_updates: new_resource.log_slave_updates,
              log_slow_rate_limit: new_resource.log_slow_rate_limit,
              slow_query_log: new_resource.slow_query_log,
              slow_query_log_file: base + '/log/slow.log',
              log_queries_not_using_indexes: new_resource.log_queries_not_using_indexes,
              log_warnings: new_resource.log_warnings,
              log_slow_verbosity: new_resource.log_slow_verbosity,
              long_query_time: new_resource.long_query_time,
              concurrent_insert: new_resource.concurrent_insert,
              myisam_recover: new_resource.myisam_recover,
              myisam_sort_buffer_size: new_resource.myisam_sort_buffer_size,
              bind_address: new_resource.bind_address,
              connect_timeout: new_resource.connect_timeout,
              interactive_timeout: new_resource.interactive_timeout,
              wait_timeout: new_resource.wait_timeout,
              max_connections: new_resource.max_connections,
              max_user_connections: new_resource.max_user_connections,
              max_allowed_packet: new_resource.max_allowed_packet,
              max_connect_errors: new_resource.max_connect_errors,
              sort_buffer_size: new_resource.sort_buffer_size,
              key_buffer: new_resource.key_buffer,
              sql_mode: new_resource.sql_mode,
              read_buffer_size: new_resource.read_buffer_size,
              query_cache_size: new_resource.query_cache_size,
              query_cache_type: new_resource.query_cache_type,
              query_cache_limit: new_resource.query_cache_limit,
              thread_cache_size: new_resource.thread_cache_size,
              join_buffer_size: new_resource.join_buffer_size,
              read_rnd_buffer_size: new_resource.read_rnd_buffer_size,
              table_cache: new_resource.table_cache,
              table_open_cache: new_resource.table_open_cache,
              table_definition_cache: new_resource.table_definition_cache,
              auto_increment_increment: new_resource.auto_increment_increment,
              auto_increment_offset: new_resource.auto_increment_offset,
              innodb_file_format: new_resource.innodb_file_format,
              innodb_buffer_pool_size: (new_resource.innodb_buffer_pool_size).to_s.gsub(/[MGK]/i, 'M' => '000000', 'm' => '000000', 'G' => '000000000', 'g' => '000000000', 'K' => '000', 'k' => '000').to_i,
              have_innodb_buffer_pool_instances: new_resource.have_innodb_buffer_pool_instances,
              innodb_open_files: new_resource.innodb_open_files,
              innodb_log_file_size: new_resource.innodb_log_file_size,
              innodb_log_buffer_size: new_resource.innodb_log_buffer_size,
              innodb_flush_method: new_resource.innodb_flush_method,
              innodb_autoextend_increment: new_resource.innodb_autoextend_increment,
              innodb_file_io_threads: new_resource.innodb_file_io_threads,
              innodb_flush_log_at_trx_commit: new_resource.innodb_flush_log_at_trx_commit,
              innodb_thread_concurrency: new_resource.innodb_thread_concurrency,
              innodb_max_dirty_pages_pct: new_resource.innodb_max_dirty_pages_pct,
              innodb_io_capacity: new_resource.innodb_io_capacity,
              innodb_commit_concurrency: new_resource.innodb_commit_concurrency,
              innodb_data_file_path: new_resource.innodb_data_file_path,
              innodb_log_files_in_group: new_resource.innodb_log_files_in_group,
              innodb_additional_mem_pool_size: new_resource.innodb_additional_mem_pool_size,
              innodb_lock_wait_timeout: new_resource.innodb_lock_wait_timeout,
              innodb_doublewrite: new_resource.innodb_doublewrite,
              innodb_data_home_dir: base + '/data',
              innodb_log_group_home_dir: base + '/translog',
              innodb_write_io_threads: new_resource.innodb_write_io_threads,
              innodb_read_io_threads: new_resource.innodb_read_io_threads,
              innodb_stats_update_need_lock: new_resource.innodb_stats_update_need_lock,
              innodb_support_xa: new_resource.innodb_support_xa,
              innodb_doublewrite_file: new_resource.innodb_doublewrite_file,
              innodb_print_all_deadlocks: new_resource.innodb_print_all_deadlocks,
              explicit_defaults_for_timestamp: new_resource.explicit_defaults_for_timestamp,
              innodb_flush_neighbor_pages: new_resource.innodb_flush_neighbor_pages,
              innodb_flush_neighbors: new_resource.innodb_flush_neighbors,
              innodb_purge_threads: new_resource.innodb_purge_threads,
              innodb_buffer_pool_restore_at_startup: new_resource.innodb_buffer_pool_restore_at_startup,
              innodb_buffer_pool_load_at_startup: new_resource.innodb_buffer_pool_load_at_startup,
              innodb_buffer_pool_dump_at_shutdown: new_resource.innodb_buffer_pool_dump_at_shutdown,
              thread_handling: new_resource.thread_handling,
              innodb_buffer_pool_populate: new_resource.innodb_buffer_pool_populate,
              sync_master_info: new_resource.sync_master_info,
              sync_relay_log: new_resource.sync_relay_log,
              sync_relay_log_info: new_resource.sync_relay_log_info,
              innodb_stats_sample_pages: new_resource.innodb_stats_sample_pages,
              innodb_stats_on_metadata: new_resource.innodb_stats_on_metadata.to_s,
              innodb_strict_mode: new_resource.innodb_strict_mode,
              gtid_domain_id: new_resource.gtid_domain_id,
              innodb_defragment: new_resource.innodb_defragment,
              slave_parallel_mode: new_resource.slave_parallel_mode
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  %w( wget libaio1 libjemalloc1 nscd logrotate python-daemon python-mysqldb numactl percona-xtrabackup pigz ).each do |pkg|
    package pkg do
      action :install
    end
  end

  package 'mysql-client' do
    action :install
    not_if do
      ::File.exist?('/usr/bin/mysql')
    end
  end

  t = template '/etc/init.d/' + new_resource.name do
    source 'etc/init.d/mysql_server.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(basedir: base + '/current',
              datadir: base + '/data',
              vardir: base + '/var',
              defaults_file: base + '/etc/my.cnf',
              name: new_resource.name,
              default_instance: new_resource.default_instance
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  filename = ::File.basename(new_resource.url)
  dirname = ::File.basename(filename, '.tar.gz')

  link base + '/current' do
    to base + '/' + dirname
    link_type :symbolic
  end

  bash 'get_mysql_binary' do
    user 'root'
    cwd base
    code <<-EOH
    wget -q --no-check-certificate #{new_resource.url}
    tar -zxf #{filename}
    EOH
    not_if do
      ::File.exist?(base + '/' + filename)
    end
  end

  bash 'install_initial_db_if_empty' do
    user 'root'
    cwd base
    code <<-EOH
    if [ -x #{base}/#{dirname}/bin/mysql_install_db ]; then
      #{base}/#{dirname}/bin/mysql_install_db --user=mysql --defaults-file=#{base}/etc/my.cnf --basedir=#{base}/#{dirname} --datadir=#{base}/data --force
    elif [ -x #{base}/#{dirname}/scripts/mysql_install_db ]; then
      #{base}/#{dirname}/scripts/mysql_install_db --user=mysql --defaults-file=#{base}/etc/my.cnf --basedir=#{base}/#{dirname} --datadir=#{base}/data --force
    fi
    /etc/init.d/#{new_resource.name} start
    #{base}/#{dirname}/bin/mysql -S #{base}/var/mysqld.sock -e "GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'db_monitor'@'127.0.0.1' IDENTIFIED BY PASSWORD '*8248778E2BE81112DA61ADD724057530A4BE7275' WITH MAX_USER_CONNECTIONS 5;"
    EOH
    not_if do
      ::File.exist?(base + '/data/mysql/user.MYD')
    end
  end

  service new_resource.name do
    if new_resource.start_by_default
      action [:enable, :start]
    else
      action :enable
    end
    supports status: true, restart: true
  end

  t = template '/etc/profile.d/' + new_resource.name + '.sh' do
    source 'etc/profile.d/mysql_server.sh.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(calias: new_resource.name,
              cpath: base
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  t = template '/etc/logrotate.d/' + new_resource.name + '-logs' do
    source 'etc/logrotate.d/mysql_server-logs.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0644'
    variables(cpath: base + '/log')
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  cron_d "#{new_resource.name}-monitoring" do
    hour '*'
    minute '*'
    day '*'
    month '*'
    weekday '*'
    command "#{base}/tools/mysql_monitoring.sh > /dev/null 2>&1"
    user 'root'
    shell '/bin/bash'
  end

  t = template base + '/tools/mysql_healthcheck.py' do
    source 'tools/mysql_healthcheck.py.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(logfile: base + '/log/healthcheck.log',
              pidfile: base + '/var/healthcheck.pid',
              socket: base + '/var/mysqld.sock',
              listen_port: new_resource.healthcheck_listen_port,
              max_slave_delay: new_resource.healthcheck_max_slave_delay,
              keep_users: new_resource.healthcheck_keep_users
             )
    if new_resource.healthcheck_enabled
      notifies :restart, "service[#{new_resource.name}-healthcheck]"
    end
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  t = template base + '/tools/mysql_monitoring.sh' do
    source 'tools/mysql_monitoring.sh.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(name: new_resource.name,
              basedir: base,
              port: new_resource.port
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  t = template '/etc/init.d/' + new_resource.name + '-healthcheck' do
    source 'etc/init.d/mysql-healthcheck.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(name: new_resource.name,
              basedir: base + '/tools'
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  service new_resource.name + '-healthcheck' do
    if new_resource.healthcheck_enabled
      action [:enable, :start]
    else
      action [:stop, :disable]
    end
    supports restart: true
  end

  # Init script will manage this also!!!
  if new_resource.default_instance
    directory '/var/run/mysqld/' do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
    link '/var/run/mysqld/mysqld.sock' do
      to base + '/var/mysqld.sock'
      link_type :symbolic
    end
  end

  t = template base + '/tools/mysql_binlogcleaner.sh' do
    source 'tools/mysql_binlogcleaner.sh.erb'
    cookbook 'L7-mysql'
    owner 'root'
    group 'root'
    mode '0755'
    variables(binlog_dir: base + '/binlog',
              mysql_cli: 'mysql',
              mysql_socket: base + '/var/mysqld.sock',
              keep_minutes: new_resource.binlogcleaner_keep_minutes
             )
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)

  if new_resource.binlogcleaner_enabled
    cron_d "#{new_resource.name}-binlogcleaner" do
      hour '*'
      minute '*/5'
      day '*'
      month '*'
      weekday '*'
      command "#{base}/tools/mysql_binlogcleaner.sh > /dev/null 2>&1"
      user 'root'
      shell '/bin/bash'
    end
  else
    cron_d "#{new_resource.name}-binlogcleaner" do
      action :delete
    end
  end

  template base + '/tools/backup_mysql_data.sh' do
    source 'tools/backup_mysql_data.sh.erb'
    cookbook 'L7-mysql'
    mode '0755'
    owner 'root'
    group 'root'
    variables(base: base,
              name: new_resource.name,
              port: new_resource.port,
              backup_user: new_resource.backup_user,
              backup_host: new_resource.backup_host,
              backup_path: new_resource.backup_path,
              backup_port: new_resource.backup_port
             )
  end

  template base + '/tools/backup_mysql_binlog.sh' do
    source 'tools/backup_mysql_binlog.sh.erb'
    cookbook 'L7-mysql'
    mode '0755'
    owner 'root'
    group 'root'
    variables(base: base,
              backup_user: new_resource.backup_user,
              backup_host: new_resource.backup_host,
              backup_path: new_resource.backup_path,
              backup_port: new_resource.backup_port
             )
  end

  template base + '/tools/restore_mysql_data.sh' do
    source 'tools/restore_mysql_data.sh.erb'
    cookbook 'L7-mysql'
    mode '0755'
    owner 'root'
    group 'root'
    variables(base: base,
              name: new_resource.name,
              port: new_resource.port,
              backup_user: new_resource.backup_user,
              backup_host: new_resource.backup_host,
              backup_path: new_resource.backup_path,
              backup_port: new_resource.backup_port
             )
  end

  template base + '/tools/backup_rsa' do
    source 'tools/backup_rsa.erb'
    cookbook 'L7-mysql'
    mode '0600'
    owner 'root'
    group 'root'
  end

  template base + '/tools/backup_rsa.pub' do
    source 'tools/backup_rsa.pub.erb'
    cookbook 'L7-mysql'
    mode '0644'
    owner 'root'
    group 'root'
  end

  require 'digest/md5'
  checksum = Digest::MD5.hexdigest(new_resource.name)

  if new_resource.backup_hour.nil?
    hour = checksum.to_s.hex % 6
  else
    hour = new_resource.backup_hour
  end

  if new_resource.backup_minute.nil?
    minute = checksum.to_s.hex % 59
  else
    minute = new_resource.backup_minute
  end

  if new_resource.backup_data
    cron_d "#{new_resource.name}-backup-mysql-data" do
      hour hour
      minute minute
      day '*'
      month '*'
      weekday '*'
      command "#{base}/tools/backup_mysql_data.sh >> #{base}/log/backup-mysql-data-#{new_resource.name}.log 2>&1"
      user 'root'
      shell '/bin/bash'
    end
  else
    cron_d "#{new_resource.name}-backup-mysql-data" do
      action :delete
    end
  end

  if new_resource.backup_binlog
    cron_d "#{new_resource.name}-backup-mysql-binlog" do
      hour '*'
      minute '0'
      day '*'
      month '*'
      weekday '*'
      command "#{base}/tools/backup_mysql_binlog.sh >> #{base}/log/backup-mysql-binlog-#{new_resource.name}.log 2>&1"
      user 'root'
      shell '/bin/bash'
    end
  else
    cron_d "#{new_resource.name}-backup-mysql-binlog" do
      action :delete
    end
  end
end
