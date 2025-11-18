# Puma configuration file

# The directory to operate out of
directory '/home/seu_usuario/agendamento-exames'

# Set the environment
environment ENV.fetch('RAILS_ENV', 'production')

# Daemonize the server
daemonize false

# Number of worker processes
workers ENV.fetch('WEB_CONCURRENCY', 2).to_i

# Min and max threads per worker
threads_count = ENV.fetch('RAILS_MAX_THREADS', 5).to_i
threads threads_count, threads_count

# Port and bind
port ENV.fetch('PORT', 3000)
bind "tcp://127.0.0.1:#{ENV.fetch('PORT', 3000)}"

# Puma PID file and state
pidfile '/home/seu_usuario/agendamento-exames/tmp/pids/puma.pid'
state_path '/home/seu_usuario/agendamento-exames/tmp/pids/puma.state'

# Logging
stdout_redirect '/home/seu_usuario/agendamento-exames/log/puma.stdout.log',
                '/home/seu_usuario/agendamento-exames/log/puma.stderr.log',
                true

# Preload application for better performance
preload_app!

# Allow puma to be restarted by `rails restart` command
plugin :tmp_restart

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end