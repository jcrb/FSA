#'Dynamic plots to explore typical fisheries stock-recruitment models.
#'
#'Plots hypothetical number of recruits versus stock size for four parameterizations
#'of the Beverton-Holt and three parameterizations of the Ricker stock-recruit models.
#'Slider bars are used to alter the parameters of each model.
#'
#'This function can be used to explore the dynamics of stock-recruitment models for
#'various parameter choices.  In these instances of model exploration the \code{S=}
#'and \code{R=} arguments should be (left) set at \code{NULL}.  This function can 
#'also be used to visually \dQuote{fit} a stock-recruit model to a set of observed
#'stock and recruitment data in order to determine reasonable starting values for
#'the non-linear least-squares fit of the stock-recruit model.  In this instance,
#'observed data are plotted by including the vectors of observed stock sizes and 
#'recruits in a model of the form \code{S~R}, in conjunction with the \code{data=}
#'argument.
#'
#'The \code{type=} argument is used to choose either the \code{"BevertonHolt"}
#'or \code{"Ricker"} models.  Different parameterizations of these two models
#'are chosen with the \code{param=} argument.  Four paramaterizations of the Beverton-Holt
#'model and three parameterizations of the Ricker model are allowed.  See \code{\link{srModels}}
#'for a representation of each parameterization.
#'
#'@aliases srSim
#'@param S An optional vector containing observed numbers of spawning stock or
#'a formula as described in the details.
#'@param R An optional vector containing observed numbers of recruits.  See details.
#'@param data An optional data frame containing the variables if \code{S} is a
#'formula.  See details.
#'@param type A single string indicating which stock-recruitment model to use.  See details.
#'@param param A single numeric indicating which parameterization of the \code{type}
#'to use.  See details.
#'@param max.S A single numeric indicating the maximum spawning stock to use for
#'scaling the x-axis.  Ignored if \code{S} is not NULL.
#'@param max.R A single numeric indicating the maximum recruitment to use for scaling
#'the y-axis.  Ignored if \code{S} is not NULL.
#'@return None.  However a dynamic graphic connected to slider bar controls of the
#'\bold{\sQuote{a}}, \bold{\sQuote{b}}, or \bold{\sQuote{Rp}} parameters specific
#'to the chosen stock-recruit model.
#'@seealso \code{\link{srModels}}
#'@keywords iplot
#'@examples
#'if (interactive()) {
#'# Defaults - Beverton-Holt, first parameterization
#'srSim()
#'
#'# Beverton-Holt, second parameterization
#'srSim(param=2)
#'
#'# Ricker model first parameterization
#'srSim(type="Ricker")
#'
#'# Ricker model second parameterization
#'srSim(type="Ricker", param=2)
#'
#'# Ricker model first parameterization with Norwegian Cod data from the FSA package
#'library(FSA)
#'data(CodNorwegian)
#'srSim(recruits~stock,data=CodNorwegian,type="Ricker",param=1)
#'
#'} # end if interactive
#'@rdname srSim
#'@export srSim
#'
srSim <- function(S=NULL,R=NULL,data=NULL,type=c("BevertonHolt","Ricker"),param=1,max.S=500,max.R=1000) {
  type <- match.arg(type)
  if (class(S)=="formula") {
    DF <- model.frame(S,data=data)
    S <- DF[,2]
    R <- DF[,1]
    max.S <- max(S,na.rm=TRUE)  #over-ride provided values if data is given
    max.R <- max(R,na.rm=TRUE)
  }
  if ((!is.null(S) & is.null(R)) | (is.null(S) & !is.null(R))) stop("Both S and R arguments must be supplied if one is given.",call.=FALSE)
  srSim.default(S,R,type,param,max.S,max.R)
}

## Internal plotting function
srSimPlot <- function(a,b,S,R,type,param,max.S,max.R,max.rds) {
  # create a sequence of stock values
  x <- c(seq(0,0.2*max.S,length.out=500),seq(0.2*max.S,max.S,length.out=500)) 
  # create a sequence of recruit values based on model choice
  if (type=="BevertonHolt") {  
    switch(toString(param),
           "1"={Rp <- a/b               # calculated Rp
              y <- a*x/(1+b*x) },       
           "2"={Rp <- b                 # 2nd param is Rp in this parameterization
              y <- a*x/(1+a*(x/Rp)) },
           "3"={Rp <- 1/b               # calculated Rp
              y <- x/(a+b*x) },
           "4"={Rp <- b                 # 2nd param is Rp in this parameterization
              y <- x/(a+x/Rp)}
           ) # end B-H switch
  } else {
    switch(toString(param),
           "1"={Rp <- a/(b*exp(1))      # calculated Rp
              Sp <- 1/b
              y <- a*x*exp(-b*x)  },
           "2"={Rp <- exp(a)/(b*exp(1)) # calculated Rp
              Sp <- 1/b
              y <- x*exp(a-b*x) },
           "3"={Rp <- b                 # 2nd param is Rp in this parameterization
              Sp <- (Rp*exp(1))/a
              y <- a*x*exp(-a*x/(Rp*exp(1))) }
           ) # end Ricker switch
  }
  old.par <- par(mfrow=c(1,2), mar=c(3.5,3.5,1.25,1.25), mgp=c(2,0.4,0), tcl=-0.2, pch=19); on.exit(par(old.par))
  plot(x,y,xlab="Parental (Spawner) Stock",ylab="Recruits",type="l",lwd=2,col="blue",ylim=c(0,max.R),xlim=c(0,max.S))
  if (!(is.null(R)||is.null(S))) { points(S,R,pch=19) }
  abline(h=Rp,lwd=2,lty=3,col="red")
  axis(4,Rp,"Rp",col.ticks="red",col.axis="red",las=1)
  if (type=="Ricker") {
    abline(v=Sp,lwd=2,lty=3,col="red")
    axis(3,Sp,"Sp",col.ticks="red",col.axis="red")
  }
  plot(x,y/x,xlab="Parental (Spawner) Stock",ylab="Recruits/Spawner",type="l",lwd=2,col="blue",ylim=c(0,max.rds),xlim=c(0,max.S))
  if (!(is.null(R)||is.null(S))) { points(S,R/S,pch=19) } 
} # end srSimPlot internal function

