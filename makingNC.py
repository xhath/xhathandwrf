def createnc(wrf,outpath):
    import netCDF4
    import xarray as xr
    import numpy as np

    dz = xr.open_dataset(wrf)
    long = dz['XLONG'][0,0,:].values
    lat = dz['XLAT'][0,:,0].values
    time = dz['XTIME'][:].values

    rain = dz['RAINNC'] + dz['RAINC']
    rain = rain.diff(dim='Time')

    dj = xr.DataArray(data=rain.values,
                    dims=('time','lat','long'),
                    coords={'time':time[1:],
                                        'lat':lat,
                                        'long':long})
    dj = xr.Dataset(
        {
            'rain': dj,
            'lat':  xr.DataArray(lat,  dims=('lat',)),
            'long': xr.DataArray(long, dims=('long',)),
        },
        coords={
            'time': time[1:],
            'lat': lat,
            'long': long
        }
    )
    dj.to_netcdf(outpath)
