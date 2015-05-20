# Exlug

Make slugs... with Elixir!!

## Install

## Usage

CLI:

```term
$ exlug --dir /path/to/src --app sleepy-waters-6298 --release
Initializing slug for /path/to/src...done
Archiving /path/to/src...done
Pushing /var/folders/5m/m_zcl3016gdfpz4yy4zp33k80000gn/T/slug-83940020.tgz...done
Releasing...done (v18)
```

In code:

```elixir
{:ok, process_types} = Procfile.parse(procfile_path)
slug = Slug.create(api_key, app_name, source_dir, process_types)
|> Slug.archive
|> Slug.push

release = Slug.release(slug)
IO.puts "done (v#{release.version})"
```
