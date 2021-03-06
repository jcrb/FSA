#' @title Confidence interval for Poisson rate parameter.
#'
#' @description Computes a confidence interval for the Poisson mean rate parameter.
#'
#' @details Computes a CI for the Poisson mean using the method described in Ulm (1990), though this method was earlier described by Liddell (1984) and possibly Garwood (1936) as noted in van der Gulden and Verbeck (1992).  Thank you to Jerry Lewis for clarifications to the historical citations of this method.
#'
#' @param x A number representing the number of observed successes.
#' @param conf.level A number that indicates the level of confidence to use for constructing confidence intervals (default is \code{0.95}).
#'
#' @return A 1x2 matrix that contains the lower and upper confidence interval bounds.
#'
#' @author Derek H. Ogle, \email{dogle@@northland.edu}
#'
#' @seealso See \code{pois.exact} in \pkg{epitools} for similar functionality.
#'
#' @references Garwood, F.  1936.  Fiducial limits for the Poisson distribution.  Biometrika.  28(3/4):437-442.
#'
#' Liddell, F.D.  1984.  Simple exact analysis of the standardised mortality ratio.  Journal of Epidemiology and Community Health. 38(1):85-88.
#'
#' Ulm, K.  1990.  A simple method to calculate the confidence interval of a standardized mortality ratio.  American Journal of Epidemiology 131(2):373-375.
#'
#' vand der Gulden, J.W.J. and A.L.M. Verbeck.  1992.  Re: \dQuote{A simple method to calculate the confidence interval of a standardized mortality ratio (SMR)}.  American Journal of Epidemiology 136(9):1170-1171.
#'
#' @keywords htest
#'
#' @examples
#' poiCI(12)
#'
#' @export
poiCI <- function(x,conf.level=0.95) {
  LCI <- qchisq((1-conf.level)/2,2*x)/2
  UCI <- qchisq(1-(1-conf.level)/2,2*(x+1))/2
  res <- cbind(LCI,UCI)
  colnames(res) <- iCILabel(conf.level)
  res
}
