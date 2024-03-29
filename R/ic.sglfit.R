#' Information criteria fit for sg-LASSO
#' 
#' @description 
#' Does information criteria for sg-LASSO regression model.
#' 
#' The function runs \link{sglfit} 1 time; computes the path solution in \ifelse{html}{\out{<code>lambda</code>}}{\code{lambda}} sequence.
#' Solutions for \code{BIC}, \code{AIC} and \code{AICc} information criteria are returned. 
#' @details
#' \ifelse{html}{\out{The sequence of linear regression models implied by &lambda; vector is fit by block coordinate-descent. The objective function is  <br><br> ||y - &iota;&alpha; - x&beta;||<sup>2</sup><sub>T</sub> + 2&lambda;  &Omega;<sub>&gamma;</sub>(&beta;), <br> where &iota;&#8712;R<sup>T</sup>enter> and ||u||<sup>2</sup><sub>T</sub>=&#60;u,u&#62;/T is the empirical inner product. The penalty function &Omega;<sub>&gamma;</sub>(.) is applied on  &beta; coefficients and is <br><br> &Omega;<sub>&gamma;</sub>(&beta;) = &gamma; |&beta;|<sub>1</sub> + (1-&gamma;)|&beta;|<sub>2,1</sub>, <br> a convex combination of LASSO and group LASSO penalty functions.}}{The sequence of linear regression models implied by \eqn{\lambda} vector is fit by block coordinate-descent. The objective function is \deqn{\|y-\iota\alpha - x\beta\|^2_{T} + 2\lambda \Omega_\gamma(\beta),} where \eqn{\iota\in R^T} and \eqn{\|u\|^2_T = \langle u,u \rangle / T} is the empirical inner product. The penalty function \eqn{\Omega_\gamma(.)} is applied on \eqn{\beta} coefficients and is \deqn{\Omega_\gamma(\beta) = \gamma |\beta|_1 + (1-\gamma)|\beta|_{2,1},} a convex combination of LASSO and group LASSO penalty functions.}     
#' @usage 
#' ic.sglfit(x, y, lambda = NULL, gamma = 1.0, gindex = 1:p,  ...)
#' @param x T by p data matrix, where T and p respectively denote the sample size and the number of regressors.
#' @param y T by 1 response variable.
#' @param lambda a user-supplied lambda sequence. By leaving this option unspecified (recommended), users can have the program compute its own \eqn{\lambda} sequence based on \code{nlambda} and \code{lambda.factor.} It is better to supply, if necessary, a decreasing sequence of lambda values than a single (small) value, as warm-starts are used in the optimization algorithm. The program will ensure that the user-supplied \eqn{\lambda} sequence is sorted in decreasing order before fitting the model.
#' @param gamma sg-LASSO mixing parameter. \eqn{\gamma} = 1 gives LASSO solution and \eqn{\gamma} = 0 gives group LASSO solution.
#' @param gindex p by 1 vector indicating group membership of each covariate.
#' @param ... Other arguments that can be passed to \link{sglfit}.
#' @return ic.sglfit object.
#' @author Jonas Striaukas
#' @examples
#' set.seed(1)
#' x = matrix(rnorm(100 * 20), 100, 20)
#' beta = c(5,4,3,2,1,rep(0, times = 15))
#' y = x%*%beta + rnorm(100)
#' gindex = sort(rep(1:4,times=5))
#' ic.sglfit(x = x, y = y, gindex = gindex, gamma = 0.5, 
#'   standardize = FALSE, intercept = FALSE)
#' @export ic.sglfit
ic.sglfit <- function(x, y, lambda = NULL, gamma = 1.0, gindex = 1:p, ...){
  sglfit.object <- sglfit(x, y, gamma = gamma, gindex = gindex, ...)
  lambda <- sglfit.object$lambda
  tp <- dim(x)
  t <- tp[1]
  p <- tp[2]
  nlam <- length(lambda)
  cvm <- matrix(NA, nrow = nlam, ncol = 3)
  yhats <- predict.sglpath(sglfit.object, newx = x)
  df <- sglfit.object$df+sglfit.object$nf
  sigsqhat <- sum((y-mean(y))^2)/t
  mse <- colSums((replicate(nlam, as.numeric(y))-yhats)^2)/t
  cvm[,1] <- mse/sigsqhat + ic.pen("bic", df, t) 
  cvm[,2] <- mse/sigsqhat + ic.pen("aic", df, t) 
  cvm[,3] <- mse/sigsqhat + ic.pen("aicc", df, t) 
  idx <- numeric(3)
  for(i in seq(3)){
  lamin <- lambda[which(cvm[,i]==min(cvm[,i]))]
  if (length(lamin)>1)
    lamin <- min(lamin)
  
  min.crit <- min(cvm[,i])
  idx[i] <- which(lamin==lambda)
  }
  ic.fit <- list(bic.fit = list(b0 = sglfit.object$b0[idx[1]], beta = sglfit.object$beta[,idx[1]]),
                    aic.fit = list(b0 = sglfit.object$b0[idx[2]], beta = sglfit.object$beta[,idx[2]]),
                    aicc.fit = list(b0 = sglfit.object$b0[idx[3]], beta = sglfit.object$beta[,idx[3]]))
  
  obj <- list(lambda = lambda, gamma = gamma, cvm = cvm, lamin = lamin,
              fit = sglfit.object, ic.fit = ic.fit)
  class(obj) <- "ic.sglfit"
  obj
}

#' Compute the penalty based on chosen information criteria
#' 
#' @param ic_choice information criteria choice: BIC, AIC or AICc.
#' @param df effective degrees of freedom.
#' @param t sample size.
#' @return penalty value.
#' @export ic.pen
#' @keywords internal
ic.pen <- function(ic_choice, df, t){
  if (ic_choice=="bic")
    pen <- log(t)/t*df
  if (ic_choice=="aic")
    pen <- 2/t*df
  if (ic_choice=="aicc")
    pen <- 2*df/(t - df - 1)
  return(pen)
}