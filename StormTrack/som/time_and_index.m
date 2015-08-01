    clear;
    dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon-90-50_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon120-255_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon-90-80_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
   % dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
   %  dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon120-255_year1979-2010M11D151'
   %dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'
   %dataname='V_GDS0_ISBL_lev250_lat0-87_lon20-130_year1979-2010M11D151daily_anomalies'
   %dataname='V_GDS0_ISBL_lev250_lat0-90_lon120-255_year1979-2010M11D151fft_2-8days'
   %dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
    name=['som_',dataname];
    
    load([dataname,'/',name,'.mat'])

  N=30;
  D=30;
  J=30;
  F=30;
  M=30;

  %N=30;
  %D=31;
  %J=31;
  %F=28;
  %M=31;


  ssd=N+D+J+F+M;
  month=['N','D','J','F','M']
  month_day=[N,D,J,F,M]
  

      
  yr=min(timeseies(:,1)):max(timeseies(:,1));
  K=20;
  
  if ~(length(find((timeseies(:,1)==min(yr))))==ssd)
      error('Check season day input')
      break
  end
  
  count_year=nan(length(yr),K);
  for p=1:K;
      for i=1:length(yr);
      count_year(i,p)...
          =length(find((timeseies(:,1)==yr(i)).*(timeseies(:,3)==p)));
      end
  end
 
 	if ~isdir([dataname,'/index_and_timeseies'])
		mkdir([dataname,'/index_and_timeseies'])
	end
