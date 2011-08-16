require 'rake/testtask'
require 'rcov/rcovtask'

task :default_rcov_params_for_units do  
  RCOV_PARAMS = ENV['RCOV_PARAMS'] = "--sort=coverage"  
  SHOW_ONLY = ENV['SHOW_ONLY'] = "lib/mobile_helpers.rb"  
end

task :default_rcov do
  puts "Executing rcov..."
  FileUtils::rm_rf 'coverage'
  command = "rcov --exclude 'Gems/*,gems/*' lib/*"
  puts command
  `#{command}`
end

desc 'RCov code coverage'
task :rcov => [ :default_rcov_params_for_units, :default_rcov ]

Rake::TestTask.new do |i|
  i.test_files = FileList['tests/*_test.rb']
  i.verbose = true
end
