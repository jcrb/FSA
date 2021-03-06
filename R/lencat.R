#' @title Constructs length class/category variable.
#'
#' @description Constructs a vector that contains the length class or category to which an individual belongs.  Optionally, that vector can be appened to the original data frame.
#'
#' @details If \code{breaks} is non-NULL then \code{w} and \code{startcat} will be ignored. The vector of values in \code{breaks} should begin with a value smaller than the minimum observed value and end with a value larger than the maximum observed value.  If the lowest break value is larger than the minimum observed value then an error will occur.  If the largest break value is smaller than the maximum observed value then an additional break value larger than the maximum observed value will be added to \code{breaks} (and a warning will be sent).  The values in \code{breaks} do not have to be equally spaced.
#'
#' If \code{breaks=NULL} (the default) then the value in \code{w} is used to create equally spaced categories.  The start of the length categories can be set with \code{startcat}.  However, if \code{startcat=NULL} (the default) the the length categories will begin with the first value less than the minimum observed value when \dQuote{rounded} by \code{w}.  For example, if the minimum observed value is 67 then the first length category will be 65 if \code{w=5}, 60 if \code{w=10}, 50 if \code{w=25}, and 50 if \code{w=50}.  The length categories will continue from this starting value by values of \code{w} until a category value is greater than the largest observed value in \code{v}.  The length categories are left-inclusive and right-exclusive by default (i.e., \code{right=FALSE}).  The number in the \code{startcat} argument should be less than the smallest value in \code{x}.  Additionally, the number of decimals in \code{startcat} should not be more than the number of decimals in \code{w} (e.g., \code{startcat=0.4} and \code{w=1} will result in an error).
#'
#' One may want to convert apparent numeric values to factor values if some of the length categories are missing (e.g., if factor values are used, for example, then tables of the length categories values will have values for all length categories; i.e., it will have zeroes for the length categories that are missing).  The numeric values can be converted to factors by including \code{as.fact}.  See the \dQuote{real data} example.
#'
#' The observed values in the \code{x} should be rounded to the appropriate number of decimals to avoid misplacement of individuals into incorrect length categories due to issues with machine-precision (see discussion in \code{all.equal}.)
#'
#' @param x A numeric vector that contains the length measurements or a formula of the form \code{~x} where \dQuote{x} generically represents a variable in \code{data} that contains length measurements.  This formula can only contain one variable.
#' @param data A data.frame that minimally contains the length measurements given in the variable in the \code{formula}.
#' @param w A single numeric that indicates the width of length categories to create.
#' @param breaks A numeric vector of lower values for the break points of the length categories.
#' @param startcat A single numeric that indicates the beginning of the first length category.
#' @param right A logical that indicates if the intervals should be closed on the right (and open on the left) or vice versa.
#' @param use.names A logical that indicates whether the names for the values in \code{breaks} should be used for the levels in the new variable.  Will throw a warning and then use default levels if \code{TRUE} but \code{names(breaks)} is \code{NULL}.
#' @param as.fact A logical that indicates that the new variable should be returned as a factor (\code{=TRUE}) or not (\code{=FALSE}; default).
#' @param droplevels,drop.levels A logical that indicates that the new variable should retain all levels indicated in \code{breaks} (\code{=FALSE}; default) or not.  Ignored if \code{as.fact=FALSE}.
#' @param vname A string that contains the name for the new length class variable.
#' @param \dots Not implemented.
#'
#' @return If the formula version of the function is used then a data frame will be returned with the a new variable, named as in \code{vname} or \code{LCat} if no name is given by the user, appended to the original data frame.  If the default version of the function is used then a single vector will be returned.  The returned values will be numeric unless \code{breaks} is named and \code{use.names=TRUE} or if  \code{as.fact=TRUE}.
#' 
#' @author Derek H. Ogle, \email{dogle@@northland.edu}
#'
#' @keywords manip
#'
#' @examples
#' # Create random lengths measured to nearest 0.1 unit
#' df1 <- data.frame(len=round(runif(50,0.1,9.9),1))
#'
#' # Create length categories by 0.1 unit
#' df1$LCat1 <- lencat(df1$len,w=0.1)
#' table(df1$LCat1)
#'
#' # length categories by 0.2 units
#' df1$LCat2 <- lencat(df1$len,w=0.2)
#' table(df1$LCat2)
#'
#' # length categories by 0.2 units starting at 0.1
#' df1$LCat3 <- lencat(df1$len,w=0.2,startcat=0.1)
#' table(df1$LCat3)
#'
#' # length categories as set by breaks
#' df1$LCat4 <- lencat(df1$len,breaks=c(0,2,4,7,10))
#' table(df1$LCat4)
#'
#' ## A Second example
#' # random lengths measured to nearest unit
#' df2 <- data.frame(len=round(runif(50,10,117),0))    
#'
#' # length categories by 5 units
#' df2$LCat1 <- lencat(df2$len,w=5)
#' table(df2$LCat1)
#'
#' # length categories by 5 units starting at 7
#' df2$LCat2 <- lencat(df2$len,w=5,startcat=7)
#' table(df2$LCat2)
#'
#' # length categories by 10 units
#' df2$LCat3 <- lencat(df2$len,w=10)
#' table(df2$LCat3)
#'
#' # length categories by 10 units starting at 5
#' df2$LCat4 <- lencat(df2$len,w=10,startcat=5)
#' table(df2$LCat4)
#'
#' # length categories as set by breaks
#' df2$LCat5 <- lencat(df2$len,breaks=c(5,50,75,150))
#' table(df2$LCat5)
#'
#' ## A Third example
#' # random lengths measured to nearest 0.1 unit
#' df3 <- data.frame(len=round(runif(50,10,117),1))
#'
#' # length categories by 5 units
#' df3$LCat1 <- lencat(df3$len,w=5)
#' table(df3$LCat1)
#'
#' ## A Fourth example
#' # random lengths measured to nearest 0.01 unit
#' df4 <- data.frame(len=round(runif(50,0.1,9.9),2))
#'
#' # length categories by 0.1 unit
#' df4$LCat1 <- lencat(df4$len,w=0.1)
#' table(df4$LCat1)
#'
#' # length categories by 2 unit
#' df4$LCat2 <- lencat(df4$len,w=2)
#' table(df4$LCat2)
#'
#' ## A Fifth example -- with real data
#' data(SMBassWB)
#' # remove variables with "anu" and "radcap" just for simplicity
#' smb1 <- smb2 <- SMBassWB[,-c(8:20)]
#'
#' # 10 mm length classes - in default LCat variable
#' smb1$LCat10 <- lencat(smb1$lencap,w=10)
#' head(smb1)
#' table(smb1$LCat10)
#'
#' # Same as previous but returned as a factor so that levels with no fish are still seen
#' smb1$LCat10A <- lencat(smb1$lencap,w=10,as.fact=TRUE)
#' head(smb1)
#' table(smb1$LCat10A)
#'
#' # Same as previous but returned as a factor with unused levels dropped
#' smb1$LCat10B <- lencat(smb1$lencap,w=10,as.fact=TRUE,droplevels=TRUE)
#' head(smb1)
#' table(smb1$LCat10B)
#'
#' # 25 mm length classes - in custom variable name
#' smb1$LCat25 <- lencat(smb1$lencap,w=25)
#' head(smb1)
#' table(smb1$LCat25)
#'
#' # using values from psdVal for Smallmouth Bass
#' smb1$PSDCat1 <- lencat(smb1$lencap,breaks=psdVal("Smallmouth Bass"))
#' head(smb1)
#' table(smb1$PSDCat1)
#'
#' # add category names
#' smb1$PSDCat2 <- lencat(smb1$lencap,breaks=psdVal("Smallmouth Bass"),use.names=TRUE)
#' head(smb1)
#' table(smb1$PSDCat2)
#'
#' # same as above but drop the unused levels
#' smb1$PSDCat2A <- lencat(smb1$lencap,breaks=psdVal("Smallmouth Bass"),
#'                         use.names=TRUE,droplevels=TRUE)
#' head(smb1)
#' table(smb1$PSDCat2A)
#' str(smb1)
#'
#' # same as above but not returned as a factor (returned as a character)
#' smb1$PSDcat2B <- lencat(smb1$lencap,breaks=psdVal("Smallmouth Bass"),
#'                         use.names=TRUE,as.fact=FALSE)
#' str(smb1)
#' 
#' ## A Sixth example -- similar to the fifth example but using the formula notation
#' # 10 mm length classes - in default LCat variable
#' smb2 <- lencat(~lencap,data=smb2,w=10)
#' head(smb2)
#'
#' # 25 mm length classes - in custom variable name
#' smb2 <- lencat(~lencap,data=smb2,w=25,vname="LenCat25")
#' head(smb2)
#'
#' # using values from psdVal for Smallmouth Bass
#' smb2 <- lencat(~lencap,data=smb2,breaks=psdVal("Smallmouth Bass"),vname="LenPsd")
#' head(smb2)
#'
#' # add category names
#' smb2 <- lencat(~lencap,data=smb2,breaks=psdVal("Smallmouth Bass"),vname="LenPsd2",
#'                use.names=TRUE,droplevels=TRUE)
#' head(smb2)
#' str(smb2)
#'
#' @rdname lencat
#' @export
lencat <- function (x,...) {
  UseMethod("lencat") 
}

