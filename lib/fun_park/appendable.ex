# START:module
defprotocol FunPark.Appendable do
  @fallback_to_any true

  def coerce(term)

  def append(accumulator, coerced)
end

# END:module

# START:impl_any
defimpl FunPark.Appendable, for: Any do
  def coerce(value) when is_list(value), do: value
  def coerce(value), do: [value]

  def append(acc, value), do: coerce(acc) ++ coerce(value)
end

# END:impl_any
