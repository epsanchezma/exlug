defmodule Exlug.Slug do

#@user_agent [ {"User-agent", "Elixir dave@pragprog.com"} ] Not sure if needed

	def new_slug(app, dir, release) do 
		
	end

	def heroku_url(app, resource) do
	    "https://api.heroku.com/apps/#{app}/#{resource}"
	    "https://api.heroku.com/apps/$APP_ID_OR_NAME/slugs"
	end

	def handle_response(%{status_code: 200, body: body}) do
	 { :ok, :body } 
	end

	def handle_response(%{status_code: ___, body: body}) do
	 { :error, :body }
	end

	def heroku_req(app, method, resource, body) do
		heroku_url(app, resource)
		|> HTTPoison.get(@user_agent) #not sure if needed
		|> handle_response

	end

end