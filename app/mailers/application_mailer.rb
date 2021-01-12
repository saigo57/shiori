# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@shiori-portfolio.work'
  layout 'mailer'
end
