%% |geogrid| documentation
% The |geogrid| function uses |meshgrid| to easily create a global grid of latitudes and longitudes. 
% 
% <CDT_Contents.html Back to Climate Data Tools Contents>
%% Syntax 
% 
%  [lat,lon] = geogrid
%  [lat,lon] = geogrid(res) 
%  [lat,lon] = geogrid([latres lonres])
%  [lat,lon] = geogrid(...,centerLon) 
% 
%% Description 
% 
% |[lat,lon] = geogrid| generates a meshgrid-style global grid of latitude and longitude
% values at a resolution of 1 degree. Postings are centered in the middle of grid cells, 
% so a 1 degree resolution grid will have latitude values of 89.5, 88.5, 87.5, etc.  
% 
% |[lat,lon] = geogrid(res)| specifies grid resolution |res|, where |res| is a scalar and 
% specifies degrees. Default |res| is |1|.
%
% |[lat,lon] = geogrid([latres lonres])| if |res| is a two-element array, the first element 
% specifies latitude resolution and the second element specifies longitude resolution. 
%  
% |[lat,lon] = geogrid(...,centerLon)| centers the grid on longitude value |centerLon|. Default
% |centerLon| is the Prime Meridian (|0| degrees). 
% 
%% Example 1: Real simple
% Here's a 1-degree global grid: 

[lat,lon] = geogrid; 

plot(lon,lat,'b.')
xlabel('longitude') 
ylabel('latitude')

%% Example 2: More complicated
% And now let's overlay a grid that has 10 degree latitude resolution and 15 degree longitude resolution, 
% centered on 180°E: 

[lat2,lon2] = geogrid([10 15],180); 

hold on
plot(lon2,lat2,'ro')

%% Author Info
% The |geogrid| function and supporting documentation were written by <http://www.chadagreene Chad A. Greene> of the University
% of Texas at Austin, Institute for Geophysics (UTIG), February 2017.  