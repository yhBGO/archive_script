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

  plevU	=  100;250	; hPa (plev)
  plevL	=  850;250 ; 

  yrStrt=  1979
  yrLast=  2010

  mStrt  = 11   	; start month
  ssd    = 151	 	; 61(ND),59(FM) a season days ; even though its leap year 


  var	=  "V_GDS0_ISBL"; "uwnd"   ; hgt uwnd vwnd air ...

  ;filter parameters

  day1=2.
  day2=8.

  filter  = "fft";  "none" ,"lanczos"
  filterperiod = day1+"-"+day2
  filterdescription =  filter+"_"+filterperiod+"days"

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


        description	= "ERA interim 1.5*1.5 daily data "+filterdescription+" by Huang Ying";     description= "NCEP/NCAR reanalysis 1 daily data without any filtering or other reprocess that averaged to monthly data by Huang Ying"

  	foutname 	= var+string_level+string_lat+string_lon+"_year"+yrStrt+"-"+yrLast+"M"+mStrt+"D"+ssd+filterdescription+".nc"

	print("to calculate"+description)

	print("to calculate"+foutname)

;;;;;;;;;;;;;;;;;;;;;;;;;;reading nc data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  years	= ispan(yrStrt,yrLast,1) 
  dir ="/lustre/huangy/ERAinterim/nc/"
  ;dir	= "/home/huangy/work/reanalysis1/daily/pressure/"
  ;print(dir+var+"."+years(0)+".nc")
  ; f	= addfile(dir+var+"."+years(1)+".nc","r");
  
  print("reading nc files")
  ;f	= addfiles(dir+var+"."+years+".nc","r");f     = addfile (dir+var+".mon.mean.nc", "r")  ;   
  f	= addfiles(dir+"v_utc_00_"+years+".nc","r")
 ; print(f[0]->lv_ISBL1)
   ; print(f[0]->lv_ISBL1({plevL-1:plevU+1}))
   ; x 	= f[:]->$var$(:,{plevL},{latS:latN},{lonL:lonR}) 
  x 	= f[:]->$var$(:,{plevL:plevU},{latS:latN},{lonL:lonR}) 
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;filtering;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  print("begin fft filtering")
  xt	= x(lv_ISBL1|:,g0_lat_2|:,g0_lon_3|:,initial_time0_hours|:)

  ;fcf     = fspan(1.0/dimsizes_n(xt,2), 0.5, dimsizes_n(xt,2)/2)   
  fcf     = ispan(1,dimsizes_n(xt,3)/2,1)*1.0/dimsizes_n(xt,3)  ; v6.1 has bug use v6.2; see NCL website frequencies spacing ; dimsizes of time coordinate
  printVarSummary(fcf)

  cf      = ezfftf (xt)                    ; sub period (2, nlon , nlat,  ntim/2)
  
  fca = 1./day2
  fcb = 1./day1   ; band pass

  ifcf    = ind(fcf.lt.fca .or. fcf.gt.fcb)   ; to remove

  printVarSummary(ifcf)

  cf(:,:,:,:,ifcf) = 0.0                        ; set coef to zero
  xfft    = ezfftb (cf, cf@xbar)
  xfft!0 = "lv_ISBL1"
  xfft!1 = "g0_lat_2"
  xfft!2 = "g0_lon_3"
  xfft!3 = "initial_time0_hours"
  printinfo(xfft,"xfft") 

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

  xfft_pick    = xfft(initial_time0_hours|ittssd,lv_ISBL1|:,g0_lat_2|:,g0_lon_3|:)

  printinfo(xfft_pick,"xfft_pick")

  Time_pick_up	= TIME(ittssd)
  Time_pick_up@units  = TIME@units
  utc_date_pick_up	= ut_calendar(Time_pick_up, 0)
  YYYY_pick_up	  	= tointeger(utc_date_pick_up(:,0))    ; Convert to integer for
  MM_pick_up		= tointeger(utc_date_pick_up(:,1))    ; use sprinti 
  DD_pick_up		= tointeger(utc_date_pick_up(:,2))    ;

 print( YYYY_pick_up*10000+MM_pick_up*100+DD_pick_up)
;;;;;;;;;;;;;;;;;;;;;;;;;;;save nc file;;;;;;;;;;;;;;;;;;;
 print("creating nc file and saving...")

	if (isfilepresent(foutname))
    		print( systemfunc("rm ./"+foutname) )
 	end if

	fout  = addfile (foutname, "c")  	; open output file

        x_output=xfft_pick
	x_output@description = description
	x_output@actual_range = (/min(x_output),max(x_output)/)
	Lat@actual_range =  (/ min(Lat),max(Lat) /)
        Plev@actual_range =  (/ min(Plev),max(Plev) /)
	Lon@actual_range = (/ min(Lon),max(Lon) /)

	fout->$var$ = x_output ;xfft_pick
	fout->initial_time0_hours  = Time_pick_up
	fout->time_YYYYMMDD = YYYY_pick_up*10000+MM_pick_up*100+DD_pick_up
	fout->lv_ISBL1 = Plev
	fout->g0_lat_2   = Lat
	fout->g0_lon_3   = Lon

  	system("ncdump -c "+foutname)


 end  
