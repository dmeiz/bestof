load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, "bestof"
set :repository,  "git://github.com/dmeiz/bestof.git"
set :scm, "git"
set :user, "dev"
set :branch, "master"
set :deploy_via, :remote_cache

role :app, "bestof.methodhead.com"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)
    run "ln -s #{shared_path}/mp3s #{latest_release}/public/mp3s"
  end
end
