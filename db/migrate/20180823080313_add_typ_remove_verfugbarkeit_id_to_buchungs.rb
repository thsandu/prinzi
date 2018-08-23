class AddTypRemoveVerfugbarkeitIdToBuchungs < ActiveRecord::Migration[5.2]
  def change
    add_column :buchungs, :typ, :string, null: false, default: 'standard'
    remove_foreign_key :buchungs, :verfugbarkeits
    remove_column :buchungs, :verfugbarkeit_id
  end

  def down
    remove_column :buchungs, :typ, :string
    add_column :buchungs, :verfugbarkeit_id
    add_foreign_key :buchungs, :verfugbarkeits
  end

end
