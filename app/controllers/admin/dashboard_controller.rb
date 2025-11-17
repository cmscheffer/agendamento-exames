class Admin::DashboardController < Admin::BaseController
  def index
    @total_solicitantes = Solicitante.count
    @total_agendamentos = Agendamento.count
    @agendamentos_recentes = Agendamento.recentes.limit(10)
  end
end