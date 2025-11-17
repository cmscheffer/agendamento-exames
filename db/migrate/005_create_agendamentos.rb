class CreateAgendamentos < ActiveRecord::Migration[6.1]
  def change
    create_table :agendamentos do |t|
      t.string :cidade_agendamento, null: false
      t.date :data_preferencia, null: false
      t.string :nome_colaborador, null: false
      t.date :data_nascimento, null: false
      t.string :cpf_colaborador, null: false
      t.string :n_ccu, null: false
      t.string :funcao, null: false
      t.integer :tipo_consulta, null: false
      t.string :outro_tipo
      t.string :matricula
      t.boolean :matricula_nao_registrada, default: false
      t.text :observacoes
      t.references :solicitante, null: false, foreign_key: true
      t.references :unidade, null: false, foreign_key: true
      t.references :cnpj, null: false, foreign_key: true
      t.timestamps
    end

    add_index :agendamentos, :solicitante_id
    add_index :agendamentos, :data_preferencia
  end
end