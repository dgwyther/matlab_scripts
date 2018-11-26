function y = local1d_old(lat,lon,A,varargin) 
% local1d returns a 1D array of values calculated from a region of interest in a 3D matrix. 
% For example, if you have a big global 3D sea surface temperature dataset, this function
% makes it easy to obtain a time series of the average sst within a region of interest. 
% 
%% Syntax 
% 
%  y = local1d(lat,lon,A,mask)
%  y = local1d(lat,lon,A,latv,lonv)
%  y = local1d(...,'areaweighted') 
%  y = local1d(...,'function',function) 
% 
%% Description 
% 
% y = local1d(lat,lon,A,mask) for 2D or 3D matrix A calculates the mean value within the 2D logical mask for each
% slice along dimension 3 of A. Inputs lat and lon are 2D grids corresponding to the first dimensions of A. 
% Output y is a vector whose length matches the third dimension of A. The mask must be logical and its dimensions 
% must match dimensions 1 and 2 of A. 
% 
% y = local1d(lat,lon,A,latv,lonv) calculates vector y for the region of interest defined by latv,lonv, 
% where lat,lon are 2D grids that match dimensions 1 and 2 of A.  If latv and lonv are scalars, y is
% the time series (or depth profile, or whatever is the third dimension of A) of the nearest-neighbor grid 
% cell. If latv and lonv are two-element arrays, y is generated from all values within the quadrangle
% given by the extents of latv and lonv, inclusive.  If latv and lonv are N-element 1D arrays, y is 
% generated from all values within the polygon latv,lonv. 
%  
% y = local1d(...,'areaweighted') weights averages by grid cell area from <geoarea_documentation.html geoarea>.
% 
% y = local1d(...,'function',function) applies any function to the data values which make up each element
% of y.  The default function is @mean, but you may use @max, @nanmedian, @std, or just about
% any other function you can think of. You can even define your own anonymous function. 
% 
%% Examples 
% For examples type 
% 
%    cdt recenter
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas Institute for Geophysics
% (UTIG), Februrary 2017.  http://www.chadagreene.com
% 
% See also recenter and geoarea. 

%% Error checks: 

narginchk(4,8) 
assert(ndims(A)>=2,'Input error: Matrix A must be 2D or 3D.') 
assert(isequal([size(A,1) size(A,2)],size(lat),size(lon))==1,'Input error: lat lon grids must match the first two dimensions of A.') 
% assert(islatlon(lat,lon)==1,'Input error: lat,lon grids appear to contain values outside the normal ranges of lats and lons. Check the order of inputs to local1d.') 

%% Parse inputs: 

% Determine which function to apply: 
tmp = strncmpi(varargin,'function',3); 
if any(tmp) 
   fn = varargin{find(tmp)+1}; 
   assert(isa(fn,'function_handle')==1,'Input error: Unrecognized function. Make sure it starts with @, like @mean, @max, or @nanmedian.')
else
   fn = @mean; % default to mean. 
end

% Determine if a mask is explicitly defined: 
if islogical(varargin{1}) 
   mask = varargin{1}; 
   assert(isequal(size(mask),[size(A,1) size(A,2)])==1,'Input error: the logical mask must match dimensions 1 and 2 of A.')
   makeamask = false; 
else
   assert(nargin>4,'Input error: Not enough inputs defined. Or perhaps you tried to enter a mask, but it was not logical class? Check inputs to local1d and try again.') 
   latv = varargin{1}; % latv and lonv define points within lat,lon
   lonv = varargin{2}; 
%    assert(islatlon(latv,lonv)==1,'Input error: latv,lonv appear to contain values outside the normal ranges of lats and lons. Check the order of inputs to local1d.') 
   assert(isvector(latv)==1,'Input error: latv and lonv can be a scalar for nearest-point, two-element arrays for a quadrangle, or N-element 1D arrays for a polygon.') 
   assert(isequal(size(latv),size(lonv))==1,'Input error: Dimensions of latv and lonv must agree.') 
   makeamask = true; 
end
   
% Check for area-average weighting: 
tmp = strncmpi(varargin,'areaweighted',4); 
if any(tmp) 
   areaweighting = true; 
   assert(isequal(fn,@mean)==1,'Input error: area weighted averaging can only be performed with the default @mean function.') 
else
   areaweighting = false; 
end

%% Make a mask if user did not explictly define one: 

if makeamask 
   switch numel(latv) 
      case 1 % use nearest point 
         
         % An explanation of gridtypes is found in the recenter documentation
         gridtype = [sign(diff(lon(2,1:2))) sign(diff(lat(1:2,1))) sign(diff(lat(2,1:2))) sign(diff(lon(1:2,1)))]; 

         if isequal(abs(gridtype),[1 1 0 0])
            lon1 = lon(1,:); 
            lat1 = lat(:,1); 
            row = interp1(lat1,1:length(lat1),latv,'nearest'); 
            col = interp1(lon1,1:length(lon1),lonv,'nearest'); 
            y = squeeze(A(row,col,:))'; 
         elseif isequal(abs(gridtype),[0 0 1 1])
            lon1 = lon(:,1); 
            lat1 = lat(1,:); 
            col = interp1(lat1,1:length(lat1),latv,'nearest'); 
            row = interp1(lon1,1:length(lon1),lonv,'nearest'); 
            y = squeeze(A(row,col,:))'; 
         else
            error('Unrecognized lat,lon grid type. It should be monotonic, like it was created by meshgrid.') 
         end
         
         % If we got through everything above, our work is done and we can quit the function: 
         return

      case 2 % a range, inclusive
         
         mask = lat>=min(latv) & lat<=max(latv) & lon>=min(lonv) & lon<=max(lonv); 
         
      otherwise 
         mask = inpolygon(lon,lat,lonv,latv); 
   end   
end

%% Reshape A such that rows correspond to time, and columns are different pixels: 

A = permute(A,[3 1 2]); 
A = reshape(A,size(A,1),size(A,2)*size(A,3)); 
A = A(:,mask(:)); 

%% Compute user-specified value: 

if areaweighting
   
   % Get a 3D grid of area: 
   Area = geoarea(lat,lon); 
   
   % Reshape it the same way as A: 
   Area = permute(Area,[3 1 2]);
   Area = reshape(Area,size(Area,1),size(Area,2)*size(Area,3));
   Area = Area(:,mask(:)); 

   % Compute weighted mean as sum(A*Area)/sum(Area):
   y = sum(bsxfun(@times,A,Area)')./sum(Area); 
   
else
     
   y = fn(A'); 
   
end

end






function tf = islatlon(lat,lon)
% islatlon determines whether lat,lon is likely to represent geographical
% coordinates. 

tf = all([isnumeric(lat) isnumeric(lon) all(abs(lat(:))<=90) all(lon(:)<=360) all(lon(:)>=-180)]); 

end