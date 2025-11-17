class Unidade < ApplicationRecord
  has_many :agendamentos, dependent: :destroy

  validates :nome, presence: true, uniqueness: true
  validates :cidade, presence: true
  validates :estado, presence: true

  def nome_completo
    "#{nome} - #{cidade}/#{estado}"
  end
end