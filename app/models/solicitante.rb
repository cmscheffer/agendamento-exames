class Solicitante < ApplicationRecord
  belongs_to :user
  has_many :agendamentos, dependent: :destroy

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :telefone, presence: true
  validates :user_id, presence: true

  def nome_completo
    "#{nome} - #{email}"
  end
end