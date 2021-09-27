port module Main exposing (main)

import Icons
import Config exposing (apiEndpoint)

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



--  MODEL
type Model
  = Failure
  | Loading
  | Success (List String)


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading, requestNewFox )

type Msg
  = GotFox (Result Http.Error (List String))
  | CopyToClipboard
  | GetFox
  | ImgPreloaded String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CopyToClipboard ->
      case model of
        Success foxes -> (model, writeClipboard <| getCurrentFox foxes)
        _ -> (model, Cmd.none)

    GetFox ->
      case model of
        Success foxes ->
          let
              newFoxes = unwrap [] <| List.tail foxes
          in
            if List.isEmpty newFoxes then
              (Loading, requestNewFox)
            else
              (Success newFoxes, Cmd.none)
        Loading -> (model, Cmd.none)
        _ -> (Loading, requestNewFox)

    GotFox result ->
      case result of
        Ok foxes ->
          ( Success [], preloadImages foxes )

        Err _ ->
          (Failure, Cmd.none)
    
    ImgPreloaded url ->
      case model of
        Success foxes -> ( Success <| foxes ++ [url], Cmd.none )
        _ -> (model, Cmd.none)

-- HELPER FUNCTIONS
requestNewFox =
  Http.get
    { url = Config.apiEndpoint "get-random-foxes"
    , expect = Http.expectJson GotFox foxDecoder
    }

foxDecoder : Decoder (List String)
foxDecoder =
  Json.Decode.list string

unwrap : a -> Maybe a -> a
unwrap default maybev =
  case maybev of
    Just v ->
      v
    Nothing ->
      default

getCurrentFox foxes =
  unwrap "" <| List.head <|foxes

-- PORTS
port preloadImages : List String -> Cmd msg
port writeClipboard : String -> Cmd msg
port preloadImageReceiver : (String -> msg) -> Sub msg

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  preloadImageReceiver ImgPreloaded


-- VIEW
view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "Could not load the fox"

    Loading ->
      container [
        navbar,
        h1 [align "center"] [ text "Loading your foxes!" ]
      ]

    Success foxes ->
      container [
        navbar
        ,main_ [class "fox-container"]
        [
          img [class "fox-img", alt "fox",  src <| getCurrentFox foxes] []
        ]
      ]

container elements =
  div [class "rootcontainer"] elements

navbar =
  nav [class "navbar"]
  [
    div [class "nav-button", onClick CopyToClipboard] [Icons.copyToClipboard],
    div [class "nav-button", onClick GetFox] [Icons.newFox],
    a [ href "https://github.com/plally/fox_pics_frontend", attribute "aria-label" "source ecode"] [ div [class "nav-button", id "github"] [Icons.github] ]
  ]
