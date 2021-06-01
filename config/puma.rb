# frozen_string_literal: true

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch('RAILS_ENV', 'development')
environment rails_env
port        ENV.fetch('PORT', 3000)

unless rails_env == 'production'
  pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')
  plugin :tmp_restart
end
