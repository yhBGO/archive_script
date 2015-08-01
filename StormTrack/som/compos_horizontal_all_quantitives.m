clear all

	nrow=4, ncolum=5;  K=nrow*ncolum;	
     	addoff_w=0.026251555;
     	addoff_h=0;%0.1;%-0.020251555%0.00010;
     	width=(0.93)/ncolum; height=(0.99)/nrow;

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
  
  	load coast;
	lat = [lat; NaN; lat];
	long = [long; NaN; long+360];
	coast_lat = lat;  coast_lon = long;
	clear lat long;

  	for	levelRef=1000%850%250%850
%for	levelRef=[250,500,850,1000]%500%250%850%850%500%250%1000%850%250%1000;%250;


%	p=1;
%	for p=1
	for p=1:20;
	close;
	figure
	
	plot(coast_lon, coast_lat, 'linewidth', 1.2, 'color', [0.6 0.6 0.6]);
	%patch(coast_lon,coast_lat,'g')


%-------------vectoor--------
	Composdata=Composdata5;
	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
	ind_level=find(a.datalevelC==levelRef);	
	plotdataC=a.composition(:,:,ind_level,p);
	v=plotdataC;

	Composdata=Composdata3;
	cnintC=cnintC3;
	linecolor=linecolor3;

  	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
	ind_level=find(a.datalevelC==levelRef);	
	datalonC=a.datalonC;
	datalatC=a.datalatC;
	[xC,yC] = meshgrid(datalonC,datalatC);
	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
       	plotdataC=a.composition(:,:,ind_level,p);

	u=plotdataC;

	myquiver(xC,yC,u',v','linecolor',[0.0,0.0,0.5],'fillcolor',[0.0,0.0,0.5],'width',1,'location',0.4,'arrowtype',0.75,'xref',double(min(datalonC)+1),'yref',double(min(datalatC)+7),'unit','m/s','length',5,'scale',0.5);
	%%quiver(xC,yC,u',v','color',[0.0,0.0,0.5],'linewidth',1.2);
	
%------------------------------------
         	Composdata=Composdata1;
         	cnintC=cnintC1;
         	linecolor=linecolor1;
           	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
         	ind_level=find(a.datalevelC==levelRef);	
         	datalonC=a.datalonC;
         	datalatC=a.datalatC;
         	[xC,yC] = meshgrid(datalonC,datalatC);
         	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
                	plotdataC=a.composition(:,:,ind_level,p);
         
         
         	hold on
         	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.0);     
         	  % clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
             	hold on
         	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.0);
         	   %clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
             hold on
	

%------------------------------------
	Composdata=Composdata2;
	cnintC=cnintC2;
	linecolor=linecolor2;

  	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
	ind_level=find(a.datalevelC==levelRef);	
	datalonC=a.datalonC;
	datalatC=a.datalatC;
	[xC,yC] = meshgrid(datalonC,datalatC);
	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
       	plotdataC=a.composition(:,:,ind_level,p);


	hold on
	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.5);%  
	%clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
    	hold on
	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.5);
	%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
	hold on


%%------------------------------------
   	%Composdata=Composdata3;
   	%cnintC=cnintC3;
   	%linecolor=linecolor3;
   
     	%a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
   	%ind_level=find(a.datalevelC==levelRef);	
   	%datalonC=a.datalonC;
   	%datalatC=a.datalatC;
   	%[xC,yC] = meshgrid(datalonC,datalatC);
   	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
          	%plotdataC=a.composition(:,:,ind_level,p);
   
   
   	%hold on
   	%plot(coast_lon, coast_lat, 'linewidth', 0.5, 'color', [0.8 0.8 0.8]);
   	%%patch(coast_lon,coast_lat,'g')
   	%[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.5);%  
   	%%clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
       	%hold on
   	%[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.5);
   	%%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
   	%hold on


