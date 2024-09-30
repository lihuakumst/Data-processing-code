%% Clear variables from memory
clear;
close all;
clc;
%% add file path
% addpath('.\waveform retracker\result_data\swot\pixel\v_01')
%% Get the boundary coordinates from.shp
% save('lake_Buchanan_shapfile.mat','shapfile')
% shapfile = load('lake_Buchanan_shapfile.mat');
shp_path = 'D:\Scientific_Research\data\Boundary_shp\North_Americ\Pennsylvania\Susquehanna_River\Export_Output_2.shp';
shapfile = shaperead(shp_path);
B_lon = shapfile.shapfile.X;
B_lat = shapfile.shapfile.Y;

%% With the measured point as the center, a research area of 1 square kilometers was established
% 1.Possum Kingdom Lake 2.kemp Lake 3.diversion Lake 4 Ontario Lake 5 Delaware_River 6 Susquehanna River
center_lat = [32.888611111111110,33.758333333333330,33.815000000000000,43.350316666666670,40.015138888888890,41.765277777777776];
center_lon = [-98.52388888888889,-99.15083333333334,-98.93333333333334,-76.70894444444444,-75.01769444444444,-76.44111111111111];
% center_lat = 33.815;
% center_lon = -98.93333333333334;
% radius = 1000:1000:9000;
radius = [1000,1500];


