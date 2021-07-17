# frozen_string_literal: true

class PlaylistOrdersController < ApplicationController
  before_action :check_signed_in

  def update
    Playlist.transaction do
      update_params.each_with_index do |id, idx|
        id = id.to_i
        p = current_user.playlist.find(id)
        p.update(order: idx)
      end
    end

    render json: {}
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :forbidden
  end

  def update_params
    params['order'].map(&:to_i)
  end
end
