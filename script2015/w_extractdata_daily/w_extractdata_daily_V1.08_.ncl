load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"  

begin
;sappersapper@gmail.com
;没有考虑季节平均的跨年问题，比如冬季三月。
;平均  冬季平均？全年平均？季节循环是相对全年平均的，preserve_avg保留的是季节平均，这两者怎么协调？若要保留平均值，考虑不同格点的差异，会出问题？
;若既保留均值，又做空间滤波，可能需要把空间滤波这一步移到后面
; to do :  syn 等量还需要去除平均值   没考虑纬度权重

;流程  read --- (zonal or meridional mean) --- clac time avg --- (detrend) --- (remove seasonal cycle) --- (time filter) --- (spatial filter) --- select and rearrange data --- (clac_synasyn) --- (clac_monthly) --- save




;; description = "example"
;  latS   =  0.
;  latN   =  90. 
;  lonL   =  20.
;  lonR   =  130.
;  levelL = 1000 ; hPa
;  levelU = 10 ; hPa
;;  varstring = "hgt"   ; hgt uwnd vwnd air omega rhum ...
; direction="~/workdata/data_for_huangy/NCEP_reanalysis2/daily/pressure/" 
;; direction = "/pub/pubDATA/NCEP_reanalysis/reanalysis2/daily/pressure/"
;  yrstart = 1979
;  yrend = 2009
;  description = "NDJFM"
;  month = 11  ; start month
;  Nday = 150
;  yrend_load = yrend+1
;
;;  remove_seasonal_cycle = True
;;  remove_seasonal_Nfftwave = 3     ; first N harmonics of the annual cycle
;;  filter = "none"     ;"lowpass" "highpass" "bandpass"  "runave"  "removerunave" "none"
;;  filter = "bandpass"
;;  Nwgt = 61                           ;   
;;  fca  = 1./30.                     ;high or low-pass freq
;;  fcb  = 1./11.
;;  filter = "lowpass"  
;;  Nwgt = 61                ;                          
;;  fca  = 1./31.             ; high or low-pass freq
;;preserve_avg = True




;; 必须指定的参数
;  description = "example" 在生成的文件名里有反应
;  latS   ;  -90 - 90
;  latN   ;  -90 - 90
;  lonL   ;  0 - 360
;  lonR   ;  0 - 360
;  levelL = 1000 ; hPa
;  levelU = 10 ; hPa
;  yrstart = 1979
;  yrend = 2009
;  month  ; 1 - 12
;  Nday   ; 1 - 366

; set default value
  if(.not.isvar("yrstart_load")) yrstart_load = yrstart end if			;读取数据的起始年份
  if(.not.isvar("yrend_load")) yrend_load = yrend end if			;读取数据的终止年份
  if(.not.isvar("yrstart_seasonal")) yrstart_seasonal = yrstart end if		;计算季节变化的起始年份
  if(.not.isvar("yrend_seasonal")) yrend_seasonal = yrend end if		;计算季节变化的终止年份
  if(.not.isvar("detrend")) detrend = False end if				;去趋势
  if(.not.isvar("remove_seasonal_cycle")) remove_seasonal_cycle = False end if	;去季节循环
  if(.not.isvar("remove_seasonal_Nfftwave")) remove_seasonal_Nfftwave=-1 end if ;保留季节循环的前几波，-1表示保留所有波数
  if(.not.isvar("preserve_avg")) preserve_avg = False end if			;最后输出的var是否要保留均值，均值是在滤波前就计算好的
  if(.not.isvar("zonal_mean")) zonal_mean = False end if			;纬向平均
  if(.not.isvar("meridional_mean")) meridional_mean = False end if		;经向平均
  if(.not.isvar("filter")) filter = "none" end if				;时间滤波    "lowpass" "highpass" "bandpass"  "runave" "removerunave" "bandpass-runmean"  "none"
  if(.not.isvar("spatialfilter")) spatialfilter = "none" end if			;空间滤波，待完善
  if(.not.isvar("clac_synasyn")) clac_synasyn = False end if			;计算相对赤道的对称/反对称平均场
  if(.not.isvar("clac_monthly")) clac_monthly = False end if			;计算月平均
  if(.not.isvar("Nday_preoffset"))  Nday_preoffset = 0  end if  		;相对指定月份第一天的offset，todo:输出这个量
