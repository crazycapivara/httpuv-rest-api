library(httpuv)

json_response <- function(req){
  data <- list(
    api_version = "0.0.1",
    values = 1:10,
    message = "hi folks"
  )
  jsonlite::toJSON(data, auto_unbox = TRUE)
}

app <- list(
  call = function(req){
    list(
      status = 200L,
      headers = list('Content-Type' = 'application/json'),
      body = json_response(req)
    )
  }
)

server <- runServer("127.0.0.1", 7700, app = app)