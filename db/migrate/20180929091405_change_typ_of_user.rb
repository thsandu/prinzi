class ChangeTypOfUser < ActiveRecord::Migration[5.2]
  def change
    User.where(typ: 'Administrator').update_all(typ: 0)
    User.where(typ: 'Mitarbeiter').update_all(typ: 1)

    change_column :users, :typ, 'integer USING typ::integer', null: false
  end
end
