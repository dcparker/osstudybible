module Kernel
  def require_with_auto_install(name, options={})
    begin
      require name
    rescue LoadError
      puts `gem install -i gems #{"-v "+options[:version] if options[:version]} #{options[:gem] || name}`
      Gem.use_paths("#{APP_ROOT}/gems", ["#{APP_ROOT}/gems"])
      require name
    end
  end
end

module Cilantro
  def self.install_missing_gems
    gempath = "#{APP_ROOT}/gems"
    if File.exists?(gempath)
      # Redirect standard output to the netherworld
      no_debug = '2>&1 >/dev/null'

      all_gems = ""
      # Ensure each gem in gems/cache is installed
      Dir.glob("#{gempath}/cache/*.gem").each do |gem_name|
        gem_name = gem_name.match(/([^\/]+)\.gem/)[1]
        j, name, version = *gem_name.match(/^(.*)-([\d\.]+)$/)
        all_gems << "#{name} --version '#{version}'\n"
        if !File.exists?("#{gempath}/gems/#{gem_name}")
          puts "Installing gem: #{gem_name}"
          puts `gem pristine --config-file gems/gemrc.yml #{name} -v#{version}`
          # LEAVE THIS HERE FOR LATER REFERENCE - These two commands unpack gems folders.
          # `mkdir -p #{gempath}/gems/#{gem_name} #{no_debug}`
          # `tar -Oxf #{gempath}/cache/#{gem_name}.gem data.tar.gz | tar -zx -C #{gempath}/gems/#{gem_name}/ #{no_debug}`
        end
      end
      # Writes a .gems file for use on sites such as heroku, that auto-install your gems.
      open(".gems", 'w') {|f| f << all_gems }
    end
  end
end
