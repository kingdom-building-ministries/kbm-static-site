task :serve do
  if sh "bundle install"
    sh "bundle exec 'jekyll serve --watch'"
  end
end

task :build do
  sh "bundle exec 'jekyll build'"
end

task :debug do
  sh "bundle exec 'jekyll serve --watch --trace'"
end
