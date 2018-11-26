function [r,p] = corr3(X,y,varargin) 
% corr3 computes linear or rank correlation for a time series and a 3D dataset. 
% 
%% Syntax 
% 
%  r = corr(X,y) 
%  [r,p] = corr(X,y)
%  [...] = corr(X,y,'name',value)
% 
%% Description 

assert(license('test','statistics_toolbox')==1,'License error: Sorry, the corr3 function requires the Statistics Toolbox.') 


[r,p] = corr(cube2rect(X),y(:),varargin{:}); 


r = rect2cube(r,size(X)); 
p = rect2cube(p,size(X)); 


end