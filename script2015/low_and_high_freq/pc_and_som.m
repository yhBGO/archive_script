eofdir='~/eof_U/';
pc = ncread([eofdir,'EOF_uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581.nc'],'eof_ts_nor');
pc1=pc(:,1);

somdir='~/som/';
somdata='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1/';
load([somdir,somdata,'som_vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1','.mat']);


figure;
plot(pc1,'k-')
hold on;
plot(find(timeseies(:,3)==20),pc1(find(timeseies(:,3)==20)),'b.')
hold on;
plot(find(timeseies(:,3)==15),pc1(find(timeseies(:,3)==15)),'r.')
legend('pc1','pattern 20', 'pattern 15');
daspect([250,1,1]);
xlim([0 length(timeseies(:,3))])
ylim([-max(abs(pc1)), max(abs(pc1))])
set(gca,'xticklabel',1979:5:2009,'xtick',((1979:5:2009)-1979)*150+1);

for i =1:20;
r(i)= mean(pc1(find(timeseies(:,3)==i)));
end
