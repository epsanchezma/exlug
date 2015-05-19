defmodule ExlugTest.CliTest do
  use ExUnit.Case

  import Exlug.CLI, only: [ parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "app, dir and release returned by option parsing with --app, --dir and --release options" do
    assert parse_args(["--app", "myapp", "--dir", "/path/to/dir", "--key", "123ABC", "--release"]) == [app: "myapp", dir: "/path/to/dir", key: "123ABC", release: true]
    assert parse_args(["--app", "myapp", "--dir", "/path/to/dir", "--key", "123ABC"]) == [app: "myapp", dir: "/path/to/dir", key: "123ABC", release: false]
  end
end
