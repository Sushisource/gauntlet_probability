import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import String
import Random exposing (Seed)
import Maybe exposing (withDefault)
-- MODEL

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
    { nextSeed = firstSeed
    , currentRFloat = 0
    , participants = []
    , success_prob = 0.5
    , success_steps = 5
    , fail_steps = -2
    , fail_steps_all = -2
    , boardLength = 100
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
            -- Could make this random, for now it's just always p1
            let selectedP = List.head model.participants
                others = List.tail model.participants |> withDefault []
            in case selectedP of 
                Just p ->
                    performTick p others model
                Nothing ->
                    model
        _ ->
            model

performTick : Participant -> List Participant -> Model -> Model
performTick mainP otherPs model = 
    let wasHeads = (randomFloat model).currentRFloat > model.success_prob
    in 
       if wasHeads then
        let adancedMP = moveP model.success_steps mainP 
        in
          { model | participants = adancedMP :: otherPs }
       else
         let backedP = moveP model.fail_steps mainP
             backedOthers = List.map (moveP model.fail_steps_all) otherPs
         in
          { model | participants = backedP :: backedOthers }

moveP :  Int -> Participant -> Participant
moveP amount p =
    { p | xpos = p.xpos + amount }

randomFloat : Model -> Model
randomFloat model =
  let
      (f, s) = Random.generate (Random.float 0 1) model.nextSeed
  in
      { model | nextSeed = s, currentRFloat = f }

firstSeed : Seed
firstSeed = Random.initialSeed <| round startTime

-- removeFromList : Int -> List -> List
-- removeFromList i xs =
--   (List.take i xs) ++ (List.drop (i+1) xs)


-- Somewhat annoyingly, we need to do this to get random numbers
port startTime : Float
