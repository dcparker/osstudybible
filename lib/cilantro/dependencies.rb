require 'rubygems'
require 'rubygems/custom_require'

module Cilantro
  class << self
    def gems
      @gems ||= {}
    end

    def add_gem(name, options)
      if gems[name]
        gems[name].merge!(options)
      else
        gems[name] = options
      end
      if RACK_ENV == :development
        open(".gems", 'w') do |f|
          gems.keys.sort.each do |name|
            options = gems[name]
            puts "Gem #{name} #{options.inspect}"
            next if options[:only_env] == :development
            gem_def = name.dup
            gem_def << " --version '#{options[:version]}'" if options[:version]
            f << gem_def << "\n"
          end
        end
      end
    end

    def install_missing_gems
      gempath = "#{APP_ROOT}/gems"
      if File.exists?(gempath)
        # Redirect standard output to the netherworld
        no_debug = '2>&1 >/dev/null'

        all_gems = ""
        # Ensure each gem in gems/cache is installed
        Dir.glob("#{gempath}/cache/*.gem").each do |gem_name|
          gem_name = gem_name.match(/([^\/]+)\.gem/)[1]
          j, name, version = *gem_name.match(/^(.*)-([\d\.]+)$/)
          Cilantro.add_gem(name, :version => version)
          if !File.exists?("#{gempath}/gems/#{gem_name}")
            puts "Installing gem: #{gem_name}"
            puts `gem pristine --config-file gems/gemrc.yml #{name} -v#{version}`
            # LEAVE THIS HERE FOR LATER REFERENCE - These two commands unpack gems folders. Might be quicker than gem pristine? (but doesn't compile any gem binary libraries)
            # `mkdir -p #{gempath}/gems/#{gem_name} #{no_debug}`
            # `tar -Oxf #{gempath}/cache/#{gem_name}.gem data.tar.gz | tar -zx -C #{gempath}/gems/#{gem_name}/ #{no_debug}`
          end
        end
      end
    end
  end
end

# 2. Each dependency should:
#   a) Require the dependency.
#   b) If not installed and is possible to install, INSTALL IT.
#   c) If in development, and dependency is needed in production, write itself to .gems.
module Kernel
  def dependency(name, options={})
    options[:only_env] = options[:env]
    options[:env] = RACK_ENV unless options[:env]
    if options[:env] == RACK_ENV
      begin
        require name
      rescue LoadError
        if File.directory?("#{APP_ROOT}/gems") && File.writable?("#{APP_ROOT}/gems")
          puts "Installing #{options[:gem] || name}#{" -v "+options[:version] if options[:version]}..."
          puts `gem install -i gems #{"-v "+options[:version] if options[:version]} #{options[:gem] || name}`
          Gem.use_paths("#{APP_ROOT}/gems", ["#{APP_ROOT}/gems"])
          require name
        else
          raise
        end
      end
    end
    Cilantro.add_gem(options[:gem] || name, options)
  end
end

# 1. Sandbox Rubygems
APP_ROOT = File.expand_path(Dir.pwd) unless defined?(APP_ROOT)

if File.directory?("#{APP_ROOT}/gems") && File.writable?("#{APP_ROOT}/gems")
  # Oh but first, go ahead and install any missing gems (PLEASE, only include gems/specifications and gems/cache in your git repo)
    Cilantro.install_missing_gems
  Gem.use_paths("#{APP_ROOT}/gems", ["#{APP_ROOT}/gems"])
end
