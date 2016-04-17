import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import String
import Random exposing (Seed)
-- MODEL

type alias Model =
    { nextSeed : Seed
    , currentRFloat : Float
    , participants : List Participant
    , success_prob : Float
    , success_steps : Int
    , fail_steps : Int
    , fail_steps_all : Int
    }

type alias Participant =
    { id : Int
    , loc : Int
    }

emptyModel : Model
emptyModel = 
    { nextSeed = firstSeed
    , currentRFloat = 0
    , participants = []
    , success_prob = 0.5
    , success_steps = 5
    , fail_steps = -2
    , fail_steps_all = -2
    }

-- UPDATE

type Action
    = StartSim
    | PauseSim
    | ResetSim
    | Tick

update : Action -> Model -> Model
update action model =
    case action of
        Tick ->
            let selectedP = List.head model.participants
            in case selectedP of 
                Just p ->
                    model
                Nothing ->
                    model
        _ ->
            model

performTick : Participant -> Model -> Model
performTick participant model = 
    let wasHeads = (randomFloat model).currentRFloat > model.success_prob
    in 
       if wasHeads then
         { model | }
       else
           {}
       
        

randomFloat : Model -> Model
randomFloat model =
  let
      (f, s) = Random.generate (Random.float 0 1) model.nextSeed
  in
      { model | nextSeed = s, currentRFloat = f }

firstSeed : Seed
firstSeed = Random.initialSeed <| round startTime


-- Somewhat annoyingly, we need to do this to get random numbers
port startTime : Float
