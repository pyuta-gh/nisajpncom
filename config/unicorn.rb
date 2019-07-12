application = "rails_root"
 
worker_processes = 2
working_directory "/home/naritam/#{application}"
 
listen "/var/run/unicorn/unicorn_#{application}.sock"
pid "/var/run/unicorn/unicorn_#{application}.pid"

stderr_path "/home/naritam/#{application}/log/unicorn.stderr.log"
stdout_path "/home/naritam/#{application}/log/unicorn.stdout.log"
 
preload_app true
