test_that("Reconstruction error works", {
  expect_equal(floor(PCAReconstructionError(iris[,1:4], PCA(iris[,1:4]))[1,1]), 51)
})