;other optional:  
  ; Ndaycutdown_start Ndaycutdown_end   					;滤波之后前后需要截断的天数
  ; fca  									;high or low-pass freq 
  ; fcb										;the second cut-off frequency for bandpass    fca < fcb < 0.5
  ; 

; reading data
  print("reading data...")   
  years_load = ispan(yrstart_load,yrend_load,1)
  years = ispan(yrstart,yrend,1)
  Nyear_load = dimsizes(years_load)
  Nyear = dimsizes(years)

  if(varstring.eq."vp") ;velocitypotential
    files = direction+"uwnd"+"."+years_load+".nc" 
    pf = addfiles(files,"r")
    uwnd = pf[:]->uwnd(:,{levelL:levelU},:,:)
    uwnd:= short2flt(uwnd)
    files = direction+"vwnd"+"."+years_load+".nc" 
    pf = addfiles(files,"r")
    vwnd = pf[:]->vwnd(:,{levelL:levelU},:,:)
    vwnd:= short2flt(vwnd)
    time = pf[:]->time
    temp:= uv2sfvpF(uwnd(:,:,{-90:90},:),vwnd(:,:,{-90:90},:))
    dims:= dimsizes(temp)
    temp = temp(:,:,:,dims(3)-1:0,:)
    copy_VarCoords(uwnd,temp(1,:,:,:,:))
    var  = temp(1,:,{levelL:levelU},{latS:latN},{lonL:lonR})
    level = pf[0]->level({levelL:levelU})
    lat = pf[0]->lat({latS:latN})
    lon = pf[0]->lon({lonL:lonR})
  else if(varstring.eq."sf") ;streamfunction
    files = direction+"uwnd"+"."+years_load+".nc" 
    pf = addfiles(files,"r")
    uwnd = pf[:]->uwnd(:,{levelL:levelU},:,:)
    uwnd:= short2flt(uwnd)
    files = direction+"vwnd"+"."+years_load+".nc" 
    pf = addfiles(files,"r")
    vwnd = pf[:]->vwnd(:,{levelL:levelU},:,:)
    vwnd:= short2flt(vwnd)
    time = pf[:]->time
    temp:= uv2sfvpF(uwnd(:,:,{-90:90},:),vwnd(:,:,{-90:90},:))
    dims:= dimsizes(temp)
    temp = temp(:,:,:,dims(3)-1:0,:)
    copy_VarCoords(uwnd,temp(0,:,:,:,:))
    var  = temp(0,:,{levelL:levelU},{latS:latN},{lonL:lonR})
    level = pf[0]->level({levelL:levelU})
    lat = pf[0]->lat({latS:latN})
    lon = pf[0]->lon({lonL:lonR})
  else if(varstring.eq."w")
    files = direction+"omega."+years_load+".nc" 
    pf = addfiles(files,"r")
    time = pf[:]->time    
    var_omega = pf[:]->omega(:,{levelL:levelU},{latS:latN},{lonL:lonR})
    var_omega:= short2flt(var_omega)
    files = direction+"air."+years_load+".nc" 
    pf = addfiles(files,"r")
    var_t = pf[:]->air(:,{levelL:levelU},{latS:latN},{lonL:lonR})
    var_t:= short2flt(var_t)
    var_p = conform(var_t,100*var_t&level,(/1/))
    var = omega_to_w(var_omega,var_p,var_t)
    printVarSummary(var)
    level = pf[0]->level({levelL:levelU})
    lat = pf[0]->lat({latS:latN})
    lon = pf[0]->lon({lonL:lonR})
  else if(varstring.eq."olr")
    direction = "/pub/pubDATA/OLR/olr.day.mean.nc"
    levelL = 0
    levelU = 0
    pf = addfile(direction,"r")
    time = pf->time 
    var = pf->$varstring$(:,{latS:latN},{lonL:lonR})
    var:= short2flt(var)
    dims:= dimsizes(var)
    temp:= new((/dims(0),1,dims(1),dims(2)/),float)
    temp(:,0,:,:) = var
