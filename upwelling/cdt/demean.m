function Adm = demean(A,dim) 
% demean removes the mean from a dataset
% 
%% Syntax 
% 
%  Adm = demean(A) 
%  Adm = demean(A,dim) 
%  
%% Description 
% 
% 
%% Example 
% 
% 
%% Author Info 
% This function was written by Chad A. Greene of the University of Texas Institute 
% for Geophysics (UTIG), February 2017.  
% http://www.chadagreene.com. 
% 
% See also: mean, demedian, and denanmean. 

%% Error checks and input parsing: 

assert(nargin>=1,'Input error: not enough inputs.') 


if nargin==1
   dim = 3; 
   if isrow(A) 
      dim = 2; 
   end
   
   if iscolumn(A)
      dim = 1; 
   end
end

%% Perform mathematics: 

Adm = bsxfun(@minus,A,mean(A,dim)); 


end