# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake/dsl_definition'
require 'rake'

Myunischedule::Application.load_tasks

namespace :users do
  
  desc "Get number of users"
  task :count => :environment do
    
    puts "User Count: #{User.all.count}"
    
  end
  
end