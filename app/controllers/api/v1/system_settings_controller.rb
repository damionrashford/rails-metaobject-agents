class Api::V1::SystemSettingsController < ApplicationController
  def index
    @settings = SystemSetting.all
    render json: @settings
  end

  def update
    @setting = SystemSetting.find_by(key: params[:key])

    if @setting.update(value: params[:value])
      # Invalidate cache
      MemcachedService.invalidate("system_settings")
      render json: @setting
    else
      render json: { errors: @setting.errors }, status: :unprocessable_entity
    end
  end
end
