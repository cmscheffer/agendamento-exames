class Solicitante::BaseController < ApplicationController
  before_action :authorize_solicitante!

  layout 'solicitante'
end