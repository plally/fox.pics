module Config exposing (apiEndpoint)
baseUrl = "https://api.fox.pics"

apiEndpoint : String -> String
apiEndpoint path =
  baseUrl ++ "/"  ++ path
