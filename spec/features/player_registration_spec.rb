# frozen_string_literal: true

describe "Player registration", type: :feature do
  let(:registration_page) { Pages::Players::Registration.new }

  context "when a player clicks the registration link" do
    it "takes them to the registration page" do
      sign_in_page = Pages::Players::SignIn.new

      sign_in_page.load

      sign_in_page.registration_link.click

      expect(registration_page).to be_displayed
    end

    context "when the player clicks the confirmation link in their email" do
      let(:unconfirmed_player) do
        Player.create!(
          email: "player@example.com",
          password: "Passw0rd"
        )
      end

      it "confirms their account" do
        confirmation_page = Pages::Players::Confirmation.new
        token = unconfirmed_player.confirmation_token

        expect { confirmation_page.load(token: token) }.
          to change { unconfirmed_player.reload.confirmed? }.to true
      end
    end
  end

  context "when the registration form is filled in correctly" do
    it "creates a new, unconfirmed player" do
      registration_page.load

      registration_page.email_field.set("player@example.com")
      registration_page.password_field.set("Passw0rd")
      registration_page.password_confirmation_field.set("Passw0rd")

      expect { registration_page.register_button.click }.
        to change(Player, :count).by 1

      new_player = Player.find_by(email: "player@example.com")
      expect(new_player).not_to be_confirmed

      sign_in_page = Pages::Players::SignIn.new
      expect(sign_in_page).to be_displayed
    end
  end

  context "when the email address is missing" do
    it "shows an error message" do
      registration_page.load

      registration_page.password_field.set("Passw0rd")
      registration_page.password_confirmation_field.set("Passw0rd")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end

  context "when the email address is invalid" do
    it "shows an error message" do
      registration_page.load

      registration_page.email_field.set("not and email address")
      registration_page.password_field.set("Passw0rd")
      registration_page.password_confirmation_field.set("Passw0rd")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end

  context "when the password is missing" do
    it "shows an error message" do
      registration_page.load

      registration_page.email_field.set("player@example.com")
      registration_page.password_confirmation_field.set("Passw0rd")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end

  context "when the password is too short" do
    it "shows an error message" do
      registration_page.load

      registration_page.email_field.set("player@example.com")
      registration_page.password_field.set("Passw")
      registration_page.password_confirmation_field.set("Passw")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end

  context "when the password confirmation is missing" do
    it "shows an error message" do
      registration_page.load

      registration_page.email_field.set("player@example.com")
      registration_page.password_field.set("Passw0rd")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end

  context "when the password confirmation does not match the password" do
    it "shows an error message" do
      registration_page.load

      registration_page.email_field.set("player@example.com")
      registration_page.password_field.set("Passw0rd")
      registration_page.password_confirmation_field.set("This does not match")
      registration_page.register_button.click

      expect(registration_page).to have_error_container
    end
  end
end
