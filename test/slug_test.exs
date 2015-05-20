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

  test "archive creates a .tar.gz file with the slug dir compressed" do
    slug = %Slug{slug_dir: Path.join(System.cwd, "test")}
    slug = Slug.archive(slug)

    assert File.exists?(slug.tar_file)
  end

  test "push upload the slug tar file" do
    slug = %Slug{blob: %{url: "https://slug-url/slug-path"}, tar_file: __ENV__.file}

    with_mock HTTPoison, [put!: fn(_url, _data, _headers) -> %MockResponse{body: ""} end] do
      slug = Slug.push(slug)
      assert slug
    end
  end

  test "release creates a new Release" do
    response = %MockResponse{body: ~s({"user":{"email":"elba@ride.com"},"app":{"name":"test_app"},"version":3})}
    slug = %Slug{app_name: "test_app", api_key: "ABC123"}

    with_mock HTTPoison, [post!: fn(_url, _data, _headers) -> response end] do

      release = Slug.release(slug)

      assert release.app.name == "test_app"
      assert release.user.email == "elba@ride.com"
      assert release.version == 3
    end
  end
end
