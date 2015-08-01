	clear
	somdata=['vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1']
	Composdata='air_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	%Composdata='hgt_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	%Composdata='uwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	%Composdata='w_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	%Composdata='vwnd_NDJFM_lev1000-10_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
	
	load([somdata,'/som_',somdata,'.mat'])
	load([somdata,'/',Composdata,'/Cps_',Composdata,'_on_S_',somdata,'.mat'])

 
     	%subplot settings
     	nrow=4, ncolum=5;  K=nrow*ncolum;	
     	addoff_w=0.026251555;
     	addoff_h=0;%0.1;%-0.020251555%0.00010;
     	width=(0.93)/ncolum; height=(0.99)/nrow;

     	cnintC=0.2%10%2;%0.002%2; 
		color_plot=load('hotcold_18lev.rgb');%nrl_sirkes_nowhite%'sunshine_diff_12lev.rgb'%'MPL_PuOr.rgb';%BlWhRe.rgb %'MPL_PuOr.rgb'

	
	%%plot  
	[xC,yC] = meshgrid(datalonC,datalevelC);

	composition_org=composition; % the loaded data 
	clear composition;
	
	cnintC=cnintC;
        plotmaxC=ceil(max(abs(composition_org(:)))/cnintC)*cnintC;

	for p = 1:nrow*ncolum  
	close;

	% extrema and choose lat belt
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

    	st_num=ones(1,length(x_point)); %flag , the number of wave guide
    	k=2;
    	split_judge=10; % larger than 10 degree means split
    	
	for i=2:length(x_point);
        if y_point(i)-y_point(i-1)>split_judge;
            st_num(i)=st_num(i-1)+1;%st_num(i-1)+1
        end
        if y_point(i)-y_point(i-1)<-split_judge;
            st_num(i)=st_num(i-1)-1;
        end
        if abs(y_point(i)-y_point(i-1))<=split_judge;
            st_num(i)=st_num(i-1);
        end
    	end
    
    	track_we_x=datalon;
    	track_we_y=nan(max(st_num)-min(st_num)+1,length(datalon));%west-east
    	for i=min(st_num):max(st_num) %  st_num, number of the splited(merged) wave train
    	track_we_y(i-min(st_num)+1,:)=mean(y_point(st_num==i)).*ones(1,length(datalon));
    	%track_we_y(2,:)=mean(y_point(st_num==2)).*ones(1,length(datalon)); %2 chosen lat 
	latRef_actral(i-min(st_num)+1)=mean(y_point(st_num==i))

	for i = 1:length(latRef_actral)
	if ~isnan(latRef_actral)
	[m,index]=min(abs(datalatC-latRef_actral(i)));
	latRef=datalatC(index);       	
	ind_lat=find(datalatC==latRef);
%*************************************************************
	%composition		
	composition(:,:,p) = squeeze(mean(composition_org(:,ind_lat,:,p),4));
    
%**************************************************************
	%for p = 1:nrow*ncolum            
  %  	h= subplot('Position',[(mod(p-1,ncolum))*width+addoff_w (ncolum-ceil(p/ncolum)-1)*height+addoff_h width-addoff_w height]);
	
	plotdataC=composition(:,:,p);
	contourf(xC,yC,plotdataC',-plotmaxC:cnintC:plotmaxC,'LineStyle','none')%,'linestyle','--','linecolor','b','linewidth',1);  
    	hold on
    	caxis( [-plotmaxC,plotmaxC])
    	hold on

	 set(gca, 'xlim', [datalonC(1) datalonC(end)], 'ylim', [min(datalevelC) max(datalevelC)],...
      	'xtick',datalonC(1):30:datalonC(end),...
    	'xticklabel',datalonC(1):30:datalonC(end),...
    	'ytick',[0:100:1000 ],...
  	'yticklabel',[0:100:1000] ,...% num2str([100:150:850]') num2str(100:150:850) ,...
  	'YDir','reverse',... %'yscale','log',...
   	'DataAspectRatio',[0.1 1 1], 'fontsize',8);

 %   	text (min(xC)+3,max(yC)+2,['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%','|ND',sprintf('%3.1f',100*pat_f_ND(p)),'%|','FM',sprintf('%3.1f',100*pat_f_FM(p)),'%',],'fontsize',9)
    	title(['(',num2str(p),')     ','Lat=',num2str(latRef)],'fontsize',16)
    	hold off


	%color bar
%	hp4 = get(h,'Position');
	if max(color_plot(:))>1.1
		color_plot=color_plot/255;
	end
    colormap(color_plot); 
%	colorbar('Position', [hp4(1)+width-addoff_w+0.0151  0.5-0.4  0.011  0.4*2],...
	colorbar(...
    'Clim',[-plotmaxC , plotmaxC],...
    'YTick',-plotmaxC:cnintC:plotmaxC,'YTickLabel',-plotmaxC:cnintC:plotmaxC,...
     'fontsize',10)

%======save figure============================
 figdir= Composdata
 
  if ~isdir(figdir)
	 mkdir(figdir)
  end

 figname=[num2str(p),'lat_',num2str(latRef),'Compos_',Composdata,'_base_SOM_',somdata]

 set(gcf, 'PaperUnits', 'normal ');
 orient Landscape
 set(gcf, 'PaperPosition', [0 0 0.999 0.999]);
 eval(['cd ' somdata,'/',Composdata,'/'])
 saveas(gcf,[figname, '.pdf'],'pdf')
 cd ../..

 end
 end 
 end
 end



