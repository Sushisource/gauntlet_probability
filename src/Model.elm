module Model (Model, Participant, initial) where

import Random exposing (Seed)

type alias Model =
    { nextSeed : Seed
    , currentRFloat : Float
    , participants : List Participant
    , success_prob : Float
    , success_steps : Int
    , fail_steps : Int
    , fail_steps_all : Int
    , boardLength : Int
    }

type alias Participant =
    { id : Int
    , xpos : Int
    }

emptyModel : Model
emptyModel = 
    { nextSeed = Random.initialSeed 123 --TODO Get new ones somehow
    , currentRFloat = 0
    , participants = []
    , success_prob = 0.5
    , success_steps = 5
    , fail_steps = -2
    , fail_steps_all = -2
    , boardLength = 100
    }

initial = { emptyModel 
             | participants =
    [ {id = 0, xpos = 0}
    , {id = 1, xpos = 0}
    , {id = 2, xpos = 0}
    , {id = 3, xpos = 0}
    , {id = 4, xpos = 0}
    ]}

