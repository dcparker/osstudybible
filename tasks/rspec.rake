require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts << '--color' # adds color to `rake`
end

# Run specs by default.
task :default => :spec
