%% |local| documentation 
% The |local| function returns a 1D array of values calculated from a region of interest in a 3D matrix. 
% For example, if you have a big global 3D sea surface temperature dataset, this function
% makes it easy to obtain a time series of the average sst within a region of interest. 
% 
% <CDT_Contents.html Back to Climate Data Tools Contents>
%% Syntax 
% 
%  y = local(A,mask)
%  y = local(...,'function',function) 
%  y = local(...,'weight',weight) 
%  y = local(...,'omitnan')
% 
%% Description 
% 
% |y = local(A,mask)| gives a time series values within a region of interest defined by |mask| inside a 
% a big gridded time series matrix |A|. For matrix |A| of dimensions MxNxP, the dimensions of
% |mask| must be MxN and the dimensions of output |y| are Px1.
% 
% |y = local(...,'function',function)| applies any function to the data values which make up each element
% of |y|.  The default function is |@mean|, but you may use |@max|, |@nanmedian|, |@std|, or just about
% any other function you can think of. You can even define your own <https://www.mathworks.com/help/matlab/matlab_prog/anonymous-functions.html 
% anonymous function>. 
%  
% |y = local(...,'weight',weight)| weights averages by any given weighting grid such as that produced by <geoarea_documentation.html |geoarea|>
% if you want an area-weighted mean. 
%  
%% Examples
% Load this sample data and for context, plot the mean sea surface temperature: 
 
load pacific_sst.mat

imagescn(lon,lat,mean(sst,3))
axis xy image
cmocean thermal 

xlabel 'longitude'
ylabel 'latitude'

%%
% Some folks characterize ENSO by the mean sea surface temperature within
% the Nino 3.4 box, defined by the region between 5 N to 5 S latitude and 170 W to
% 120 W longitude. Let's get a time series of average sea surface
% temperatures within that box. Start by creating a mask corresponding to
% the Nino 3.4 box: 

% Turn lat and lon into grids: 
[Lon,Lat] = meshgrid(lon,lat); 

% Make a mask of ones inside the polygon: 
mask = geomask(Lat,Lon,[-5 5],[-170 -120]); 

figure
imagescn(lon,lat,mask)
axis xy image

title 'Nino 3.4 mask'
xlabel 'longitude'
ylabel 'latitude'

ax = axis;
borders('countries','nomappingtoolbox')
axis(ax)

%% 
% That yellow rectangle contains the grid cells over which we'll calculate
% the mean SST time series. To get a time series of mean SST within the Nino
% 3.4 box, just give the |local| function, the |sst| dataset and the |mask|: 

y = local(sst,mask); 

figure
plot(t,y) 
axis tight
box off
datetick('x','keeplimits') 
ylabel(' sea surface temperature (\circC) ')

%% Area averaged means: 
% Assuming you are not in the Flat Earth Society, we'll have to deal with
% the inconvenient truth that the grid cells of latitude and longitude are
% not equal in area. If you want an area-weighted mean, use the
% <geoarea_documentation.html |geoarea|> function to get the area of the
% grid cells and use those areas as weights when calling |local|: 

Area = geoarea(Lat,Lon); 

yw = local(sst,mask,'weight',Area); 

hold on
plot(t,yw)

%% 
% Now you might have noticed, the area-averaged values are *very* close to
% the unweighted means. That's because the Nino 3.4 box is close to the
% equator, where all the grid cells are about the same size. The largest 
% and smallest grid cells within the Nino 3.4 box only differ by about 0.2%
% in area, so calculating the area-weighted mean here is probably
% unnecessary. 

%% Beyond average 
% Maybe you don't want the average value within the Nino 3.4 box--maybe instead you need the maximum and minimum values. 
% Let's calculate the maximum and minimum values within the Nino 3.4 box as a function of time.  Then plot 
% the min-to-max range as a semitransparent |patch| object and send it to he bottom of the graphical stack: 

% Calculate max and min values within the Nino 3.4 box: 
ymax = local(sst,mask,'function',@max); 
ymin = local(sst,mask,'function',@min); 

% Plot the min-to-max range as a patch object: 
h = patch([t;flipud(t)],[ymin;flipud(ymax)],'b','facealpha',0.25,'edgecolor','none'); 

% Send the patch to the bottom of the stack: 
uistack(h,'bottom') 

% Zoom in to see what's going on: 
ylim([22 31]) 
xlim([datenum('jan 1, 1990') datenum('jan 1, 2000')]) 
datetick('x','keeplimits') 

