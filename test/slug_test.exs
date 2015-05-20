defmodule ExlugTest.SlugTest do
  use ExUnit.Case, async: false
  alias Exlug.Slug

  import Mock

  defmodule MockResponse do
    defstruct body: ""
  end

  test "create creates a new Slug" do
    response = %MockResponse{body: ~s({"blob":{"method":"put","url":"https://slug-url.com/slug"},"id":"c90ae68f-c2c8-4638"})}
    with_mock HTTPoison, [post!: fn(_url, _data, _headers) -> response end] do
      slug = Slug.create("ABC123", "test_app", "/path/to/app", %{"web" => "bin/web start"})

      assert slug.slug_dir == "/path/to/app"
      assert slug.api_key == "ABC123"
      assert slug.app_name == "test_app"
      assert slug.blob.url == "https://slug-url.com/slug"
      assert slug.id == "c90ae68f-c2c8-4638"
    end
  end

end
