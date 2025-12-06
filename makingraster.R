bmj_data1 <- mengolahbulanan("C:/Users/HP/Downloads/ftrack/output/september/output_bmj2/wrfout_d02_2024-08-31_12",'Hujan','09')

cobaan <- (bmj_data1)

rasterhujan <- st_as_sf(x = bmj_data1,
                        coords = c('long','lat'),
                        crs = 4326)


balikpapan <- st_read('C:/Users/HP/Downloads/ftrack/output_wrf/balikpapan.shp')


datacrop <- st_intersection(rasterhujan,balikpapan)

koordinat <- st_coordinates(datacrop)

dfakhir <- cbind(datacrop,koordinat)


#plot

ggplot()+
  geom_sf(data = balikpapan,fill = NA)+
  geom_tile(data = dfakhir, aes(x=X, y= Y, fill = Hujan))+
  scale_fill_gradient(
    low='skyblue',
    high = 'blue'
  )+
  theme_bw()+
  labs(title = 'Peta Spasial Hujan',fill='Curah Hujan (mm)')+
  xlab('Long')+
  ylab('Latitude')
