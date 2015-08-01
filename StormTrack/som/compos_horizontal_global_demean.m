	clear all

        somdata=['vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1']
	levelS=250;
    
       %% composition of other quantities
       %Composdata='vwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
       %Composdata='vwnd_NDJFM_lev1000-10_lat0-90_lon0-360_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
       %Composdata =['uwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-']
       Composdata='uwnd_NDJFM_lev1000-10_lat-90-90_lon0-360_year1979-2010_original';
       %Composdatadir= '../data_preprocess/data_to_analyze/'
        Composdatadir='../../data_for_huangy/derived/'
     %varnameC	= [VarCompo,'_GDS0_ISBL']
     %vardatenameC = 'time_YYYYMMDD'
     %latnameC =     'g0_lat_2'
     %lonnameC =     'g0_lon_3'
     %levelnameC =   'lv_ISBL1'
    
     varnameC = 'var' 
     vardatenameC = 'time_yyyymmdd'
     latnameC =     'lat'
     lonnameC =     'lon'
     levelnameC =   'level'
     
 
     %subplot settings
     K=20;
     nrow=4, ncolum=5;	
     addoff_w=0.026251555;
     addoff_h=0;%0.1;%-0.020251555%0.00010;
     width=(0.93)/ncolum; height=(0.99)/nrow;

     cnintC=4;%2;
     cnintS=2;

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%===============================================
     load([somdata,'/som_',somdata,'.mat'])
     somdatalat=datalat;
     somdatalon=datalon;


    %------------------------------------------- 

     fC 	= [Composdatadir,Composdata,'.nc']

     time_YYYYMMDDC= ncread(fC,vardatenameC);
     datalonC	= ncread(fC,lonnameC);
     datalatC	= ncread(fC,latnameC);
     datalevelC = ncread(fC,levelnameC);
     dataC         = ncread(fC,varnameC);

    datalonC=datalonC(1:73);
    datalatC=datalatC(37:end);
    datalevelC=datalevelC;
    dataC=dataC(1:73,37:end,:,:);
    dataC=dataC-repmat(mean(dataC,4),[1,1,1,size(dataC,4)]);

    disp(['to composite file max',num2str(max(dataC(:))) ]) 
    disp(['to composite file min',num2str(min(dataC(:))) ])
    

    nlon = length(datalonC); % length of latitude
    nlat = length(datalatC); % length of longitude
    nlevel=length(datalevelC);%length of level
	
    	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	datalonC=datalonC(find(datalonC==20):find(datalonC==130));
