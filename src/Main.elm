import Html exposing (Html)
import StartApp
import View
import Task
import Keyboard
import Effects exposing (Never)

import Model exposing (Model)
import Update
import Actions

app =
  StartApp.start
    { init = (Model.initial, Effects.tick Actions.StartSim)
    , update = Update.update
    , view = View.view
    , inputs = []
    }


main : Signal Html
main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
