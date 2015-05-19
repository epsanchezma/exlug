defmodule Exlug.Slug do
  defstruct [:blob, :created_at, :id, :process_types, :updated_at, :slug_dir, :api_key, :app_name, :tar_file]

  @moduledoc """
  """
  def create(api_key, app_name, source_dir, process_types) do
    create_slug(app_name, api_key, process_types)
    Map.merge(slug, %{slug_dir: source_dir, api_key: api_key, app_name: app_name})
  end

  defp create_slug(app_name, api_key, process_types) do
    url = resource_url(app_name, resource)
    json = JSX.encode!(Map.put(%{}, "process_types", process_types))
    slug = post(url, json, default_headers(api_key))
    Map.merge(%Exlug.Slug{}, slug)
  end

  def archive(slug) do

  end

  def push(slug) do

  end

  def release(slug) do
  end


  defp post(url, data, headers) do
    response = HTTPoison.post!(url, data, headers)
    JSX.decode!(response.body, [{:labels, :atom}])
  end

  defp default_headers(api_key) do
    %{"Content-type" => "application/json", "Accept" => "application/vnd.heroku+json; version=3", "Authorization" => "Bearer #{api_key}"}
  end

  defp resource_url(app_name, resource) do
    "https://api.heroku.com/apps/#{app_name}/#{resource}"
  end

  defp to_json(root, data) do
    JSX.encode!(Map.put(%{}, root, data))
  end
end
