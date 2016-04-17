module Actions (Action(..)) where

import Time exposing (Time)

type Action
    = StartSim Time
    | PauseSim
    | ResetSim
    | ResumeSim
    | Tick Time
    -- I could probably not have 4 different actions here by doing some JSON
    -- funny business, but this is fine for now.
    | UpdateSProb String
    | UpdateSSteps String
    | UpdateFSteps String
    | UpdateFASteps String
    | NoOp
