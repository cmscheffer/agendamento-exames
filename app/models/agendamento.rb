class Agendamento < ApplicationRecord
  belongs_to :solicitante
  belongs_to :unidade
  belongs_to :cnpj

  enum tipo_consulta: {
    admissional: 0,
    demissional: 1,
    periodico: 2,
    retorno_trabalho: 3,
    mudanca_funcao: 4,
    outro: 5
  }

  validates :cidade_agendamento, presence: true
  validates :nome_colaborador, presence: true
  validates :data_nascimento, presence: true
  validates :cpf_colaborador, presence: true
  validates :n_ccu, presence: true
  validates :funcao, presence: true
  validates :tipo_consulta, presence: true
  validates :data_preferencia, presence: true
  validates :solicitante_id, presence: true
  validates :unidade_id, presence: true
  validates :cnpj_id, presence: true

  validate :validar_cpf_colaborador
  validate :data_nascimento_valida
  validate :data_preferencia_valida

  scope :por_solicitante, ->(solicitante_id) { where(solicitante_id: solicitante_id) }
  scope :recentes, -> { order(created_at: :desc) }

  def nome_tipo_consulta
    return outro_tipo if outro? && outro_tipo.present?
    I18n.t("activerecord.attributes.agendamento.tipos.#{tipo_consulta}")
  end

  private

  def validar_cpf_colaborador
    errors.add(:cpf_colaborador, 'inválido') unless CPF.valid?(cpf_colaborador)
  end

  def data_nascimento_valida
    return unless data_nascimento.present?
    
    if data_nascimento > Date.current
      errors.add(:data_nascimento, 'não pode ser futura')
    end
    
    if data_nascimento < 100.years.ago
      errors.add(:data_nascimento, 'parece inválida')
    end
  end

  def data_preferencia_valida
    return unless data_preferencia.present?
    
    if data_preferencia < Date.current
      errors.add(:data_preferencia, 'não pode ser passada')
    end
    
    if data_preferencia > 1.year.from_now
      errors.add(:data_preferencia, 'muito distante')
    end
  end
end