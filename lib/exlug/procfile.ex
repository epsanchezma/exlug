defmodule Exlug.Procfile do
  def parse(procfile) do
    process_types = :yamerl_constr.string(procfile)
    case List.first(process_types) do
      list = [{_,_}|_]   -> {:ok, to_map(list)}
                    _    -> {:error, "Invalid Procfile"}
    end
  end

  defp to_map(list) when is_list(list) do
    list |> Enum.map(fn {key, value} -> {List.to_string(key), List.to_string(value)} end) |> Enum.into(%{})
  end
end
