%% |island| documentation
% |island| is a logical function for determing whether a geolocation corresponds
% to land or water. 
% 
% <CDT_Contents.html Back to Climate Data Tools Contents>
%% Syntax
% 
%  tf = island(lat,lon)
% 
%% Description 
% 
% |tf = island(lat,lon)| uses a 1/8 degree resolution global land mask to determine
% whether the geographic location(s) given by |lat,lon| correspond to land or water.
% Output is |true| for land locations, |false| otherwise. 
% 
%% Example
% This example uses <geogrid_documentation.html |geogrid|> to create a 1x2 degree
% resolution grid, and we'll get some z values from Matlab's built-in example 
% |peaks| function: 

% Create a sample grid, 1 degree (lat) by 2 degree (lon) resolution: 
[lat,lon] = geogrid([1 2]); 

% Some sample z data: 
z = peaks(180);

% Plot the full grid: 
imagescn(lon,lat,z)

%% 
% Mask-out land values by setting them to |NaN|: 

% Determine which grid points correspond to land: 
land = island(lat,lon); 

% Set land values to NaN: 
z(land) = NaN; 

% Plot the masked dataset: 
imagescn(lon,lat,z) 

%% Author Info