#' @title Creates a function for a specific parameterization of a common stock-recruitment model .
#'
#' @description Creates a function for a specific parameterization of a \dQuote{Beverton-Holt}, \dQuote{Ricker},  \dQuote{Shepherd}, or \dQuote{Saila-Lorda} stock-recruitment model.  Type \code{srModels()} for the equations of each model.
#'
#' @param type A string that indicates the type of stock-recruitment model.
#' @param param A single numeric that indicates the parameterization of the stock-recruitment model type.
#' @param simple A logical that indicates whether the user should be allowed to send all parameter values in the first parameter argument (\code{=FALSE}; default) or whether all individual parameters must be specified (\code{=TRUE}).
#' @param msg A logical that indicates whether a message about the model and parameter definitions should be output (\code{=TRUE}) or not (\code{=FALSE}; default).
#'
#' @return A function that can be used to predict recruitment given a vector of stock sizes and values for the model parameters.  The result should be saved to an object that can then be used as a function name.  When the resulting function is used, the parameters are ordered as shown when the definitions of the parameters are printed after the function is called (assuming that \code{msg=TRUE}).  The values for both/all parameters can be included as a vector of length two/three in the first parameter argument.
#'
#'If \code{simple=FALSE} then the values for all parameters can be included as a vector in the first parameter argument.  If \code{simple=TRUE} then all parameters must be declared individually in each function.  The resulting function is somewhat easier to read when \code{simple=TRUE}.
#'
#' @author Derek H. Ogle, \email{dogle@@northland.edu}, thanks to Gabor Grothendieck for a hint about using \code{get()}.
#'
#' @seealso \code{\link{srStarts}}, \code{\link{srModels}}, and \code{\link{srSim}}
#'
#' @section fishR vignette: \url{https://sites.google.com/site/fishrfiles/gnrl/StockRecruit.pdf}
#'
#' @references 
#' Beverton, R.J.H. and S.J. Holt.  1957.  On the dynamics of exploited fish populations, Fisheries Investigations (Series 2), volume 19. United Kingdom Ministry of Agriculture and Fisheries, 533 pp.
#' 
#' Iles, T.C.  1994.  A review of stock-recruitment relationships with reference to flatfish populations.  Netherlands Journal of Sea Research 32:399-420.
#'
#' Quinn II, T.J. and R.B. Deriso. 1999. Quantitative Fish Dynamics. Oxford University Press.
#'
#' Ricker, W.E. 1954. Stock and recruitment. Journal of the Fisheries Research Board of Canada 11:559-623.
#'
#' Ricker, W.E. 1975. \href{http://www.dfo-mpo.gc.ca/Library/1485.pdf}{Computation and interpretation of biological statistics of fish populations}. Technical Report Bulletin 191, Bulletin of the Fisheries Research Board of Canada.
#' 
#' Shepherd, J. 1982. A versatile new stock-recruitment relationship for fisheries and construction of sustainable yield curves. Journal du Conseil International pour l'Exploration de la Mar 40:67-75. 
#' 
#' @keywords manip
#' 
#' @examples
#' ## Simple Examples
#' # create some dummy stock data
#' stock <- seq(0.01,1000,length.out=199)
#' 
#' # Beverton-Holt #1 parameterization
#' ( bh1 <- srFuns() )
#' plot(bh1(stock,a=0.5,b=0.01)~stock,type="l",lwd=2,ylab="Recruits",xlab="Spawners",ylim=c(0,50))
#'
#' # Ricker #1 parameterization
#' ( r1 <- srFuns("Ricker") )
#' lines(r1(stock,a=0.5,b=0.005)~stock,lwd=2,col="red")
#'
#' # Shephered parameterization
#' ( s1 <- srFuns("Shepherd") )
#' lines(s1(stock,a=0.5,b=0.005,c=2.5)~stock,lwd=2,col="blue")
#' 
#' # Saila-Lorda parameterization
#' ( sl1 <- srFuns("SailaLorda") )
#' lines(sl1(stock,a=0.5,b=0.005,c=1.05)~stock,lwd=2,col="salmon")
#' 
#' ## Examples of fitting stock-recruitment models
#' data(CodNorwegian)
#'
#' # Fitting the Beverton-Holt #1 parameterization with multiplicative errors
#' bh1s <- srStarts(recruits~stock,data=CodNorwegian)
#' fit1 <- nls(log(recruits)~log(bh1(stock,a,b)),data=CodNorwegian,start=bh1s)
#' summary(fit1,correlation=TRUE)
#' plot(recruits~stock,data=CodNorwegian,pch=19,xlim=c(0,200))
#' curve(bh1(x,a=coef(fit1)[1],b=coef(fit1)[2]),from=0,to=200,col="red",lwd=3,add=TRUE)
#'
#' # Fitting the Ricker #3 parameterization with multiplicative errors
#' r3 <- srFuns("Ricker",param=3)
#' r3s <- srStarts(recruits~stock,data=CodNorwegian,type="Ricker",param=3)
#' fit2 <- nls(log(recruits)~log(r3(stock,a,Rp)),data=CodNorwegian,start=r3s)
#' summary(fit2,correlation=TRUE)
#' curve(r3(x,a=coef(fit2)[1],Rp=coef(fit2)[2]),from=0,to=200,col="blue",lwd=3,add=TRUE)
#'
#' @export
srFuns <- function(type=c("BevertonHolt","Ricker","Shepherd","SailaLorda"),param=1,simple=FALSE,msg=FALSE) {
  ## Define functions (internal)
  BevertonHolt1 <- function(S,a,b=NULL) {
    if (length(a)>1) { b <- a[2]; a <- a[1] }
    a*S/(1+b*S)
  }
  SBevertonHolt1 <- function(S,a,b) a*S/(1+b*S)
  BevertonHolt2 <- function(S,a,Rp=NULL) {
    if (length(a)>1) { Rp <- a[2]; a <- a[1] }
    a*S/(1+a*S/Rp)
  }
  SBevertonHolt2 <- function(S,a,Rp) a*S/(1+a*S/Rp)
  BevertonHolt3 <- function(S,a,b=NULL) {
    if (length(a)>1) { b <- a[2]; a <- a[1] }
    S/(a+b*S)
  }
  SBevertonHolt3 <- function(S,a,b) S/(a+b*S)
  BevertonHolt4 <- function(S,a,Rp=NULL) {
      if (length(a)>1) { Rp <- a[2]; a <- a[1] }
      S/(a+S/Rp)
    }
  SBevertonHolt4 <- function(S,a,Rp) S/(a+S/Rp)
  Ricker1 <- function(S,a,b=NULL) {
    if (length(a)>1) { b <- a[2]; a <- a[1] }
    a*S*exp(-b*S)
  }
  SRicker1 <- function(S,a,b) a*S*exp(-b*S)
  Ricker2 <- function(S,a,b=NULL) {
    if (length(a)>1) { b <- a[2]; a <- a[1] }
    S*exp(a-b*S)
  }
  SRicker2 <- function(S,a,b) S*exp(a-b*S)
  Ricker3 <- function(S,a,Rp=NULL) {
    if (length(a)>1) { Rp <- a[2]; a <- a[1] }
    a*S*exp(-a/exp(1)*S/Rp)
  }
  SRicker3 <- function(S,a,Rp) a*S*exp(-a/exp(1)*S/Rp)
  Shepherd <- function(S,a,b=NULL,c=NULL) {
    if (length(a)>1) { c <- a[3]; b <- a[2]; a <- a[1] }
    a*S/(1+(b*S)^c)
  }
  SShepherd <- function(S,a,b,c) a*S/(1+(b*S)^c)
  SailaLorda <- function(S,a,b=NULL,c=NULL) {
    if (length(a)>1) { c <- a[3]; b <- a[2]; a <- a[1] }
    a*(S^c)*exp(-b*S)
  }
  SSailaLorda <- function(S,a,b,c) a*(S^c)*exp(-b*S)
  ## END INTERNAL FUNCTIONS
  
  ## START MAIN FUNCTION  
  ## Some checks
  type <- match.arg(type)
  if (length(param)!=1) stop("Only one 'param' is allowed.",call.=FALSE)
  if (type=="BevertonHolt") {
    if (!param %in% 1:4) stop("'param' must be in 1:4 when type='BevertonHolt'.",call.=FALSE)
    type <- paste0(type,param)
  } else if (type=="Ricker") {
    if (!param %in% 1:3) stop("'param' must be in 1:3 when type='Ricker'.",call.=FALSE)
    type <- paste0(type,param)
  }
  
  ## Messages based on type
  if (msg) {
    switch(type,
      BevertonHolt1={
        cat("You have chosen the first parameterization of the 'Beverton-Holt' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*S/(1+b*S)\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      b = density-dependent parameter.\n\n")
      },
      BevertonHolt2={
        cat("You have chosen the second parameterization of the 'Beverton-Holt' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*S/(1+a*(S/Rp))\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      Rp = peak recruitment at the asymptote.\n\n")
      },
      BevertonHolt3={
        cat("You have chosen the third parameterization of the 'Beverton-Holt' stock-recruitment model.\n\n")
        cat("  E[R|S] = S/(a+b*S)\n\n")
      },
      BevertonHolt4={
        cat("You have chosen the fourth parameterization of the 'Beverton-Holt' stock-recruitment model.\n\n")
        cat("  E[R|S] = S/(a+S/Rp)\n\n")
        cat("where Rp = peak recruitment at the asymptote.\n\n")
      },
      Ricker1={
        cat("You have chosen the first parameterization of the 'Ricker' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*S*exp(-b*S)\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      b = density-dependent parameter.\n\n")
      },
      Ricker2={
        cat("You have chosen the second parameterization of the 'Ricker' stock-recruitment model.\n\n")
        cat("  E[R|S] = S*exp(a-b*S)\n\n")
        cat("where b = density-dependent parameter.\n\n")
      },
      Ricker3={
        cat("You have chosen the third parameterization of the 'Ricker' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*S*exp(-a*S/(e*Rp))\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      Rp = peak level of recruitment.\n\n")
      },
      Shepherd={
        cat("You have chosen the 'Shepherd' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*S/(1+(b*S)^c)\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      b = density-dependent parameter.\n")
        cat("      c = shape parameter.\n\n")
      },
      SailaLorda={
        cat("You have chosen the 'Saila-Lorda' stock-recruitment model.\n\n")
        cat("  E[R|S] = a*(S^c)*exp(-b*S)\n\n")
        cat("where a = the density-independent slope near S=0.\n")
        cat("      b = density-dependent parameter.\n")
        cat("      c = shape parameter.\n\n")      }
    )  # end type switch
  } # end if (msg)
  if (simple) type <- paste("S",type,sep="")
  get(type)
}