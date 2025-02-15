% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/patchDetection.R
\name{patchDetection}
\alias{patchDetection}
\title{Function to detect patches containing defined cell types}
\usage{
patchDetection(
  object,
  patch_cells,
  colPairName,
  min_patch_size = 1,
  name = "patch_id",
  expand_by = 0,
  coords = c("Pos_X", "Pos_Y"),
  convex = FALSE,
  img_id = NULL,
  BPPARAM = SerialParam()
)
}
\arguments{
\item{object}{a \code{SingleCellExperiment} or \code{SpatialExperiment}
object}

\item{patch_cells}{logical vector of length equal to the number of cells
contained in \code{object}. \code{TRUE} entries define the cells to consider
for patch detection (see Details).}

\item{colPairName}{single character indicating the \code{colPair(object)}
entry containing the neighbor information.}

\item{min_patch_size}{single integer indicating the minimum number of 
connected cells that make up a patch before expansion.}

\item{name}{single character specifying the \code{colData} entry storing
the patch IDs in the returned object.}

\item{expand_by}{single numeric indicating in which vicinity range cells
should be considered as belonging to the patch (see Details).}

\item{coords}{character vector of length 2 specifying the names of the
\code{colData} (for a \code{SingleCellExperiment} object) or the
\code{spatialCoords} entries of the cells' x and y locations.}

\item{convex}{should the convex hull be computed before expansion? Default:
the concave hull is computed.}

\item{img_id}{single character indicating the \code{colData(object)} entry
containing the unique image identifiers.}

\item{BPPARAM}{a \code{\link[BiocParallel]{BiocParallelParam-class}} object
defining how to parallelize computations.}
}
\value{
An object of \code{class(object)} containing a patch ID for each 
cell in \code{colData(object)[[name]]}.
}
\description{
Function to detect spatial clusters of defined types of cells.
By defining a certain distance threshold, all cells within the vicinity
of these clusters are detected as well.
}
\section{Detecting patches of defined cell types}{

This function works as follows:

1. Only cells defined by \code{patch_cells} are considered for patch 
detection.

2. Patches of connected cells are detected. Here, cell-to-cell connections
are defined by the interaction graph stored in 
\code{colPair(object, colPairName)}. At this point, patches that contain 
fewer than \code{min_patch_size} cells are removed.

3. If \code{expand_by > 0}, a concave (default) or convex hull is constructed
around each patch. This is is then expanded by \code{expand_by} and cells
within the expanded hull are detected and assigned to the patch. This 
expansion only works if a patch contains at least 3 cells.

The returned object contains an additional entry 
\code{colData(object)[[name]]}, which stores the patch ID per cell. \code{NA}
indicate cells that are not part of a patch.
}

\examples{
library(cytomapper)
data(pancreasSCE)

# Visualize cell types
plotSpatial(pancreasSCE, img_id = "ImageNb", node_color_by = "CellType")

# Build interaction graph
pancreasSCE <- buildSpatialGraph(pancreasSCE, img_id = "ImageNb", 
                                 type = "expansion", threshold = 20)

# Detect patches of "celltype_B" cells
pancreasSCE <- patchDetection(pancreasSCE, 
                              patch_cells = pancreasSCE$CellType == "celltype_B",
                              colPairName = "expansion_interaction_graph")
                              
plotSpatial(pancreasSCE, img_id = "ImageNb", node_color_by = "patch_id")

# Include cells in vicinity
pancreasSCE <- patchDetection(pancreasSCE, 
                              patch_cells = pancreasSCE$CellType == "celltype_B",
                              colPairName = "expansion_interaction_graph",
                              expand_by = 20, 
                              img_id = "ImageNb")

plotSpatial(pancreasSCE, img_id = "ImageNb", node_color_by = "patch_id")
  
}
\references{
\href{https://www.biorxiv.org/content/10.1101/2021.07.29.454093v1}{
Hoch, T. et al., Multiplexed Imaging Mass Cytometry of Chemokine Milieus in 
Metastatic Melanoma Characterizes Features of Response to Immunotherapy., 
bioRxiv 2021}
}
\author{
Tobias Hoch

adapted by Nils Eling (\email{nils.eling@dqbm.uzh.ch})
}
