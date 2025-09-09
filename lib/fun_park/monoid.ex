# START:protocol
defprotocol FunPark.Monoid do
  def empty(monoid_struct)
  def append(monoid_struct_a, monoid_struct_b)
  def wrap(monoid_struct, value)
  def unwrap(monoid_struct)
end

# END:protocol
