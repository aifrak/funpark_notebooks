defmodule FunPark.Maintenance do
  import FunPark.Monad, only: [bind: 2, map: 2]
  alias FunPark.Errors.ValidationError
  alias FunPark.Monad.Effect
  alias FunPark.Monad.Either
  alias FunPark.Maintenance.Repo
  alias FunPark.Ride
  alias FunPark.Maintenance.Store

  # START:add_to_all
  def add_to_all(%Ride{} = ride) do
    ride
    |> Repo.add_schedule()
    |> bind(&Repo.add_unschedule/1)
    |> bind(&Repo.add_lockout/1)
    |> bind(&Repo.add_compliance/1)
  end

  # END:add_to_all

  # START:remove_from_all
  def remove_from_all(%Ride{} = ride) do
    Either.sequence_a([
      Repo.remove_schedule(ride),
      Repo.remove_unschedule(ride),
      Repo.remove_lockout(ride),
      Repo.remove_compliance(ride)
    ])
    |> map(fn _ -> ride end)
  end

  # END:remove_from_all

  # START:check_in_all
  def check_in_all(%Ride{} = ride) do
    ride
    |> Repo.in_schedule()
    |> bind(&Repo.in_unschedule/1)
    |> bind(&Repo.in_lockout/1)
    |> bind(&Repo.in_compliance/1)
    |> Effect.run(%{store: Store})
  end

  # END:check_in_all

  # START:check_online_bind
  def check_online_bind(%Ride{} = ride) do
    ride
    |> Repo.not_in_schedule()
    |> bind(&Repo.not_in_unschedule/1)
    |> bind(&Repo.not_in_lockout/1)
    |> bind(&Repo.not_in_compliance/1)
    |> Effect.run(%{store: Store})
  end

  # END:check_online_bind

  # START:check_online
  def check_online(%Ride{} = ride) do
    Effect.validate(ride, [
      &Repo.not_in_schedule/1,
      &Repo.not_in_unschedule/1,
      &Repo.not_in_lockout/1,
      &Repo.not_in_compliance/1
    ])
    |> Effect.run(%{store: Store})
  end

  # END:check_online

  # START:online?
  def online?(%Ride{} = ride) do
    ride
    |> check_online()
    |> Either.right?()
  end

  # END:online?

  # START:ensure_online
  def ensure_online(%Ride{} = ride) do
    ride
    |> check_online()
    |> Either.map_left(&ValidationError.new/1)
  end

  # END:ensure_online
end
