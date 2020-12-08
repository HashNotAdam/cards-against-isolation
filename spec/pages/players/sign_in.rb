# frozen_string_literal: true

module Pages
  module Players
    class SignIn < SitePrism::Page
      set_url "/players/sign_in"

      element :email_field, "#new_player input[name='player[email]']"
      element :password_field, "#new_player input[name='player[password]']"
      element :login_button, "#new_player input[type=submit]"

      element :registration_link, "a[href='/players/sign_up']"

      element :alert, ".alert"
    end
  end
end
