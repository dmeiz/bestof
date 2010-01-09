set :application, "bestof"
set :repository,  "git@github.com:dmeiz/bestof.git"
set :scm, "git"
set :user, "dev"
set :branch, "master"

role :app, "bestof.methodhead.com"
role :web, "bestof.methodhead.com"
role :db, "betagrove.com", :primary => true

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
