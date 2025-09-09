defmodule FunPark.Monoid.ListConcat do
  defstruct value: []
end

defimpl FunPark.Monoid, for: FunPark.Monoid.ListConcat do
  alias FunPark.Monoid.ListConcat

  def empty(_), do: %ListConcat{}

  def append(%ListConcat{value: a}, %ListConcat{value: b}) do
    %ListConcat{value: a ++ b}
  end

  def wrap(%ListConcat{}, value) when is_list(value), do: %ListConcat{value: value}

  def unwrap(%ListConcat{value: value}), do: value
end