;    copy_VarMeta
    level = levelL
    lat = pf->lat({latS:latN})
    lon = pf->lon({lonL:lonR})
    temp!1 = "level"
    temp&level = level
    var:= temp
    printVarSummary(var)
  else if(varstring.eq."precip")
    direction = "/pub/pubDATA/NCEP_reanalysis/reanalysis2/daily/surface/"
    levelL = 0
    levelU = 0
    files = direction+"pr_wtr.eatm."+years_load+".nc" 
    pf = addfiles(files,"r")
    time = pf[:]->time 
    var = pf[:]->pr_wtr(:,{latS:latN},{lonL:lonR})
    var:= short2flt(var)
    dims:= dimsizes(var)
    temp:= new((/dims(0),1,dims(1),dims(2)/),float)
    temp(:,0,:,:) = var
;    copy_VarMeta
    level = levelL
    lat = pf[0]->lat({latS:latN})
    lon = pf[0]->lon({lonL:lonR})
    temp!1 = "level"
    temp&level = level
    var:= temp
    printVarSummary(var)
  else if(varstring.eq."slp")
    direction = "/pub/pubDATA/NCEP_reanalysis/reanalysis2/daily/surface/"
    levelL = 0
    levelU = 0
    files = direction+"mslp."+years_load+".nc" 
    pf = addfiles(files,"r")
    time = pf[:]->time 
    var = pf[:]->mslp(:,{latS:latN},{lonL:lonR})
    var:= short2flt(var)
    dims:= dimsizes(var)
    temp:= new((/dims(0),1,dims(1),dims(2)/),float)
    temp(:,0,:,:) = var
;    copy_VarMeta
    level = levelL
    lat = pf[0]->lat({latS:latN})
    lon = pf[0]->lon({lonL:lonR})
    temp!1 = "level"
    temp&level = level
    var:= temp
    printVarSummary(var)
  else
    files = direction+varstring+"."+years_load+".nc" 
    pf = addfiles(files,"r")
    time = pf[:]->time    
    if(lonL.lt.0)
    var = pf[:]->$varstring$(:,{levelL:levelU},{latS:latN},:)
    lon = pf[0]->lon
;    var = lonPivot(var,lonR)
;    lon = lonPivot(lon,lonR)
    var = lonFlip(var)
    lon = lonFlip(lon)
    lon = where(lon.ge.180,lon-360,lon)
    printVarSummary(var)
    print(lon)
    var := var(:,:,:,{lonL:lonR})
    lon := lon({lonL:lonR})
        printVarSummary(var)
    print(lon)
    else
    var = pf[:]->$varstring$(:,{levelL:levelU},{latS:latN},{lonL:lonR})
    lon = pf[0]->lon({lonL:lonR})
    end if
    var:= short2flt(var)
    ;var = lonFlip( var )   
    level = pf[0]->level({levelL:levelU})
    lat = pf[0]->lat({latS:latN})
  end if
  end if
  end if
  end if
  end if
  end if
  utc_d = floattointeger(ut_calendar(time,0))  ; utc_date(:,0)=years, utc_date(:,1)=months ; utc_date(:,2)=days, utc_date(:,3)=hours ...
  temp := var(level|:,lat|:,lon|:,time|:)
  var:= temp
  print("max:"+max(var)+" min:"+min(var)+" variance:"+sum(dim_variance_n(var,3)))


; clac zonal or meridional mean
  if(zonal_mean.eq.True)
    print("clac zonal mean")
    dims:= dimsizes(var)
    temp := new((/dims(0),dims(1),1,dims(3)/),typeof(var))
    temp = dim_avg_n_Wrap(var,2)
    temp!2 = "lon"
    lon := dim_avg(lon)
    temp&lon = lon
    var := temp
  end if
  if(meridional_mean.eq.True)
    print("clac meridional mean")
    dims:= dimsizes(var)
    temp := new((/dims(0),1,dims(2),dims(3)/),typeof(var))
    temp = dim_avg_n_Wrap(var,1)
    temp!1 = "lat"
    lat := dim_avg(lat)
    temp&lat = lat
    var := temp
  end if


