class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.references :dest, null: false, foreign_key: { to_table: "users" }, index: true

      t.references :mparent, null: true, foreign_key: { to_table: "messages" }, index: true
      t.references :mroot, null: true, foreign_key: { to_table: "messages" }, index: true

      t.boolean :is_public, null: false, default: true

      t.timestamps
    end
  end
end