%%plot 
  
    	north_pattern=[1,14,13,17,5,18];
	count_year_north=mean(count_year(:,north_pattern),2);
	figure;
		
	plot(yr(1:end-1),count_year_north(1:end-1),'linewidth',2,'linestyle','-');
		hold on;
		plot(yr(1:end-1),count_year_north(1:end-1),'linewidth',2,'linestyle','*');

    	set(gca,'xlim',[min(yr)-0.5 max(yr)-0.5],'ylim',[0,max(count_year(:))],...
        'xtick',(min(yr)+1:10:max(yr)),'xticklabel',(min(yr)+1:10:max(yr)),'ytick',0:5:max(count_year(:)),'yticklabel',0:5:max(count_year(:)),'fontsize',18);
       	axis square;
       	hold on
       	plot((((min(yr)+1:10:max(yr)))'*ones(size([0,max(count_year(:))])))',(ones(size(((min(yr)+1:10:max(yr)))))'*[0,max(count_year(:))])','r');
       
        ticks=get(gca,'xtick');
		text(double(max(yr))-3,max(count_year(:))-1.5,['Northern Branch'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');
	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
%	saveas(gcf,[dataname,'/index_and_timeseies/year_north_som_','.pdf'],'pdf')
	saveas(gcf,[dataname,'/index_and_timeseies/year_north_som_','.eps'],'psc2')

    %----------------
     	south_pattern=[20,11,3,9,15];
	count_year_south=mean(count_year(:,south_pattern),2);
	figure;
		
	plot(yr(1:end-1),count_year_south(1:end-1),'linewidth',2,'linestyle','-');
		hold on;
		plot(yr(1:end-1),count_year_south(1:end-1),'linewidth',2,'linestyle','*');

    	set(gca,'xlim',[min(yr)-0.5 max(yr)-0.5],'ylim',[0,max(count_year(:))],...
        'xtick',(min(yr)+1:10:max(yr)),'xticklabel',(min(yr)+1:10:max(yr)),'ytick',0:5:max(count_year(:)),'yticklabel',0:5:max(count_year(:)),'fontsize',18);
       	axis square;
       	hold on
       	plot((((min(yr)+1:10:max(yr)))'*ones(size([0,max(count_year(:))])))',(ones(size(((min(yr)+1:10:max(yr)))))'*[0,max(count_year(:))])','r');
       

        ticks=get(gca,'xtick');
	text(double(max(yr))-3,max(count_year(:))-1.5,['Southern Branch'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');
	
	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
%	saveas(gcf,[dataname,'/index_and_timeseies/year_south_som_','.pdf'],'pdf')
	saveas(gcf,[dataname,'/index_and_timeseies/year_south_som_','.eps'],'psc2')

   %----------------- 
  	loop_north_double=[4,2,6,14,13,18,7];
	count_year_north_double=mean(count_year(:,loop_north_double),2);
	figure;
		
	plot(yr(1:end-1),count_year_north_double(1:end-1),'linewidth',2,'linestyle','-')
		hold on;
		plot(yr(1:end-1),count_year_north_double(1:end-1),'linewidth',2,'linestyle','*')

    	set(gca,'xlim',[min(yr)-0.5 max(yr)-0.5],'ylim',[0,max(count_year(:))],...
        'xtick',(min(yr)+1:10:max(yr)),'xticklabel',(min(yr)+1:10:max(yr)),'ytick',0:5:max(count_year(:)),'yticklabel',0:5:max(count_year(:)),'fontsize',18);
       	axis square;
       	hold on
       	plot((((min(yr)+1:10:max(yr)))'*ones(size([0,max(count_year(:))])))',(ones(size(((min(yr)+1:10:max(yr)))))'*[0,max(count_year(:))])','r');
       
        ticks=get(gca,'xtick');
		text(double(max(yr))-3,max(count_year(:))-1.5,['Northern-Double-Northern'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');

	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	%saveas(gcf,[dataname,'/index_and_timeseies/year_north_to_double_som_','.pdf'],'pdf')
	saveas(gcf,[dataname,'/index_and_timeseies/year_north_to_double_som_','.eps'],'psc2')

 %----------------- 
  	chain_double=[19,10,8,12,16];
	count_year_double=mean(count_year(:,chain_double),2);
	figure;
		
	    plot(yr(1:end-1),count_year_double(1:end-1),'linewidth',2,'linestyle','-')
		hold on
		plot(yr(1:end-1),count_year_double(1:end-1),'linewidth',2,'linestyle','*')
    	set(gca,'xlim',[min(yr)-0.5 max(yr)-0.5],'ylim',[0,max(count_year(:))],...
        'xtick',(min(yr)+1:10:max(yr)),'xticklabel',(min(yr)+1:10:max(yr)),'ytick',0:5:max(count_year(:)),'yticklabel',0:5:max(count_year(:)),'fontsize',18);
       	axis square;
       	hold on
       	plot((((min(yr)+1:10:max(yr)))'*ones(size([0,max(count_year(:))])))',(ones(size(((min(yr)+1:10:max(yr)))))'*[0,max(count_year(:))])','r');
       
        ticks=get(gca,'xtick');
	text(double(max(yr))-3,max(count_year(:))-1.5,['Double'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');

		set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/index_and_timeseies/year_double_','.eps'],'psc2')

%---------------
    
	%break

	%set(gcf, 'PaperUnits', 'normal ');
	%orient Landscape
 	%set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	%saveas(gcf,[dataname,'/index_and_timeseies_year_som_',dataname,'.pdf'],'pdf')

	
  %% month

    date_num_of_season =((1:length(timeseies(:,2)))'.*(timeseies(:,3)~=0));
    date_num_of_season(date_num_of_season==0)=[];
    date_num_of_season= mod(date_num_of_season,ssd);
    date_num_of_season(find(date_num_of_season==0))=ssd;
    nyear=length(date_num_of_season)/ssd;

   count_m_freq=zeros(length(month),K);
   for p=1:K;

        ind = find(timeseies(:,3) == p);
       for i=1:length(month);
	% count frequncy of each pattern in early or late winter
 

	if i>=2
    	count_m_freq(i,p) = length(find((date_num_of_season(ind)<= sum(month_day(1:i))).* (date_num_of_season(ind)>sum(month_day(1:i-1)) )))/(month_day(i)*nyear) ;
        end
	
	if i==1
	count_m_freq(i,p) = length(find(date_num_of_season(ind)<= sum(month_day(1:i))))/(month_day(1:i)*nyear);	
	end
	
	end	
   end
 

%%plot  month
    
    figure;
	count_m_freq_north=mean(count_m_freq(:,north_pattern),2);

	bar(1:length(month),count_m_freq_north,1,'r')
    	set(gca,'xlim',[1-0.5 length(month)+0.5],'ylim',[0,max(count_m_freq(:))],...
        'xtick',1:length(month),'xticklabel',{month(:)},'ytick',0:0.01:max(count_m_freq(:)),'yticklabel',0:0.01:max(count_m_freq(:)),'fontsize',18);
       axis square;
       hold on
         ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(length(month)-1),max(count_m_freq(:))-0.005,['Northern Branch'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');

   	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/index_and_timeseies/month_north_som_','.eps'],'psc2')
   

    %------------
    figure;

        count_m_freq_south=mean(count_m_freq(:,south_pattern),2);
      	bar(1:length(month),count_m_freq_south,1,'r')
    	set(gca,'xlim',[1-0.5 length(month)+0.5],'ylim',[0,max(count_m_freq(:))],...
        'xtick',1:length(month),'xticklabel',{month(:)},'ytick',0:0.01:max(count_m_freq(:)),'yticklabel',0:0.01:max(count_m_freq(:)),'fontsize',18);
       axis square;
       hold on
         ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(length(month)-1),max(count_m_freq(:))-0.005,['Southern Branch'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');
    	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
%	saveas(gcf,[dataname,'/index_and_timeseies/month_south_som_','.pdf'],'pdf')
	saveas(gcf,[dataname,'/index_and_timeseies/month_south_som_','.eps'],'psc2')
    
%---------------
    figure;

       count_m_freq_north_double=mean(count_m_freq(:,loop_north_double),2);
      	bar(1:length(month),count_m_freq_north_double,1,'r')
    	set(gca,'xlim',[1-0.5 length(month)+0.5],'ylim',[0,max(count_m_freq(:))],...
        'xtick',1:length(month),'xticklabel',{month(:)},'ytick',0:0.01:max(count_m_freq(:)),'yticklabel',0:0.01:max(count_m_freq(:)),'fontsize',18);
       axis square;
       hold on
         ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(length(month)-1),max(count_m_freq(:))-0.005,['Northern-Double-Northern'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');
    	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/index_and_timeseies/month_north_double_som_','.eps'],'psc2')
    %---------------
     figure;

        count_m_freq_double=mean(count_m_freq(:,chain_double),2);
		bar(1:length(month),count_m_freq_double,1,'r')
      	%bar(1:length(month),count_m_freq_double,1,'r')
    	set(gca,'xlim',[1-0.5 length(month)+0.5],'ylim',[0,max(count_m_freq(:))],...
        'xtick',1:length(month),'xticklabel',{month(:)},'ytick',0:0.01:max(count_m_freq(:)),'yticklabel',0:0.01:max(count_m_freq(:)),'fontsize',18);
       axis square;
       hold on
         ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(length(month)-1),max(count_m_freq(:))-0.005,['Double'],'fontsize',18,'rotation',0,'HorizontalAlignment','right');
    	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/index_and_timeseies/month_double_som_','.eps'],'psc2')
    %---------------

   

 
	%set(gcf, 'PaperUnits', 'normal ');
	%orient Landscape
 	%set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	%saveas(gcf,[dataname,'/index_timeseies_seasonal_som_',dataname,'.pdf'],'pdf')

      %save([dataname,'/choose_timeseies_som_',dataname,'.mat'],'count_year','count_m_freq');
