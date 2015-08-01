   clear;
    %name='som_vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1';
    dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1';
    name=['som_',dataname];

     if  ~exist([dataname,'/som_pattern_lag_',dataname,'.mat'],'file')
	   display([dataname,'/som_pattern_lag_',dataname,'.mat  file not exist'])
	   warning('file not exist')
	 %   load([name,'.mat']);
    	load([dataname,'/',name,'.mat']);

    %myRoot =dataname;
	%if ~isdir(myRoot) %
    	%mkdir(myRoot);
	%end
    
    
    	ssd=150;
    	yrStrt=1979;
   	yrEnd = 2010;
    
        
         K=20;
         p = 1:20;
         lagday=-12:12;
         
         count=zeros(length(lagday),length(p),K);
       for k=1:K
            for ip=1:length(p)  
              for ilagday=1:length(lagday)
                for i= max(1,-lagday(ilagday)+1):min(length(timeseies(:,3)),length(timeseies(:,3))-lagday(ilagday))			
    			 
			count(ilagday,ip,k)=count(ilagday,ip,k)+(timeseies(i,3)==k)...
                    *(timeseies(i+lagday(ilagday),3)==p(ip))*(timeseies(i,1)==timeseies(i+lagday(ilagday),1)); 
		end	
	       end
             end 
            end 
       
       %%
       pattern_evolution_lag=count;
       save([dataname,'/som_pattern_lag_',dataname,'.mat'],'pattern_evolution_lag','lagday');
       else
	display([dataname,'/som_pattern_lag_',dataname,'.mat   file exist'])
	warning('file exist, no calculation just plot')
	load([dataname,'/som_pattern_lag_',dataname,'.mat'])
 	end

	 K=20;
         p = 1:20;
         lagday=-12:12;
	 %temp modify plot
	%plot
	 for k=1:K
            for ip=1:length(p) 
		   for ilagday=1:length(lagday)
			  if lagday(ilagday)==0 
       				pattern_evolution_lag(ilagday,ip,k)=0;
			  end
		   end
	    end 
         end 


       nrow=4; ncolum=5;
	
    addoff_w=0.026251555;
    addoff_h=0.01;%-0.020251555%0.00010;
    width=(0.93)/ncolum; height=(1.0)/nrow;
	%nscale=0.2;
	%Paperwidth=(datalon(end)-datalon(1))*nscale
	%Paperheight=(datalat(end)-datalat(1))*nscale

    %cnint=30;
    plotdata= pattern_evolution_lag;
   % plotmax=ceil(max(abs(plotdata(:)))/cnint)*cnint;
    plotmax=max(plotdata(:));
    K=20;
     p=1:K;
%   [x,y]=meshgrid(lagday,p);
    x=lagday;
    y=p;
    figure;
	for j = 1:nrow*ncolum;       
    h= subplot('Position',[(mod(j-1,ncolum))*width+addoff_w (ncolum-ceil(j/ncolum)-1)*height+addoff_h width-addoff_w height-addoff_h]);
    imagesc(x,y,plotdata(:,:,j)');   
    
    %caxis([0 plotmax]);
%caxis([0 plotmax]);
    set(gca,'xlim',[min(lagday) max(lagday)],'ylim',[0.5,K+0.5],...
        'xtick',min(lagday):3:max(lagday),'xticklabel',min(lagday):3:max(lagday),'ytick',2:2:K,'yticklabel',2:2:K,'fontsize',12);
       axis square;
    text(double(min(lagday)),1.5,['(',num2str(j),')'],'fontsize',12);
    end
    
     color='MPL_PuRd.rgb'
     color=load(color);
     if max(color(:))>1
	     color=color/255;
     end
 colormap(color);
    hp4 = get(h,'Position');
    colorbar('Position', [hp4(1)+width-addoff_w+0.015  0.5-0.3  0.011  0.3*2],...%,...
  'Clim',[20 , plotmax],...
    'YTick',20:20:plotmax,'YTickLabel',20:20:plotmax,...
    'fontsize',12)

	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.005 0.999 0.994]);
	saveas(gcf,[dataname,'/pattern_lag_',dataname,'.pdf'],'pdf')


   
    
    
