require 'dm-types'
include DataMapper::Types

migration 1, :create_posts do
  up do
    create_table :posts do
      column :id, Serial
      column :title, String
      column :body, Text
      column :created_at, DateTime
    end
  end

  down do
    drop_table :posts
  end
end
