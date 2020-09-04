class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :brand
      t.float :price
      t.text :description
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
