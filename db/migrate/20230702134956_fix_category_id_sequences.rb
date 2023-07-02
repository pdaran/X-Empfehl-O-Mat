class FixIdSequences < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER SEQUENCE categories_id_seq RENAME TO categories_numeric_id_seq;
      ALTER TABLE categories ALTER COLUMN numeric_id SET DEFAULT nextval('categories_numeric_id_seq');
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE categories_numeric_id_seq RENAME TO categories_id_seq;
      ALTER TABLE categories ALTER COLUMN numeric_id SET DEFAULT nextval('categories_id_seq');
    SQL
  end

end
