module View (view) where

import Signal exposing (Signal, Address)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (..)
import Html exposing (..)

import Model exposing (Model, Participant)
import Actions exposing(..)

pSiz = 10
vSpacing = 25

renderSim : (Int, Int) -> Model -> Element
renderSim (w',h') model =
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

view : Signal.Address Action -> Model -> Html
view address model =
  div
  [ ]
  [ div
    [ ]
    [ renderSim (800, 600) model |> fromElement ]
  ]
