defmodule FunPark.Eq.Utils do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]

  alias FunPark.Eq
  alias FunPark.Monoid

  # START:contramap
  def contramap(f, eq \\ Eq) do
    eq = to_eq_map(eq)

    %{
      eq?: fn a, b -> eq.eq?.(f.(a), f.(b)) end,
      not_eq?: fn a, b -> eq.not_eq?.(f.(a), f.(b)) end
    }
  end

  # END:contramap

  # START:eq?
  def eq?(a, b, eq \\ Eq) do
    eq = to_eq_map(eq)
    eq.eq?.(a, b)
  end

  # END:eq?

  # START:not_eq?
  def not_eq?(a, b, eq \\ Eq) do
    eq = to_eq_map(eq)
    eq.not_eq?.(a, b)
  end

  # END:not_eq?

  # START:append_all
  def append_all(a, b) do
    m_append(%Monoid.Eq.All{}, a, b)
  end

  # END:append_all

  # START:concat_all
  def concat_all(eq_list) when is_list(eq_list) do
    m_concat(%Monoid.Eq.All{}, eq_list)
  end

  # END:concat_all

  # START:append_any
  def append_any(a, b) do
    m_append(%Monoid.Eq.Any{}, a, b)
  end

  # END:append_any

  # START:concat_any
  def concat_any(eq_list) when is_list(eq_list) do
    m_concat(%Monoid.Eq.Any{}, eq_list)
  end

  # END:concat_any

  # START:to_predicate
  def to_predicate(target, eq \\ Eq) do
    eq = to_eq_map(eq)

    fn elem -> eq.eq?.(elem, target) end
  end

  # END:to_predicate

  # START:to_eq_map
  def to_eq_map(%{eq?: eq_fun, not_eq?: not_eq_fun} = eq_map)
      when is_function(eq_fun, 2) and is_function(not_eq_fun, 2) do
    eq_map
  end

  def to_eq_map(module) when is_atom(module) do
    %{
      eq?: &module.eq?/2,
      not_eq?: &module.not_eq?/2
    }
  end

  # END:to_eq_map
end
