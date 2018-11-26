



filename = '/Users/chadgreene/Documents/MATLAB/ECMWF/ERA_Interim_global_wind_2015.nc'; 
% filename = '_grib2netcdf-atls04-95e2cf679cd58ee9b4db4dd119a05a8d-h5dMRc.nc'; 
lat = ncread(filename,'latitude'); 
lon = ncread(filename,'longitude'); 
sst = ncread(filename,'sst'); 
u10 = ncread(filename,'u10'); 
v10 = ncread(filename,'v10'); 

sst = permute(sst,[2 1 3]); 
u10 = permute(u10,[2 1 3]); 
v10 = permute(v10,[2 1 3]); 
[Lon,Lat] = meshgrid(lon,lat); 


plot(Lon,Lat,'r.'); 
%% 

hold on

[la,lo,U] = recenter(Lat,Lon,u10,'center',-120); 
plot(lo,la,'b.') 

%% 

imagescn(lo(1,:),la(:,1),mean(U,3)) 
axis xy image 

%% 

lo = Lon(1,:); 
la = Lat(:,1); 
% [Lat,Lon,u10,v10,sst] = recenter(Lat,Lon,u10,v10,sst,'center',0); 

%% 

% lat = Lat; 
% lon = Lon; 
u10 = mean(u10,3); 
v10 = mean(v10,3); 
sst = mean(sst,3); 
lat = Lat(:,1); 
lon = Lon(1,:); 

% save('ERA_Interim_wind_2015.mat','lat','lon','u10','v10','sst'); 

% save('wind_data.mat')

%%
% 
% filename = '_grib2netcdf-atls14-95e2cf679cd58ee9b4db4dd119a05a8d-gJq8TI.nc'; 
% filename = 'ERA_interim_Calif_2015.nc';
filename = 'ERA_Interim_global_wind_2015.nc'; 
filename = 'global_sst_2015.nc'; 
lat = ncread(filename,'latitude'); 
lon = ncread(filename,'longitude'); 
sst = ncread(filename,'sst'); 
u10 = ncread(filename,'u10'); 
v10 = ncread(filename,'v10'); 

sst = permute(sst,[2 1 3]); 
u10 = permute(u10,[2 1 3]); 
v10 = permute(v10,[2 1 3]); 
% [Lon,Lat] = meshgrid(lon,lat); 

% [Lat,Lon,u10,v10,sst] = rewrap(Lat,Lon,u10,v10,sst); 

%% 

% lat = Lat; 
% lon = Lon; 
% u10 = mean(u10,3); 
% v10 = mean(v10,3); 
% sst = mean(sst,3); 
% 
% save('ERA_Interim_wind.mat','lat','lon','u10','v10','sst'); 

%% 


load ERA_Interim_wind_2015.mat

lat = flipud(lat); 
[Lon,Lat] = meshgrid(lon,lat); 
u10 = flipud(u10); 
v10 = flipud(v10); 
sst = flipud(sst); 

u10 = filt2(u10,1/8,1,'lp'); 
v10 = filt2(v10,1/8,1,'lp'); 

imagescn(lon,lat,sst-273.15)
axis xy image
hold on

sc = 0.03; 
q = quiver(imresize(lon,sc),imresize(lat,sc),imresize(u10,sc),imresize(v10,sc),'color',0.1*[1 1 1]);
cmocean thermal  
caxis([-2 30])

% shadem(2,[225 36])

%% 


Taue = windstress(u10); % Tau_lam
Taun = windstress(v10); % tau_phi

Taue(isnan(sst)) = nan; 
Taun(isnan(sst)) = nan; 

f = coriolisf(Lat,Lon); 

%% 

del = 0.25e-5; % friction parameter Eq 4 
rho_w = 1027; 

U = (del*Taue + f.*Taun)./(rho_w.*(f.^2 + del^2)); 
V = (del*Taun - f.*Taue)./(rho_w.*(f.^2 + del^2)); 

R = 6371000; % Earth radius in meters.

