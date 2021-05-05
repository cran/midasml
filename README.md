midasml - Estimation and Prediction Methods for High-Dimensional Mixed Frequency Time Series Data

## About

The *midasml* package implements *estimation* and *prediction* methods for high-dimensional mixed-frequency (MIDAS) time-series and panel data regression models. The regularized MIDAS models are estimated using orthogonal (e.g. Legendre) polynomials and sparse-group LASSO estimator. For more information on the *midasml* approach see [1, 2]. 

The package is equipped with the fast implementation of the sparse-group LASSO estimator by means of proximal block coordinate descent. High-dimensional mixed frequency time-series data can also be easily manipulated with functions provided in the package.

## Software in other languages

- Julia implmentation of the midasml method is available [here](https://github.com/ababii/Pythia.jl).

## Run to install the package

```{r }
# CRAN version - 0.1.4
install.packages("midasml") 

# Development version - 0.1.4
# install.packages("devtools")
library(devtools)
install_github("jstriaukas/midasml")
```

## References

[1] Babii, A., Ghysels, E., & Striaukas, J. (2021). Machine learning time series regressions with an application to nowcasting. forthcoming at *Journal of Business & Economic Statistics*, https://doi.org/10.1080/07350015.2021.1899933. 

[2] Babii, A., Ball, R., Ghysels, E., & Striaukas, J. (2021). Machine learning panel data regressions with an
application to nowcasting price-earnings ratios. <https://arxiv.org/abs/2008.03600>.