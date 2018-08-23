class AddStatusToVerfugbarkeits < ActiveRecord::Migration[5.2]
  def change
    add_column :verfugbarkeits, :status, :string, null: false, default: 'verfügbar'
    add_column :verfugbarkeits, :start, :datetime, null: false, default: Time.now
    add_column :verfugbarkeits, :ende, :datetime, null: false, default: Time.now
    remove_column :verfugbarkeits, :tag, :datetime
  end

  def down
    remove_column :verfugbarkeits, :status, :string
    remove_column :verfugbarkeits, :start, :datetime
    remove_column :verfugbarkeits, :ende, :datetime
    add_column :verfugbarkeits, :tag, :datetime
  end
end
