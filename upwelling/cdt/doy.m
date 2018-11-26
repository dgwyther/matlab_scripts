function n = doy(t,varargin) 
% doy returns the Julian day of year. 
% 
%% Syntax
% 
%  n = doy(t) 
%  n = doy(t,'yearfraction') 
%  n = doy(t,'decimalyear') 
% 
%% Description 
% 
% n = doy(t) gives the day of year (from 1 to 366.999) corresponding to the date(s) 
% given by t. Input dates can be datenum or string format. 
% 
% n = doy(t,'yearfraction') gives the fraction of the year corresponding to date(s) t. 
% This accounts for leap years, so July 4th of any leap year is 0.5082 of the year, 
% but for non-leap years, July 4th is 0.5068 of the year. 
% 
% n = doy(t,'decimalyear') is similar to the 'yearfraction' option, but adds the year. 
% So July 4th of 2016 is 2016.5082 in decimal year format. 
% 
%% Examples: 
% 
% 
%% Author Info: 
% This function was written by Chad A. Greene of the University of Texas Institute for 
% Geophysics (UTIG), June 2017. 
% 
% See also datenum, datevec, and datestr. 


%% Parse inputs: 

yearfraction = false; 
if nargin>1
   if any(strncmpi(varargin,'yearfraction',4))
      yearfraction = true; 
   end
   
   if any(strncmpi(varargin,'decimalyear',3)) 
      yearfraction = true; 
      decyear = true; 
   end
end

%% Perform mathematics: 

% If the input is a string, convert it to datenum: 
t = datenum(t); 

% Get the year of each input date: 
[yr,~,~] = datevec(t); 

% Datenum corresponding to the strike of midnight at New Years: 
tnye = datenum(yr,0,0,0,0,0); 

% The day of the year is the date minus the datenum of the New Year: 
n = t - tnye; 

if yearfraction 
   
   % Datenum of the ceiling new years: 
   tmax = datenum(yr+1,0,0,0,0,0); 
     
   % The year fraction is the day of year out of the total number of days in the year: 
   n = n./(tmax-tnye); 
   
   if decyear
      n = n+yr; 
   end
   
end


end
