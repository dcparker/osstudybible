# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-migrations}
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Sadauskas"]
  s.date = %q{2009-09-30}
  s.description = %q{DataMapper plugin for writing and speccing migrations}
  s.email = ["psadauskas [a] gmail [d] com"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "TODO", "History.rdoc"]
  s.files = ["History.rdoc", "LICENSE", "Manifest.txt", "README.rdoc", "Rakefile", "TODO", "db/migrations/1_create_people_table.rb", "db/migrations/2_add_dob_to_people.rb", "db/migrations/config.rb", "examples/sample_migration.rb", "examples/sample_migration_spec.rb", "lib/dm-migrations.rb", "lib/dm-migrations/migration.rb", "lib/dm-migrations/migration_runner.rb", "lib/dm-migrations/sql.rb", "lib/dm-migrations/sql/column.rb", "lib/dm-migrations/sql/mysql.rb", "lib/dm-migrations/sql/postgresql.rb", "lib/dm-migrations/sql/sqlite3.rb", "lib/dm-migrations/sql/table.rb", "lib/dm-migrations/sql/table_creator.rb", "lib/dm-migrations/sql/table_modifier.rb", "lib/dm-migrations/version.rb", "lib/spec/example/migration_example_group.rb", "lib/spec/matchers/migration_matchers.rb", "spec/integration/migration_runner_spec.rb", "spec/integration/migration_spec.rb", "spec/integration/sql_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/unit/migration_spec.rb", "spec/unit/sql/column_spec.rb", "spec/unit/sql/postgresql_spec.rb", "spec/unit/sql/sqlite3_extensions_spec.rb", "spec/unit/sql/table_creator_spec.rb", "spec/unit/sql/table_modifier_spec.rb", "spec/unit/sql/table_spec.rb", "spec/unit/sql_spec.rb", "tasks/db.rb", "tasks/install.rb", "tasks/spec.rb"]
  s.homepage = %q{http://github.com/datamapper/dm-more/tree/master/dm-migrations}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{DataMapper plugin for writing and speccing migrations}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["= 0.10.1"])
    else
      s.add_dependency(%q<dm-core>, ["= 0.10.1"])
    end
  else
    s.add_dependency(%q<dm-core>, ["= 0.10.1"])
  end
end
