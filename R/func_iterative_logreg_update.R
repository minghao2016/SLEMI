#' Iterative updating of prior probabilities in logistic regression estimator
#' 
#' Internal, auxiliary functions
#'
#' @param prob_lr is a matrix of class probabilities for each observation
#' @param p0 is a numeric vector of prior probabilities used for logistic regression estimation
#' @param cell_id a list of logical vectors indicating class labels of each observation
#' @param signal_levels is a vector of class labels
#' @param cc_maxit is the number of iteration of procedure to be carried out
#' @return A list with components
#' \enumerate{
#'   \item p_opt - a numeric vectors with estimated optimal input probabilities
#'   \item MI_opt -  a numerical value of estimated channel capacity
#' }
#' @keywords internal
func_iterative_logreg_update<-function(prob_lr,p0,cell_id,signal_levels,cc_maxit){
  
  if (!is.numeric(p0)){
    stop("prior probabilities are not numeric")
  }

  if (any(p0<0)|all(p0==0)) {
    stop("prior probabilities are either negative or not positive")
  } 

  if (is.matrix(prob_lr)) {
    stop("prob_lr is not submitted as data.frame")
  } 

  if (! length(colnames(prob_lr)) == length(signal_levels) ) {
    stop("prob_lr colnames are not consistent with signal levels")
  } 

  if (! length(p0) == length(signal_levels) ) {
    stop("p0 length is not consistent with signal levels")
  } 

  if (! all(sort(colnames(prob_lr)) == sort(signal_levels) )) {
    stop("prob_lr colnames are not consistent with signal levels")
  } 

  if (! all(apply(prob_lr,1,function(x){ (round(sum(x),digits=8)==1)&(all(x>=0)) })) ) {
    stop("model probabilities are not summing to 1")
  } 

  if ((!is.numeric(cc_maxit))|cc_maxit<3){
    stop("please supply a correct cc_maxit parameter")
  }

  if (!sum(p0)==1){
    warning("prior probabilities are not summing to 1")
    p0=p0/sum(p0)
  }

  for (i in 1:cc_maxit){
    C_mc<-sapply(signal_levels,function(x) {
      mc_values=log(prob_lr[[x]][cell_id[[x]] ])
      mean(mc_values[is.finite(mc_values)])
    },simplify=TRUE)
    
    p_opt=exp(C_mc)/sum(exp(C_mc))
    
    #for debugging:
    #MI_opt=sum(C_mc*p_opt-x_log_y(p_opt,p_opt))
    #print(c(p_opt,exp(MI_opt)))  #for debugging
    #print(c(exp(MI_opt)))        #for debugging
    
    prob_ratio=(p0[1]/p0)*(p_opt/p_opt[1])
    temp_val <- prob_lr*t(replicate(nrow(prob_lr),prob_ratio))
    prob_lr <- data.frame(t(apply(temp_val,1,function(x){ x/sum(x) })))
    colnames(prob_lr) <- signal_levels
    p0=p_opt
  }
  MI_opt=sum(C_mc*p_opt-aux_x_log_y(p_opt,p_opt))
  
  if (MI_opt<0) {MI_opt=0}

  out=list(p_opt=p_opt,MI_opt=MI_opt)
  out
}