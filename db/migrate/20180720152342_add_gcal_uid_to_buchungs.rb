class AddGcalUidToBuchungs < ActiveRecord::Migration[5.2]
  def change
    add_column :buchungs, :gcal_uid, :string
  end
end
