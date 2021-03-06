% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/srSim.R
\name{srSim}
\alias{srSim}
\title{Dynamic plots to explore typical fisheries stock-recruitment models.}
\usage{
srSim(S = NULL, R = NULL, data = NULL, type = c("BevertonHolt",
  "Ricker"), param = 1, max.S = 500, max.R = 1000)
}
\arguments{
\item{S}{Either a vector of observed stock levels or a formula of the form \code{R~S}.}

\item{R}{A vector of observed recruitment levels.}

\item{data}{A data frame from which the vectors of observed stock and recruitment levels can be found.  Used only if a formula is used in \code{s}.}

\item{type}{A string that indicates the type of the stock-recruitment model.  Must be one of \code{"BevertonHolt"}, \code{"Ricker"}, \code{"Shepherd"}, or \code{"SailaLorda"}.}

\item{param}{A numeric that indicates the parameterization of the stock-recruitment model type.  This is ignored if \code{type="Shepherd"} or \code{type="SailaLorda"}}

\item{max.S}{A single numeric that indicates the maximum spawning stock to use for scaling the x-axis.  Ignored if \code{S} is not NULL.}

\item{max.R}{A single numeric that indicates the maximum recruitment to use for scaling the y-axis.  Ignored if \code{S} is not NULL.}
}
\value{
None.  However a dynamic graphic connected to slider bar controls of the \bold{\sQuote{a}}, \bold{\sQuote{b}}, or \bold{\sQuote{Rp}} parameters specific to the chosen stock-recruit model.
}
\description{
Plots modeled number of recruits versus stock size for common parameterizations of the Beverton-Holt, Ricker, Shepherd, and Saila-Lorda stock-recruit models.  Slider bars are used to dynamically alter the parameters of each model.
}
\details{
This function can be used to explore the dynamics of stock-recruitment models for various parameter choices.  In these instances of model exploration the \code{S=} and \code{R=} arguments should be (left) set at \code{NULL}.

This function can  also be used to visually \dQuote{fit} a stock-recruit model to a set of observed stock and recruitment data to determine reasonable starting values for non-linear model fitting.  In this use, observed data are plotted by including the vectors of observed stock sizes and recruits in a formula of the form \code{S~R}, in conjunction with the \code{data=} argument.

The \code{type=} argument is used to choose either the \code{"BevertonHolt"}, \code{"Ricker"}, \code{"Shepherd"}, or \code{"SailaLorda"} stock-recruitment models.  Common parameterizations of the \code{"BevertonHolt"} and \code{"Ricker"} models can be chosen with \code{param=}.  Four paramaterizations of the Beverton-Holt model and three parameterizations of the Ricker model are allowed.  Type \code{srModels()} to see equations for each model.
}
\examples{
## ONLY RUN IN INTERACTIVE MODE
if (interactive()) {
# Defaults - Beverton-Holt, first parameterization
srSim()

# Beverton-Holt, second parameterization
srSim(param=2)

# Ricker model first parameterization
srSim(type="Ricker")

# Ricker model second parameterization
srSim(type="Ricker", param=2)

# Ricker model first parameterization with Norwegian Cod data from the FSA package
data(CodNorwegian)
srSim(recruits~stock,data=CodNorwegian,type="Ricker",param=1)

}  ## END IF INTERACTIVE MODE
}
\author{
Derek H. Ogle, \email{dogle@northland.edu}
}
\seealso{
\code{\link{srModels}}
}
\keyword{iplot}

