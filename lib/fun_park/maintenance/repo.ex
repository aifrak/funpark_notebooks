defmodule FunPark.Maintenance.Repo do
  import FunPark.Monad, only: [bind: 2, map: 2]

  alias FunPark.Monad.Effect
  alias FunPark.Monad.Either
  alias FunPark.Maintenance.Store
  alias FunPark.Ride

  # START:create_store
  def create_store do
    Either.sequence_a([
      Store.create_table(:schedule),
      Store.create_table(:unschedule),
      Store.create_table(:lockout),
      Store.create_table(:compliance)
    ])
  end

  # END:create_store

  # START:add_schedule
  def add_schedule(%Ride{} = ride) do
    ride
    |> add_ride_effect()
    |> Effect.run(%{table: :schedule})
  end

  # END:add_schedule

  # START:add_others
  def add_unschedule(%Ride{} = ride) do
    ride
    |> add_ride_effect()
    |> Effect.run(%{table: :unschedule})
  end

  def add_lockout(%Ride{} = ride) do
    ride
    |> add_ride_effect()
    |> Effect.run(%{table: :lockout})
  end

  def add_compliance(%Ride{} = ride) do
    ride
    |> add_ride_effect()
    |> Effect.run(%{table: :compliance})
  end

  # END:add_others

  # START:remove
  def remove_schedule(%Ride{} = ride) do
    ride
    |> remove_ride_effect()
    |> Effect.run(%{table: :schedule})
  end

  def remove_unschedule(%Ride{} = ride) do
    ride
    |> remove_ride_effect()
    |> Effect.run(%{table: :unschedule})
  end

  def remove_lockout(%Ride{} = ride) do
    ride
    |> remove_ride_effect()
    |> Effect.run(%{table: :lockout})
  end

  def remove_compliance(%Ride{} = ride) do
    ride
    |> remove_ride_effect()
    |> Effect.run(%{table: :compliance})
  end

  # END:remove

  # START:in_maintenance
  def in_schedule(%Ride{} = ride), do: has_ride_effect(ride, :schedule)
  def in_unschedule(%Ride{} = ride), do: has_ride_effect(ride, :unschedule)
  def in_lockout(%Ride{} = ride), do: has_ride_effect(ride, :lockout)
  def in_compliance(%Ride{} = ride), do: has_ride_effect(ride, :compliance)

  # END:in_maintenance

  # START:not_in
  def not_in_schedule(%Ride{} = ride) do
    assert_absent_effect(
      ride,
      &in_schedule/1,
      "#{ride.name} is in scheduled maintenance"
    )
  end

  def not_in_unschedule(%Ride{} = ride) do
    assert_absent_effect(
      ride,
      &in_unschedule/1,
      "#{ride.name} is in unscheduled maintenance"
    )
  end

  def not_in_lockout(%Ride{} = ride) do
    assert_absent_effect(
      ride,
      &in_lockout/1,
      "#{ride.name} is locked out"
    )
  end

  def not_in_compliance(%Ride{} = ride) do
    assert_absent_effect(
      ride,
      &in_compliance/1,
      "#{ride.name} is out of compliance"
    )
  end

  # END:not_in

  # START:validate_ride_effect

  defp validate_ride_effect(ride) do
    Effect.lift_either(fn -> Ride.validate(ride) end)
  end

  # END:validate_ride_effect

  # START:add_to_store_effect
  defp add_to_store_effect(valid_ride) do
    Effect.asks(fn env -> env[:table] end)
    |> bind(fn table -> Store.add(valid_ride, table) end)
  end

  # END:add_to_store_effect

  # START:add_ride_effect
  def add_ride_effect(%Ride{} = ride) do
    validate_ride_effect(ride)
    |> bind(&add_to_store_effect/1)
  end

  # END:add_ride_effect

  # START:remove_from_store_effect
  defp remove_from_store_effect(valid_ride) do
    Effect.asks(fn env -> env[:table] end)
    |> bind(fn table -> Store.remove(valid_ride, table) end)
  end

  # END:remove_from_store_effect

  # START:remove_ride_effect
  def remove_ride_effect(%Ride{} = ride) do
    validate_ride_effect(ride)
    |> bind(&remove_from_store_effect/1)
    |> map(fn _ -> ride end)
  end

  # END:remove_ride_effect

  # START:has_ride_effect
  def has_ride_effect(%Ride{} = ride, table) do
    Effect.asks(fn env -> env[:store] end)
    |> bind(fn store -> store.get(ride, table) end)
    |> map(fn _ -> ride end)
  end

  # END:has_ride_effect

  # START:assert_absent_effect
  def assert_absent_effect(%Ride{} = ride, kleisli_fn, reason_msg) do
    ride
    |> kleisli_fn.()
    |> Effect.flip_either()
    |> bind(right_if_absent(ride))
    |> Effect.map_left(replace_ride_with_reason(reason_msg))
  end

  defp right_if_absent(ride) do
    fn
      :not_found -> Effect.right(ride)
      other -> Effect.left(other)
    end
  end

  defp replace_ride_with_reason(reason_msg) do
    fn
      %Ride{} -> reason_msg
      other -> other
    end
  end

  # END:assert_absent_effect
end
