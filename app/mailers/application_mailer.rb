# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@shiori-movie.herokuapp.com'
  layout 'mailer'
end
