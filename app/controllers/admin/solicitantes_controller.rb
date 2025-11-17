class Admin::SolicitantesController < Admin::BaseController
  before_action :set_solicitante, only: [:show, :edit, :update, :destroy]

  def index
    @solicitantes = Solicitante.includes(:user).order(:nome)
  end

  def show
  end

  def new
    @solicitante = Solicitante.new
    @solicitante.build_user
  end

  def create
    @solicitante = Solicitante.new(solicitante_params)
    @solicitante.user.role = :solicitante

    if @solicitante.save
      redirect_to admin_solicitante_path(@solicitante), notice: 'Solicitante criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @solicitante.update(solicitante_params)
      redirect_to admin_solicitante_path(@solicitante), notice: 'Solicitante atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @solicitante.destroy
    redirect_to admin_solicitantes_path, notice: 'Solicitante removido com sucesso.'
  end

  private

  def set_solicitante
    @solicitante = Solicitante.find(params[:id])
  end

  def solicitante_params
    params.require(:solicitante).permit(
      :nome, :email, :telefone, :empresa, :cargo,
      user_attributes: [:id, :email, :password, :password_confirmation, :nome]
    )
  end
end