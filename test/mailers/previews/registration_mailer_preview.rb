# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer
class RegistrationMailerPreview < ActionMailer::Preview
    def signup_email
        RegistrationMailer.with(user: User.first).signup_email
    end
end
