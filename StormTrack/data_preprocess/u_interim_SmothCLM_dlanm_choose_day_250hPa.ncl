load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"  
load "$ncl_myfunc/see.ncl"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		this script is to deal with daily data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
begin

  latS	=  0.
  latN	=  87. 

  lonL	=  120. ; 0.	; 120
  lonR	=  255.	; 255

  plevU	=  250	; hPa (plev)
  plevL	=  250 ; 

  yrStrt=  1979
  yrLast=  2010

  mStrt  = 11   	; start month
  ssd    = 151	 	; 61(ND),59(FM) a season days ; even though its leap year 


  var	=  "U_GDS0_ISBL"; "uwnd"   ; hgt uwnd vwnd air ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  	if(plevU .eq. plevL) 
    	string_level 	= "_lev"+plevL
  	else
    	string_level 	= "_lev"+plevL+"-"+plevU
  	end if
  	if(latS.eq.latN) 
    	string_lat 	= "_lat"+latS
  	else
    	string_lat 	= "_lat"+latS+"-"+latN
  	end if
  	if(lonL.eq.lonR) 
    	string_lon 	= "_lon"+lonL
  	else
    	string_lon 	= "_lon"+lonL+"-"+lonR
  	end if
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        description	= "ERA interim 1.5*1.5 daily data daily anomalies (daily climatology has been smoothed by fft by NCL function smthClmDayTLL ) using NCL function by Huang Ying";     description= "NCEP/NCAR reanalysis 1 daily data without any filtering or other reprocess that averaged to monthly data by Huang Ying"

  	foutname 	= var+"_DailyAnomSmClm"+string_level+string_lat+string_lon+"_year"+yrStrt+"-"+yrLast+"M"+mStrt+"D"+ssd+".nc"

	print(" to calculate"+description)

	print(foutname+" this file will be outputted")

;;;;;;;;;;;;;;;;;;;;;;;;;;reading nc data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  years	= ispan(yrStrt,yrLast,1) 
  dir ="/lustre/huangy/ERAinterim/nc/"
  ;dir	= "/home/huangy/work/reanalysis1/daily/pressure/"
  ;print(dir+var+"."+years(0)+".nc")
  ; f	= addfile(dir+var+"."+years(1)+".nc","r");
  
  print("reading nc files")
  ;f	= addfiles(dir+var+"."+years+".nc","r");f     = addfile (dir+var+".mon.mean.nc", "r")  ;   
  f	= addfiles(dir+"u_utc_00_"+years+".nc","r")
 ; print(f[0]->lv_ISBL1)
   ; print(f[0]->lv_ISBL1({plevL-1:plevU+1}))
   ; x 	= f[:]->$var$(:,{plevL},{latS:latN},{lonL:lonR}) 
  x 	= f[:]->$var$(:,{plevL:plevU},{latS:latN},{lonL:lonR}) ;
 ; x 	= f[:]->$var$(:,{plevL:plevU},{latS:latN},{lonL:lonR}) 

  ;x=f[:]->$var$  {plevL:plevU}
  
  printinfo(x,"x")

  Lat	= f[0]->g0_lat_2({latS:latN})
  Lon	= f[0]->g0_lon_3({lonL:lonR})
  Plev  = f[0]->lv_ISBL1({plevL:plevU})

  TIME	= f[:]->initial_time0_hours 
 
  utc_date = ut_calendar(TIME, 0)
  YYYY	  = tointeger(utc_date(:,0))    ; Convert to integer for
  MM	  = tointeger(utc_date(:,1))    ; use sprinti 
  DD 	  = tointeger(utc_date(:,2))    ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;daily anomalies;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ddd     = day_of_year(YYYY, MM, DD) 
  ttyyyyddd = YYYY*1000 + ddd        	; total year_daynumber 

  ;printVarSummary(yyyyddd)
  xttdClm   = clmDayTLLL(x,ttyyyyddd)	; (366,1level,lat,lon)
  xttdClm!0 =  "year_of_day"
;  xttdClm!1 =  "lv_ISBL1"
;  xttdCLm!2 =  "g0_lat_2"
;  xttdCLm!3 =  "g0_lon_3"
  printinfo( xttdClm, "xttdClm" )



