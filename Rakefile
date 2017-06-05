desc "Run continuous integration tasks (build and deploy)"
task :ci do
  sh "bundle exec middleman build --clean"
  sh "bundle exec middleman deploy"
end
