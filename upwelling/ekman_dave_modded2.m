function varargout = ekman_dave_modded(lat,lon,Taux,Tauy,varargin) 
% BLAH
%ne of the University of Texas 
% Institute for Geophysics (UTIG), February 2017. 
% http://www.chadagreene.com
% 
% See also: geocurl and geodim. 

%% Initial error checks: 

narginchk(4,inf) 
assert(isequal(size(Taux),size(Tauy))==1,'Input error: Dimensions of u10 and v10 must agree.') 
assert(islatlon(lat,lon)==1,'Input error: lat and/or lon values appear to exceed the normal range of geo coordinates.') 
assert(isvector(lat)==0,'Input error: lat and lon must be 2D grids, not vectors. Use meshgrid to make a 2D grid.') 
assert(isequal(size(lat),size(lon))==1,'Input error: Dimensions of lat and lon must agree.') 
assert(isequal(size(lat),[size(Taux,1) size(Taux,2)])==1,'Input error: The dimensions of wind field must match the dimensions of lat and lon.')
assert(numel(lat)>3,'Input error: The grid should have more than a few points.') 

if any(abs(lat(:))<10)
   warning('You have included some data points within 10 degrees of the equator. Some folks say Ekman is invalid within 10 degrees of the equator, others say Ekman''s formulas work as close as two or three degrees from the equator. There is no clearly defined cutoff latitude, but the issue is that Ekman divides by the Coriolis frequency, which approaches zero at the equator.')
end

%% Set defaults: 

Cd = 1.25e-3; 
rho = 1028; 
ice = false; % no sea ice present unless user says so.

%% Check for user-defined preferences: 

%% Calculate Ekman layer depth if user wants it: 

%% Change grid orientation if necessary: 
% Some grids are created like [lon,lat] = meshgrid(-180:180,-90:90) while others are created like 
% [lat,lon] = meshgrid(-90:90,-180:180). For consistency, let's permute the [lat,lon] types into [lon,lat] types: 

% An overview of gridtypes appears in the recenter function
gridtype = [sign(diff(lon(2,1:2))) sign(diff(lat(1:2,1))) sign(diff(lat(2,1:2))) sign(diff(lon(1:2,1)))]; 
size(lat)
if isequal(abs(gridtype),[1 1 0 0])
   % This means it's the [lon,lat] type, and we're good to keep going.
   permutedims = false; 
   
elseif isequal(abs(gridtype),[0 0 1 1])
   lat = permute(lat,[2 1 3]); 
   lon = permute(lon,[2 1 3]); 
   Taux = permute(Taux,[2 1 3]); 
   Tauy = permute(Tauy,[2 1 3]); 
   rho = permute(rho,[2 1 3]); 
   permutedims = true; 
else
   error('Unrecognized lat,lon grid type. It should be monotonic, like it was created by meshgrid.') 
end
size(lat)
%% Calculate parameters for the input grid: 
% Grid dimensions: 
[dx,dy] = geodim(lat,lon); 
size(dy),size(dx)
%figure,flat_pcolor(lon,lat,dx),colorbar
%figure,flat_pcolor(lon,lat,dy),colorbar
% Coriolis frequency: 
f = coriolisf(lat); 
nanmean(f(:))
size(f)
% Estimate wind stress based on 10 m wind speed and drag coefficient:
%[Taux,Tauy] = windstress(u10,v10,'Cd',Cd); commented out for ekman_dave



disp('custom calc REMOVE for real data')
UE = Taux;%bsxfun(@rdivide,Taux,(rho.*f)); % m^2/s
VE = Tauy;%bsxfun(@rdivide,Tauy,(rho.*f)); % m^2/s
[~,du] = gradient(UE(:,:));
[dv,~] = gradient(VE(:,:));
wE = (dv./dx-du./dy)./(rho.*f);
rho 
disp('custom calc REMOVE for real data')


%% Return to original grid orientation if we changed it: 

if permutedims 
   UE = ipermute(UE,[2 1 3]); 
   VE = ipermute(VE,[2 1 3]); 
   if nargout>2
      wE = ipermute(wE,[2 1 3]); 
   end
end

%% Package up the outputs: 

switch nargout
   case {0,1} 
      varargout{1} = wE; 
      
   case 2
      varargout{1} = UE; 
      varargout{2} = VE; 

   case {3,4}
      varargout{1} = UE; 
      varargout{2} = VE; 
      varargout{3} = wE; 
      
   otherwise 
      error('Unrecognized outputs. But I can''t even imagine how we got here.')
end

end




%% Subfunctions 



function tf = islatlon(lat,lon)
% islatlon determines whether lat,lon is likely to represent geographical coordinates. 
% Set default output: 
tf = true; 

% If *any* inputs don't look like lat,lon, assume none of them are lat,lon. 

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


function [ Cdn10e ] = Cd_ice(SeaIceConcentration)
% Cd_ice estimates drag coefficient on sea ice resulting from 10 m winds. This
% model is from Lüpkes and Birnbaum, 2005. 
% 
% Enter Sea Ice Concentration (fraction) and get a coefficient of drag in
% return.  
% 
% Chad Greene, September 26, 2013.   
% 
% See also windstress.

A = SeaIceConcentration; % sea ice concentration 
A(A>1) = 1; 
hf = .49*(1-exp(-.59.*A)); % Eq 20
Di = 31*hf./(1-A); % Eq 21
ar = Di./hf; % aspect ratio from Eq 22

Cdn10i = 1.89e-3; % constants used in text 
Cdn10w = 1.25e-3;

Cdn10e = (.34*A.^2).*(((1-A).^.8 + .5*(1-.5*A).^2)./(ar+90*A)) + A.*Cdn10i + (1-A).*Cdn10w;

% The equation above blows up in Matlab where A=0 (no sea ice present), but equation 22
% of lupkes2005surface indicates that when A=0, the equation reduces to the last term. 
% In other words, evaluating the Equation 22 by hand we'd be left with just the last term, 
% but Matlab sends the the whole solution to NaN if the first two terms are included when 
% A=0, so let's just set it manually, and include a little wiggle room for numerical noise: 

Cdn10e(A<0.001) = Cdn10w; 

end
