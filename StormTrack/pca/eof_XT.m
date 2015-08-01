%%

dir='../../data_for_huangy/derived'
filename='uwnd_NDJFM_lev1000-10_lat-90-90_lon0-360_year1979-2010_original';
namestring=[dir,'/',filename,'.nc'];

ncdisp(namestring)
var=ncread(namestring,'var');
level=ncread(namestring,'level');
lat=ncread(namestring,'lat');
lon=ncread(namestring,'lon');
time=ncread(namestring,'time');

disp('read data finished')


strings= regexp(filename, '_', 'split')
varinfo=[strings(1),strings(2),strings(end)];

lonL=20;
lonR=130;
latS=0;
latN=90;
levelT=100;
levelB=1000;

var=var(find(lon==lonL):find(lon==lonR),find(lat==latS):find(lat==latN),find(level==levelB):find(level==levelT),:);
lon=lon(find(lon==lonL):find(lon==lonR));
lat=lat(find(lat==latS):find(lat==latN));
level=level(find(level==levelB):find(level==levelT));

levstring=['lev',num2str(levelB),'-',num2str(levelT)];
latstring=['lat',num2str(latS),'_',num2str(latN)];
lonstring=['lon',num2str(lonL),'_',num2str(lonR)];


save(strcat(varinfo{1},'_',varinfo{2},'_',levstring,'_',latstring,'_',lonstring,'_',varinfo{end},'.mat'),'var','lon','lat','level');


%%
load  uwnd_NDJFM_lev1000-100_lat0_90_lon20_130_original.mat
y=reshape(squeeze(mean(var,1)),length(lat)*length(level),length(time));
y=y';

nt=length(time);
nx=length(lat)*length(lat);
% ---EOF---
nmode = 6; % Maximun EOF number

covy = y'*y/(nt-1);
covy=double(covy);
[eof,latent] = eigs(covy,nmode); 
pc = y*eof;
totalvar = sum(y(:)'*y(:))/(nt-1);
explained_eof = diag(latent)/totalvar *100; %variance,in percentage 
%EOFyreconstruct = zeros(nx,nt,nmode);
%for i = 1:nmode
%    EOFyreconstruct(:,:,i) = pc(:,i)*eof(:,i)';
%end
pass_north=num2str(explained_eof(1:end-1)'*(1-sqrt(2/nt))-explained_eof(2:end)'>0);

disp(['normal EOF:  explained:(%)' num2str(explained_eof') ])
disp(['sqrt(2/N): ' num2str(sqrt(2/nt))])
disp(['pass the North test: '  num2str(explained_eof(1:end-1)'*(1-sqrt(2/nt))-explained_eof(2:end)'>0)])

eof_reshape=reshape(eof,length(lat),length(level),nmode);

save(['EOF_',filename,'.mat'],'pc','explained_eof','eof','pass_north','lat','level','eof_reshape');

