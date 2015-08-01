;this script is to choose area and proform EOF on the data
;load "$ncl_myfunc/see.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
 ;dir="~/workdata/StormTrack/eof_U/"
 ;name="uwnd_monthly_lev250_lat0-87_lon20-130_year1979-2010_original"
  dir="~/workdata/script2015/w_extractdata_daily/"
 ; name   = "uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_orginal"
;  name   = "uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581"
  weighted = True
  weighted = True
  print(" to EOF: "+name)

; =============================================================
; Open the file: Read only the user specified period and level
; ==============================================================
 
  print("reading nc files")
  f    = addfile (dir+name+".nc", "r")
;  x     = short2flt( f[:]->$var$(:,{plev},{latS:latN},{lonL:lonR}) )
  x     = rm_single_dims(short2flt( f->var))
  lat    = f->lat
  lon    = f->lon
;  level  = f->level
  time	 = f->time
  Time_yyyymmdd	= f->time_yyyymmdd

; ================================================================
; create weights:  sqrt(cos(lat))   [or sqrt(gw) ]
; =================================================================
  if ( weighted .eq. True)
  print("performing area weighted EOF")
  rad    = 4.*atan(1.)/180. 
  clat   = sqrt( abs(cos(rad*lat) ))     ; gw for gaussian grid
  printVarSummary(x)
  xw     = x*conform(x, clat, 1)
  ;xw     = x*conform(x, clat, 1)
  copy_VarMeta(x,xw)
	
  ;printVarSummary(xw)
  wx     = xw(lat|:,lon|:,time|:)  ; Reorder (lat,lon,time) the *weighted* input data
  delete(xw)
  end if		
   ;************ Compute EOFs & Standardize time series***********************************
   neof   = 10                                  ; Leading EOF only
   optEOF = True       
   optETS = False

  
  eof    = eofunc_Wrap(wx, neof, optEOF)
;  eof    = -eof
  printVarSummary( eof ) 
  eof@long_name ="eof " +" of "+ wx@long_name
   
  eof_ts = eofunc_ts_Wrap (wx, eof, optETS)   
  eof_ts = dim_standardize_n( eof_ts, 0, 1)      ; normalized

  printVarSummary( eof_ts )
;  print(eof_ts@time)

  delta_pcvar=eof@pcvar*sqrt(2.0/dimsizes(time));  North judgement
  printVarSummary(delta_pcvar) 
;;*******************************************
;; North significance test: any pcvar, eval_transpose, eval can be used
;; need NCL version 6.3
;;*******************************************
;  ntim=dimsizes(time) 
;  
;  prinfo = True
;  sig    = eofunc_north(eof@pcvar, ntim, prinfo)    

;*******************************************
; Create netCDF: simple approach                                               
;*******************************************
  
  fnc          =  "EOF_"+name+".nc"
  if (isfilepresent(fnc))
    print( systemfunc("rm ./"+fnc) )
  end if
; system("/bin/rm -f "+fnc)               ; rm any pre-existing file            
  fout         = addfile(fnc, "c")   ; new netCDF file                   
  
  if weighted .eq. True
  fout@title   = " area weighted EOF "+name
  else 
  fout@title	= " EOF "+name
  end if
  fout->eof    = eof
  fout->eof_ts_nor = eof_ts
 
;  fout->sig    = sig ; only can be used in NCL version 6.3 
  fout->time   = time
 ; printVarSummary(time)
 ; printVarSummary(Time_yyyymmdd)
  fout->time_yyyymmdd = Time_yyyymmdd
  fout->pcvar=eof@pcvar
  fout->delta_pcvar=delta_pcvar
  fout@optEOF = optEOF
  fout@optETS = optETS
  fout@creation_date = systemfunc ("date")  
  fout@direction = dir
  if weighted .eq. True
    fout@areaweighted = "weighted"
  else 
     fout@areaweighted = "none weighted"
  end if

  end
