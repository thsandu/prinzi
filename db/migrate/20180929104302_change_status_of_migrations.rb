class ChangeStatusOfMigrations < ActiveRecord::Migration[5.2]
  def change
    change_column_default :verfugbarkeits, :status, nil

    Verfugbarkeit.where(status: "verfügbar").update_all(status: 0)
    Verfugbarkeit.where(status: "abwesend").update_all(status: 1)
    Verfugbarkeit.where(status: "fragen").update_all(status: 2)

    change_column :verfugbarkeits, :status, 'integer USING status::integer', default: 0, null: false
  end
end
