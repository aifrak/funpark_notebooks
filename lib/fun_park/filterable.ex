# START:protocol
defprotocol FunPark.Filterable do
  def guard(structure, bool)
  def filter(structure, predicate)
  def filter_map(structure, func)
end

# END:protocol