%% Time series from masks
% Instead of defining polygons, points, or limits of quadrangles, you may already have some logical |mask|
% you'd like to apply to your data.  In this example, let's compare the sea surface temperature of the
% northern hemisphere versus the southern hemisphere (not accounting for differences in grid cell areas). 
% Land values in the |sst| dataset are |NaN|, so we can either use |@nanmean| instead of the default |@mean| function, 
% or we can mask-out the land values manually. It's slightly easier to just use |@nanmean| the same way we used
% |@min| and |@max| above, but I want to create the masks manually so we can get a visual sense of what the
% masks mean.  Start by defining the |ocean| as anything where all the |sst| values are finite: 

% Ocean mask: 
ocean = all(isfinite(sst),3); 

% Make masks of northern and southern hemispheres: 
north = ocean & Lat>0; 
south = ocean & Lat<0; 

%% 
% Here's what those masks look like; yellow is |true| and blue is |false|: 

figure
subplot(1,3,1) 
imagesc(ocean) 
axis image off
title 'ocean'

subplot(1,3,2) 
imagesc(north) 
axis image off
title 'northern hemisphere'

subplot(1,3,3) 
imagesc(south) 
axis image off
title 'southern hemisphere'

%% 
% With masks defined it's easy to compare sea surface temperatures in the northern and southern hemispheres: 

% Calculate time series of SSTs: 
ynorth = local(sst,north); 
ysouth = local(sst,south); 

% Plot time series: 
figure
plot(t,ynorth,'b') 
hold on
plot(t,ysouth,'r') 
ylabel(' mean sst (\circC) ')
legend('northern hemisphere','southern hemisphere') 

% Zoom in on a 3 year period: 
xlim([datenum('jan 1, 1990') datenum('jan 1, 1993')]) 
datetick('x','keeplimits') 

%% Area-weighted mean
% The time series above indicates that sea surface temperatures in the northern and southern hemispheres tend
% to be out of phase with each other due to seasonality. But in the plot above, every grid cell was given equal
% weight in the calculation of the means, even though poleward (colder) grid cells are smaller in area than 
% equatorward (warmer) grid cells.  Unweighted means bias global averages toward values found near the 
% poles rather than representing a true spatial average.  For a better measure of average sea surface temperatures, 
% use the |'areaweighted'| option:  

% Calculate time series of SSTs: 
ynorthw = local(sst,north,'weight',Area); 
ysouthw = local(sst,south,'weight',Area); 

% Plot time series: 
plot(t,ynorthw,'b','linewidth',2) 
plot(t,ysouthw,'r','linewidth',2) 
legend('unweighted northern hemisphere','unweighted southern hemisphere',...
  'area-weighted northern hemisphere','area-weighted southern hemisphere') 

% Zoom in on a 3 year period: 
xlim([datenum('jan 1, 1990') datenum('jan 1, 1993')]) 
datetick('x','keeplimits') 

%% 
% Area-weighted sea surface temperatures are higher than unweighted means because warm grid cells near the
% equator are much larger than cold, small grid cells near the poles, so they should contribute more to the true 
% spatial average.  An offset of several degrees still remains between the northern and southern hemispheres, 
% but that does not mean the northern hemisphere is several degrees warmer than the southern hemisphere.  Rather
% the bias more likely a result of Canada and the United States getting in the way of the ocean and thus reducing
% the overall contribution of the northernmost grid cells.  Here's a look at how many grid cells are contributing
% to averages, by latitude: 

figure
hist(Lat(ocean),-55:10:55)
xlabel('latitude')
ylabel('number of contributing cells') 
xlim([-60 60])

%% Define your own anonymous function
% Perhaps you feel too limited by Matlab's offerings of simple functions like |@mean|, |@max|, |@min|, etc. If you
% need to get more complicated measures of what's going on inside a region of interest, simply define a function
% of your own. 
% 
% Say you want the total temperature range in a region of interest in degrees Fahrenheit.  For any arbitrary set of temperature
% values |x|, we want the |max(x)| minus |min(x)|, and then convert to Fahrenheit by multiplying by 9/5 and add 32: 

% Define temperature span in degrees F: 
fn = @(x) (max(x) - min(x))*9/5+32;

% Calculate
sst_range_F = local(sst,north,'function',fn); 

figure
plot(t,sst_range_F) 

% Zoom in on a 3 year period: 
xlim([datenum('jan 1, 1990') datenum('jan 1, 1993')]) 
datetick('x','keeplimits') 
ylabel(' Range of SSTs in northern hemisphere, (\circF) ')

%% 
% The plot above implies that in the winter, there's about a 90 degree difference in temperature between the north
% pole and the equator.  In the summer, the Arctic warms up, while the equator stays about the same temperature, 
% so the difference in temperature drops to about 72 degrees. 

%% Author Info 
% The |local| function and supporting documentation were written by Chad A. Greene of the University of Texas
% Institute for Geophysics (UTIG), February 2017. 

