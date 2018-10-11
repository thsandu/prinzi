class ChangeTypOfBuchungs < ActiveRecord::Migration[5.2]
  def change
    change_column_default :buchungs, :typ, from: 'standard', to: nil
    change_column :buchungs, :typ, 'integer USING status::integer', default: 0, null: false
  end
end
