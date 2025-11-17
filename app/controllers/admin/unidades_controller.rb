class Admin::UnidadesController < Admin::BaseController
  before_action :set_unidade, only: [:show, :edit, :update, :destroy]

  def index
    @unidades = Unidade.order(:nome)
  end

  def show
  end

  def new
    @unidade = Unidade.new
  end

  def create
    @unidade = Unidade.new(unidade_params)

    if @unidade.save
      redirect_to admin_unidades_path, notice: 'Unidade criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @unidade.update(unidade_params)
      redirect_to admin_unidades_path, notice: 'Unidade atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @unidade.agendamentos.any?
      redirect_to admin_unidades_path, alert: 'Não é possível remover unidade com agendamentos.'
    else
      @unidade.destroy
      redirect_to admin_unidades_path, notice: 'Unidade removida com sucesso.'
    end
  end

  private

  def set_unidade
    @unidade = Unidade.find(params[:id])
  end

  def unidade_params
    params.require(:unidade).permit(:nome, :cidade, :estado, :endereco, :telefone)
  end
end