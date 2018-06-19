# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"

  def frontend_url
    "#{ENV['PROTOCOL']}://#{ENV['FRONTEND_HOST']}"
  end

  layout "mailer"
end
