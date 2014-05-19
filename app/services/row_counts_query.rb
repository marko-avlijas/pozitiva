class RowCountsQuery
  class << self
    def total
      sum_query.flatten.first #.each_with_object(Hash.new) do |row, grid|
        # grid[row['row']] ||= {}
        # grid[row['row']][row['col']] = row['c']
      # end
    end
    
    def count_per_table
      table_names = ["offers", "offer_items", "orders", "order_items", "users", "groups", "deliveries", "group_offerings", "locations"]
      
      table_names.map do |table| 
        [table, ActiveRecord::Base.connection.select_rows("select count(id) from #{table};").flatten.first]
      end
    end
 
    private

      def count_query
        ActiveRecord::Base.connection.execute <<-SQL.squish
          CREATE OR REPLACE FUNCTION count_em_all () RETURNS SETOF table_count  AS '
          DECLARE 
             the_count RECORD; 
             t_name RECORD; 
             r table_count%ROWTYPE; 
          
          BEGIN
             FOR t_name IN 
                 SELECT 
                     c.relname
                 FROM
                     pg_catalog.pg_class c LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                 WHERE 
                     c.relkind = ''r''
                     AND n.nspname = ''public'' 
                 ORDER BY 1 
                 LOOP
                     FOR the_count IN EXECUTE ''SELECT COUNT(*) AS "count" FROM '' || t_name.relname 
                     LOOP 
                     END LOOP; 
          
                     r.table_name := t_name.relname; 
                     r.num_rows := the_count.count; 
                     RETURN NEXT r; 
                 END LOOP; 
                 RETURN; 
          END;
          ' LANGUAGE plpgsql;
          SQL

        ActiveRecord::Base.connection.select_rows "select count_em_all();"
      end

      def sum_query
        ActiveRecord::Base.connection.select_rows <<-SQL.squish
        SELECT sum(reltuples) from pg_class where relname IN (SELECT c.relname
         FROM pg_catalog.pg_class c
         LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
         WHERE c.relkind = 'r'
         AND n.nspname <> 'pg_catalog'
         AND n.nspname <> 'information_schema'
         AND n.nspname !~ '^pg_toast'
         AND pg_catalog.pg_table_is_visible(c.oid));
        SQL
      end
  end
end