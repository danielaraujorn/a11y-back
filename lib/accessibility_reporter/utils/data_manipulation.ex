defmodule AccessibilityReporter.Utils.DataManipulation do
  import Ecto.Query, warn: false

  def apply_operations(query, operations) do
    Enum.reduce(operations, query, fn {operation, value}, query ->
      apply_operations(query, to_atom(operation), value)
    end)
  end

  defp to_atom(value) when is_binary(value), do: String.to_existing_atom(value)
  defp to_atom(value), do: value

  defp apply_operations(query, :ids, ids),
    do: where(query, [j], j.id in ^ids)

  defp apply_operations(query, :inserted_at, datetime),
    do: where(query, [j], j.inserted_at >= ^datetime)

  defp apply_operations(query, :inserted_at_start, inserted_at_start),
    do: where(query, [u], u.inserted_at >= ^inserted_at_start)

  defp apply_operations(query, :inserted_at_end, inserted_at_end),
    do: where(query, [u], u.inserted_at <= ^inserted_at_end)

  defp apply_operations(query, :offset, offset), do: offset(query, ^offset)
  defp apply_operations(query, :limit, limit), do: limit(query, ^limit)

  defp apply_operations(query, :sort, sort) when is_map(sort),
    do: apply_operations(query, :sort, Map.to_list(sort))

  defp apply_operations(query, :sort, sort), do: order_by(query, ^sort)

  defp apply_operations(query, :email, email),
    do: where(query, [u], like(u.email, ^"#{sanitize_sql_like(email)}%"))

  defp apply_operations(query, :name, name),
    do: where(query, [d], like(d.name, ^"#{sanitize_sql_like(name)}%"))

  defp apply_operations(query, :roles, role),
    do: where(query, [u], u.role in ^role)

  defp apply_operations(query, _, nil), do: query
  defp apply_operations(query, _, _), do: query

  @spec sanitize_sql_like(String.t()) :: String.t()
  @spec sanitize_sql_like(String.t(), String.t()) :: String.t()
  defp sanitize_sql_like(input, escape_char \\ "\\")
       when is_binary(input) and is_binary(escape_char) do
    # Direct port of Rails' sanitize_sql_like:
    # https://github.com/rails/rails/blob/v5.2.2/activerecord/lib/active_record/sanitization.rb#L93-L110
    {:ok, pattern} = Regex.compile("#{Regex.escape(escape_char)}|%|_")
    Regex.replace(pattern, input, fn x -> "\\" <> x end)
  end
end
