defmodule FunPark.Macros do
  # START:eq_for
  defmacro eq_for(for_struct, field) do
    quote do
      alias FunPark.Eq

      defimpl FunPark.Eq, for: unquote(for_struct) do
        def eq?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Eq.eq?(v1, v2)

        def not_eq?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Eq.not_eq?(v1, v2)
      end
    end
  end

  # END:eq_for

  # START:ord_for
  defmacro ord_for(for_struct, field) do
    quote do
      alias FunPark.Ord

      defimpl FunPark.Ord, for: unquote(for_struct) do
        def lt?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Ord.lt?(v1, v2)

        def le?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Ord.le?(v1, v2)

        def gt?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Ord.gt?(v1, v2)

        def ge?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ),
            do: Ord.ge?(v1, v2)
      end
    end
  end

  # END:ord_for
end
