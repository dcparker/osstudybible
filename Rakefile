require 'fileutils'

if File.exists?('lib/cilantro.rb')
  require 'lib/cilantro'
  Cilantro.database_config 'config/linode.yml' if File.exists?('config/linode.yml')
  Cilantro.load_environment(:rake)
end

# Load any app level custom rakefile extensions from lib/tasks
tasks_path = File.join(File.dirname(__FILE__), "tasks")
rake_files = Dir["#{tasks_path}/*.rake"]
rake_files.each do |rake_file|
  begin
    load rake_file
  rescue LoadError
    warn "Could not load #{rake_file}"
  end
end

##############################################################################
# ADD YOUR CUSTOM TASKS IN /tasks
# NAME YOUR RAKE FILES file_name.rake
##############################################################################
