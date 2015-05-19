defmodule ExlugTest.ProcfileTest do
  use ExUnit.Case
  alias Exlug.Procfile

  test "parse parses valid Procfile" do
    {:ok, process_types} = Procfile.parse("web: bin/app_name\nworker: bin/worker")

    assert process_types["web"] == "bin/app_name"
    assert process_types["worker"] == "bin/worker"
  end

  test "parse raise error with invalid Procfile" do
    {:error, error} = Procfile.parse("web bin/app_name")
    assert error == "Invalid Procfile"
  end
end
