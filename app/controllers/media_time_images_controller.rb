# frozen_string_literal: true

class MediaTimeImagesController < ApplicationController
  before_action :find_media_manage

  def create
    time_image = @media_manage.media_time_image.create(media_time_image_params)

    if time_image.save
      flash[:success] = '画像を保存しました'
    else
      flash[:error] = '画像が保存できませんでした'
    end

    redirect_to_media_manage(@media_manage)
  end

  def destroy
    time_image = @media_manage.media_time_image.find(params[:id])

    if time_image.destroy
      flash[:success] = '画像を削除しました'
    else
      flash[:error] = '画像を削除できませんでした'
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = '画像が存在しません'
  ensure
    redirect_to_media_manage(@media_manage)
  end

  private

  def find_media_manage
    id = media_time_image_params[:media_manage_id].to_i
    @media_manage = current_user.media_manage.find(id)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = '画像が存在しません'
    redirect_to root_url
  end

  def media_time_image_params
    params.require(:media_time_image).permit(:image, :media_manage_id)
  end
end
