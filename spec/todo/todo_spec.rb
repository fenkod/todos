require 'spec_helper'

class LoginPage < SitePrism::Page
	set_url "http://localhost:9292"

	element :username_input, ".login input#username"
	element :password_input, ".login input#password"
	element :submit_button,  ".login input[value='Login']"
end

describe "login page" do
	let(:login) { LoginPage.new }
	before { login.load }

	it "has a username input" do
		expect(login).to have_username_input
	end

	it "has a password input" do
		expect(login).to have_password_input
	end

	it "has a submit button" do
		expect(login).to have_submit_button
	end

	it "displays a validation error" do
		login.username_input.set("a-username")
		login.password_input.set("a-password")

		login.submit_button.click

		expect(login).to have_content "Invalid"
	end
end
