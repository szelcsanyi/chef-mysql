actions :create, :remove

attribute :name, kind_of: String, name_attribute: true
attribute :cookbook, kind_of: String, default: 'L7-mysql'

attribute :url, kind_of: String, default: 'http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.30-30.1/binary/linux/x86_64/Percona-Server-5.5.30-rel30.1-465.Linux.x86_64.tar.gz'
attribute :home, kind_of: String, default: '/opt'
attribute :port, kind_of: [Integer, String], default: '3306'
attribute :nice, kind_of: [Integer, String], default: '0'
attribute :open_files_limit, kind_of: [Integer, String], default: '16384'
attribute :default_storage_engine, kind_of: String, default: 'InnoDB'
attribute :transaction_isolation, kind_of: String, default: 'READ-COMMITTED'
attribute :tmpdir, kind_of: String, default: '/dev/shm'
attribute :max_heap_table_size, kind_of: [Integer, String], default: '32M'
attribute :tmp_table_size, kind_of: [Integer, String], default: '32M'

attribute :slave_net_timeout, kind_of: [Integer, String], default: '120'
attribute :slave_compressed_protocol, kind_of: [Integer, String], default: '1'
attribute :skip_slave_start, kind_of: [Integer, String], default: '1'
attribute :slave_skip_errors, kind_of: [String, NilClass], default: nil
attribute :slave_parallel_threads, kind_of: [Integer, NilClass], default: nil
attribute :slave_parallel_mode, kind_of: [String, NilClass], default: nil

attribute :report_host, kind_of: String, default: node['hostname']
attribute :server_id, kind_of: [Integer, String], default: node['ipaddress'].split('.')[2].to_i * 1000 + node['ipaddress'].split('.')[3].to_i
attribute :read_only, kind_of: [Integer, String], default: '0'

attribute :replicate_ignore_table, kind_of: [NilClass, String, Array], default: nil
attribute :replicate_wild_ignore_table, kind_of: [NilClass, String, Array], default: nil

attribute :sync_binlog, kind_of: [Integer, String], default: '1'
attribute :binlog_format, kind_of: [String, NilClass], default: nil
attribute :max_binlog_size, kind_of: [Integer, String], default: '1G'
attribute :expire_logs_days, kind_of: [Integer, String], default: '1'
attribute :log_slave_updates, kind_of: [Integer, String], default: '0'
attribute :do_binlog, kind_of: [FalseClass, TrueClass], default: false
attribute :master_verify_checksum, kind_of: [FalseClass, TrueClass, NilClass], default: nil

attribute :sync_master_info, kind_of: [String, Integer, NilClass], default: nil
attribute :sync_relay_log, kind_of: [String, Integer, NilClass], default: nil
attribute :sync_relay_log_info, kind_of: [String, Integer, NilClass], default: nil

attribute :skip_name_resolv, kind_of: [String, Integer, NilClass], default: '1'
attribute :event_scheduler, kind_of: String, default: 'On'

attribute :log_slow_rate_limit, kind_of: [Integer, String], default: '100'
attribute :log_queries_not_using_indexes, kind_of: [Integer, String], default: '0'
attribute :log_warnings, kind_of: [Integer, String], default: '2'
attribute :log_slow_verbosity, kind_of: String, default: 'query_plan,innodb'
attribute :long_query_time, kind_of: [Integer, String], default: '2'
attribute :slow_query_log, kind_of: [Integer, String], default: '1'

attribute :concurrent_insert, kind_of: [Integer, String], default: '2'
attribute :myisam_recover, kind_of: String, default: 'BACKUP,FORCE'
attribute :myisam_sort_buffer_size, kind_of: [Integer, String], default: '16M'

attribute :bind_address, kind_of: String, default: '0.0.0.0'
attribute :connect_timeout, kind_of: [Integer, String], default: '10'
attribute :interactive_timeout, kind_of: [Integer, String], default: '3600'
attribute :wait_timeout, kind_of: [Integer, String], default: '3600'
attribute :max_connections, kind_of: [Integer, String], default: '1200'
attribute :max_user_connections, kind_of: [Integer, String], default: '1000'
attribute :max_allowed_packet, kind_of: [Integer, String], default: '16M'
attribute :max_connect_errors, kind_of: [Integer, String], default: '99999999'

