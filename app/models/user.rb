class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { solicitante: 0, admin: 1 }

  has_many :agendamentos, dependent: :destroy
  has_many :solicitantes, dependent: :destroy

  validates :nome, presence: true
  validates :role, presence: true

  def admin?
    role == 'admin'
  end

  def solicitante?
    role == 'solicitante'
  end
end