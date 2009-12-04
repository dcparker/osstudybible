# This is a fix, at least for the linode server install of mysql
module SQL
  module Mysql
    def create_table_statement(quoted_table_name)
      "CREATE TABLE #{quoted_table_name}"
    end
  end
end
