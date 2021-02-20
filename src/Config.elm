module Config exposing (apiEndpoint)
baseUrl = "https://store.fox.pics"

apiEndpoint : String -> String
apiEndpoint path =
  baseUrl ++ "/"  ++ path
