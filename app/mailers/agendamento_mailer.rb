class AgendamentoMailer < ApplicationMailer
  default from: 'sistema@examesocupacionais.com.br'

  def novo_agendamento(agendamento)
    @agendamento = agendamento
    @solicitante = agendamento.solicitante
    
    mail(
      to: @solicitante.email,
      subject: "Confirmação de Agendamento - Exame Ocupacional ##{agendamento.id}"
    )
  end

  def agendamento_admin(agendamento)
    @agendamento = agendamento
    
    # Enviar para email do administrador
    mail(
      to: Rails.application.credentials.admin_email || 'admin@empresa.com.br',
      subject: "Novo Agendamento Solicitado ##{agendamento.id}"
    )
  end
end