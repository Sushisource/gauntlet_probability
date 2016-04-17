module Model (Model, Participant, initial) where

import Random exposing (Seed)
import Time exposing (Time)
import Array exposing (Array)

-- Unused right now
type alias Animation =
  Maybe { prevClockTime : Time, elapsed : Time }

type alias Model =
    { nextSeed : Seed
    , currentRFloat : Float
    , currentP : Int
    , participants : Array Participant
    , success_prob : Float
    , success_steps : Int
    , fail_steps : Int
    , fail_steps_all : Int
    , boardLength : Int
    , animation : Animation
    }

type alias Participant =
    { id : Int
    , xpos : Int
    }

emptyModel : Model
emptyModel = 
    { nextSeed = Random.initialSeed 123 --TODO Get new ones somehow
    , currentRFloat = 0
    , currentP = 0
    , participants = Array.empty
    , success_prob = 0.9
    , success_steps = 5
    , fail_steps = -2
    , fail_steps_all = -2
    , boardLength = 100
    , animation = Nothing
    }

initial = { emptyModel 
             | participants = Array.fromList
    [ {id = 0, xpos = 0}
    , {id = 1, xpos = 0}
    , {id = 2, xpos = 0}
    , {id = 3, xpos = 0}
    , {id = 4, xpos = 0}
    ]}

