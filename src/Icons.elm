module Icons exposing (..)

import Svg.Attributes exposing (..)
import Svg exposing (..)

newFox =
  svg [ width "24", height "24", viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round", class "feather feather-rotate-cw" ] [ polyline [ points "23 4 23 10 17 10" ] [], Svg.path [ d "M20.49 15a9 9 0 1 1-2.12-9.36L23 10" ] [] ]

copyToClipboard =
  svg [ width "24", height "24", viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round", class "feather feather-clipboard" ] [ Svg.path [ d "M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" ] [], rect [ x "8", y "2", width "8", height "4", rx "1", ry "1" ] [] ]

github =
  svg [ width "24", height "24", viewBox "0 0 24 24", fill "none", stroke "currentColor", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round", class "feather feather-github" ] [ Svg.path [ d "M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" ] [] ]