#' @rdname lencat
#' @export
lencat.default <- function(x,w=1,breaks=NULL,startcat=NULL,
                           right=FALSE,use.names=FALSE,
                           as.fact=use.names,
                           droplevels=drop.levels,drop.levels=FALSE,
                           ...) {
  ## Some Checks
  if (!is.numeric(x)) stop("'x' must be numeric.",call.=FALSE)
  if (length(w)>1) stop("'w' must be of length 1.",call.=FALSE)
  if (w<0) stop("'w' must be positive.",call.=FALSE)
  if (!is.null(startcat)) if (length(startcat)>1) stop("'startcat' must be of length 1.",call.=FALSE)
  ## Check whether x is all NAs
  if (all(is.na(x))) {
    ## If so, send a warning.
    warning("Note that all values in 'x' were missing.",call.=FALSE)
    ## and put all NAs in lcat to return (i.e., if x are all
    ## missing then make the length categories all missing)
    lcat <- x
  } else {
    ## If not then create the length categories
    ## find range of values in x
    maxx <- max(x,na.rm=TRUE)
    minx <- min(x,na.rm=TRUE)
    if (is.null(breaks)) {
      ## If no breaks given then create them
      if (is.null(startcat)) startcat <- floor(minx/w)*w
      # identify decimals in startcat and w
      decs <- iCheckStartcatW(startcat,w,x)
      # Creates cut breaks (one more than max so that max is included in a break)
      breaks <- round(seq(startcat,maxx+w,w),decs$wdec)
    } else {
      ## breaks are given, check to see if they are useable
      # remove NAs (if they exist)
      breaks <- breaks[!is.na(breaks)]
      # stop if breaks don't go below minimum observed value
      if (minx < breaks[1]) stop("Lowest break (",breaks[1],") is larger than minimum observation (",minx,").",call.=FALSE)
      # make a break larger than maximum value if needed
      if (maxx >= max(breaks)) breaks <- c(breaks,1.1*maxx)
    }
    ## actually make the values
    lcat <- breaks[cut(x,breaks,labels=FALSE,right=right,include.lowest=TRUE)]
    ## convert numeric to factor if asked to do so (drop last break that is always empty)
    if (as.fact) lcat <- factor(lcat,levels=breaks[-length(breaks)])
    ## converts length categories to level names
    if (!use.names) {
      # remove names from variable if they exist and use.names=FALSE
      if(!is.null(names(breaks))) names(lcat) <- NULL
    } else {
      if (is.null(names(breaks))) {
        warning("'use.catnames=TRUE', but 'breaks' is not named.  Used default labels.",call.=FALSE)
      } else {
        # if breaks has names, add new var with those names by comparing to numeric breaks
        lcat <- names(breaks)[match(lcat,breaks)]
        # make sure the labels are ordered as ordered in breaks (drop last break that is always empty)
        if (as.fact) lcat <- factor(lcat,levels=names(breaks))
        #      lcat <- factor(lcat,levels=names(breaks)[-length(breaks)])
        # change logical to note that it was a factor
        #      as.fact <- TRUE
      }
    }
    if (as.fact & droplevels) lcat <- droplevels(lcat)
  }
  lcat
}

