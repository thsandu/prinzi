class CreateVerfugbarkeits < ActiveRecord::Migration[5.2]
  def change
    create_table :verfugbarkeits do |t|
      t.timestamp :tag, null: false

      t.timestamps
    end
  end

  def down
    drop_table :verfugbarkeits
  end

end