attribute :sort_buffer_size, kind_of: [Integer, String], default: '2M'
attribute :key_buffer, kind_of: [Integer, String], default: '32M'
attribute :sql_mode, kind_of: String, default: 'NO_ENGINE_SUBSTITUTION'
attribute :read_buffer_size, kind_of: [Integer, String], default: '2M'
attribute :query_cache_size, kind_of: [Integer, String], default: '0'
attribute :query_cache_type, kind_of: [Integer, String], default: '1'
attribute :query_cache_limit, kind_of: [Integer, String], default: '1M'
attribute :thread_cache_size, kind_of: [Integer, String], default: '1024'
attribute :join_buffer_size, kind_of: [Integer, String], default: '1M'
attribute :read_rnd_buffer_size, kind_of: [Integer, String], default: '1M'
attribute :table_cache, kind_of: [Integer, String, NilClass], default: nil
attribute :table_open_cache, kind_of: [Integer, String, NilClass], default: nil
attribute :table_definition_cache, kind_of: [Integer, String, NilClass], default: nil
attribute :auto_increment_increment, kind_of: [Integer, String], default: '1'
attribute :auto_increment_offset, kind_of: [Integer, String], default: '1'

attribute :innodb_file_format, kind_of: String, default: 'Barracuda'
attribute :innodb_buffer_pool_size, kind_of: [Integer, String], default: (node['memory']['total'].to_i * 1024 * 0.7).round
attribute :have_innodb_buffer_pool_instances, kind_of: [FalseClass, TrueClass], default: true
attribute :innodb_open_files, kind_of: [Integer, String], default: '16384'
attribute :innodb_log_file_size, kind_of: [Integer, String], default: '256M'
attribute :innodb_log_buffer_size, kind_of: [Integer, String], default: '32M'
attribute :innodb_flush_method, kind_of: String, default: 'O_DIRECT'
attribute :innodb_autoextend_increment, kind_of: [Integer, String], default: '100'
attribute :innodb_file_io_threads, kind_of: [Integer, String], default: '4'
attribute :innodb_flush_log_at_trx_commit, kind_of: [Integer, String], default: '1'
attribute :innodb_thread_concurrency, kind_of: [Integer, String], default: '128'
attribute :innodb_max_dirty_pages_pct, kind_of: [Integer, String], default: '90'
attribute :innodb_io_capacity, kind_of: [Integer, String], default: '400'
attribute :innodb_commit_concurrency, kind_of: [Integer, String], default: '16'
attribute :innodb_data_file_path, kind_of: String, default: 'ibdata1:128M:autoextend'
attribute :innodb_log_files_in_group, kind_of: [Integer, String], default: '2'
attribute :innodb_additional_mem_pool_size, kind_of: [Integer, String], default: '10M'
attribute :innodb_lock_wait_timeout, kind_of: [Integer, String], default: '50'
attribute :innodb_doublewrite, kind_of: [Integer, String], default: '1'
attribute :innodb_write_io_threads, kind_of: [Integer, String], default: '4'
attribute :innodb_read_io_threads, kind_of: [Integer, String], default: '4'
attribute :innodb_stats_update_need_lock, kind_of: [Integer, String, NilClass], default: nil
attribute :innodb_support_xa, kind_of: [Integer, String], default: '1'
attribute :innodb_doublewrite_file, kind_of: [NilClass, String], default: nil
attribute :innodb_print_all_deadlocks, kind_of: [NilClass, String], default: nil
attribute :innodb_purge_threads, kind_of: [NilClass, Integer], default: nil
attribute :innodb_buffer_pool_restore_at_startup, kind_of: [NilClass, Integer, String], default: nil
attribute :innodb_buffer_pool_load_at_startup, kind_of: [NilClass, Integer, String], default: nil
attribute :innodb_buffer_pool_dump_at_shutdown, kind_of: [NilClass, Integer, String], default: nil
attribute :innodb_buffer_pool_populate, kind_of: [NilClass, Integer, String], default: nil
attribute :innodb_stats_sample_pages, kind_of: [NilClass, Integer, String], default: nil
attribute :innodb_stats_on_metadata, kind_of: [Integer, String], default: 0
attribute :innodb_strict_mode, kind_of: [Integer, String], default: '1'
attribute :innodb_defragment, kind_of: [NilClass, Integer, String], default: nil

