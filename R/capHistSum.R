#' @title Summarize capture histories in individual fish format.
#'
#' @description Use to summarize a capture history data file that is in the \dQuote{individual} fish format (see \code{\link{capHistConvert}} for a discussion of data file format types).  Summarized capture history results may be used in the Lincoln-Petersent, Schnabel, Schumacher-Eschmeyer, or Jolly-Seber methods for estimating population abundance (see \code{\link{mrClosed}} and \code{\link{mrOpen}}).
#'
#' @details This function requires the capture history data file to be in the \dQuote{individual} fish format.  See \code{\link{capHistConvert}} for a description of this (and other) formats and for methods to convert from other formats to the \dQuote{individual} fish format.  In addition, this function requires only the capture history portion of the data file.  Thus, if \code{df} contains columns with non-capture history information (e.g., fish ID, length, location, etc.) then use \code{cols2use=} to identify which columns contain only the capture history information.  Columns to use can be identified by listing the column numbers (e.g., columns 2 through 7 could be included with \code{cols2use=2:7}).  In many instances it may be easier to identify columns to \emph{exclude} which can be done by preceding the column number by a negative sign (e.g., columns 1 through 3 are excluded with \code{cols2use=-(1:3)}).
#' 
#' The object returned from this function can be used directly in \code{\link{mrClosed}} and \code{\link{mrOpen}}.  See examples of this functionality on the help pages for those functions.
#' 
#' The \code{plot} function can be used to construct the two diagnostic plots described by Baillargeon and Rivest (2007).  The \code{what="f"} plot will plot the log of the number of fish seen i times divided by \code{choose(t,i)} against i.  The \code{what="u"} plot will plot the log of the number of fish seen for the first time on event i against i.  Baillargeon and Rivest (2007) provide a table that can be used to diagnosed types of heterogeneities in capture probabilities from these plots.
#'
#' @note This function assumes that all unmarked captured fish are marked and returned to the population (i.e., no losses at the time of marking are allowed).
#' 
#' @param df A data.frame that contains the capture histories (and, perhaps, other information) in \dQuote{individual} fish format.  See details.
#' @param cols2use A numeric vector of columns that contain the capture histories.  See details.
#' @param x An object from \code{capHistSum}.
#' @param what A string that indicates what type of diagnostic plot to construct with \code{plot}.  See details.
#' @param \dots Optional arguments to send to \code{plot}.
#'
#' @author Derek H. Ogle, \email{dogle@@northland.edu}
#'
#' @return If the capture history data file represents only two samples, then a list with the following two components is returned.
#'  \itemize{
#'    \item \code{caphist} A vector summarizing the frequency of fish with each capture history.
#'    \item \code{sum} A data.frame that contains the number of marked fish from the first sample (\code{M}), the number of captured fish in the second sample (\code{n}), and the number of recaptured (i.e. previously marked) fish in the second sample (\code{m}).
#'  }
#'
#' If the capture history data file represents more than two samples, then a list with the following five components is returned
#'  \itemize{
#'    \item \code{caphist} A vector summarizing the frequency of fish with each capture history.
#'    \item \code{sum} A data frame that contains the the number of captured fish in the ith sample (\code{n}), the number of recaptured (i.e. previously marked) fish in the ith sample (\code{m}), the number of marked fish returned to the population following the ith sample (\code{R}; this will equal \code{n} as the function currently does not handle mortalities); the number of marked fish in the population prior to the ith sample (\code{M}); the number of fish first seen in the ith sample (\code{u}); the number of fish lasst seen in the ith sample (\code{v}); and the number of fish seen i times (\code{f}).
#'    \item \code{methodB.top} A matrix that contains the top of the Method B table used for the Jolly-Seber method (i.e., a contingency table of capture sample (columns) and last seen sample (rows)).
#'    \item \code{methodB.bot} A data.frame that contains the bottom of the Method B table used for the Jolly-Seber method (i.e., the number of marked fish in the sample (\code{m}), the number of unmarked fish in the sample (\code{u}), the total number of fish in the sample (\code{n}), and the number of marked fish returned to the population following the sample (\code{R}).
#'    \item \code{m.array} A matrix that contains the the so-called \dQuote{m-array}.  The first column contains the number of fish captured on the ith event.  The columns labelled with \dQuote{cX} prefix show the number of fish originally captured in the ith row that were captured in the Xth event.  The last column shows the number of fish originally captured in the ith row that were never recaptured.
#'  }
#'
#' @seealso See \code{description} in \pkg{Rcapture} for \code{m.array} and some of the same values in \code{sum}.  See \code{\link{capHistConvert}} for a descriptions of capture history data file formats and how to convert between them.  See \code{\link{mrClosed}} and \code{\link{mrOpen}} for how to estimate abundance from the summarized capture history information.
#'
#' @section fishR vignette: \url{https://sites.google.com/site/fishrfiles/gnrl/MRClosed.pdf}, \url{https://sites.google.com/site/fishrfiles/gnrl/MROpen.pdf}
#'
#' @references Baillargeon, S. and Rivest, L.-P. (2007). Rcapture: Loglinear models for capture-recapture in R. Journal of Statistical Software, 19(5):1-31.
#' 
#' @keywords manip
#' 
#' @aliases capHistSum age.CapHist
#' 
#' @examples
#' # data.frame with IDs in the first column
#' data(PikeNYPartial1)
#' head(PikeNYPartial1)
#' ( ch1 <- capHistSum(PikeNYPartial1,cols2use=-1) )
#' 
#' # diagnostic plots
#' plot(ch1)
#' plot(ch1,what="f")
#' plot(ch1,what="u")
#'
#' # An examle with only two sample events (for demonstration only)
#' ( ch2 <- capHistSum(PikeNYPartial1,cols2use=-c(1,4:5)) )
#'
#' @rdname capHistSum
#' @export
capHistSum <- function(df,cols2use=NULL) {
  
  # start of main capHistSum function  
  ifelse(is.null(cols2use),ch <- df, ch <- df[,cols2use])    
  # Number of samples
  k <- dim(ch)[2]
  # Capture history frequencies
  res1 <- iSumCH(ch)
  if (k==2) {
    d <- list(caphist=res1,sum=iSumCHnumPetersen(res1))
  } else {
    # Construct schnabel summary from marked & unmarked
    res2.schnabel <- iSumCHnumSchnabel(ch,k)
    # Construct jolly bottom method B table from marked & unmarked
    res2.jolly <- iMethodBBot(ch,k)
    # Construct jolly top method B table
    res3 <- iMethodBTop(ch,k)
    # Construct m-array table from top of methodB table
    res4 <- iMarray(res3,res2.schnabel)
    # Put together as a list
    d <- list(caphist=res1,sum=res2.schnabel,methodB.top=res3,methodB.bot=res2.jolly,m.array=res4)
  }
  class(d) <- "CapHist"
  d
}


