#' @title Constructs a p-value for a bootstrapped hypothesis test using nlsBoot.
#'
#' @description Constructs a non-parametric bootstrap p-value from \code{nlsBoot()} (in the \pkg{nlstools} package) like results.
#'
#' @details The \dQuote{direction} of the alternative hypothesis is identified by a string in the \code{alt=} argument.  The strings may be \code{"less"} for a \dQuote{less than} alternative, \code{"greater"} for a \dQuote{greater than}
#'alternative, or \code{"two.sided"} for a \dQuote{not equals} alternative (the DEFAULT).
#'
#' In the one-tailed alternatives the p-value is the proportion of bootstrapped parameter estimates in \code{object$coefboot} that are extreme of the null hypothesized parameter value in \code{bo}.  In the two-tailed alternative the p-value is twice the smallest of the proportion of bootstrapped parameter estimates above or below the null hypothesized parameter value in \code{bo}.
#'
#' @param object An nlsBoot object saved from \code{nlsBoot()}.
#' @param parm An integer that indicates which parameter to compute the confidence interval for.  Will compute for all parameters if left \code{NULL}.
#' @param bo The null hypothesized parameter value.
#' @param alt A string that identifies the \dQuote{direction} of the alternative hypothesis.  See details.
#' @param plot A logical that indicates whether a histogram of the \code{parm} parameters with a vertical lines illustrating the \code{bo}value should be constructed.
#' @param \dots Additional arguments for methods. 
#'
#' @return Returns a matrix with two columns.  The first column contains the hypothesized value sent to this function and the second column is the corresponding p-value.
#'
#' @author Derek H. Ogle, \email{dogle@@northland.edu}
#'
#' @seealso \code{summary.nlsBoot} in \pkg{nlstools} and \code{\link{confint.nlsBoot}}.
#'
#' @aliases htest htest.nlsBoot
#'
#' @keywords htest
#'
#' @examples
#' ## ONLY RUN IN INTERACTIVE MODE
#' if (interactive()) {
#'
#' require(nlstools)
#' example(nlsBoot)
#' htest(boo,"lag",50)
#' htest(boo,"lag",50,alt="less")
#' 
#' } ## END IF INTERACTIVE MODE
#'
#' @rdname htest
#' @export
htest <- function(object, ...) {
  UseMethod("htest") 
}

#' @rdname htest
#' @export
htest.nlsBoot <- function(object,parm=NULL,bo=0,alt=c("two.sided","less","greater"),plot=FALSE,...) {
  alt <- match.arg(alt)
  # check if result is a vector -- i.e., only one parameter
  if (class(object$coefboot) != "matrix") {
    if (!is.null(parm)) warning("Results have only one dimension, value in 'parm' will be ignored.",call.=FALSE)
    # set dat equal to that vector
    dat <- object$coefboot
  } else {
    # check if more than one parm was sent
    if (length(parm)>1) {
      # only use first
      parm <- parm[1]
      warning("You can only test one paramater at a time.  Only the first will be used.",call.=FALSE)
    }
    # was a numeric column name given
    if (is.numeric(parm)) {
      # the column number was too big
      if (parm>ncol(object$coefboot)) stop("'parm' number greater than number of parameters.",call.=FALSE)
    } else { # a named variable was given
      # column name does not exist in the matrix
      if (!(parm %in% colnames(object$coefboot))) stop("'parm' name does not exist in nlsBoot results.",call.=FALSE)
    }
    # set dat equal to one column of matrix of results
    dat <- object$coefboot[,parm]
  }
  p.lt <- length(dat[dat>bo])/length(dat)
  p.gt <- length(dat[dat<bo])/length(dat)
  switch(alt,
    less=p.value <- p.lt,
    greater=p.value <- p.gt,
    two.sided=p.value <- 2*min(p.lt,p.gt)
  )
  res <- cbind(bo,p.value)
  colnames(res) <- c("Ho Value","p value")
  rownames(res) <- ""
  
  if (plot) {
    op <- par(mar=c(3.5,3.5,1,1),mgp=c(2,0.75,0))
    hist(object$coefboot[,parm],xlab=colnames(object$coefboot)[parm],main="")
    abline(v=bo,col="red",lwd=2,lty=2)
  }
  res
}  
