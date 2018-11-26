


%% Load data 

load snapshot_for_chad.mat

LON = round(LON,4); % rounding to 4 significant digits to get rid of numerical noise.  
LAT = round(LAT,4); 

%% Plot 

[UE,VE,wE] = ekman_dave(LAT,LON,UWND_rho,VWND_rho); 

%% 

pcolorps(LAT,LON,wE)
quiverps(LAT,LON,UWND_rho,VWND_rho,'k') % black wind stress
q=quiverps(LAT,LON,UE,VE);             % gray surface water transport
q.Color = [.5 .5 .5]; 
axis tight
antbounds('gl','k')

colorbar
cmocean('bal','pivot') 