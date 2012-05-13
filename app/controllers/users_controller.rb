class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { redirect_to "/", notice: 'Successfully logon.' }
      format.json { render json: "/", status: :created, location: "/" }
    end

  end

end
