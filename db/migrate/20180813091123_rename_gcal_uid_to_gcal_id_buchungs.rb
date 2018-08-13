class RenameGcalUidToGcalIdBuchungs < ActiveRecord::Migration[5.2]
  def change
    rename_column :buchungs, :gcal_uid, :gcal_id
  end

  def down
    rename_column :buchungs, :gcal_id, :gcal_uid
  end
end