##############################################################
## INTERNAL - Frequency of fish by unique capture history
##############################################################
iSumCH <- function(ch) {
  # Concatenate 0,1s to make a composite label
  ch.lbl <- apply(ch,1,paste,collapse="")
  # Send back the frequency table by capture history
  table(as.factor(ch.lbl))
}

##############################################################
## INTERNAL - Find number of marks, recaps, total catch by sample
##############################################################
iSumCHnum <- function(ch,k) {
  # Total number (catch) in each sample
  n <- apply(ch,2,sum)
  # Initiate number of marks
  m <- rep(0,k)
  # Store first sample in a temp vector
  chp <- ch[,1]
  # Cycle through remaining samples
  for (i in 2:k) {
    #   Cross-tab previous with ith samples
    st <- table(chp,ch[,i])
    #   Marked fish seen in both samples (i.e., 1,1 group)
    if (any(rownames(st)=="1") & any(colnames(st)=="1")) {
      m[i] <- st["1","1"]
    }
    #   Add ith sample to previous samples, 1s indicate previously caught
    chp <- as.numeric(chp+ch[,i]>0)
  }
  # Unmarked fish
  u <- n-m
  # Return results as a data.frame
  data.frame(n,m,u)
}

##############################################################
## INTERNAL - 
##############################################################
iSumCHnumPetersen <- function(cht) {
  df <- data.frame(M=cht["10"]+cht["11"],
                   n=cht["01"]+cht["11"],
                   m=cht["11"])
  rownames(df) <- NULL
  df
}

##############################################################
## INTERNAL - Modify mark, recap, catch data to a Schnabel summary
##############################################################
iSumCHnumSchnabel <- function(ch,k) {
  # Frequency of marked and unmarked fish in each sample
  df <- iSumCHnum(ch,k)
  # Unmarked fish returned to the population after sample
  R <- df$n
  #   0 by default for last sample
  R[k] <- 0
  # Marked fish prior to sample
  M <- c(0,cumsum(df$n-df$m)[1:(k-1)])
  # Number of fish seen for first time at i
  u <- iGetUi(ch)
  # Number of fish seen for lat time at i
  v <- iGetVi(ch)
  # Number of fish seen i times
  f <- iGetFi(ch)
  # Return results as a data.frame
  data.frame(n=df$n,m=df$m,R,M,u,v,f)
}


iGetFi <- function(chdf) {
  # as.vector to strip attributes
  as.vector(table(factor(rowSums(chdf),levels=1:ncol(chdf))) )
}

iGetVi <- function(chdf) {
  events <- ncol(chdf)
  vi <- numeric(events)
  for (i in 1:events) {
    if (i<(events-1)) {
      # captured in the ith event, get ch for all events after that
      tmp1 <- chdf[chdf[,i]==1,(i+1):events]
      # If rowSums==0 then it was not captured again
      tmpv <- table(rowSums(tmp1))
      vi[i] <- ifelse(any(names(tmpv)=="0"),tmpv["0"],0)
    } else if (i==(events-1)) {
      # handle second to last event which produces a vector (can't use rowSums)
      tmp1 <- chdf[chdf[,i]==1,events]
      vi[i] <- length(tmp1)
    } else {
      # handle last event ... vi is just ni
      vi[i] <- sum(chdf[,i])
    }
  }
  vi
}

