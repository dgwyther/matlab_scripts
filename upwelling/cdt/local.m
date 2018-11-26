function y = local(A,mask,varargin) 
% local returns a 1D array of values calculated from a region of interest in a 3D matrix. 
% For example, if you have a big global 3D sea surface temperature dataset, this function
% makes it easy to obtain a time series of the average sst within a region of interest. 
% 
%% Syntax 
% 
%  y = local(A,mask)
%  y = local(...,'function',function) 
%  y = local(...,'weight',weight) 
%  y = local(...,'omitnan') not yet supported
% 
%% Description 
% 
% y = local(A,mask) calculates the mean value within the 2D logical mask for each
% slice along dimension 3 of A. For matrix A of dimensions MxNxP, the dimensions of
% mask must be MxN and the dimensions of output y are Px1. 
% 
% y = local(...,'function',function) applies any function to the data values which make up each element
% of y.  The default function is @mean, but you may use @max, @nanmedian, @std, or just about
% any other function you can think of. You can even define your own anonymous function. 
%  
% y = local(...,'weight',weight) weights averages by any given weighting grid such as that produced by <geoarea_documentation.html geoarea>
% if you want an area-weighted mean. 
% 
%% Examples 
% For examples type 
% 
%    cdt local
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas Institute for Geophysics
% (UTIG), Februrary 2017.  http://www.chadagreene.com
% 
% See also geomask, geoarea, and recenter. 

%% Error checks: 

assert(nargin>1,'Input error: local requires at least 2 inputs.') 
assert(ndims(A)>=2,'Input error: Matrix A must be 2D or 3D.') 
assert(isequal([size(A,1) size(A,2)],size(mask))==1,'Input error: lat lon grids must match the first two dimensions of A.') 
assert(islogical(mask)==1,'Error: the mask must be logical, containing true corresponding to grid cells of interest.')

%% Parse inputs: 

% Determine which function to apply: 
tmp = strncmpi(varargin,'function',3); 
if any(tmp) 
   fn = varargin{find(tmp)+1}; 
   assert(isa(fn,'function_handle')==1,'Input error: Unrecognized function. Make sure it starts with @, like @mean, @max, or @nanmedian.')
else
   fn = @mean; % default to mean. 
end

   
% Check for area-average weighting: 
tmp = strncmpi(varargin,'weight',3); 
if any(tmp) 
   weighting = true; 
   assert(isequal(fn,@mean)==1,'Input error: weighted averaging can only be performed with the default @mean function.') 
   weight = varargin{find(tmp)+1}; 
   assert(isequal([size(A,1) size(A,2)],size(weight))==1,'Error: Size of weights must match the first two dimensions of A.') 
else
   weighting = false; 
end

%% Reshape A such that rows correspond to time, and columns are different pixels: 

A = permute(A,[3 1 2]); 
A = reshape(A,size(A,1),size(A,2)*size(A,3)); 
A = A(:,mask(:)); 

%% Compute user-specified value: 

if weighting
      
   % Reshape it the same way as A: 
   weight = permute(weight,[3 1 2]);
   weight = reshape(weight,size(weight,1),size(weight,2)*size(weight,3));
   weight = weight(:,mask(:)); 

   % Compute weighted mean as sum(A*Area)/sum(Area):
   y = sum(bsxfun(@times,A,weight),2)./sum(weight); 
   
else
   
   y = fn(A')'; 
   
end

end



