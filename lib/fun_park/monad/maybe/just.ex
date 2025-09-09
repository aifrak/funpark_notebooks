# START:module
defmodule FunPark.Monad.Maybe.Just do
  @enforce_keys [:value]
  defstruct [:value]

  def pure(nil), do: raise(ArgumentError, "Cannot wrap nil in a Just")
  def pure(value), do: %__MODULE__{value: value}
end

# END:module

# START:impl_monad
defimpl FunPark.Monad, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.{Just, Nothing}

  def map(%Just{value: value}, func), do: Just.pure(func.(value))

  def ap(%Just{value: func}, %Just{value: value}),
    do: Just.pure(func.(value))

  def ap(%Just{}, %Nothing{}), do: %Nothing{}

  def bind(%Just{value: value}, func), do: func.(value)
end

# END:impl_monad

# START:impl_string
defimpl String.Chars, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.Just

  def to_string(%Just{value: value}), do: "Just(#{value})"
end

# END:impl_string

# START:impl_foldable
defimpl FunPark.Foldable, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.Just

  def fold_l(%Just{value: value}, just_func, _nothing_func) do
    just_func.(value)
  end

  def fold_r(%Just{} = just, just_func, nothing_func) do
    fold_l(just, just_func, nothing_func)
  end
end

# END:impl_foldable

# START:impl_filterable
defimpl FunPark.Filterable, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad

  def guard(%Just{} = maybe, true), do: maybe
  def guard(%Just{}, false), do: Maybe.nothing()

  def filter(%Just{} = maybe, predicate) do
    Monad.bind(maybe, fn value ->
      if predicate.(value) do
        Maybe.pure(value)
      else
        Maybe.nothing()
      end
    end)
  end

  def filter_map(%Just{value: value}, func) do
    case func.(value) do
      %Just{} = just -> just
      _ -> Maybe.nothing()
    end
  end
end

# END:impl_filterable

# START:impl_eq
defimpl FunPark.Eq, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.{Just, Nothing}
  alias FunPark.Eq

  def eq?(%Just{value: v1}, %Just{value: v2}), do: Eq.eq?(v1, v2)
  def eq?(%Just{}, %Nothing{}), do: false

  def not_eq?(%Just{value: v1}, %Just{value: v2}), do: not Eq.eq?(v1, v2)
  def not_eq?(%Just{}, %Nothing{}), do: true
end

# END:impl_eq

# START:impl_ord
defimpl FunPark.Ord, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.{Just, Nothing}
  alias FunPark.Ord

  def lt?(%Just{value: v1}, %Just{value: v2}), do: Ord.lt?(v1, v2)
  def lt?(%Just{}, %Nothing{}), do: false

  def le?(%Just{value: v1}, %Just{value: v2}), do: Ord.le?(v1, v2)
  def le?(%Just{}, %Nothing{}), do: false

  def gt?(%Just{value: v1}, %Just{value: v2}), do: Ord.gt?(v1, v2)
  def gt?(%Just{}, %Nothing{}), do: true

  def ge?(%Just{value: v1}, %Just{value: v2}), do: Ord.ge?(v1, v2)
  def ge?(%Just{}, %Nothing{}), do: true
end

# END:impl_ord