; clac avg
 print("calc avg ...")
 do iday = 0,dimsizes(time)-1   
   if(utc_d(iday,0).eq.yrstart) 
     selectday_start = iday
     iday = iday+366
   end if
   if(utc_d(iday,0).eq.yrend) 
     selectday_end = iday
   end if
 end do
  timetemp:= time(selectday_start:selectday_end)
  utc_dtemp:= utc_d(selectday_start:selectday_end,:)
  if(Nday.ge.366) then
   vartemp:= var(:,:,:,selectday_start:selectday_end)
  else
   selectdays := new(Nday*Nyear,"integer")    ; day numbers
   jyear = 0                        ; record year number
   do iday = 0,dimsizes(timetemp)-1     ; record day number
     if(utc_dtemp(iday,1).eq.month  .and.  (iday-Nday_preoffset+Nday-1).lt.dimsizes(timetemp)-1)   
;print(utc_dtemp(iday,0)+"_"+utc_dtemp(iday,1)+"_"+utc_dtemp(iday,2))
       selectdays(Nday*jyear:Nday*jyear+Nday-1) = ispan(iday-Nday_preoffset,iday-Nday_preoffset+Nday-1,1)
       jyear = jyear+1
       if(Nday.le.31)
         iday = iday+31  ;必须加这句，否则下一次utc_dtemp(iday,1).eq.month这个条件还是满足，会出错
       else
         iday = iday+Nday-1 ;循环本身会加1
       end if
     end if
   end do
   if(ismissing(selectdays(Nday*Nyear-1))) then
     temp := selectdays(0:Nday*(Nyear-1)-1)
     selectdays:= temp
   end if
   vartemp:= var(:,:,:,selectday_start+selectdays)
  end if
 var_avg = dim_avg_Wrap(vartemp)
 delete(vartemp)


  ; detrend
  if(detrend) then
    print("detrend...")
    detrend_return_info = True
    temp:= dtrend(var,detrend_return_info)
;    dtrend_msg
    copy_VarMeta(var,temp)
    var = temp
    print("max:"+max(var)+" min:"+min(var)+" variance:"+sum(dim_variance_n(var,3)))
  end if


; remove seasonal cycle
  if(remove_seasonal_cycle) then
   print("remove seasonal cycle...")
   selectdays := new(365*Nyear,"integer")  ; day numbers
   jyear = 0                        ; record year number
   do iday = 0,dimsizes(time)-1     ; record day number
     DayOfYear = day_of_year(utc_d(iday,0),utc_d(iday,1),utc_d(iday,2))
     if(DayOfYear.eq.1  .and.  utc_d(iday,0).ge.yrstart_seasonal  .and.  utc_d(iday,0).le.yrend_seasonal )   
       selectdays(365*jyear:365*(jyear+1)-1) = ispan(iday,iday+365-1,1)
       jyear = jyear+1
       iday = iday+364
     end if
   end do
   dims:= dimsizes(var)
   var_seasonal = dim_avg_n(  reshape( var(:,:,:,selectdays),(/dims(0),dims(1),dims(2),Nyear,365/) ),3  )
   var_avg_whole = dim_avg_n( var_seasonal,3 )
   if(remove_seasonal_Nfftwave.gt.0)
     var_seasonal_fft = cfftf(var_seasonal,0,0)
     var_seasonal_fft(:,:,:,:,remove_seasonal_Nfftwave+1:365-1-remove_seasonal_Nfftwave) = 0
     var_seasonal_fft(:,:,:,:,0) = 0 ;不将平均值计入季节平均
     var_seasonal = cfftb(var_seasonal_fft,1)
     ;var_seasonal_fft = ezfftf(var_seasonal)
     ;var_seasonal_fft(:,:,:,:,remove_seasonal_Nfftwave:) = 0 
     ;var_seasonal = ezfftb(var_seasonal_fft,var_seasonal_fft@xbar) ; bug at the 365th day before NCL_v6.2!
     ;var_seasonal = ezfftb(var_seasonal_fft,0)
   end if
   temp:= var
   do iday = 0,dimsizes(time)-1     ; record day number
     DayOfYear = day_of_year(utc_d(iday,0),utc_d(iday,1),utc_d(iday,2))
     if(DayOfYear.eq.366)   
       var(:,:,:,iday) = var(:,:,:,iday)-(var_seasonal(:,:,:,365-1)+var_seasonal(:,:,:,0))/2
     else
       var(:,:,:,iday) = var(:,:,:,iday)-var_seasonal(:,:,:,DayOfYear-1)
     end if
   end do
   copy_VarMeta(temp,var)
   copy_VarCoords(var(:,:,:,1),var_seasonal(:,:,:,1))
   var_seasonal!3 = "dayseasonal"
   var_seasonal&dayseasonal = ispan(1,365,1)
  end if
  print("max:"+max(var)+" min:"+min(var)+" variance:"+sum(dim_variance_n(var,3)))


