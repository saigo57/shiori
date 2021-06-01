# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    Rails.logger.info('HomeController#index')
    redirect_to media_manages_url if user_signed_in?
  end
end
