# START:module
defmodule FunPark.Monoid.Eq.All do
  defstruct eq?: &FunPark.Monoid.Eq.All.default_eq?/2,
            not_eq?: &FunPark.Monoid.Eq.All.default_not_eq?/2

  def default_eq?(_, _), do: true

  def default_not_eq?(_, _), do: false
end

# END:module

# START:impl_monoid
defimpl FunPark.Monoid, for: FunPark.Monoid.Eq.All do
  alias FunPark.Eq.Utils
  alias FunPark.Monoid.Eq.All

  def empty(_), do: %All{}

  def append(%All{} = eq1, %All{} = eq2) do
    %All{
      eq?: fn a, b -> eq1.eq?.(a, b) && eq2.eq?.(a, b) end,
      not_eq?: fn a, b -> eq1.not_eq?.(a, b) || eq2.not_eq?.(a, b) end
    }
  end

  def wrap(%All{}, eq) do
    eq = Utils.to_eq_map(eq)

    %All{
      eq?: eq.eq?,
      not_eq?: eq.not_eq?
    }
  end

  def unwrap(%All{eq?: eq?, not_eq?: not_eq?}) do
    %{eq?: eq?, not_eq?: not_eq?}
  end
end

# END:impl_monoid
