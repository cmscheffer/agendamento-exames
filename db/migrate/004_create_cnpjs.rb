class CreateCnpjs < ActiveRecord::Migration[6.1]
  def change
    create_table :cnpjs do |t|
      t.string :numero, null: false
      t.string :razao_social, null: false
      t.text :descricao, null: false
      t.string :endereco
      t.timestamps
    end

    add_index :cnpjs, :numero, unique: true
  end
end