port module Main exposing (main)

import Icons

import Browser
import Html exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading, requestNewFox )

type Msg
  = GotFox (Result Http.Error String)
  | CopyToClipboard
  | GetFox


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CopyToClipboard ->
      case model of
        Success url -> (model, writeClipboard url)
        _ -> (model, Cmd.none)

    GetFox ->
      (Loading, requestNewFox)

    GotFox result ->
      case result of
        Ok foxId ->
          ( Success ("https://fox.foxorsomething.net/" ++ foxId ++ ".png")
          , Cmd.none
          )

        Err _ ->
          (Failure, Cmd.none)

-- HELPER FUNCTIONS
requestNewFox =
  Http.get
    { url = "https://fox.foxorsomething.net/random.json"
    , expect = Http.expectJson GotFox foxDecoder
    }

foxDecoder : Decoder  String
foxDecoder =
  field "id" string

writeModelToClipboard model =
  case model of
    Success url -> (model, writeClipboard url)
    _ -> (model, Cmd.none)

-- PORTS
port writeClipboard : String -> Cmd msg

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW
view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "Could not load the fox"

    Loading ->
      text "Loading..."

    Success foxUrl ->
      div [class "rootcontainer"] [
        div [class "navbar"]
        [
          div [class "nav-button", onClick CopyToClipboard] [Icons.copyToClipboard],
          div [class "nav-button", onClick GetFox] [Icons.newFox]
        ]
        ,div [class "fox-container"]
        [
          img [class "fox-img", src foxUrl] []
        ]
      ]
