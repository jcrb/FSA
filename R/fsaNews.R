#'Read news and changes in the 'FSA' package.
#'
#'Read news and changes in the \sQuote{FSA} package.
#'
#'@aliases fsaNews FSANews
#'@return None.
#'@keywords manip
#'@export fsaNews FSANews
#'@examples
#'fsaNews()
#'FSANews()
#'
fsaNews <- FSANews <- function () {
  browseURL("https://github.com/droglenc/FSA/blob/master/NEWS.md")
}