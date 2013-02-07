class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :lat, null: false
      t.string :lng, null: false
    end
  end
end
