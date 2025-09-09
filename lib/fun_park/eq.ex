# START:protocol
defprotocol FunPark.Eq do
  @fallback_to_any true

  def eq?(a, b)

  def not_eq?(a, b)
end

# END:protocol

# START:impl_any
defimpl FunPark.Eq, for: Any do
  def eq?(a, b), do: a == b
  def not_eq?(a, b), do: a != b
end

# END:impl_any

# START:impl_date_time
defimpl FunPark.Eq, for: DateTime do
  def eq?(a, b), do: DateTime.compare(a, b) == :eq
  def not_eq?(a, b), do: DateTime.compare(a, b) != :eq
end

# END:impl_date_time
