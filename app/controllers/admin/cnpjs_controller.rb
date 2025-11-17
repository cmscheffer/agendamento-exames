class Admin::CnpjsController < Admin::BaseController
  before_action :set_cnpj, only: [:show, :edit, :update, :destroy]

  def index
    @cnpjs = Cnpj.order(:razao_social)
  end

  def show
  end

  def new
    @cnpj = Cnpj.new
  end

  def create
    @cnpj = Cnpj.new(cnpj_params)

    if @cnpj.save
      redirect_to admin_cnpjs_path, notice: 'CNPJ criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @cnpj.update(cnpj_params)
      redirect_to admin_cnpjs_path, notice: 'CNPJ atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    if @cnpj.agendamentos.any?
      redirect_to admin_cnpjs_path, alert: 'Não é possível remover CNPJ com agendamentos.'
    else
      @cnpj.destroy
      redirect_to admin_cnpjs_path, notice: 'CNPJ removido com sucesso.'
    end
  end

  private

  def set_cnpj
    @cnpj = Cnpj.find(params[:id])
  end

  def cnpj_params
    params.require(:cnpj).permit(:numero, :razao_social, :descricao, :endereco)
  end
end