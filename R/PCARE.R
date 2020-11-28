#' Calculates reconstruction error for Principal Components
#' Analysis -- PCA -- with output from stats::prcomp or PCA in this package.
#'
#' @param data - original data used to create PCA model
#' @param mod.pca - a PCA or stats::prcomp model
#' @param max_components - Maximum number of PCs to include
#'
#' @return
#' @export
#'
#' @examples
#' iris_re <- PCAReconstructionError(iris[,1:4], PCA(iris[,1:4]))
PCAReconstructionError <- function(data, mod.pca, max_components) {
  if (missing(max_components)) {max_components <- ncol(mod.pca$rotation)}
  data.mat <- as.matrix(data)

  # Deal with possibly scaled data. Subtracting mean here and
  # possibly scaling
  if ((is.logical(mod.pca$scale)) && (!mod.pca$scale)) {
    scaled_centered_data.mat <- scale(data.mat, center = TRUE, scale = FALSE)
  } else {
    scaled_centered_data.mat <- scale(data.mat, center = TRUE, scale = TRUE)
  }
  # Initialize results list for do.call/rbind recovery
  # after loop
  RE_data.list <- list()
  # Set previous fit values. Would be the mean.mat if not
  # for the centering above.
  previous_fit.mat <- matrix(rep(0, nrow(data.mat)*ncol(data.mat)),
                             nrow = nrow(data.mat))
  # Loop over desired number of principal components for calculate
  # reconstruction error
  for (current_PC in 1:max_components){
    # Build a matrix of partial projections for each
    # projected data point given the current principal component
    this_PC <- mod.pca$rotation[,current_PC]
    PC.mat <- matrix(this_PC, nrow=nrow(data.mat), ncol=ncol(data.mat), byrow=TRUE)
    # Calculate projection data projection onto onto all
    # principal components up to the current component
    fit.mat <- previous_fit.mat + PC.mat * mod.pca$x[, current_PC]
    # Calculate the Reconstruction Error as described in
    # Elements of Statistical Learning, Eq 14.50
    RE_data.list[[paste(current_PC)]] <- data.table::data.table(
      RE = sum((scaled_centered_data.mat - fit.mat)^2),
      Components = current_PC)
    # Save fit results for next iteration
    previous_fit.mat <- fit.mat
  }
  # return results as a data.table
  return(do.call(rbind, RE_data.list))
}
