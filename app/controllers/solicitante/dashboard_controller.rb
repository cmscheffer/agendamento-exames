class Solicitante::DashboardController < Solicitante::BaseController
  def index
    @meus_agendamentos = current_user.agendamentos.recentes
    @total_agendamentos = current_user.agendamentos.count
  end
end