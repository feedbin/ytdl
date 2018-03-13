lock "3.10.1"

set :branch, "master"

set :application, "ytdl"
set :repo_url, "git@github.com:feedbin/#{fetch(:application)}.git"
set :deploy_to, "/srv/apps/#{fetch(:application)}"
set :log_level, :warn

append :linked_dirs, "env"

namespace :app do

  desc "Start processes"
  task :start do
    on roles(:app) do |host|
      within release_path do
        execute :sudo, :systemctl, :start, "ytdl.target"
      end
    end
  end

  desc "Stop processes"
  task :stop do
    on roles(:app) do |host|
      within release_path do
        execute :sudo, :systemctl, :stop, "ytdl.target"
      end
    end
  end

  desc "Restart processes"
  task :restart do
    on roles(:app) do |host|
      within release_path do
        execute :sudo, :systemctl, :restart, "ytdl.target"
      end
    end
  end

  desc "Bootstrap app"
  task :bootstrap do
    on roles(:app) do
      within release_path do
        execute "script/bootstrap.sh"
      end
    end
  end

  desc "Export systemd"
  task :export do
    on roles(:app) do
      within current_path do
        execute :sudo, "/usr/local/rbenv/shims/foreman", :export, :systemd, "/etc/systemd/system", "--user app", "--root #{fetch(:deploy_to)}/current"
        execute :sudo, :systemctl, "daemon-reload"
        execute :sudo, :systemctl, :enable, "ytdl.target"
      end
    end
  end

end

after "deploy:updated", "app:bootstrap"
after "deploy:published", "app:export"
after "app:export", "app:restart"