attribute :thread_handling, kind_of: [NilClass, String], default: nil

# Devices and filesystems
attribute :base_device, kind_of: [String, NilClass], default: nil
attribute :base_fs, kind_of: String, default: 'ext4'
attribute :base_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :tmp_device, kind_of: [String, NilClass], default: nil
attribute :tmp_fs, kind_of: String, default: 'ext4'
attribute :tmp_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :var_device, kind_of: [String, NilClass], default: nil
attribute :var_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'
attribute :var_fs, kind_of: String, default: 'ext4'

attribute :log_device, kind_of: [String, NilClass], default: nil
attribute :log_fs, kind_of: String, default: 'ext4'
attribute :log_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :etc_device, kind_of: [String, NilClass], default: nil
attribute :etc_fs, kind_of: String, default: 'ext4'
attribute :etc_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :data_device, kind_of: [String, NilClass], default: nil
attribute :data_fs, kind_of: String, default: 'ext4'
attribute :data_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :binlog_device, kind_of: [String, NilClass], default: nil
attribute :binlog_fs, kind_of: String, default: 'ext4'
attribute :binlog_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :translog_device, kind_of: [String, NilClass], default: nil
attribute :translog_fs, kind_of: String, default: 'ext4'
attribute :translog_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :relaylog_device, kind_of: [String, NilClass], default: nil
attribute :relaylog_fs, kind_of: String, default: 'ext4'
attribute :relaylog_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

attribute :tools_device, kind_of: [String, NilClass], default: nil
attribute :tools_fs, kind_of: String, default: 'ext4'
attribute :tools_mount_options, kind_of: String, default: 'noatime,nodiratime,errors=remount-ro'

# Healthcheck daemon
attribute :healthcheck_enabled, kind_of: [FalseClass, TrueClass], default: false
attribute :healthcheck_max_slave_delay, kind_of: [Integer, String], default: '60'
attribute :healthcheck_listen_port, kind_of: [Integer, String], default: '13306'
# Connections will be killed on error. Keep these user connections.
attribute :healthcheck_keep_users, kind_of: [String, Array], default: ['root', 'system user']

# If disk is getting full, purge some binlog files
attribute :binlogcleaner_enabled, kind_of: [FalseClass, TrueClass], default: false
attribute :binlogcleaner_keep_minutes, kind_of: [String, Integer], default: 240

attribute :explicit_defaults_for_timestamp, kind_of: [FalseClass, TrueClass, NilClass], default: nil

attribute :innodb_flush_neighbor_pages, kind_of: [String, NilClass], default: nil
attribute :innodb_flush_neighbors, kind_of: [String, Integer, NilClass], default: nil

attribute :gtid_domain_id, kind_of: [String, Integer, NilClass], default: nil

# If default instance then symlink the mysql socket file to default location
attribute :default_instance, kind_of: [FalseClass, TrueClass], default: false

attribute :backup_data, kind_of: [FalseClass, TrueClass], default: false
attribute :backup_binlog, kind_of: [FalseClass, TrueClass], default: false
attribute :backup_host, kind_of: [String, NilClass], default: nil
attribute :backup_port, kind_of: [String, Integer, NilClass], default: 22
attribute :backup_user, kind_of: [String, NilClass], default: nil
attribute :backup_path, kind_of: [String, NilClass], default: nil
attribute :backup_hour, kind_of: [String, Integer, NilClass], default: nil
attribute :backup_minute, kind_of: [String, Integer, NilClass], default: nil

attribute :start_by_default, kind_of: [FalseClass, TrueClass], default: false

def initialize(*args)
  super
  @action = :create
end
