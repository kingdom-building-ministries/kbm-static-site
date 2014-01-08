task :serve do
  if sh "bundle install"
    sh "bundle exec 'jekyll serve --config _config.yml,_staging_config.yml --watch'"
  end
end

task :build do
  sh "bundle exec 'jekyll build'"
end

task :debug do
  sh "bundle exec 'jekyll serve --watch --trace'"
end

task :stage do
  sh "bundle exec 'jekyll build --config _config.yml,_staging_config.yml --trace'"
end

task :deploy do
  sh "bundle exec 'jekyll build --config _config.yml,_deploy_config.yml --trace'"
end
