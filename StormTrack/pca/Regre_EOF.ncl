;this script is to choose area and proform EOF on the data
;load "$ncl_myfunc/see.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; EOFdir="~/workdata/StormTrack/eof_U/"
; EOFname="uwnd_monthly_lev250_lat0-87_lon20-130_year1979-2010_original"
 EOFdir="./"
 EOFname= "EOF_uwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010deseasonal3-lowpassNwgt61-0.0322581"
 Regdir = "~/workdata/StormTrack/data_preprocess/data_to_be_som/"
 Regname= "vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1"

; =============================================================
; Open the file: Read only the user specified period and level
; ==============================================================
 
  print("reading EOF file ")
  f    = addfile (EOFdir+EOFname+".nc", "r")
  Time_yyyymmdd	= f->time_yyyymmdd;
  eof_ts_nor	= f->eof_ts_nor;
  neof	= dimsizes(f->evn)	

  fR	= addfile(Regdir+Regname+".nc","r")
  xR	= fR->var 
  Time_yyyymmddR = fR->time_yyyymmdd;
  timeR= fR->time
  
  timeequal=(Time_yyyymmdd .eq. Time_yyyymmddR)
  if ( ismissing(ind(timeequal .eq. False) ) )
  else
  print("time series not match")
  break
  end if

;; =================================================================
; Regress
; =================================================================
 dimsize_xR=dimsizes(xR)
 dimsize_xR(0)=neof;
 eof_regres = new((dimsize_xR),"float")                ; create an array w meta data

  do ne=0,neof-1
     eof_regres(ne,:,:) = (/ regCoef(eof_ts_nor(ne,:), xR(lat|:, lon|:,time|:)) /) ;

  end do 
  eof_regres!0="evn"
  eof_regres!1=xR!1
  eof_regres!2=xR!2

    fnc  =  "Reg_"+Regname+"_of_"+EOFname+".nc"
  if (isfilepresent(fnc))
    print( systemfunc("rm ./"+fnc) )
  end if
; system("/bin/rm -f "+fnc)               ; rm any pre-existing file            
  fout         = addfile(fnc, "c")   ; new netCDF file                   
  
  fout@title   = " Regression "+Regname + " of " + EOFname
  fout->eof_regres    = eof_regres
  fout->eof_ts_nor = eof_ts_nor
  fout->lat	= fR->lat
  fout->lon	= fR->lon
;  fout->sig    = sig ; only can be used in NCL version 6.3 
 ; printVarSummary(time)
 ; printVarSummary(Time_yyyymmdd)
  fout->time_yyyymmdd = Time_yyyymmddR
  fout->pcvar=f->pcvar
  fout->delta_pcvar=f->delta_pcvar
  fout->time = timeR

  fout@optEOF = f@optEOF
  fout@optETS = f@optETS
  fout@EOFname = EOFname
  fout@EOFdir  = EOFdir
  fout@Regname = Regname
  fout@Regdir  = Regdir
  fout@creation_date = systemfunc ("date")  

  end
; 


