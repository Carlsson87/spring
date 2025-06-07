# Spring

Simulate spring based motions.

## Usage

```elm
import Spring exposing (Spring)

config : Spring.Config
config =
    Spring.config
        { strength = 500
        , friction = 10
        }

mySpring : Spring
mySpring =
    Spring.create
        { target = 100
        , value = 0
        }

updatedSpring : Spring
updatedSpring =
    Spring.update config 16 mySpring
```

