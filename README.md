# Exlug

Make slugs... with Elixir!!

## Install

CLI:

```term
curl https://raw.githubusercontent.com/ride/exlug/master/exlug -o exlug
chmod +x exlug
./exlug
```

Code:

Add exlug as a dependency to your project

```elixir
  defp deps do
    [{:exlug, "~> 0.1.0"}]
  end
```

## Usage

CLI:

```term
$ ./exlug --dir /path/to/src --app sleepy-waters-6298 --release
Initializing slug for /path/to/src...done
Archiving /path/to/src...done
Pushing /var/folders/5m/m_zcl3016gdfpz4yy4zp33k80000gn/T/slug-83940020.tgz...done
Releasing...done (v18)
```

Code:

```elixir
{:ok, process_types} = Procfile.parse(procfile_path)
slug = Slug.create(api_key, app_name, source_dir, process_types)
|> Slug.archive
|> Slug.push

release = Slug.release(slug)
IO.puts "done (v#{release.version})"
```

## License

exlug is copyright (c) 2015 Ride Group Inc and contributors.

The source code is released under the MIT License.

Check [LICENSE](LICENSE) for more information.
