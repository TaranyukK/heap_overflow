class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
