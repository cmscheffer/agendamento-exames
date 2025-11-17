class CreateSolicitantes < ActiveRecord::Migration[6.1]
  def change
    create_table :solicitantes do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :telefone, null: false
      t.string :empresa
      t.string :cargo
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :solicitantes, :email, unique: true
  end
end