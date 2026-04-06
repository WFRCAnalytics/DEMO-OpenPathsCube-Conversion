
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 05_REMM_AvgTravelTime.txt)



;get start time
ScriptStartTime = currenttime()




 RUN PGM=MATRIX  MSG='REMM: calculate average travel time by TAZ'
  FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
  FILEI MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_Pk.mtx'
  FILEI MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_Pk.mtx'
  FILEI MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_Pk.mtx'
  FILEI MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_Pk.mtx'
  FILEI MATI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_Pk.mtx'
  FILEI MATI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_Pk.mtx'
  FILEI MATI[8] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_Pk.mtx'
  FILEI MATI[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_Pk.mtx'
  FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_Pk.mtx'
  FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_Pk.mtx'
  FILEI MATI[12] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_Pk.mtx'
  FILEI MATI[13] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_Pk.mtx'

  FILEI MATI[14] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Pk.mtx'

  
  MW[1] = MI.1.ivt_GP
  MW[2] = MI.2.INITWAIT + MI.2.XFERWAIT + MI.2.DRIVETIME + MI.2.T456789 + MI.2.WALKTIME
  MW[3] = MI.3.INITWAIT + MI.3.XFERWAIT + MI.3.DRIVETIME + MI.3.T456789 + MI.3.WALKTIME
  MW[4] = MI.4.INITWAIT + MI.4.XFERWAIT + MI.4.DRIVETIME + MI.4.T456789 + MI.4.WALKTIME
  MW[5] = MI.5.INITWAIT + MI.5.XFERWAIT + MI.5.DRIVETIME + MI.5.T456789 + MI.5.WALKTIME
  MW[6] = MI.6.INITWAIT + MI.6.XFERWAIT + MI.6.DRIVETIME + MI.6.T456789 + MI.6.WALKTIME
  MW[7] = MI.7.INITWAIT + MI.7.XFERWAIT + MI.7.DRIVETIME + MI.7.T456789 + MI.7.WALKTIME
  MW[8] = MI.8.INITWAIT + MI.8.XFERWAIT + MI.8.DRIVETIME + MI.8.T456789 + MI.8.WALKTIME
  MW[9] = MI.9.INITWAIT + MI.9.XFERWAIT + MI.9.DRIVETIME + MI.9.T456789 + MI.9.WALKTIME
  MW[10] = MI.10.INITWAIT + MI.10.XFERWAIT + MI.10.DRIVETIME + MI.10.T456789 + MI.10.WALKTIME
  MW[11] = MI.11.INITWAIT + MI.11.XFERWAIT + MI.11.DRIVETIME + MI.11.T456789 + MI.11.WALKTIME
  MW[12] = MI.12.INITWAIT + MI.12.XFERWAIT + MI.12.DRIVETIME + MI.12.T456789 + MI.12.WALKTIME
  MW[13] = MI.13.INITWAIT + MI.13.XFERWAIT + MI.13.DRIVETIME + MI.13.T456789 + MI.13.WALKTIME

  
  MW[41] = MI.14.auto
  MW[42] = MI.14.dLCL
  MW[43] = MI.14.dCOR
  MW[44] = MI.14.dEXP
  MW[45] = MI.14.dLRT
  MW[46] = MI.14.dCRT
  MW[47] = MI.14.dBRT
  MW[48] = MI.14.wLCL
  MW[49] = MI.14.wCOR
  MW[50] = MI.14.wEXP
  MW[51] = MI.14.wLRT
  MW[52] = MI.14.wCRT
  MW[53] = MI.14.wBRT
  
    
    ZONEMSG = 10
    
    
    if (i=1)
        PRINT CSV=T,  
            FILE='@ParentDir@@ScenarioDir@6_REMM\AvgTravelTime.csv', 
            FORM=15.2, 
            LIST='TAZ',
                 'TIMEAuto',
                 'TIMETran'
    endif
    
    
    JLOOP
        
        if (j=1)
            _TIMETRIPAuto = 0
            _TRIPAuto     = 0
            
            _TIMETRIPTran = 0
            _TRIPTran     = 0
        endif
        
        _TIMETRIPAuto = _TIMETRIPAuto  +  MW[1] * MW[41]
        _TRIPAuto     = _TRIPAuto + MW[41]
        
        _TIMETRIPTran = _TIMETRIPTran  +  MW[02] * MW[42] +
                                          MW[03] * MW[43] +
                                          MW[04] * MW[44] +
                                          MW[05] * MW[45] +
                                          MW[06] * MW[46] +
                                          MW[07] * MW[47] +
                                          MW[08] * MW[48] +
                                          MW[09] * MW[49] +
                                          MW[10] * MW[50] +
                                          MW[11] * MW[51] +
                                          MW[12] * MW[52] +
                                          MW[13] * MW[53]
        
        _TRIPTran = _TRIPTran + MW[42] +
                                MW[43] +
                                MW[44] +
                                MW[45] +
                                MW[46] +
                                MW[47] +
                                MW[48] +
                                MW[49] +
                                MW[50] +
                                MW[51] +
                                MW[52] +
                                MW[53]  
        
    ENDJLOOP

       if (_TRIPAuto=0)
          time1=_time1
       else
          time1=_TIMETRIPAuto/_TRIPAuto
          _time1=time1
       endif
      
       if (_TRIPTran=0)
          time2=_time2
       else
          time2=_TIMETRIPTran/_TRIPTran
          _time2=time2
       endif
    
      PRINT CSV=T,  file='@ParentDir@@ScenarioDir@6_REMM\AvgTravelTime.csv', 
          FORM=15.2, 
          LIST= i,
                time1,
                time2  

 ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Calculate avg travel time          ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 05_REMM_AvgTravelTime.txt)