; time filtering
  sigma = 1.0                          ; Lanczos sigma
  if(filter.eq."lowpass") then
  print("use lowpass filter")
  wgt  = filwgts_lanczos (Nwgt, 0, fca, 0, sigma )  ; low- or high- pass filter
  var = wgt_runave_Wrap ( var, wgt, 0 )
  end if
  if(filter.eq."highpass") then
  print("use highpass filter")
  wgt  = filwgts_lanczos (Nwgt, 1, fca, 0, sigma )  ; low- or high- pass filter
  var = wgt_runave_Wrap ( var, wgt, 0 )
  end if
  if(filter.eq."bandpass") then
  print("use bandpass filter")
  wgt  = filwgts_lanczos (Nwgt, 2, fca, fcb, sigma )  ; band-pass filter
  var = wgt_runave_Wrap ( var, wgt, 0 )
  end if
  if(filter.eq."runave") then
  print("use running average")
  var = runave_Wrap ( var,Nwgt, 0 )
  end if
  if(filter.eq."removerunave") then
  print("remove running average")
  var = var - runave_Wrap ( var,Nwgt, 0 )
  end if
  if(filter.eq."bandpass-runmean") then
  print("perform bandpass through running average")
  var = var - runave_Wrap ( var,Nwgt, 0 )
  var = runave_Wrap ( var,Nwgt2, 0 ) ;这样算头尾又会浪费几天，可以加入一个临时变量 todo 
  end if
  ;var := var(:,:,(Nwgt-1)/2:N-1-(Nwgt-1)/2)
  print("max:"+max(var)+" min:"+min(var)+" variance:"+sum(dim_variance_n(var,3)))


; spatial filtering
  print("spatialfilter: "+spatialfilter)
  if(spatialfilter.eq."fft") 
     if(dimsizes(lon).ne.dims(2)) 
       print("!")
       print("Error:  spatialfilter with fft should be used with full parallel circle! ! !")
       print("!")
     end if
     temp := ezfftf(var(time|:,level|:,lat|:,lon|:))
     if(spatialfilter_waveH.gt.0) 
       temp(:,:,:,:,spatialfilter_waveH:) = 0  
     end if
     if(spatialfilter_waveL.gt.1)  
       temp(:,:,:,:,0:spatialfilter_waveL-2) = 0  
     end if
     if(spatialfilter_waveL.gt.0) 
       temp := ezfftb(temp,0) 
     else
       temp := ezfftb(temp,temp@xbar)   
     end if
     temp!0 = "time"
     temp!1 = "level"
     temp!2 = "lat"
     temp!3 = "lon"
     vartemp := temp(level|:,lat|:,lon|:,time|:)
     copy_VarMeta(var,vartemp)
     var = vartemp
     delete(vartemp)
  end if
  print("max:"+max(var)+" min:"+min(var)+" variance:"+sum(dim_variance_n(var,3)))


