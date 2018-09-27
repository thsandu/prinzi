class ChangeStartEndeFromVerfugbarkeits < ActiveRecord::Migration[5.2]
  def change
    change_column_default :verfugbarkeits, :start, nil
    change_column_default :verfugbarkeits, :ende, nil
  end
end
