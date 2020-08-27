# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in the Gemfile

require "capistrano/rails"
require "capistrano/rbenv"
require "capistrano/passenger"
set :rbenv_type, :user
set :rbenv_ruby, '2.7.0'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

