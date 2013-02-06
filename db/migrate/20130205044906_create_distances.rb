class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.integer :city_id, null: false
      t.integer :destination_id, null: false
      t.integer :value, null: false
    end
  end
end
