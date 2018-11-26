%% |geoarea| documentation 
% The |geoarea| gives the approximate area of each cell in a lat,lon grid assuming a spherical Earth  
% of radius 6371000 meters. This function was designed to enable easy area-averaged
% weighting of large gridded climate datasets.  This function is similar to <geodim_documentation.html |geodim|>. 
% 
% <CDT_Contents.html Back to Climate Data Tools Contents>
%% Syntax 
% 
%  A = geoarea(lat,lon)
%  A = geoarea(lat,lon,'km2')
% 
%% Description
% 
% |A = geoarea(lat,lon)| gives an approximate area of each grid cell given by |lat,lon|. Inputs
% |lat| and |lon| must have matching dimensions, as if they were created by |meshgrid|. 
%
% |A = geoarea(lat,lon,'km2')| gives grid cell area in square kilometers. 
%
%% Example 
% Given a 10 degree global grid made by <geogrid_documentation.html |geogrid|>. 

[lat,lon] = geogrid(10); 

%% 
% Each grid cell has these dimensions: 

A = geodim(lat,lon,'km^2'); 

%% 
% Plot the grid cell area:

p = pcolor(lon,lat,A); 
axis image
ylabel('latitude') 
xlabel('longitude') 
cb = colorbar; 
ylabel(cb,'grid cell area (km^2)')

%% 
% Just as we expect, grid cells are bigger close to the equator, and smaller near the poles. 
% If you look closely at the map above, you may notice that the values at the top of the world do not appear to 
% match the values at the bottom of the world.  That's due to an unfortunate behavior of |pcolor|, which discards
% a row and a column of data.  That behavior can be fixed by using interpolated shading or by using |imagesc| instead
% of |pcolor|, but I used |pcolor| above because it's an easy way to include grid lines. 

%% Author Info
% The |geoarea| function was written by Chad A. Greene of the University of Texas 
% Institute for Geophysics (UTIG), Februrary 2017. 