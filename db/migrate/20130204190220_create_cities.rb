class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.string :lat, null: false
      t.string :lng, null: false
    end
  end
end