%------------------------------------
   	%Composdata=Composdata4;
   	%cnintC=cnintC4;
   	%linecolor=linecolor4;
   
     	%a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
   	%ind_level=find(a.datalevelC==levelRef);	
   	%datalonC=a.datalonC;
   	%datalatC=a.datalatC;
   	%[xC,yC] = meshgrid(datalonC,datalatC);
   	%plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
          	%plotdataC=a.composition(:,:,ind_level,p);
   
   
   	%hold on
   	%[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',1.75);%  
   	%%clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
       	%hold on
   	%[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',1.75);
   	%%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
   	%hold on



%%------------------------------------
%   	Composdata=Composdata5;
%   	cnintC=cnintC5;
%   	linecolor=linecolor5;
%   
%     	a= load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat']);
%   	ind_level=find(a.datalevelC==levelRef);	
%   	datalonC=a.datalonC;
%   	datalatC=a.datalatC;
%   	[xC,yC] = meshgrid(datalonC,datalatC);
%   	plotmaxC=ceil(max(abs(a.composition(:)))/cnintC)*cnintC;
%          	plotdataC=a.composition(:,:,ind_level,p);
%   
%   	hold on
%   	[C_n,h_n]=contour(xC,yC,plotdataC',-plotmaxC:cnintC:-cnintC,'LineStyle','--','color',linecolor,'linewidth',2.5);%  
%   	%clabel(C_n,h_n,'FontSize',10,'Color','k','Rotation',0)
%       	hold on
%   	[C_p,h_p]=contour(xC,yC,plotdataC',cnintC:cnintC:plotmaxC,'linestyle','-','color',linecolor,'linewidth',2.5);
%   	%clabel(C_p,h_p,'FontSize',10,'Color','k','Rotation',0)
%   	hold on




	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	set(gca, 'xlim', [datalonC(1) datalonC(end)], 'ylim', [min(datalatC) max(datalatC)],...
      	'xtick',datalonC(1):30:datalonC(end),...
    	'xticklabel',datalonC(1):30:datalonC(end),...
	'ytick',[datalatC(1):30:datalatC(end) ],...
	'yticklabel',[datalatC(1):30:datalatC(end)] ,...% num2str([100:150:850]') num2str(100:150:850) ,...
    	'fontsize',20,	'DataAspectRatio',[1,1,1],'linewidth',2.0)
 
	text(double(min(datalonC)+1),double(max(datalatC)-3),['(',num2str(p),')','lev: ',num2str(levelRef),'hPa'],'fontsize',25);
%	text(double(min(datalonC)+1),double(min(datalatC)+3),['(cint: ' ,'air ', num2str(cnintC1),'K | ','h ', num2str(cnintC2), 'm | ', '\omega ', num2str(cnintC4),'Pa/s )'],'fontsize',15);
	text(double(min(datalonC)+1),double(min(datalatC)+3),['(cint: ' ,'air ', num2str(cnintC1),'K | ','h ', num2str(cnintC2), 'm  ',' )'],'fontsize',15);
%	text(double(min(datalonC)+1),double(min(datalatC)+3),['(cint: ', 'h ', num2str(cnintC2), 'm ', ')'],'fontsize',15);
	box on;

	%===============save fig===========================
	%set(gcf, 'PaperUnits', 'normal ');
 	%set(gcf, 'PaperPosition', [0 0 0.999 0.999]);
	set(gcf, 'Units', 'pixels');
	set(gcf, 'Papersize',[800,800])
 	set(gcf, 'Position', [0 0 800 800]);

		if ~isdir([somdata,'/horizontal_h_t_v850/'])
		mkdir([somdata,'/horizontal_h_t_v850/'])
		end

% 	orient Landscape
% 	saveas(gcf,[somdata,'/horizontal_h_t_v850/lev',num2str(levelRef),'composition_',num2str(p), '.pdf'],'pdf')
%	orient portrait
	saveas(gcf,[somdata,'/horizontal_h_t_v850/lev',num2str(levelRef),'composition_',num2str(p), '.eps'],'psc2')


end
end
