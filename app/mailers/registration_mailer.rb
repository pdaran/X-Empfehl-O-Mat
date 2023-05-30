class RegistrationMailer < ApplicationMailer
    layout 'mailer' # use mailer.(html|text).erb as the layout
    default from: email_address_with_name('notification@example.com', 'Example Company Notifications')
  
    def signup_email
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail(
        to: email_address_with_name(@user.email, 'Example User'),
        subject: 'Registration Confirmation',
        template_path: 'registration_mailer',
        template_name: 'signup_email'
      )
    end
end
