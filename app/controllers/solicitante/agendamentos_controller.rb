class Solicitante::AgendamentosController < Solicitante::BaseController
  before_action :set_agendamento, only: [:show, :edit, :update, :destroy]

  def index
    @agendamentos = current_user.agendamentos.recentes
  end

  def show
  end

  def new
    @agendamento = Agendamento.new
    @unidades = Unidade.order(:nome)
    @cnpjs = Cnpj.order(:razao_social)
  end

  def create
    @agendamento = Agendamento.new(agendamento_params)
    @agendamento.solicitante = current_user.solicitante

    if @agendamento.save
      # Enviar email em background
      AgendamentoMailer.novo_agendamento(@agendamento).deliver_later
      
      redirect_to solicitante_agendamento_path(@agendamento), 
                  notice: 'Agendamento criado com sucesso! Você receberá um email com os detalhes.'
    else
      @unidades = Unidade.order(:nome)
      @cnpjs = Cnpj.order(:razao_social)
      render :new
    end
  end

  def edit
    @unidades = Unidade.order(:nome)
    @cnpjs = Cnpj.order(:razao_social)
  end

  def update
    if @agendamento.update(agendamento_params)
      redirect_to solicitante_agendamento_path(@agendamento), 
                  notice: 'Agendamento atualizado com sucesso.'
    else
      @unidades = Unidade.order(:nome)
      @cnpjs = Cnpj.order(:razao_social)
      render :edit
    end
  end

  def destroy
    if @agendamento.destroy
      redirect_to solicitante_agendamentos_path, 
                  notice: 'Agendamento removido com sucesso.'
    else
      redirect_to solicitante_agendamentos_path, 
                  alert: 'Erro ao remover agendamento.'
    end
  end

  private

  def set_agendamento
    @agendamento = current_user.agendamentos.find(params[:id])
  end

  def agendamento_params
    params.require(:agendamento).permit(
      :cidade_agendamento, :unidade_id, :cnpj_id, 
      :nome_colaborador, :data_nascimento, :cpf_colaborador,
      :n_ccu, :funcao, :tipo_consulta, :outro_tipo,
      :matricula, :matricula_nao_registrada, :data_preferencia,
      :observacoes
    )
  end
end