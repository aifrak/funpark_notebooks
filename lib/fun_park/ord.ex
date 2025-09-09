# START:protocol
defprotocol FunPark.Ord do
  @fallback_to_any true

  def lt?(a, b)
  def le?(a, b)
  def gt?(a, b)
  def ge?(a, b)
end

# END:protocol

# START:impl_any
defimpl FunPark.Ord, for: Any do
  def lt?(a, b), do: a < b
  def le?(a, b), do: a <= b
  def gt?(a, b), do: a > b
  def ge?(a, b), do: a >= b
end

# END:impl_any

# START:impl_date_time
defimpl FunPark.Ord, for: DateTime do
  def lt?(a, b), do: DateTime.compare(a, b) == :lt
  def le?(a, b), do: match?(x when x in [:lt, :eq], DateTime.compare(a, b))
  def gt?(a, b), do: DateTime.compare(a, b) == :gt
  def ge?(a, b), do: match?(x when x in [:gt, :eq], DateTime.compare(a, b))
end

# END:impl_date_time
