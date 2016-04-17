module Update (update) where

import Maybe exposing (withDefault)
import Effects exposing (Effects)
import Random

import Model exposing (Model, Participant)
import Actions exposing (..)



update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Tick t ->
            -- Could make this random, for now it's just always p1
            let selectedP = List.head model.participants
                others = List.tail model.participants |> withDefault []
            in case selectedP of 
                Just p ->
                    (performTick p others model, Effects.none)
                Nothing ->
                    (model, Effects.none)
        _ ->
            (model, Effects.none)

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
