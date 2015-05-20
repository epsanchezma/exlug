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
    dir = Path.expand(slug.slug_dir)
    file_list = File.ls!(dir)
      |> Enum.reject(&(String.ends_with?(&1,".tar.gz")))
      |> Enum.map(&({'app/#{&1}', '#{dir}/#{&1}'}))
    tar_file = Path.join([System.tmp_dir, "slug-#{:erlang.phash2(:erlang.make_ref)}.tgz"])
    :ok = :erl_tar.create(tar_file, file_list, [:compressed])
    Map.merge(slug, %{tar_file: tar_file})
  end

  def push(slug) do
    url = slug.blob.url
    file_size = File.stat!(slug.tar_file).size
    put(url, File.read!(slug.tar_file), %{"Content-Type" => ""})
    slug
  end

  def release(slug) do
    url = resource_url(slug.app_name, "releases")
    json = encode_json(%{slug: slug.id})
    response = post(url, json, Map.merge(default_headers, authorization_header(slug.api_key)))
    release = decode_json(response.body)
    release
  end


  defp post(url, data, headers) do
    HTTPoison.post!(url, data, headers)
  end

  defp put(url, data, headers) do
    HTTPoison.put!(url, data, headers)
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
