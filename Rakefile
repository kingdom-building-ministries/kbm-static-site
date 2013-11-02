task :serve do
  if sh "bundle install"
    sh "bundle exec 'jekyll serve --watch --trace'"
  end
end

task :build do
  sh "bundle exec 'jekyll build'"
end
