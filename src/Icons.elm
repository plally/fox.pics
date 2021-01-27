module Icons exposing (..)

import Svg.Attributes exposing (..)
import Svg exposing (..)

newFox =
  svg [ width "24", height "24", viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round", class "feather feather-rotate-cw" ] [ polyline [ points "23 4 23 10 17 10" ] [], Svg.path [ d "M20.49 15a9 9 0 1 1-2.12-9.36L23 10" ] [] ]

copyToClipboard =
  svg [ width "24", height "24", viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round", class "feather feather-clipboard" ] [ Svg.path [ d "M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" ] [], rect [ x "8", y "2", width "8", height "4", rx "1", ry "1" ] [] ]

