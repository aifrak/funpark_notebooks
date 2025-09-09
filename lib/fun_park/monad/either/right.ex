# START:module
defmodule FunPark.Monad.Either.Right do
  @enforce_keys [:right]
  defstruct [:right]

  def pure(value), do: %__MODULE__{right: value}
end

# END:module

# START:impl_string
defimpl String.Chars, for: FunPark.Monad.Either.Right do
  alias FunPark.Monad.Either.Right

  def to_string(%Right{right: value}), do: "Right(#{value})"
end

# END:impl_string

# START:impl_monad
defimpl FunPark.Monad, for: FunPark.Monad.Either.Right do
  alias FunPark.Monad.Either.{Left, Right}

  def ap(%Right{right: func}, %Right{right: value}), do: Right.pure(func.(value))
  def ap(%Right{right: _func}, %Left{} = left), do: left

  def bind(%Right{right: value}, func), do: func.(value)
  def map(%Right{right: value}, func), do: Right.pure(func.(value))
end

# END:impl_monad

# START:impl_foldable
defimpl FunPark.Foldable, for: FunPark.Monad.Either.Right do
  alias FunPark.Monad.Either.Right

  def fold_l(%Right{right: value}, right_func, _left_func) do
    right_func.(value)
  end

  def fold_r(%Right{} = right, right_func, left_func) do
    fold_l(right, right_func, left_func)
  end
end

# END:impl_foldable

# START:impl_eq
defimpl FunPark.Eq, for: FunPark.Monad.Either.Right do
  alias FunPark.Monad.Either.{Left, Right}
  alias FunPark.Eq

  def eq?(%Right{right: v1}, %Right{right: v2}), do: Eq.eq?(v1, v2)
  def eq?(%Right{}, %Left{}), do: false

  def not_eq?(%Right{right: v1}, %Right{right: v2}), do: Eq.not_eq?(v1, v2)
  def not_eq?(%Right{}, %Left{}), do: true
end

# END:impl_eq

# START:impl_ord
defimpl FunPark.Ord, for: FunPark.Monad.Either.Right do
  alias FunPark.Monad.Either.{Left, Right}
  alias FunPark.Ord

  def lt?(%Right{right: v1}, %Right{right: v2}), do: Ord.lt?(v1, v2)
  def lt?(%Right{}, %Left{}), do: false

  def le?(%Right{right: v1}, %Right{right: v2}), do: Ord.le?(v1, v2)
  def le?(%Right{}, %Left{}), do: false

  def gt?(%Right{right: v1}, %Right{right: v2}), do: Ord.gt?(v1, v2)
  def gt?(%Right{}, %Left{}), do: true

  def ge?(%Right{right: v1}, %Right{right: v2}), do: Ord.ge?(v1, v2)
  def ge?(%Right{}, %Left{}), do: true
end

# END:impl_ord
