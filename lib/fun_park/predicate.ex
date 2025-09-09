# START:module
defmodule FunPark.Predicate do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]
  alias FunPark.Monoid.Predicate.{All, Any}

  # START:p_and
  def p_and(pred1, pred2) when is_function(pred1) and is_function(pred2) do
    m_append(%All{}, pred1, pred2)
  end

  # END:p_and

  # START:p_or
  def p_or(pred1, pred2) when is_function(pred1) and is_function(pred2) do
    m_append(%Any{}, pred1, pred2)
  end

  # END:p_or

  # START:p_not
  def p_not(pred) when is_function(pred) do
    fn value -> not pred.(value) end
  end

  # END:p_not

  # START:p_all
  def p_all(p_list) when is_list(p_list) do
    m_concat(%All{}, p_list)
  end

  # END:p_all

  # START:p_any
  def p_any(p_list) when is_list(p_list) do
    m_concat(%Any{}, p_list)
  end

  # END:p_any

  # START:p_none
  def p_none(p_list) when is_list(p_list) do
    p_not(p_any(p_list))
  end

  # END:p_none
end

# END:module

# START:impl_fold
defimpl FunPark.Foldable, for: Function do
  def fold_l(predicate, true_func, false_func) do
    case predicate.() do
      true -> true_func.()
      false -> false_func.()
    end
  end

  def fold_r(predicate, true_func, false_func) do
    fold_l(predicate, true_func, false_func)
  end
end

# END:impl_fold
