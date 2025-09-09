# START:module
defmodule FunPark.Monoid.Sum do
  defstruct value: 0
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Sum do
  alias FunPark.Monoid.Sum

  def empty(_), do: %Sum{}

  def append(%Sum{value: a}, %Sum{value: b}) do
    %Sum{value: a + b}
  end

  def wrap(%Sum{}, value) when is_number(value), do: %Sum{value: value}

  def unwrap(%Sum{value: value}) when is_number(value), do: value
end

# END:impl_monoid
