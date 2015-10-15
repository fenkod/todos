require 'spec_helper'

class Login < SitePrism::Section
	element :username_input, "input#username"
	element :password_input, "input#password"
	element :submit_button,  "input[value='Login']"

	def login_with(username, password)
		username_input.set(username)
		password_input.set(password)

		submit_button.click
	end
end

class TodoForm < SitePrism::Section
	element :todo_input, "input[name='text']"
	element :todo_submit, "input[type='submit']"

	def add_todo(text)
		todo_input.set(text)
		todo_submit.click
	end
end

class TodoList < SitePrism::Section
	elements :items, "li"
end

class ToDo < SitePrism::Section
	section :form, TodoForm, "form"
	section :list, TodoList, "ul"
end

class CoolStuffApp < SitePrism::Page
	set_url "http://localhost:9292"

	section :login, Login, ".login"
	section :todo, ToDo, "#todo-app"
end

describe "login page" do
	let(:app) { CoolStuffApp.new }
	let(:login) { app.login }
	before    { app.load }

	it "has a username input" do
		expect(login).to have_username_input
	end

	it "has a password input" do
		expect(login).to have_password_input
	end

	it "has a submit button" do
		expect(login).to have_submit_button
	end

	it "displays a validation error with invalid credentials" do
		login.login_with("bad@example.com", "bad-password")

		expect(app).to have_login
		expect(login).to have_content "Invalid"
	end

	it "displays the todo section when logged in with valid credentials" do
		login.login_with("test@example.com", "password")

		expect(app).not_to have_login
		expect(app).to have_todo
	end
end

describe "adding todos" do
	let(:app) { CoolStuffApp.new }

	before {
		app.load
		app.login.login_with("test@example.com", "password")
	}

	it "adds a todo to the list" do
		app.todo.form.add_todo("Wake Up")

		expect(app.todo).to have_list
		expect(app.todo.list.items.first).to have_content "Wake Up"
	end

	it "adds multiple todos to the list" do
		items = ["Wake Up", "Get out of Bed", "Drag a Comb Across My Head"]

		items.each do |item|
			app.todo.form.add_todo(item)
		end

		items.each_with_index do |item, index|
			expect(app.todo.list.items[index].text).to eql item
		end

		expect(app.todo.list.items.first.text).to eql items[0]
		expect(app.todo.list.items.last.text).to eql items[-1]
	end
end
