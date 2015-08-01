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
        load([somdata,'/','lon_mean.mat'],'lon_phase_mean','lon_wave_max') 

%	p=1;
%	for p=1
	for p=1:20;

	  	Composdata=Composdata1;  
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
		datalonC=a.datalonC;

	for	lonRef_actral=[lon_wave_max(p)];	

	if ~isnan(lonRef_actral)

 	[m,index]=min(abs(datalonC-lonRef_actral));
	lonRef=datalonC(index);       	
	ind_lon=find(datalonC==lonRef);

	close;
	figure
		
%------------------------------------
         	Composdata=Composdata1;
         	cnintC=cnintC1;
         	linecolor=linecolor1;
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	ind_lat=find(a.datalonC==lonRef);	
         
         	datalatC=a.datalatC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalatC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(ind_lon,:,:,p));
         
         
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
         	ind_lat=find(a.datalonC==lonRef);	
         
         	datalatC=a.datalatC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalatC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(ind_lon,:,:,p));

         
         
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
         	%ind_lat=find(a.datalonC==lonRef);	
         
         	%datalatC=a.datalatC;
		%datalevelC=a.datalevelC;
         	%[xC,yC] = meshgrid(datalatC,datalevelC);
         	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                %plotdataC=squeeze(a.composition(ind_lon,:,:,p));
;
         
         
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
         	ind_lat=find(a.datalonC==lonRef);	
         
         	datalatC=a.datalatC;
		datalevelC=a.datalevelC;
         	[xC,yC] = meshgrid(datalatC,datalevelC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                plotdataC=squeeze(a.composition(ind_lon,:,:,p));
                        
         
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
         	%ind_lat=find(a.datalonC==lonRef);	
         
         	%datalatC=a.datalatC;
		%datalevelC=a.datalevelC;
         	%[xC,yC] = meshgrid(datalatC,datalevelC);
         	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                %plotdataC=squeeze(a.composition(ind_lon,:,:,p));                %
         
         
         	%hold on
         	%[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  %% clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	%hold on
         	%[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             	%hold on



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	set(gca, 'xlim', [min(xC(:)) max(xC(:))], 'ylim', [min(yC(:)) max(max(yC(:)))],...
      	'xtick',datalatC(1):30:datalatC(end),...
    	'xticklabel',datalatC(1):30:datalatC(end),...
    	'ytick',[0:100:1000 ],...
  	'yticklabel',[0:100:1000] ,...% num2str([100:150:850]') num2str(100:150:850) ,...
  	'YDir','reverse',... %'yscale','log',... 
   	'DataAspectRatio',[0.1 1 1], 'fontsize',20,'linewidth',2.0);

 
	text(double(min(xC(:))+1),double(max(yC(:))-50),['(',num2str(p),')','Lon= ',num2str(lonRef),'E'],'fontsize',25);
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

		if ~isdir([somdata,'/lon_Wmax_all_lat/'])
		mkdir([somdata,'/lon_Wmax_all_lat/'])
		end

% 	orient Landscape
% 	saveas(gcf,[somdata,'/lon_Wmax_all_lat/,'composition_',num2str(p),'_lon_',num2str(lonRef).pdf'],'pdf')
%	orient portrait
	saveas(gcf,[somdata,'/lon_Wmax_all_lat/','composition_',num2str(p),'_lon_',num2str(lonRef), '.eps'],'psc2')


end
end
end
%end
