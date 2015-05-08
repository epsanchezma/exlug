defmodule Exlug.CLI do
  @moduledoc """
  handle the command line parsing and the dispatch to the various functions that end up uploading a slug to Heroku.
  """
  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is an app name specified with --app flag, dir specified with --dir and a optional release flag.
  Return a keyword list of `[app: app, dir: dir, release: release]`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean, dir: :string, app: :string, release: :boolean ],
                                      aliases: [ h:    :help    ])

    case parse do
      { [ help: true ], _, _ }                        -> :help
      { [app: app, dir: dir, release: release], _, _} -> [app: app, dir: dir, release: release]
      { [app: app, dir: dir], _, _}                   -> [app: app, dir: dir, release: false]
      _                                               -> :help
    end
  end
end
