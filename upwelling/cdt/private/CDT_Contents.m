%% CDT Contents 
% This page lists the contents of Climate Data Tools for Matlab. 
% 
%% Getting help 
% To access this page from the Command Window, simply type 
% 
%  cdt
% 
% To access the help file for a particular function in CDT, type |cdt| followed by the function name. 
% For example, 
% 
%  cdt deseason 
%
%% Descriptive statistics 
% 
% * <season_documentation.html *|season|*> calculates the seasonal (aka annual) climatology of a time series. 
% 
% * <deseason_documentation.html *|deseason|*> removes the seasonal (aka annual) climatology from a time series. 
% 
% * *|trend|*
% 
% * *|detrendn|* 
% 
% * *|wmean|* weighted mean, include 'omitnan' option
% 
% * *|dewmean|*
% 
% * *|demean|* 
% 
% * *|demedian|*
% 

%% Matrix manipulation
% Never write a |for| loop (except for exceptions). And never _ever_ write a 
% |for| loop within another |for| loop (except under absolute dire circumstances). 
% Matlab is typically much faster if code is <https://www.mathworks.com/help/matlab/matlab_prog/vectorization.html
% *vectorized*>, and vectorized code is much easier to debug than anything containing
% loops within loops. 
% 
% The following functions make it easy to reshape big climate data matrices for 
% use with standard Matlab functions. 
% 
% * *|cube2rect|* turns a 3D matrix (whose dimensions may correspond to lat*lon*time or lon*lat*time)
% into a rectangular 2D matrix. 
% 
% * *|rect2cube|* reshapes a rectangularized time series back into a 3D matrix. 

%% Misc and masks 
% 
% * *||*
% 
% * *||*
% 
% * *||*
% 
% * <island_documentation.html *|island|*> determines whether geographic locations
% correspond to land or water. 
% 
% * <geomask_documentation.html *|geomask|*> determines whether geographic locations
% are within a given geographic region.

%% 1D data  
% In keeping with the semantics of official Matlab documentation, the terms 1D, 2D, and 3D refer to the 
% non-unity dimensions of data matrices.  In reality, a vector describing a quantity that changes through
% time has dimensions of time and the changing quantity, but if the vector is 1xN or Nx1, we consider it
% 1D data. 
% 
% * <local_documentation.html *|local|*>  returns a 1D array of values calculated from a region of interest in a 3D matrix. 
% For example, if you have a big global 3D sea surface temperature dataset, this function
% makes it easy to obtain a time series of the average sst within a region of interest. 


%% 2D data  
%
% * <geoarea_documentation.html *|geoarea|*> gives the approximate area of each cell in a lat,lon grid assuming a spherical Earth  
% of radius 6371000 meters. This function was designed to enable easy area-averaged weighting of large gridded climate datasets.
% 
% * <geodim_documentation.html *|geodim|*> gives the approximate dimensions of each cell in a lat,lon grid assuming a spherical   
% Earth of radius 6371000 meters.
% 
% * <geogrid_documentation.html *|geogrid|*> uses |meshgrid| to easily create a global grid of latitudes and longitudes. 
% 
% * <recenter_documentation.html *|recenter|*> rewraps a gridded dataset to be centered on a specified longitude.

%% 3D data 
%
% * <local1d_documentation.html *|local1d|*>  returns a 1D array of values calculated from a region of interest in a 3D matrix. 
% For example, if you have a big global 3D sea surface temperature dataset, this function
% makes it easy to obtain a time series of the average sst within a region of interest. 
% 
% * <recenter_documentation.html *|recenter|*> rewraps a gridded dataset to be centered on a specified longitude.
% 
% * <xcorr3_documentation.html *|xcorr3|*> gives a map of correlation coefficients between grid cells of a 3D spatiotemporal  
% dataset and a reference time series.
% 
% * <xcov3_documentation.html *|xcov3|*> gives a map of covariance between grid cells of a 3D spatiotemporal dataset and a 
% reference time series.

%% Statistical analysis
% Consider bringing Aslak Grinsted on board and/or Tapio Schneider or perhaps BARCAST. 

%% Ocean & atmosphere data analysis  
% 
% * <bottom_documentation.html *|bottom|*> finds the lowermost finite values of a 3D matrix such as seafloor
% temperature. 
% 
% * <coriolisf_documentation.html *|coriolisf|*> returns the Coriolis frequency for any given latitude(s). 
%
% * <ekman_documentation.html *|ekman|*> estimates the classical <https://en.wikipedia.org/wiki/Ekman_transport Ekman 
% transport> and upwelling/downwelling from 10 m winds. 
% 
% * <windstress_documentation.html *|windstress|*> estimates wind stress on the ocean from wind speed.

%% Plotting 
% 
% * <anomaly_documentation.html *|anomaly|*> plots line data with different colors of shading filling the area
% between the curve and a reference value.  This is a common way of displaying anomaly time series such as sea surface
% temperatures or climate indices. 
% 
% * <spiralplot_documentation.html *|spiralplot|*> plots an Ed Hawkins style spiral plot of a time series. 
% 
% * <rgb_documentation.html *|rgb|*> provides RGB values of common and uncommon colors by name. 

%% Mapmaking 
% 
% * <rgb_documentation.html *|rgb|*> provides RGB values of common and uncommon colors by name. 
% 
% * <cmocean_documentation.html *|cmocean|*> provides perceptually-uniform colormaps by <http://dx.doi.org/10.5670/oceanog.2016.66 Thyng et al., 2016>.
% 
% * <imagescn_documentation.html *|imagescn|*> is faster than |pcolor|, plots _all_ the data you give 
% it (whereas |pcolor| deletes data near edges and |NaN| values), makes |NaN| values transparent
% (whereas |imagesc| assigns the same color as the lowest value in the color axis), and is slightly
% easier to use than |imagesc|. 

%% Tutorials 
% 
% * How to import NetCDF data. 
% 
% * How to import HDF data. 
% 
% * How to save high-quality figures. 
% 
% * How to make a gif. 

