clear all

	nrow=4, ncolum=5;  K=nrow*ncolum;	
     	addoff_w=0.026251555;
     	addoff_h=0;%0.1;%-0.020251555%0.00010;
     	width=(0.99)/ncolum; height=(0.99)/nrow;

	somdata=['vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1']

	Composdata1='air_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	Composdata2='hgt_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	Composdata3='uwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	Composdata4='w_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	Composdata5='vwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'

    	cnintC1=0.5%
	cnintC2=10%
	cnintC3=2%
	cnintC4=0.005%
	cnintC5=2 
	%color_plot=load('hotcold_18lev.rgb');%nrl_sirkes_nowhite%'sunshine_diff_12lev.rgb'%'MPL_PuOr.rgb';%BlWhRe.rgb %'MPL_PuOr.rgb'
	linecolor1='r'%[0.2,0.4,0.0];%green
	linecolor2='k'%[0.6,0.4,0.0];%gold
	linecolor3=[0.8,0.0,0.0];%'r'
	linecolor4=[0.2,0.2,0.8]%'b';%[0.6,0.0,0.4];%violet
	linecolor5=[0.0,0.0,0.8];%'b';

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%===============================================
        load([somdata,'/','lat_mean.mat'],'lat_north_mean','lat_south_mean') 

%	p=1;
%	for p=1
	for p=1:20;

	  	Composdata=Composdata1;  
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
		datalatC=a.datalatC;

	for	latRef_actral=[lat_north_mean(p),lat_south_mean(p)];	
	%latRef_actral=lat_south_mean(p);

	if ~isnan(latRef_actral)

 	[m,index]=min(abs(datalatC-latRef_actral));
	latRef=datalatC(index);       	
	ind_lat=find(datalatC==latRef);

	close;
	figure
		
%------------------------------------
         	Composdata=Composdata1;
         	cnintC=cnintC1;
         	linecolor=linecolor1;
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	ind_lat=find(a.datalatC==latRef);	
         
         	datalonC=a.datalonC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalonC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(:,ind_lat,:,p));
         
         
         	hold on
         	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  % clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	hold on
         	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	hold on
	

%%------------------------------------
      		Composdata=Composdata2;
         	cnintC=cnintC2;
         	linecolor=linecolor2;
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	ind_lat=find(a.datalatC==latRef);	
         
            
         	datalonC=a.datalonC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalonC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(:,ind_lat,:,p));
         
         
         	hold on
         	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  % clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	hold on
         	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	hold on


%%------------------------------------

      		%Composdata=Composdata3;
         	%cnintC=cnintC3;
         	%linecolor=linecolor3;
           	%a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	%ind_lat=find(a.datalatC==latRef);	
         
            
         	%datalonC=a.datalonC;
		%datalevelC=a.datalevelC;
         	%[xC,yC] = meshgrid(datalonC,datalevelC);
         	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                %plotdataC=squeeze(a.composition(:,ind_lat,:,p));
         
         
         	%hold on
         	%[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  %% clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	%hold on
         	%[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	%hold on


%------------------------------------
   
      		Composdata=Composdata4;
         	cnintC=cnintC4;
         	linecolor=linecolor4;
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	ind_lat=find(a.datalatC==latRef);	
         
            
         	datalonC=a.datalonC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalonC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(:,ind_lat,:,p));
         
         
         	hold on
         	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  % clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	hold on
         	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	hold on



%%------------------------------------

      		%Composdata=Composdata5;
         	%cnintC=cnintC5;
         	%linecolor=linecolor5;
           	%a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	%ind_lat=find(a.datalatC==latRef);	
         
            
         	%datalonC=a.datalonC;
		%datalevelC=a.datalevelC;
         	%[xC,yC] = meshgrid(datalonC,datalevelC);
         	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                %plotdataC=squeeze(a.composition(:,ind_lat,:,p));
         
         
         	%hold on
         	%[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  %% clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	%hold on
         	%[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	%hold on




	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	set(gca, 'xlim', [datalonC(1) datalonC(end)], 'ylim', [min(datalevelC) max(datalevelC)],...
      	'xtick',datalonC(1):30:datalonC(end),...
    	'xticklabel',datalonC(1):30:datalonC(end),...
    	'ytick',[0:100:1000 ],...
  	'yticklabel',[0:100:1000] ,...% num2str([100:150:850]') num2str(100:150:850) ,...
  	'YDir','reverse',... %'yscale','log',... 
   	'DataAspectRatio',[0.1 1 1], 'fontsize',20,'linewidth',2.0);

 
	text(double(min(xC(:))+1),double(max(yC(:))-50),['(',num2str(p),')','Lat= ',num2str(latRef),'N'],'fontsize',25);
	text(double(min(xC(:))+1),double(min(yC(:))+20),['(cint: ' ,'air ', num2str(cnintC1),'K | ','h ', num2str(cnintC2), 'm | ', '\omega ', num2str(cnintC4),'Pa/s )'],'fontsize',15);
%	text(double(min(xC(:))+1),double(min(yC(:))+30),['(cint: ' ,'air ', num2str(cnintC1),'K | ','h ', num2str(cnintC2), 'm  ',' )'],'fontsize',15);
%	text(double(min(xC(:))+1),double(min(yC(:))+30),['(cint: ', 'h ', num2str(cnintC2), 'm ', ')'],'fontsize',15);
	box on;

	%===============save fig===========================
	%set(gcf, 'PaperUnits', 'normal ');
 	%set(gcf, 'PaperPosition', [0 0 0.999 0.999]);
	set(gcf, 'Units', 'pixels');
	set(gcf, 'Papersize',[800,800])
 	set(gcf, 'Position', [0 0 800 800]);

		if ~isdir([somdata,'/vertical_all_lat/'])
		mkdir([somdata,'/vertical_all_lat/'])
		end

% 	orient Landscape
% 	saveas(gcf,[somdata,'/vertical_all_lat/,'composition_',num2str(p),'lat',num2str(latRef).pdf'],'pdf')
%	orient portrait
	saveas(gcf,[somdata,'/vertical_all_lat/','composition_',num2str(p),'lat',num2str(latRef), '.eps'],'psc2')


end
end
end
%end
