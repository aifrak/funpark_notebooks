defmodule FunPark.Monoid.Utils do
  import FunPark.Monoid, only: [empty: 1, append: 2, wrap: 2, unwrap: 1]
  import FunPark.Foldable, only: [fold_l: 3]

  # START:m_append
  def m_append(monoid, a, b) when is_struct(monoid) do
    append(wrap(monoid, a), wrap(monoid, b)) |> unwrap()
  end

  # END:m_append

  # START:m_concat
  def m_concat(monoid, values) when is_struct(monoid) and is_list(values) do
    fold_l(values, empty(monoid), fn value, acc ->
      append(acc, wrap(monoid, value))
    end)
    |> unwrap()
  end

  # END:m_concat
end
