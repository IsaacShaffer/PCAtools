# PCAtools

A Principal Components Analysis (PCA) tool.

### Installation

devtools::install_github("IsaacShaffer/PCAtools")

### Usage

For a complete full rank PCA analysis:

```r
iris_demo <- PCA(iris[,1:4])
```

The data projected onto their respective PCs:

```
> head(iris_demo$x)

          [,1]       [,2]        [,3]         [,4]
[1,] -2.684126 -0.3193972  0.02791483  0.002262437
[2,] -2.714142  0.1770012  0.21046427  0.099026550
[3,] -2.888991  0.1449494 -0.01790026  0.019968390
[4,] -2.745343  0.3182990 -0.03155937 -0.075575817
[5,] -2.728717 -0.3267545 -0.09007924 -0.061258593
[6,] -2.280860 -0.7413304 -0.16867766 -0.024200858

```

They can be used in conjunction with other dimension reduction assessment tools like `PCAReconstructionError`:

```
> PCAReconstructionError(iris[,1:4], iris_demo)
             RE Components
1: 5.136259e+01          1
2: 1.520464e+01          2
3: 3.551429e+00          3
4: 8.245577e-29          4
```

