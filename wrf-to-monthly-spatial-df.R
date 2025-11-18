mengolahbulanan <- function(wrf,var,bulan){
  
  library(ncdf4)
  library(tidyverse)
  wrf <- nc_open(wrf)
  long <- ncvar_get(wrf,'XLONG')
  lat <- ncvar_get(wrf,'XLAT')
  
  lat <- lat[1,,1]
  long <- long[,1,1]
  date <- ncvar_get(wrf,'Times')
  date <- as.POSIXct(date,format='%Y-%m-%d_%H:%M:%S',tz = 'UTC')
  date <- as.POSIXct(date, format = '%Y-%m-%d %H:%M:%S', tz = 'Asia/Makassar')
  date <- as.Date(date,format = '%Y-%m-%d')
  idx <- format(date,'%m') == bulan
  if (var=='Rain'){
    rain <- ncvar_get(wrf,'PREC_ACC_C') + ncvar_get(wrf,'PREC_ACC_NC')
    rain <- rain[,,idx]
    rain <- apply(rain,c(1,2),sum)
    
    wrf.var <- rain
  } else if(var == 'Suhu2m'){
    T2 <- ncvar_get(wrf,'T2')-273.15
    T2 <- T2[,,idx]
    T2 <- apply(T2,c(1,2),mean)
    wrf.var <- T2
      
  } else if (var == 'wspeed'){
    U10 <- ncvar_get(wrf,'U10')^2
    V10 <- ncvar_get(wrf,'V10')^2
    ws <- sqrt(U10+V10)
    ws <- apply(ws,c(1,2),mean)
    wrf.var <- ws

  } else if (var == 'SfTemp'){
    TS <- ncvar_get(wrf,'TSK')-273.15
    TS <- TS[,,idx]
    TS <- apply(TS,c(1,2),mean)
    wrf.var <- TS
  } else if (var == 'RH'){
    t2m <- ncvar_get(wrf,'T2')-273.15
    psfc <- ncvar_get(wrf,'PSFC')/100
    qv2 <- ncvar_get(wrf,'Q2')
    
    es <- 6.1094 * exp(17.625 * t2m/(t2m + 243.04))
    ws <- 0.622*es/(psfc - es)
    rh <- qv2/ws * 100
    rh <- rh[,,idx]
    rh <- apply(rh,c(1,2),mean)
    wrf.var <- rh
  }
  array3d <- array(wrf.var,dim(wrf.var),
                   dimnames=
                     list(
                       long=long,
                       lat=lat
                     ))
  df <- as.data.frame.table(array3d,responseName = var)
  df <- df %>% 
    mutate(long = as.numeric(as.character(long))) %>% 
    mutate(lat = as.numeric(as.character(lat)))
  
}