[~,py] = gradient(U,lon,lat); 
[qx,~] = gradient(V.*cosd(Lat),lon,lat); 

w = (1./(R.*cosd(Lat))).*(py + qx);

%%

% https://marine.rutgers.edu/dmcs/ms501/2004/Notes/Wilkin20041028.htm 

rho_w = 1025; 

Ve = -Taue./(rho_w*f); 
Ue = Taun./(rho_w*f); 

R = 6371000; % Earth radius in meters.

% Determine approximate x and y dimensions of each grid cell in meters: 

[dlat1,dlat2] = gradient(Lat); 
[dlon1,dlon2] = gradient(Lon); 

% We don't know if lat and lon were created by [lat,lon] = meshgrid(lat_array,lon_array) or [lon,lat] = meshgrid(lon_array,lat_array) 
% but we can find out: 
if isequal(dlat1,zeros(size(Lat)))
   dlat = dlat2; 
   dlon = dlon1; 
   assert(isequal(dlon2,zeros(size(Lon)))==1,'Error: lat and lon must be monotonic grids, as if created by meshgrid.') 
else
   dlat = dlat1; 
   dlon = dlon2; 
   assert(isequal(dlon1,dlat2,zeros(size(Lon)))==1,'Error: lat and lon must be monotonic grids, as if created by meshgrid.') 
end

% Convert dlats and dlons to grid cell sizes: 
dy = dlat*R*pi/180;
dx = (dlon/180).*pi*R.*cosd(Lat); 

[~,py] = gradient(Ve./dy);
[qx,~] = gradient(Ue./dx);
ek =  qx+py; 

%% 


ek2 = (1/1025) * geocurl(Lat,Lon,Taue./f,Taun./f); 

[UE,VE,wE] = ekman(Lat,Lon,u10,v10); 

fullfig
imagescn(lon,lat,(wE)*m2cm(1)/s2day(1)); 
axis xy image 
caxis([-1 1]*50)
cmocean bal

hold on
q1 = quiver(imresize(lon,sc),imresize(lat,sc),imresize(UE,sc),imresize(VE,sc),'color',rgb('light red'));
q = quiver(imresize(lon,sc),imresize(lat,sc),imresize(u10,sc),imresize(v10,sc),'color',0.1*[1 1 1]);


q1 = quiver(imresize(lon,sc),imresize(lat,sc),imresize(UE1,sc),imresize(VE1,sc),'color',rgb('gold'));

%% 

u10(isnan(sst)) = nan; 
v10(isnan(sst)) = nan; 
Taue = windstress(u10); 
Taun = windstress(v10); 

f = coriolisf(lat,lon); 

% ek = (-1/1027) * geocurl(Lat,Lon,bsxfun(@rdivide,Taue,f),bsxfun(@rdivide,Taun,f)); 
% ek = geocurl(lat,lon,mean(Taue,3)./f,mean(Taun,3)./f)*(-1/1027); 
ek = geocurl(lat,lon,mean(Taue,3)./f,mean(Taun,3)./f)*(-1/1027); 
ek(isnan(mean(sst,3))) = nan; 

% ek =  (-1/1027) * geocurl(Lat,Lon,bsxfun(@rdivide,Taue,f),bsxfun(@rdivide,Taun,f)); 
ek = mean(ek,3);

ekm = ek*30.4*24*60*60;

%%
figure
imagescn(lon(1,:),lat(:,1),ek*1e7)

axis xy 
% axis([-130 -75 -15 25]) 
colorbar
hold on
% borders('countries','facecolor',rgb('dark gray'),'nomappingtoolbox') 
caxis([-1 1]*25) 
cmocean('bal','pivot') 

% q = quiver(imresize(lon,0.08),imresize(lat,0.08),imresize(u10,0.08),imresize(v10,0.08),'k');

contour(lon,lat,ek*1e7,[-1 1]*20,'color',rgb('dark red'),'linewidth',2)
% 
% figure(1) 
% contour(lon,lat,ek*1e7,[-1 1]*20,'color',rgb('dark red'),'linewidth',2)
% caxis([12 22])

%% 
