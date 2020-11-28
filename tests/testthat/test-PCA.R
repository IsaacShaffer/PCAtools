test_that("PCA works", {
  expect_equal(round(PCA(iris[,1:4])$x[1,1], 3), -2.684)
})
