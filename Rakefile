task :default => "spec"


module TaskUtils
  extend self

  def run_tests(path)
    system("cd #{path} && bundle exec rake spec")
  end

  def build(path)
    system("cd #{path} && rake build")
  end

  def install_deps(path)
    system("cd #{path} && bundle")
  end

  def each_gem(action, paths = all_paths, &block)
    all_paths.each do |path|
      puts action
      name = File.basename(path)
      block.call(name, path)
    end
  end

  def all_paths
    Dir[File.join(File.dirname(__FILE__), 'muzang-*')]
  end

end

namespace :dependencies do
  desc "Install all dependencies"
  task :install do
    TaskUtils.each_gem("Installing dependencies...") do |name, path|
      puts name
      TaskUtils.install_deps(path)
    end
  end
end

namespace :build do
  desc "Builds all gems"
  task :all do
    TaskUtils.each_gem("Building...") do |name, path|
      puts name
      TaskUtils.build(path)
    end
  end
end

desc "Run all DRUG-bot tests"
task :spec do
  TaskUtils.each_gem("Running tests...") do |name, path|
    puts name
    TaskUtils.run_tests(path)
  end
end
