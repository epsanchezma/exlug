defmodule Exlug.CLI do
  alias Exlug.Slug
  alias Exlug.Procfile

  @moduledoc """
  handle the command line parsing and the dispatch to the various functions that end up uploading a slug to Heroku.
  """
  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts """
    usage: exlug --app example_app --dir /path/to/src [--key 123ABC] [--release]
    """
    System.halt(0)
  end

  def process([app: app_name, dir: source_dir, key: api_key, release: release]) do
    process_types = parse_procfile(source_dir)
    slug = Slug.create(api_key, app_name, source_dir, process_types)
    |> Slug.archive
    |> Slug.push
    if release, do: Slug.release(slug)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is an app name specified with --app flag, dir specified with --dir and a optional release flag.
  Return a keyword list of `[app: app, dir: dir, release: release]`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean, dir: :string, app: :string, release: :boolean, key: :string ],
                                      aliases: [ h:    :help    ])

    case parse do #not sure of the third line syntax
      { [ help: true ], _, _ }                                   -> :help
      { [app: app, dir: dir, key: key], _, _}                    -> [app: app, dir: dir, key: key, release: false]
      { [app: app, dir: dir, release: release], _, _}            -> [app: app, dir: dir, key: netrc_key, release: release]
      { [app: app, dir: dir, key: key, release: release], _, _}  -> [app: app, dir: dir, key: key, release: release]
      { [app: app, dir: dir], _, _, }                            -> [app: app, dir: dir, key: netrc_key, release: false]
      _                                                          -> :help
    end
  end

  defp netrc_key do
    case Netrc.read["api.heroku.com"] do
      nil -> display_netrc_error
      host -> Map.fetch!(host, "password")
    end
  end

  defp parse_procfile(dir) do
    procfile_path = Path.join(dir, "Procfile")
    case File.read(procfile_path) do
      {:ok, procfile} -> Procfile.parse(procfile)
      {:error, _}     -> display_procfile_error
    end
  end

  defp display_procfile_error do
    IO.puts "It must exist a Procfile in the application folder"
    System.halt(0)
  end

  defp display_netrc_error do
    IO.puts "Key wasn't specified with --key option and there is not a API key in user .netrc file"
    System.halt(0)
  end
end
