% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/rcumsum.R
\name{rcumsum}
\alias{pcumsum}
\alias{rcumsum}
\title{Computes the prior to or reverse cumulative sum of a vector.}
\usage{
rcumsum(x)

pcumsum(x)
}
\arguments{
\item{x}{a numeric object.}
}
\value{
A numeric vector that contains the prior-to or reverse cumulative sums.
}
\description{
Computes the prior-to (i.e., the cumulative sum priot to but not including the current value) or the reverse cumulative sum (i.e., the number that large or larger) of a vector.
}
\details{
An \code{NA} in the vector causes all returned values to be \code{NA}.
}
\examples{
cbind(vals=1:10,
      cum=cumsum(1:10),
      pcum=pcumsum(1:10),
      rcum=rcumsum(1:10))
}
\author{
Derek H. Ogle, \email{dogle@northland.edu}
}
\seealso{
\code{cumsum}.
}
\keyword{misc}

