# START:module
defmodule FunPark.Monoid.Min do
  defstruct value: nil, id: nil, ord: FunPark.Ord
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Min do
  alias FunPark.Monoid.Min
  alias FunPark.Ord.Utils

  def empty(%Min{id: id, ord: ord}), do: %Min{value: id, id: id, ord: ord}

  def append(%Min{value: a, ord: ord} = min1, %Min{value: b}) do
    %Min{min1 | value: Utils.min(a, b, ord)}
  end

  def wrap(%Min{ord: ord}, value) do
    %Min{value: value, ord: Utils.to_ord_map(ord)}
  end

  def unwrap(%Min{value: value}), do: value
end

# END:impl_monoid
