# START:module
defmodule FunPark.Monad.Maybe.Nothing do
  defstruct []

  def pure, do: %__MODULE__{}
end

# END:module

# START:impl_monad
defimpl FunPark.Monad, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def map(%Nothing{}, _func), do: %Nothing{}
  def ap(%Nothing{}, _val), do: %Nothing{}
  def bind(%Nothing{}, _func), do: %Nothing{}
end

# END:impl_monad

# START:impl_string
defimpl String.Chars, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def to_string(%Nothing{}), do: "Nothing"
end

# END:impl_string

# START:impl_foldable
defimpl FunPark.Foldable, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def fold_l(%Nothing{}, _just_func, nothing_func) do
    nothing_func.()
  end

  def fold_r(%Nothing{} = nothing, just_func, nothing_func) do
    fold_l(nothing, just_func, nothing_func)
  end
end

# END:impl_foldable

# START:impl_filterable
defimpl FunPark.Filterable, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def guard(%Nothing{}, _boolean), do: %Nothing{}
  def filter(%Nothing{}, _predicate), do: %Nothing{}
  def filter_map(%Nothing{}, _func), do: %Nothing{}
end

# END:impl_filterable

# START:impl_eq
defimpl FunPark.Eq, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.{Nothing, Just}

  def eq?(%Nothing{}, %Nothing{}), do: true
  def eq?(%Nothing{}, %Just{}), do: false

  def not_eq?(%Nothing{}, %Nothing{}), do: false
  def not_eq?(%Nothing{}, %Just{}), do: true
end

# END:impl_eq

# START:impl_ord
defimpl FunPark.Ord, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.{Nothing, Just}

  def lt?(%Nothing{}, %Just{}), do: true
  def lt?(%Nothing{}, %Nothing{}), do: false

  def le?(%Nothing{}, %Just{}), do: true
  def le?(%Nothing{}, %Nothing{}), do: true

  def gt?(%Nothing{}, %Just{}), do: false
  def gt?(%Nothing{}, %Nothing{}), do: false

  def ge?(%Nothing{}, %Just{}), do: false
  def ge?(%Nothing{}, %Nothing{}), do: true
end

# END:impl_ord
