defmodule FunPark.Ride.FastLane do
  import FunPark.Monad, only: [ap: 2, bind: 2, map: 2]
  import FunPark.Utils, only: [curry: 1, curry_r: 1]

  alias FunPark.Monad.Either
  alias FunPark.Ride
  alias FunPark.Patron
  alias FunPark.Errors.ValidationError
  alias FunPark.Maintenance

  # START:ensure_height
  def ensure_height(%Patron{} = patron, %Ride{} = ride) do
    patron
    |> Either.lift_predicate(
      curry_r(&Ride.tall_enough?/2).(ride),
      fn p -> "#{Patron.get_name(p)} is not tall enough" end
    )
    |> Either.map_left(&ValidationError.new/1)
  end

  # END:ensure_height

  # START:ensure_age
  def ensure_age(%Patron{} = patron, %Ride{} = ride) do
    patron
    |> Either.lift_predicate(
      curry_r(&Ride.old_enough?/2).(ride),
      fn p -> "#{Patron.get_name(p)} is not old enough" end
    )
    |> Either.map_left(&ValidationError.new/1)
  end

  # END:ensure_age

  # START:ensure_eligibility
  def ensure_eligibility(%Patron{} = patron, %Ride{} = ride) do
    validate_height = curry_r(&ensure_height/2)

    patron
    |> ensure_age(ride)
    |> bind(validate_height.(ride))
  end

  # END:ensure_eligibility

  # START:ensure_fast_pass
  def ensure_fast_pass(%Patron{} = patron, %Ride{} = ride) do
    patron
    |> Either.lift_predicate(
      curry_r(&Ride.fast_pass?/2).(ride),
      fn p -> "#{Patron.get_name(p)} does not have a fast pass" end
    )
    |> Either.map_left(&ValidationError.new/1)
  end

  # END:ensure_fast_pass

  # START:ensure_vip_or_fast_pass
  def ensure_vip_or_fast_pass(%Patron{} = patron, %Ride{} = ride) do
    patron
    |> Either.lift_predicate(
      &Patron.vip?/1,
      fn p -> "#{Patron.get_name(p)} is not a VIP" end
    )
    |> Either.map_left(&ValidationError.new/1)
    |> Either.or_else(fn -> ensure_fast_pass(patron, ride) end)
  end

  # END:ensure_vip_or_fast_pass

  # START:ensure_fast_pass_lane
  def ensure_fast_pass_lane(%Patron{} = patron, %Ride{} = ride) do
    ensure_vip_or_pass = curry_r(&ensure_vip_or_fast_pass/2)

    patron
    |> ensure_eligibility(ride)
    |> bind(ensure_vip_or_pass.(ride))
  end

  # END:ensure_fast_pass_lane

  # START:ensure_fast_pass_lane_group
  def ensure_fast_pass_lane_group(
        patrons,
        %Ride{} = ride
      )
      when is_list(patrons) do
    eligible_for_fast_lane = curry_r(&ensure_fast_pass_lane/2)

    Either.traverse(
      patrons,
      eligible_for_fast_lane.(ride)
    )
  end

  # END:ensure_fast_pass_lane_group

  # START:validate_eligibility
  def validate_eligibility(%Patron{} = patron, %Ride{} = ride) do
    validate_height = curry_r(&ensure_height/2)
    validate_age = curry_r(&ensure_age/2)

    patron
    |> Either.validate([validate_height.(ride), validate_age.(ride)])
  end

  # END:validate_eligibility

  # START:validate_fast_pass_lane
  def validate_fast_pass_lane(%Patron{} = patron, %Ride{} = ride) do
    validate_eligibility = curry(&validate_eligibility/2)
    validate_vip_or_pass = curry(&ensure_vip_or_fast_pass/2)

    Either.validate(
      ride,
      [
        validate_eligibility.(patron),
        validate_vip_or_pass.(patron),
        &Ride.ensure_online/1
      ]
    )
    |> map(fn _ -> patron end)
  end

  # END:validate_fast_pass_lane

  # START:validate_fast_pass_lane_b
  def validate_fast_pass_lane_b(%Patron{} = patron, %Ride{} = ride) do
    validate_vip_or_pass = curry(&ensure_vip_or_fast_pass/2)
    validate_eligibility = curry(&validate_eligibility/2)

    Either.validate(
      ride,
      [
        validate_eligibility.(patron),
        validate_vip_or_pass.(patron)
      ]
    )
    |> bind(&Maintenance.ensure_online/1)
    |> map(fn _ -> patron end)
  end

  # END:validate_fast_pass_lane_b

  # START:validate_fast_pass_lane_answer_a
  def validate_answer_a(%Patron{} = patron, %Ride{} = ride) do
    validate_vip_or_pass = curry(&ensure_vip_or_fast_pass/2)

    validate_eligibility =
      curry(fn p, r ->
        validate_eligibility(p, r)
        |> Either.map_left(fn _ ->
          "#{Patron.get_name(p)} is not eligible for this ride"
        end)
      end)

    Either.validate(
      ride,
      [
        validate_eligibility.(patron),
        validate_vip_or_pass.(patron),
        &Ride.ensure_online/1
      ]
    )
    |> map(fn _ -> patron end)
  end

  # END:validate_fast_pass_lane_answer_a

  # START:validate_fast_pass_lane_answer_b
  def validate_answer_b(%Patron{} = patron, %Ride{} = ride) do
    validate_vip_or_pass = curry(&ensure_vip_or_fast_pass/2)
    validate_eligibility = curry(&validate_eligibility/2)

    validate_fast_lane =
      Either.validate(
        ride,
        [
          validate_eligibility.(patron),
          validate_vip_or_pass.(patron)
        ]
      )

    Ride.ensure_online(ride)
    |> Either.map_left(fn message -> [message] end)
    |> ap(validate_fast_lane)
    |> map(fn _ -> patron end)
  end

  # END:validate_fast_pass_lane_answer_b

  # START:validate_fast_pass_lane_answer_c
  def validate_answer_c(%Patron{} = patron, %Ride{} = ride) do
    validate_fast_lane =
      curry_r(fn p, r ->
        ensure_vip_or_fast_pass(p, r)
        |> Either.map_left(fn _ ->
          "#{Patron.get_name(p)} can ride, but not through the fast lane"
        end)
      end)

    validate_eligibility =
      curry_r(fn p, r ->
        validate_eligibility(p, r)
        |> Either.map_left(fn _ ->
          "#{Patron.get_name(p)} is not eligible for this ride"
        end)
      end)

    Either.validate(
      patron,
      [
        validate_eligibility.(ride),
        validate_fast_lane.(ride)
      ]
    )
    |> map(fn _ ->
      "#{Patron.get_name(patron)} can enter the fast lane"
    end)
    |> Either.map_left(fn [first | _] -> first end)
  end

  # END:validate_fast_pass_lane_answer_c

  def validate_fast_pass_lane_a(%Patron{} = patron, %Ride{} = ride) do
    validate_eligibility = curry_r(&validate_eligibility/2)
    validate_vip_or_pass = curry_r(&ensure_vip_or_fast_pass/2)

    patron
    |> Either.validate([
      validate_eligibility.(ride),
      validate_vip_or_pass.(ride)
    ])
  end

  # START:validate_fast_pass_lane_group
  def validate_fast_pass_lane_group(
        patrons,
        %Ride{} = ride
      )
      when is_list(patrons) do
    validate_fast_lane = curry_r(&validate_fast_pass_lane/2)

    patrons
    |> Either.traverse_a(validate_fast_lane.(ride))
  end

  # END:validate_fast_pass_lane_group
end
