load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, "bestof"
set :repository,  "git://github.com/dmeiz/bestof.git"
set :scm, "git"
set :user, "dev"
set :branch, "master"

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
end
