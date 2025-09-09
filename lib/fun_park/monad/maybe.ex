defmodule FunPark.Monad.Maybe do
  import FunPark.Monad, only: [bind: 2, map: 2]
  import FunPark.Foldable, only: [fold_l: 3]
  alias FunPark.Monad.Maybe.{Just, Nothing}
  # alias FunPark.Monad.Either.{Left, Right}
  alias FunPark.Eq
  alias FunPark.Identity
  alias FunPark.Ord

  # START:basic

  def just(value), do: Just.pure(value)
  def nothing, do: Nothing.pure()
  def pure(value), do: just(value)

  def just?(%Just{}), do: true
  def just?(_), do: false

  def nothing?(%Nothing{}), do: true
  def nothing?(_), do: false
  # END:basic

  # START:guard
  def guard(maybe, true), do: maybe
  def guard(_maybe, false), do: nothing()
  # END:guard

  # START:filter
  def filter(maybe, predicate) do
    bind(maybe, fn value ->
      if predicate.(value) do
        pure(value)
      else
        nothing()
      end
    end)
  end

  # END:filter

  # START:or_else
  def or_else(%Nothing{}, fallback_fun) when is_function(fallback_fun, 0),
    do: fallback_fun.()

  def or_else(%Just{} = just, _fallback_fun), do: just
  # END:or_else

  # START:get_or_else
  def get_or_else(maybe, default) do
    fold_l(maybe, fn value -> value end, fn -> default end)
  end

  # END:get_or_else

  # START:lift_eq
  def lift_eq(custom_eq) do
    custom_eq = Eq.Utils.to_eq_map(custom_eq)

    %{
      eq?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_eq.eq?.(v1, v2)
        %Nothing{}, %Nothing{} -> true
        %Nothing{}, %Just{} -> false
        %Just{}, %Nothing{} -> false
      end,
      not_eq?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_eq.not_eq?.(v1, v2)
        %Nothing{}, %Nothing{} -> false
        %Nothing{}, %Just{} -> true
        %Just{}, %Nothing{} -> true
      end
    }
  end

  # END:lift_eq

  # START:lift_ord
  def lift_ord(custom_ord) do
    custom_ord = Ord.Utils.to_ord_map(custom_ord)

    %{
      lt?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_ord.lt?.(v1, v2)
        %Nothing{}, %Nothing{} -> false
        %Nothing{}, %Just{} -> true
        %Just{}, %Nothing{} -> false
      end,
      le?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_ord.le?.(v1, v2)
        %Nothing{}, %Nothing{} -> true
        %Nothing{}, %Just{} -> true
        %Just{}, %Nothing{} -> false
      end,
      gt?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_ord.gt?.(v1, v2)
        %Nothing{}, %Nothing{} -> false
        %Just{}, %Nothing{} -> true
        %Nothing{}, %Just{} -> false
      end,
      ge?: fn
        %Just{value: v1}, %Just{value: v2} -> custom_ord.ge?.(v1, v2)
        %Nothing{}, %Nothing{} -> true
        %Just{}, %Nothing{} -> true
        %Nothing{}, %Just{} -> false
      end
    }
  end

  # END:lift_ord

  # START:sequence
  def sequence([]), do: pure([])

  def sequence([head | tail]) do
    bind(head, fn value ->
      bind(sequence(tail), fn rest ->
        pure([value | rest])
      end)
    end)
  end

  # END:sequence

  # def traverse([], _func), do: pure([])

  # def traverse([head | tail], func) do
  #   bind(func.(head), fn value ->
  #     bind(traverse(tail, func), fn rest ->
  #       pure([value | rest])
  #     end)
  #   end)
  # end

  # START:traverse
  def traverse([], _func), do: pure([])

  def traverse(list, func) when is_list(list) and is_function(func, 1) do
    list
    |> Enum.reduce_while(pure([]), fn item, %Just{value: acc} ->
      case func.(item) do
        %Just{value: value} -> {:cont, pure([value | acc])}
        %Nothing{} -> {:halt, nothing()}
      end
    end)
    |> map(&:lists.reverse/1)
  end

  # END:traverse

  # START:concat
  def concat(list) when is_list(list) do
    list
    |> fold_l([], fn
      %Just{value: value}, acc -> [value | acc]
      %Nothing{}, acc -> acc
    end)
    |> :lists.reverse()
  end

  # END:concat

  # START:concat_map
  def concat_map(list, func) when is_list(list) and is_function(func, 1) do
    fold_l(list, [], fn item, acc ->
      case func.(item) do
        %Just{value: value} -> [value | acc]
        %Nothing{} -> acc
      end
    end)
    |> :lists.reverse()
  end

  # END:concat_map

  # START:lift_identity
  def lift_identity(%Identity{} = identity) do
    case identity do
      %Identity{value: nil} -> nothing()
      %Identity{value: value} -> just(value)
    end
  end

  # END:lift_identity

  # def lift_either(either) do
  #   case either do
  #     %Right{right: value} -> just(value)
  #     %Left{} -> nothing()
  #   end
  # end

  # START:lift_predicate
  def lift_predicate(value, predicate) when is_function(predicate, 1) do
    fold_l(
      fn -> predicate.(value) end,
      fn -> just(value) end,
      fn -> nothing() end
    )
  end

  # END:lift_predicate

  # START:bridge_nil
  def from_nil(nil), do: nothing()
  def from_nil(value), do: just(value)

  def to_nil(%Nothing{}), do: nil
  def to_nil(%Just{value: value}), do: value
  # END:bridge_nil

  # START:from_try
  def from_try(func) do
    try do
      result = func.()
      just(result)
    rescue
      _exception ->
        nothing()
    end
  end

  # END:from_try

  # START:to_try!
  def to_try!(maybe, message \\ "Nothing value encountered")
      when is_struct(maybe, Just) or is_struct(maybe, Nothing) do
    case maybe do
      %Just{value: value} -> value
      %Nothing{} -> raise message
    end
  end

  # END:to_try!

  # START:from_result
  def from_result({:ok, value}), do: just(value)
  def from_result({:error, _reason}), do: nothing()
  # END:from_result

  # START:to_result
  def to_result(maybe)
      when is_struct(maybe, Just) or
             is_struct(maybe, Nothing) do
    case maybe do
      %Just{value: value} -> {:ok, value}
      %Nothing{} -> {:error, :nothing}
    end
  end

  # END:to_result
end
