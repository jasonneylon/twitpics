raise "Edit config before deploy"
set :application,         ""
set :repository,          "" 
set :domain,              ""

set :deploy_to,           "/var/www/#{application}"
set :repository_cache,    "#{application}_cache"
set :environment,         "production"
  
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :branch, "master"
set :keep_releases,       3
set :user,                "deploy"
set :deploy_via,          :remote_cache
set :scm,                 :git
set :runner,              "deploy"
ssh_options[:forward_agent] = true
set :use_sudo,               false

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

namespace :deploy do
  task(:start) {}
  task(:stop) {}

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Install gems"
  task :install_gems do
    sudo "/usr/local/bin/geminstaller -c #{current_path}/config/geminstaller.yml"
  end
  
end

before 'deploy:restart', 'deploy:install_gems'
after 'deploy:symlink', 'deploy:cleanup'

