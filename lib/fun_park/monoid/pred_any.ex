# START:module
defmodule FunPark.Monoid.Predicate.Any do
  defstruct value: &FunPark.Monoid.Predicate.Any.default_pred?/1

  def default_pred?(_), do: false
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Predicate.Any do
  alias FunPark.Monoid.Predicate.Any

  def empty(_), do: %Any{}

  def append(%Any{} = p1, %Any{} = p2) do
    %Any{
      value: fn value -> p1.value.(value) or p2.value.(value) end
    }
  end

  def wrap(%Any{}, value) when is_function(value, 1) do
    %Any{value: value}
  end

  def unwrap(%Any{value: value}), do: value
end

# END:impl_monoid
