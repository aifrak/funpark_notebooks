# START:module
defmodule FunPark.Monad.Either.Left do
  @enforce_keys [:left]
  defstruct [:left]

  def pure(value), do: %__MODULE__{left: value}
end

# END:module

# START:impl_string
defimpl String.Chars, for: FunPark.Monad.Either.Left do
  alias FunPark.Monad.Either.Left

  def to_string(%Left{left: left}), do: "Left(#{left})"
end

# END:impl_string

# START:impl_monad
defimpl FunPark.Monad, for: FunPark.Monad.Either.Left do
  alias FunPark.Monad.Either.{Left, Right}
  def map(%Left{} = left, _func), do: left

  def ap(%Left{} = left, %Left{}), do: left
  def ap(%Left{} = left, %Right{}), do: left

  def bind(%Left{} = left, _func), do: left
end

# END:impl_monad

# START:impl_foldable
defimpl FunPark.Foldable, for: FunPark.Monad.Either.Left do
  alias FunPark.Monad.Either.Left

  def fold_l(%Left{left: left}, _right_func, left_func) do
    left_func.(left)
  end

  def fold_r(%Left{} = left, right_func, left_func) do
    fold_l(left, right_func, left_func)
  end
end

# END:impl_foldable

# START:impl_eq
defimpl FunPark.Eq, for: FunPark.Monad.Either.Left do
  alias FunPark.Monad.Either.{Left, Right}
  alias FunPark.Eq

  def eq?(%Left{left: v1}, %Left{left: v2}), do: Eq.eq?(v1, v2)
  def eq?(%Left{}, %Right{}), do: false

  def not_eq?(%Left{left: v1}, %Left{left: v2}), do: Eq.not_eq?(v1, v2)
  def not_eq?(%Left{}, %Right{}), do: true
end

# END:impl_eq

# START:impl_ord
defimpl FunPark.Ord, for: FunPark.Monad.Either.Left do
  alias FunPark.Monad.Either.{Left, Right}
  alias FunPark.Ord

  def lt?(%Left{left: v1}, %Left{left: v2}), do: Ord.lt?(v1, v2)
  def lt?(%Left{}, %Right{}), do: true

  def le?(%Left{left: v1}, %Left{left: v2}), do: Ord.le?(v1, v2)
  def le?(%Left{}, %Right{}), do: true

  def gt?(%Left{left: v1}, %Left{left: v2}), do: Ord.gt?(v1, v2)
  def gt?(%Left{}, %Right{}), do: false

  def ge?(%Left{left: v1}, %Left{left: v2}), do: Ord.ge?(v1, v2)
  def ge?(%Left{}, %Right{}), do: false
end

# END:impl_ord
