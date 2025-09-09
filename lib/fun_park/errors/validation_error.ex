# START:module
defmodule FunPark.Errors.ValidationError do
  defstruct errors: [], __exception__: true

  @behaviour Exception

  def new(errors) when is_list(errors), do: %__MODULE__{errors: errors}

  def new(error), do: %__MODULE__{errors: [error]}

  def merge(%__MODULE__{errors: e1}, %__MODULE__{errors: e2}),
    do: %__MODULE__{errors: e1 ++ e2}

  @impl Exception
  def exception(args) when is_list(args), do: struct(__MODULE__, args)

  @impl Exception
  def exception(message) when is_binary(message),
    do: %__MODULE__{errors: [message]}

  @impl Exception
  def message(%__MODULE__{errors: errors}) do
    Enum.map_join(errors, ", ", &to_string/1)
  end
end

# END:module

# START:impl_appendable
defimpl FunPark.Appendable, for: FunPark.Errors.ValidationError do
  alias FunPark.Errors.ValidationError

  def coerce(%ValidationError{errors: e}), do: ValidationError.new(e)

  def append(%ValidationError{} = acc, %ValidationError{} = value) do
    ValidationError.merge(acc, value)
  end
end

# END:impl_appendable
