#' @title Capture histories (2 samples) of Bluegill from Jewett Lake.
#'
#' @description Each line consists of the capture history over two samples of Bluegill (\emph{Lepomis macrochirus}) in Jewett Lake (MI).  This file contains the capture histories for only Bluegill larger thatn 6-in.
#'
#' @name BluegillJL
#'
#' @docType data
#' 
#' @format A data frame with 277 observations on the following 2 variables.
#'  \describe{
#'    \item{first}{a numeric vector of indicator variables for the first sample (1=captured).}
#'    \item{second}{a numeric vector of indicator variables for the second sample (1=captured).} 
#'  }
#' 
#' @section Topic(s):
#'  \itemize{
#'    \item Population size
#'    \item Abundance
#'    \item Mark-recapture
#'    \item Petersen method
#'    \item Capture history
#'  }
#' 
#' @concept Abundance 'Population Size' 'Mark-Recapture' Petersen 'Capture History'
#' 
#' @source From example 8.1 in Schneider, J.C. 1998. \href{http://www.michigandnr.com/publications/pdfs/IFR/manual/SMII\%20Chapter08.pdf}{Lake fish population estimates by mark-and-recapture methods.}  Chapter 8 in Schneider, J.C. (ed.) 2000. Manual of fisheries survey methods II: with periodic updates. Michigan Department of Natural Resources, Fisheries Special Report 25, Ann Arbor.
#' 
#' @keywords datasets
#' 
#' @examples
#' data(BluegillJL)
#' str(BluegillJL)
#' head(BluegillJL)
#'
NULL
