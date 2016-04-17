module GProb where

import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (..)
import Signal exposing (Signal, Address)
import String
import Random exposing (Seed)
import Maybe exposing (withDefault)
import Window
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

pSiz = 10
vSpacing = 25

-- UPDATE

type Action
    = StartSim
    | PauseSim
    | ResetSim
    | Tick
    | NoOp

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

-- VIEW
view : (Int, Int) -> Model -> Element
view (w',h') model =
  let
    (w,h) = (toFloat w', toFloat h')
    pRects = List.indexedMap drawPs model.participants
    topLeftPrects = List.map (move (-w/2 + 50, h/2 - 50)) pRects
  in
    collage w' h'
      ([ rect w h
          |> filled (rgb 174 238 238)
       ] ++ topLeftPrects)

drawPs : Int -> Participant -> Form
drawPs index p =
    rect pSiz pSiz
      |> filled (rgb 0 0 0)
      |> move (toFloat p.xpos, toFloat index * -vSpacing)

    

-- INPUT
main : Signal Element
main =
  Signal.map2 view Window.dimensions (Signal.foldp update defaultModel actions.signal)

-- actions from user input
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

defaultModel = { emptyModel 
             | participants =
    [ {id = 0, xpos = 0}
    , {id = 1, xpos = 0}
    , {id = 2, xpos = 0}
    , {id = 3, xpos = 0}
    , {id = 4, xpos = 0}
    ]}

-- Somewhat annoyingly, we need to do this to get random numbers
port startTime : Float
