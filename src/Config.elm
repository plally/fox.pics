module Config exposing (apiEndpoint)
baseUrl = "https://vtt20ior3c.execute-api.us-east-2.amazonaws.com"

apiEndpoint : String -> String
apiEndpoint path =
  baseUrl ++ "/"  ++ path
