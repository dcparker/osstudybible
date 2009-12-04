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
        Cilantro.add_gem(name, :version => version)
        if !File.exists?("#{gempath}/gems/#{gem_name}")
          puts "Installing gem: #{gem_name}"
          puts `gem pristine --config-file gems/gemrc.yml #{name} -v#{version}`
          # LEAVE THIS HERE FOR LATER REFERENCE - These two commands unpack gems folders.
          # `mkdir -p #{gempath}/gems/#{gem_name} #{no_debug}`
          # `tar -Oxf #{gempath}/cache/#{gem_name}.gem data.tar.gz | tar -zx -C #{gempath}/gems/#{gem_name}/ #{no_debug}`
        end
      end
      # Writes a .gems file for use on sites such as heroku, that auto-install your gems.
      # Cilantro.add_gem(name, options)
    end
  end
end
