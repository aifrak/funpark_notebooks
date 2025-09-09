defmodule FunPark.FastPass do
  alias FunPark.Eq
  alias FunPark.Ride

  # START:struct_and_make
  defstruct id: nil,
            ride: nil,
            time: nil

  def make(%Ride{} = ride, %DateTime{} = time) do
    %__MODULE__{
      id: :erlang.unique_integer([:positive]),
      ride: ride,
      time: time
    }
  end

  # END:struct_and_make

  # START:change
  def change(%__MODULE__{} = fast_pass, attrs) when is_map(attrs) do
    attrs = Map.delete(attrs, :id)

    struct(fast_pass, attrs)
  end

  # END:change

  # START:eq_time
  def get_time(%__MODULE__{time: time}), do: time

  def eq_time do
    Eq.Utils.contramap(&get_time/1)
  end

  # END:eq_time

  # START:eq_ride
  # START:get_ride
  def get_ride(%__MODULE__{ride: ride}), do: ride

  # END:get_ride

  def eq_ride do
    Eq.Utils.contramap(&get_ride/1)
  end

  # END:eq_ride

  # START:eq_ride_and_time
  def eq_ride_and_time do
    Eq.Utils.concat_all([eq_ride(), eq_time()])
  end

  # END:eq_ride_and_time

  # START:duplicate_pass
  def duplicate_pass do
    Eq.Utils.concat_any([Eq, eq_ride_and_time()])
  end

  # END:duplicate_pass

  # START:valid
  def valid?(%__MODULE__{} = fast_pass, %Ride{} = ride) do
    Eq.Utils.eq?(get_ride(fast_pass), ride)
  end

  # END:valid
end

# START:impl_eq
defimpl FunPark.Eq, for: FunPark.FastPass do
  alias FunPark.Eq
  alias FunPark.FastPass
  def eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.eq?(v1, v2)
  def not_eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.not_eq?(v1, v2)
end

# END:impl_eq

# START:impl_ord
defimpl FunPark.Ord, for: FunPark.FastPass do
  alias FunPark.Ord
  alias FunPark.FastPass

  def lt?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.lt?(v1, v2)
  def le?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.le?(v1, v2)
  def gt?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.gt?(v1, v2)
  def ge?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.ge?(v1, v2)
end

# END:impl_ord
