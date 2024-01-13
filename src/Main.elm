port module Main exposing (main)

import Icons
import Config

import Browser
import Html exposing (..)
import Http
import Json.Decode exposing (Decoder, string)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, custom)


-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



--  MODEL
type ModelState
  = Failure
  | Loading
  | Success (List String)

type alias Model =
    { state: ModelState,
      modalOpen: Bool
    }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Loading False, requestNewFox )

type Msg
  = GotFox (Result Http.Error (List String))
  | CopyToClipboard
  | GetFox
  | ImgPreloaded String
  | OpenInfoModel
  | HideInfoModel
  | Noop


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CopyToClipboard ->
      case model.state of
        Success foxes -> (model, writeClipboard <| getCurrentFox foxes)
        _ -> (model, Cmd.none)

    GetFox ->
      case model.state of
        Success foxes ->
          let
              newFoxes = unwrap [] <| List.tail foxes
          in
            if List.isEmpty newFoxes then
              (Model Loading False, requestNewFox)
            else
              (Model (Success newFoxes) False, Cmd.none)
        Loading -> (model, Cmd.none)
        _ -> (Model Loading False, requestNewFox)

    GotFox result ->
      case result of
        Ok foxes ->
          ( Model (Success []) False, preloadImages foxes )

        Err _ ->
          (Model Failure False, Cmd.none)
    
    ImgPreloaded url ->
      case model.state of
        Success foxes -> ( Model (Success <| foxes ++ [url]) False, Cmd.none )
        _ -> (model, Cmd.none)

    OpenInfoModel ->
      ({ model | modalOpen = True}, Cmd.none)
    HideInfoModel ->
      ( {model | modalOpen = False}, Cmd.none)
    Noop ->
      ( model, Cmd.none )
      
-- HELPER FUNCTIONS
requestNewFox : Cmd Msg
requestNewFox =
  Http.get
    { url = Config.apiEndpoint "v1/get-random-foxes"
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

getCurrentFox : List String -> String
getCurrentFox foxes =
  unwrap "" <| List.head <|foxes

-- PORTS
port preloadImages : List String -> Cmd msg
port writeClipboard : String -> Cmd msg
port preloadImageReceiver : (String -> msg) -> Sub msg

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
  preloadImageReceiver ImgPreloaded


-- VIEW
view : Model -> Html Msg
view model =
  case model.state of
    Failure ->
      text "Could not load the fox"

    Loading ->
      container [
        navbar model,
        h1 [align "center"] [ text "Loading the foxes!" ]
      ]

    Success foxes ->
      container [
        navbar model
        ,main_ [class "fox-container"]
        [
          img [class "fox-img", alt "fox",  src <| getCurrentFox foxes] []
        ]
      ]

container : List (Html msg) -> Html msg
container elements =
  div [class "rootcontainer"] elements

navbar : Model -> Html Msg
navbar model =
  nav [class "navbar"]
  [
    button [class "nav-button", onClick CopyToClipboard] [Icons.copyToClipboard],
    button [class "nav-button", onClick GetFox] [Icons.newFox],
    a [ onClick OpenInfoModel, attribute "aria-label" "information"] [ button [class "nav-button", id "github"] [Icons.info] ],
    modal model.modalOpen
  ]

onClickNoBubble : msg -> Html.Attribute msg
onClickNoBubble message =
    Html.Events.custom "click" (Json.Decode.succeed { message = message, stopPropagation = True, preventDefault = False })

modal : Bool -> Html Msg
modal hide = 
 if hide then
  let 
    iconStyle = [
        style "display" "inline-block"
      , style "verticle-align" "middle" ]
    textStyle  = [
        style "display" "inline-block"
      , style "position" "relative"
     
      , style "verticle-align" "middle"
      , style "top" "-7px"
      , style "left" "10px"
      , style  "font-size" "20px"]
  in
    div [class "modalBackground", onClick HideInfoModel] [
      div [class "modal", onClickNoBubble Noop ] [
        a [href "https://github.com/plally/fox.pics"] [
          span [class "info-link" ] [
              span iconStyle [ Icons.github ],
              span textStyle [text "Repository"]
          ]
        ],
        br [] [],
        a [href "mailto:contact@fox.pics"] [
          span [class "info-link" ] [
            span iconStyle [ Icons.email ],
            span textStyle [text "contact@fox.pics"]
          ]
        ],
       br [] [],
        a [href "https://discord.gg/TuSf7jNX87"] [
          span [class "info-link" ] [
            span iconStyle [ Icons.chat ],
            span textStyle [text "Discord"]
          ]
        ],
       br [] [],
        a [href "https://bsky.app/profile/fox.pics"] [
          span [class "info-link" ] [
            span iconStyle [ Icons.atSign ],
            span textStyle [text "BlueSky"]
          ]
        ]
      ]
    ]
  else
      div [] []
  
