function A3 = rect2cube(A2,gridsize_or_mask) 

assert(nargin==2,'Error: rect2cube requires 2 inputs.') 


if numel(gridsize_or_mask)<=3
   gridsize = gridsize_or_mask; 
else
   gridsize = size(mask); 
   mask = gridsize_or_mask; 
   error('masking option does not yet work.') 
end



% Unreshape back to original size of A: 
A3 = ipermute(reshape(A2,[],gridsize(1),gridsize(2)),[3 1 2]); 


end