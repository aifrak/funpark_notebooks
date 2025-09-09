# START:module
defmodule FunPark.Monoid.Max do
  defstruct value: nil, ord: FunPark.Ord
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Max do
  alias FunPark.Monoid.Max
  alias FunPark.Ord.Utils

  # START:empty
  def empty(%Max{value: min_value, ord: ord}) do
    %Max{value: min_value, ord: ord}
  end

  # END:empty

  # START:append
  def append(%Max{value: a, ord: ord}, %Max{value: b}) do
    %Max{value: Utils.max(a, b, ord), ord: ord}
  end

  # END:append

  # START:wrap
  def wrap(%Max{ord: ord}, value) do
    %Max{value: value, ord: Utils.to_ord_map(ord)}
  end

  def unwrap(%Max{value: value}), do: value
  # END:wrap
end

# END:impl_monoid
