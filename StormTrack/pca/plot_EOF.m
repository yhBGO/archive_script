addpath(genpath('~/workdata/third/'))
eof=ncread('~/eof_U/EOF_uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581.nc','eof');
lat=ncread('~/eof_U/EOF_uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581.nc','lat');
lon=ncread('EOF_uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581.nc','lon');

pcolor(lon,lat,squeeze(eof(:,:,1))')
shading interp;

color=load('MPL_PuOr.rgb');
if max(color)>1
color=color/max(color(:));
end 
colormap(color);
colorbar
caxis([-abs(max(eof(:))) abs(max(eof(:)))])

hold on;
a=load('coast');
plot(a.long,a.lat,'k');

var=ncread('~/w_extractdata_daily/uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581.nc','var');
var_org=ncread('~/w_extractdata_daily/uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_orginal.nc','var');
contour(meshgrid(lon,lat),var(:,:,1))
