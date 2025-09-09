defmodule FunPark.Math do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]
  alias FunPark.Monoid
  alias FunPark.Monad.Maybe

  def positive?(value) when is_number(value) do
    value > 0
  end

  def negative?(value) when is_number(value) do
    value < 0
  end

  # START:sum
  def sum(a, b) do
    m_append(%Monoid.Sum{}, a, b)
  end

  # START:sum_concat
  def sum(list) when is_list(list) do
    m_concat(%Monoid.Sum{}, list)
  end

  # END:sum_concat
  # END:sum

  # START:max
  def max(a, b) do
    m_append(%Monoid.Max{value: Float.min_finite()}, a, b)
  end

  def max(list) when is_list(list) do
    m_concat(%Monoid.Max{value: Float.min_finite()}, list)
  end

  # END:max

  # START:min
  def min(a, b) do
    m_append(%Monoid.Min{id: Float.max_finite()}, a, b)
  end

  def min(list) when is_list(list) do
    m_concat(%Monoid.Min{id: Float.max_finite()}, list)
  end

  # END:min

  # START:divide
  def divide(_numerator, 0), do: Maybe.nothing()

  def divide(numerator, denominator),
    do: Maybe.just(numerator / denominator)

  # END:divide

  # START:maybe_divide
  def maybe_divide(_numerator, 0), do: Maybe.nothing()

  def maybe_divide(numerator, denominator),
    do: Maybe.just(numerator / denominator)

  # END:divide
end
