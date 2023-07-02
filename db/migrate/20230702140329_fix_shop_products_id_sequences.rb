class FixShopProductsIdSequences < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER SEQUENCE shops_id_seq RENAME TO shops_numeric_id_seq;
      ALTER TABLE shops ALTER COLUMN numeric_id SET DEFAULT nextval('shops_numeric_id_seq');
      ALTER SEQUENCE products_id_seq RENAME TO products_numeric_id_seq;
      ALTER TABLE products ALTER COLUMN numeric_id SET DEFAULT nextval('products_numeric_id_seq');
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE shops_numeric_id_seq RENAME TO shops_id_seq;
      ALTER TABLE shops ALTER COLUMN numeric_id SET DEFAULT nextval('shops_id_seq');
      ALTER SEQUENCE products_numeric_id_seq RENAME TO products_id_seq;
      ALTER TABLE products ALTER COLUMN numeric_id SET DEFAULT nextval('products_id_seq');
    SQL
  end
end
