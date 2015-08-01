   clear;
    %name='som_vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1';
    dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1';
    name=['som_',dataname];

     if  ~exist([dataname,'/transition_',dataname,'.mat'],'file')
	   display([dataname,'/transition_',dataname,'.mat  file not exist'])
	   warning('file not exist')
	%load([name,'.mat']);
    	load([dataname,'/',name,'.mat']);

    	%myRoot =dataname;
	%if ~isdir(myRoot) %
    	%mkdir(myRoot);
	%end
    
    
    	ssd=150;
    	yrStrt=1979;
	yrEnd = 2010;
    
        
        K=20;
	
                
        count=zeros(K,K);
	lagday = 1
       
	for k=1:K
            for p=1:K 
              for ilagday=1:length(lagday)
                for i= max(1,-lagday(ilagday)+1):min(length(timeseies(:,3)),length(timeseies(:,3))-lagday(ilagday))			
    			 
		count(p,k)=count(p,k)+(timeseies(i,3)==k)...
                    *(timeseies(i+lagday,3)==p)*(timeseies(i,1)==timeseies(i+lagday,1)); 
		end	
	   end
         end 
	end 
       
       %%
       pattern_transition=count;
	pattern_number=1:K;
       save([dataname,'/transition_',dataname,'.mat'],'pattern_transition','pattern_number');
       else
	display([dataname,'/transition_',dataname,'.mat   file exist'])
	warning('file exist, no calculation just plot')
	load([dataname,'/transition_',dataname,'.mat'])
 	end

	%========plot==========

    	plotdata= pattern_transition;
   	%plotmax=ceil(max(abs(plotdata(:)))/cnint)*cnint;
    	plotmax=max(plotdata(:));
    
    	figure;
    
     	color='MPL_PuRd.rgb';
     	color=load(color);
     	if max(color(:))>1
	     color=color/255;
     	end
	MPL_PuRd=color;
	labels=1:1:20;%20;%num2str(pattern_number);
	heatmap(plotdata,labels,labels,'%3d','GridLines',':','TextColor','b','fontsize',8);%,'Colormap','copper')%,'ShowAllTicks',true)
        colormap(color)
	set(gca,'fontsize',14);
	xlabel('Pattern Number (Lag Day = 0)','fontsize',14);
	ylabel('Pattern Number (Lag Day = +1)','fontsize',14);

	%colormap(color);
    	%hp4 = get(h,'Position');
    	%colorbar('Position', [hp4(1)+width-addoff_w+0.015  0.5-0.3  0.011  0.3*2],...%,...
  	%'Clim',[20 , plotmax],...
    	%'YTick',20:20:plotmax,'YTickLabel',20:20:plotmax,...
    	%'fontsize',12)
    
    


	%set(gcf, 'PaperUnits', 'normal ');
	%set(gcf, 'Papersize',[1,1])
	%orient portrait
 	%set(gcf, 'PaperPosition', [0 0 0.999 0.999]);
	%saveas(gcf,[dataname,'/transition_',dataname,'.pdf'],'pdf')

	set(gcf, 'Units', 'pixels');
	set(gcf, 'Papersize',[800,800])
 	set(gcf, 'Position', [3 3 797 797]);
	saveas(gcf,[dataname,'/transition_',dataname,'.eps'],'psc2')


   
    
    