%	dataC=dataC(find(datalonC==20):find(datalonC==130),:,:,:);	

	
	%calculation compostion
	
	if ~isdir(['./',somdata,'/',Composdata])
		mkdir(['./',somdata,'/',Composdata])
	end

	if ~exist([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat'],'file')

    	for p = 1:K
      	% count frequncy of each pattern in early or late winter
    	ind = find(timeseies(:,3) == p);
	%composition	
	composition(:,:,:,p) = squeeze(mean(dataC(:,:,:,ind),4));
    	end

	pattern_num = 1:K;

	save([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat'],'composition','datalonC','datalatC','datalevelC','pattern_num','Composdata','somdata')
	else

	load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat'])
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%lon-lat plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	composition_org=composition; % the loaded data
	clear composition;

	%calculation
        for levelRef=[50,250,300,100,400,500,600,700,850]% 250 200;850,50,10

	close;
	
	ind_level=find(datalevelC==levelRef);

	for p = 1:K
      	% count frequncy of each pattern in early or late winter
    	ind = find(timeseies(:,3) == p);
	%composition		
	composition(:,:,p) = squeeze(mean(composition_org(:,:,ind_level,p),4));
    	end


	%plot 
	load coast;
	lat = [lat; NaN; lat];
	long = [long; NaN; long+360];
	coast_lat = lat;  coast_lon = long;
	clear lat long;

	clear p
	%%plot  
	[xC,yC] = meshgrid(datalonC,datalatC);
        [xS,yS] = meshgrid(somdatalon,somdatalat);

	cnintC=cnintC;
        plotmaxC=ceil(max(abs(composition_org(:)))/cnintC)*cnintC;

	cnintS=cnintS;
        plotmaxS=ceil(max(abs(Map_cluster(:)))/cnintS)*cnintS;
	   
	for p = 1:nrow*ncolum
            
    	h= subplot('Position',[(mod(p-1,ncolum))*width+addoff_w (ncolum-ceil(p/ncolum)-1)*height+addoff_h width-addoff_w height]);


    critical_value=max(Map_cluster(:))/5;
    [pattern_max,imax]=extrema2(abs(squeeze(Map_cluster(:,:,p))));
    [iimax,ijmax]=ind2sub(size(squeeze(Map_cluster(:,:,p))),imax);
    ilon=datalon(ijmax(pattern_max>critical_value));
    ilat=datalat(iimax(pattern_max>critical_value));

    ilat((ilon==datalon(1))|(ilon==datalon(end)))=[];
    ilon((ilon==datalon(1))|(ilon==datalon(end)))=[];

    ilon((ilat==datalat(1))|(ilat==datalat(end)))=[];
    ilat((ilat==datalat(1))|(ilat==datalat(end)))=[];

    
    [x_point,index]=sort(ilon);
    y_point=ilat(index);
   
%*************************************************************



	plotdataC=composition(:,:,p);
	plotdataS=Map_cluster(:,:,p);

	 contourf(xC,yC,plotdataC',-plotmaxC:cnintC:plotmaxC,'LineStyle','none')%,'linestyle','--','linecolor','b','linewidth',1);  
    	hold on
    	caxis( [-plotmaxC,plotmaxC])

	 contour(xS,yS,plotdataS,cnintS:cnintS:plotmaxS,'linestyle','-','linecolor','r')
    	 hold on; 
    	 contour(xS,yS,plotdataS,-plotmaxS:cnintS:-cnintS,'linestyle','--','linecolor','b')


   	plot(coast_lon, coast_lat, 'linewidth', 0.5, 'color', [0.2 0.2 0.2]);

	set(gca, 'xlim', [datalonC(1) datalonC(end)], 'ylim', [datalatC(1) datalatC(end)],'ytick',datalatC(1):20:datalatC(end),...
	'yticklabel',datalatC(1):20:datalatC(end),...
	'xtick',datalonC(1):60:datalonC(end),'xticklabel',...
	datalonC(1):60:datalonC(end),'fontsize',8);
	set(gca,'DataAspectRatio',[1*(max(datalonC)-min(datalonC))/(255-150),1,1])

     	hold on

	plot([min(somdatalon) max(somdatalon) max(somdatalon) min(somdatalon) min(somdatalon)], [min(somdatalat) min(somdatalat) max(somdatalat) max(somdatalat) min(somdatalat)], 'linewidth',1.5,'color','c', 'linewidth', 1);

	plot(ilon,ilat,'k*');
	text (double(min(datalonC)+1),double(max(datalat)+5),['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%'],'fontsize',9)
    	text(double(min(datalonC)+(max(datalonC)-min(datalonC))/2.0),double(max(datalat)+5),['lev:',num2str(levelS),'/',num2str(levelRef)],'fontsize',9)
%	text(double(max(datalonC)-(max(datalonC)-min(datalonC))/10.0)),double(max(datalat)+5),['cn: ',num2str(cnintS),'m/s'],'fontsize',9)

    	hold off	
	end


	hp4 = get(h,'Position');
	 %load BlWhRe.rgb
 	%BlWhRe=BlWhRe/255;
	color_plot=load('MPL_PuOr.rgb')%load('BlWhRe.rgb');%'MPL_PuOr.rgb'
	if max(color_plot(:))>1.1
		color_plot=color_plot/255;
	end

     	colormap(color_plot); 

	colorbar('Position', [hp4(1)+width-addoff_w+0.0151  0.5-0.4  0.011  0.4*2],...
    ... %'Clim',[-plotmaxC , plotmaxC],...
    'YTick',-plotmaxC:cnintC:plotmaxC,'YTickLabel',-plotmaxC:cnintC:plotmaxC,...
     'fontsize',10)
     caxis([-plotmaxC , plotmaxC])
 
  %  colorbar('direction','reverse')

   %clb=	colorbar('Position', [ 0.5-0.4 hp4(2)-0.1  0.4*2 0.051],...
    %'Clim',[-plotmaxC , plotmaxC],...
    %'fontsize',10,'location','southoutside')
%%    set(clb,'Position', [ 0.5-0.4 hp4(2)-0.05  0.4*2 0.0151],'XTick',-plotmaxC:cnintC:plotmaxC,'XTickLabel',-plotmaxC:cnintC:plotmaxC)


%======save figure============================

 figname=['lev_',num2str(levelRef),'Compos_',Composdata,'_base_SOM_',somdata]
 figdir= Composdata
 
  if ~isdir([somdata,'/',figdir])
	 mkdir([somdata,'/',figdir])
  end
 set(gcf, 'PaperUnits', 'normal ');
 orient Landscape
 set(gcf, 'PaperPosition', [0 0 0.999 0.999]);
% saveas(gcf,['1.pdf'],'pdf')
 eval(['cd ' somdata,'/',Composdata,'/'])
 saveas(gcf,[figname, '.pdf'],'pdf')
 cd ../..
 
 end

 
