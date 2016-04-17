module Actions (Action(..)) where

import Time exposing (Time)

type Action
    = StartSim Time
    | PauseSim
    | ResetSim
    | Tick Time
    | NoOp
