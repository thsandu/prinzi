class RemoveGcalIdFromBuchungs < ActiveRecord::Migration[5.2]
  def change
    remove_column :buchungs, :gcal_id, :string
    add_column :verfugbarkeits, :gcal_id, :string
  end
end
