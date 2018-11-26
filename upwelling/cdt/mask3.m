function A_masked = mask3(A,mask,varargin) 
% mask3 applies a mask to all levels of 3D matrix corresponding to a 2D mask.
% 
%% Syntax
% 
%  A_masked = mask3(A,mask)
%  A_masked = mask3(A,mask,ReplacementValue)
% 
%% Description
% 
% A_masked = mask3(A,mask) sets all elements along the third dimenion of the 3D 
% matrix A to NaN wherevever there are true elements in the corresponding 2D 
% logical mask.
% 
% A_masked = mask3(A,mask,ReplacementValue) fills masked elements with a specified 
% value. Default ReplacementValue is NaN.  
% 
%% Example 
% 
%    A = rand(100,100,300); 
%    mask = peaks(100)>1; 
%    A_masked = mask3(A,mask); 
% 
%    figure
%    subplot(1,2,1) 
%    imagesc(mask) 
%    colorbar
%    title 'this is the mask' 
% 
%    subplot(1,2,2) 
%    imagesc(sum(isfinite(A_masked),3))
%    colorbar
%    title 'number of finite values in A_masked'
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas Institute for 
% Geophysics (UTIG), January 2017. 
% http://www.chadagreene.com 
% 
% See also: geomask, island, and bsxfun.

%% Error checks: 

assert(ndims(A)>=2,'Input error: The mask3 function requires that matrix A must be 2 or 3 dimensional.') 
assert(isequal([size(A,1) size(A,2)],size(mask))==1,'Input error: The dimensions of the mask must match the first two dimensions of A.') 

%% Input parsing: 

if nargin>2 
   ReplacementValue = varargin{1}; 
   assert(isnumeric(ReplacementValue)==1,'Input error: Replacement value must be numeric.')
   assert(isscalar(ReplacementValue)==1,'Input error: Replacement value must be a scalar or NaN.')
else 
   ReplacementValue = NaN; 
end

%% Perform fancy math: 

% Make a 2D numeric mask of ones: 
m2 = ones(size(mask)); 

% Set mask values to that which the user desires most: 
m2(mask) = ReplacementValue; 

% Apply the mask to all levels of A: 
A_masked = bsxfun(@times,A,m2); 

end


