class Cnpj < ApplicationRecord
  has_many :agendamentos, dependent: :destroy

  validates :numero, presence: true, uniqueness: true
  validates :razao_social, presence: true
  validates :descricao, presence: true

  validate :validar_cnpj

  def numero_formatado
    CNPJ.new(numero).formatted
  end

  private

  def validar_cnpj
    errors.add(:numero, 'inválido') unless CNPJ.valid?(numero)
  end
end