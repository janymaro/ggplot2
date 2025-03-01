% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stat-sf-coordinates.R
\docType{data}
\name{stat_sf_coordinates}
\alias{stat_sf_coordinates}
\alias{StatSfCoordinates}
\title{Extract coordinates from 'sf' objects}
\usage{
stat_sf_coordinates(
  mapping = aes(),
  data = NULL,
  geom = "point",
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  fun.geometry = NULL,
  ...
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[=aes]{aes()}}. If specified and
\code{inherit.aes = TRUE} (the default), it is combined with the default mapping
at the top level of the plot. You must supply \code{mapping} if there is no plot
mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[=ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[=fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{geom}{The geometric object to use to display the data, either as a
\code{ggproto} \code{Geom} subclass or as a string naming the geom stripped of the
\code{geom_} prefix (e.g. \code{"point"} rather than \code{"geom_point"})}

\item{position}{Position adjustment, either as a string naming the adjustment
(e.g. \code{"jitter"} to use \code{position_jitter}), or the result of a call to a
position adjustment function. Use the latter if you need to change the
settings of the adjustment.}

\item{na.rm}{If \code{FALSE}, the default, missing values are removed with
a warning. If \code{TRUE}, missing values are silently removed.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[=borders]{borders()}}.}

\item{fun.geometry}{A function that takes a \code{sfc} object and returns a \code{sfc_POINT} with the
same length as the input. If \code{NULL}, \code{function(x) sf::st_point_on_surface(sf::st_zm(x))}
will be used. Note that the function may warn about the incorrectness of
the result if the data is not projected, but you can ignore this except
when you really care about the exact locations.}

\item{...}{Other arguments passed on to \code{\link[=layer]{layer()}}. These are
often aesthetics, used to set an aesthetic to a fixed value, like
\code{colour = "red"} or \code{size = 3}. They may also be parameters
to the paired geom/stat.}
}
\description{
\code{stat_sf_coordinates()} extracts the coordinates from 'sf' objects and
summarises them to one pair of coordinates (x and y) per geometry. This is
convenient when you draw an sf object as geoms like text and labels (so
\code{\link[=geom_sf_text]{geom_sf_text()}} and \code{\link[=geom_sf_label]{geom_sf_label()}} relies on this).
}
\details{
coordinates of an \code{sf} object can be retrieved by \code{sf::st_coordinates()}.
But, we cannot simply use \code{sf::st_coordinates()} because, whereas text and
labels require exactly one coordinate per geometry, it returns multiple ones
for a polygon or a line. Thus, these two steps are needed:
\enumerate{
\item Choose one point per geometry by some function like \code{sf::st_centroid()}
or \code{sf::st_point_on_surface()}.
\item Retrieve coordinates from the points by \code{sf::st_coordinates()}.
}

For the first step, you can use an arbitrary function via \code{fun.geometry}.
By default, \code{function(x) sf::st_point_on_surface(sf::st_zm(x))} is used;
\code{sf::st_point_on_surface()} seems more appropriate than \code{sf::st_centroid()}
since lables and text usually are intended to be put within the polygon or
the line. \code{sf::st_zm()} is needed to drop Z and M dimension beforehand,
otherwise \code{sf::st_point_on_surface()} may fail when the geometries have M
dimension.
}
\section{Computed variables}{

These are calculated by the 'stat' part of layers and can be accessed with \link[=aes_eval]{delayed evaluation}.
\itemize{
\item \code{after_stat(x)}\cr X dimension of the simple feature.
\item \code{after_stat(y)}\cr Y dimension of the simple feature.
}
}

\examples{
if (requireNamespace("sf", quietly = TRUE)) {
nc <- sf::st_read(system.file("shape/nc.shp", package="sf"))

ggplot(nc) +
  stat_sf_coordinates()

ggplot(nc) +
  geom_errorbarh(
    aes(geometry = geometry,
        xmin = after_stat(x) - 0.1,
        xmax = after_stat(x) + 0.1,
        y = after_stat(y),
        height = 0.04),
    stat = "sf_coordinates"
  )
}

}
\keyword{datasets}
