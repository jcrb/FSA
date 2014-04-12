#'Opens web pages associated with the fishR site.
#'
#'Opens web pages associated with the fishR site.
#'
#'@param where A string indicating a particular page on the fishR site to open.
#'@return None, but a webpage will be opened in the default browswer.
#'@export
#'@keywords misc
#'@examples
#'\dontrun{
#'fishR()            # home page
#'fishR("general")   # general examples page
#'fishR("books")     # books examples page
#'fishR("AIFFD")     # Analysis & Interpretation of Freshwater Fisheries Data page
#'fishR("news")      # News page
#'}
#'
fishR <- function(where=c("home","general","books","AIFFD","news")) {
  where <- match.arg(where)
  switch(where,
    home={browseURL("http://fishr.wordpress.com")},
    general={browseURL("http://fishr.wordpress.com/vignettes/")},
    books={browseURL("http://fishr.wordpress.com/books/")},
    AIFFD={browseURL("http://fishr.wordpress.com/books/aiffd/")},
    news={browseURL("https://github.com/droglenc/FSA/blob/master/NEWS.md")}
  ) 
}