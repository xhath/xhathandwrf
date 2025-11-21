delta_cor <- function(dfobs, dfbaseline, dfmodel){
  obs <- dfobs$CH
  baseline <- dfbaseline$CH
  model <- as.numeric(dfmodel$CH)
  
  ratio <- model / baseline
  corrected <- ratio * obs
 
}

#InputWithDataFrame
