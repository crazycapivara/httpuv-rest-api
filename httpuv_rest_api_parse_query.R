library(httpuv)

get_default_data <- function(){
  list(
    api_version = "0.0.1",
    values = 1:10,
    message = "hi folks"
  )
}

parse_query <- function(query){
  data <- get(query$data)
  if(!is.null(query$limit)){
    data <- head(data, as.numeric(query$limit))
  }
  data
}

json_response <- function(req){
  query <- shiny::parseQueryString(req$QUERY_STRING)
  data <- tryCatch({
    parse_query(query)
  }, error = function(e){
    get_default_data()  
  })
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

# library(httr)
# GET("localhost:7700?data=quakes&limit=6") %>%
#   content(as = "text") %>%
#   jsonlite::fromJSON(flatten = TRUE)