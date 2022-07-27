class ApiKeysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_key, only: %i[ show edit update destroy ]

  def index
    @api_keys = ApiKey.all
  end

  def show
  end

  def edit
  end

  def create
    if current_user.keys_limit_reached?
      return redirect_to api_keys_path, notice: " You can only create #{current_user.keys_limit} api keys. "
    end
    current_user.api_keys.create( subscription_type: current_user.subscription_type )
    redirect_to api_keys_path
  end

  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to api_key_url(@api_key), notice: "Api key was successfully updated." }
        format.json { render :show, status: :ok, location: @api_key }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @api_key.destroy
    respond_to do |format|
      format.html { redirect_to api_keys_url, notice: "Api key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_api_key
      @api_key = ApiKey.find( params[:id] )
    end

    def api_key_params
      params.require( :api_key ).permit( :api_key, :frequency )
    end
end
