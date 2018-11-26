%% |geogradient| documentation 



ccc
[lat,lon] = geogrid; 

% lat = fliplr(lat); 
% lon = fliplr(lon); 
% z = lat + lon/2; 

% z = cosd(lat); 
% z = sind(2*lon).*cosd(lat*3); 

[gx,gy] = geogradient(lat,lon,z,'km'); 

pcolor(lon,lat,z) 
shading interp
hold on

sc = 1/10; 
quiver(imresize(lon,sc),imresize(lat,sc),imresize(gx,sc),imresize(gy,sc),'k'); 



colorbar