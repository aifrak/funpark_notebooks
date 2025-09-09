defmodule FunPark.Reader do
  # START:basic
  @enforce_keys [:run]
  defstruct [:run]

  # START:pure
  def pure(value), do: %__MODULE__{run: fn _env -> value end}
  # END:pure

  def run(%__MODULE__{run: f}, env), do: f.(env)
  # END:basic

  # START:ask
  def ask, do: %__MODULE__{run: fn env -> env end}
  # END:ask

  # START:asks
  def asks(func), do: %__MODULE__{run: func}
  # END:asks
end

# START:impl_monad
defimpl FunPark.Monad, for: FunPark.Reader do
  alias FunPark.Reader

  def map(%Reader{run: f}, func),
    do: %Reader{run: fn env -> func.(f.(env)) end}

  def bind(%Reader{run: f}, func),
    do: %Reader{run: fn env -> func.(f.(env)).run.(env) end}

  def ap(%Reader{run: f_func}, %Reader{run: f_value}),
    do: %Reader{run: fn env -> f_func.(env).(f_value.(env)) end}
end

# END:impl_monad
