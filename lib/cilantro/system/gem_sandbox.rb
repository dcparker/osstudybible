# File: sandbox_gems.rb
#
# Discription:
# Sandboxes the local gems folder.

APP_ROOT = File.expand_path(Dir.pwd) unless defined?(APP_ROOT)

require 'rubygems'
require 'rubygems/custom_require'
require File.dirname(__FILE__) + '/install_missing_gems'

module Kernel
  def require_with_auto_install(name, options={})
    require name
  end
end

if File.exists?("#{APP_ROOT}/gems") && File.writable?("#{APP_ROOT}/gems")
  # Oh but first, go ahead and install any missing gems (PLEASE, only include gems/specifications and gems/cache in your git repo)
    Cilantro.install_missing_gems
  Gem.use_paths("#{APP_ROOT}/gems", ["#{APP_ROOT}/gems"])
end
