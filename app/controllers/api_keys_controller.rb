class ApiKeysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_key, only: %i[ show edit update destroy ]
  before_action :check_key_limit, only: [:create]

  def index
    @api_keys = ApiKey.all
  end

  def show
    @frequency = ApiKey.find_by(api_key:@api_key.api_key).frequency
  end

  def edit
  end

  def create
    current_user.api_keys.create(subscription_type: User.find_by(id:current_user.id).subscription_type)
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
      @api_key = ApiKey.find(params[:id])
    end

    def api_key_params
      params.require(:api_key).permit(:api_key, :frequency)
    end

    def check_key_limit
      if ApiKey.has_exceeded_keys_limit?(current_user)
        return redirect_to api_keys_path, notice: 'You have reached the limit of API keys.'
      end
    end
end