;
;; =================================================================
;; Regress
;; =================================================================
; 
;; eof_regres = new((/neof,dimsizes(latarr0),dimsizes(lonarr0)/),"float")                ; create an array w meta data
;;
;;  do ne=0,neof-1
;;     eof_regres(ne,:,:) = (/ regCoef(eof_ts(ne,:), x0(lat|:,lon|:,time|ittssd)) /) ;
;;  end do 
;;  eof_regres!0="evn"
;;  eof_regres!1="lat"
;;  eof_regres!2="lon"
;;  eof_regres&lat=latarr0
;;  eof_regres&lon=lonarr0
;;  eof_regres&lat@units="degrees_north"
;;  eof_regres&lon@units="degrees_east" 
;;;  printinfo(eof_regres,"eof_regres")
;
;;============================================================
;; PLOTS
;;============================================================
; print("openning wks")
;
; runtime = systemfunc("date +%m_%d_%H_%M")
;  print("runtime is "+runtime)
;
;;*******************************************
;; first plot
;;*******************************************
;a= systemfunc("mkdir "+ names )
;print("cd dir")
;  do n=0,neof-1
;  wks = gsn_open_wks("oldeps",names+"/"+"EOF"+(n+1)+"_"+names)
;  gsn_define_colormap(wks,"BlWhRe")                    
;  plot = new(neof,graphic)                ; create graphic array
;
;
;  ; EOF patterns
; 
;  plotx = eof
;  res                      = True         
;  res@gsnDraw              = False        ; don't draw yet
;  res@gsnFrame             = False        ; don't advance frame yet
;  res@gsnPolar             = "NH"
;  res@gsnSpreadColors      = True         ; spread out color table
;  res@gsnAddCyclic         = False        ; plotted dataa are not cyclic
;  res@mpFillOn             = False        ; turn off map fill
;
;  res@lbLabelAutoStride    = True                 ; optimal labels
;
;  res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
;  
;  cmax=ceil(max(abs(plotx)))
;  cnint = 0.1   ; normalized no unit not m/s
;  res@cnMinLevelValF = -cmax
;  print("2*cmax/cnit: "+ (2*cmax/cnint) )
;  res@cnMaxLevelValF = cmax
;;  res@cnLevelSpacingF          = cnint           ; contour interval
;  res@cnFillOn             = True         ; turn on color fill
;  res@cnLinesOn            = True         ; True is default
;  res@cnLineLabelsOn       = True         ; True is default
;
;  res@lbLabelBarOn         = False        ; turn off individual lb's·                                         ; set symmetric plot min/max
;  symMinMaxPlt(plotx, tointeger(2*cmax/cnint), False, res)       ; contributed.ncl
;  
;  ; panel plot only resources
;
;  resP                     = True         ; modify the panel plot
;  resP@gsnMaximize         = True         ; large format
;  resP@gsnPanelLabelBar    = False         ; add common colorbar
;  resP@gsnPaperOrientation = "portrait"   ; force portraitorbar
;  resP@lbLabelAutoStride   = True         ; auto stride on labels
;;  resP@txString            = name
;
;  print("drawing eof")
;  ;dum = new(neof,graphic) 
;;  do n=0,neof-1
;     res@gsnLeftString  = "EOF "+(n+1)
;     res@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
;     plot(n)=gsn_csm_contour_map_polar(wks,eof(n,:,:),res)
;     ;plot(n)=gsn_csm_contour_map_polar(wks,eof_regres(n,:,:),res)
;
;   ; draw each line separately. Each line must contain two points.
;  ;do i = 0 , 3
;  ;  dum(n)=gsn_add_polyline(wks,plot(n),(/lonL, lonR, lonR,lonL,lonL/),(/latS,latS,latN,latN,latS/),respl)      
;  ;end do 
;;  end do
;;  gsn_panel(wks,plot,(/1,neof/),resP)     ; now draw as one plot
;  gsn_panel(wks,plot(n),(/1,1/),resP) ; only one plot each pannel
;  print("wks end")   ;
;  ;delete(plot);
;    end do
;    break
;;*******************************************
;; second plot
;;*******************************************
;; EOF time series  [bar form]
;
;
; wks2 = gsn_open_wks("oldeps",name+"/"+"PC"+(n+1)+"_"+names+runtime)
; gsn_define_colormap(wks2,"BlWhRe")  
;
; 
; print("drawing eof_ts ")
;  rts           = True
;  rts@gsnDraw   = False       ; don't draw yet
;  rts@gsnFrame  = False       ; don't advance frame yet
;  rts@gsnScale  = True        ; force text scaling               
;
;; these four rtsources allow the user to stretch the plot size, and
;; decide exactly where on the page to draw it.
;
;  rts@vpHeightF = 0.40        ; Changes the aspect ratio
;  rts@vpWidthF  = 0.85
;  rts@vpXF      = 0.10        ; change start locations
;  rts@vpYF      = 0.75        ; the plot
;
;
;  rts@tiYAxisString = "Standardized"          ; y-axis label      
;;  rts@gsnYRefLine           = 0.              ; reference line   
;;  rts@gsnXYBarChart         = False            ;True- create bar chart 
;;  rts@gsnAboveYRefLineColor = "red"           ; above ref line fill red
;;  rts@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
;
;  rts@gsnYRefLine           = (/-1.0,0,1.0/)     ; create a reference line   
;  rts@gsnAboveYRefLineColor = (/"transparent","transparent","red"/)
;  rts@gsnBelowYRefLineColor = (/"blue","transparent","transparent"/)
;  rts@gsnYRefLineColor      = (/"black","black","black"/)
;
;
;; panel plot only resources
;   rtsP                      = True            ; modify the panel plot
;;  rtsP@gsnMaximize          = True            ; large format
;   rtsP@txString            = ""
;
;  plot = new(neof,graphic)                ; create graphic array 
;; create individual plots
;  do n=0,neof-1
;     rts@gsnLeftString  = "PC "+(n+1)
;     rts@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
;     ;plot(n) = gsn_csm_xy (wks2,yrfrac,eef_ts(n,:),rts)
;     print("Ploting")
;     plot(n) = gsn_csm_xy (wks2,ispan(1,dimsizes(eof_ts(n,:)),1),eof_ts(n,:),rts)
;  end do
;  gsn_panel(wks2,plot,(/neof,1/),rtsP)     ; now draw as one plot
;   delete(plot)
;;;*******************************************
;;; third plot   ; EOF regression patterns
;;;*******************************************
;;  print("wks3ing")
;;  wks3 = gsn_open_wks("eps",names0+runtime)
;;  gsn_define_colormap(wks3,"BlWhRe")                    
;;  plot3 = new(neof,graphic)                ; create graphic array
;  
;;  delete(plotx)
;;  plotx                        = eof_regres  
;  
;;  res3                      = True         
;;  res3@gsnDraw              = False        ; don't draw yet
;;  res3@gsnFrame             = False        ; don't advance frame yet
;;  res3@gsnPolar             = "NH"
;;  res3@gsnSpreadColors      = True         ; spread out color table
;;  res3@gsnAddCyclic         = False        ; plotted dataa are not cyclic
;;  res3@mpFillOn             = False        ; turn off map fill
;;  res3@lbLabelAutoStride    = True                 ; optimal labels
;;  res3@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
;;  cmax                        = ceil(max(abs(plotx)))
;;  cnint                        = 2               ; unit m/s
;;  res3@cnMinLevelValF        = -cmax
;;  res3@cnMaxLevelValF = cmax
;;  res3@cnLevelSpacingF          = cnint           ; contour interval
;;  res3@cnFillOn             = True         ; turn on color fill
;;  res3@cnLinesOn            = True         ; True is default
;;  res3@cnLineLabelsOn       = True         ; True is default
;;  res3@lbLabelBarOn         = False        ; turn off individual lb' 
;;  print("number of contours are 2*cmax/cnit: "+ (2*cmax/cnint) )  
;;  symMinMaxPlt(plotx, tointeger(2*cmax/cnint), False, res3) ; set symmetric plot min/max  
;
;; draw box resources
;;  respl                  = True                      ; polyline mods desired
;;  respl@gsLineColor      = "red"                     ; color of lines
;;  respl@gsLineThicknessF = 2.0                       ; thickness of lines
;
;;  print("drawing eof_regression")
;;  dum = new(neof,graphic) 
;;  do n=0,neof-1
;;     res3@gsnLeftString  = "EOF "+(n+1)
;;     res3@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
;;     plot3(n)=gsn_csm_contour_map_polar(wks3,eof_regres(n,:,:),res3)
;  ; draw each line separately. Each line must contain two points.
;;  do i = 0 , 1
;;    dum(n)=gsn_add_polyline(wks3,plot3(n),(/lonL, lonR, lonR,lonL,lonL/),(/latS,latS,latN,latN,latS/),respl)   
;;  end do
;;  end do
;; panel plot only resources
;;  resP3                  = resP                 ; modify the panel plot
;
; 
; 
;;  gsn_panel(wks3,plot3,(/1,neof/),resP3)     ; now draw as one plot
;;  delete(plot3)
;
;
;end
  
