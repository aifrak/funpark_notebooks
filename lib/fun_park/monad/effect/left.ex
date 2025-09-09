defmodule FunPark.Monad.Effect.Left do
  alias FunPark.Monad.Either

  # START:basic
  defstruct [:effect]

  # START:pure
  def pure(value) do
    %__MODULE__{
      effect: fn _env ->
        Task.async(fn -> Either.left(value) end)
      end
    }
  end

  # END:pure

  # END:basic

  def asks(f) do
    %__MODULE__{
      effect: fn env ->
        Task.async(fn -> Either.left(f.(env)) end)
      end
    }
  end
end

defimpl FunPark.Monad, for: FunPark.Monad.Effect.Left do
  alias FunPark.Monad.Effect.Left

  # START:map
  def map(%Left{} = left, _transform), do: left

  # END:map

  # START:bind
  def bind(%Left{} = left, _func), do: left

  # END:bind

  def ap(%Left{} = left, _func), do: left
end
