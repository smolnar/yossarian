require 'rvm/capistrano'
require 'bundler/capistrano'
require 'whenever/capistrano'

set :stages, [:staging, :production]

require 'capistrano/ext/multistage'

set :application,    'yossarian'
set :scm,            :git
set :repository,     'git@github.com:smolnar/yossarian.git'
set :scm_passphrase, ''
set :user,           'deploy'
set(:deploy_to)      { "/home/deploy/projects/#{application}-#{rails_env}" }

set :use_sudo, false

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, 'read-only'       # more info: rvm help autolibs

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :ssh_options, { forward_agent: true }

# Whenever
set :whenever_command, "RAILS_ENV=#{rails_env} bundle exec whenever"

default_run_options[:pty] = true

namespace :db do
  desc "Creates DB"
  task :create, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
  end

  desc "Sets up current DB for this environment"
  task :setup, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:setup"
  end

  desc "Drops DB for this environment"
  task :drop, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:drop"
  end

  desc "Migrates DB during release"
  task :create_release, roles: :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
  end

  desc "Sets up DB during deployment of release for this environment"
  task :setup_release, roles: :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:setup"
  end

  desc "Run database seeds"
  task :seed do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end
end

namespace :sidekiq do
  desc "Run Sidekiq"
  task :start, roles: :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec sidekiq -d -q artists,events,youtube -L #{shared_path}/log/sidekiq.log -P #{shared_path}/sidekiq.pid"
  end

  desc "Kill Sidekiq"
  task :stop, roles: :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec sidekiqctl stop #{shared_path}/sidekiq.pid 60"
  end
end

namespace :deploy do
  [:start, :stop, :restart, :upgrade].each do |command|
    desc "#{command.to_s.capitalize} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn-#{application}-#{rails_env} #{command}"
    end
  end

  desc "Symlink shared"
  task :symlink_shared, roles: :app do
    run "ln -nfs #{shared_path} #{release_path}/shared"
    run "for file in #{shared_path}/config/*.yml; do ln -nfs $file #{release_path}/config; done"
    run "for file in #{shared_path}/public/*; do ln -nfs $file #{release_path}/public; done"
  end

  after 'deploy',             'deploy:cleanup'
  after 'deploy:update_code', 'deploy:symlink_shared', 'db:create_release', 'deploy:migrate'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end
