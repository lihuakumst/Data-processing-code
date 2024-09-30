# -*- coding:utf-8 -*-

from dbfread import DBF
import os
import zipfile


# pip install -i https://pypi.tuna.tsinghua.edu.cn/simple dbfread

def search_lake(dbf_file, lake_name):
    table = DBF(dbf_file)
    count = 0
    for record in table:
        # print(f"Being from table to select {lake_name}")
        if lake_name in record['lake_name']:
            count += 1
            # print(f'finging {count} data')
            lake_name = record['lake_name']
            lake_id = record['lake_id']
            # river_id = record['reach_id']
            obs_id = record['obs_id']
            time = record['time_str'][0:10]
            height_reference = record['wse']
            geoid_hght = record['geoid_hght']
            height = height_reference + geoid_hght
            area = record['area_total']
            # solid_tide = record['solid_tide']
            # load_tidef = record['load_tidef']
            # load_tideg = record['load_tideg']
            # pole_tide = record['pole_tide']
            # dry_trop_c = record['dry_trop_c']
            # wet_trop_c = record['wet_trop_c']
            # iono_c = record['iono_c']
            print(f"find lake_name is : {lake_name} in the one number {count}")
            # with open('swot_LakeSP_LAKE_KEMP_version_01_.txt','a+') as fp:
            # fp.writelines('lake_name,lake_id,time,height_reference,geoid_hght,height,solid_tide,load_tidef,load_tideg,pole_tide,dry_trop_c,wet_trop_c,solid_tide,iono_c\n')
            # fp.writelines([lake_name,lake_id,time,height_reference,geoid_hght,height,solid_tide,load_tidef,load_tideg,pole_tide,dry_trop_c,wet_trop_c,solid_tide,iono_c])
            fp.write(lake_name + ',')
            # fp.write(obs_id + ',')
            # fp.write(lake_id + ',')
            fp.write(time + ',')
            fp.write(str(height_reference) + ',')
            fp.write(str(geoid_hght) + ',')
            fp.write(str(height) + ',')
            fp.write(str(area) + '\n')
            # fp.write(str(solid_tide) + ',')
            # fp.write(str(load_tidef) + ',')
            # fp.write(str(load_tideg) + ',')
            # fp.write(str(pole_tide) + ',')
            # fp.write(str(dry_trop_c) + ',')
            # fp.write(str(wet_trop_c) + ',')
            # fp.write(str(iono_c) + '\n')
    print(count)

def unzip_file(zip_file, extract_to,file):
    if not os.path.exists(extract_to):
        os.makedirs(extract_to)
    with zipfile.ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
        print(f'extracted the {file}')


data_version = 'versions_20'
Lake_name = 'Kemp_Lake'

zip_file_path = f'D:\\Scientific_Research\\data\\swot\\LakeSP\\{data_version}\\{Lake_name}\\zip_file'
extract_path = zip_file_path[0:51+len(Lake_name)+1]
# extract_path =zip_file_path[0:70]
extract_to = os.path.join(extract_path, 'extractfile')  
print(extract_to)
file = os.listdir(zip_file_path)
for file in file:
	zip_path = os.path.join(zip_file_path,file)
	unzip_file(zip_path,extract_to,file)


file_name_s_data = f'.\\data_result\\swot_LakeSP_{Lake_name}_{data_version}.txt'
# file_name_s_data = f'swot_LakeSP_{}_versions_01.txt'.format(Lake_name)
fp = open(file_name_s_data, 'w')
fp.writelines('Lake_name,time,height_reference,geoid_hght,height,area\n')

Lake = "KEMP"

for file_name in os.listdir(extract_to):
    file_path = os.path.join(extract_to, file_name)
    if file_name.endswith('.dbf') and os.path.isfile(file_path):
        # search_lake(file_path, Lake_name),# 7250132352;7250145713
        search_lake(file_path, Lake)

fp.close()

# if __name__ == "__main_":
#     data_zip_path = ''
