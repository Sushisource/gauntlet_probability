module Update (update) where

import Maybe exposing (withDefault)
import Effects exposing (Effects)
import Random
import Array exposing (Array)
import Debug

import Model exposing (Model, Participant)
import Actions exposing (..)

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        StartSim t ->
            let seed = Random.initialSeed (floor t)
            in
               ({model | nextSeed = seed}, Effects.tick Tick)
        Tick t ->
            -- Could make this random, for now it's just always p1
            let (chosenOne, s2) = randInt model |> Debug.log "chosen"
                pModder = (performTick chosenOne model)
                updatedPs = Array.indexedMap pModder model.participants
            in
              ({model | participants = updatedPs, nextSeed = s2}, Effects.tick Tick)
        _ ->
            (model, Effects.none)

performTick : Int -> Model -> Int -> Participant -> Participant
performTick chosenIx model curIx curP = 
    let (rfloat, _) = randomFloat model 
        wasHeads = rfloat < model.success_prob
        curIsChosen = curIx == chosenIx
    in 
       if wasHeads then
         if curIsChosen then
           { curP | xpos = curP.xpos + model.success_steps }
         else
           curP
       else
         if curIsChosen then
           { curP | xpos = curP.xpos - model.fail_steps }
         else
           { curP | xpos = curP.xpos - model.fail_steps_all }

moveP :  Int -> Participant -> Participant
moveP amount p =
    { p | xpos = max 0 (p.xpos + amount) }

randomFloat : Model -> (Float, Random.Seed)
randomFloat model =
  Random.generate (Random.float 0 1) model.nextSeed

randInt : Model -> (Int, Random.Seed)
randInt model =
  Random.generate (Random.int 0 (Array.length model.participants - 1)) model.nextSeed
