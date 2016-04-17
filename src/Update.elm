module Update (update) where

import Maybe exposing (withDefault)
import Effects exposing (Effects)
import Random
import Array exposing (Array)
import Debug
import String
import Result

import Model exposing (Model, Participant, initial)
import Actions exposing (..)

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        StartSim t ->
            let seed = Random.initialSeed (floor t)
            in
               ({model | nextSeed = seed}, Effects.tick Tick)
        PauseSim ->
            -- Stops ticking
            ({model | paused = True}, Effects.none)
        ResetSim ->
            (initial, Effects.none)
        ResumeSim ->
            ({model | paused = False}, Effects.tick Tick)
        Tick t ->
            -- Could make this random, for now it's just always p1
            let (chosenOne, s2) = randInt model
                pModder = (performTick chosenOne model)
                updatedPs = Array.indexedMap pModder model.participants
                effect = if model.paused then Effects.none else Effects.tick Tick
            in
              ({model | participants = updatedPs, nextSeed = s2}, effect)
        UpdateSProb s ->
            ({model | success_prob = (String.toFloat s |> Result.withDefault model.success_prob)}, Effects.none)
        UpdateSSteps s ->
            ({model | success_steps = (String.toInt s |> Result.withDefault model.success_steps)}, Effects.none)
        UpdateFSteps s ->
            ({model | fail_steps = (String.toInt s |> Result.withDefault model.fail_steps)}, Effects.none)
        UpdateFASteps s ->
            ({model | fail_steps_all = (String.toInt s |> Result.withDefault model.fail_steps_all)}, Effects.none)
        NoOp ->
            (model, Effects.none)

performTick : Int -> Model -> Int -> Participant -> Participant
performTick chosenIx model curIx curP = 
    let (rfloat, _) = randomFloat model 
        wasHeads = rfloat < model.success_prob
        curIsChosen = curIx == chosenIx
    in 
       if wasHeads then
         if curIsChosen then
           moveP model.success_steps curP
         else
           curP
       else
         if curIsChosen then
           moveP -model.fail_steps curP
         else
           moveP -model.fail_steps_all curP

moveP :  Int -> Participant -> Participant
moveP amount p =
    { p | xpos = max 0 (p.xpos + amount) }

randomFloat : Model -> (Float, Random.Seed)
randomFloat model =
  Random.generate (Random.float 0 1) model.nextSeed

randInt : Model -> (Int, Random.Seed)
randInt model =
  Random.generate (Random.int 0 (Array.length model.participants - 1)) model.nextSeed