; select and rearrange data
  print("select and rearrange data ...")
  temp:= time(selectday_start:selectday_end)
  time:= temp
  temp:= utc_d(selectday_start:selectday_end,:)
  utc_d:= temp
  temp:= var(:,:,:,selectday_start:selectday_end)
  var:= temp
  if(Nday.ge.366) then
   dims:= dimsizes(var)
   Time = cd_calendar(time,4) ; YYYY.fraction_of_year
   asciiwrite("temp.txt",Time)
  else
   selectdays := new(Nday*Nyear,"integer")    ; day numbers
   jyear = 0                        ; record year number
   do iday = 0,dimsizes(time)-1     ; record day number
     if(utc_d(iday,1).eq.month  .and.  (iday-Nday_preoffset+Nday-1).lt.dimsizes(time)-1)   
       selectdays(Nday*jyear:Nday*jyear+Nday-1) = ispan(iday-Nday_preoffset,iday-Nday_preoffset+Nday-1,1)
       jyear = jyear+1
       if(Nday.le.31)
          iday = iday+31  ;必须加这句，否则下一次utc_dtemp(iday,1).eq.month这个条件还是满足，会出错
        else
          iday = iday+Nday-1 ;循环本身会加1
        end if
     end if
   end do
   printVarSummary(selectdays)
   if(ismissing(selectdays(Nday*Nyear-1))) then
     temp := selectdays(0:Nday*(Nyear-1)-1)
     selectdays:= temp
   end if
   printVarSummary(selectdays)
   ;print(utc_d(selectdays,0)+" "+utc_d(selectdays,1)+" "+utc_d(selectdays,2))
   asciiwrite("temp.txt",utc_d(selectdays,0)+" "+utc_d(selectdays,1)+" "+utc_d(selectdays,2))  

   temp:= var(:,:,:,selectdays)
   var:= temp
   temp:= time(selectdays)
   time:= temp
   dims:= dimsizes(var)
   Time = yrstart+ispan(0,dims(3)-1,1)*1.0/Nday
  end if
  if(isvar("Ndaycutdown_end"))
    temp:= Time(:dims(3)-1-Ndaycutdown)
    Time:= temp
    temp:= time(:dims(3)-1-Ndaycutdown)
    time:= temp
    temp:= var(:,:,:,:dims(3)-1-Ndaycutdown)
    var:= temp
    dims:= dimsizes(var)
  end if
  if(isvar("Ndaycutdown_start"))
    temp:= Time(Ndaycutdown_start:)
    Time:= temp
    temp:= time(Ndaycutdown_start:)
    time:= temp
    temp:= var(:,:,:,Ndaycutdown_start:)
    var:= temp
    dims:= dimsizes(var)
  end if
  var = dim_rmvmean_Wrap(var)  ; 去掉剩余的均值
  if(preserve_avg.eq.True) var = var+conform(var,var_avg,(/0,1,2/)) end if  ; 若需要，加上一开始计算出来的均值
  time_yyyymmdd = cd_calendar(time,-2)
  if(isvar("var_seasonal"))
  var_seasonal!0 = "level"
  var_seasonal!1 = "lat"
  var_seasonal!2 = "lon"
  var_seasonal&level = level
  var_seasonal&lat = lat
  var_seasonal&lon = lon
  var_avg_whole!0 = "level"
  var_avg_whole!1 = "lat"
  var_avg_whole!2 = "lon"
  var_avg_whole&level = level
  var_avg_whole&lat = lat
  var_avg_whole&lon = lon
  ;copy_VarCoords(var_seasonal(:,:,:,0),var_avg_whole)
  end if
  var!0 = "level"
  var!1 = "lat"
  var!2 = "lon"
  var!3 = "time"
  var&level = level
  var&lat = lat
  var&lon = lon
  var&time = time
  printVarSummary(var)

  ;clac syn and asyn
  if(clac_synasyn)
    nlat = dims(1)
    indcenterlat = (nlat-1)/2
    varS = dim_avg_n(var(:,0:(indcenterlat-1),:,:),1)
    varN = dim_avg_n(var(:,(indcenterlat+1):(nlat-1),:,:),1)
    ;syn = (varS+varN)/2
    syn = (varS*indcenterlat+varN*indcenterlat+var(:,indcenterlat,:,:))/nlat
    asyn = (-varS+varN)/2
    copy_VarMeta(var(:,0,:,:),syn)   ;这里可能会出现bug
    copy_VarMeta(var(:,0,:,:),asyn)
  end if

  ;clac monthly data
  if(clac_monthly)
    temp:=var(time|:,level|:,lat|:,lon|:)