#' @rdname lencat
#' @export
lencat.formula <- function(x,data,w=1,breaks=NULL,startcat=NULL,
                           right=FALSE,use.names=FALSE,
                           as.fact=use.names,droplevels=drop.levels,drop.levels=FALSE,
                           vname=NULL,...) {
  ## Handle the formula with some checks
  x <- iHndlFormula(x,data)
  if (x$vnum>1) stop("'x' must be only one variable.",call.=FALSE)

  ## Create the length category variable
  tmp <- lencat.default(data[,x$vname],w=w,breaks=breaks,startcat=startcat,right=right,
                        use.names=use.names,as.fact=as.fact,droplevels=droplevels)
  ## Append the new variable to the old data.frame
  nd <- data.frame(data,tmp)
  ## Name the new variable
  names(nd)[ncol(nd)] <- iMakeVname(vname,data)
  ## Return the new data.frame
  nd
}

##############################################################
## Internal function to create a name for the variable if
##   none was given in vname
##############################################################
iMakeVname <- function(vname,data) {
  # if no name given then default to "LCat"
  if (is.null(vname)) vname <- "LCat"
  # create list of names that includes vname & vname with numbers appended 
  vnames <- c(vname,paste(vname,seq(1:100),sep=""))
  # find first instance where names match
  ind <- which(vnames %in% names(data))
  # if no match then go with given vname
  if (length(ind)==0) vname <- vname
  # if is match then go with name that is one index later in vnames
  else vname <- vnames[max(ind)+1]
  vname
}
