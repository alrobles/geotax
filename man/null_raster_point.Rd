% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/null_raster_point.R
\name{null_raster_point}
\alias{null_raster_point}
\title{Create a point matrix from from a shape file with an arbitrary resolution}
\usage{
null_raster_point(shp, res)
}
\arguments{
\item{shp}{A shape file}

\item{res}{A resolution vector of the null raster in geographical degrees}
}
\value{
a data frame of null points
}
\description{
Create a point matrix from from a shape file with an arbitrary resolution
}
\examples{
null_raster_point(shp = mexico, res = 1)
}
