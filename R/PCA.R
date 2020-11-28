#' A Principal Components Analysis tool
#' based on single value decomposition
#'
#'
#' @param data - An N x P matrix of N observations on P features.
#' @param scale - If TRUE features are scaled AND centered. If FALSE features are only centered. default: FALSE
#'
#' @return
#' @export
#'
#' @examples
#' PCA.model <- PCA(iris[,1:4])
PCA <- function(data, scale = FALSE) {
  # Coerce data.frame or data.table to matrix
  # Use separate step for better trace back
  # A simple column sd function
  colSd <- function(data) {
    data.mat <- as.matrix(data)
    return(apply(data.mat, 2, stats::sd) )
  }
  data.mat <- as.matrix(data)
  if (scale) {
    # Calculate scale vector
    scale.out = colSd(data.mat)
    # Calculate mean/center vector
    center.out = colMeans((data.mat))
    # Scale and center data
    scaled_centered_data.mat <- t(apply(data.mat, 1,
                                        function(x){(x-center.out)/scale.out}))
  } else {
    scale.out = FALSE
    # Calculate mean/center vector
    center.out = colMeans((data.mat))
    # Center data
    scaled_centered_data.mat <- t(apply(data.mat, 1, function(x){x-center.out}))
  }
  # Estimate spectral decomposition for centered (and scaled?)
  # data.
  # TODO: Add rank limits
  svd_results.list <- svd(scaled_centered_data.mat)
  # Extract rotation matrix providied in prcomp results
  rotation <- svd_results.list$v
  # calculate projections from data onto all principal components
  x <- scaled_centered_data.mat %*% rotation
  # Return a list of results similar to prcomp
  return(list(rotation = rotation,
              center = center.out,
              scale = scale.out,
              x = x))
}
