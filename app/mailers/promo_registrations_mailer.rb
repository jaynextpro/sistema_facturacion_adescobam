class PromoRegistrationsMailer < ApplicationMailer
    after_deliver :update_registration_email_flags

    def send_confirmation_entry_email
        @promo_registration = params[:promo_registration]
        @email = "confirmation"

        mail(to: @promo_registration.email, subject: "Lay’s® Flavor Drop Global Edition | Your Entry is Confirmed")
    end

    private

    def update_registration_email_flags
        if @email == "confirmation"
            @promo_registration.update_columns(sent_confirmation_entry_email: true)
        end
    end
end
