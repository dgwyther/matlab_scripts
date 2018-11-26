function f = coriolisf(lat)
% coriolisf returns the Coriolis frequency for any given latitude(s). 
% The Coriolis frequency is sometimes called the Coriolis parameter or the 
% Coriolis coefficient. It is a function of only latitude.
%  
% Note: this function only applies to Earth or other celestial bodies whose
% rate of rotation is 7.2921 x 10^-5 radians per second. 
% 
%% Syntax
% 
%  f = coriolisf(lat) 
% 
%% Description
% 
% f = coriolisf(lat) returns the Coriolis frequency in radians per second
% for point(s) at latitude(s) lat.
% 
%% Examples 
% For examples type: 
% 
%   cdt coriolisf
% 
%% Author Info
% Written by Chad A. Greene of the University of Texas Institute for
% Geophysics (UTIG). July 2014. http://www.chadagreene.com
% 
% See also: ekman. 

assert(max(abs(lat(:)))<=90,'Latitude value(s) out of realistic bounds. Check inputs and try again.')

f = 2*(7.2921e-5).*sind(lat); 

end

