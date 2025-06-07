module Spring exposing
    ( Spring, create, update, value, equilibrium
    , Config, config, setEquilibriumThreshold
    )

{-| A simple spring simulation for smooth, physically-inspired animations.

This module provides a spring model that moves a value toward a target over time,
based on configurable tension and friction. It can be used to animate values like
positions, sizes, or any other continuous quantity.


# Spring

@docs Spring, create, update, value, equilibrium


# Configuration

@docs Config, config, setEquilibriumThreshold

-}

-- TYPES


{-| A `Spring` represents a value that moves toward a target using spring dynamics.

It holds the current value, the target value, and the velocity of the spring.

-}
type Spring
    = Spring
        { value : Float
        , target : Float
        , velocity : Float
        }


{-| Configuration for a spring simulation.

Includes:

  - `tension`: how strongly the spring is pulled toward the target
  - `friction`: how much resistance slows the spring down
  - `equilibriumThreshold`: how close is “close enough” to be considered settled

-}
type Config
    = Config
        { tension : Float
        , friction : Float
        , equilibriumThreshold : Float
        }



-- CONFIGURATION


{-| Create a basic `Config` using the given tension and friction values.

The `equilibriumThreshold` is set to a default of `0.05`, which defines how close the
spring’s value and velocity must be to the target and zero, respectively, before
it is considered at rest.

    config { tension = 100, friction = 15 }

-}
config : { tension : Float, friction : Float } -> Config
config x =
    Config
        { tension = x.tension
        , friction = x.friction
        , equilibriumThreshold = 0.05
        }


{-| Override the `equilibriumThreshold` of a given `Config`.

This can be useful if you want to change how strictly the spring checks for rest.

    config { tension = 100, friction = 15 }
        |> setEquilibriumThreshold 0.01

-}
setEquilibriumThreshold : Float -> Config -> Config
setEquilibriumThreshold equilibriumThreshold (Config cfg) =
    Config { cfg | equilibriumThreshold = equilibriumThreshold }



-- SPRING CREATION


{-| Create a new `Spring` given an initial value and a target.

The initial velocity will be zero.

    create { value = 0, target = 100 }

-}
create : { value : Float, target : Float } -> Spring
create x =
    Spring
        { value = x.value
        , target = x.target
        , velocity = 0
        }



-- SIMULATION


{-| Step the spring simulation forward by a given number of milliseconds.

Applies the configured spring dynamics to update the value and velocity.

If the spring is close enough to equilibrium (as defined by the threshold in the config),
it snaps to rest.

    update myConfig 16 mySpring

-}
update : Config -> Float -> Spring -> Spring
update (Config cfg) deltaMs (Spring x) =
    if
        abs (x.value - x.target)
            < cfg.equilibriumThreshold
            && abs x.velocity
            < cfg.equilibriumThreshold
    then
        Spring { x | value = x.target, velocity = 0 }

    else
        let
            deltaSeconds =
                deltaMs / 1000

            acc =
                deltaSeconds * (((x.target - x.value) * cfg.tension) - (x.velocity * cfg.friction))

            newVelocity =
                x.velocity + acc
        in
        Spring { x | value = x.value + newVelocity * deltaSeconds, velocity = newVelocity }



-- INSPECTION


{-| Get the current value of a `Spring`.

    value mySpring

-}
value : Spring -> Float
value (Spring x) =
    x.value


{-| Check if a `Spring` is at equilibrium.

This returns `True` if the value equals the target and the velocity is zero.

    equilibrium mySpring

-}
equilibrium : Spring -> Bool
equilibrium (Spring x) =
    x.value == x.target && x.velocity == 0
