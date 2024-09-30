%% Clear variables from memory
clear;
close all;
clc;
% starting time
tic
%% Get the boundary coordinates from.shp
shp_path = 'E:\KUST\scientific_research\data\Boundary_shp\Texas\Lake_Buchanan\LakeBuchanan.shp';
% shapfile = shaperead(shp_path);
% save('lake_Buchanan_shapfile.mat','shapfile')
% shapfile = load('lake_Buchanan_shapfile.mat');
B_lon = shapfile.shapfile.X;
B_lat = shapfile.shapfile.Y;

%% With the measured point as the center, a research area of 1 square kilometers was established
% 1.Possum Kingdom Lake 2.kemp Lake 3.diversion Lake 4 Ontario Lake 5 Delaware_River 6 Susquehanna River
center_lat = [32.888611111111110,33.758333333333330,33.815000000000000,43.350316666666670,40.015138888888890,41.765277777777776];
center_lon = [-98.52388888888889,-99.15083333333334,-98.93333333333334,-76.70894444444444,-75.01769444444444,-76.44111111111111];
radius = [1000,1500]; 
%  -------------------------------------------------------------read SWOT data------------------------------------------
for R = 1:length(radius)
    fprintf('radius:%d\n',radius(R));
    % Boundary coordas
    [lon_cycle,lat_cycle] = getEndPointByTrigonometric(center_lon(4),center_lat(4),radius(R));
    [in,on] = inpolygon(lon_cycle,lat_cycle,B_lon,B_lat);
    lon_cycle_in = lon_cycle(in);
    lat_cycle_in = lat_cycle(in);
 
    if length(lon_cycle_in) < length(lon_cycle)
        disp("！！！！");
        [in_out,on_out] =  inpolygon(B_lon,B_lat,lon_cycle,lat_cycle);
        lon_B_in_in = B_lon(in_out&~on_out);
        lat_B_in_in = B_lat(in_out&~on_out);

    new_lon_point = cat(1,lon_cycle_in,lon_B_in_in);
    new_lat_point = cat(1,lat_cycle_in,lat_B_in_in);

    root_path = 'D:\Scientific_Research\tools\matlab\result_data\swot\Diffference_radius';
    data_type = 'rater_100m';
    data_version = 'version_20';
    lake_name = 'Ontario_lake';
    file_name = strcat(lake_name,'_',data_version,'_radius_',num2str(radius(R)),'m.txt');
    disp(['---' file_name]);
    
    if ~isfolder(root_path)
        mkdir(root_path);
        disp(['creating' root_path 'ok!']);
        root_path_2 = strcat(root_path,'\',data_type);
    else
        disp([root_path 'had exist']);
        root_path_2 = strcat(root_path,'\',data_type);
    end
    
    if ~exist(root_path_2,'dir')
       mkdir(root_path_2);
       dsip(['creating' root_path_2 'ok!']);
       root_path_3 = strcat(root_path_2,'\',data_version);
    else
        disp([root_path_2 'had exist']);
        root_path_3 = strcat(root_path_2,'\',data_version);
    end
    
    if ~exist(root_path_3,'dir')
        mkdir(root_path_3);
        disp(['creating' root_path_3 'ok!']);
        root_path_4 = strcat(root_path_3,'\',lake_name);
    else
        disp([root_path_3 'had exist']);
        root_path_4 = strcat(root_path_3,'\',lake_name);
    end
    
    if ~isfolder(root_path_4)
        mkdir(root_path_4)
        disp(['creating' root_path_4 'ok!']);
        swot_storted_fileName = strcat(root_path_4,'\',file_name);
    else
        disp([root_path_4 'had exist']);
        swot_storted_fileName = strcat(root_path_4,'\',file_name);
    end
    disp(['%%' swot_storted_fileName])
    TitleName = strcat('pass_number',32,'cycle',32,'longitude',32,'latitude',32,'illumination_time',32,'water_surface_elevation',32,'water_area',32,'geoid',32,...
        'solid_earth_tide',32,'pole_tide',32,'load_tide_got',32,'load_tide_fes',32,'model_dry_tropo_cor',32,'model_wet_tropo_cor',32,'iono_cor_gim_ka\n');

%     swot_storted_fileName = strcat('D:\Scientific_Research\tools\matlab\result_data\swot\Diffference_radius\rater_100m\versions_11\Diversion_Lake\','Diversion_Lake','_verison_20_radius_',num2str(radius(R)),'m.txt');
    fp_raster = fopen(swot_storted_fileName,'w');
    disp(fp_raster);
    fprintf(fp_raster,TitleName);

    file_path =  'D:\Scientific_Research\data\swot\Raster\versions_20\Ontario_Lake\resolution_100m'; % Ontario Lake
    % file_path = 'D:\DATA\swot\Water_Mask_Raster_Image_Data\Mullett\versions_02\resolution_100m'; %resolution_100
%     file_path = 'D:\Scientific_Research\data\swot\Raster\versions_20\Possum_Kingdom_Lake\resolution_100m'; %resolution_100,PossumKingdom
%     file_path = 'D:\Scientific_Research\data\swot\Raster\versions_20\Kemp_Lake\solution_100m'; %resolution_100 Kemp
    % file_path = 'D:\DATA\swot\Water_Mask_Raster_Image_Data\Choke_Canyon_Res\versions_02\resolution_100m'; %r esolution_100 Choke_Canyou
%     file_path = 'D:\Scientific_Research\data\swot\Raster\versions_20\Possum_Kingdom_Lake\resolution_100m';% North Susquehanna river
    list_fileName = ls(file_path);
    r_n = size(list_fileName);
    for i = 3:r_n
        data_path = strcat(file_path,'\',list_fileName(i,:));
        fprintf("i:%d\n",i);
        pass_number = ncreadatt(data_path,'/','pass_number');
        cycle_number = ncreadatt(data_path,'/','cycle_number');
        %     lat = ncread(data_path,'/pixel_cloud/latitude');
        %     lon = ncread(data_path,'/pixel_cloud/longitude');
        latitude = ncread(data_path,'latitude');
        longitude = ncread(data_path,'longitude');
        illumination_time = ncread(data_path,'illumination_time');%Time of measurement in seconds in the UTC time scale since 1 Jan 2000 00:00:00 UTC. [tai_utc_difference] is the difference between TAI and UTC reference time (seconds) for the first measurement of the data set. If a leap second occurs within the data set, the attribute leap_second is set to the UTC time at which the leap second occurs.
        %     illumination_time_tai = ncread(data_path,'illumination_time_tai');%Time of measurement in seconds in the TAI time scale since 1 Jan 2000 00:00:00 TAI. This time scale contains no leap seconds. The difference (in seconds) with time in UTC is given by the attribute [illumination_time:tai_utc_difference].
        water_surface_elevation = ncread(data_path,'wse');%Water surface elevation of the pixel above the geoid and after using models to subtract the effects of tides (solid_earth_tide, load_tide_fes, pole_tide)
        %     water_surface_elevation_qual = ncread(data_path,'wse_qual');
        %     wse_qual_bitwise = ncread(data_path,'wse_qual_bitwise');
        water_area = ncread(data_path,'water_area');%Surface area of the water pixels
        %     water_area_qual = ncread(data_path,'water_area_qual');%Summary quality indicator for the water surface area and water fraction quantities. A value of 0 indicates a nominal measurement, 1 indicates a suspect measurement, 2 indicates a degraded measurement, and 3 indicates a bad measurement.'
        %     water_area_qual_bitwise = ncread(data_path,'water_area_qual_bitwise');%Bitwise quality indicator for the water surface area and water fraction quantities. If this word is interpreted as an unsigned integer, a value of 0 indicates good data, positive values less than 32768 represent suspect data, values greater than or equal to 32768 but less than 8388608 represent degraded data, and values greater than or equal to 8388608 represent bad data.
        %     water_fraction = ncread(data_path,'water_frac');%Fraction of the pixel that is water
        %     cross_track = ncread(data_path,'cross_track');%Approximate cross-track location of the pixel
        geoid = ncread(data_path,'geoid');%Geoid height above the reference ellipsoid with a correction to refer the value to the mean tide system, i.e. includes the permanent tide (zero frequency).
        solid_earth_tide = ncread(data_path,'solid_earth_tide');%Solid-Earth (body) tide height. The zero-frequency permanent tide component is not included
        pole_tide = ncread(data_path,'pole_tide');
        load_tide_got = ncread(data_path,'load_tide_got');
        load_tide_fes = ncread(data_path,'load_tide_fes');
        model_dry_tropo_cor = ncread(data_path,'model_dry_tropo_cor');%Equivalent vertical correction due to dry troposphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        model_wet_tropo_cor = ncread(data_path,'model_wet_tropo_cor');%Equivalent vertical correction due to wet troposphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        iono_cor_gim_ka = ncread(data_path,'iono_cor_gim_ka');%Equivalent vertical correction due to ionosphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        %% select data in eara of Congo River
        
        % quality flag 0，1,2,3 ——> good,suspect,degreded and bad measurements
        wse_qual = ncread(data_path,'wse_qual');
        
        disp("select")
        [in,on]=inpolygon(longitude,latitude,new_lon_point,new_lat_point);
        lon_in = longitude(in&~on);
        lat_in = latitude(in&~on);
        illumination_time_in = illumination_time(in&~on);
        for j=1:length(illumination_time_in)
            [real_datenum,YMD]  = TimeConv(illumination_time_in(j));
            for t=1:length(YMD)
                year=num2str(YMD(1));
                if YMD(2)<10
                    month=strcat('0',num2str(YMD(2)));
                else
                    month=num2str(YMD(2));
                end
                if YMD(3)<10
                    days=strcat('0',num2str(YMD(3)));
                else
                    days=num2str(YMD(3));
                end
            end
            illumination_time_in(j)=str2num(strcat(year,month,days));
        end
        water_surface_elevation_in = water_surface_elevation(in&~on);
        %     water_surface_elevation_qual_in = water_surface_elevation_qual(in&~on);
        %     wse_qual_bitwise_in = wse_qual_bitwise(in&~on);
        water_area_in = water_area(in&~on);
        %     water_area_qual_in = water_area_qual(in&~on);
        %     water_area_qual_bitwise_in = water_area_qual_bitwise(in&~on);
        %     water_fraction_in = water_fraction(in&~on);
        %     cross_track_in = cross_track(in&~on);
        geoid_in = geoid(in&~on);
        solid_earth_tide_in = solid_earth_tide(in&~on);
        pole_tide_in = pole_tide(in&~on);
        load_tide_got_in = load_tide_got(in&~on);
        load_tide_fes_in = load_tide_fes(in&~on);
        model_dry_tropo_cor_in = model_dry_tropo_cor(in&~on);
        model_wet_tropo_cor_in = model_wet_tropo_cor(in&~on);
        iono_cor_gim_ka_in = iono_cor_gim_ka(in&~on);
        wse_qual_in = wse_qual(in&~on);
      

        disp("writting")
        for i = 1:length(lon_in)
            if wse_qual_in(i) == 0
                data_str = strcat(num2str(pass_number),32,num2str(cycle_number),32,num2str(lon_in(i)),32,num2str(lat_in(i)),32,...
                    num2str(illumination_time_in(i)),32,num2str(water_surface_elevation_in(i)),32,num2str(water_area_in(i)),32,...
                    num2str(geoid_in(i)),32,num2str(solid_earth_tide_in(i)),32,num2str(pole_tide_in(i)),32,num2str(load_tide_got_in(i)),32,...
                    num2str(load_tide_fes_in(i)),32,num2str(model_dry_tropo_cor_in(i)),32,num2str(model_wet_tropo_cor_in(i)),32,num2str(iono_cor_gim_ka_in(i)));
                fprintf(fp_raster,'%s\n',data_str);
            end
        end
        disp('----------------------')
        end
    fclose(fp_raster);
end
elapsed_time = toc;
disp(['Elapsed time: ', num2str(elapsed_time), ' seconds']);