function [ real_datenum , YMD ]  = TimeConv( time_cumulative , varargin )
    %% 输入列向量
    if isempty( varargin )
        refer_datastr = '01-jan-2000' ;
    else
        refer_datastr = varargin{ 1 } ;
    end
   %  Modified at  17:14:14  , 2021-06-02  对非 double 类型数据强制转换
   time_cumulative = V2C( double( time_cumulative ) ) ;
   refer_datenum = datenum( refer_datastr )                                                ;
   real_datenum  = time_cumulative ./ ( 3600 * 24 ) + refer_datenum                        ;
   if isempty(  time_cumulative  )
       return  ;
   end
   YMD           =  squeeze( reshape( datevec( real_datenum ) , [ size( time_cumulative ) , 6 ]  ) ) ;
   %% 防止精度损失
   if iscolumn( YMD )
       YMD = YMD' ;
   end
   YMD( : , 6 )  = floor( YMD( : , 6 ) ) + mod(  time_cumulative , 1  ) ;
   id1  =  ( datenum( YMD ) -  real_datenum  ) >   0.5 * 1  / 3600 / 24   ;      
   id2  =  ( datenum( YMD ) -  real_datenum  ) < - 0.5 * 1  / 3600 / 24   ;      
   YMD( id1 , 6 ) = YMD( id1 , 6 ) - 1                                     ;
   YMD( id2 , 6 ) = YMD( id2 , 6 ) + 1                                     ;
end
%% 

% [ a , b ]  = TimeConv( [ 1  59.9999999 ]' )
% [ a , b ]  = TimeConv( [ 1  60.0000000000001 ]' )



% [ a , b ]  = TimeConv( [ 1  59.9999999 + 366 * 3600 * 24 - 60 ]' )

%% 改正之前为
%% 2001 1  1  0 0 0
%% 改正之后为
%% 2001 1  1  0 0    -1.00582838058472e-07

% [ a , b ]  = TimeConv( [ 1  366 * 3600 * 24 + 0.0000001  ]' )


%% 改正之前为
%% 2001 1  1  0 0 0
%% 该整之后为
%% 2001 1  1  0 0   1.00582838058472e-07