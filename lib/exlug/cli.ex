defmodule Exlug.CLI do
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
    usage: exlug <--app exampleapp> <--dir /path/to/src> [--release]
    """
    System.halt(0)
  end

  def process([app: app, dir: dir, release: release], resource: resource) do
    # Exlug.Slug.push(app, dir, release)
      Exlug.Slug.new_slug(app,dir,release,resource)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is an app name specified with --app flag, dir specified with --dir and a optional release flag.
  Return a keyword list of `[app: app, dir: dir, release: release]`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean, dir: :string, app: :string, release: :boolean, resource :string ],
                                      aliases: [ h:    :help    ])

    case parse do #not sure of the third line syntax
      { [ help: true ], _, _ }                                             -> :help
      { [app: app, dir: dir, release: release, resource: resource], _, _}  -> [app: app, dir: dir, release: release, resource: resource]
      { [app: app, dir: dir], _, _, _, _}                                  -> [app: app, dir: dir, release: false, resource: resource]
      _                                                                    -> :help
    end
  end
end
