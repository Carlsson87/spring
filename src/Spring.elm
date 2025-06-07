module Spring exposing (Config, Spring, config, create, equilibrium, setEquilibriumThreshold, update, value)


type Spring
    = Spring
        { value : Float
        , target : Float
        , velocity : Float
        }


type Config
    = Config
        { tension : Float
        , friction : Float
        , equilibriumThreshold : Float
        }


config : { tension : Float, friction : Float } -> Config
config x =
    Config
        { tension = x.tension
        , friction = x.friction
        , equilibriumThreshold = 0.05
        }


setEquilibriumThreshold : Float -> Config -> Config
setEquilibriumThreshold equilibriumThreshold (Config cfg) =
    Config { cfg | equilibriumThreshold = equilibriumThreshold }


create : { value : Float, target : Float } -> Spring
create x =
    Spring
        { value = x.value
        , target = x.target
        , velocity = 0
        }


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


value : Spring -> Float
value (Spring x) =
    x.value


equilibrium : Spring -> Bool
equilibrium (Spring x) =
    x.value == x.target && x.velocity == 0
