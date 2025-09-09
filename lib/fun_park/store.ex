defmodule FunPark.Store do
  import FunPark.Monad
  alias FunPark.Monad.Either

  # START:create_table
  def create_table(table) when is_atom(table) do
    Either.from_try(fn ->
      :ets.new(table, [:named_table, :set, :public])
    end)
  end

  # END:create_table

  # START:drop_table
  def drop_table(table) when is_atom(table) do
    Either.from_try(fn ->
      :ets.delete(table)
    end)
    |> map(fn _ -> table end)
  end

  # END:drop_table

  # START:insert_item
  def insert_item(table, %{id: id} = item) when is_atom(table) do
    Either.from_try(fn ->
      :ets.insert(table, {id, Map.from_struct(item)})
    end)
    |> map(fn _ -> item end)
  end

  # END:insert_item

  # START:get_item
  def get_item(table, id) when is_atom(table) do
    Either.from_try(fn ->
      :ets.lookup(table, id)
    end)
    |> bind(fn
      [{_id, item}] -> Either.pure(item)
      [] -> Either.left(:not_found)
    end)
  end

  # END:get_item

  # START:get_all_items
  def get_all_items(table) when is_atom(table) do
    Either.from_try(fn ->
      :ets.tab2list(table)
    end)
    |> map(fn items ->
      Enum.map(items, fn {_, item} -> item end)
    end)
  end

  # END:get_all_items

  # START:delete_item
  def delete_item(table, id) when is_atom(table) do
    Either.from_try(fn ->
      :ets.delete(table, id)
    end)
    |> map(fn _ -> id end)
  end

  # END:delete_item
end
