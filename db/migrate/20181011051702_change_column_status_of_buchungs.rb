class ChangeColumnStatusOfBuchungs < ActiveRecord::Migration[5.2]
  def change
    change_column :buchungs, :status, 'integer USING status::integer', default: 0, null: false
  end
end