;;;;;;;;;;;;;;;;;;;;;;;;;;;
  xreshape     	   = reshape(x,(/dimsizes(TIME),dimsizes(Plev)*dimsizes(Lat),dimsizes(Lon)/))
  xttdClmreshape   = reshape(xttdClm,(/366,dimsizes(Plev)*dimsizes(Lat),dimsizes(Lon)/))
  xttdClmreshape!0 = "year_of_day"
  xttdClmreshape!1 = "g0_lat_2" ;in fact (g0_lat_2 times lv_ISBL1)
  xttdClmreshape!2 = "g0_lon_3"


  printinfo(xttdClmreshape,"xttdClmreshape")
  print("the g0_lat_2 is in fact (g0_lat_2 times lv_ISBL1)")


  xttdCLmSmreshape = smthClmDayTLL(xttdClmreshape,3); remove harmonics  greater than 3 
;
  printinfo(xttdCLmSmreshape,"xttdCLmSmreshape")
  xttdCLmSm	 =  reshape(xttdCLmSmreshape,(/366,dimsizes(Plev),dimsizes(Lat),dimsizes(Lon)/)); (yearday366,level,lat,lon)
  xttdCLmSm!0 =  "year_of_day"
;  xttdCLmSm!1 =  "lv_ISBL1"
;  xttdCLmSm!2 =  "g0_lat_2"
;  xttdCLmSm!3 =  "g0_lon_3"

  printinfo(xttdCLmSm,"xttdCLmSm")


  xttdAnomreshape  = calcDayAnomTLL ( xreshape, ttyyyyddd, xttdCLmSmreshape)     ; (totaltime, 1level lat,lon)
 
  xttdAnom	= reshape(xttdAnomreshape,(/dimsizes(TIME),dimsizes(Plev),dimsizes(Lat),dimsizes(Lon)/))
;  
  copy_VarMeta (x , xttdAnom   ) 
  
 
  printinfo(xttdAnom,"xttAnom")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;pick up days;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 print("picking up dates")

  idStrt0   = ind((MM*100+DD) .eq. (mStrt*100+01)) ; yyyy-12-01 
  if ( (last(idStrt0)+ssd) .gt. (dimsizes(TIME)+1) ) then
  idStrt    = idStrt0(:dimsizes(idStrt0)-2)  ;remove the last season if exceed
  else 
  idStrt    = idStrt0
  end if
  delete(idStrt0)
;  print(idStrt)
  SSD       = ispan(0, ssd-1, 1) ; one season array
  ittssdM   = conform_dims((/dimsizes(idStrt),dimsizes(SSD)/),SSD,1)+conform_dims((/dimsizes(idStrt),dimsizes(SSD)/),idStrt,0)
  ittssd    = ndtooned(ittssdM) ; total season days indeces
;  print(ittssd)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  xdAnom_pick    = xttdAnom(initial_time0_hours|ittssd,lv_ISBL1|:,g0_lat_2|:,g0_lon_3|:)

  printinfo(xdAnom_pick,"xdAnom_pick")

  Time_pick_up	= TIME(ittssd)
  Time_pick_up@units  = TIME@units
  utc_date_pick_up	= ut_calendar(Time_pick_up, 0)
  YYYY_pick_up	  	= tointeger(utc_date_pick_up(:,0))    ; Convert to integer for
  MM_pick_up		= tointeger(utc_date_pick_up(:,1))    ; use sprinti 
  DD_pick_up		= tointeger(utc_date_pick_up(:,2))    ;

; print( YYYY_pick_up*10000+MM_pick_up*100+DD_pick_up)
;;;;;;;;;;;;;;;;;;;;;;;;;;;save nc file;;;;;;;;;;;;;;;;;;;
 print("creating nc file and saving...")

	if (isfilepresent(foutname))
    		print( systemfunc("rm ./"+foutname) )
 	end if

	fout  = addfile (foutname, "c")  	; open output file

        x_output=xdAnom_pick         ; to change 
	x_output@description = description
	x_output@actual_range = (/min(x_output),max(x_output)/)
	Lat@actual_range =  (/ min(Lat),max(Lat) /)
        Plev@actual_range =  (/ min(Plev),max(Plev) /)
	Lon@actual_range = (/ min(Lon),max(Lon) /)

	fout->$var$ = x_output ;xfft_pick
	fout->initial_time0_hours  = Time_pick_up
	fout->time_YYYYMMDD = YYYY_pick_up*10000+MM_pick_up*100+DD_pick_up
	fout->lv_ISBL1 	 = Plev
	fout->g0_lat_2   = Lat
	fout->g0_lon_3   = Lon

        fout->DailyClim  	=  (/xttdClm/)
	fout->DailyClimSmth 	=  (/xttdCLmSm/)
	 xttdCLmSm!0 =  "year_of_day"
  	 xttdCLmSm!1 =  "lv_ISBL1"
 	 xttdCLmSm!2 =  "g0_lat_2"
  	 xttdCLmSm!3 =  "g0_lon_3"

  	system("ncdump -c "+foutname)


 end  
