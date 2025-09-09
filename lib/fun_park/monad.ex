# START:protocol
defprotocol FunPark.Monad do
  def map(monad_value, func)
  def bind(monad_value, func_returning_monad)
  def ap(monadic_func, monad_value)
end

# END:protocol
