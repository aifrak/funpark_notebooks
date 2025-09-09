defmodule FunPark.Errors.EffectError do
  defstruct [:stage, :reason, __exception__: true]

  @behaviour Exception

  @type t :: %__MODULE__{
          stage: atom(),
          reason: any()
        }

  @spec new(atom(), any()) :: t()
  def new(stage, reason), do: %__MODULE__{stage: stage, reason: reason}

  @impl Exception
  def exception(%{stage: stage, reason: reason}),
    do: %__MODULE__{stage: stage, reason: reason}

  @impl Exception
  def message(%__MODULE__{stage: stage, reason: reason}) do
    "EffectError at #{stage}: #{Exception.message(reason)}"
  rescue
    _ -> "EffectError at #{stage}: #{inspect(reason)}"
  end
end
