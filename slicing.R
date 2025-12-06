data <- nc_open("C:/Users/HP/Downloads/output_bmj1/wrfout_d01_2024-11-30_12")


date <- ncvar_get(data,'Times')
date <- as.POSIXct(date,format='%Y-%m-%d_%H:%M:%S',tz = 'UTC')
date <- as.POSIXct(date, format = '%Y-%m-%d %H:%M:%S', tz = 'Asia/Makassar')
date <- as.Date(date,format = '%Y-%m-%d')
idx <- format(date,'%m') == '12'
