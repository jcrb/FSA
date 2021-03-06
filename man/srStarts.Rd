% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/srStarts.R
\name{srStarts}
\alias{srStarts}
\title{Finds reasonable starting values for parameters in specific paramaterizations of common stock-recruitment models.}
\usage{
srStarts(formula, data = NULL, type = c("BevertonHolt", "Ricker",
  "Shepherd", "SailaLorda"), param = 1, plot = FALSE, col.mdl = "gray70",
  lwd.mdl = 3, lty.mdl = 1, ...)
}
\arguments{
\item{formula}{A formula of the form \code{Recruits~Stock}.}

\item{data}{A data frame in which \code{Recruits} and \code{Stock} are found.}

\item{type}{A string that indicates the type of the stock-recruitment model.  Must be one of \code{"BevertonHolt"}, \code{"Ricker"}, \code{"Shepherd"}, or \code{"SailaLorda"}.}

\item{param}{A numeric that indicates the parameterization of the stock-recruitment model type.  This is ignored if \code{type="Shepherd"} or \code{type="SailaLorda"}}

\item{plot}{A logical that indicates whether or not a plot of the data with the model fit at the starting values superimposed is created.}

\item{col.mdl}{A color for the model when \code{plot=TRUE}.}

\item{lwd.mdl}{A line width for the model when \code{plot=TRUE}.}

\item{lty.mdl}{A line type for the model when \code{plot=TRUE}.}

\item{\dots}{Further arguments passed to the methods.}
}
\value{
A list that contains reasonable starting values.  Note that the parameters will be listed in the same order and with the same names as listed in \code{\link{srFuns}}.
}
\description{
Finds reasonable starting values for parameters in specific parameterizations of the \dQuote{Beverton-Holt}, \dQuote{Ricker},  \dQuote{Shepherd}, or \dQuote{Saila-Lorda} stock-recruitment models.  Type \code{srModels()} for the equations of each model.
}
\details{
This function attempts to find reasonable starting values for a variety of parameterizations of the \dQuote{Beverton-Holt}, \dQuote{Ricker},  \dQuote{Shepherd}, or \dQuote{Saila-Lorda} stock-recruitment models.  There is no guarantee that these starting values are the \sQuote{best} starting values.  One should use them with caution and should perform sensitivity analyses to determine the impact of different starting values on the final model results.

Starting values for the first parameterization of the Beverton-Holt model were derived by linearizing the function (inverting both sides and simplifying), fitting a linear model to the observed data, and extracting parameter values from the corresponding linear model parameters.  Starting values for the other parameterizations of the Beverton-Holt model were derived from known relationships between the parameters of each parameterization and the first parameterization.  If the computed starting value for the \code{Rp} parameter was larger than the largest observed recruitment value, then the starting value for \code{Rp} was set to the largest observed recruitment value.

Starting values for the Shepherd function were the same as those for the first parameterization of the Beverton-Holt function with the addition that \code{c=1}.

Starting values for the Ricker parameterizations followed the same general procedure as described for the Beverton-Holt parameterizations.  If the computed starting value for \code{atilde} was less than zero then the starting value was set to 0.00001.

Starting values for the Saila-Lorda function were the same as those for the first parameterization of the Ricker function with the addition that \code{c=1}.
}
\section{fishR vignette}{
 \url{https://sites.google.com/site/fishrfiles/gnrl/StockRecruit.pdf}
}
\examples{
## Simple Examples
data(CodNorwegian)
srStarts(recruits~stock,data=CodNorwegian)
srStarts(recruits~stock,data=CodNorwegian,param=2)
srStarts(recruits~stock,data=CodNorwegian,param=3)
srStarts(recruits~stock,data=CodNorwegian,param=4)
srStarts(recruits~stock,data=CodNorwegian,type="Ricker")
srStarts(recruits~stock,data=CodNorwegian,type="Ricker",param=2)
srStarts(recruits~stock,data=CodNorwegian,type="Ricker",param=3)
srStarts(recruits~stock,data=CodNorwegian,type="Shepherd")
srStarts(recruits~stock,data=CodNorwegian,type="SailaLorda")

## Simple Examples with a Plot
srStarts(recruits~stock,data=CodNorwegian,type="Ricker",plot=TRUE)
srStarts(recruits~stock,data=CodNorwegian,type="BevertonHolt",plot=TRUE)
srStarts(recruits~stock,data=CodNorwegian,type="Shepherd",plot=TRUE)
srStarts(recruits~stock,data=CodNorwegian,type="SailaLorda",plot=TRUE)

## See examples in srFuns() for use of srStarts() when fitting stock-recruit models
}
\author{
Derek H. Ogle, \email{dogle@northland.edu}
}
\references{
Beverton, R.J.H. and S.J. Holt.  1957.  On the dynamics of exploited fish populations, Fisheries Investigations (Series 2), volume 19.  United Kingdom Ministry of Agriculture and Fisheries, 533 pp.

Iles, T.C.  1994.  A review of stock-recruitment relationships with reference to flatfish populations.  Netherlands Journal of Sea Research 32:399-420.

Quinn II, T.J. and R.B. Deriso. 1999. Quantitative Fish Dynamics. Oxford University Press.

Ricker, W.E. 1954. Stock and recruitment. Journal of the Fisheries Research Board of Canada 11:559-623.

Ricker, W.E. 1975. \href{http://www.dfo-mpo.gc.ca/Library/1485.pdf}{Computation and interpretation of biological statistics of fish populations}. Technical Report Bulletin 191, Bulletin of the Fisheries Research Board of Canada.

Shepherd, J. 1982. A versatile new stock-recruitment relationship for fisheries and construction of sustainable yield curves. Journal du Conseil International pour l'Exploration de la Mar 40:67-75.
}
\seealso{
\code{\link{srModels}}, \code{\link{srFuns}}, and \code{\link{srSim}}.
}
\keyword{manip}

