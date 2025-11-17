class CreateUnidades < ActiveRecord::Migration[6.1]
  def change
    create_table :unidades do |t|
      t.string :nome, null: false
      t.string :cidade, null: false
      t.string :estado, null: false
      t.string :endereco
      t.string :telefone
      t.timestamps
    end

    add_index :unidades, :nome, unique: true
  end
end