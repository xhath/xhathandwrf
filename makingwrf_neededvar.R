membuatncdf <- function(wrf,outputpath){
  
  library(ncdf4)
  library(tidyverse)
  #library(stars)
  wrf <- nc_open(wrf)
  on.exit(nc_close(wrf))
  
  long <- ncvar_get(wrf,'XLONG')
  lat <- ncvar_get(wrf,'XLAT')
  
  lat <- lat[1,,1]
  long <- long[,1,1]
  date <- ncvar_get(wrf,'Times')
  
  date <- dim(date)[1]
  
  #timez <- ncvar_get(wrf,'Times')
  #timez <- timez[]
  
  rainc <- ncvar_get(wrf, 'RAINC')
  rainnc <- ncvar_get(wrf, 'RAINNC')
  rain <- rainc + rainnc
  rain[rain == 9999] <- 0
  #rain[rain>1000] <- 0
  #rain[rain>=250] <- 0
  rain[rain < 0] <- 0
  rain_diff <- rain
  for(i in 2:dim(rain)[3]) {
    rain_diff[,,i] <- rain[,,i] - rain[,,i-1]
    }
  rain_diff[rain_diff < 0] <- 0
  #rain_diff[rain_diff>=250] <- 0
  hourly_rain <- as.numeric(rain_diff)

  T2 <- ncvar_get(wrf,'T2')-273.15
  T2M <- T2
    

  U10 <- ncvar_get(wrf,'U10')^2
  V10 <- ncvar_get(wrf,'V10')^2
  ws <- sqrt(U10+V10)
  ws10m <- ws
    
  TS <- ncvar_get(wrf,'TSK')-273.15
  SFTEMP <- TS

  t2m <- ncvar_get(wrf,'T2')-273.15
  psfc <- ncvar_get(wrf,'PSFC')/100
  qv2 <- ncvar_get(wrf,'Q2')
    
  es <- 6.1094 * exp(17.625 * t2m/(t2m + 243.04))
  ws <- 0.622*es/(psfc - es)
  rh <- qv2/ws * 100
  
  #rain_date <- dim(hourly_rain)[3]
  
  longitude <- ncdim_def('longitude','degree',vals = long)
  latitude <- ncdim_def('latitude','degree',vals = lat)
  #time_date_rain <- ncdim_def('time','hourly',vals = 1:rain_date)
  time_date <- ncdim_def('time','hourly',vals=1:date)
  
  var_rain <- ncvar_def('rain','mm/hour',dim=list(longitude,latitude,time_date),missval = 9999)
  
  var_t2m    <- ncvar_def('t2m', 'degC', list(longitude,latitude,time_date),missval = 9999)
  var_sftemp <- ncvar_def('surface_temp', 'degC', list(longitude,latitude,time_date),missval = 9999)
  var_ws10m  <- ncvar_def('windspeed_10m', 'm/s', list(longitude,latitude,time_date),missval = 9999)
  var_rh     <- ncvar_def('rh', '%', list(longitude,latitude,time_date),missval = 9999)
  #var_time <- ncvar_def('time','date',list(as.numeric(timez)))
  
  nc_fixed <- nc_create(outputpath,vars=list(var_rain,var_rh,var_ws10m,var_sftemp,var_t2m))
  #nc_rain <- nc_create('C:/Users/HP/Downloads/nc_.nc',vars=list(var_rain))
  
  ncvar_put(nc_fixed,var_rain,hourly_rain)
  ncvar_put(nc_fixed,var_sftemp,SFTEMP)
  ncvar_put(nc_fixed,var_rh,rh)
  ncvar_put(nc_fixed,var_t2m,T2M)
  ncvar_put(nc_fixed,var_ws10m,ws10m)
  
  nc_close(nc_fixed)
  
}
