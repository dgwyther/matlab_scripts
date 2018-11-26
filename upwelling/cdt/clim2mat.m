function Ar = clim2mat(A) 



Ar = permute(A,[3 1 2]); 
Ar = reshape(Ar,size(Ar,1),size(Ar,2)*size(Ar,3)); 


end