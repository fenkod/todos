require 'spec_helper'

class LoginPage < SitePrism::Page
	set_url "http://localhost:9292"
end

describe "Sanity" do
	it "is sane" do
		LoginPage.new.load
	end
end
