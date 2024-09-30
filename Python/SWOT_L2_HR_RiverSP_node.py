# -*- coding:utf-8 -*-

# impiort numpy as np
from dbfread import DBF
import os
import zipfile
import pointInpolygon
# import GetEndPointCorrdis
# # GetEndPointCorrdis.getEndPointByTrigonometric()
def search_lake(dbf_file, river_name, lon_center,lat_center,radius,lon_lis,lat_lis):
    print(river_name)
    table = DBF(dbf_file)
    count = 0
    for record in table:
        count += 1
        # print(f"Being from table to select {river_name}")
        if river_name in record['river_name']:
            lat_node = record['p_lat'] # reach:p_lat  ----node lat
            lon_node = record['p_lon']
            def read_write():
                print("finde reach")
                river_name_find = record['river_name']
                river_id = record['reach_id']
                time = record['time_str'][0:10]
                height_reference = record['wse']
                geoid_hght = record['geoid_hght']
                height = height_reference + geoid_hght
                area = record['area_total']
                solid_tide = record['solid_tide']
                load_tidef = record['load_tidef']
                load_tideg = record['load_tideg']
                pole_tide = record['pole_tide']
                dry_trop_c = record['dry_trop_c']
                wet_trop_c = record['wet_trop_c']
                iono_c = record['iono_c']
                # print(height_reference)
                # print(f"find lake_id is : {river_id}")
                # with open('swot_LakeSP_LAKE_KEMP_version_01_.txt','a+') as fp:
                # fp.writelines('lake_name,lake_id,time,height_reference,geoid_hght,height,solid_tide,load_tidef,load_tideg,pole_tide,dry_trop_c,wet_trop_c,solid_tide,iono_c\n')
                # fp.writelines([lake_name,lake_id,time,height_reference,geoid_hght,height,solid_tide,load_tidef,load_tideg,pole_tide,dry_trop_c,wet_trop_c,solid_tide,iono_c])
                if height > 0:
                    fp.write(river_name_find + ',')
                    fp.write(river_id + ',')
                    fp.write(str(lat_node) + ',')
                    fp.write(str(lon_node) + ",")
                    lon_lis.append(lon_center-lon_node)
                    lat_lis.append(lat_center-lat_node)
                    fp.write(time + ',')
                    fp.write(str(height_reference) + ',')
                    fp.write(str(geoid_hght) + ',')
                    fp.write(str(height) + ',')
                    fp.write(str(area) + ',')
                    fp.write(str(solid_tide) + ',')
                    fp.write(str(load_tidef) + ',')
                    fp.write(str(load_tideg) + ',')
                    fp.write(str(pole_tide) + ',')
                    fp.write(str(dry_trop_c) + ',')
                    fp.write(str(wet_trop_c) + ',')
                    fp.write(str(iono_c) + '\n')
            if lat_node > 0:
                Point_In_cycle = pointInpolygon.PointInPolygon(lon_center,lat_center,lon_node,lat_node,radius)
                print(Point_In_cycle)
                if Point_In_cycle:
                    read_write()
                else:
                    print('This point is not in the area')
            # if diff_lat > 0 and diff_lon > 0:
            #     if diff_lat < lat_limit and diff_lon < lon_limit:
            #         read_write()
            # elif diff_lat > 0 and diff_lon < 0:
            #     if diff_lat < lat_limit and diff_lon > -lon_limit:
            #         read_write()
            # elif diff_lat < 0 and diff_lon > 0:
            #     if diff_lat > -lat_limit and diff_lon < lon_limit:
            #         read_write()
            # else:
            #     if diff_lat > -lat_limit and diff_lon > -lon_limit:
            #         read_write()
    print(count)
def unzip_file(zip_file, extract_to,zip_file_name):
    if not os.path.exists(extract_to):
        os.makedirs(extract_to)
    with zipfile.ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
    print(f'---extracted the {zip_file_name}------------')

# River Name
River_name = 'Susquehanna River'
# data_version
data_version = 'version_20'
# node or reach
node_reach = 'reach'
# 1-Delaware river  2-Susquehanna River_per
lon = [-75.01769444444444,-76.44111111111111]
lat = [40.01513888888889,41.765277777777776]
lon_center = lon[1]
lat_center = lat[1]

zip_file_path = r'D:\Scientific_Research\data\swot\RiverSP\version_20\Susquehanna_River\P91\reach\zip_file'
extract_path = zip_file_path[0:len(zip_file_path)-len('zip_file')]

extract_to = os.path.join(extract_path, 'extractfile')  
if not os.path.exists(extract_to):
    os.makedirs(extract_to)
    print(f'-----created the {extract_to}------------')
print(extract_to)

files = os.listdir(zip_file_path)
for file in files:
    zip_path = os.path.join(zip_file_path,file)
    unzip_file(zip_path,extract_to,file)


r = 4
radius = []
for i in range(4,6):
    r += 1
    radius.append(r)
print('radius：',radius)


To_data_path = f'.\\Result_data\\Difference_radius\\{data_version}\\{River_name}\\{node_reach}'
if not os.path.exists(To_data_path):
    os.makedirs(To_data_path)
    print(f'docment **{To_data_path} ** had create')
else:
    print(f'docment **{To_data_path}**had exist')
lon_lis = []
lat_lis = []
for R in radius:
    file_name_s_data = f'{To_data_path}\\swot_Node_{River_name}_{data_version}_radius_{str(R)}.txt'
    # file_name_s_data = f'swot_LakeSP_{}_versions_01.txt'.format(Lake_name)
    fp = open(file_name_s_data, 'w')
    fp.writelines('river_name,river_id,lon,lat,time,height_reference,geoid_hght,height,area,solid_tide,load_tidef,load_tideg,pole_tide,dry_trop_c,wet_trop_c,solid_tide,iono_c\n')
    for file_name in os.listdir(extract_to):
        file_path = os.path.join(extract_to, file_name)
        if file_name.endswith('.dbf') and os.path.isfile(file_path):
            # search_lake(file_path, Lake_name),# 7250132352;7250145713
            search_lake(file_path, River_name, lon_center, lat_center,R,lon_lis,lat_lis)
    fp.close()
print("lon",lon_lis)
