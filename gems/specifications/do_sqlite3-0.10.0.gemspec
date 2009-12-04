# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{do_sqlite3}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dirkjan Bussink"]
  s.date = %q{2009-09-15}
  s.description = %q{Implements the DataObjects API for Sqlite3}
  s.email = %q{d.bussink@gmail.com}
  s.extensions = ["ext/do_sqlite3_ext/extconf.rb"]
  s.files = ["lib/do_sqlite3/transaction.rb", "lib/do_sqlite3/version.rb", "lib/do_sqlite3.rb", "spec/command_spec.rb", "spec/connection_spec.rb", "spec/lib/rspec_immediate_feedback_formatter.rb", "spec/reader_spec.rb", "spec/result_spec.rb", "spec/spec_helper.rb", "spec/typecast/array_spec.rb", "spec/typecast/bigdecimal_spec.rb", "spec/typecast/boolean_spec.rb", "spec/typecast/byte_array_spec.rb", "spec/typecast/class_spec.rb", "spec/typecast/date_spec.rb", "spec/typecast/datetime_spec.rb", "spec/typecast/float_spec.rb", "spec/typecast/integer_spec.rb", "spec/typecast/nil_spec.rb", "spec/typecast/range_spec.rb", "spec/typecast/string_spec.rb", "spec/typecast/time_spec.rb", "tasks/gem.rake", "tasks/install.rake", "tasks/native.rake", "tasks/release.rake", "tasks/retrieve.rake", "tasks/spec.rake", "ext/do_sqlite3_ext/extconf.rb", "ext/do_sqlite3_ext/do_sqlite3_ext.c", "ext/do_sqlite3_ext/error.h", "LICENSE", "Rakefile", "HISTORY.markdown", "README.markdown", "Manifest.txt"]
  s.homepage = %q{http://github.com/datamapper/do}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dorb}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{DataObjects Sqlite3 Driver}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["~> 2.0"])
      s.add_runtime_dependency(%q<extlib>, ["~> 0.9.12"])
      s.add_runtime_dependency(%q<data_objects>, ["= 0.10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.2.0"])
    else
      s.add_dependency(%q<addressable>, ["~> 2.0"])
      s.add_dependency(%q<extlib>, ["~> 0.9.12"])
      s.add_dependency(%q<data_objects>, ["= 0.10.0"])
      s.add_dependency(%q<rspec>, ["~> 1.2.0"])
    end
  else
    s.add_dependency(%q<addressable>, ["~> 2.0"])
    s.add_dependency(%q<extlib>, ["~> 0.9.12"])
    s.add_dependency(%q<data_objects>, ["= 0.10.0"])
    s.add_dependency(%q<rspec>, ["~> 1.2.0"])
  end
end
