% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reg.panel.sgl.R
\name{reg.panel.sgl}
\alias{reg.panel.sgl}
\title{Regression fit for panel sg-LASSO}
\usage{
reg.panel.sgl(x, y, gamma = NULL, gindex, intercept = TRUE, 
              method_choice = c("ic","cv"), nfolds = 10, 
              method = c("pooled", "fe"), nf = NULL, 
              verbose = FALSE, ...)
}
\arguments{
\item{x}{NT by p data matrix, where NT and p respectively denote the sample size of pooled data and the number of regressors.}

\item{y}{NT by 1 response variable.}

\item{gamma}{sg-LASSO mixing parameter. \eqn{\gamma} = 1 gives LASSO solution and \eqn{\gamma} = 0 gives group LASSO solution.}

\item{gindex}{p by 1 vector indicating group membership of each covariate.}

\item{intercept}{whether intercept be fitted (\code{TRUE}) or set to zero (\code{FALSE}). Default is \code{TRUE}.}

\item{method_choice}{choose between \code{ic} and \code{cv}. \code{ic} gives fit based on information criteria (BIC, AIC or AICc) by running \code{ic.fit}, while \code{cv} gives fit based on cross-validation by running \code{cv.sglfit}. If \code{cv} is chosen, optional number of folds \code{nfolds} can be supplied.}

\item{nfolds}{number of folds of the cv loop. Default set to \code{10}.}

\item{method}{choose between 'pooled' and 'fe'; 'pooled' forces the intercept to be fitted in \link{sglfit}, 'fe' computes the fixed effects. User must input the number of fixed effects \code{nf} for \code{method = 'fe'}, and it is recommended to do so for \code{method = 'pooled'}. Program uses supplied \code{nf} to construct \code{foldsid} if \code{method_choice = 'cv'} is chosen. Default is set to \code{method = 'pooled'}.}

\item{nf}{number of fixed effects. Used only if \code{method = 'fe'}.}

\item{verbose}{flag to print information.}

\item{...}{Other arguments that can be passed to \code{sglfit}.}
}
\value{
reg.panel.sgl object.
}
\description{
Fits panel data sg-LASSO regression model.

The function fits sg-LASSO regression based on chosen tuning parameter selection method_choice. Options include cross-validation and information criteria.
}
\details{
\ifelse{html}{\out{The sequence of linear regression models implied by &lambda; vector is fit by block coordinate-descent. The objective function is either (case <code>method='pooled'</code>) <br><br> ||y - &iota;&alpha; - x&beta;||<sup>2</sup><sub>NT</sub> + 2&lambda;  &Omega;<sub>&gamma;</sub>(&beta;), <br> where &iota;&#8712;R<sup>NT</sup> and &alpha; is common intercept to all N items or (case <code>method='fe'</code>) <br><br> ||y - B&alpha; - x&beta;||<sup>2</sup><sub>NT</sub> + 2&lambda;  &Omega;<sub>&gamma;</sub>(&beta;), <br> where B = I<sub>N</sub>&#8855;&iota; and ||u||<sup>2</sup><sub>NT</sub>=&#60;u,u&#62;/NT is the empirical inner product. The penalty function &Omega;<sub>&gamma;</sub>(.) is applied on  &beta; coefficients and is <br><br> &Omega;<sub>&gamma;</sub>(&beta;) = &gamma; |&beta;|<sub>1</sub> + (1-&gamma;)|&beta;|<sub>2,1</sub>, <br> a convex combination of LASSO and group LASSO penalty functions.}}{The sequence of linear regression models implied by \eqn{\lambda} vector is fit by block coordinate-descent. The objective function is  either (case \code{method='pooled'})  \deqn{\|y-\iota\alpha - x\beta\|^2_T + 2\lambda \Omega_\gamma(\beta),} where \eqn{\iota\in R^{NT}} and \eqn{\alpha} is common intercept to all N items or (case \code{method='fe'}) \deqn{\|y-B\alpha - x\beta\|^2_T + 2\lambda \Omega_\gamma(\beta),} where \eqn{B=I_N \times \iota} and \eqn{\|u\|^2_{NT} = \langle u,u \rangle / {NT}} is the empirical inner product. The penalty function \eqn{\Omega_\gamma(.)} is applied on \eqn{\beta} coefficients and is \deqn{\Omega_\gamma(\beta) = \gamma |\beta|_1 + (1-\gamma)|\beta|_{2,1},} a convex combination of LASSO and group LASSO penalty functions.}
}
\examples{
set.seed(1)
x = matrix(rnorm(100 * 20), 100, 20)
beta = c(5,4,3,2,1,rep(0, times = 15))
y = x\%*\%beta + rnorm(100)
gindex = sort(rep(1:4,times=5))
reg.panel.sgl(x = x, y = y, 
  gindex = gindex, gamma = 0.5, 
  method = "fe", nf = 10, 
  standardize = FALSE, intercept = FALSE)
}
\author{
Jonas Striaukas
}
