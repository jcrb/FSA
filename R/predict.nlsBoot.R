#' @title Constructs a prediction and confidence interval from nlsBoot results.
#'
#' @description Constructs a non-parametric bootstrap prediction with confidence interval from \code{nlsBoot()} (in the \pkg{nlstools} package) like results.
#'
#' @details This function applies a user-supplied function to each row of the \code{coefBoot} object in a \code{nlsBoot} object and then finds the median and the two quantiles that have the proportion (1-\code{conf.level})/2 of the bootstrapped predictions below and above.  The median is returned as the predicted value and the quantiles are returned as an approximate 100\code{conf.level}\% confidence interval for that prediction.
#'
#' @aliases predict.nlsboot
#'
#' @param object An nlsBoot object saved from \code{nlsBoot()}.
#' @param FUN The function to be applied.
#' @param MARGIN A single numeric that indicates the margin over which to apply the function. \code{MARGIN=1} will apply to each row and is the default.
#' @param conf.level A level of confidence as a proportion.
#' @param digits A single numeric that indicates the number of digits for the result.
#' @param \dots Additional arguments for \code{apply()}.
#'
#' @return A matrix with one row and three columns with the first column holding the predicted value (i.e., the median prediction) and the last two columns holding the approximate confidence interval.
#'
#' @author Derek H. Ogle, \email{dogle@@northland.edu}
#'
#' @seealso \code{\link{confint.nlsBoot}}, \code{summary.nlsBoot} in \pkg{nlstools}
#'
#' @keywords htest
#'
#' @examples
#' data(Ecoli)
#' fnx <- function(days,B1,B2,B3) {
#'   if (length(B1) > 1) {
#'     B2 <- B1[2]
#'     B3 <- B1[3]
#'     B1 <- B1[1]
#'   }
#'   B1/(1+exp(B2+B3*days))
#' }
#' nl1 <- nls(cells~fnx(days,B1,B2,B3),data=Ecoli,start=list(B1=6,B2=7.2,B3=-1.45))
#'
#' ## ONLY RUN IN INTERACTIVE MODE
#' if (interactive()) {
#' 
#' require(nlstools)    # for nlsBoot()
#' nl1.boot <- nlsBoot(nl1,niter=99)  # way too few
#' predict(nl1.boot,fnx,days=3)
#' 
#' }
#'
#' @rdname predict.nlsBoot
#' @export
predict.nlsBoot <- function(object,FUN,MARGIN=1,conf.level=0.95,digits=NULL,...) {
  res <- quantile(apply(object$coefboot,MARGIN=MARGIN,FUN=FUN,...),c(0.5,(1-conf.level)/2,1-(1-conf.level)/2))
  if (!is.null(digits)) res <- round(res,digits)
  names(res) <- c("prediction",iCILabel(conf.level))
  res
}
