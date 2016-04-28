module View (view) where

import Signal exposing (Signal, Address)
import Graphics.Collage exposing (collage, Form, move, filled, rect)
import Graphics.Element exposing (..)
import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Array

import Model exposing (Model, Participant)
import Actions exposing(..)

pSiz = 10
vSpacing = 25

renderSim : (Int, Int) -> Model -> Element
renderSim (w',h') model =
  let
    (w,h) = (toFloat w', toFloat h')
    pRects = Array.indexedMap drawPs model.participants |> Array.toList
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

drawSlider : String -> b -> b -> b -> b -> Signal.Address a -> (String -> a) -> Html
drawSlider name minRange maxRange stepSiz curval address action =
    let id' = name ++ "_slider"
        scurval = toString curval
    in
    div [] 
    [ text name
    , input [ id id'
            , type' "range"
            , Html.Attributes.min (toString minRange)
            , Html.Attributes.max (toString maxRange)
            , step (toString stepSiz)
            , value scurval
            , Events.on "change" Events.targetValue (\v -> Signal.message address (action v))
            ] []
    , text scurval
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
  [ ]
  [ div [] [ renderSim (800, 600) model |> fromElement ]
  , div []
      [ button [Events.onClick address PauseSim] [text "Pause"]
      , button [Events.onClick address ResumeSim] [text "Resume/Start"]
      , button [Events.onClick address ResetSim] [text "Reset"]
      , h3 [] [text "Sliders work best when the sim is paused"]
      , h4 [] [text "Set FailStepsAll to zero to witness gauntlet magicks"]
      , drawSlider "SuccessProbability" 0.01 1.01 0.01 model.success_prob address Actions.UpdateSProb
      , drawSlider "SuccessSteps" 0 30 1 model.success_steps address Actions.UpdateSSteps
      , drawSlider "FailSteps" 0 30 1 model.fail_steps address Actions.UpdateFSteps
      , drawSlider "FailStepsAll" 0 30 1 model.fail_steps_all address Actions.UpdateFASteps
      , drawSlider "Participants" 0 30 1 model.numParticipants address Actions.UpdateParticipants
      ]
  ]