## Internal function that processes the dialog box
srSim.default <- function(S,R,type,param,max.S,max.R) {
  # internal refresh function for the dialog box
  refresh <- function(...) srSimPlot(relax::slider(no=1), relax::slider(no=2),S,R,type,param,max.S,max.R,max.rds)
  
  if (type=="BevertonHolt") {
    if (is.na(match(param,1:4))) stop("'param' argument must be in 1:4 when type='BevertonHolt'.",call.=FALSE)
    if (param==1) {              # works OK for default max.S and max.R 
      delta.a <- max.R/10000
      delta.b <- max.S/50000
      max.rds <- ifelse(is.null(S),500*delta.a,max(R/S,na.rm=TRUE)) # set same as max for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(        "a",         "b"),
                     sl.mins=    c( 10*delta.a,      5*delta.b),
                     sl.maxs=    c(500*delta.a,     50*delta.b),
                     sl.deltas=  c(    delta.a,        delta.b),
                     sl.defaults=c(500*delta.a,      5*delta.b),
                     title = "Beverton-Holt Stock-Recruit Model #1",pos.of.panel="left")
    } else if (param==2) {      # works OK for default max.S and max.R
      delta.a <- max.R/10000
      max.rds <- ifelse(is.null(S),1000*delta.a,max(R/S,na.rm=TRUE)) # set same as max for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(         "a",         "Rp"),
                     sl.mins=    c(  10*delta.a,   0.02*max.R),
                     sl.maxs=    c(1000*delta.a,        max.R),
                     sl.deltas=  c(     delta.a,   0.02*max.R),
                     sl.defaults=c( 500*delta.a,        max.R),
                     title = "Beverton-Holt Stock-Recruit Model #2",pos.of.panel="left")
    } else if (param==3) {     # works OK for default max.S and max.R
      delta.a <- 1/max.R
      delta.b <- 0.0001*max.S/max.R
      max.rds <- ifelse(is.null(S),1/(10*delta.a),max(R/S,na.rm=TRUE)) # set same as inverse of min for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(        "a",         "b"),
                     sl.mins=    c( 10*delta.a,  20*delta.b),
                     sl.maxs=    c(200*delta.a, 120*delta.b),
                     sl.deltas=  c(    delta.a,     delta.b),
                     sl.defaults=c( 10*delta.a,  20*delta.b),
                     title = "Beverton-Holt Stock-Recruit Model #3",pos.of.panel="left")
    } else if (param==4) {    # works OK for default max.S and max.R
      delta.a <- 1/max.R
      max.rds <- ifelse(is.null(S),1/(10*delta.a),max(R/S,na.rm=TRUE)) # set same as inverse of min for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(        "a",        "Rp"),
                     sl.mins=    c( 10*delta.a,  0.02*max.R),
                     sl.maxs=    c(200*delta.a,       max.R),
                     sl.deltas=  c(    delta.a,  0.02*max.R),
                     sl.defaults=c( 10*delta.a,       max.R),
                     title = "Beverton-Holt Stock-Recruit Model #4",pos.of.panel="left")
    }
  } else {
    if (is.na(match(param,1:3))) stop("'param' argument must be in 1:3 when type='Ricker'.",call.=FALSE)
    if (param==1) {        # works OK for default max.S and max.R
      delta.a <- 10/max.R
      delta.b <- 0.002*max.S/max.R 
      max.rds <- ifelse(is.null(S),2000*delta.a,max(R/S,na.rm=TRUE))  # set same as max for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(          "a",         "b"),
                     sl.mins=    c(   40*delta.a,   8*delta.b),
                     sl.maxs=    c( 2000*delta.a, 100*delta.b),
                     sl.deltas=  c(      delta.a,     delta.b),
                     sl.defaults=c( 2000*delta.a,   8*delta.b),
                     title = "Ricker Stock-Recruit Model #1",pos.of.panel="left")
    } else if (param==2) {  # works OK for default max.S and max.R
      delta.a <- 10/max.R
      delta.b <- 0.002*max.S/max.R    
      max.rds <- ifelse(is.null(S),exp(300*delta.a),max(R/S,na.rm=TRUE))  # set same as exp(max for a)
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(          "a",         "b"),
                     sl.mins=    c(      delta.a,   8*delta.b),
                     sl.maxs=    c(  300*delta.a, 100*delta.b),
                     sl.deltas=  c(      delta.a,     delta.b),
                     sl.defaults=c(  300*delta.a,   8*delta.b),
                     title = "Ricker Stock-Recruit Model #2",pos.of.panel="left")
    } else {
      delta.a <- 10/max.R
      max.rds <- ifelse(is.null(S),6000*delta.a,max(R/S,na.rm=TRUE))   # set same as max for a
      relax::gslider(refresh,prompt=TRUE,hscale=2,
                     sl.names=   c(          "a",         "Rp"),
                     sl.mins=    c(  550*delta.a,   0.02*max.R),
                     sl.maxs=    c( 6000*delta.a,        max.R),
                     sl.deltas=  c(      delta.a,   0.02*max.R),
                     sl.defaults=c( 6000*delta.a,        max.R),
                     title = "Ricker Stock-Recruit Model #3",pos.of.panel="left")
    }
  }
}