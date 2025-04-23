class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.date :date_of_birth
      t.string :gender
      t.string :phone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
