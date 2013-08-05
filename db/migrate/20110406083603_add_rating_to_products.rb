class AddRatingToProducts < ActiveRecord::Migration
  def self.up
    if table_exists?('variants')
      add_column :variants, :avg_rating, :decimal, :default => 0.0, :null => false, :precision => 7, :scale => 5
      add_column :variants, :reviews_count, :integer, :default => 0, :null => false
    elsif table_exists?('spree_variants')
      add_column :spree_variants, :avg_rating, :decimal, :default => 0.0, :null => false, :precision => 7, :scale => 5
      add_column :spree_variants, :reviews_count, :integer, :default => 0, :null => false
    end
  end

  def self.down
    if table_exists?('variants')
      remove_column :variants, :reviews_count
      remove_column :variants, :avg_rating
    elsif table_exists?('spree_variants')
      remove_column :spree_variants, :reviews_count
      remove_column :spree_variants, :avg_rating
    end
  end
end
