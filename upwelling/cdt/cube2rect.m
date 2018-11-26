function A2 = cube2rect(A3,mask)
% cube2rect reshapes a 3D matrix for use with many standard Matlab functions. 
% 
%



if nargin<2
   mask = true(size(A3,1),size(A3,2)); 
end

% Reshape
A2 = permute(A3,[3 1 2]); 
A2 = reshape(A2,size(A2,1),size(A2,2)*size(A2,3)); 

% Eliminate masked-out values: 
A2 = A2(:,mask(:)); 




end