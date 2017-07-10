class Api::ApiBaseController < ApplicationController

  before_action :set_lang

  def set_lang
    @chinese = params[:l] == 'cn'
  end

end
