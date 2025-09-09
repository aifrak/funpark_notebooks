defmodule FunPark.Maintenance.Store do
  import FunPark.Monad

  alias FunPark.Monad.Effect
  alias FunPark.Ride
  alias FunPark.Store

  def create_table(table) do
    Store.create_table(table)
  end

  # START:add
  def add(%Ride{} = ride, table) do
    Effect.lift_either(fn -> Store.insert_item(table, ride) end)
    |> map(&simulate_delay/1)
    |> Effect.map_left(&simulate_delay/1)
  end

  # END:add

  # START:remove
  def remove(%Ride{id: id}, table) do
    Effect.lift_either(fn -> Store.delete_item(table, id) end)
    |> map(&simulate_delay/1)
    |> Effect.map_left(&simulate_delay/1)
  end

  # END:remove

  # START:get
  def get(%Ride{id: id}, table) do
    Effect.lift_either(fn -> Store.get_item(table, id) end)
    |> map(&simulate_delay/1)
    |> Effect.map_left(&simulate_delay/1)
  end

  # END:get

  defp simulate_delay(ride) do
    Process.sleep(500)
    ride
  end
end