;    temp = temp^2
    ;copy_VarMeta(var(:,:,:,0),temp(0,:,:,:))
    temp!0 = "time"
    temp!1 = "level"
    temp!2 = "lat"
    temp!3 = "lon"
    temp&level = level
    temp&lat = lat
    temp&lon = lon
    temp&time = time
     printVarSummary(temp)
    var_monthly = calculate_monthly_values(temp,"ave",0,False)
    var_monthly!1 = "level"
    var_monthly!0 = "time_monthly"
    printVarSummary(var_monthly)
  end if


; save data
  print("save data...")
;  setfileoption("nc","Format","LargeFile")  ; 2-4G
  setfileoption("nc","Format","NetCDF4Classic")  ; >4G 

  if(filter.ne."none")
    string_filter = filter+"Nwgt"+Nwgt
    if(filter.eq."lowpass" .or. filter.eq."highpass")
      string_filter = string_filter + "-" + fca
    end if
    if(filter.eq."bandpass")
      string_filter = string_filter + "-" + fca + "-" + fcb
    end if
    if(filter.eq."bandpass-runmean")
      string_filter = string_filter + "-" + Nwgt2
    end if
  else
    string_filter = ""
  end if
  if(preserve_avg.eq.True)  string_filter = string_filter + "_withmean"  end if
  if((preserve_avg.eq.True ) .and. (filter .eq. "none") .and. (detrend .eq. False )) string_filter = "_orginal" end if
  if(spatialfilter.ne."none")
    string_spatialfilter = "space"+spatialfilter
    if(spatialfilter.eq."fft")
      string_spatialfilter = string_spatialfilter+spatialfilter_waveL+"-"+spatialfilter_waveH
    end if
  else
    string_spatialfilter = ""
  end if
  if(remove_seasonal_cycle)
    if(remove_seasonal_Nfftwave.gt.0) 
      string_filter = "deseasonal"+remove_seasonal_Nfftwave+"-"+string_filter 
    else
      string_filter = "deseasonal-"+string_filter 
    end if
  end if
  if(detrend) 
    string_filter = "detrend-"+string_filter
  end if
  if(levelL.eq.levelU) 
    string_level = "_lev"+levelL
  else
    string_level = "_lev"+levelL+"-"+levelU
  end if
  if(latS.eq.latN) 
    string_lat = "_lat"+latS
  else
    string_lat = "_lat"+latS+"-"+latN
  end if
  if(meridional_mean.eq.True)
    string_lat = string_lat+"mean" 
  end if
  if(lonL.eq.lonR)
    string_lon = "_lon"+lonL
  else
    string_lon = "_lon"+lonL+"-"+lonR
  end if
  if(zonal_mean.eq.True)
    string_lon = string_lon+"mean" 
  end if
  foutname = varstring+"_"+description+string_level+string_lat+string_lon+"_year"+yrstart+"-"+yrend+string_filter+string_spatialfilter+".nc"
  ;foutname = varstring+"_"+description+"_lev"+levelL+"-"+levelU+"_lat"+latS+"-"+latN+"_lon"+lonL+"-"+lonR+"_year"+yrstart+"-"+yrend+"_filter-"+filter+".nc"
  print(foutname)
  if (isfilepresent(foutname))
    print( systemfunc("rm ./"+foutname) )
  end if
  fout = addfile(foutname,"c") 
  fout->var  = rm_single_dims(var(time|:,level|:,lat|:,lon|:))
  fout->Time = Time
  fout->time = time
  fout->time_yyyymmdd = time_yyyymmdd
  fout->var_avg = rm_single_dims(var_avg)
  fout@creation_date = systemfunc ("date")  
  fout@direction = direction
  fout@remove_seasonal_cycle = remove_seasonal_cycle
  fout@yrstart_seasonal = yrstart_seasonal
  fout@yrend_seasonal = yrend_seasonal
  if(isvar("var_seasonal")) 
    fout->var_seasonal = rm_single_dims(var_seasonal(dayseasonal|:,level|:,lat|:,lon|:)) 
    fout->var_avg_whole = rm_single_dims(var_avg_whole)
  end if
  if(clac_synasyn)
    fout->syn  = rm_single_dims(syn)
    fout->asyn  = rm_single_dims(asyn)
  end if
  if(clac_monthly)
    fout->var_monthly = rm_single_dims(var_monthly)
  end if
  if(detrend) fout->trend = detrend_return_info@slope  end if

end



