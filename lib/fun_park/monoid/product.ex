# START:module
defmodule FunPark.Monoid.Product do
  @type t :: %__MODULE__{value: number()}

  defstruct value: 1
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Product do
  alias FunPark.Monoid.Product

  @spec empty(Product.t()) :: Product.t()
  def empty(_), do: %Product{}

  @spec append(Product.t(), Product.t()) :: Product.t()
  def append(%Product{value: a}, %Product{value: b}) do
    %Product{value: a * b}
  end

  @spec wrap(Product.t(), number()) :: Product.t()
  def wrap(%Product{}, value) when is_number(value),
    do: %Product{value: value}

  @spec unwrap(Product.t()) :: number()
  def unwrap(%Product{value: value}) when is_number(value), do: value
end

# END:impl_monoid
