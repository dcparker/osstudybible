# Purpose:
# Watches the file system for changes
#
# Usage:
# > require 'file_monitor'
# > file_spy = FileMonitor.new
# > file_spy.add(Dir.pwd) do |i|
# >   puts "you probably should handle the change in #{i.file}"
# > end
# > file_spy.spawn

require 'digest/md5'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
module HashAccess
  def method_missing(mth, *args)
    return args.empty? ? self[mth] : self[mth.to_s.chomp('=').to_sym]=args.first
  end
end

class FileMonitor
  VERSION = '0.0.1'
  attr_accessor :spawns
  def initialize()
    @watched = []
  end

  def add(item, &callback)
    if File.file? item
      h = {:file=>File.expand_path(item), :callback=>callback}
      h.extend(HashAccess)
      @watched << h
    elsif File.directory? item
      files_recursive(item).each {|f| add(f, &callback) }
    end
  end

  def changes?
    return first_changed
  end

  def process
    # iterates watched files and runs callbacks when changes are detected.
    @watched.each do |i|
      key = digest(i.file)
      i.digest = key if i.digest.nil?  # skip first change detection, its always unknown on first run
      update(i, key) unless i.digest == key
    end
  end

  def watching
    # Returns an Array of files being watched
    @watched
  end

  def monitor(interval = 1)
    trap("INT") do 
      STDERR.puts "  Interrupted by Control-C"
      exit 2
    end

    while true
      process
      sleep interval
    end
  end

  def spawn(interval = 1)
    if @spawns.nil? 
      @spawns = fork {monitor interval}
      Process.detach(@spawns)
      Kernel.at_exit do
        Process.kill('HUP', @spawns)
        @spawns = nil
      end
      true
    else
      @spawns
    end
    @spawns ||= []
  end
private
  def update(item, key)
    item.callback.call(item) unless item.callback.nil?
    item.digest= key
  end

  def first_changed
    # returns first changed item or false
    @watched.each {|i| return i if changed? i}
    false
  end

  def changed?(item)
    # returns md5 if changed, returns false when not changed
    md5 = digest(item.file) 
    md5 == item.digest ? false : md5
  end

  def digest(file)
    # # returns the md5 of a file
    # Digest::MD5.hexdigest( File.read(file) )
    # returns the last-modified date of a file
    File.mtime(file)
  end

  def files_recursive(dirname)
    # return an array of files from this (dirname) point forth.
    Dir["#{dirname}/**/**"].collect {|f| f if File.file? f }.compact
  end
end