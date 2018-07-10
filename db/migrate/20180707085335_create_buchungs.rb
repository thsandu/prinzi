class CreateBuchungs < ActiveRecord::Migration[5.2]
  def change
    create_table :buchungs do |t|
      t.string :status, null: false
      t.timestamp :start, null: false
      t.timestamp :ende, null: false
      t.belongs_to :verfugbarkeit, foreign_key: true

      t.timestamps
    end

    def down
      drop_table :buchungs
    end
  end
end
