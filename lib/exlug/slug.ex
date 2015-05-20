defmodule Exlug.Slug do
  defstruct [:blob, :id, :process_types, :slug_dir, :api_key, :app_name, :tar_file]

  @moduledoc """
  """
  def create(api_key, app_name, source_dir, process_types) do
    slug = create_slug(app_name, api_key, process_types)
    Map.merge(slug, %{slug_dir: source_dir, api_key: api_key, app_name: app_name})
  end

  defp create_slug(app_name, api_key, process_types) do
    url = resource_url(app_name, "slugs")
    json = encode_json(Map.put(%{}, "process_types", process_types))
    response = post(url, json, Map.merge(default_headers, authorization_header(api_key)))
    slug = decode_json(response.body)
    Map.merge(%Exlug.Slug{}, Map.take(slug, [:blob, :id, :process_types]))
  end

  def archive(slug) do
    slug
  end

  def push(slug) do
    slug
  end

  def release(slug) do
    slug
  end


  defp post(url, data, headers) do
    HTTPoison.post!(url, data, headers)
  end

  defp decode_json(body) do
    JSX.decode!(body, [{:labels, :atom}])
  end

  defp encode_json(body) do
    JSX.encode!(body)
  end

  defp default_headers do
    %{"Content-type" => "application/json", "Accept" => "application/vnd.heroku+json; version=3"}
  end

  defp authorization_header(api_key) do
    %{"Authorization" => "Bearer #{api_key}"}
  end

  defp resource_url(app_name, resource) do
    "https://api.heroku.com/apps/#{app_name}/#{resource}"
  end
end
