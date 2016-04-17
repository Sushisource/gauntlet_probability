module View (view) where

import Signal exposing (Signal, Address)
import Graphics.Collage exposing (collage, Form, move, filled, rect)
import Graphics.Element exposing (..)
import Color exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
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

drawSlider : String -> Int -> Int -> Html
drawSlider name maxRange curval =
    let id' = name ++ "_slider"
        scurval = toString curval
    in
    div [] 
    [ text name
    , input [ id id'
            , type' "range"
            , Html.Attributes.max (toString maxRange)
            , value scurval
            ] []
    , text scurval
    ]

view : Signal.Address Action -> Model -> Html
view address model =
  div
  [ ]
  [ div [] [ renderSim (800, 600) model |> fromElement ]
  , div []
      [ drawSlider "SuccessProbability" 100 (round model.success_prob * 100)
      , drawSlider "SuccessSteps" 100 model.success_steps
      ]
  ]
