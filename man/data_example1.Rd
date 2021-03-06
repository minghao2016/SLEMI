% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{data_example1}
\alias{data_example1}
\title{Exemplary data set I}
\format{
A data frame with 1500 rows and 3 variables:
\describe{
\item{signal}{Label of input}
\item{response}{The value of output}
\item{sideVar}{Label of the type of given observation}
}
}
\source{
synthetic
}
\usage{
data_example1
}
\description{
A dataset describing simple one dimensional input - one dimensional output channel 
with 500 observations per input. In addition, each observation is assigned to one of three types
that occurs with propensities (0.6,0.3,0.1), respectively 
Conditional output distributions are Gaussian.
}
\keyword{internal}
