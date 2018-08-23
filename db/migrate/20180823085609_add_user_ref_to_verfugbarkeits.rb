class AddUserRefToVerfugbarkeits < ActiveRecord::Migration[5.2]
  def change
    add_reference :verfugbarkeits, :user, foreign_key: true
  end
end
