module Config exposing (apiEndpoint)
baseUrl : String
baseUrl = "https://fox-pics.vulpes.workers.dev"

apiEndpoint : String -> String
apiEndpoint path =
  baseUrl ++ "/"  ++ path
