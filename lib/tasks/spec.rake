# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'
namespace :spec do
  desc 'Execute rubocop -DR'
  RuboCop::RakeTask.new(:rubocop) do |tsk|
    tsk.options = ['-DR'] # Rails, display cop name
    tsk.fail_on_error = false
  end
end
Rake::Task[:spec].enhance do
  Rake::Task['spec:rubocop'].invoke
end
