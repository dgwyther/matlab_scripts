function [FX,FY] = geogradient(lat,lon,F,varargin)
% geogradient calculates the spatial gradient of gridded data equally
% spaced in geographic coordinates. 
% 
%% Syntax 
% 
%  [FX,FY] = geogradient(lat,lon,F)
%  [FX,FY] = geogradient(lat,lon,F,'km')
% 
%% Description
% 
% [FX,FY] = geogradient(lat,lon,F)
% 
% [FX,FY] = geogradient(lat,lon,F,'km')
% 
%% Examples 
% For examples, type 
% 
%   cdt geogradient
%
%% Author Info
% This function was written by Chad A. Greene of the University of Texas 
% Institute for Geophysics (UTIG), June 2017. 
% http://www.chadagreene.com
% 
% See also: geoarea and geocurl. 

%% Initial error checks: 

assert(nargout==2,'Error: geogradient requires two outputs, FX and FY. Type ''cdt geogradient'' for help.') 
assert(nargin>2,'Error: geogradient requires at least three inputs: lat, lon, and F.') 
assert(islatlon(lat,lon)==1,'Input error: geogradient requires the first two inputs to be lat and lon.') 
assert(isequal(size(lat),size(lon),[size(F,1) size(F,2)])==1,'Input error: dimensions of lat, lon, and F must match.')

%% Input parsing: 

% Set defaults: 
km = false; 

if nargin>3
    tmp = strcmpi(varargin,'km'); 
    if any(tmp)
        km = true; 
    else
        error('Unrecognized input.') 
    end
end
 
%% Change grid orientation if necessary: 
% Some grids are created like [lon,lat] = meshgrid(-180:180,-90:90) while others are created like 
% [lat,lon] = meshgrid(-90:90,-180:180). For consistency, let's permute the [lat,lon] types into [lon,lat] types: 

% An overview of gridtypes appears in the recenter function
gridtype = [sign(diff(lon(2,1:2))) sign(diff(lat(1:2,1))) sign(diff(lat(2,1:2))) sign(diff(lon(1:2,1)))]; 

if isequal(abs(gridtype),[1 1 0 0])
   % This means it's the [lon,lat] type, and we're good to keep going.
   permutedims = false; 
   
elseif isequal(abs(gridtype),[0 0 1 1])
   lat = permute(lat,[2 1 3]); 
   lon = permute(lon,[2 1 3]); 
   F = permute(F,[2 1 3]); 
   permutedims = true; 
else
   error('Unrecognized lat,lon grid type. It should be monotonic, like it was created by meshgrid.') 
end
%% Estimate grid size: 

if km
    [dx,dy] = geodim(lat,lon,'km');
else
    [dx,dy] = geodim(lat,lon);
end

% x = cumsum(dx,2);
% y = cumsum(dy,1);

%% Calculate gradient: 

% Preallocate output: 
FX = nan(size(F)); 
FY = nan(size(F)); 

% Calculate gradient for each slice of F: 
for k = 1:size(F,3)
%     [FX(:,:,k),FY(:,:,k)] = gradient(F(:,:,k),x,y); 
    [FX(:,:,k),FY(:,:,k)] = gradient(F(:,:,k)); 
end

FX = bsxfun(@rdivide,FX,dx); 
FY = bsxfun(@rdivide,FY,dy); 

%% Return to original grid orientation if we changed it: 

if permutedims 
   FX = ipermute(FX,[2 1 3]); 
   FY = ipermute(FY,[2 1 3]); 
end

end


function tf = islatlon(lat,lon)
% islatlon determines whether lat,lon is likely to represent geographical
% coordinates. 

tf = all([isnumeric(lat) isnumeric(lon) all(abs(lat(:))<=90) all(lon(:)<=360) all(lon(:)>=-180)]); 

end