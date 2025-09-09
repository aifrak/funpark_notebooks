# START:protocol

defprotocol FunPark.Foldable do
  def fold_l(structure, transform_fn, base)
  def fold_r(structure, transform_fn, base)
end

# END:protocol