iGetUi <- function(chdf) {
  events <- ncol(chdf)
  ui <- numeric(events)
  for (i in 1:events) {
    if (i==1) {
      # handle first event, ui=ni
      ui[i] <- sum(chdf[,i])
    } else if (i==2) {
      tmp1 <- chdf[chdf[,i]==1,1:(i-1)]
      ui[i] <- length(tmp1)
    } else {
      # captured in ith event, get ch for all events before that
      tmp1 <- chdf[chdf[,i]==1,1:(i-1)]
      # if rowSums==0 then it was not captured previously
      tmpu <- table(rowSums(tmp1))
      ui[i] <- ifelse(any(names(tmpu)=="0"),tmpu["0"],0)
    }
  }
  ui
}


##############################################################
## INTERNAL - Modify mark, recap, catch data to a Jolly (bottom Method B) summary
##############################################################
iMethodBBot <- function(ch,k) {
  # Frequency of marked and unmarked fish in each sample
  df <- iSumCHnum(ch,k)
  # Unmarked fish returned to the population after sample
  R <- df$n
  #   0 by default for last sample
  R[k] <- 0
  # Put together a matrix (first 3 are re-ordering of df)
  tmp <- rbind(df$m,df$u,df$n,R)
  # rename rows and columns
  rownames(tmp) <- c("m","u","n","R")
  colnames(tmp) <- paste0("i=",1:ncol(tmp))
  # return matrix
  tmp
}

##############################################################
## INTERNAL -- Make top of the Method B table
##############################################################
iMethodBTop <- function(ch,k) {
  # create a matrix to hold the Method B table (NA on lower triangle, 0 on upper)
  mb.top <- matrix(nrow=k,ncol=k)
  mb.top[upper.tri(mb.top)] <- 0
  # Loop through each possible recapture time
  for (i in 2:k) {
    # Reduce matrix to only fish sampled at time i (i.e., all 1s in ith column)
    ch.tmp.i <- ch[ch[,i]==1,,drop=FALSE]
    # Need to look for previous capture times
    for (j in (i-1):1) {
      # Find the matrix to fish sampled at both times i and j, but not between i and j
      #   i.e., all 1s in columns i and j
      ch.tmp.j <- ch.tmp.i[ch.tmp.i[,j]==1,,drop=FALSE]
      mb.top[j,i] <- nrow(ch.tmp.j)
      # Keep the rows where fish were not sampled on jth sample
      ch.tmp.i <- ch.tmp.i[ch.tmp.i[,j]==0,,drop=FALSE]
      # if no rows are left then nothing left to do
      if (nrow(ch.tmp.i)==0) break
    } # end j loop
  } # end i loop
  # relabel rows and columns
  colnames(mb.top) <- paste0("i=",1:ncol(mb.top))
  rownames(mb.top) <- paste0("j=",1:nrow(mb.top))
  # return matrix
  mb.top
}

##############################################################
## INTERNAL -- Make m-array from top of Method B table
##############################################################
iMarray <- function(mb,smry) {
  events <- ncol(mb)
  # label rows and columns of mb (follow strategy in Rcapture)
  rownames(mb) <- paste0("i=",1:events)
  colnames(mb) <- paste0("c",1:events)
  # put ni in first column
  mb[,1] <- smry$n
  colnames(mb)[1] <- "ni"
  # put non-captured total in last column
  tmp <- mb[,1]-rowSums(mb[,2:events],na.rm=TRUE)
  mb <- cbind(mb,tmp)
  colnames(mb)[events+1] <- "not recapt"
  # return matrix
  mb
}

#' @rdname capHistSum
#' @export
plot.CapHist <- function(x,what=c("u","f"),...) {
  opar <- par()
  what <- match.arg(what,several.ok=TRUE)
  tmp <- x$sum[,c("n","u","f")]
  t <- nrow(tmp)
  tmp$i <- 1:t
  # scale the F variable
  tmp$sf <- log(tmp$f/choose(t,tmp$i))
  tmp$sf[which(tmp$f==0)] <- NA
  # log of the U variable
  tmp$su <- log(tmp$u)
  tmp$su[which(tmp$u==0)] <- NA
  # catch if two plots are being made
  if (length(what)==2) opar <- par(mfrow=c(1,2))
  # make the fi plot
  if ("f" %in% what) {
    tmp2 <- tmp[!is.na(tmp$sf),]
    plot(sf~i,data=tmp2,ylab="log(scaled fi)",xlab="Number of Times Captured",type="b",pch=16,...)
  }
  # make the ui plot
  if ("u" %in% what) {
    plot(su~i,data=tmp,ylab="log(ui)",xlab="Capture Event (i)",type="b",pch=16,...)
  }
  par(opar)
}
