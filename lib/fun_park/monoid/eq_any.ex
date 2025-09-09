# START:module
defmodule FunPark.Monoid.Eq.Any do
  defstruct eq?: &FunPark.Monoid.Eq.Any.default_eq?/2,
            not_eq?: &FunPark.Monoid.Eq.Any.default_not_eq?/2

  def default_eq?(_, _), do: false

  def default_not_eq?(_, _), do: true
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Eq.Any do
  alias FunPark.Eq.Utils
  alias FunPark.Monoid.Eq.Any

  def empty(_), do: %Any{}

  def append(%Any{} = eq1, %Any{} = eq2) do
    %Any{
      eq?: fn a, b -> eq1.eq?.(a, b) || eq2.eq?.(a, b) end,
      not_eq?: fn a, b -> eq1.not_eq?.(a, b) && eq2.not_eq?.(a, b) end
    }
  end

  def wrap(%Any{}, eq) do
    eq = Utils.to_eq_map(eq)

    %Any{
      eq?: eq.eq?,
      not_eq?: eq.not_eq?
    }
  end

  def unwrap(%Any{eq?: eq?, not_eq?: not_eq?}) do
    %{eq?: eq?, not_eq?: not_eq?}
  end
end

# END:impl_monoid