root_file = 'D:\Scientific_Research\tools\matlab\result_data\swot\Diffference_radius\';
file_1 = 'pixel';
file_2 = 'version_20';
file_3 = 'Ontario_Lake';
if ~exist(root_file,'dir')
    mkdir(root_file);
    disp(['file ' root_file 'had create'])
    root_file_2 = strcat(root_file,'\',file_1);
else
    root_file_2 = strcat(root_file,'\',file_1);
end
if ~isfolder(root_file_2)
    mkdir(root_file_2)
    disp(['file ' root_file_2 'had create'])
    root_file_3 = strcat(root_file_2,'\',file_2);
else
    root_file_3 = strcat(root_file_2,'\',file_2);
end
if ~exist(root_file_3,'dir')
    mkdir(root_file_3)
    disp(['file ' root_file_3 'had create'])
    root_file_3 = strcat(root_file_3,'\',file_3);
else
    root_file_3 = strcat(root_file_3,'\',file_3);
end
if ~isfolder(root_file_3)
    mkdir(root_file_3)
    disp(['file ' root_file_3 'had create'])
else
    disp('File already exists！！！！')
end

swot_storted_fileName = strcat(root_file_3,'\',file_3,'_',file_2);
disp(swot_storted_fileName)

for R = 1:length(radius)
    [lon_cycle,lat_cycle] = getEndPointByTrigonometric(center_lon(4),center_lat(4),radius(R));
    
    [in,on] = inpolygon(lon_cycle,lat_cycle,B_lon,B_lat);
    lon_cycle_in = lon_cycle(in);
    lat_cycle_in = lat_cycle(in);
    % ****************************************
    if length(lon_cycle_in) < (1080 * radius(R) / 500)
       [in_out,on_out] =  inpolygon(B_lon,B_lat,lon_cycle,lat_cycle);
       lon_B_in_in = B_lon(in_out&~on_out);
       lat_B_in_in = B_lat(in_out&~on_out);
    end
    new_lon_point = cat(1,lon_cycle_in,lon_B_in_in);
    new_lat_point = cat(1,lat_cycle_in,lat_B_in_in);
    
    %% -------------------------------read SWOT data----------------------------------
    file_path =  'D:\Scientific_Research\data\swot\Pixel\versions_20\Ontario_Lake\p48_91_326_397';% Kemp and Diversion
    % file_path =  'D:\Scientific_Research\data\swot\pixel\versions_01\Susquehnaan_river\p22_080R'; % susquehanna River riversions_01
    % file_path = 'D:\Scientific_Research\data\swot\pixel\versions_02\Delaware_river';% susquehanna River riversions_02
    % TitleName = strcat('pass_number',32,'cycle',32,'longitude',32,'latitude',32,'illumination_time',32,'water_surface_elevation',32,...
    %    'water_area',32,'geoid',32,'solid_earth_tide',32,'pole_tide',32,'load_tide_got',32,'load_tide_fes',32,'model_dry_tropo_cor',32,...
    %    'model_wet_tropo_cor',32,'iono_cor_gim_ka\n');
    TitleName = strcat('pass_number',32,'cycle',32,'time',32,'wse\n');
    
    To_swotdata_storted_fileName = strcat(swot_storted_fileName,'_',num2str(radius(R)),'.txt');
%     To_swotdata_storted_fileName =strcat( '.\Ders_vsersion_20_radius_',num2str(radius(R)),'.txt');
    fp_pass24 = fopen(To_swotdata_storted_fileName,'w');
    fprintf(fp_pass24,TitleName);
    list_fileName = ls(file_path);
    r_n = size(list_fileName);
    for i = 3:r_n
        data_path = strcat(file_path,'\',list_fileName(i,:));
        fprintf("i:%d\n",i);
        pass_number = ncreadatt(data_path,'/','pass_number');
        cycle_number = ncreadatt(data_path,'/','cycle_number');
        latitude = ncread(data_path,'/pixel_cloud/latitude');
        longitude = ncread(data_path,'/pixel_cloud/longitude');
        illumination_time = ncread(data_path,'/pixel_cloud/illumination_time');%Time of measurement in seconds in the UTC time scale since 1 Jan 2000 00:00:00 UTC. [tai_utc_difference] is the difference between TAI and UTC reference time (seconds) for the first measurement of the data set. If a leap second occurs within the data set, the attribute leap_second is set to the UTC time at which the leap second occurs.
        %     illumination_time_tai = ncread(data_path,'illumination_time_tai');%Time of measurement in seconds in the TAI time scale since 1 Jan 2000 00:00:00 TAI. This time scale contains no leap seconds. The difference (in seconds) with time in UTC is given by the attribute [illumination_time:tai_utc_difference].
        water_surface_elevation = ncread(data_path,'/pixel_cloud/height');%Height of the pixel above the reference ellipsoid.
        water_area = ncread(data_path,'/pixel_cloud/pixel_area');%Surface area of the water pixels
        % --------------------------quality flag---------------------------
        interferogram_qual = ncread(data_path,'/pixel_cloud/interferogram_qual');% Quality flag for the interferogram quantities in the pixel cloud data
        classification_qual = ncread(data_path,'/pixel_cloud/classification_qual');% Quality flag for the classification quantities in the pixel cloud data
        %     geolocation_qual = ncread(data_path,'/pixel_cloud/geolocation_qual'); % Quality flag for the geolocation quantities in the pixel cloud data
        sig0_qual  =  ncread(data_path,'/pixel_cloud/sig0_qual'); % Quality flag for sig0
        % -----------------------------------------------------
        phase_noise_std  =  ncread(data_path,'/pixel_cloud/phase_noise_std'); % Estimate of the phase noise standard deviation
        dheight_dphase = ncread(data_path,'/pixel_cloud/dheight_dphase'); % Sensitivity of the height estimate to the interferogram phase.
        % ----------------------------------------------------------------------------------
        water_frac = ncread(data_path,'/pixel_cloud/water_frac');% Noisy estimate of the fraction of the pixel that is water
        classification = ncread(data_path,'/pixel_cloud/classification');% Flags indicating water detection results//land land_near_water water_near_land open_water dark_water low_coh_water_near_land open_low_coh_water//[1  2  3  4  5  6  7]
        bright_land_flag = ncread(data_path,'/pixel_cloud/bright_land_flag');% Flag indicating areas that are not typically water but are expected to be bright (e.g., urban areas, ice).  Flag value 2 indicates cases where prior data indicate land, but where prior_water_prob indicates possible water.'
        
        % --------------------------- ----------------------------
        %     geoid = ncread(data_path,'/pixel_cloud/geoid');%Geoid height above the reference ellipsoid with a correction to refer the value to the mean tide system, i.e. includes the permanent tide (zero frequency).
        solid_earth_tide = ncread(data_path,'/pixel_cloud/solid_earth_tide');%Solid-Earth (body) tide height. The zero-frequency permanent tide component is not included
        pole_tide = ncread(data_path,'/pixel_cloud/pole_tide');
        load_tide_got  =  ncread(data_path,'/pixel_cloud/load_tide_got');
        load_tide_fes  =  ncread(data_path,'/pixel_cloud/load_tide_fes');
        %     model_dry_tropo_cor = ncread(data_path,'/pixel_cloud/model_dry_tropo_cor');%Equivalent vertical correction due to dry troposphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        %     model_wet_tropo_cor = ncread(data_path,'/pixel_cloud/model_wet_tropo_cor');%Equivalent vertical correction due to wet troposphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        %     iono_cor_gim_ka = ncread(data_path,'/pixel_cloud/iono_cor_gim_ka');%Equivalent vertical correction due to ionosphere delay. The reported water surface elevation, latitude and longitude are computed after adding negative media corrections to uncorrected range along slant-range paths, accounting for the differential delay between the two KaRIn antennas. The equivalent vertical correction is computed by applying obliquity factors to the slant-path correction. Adding the reported correction to the reported water surface elevation results in the uncorrected pixel height.'
        % ##################################select data in eara of Congo River#
        fprintf("select\n");
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
        water_area_in = water_area(in&~on);
        % -----------------------------------------------------
        interferogram_qual_in = interferogram_qual(in&~on);
        classification_qual_in = classification_qual(in&~on);
        %     geolocation_qual_in = geolocation_qual(in&~on);
        sig0_qual_in = sig0_qual(in&~on);
        % -----------------------------------------------------
        phase_noise_std_in = phase_noise_std(in&~on);
        dheight_dphase_in = dheight_dphase(in&~on);
        % ---------------------------------------------
        water_frac_in = water_frac(in&~on);
        classification_in = classification(in&~on);
        bright_land_flag_in = bright_land_flag(in&~on);
        % ---------------------------------------------------------------
        %     geoid_in = geoid(in&~on);
        solid_earth_tide_in = solid_earth_tide(in&~on);
        %     load_tide_got_in = load_tide_got(in&~on);
        load_tide_fes_in = load_tide_fes(in&~on);
        pole_tide_in = pole_tide(in&~on);
        %     model_dry_tropo_cor_in = model_dry_tropo_cor(in&~on);
        %     model_wet_tropo_cor_in = model_wet_tropo_cor(in&~on);
        %     iono_cor_gim_ka_in = iono_cor_gim_ka(in&~on);
        fprintf("writting\n");
        disp("-----------------------")
        wse_p = [];
        count = 0;
        height = [];
        for i = 1:length(lon_in)
            if interferogram_qual_in(i) == 0 && classification_qual_in(i) == 0 && sig0_qual_in(i) == 0
                if classification_in(i) == 3 || classification_in(i) == 4
                    count = count + 1;
                    wse_p(count) =  phase_noise_std_in(i) * dheight_dphase_in(i);
                    height(count) = water_surface_elevation_in(i) - solid_earth_tide_in(i) - load_tide_fes_in(i) - pole_tide_in(i);
                    
                    %                 data_str = strcat(num2str(pass_number),32,num2str(cycle_number),32,num2str(lon_in(i)),32,num2str(lat_in(i)),32,...
                    %                     num2str(illumination_time_in(i)),32,num2str(water_surface_elevation_in(i)),32,num2str(water_area_in(i)),32,...
                    %                     num2str(geoid_in(i)),32,num2str(solid_earth_tide_in(i)),32,num2str(pole_tide_in(i)),32,...
                    %                     num2str(load_tide_got_in(i)),32,num2str(load_tide_fes_in(i)),32,num2str(model_dry_tropo_cor_in(i)),32,...
                    %                     num2str(model_wet_tropo_cor_in(i)),32,num2str(iono_cor_gim_ka_in(i)));
                    %                 fprintf(fp_pass24,'%s\n',data_str);
                end
            end
        end
        wse = sum((height .* ((1 ./ wse_p) .^ 2))) / (sum((1 ./ wse_p) .^ 2));
        if length(height) ~= 0
            data_str = strcat(num2str(pass_number()),32,num2str(cycle_number),32,num2str(illumination_time_in(1)),32,num2str(wse));
            fprintf(fp_pass24,'%s\n',data_str);
        end
    end
    fclose(fp_pass24);
end
