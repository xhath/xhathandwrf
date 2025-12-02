def rained(wrf_out,bulan,localtz):
    import wrf
    import xarray
    import pandas as pd
    import numpy as np
    from netCDF4 import Dataset
    import openpyxl

    data = Dataset(wrf_out)
    rain = wrf.getvar(data,'RAINNC',timeidx=wrf.ALL_TIMES) + wrf.getvar(data,'RAINC',timeidx=wrf.ALL_TIMES)
    rain = rain.diff(dim='Time') 

    dz = rain.to_dataframe(name='rain').reset_index()
    dz = dz[(dz['south_north']==17)&(dz['west_east']==35)]
    dz['Time'] = dz['Time'] + pd.Timedelta(hours= localtz)
    dz['Bulan'] = dz['Time'].dt.month

    dz = dz[dz['Bulan']==bulan]
    dz['Time'] = dz['Time'].dt.date
    dz = dz.groupby('Time').agg({'rain':'sum'}).reset_index()
    dz['rain'] = dz['rain'].apply(lambda x: format(x,'.2f'))
    dz['rain'] = dz['rain'].astype(float)

    return dz
