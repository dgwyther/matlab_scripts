function curlz = geocurl(lat,lon,U,V,varargin)
% geocurl gives the area of each cell in a lat,lon grid assuming a spherical Earth  
% of radius 6371000 meters. This function was designed to enable easy area-averaged
% weighting of large gridded climate datasets.  
% 
%% Syntax 
% 
%  curlz = geocurl(lat,lon,U,V)
% 
%% Description
% 
% curlz = geocurl(lat,lon) gives an approximate area of each grid cell given by lat,lon. Inputs
% lat and lon must have matching dimensions, as if they were created by meshgrid. 
%
%% Author Info
% This function was written by Chad A. Greene of the University of Texas 
% Institute for Geophysics (UTIG), Februrary 2017. 
% 
% See also: curl and geoarea. 

%% Error checks: 

narginchk(4,inf) 
assert(isvector(lat)==0,'Input error: lat and lon must be 2D grids as if created by meshgrid.') 
assert(isequal(size(lat),size(lon))==1,'Input error: the dimensions of lat and lon must match.') 
assert(isequal(size(U),size(V))==1,'Input error: the dimensions of U and V must match.') 
assert(isequal(size(lat),[size(U,1) size(U,2)])==1,'Input error: the dimensions of lat and lon do not appear to match U and V.') 
assert(ismatrix(lat)==1,'Input error: lat and lon must be 2D matrices that correspond to the size of U and V.') 
assert(islatlon(lat,lon)==1,'Input error: Some of the values in lat or lon do not match typical lat,lon ranges. Check inputs and try again.') 

%% Set defaults: 

R = 6371000; % Earth radius in meters.

%% Determine approximate x and y dimensions of each grid cell in meters: 

[dlat1,dlat2] = gradient(lat); 
[dlon1,dlon2] = gradient(lon); 

% We don't know if lat and lon were created by [lat,lon] = meshgrid(lat_array,lon_array) or [lon,lat] = meshgrid(lon_array,lat_array) 
% but we can find out: 
if isequal(dlat1,zeros(size(lat)))
   dlat = dlat2; 
   dlon = dlon1; 
   assert(isequal(dlon2,zeros(size(lon)))==1,'Error: lat and lon must be monotonic grids, as if created by meshgrid.') 
else
   dlat = dlat1; 
   dlon = dlon2; 
   assert(isequal(dlon1,dlat2,zeros(size(lon)))==1,'Error: lat and lon must be monotonic grids, as if created by meshgrid.') 
end

% Convert dlats and dlons to grid cell sizes: 
dy = dlat*R*pi/180;
dx = (dlon/180).*pi*R.*cosd(lat); 

%% Calculate curlz:

% Preallocate curlz
curlz = nan(size(U)); 

% curlz is dV/dx - dU/dy, so solve it for each slice of U,V: 
for k = 1:size(U,3)
   [~,py] = gradient(U(:,:,k)./dy);
   [qx,~] = gradient(V(:,:,k)./dx);
   curlz(:,:,k) = qx-py; 
end

end
















%% SUBFUNCTIONS 

function tf = islatlon(lat,lon)
% islatlon determines whether lat,lon is likely to represent geographical
% coordinates. 
% 
%% Citing Antarctic Mapping Tools
% If AMT is useful for you, please cite the following paper: 
% 
% Greene, C. A., Gwyther, D. E., & Blankenship, D. D. (2016). Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences. http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Syntax
% 
% tf = islatlon(lat,lon) returns true if all values in lat are numeric
% between -90 and 90 inclusive, and all values in lon are numeric between 
% -180 and 360 inclusive. 
% 
%% Example 1: A single location
% 
% islatlon(110,30)
%    = 0
% 
% because 110 is outside the bounds of latitude values. 
% 
%% Example 2: A grid
% 
% [lon,lat] = meshgrid(-180:180,90:-1:-90); 
% 
% islatlon(lat,lon)
%    = 1 
% 
% because all values in lat are between -90 and 90, and all values in lon
% are between -180 and 360.  What if it's really, really close? What if
% just one value violates these rules? 
% 
% lon(1) = -180.002; 
% 
% islatlon(lat,lon)
%    = 0
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas at
% Austin's Institute for Geophysics (UTIG). http://www.chadagreene.com. 
% March 30, 2015. 
% 
% See also wrapTo180, wrapTo360, projfwd, and projinv.  

% Make sure there are two inputs: 
narginchk(2,2)

% Set default output: 
tf = true; 

%% If *any* inputs don't look like lat,lon, assume none of them are lat,lon. 

if ~isnumeric(lat)
    tf = false; 
    return
end

if ~isnumeric(lon)
    tf = false; 
    return
end
if any(abs(lat(:))>90)
    tf = false; 
    return
end

if any(lon(:)>360)
    tf = false; 
    return
end    

if any(lon(:)<-180)
    tf = false; 
end

end