
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 16_SharesReport.txt)



;get start time
ScriptStartTime = currenttime()




;Cluster: distrubute MATRIX call onto processor 2
DistributeMultiStep Alias='Shares_Proc2'

    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - peak'
      FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Pk.mtx'
      FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Pk.mtx'
      FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Pk.mtx'
      FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Pk.mtx'
      FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
      FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
     
      FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Pk_auto_managedlanes.mtx'       ; HBW trip table 
            MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Pk_auto_managedlanes.mtx'       ; HBC trip table 
            MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Pk_auto_managedlanes.mtx'       ; HBO trip table  
            MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_Pk_auto_managedlanes.mtx'       ; NHB trip table  
      
      ZONEMSG = 10
    
    ;******************************** HBW summary values
    JLOOP 
      if (I=1-@UsedZones@  |  J=1-@UsedZones@)
        _HBWMOTOR = _HBWMOTOR + mi.01.motor[j] 
        _HBWNONMO = _HBWNONMO + mi.01.nonmotor[j]
        _HBWTRANT = _HBWTRANT + mi.01.transit[j]
        _HBWAUTOT = _HBWAUTOT + mi.01.auto[j]
        _HBWAUTO1 = _HBWAUTO1 + mi.01.DA[j]
        _HBWAUTO2 = _HBWAUTO2 + mi.01.SR2[j]
        _HBWAUTO3 = _HBWAUTO3 + mi.01.SR3p[j]  
        _HBWLCLW  = _HBWLCLW  + mi.01.wLCL[j]
        _HBWLCLD  = _HBWLCLD  + mi.01.dLCL[j]
        _HBWCORW  = _HBWCORW  + mi.01.wCOR[j]
        _HBWCORD  = _HBWCORD  + mi.01.dCOR[j]
        _HBWEXPW  = _HBWEXPW  + mi.01.wEXP[j]
        _HBWEXPD  = _HBWEXPD  + mi.01.dEXP[j]
        _HBWLRTW  = _HBWLRTW  + mi.01.wLRT[j]
        _HBWLRTD  = _HBWLRTD  + mi.01.dLRT[j]
        _HBWCRTW  = _HBWCRTW  + mi.01.wCRT[j]
        _HBWCRTD  = _HBWCRTD  + mi.01.dCRT[j]
        _HBWTRANW = _HBWTRANW + mi.01.wTRN[j] ;sum of walk access to transit
        _HBWTRAND = _HBWTRAND + mi.01.dTRN[j] ;sum of drive access to transit  
    
        _HBWBRTW  = _HBWBRTW  + mi.01.wBRT[j]
        _HBWBRTD  = _HBWBRTD  + mi.01.dBRT[j]
    
        _HBW_DANON  = _HBW_DANON  + mi.07.alone_non[j] 
        _HBW_DATOL  = _HBW_DATOL  + mi.07.alone_toll[j]
        _HBW_SR2NON = _HBW_SR2NON + mi.07.sr2_non[j]
        _HBW_SR2TOL = _HBW_SR2TOL + mi.07.sr2_toll[j]  
        _HBW_SR2HOV = _HBW_SR2HOV + mi.07.sr2_hov[j]
        _HBW_SR3NON = _HBW_SR3NON + mi.07.sr3_non[j]
        _HBW_SR3TOL = _HBW_SR3TOL + mi.07.sr3_toll[j]
        _HBW_SR3HOV = _HBW_SR3HOV + mi.07.sr3_hov[j]
    
        
        _HBCMOTOR = _HBCMOTOR + mi.02.motor[j] 
        _HBCNONMO = _HBCNONMO + mi.02.nonmotor[j]
        _HBCTRANT = _HBCTRANT + mi.02.transit[j]
        _HBCAUTOT = _HBCAUTOT + mi.02.auto[j]
        _HBCAUTO1 = _HBCAUTO1 + mi.02.DA[j]
        _HBCAUTO2 = _HBCAUTO2 + mi.02.SR2[j]
        _HBCAUTO3 = _HBCAUTO3 + mi.02.SR3p[j]  
        _HBCLCLW  = _HBCLCLW  + mi.02.wLCL[j]
        _HBCLCLD  = _HBCLCLD  + mi.02.dLCL[j]
        _HBCCORW  = _HBCCORW  + mi.02.wCOR[j]
        _HBCCORD  = _HBCCORD  + mi.02.dCOR[j]
        _HBCEXPW  = _HBCEXPW  + mi.02.wEXP[j]
        _HBCEXPD  = _HBCEXPD  + mi.02.dEXP[j]
        _HBCLRTW  = _HBCLRTW  + mi.02.wLRT[j]
        _HBCLRTD  = _HBCLRTD  + mi.02.dLRT[j]
        _HBCCRTW  = _HBCCRTW  + mi.02.wCRT[j]
        _HBCCRTD  = _HBCCRTD  + mi.02.dCRT[j]
        _HBCTRANW = _HBCTRANW + mi.02.wTRN[j];sum of walk access to transit
        _HBCTRAND = _HBCTRAND + mi.02.dTRN[j] ;sum of drive access to transit  
    
        _HBCBRTW  = _HBCBRTW  + mi.02.wBRT[j]
        _HBCBRTD  = _HBCBRTD  + mi.02.dBRT[j]
    
        _HBC_DANON  = _HBC_DANON  + mi.08.alone_non[j] 
        _HBC_SR2NON = _HBC_SR2NON + mi.08.sr2_non[j]
        _HBC_SR3NON = _HBC_SR3NON + mi.08.sr3_non[j]
        _HBC_SR2HOV = _HBC_SR2HOV + mi.08.sr2_hov[j]
        _HBC_SR3HOV = _HBC_SR3HOV + mi.08.sr3_hov[j]
        _HBC_DATOL  = _HBC_DATOL  + mi.08.alone_toll[j]
        _HBC_SR2TOL = _HBC_SR2TOL + mi.08.sr2_toll[j]    
        _HBC_SR3TOL = _HBC_SR3TOL + mi.08.sr3_toll[j]
        
                
        _HBOMOTOR = _HBOMOTOR + mi.03.motor[j] 
        _HBONONMO = _HBONONMO + mi.03.nonmotor[j]
        _HBOTRANT = _HBOTRANT + mi.03.transit[j]
        _HBOAUTOT = _HBOAUTOT + mi.03.auto[j]
        _HBOAUTO1 = _HBOAUTO1 + mi.03.DA[j]
        _HBOAUTO2 = _HBOAUTO2 + mi.03.SR2[j]
        _HBOAUTO3 = _HBOAUTO3 + mi.03.SR3p[j]    
        _HBOLCLW  = _HBOLCLW  + mi.03.wLCL[j]
        _HBOLCLD  = _HBOLCLD  + mi.03.dLCL[j]
        _HBOCORW  = _HBOCORW  + mi.03.wCOR[j]
        _HBOCORD  = _HBOCORD  + mi.03.dCOR[j]
        _HBOEXPW  = _HBOEXPW  + mi.03.wEXP[j]
        _HBOEXPD  = _HBOEXPD  + mi.03.dEXP[j]
        _HBOLRTW  = _HBOLRTW  + mi.03.wLRT[j]
        _HBOLRTD  = _HBOLRTD  + mi.03.dLRT[j]
        _HBOCRTW  = _HBOCRTW  + mi.03.wCRT[j]
        _HBOCRTD  = _HBOCRTD  + mi.03.dCRT[j]
        _HBOTRANW = _HBOTRANW + mi.03.wTRN[j] ;sum of walk access to transit
        _HBOTRAND = _HBOTRAND + mi.03.dTRN[j] ;sum of drive access to transit     
    
        _HBOBRTW  = _HBOBRTW  + mi.03.wBRT[j]
        _HBOBRTD  = _HBOBRTD  + mi.03.dBRT[j]
    
        _HBO_DANON  = _HBO_DANON  + mi.09.alone_non[j] 
        _HBO_SR2NON = _HBO_SR2NON + mi.09.sr2_non[j]
        _HBO_SR3NON = _HBO_SR3NON + mi.09.sr3_non[j]
        _HBO_SR2HOV = _HBO_SR2HOV + mi.09.sr2_hov[j]
        _HBO_SR3HOV = _HBO_SR3HOV + mi.09.sr3_hov[j]
        _HBO_DATOL  = _HBO_DATOL  + mi.09.alone_toll[j]
        _HBO_SR2TOL = _HBO_SR2TOL + mi.09.sr2_toll[j]
        _HBO_SR3TOL = _HBO_SR3TOL + mi.09.sr3_toll[j]
        
    
        _NHBMOTOR = _NHBMOTOR + mi.04.motor[j] 
        _NHBNONMO = _NHBNONMO + mi.04.nonmotor[j]
        _NHBTRANT = _NHBTRANT + mi.04.transit[j]
        _NHBAUTOT = _NHBAUTOT + mi.04.auto[j]
        _NHBAUTO1 = _NHBAUTO1 + mi.04.DA[j]
        _NHBAUTO2 = _NHBAUTO2 + mi.04.SR2[j]
        _NHBAUTO3 = _NHBAUTO3 + mi.04.SR3p[j]  
        _NHBLCLW  = _NHBLCLW  + mi.04.wLCL[j]
        _NHBLCLD  = _NHBLCLD  + mi.04.dLCL[j]
        _NHBCORW  = _NHBCORW  + mi.04.wCOR[j]
        _NHBCORD  = _NHBCORD  + mi.04.dCOR[j]
        _NHBEXPW  = _NHBEXPW  + mi.04.wEXP[j]
        _NHBEXPD  = _NHBEXPD  + mi.04.dEXP[j]
        _NHBLRTW  = _NHBLRTW  + mi.04.wLRT[j]
        _NHBLRTD  = _NHBLRTD  + mi.04.dLRT[j]
        _NHBCRTW  = _NHBCRTW  + mi.04.wCRT[j]
        _NHBCRTD  = _NHBCRTD  + mi.04.dCRT[j]
        _NHBTRANW = _NHBTRANW + mi.04.wTRN[j] ;sum of walk access to transit
        _NHBTRAND = _NHBTRAND + mi.04.dTRN[j] ;sum of drive access to transit   
    
        _NHBBRTW  = _NHBBRTW  + mi.04.wBRT[j]
        _NHBBRTD  = _NHBBRTD  + mi.04.dBRT[j]
        
        _NHB_DANON  = _NHB_DANON  + mi.10.alone_non[j] 
        _NHB_SR2NON = _NHB_SR2NON + mi.10.sr2_non[j]
        _NHB_SR3NON = _NHB_SR3NON + mi.10.sr3_non[j]
        _NHB_SR2HOV = _NHB_SR2HOV + mi.10.sr2_hov[j]
        _NHB_SR3HOV = _NHB_SR3HOV + mi.10.sr3_hov[j]
        _NHB_DATOL  = _NHB_DATOL  + mi.10.alone_toll[j]
        _NHB_SR2TOL = _NHB_SR2TOL + mi.10.sr2_toll[j]    
        _NHB_SR3TOL = _NHB_SR3TOL + mi.10.sr3_toll[j]
        
        
        PR_HBSch_SB = PR_HBSch_SB + mi.05.Pk_SchoolBus[j]
        PR_HBSch_DS = PR_HBSch_DS + mi.05.Pk_DriveSelf[j]
        PR_HBSch_DO = PR_HBSch_DO + mi.05.Pk_DropOff[j]
        PR_HBSch_Wk = PR_HBSch_Wk + mi.05.Pk_Walk[j]
        PR_HBSch_Bk = PR_HBSch_Bk + mi.05.Pk_Bike[j]
        
        SC_HBSch_SB = SC_HBSch_SB + mi.06.Pk_SchoolBus[j]
        SC_HBSch_DS = SC_HBSch_DS + mi.06.Pk_DriveSelf[j]
        SC_HBSch_DO = SC_HBSch_DO + mi.06.Pk_DropOff[j]
        SC_HBSch_Wk = SC_HBSch_Wk + mi.06.Pk_Walk[j]
        SC_HBSch_Bk = SC_HBSch_Bk + mi.06.Pk_Bike[j]
        
      endif
    ENDJLOOP
    
    
    ;************** Once i-loop is finished, create summary
    if (i==zones)
        ;HBSch totals
        _HBS_SB = PR_HBSch_SB +
                  SC_HBSch_SB
        
        _HBS_DS = PR_HBSch_DS +
                  SC_HBSch_DS
        
        _HBS_DO = PR_HBSch_DO +
                  SC_HBSch_DO
        
        _HBSMOTOR_PR = PR_HBSch_SB +
                       PR_HBSch_DS +
                       PR_HBSch_DO
        
        _HBSMOTOR_SC = SC_HBSch_SB +
                       SC_HBSch_DS +
                       SC_HBSch_DO
        
        _HBSMOTOR = _HBSMOTOR_PR +
                    _HBSMOTOR_SC
        
        _HBSNONMO = PR_HBSch_Wk +
                    PR_HBSch_Bk +
                    SC_HBSch_Wk +
                    SC_HBSch_Bk
        
        _HBSTRIPT = _HBSMOTOR + _HBSNONMO
        
      ;Grand total trips is Motor + Non-Motor
      _HBWTRIPT = _HBWMOTOR + _HBWNONMO 
      _HBCTRIPT = _HBCMOTOR + _HBCNONMO 
      _HBOTRIPT = _HBOMOTOR + _HBONONMO 
      _NHBTRIPT = _NHBMOTOR + _NHBNONMO 
    
      ;Total transit is sum of walk + drive
      _HBWLCLT = _HBWLCLW + _HBWLCLD
      _HBWCORT = _HBWCORW + _HBWCORD
      _HBWEXPT = _HBWEXPW + _HBWEXPD
      _HBWLRTT = _HBWLRTW + _HBWLRTD
      _HBWCRTT = _HBWCRTW + _HBWCRTD
      _HBWBRTT = _HBWBRTW + _HBWBRTD
    
      _HBCLCLT = _HBCLCLW + _HBCLCLD
      _HBCCORT = _HBCCORW + _HBCCORD
      _HBCEXPT = _HBCEXPW + _HBCEXPD
      _HBCLRTT = _HBCLRTW + _HBCLRTD
      _HBCCRTT = _HBCCRTW + _HBCCRTD
      _HBCBRTT = _HBCBRTW + _HBCBRTD
    
      _HBOLCLT = _HBOLCLW + _HBOLCLD
      _HBOCORT = _HBOCORW + _HBOCORD
      _HBOEXPT = _HBOEXPW + _HBOEXPD
      _HBOLRTT = _HBOLRTW + _HBOLRTD
      _HBOCRTT = _HBOCRTW + _HBOCRTD
      _HBOBRTT = _HBOBRTW + _HBOBRTD
    
      _NHBLCLT = _NHBLCLW + _NHBLCLD
      _NHBCORT = _NHBCORW + _NHBCORD
      _NHBEXPT = _NHBEXPW + _NHBEXPD
      _NHBLRTT = _NHBLRTW + _NHBLRTD
      _NHBCRTT = _NHBCRTW + _NHBCRTD
      _NHBBRTT = _NHBBRTW + _NHBBRTD
    
      ;Total the purposes
      _TOTTRIPT = _HBWTRIPT + 
                  _HBCTRIPT + 
                  _HBOTRIPT + 
                  _NHBTRIPT + 
                  _HBSTRIPT*100                         ;added HBSch
      
        _TOTNONMO = _HBWNONMO + 
                    _HBCNONMO + 
                    _HBONONMO + 
                    _NHBNONMO + 
                    _HBSNONMO*100                       ;added HBSch
        
        _TOTMOTOR = _HBWMOTOR + 
                    _HBCMOTOR + 
                    _HBOMOTOR + 
                    _NHBMOTOR + 
                    _HBSMOTOR*100                       ;added HBSch
          
          _TOTAUTOT = _HBWAUTOT + 
                      _HBCAUTOT + 
                      _HBOAUTOT + 
                      _NHBAUTOT + 
                      _HBSMOTOR*100                       ;added HBSch
          
            _TOTAUTO1 = _HBWAUTO1 + _HBCAUTO1 + _HBOAUTO1 + _NHBAUTO1
              _TOT_DANON = _HBW_DANON + _HBC_DANON + _HBO_DANON + _NHB_DANON
              _TOT_DATOL = _HBW_DATOL + _HBC_DATOL + _HBO_DATOL + _NHB_DATOL
            _TOTAUTO2 = _HBWAUTO2 + _HBCAUTO2 + _HBOAUTO2 + _NHBAUTO2
              _TOT_SR2NON = _HBW_SR2NON + _HBC_SR2NON + _HBO_SR2NON + _NHB_SR2NON
              _TOT_SR2TOL = _HBW_SR2TOL + _HBC_SR2TOL + _HBO_SR2TOL + _NHB_SR2TOL
              _TOT_SR2HOV = _HBW_SR2HOV + _HBC_SR2HOV + _HBO_SR2HOV + _NHB_SR2HOV
            _TOTAUTO3 = _HBWAUTO3 + _HBCAUTO3 + _HBOAUTO3 + _NHBAUTO3
              _TOT_SR3NON = _HBW_SR3NON + _HBC_SR3NON + _HBO_SR3NON + _NHB_SR3NON
              _TOT_SR3TOL = _HBW_SR3TOL + _HBC_SR3TOL + _HBO_SR3TOL + _NHB_SR3TOL
              _TOT_SR3HOV = _HBW_SR3HOV + _HBC_SR3HOV + _HBO_SR3HOV + _NHB_SR3HOV
                    
          _TOTTRANT = _HBWTRANT + _HBCTRANT + _HBOTRANT + _NHBTRANT
            _TOTLCLT = _HBWLCLT + _HBCLCLT + _HBOLCLT + _NHBLCLT
              _TOTLCLW  = _HBWLCLW  + _HBCLCLW  + _HBOLCLW  + _NHBLCLW
              _TOTLCLD  = _HBWLCLD  + _HBCLCLD  + _HBOLCLD  + _NHBLCLD
            _TOTCORT = _HBWCORT + _HBCCORT + _HBOCORT + _NHBCORT
              _TOTCORW  = _HBWCORW  + _HBCCORW  + _HBOCORW  + _NHBCORW
              _TOTCORD  = _HBWCORD  + _HBCCORD  + _HBOCORD  + _NHBCORD
            _TOTEXPT = _HBWEXPT + _HBCEXPT + _HBOEXPT + _NHBEXPT
              _TOTEXPW  = _HBWEXPW  + _HBCEXPW  + _HBOEXPW  + _NHBEXPW
              _TOTEXPD  = _HBWEXPD  + _HBCEXPD  + _HBOEXPD  + _NHBEXPD
            _TOTLRTT = _HBWLRTT + _HBCLRTT + _HBOLRTT + _NHBLRTT
              _TOTLRTW  = _HBWLRTW  + _HBCLRTW  + _HBOLRTW  + _NHBLRTW
              _TOTLRTD  = _HBWLRTD  + _HBCLRTD  + _HBOLRTD  + _NHBLRTD
            _TOTCRTT = _HBWCRTT + _HBCCRTT + _HBOCRTT + _NHBCRTT
              _TOTCRTW  = _HBWCRTW  + _HBCCRTW  + _HBOCRTW  + _NHBCRTW
              _TOTCRTD  = _HBWCRTD  + _HBCCRTD  + _HBOCRTD  + _NHBCRTD    
            _TOTBRTT = _HBWBRTT + _HBCBRTT + _HBOBRTT + _NHBBRTT
              _TOTBRTW  = _HBWBRTW  + _HBCBRTW  + _HBOBRTW  + _NHBBRTW
              _TOTBRTD  = _HBWBRTD  + _HBCBRTD  + _HBOBRTD  + _NHBBRTD 
    
        
      ;*********************** Note:  Purpose blocks are identical but for HBW, HBC, etc; so updates can be easily made by changing these prefixes.
      ;*********************** Compute HBW absolute share info
      if (_HBWTRIPT!=0)  
        _HBWNONMO_SABS = (_HBWNONMO / _HBWTRIPT)*100  ;Absolute Non-Motorized Share
        _HBWMOTOR_SABS = (_HBWMOTOR / _HBWTRIPT)*100  ;Absolute Motorized Share
          _HBWAUTOT_SABS = (_HBWAUTOT / _HBWTRIPT)*100  ;Absolute Auto Share
            _HBWAUTO1_SABS = (_HBWAUTO1 / _HBWTRIPT)*100  ;Absolute Drive-Alone Share
              _HBW_DANON_SABS = (_HBW_DANON / _HBWTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBW_DATOL_SABS = (_HBW_DATOL / _HBWTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBWAUTO2_SABS = (_HBWAUTO2 / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBW_SR2NON_SABS = (_HBW_SR2NON / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBW_SR2TOL_SABS = (_HBW_SR2TOL / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBW_SR2HOV_SABS = (_HBW_SR2HOV / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBWAUTO3_SABS = (_HBWAUTO3 / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBW_SR3NON_SABS = (_HBW_SR3NON / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBW_SR3TOL_SABS = (_HBW_SR3TOL / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBW_SR3HOV_SABS = (_HBW_SR3HOV / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBWTRANT_SABS = (_HBWTRANT / _HBWTRIPT)*100  ;Absolute Transit Share
            _HBWLCLT_SABS = (_HBWLCLT / _HBWTRIPT)*100  ;Absolute Transit Local Share
              _HBWLCLW_SABS = (_HBWLCLW / _HBWTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBWLCLD_SABS = (_HBWLCLD / _HBWTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBWCORT_SABS = (_HBWCORT / _HBWTRIPT)*100  ;Absolute Transit COR Share
              _HBWCORW_SABS = (_HBWCORW / _HBWTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBWCORD_SABS = (_HBWCORD / _HBWTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBWEXPT_SABS = (_HBWEXPT / _HBWTRIPT)*100  ;Absolute Transit Express Share
              _HBWEXPW_SABS = (_HBWEXPW / _HBWTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBWEXPD_SABS = (_HBWEXPD / _HBWTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBWLRTT_SABS = (_HBWLRTT / _HBWTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBWLRTW_SABS = (_HBWLRTW / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBWLRTD_SABS = (_HBWLRTD / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBWCRTT_SABS = (_HBWCRTT / _HBWTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBWCRTW_SABS = (_HBWCRTW / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBWCRTD_SABS = (_HBWCRTD / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBWBRTT_SABS = (_HBWBRTT / _HBWTRIPT)*100  ;Absolute Transit BRT Share
              _HBWBRTW_SABS = (_HBWBRTW / _HBWTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBWBRTD_SABS = (_HBWBRTD / _HBWTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBW relative share info
      if (_HBWTRIPT!=0)  
        _HBWMOTOR_SREL = (_HBWMOTOR / _HBWTRIPT)*100  ;Relative Motorized Share
        _HBWNONMO_SREL = (_HBWNONMO / _HBWTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBWMOTOR!=0)  
          _HBWAUTOT_SREL = (_HBWAUTOT / _HBWMOTOR)*100  ;Relative Auto Share
          _HBWTRANT_SREL = (_HBWTRANT / _HBWMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBWAUTOT!=0)  
            _HBWAUTO1_SREL = (_HBWAUTO1 / _HBWAUTOT)*100  ;Relative Drive-Alone Share
            _HBWAUTO2_SREL = (_HBWAUTO2 / _HBWAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBWAUTO3_SREL = (_HBWAUTO3 / _HBWAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBWAUTO1!=0)  
              _HBW_DANON_SREL = (_HBW_DANON / _HBWAUTO1)*100  ;Relative DA non-tol
              _HBW_DATOL_SREL = (_HBW_DATOL / _HBWAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBWAUTO2!=0)  
              _HBW_SR2NON_SREL = (_HBW_SR2NON / _HBWAUTO2)*100  
              _HBW_SR2TOL_SREL = (_HBW_SR2TOL / _HBWAUTO2)*100  
              _HBW_SR2HOV_SREL = (_HBW_SR2HOV / _HBWAUTO2)*100  
      endif    
      if (_HBWAUTO3!=0)  
              _HBW_SR3NON_SREL = (_HBW_SR3NON / _HBWAUTO3)*100  
              _HBW_SR3TOL_SREL = (_HBW_SR3TOL / _HBWAUTO3)*100  
              _HBW_SR3HOV_SREL = (_HBW_SR3HOV / _HBWAUTO3)*100  
      endif   
      if (_HBWTRANT!=0)  
            _HBWLCLT_SREL = (_HBWLCLT / _HBWTRANT)*100  ;Relative Transit Local Share
            _HBWCORT_SREL = (_HBWCORT / _HBWTRANT)*100  ;Relative Transit COR Share
            _HBWEXPT_SREL = (_HBWEXPT / _HBWTRANT)*100  ;Relative Transit Express Share
            _HBWLRTT_SREL = (_HBWLRTT / _HBWTRANT)*100  ;Relative Transit Light-Rail Share
            _HBWCRTT_SREL = (_HBWCRTT / _HBWTRANT)*100  ;Relative Transit Commuter rail Share
            _HBWBRTT_SREL = (_HBWBRTT / _HBWTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBWLCLT!=0)  
              _HBWLCLW_SREL = (_HBWLCLW / _HBWLCLT)*100  ;Relative Transit Local-Walk Share
              _HBWLCLD_SREL = (_HBWLCLD / _HBWLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBWLCLW_SREL = .0001
              _HBWLCLD_SREL = .0001          
      endif
      if (_HBWCORT!=0)  
              _HBWCORW_SREL = (_HBWCORW / _HBWCORT)*100  ;Relative Transit COR-Walk Share
              _HBWCORD_SREL = (_HBWCORD / _HBWCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBWCORW_SREL = .0001
              _HBWCORD_SREL = .0001          
      endif
      if (_HBWEXPT!=0)  
              _HBWEXPW_SREL = (_HBWEXPW / _HBWEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBWEXPD_SREL = (_HBWEXPD / _HBWEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBWEXPW_SREL = .0001
              _HBWEXPD_SREL = .0001
      endif 
      if (_HBWLRTT!=0)  
              _HBWLRTW_SREL = (_HBWLRTW / _HBWLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBWLRTD_SREL = (_HBWLRTD / _HBWLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBWLRTW_SREL = .0001
              _HBWLRTD_SREL = .0001
      endif      
      if (_HBWCRTT!=0)  
              _HBWCRTW_SREL = (_HBWCRTW / _HBWCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBWCRTD_SREL = (_HBWCRTD / _HBWCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBWCRTW_SREL = .0001
              _HBWCRTD_SREL = .0001
      endif
      if (_HBWBRTT!=0)  
              _HBWBRTW_SREL = (_HBWBRTW / _HBWBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBWBRTD_SREL = (_HBWBRTD / _HBWBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBWBRTW_SREL = .0001
              _HBWBRTD_SREL = .0001
      endif
    
      
      ;*********************** Compute HBC absolute share info
      if (_HBCTRIPT!=0)  
        _HBCNONMO_SABS = (_HBCNONMO / _HBCTRIPT)*100  ;Absolute Non-Motorized Share
        _HBCMOTOR_SABS = (_HBCMOTOR / _HBCTRIPT)*100  ;Absolute Motorized Share
          _HBCAUTOT_SABS = (_HBCAUTOT / _HBCTRIPT)*100  ;Absolute Auto Share
            _HBCAUTO1_SABS = (_HBCAUTO1 / _HBCTRIPT)*100  ;Absolute Drive-Alone Share
              _HBC_DANON_SABS = (_HBC_DANON / _HBCTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBC_DATOL_SABS = (_HBC_DATOL / _HBCTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBCAUTO2_SABS = (_HBCAUTO2 / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBC_SR2NON_SABS = (_HBC_SR2NON / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBC_SR2TOL_SABS = (_HBC_SR2TOL / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBC_SR2HOV_SABS = (_HBC_SR2HOV / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBCAUTO3_SABS = (_HBCAUTO3 / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBC_SR3NON_SABS = (_HBC_SR3NON / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBC_SR3TOL_SABS = (_HBC_SR3TOL / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBC_SR3HOV_SABS = (_HBC_SR3HOV / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBCTRANT_SABS = (_HBCTRANT / _HBCTRIPT)*100  ;Absolute Transit Share
            _HBCLCLT_SABS = (_HBCLCLT / _HBCTRIPT)*100  ;Absolute Transit Local Share
              _HBCLCLW_SABS = (_HBCLCLW / _HBCTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBCLCLD_SABS = (_HBCLCLD / _HBCTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBCCORT_SABS = (_HBCCORT / _HBCTRIPT)*100  ;Absolute Transit COR Share
              _HBCCORW_SABS = (_HBCCORW / _HBCTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBCCORD_SABS = (_HBCCORD / _HBCTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBCEXPT_SABS = (_HBCEXPT / _HBCTRIPT)*100  ;Absolute Transit Express Share
              _HBCEXPW_SABS = (_HBCEXPW / _HBCTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBCEXPD_SABS = (_HBCEXPD / _HBCTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBCLRTT_SABS = (_HBCLRTT / _HBCTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBCLRTW_SABS = (_HBCLRTW / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBCLRTD_SABS = (_HBCLRTD / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBCCRTT_SABS = (_HBCCRTT / _HBCTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBCCRTW_SABS = (_HBCCRTW / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBCCRTD_SABS = (_HBCCRTD / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBCBRTT_SABS = (_HBCBRTT / _HBCTRIPT)*100  ;Absolute Transit BRT Share
              _HBCBRTW_SABS = (_HBCBRTW / _HBCTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBCBRTD_SABS = (_HBCBRTD / _HBCTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBC relative share info
      if (_HBCTRIPT!=0)  
        _HBCMOTOR_SREL = (_HBCMOTOR / _HBCTRIPT)*100  ;Relative Motorized Share
        _HBCNONMO_SREL = (_HBCNONMO / _HBCTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBCMOTOR!=0)  
          _HBCAUTOT_SREL = (_HBCAUTOT / _HBCMOTOR)*100  ;Relative Auto Share
          _HBCTRANT_SREL = (_HBCTRANT / _HBCMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBCAUTOT!=0)  
            _HBCAUTO1_SREL = (_HBCAUTO1 / _HBCAUTOT)*100  ;Relative Drive-Alone Share
            _HBCAUTO2_SREL = (_HBCAUTO2 / _HBCAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBCAUTO3_SREL = (_HBCAUTO3 / _HBCAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBCAUTO1!=0)  
              _HBC_DANON_SREL = (_HBC_DANON / _HBCAUTO1)*100  ;Relative DA non-tol
              _HBC_DATOL_SREL = (_HBC_DATOL / _HBCAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBCAUTO2!=0)  
              _HBC_SR2NON_SREL = (_HBC_SR2NON / _HBCAUTO2)*100  
              _HBC_SR2TOL_SREL = (_HBC_SR2TOL / _HBCAUTO2)*100  
              _HBC_SR2HOV_SREL = (_HBC_SR2HOV / _HBCAUTO2)*100  
      endif    
      if (_HBCAUTO3!=0)  
              _HBC_SR3NON_SREL = (_HBC_SR3NON / _HBCAUTO3)*100  
              _HBC_SR3TOL_SREL = (_HBC_SR3TOL / _HBCAUTO3)*100  
              _HBC_SR3HOV_SREL = (_HBC_SR3HOV / _HBCAUTO3)*100  
      endif   
      if (_HBCTRANT!=0)  
            _HBCLCLT_SREL = (_HBCLCLT / _HBCTRANT)*100  ;Relative Transit Local Share
            _HBCCORT_SREL = (_HBCCORT / _HBCTRANT)*100  ;Relative Transit COR Share
            _HBCEXPT_SREL = (_HBCEXPT / _HBCTRANT)*100  ;Relative Transit Express Share
            _HBCLRTT_SREL = (_HBCLRTT / _HBCTRANT)*100  ;Relative Transit Light-Rail Share
            _HBCCRTT_SREL = (_HBCCRTT / _HBCTRANT)*100  ;Relative Transit Commuter rail Share
            _HBCBRTT_SREL = (_HBCBRTT / _HBCTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBCLCLT!=0)  
              _HBCLCLW_SREL = (_HBCLCLW / _HBCLCLT)*100  ;Relative Transit Local-Walk Share
              _HBCLCLD_SREL = (_HBCLCLD / _HBCLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLCLW_SREL = .0001
              _HBCLCLD_SREL = .0001          
      endif
      if (_HBCCORT!=0)  
              _HBCCORW_SREL = (_HBCCORW / _HBCCORT)*100  ;Relative Transit COR-Walk Share
              _HBCCORD_SREL = (_HBCCORD / _HBCCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBCCORW_SREL = .0001
              _HBCCORD_SREL = .0001          
      endif
      if (_HBCEXPT!=0)  
              _HBCEXPW_SREL = (_HBCEXPW / _HBCEXPT)*100  ;Relative Transit Local-Walk Share
              _HBCEXPD_SREL = (_HBCEXPD / _HBCEXPT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCEXPW_SREL = .0001
              _HBCEXPD_SREL = .0001
      endif 
      if (_HBCLRTT!=0)  
              _HBCLRTW_SREL = (_HBCLRTW / _HBCLRTT)*100  ;Relative Transit Local-Walk Share
              _HBCLRTD_SREL = (_HBCLRTD / _HBCLRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLRTW_SREL = .0001
              _HBCLRTD_SREL = .0001
      endif      
      if (_HBCCRTT!=0)  
              _HBCCRTW_SREL = (_HBCCRTW / _HBCCRTT)*100  ;Relative Transit Local-Walk Share
              _HBCCRTD_SREL = (_HBCCRTD / _HBCCRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCCRTW_SREL = .0001
              _HBCCRTD_SREL = .0001
      endif
      if (_HBCBRTT!=0)  
              _HBCBRTW_SREL = (_HBCBRTW / _HBCBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBCBRTD_SREL = (_HBCBRTD / _HBCBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBCBRTW_SREL = .0001
              _HBCBRTD_SREL = .0001
      endif
    
      ;*********************** Compute HBO absolute share info
      if (_HBOTRIPT!=0)  
        _HBONONMO_SABS = (_HBONONMO / _HBOTRIPT)*100  ;Absolute Non-Motorized Share
        _HBOMOTOR_SABS = (_HBOMOTOR / _HBOTRIPT)*100  ;Absolute Motorized Share
          _HBOAUTOT_SABS = (_HBOAUTOT / _HBOTRIPT)*100  ;Absolute Auto Share
            _HBOAUTO1_SABS = (_HBOAUTO1 / _HBOTRIPT)*100  ;Absolute Drive-Alone Share
              _HBO_DANON_SABS = (_HBO_DANON / _HBOTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBO_DATOL_SABS = (_HBO_DATOL / _HBOTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBOAUTO2_SABS = (_HBOAUTO2 / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBO_SR2NON_SABS = (_HBO_SR2NON / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBO_SR2TOL_SABS = (_HBO_SR2TOL / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBO_SR2HOV_SABS = (_HBO_SR2HOV / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBOAUTO3_SABS = (_HBOAUTO3 / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBO_SR3NON_SABS = (_HBO_SR3NON / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBO_SR3TOL_SABS = (_HBO_SR3TOL / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBO_SR3HOV_SABS = (_HBO_SR3HOV / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBOTRANT_SABS = (_HBOTRANT / _HBOTRIPT)*100  ;Absolute Transit Share
            _HBOLCLT_SABS = (_HBOLCLT / _HBOTRIPT)*100  ;Absolute Transit Local Share
              _HBOLCLW_SABS = (_HBOLCLW / _HBOTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBOLCLD_SABS = (_HBOLCLD / _HBOTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBOCORT_SABS = (_HBOCORT / _HBOTRIPT)*100  ;Absolute Transit COR Share
              _HBOCORW_SABS = (_HBOCORW / _HBOTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBOCORD_SABS = (_HBOCORD / _HBOTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBOEXPT_SABS = (_HBOEXPT / _HBOTRIPT)*100  ;Absolute Transit Express Share
              _HBOEXPW_SABS = (_HBOEXPW / _HBOTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBOEXPD_SABS = (_HBOEXPD / _HBOTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBOLRTT_SABS = (_HBOLRTT / _HBOTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBOLRTW_SABS = (_HBOLRTW / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBOLRTD_SABS = (_HBOLRTD / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBOCRTT_SABS = (_HBOCRTT / _HBOTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBOCRTW_SABS = (_HBOCRTW / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBOCRTD_SABS = (_HBOCRTD / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBOBRTT_SABS = (_HBOBRTT / _HBOTRIPT)*100  ;Absolute Transit BRT Share
              _HBOBRTW_SABS = (_HBOBRTW / _HBOTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBOBRTD_SABS = (_HBOBRTD / _HBOTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBO relative share info
      if (_HBOTRIPT!=0)  
        _HBOMOTOR_SREL = (_HBOMOTOR / _HBOTRIPT)*100  ;Relative Motorized Share
        _HBONONMO_SREL = (_HBONONMO / _HBOTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBOMOTOR!=0)  
          _HBOAUTOT_SREL = (_HBOAUTOT / _HBOMOTOR)*100  ;Relative Auto Share
          _HBOTRANT_SREL = (_HBOTRANT / _HBOMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBOAUTOT!=0)  
            _HBOAUTO1_SREL = (_HBOAUTO1 / _HBOAUTOT)*100  ;Relative Drive-Alone Share
            _HBOAUTO2_SREL = (_HBOAUTO2 / _HBOAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBOAUTO3_SREL = (_HBOAUTO3 / _HBOAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBOAUTO1!=0)  
              _HBO_DANON_SREL = (_HBO_DANON / _HBOAUTO1)*100  ;Relative DA non-tol
              _HBO_DATOL_SREL = (_HBO_DATOL / _HBOAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBOAUTO2!=0)  
              _HBO_SR2NON_SREL = (_HBO_SR2NON / _HBOAUTO2)*100  
              _HBO_SR2TOL_SREL = (_HBO_SR2TOL / _HBOAUTO2)*100  
              _HBO_SR2HOV_SREL = (_HBO_SR2HOV / _HBOAUTO2)*100  
      endif    
      if (_HBOAUTO3!=0)  
              _HBO_SR3NON_SREL = (_HBO_SR3NON / _HBOAUTO3)*100  
              _HBO_SR3TOL_SREL = (_HBO_SR3TOL / _HBOAUTO3)*100  
              _HBO_SR3HOV_SREL = (_HBO_SR3HOV / _HBOAUTO3)*100  
      endif   
      if (_HBOTRANT!=0)  
            _HBOLCLT_SREL = (_HBOLCLT / _HBOTRANT)*100  ;Relative Transit Local Share
            _HBOCORT_SREL = (_HBOCORT / _HBOTRANT)*100  ;Relative Transit COR Share
            _HBOEXPT_SREL = (_HBOEXPT / _HBOTRANT)*100  ;Relative Transit Express Share
            _HBOLRTT_SREL = (_HBOLRTT / _HBOTRANT)*100  ;Relative Transit Light-Rail Share
            _HBOCRTT_SREL = (_HBOCRTT / _HBOTRANT)*100  ;Relative Transit Commuter rail Share
            _HBOBRTT_SREL = (_HBOBRTT / _HBOTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBOLCLT!=0)  
              _HBOLCLW_SREL = (_HBOLCLW / _HBOLCLT)*100  ;Relative Transit Local-Walk Share
              _HBOLCLD_SREL = (_HBOLCLD / _HBOLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBOLCLW_SREL = .0001
              _HBOLCLD_SREL = .0001          
      endif
      if (_HBOCORT!=0)  
              _HBOCORW_SREL = (_HBOCORW / _HBOCORT)*100  ;Relative Transit COR-Walk Share
              _HBOCORD_SREL = (_HBOCORD / _HBOCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBOCORW_SREL = .0001
              _HBOCORD_SREL = .0001          
      endif
      if (_HBOEXPT!=0)  
              _HBOEXPW_SREL = (_HBOEXPW / _HBOEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBOEXPD_SREL = (_HBOEXPD / _HBOEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBOEXPW_SREL = .0001
              _HBOEXPD_SREL = .0001
      endif 
      if (_HBOLRTT!=0)  
              _HBOLRTW_SREL = (_HBOLRTW / _HBOLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBOLRTD_SREL = (_HBOLRTD / _HBOLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBOLRTW_SREL = .0001
              _HBOLRTD_SREL = .0001
      endif      
      if (_HBOCRTT!=0)  
              _HBOCRTW_SREL = (_HBOCRTW / _HBOCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBOCRTD_SREL = (_HBOCRTD / _HBOCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBOCRTW_SREL = .0001
              _HBOCRTD_SREL = .0001
      endif
      if (_HBOBRTT!=0)  
              _HBOBRTW_SREL = (_HBOBRTW / _HBOBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBOBRTD_SREL = (_HBOBRTD / _HBOBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBOBRTW_SREL = .0001
              _HBOBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute NHB relative share info
      if (_NHBTRIPT!=0)  
        _NHBMOTOR_SREL = (_NHBMOTOR / _NHBTRIPT)*100  ;Relative Motorized Share
        _NHBNONMO_SREL = (_NHBNONMO / _NHBTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_NHBMOTOR!=0)  
          _NHBAUTOT_SREL = (_NHBAUTOT / _NHBMOTOR)*100  ;Relative Auto Share
          _NHBTRANT_SREL = (_NHBTRANT / _NHBMOTOR)*100  ;Relative Transit Share
      endif
      if (_NHBAUTOT!=0)  
            _NHBAUTO1_SREL = (_NHBAUTO1 / _NHBAUTOT)*100  ;Relative Drive-Alone Share
            _NHBAUTO2_SREL = (_NHBAUTO2 / _NHBAUTOT)*100  ;Relative Shared ride 2 pers Share
            _NHBAUTO3_SREL = (_NHBAUTO3 / _NHBAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_NHBAUTO1!=0)  
              _NHB_DANON_SREL = (_NHB_DANON / _NHBAUTO1)*100  ;Relative DA non-tol
              _NHB_DATOL_SREL = (_NHB_DATOL / _NHBAUTO1)*100  ;Relative DA tol
      endif  
      if (_NHBAUTO2!=0)  
              _NHB_SR2NON_SREL = (_NHB_SR2NON / _NHBAUTO2)*100  
              _NHB_SR2TOL_SREL = (_NHB_SR2TOL / _NHBAUTO2)*100  
              _NHB_SR2HOV_SREL = (_NHB_SR2HOV / _NHBAUTO2)*100  
      endif    
      if (_NHBAUTO3!=0)  
              _NHB_SR3NON_SREL = (_NHB_SR3NON / _NHBAUTO3)*100  
              _NHB_SR3TOL_SREL = (_NHB_SR3TOL / _NHBAUTO3)*100  
              _NHB_SR3HOV_SREL = (_NHB_SR3HOV / _NHBAUTO3)*100  
      endif   
      if (_NHBTRANT!=0)  
            _NHBLCLT_SREL = (_NHBLCLT / _NHBTRANT)*100  ;Relative Transit Local Share
            _NHBCORT_SREL = (_NHBCORT / _NHBTRANT)*100  ;Relative Transit COR Share
            _NHBEXPT_SREL = (_NHBEXPT / _NHBTRANT)*100  ;Relative Transit Express Share
            _NHBLRTT_SREL = (_NHBLRTT / _NHBTRANT)*100  ;Relative Transit Light-Rail Share
            _NHBCRTT_SREL = (_NHBCRTT / _NHBTRANT)*100  ;Relative Transit Commuter rail Share
            _NHBBRTT_SREL = (_NHBBRTT / _NHBTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_NHBLCLT!=0)  
              _NHBLCLW_SREL = (_NHBLCLW / _NHBLCLT)*100  ;Relative Transit Local-Walk Share
              _NHBLCLD_SREL = (_NHBLCLD / _NHBLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _NHBLCLW_SREL = .0001
              _NHBLCLD_SREL = .0001          
      endif
      if (_NHBCORT!=0)  
              _NHBCORW_SREL = (_NHBCORW / _NHBCORT)*100  ;Relative Transit COR-Walk Share
              _NHBCORD_SREL = (_NHBCORD / _NHBCORT)*100  ;Relative Transit COR-Drive Share
      else
              _NHBCORW_SREL = .0001
              _NHBCORD_SREL = .0001          
      endif
      if (_NHBEXPT!=0)  
              _NHBEXPW_SREL = (_NHBEXPW / _NHBEXPT)*100  ;Relative Transit EXP-Walk Share
              _NHBEXPD_SREL = (_NHBEXPD / _NHBEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _NHBEXPW_SREL = .0001
              _NHBEXPD_SREL = .0001
      endif 
      if (_NHBLRTT!=0)  
              _NHBLRTW_SREL = (_NHBLRTW / _NHBLRTT)*100  ;Relative Transit LRT-Walk Share
              _NHBLRTD_SREL = (_NHBLRTD / _NHBLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _NHBLRTW_SREL = .0001
              _NHBLRTD_SREL = .0001
      endif      
      if (_NHBCRTT!=0)  
              _NHBCRTW_SREL = (_NHBCRTW / _NHBCRTT)*100  ;Relative Transit CRT-Walk Share
              _NHBCRTD_SREL = (_NHBCRTD / _NHBCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _NHBCRTW_SREL = .0001
              _NHBCRTD_SREL = .0001
      endif
      if (_NHBBRTT!=0)  
              _NHBBRTW_SREL = (_NHBBRTW / _NHBBRTT)*100  ;Relative Transit BRT-Walk Share
              _NHBBRTD_SREL = (_NHBBRTD / _NHBBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _NHBBRTW_SREL = .0001
              _NHBBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      
      ;*********************** Compute HBS share - relative
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_REL = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_REL = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
      endif
      
      if (_HBSMOTOR!=0)  
          PR_HBS_Rel = _HBSMOTOR_PR / _HBSMOTOR * 100
          SC_HBS_Rel = _HBSMOTOR_SC / _HBSMOTOR * 100
          
          HBS_SchBus_Rel = _HBS_SB / _HBSMOTOR * 100
          HBS_DrSelf_Rel = _HBS_DS / _HBSMOTOR * 100
          HBS_DrpOff_Rel = _HBS_DO   / _HBSMOTOR * 100
      endif
      
      if (_HBSMOTOR_PR!=0)  
          PR_HBS_SchBus_Rel = PR_HBSch_SB / _HBSMOTOR_PR * 100
          PR_HBS_DrSelf_Rel = PR_HBSch_DS / _HBSMOTOR_PR * 100
          PR_HBS_DrpOff_Rel = PR_HBSch_DO   / _HBSMOTOR_PR * 100
      endif
      
      if (_HBSMOTOR_SC!=0)  
          SC_HBS_SchBus_Rel = SC_HBSch_SB / _HBSMOTOR_SC * 100
          SC_HBS_DrSelf_Rel = SC_HBSch_DS / _HBSMOTOR_SC * 100
          SC_HBS_DrpOff_Rel = SC_HBSch_DO   / _HBSMOTOR_SC * 100
      endif
      
      ;*********************** Compute HBS share - absolute
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_Abs = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_Abs = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
          
          PR_HBS_Abs = _HBSMOTOR_PR / _HBSTRIPT * 100
          SC_HBS_Abs = _HBSMOTOR_SC / _HBSTRIPT * 100
          
          HBS_SchBus_Abs = _HBS_SB / _HBSTRIPT * 100
          HBS_DrSelf_Abs = _HBS_DS / _HBSTRIPT * 100
          HBS_DrpOff_Abs = _HBS_DO   / _HBSTRIPT * 100
          
          PR_HBS_SchBus_Abs = PR_HBSch_SB / _HBSTRIPT * 100
          PR_HBS_DrSelf_Abs = PR_HBSch_DS / _HBSTRIPT * 100
          PR_HBS_DrpOff_Abs = PR_HBSch_DO   / _HBSTRIPT * 100
          
          SC_HBS_SchBus_Abs = SC_HBSch_SB / _HBSTRIPT * 100
          SC_HBS_DrSelf_Abs = SC_HBSch_DS / _HBSTRIPT * 100
          SC_HBS_DrpOff_Abs = SC_HBSch_DO   / _HBSTRIPT * 100
      endif
      
    
      ;*********************** Compute TOT absolute share info
      if (_TOTTRIPT!=0)  
        _TOTNONMO_SABS = (_TOTNONMO / _TOTTRIPT)*100  ;Absolute Non-Motorized Share
        _TOTMOTOR_SABS = (_TOTMOTOR / _TOTTRIPT)*100  ;Absolute Motorized Share
          _TOTAUTOT_SABS = (_TOTAUTOT / _TOTTRIPT)*100  ;Absolute Auto Share
            _TOTAUTO1_SABS = (_TOTAUTO1 / _TOTTRIPT)*100  ;Absolute Drive-Alone Share
              _TOT_DANON_SABS = (_TOT_DANON / _TOTTRIPT)*100  
              _TOT_DATOL_SABS = (_TOT_DATOL / _TOTTRIPT)*100  
            _TOTAUTO2_SABS = (_TOTAUTO2 / _TOTTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _TOT_SR2NON_SABS = (_TOT_SR2NON / _TOTTRIPT)*100  
              _TOT_SR2TOL_SABS = (_TOT_SR2TOL / _TOTTRIPT)*100  
              _TOT_SR2HOV_SABS = (_TOT_SR2HOV / _TOTTRIPT)*100  
            _TOTAUTO3_SABS = (_TOTAUTO3 / _TOTTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _TOT_SR3NON_SABS = (_TOT_SR3NON / _TOTTRIPT)*100  
              _TOT_SR3TOL_SABS = (_TOT_SR3TOL / _TOTTRIPT)*100  
              _TOT_SR3HOV_SABS = (_TOT_SR3HOV / _TOTTRIPT)*100   
          _TOTTRANT_SABS = (_TOTTRANT / _TOTTRIPT)*100  ;Absolute Transit Share
            _TOTLCLT_SABS = (_TOTLCLT / _TOTTRIPT)*100  ;Absolute Transit Local Share
              _TOTLCLW_SABS = (_TOTLCLW / _TOTTRIPT)*100  ;Absolute Transit Local-Walk Share
              _TOTLCLD_SABS = (_TOTLCLD / _TOTTRIPT)*100  ;Absolute Transit Local-Drive Share
            _TOTCORT_SABS = (_TOTCORT / _TOTTRIPT)*100  ;Absolute Transit COR Share
              _TOTCORW_SABS = (_TOTCORW / _TOTTRIPT)*100  ;Absolute Transit COR-Walk Share
              _TOTCORD_SABS = (_TOTCORD / _TOTTRIPT)*100  ;Absolute Transit COR-Drive Share
            _TOTEXPT_SABS = (_TOTEXPT / _TOTTRIPT)*100  ;Absolute Transit Express Share
              _TOTEXPW_SABS = (_TOTEXPW / _TOTTRIPT)*100  ;Absolute Transit Express-Walk Share
              _TOTEXPD_SABS = (_TOTEXPD / _TOTTRIPT)*100  ;Absolute Transit Express-Drive Share
            _TOTLRTT_SABS = (_TOTLRTT / _TOTTRIPT)*100  ;Absolute Transit Light-Rail Share
              _TOTLRTW_SABS = (_TOTLRTW / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _TOTLRTD_SABS = (_TOTLRTD / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _TOTCRTT_SABS = (_TOTCRTT / _TOTTRIPT)*100  ;Absolute Transit Commuter rail Share
              _TOTCRTW_SABS = (_TOTCRTW / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _TOTCRTD_SABS = (_TOTCRTD / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _TOTBRTT_SABS = (_TOTBRTT / _TOTTRIPT)*100  ;Absolute Transit BRT Share
              _TOTBRTW_SABS = (_TOTBRTW / _TOTTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _TOTBRTD_SABS = (_TOTBRTD / _TOTTRIPT)*100  ;Absolute Transit BRT-Drive Share
              
          TOT_HBSMOTOR_Abs = _HBSMOTOR / (_TOTTRIPT/100) * 100
          
          PR_TOT_Abs = _HBSMOTOR_PR / (_TOTTRIPT/100) * 100
          SC_TOT_Abs = _HBSMOTOR_SC / (_TOTTRIPT/100) * 100
          
          TOT_SchBus_Abs = _HBS_SB / (_TOTTRIPT/100) * 100
          TOT_DrSelf_Abs = _HBS_DS / (_TOTTRIPT/100) * 100
          TOT_DrpOff_Abs = _HBS_DO / (_TOTTRIPT/100) * 100
          
          PR_TOT_SchBus_Abs = PR_HBSch_SB / (_TOTTRIPT/100) * 100
          PR_TOT_DrSelf_Abs = PR_HBSch_DS / (_TOTTRIPT/100) * 100
          PR_TOT_DrpOff_Abs = PR_HBSch_DO / (_TOTTRIPT/100) * 100
          
          SC_TOT_SchBus_Abs = SC_HBSch_SB / (_TOTTRIPT/100) * 100
          SC_TOT_DrSelf_Abs = SC_HBSch_DS / (_TOTTRIPT/100) * 100
          SC_TOT_DrpOff_Abs = SC_HBSch_DO / (_TOTTRIPT/100) * 100
      endif
    
      ;*********************** Compute TOT relative share info
      if (_TOTTRIPT!=0)  
        _TOTMOTOR_SREL = (_TOTMOTOR / _TOTTRIPT)*100  ;Relative Motorized Share
        _TOTNONMO_SREL = (_TOTNONMO / _TOTTRIPT)*100  ;Relative Non-Motorized Share
      endif
      
      if (_TOTMOTOR!=0)  
          _TOTAUTOT_SREL = (_TOTAUTOT / _TOTMOTOR)*100  ;Relative Auto Share
          _TOTTRANT_SREL = (_TOTTRANT / _TOTMOTOR)*100  ;Relative Transit Share
      endif
      
      if (_TOTAUTOT!=0)  
            _TOTAUTO1_SREL = (_TOTAUTO1 / _TOTAUTOT)*100  ;Relative Drive-Alone Share
            _TOTAUTO2_SREL = (_TOTAUTO2 / _TOTAUTOT)*100  ;Relative Shared ride 2 pers Share
            _TOTAUTO3_SREL = (_TOTAUTO3 / _TOTAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      
      if (_TOTAUTO1!=0)  
              _TOT_DANON_SREL = (_TOT_DANON / _TOTAUTO1)*100 
              _TOT_DATOL_SREL = (_TOT_DATOL / _TOTAUTO1)*100 
      endif
      
      if (_TOTAUTO2!=0)  
              _TOT_SR2NON_SREL = (_TOT_SR2NON / _TOTAUTO2)*100 
              _TOT_SR2TOL_SREL = (_TOT_SR2TOL / _TOTAUTO2)*100 
              _TOT_SR2HOV_SREL = (_TOT_SR2HOV / _TOTAUTO2)*100 
      endif
      
      if (_TOTAUTO3!=0)  
              _TOT_SR3NON_SREL = (_TOT_SR3NON / _TOTAUTO3)*100 
              _TOT_SR3TOL_SREL = (_TOT_SR3TOL / _TOTAUTO3)*100 
              _TOT_SR3HOV_SREL = (_TOT_SR3HOV / _TOTAUTO3)*100 
      endif
      
      if (_TOTTRANT!=0)  
            _TOTLCLT_SREL = (_TOTLCLT / _TOTTRANT)*100  ;Relative Transit Local Share
            _TOTCORT_SREL = (_TOTCORT / _TOTTRANT)*100  ;Relative Transit COR Share
            _TOTEXPT_SREL = (_TOTEXPT / _TOTTRANT)*100  ;Relative Transit Express Share
            _TOTLRTT_SREL = (_TOTLRTT / _TOTTRANT)*100  ;Relative Transit Light-Rail Share
            _TOTCRTT_SREL = (_TOTCRTT / _TOTTRANT)*100  ;Relative Transit Commuter rail Share
            _TOTBRTT_SREL = (_TOTBRTT / _TOTTRANT)*100  ;Relative Transit BRT Share
      endif
      
      if (_TOTLCLT!=0)  
              _TOTLCLW_SREL = (_TOTLCLW / _TOTLCLT)*100  ;Relative Transit Local-Walk Share
              _TOTLCLD_SREL = (_TOTLCLD / _TOTLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _TOTLCLW_SREL = .0001
              _TOTLCLD_SREL = .0001          
      endif
      
      if (_TOTCORT!=0)  
              _TOTCORW_SREL = (_TOTCORW / _TOTCORT)*100  ;Relative Transit COR-Walk Share
              _TOTCORD_SREL = (_TOTCORD / _TOTCORT)*100  ;Relative Transit COR-Drive Share
      else
              _TOTCORW_SREL = .0001
              _TOTCORD_SREL = .0001          
      endif
      if (_TOTEXPT!=0)  
              _TOTEXPW_SREL = (_TOTEXPW / _TOTEXPT)*100  ;Relative Transit EXP-Walk Share
              _TOTEXPD_SREL = (_TOTEXPD / _TOTEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _TOTEXPW_SREL = .0001
              _TOTEXPD_SREL = .0001
      endif 
      if (_TOTLRTT!=0)  
              _TOTLRTW_SREL = (_TOTLRTW / _TOTLRTT)*100  ;Relative Transit LRT-Walk Share
              _TOTLRTD_SREL = (_TOTLRTD / _TOTLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _TOTLRTW_SREL = .0001
              _TOTLRTD_SREL = .0001
      endif      
      if (_TOTCRTT!=0)  
              _TOTCRTW_SREL = (_TOTCRTW / _TOTCRTT)*100  ;Relative Transit CRT-Walk Share
              _TOTCRTD_SREL = (_TOTCRTD / _TOTCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _TOTCRTW_SREL = .0001
              _TOTCRTD_SREL = .0001
      endif
      if (_TOTBRTT!=0)  
              _TOTBRTW_SREL = (_TOTBRTW / _TOTBRTT)*100  ;Relative Transit BRT-Walk Share
              _TOTBRTD_SREL = (_TOTBRTD / _TOTBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _TOTBRTW_SREL = .0001
              _TOTBRTD_SREL = .0001
      endif    
      
      
      ;***********************************************************************************
      ;**********  Begin CSV print (for easy import to Excel)  
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'TripCategory',   'HBWtrip',   'HBWabs',   'HBWrel',
    			          ,   'HBCtrip',   'HBCabs',   'HBCrel',
    			          ,   'HBOtrip',   'HBOabs',   'HBOrel',
    			          ,   'NHBtrip',   'NHBabs',   'NHBrel',
    			          ,   'HBSchtrip', 'HBSchabs', 'HBSchrel',
    			          ,   'TOTtrip',   'TOTabs',   'TOTrel',
    	
    	'\n1) Total Trips', 
    	    _HBWTRIPT/100(10.0), 100, 100,
    			_HBCTRIPT/100(10.0), 100, 100,
    			_HBOTRIPT/100(10.0), 100, 100,
    			_NHBTRIPT/100(10.0), 100, 100,
    			    _HBSTRIPT(10.0), 100, 100,
    			_TOTTRIPT/100(10.0), 100, 100,
    
    	'\n    2) Non-Motorized', 
    	    _HBWNONMO/100(10.0), _HBWNONMO_SABS, _HBWNONMO_SREL,
    			_HBCNONMO/100(10.0), _HBCNONMO_SABS, _HBCNONMO_SREL,
    			_HBONONMO/100(10.0), _HBONONMO_SABS, _HBONONMO_SREL,
    			_NHBNONMO/100(10.0), _NHBNONMO_SABS, _NHBNONMO_SREL,
    			    _HBSNONMO(10.0),  HBS_NONMO_Abs, HBS_NONMO_Rel,
    			_TOTNONMO/100(10.0), _TOTNONMO_SABS, _TOTNONMO_SREL,
    
    	'\n    2) Motorized', 
    	    _HBWMOTOR/100(10.0), _HBWMOTOR_SABS, _HBWMOTOR_SREL,
    			_HBCMOTOR/100(10.0), _HBCMOTOR_SABS, _HBCMOTOR_SREL,
    			_HBOMOTOR/100(10.0), _HBOMOTOR_SABS, _HBOMOTOR_SREL,
    			_NHBMOTOR/100(10.0), _NHBMOTOR_SABS, _NHBMOTOR_SREL,
    			    _HBSMOTOR(10.0),  HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_TOTMOTOR/100(10.0), _TOTMOTOR_SABS, _TOTMOTOR_SREL
    			         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n        3) Auto', 
    	    _HBWAUTOT/100(10.0), _HBWAUTOT_SABS, _HBWAUTOT_SREL,
    			_HBCAUTOT/100(10.0), _HBCAUTOT_SABS, _HBCAUTOT_SREL,
    			_HBOAUTOT/100(10.0), _HBOAUTOT_SABS, _HBOAUTOT_SREL,
    			_NHBAUTOT/100(10.0), _NHBAUTOT_SABS, _NHBAUTOT_SREL,
    			'-', '-', '-',
    			_TOTAUTOT/100(10.0), _TOTAUTOT_SABS, _TOTAUTOT_SREL,
    	'\n            4) Auto 1 pers', 
    	    _HBWAUTO1/100(10.0), _HBWAUTO1_SABS, _HBWAUTO1_SREL,
    			_HBCAUTO1/100(10.0), _HBCAUTO1_SABS, _HBCAUTO1_SREL,
    			_HBOAUTO1/100(10.0), _HBOAUTO1_SABS, _HBOAUTO1_SREL,
    			_NHBAUTO1/100(10.0), _NHBAUTO1_SABS, _NHBAUTO1_SREL,
    			'-', '-', '-',
    			_TOTAUTO1/100(10.0), _TOTAUTO1_SABS, _TOTAUTO1_SREL,
    
    	'\n                    GP use', 
    	    _HBW_DANON/100(10.0), _HBW_DANON_SABS, _HBW_DANON_SREL,
    			_HBC_DANON/100(10.0), _HBC_DANON_SABS, _HBC_DANON_SREL,
    			_HBO_DANON/100(10.0), _HBO_DANON_SABS, _HBO_DANON_SREL,
    			_NHB_DANON/100(10.0), _NHB_DANON_SABS, _NHB_DANON_SREL,
    			'-', '-', '-',
    			_TOT_DANON/100(10.0), _TOT_DANON_SABS, _TOT_DANON_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_DATOL/100(10.0), _HBW_DATOL_SABS, _HBW_DATOL_SREL,
    			_HBC_DATOL/100(10.0), _HBC_DATOL_SABS, _HBC_DATOL_SREL,
    			_HBO_DATOL/100(10.0), _HBO_DATOL_SABS, _HBO_DATOL_SREL,
    			_NHB_DATOL/100(10.0), _NHB_DATOL_SABS, _NHB_DATOL_SREL,
    			'-', '-', '-',
    			_TOT_DATOL/100(10.0), _TOT_DATOL_SABS, _TOT_DATOL_SREL
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Auto 2 pers', 
    	    _HBWAUTO2/100(10.0), _HBWAUTO2_SABS, _HBWAUTO2_SREL,
    			_HBCAUTO2/100(10.0), _HBCAUTO2_SABS, _HBCAUTO2_SREL,
    			_HBOAUTO2/100(10.0), _HBOAUTO2_SABS, _HBOAUTO2_SREL,
    			_NHBAUTO2/100(10.0), _NHBAUTO2_SABS, _NHBAUTO2_SREL,
    			'-', '-', '-',
    			_TOTAUTO2/100(10.0), _TOTAUTO2_SABS, _TOTAUTO2_SREL,
    			         
    	'\n                    GP use', 
    	    _HBW_SR2NON/100(10.0), _HBW_SR2NON_SABS, _HBW_SR2NON_SREL,
    			_HBC_SR2NON/100(10.0), _HBC_SR2NON_SABS, _HBC_SR2NON_SREL,
    			_HBO_SR2NON/100(10.0), _HBO_SR2NON_SABS, _HBO_SR2NON_SREL,
    			_NHB_SR2NON/100(10.0), _NHB_SR2NON_SABS, _NHB_SR2NON_SREL,
    			'-', '-', '-',
    			_TOT_SR2NON/100(10.0), _TOT_SR2NON_SABS, _TOT_SR2NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR2HOV/100(10.0), _HBW_SR2HOV_SABS, _HBW_SR2HOV_SREL,
    			_HBC_SR2HOV/100(10.0), _HBC_SR2HOV_SABS, _HBC_SR2HOV_SREL,
    			_HBO_SR2HOV/100(10.0), _HBO_SR2HOV_SABS, _HBO_SR2HOV_SREL,
    			_NHB_SR2HOV/100(10.0), _NHB_SR2HOV_SABS, _NHB_SR2HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR2HOV/100(10.0), _TOT_SR2HOV_SABS, _TOT_SR2HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR2TOL/100(10.0), _HBW_SR2TOL_SABS, _HBW_SR2TOL_SREL,
    			_HBC_SR2TOL/100(10.0), _HBC_SR2TOL_SABS, _HBC_SR2TOL_SREL,
    			_HBO_SR2TOL/100(10.0), _HBO_SR2TOL_SABS, _HBO_SR2TOL_SREL,
    			_NHB_SR2TOL/100(10.0), _NHB_SR2TOL_SABS, _NHB_SR2TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR2TOL/100(10.0), _TOT_SR2TOL_SABS, _TOT_SR2TOL_SREL
    	
    			
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Auto 3+pers', 
    	    _HBWAUTO3/100(10.0), _HBWAUTO3_SABS, _HBWAUTO3_SREL,
    			_HBCAUTO3/100(10.0), _HBCAUTO3_SABS, _HBCAUTO3_SREL,
    			_HBOAUTO3/100(10.0), _HBOAUTO3_SABS, _HBOAUTO3_SREL,
    			_NHBAUTO3/100(10.0), _NHBAUTO3_SABS, _NHBAUTO3_SREL,	
    			'-', '-', '-',
    			_TOTAUTO3/100(10.0), _TOTAUTO3_SABS, _TOTAUTO3_SREL,	
    			         
    	'\n                    GP use', 
    	    _HBW_SR3NON/100(10.0), _HBW_SR3NON_SABS, _HBW_SR3NON_SREL,
    			_HBC_SR3NON/100(10.0), _HBC_SR3NON_SABS, _HBC_SR3NON_SREL,
    			_HBO_SR3NON/100(10.0), _HBO_SR3NON_SABS, _HBO_SR3NON_SREL,
    			_NHB_SR3NON/100(10.0), _NHB_SR3NON_SABS, _NHB_SR3NON_SREL,
    			'-', '-', '-',
    		  _TOT_SR3NON/100(10.0), _TOT_SR3NON_SABS, _TOT_SR3NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR3HOV/100(10.0), _HBW_SR3HOV_SABS, _HBW_SR3HOV_SREL,
    			_HBC_SR3HOV/100(10.0), _HBC_SR3HOV_SABS, _HBC_SR3HOV_SREL,
    			_HBO_SR3HOV/100(10.0), _HBO_SR3HOV_SABS, _HBO_SR3HOV_SREL,
    			_NHB_SR3HOV/100(10.0), _NHB_SR3HOV_SABS, _NHB_SR3HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR3HOV/100(10.0), _TOT_SR3HOV_SABS, _TOT_SR3HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR3TOL/100(10.0), _HBW_SR3TOL_SABS, _HBW_SR3TOL_SREL,
    			_HBC_SR3TOL/100(10.0), _HBC_SR3TOL_SABS, _HBC_SR3TOL_SREL,
    			_HBO_SR3TOL/100(10.0), _HBO_SR3TOL_SABS, _HBO_SR3TOL_SREL,
    			_NHB_SR3TOL/100(10.0), _NHB_SR3TOL_SABS, _NHB_SR3TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR3TOL/100(10.0), _TOT_SR3TOL_SABS, _TOT_SR3TOL_SREL
    	
          
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) School Trips', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR(10.0), HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_HBSMOTOR(10.0), TOT_HBSMOTOR_Abs, HBS_MOTOR_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_SB(10.0), HBS_SchBus_Abs, HBS_SchBus_Rel,
    			_HBS_SB(10.0), TOT_SchBus_Abs, HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DS(10.0), HBS_DrSelf_Abs, HBS_DrSelf_Rel,
    			_HBS_DS(10.0), TOT_DrSelf_Abs, HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DO(10.0), HBS_DrpOff_Abs, HBS_DrpOff_Rel,
    			_HBS_DO(10.0), TOT_DrpOff_Abs, HBS_DrpOff_Rel,
    			
    	'\n                    K-6', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_PR(10.0), PR_HBS_Abs, PR_HBS_Rel,
    			_HBSMOTOR_PR(10.0), PR_TOT_Abs, PR_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_SB(10.0), PR_HBS_SchBus_Abs, PR_HBS_SchBus_Rel,
    			PR_HBSch_SB(10.0), PR_TOT_SchBus_Abs, PR_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DS(10.0), PR_HBS_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			PR_HBSch_DS(10.0), PR_TOT_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DO(10.0), PR_HBS_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			PR_HBSch_DO(10.0), PR_TOT_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			
    	'\n                    7-12', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_SC(10.0), SC_HBS_Abs, SC_HBS_Rel,
    			_HBSMOTOR_SC(10.0), SC_TOT_Abs, SC_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_SB(10.0), SC_HBS_SchBus_Abs, SC_HBS_SchBus_Rel,
    			SC_HBSch_SB(10.0), SC_TOT_SchBus_Abs, SC_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DS(10.0), SC_HBS_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			SC_HBSch_DS(10.0), SC_TOT_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DO(10.0), SC_HBS_DrpOff_Abs, SC_HBS_DrpOff_Rel,
    			SC_HBSch_DO(10.0), SC_TOT_DrpOff_Abs, SC_HBS_DrpOff_Rel
    	
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n        3) Transit', 
    	    _HBWTRANT/100(10.0), _HBWTRANT_SABS, _HBWTRANT_SREL,
    			_HBCTRANT/100(10.0), _HBCTRANT_SABS, _HBCTRANT_SREL,
    			_HBOTRANT/100(10.0), _HBOTRANT_SABS, _HBOTRANT_SREL,
    			_NHBTRANT/100(10.0), _NHBTRANT_SABS, _NHBTRANT_SREL,
    			'-', '-', '-',
    			_TOTTRANT/100(10.0), _TOTTRANT_SABS, _TOTTRANT_SREL
    	
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Local Bus (LCL)', 
    	    _HBWLCLT/100(10.0), _HBWLCLT_SABS, _HBWLCLT_SREL,
    			_HBCLCLT/100(10.0), _HBCLCLT_SABS, _HBCLCLT_SREL,
    			_HBOLCLT/100(10.0), _HBOLCLT_SABS, _HBOLCLT_SREL,
    			_NHBLCLT/100(10.0), _NHBLCLT_SABS, _NHBLCLT_SREL,
    			'-', '-', '-',
    			_TOTLCLT/100(10.0), _TOTLCLT_SABS, _TOTLCLT_SREL,
    
    	'\n                    LCL Walk', 
    	    _HBWLCLW/100(10.0), _HBWLCLW_SABS, _HBWLCLW_SREL,
    			_HBCLCLW/100(10.0), _HBCLCLW_SABS, _HBCLCLW_SREL,
    			_HBOLCLW/100(10.0), _HBOLCLW_SABS, _HBOLCLW_SREL,
    			_NHBLCLW/100(10.0), _NHBLCLW_SABS, _NHBLCLW_SREL,
    			'-', '-', '-',
    			_TOTLCLW/100(10.0), _TOTLCLW_SABS, _TOTLCLW_SREL,
    
    	'\n                    LCL Drive', 
    	    _HBWLCLD/100(10.0), _HBWLCLD_SABS, _HBWLCLD_SREL,
    			_HBCLCLD/100(10.0), _HBCLCLD_SABS, _HBCLCLD_SREL,
    			_HBOLCLD/100(10.0), _HBOLCLD_SABS, _HBOLCLD_SREL,
    			_NHBLCLD/100(10.0), _NHBLCLD_SABS, _NHBLCLD_SREL,	
    			'-', '-', '-',
    			_TOTLCLD/100(10.0), _TOTLCLD_SABS, _TOTLCLD_SREL
    
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Core Bus (COR)', 
    	    _HBWCORT/100(10.0), _HBWCORT_SABS, _HBWCORT_SREL,
    			_HBCCORT/100(10.0), _HBCCORT_SABS, _HBCCORT_SREL,
    			_HBOCORT/100(10.0), _HBOCORT_SABS, _HBOCORT_SREL,
    			_NHBCORT/100(10.0), _NHBCORT_SABS, _NHBCORT_SREL,
    			'-', '-', '-',
    			_TOTCORT/100(10.0), _TOTCORT_SABS, _TOTCORT_SREL,
    
    	'\n                    COR Walk', 
    	    _HBWCORW/100(10.0), _HBWCORW_SABS, _HBWCORW_SREL,
    			_HBCCORW/100(10.0), _HBCCORW_SABS, _HBCCORW_SREL,
    			_HBOCORW/100(10.0), _HBOCORW_SABS, _HBOCORW_SREL,
    			_NHBCORW/100(10.0), _NHBCORW_SABS, _NHBCORW_SREL,
    			'-', '-', '-',
    			_TOTCORW/100(10.0), _TOTCORW_SABS, _TOTCORW_SREL,
    
    	'\n                    COR Drive', 
    	    _HBWCORD/100(10.0), _HBWCORD_SABS, _HBWCORD_SREL,
    			_HBCCORD/100(10.0), _HBCCORD_SABS, _HBCCORD_SREL,
    			_HBOCORD/100(10.0), _HBOCORD_SABS, _HBOCORD_SREL,
    			_NHBCORD/100(10.0), _NHBCORD_SABS, _NHBCORD_SREL,	
    			'-', '-', '-',
    			_TOTCORD/100(10.0), _TOTCORD_SABS, _TOTCORD_SREL
    			
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Bus-Rapid Transit (BRT)',
    	    _HBWBRTT/100(10.0), _HBWBRTT_SABS, _HBWBRTT_SREL,
    			_HBCBRTT/100(10.0), _HBCBRTT_SABS, _HBCBRTT_SREL,
    			_HBOBRTT/100(10.0), _HBOBRTT_SABS, _HBOBRTT_SREL,
    			_NHBBRTT/100(10.0), _NHBBRTT_SABS, _NHBBRTT_SREL,
    			'-', '-', '-',
    			_TOTBRTT/100(10.0), _TOTBRTT_SABS, _TOTBRTT_SREL,
    
    	'\n                    BRT Walk', 
    	    _HBWBRTW/100(10.0), _HBWBRTW_SABS, _HBWBRTW_SREL,
    			_HBCBRTW/100(10.0), _HBCBRTW_SABS, _HBCBRTW_SREL,
    			_HBOBRTW/100(10.0), _HBOBRTW_SABS, _HBOBRTW_SREL,
    			_NHBBRTW/100(10.0), _NHBBRTW_SABS, _NHBBRTW_SREL,
    			'-', '-', '-',
    			_TOTBRTW/100(10.0), _TOTBRTW_SABS, _TOTBRTW_SREL,
    
    	'\n                    BRT Drive', 
    	    _HBWBRTD/100(10.0), _HBWBRTD_SABS, _HBWBRTD_SREL,
    			_HBCBRTD/100(10.0), _HBCBRTD_SABS, _HBCBRTD_SREL,
    			_HBOBRTD/100(10.0), _HBOBRTD_SABS, _HBOBRTD_SREL,
    			_NHBBRTD/100(10.0), _NHBBRTD_SABS, _NHBBRTD_SREL,	
    			'-', '-', '-',
    			_TOTBRTD/100(10.0), _TOTBRTD_SABS, _TOTBRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Express Bus (EXP)', 
    	    _HBWEXPT/100(10.0), _HBWEXPT_SABS, _HBWEXPT_SREL,
    			_HBCEXPT/100(10.0), _HBCEXPT_SABS, _HBCEXPT_SREL,
    			_HBOEXPT/100(10.0), _HBOEXPT_SABS, _HBOEXPT_SREL,
    			_NHBEXPT/100(10.0), _NHBEXPT_SABS, _NHBEXPT_SREL,
    			'-', '-', '-',
    			_TOTEXPT/100(10.0), _TOTEXPT_SABS, _TOTEXPT_SREL,
    
    	'\n                    EXP Walk', 
    	    _HBWEXPW/100(10.0), _HBWEXPW_SABS, _HBWEXPW_SREL,
    			_HBCEXPW/100(10.0), _HBCEXPW_SABS, _HBCEXPW_SREL,
    			_HBOEXPW/100(10.0), _HBOEXPW_SABS, _HBOEXPW_SREL,
    			_NHBEXPW/100(10.0), _NHBEXPW_SABS, _NHBEXPW_SREL,
    			'-', '-', '-',
    			_TOTEXPW/100(10.0), _TOTEXPW_SABS, _TOTEXPW_SREL,
    
    	'\n                    EXP Drive', 
    	    _HBWEXPD/100(10.0), _HBWEXPD_SABS, _HBWEXPD_SREL,
    			_HBCEXPD/100(10.0), _HBCEXPD_SABS, _HBCEXPD_SREL,
    			_HBOEXPD/100(10.0), _HBOEXPD_SABS, _HBOEXPD_SREL,
    			_NHBEXPD/100(10.0), _NHBEXPD_SABS, _NHBEXPD_SREL,
    			'-', '-', '-',
    			_TOTEXPD/100(10.0), _TOTEXPD_SABS, _TOTEXPD_SREL
    			
    		         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Light-Rail Transit (LRT)', 
    	    _HBWLRTT/100(10.0), _HBWLRTT_SABS, _HBWLRTT_SREL,
    			_HBCLRTT/100(10.0), _HBCLRTT_SABS, _HBCLRTT_SREL,
    			_HBOLRTT/100(10.0), _HBOLRTT_SABS, _HBOLRTT_SREL,
    			_NHBLRTT/100(10.0), _NHBLRTT_SABS, _NHBLRTT_SREL,
    			'-', '-', '-',
    			_TOTLRTT/100(10.0), _TOTLRTT_SABS, _TOTLRTT_SREL,
    
    	'\n                    LRT Walk', 
    	    _HBWLRTW/100(10.0), _HBWLRTW_SABS, _HBWLRTW_SREL,
    			_HBCLRTW/100(10.0), _HBCLRTW_SABS, _HBCLRTW_SREL,
    			_HBOLRTW/100(10.0), _HBOLRTW_SABS, _HBOLRTW_SREL,
    			_NHBLRTW/100(10.0), _NHBLRTW_SABS, _NHBLRTW_SREL,
    			'-', '-', '-',
    			_TOTLRTW/100(10.0), _TOTLRTW_SABS, _TOTLRTW_SREL,
    
    	'\n                    LRT Drive', 
    	    _HBWLRTD/100(10.0), _HBWLRTD_SABS, _HBWLRTD_SREL,
    			_HBCLRTD/100(10.0), _HBCLRTD_SABS, _HBCLRTD_SREL,
    			_HBOLRTD/100(10.0), _HBOLRTD_SABS, _HBOLRTD_SREL,
    			_NHBLRTD/100(10.0), _NHBLRTD_SABS, _NHBLRTD_SREL,
    			'-', '-', '-',
    			_TOTLRTD/100(10.0), _TOTLRTD_SABS, _TOTLRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n            4) Commuter-Rail Transit (CRT)', 
    	    _HBWCRTT/100(10.0), _HBWCRTT_SABS, _HBWCRTT_SREL,
    			_HBCCRTT/100(10.0), _HBCCRTT_SABS, _HBCCRTT_SREL,
    			_HBOCRTT/100(10.0), _HBOCRTT_SABS, _HBOCRTT_SREL,
    			_NHBCRTT/100(10.0), _NHBCRTT_SABS, _NHBCRTT_SREL,
    			'-', '-', '-',
    			_TOTCRTT/100(10.0), _TOTCRTT_SABS, _TOTCRTT_SREL,
    
    	'\n                    CRT Walk', 
    	    _HBWCRTW/100(10.0), _HBWCRTW_SABS, _HBWCRTW_SREL,
    			_HBCCRTW/100(10.0), _HBCCRTW_SABS, _HBCCRTW_SREL,
    			_HBOCRTW/100(10.0), _HBOCRTW_SABS, _HBOCRTW_SREL,
    			_NHBCRTW/100(10.0), _NHBCRTW_SABS, _NHBCRTW_SREL,
    			'-', '-', '-',
    			_TOTCRTW/100(10.0), _TOTCRTW_SABS, _TOTCRTW_SREL,
    
    	'\n                    CRT Drive', 
    	    _HBWCRTD/100(10.0), _HBWCRTD_SABS, _HBWCRTD_SREL,
    			_HBCCRTD/100(10.0), _HBCCRTD_SABS, _HBCCRTD_SREL,
    			_HBOCRTD/100(10.0), _HBOCRTD_SABS, _HBOCRTD_SREL,
    			_NHBCRTD/100(10.0), _NHBCRTD_SABS, _NHBCRTD_SREL,	
    			'-', '-', '-',
    			_TOTCRTD/100(10.0), _TOTCRTD_SABS, _TOTCRTD_SREL,	
      '\n  '
      
            
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Pk.csv' LIST=
    	'\n   Run ID (RID card): @RID@', 
    	'\n   Socio-Economic year modeled:         @demographicyear@', 
    	'\n   Network infrastructure year modeled: @networkyear@',
    	'\n   Period the results apply to:  Peak Period',
    	'\n   Shares\@RID@_RegionShares_Pk.csv', 
    	'\n   For this run Mode Choice was run in its regular form (i.e. not bypassed with approximation).',
    	'\n   NOTE:  Indentations correspond with each level in the nested Logit choice model.'
    
    endif
    
    ENDRUN

;Cluster: end of group distributed to processor 2
EndDistributeMULTISTEP


;Cluster: distrubute MATRIX call onto processor 3
DistributeMultiStep Alias='Shares_Proc3'

    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - off peak'
      FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Ok.mtx'
      FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Ok.mtx'
      FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Ok.mtx'
      FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Ok.mtx'
      FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
      FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
     
      FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Ok_auto_managedlanes.mtx'       ; HBW trip table 
            MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Ok_auto_managedlanes.mtx'       ; HBC trip table 
            MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Ok_auto_managedlanes.mtx'       ; HBO trip table  
            MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_Ok_auto_managedlanes.mtx'       ; NHB trip table  
      
      ZONEMSG = 10
    
    ;******************************** HBW summary values
    JLOOP 
      if (I=1-@UsedZones@  |  J=1-@UsedZones@)
        _HBWMOTOR = _HBWMOTOR + mi.01.motor[j] 
        _HBWNONMO = _HBWNONMO + mi.01.nonmotor[j]
        _HBWTRANT = _HBWTRANT + mi.01.transit[j]
        _HBWAUTOT = _HBWAUTOT + mi.01.auto[j]
        _HBWAUTO1 = _HBWAUTO1 + mi.01.DA[j]
        _HBWAUTO2 = _HBWAUTO2 + mi.01.SR2[j]
        _HBWAUTO3 = _HBWAUTO3 + mi.01.SR3p[j]  
        _HBWLCLW  = _HBWLCLW  + mi.01.wLCL[j]
        _HBWLCLD  = _HBWLCLD  + mi.01.dLCL[j]
        _HBWCORW  = _HBWCORW  + mi.01.wCOR[j]
        _HBWCORD  = _HBWCORD  + mi.01.dCOR[j]
        _HBWEXPW  = _HBWEXPW  + mi.01.wEXP[j]
        _HBWEXPD  = _HBWEXPD  + mi.01.dEXP[j]
        _HBWLRTW  = _HBWLRTW  + mi.01.wLRT[j]
        _HBWLRTD  = _HBWLRTD  + mi.01.dLRT[j]
        _HBWCRTW  = _HBWCRTW  + mi.01.wCRT[j]
        _HBWCRTD  = _HBWCRTD  + mi.01.dCRT[j]
        _HBWTRANW = _HBWTRANW + mi.01.wTRN[j] ;sum of walk access to transit
        _HBWTRAND = _HBWTRAND + mi.01.dTRN[j] ;sum of drive access to transit  
    
        _HBWBRTW  = _HBWBRTW  + mi.01.wBRT[j]
        _HBWBRTD  = _HBWBRTD  + mi.01.dBRT[j]
    
        _HBW_DANON  = _HBW_DANON  + mi.07.alone_non[j] 
        _HBW_DATOL  = _HBW_DATOL  + mi.07.alone_toll[j]
        _HBW_SR2NON = _HBW_SR2NON + mi.07.sr2_non[j]
        _HBW_SR2TOL = _HBW_SR2TOL + mi.07.sr2_toll[j]  
        _HBW_SR2HOV = _HBW_SR2HOV + mi.07.sr2_hov[j]
        _HBW_SR3NON = _HBW_SR3NON + mi.07.sr3_non[j]
        _HBW_SR3TOL = _HBW_SR3TOL + mi.07.sr3_toll[j]
        _HBW_SR3HOV = _HBW_SR3HOV + mi.07.sr3_hov[j]
    
        
        _HBCMOTOR = _HBCMOTOR + mi.02.motor[j] 
        _HBCNONMO = _HBCNONMO + mi.02.nonmotor[j]
        _HBCTRANT = _HBCTRANT + mi.02.transit[j]
        _HBCAUTOT = _HBCAUTOT + mi.02.auto[j]
        _HBCAUTO1 = _HBCAUTO1 + mi.02.DA[j]
        _HBCAUTO2 = _HBCAUTO2 + mi.02.SR2[j]
        _HBCAUTO3 = _HBCAUTO3 + mi.02.SR3p[j]  
        _HBCLCLW  = _HBCLCLW  + mi.02.wLCL[j]
        _HBCLCLD  = _HBCLCLD  + mi.02.dLCL[j]
        _HBCCORW  = _HBCCORW  + mi.02.wCOR[j]
        _HBCCORD  = _HBCCORD  + mi.02.dCOR[j]
        _HBCEXPW  = _HBCEXPW  + mi.02.wEXP[j]
        _HBCEXPD  = _HBCEXPD  + mi.02.dEXP[j]
        _HBCLRTW  = _HBCLRTW  + mi.02.wLRT[j]
        _HBCLRTD  = _HBCLRTD  + mi.02.dLRT[j]
        _HBCCRTW  = _HBCCRTW  + mi.02.wCRT[j]
        _HBCCRTD  = _HBCCRTD  + mi.02.dCRT[j]
        _HBCTRANW = _HBCTRANW + mi.02.wTRN[j];sum of walk access to transit
        _HBCTRAND = _HBCTRAND + mi.02.dTRN[j] ;sum of drive access to transit  
    
        _HBCBRTW  = _HBCBRTW  + mi.02.wBRT[j]
        _HBCBRTD  = _HBCBRTD  + mi.02.dBRT[j]
    
        _HBC_DANON  = _HBC_DANON  + mi.08.alone_non[j] 
        _HBC_SR2NON = _HBC_SR2NON + mi.08.sr2_non[j]
        _HBC_SR3NON = _HBC_SR3NON + mi.08.sr3_non[j]
        _HBC_SR2HOV = _HBC_SR2HOV + mi.08.sr2_hov[j]
        _HBC_SR3HOV = _HBC_SR3HOV + mi.08.sr3_hov[j]
        _HBC_DATOL  = _HBC_DATOL  + mi.08.alone_toll[j]
        _HBC_SR2TOL = _HBC_SR2TOL + mi.08.sr2_toll[j]    
        _HBC_SR3TOL = _HBC_SR3TOL + mi.08.sr3_toll[j]
        
                
        _HBOMOTOR = _HBOMOTOR + mi.03.motor[j] 
        _HBONONMO = _HBONONMO + mi.03.nonmotor[j]
        _HBOTRANT = _HBOTRANT + mi.03.transit[j]
        _HBOAUTOT = _HBOAUTOT + mi.03.auto[j]
        _HBOAUTO1 = _HBOAUTO1 + mi.03.DA[j]
        _HBOAUTO2 = _HBOAUTO2 + mi.03.SR2[j]
        _HBOAUTO3 = _HBOAUTO3 + mi.03.SR3p[j]    
        _HBOLCLW  = _HBOLCLW  + mi.03.wLCL[j]
        _HBOLCLD  = _HBOLCLD  + mi.03.dLCL[j]
        _HBOCORW  = _HBOCORW  + mi.03.wCOR[j]
        _HBOCORD  = _HBOCORD  + mi.03.dCOR[j]
        _HBOEXPW  = _HBOEXPW  + mi.03.wEXP[j]
        _HBOEXPD  = _HBOEXPD  + mi.03.dEXP[j]
        _HBOLRTW  = _HBOLRTW  + mi.03.wLRT[j]
        _HBOLRTD  = _HBOLRTD  + mi.03.dLRT[j]
        _HBOCRTW  = _HBOCRTW  + mi.03.wCRT[j]
        _HBOCRTD  = _HBOCRTD  + mi.03.dCRT[j]
        _HBOTRANW = _HBOTRANW + mi.03.wTRN[j] ;sum of walk access to transit
        _HBOTRAND = _HBOTRAND + mi.03.dTRN[j] ;sum of drive access to transit     
    
        _HBOBRTW  = _HBOBRTW  + mi.03.wBRT[j]
        _HBOBRTD  = _HBOBRTD  + mi.03.dBRT[j]
    
        _HBO_DANON  = _HBO_DANON  + mi.09.alone_non[j] 
        _HBO_SR2NON = _HBO_SR2NON + mi.09.sr2_non[j]
        _HBO_SR3NON = _HBO_SR3NON + mi.09.sr3_non[j]
        _HBO_SR2HOV = _HBO_SR2HOV + mi.09.sr2_hov[j]
        _HBO_SR3HOV = _HBO_SR3HOV + mi.09.sr3_hov[j]
        _HBO_DATOL  = _HBO_DATOL  + mi.09.alone_toll[j]
        _HBO_SR2TOL = _HBO_SR2TOL + mi.09.sr2_toll[j]
        _HBO_SR3TOL = _HBO_SR3TOL + mi.09.sr3_toll[j]
        
    
        _NHBMOTOR = _NHBMOTOR + mi.04.motor[j] 
        _NHBNONMO = _NHBNONMO + mi.04.nonmotor[j]
        _NHBTRANT = _NHBTRANT + mi.04.transit[j]
        _NHBAUTOT = _NHBAUTOT + mi.04.auto[j]
        _NHBAUTO1 = _NHBAUTO1 + mi.04.DA[j]
        _NHBAUTO2 = _NHBAUTO2 + mi.04.SR2[j]
        _NHBAUTO3 = _NHBAUTO3 + mi.04.SR3p[j]  
        _NHBLCLW  = _NHBLCLW  + mi.04.wLCL[j]
        _NHBLCLD  = _NHBLCLD  + mi.04.dLCL[j]
        _NHBCORW  = _NHBCORW  + mi.04.wCOR[j]
        _NHBCORD  = _NHBCORD  + mi.04.dCOR[j]
        _NHBEXPW  = _NHBEXPW  + mi.04.wEXP[j]
        _NHBEXPD  = _NHBEXPD  + mi.04.dEXP[j]
        _NHBLRTW  = _NHBLRTW  + mi.04.wLRT[j]
        _NHBLRTD  = _NHBLRTD  + mi.04.dLRT[j]
        _NHBCRTW  = _NHBCRTW  + mi.04.wCRT[j]
        _NHBCRTD  = _NHBCRTD  + mi.04.dCRT[j]
        _NHBTRANW = _NHBTRANW + mi.04.wTRN[j] ;sum of walk access to transit
        _NHBTRAND = _NHBTRAND + mi.04.dTRN[j] ;sum of drive access to transit   
    
        _NHBBRTW  = _NHBBRTW  + mi.04.wBRT[j]
        _NHBBRTD  = _NHBBRTD  + mi.04.dBRT[j]
        
        _NHB_DANON  = _NHB_DANON  + mi.10.alone_non[j] 
        _NHB_SR2NON = _NHB_SR2NON + mi.10.sr2_non[j]
        _NHB_SR3NON = _NHB_SR3NON + mi.10.sr3_non[j]
        _NHB_SR2HOV = _NHB_SR2HOV + mi.10.sr2_hov[j]
        _NHB_SR3HOV = _NHB_SR3HOV + mi.10.sr3_hov[j]
        _NHB_DATOL  = _NHB_DATOL  + mi.10.alone_toll[j]
        _NHB_SR2TOL = _NHB_SR2TOL + mi.10.sr2_toll[j]    
        _NHB_SR3TOL = _NHB_SR3TOL + mi.10.sr3_toll[j]
        
        
        PR_HBSch_SB = PR_HBSch_SB + mi.05.Ok_SchoolBus[j]
        PR_HBSch_DS = PR_HBSch_DS + mi.05.Ok_DriveSelf[j]
        PR_HBSch_DO = PR_HBSch_DO + mi.05.Ok_DropOff[j]
        PR_HBSch_Wk = PR_HBSch_Wk + mi.05.Ok_Walk[j]
        PR_HBSch_Bk = PR_HBSch_Bk + mi.05.Ok_Bike[j]
        
        SC_HBSch_SB = SC_HBSch_SB + mi.06.Ok_SchoolBus[j]
        SC_HBSch_DS = SC_HBSch_DS + mi.06.Ok_DriveSelf[j]
        SC_HBSch_DO = SC_HBSch_DO + mi.06.Ok_DropOff[j]
        SC_HBSch_Wk = SC_HBSch_Wk + mi.06.Ok_Walk[j]
        SC_HBSch_Bk = SC_HBSch_Bk + mi.06.Ok_Bike[j]
        
      endif
    ENDJLOOP
    
    
    ;************** Once i-loop is finished, create summary
    if (i==zones)
        ;HBSch totals
        _HBS_SB = PR_HBSch_SB +
                  SC_HBSch_SB
        
        _HBS_DS = PR_HBSch_DS +
                  SC_HBSch_DS
        
        _HBS_DO = PR_HBSch_DO +
                  SC_HBSch_DO
        
        _HBSMOTOR_PR = PR_HBSch_SB +
                       PR_HBSch_DS +
                       PR_HBSch_DO
        
        _HBSMOTOR_SC = SC_HBSch_SB +
                       SC_HBSch_DS +
                       SC_HBSch_DO
        
        _HBSMOTOR = _HBSMOTOR_PR +
                    _HBSMOTOR_SC
        
        _HBSNONMO = PR_HBSch_Wk +
                    PR_HBSch_Bk +
                    SC_HBSch_Wk +
                    SC_HBSch_Bk
        
        _HBSTRIPT = _HBSMOTOR + _HBSNONMO
        
      ;Grand total trips is Motor + Non-Motor
      _HBWTRIPT = _HBWMOTOR + _HBWNONMO 
      _HBCTRIPT = _HBCMOTOR + _HBCNONMO 
      _HBOTRIPT = _HBOMOTOR + _HBONONMO 
      _NHBTRIPT = _NHBMOTOR + _NHBNONMO 
    
      ;Total transit is sum of walk + drive
      _HBWLCLT = _HBWLCLW + _HBWLCLD
      _HBWCORT = _HBWCORW + _HBWCORD
      _HBWEXPT = _HBWEXPW + _HBWEXPD
      _HBWLRTT = _HBWLRTW + _HBWLRTD
      _HBWCRTT = _HBWCRTW + _HBWCRTD
      _HBWBRTT = _HBWBRTW + _HBWBRTD
    
      _HBCLCLT = _HBCLCLW + _HBCLCLD
      _HBCCORT = _HBCCORW + _HBCCORD
      _HBCEXPT = _HBCEXPW + _HBCEXPD
      _HBCLRTT = _HBCLRTW + _HBCLRTD
      _HBCCRTT = _HBCCRTW + _HBCCRTD
      _HBCBRTT = _HBCBRTW + _HBCBRTD
    
      _HBOLCLT = _HBOLCLW + _HBOLCLD
      _HBOCORT = _HBOCORW + _HBOCORD
      _HBOEXPT = _HBOEXPW + _HBOEXPD
      _HBOLRTT = _HBOLRTW + _HBOLRTD
      _HBOCRTT = _HBOCRTW + _HBOCRTD
      _HBOBRTT = _HBOBRTW + _HBOBRTD
    
      _NHBLCLT = _NHBLCLW + _NHBLCLD
      _NHBCORT = _NHBCORW + _NHBCORD
      _NHBEXPT = _NHBEXPW + _NHBEXPD
      _NHBLRTT = _NHBLRTW + _NHBLRTD
      _NHBCRTT = _NHBCRTW + _NHBCRTD
      _NHBBRTT = _NHBBRTW + _NHBBRTD
    
      ;Total the purposes
      _TOTTRIPT = _HBWTRIPT + 
                  _HBCTRIPT + 
                  _HBOTRIPT + 
                  _NHBTRIPT + 
                  _HBSTRIPT*100                         ;added HBSch
      
        _TOTNONMO = _HBWNONMO + 
                    _HBCNONMO + 
                    _HBONONMO + 
                    _NHBNONMO + 
                    _HBSNONMO*100                       ;added HBSch
        
        _TOTMOTOR = _HBWMOTOR + 
                    _HBCMOTOR + 
                    _HBOMOTOR + 
                    _NHBMOTOR + 
                    _HBSMOTOR*100                       ;added HBSch
          
          _TOTAUTOT = _HBWAUTOT + 
                      _HBCAUTOT + 
                      _HBOAUTOT + 
                      _NHBAUTOT + 
                      _HBSMOTOR*100                       ;added HBSch
          
            _TOTAUTO1 = _HBWAUTO1 + _HBCAUTO1 + _HBOAUTO1 + _NHBAUTO1
              _TOT_DANON = _HBW_DANON + _HBC_DANON + _HBO_DANON + _NHB_DANON
              _TOT_DATOL = _HBW_DATOL + _HBC_DATOL + _HBO_DATOL + _NHB_DATOL
            _TOTAUTO2 = _HBWAUTO2 + _HBCAUTO2 + _HBOAUTO2 + _NHBAUTO2
              _TOT_SR2NON = _HBW_SR2NON + _HBC_SR2NON + _HBO_SR2NON + _NHB_SR2NON
              _TOT_SR2TOL = _HBW_SR2TOL + _HBC_SR2TOL + _HBO_SR2TOL + _NHB_SR2TOL
              _TOT_SR2HOV = _HBW_SR2HOV + _HBC_SR2HOV + _HBO_SR2HOV + _NHB_SR2HOV
            _TOTAUTO3 = _HBWAUTO3 + _HBCAUTO3 + _HBOAUTO3 + _NHBAUTO3
              _TOT_SR3NON = _HBW_SR3NON + _HBC_SR3NON + _HBO_SR3NON + _NHB_SR3NON
              _TOT_SR3TOL = _HBW_SR3TOL + _HBC_SR3TOL + _HBO_SR3TOL + _NHB_SR3TOL
              _TOT_SR3HOV = _HBW_SR3HOV + _HBC_SR3HOV + _HBO_SR3HOV + _NHB_SR3HOV
                    
          _TOTTRANT = _HBWTRANT + _HBCTRANT + _HBOTRANT + _NHBTRANT
            _TOTLCLT = _HBWLCLT + _HBCLCLT + _HBOLCLT + _NHBLCLT
              _TOTLCLW  = _HBWLCLW  + _HBCLCLW  + _HBOLCLW  + _NHBLCLW
              _TOTLCLD  = _HBWLCLD  + _HBCLCLD  + _HBOLCLD  + _NHBLCLD
            _TOTCORT = _HBWCORT + _HBCCORT + _HBOCORT + _NHBCORT
              _TOTCORW  = _HBWCORW  + _HBCCORW  + _HBOCORW  + _NHBCORW
              _TOTCORD  = _HBWCORD  + _HBCCORD  + _HBOCORD  + _NHBCORD
            _TOTEXPT = _HBWEXPT + _HBCEXPT + _HBOEXPT + _NHBEXPT
              _TOTEXPW  = _HBWEXPW  + _HBCEXPW  + _HBOEXPW  + _NHBEXPW
              _TOTEXPD  = _HBWEXPD  + _HBCEXPD  + _HBOEXPD  + _NHBEXPD
            _TOTLRTT = _HBWLRTT + _HBCLRTT + _HBOLRTT + _NHBLRTT
              _TOTLRTW  = _HBWLRTW  + _HBCLRTW  + _HBOLRTW  + _NHBLRTW
              _TOTLRTD  = _HBWLRTD  + _HBCLRTD  + _HBOLRTD  + _NHBLRTD
            _TOTCRTT = _HBWCRTT + _HBCCRTT + _HBOCRTT + _NHBCRTT
              _TOTCRTW  = _HBWCRTW  + _HBCCRTW  + _HBOCRTW  + _NHBCRTW
              _TOTCRTD  = _HBWCRTD  + _HBCCRTD  + _HBOCRTD  + _NHBCRTD    
            _TOTBRTT = _HBWBRTT + _HBCBRTT + _HBOBRTT + _NHBBRTT
              _TOTBRTW  = _HBWBRTW  + _HBCBRTW  + _HBOBRTW  + _NHBBRTW
              _TOTBRTD  = _HBWBRTD  + _HBCBRTD  + _HBOBRTD  + _NHBBRTD 
    
        
      ;*********************** Note:  Purpose blocks are identical but for HBW, HBC, etc; so updates can be easily made by changing these prefixes.
      ;*********************** Compute HBW absolute share info
      if (_HBWTRIPT!=0)  
        _HBWNONMO_SABS = (_HBWNONMO / _HBWTRIPT)*100  ;Absolute Non-Motorized Share
        _HBWMOTOR_SABS = (_HBWMOTOR / _HBWTRIPT)*100  ;Absolute Motorized Share
          _HBWAUTOT_SABS = (_HBWAUTOT / _HBWTRIPT)*100  ;Absolute Auto Share
            _HBWAUTO1_SABS = (_HBWAUTO1 / _HBWTRIPT)*100  ;Absolute Drive-Alone Share
              _HBW_DANON_SABS = (_HBW_DANON / _HBWTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBW_DATOL_SABS = (_HBW_DATOL / _HBWTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBWAUTO2_SABS = (_HBWAUTO2 / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBW_SR2NON_SABS = (_HBW_SR2NON / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBW_SR2TOL_SABS = (_HBW_SR2TOL / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBW_SR2HOV_SABS = (_HBW_SR2HOV / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBWAUTO3_SABS = (_HBWAUTO3 / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBW_SR3NON_SABS = (_HBW_SR3NON / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBW_SR3TOL_SABS = (_HBW_SR3TOL / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBW_SR3HOV_SABS = (_HBW_SR3HOV / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBWTRANT_SABS = (_HBWTRANT / _HBWTRIPT)*100  ;Absolute Transit Share
            _HBWLCLT_SABS = (_HBWLCLT / _HBWTRIPT)*100  ;Absolute Transit Local Share
              _HBWLCLW_SABS = (_HBWLCLW / _HBWTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBWLCLD_SABS = (_HBWLCLD / _HBWTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBWCORT_SABS = (_HBWCORT / _HBWTRIPT)*100  ;Absolute Transit COR Share
              _HBWCORW_SABS = (_HBWCORW / _HBWTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBWCORD_SABS = (_HBWCORD / _HBWTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBWEXPT_SABS = (_HBWEXPT / _HBWTRIPT)*100  ;Absolute Transit Express Share
              _HBWEXPW_SABS = (_HBWEXPW / _HBWTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBWEXPD_SABS = (_HBWEXPD / _HBWTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBWLRTT_SABS = (_HBWLRTT / _HBWTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBWLRTW_SABS = (_HBWLRTW / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBWLRTD_SABS = (_HBWLRTD / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBWCRTT_SABS = (_HBWCRTT / _HBWTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBWCRTW_SABS = (_HBWCRTW / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBWCRTD_SABS = (_HBWCRTD / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBWBRTT_SABS = (_HBWBRTT / _HBWTRIPT)*100  ;Absolute Transit BRT Share
              _HBWBRTW_SABS = (_HBWBRTW / _HBWTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBWBRTD_SABS = (_HBWBRTD / _HBWTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBW relative share info
      if (_HBWTRIPT!=0)  
        _HBWMOTOR_SREL = (_HBWMOTOR / _HBWTRIPT)*100  ;Relative Motorized Share
        _HBWNONMO_SREL = (_HBWNONMO / _HBWTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBWMOTOR!=0)  
          _HBWAUTOT_SREL = (_HBWAUTOT / _HBWMOTOR)*100  ;Relative Auto Share
          _HBWTRANT_SREL = (_HBWTRANT / _HBWMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBWAUTOT!=0)  
            _HBWAUTO1_SREL = (_HBWAUTO1 / _HBWAUTOT)*100  ;Relative Drive-Alone Share
            _HBWAUTO2_SREL = (_HBWAUTO2 / _HBWAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBWAUTO3_SREL = (_HBWAUTO3 / _HBWAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBWAUTO1!=0)  
              _HBW_DANON_SREL = (_HBW_DANON / _HBWAUTO1)*100  ;Relative DA non-tol
              _HBW_DATOL_SREL = (_HBW_DATOL / _HBWAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBWAUTO2!=0)  
              _HBW_SR2NON_SREL = (_HBW_SR2NON / _HBWAUTO2)*100  
              _HBW_SR2TOL_SREL = (_HBW_SR2TOL / _HBWAUTO2)*100  
              _HBW_SR2HOV_SREL = (_HBW_SR2HOV / _HBWAUTO2)*100  
      endif    
      if (_HBWAUTO3!=0)  
              _HBW_SR3NON_SREL = (_HBW_SR3NON / _HBWAUTO3)*100  
              _HBW_SR3TOL_SREL = (_HBW_SR3TOL / _HBWAUTO3)*100  
              _HBW_SR3HOV_SREL = (_HBW_SR3HOV / _HBWAUTO3)*100  
      endif   
      if (_HBWTRANT!=0)  
            _HBWLCLT_SREL = (_HBWLCLT / _HBWTRANT)*100  ;Relative Transit Local Share
            _HBWCORT_SREL = (_HBWCORT / _HBWTRANT)*100  ;Relative Transit COR Share
            _HBWEXPT_SREL = (_HBWEXPT / _HBWTRANT)*100  ;Relative Transit Express Share
            _HBWLRTT_SREL = (_HBWLRTT / _HBWTRANT)*100  ;Relative Transit Light-Rail Share
            _HBWCRTT_SREL = (_HBWCRTT / _HBWTRANT)*100  ;Relative Transit Commuter rail Share
            _HBWBRTT_SREL = (_HBWBRTT / _HBWTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBWLCLT!=0)  
              _HBWLCLW_SREL = (_HBWLCLW / _HBWLCLT)*100  ;Relative Transit Local-Walk Share
              _HBWLCLD_SREL = (_HBWLCLD / _HBWLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBWLCLW_SREL = .0001
              _HBWLCLD_SREL = .0001          
      endif
      if (_HBWCORT!=0)  
              _HBWCORW_SREL = (_HBWCORW / _HBWCORT)*100  ;Relative Transit COR-Walk Share
              _HBWCORD_SREL = (_HBWCORD / _HBWCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBWCORW_SREL = .0001
              _HBWCORD_SREL = .0001          
      endif
      if (_HBWEXPT!=0)  
              _HBWEXPW_SREL = (_HBWEXPW / _HBWEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBWEXPD_SREL = (_HBWEXPD / _HBWEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBWEXPW_SREL = .0001
              _HBWEXPD_SREL = .0001
      endif 
      if (_HBWLRTT!=0)  
              _HBWLRTW_SREL = (_HBWLRTW / _HBWLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBWLRTD_SREL = (_HBWLRTD / _HBWLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBWLRTW_SREL = .0001
              _HBWLRTD_SREL = .0001
      endif      
      if (_HBWCRTT!=0)  
              _HBWCRTW_SREL = (_HBWCRTW / _HBWCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBWCRTD_SREL = (_HBWCRTD / _HBWCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBWCRTW_SREL = .0001
              _HBWCRTD_SREL = .0001
      endif
      if (_HBWBRTT!=0)  
              _HBWBRTW_SREL = (_HBWBRTW / _HBWBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBWBRTD_SREL = (_HBWBRTD / _HBWBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBWBRTW_SREL = .0001
              _HBWBRTD_SREL = .0001
      endif
    
      
      ;*********************** Compute HBC absolute share info
      if (_HBCTRIPT!=0)  
        _HBCNONMO_SABS = (_HBCNONMO / _HBCTRIPT)*100  ;Absolute Non-Motorized Share
        _HBCMOTOR_SABS = (_HBCMOTOR / _HBCTRIPT)*100  ;Absolute Motorized Share
          _HBCAUTOT_SABS = (_HBCAUTOT / _HBCTRIPT)*100  ;Absolute Auto Share
            _HBCAUTO1_SABS = (_HBCAUTO1 / _HBCTRIPT)*100  ;Absolute Drive-Alone Share
              _HBC_DANON_SABS = (_HBC_DANON / _HBCTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBC_DATOL_SABS = (_HBC_DATOL / _HBCTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBCAUTO2_SABS = (_HBCAUTO2 / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBC_SR2NON_SABS = (_HBC_SR2NON / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBC_SR2TOL_SABS = (_HBC_SR2TOL / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBC_SR2HOV_SABS = (_HBC_SR2HOV / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBCAUTO3_SABS = (_HBCAUTO3 / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBC_SR3NON_SABS = (_HBC_SR3NON / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBC_SR3TOL_SABS = (_HBC_SR3TOL / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBC_SR3HOV_SABS = (_HBC_SR3HOV / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBCTRANT_SABS = (_HBCTRANT / _HBCTRIPT)*100  ;Absolute Transit Share
            _HBCLCLT_SABS = (_HBCLCLT / _HBCTRIPT)*100  ;Absolute Transit Local Share
              _HBCLCLW_SABS = (_HBCLCLW / _HBCTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBCLCLD_SABS = (_HBCLCLD / _HBCTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBCCORT_SABS = (_HBCCORT / _HBCTRIPT)*100  ;Absolute Transit COR Share
              _HBCCORW_SABS = (_HBCCORW / _HBCTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBCCORD_SABS = (_HBCCORD / _HBCTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBCEXPT_SABS = (_HBCEXPT / _HBCTRIPT)*100  ;Absolute Transit Express Share
              _HBCEXPW_SABS = (_HBCEXPW / _HBCTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBCEXPD_SABS = (_HBCEXPD / _HBCTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBCLRTT_SABS = (_HBCLRTT / _HBCTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBCLRTW_SABS = (_HBCLRTW / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBCLRTD_SABS = (_HBCLRTD / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBCCRTT_SABS = (_HBCCRTT / _HBCTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBCCRTW_SABS = (_HBCCRTW / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBCCRTD_SABS = (_HBCCRTD / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBCBRTT_SABS = (_HBCBRTT / _HBCTRIPT)*100  ;Absolute Transit BRT Share
              _HBCBRTW_SABS = (_HBCBRTW / _HBCTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBCBRTD_SABS = (_HBCBRTD / _HBCTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBC relative share info
      if (_HBCTRIPT!=0)  
        _HBCMOTOR_SREL = (_HBCMOTOR / _HBCTRIPT)*100  ;Relative Motorized Share
        _HBCNONMO_SREL = (_HBCNONMO / _HBCTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBCMOTOR!=0)  
          _HBCAUTOT_SREL = (_HBCAUTOT / _HBCMOTOR)*100  ;Relative Auto Share
          _HBCTRANT_SREL = (_HBCTRANT / _HBCMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBCAUTOT!=0)  
            _HBCAUTO1_SREL = (_HBCAUTO1 / _HBCAUTOT)*100  ;Relative Drive-Alone Share
            _HBCAUTO2_SREL = (_HBCAUTO2 / _HBCAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBCAUTO3_SREL = (_HBCAUTO3 / _HBCAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBCAUTO1!=0)  
              _HBC_DANON_SREL = (_HBC_DANON / _HBCAUTO1)*100  ;Relative DA non-tol
              _HBC_DATOL_SREL = (_HBC_DATOL / _HBCAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBCAUTO2!=0)  
              _HBC_SR2NON_SREL = (_HBC_SR2NON / _HBCAUTO2)*100  
              _HBC_SR2TOL_SREL = (_HBC_SR2TOL / _HBCAUTO2)*100  
              _HBC_SR2HOV_SREL = (_HBC_SR2HOV / _HBCAUTO2)*100  
      endif    
      if (_HBCAUTO3!=0)  
              _HBC_SR3NON_SREL = (_HBC_SR3NON / _HBCAUTO3)*100  
              _HBC_SR3TOL_SREL = (_HBC_SR3TOL / _HBCAUTO3)*100  
              _HBC_SR3HOV_SREL = (_HBC_SR3HOV / _HBCAUTO3)*100  
      endif   
      if (_HBCTRANT!=0)  
            _HBCLCLT_SREL = (_HBCLCLT / _HBCTRANT)*100  ;Relative Transit Local Share
            _HBCCORT_SREL = (_HBCCORT / _HBCTRANT)*100  ;Relative Transit COR Share
            _HBCEXPT_SREL = (_HBCEXPT / _HBCTRANT)*100  ;Relative Transit Express Share
            _HBCLRTT_SREL = (_HBCLRTT / _HBCTRANT)*100  ;Relative Transit Light-Rail Share
            _HBCCRTT_SREL = (_HBCCRTT / _HBCTRANT)*100  ;Relative Transit Commuter rail Share
            _HBCBRTT_SREL = (_HBCBRTT / _HBCTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBCLCLT!=0)  
              _HBCLCLW_SREL = (_HBCLCLW / _HBCLCLT)*100  ;Relative Transit Local-Walk Share
              _HBCLCLD_SREL = (_HBCLCLD / _HBCLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLCLW_SREL = .0001
              _HBCLCLD_SREL = .0001          
      endif
      if (_HBCCORT!=0)  
              _HBCCORW_SREL = (_HBCCORW / _HBCCORT)*100  ;Relative Transit COR-Walk Share
              _HBCCORD_SREL = (_HBCCORD / _HBCCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBCCORW_SREL = .0001
              _HBCCORD_SREL = .0001          
      endif
      if (_HBCEXPT!=0)  
              _HBCEXPW_SREL = (_HBCEXPW / _HBCEXPT)*100  ;Relative Transit Local-Walk Share
              _HBCEXPD_SREL = (_HBCEXPD / _HBCEXPT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCEXPW_SREL = .0001
              _HBCEXPD_SREL = .0001
      endif 
      if (_HBCLRTT!=0)  
              _HBCLRTW_SREL = (_HBCLRTW / _HBCLRTT)*100  ;Relative Transit Local-Walk Share
              _HBCLRTD_SREL = (_HBCLRTD / _HBCLRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLRTW_SREL = .0001
              _HBCLRTD_SREL = .0001
      endif      
      if (_HBCCRTT!=0)  
              _HBCCRTW_SREL = (_HBCCRTW / _HBCCRTT)*100  ;Relative Transit Local-Walk Share
              _HBCCRTD_SREL = (_HBCCRTD / _HBCCRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCCRTW_SREL = .0001
              _HBCCRTD_SREL = .0001
      endif
      if (_HBCBRTT!=0)  
              _HBCBRTW_SREL = (_HBCBRTW / _HBCBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBCBRTD_SREL = (_HBCBRTD / _HBCBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBCBRTW_SREL = .0001
              _HBCBRTD_SREL = .0001
      endif
    
      ;*********************** Compute HBO absolute share info
      if (_HBOTRIPT!=0)  
        _HBONONMO_SABS = (_HBONONMO / _HBOTRIPT)*100  ;Absolute Non-Motorized Share
        _HBOMOTOR_SABS = (_HBOMOTOR / _HBOTRIPT)*100  ;Absolute Motorized Share
          _HBOAUTOT_SABS = (_HBOAUTOT / _HBOTRIPT)*100  ;Absolute Auto Share
            _HBOAUTO1_SABS = (_HBOAUTO1 / _HBOTRIPT)*100  ;Absolute Drive-Alone Share
              _HBO_DANON_SABS = (_HBO_DANON / _HBOTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBO_DATOL_SABS = (_HBO_DATOL / _HBOTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBOAUTO2_SABS = (_HBOAUTO2 / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBO_SR2NON_SABS = (_HBO_SR2NON / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBO_SR2TOL_SABS = (_HBO_SR2TOL / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBO_SR2HOV_SABS = (_HBO_SR2HOV / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBOAUTO3_SABS = (_HBOAUTO3 / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBO_SR3NON_SABS = (_HBO_SR3NON / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBO_SR3TOL_SABS = (_HBO_SR3TOL / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBO_SR3HOV_SABS = (_HBO_SR3HOV / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBOTRANT_SABS = (_HBOTRANT / _HBOTRIPT)*100  ;Absolute Transit Share
            _HBOLCLT_SABS = (_HBOLCLT / _HBOTRIPT)*100  ;Absolute Transit Local Share
              _HBOLCLW_SABS = (_HBOLCLW / _HBOTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBOLCLD_SABS = (_HBOLCLD / _HBOTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBOCORT_SABS = (_HBOCORT / _HBOTRIPT)*100  ;Absolute Transit COR Share
              _HBOCORW_SABS = (_HBOCORW / _HBOTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBOCORD_SABS = (_HBOCORD / _HBOTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBOEXPT_SABS = (_HBOEXPT / _HBOTRIPT)*100  ;Absolute Transit Express Share
              _HBOEXPW_SABS = (_HBOEXPW / _HBOTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBOEXPD_SABS = (_HBOEXPD / _HBOTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBOLRTT_SABS = (_HBOLRTT / _HBOTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBOLRTW_SABS = (_HBOLRTW / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBOLRTD_SABS = (_HBOLRTD / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBOCRTT_SABS = (_HBOCRTT / _HBOTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBOCRTW_SABS = (_HBOCRTW / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBOCRTD_SABS = (_HBOCRTD / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBOBRTT_SABS = (_HBOBRTT / _HBOTRIPT)*100  ;Absolute Transit BRT Share
              _HBOBRTW_SABS = (_HBOBRTW / _HBOTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBOBRTD_SABS = (_HBOBRTD / _HBOTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBO relative share info
      if (_HBOTRIPT!=0)  
        _HBOMOTOR_SREL = (_HBOMOTOR / _HBOTRIPT)*100  ;Relative Motorized Share
        _HBONONMO_SREL = (_HBONONMO / _HBOTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBOMOTOR!=0)  
          _HBOAUTOT_SREL = (_HBOAUTOT / _HBOMOTOR)*100  ;Relative Auto Share
          _HBOTRANT_SREL = (_HBOTRANT / _HBOMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBOAUTOT!=0)  
            _HBOAUTO1_SREL = (_HBOAUTO1 / _HBOAUTOT)*100  ;Relative Drive-Alone Share
            _HBOAUTO2_SREL = (_HBOAUTO2 / _HBOAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBOAUTO3_SREL = (_HBOAUTO3 / _HBOAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBOAUTO1!=0)  
              _HBO_DANON_SREL = (_HBO_DANON / _HBOAUTO1)*100  ;Relative DA non-tol
              _HBO_DATOL_SREL = (_HBO_DATOL / _HBOAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBOAUTO2!=0)  
              _HBO_SR2NON_SREL = (_HBO_SR2NON / _HBOAUTO2)*100  
              _HBO_SR2TOL_SREL = (_HBO_SR2TOL / _HBOAUTO2)*100  
              _HBO_SR2HOV_SREL = (_HBO_SR2HOV / _HBOAUTO2)*100  
      endif    
      if (_HBOAUTO3!=0)  
              _HBO_SR3NON_SREL = (_HBO_SR3NON / _HBOAUTO3)*100  
              _HBO_SR3TOL_SREL = (_HBO_SR3TOL / _HBOAUTO3)*100  
              _HBO_SR3HOV_SREL = (_HBO_SR3HOV / _HBOAUTO3)*100  
      endif   
      if (_HBOTRANT!=0)  
            _HBOLCLT_SREL = (_HBOLCLT / _HBOTRANT)*100  ;Relative Transit Local Share
            _HBOCORT_SREL = (_HBOCORT / _HBOTRANT)*100  ;Relative Transit COR Share
            _HBOEXPT_SREL = (_HBOEXPT / _HBOTRANT)*100  ;Relative Transit Express Share
            _HBOLRTT_SREL = (_HBOLRTT / _HBOTRANT)*100  ;Relative Transit Light-Rail Share
            _HBOCRTT_SREL = (_HBOCRTT / _HBOTRANT)*100  ;Relative Transit Commuter rail Share
            _HBOBRTT_SREL = (_HBOBRTT / _HBOTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBOLCLT!=0)  
              _HBOLCLW_SREL = (_HBOLCLW / _HBOLCLT)*100  ;Relative Transit Local-Walk Share
              _HBOLCLD_SREL = (_HBOLCLD / _HBOLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBOLCLW_SREL = .0001
              _HBOLCLD_SREL = .0001          
      endif
      if (_HBOCORT!=0)  
              _HBOCORW_SREL = (_HBOCORW / _HBOCORT)*100  ;Relative Transit COR-Walk Share
              _HBOCORD_SREL = (_HBOCORD / _HBOCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBOCORW_SREL = .0001
              _HBOCORD_SREL = .0001          
      endif
      if (_HBOEXPT!=0)  
              _HBOEXPW_SREL = (_HBOEXPW / _HBOEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBOEXPD_SREL = (_HBOEXPD / _HBOEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBOEXPW_SREL = .0001
              _HBOEXPD_SREL = .0001
      endif 
      if (_HBOLRTT!=0)  
              _HBOLRTW_SREL = (_HBOLRTW / _HBOLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBOLRTD_SREL = (_HBOLRTD / _HBOLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBOLRTW_SREL = .0001
              _HBOLRTD_SREL = .0001
      endif      
      if (_HBOCRTT!=0)  
              _HBOCRTW_SREL = (_HBOCRTW / _HBOCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBOCRTD_SREL = (_HBOCRTD / _HBOCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBOCRTW_SREL = .0001
              _HBOCRTD_SREL = .0001
      endif
      if (_HBOBRTT!=0)  
              _HBOBRTW_SREL = (_HBOBRTW / _HBOBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBOBRTD_SREL = (_HBOBRTD / _HBOBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBOBRTW_SREL = .0001
              _HBOBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute NHB relative share info
      if (_NHBTRIPT!=0)  
        _NHBMOTOR_SREL = (_NHBMOTOR / _NHBTRIPT)*100  ;Relative Motorized Share
        _NHBNONMO_SREL = (_NHBNONMO / _NHBTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_NHBMOTOR!=0)  
          _NHBAUTOT_SREL = (_NHBAUTOT / _NHBMOTOR)*100  ;Relative Auto Share
          _NHBTRANT_SREL = (_NHBTRANT / _NHBMOTOR)*100  ;Relative Transit Share
      endif
      if (_NHBAUTOT!=0)  
            _NHBAUTO1_SREL = (_NHBAUTO1 / _NHBAUTOT)*100  ;Relative Drive-Alone Share
            _NHBAUTO2_SREL = (_NHBAUTO2 / _NHBAUTOT)*100  ;Relative Shared ride 2 pers Share
            _NHBAUTO3_SREL = (_NHBAUTO3 / _NHBAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_NHBAUTO1!=0)  
              _NHB_DANON_SREL = (_NHB_DANON / _NHBAUTO1)*100  ;Relative DA non-tol
              _NHB_DATOL_SREL = (_NHB_DATOL / _NHBAUTO1)*100  ;Relative DA tol
      endif  
      if (_NHBAUTO2!=0)  
              _NHB_SR2NON_SREL = (_NHB_SR2NON / _NHBAUTO2)*100  
              _NHB_SR2TOL_SREL = (_NHB_SR2TOL / _NHBAUTO2)*100  
              _NHB_SR2HOV_SREL = (_NHB_SR2HOV / _NHBAUTO2)*100  
      endif    
      if (_NHBAUTO3!=0)  
              _NHB_SR3NON_SREL = (_NHB_SR3NON / _NHBAUTO3)*100  
              _NHB_SR3TOL_SREL = (_NHB_SR3TOL / _NHBAUTO3)*100  
              _NHB_SR3HOV_SREL = (_NHB_SR3HOV / _NHBAUTO3)*100  
      endif   
      if (_NHBTRANT!=0)  
            _NHBLCLT_SREL = (_NHBLCLT / _NHBTRANT)*100  ;Relative Transit Local Share
            _NHBCORT_SREL = (_NHBCORT / _NHBTRANT)*100  ;Relative Transit COR Share
            _NHBEXPT_SREL = (_NHBEXPT / _NHBTRANT)*100  ;Relative Transit Express Share
            _NHBLRTT_SREL = (_NHBLRTT / _NHBTRANT)*100  ;Relative Transit Light-Rail Share
            _NHBCRTT_SREL = (_NHBCRTT / _NHBTRANT)*100  ;Relative Transit Commuter rail Share
            _NHBBRTT_SREL = (_NHBBRTT / _NHBTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_NHBLCLT!=0)  
              _NHBLCLW_SREL = (_NHBLCLW / _NHBLCLT)*100  ;Relative Transit Local-Walk Share
              _NHBLCLD_SREL = (_NHBLCLD / _NHBLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _NHBLCLW_SREL = .0001
              _NHBLCLD_SREL = .0001          
      endif
      if (_NHBCORT!=0)  
              _NHBCORW_SREL = (_NHBCORW / _NHBCORT)*100  ;Relative Transit COR-Walk Share
              _NHBCORD_SREL = (_NHBCORD / _NHBCORT)*100  ;Relative Transit COR-Drive Share
      else
              _NHBCORW_SREL = .0001
              _NHBCORD_SREL = .0001          
      endif
      if (_NHBEXPT!=0)  
              _NHBEXPW_SREL = (_NHBEXPW / _NHBEXPT)*100  ;Relative Transit EXP-Walk Share
              _NHBEXPD_SREL = (_NHBEXPD / _NHBEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _NHBEXPW_SREL = .0001
              _NHBEXPD_SREL = .0001
      endif 
      if (_NHBLRTT!=0)  
              _NHBLRTW_SREL = (_NHBLRTW / _NHBLRTT)*100  ;Relative Transit LRT-Walk Share
              _NHBLRTD_SREL = (_NHBLRTD / _NHBLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _NHBLRTW_SREL = .0001
              _NHBLRTD_SREL = .0001
      endif      
      if (_NHBCRTT!=0)  
              _NHBCRTW_SREL = (_NHBCRTW / _NHBCRTT)*100  ;Relative Transit CRT-Walk Share
              _NHBCRTD_SREL = (_NHBCRTD / _NHBCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _NHBCRTW_SREL = .0001
              _NHBCRTD_SREL = .0001
      endif
      if (_NHBBRTT!=0)  
              _NHBBRTW_SREL = (_NHBBRTW / _NHBBRTT)*100  ;Relative Transit BRT-Walk Share
              _NHBBRTD_SREL = (_NHBBRTD / _NHBBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _NHBBRTW_SREL = .0001
              _NHBBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      
      ;*********************** Compute HBS share - relative
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_REL = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_REL = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
      endif
      
      if (_HBSMOTOR!=0)  
          PR_HBS_Rel = _HBSMOTOR_PR / _HBSMOTOR * 100
          SC_HBS_Rel = _HBSMOTOR_SC / _HBSMOTOR * 100
          
          HBS_SchBus_Rel = _HBS_SB / _HBSMOTOR * 100
          HBS_DrSelf_Rel = _HBS_DS / _HBSMOTOR * 100
          HBS_DrpOff_Rel = _HBS_DO   / _HBSMOTOR * 100
      endif
      
      if (_HBSMOTOR_PR!=0)  
          PR_HBS_SchBus_Rel = PR_HBSch_SB / _HBSMOTOR_PR * 100
          PR_HBS_DrSelf_Rel = PR_HBSch_DS / _HBSMOTOR_PR * 100
          PR_HBS_DrpOff_Rel = PR_HBSch_DO   / _HBSMOTOR_PR * 100
      endif
      
      if (_HBSMOTOR_SC!=0)  
          SC_HBS_SchBus_Rel = SC_HBSch_SB / _HBSMOTOR_SC * 100
          SC_HBS_DrSelf_Rel = SC_HBSch_DS / _HBSMOTOR_SC * 100
          SC_HBS_DrpOff_Rel = SC_HBSch_DO   / _HBSMOTOR_SC * 100
      endif
      
      ;*********************** Compute HBS share - absolute
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_Abs = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_Abs = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
          
          PR_HBS_Abs = _HBSMOTOR_PR / _HBSTRIPT * 100
          SC_HBS_Abs = _HBSMOTOR_SC / _HBSTRIPT * 100
          
          HBS_SchBus_Abs = _HBS_SB / _HBSTRIPT * 100
          HBS_DrSelf_Abs = _HBS_DS / _HBSTRIPT * 100
          HBS_DrpOff_Abs = _HBS_DO   / _HBSTRIPT * 100
          
          PR_HBS_SchBus_Abs = PR_HBSch_SB / _HBSTRIPT * 100
          PR_HBS_DrSelf_Abs = PR_HBSch_DS / _HBSTRIPT * 100
          PR_HBS_DrpOff_Abs = PR_HBSch_DO   / _HBSTRIPT * 100
          
          SC_HBS_SchBus_Abs = SC_HBSch_SB / _HBSTRIPT * 100
          SC_HBS_DrSelf_Abs = SC_HBSch_DS / _HBSTRIPT * 100
          SC_HBS_DrpOff_Abs = SC_HBSch_DO   / _HBSTRIPT * 100
      endif
      
    
      ;*********************** Compute TOT absolute share info
      if (_TOTTRIPT!=0)  
        _TOTNONMO_SABS = (_TOTNONMO / _TOTTRIPT)*100  ;Absolute Non-Motorized Share
        _TOTMOTOR_SABS = (_TOTMOTOR / _TOTTRIPT)*100  ;Absolute Motorized Share
          _TOTAUTOT_SABS = (_TOTAUTOT / _TOTTRIPT)*100  ;Absolute Auto Share
            _TOTAUTO1_SABS = (_TOTAUTO1 / _TOTTRIPT)*100  ;Absolute Drive-Alone Share
              _TOT_DANON_SABS = (_TOT_DANON / _TOTTRIPT)*100  
              _TOT_DATOL_SABS = (_TOT_DATOL / _TOTTRIPT)*100  
            _TOTAUTO2_SABS = (_TOTAUTO2 / _TOTTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _TOT_SR2NON_SABS = (_TOT_SR2NON / _TOTTRIPT)*100  
              _TOT_SR2TOL_SABS = (_TOT_SR2TOL / _TOTTRIPT)*100  
              _TOT_SR2HOV_SABS = (_TOT_SR2HOV / _TOTTRIPT)*100  
            _TOTAUTO3_SABS = (_TOTAUTO3 / _TOTTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _TOT_SR3NON_SABS = (_TOT_SR3NON / _TOTTRIPT)*100  
              _TOT_SR3TOL_SABS = (_TOT_SR3TOL / _TOTTRIPT)*100  
              _TOT_SR3HOV_SABS = (_TOT_SR3HOV / _TOTTRIPT)*100   
          _TOTTRANT_SABS = (_TOTTRANT / _TOTTRIPT)*100  ;Absolute Transit Share
            _TOTLCLT_SABS = (_TOTLCLT / _TOTTRIPT)*100  ;Absolute Transit Local Share
              _TOTLCLW_SABS = (_TOTLCLW / _TOTTRIPT)*100  ;Absolute Transit Local-Walk Share
              _TOTLCLD_SABS = (_TOTLCLD / _TOTTRIPT)*100  ;Absolute Transit Local-Drive Share
            _TOTCORT_SABS = (_TOTCORT / _TOTTRIPT)*100  ;Absolute Transit COR Share
              _TOTCORW_SABS = (_TOTCORW / _TOTTRIPT)*100  ;Absolute Transit COR-Walk Share
              _TOTCORD_SABS = (_TOTCORD / _TOTTRIPT)*100  ;Absolute Transit COR-Drive Share
            _TOTEXPT_SABS = (_TOTEXPT / _TOTTRIPT)*100  ;Absolute Transit Express Share
              _TOTEXPW_SABS = (_TOTEXPW / _TOTTRIPT)*100  ;Absolute Transit Express-Walk Share
              _TOTEXPD_SABS = (_TOTEXPD / _TOTTRIPT)*100  ;Absolute Transit Express-Drive Share
            _TOTLRTT_SABS = (_TOTLRTT / _TOTTRIPT)*100  ;Absolute Transit Light-Rail Share
              _TOTLRTW_SABS = (_TOTLRTW / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _TOTLRTD_SABS = (_TOTLRTD / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _TOTCRTT_SABS = (_TOTCRTT / _TOTTRIPT)*100  ;Absolute Transit Commuter rail Share
              _TOTCRTW_SABS = (_TOTCRTW / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _TOTCRTD_SABS = (_TOTCRTD / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _TOTBRTT_SABS = (_TOTBRTT / _TOTTRIPT)*100  ;Absolute Transit BRT Share
              _TOTBRTW_SABS = (_TOTBRTW / _TOTTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _TOTBRTD_SABS = (_TOTBRTD / _TOTTRIPT)*100  ;Absolute Transit BRT-Drive Share
              
          TOT_HBSMOTOR_Abs = _HBSMOTOR / (_TOTTRIPT/100) * 100
          
          PR_TOT_Abs = _HBSMOTOR_PR / (_TOTTRIPT/100) * 100
          SC_TOT_Abs = _HBSMOTOR_SC / (_TOTTRIPT/100) * 100
          
          TOT_SchBus_Abs = _HBS_SB / (_TOTTRIPT/100) * 100
          TOT_DrSelf_Abs = _HBS_DS / (_TOTTRIPT/100) * 100
          TOT_DrpOff_Abs = _HBS_DO / (_TOTTRIPT/100) * 100
          
          PR_TOT_SchBus_Abs = PR_HBSch_SB / (_TOTTRIPT/100) * 100
          PR_TOT_DrSelf_Abs = PR_HBSch_DS / (_TOTTRIPT/100) * 100
          PR_TOT_DrpOff_Abs = PR_HBSch_DO / (_TOTTRIPT/100) * 100
          
          SC_TOT_SchBus_Abs = SC_HBSch_SB / (_TOTTRIPT/100) * 100
          SC_TOT_DrSelf_Abs = SC_HBSch_DS / (_TOTTRIPT/100) * 100
          SC_TOT_DrpOff_Abs = SC_HBSch_DO / (_TOTTRIPT/100) * 100
      endif
    
      ;*********************** Compute TOT relative share info
      if (_TOTTRIPT!=0)  
        _TOTMOTOR_SREL = (_TOTMOTOR / _TOTTRIPT)*100  ;Relative Motorized Share
        _TOTNONMO_SREL = (_TOTNONMO / _TOTTRIPT)*100  ;Relative Non-Motorized Share
      endif
      
      if (_TOTMOTOR!=0)  
          _TOTAUTOT_SREL = (_TOTAUTOT / _TOTMOTOR)*100  ;Relative Auto Share
          _TOTTRANT_SREL = (_TOTTRANT / _TOTMOTOR)*100  ;Relative Transit Share
      endif
      
      if (_TOTAUTOT!=0)  
            _TOTAUTO1_SREL = (_TOTAUTO1 / _TOTAUTOT)*100  ;Relative Drive-Alone Share
            _TOTAUTO2_SREL = (_TOTAUTO2 / _TOTAUTOT)*100  ;Relative Shared ride 2 pers Share
            _TOTAUTO3_SREL = (_TOTAUTO3 / _TOTAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      
      if (_TOTAUTO1!=0)  
              _TOT_DANON_SREL = (_TOT_DANON / _TOTAUTO1)*100 
              _TOT_DATOL_SREL = (_TOT_DATOL / _TOTAUTO1)*100 
      endif
      
      if (_TOTAUTO2!=0)  
              _TOT_SR2NON_SREL = (_TOT_SR2NON / _TOTAUTO2)*100 
              _TOT_SR2TOL_SREL = (_TOT_SR2TOL / _TOTAUTO2)*100 
              _TOT_SR2HOV_SREL = (_TOT_SR2HOV / _TOTAUTO2)*100 
      endif
      
      if (_TOTAUTO3!=0)  
              _TOT_SR3NON_SREL = (_TOT_SR3NON / _TOTAUTO3)*100 
              _TOT_SR3TOL_SREL = (_TOT_SR3TOL / _TOTAUTO3)*100 
              _TOT_SR3HOV_SREL = (_TOT_SR3HOV / _TOTAUTO3)*100 
      endif
      
      if (_TOTTRANT!=0)  
            _TOTLCLT_SREL = (_TOTLCLT / _TOTTRANT)*100  ;Relative Transit Local Share
            _TOTCORT_SREL = (_TOTCORT / _TOTTRANT)*100  ;Relative Transit COR Share
            _TOTEXPT_SREL = (_TOTEXPT / _TOTTRANT)*100  ;Relative Transit Express Share
            _TOTLRTT_SREL = (_TOTLRTT / _TOTTRANT)*100  ;Relative Transit Light-Rail Share
            _TOTCRTT_SREL = (_TOTCRTT / _TOTTRANT)*100  ;Relative Transit Commuter rail Share
            _TOTBRTT_SREL = (_TOTBRTT / _TOTTRANT)*100  ;Relative Transit BRT Share
      endif
      
      if (_TOTLCLT!=0)  
              _TOTLCLW_SREL = (_TOTLCLW / _TOTLCLT)*100  ;Relative Transit Local-Walk Share
              _TOTLCLD_SREL = (_TOTLCLD / _TOTLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _TOTLCLW_SREL = .0001
              _TOTLCLD_SREL = .0001          
      endif
      
      if (_TOTCORT!=0)  
              _TOTCORW_SREL = (_TOTCORW / _TOTCORT)*100  ;Relative Transit COR-Walk Share
              _TOTCORD_SREL = (_TOTCORD / _TOTCORT)*100  ;Relative Transit COR-Drive Share
      else
              _TOTCORW_SREL = .0001
              _TOTCORD_SREL = .0001          
      endif
      if (_TOTEXPT!=0)  
              _TOTEXPW_SREL = (_TOTEXPW / _TOTEXPT)*100  ;Relative Transit EXP-Walk Share
              _TOTEXPD_SREL = (_TOTEXPD / _TOTEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _TOTEXPW_SREL = .0001
              _TOTEXPD_SREL = .0001
      endif 
      if (_TOTLRTT!=0)  
              _TOTLRTW_SREL = (_TOTLRTW / _TOTLRTT)*100  ;Relative Transit LRT-Walk Share
              _TOTLRTD_SREL = (_TOTLRTD / _TOTLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _TOTLRTW_SREL = .0001
              _TOTLRTD_SREL = .0001
      endif      
      if (_TOTCRTT!=0)  
              _TOTCRTW_SREL = (_TOTCRTW / _TOTCRTT)*100  ;Relative Transit CRT-Walk Share
              _TOTCRTD_SREL = (_TOTCRTD / _TOTCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _TOTCRTW_SREL = .0001
              _TOTCRTD_SREL = .0001
      endif
      if (_TOTBRTT!=0)  
              _TOTBRTW_SREL = (_TOTBRTW / _TOTBRTT)*100  ;Relative Transit BRT-Walk Share
              _TOTBRTD_SREL = (_TOTBRTD / _TOTBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _TOTBRTW_SREL = .0001
              _TOTBRTD_SREL = .0001
      endif    
      
      
      ;***********************************************************************************
      ;**********  Begin CSV print (for easy import to Excel)  
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'TripCategory',   'HBWtrip',   'HBWabs',   'HBWrel',
    			          ,   'HBCtrip',   'HBCabs',   'HBCrel',
    			          ,   'HBOtrip',   'HBOabs',   'HBOrel',
    			          ,   'NHBtrip',   'NHBabs',   'NHBrel',
    			          ,   'HBSchtrip', 'HBSchabs', 'HBSchrel',
    			          ,   'TOTtrip',   'TOTabs',   'TOTrel',
    	
    	'\n1) Total Trips', 
    	    _HBWTRIPT/100(10.0), 100, 100,
    			_HBCTRIPT/100(10.0), 100, 100,
    			_HBOTRIPT/100(10.0), 100, 100,
    			_NHBTRIPT/100(10.0), 100, 100,
    			    _HBSTRIPT(10.0), 100, 100,
    			_TOTTRIPT/100(10.0), 100, 100,
    
    	'\n    2) Non-Motorized', 
    	    _HBWNONMO/100(10.0), _HBWNONMO_SABS, _HBWNONMO_SREL,
    			_HBCNONMO/100(10.0), _HBCNONMO_SABS, _HBCNONMO_SREL,
    			_HBONONMO/100(10.0), _HBONONMO_SABS, _HBONONMO_SREL,
    			_NHBNONMO/100(10.0), _NHBNONMO_SABS, _NHBNONMO_SREL,
    			    _HBSNONMO(10.0),  HBS_NONMO_Abs, HBS_NONMO_Rel,
    			_TOTNONMO/100(10.0), _TOTNONMO_SABS, _TOTNONMO_SREL,
    
    	'\n    2) Motorized', 
    	    _HBWMOTOR/100(10.0), _HBWMOTOR_SABS, _HBWMOTOR_SREL,
    			_HBCMOTOR/100(10.0), _HBCMOTOR_SABS, _HBCMOTOR_SREL,
    			_HBOMOTOR/100(10.0), _HBOMOTOR_SABS, _HBOMOTOR_SREL,
    			_NHBMOTOR/100(10.0), _NHBMOTOR_SABS, _NHBMOTOR_SREL,
    			    _HBSMOTOR(10.0),  HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_TOTMOTOR/100(10.0), _TOTMOTOR_SABS, _TOTMOTOR_SREL
    			         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n        3) Auto', 
    	    _HBWAUTOT/100(10.0), _HBWAUTOT_SABS, _HBWAUTOT_SREL,
    			_HBCAUTOT/100(10.0), _HBCAUTOT_SABS, _HBCAUTOT_SREL,
    			_HBOAUTOT/100(10.0), _HBOAUTOT_SABS, _HBOAUTOT_SREL,
    			_NHBAUTOT/100(10.0), _NHBAUTOT_SABS, _NHBAUTOT_SREL,
    			'-', '-', '-',
    			_TOTAUTOT/100(10.0), _TOTAUTOT_SABS, _TOTAUTOT_SREL,
    	'\n            4) Auto 1 pers', 
    	    _HBWAUTO1/100(10.0), _HBWAUTO1_SABS, _HBWAUTO1_SREL,
    			_HBCAUTO1/100(10.0), _HBCAUTO1_SABS, _HBCAUTO1_SREL,
    			_HBOAUTO1/100(10.0), _HBOAUTO1_SABS, _HBOAUTO1_SREL,
    			_NHBAUTO1/100(10.0), _NHBAUTO1_SABS, _NHBAUTO1_SREL,
    			'-', '-', '-',
    			_TOTAUTO1/100(10.0), _TOTAUTO1_SABS, _TOTAUTO1_SREL,
    
    	'\n                    GP use', 
    	    _HBW_DANON/100(10.0), _HBW_DANON_SABS, _HBW_DANON_SREL,
    			_HBC_DANON/100(10.0), _HBC_DANON_SABS, _HBC_DANON_SREL,
    			_HBO_DANON/100(10.0), _HBO_DANON_SABS, _HBO_DANON_SREL,
    			_NHB_DANON/100(10.0), _NHB_DANON_SABS, _NHB_DANON_SREL,
    			'-', '-', '-',
    			_TOT_DANON/100(10.0), _TOT_DANON_SABS, _TOT_DANON_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_DATOL/100(10.0), _HBW_DATOL_SABS, _HBW_DATOL_SREL,
    			_HBC_DATOL/100(10.0), _HBC_DATOL_SABS, _HBC_DATOL_SREL,
    			_HBO_DATOL/100(10.0), _HBO_DATOL_SABS, _HBO_DATOL_SREL,
    			_NHB_DATOL/100(10.0), _NHB_DATOL_SABS, _NHB_DATOL_SREL,
    			'-', '-', '-',
    			_TOT_DATOL/100(10.0), _TOT_DATOL_SABS, _TOT_DATOL_SREL
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Auto 2 pers', 
    	    _HBWAUTO2/100(10.0), _HBWAUTO2_SABS, _HBWAUTO2_SREL,
    			_HBCAUTO2/100(10.0), _HBCAUTO2_SABS, _HBCAUTO2_SREL,
    			_HBOAUTO2/100(10.0), _HBOAUTO2_SABS, _HBOAUTO2_SREL,
    			_NHBAUTO2/100(10.0), _NHBAUTO2_SABS, _NHBAUTO2_SREL,
    			'-', '-', '-',
    			_TOTAUTO2/100(10.0), _TOTAUTO2_SABS, _TOTAUTO2_SREL,
    			         
    	'\n                    GP use', 
    	    _HBW_SR2NON/100(10.0), _HBW_SR2NON_SABS, _HBW_SR2NON_SREL,
    			_HBC_SR2NON/100(10.0), _HBC_SR2NON_SABS, _HBC_SR2NON_SREL,
    			_HBO_SR2NON/100(10.0), _HBO_SR2NON_SABS, _HBO_SR2NON_SREL,
    			_NHB_SR2NON/100(10.0), _NHB_SR2NON_SABS, _NHB_SR2NON_SREL,
    			'-', '-', '-',
    			_TOT_SR2NON/100(10.0), _TOT_SR2NON_SABS, _TOT_SR2NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR2HOV/100(10.0), _HBW_SR2HOV_SABS, _HBW_SR2HOV_SREL,
    			_HBC_SR2HOV/100(10.0), _HBC_SR2HOV_SABS, _HBC_SR2HOV_SREL,
    			_HBO_SR2HOV/100(10.0), _HBO_SR2HOV_SABS, _HBO_SR2HOV_SREL,
    			_NHB_SR2HOV/100(10.0), _NHB_SR2HOV_SABS, _NHB_SR2HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR2HOV/100(10.0), _TOT_SR2HOV_SABS, _TOT_SR2HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR2TOL/100(10.0), _HBW_SR2TOL_SABS, _HBW_SR2TOL_SREL,
    			_HBC_SR2TOL/100(10.0), _HBC_SR2TOL_SABS, _HBC_SR2TOL_SREL,
    			_HBO_SR2TOL/100(10.0), _HBO_SR2TOL_SABS, _HBO_SR2TOL_SREL,
    			_NHB_SR2TOL/100(10.0), _NHB_SR2TOL_SABS, _NHB_SR2TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR2TOL/100(10.0), _TOT_SR2TOL_SABS, _TOT_SR2TOL_SREL
    	
    			
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Auto 3+pers', 
    	    _HBWAUTO3/100(10.0), _HBWAUTO3_SABS, _HBWAUTO3_SREL,
    			_HBCAUTO3/100(10.0), _HBCAUTO3_SABS, _HBCAUTO3_SREL,
    			_HBOAUTO3/100(10.0), _HBOAUTO3_SABS, _HBOAUTO3_SREL,
    			_NHBAUTO3/100(10.0), _NHBAUTO3_SABS, _NHBAUTO3_SREL,	
    			'-', '-', '-',
    			_TOTAUTO3/100(10.0), _TOTAUTO3_SABS, _TOTAUTO3_SREL,	
    			         
    	'\n                    GP use', 
    	    _HBW_SR3NON/100(10.0), _HBW_SR3NON_SABS, _HBW_SR3NON_SREL,
    			_HBC_SR3NON/100(10.0), _HBC_SR3NON_SABS, _HBC_SR3NON_SREL,
    			_HBO_SR3NON/100(10.0), _HBO_SR3NON_SABS, _HBO_SR3NON_SREL,
    			_NHB_SR3NON/100(10.0), _NHB_SR3NON_SABS, _NHB_SR3NON_SREL,
    			'-', '-', '-',
    		  _TOT_SR3NON/100(10.0), _TOT_SR3NON_SABS, _TOT_SR3NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR3HOV/100(10.0), _HBW_SR3HOV_SABS, _HBW_SR3HOV_SREL,
    			_HBC_SR3HOV/100(10.0), _HBC_SR3HOV_SABS, _HBC_SR3HOV_SREL,
    			_HBO_SR3HOV/100(10.0), _HBO_SR3HOV_SABS, _HBO_SR3HOV_SREL,
    			_NHB_SR3HOV/100(10.0), _NHB_SR3HOV_SABS, _NHB_SR3HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR3HOV/100(10.0), _TOT_SR3HOV_SABS, _TOT_SR3HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR3TOL/100(10.0), _HBW_SR3TOL_SABS, _HBW_SR3TOL_SREL,
    			_HBC_SR3TOL/100(10.0), _HBC_SR3TOL_SABS, _HBC_SR3TOL_SREL,
    			_HBO_SR3TOL/100(10.0), _HBO_SR3TOL_SABS, _HBO_SR3TOL_SREL,
    			_NHB_SR3TOL/100(10.0), _NHB_SR3TOL_SABS, _NHB_SR3TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR3TOL/100(10.0), _TOT_SR3TOL_SABS, _TOT_SR3TOL_SREL
    	
          
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) School Trips', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR(10.0), HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_HBSMOTOR(10.0), TOT_HBSMOTOR_Abs, HBS_MOTOR_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_SB(10.0), HBS_SchBus_Abs, HBS_SchBus_Rel,
    			_HBS_SB(10.0), TOT_SchBus_Abs, HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DS(10.0), HBS_DrSelf_Abs, HBS_DrSelf_Rel,
    			_HBS_DS(10.0), TOT_DrSelf_Abs, HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DO(10.0), HBS_DrpOff_Abs, HBS_DrpOff_Rel,
    			_HBS_DO(10.0), TOT_DrpOff_Abs, HBS_DrpOff_Rel,
    			
    	'\n                    K-6', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_PR(10.0), PR_HBS_Abs, PR_HBS_Rel,
    			_HBSMOTOR_PR(10.0), PR_TOT_Abs, PR_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_SB(10.0), PR_HBS_SchBus_Abs, PR_HBS_SchBus_Rel,
    			PR_HBSch_SB(10.0), PR_TOT_SchBus_Abs, PR_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DS(10.0), PR_HBS_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			PR_HBSch_DS(10.0), PR_TOT_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DO(10.0), PR_HBS_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			PR_HBSch_DO(10.0), PR_TOT_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			
    	'\n                    7-12', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_SC(10.0), SC_HBS_Abs, SC_HBS_Rel,
    			_HBSMOTOR_SC(10.0), SC_TOT_Abs, SC_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_SB(10.0), SC_HBS_SchBus_Abs, SC_HBS_SchBus_Rel,
    			SC_HBSch_SB(10.0), SC_TOT_SchBus_Abs, SC_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DS(10.0), SC_HBS_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			SC_HBSch_DS(10.0), SC_TOT_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DO(10.0), SC_HBS_DrpOff_Abs, SC_HBS_DrpOff_Rel,
    			SC_HBSch_DO(10.0), SC_TOT_DrpOff_Abs, SC_HBS_DrpOff_Rel
    	
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n        3) Transit', 
    	    _HBWTRANT/100(10.0), _HBWTRANT_SABS, _HBWTRANT_SREL,
    			_HBCTRANT/100(10.0), _HBCTRANT_SABS, _HBCTRANT_SREL,
    			_HBOTRANT/100(10.0), _HBOTRANT_SABS, _HBOTRANT_SREL,
    			_NHBTRANT/100(10.0), _NHBTRANT_SABS, _NHBTRANT_SREL,
    			'-', '-', '-',
    			_TOTTRANT/100(10.0), _TOTTRANT_SABS, _TOTTRANT_SREL
    	
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Local Bus (LCL)', 
    	    _HBWLCLT/100(10.0), _HBWLCLT_SABS, _HBWLCLT_SREL,
    			_HBCLCLT/100(10.0), _HBCLCLT_SABS, _HBCLCLT_SREL,
    			_HBOLCLT/100(10.0), _HBOLCLT_SABS, _HBOLCLT_SREL,
    			_NHBLCLT/100(10.0), _NHBLCLT_SABS, _NHBLCLT_SREL,
    			'-', '-', '-',
    			_TOTLCLT/100(10.0), _TOTLCLT_SABS, _TOTLCLT_SREL,
    
    	'\n                    LCL Walk', 
    	    _HBWLCLW/100(10.0), _HBWLCLW_SABS, _HBWLCLW_SREL,
    			_HBCLCLW/100(10.0), _HBCLCLW_SABS, _HBCLCLW_SREL,
    			_HBOLCLW/100(10.0), _HBOLCLW_SABS, _HBOLCLW_SREL,
    			_NHBLCLW/100(10.0), _NHBLCLW_SABS, _NHBLCLW_SREL,
    			'-', '-', '-',
    			_TOTLCLW/100(10.0), _TOTLCLW_SABS, _TOTLCLW_SREL,
    
    	'\n                    LCL Drive', 
    	    _HBWLCLD/100(10.0), _HBWLCLD_SABS, _HBWLCLD_SREL,
    			_HBCLCLD/100(10.0), _HBCLCLD_SABS, _HBCLCLD_SREL,
    			_HBOLCLD/100(10.0), _HBOLCLD_SABS, _HBOLCLD_SREL,
    			_NHBLCLD/100(10.0), _NHBLCLD_SABS, _NHBLCLD_SREL,	
    			'-', '-', '-',
    			_TOTLCLD/100(10.0), _TOTLCLD_SABS, _TOTLCLD_SREL
    
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Core Bus (COR)', 
    	    _HBWCORT/100(10.0), _HBWCORT_SABS, _HBWCORT_SREL,
    			_HBCCORT/100(10.0), _HBCCORT_SABS, _HBCCORT_SREL,
    			_HBOCORT/100(10.0), _HBOCORT_SABS, _HBOCORT_SREL,
    			_NHBCORT/100(10.0), _NHBCORT_SABS, _NHBCORT_SREL,
    			'-', '-', '-',
    			_TOTCORT/100(10.0), _TOTCORT_SABS, _TOTCORT_SREL,
    
    	'\n                    COR Walk', 
    	    _HBWCORW/100(10.0), _HBWCORW_SABS, _HBWCORW_SREL,
    			_HBCCORW/100(10.0), _HBCCORW_SABS, _HBCCORW_SREL,
    			_HBOCORW/100(10.0), _HBOCORW_SABS, _HBOCORW_SREL,
    			_NHBCORW/100(10.0), _NHBCORW_SABS, _NHBCORW_SREL,
    			'-', '-', '-',
    			_TOTCORW/100(10.0), _TOTCORW_SABS, _TOTCORW_SREL,
    
    	'\n                    COR Drive', 
    	    _HBWCORD/100(10.0), _HBWCORD_SABS, _HBWCORD_SREL,
    			_HBCCORD/100(10.0), _HBCCORD_SABS, _HBCCORD_SREL,
    			_HBOCORD/100(10.0), _HBOCORD_SABS, _HBOCORD_SREL,
    			_NHBCORD/100(10.0), _NHBCORD_SABS, _NHBCORD_SREL,	
    			'-', '-', '-',
    			_TOTCORD/100(10.0), _TOTCORD_SABS, _TOTCORD_SREL
    			
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Bus-Rapid Transit (BRT)',
    	    _HBWBRTT/100(10.0), _HBWBRTT_SABS, _HBWBRTT_SREL,
    			_HBCBRTT/100(10.0), _HBCBRTT_SABS, _HBCBRTT_SREL,
    			_HBOBRTT/100(10.0), _HBOBRTT_SABS, _HBOBRTT_SREL,
    			_NHBBRTT/100(10.0), _NHBBRTT_SABS, _NHBBRTT_SREL,
    			'-', '-', '-',
    			_TOTBRTT/100(10.0), _TOTBRTT_SABS, _TOTBRTT_SREL,
    
    	'\n                    BRT Walk', 
    	    _HBWBRTW/100(10.0), _HBWBRTW_SABS, _HBWBRTW_SREL,
    			_HBCBRTW/100(10.0), _HBCBRTW_SABS, _HBCBRTW_SREL,
    			_HBOBRTW/100(10.0), _HBOBRTW_SABS, _HBOBRTW_SREL,
    			_NHBBRTW/100(10.0), _NHBBRTW_SABS, _NHBBRTW_SREL,
    			'-', '-', '-',
    			_TOTBRTW/100(10.0), _TOTBRTW_SABS, _TOTBRTW_SREL,
    
    	'\n                    BRT Drive', 
    	    _HBWBRTD/100(10.0), _HBWBRTD_SABS, _HBWBRTD_SREL,
    			_HBCBRTD/100(10.0), _HBCBRTD_SABS, _HBCBRTD_SREL,
    			_HBOBRTD/100(10.0), _HBOBRTD_SABS, _HBOBRTD_SREL,
    			_NHBBRTD/100(10.0), _NHBBRTD_SABS, _NHBBRTD_SREL,	
    			'-', '-', '-',
    			_TOTBRTD/100(10.0), _TOTBRTD_SABS, _TOTBRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Express Bus (EXP)', 
    	    _HBWEXPT/100(10.0), _HBWEXPT_SABS, _HBWEXPT_SREL,
    			_HBCEXPT/100(10.0), _HBCEXPT_SABS, _HBCEXPT_SREL,
    			_HBOEXPT/100(10.0), _HBOEXPT_SABS, _HBOEXPT_SREL,
    			_NHBEXPT/100(10.0), _NHBEXPT_SABS, _NHBEXPT_SREL,
    			'-', '-', '-',
    			_TOTEXPT/100(10.0), _TOTEXPT_SABS, _TOTEXPT_SREL,
    
    	'\n                    EXP Walk', 
    	    _HBWEXPW/100(10.0), _HBWEXPW_SABS, _HBWEXPW_SREL,
    			_HBCEXPW/100(10.0), _HBCEXPW_SABS, _HBCEXPW_SREL,
    			_HBOEXPW/100(10.0), _HBOEXPW_SABS, _HBOEXPW_SREL,
    			_NHBEXPW/100(10.0), _NHBEXPW_SABS, _NHBEXPW_SREL,
    			'-', '-', '-',
    			_TOTEXPW/100(10.0), _TOTEXPW_SABS, _TOTEXPW_SREL,
    
    	'\n                    EXP Drive', 
    	    _HBWEXPD/100(10.0), _HBWEXPD_SABS, _HBWEXPD_SREL,
    			_HBCEXPD/100(10.0), _HBCEXPD_SABS, _HBCEXPD_SREL,
    			_HBOEXPD/100(10.0), _HBOEXPD_SABS, _HBOEXPD_SREL,
    			_NHBEXPD/100(10.0), _NHBEXPD_SABS, _NHBEXPD_SREL,
    			'-', '-', '-',
    			_TOTEXPD/100(10.0), _TOTEXPD_SABS, _TOTEXPD_SREL
    			
    		         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Light-Rail Transit (LRT)', 
    	    _HBWLRTT/100(10.0), _HBWLRTT_SABS, _HBWLRTT_SREL,
    			_HBCLRTT/100(10.0), _HBCLRTT_SABS, _HBCLRTT_SREL,
    			_HBOLRTT/100(10.0), _HBOLRTT_SABS, _HBOLRTT_SREL,
    			_NHBLRTT/100(10.0), _NHBLRTT_SABS, _NHBLRTT_SREL,
    			'-', '-', '-',
    			_TOTLRTT/100(10.0), _TOTLRTT_SABS, _TOTLRTT_SREL,
    
    	'\n                    LRT Walk', 
    	    _HBWLRTW/100(10.0), _HBWLRTW_SABS, _HBWLRTW_SREL,
    			_HBCLRTW/100(10.0), _HBCLRTW_SABS, _HBCLRTW_SREL,
    			_HBOLRTW/100(10.0), _HBOLRTW_SABS, _HBOLRTW_SREL,
    			_NHBLRTW/100(10.0), _NHBLRTW_SABS, _NHBLRTW_SREL,
    			'-', '-', '-',
    			_TOTLRTW/100(10.0), _TOTLRTW_SABS, _TOTLRTW_SREL,
    
    	'\n                    LRT Drive', 
    	    _HBWLRTD/100(10.0), _HBWLRTD_SABS, _HBWLRTD_SREL,
    			_HBCLRTD/100(10.0), _HBCLRTD_SABS, _HBCLRTD_SREL,
    			_HBOLRTD/100(10.0), _HBOLRTD_SABS, _HBOLRTD_SREL,
    			_NHBLRTD/100(10.0), _NHBLRTD_SABS, _NHBLRTD_SREL,
    			'-', '-', '-',
    			_TOTLRTD/100(10.0), _TOTLRTD_SABS, _TOTLRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n            4) Commuter-Rail Transit (CRT)', 
    	    _HBWCRTT/100(10.0), _HBWCRTT_SABS, _HBWCRTT_SREL,
    			_HBCCRTT/100(10.0), _HBCCRTT_SABS, _HBCCRTT_SREL,
    			_HBOCRTT/100(10.0), _HBOCRTT_SABS, _HBOCRTT_SREL,
    			_NHBCRTT/100(10.0), _NHBCRTT_SABS, _NHBCRTT_SREL,
    			'-', '-', '-',
    			_TOTCRTT/100(10.0), _TOTCRTT_SABS, _TOTCRTT_SREL,
    
    	'\n                    CRT Walk', 
    	    _HBWCRTW/100(10.0), _HBWCRTW_SABS, _HBWCRTW_SREL,
    			_HBCCRTW/100(10.0), _HBCCRTW_SABS, _HBCCRTW_SREL,
    			_HBOCRTW/100(10.0), _HBOCRTW_SABS, _HBOCRTW_SREL,
    			_NHBCRTW/100(10.0), _NHBCRTW_SABS, _NHBCRTW_SREL,
    			'-', '-', '-',
    			_TOTCRTW/100(10.0), _TOTCRTW_SABS, _TOTCRTW_SREL,
    
    	'\n                    CRT Drive', 
    	    _HBWCRTD/100(10.0), _HBWCRTD_SABS, _HBWCRTD_SREL,
    			_HBCCRTD/100(10.0), _HBCCRTD_SABS, _HBCCRTD_SREL,
    			_HBOCRTD/100(10.0), _HBOCRTD_SABS, _HBOCRTD_SREL,
    			_NHBCRTD/100(10.0), _NHBCRTD_SABS, _NHBCRTD_SREL,	
    			'-', '-', '-',
    			_TOTCRTD/100(10.0), _TOTCRTD_SABS, _TOTCRTD_SREL,	
      '\n  '
      
            
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Ok.csv' LIST=
    	'\n   Run ID (RID card): @RID@', 
    	'\n   Socio-Economic year modeled:         @demographicyear@', 
    	'\n   Network infrastructure year modeled: @networkyear@',
    	'\n   Period the results apply to:  Off-Peak Period',
    	'\n   Shares\@RID@_RegionShares_Ok.csv', 
    	'\n   For this run Mode Choice was run in its regular form (i.e. not bypassed with approximation).',
    	'\n   NOTE:  Indentations correspond with each level in the nested Logit choice model.'
    
    endif
    
    ENDRUN
    
;Cluster: end of group distributed to processor 3
EndDistributeMULTISTEP




;Cluster: distrubute MATRIX call onto processor 4
DistributeMultiStep Alias='Shares_Proc4'

    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - daily'
      FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
      FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
      FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
      FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx'
      FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
      FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
     
      FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_pkok_auto_managedlanes.mtx'       ; HBW trip table 
            MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_pkok_auto_managedlanes.mtx'       ; HBC trip table 
            MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_pkok_auto_managedlanes.mtx'       ; HBO trip table  
            MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_pkok_auto_managedlanes.mtx'       ; NHB trip table
      
      ZONEMSG = 10
    
    ;******************************** HBW summary values
    JLOOP 
      if (I=1-@UsedZones@  |  J=1-@UsedZones@)
        _HBWMOTOR = _HBWMOTOR + mi.01.motor[j] 
        _HBWNONMO = _HBWNONMO + mi.01.nonmotor[j]
        _HBWTRANT = _HBWTRANT + mi.01.transit[j]
        _HBWAUTOT = _HBWAUTOT + mi.01.auto[j]
        _HBWAUTO1 = _HBWAUTO1 + mi.01.DA[j]
        _HBWAUTO2 = _HBWAUTO2 + mi.01.SR2[j]
        _HBWAUTO3 = _HBWAUTO3 + mi.01.SR3p[j]  
        _HBWLCLW  = _HBWLCLW  + mi.01.wLCL[j]
        _HBWLCLD  = _HBWLCLD  + mi.01.dLCL[j]
        _HBWCORW  = _HBWCORW  + mi.01.wCOR[j]
        _HBWCORD  = _HBWCORD  + mi.01.dCOR[j]
        _HBWEXPW  = _HBWEXPW  + mi.01.wEXP[j]
        _HBWEXPD  = _HBWEXPD  + mi.01.dEXP[j]
        _HBWLRTW  = _HBWLRTW  + mi.01.wLRT[j]
        _HBWLRTD  = _HBWLRTD  + mi.01.dLRT[j]
        _HBWCRTW  = _HBWCRTW  + mi.01.wCRT[j]
        _HBWCRTD  = _HBWCRTD  + mi.01.dCRT[j]
        _HBWTRANW = _HBWTRANW + mi.01.wTRN[j] ;sum of walk access to transit
        _HBWTRAND = _HBWTRAND + mi.01.dTRN[j] ;sum of drive access to transit  
    
        _HBWBRTW  = _HBWBRTW  + mi.01.wBRT[j]
        _HBWBRTD  = _HBWBRTD  + mi.01.dBRT[j]
    
        _HBW_DANON  = _HBW_DANON  + mi.07.alone_non[j] 
        _HBW_DATOL  = _HBW_DATOL  + mi.07.alone_toll[j]
        _HBW_SR2NON = _HBW_SR2NON + mi.07.sr2_non[j]
        _HBW_SR2TOL = _HBW_SR2TOL + mi.07.sr2_toll[j]  
        _HBW_SR2HOV = _HBW_SR2HOV + mi.07.sr2_hov[j]
        _HBW_SR3NON = _HBW_SR3NON + mi.07.sr3_non[j]
        _HBW_SR3TOL = _HBW_SR3TOL + mi.07.sr3_toll[j]
        _HBW_SR3HOV = _HBW_SR3HOV + mi.07.sr3_hov[j]
    
        
        _HBCMOTOR = _HBCMOTOR + mi.02.motor[j] 
        _HBCNONMO = _HBCNONMO + mi.02.nonmotor[j]
        _HBCTRANT = _HBCTRANT + mi.02.transit[j]
        _HBCAUTOT = _HBCAUTOT + mi.02.auto[j]
        _HBCAUTO1 = _HBCAUTO1 + mi.02.DA[j]
        _HBCAUTO2 = _HBCAUTO2 + mi.02.SR2[j]
        _HBCAUTO3 = _HBCAUTO3 + mi.02.SR3p[j]  
        _HBCLCLW  = _HBCLCLW  + mi.02.wLCL[j]
        _HBCLCLD  = _HBCLCLD  + mi.02.dLCL[j]
        _HBCCORW  = _HBCCORW  + mi.02.wCOR[j]
        _HBCCORD  = _HBCCORD  + mi.02.dCOR[j]
        _HBCEXPW  = _HBCEXPW  + mi.02.wEXP[j]
        _HBCEXPD  = _HBCEXPD  + mi.02.dEXP[j]
        _HBCLRTW  = _HBCLRTW  + mi.02.wLRT[j]
        _HBCLRTD  = _HBCLRTD  + mi.02.dLRT[j]
        _HBCCRTW  = _HBCCRTW  + mi.02.wCRT[j]
        _HBCCRTD  = _HBCCRTD  + mi.02.dCRT[j]
        _HBCTRANW = _HBCTRANW + mi.02.wTRN[j];sum of walk access to transit
        _HBCTRAND = _HBCTRAND + mi.02.dTRN[j] ;sum of drive access to transit  
    
        _HBCBRTW  = _HBCBRTW  + mi.02.wBRT[j]
        _HBCBRTD  = _HBCBRTD  + mi.02.dBRT[j]
    
        _HBC_DANON  = _HBC_DANON  + mi.08.alone_non[j] 
        _HBC_SR2NON = _HBC_SR2NON + mi.08.sr2_non[j]
        _HBC_SR3NON = _HBC_SR3NON + mi.08.sr3_non[j]
        _HBC_SR2HOV = _HBC_SR2HOV + mi.08.sr2_hov[j]
        _HBC_SR3HOV = _HBC_SR3HOV + mi.08.sr3_hov[j]
        _HBC_DATOL  = _HBC_DATOL  + mi.08.alone_toll[j]
        _HBC_SR2TOL = _HBC_SR2TOL + mi.08.sr2_toll[j]    
        _HBC_SR3TOL = _HBC_SR3TOL + mi.08.sr3_toll[j]
        
                
        _HBOMOTOR = _HBOMOTOR + mi.03.motor[j] 
        _HBONONMO = _HBONONMO + mi.03.nonmotor[j]
        _HBOTRANT = _HBOTRANT + mi.03.transit[j]
        _HBOAUTOT = _HBOAUTOT + mi.03.auto[j]
        _HBOAUTO1 = _HBOAUTO1 + mi.03.DA[j]
        _HBOAUTO2 = _HBOAUTO2 + mi.03.SR2[j]
        _HBOAUTO3 = _HBOAUTO3 + mi.03.SR3p[j]    
        _HBOLCLW  = _HBOLCLW  + mi.03.wLCL[j]
        _HBOLCLD  = _HBOLCLD  + mi.03.dLCL[j]
        _HBOCORW  = _HBOCORW  + mi.03.wCOR[j]
        _HBOCORD  = _HBOCORD  + mi.03.dCOR[j]
        _HBOEXPW  = _HBOEXPW  + mi.03.wEXP[j]
        _HBOEXPD  = _HBOEXPD  + mi.03.dEXP[j]
        _HBOLRTW  = _HBOLRTW  + mi.03.wLRT[j]
        _HBOLRTD  = _HBOLRTD  + mi.03.dLRT[j]
        _HBOCRTW  = _HBOCRTW  + mi.03.wCRT[j]
        _HBOCRTD  = _HBOCRTD  + mi.03.dCRT[j]
        _HBOTRANW = _HBOTRANW + mi.03.wTRN[j] ;sum of walk access to transit
        _HBOTRAND = _HBOTRAND + mi.03.dTRN[j] ;sum of drive access to transit     
    
        _HBOBRTW  = _HBOBRTW  + mi.03.wBRT[j]
        _HBOBRTD  = _HBOBRTD  + mi.03.dBRT[j]
    
        _HBO_DANON  = _HBO_DANON  + mi.09.alone_non[j] 
        _HBO_SR2NON = _HBO_SR2NON + mi.09.sr2_non[j]
        _HBO_SR3NON = _HBO_SR3NON + mi.09.sr3_non[j]
        _HBO_SR2HOV = _HBO_SR2HOV + mi.09.sr2_hov[j]
        _HBO_SR3HOV = _HBO_SR3HOV + mi.09.sr3_hov[j]
        _HBO_DATOL  = _HBO_DATOL  + mi.09.alone_toll[j]
        _HBO_SR2TOL = _HBO_SR2TOL + mi.09.sr2_toll[j]
        _HBO_SR3TOL = _HBO_SR3TOL + mi.09.sr3_toll[j]
        
    
        _NHBMOTOR = _NHBMOTOR + mi.04.motor[j] 
        _NHBNONMO = _NHBNONMO + mi.04.nonmotor[j]
        _NHBTRANT = _NHBTRANT + mi.04.transit[j]
        _NHBAUTOT = _NHBAUTOT + mi.04.auto[j]
        _NHBAUTO1 = _NHBAUTO1 + mi.04.DA[j]
        _NHBAUTO2 = _NHBAUTO2 + mi.04.SR2[j]
        _NHBAUTO3 = _NHBAUTO3 + mi.04.SR3p[j]  
        _NHBLCLW  = _NHBLCLW  + mi.04.wLCL[j]
        _NHBLCLD  = _NHBLCLD  + mi.04.dLCL[j]
        _NHBCORW  = _NHBCORW  + mi.04.wCOR[j]
        _NHBCORD  = _NHBCORD  + mi.04.dCOR[j]
        _NHBEXPW  = _NHBEXPW  + mi.04.wEXP[j]
        _NHBEXPD  = _NHBEXPD  + mi.04.dEXP[j]
        _NHBLRTW  = _NHBLRTW  + mi.04.wLRT[j]
        _NHBLRTD  = _NHBLRTD  + mi.04.dLRT[j]
        _NHBCRTW  = _NHBCRTW  + mi.04.wCRT[j]
        _NHBCRTD  = _NHBCRTD  + mi.04.dCRT[j]
        _NHBTRANW = _NHBTRANW + mi.04.wTRN[j] ;sum of walk access to transit
        _NHBTRAND = _NHBTRAND + mi.04.dTRN[j] ;sum of drive access to transit   
    
        _NHBBRTW  = _NHBBRTW  + mi.04.wBRT[j]
        _NHBBRTD  = _NHBBRTD  + mi.04.dBRT[j]
        
        _NHB_DANON  = _NHB_DANON  + mi.10.alone_non[j] 
        _NHB_SR2NON = _NHB_SR2NON + mi.10.sr2_non[j]
        _NHB_SR3NON = _NHB_SR3NON + mi.10.sr3_non[j]
        _NHB_SR2HOV = _NHB_SR2HOV + mi.10.sr2_hov[j]
        _NHB_SR3HOV = _NHB_SR3HOV + mi.10.sr3_hov[j]
        _NHB_DATOL  = _NHB_DATOL  + mi.10.alone_toll[j]
        _NHB_SR2TOL = _NHB_SR2TOL + mi.10.sr2_toll[j]    
        _NHB_SR3TOL = _NHB_SR3TOL + mi.10.sr3_toll[j]
        
        
        PR_HBSch_SB = PR_HBSch_SB + mi.05.SchoolBus[j]
        PR_HBSch_DS = PR_HBSch_DS + mi.05.DriveSelf[j]
        PR_HBSch_DO = PR_HBSch_DO + mi.05.DropOff[j]
        PR_HBSch_Wk = PR_HBSch_Wk + mi.05.Walk[j]
        PR_HBSch_Bk = PR_HBSch_Bk + mi.05.Bike[j]
        
        SC_HBSch_SB = SC_HBSch_SB + mi.06.SchoolBus[j]
        SC_HBSch_DS = SC_HBSch_DS + mi.06.DriveSelf[j]
        SC_HBSch_DO = SC_HBSch_DO + mi.06.DropOff[j]
        SC_HBSch_Wk = SC_HBSch_Wk + mi.06.Walk[j]
        SC_HBSch_Bk = SC_HBSch_Bk + mi.06.Bike[j]
        
      endif
    ENDJLOOP
    
    
    ;************** Once i-loop is finished, create summary
    if (i==zones)
        ;HBSch totals
        _HBS_SB = PR_HBSch_SB +
                  SC_HBSch_SB
        
        _HBS_DS = PR_HBSch_DS +
                  SC_HBSch_DS
        
        _HBS_DO = PR_HBSch_DO +
                  SC_HBSch_DO
        
        _HBSMOTOR_PR = PR_HBSch_SB +
                       PR_HBSch_DS +
                       PR_HBSch_DO
        
        _HBSMOTOR_SC = SC_HBSch_SB +
                       SC_HBSch_DS +
                       SC_HBSch_DO
        
        _HBSMOTOR = _HBSMOTOR_PR +
                    _HBSMOTOR_SC
        
        _HBSNONMO = PR_HBSch_Wk +
                    PR_HBSch_Bk +
                    SC_HBSch_Wk +
                    SC_HBSch_Bk
        
        _HBSTRIPT = _HBSMOTOR + _HBSNONMO
        
      ;Grand total trips is Motor + Non-Motor
      _HBWTRIPT = _HBWMOTOR + _HBWNONMO 
      _HBCTRIPT = _HBCMOTOR + _HBCNONMO 
      _HBOTRIPT = _HBOMOTOR + _HBONONMO 
      _NHBTRIPT = _NHBMOTOR + _NHBNONMO 
    
      ;Total transit is sum of walk + drive
      _HBWLCLT = _HBWLCLW + _HBWLCLD
      _HBWCORT = _HBWCORW + _HBWCORD
      _HBWEXPT = _HBWEXPW + _HBWEXPD
      _HBWLRTT = _HBWLRTW + _HBWLRTD
      _HBWCRTT = _HBWCRTW + _HBWCRTD
      _HBWBRTT = _HBWBRTW + _HBWBRTD
    
      _HBCLCLT = _HBCLCLW + _HBCLCLD
      _HBCCORT = _HBCCORW + _HBCCORD
      _HBCEXPT = _HBCEXPW + _HBCEXPD
      _HBCLRTT = _HBCLRTW + _HBCLRTD
      _HBCCRTT = _HBCCRTW + _HBCCRTD
      _HBCBRTT = _HBCBRTW + _HBCBRTD
    
      _HBOLCLT = _HBOLCLW + _HBOLCLD
      _HBOCORT = _HBOCORW + _HBOCORD
      _HBOEXPT = _HBOEXPW + _HBOEXPD
      _HBOLRTT = _HBOLRTW + _HBOLRTD
      _HBOCRTT = _HBOCRTW + _HBOCRTD
      _HBOBRTT = _HBOBRTW + _HBOBRTD
    
      _NHBLCLT = _NHBLCLW + _NHBLCLD
      _NHBCORT = _NHBCORW + _NHBCORD
      _NHBEXPT = _NHBEXPW + _NHBEXPD
      _NHBLRTT = _NHBLRTW + _NHBLRTD
      _NHBCRTT = _NHBCRTW + _NHBCRTD
      _NHBBRTT = _NHBBRTW + _NHBBRTD
    
      ;Total the purposes
      _TOTTRIPT = _HBWTRIPT + 
                  _HBCTRIPT + 
                  _HBOTRIPT + 
                  _NHBTRIPT + 
                  _HBSTRIPT*100                         ;added HBSch
      
        _TOTNONMO = _HBWNONMO + 
                    _HBCNONMO + 
                    _HBONONMO + 
                    _NHBNONMO + 
                    _HBSNONMO*100                       ;added HBSch
        
        _TOTMOTOR = _HBWMOTOR + 
                    _HBCMOTOR + 
                    _HBOMOTOR + 
                    _NHBMOTOR + 
                    _HBSMOTOR*100                       ;added HBSch
          
          _TOTAUTOT = _HBWAUTOT + 
                      _HBCAUTOT + 
                      _HBOAUTOT + 
                      _NHBAUTOT + 
                      _HBSMOTOR*100                       ;added HBSch
          
            _TOTAUTO1 = _HBWAUTO1 + _HBCAUTO1 + _HBOAUTO1 + _NHBAUTO1
              _TOT_DANON = _HBW_DANON + _HBC_DANON + _HBO_DANON + _NHB_DANON
              _TOT_DATOL = _HBW_DATOL + _HBC_DATOL + _HBO_DATOL + _NHB_DATOL
            _TOTAUTO2 = _HBWAUTO2 + _HBCAUTO2 + _HBOAUTO2 + _NHBAUTO2
              _TOT_SR2NON = _HBW_SR2NON + _HBC_SR2NON + _HBO_SR2NON + _NHB_SR2NON
              _TOT_SR2TOL = _HBW_SR2TOL + _HBC_SR2TOL + _HBO_SR2TOL + _NHB_SR2TOL
              _TOT_SR2HOV = _HBW_SR2HOV + _HBC_SR2HOV + _HBO_SR2HOV + _NHB_SR2HOV
            _TOTAUTO3 = _HBWAUTO3 + _HBCAUTO3 + _HBOAUTO3 + _NHBAUTO3
              _TOT_SR3NON = _HBW_SR3NON + _HBC_SR3NON + _HBO_SR3NON + _NHB_SR3NON
              _TOT_SR3TOL = _HBW_SR3TOL + _HBC_SR3TOL + _HBO_SR3TOL + _NHB_SR3TOL
              _TOT_SR3HOV = _HBW_SR3HOV + _HBC_SR3HOV + _HBO_SR3HOV + _NHB_SR3HOV
                    
          _TOTTRANT = _HBWTRANT + _HBCTRANT + _HBOTRANT + _NHBTRANT
            _TOTLCLT = _HBWLCLT + _HBCLCLT + _HBOLCLT + _NHBLCLT
              _TOTLCLW  = _HBWLCLW  + _HBCLCLW  + _HBOLCLW  + _NHBLCLW
              _TOTLCLD  = _HBWLCLD  + _HBCLCLD  + _HBOLCLD  + _NHBLCLD
            _TOTCORT = _HBWCORT + _HBCCORT + _HBOCORT + _NHBCORT
              _TOTCORW  = _HBWCORW  + _HBCCORW  + _HBOCORW  + _NHBCORW
              _TOTCORD  = _HBWCORD  + _HBCCORD  + _HBOCORD  + _NHBCORD
            _TOTEXPT = _HBWEXPT + _HBCEXPT + _HBOEXPT + _NHBEXPT
              _TOTEXPW  = _HBWEXPW  + _HBCEXPW  + _HBOEXPW  + _NHBEXPW
              _TOTEXPD  = _HBWEXPD  + _HBCEXPD  + _HBOEXPD  + _NHBEXPD
            _TOTLRTT = _HBWLRTT + _HBCLRTT + _HBOLRTT + _NHBLRTT
              _TOTLRTW  = _HBWLRTW  + _HBCLRTW  + _HBOLRTW  + _NHBLRTW
              _TOTLRTD  = _HBWLRTD  + _HBCLRTD  + _HBOLRTD  + _NHBLRTD
            _TOTCRTT = _HBWCRTT + _HBCCRTT + _HBOCRTT + _NHBCRTT
              _TOTCRTW  = _HBWCRTW  + _HBCCRTW  + _HBOCRTW  + _NHBCRTW
              _TOTCRTD  = _HBWCRTD  + _HBCCRTD  + _HBOCRTD  + _NHBCRTD    
            _TOTBRTT = _HBWBRTT + _HBCBRTT + _HBOBRTT + _NHBBRTT
              _TOTBRTW  = _HBWBRTW  + _HBCBRTW  + _HBOBRTW  + _NHBBRTW
              _TOTBRTD  = _HBWBRTD  + _HBCBRTD  + _HBOBRTD  + _NHBBRTD 
    
        
      ;*********************** Note:  Purpose blocks are identical but for HBW, HBC, etc; so updates can be easily made by changing these prefixes.
      ;*********************** Compute HBW absolute share info
      if (_HBWTRIPT!=0)  
        _HBWNONMO_SABS = (_HBWNONMO / _HBWTRIPT)*100  ;Absolute Non-Motorized Share
        _HBWMOTOR_SABS = (_HBWMOTOR / _HBWTRIPT)*100  ;Absolute Motorized Share
          _HBWAUTOT_SABS = (_HBWAUTOT / _HBWTRIPT)*100  ;Absolute Auto Share
            _HBWAUTO1_SABS = (_HBWAUTO1 / _HBWTRIPT)*100  ;Absolute Drive-Alone Share
              _HBW_DANON_SABS = (_HBW_DANON / _HBWTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBW_DATOL_SABS = (_HBW_DATOL / _HBWTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBWAUTO2_SABS = (_HBWAUTO2 / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBW_SR2NON_SABS = (_HBW_SR2NON / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBW_SR2TOL_SABS = (_HBW_SR2TOL / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBW_SR2HOV_SABS = (_HBW_SR2HOV / _HBWTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBWAUTO3_SABS = (_HBWAUTO3 / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBW_SR3NON_SABS = (_HBW_SR3NON / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBW_SR3TOL_SABS = (_HBW_SR3TOL / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBW_SR3HOV_SABS = (_HBW_SR3HOV / _HBWTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBWTRANT_SABS = (_HBWTRANT / _HBWTRIPT)*100  ;Absolute Transit Share
            _HBWLCLT_SABS = (_HBWLCLT / _HBWTRIPT)*100  ;Absolute Transit Local Share
              _HBWLCLW_SABS = (_HBWLCLW / _HBWTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBWLCLD_SABS = (_HBWLCLD / _HBWTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBWCORT_SABS = (_HBWCORT / _HBWTRIPT)*100  ;Absolute Transit COR Share
              _HBWCORW_SABS = (_HBWCORW / _HBWTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBWCORD_SABS = (_HBWCORD / _HBWTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBWEXPT_SABS = (_HBWEXPT / _HBWTRIPT)*100  ;Absolute Transit Express Share
              _HBWEXPW_SABS = (_HBWEXPW / _HBWTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBWEXPD_SABS = (_HBWEXPD / _HBWTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBWLRTT_SABS = (_HBWLRTT / _HBWTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBWLRTW_SABS = (_HBWLRTW / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBWLRTD_SABS = (_HBWLRTD / _HBWTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBWCRTT_SABS = (_HBWCRTT / _HBWTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBWCRTW_SABS = (_HBWCRTW / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBWCRTD_SABS = (_HBWCRTD / _HBWTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBWBRTT_SABS = (_HBWBRTT / _HBWTRIPT)*100  ;Absolute Transit BRT Share
              _HBWBRTW_SABS = (_HBWBRTW / _HBWTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBWBRTD_SABS = (_HBWBRTD / _HBWTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBW relative share info
      if (_HBWTRIPT!=0)  
        _HBWMOTOR_SREL = (_HBWMOTOR / _HBWTRIPT)*100  ;Relative Motorized Share
        _HBWNONMO_SREL = (_HBWNONMO / _HBWTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBWMOTOR!=0)  
          _HBWAUTOT_SREL = (_HBWAUTOT / _HBWMOTOR)*100  ;Relative Auto Share
          _HBWTRANT_SREL = (_HBWTRANT / _HBWMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBWAUTOT!=0)  
            _HBWAUTO1_SREL = (_HBWAUTO1 / _HBWAUTOT)*100  ;Relative Drive-Alone Share
            _HBWAUTO2_SREL = (_HBWAUTO2 / _HBWAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBWAUTO3_SREL = (_HBWAUTO3 / _HBWAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBWAUTO1!=0)  
              _HBW_DANON_SREL = (_HBW_DANON / _HBWAUTO1)*100  ;Relative DA non-tol
              _HBW_DATOL_SREL = (_HBW_DATOL / _HBWAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBWAUTO2!=0)  
              _HBW_SR2NON_SREL = (_HBW_SR2NON / _HBWAUTO2)*100  
              _HBW_SR2TOL_SREL = (_HBW_SR2TOL / _HBWAUTO2)*100  
              _HBW_SR2HOV_SREL = (_HBW_SR2HOV / _HBWAUTO2)*100  
      endif    
      if (_HBWAUTO3!=0)  
              _HBW_SR3NON_SREL = (_HBW_SR3NON / _HBWAUTO3)*100  
              _HBW_SR3TOL_SREL = (_HBW_SR3TOL / _HBWAUTO3)*100  
              _HBW_SR3HOV_SREL = (_HBW_SR3HOV / _HBWAUTO3)*100  
      endif   
      if (_HBWTRANT!=0)  
            _HBWLCLT_SREL = (_HBWLCLT / _HBWTRANT)*100  ;Relative Transit Local Share
            _HBWCORT_SREL = (_HBWCORT / _HBWTRANT)*100  ;Relative Transit COR Share
            _HBWEXPT_SREL = (_HBWEXPT / _HBWTRANT)*100  ;Relative Transit Express Share
            _HBWLRTT_SREL = (_HBWLRTT / _HBWTRANT)*100  ;Relative Transit Light-Rail Share
            _HBWCRTT_SREL = (_HBWCRTT / _HBWTRANT)*100  ;Relative Transit Commuter rail Share
            _HBWBRTT_SREL = (_HBWBRTT / _HBWTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBWLCLT!=0)  
              _HBWLCLW_SREL = (_HBWLCLW / _HBWLCLT)*100  ;Relative Transit Local-Walk Share
              _HBWLCLD_SREL = (_HBWLCLD / _HBWLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBWLCLW_SREL = .0001
              _HBWLCLD_SREL = .0001          
      endif
      if (_HBWCORT!=0)  
              _HBWCORW_SREL = (_HBWCORW / _HBWCORT)*100  ;Relative Transit COR-Walk Share
              _HBWCORD_SREL = (_HBWCORD / _HBWCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBWCORW_SREL = .0001
              _HBWCORD_SREL = .0001          
      endif
      if (_HBWEXPT!=0)  
              _HBWEXPW_SREL = (_HBWEXPW / _HBWEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBWEXPD_SREL = (_HBWEXPD / _HBWEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBWEXPW_SREL = .0001
              _HBWEXPD_SREL = .0001
      endif 
      if (_HBWLRTT!=0)  
              _HBWLRTW_SREL = (_HBWLRTW / _HBWLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBWLRTD_SREL = (_HBWLRTD / _HBWLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBWLRTW_SREL = .0001
              _HBWLRTD_SREL = .0001
      endif      
      if (_HBWCRTT!=0)  
              _HBWCRTW_SREL = (_HBWCRTW / _HBWCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBWCRTD_SREL = (_HBWCRTD / _HBWCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBWCRTW_SREL = .0001
              _HBWCRTD_SREL = .0001
      endif
      if (_HBWBRTT!=0)  
              _HBWBRTW_SREL = (_HBWBRTW / _HBWBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBWBRTD_SREL = (_HBWBRTD / _HBWBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBWBRTW_SREL = .0001
              _HBWBRTD_SREL = .0001
      endif
    
      
      ;*********************** Compute HBC absolute share info
      if (_HBCTRIPT!=0)  
        _HBCNONMO_SABS = (_HBCNONMO / _HBCTRIPT)*100  ;Absolute Non-Motorized Share
        _HBCMOTOR_SABS = (_HBCMOTOR / _HBCTRIPT)*100  ;Absolute Motorized Share
          _HBCAUTOT_SABS = (_HBCAUTOT / _HBCTRIPT)*100  ;Absolute Auto Share
            _HBCAUTO1_SABS = (_HBCAUTO1 / _HBCTRIPT)*100  ;Absolute Drive-Alone Share
              _HBC_DANON_SABS = (_HBC_DANON / _HBCTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBC_DATOL_SABS = (_HBC_DATOL / _HBCTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBCAUTO2_SABS = (_HBCAUTO2 / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBC_SR2NON_SABS = (_HBC_SR2NON / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBC_SR2TOL_SABS = (_HBC_SR2TOL / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBC_SR2HOV_SABS = (_HBC_SR2HOV / _HBCTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBCAUTO3_SABS = (_HBCAUTO3 / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBC_SR3NON_SABS = (_HBC_SR3NON / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBC_SR3TOL_SABS = (_HBC_SR3TOL / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBC_SR3HOV_SABS = (_HBC_SR3HOV / _HBCTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBCTRANT_SABS = (_HBCTRANT / _HBCTRIPT)*100  ;Absolute Transit Share
            _HBCLCLT_SABS = (_HBCLCLT / _HBCTRIPT)*100  ;Absolute Transit Local Share
              _HBCLCLW_SABS = (_HBCLCLW / _HBCTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBCLCLD_SABS = (_HBCLCLD / _HBCTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBCCORT_SABS = (_HBCCORT / _HBCTRIPT)*100  ;Absolute Transit COR Share
              _HBCCORW_SABS = (_HBCCORW / _HBCTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBCCORD_SABS = (_HBCCORD / _HBCTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBCEXPT_SABS = (_HBCEXPT / _HBCTRIPT)*100  ;Absolute Transit Express Share
              _HBCEXPW_SABS = (_HBCEXPW / _HBCTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBCEXPD_SABS = (_HBCEXPD / _HBCTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBCLRTT_SABS = (_HBCLRTT / _HBCTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBCLRTW_SABS = (_HBCLRTW / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBCLRTD_SABS = (_HBCLRTD / _HBCTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBCCRTT_SABS = (_HBCCRTT / _HBCTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBCCRTW_SABS = (_HBCCRTW / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBCCRTD_SABS = (_HBCCRTD / _HBCTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBCBRTT_SABS = (_HBCBRTT / _HBCTRIPT)*100  ;Absolute Transit BRT Share
              _HBCBRTW_SABS = (_HBCBRTW / _HBCTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBCBRTD_SABS = (_HBCBRTD / _HBCTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBC relative share info
      if (_HBCTRIPT!=0)  
        _HBCMOTOR_SREL = (_HBCMOTOR / _HBCTRIPT)*100  ;Relative Motorized Share
        _HBCNONMO_SREL = (_HBCNONMO / _HBCTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBCMOTOR!=0)  
          _HBCAUTOT_SREL = (_HBCAUTOT / _HBCMOTOR)*100  ;Relative Auto Share
          _HBCTRANT_SREL = (_HBCTRANT / _HBCMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBCAUTOT!=0)  
            _HBCAUTO1_SREL = (_HBCAUTO1 / _HBCAUTOT)*100  ;Relative Drive-Alone Share
            _HBCAUTO2_SREL = (_HBCAUTO2 / _HBCAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBCAUTO3_SREL = (_HBCAUTO3 / _HBCAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBCAUTO1!=0)  
              _HBC_DANON_SREL = (_HBC_DANON / _HBCAUTO1)*100  ;Relative DA non-tol
              _HBC_DATOL_SREL = (_HBC_DATOL / _HBCAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBCAUTO2!=0)  
              _HBC_SR2NON_SREL = (_HBC_SR2NON / _HBCAUTO2)*100  
              _HBC_SR2TOL_SREL = (_HBC_SR2TOL / _HBCAUTO2)*100  
              _HBC_SR2HOV_SREL = (_HBC_SR2HOV / _HBCAUTO2)*100  
      endif    
      if (_HBCAUTO3!=0)  
              _HBC_SR3NON_SREL = (_HBC_SR3NON / _HBCAUTO3)*100  
              _HBC_SR3TOL_SREL = (_HBC_SR3TOL / _HBCAUTO3)*100  
              _HBC_SR3HOV_SREL = (_HBC_SR3HOV / _HBCAUTO3)*100  
      endif   
      if (_HBCTRANT!=0)  
            _HBCLCLT_SREL = (_HBCLCLT / _HBCTRANT)*100  ;Relative Transit Local Share
            _HBCCORT_SREL = (_HBCCORT / _HBCTRANT)*100  ;Relative Transit COR Share
            _HBCEXPT_SREL = (_HBCEXPT / _HBCTRANT)*100  ;Relative Transit Express Share
            _HBCLRTT_SREL = (_HBCLRTT / _HBCTRANT)*100  ;Relative Transit Light-Rail Share
            _HBCCRTT_SREL = (_HBCCRTT / _HBCTRANT)*100  ;Relative Transit Commuter rail Share
            _HBCBRTT_SREL = (_HBCBRTT / _HBCTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBCLCLT!=0)  
              _HBCLCLW_SREL = (_HBCLCLW / _HBCLCLT)*100  ;Relative Transit Local-Walk Share
              _HBCLCLD_SREL = (_HBCLCLD / _HBCLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLCLW_SREL = .0001
              _HBCLCLD_SREL = .0001          
      endif
      if (_HBCCORT!=0)  
              _HBCCORW_SREL = (_HBCCORW / _HBCCORT)*100  ;Relative Transit COR-Walk Share
              _HBCCORD_SREL = (_HBCCORD / _HBCCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBCCORW_SREL = .0001
              _HBCCORD_SREL = .0001          
      endif
      if (_HBCEXPT!=0)  
              _HBCEXPW_SREL = (_HBCEXPW / _HBCEXPT)*100  ;Relative Transit Local-Walk Share
              _HBCEXPD_SREL = (_HBCEXPD / _HBCEXPT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCEXPW_SREL = .0001
              _HBCEXPD_SREL = .0001
      endif 
      if (_HBCLRTT!=0)  
              _HBCLRTW_SREL = (_HBCLRTW / _HBCLRTT)*100  ;Relative Transit Local-Walk Share
              _HBCLRTD_SREL = (_HBCLRTD / _HBCLRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCLRTW_SREL = .0001
              _HBCLRTD_SREL = .0001
      endif      
      if (_HBCCRTT!=0)  
              _HBCCRTW_SREL = (_HBCCRTW / _HBCCRTT)*100  ;Relative Transit Local-Walk Share
              _HBCCRTD_SREL = (_HBCCRTD / _HBCCRTT)*100  ;Relative Transit Local-Drive Share
      else
              _HBCCRTW_SREL = .0001
              _HBCCRTD_SREL = .0001
      endif
      if (_HBCBRTT!=0)  
              _HBCBRTW_SREL = (_HBCBRTW / _HBCBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBCBRTD_SREL = (_HBCBRTD / _HBCBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBCBRTW_SREL = .0001
              _HBCBRTD_SREL = .0001
      endif
    
      ;*********************** Compute HBO absolute share info
      if (_HBOTRIPT!=0)  
        _HBONONMO_SABS = (_HBONONMO / _HBOTRIPT)*100  ;Absolute Non-Motorized Share
        _HBOMOTOR_SABS = (_HBOMOTOR / _HBOTRIPT)*100  ;Absolute Motorized Share
          _HBOAUTOT_SABS = (_HBOAUTOT / _HBOTRIPT)*100  ;Absolute Auto Share
            _HBOAUTO1_SABS = (_HBOAUTO1 / _HBOTRIPT)*100  ;Absolute Drive-Alone Share
              _HBO_DANON_SABS = (_HBO_DANON / _HBOTRIPT)*100  ;Absolute Drive-Alone, non managed
              _HBO_DATOL_SABS = (_HBO_DATOL / _HBOTRIPT)*100  ;Absolute Drive-Alone, toll
            _HBOAUTO2_SABS = (_HBOAUTO2 / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _HBO_SR2NON_SABS = (_HBO_SR2NON / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _HBO_SR2TOL_SABS = (_HBO_SR2TOL / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _HBO_SR2HOV_SABS = (_HBO_SR2HOV / _HBOTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _HBOAUTO3_SABS = (_HBOAUTO3 / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _HBO_SR3NON_SABS = (_HBO_SR3NON / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _HBO_SR3TOL_SABS = (_HBO_SR3TOL / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _HBO_SR3HOV_SABS = (_HBO_SR3HOV / _HBOTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _HBOTRANT_SABS = (_HBOTRANT / _HBOTRIPT)*100  ;Absolute Transit Share
            _HBOLCLT_SABS = (_HBOLCLT / _HBOTRIPT)*100  ;Absolute Transit Local Share
              _HBOLCLW_SABS = (_HBOLCLW / _HBOTRIPT)*100  ;Absolute Transit Local-Walk Share
              _HBOLCLD_SABS = (_HBOLCLD / _HBOTRIPT)*100  ;Absolute Transit Local-Drive Share
            _HBOCORT_SABS = (_HBOCORT / _HBOTRIPT)*100  ;Absolute Transit COR Share
              _HBOCORW_SABS = (_HBOCORW / _HBOTRIPT)*100  ;Absolute Transit COR-Walk Share
              _HBOCORD_SABS = (_HBOCORD / _HBOTRIPT)*100  ;Absolute Transit COR-Drive Share
            _HBOEXPT_SABS = (_HBOEXPT / _HBOTRIPT)*100  ;Absolute Transit Express Share
              _HBOEXPW_SABS = (_HBOEXPW / _HBOTRIPT)*100  ;Absolute Transit Express-Walk Share
              _HBOEXPD_SABS = (_HBOEXPD / _HBOTRIPT)*100  ;Absolute Transit Express-Drive Share
            _HBOLRTT_SABS = (_HBOLRTT / _HBOTRIPT)*100  ;Absolute Transit Light-Rail Share
              _HBOLRTW_SABS = (_HBOLRTW / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _HBOLRTD_SABS = (_HBOLRTD / _HBOTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _HBOCRTT_SABS = (_HBOCRTT / _HBOTRIPT)*100  ;Absolute Transit Commuter rail Share
              _HBOCRTW_SABS = (_HBOCRTW / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _HBOCRTD_SABS = (_HBOCRTD / _HBOTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _HBOBRTT_SABS = (_HBOBRTT / _HBOTRIPT)*100  ;Absolute Transit BRT Share
              _HBOBRTW_SABS = (_HBOBRTW / _HBOTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _HBOBRTD_SABS = (_HBOBRTD / _HBOTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute HBO relative share info
      if (_HBOTRIPT!=0)  
        _HBOMOTOR_SREL = (_HBOMOTOR / _HBOTRIPT)*100  ;Relative Motorized Share
        _HBONONMO_SREL = (_HBONONMO / _HBOTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_HBOMOTOR!=0)  
          _HBOAUTOT_SREL = (_HBOAUTOT / _HBOMOTOR)*100  ;Relative Auto Share
          _HBOTRANT_SREL = (_HBOTRANT / _HBOMOTOR)*100  ;Relative Transit Share
      endif
      if (_HBOAUTOT!=0)  
            _HBOAUTO1_SREL = (_HBOAUTO1 / _HBOAUTOT)*100  ;Relative Drive-Alone Share
            _HBOAUTO2_SREL = (_HBOAUTO2 / _HBOAUTOT)*100  ;Relative Shared ride 2 pers Share
            _HBOAUTO3_SREL = (_HBOAUTO3 / _HBOAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_HBOAUTO1!=0)  
              _HBO_DANON_SREL = (_HBO_DANON / _HBOAUTO1)*100  ;Relative DA non-tol
              _HBO_DATOL_SREL = (_HBO_DATOL / _HBOAUTO1)*100  ;Relative DA tol
      endif  
      if (_HBOAUTO2!=0)  
              _HBO_SR2NON_SREL = (_HBO_SR2NON / _HBOAUTO2)*100  
              _HBO_SR2TOL_SREL = (_HBO_SR2TOL / _HBOAUTO2)*100  
              _HBO_SR2HOV_SREL = (_HBO_SR2HOV / _HBOAUTO2)*100  
      endif    
      if (_HBOAUTO3!=0)  
              _HBO_SR3NON_SREL = (_HBO_SR3NON / _HBOAUTO3)*100  
              _HBO_SR3TOL_SREL = (_HBO_SR3TOL / _HBOAUTO3)*100  
              _HBO_SR3HOV_SREL = (_HBO_SR3HOV / _HBOAUTO3)*100  
      endif   
      if (_HBOTRANT!=0)  
            _HBOLCLT_SREL = (_HBOLCLT / _HBOTRANT)*100  ;Relative Transit Local Share
            _HBOCORT_SREL = (_HBOCORT / _HBOTRANT)*100  ;Relative Transit COR Share
            _HBOEXPT_SREL = (_HBOEXPT / _HBOTRANT)*100  ;Relative Transit Express Share
            _HBOLRTT_SREL = (_HBOLRTT / _HBOTRANT)*100  ;Relative Transit Light-Rail Share
            _HBOCRTT_SREL = (_HBOCRTT / _HBOTRANT)*100  ;Relative Transit Commuter rail Share
            _HBOBRTT_SREL = (_HBOBRTT / _HBOTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_HBOLCLT!=0)  
              _HBOLCLW_SREL = (_HBOLCLW / _HBOLCLT)*100  ;Relative Transit Local-Walk Share
              _HBOLCLD_SREL = (_HBOLCLD / _HBOLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _HBOLCLW_SREL = .0001
              _HBOLCLD_SREL = .0001          
      endif
      if (_HBOCORT!=0)  
              _HBOCORW_SREL = (_HBOCORW / _HBOCORT)*100  ;Relative Transit COR-Walk Share
              _HBOCORD_SREL = (_HBOCORD / _HBOCORT)*100  ;Relative Transit COR-Drive Share
      else
              _HBOCORW_SREL = .0001
              _HBOCORD_SREL = .0001          
      endif
      if (_HBOEXPT!=0)  
              _HBOEXPW_SREL = (_HBOEXPW / _HBOEXPT)*100  ;Relative Transit EXP-Walk Share
              _HBOEXPD_SREL = (_HBOEXPD / _HBOEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _HBOEXPW_SREL = .0001
              _HBOEXPD_SREL = .0001
      endif 
      if (_HBOLRTT!=0)  
              _HBOLRTW_SREL = (_HBOLRTW / _HBOLRTT)*100  ;Relative Transit LRT-Walk Share
              _HBOLRTD_SREL = (_HBOLRTD / _HBOLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _HBOLRTW_SREL = .0001
              _HBOLRTD_SREL = .0001
      endif      
      if (_HBOCRTT!=0)  
              _HBOCRTW_SREL = (_HBOCRTW / _HBOCRTT)*100  ;Relative Transit CRT-Walk Share
              _HBOCRTD_SREL = (_HBOCRTD / _HBOCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _HBOCRTW_SREL = .0001
              _HBOCRTD_SREL = .0001
      endif
      if (_HBOBRTT!=0)  
              _HBOBRTW_SREL = (_HBOBRTW / _HBOBRTT)*100  ;Relative Transit BRT-Walk Share
              _HBOBRTD_SREL = (_HBOBRTD / _HBOBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _HBOBRTW_SREL = .0001
              _HBOBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      ;*********************** Compute NHB relative share info
      if (_NHBTRIPT!=0)  
        _NHBMOTOR_SREL = (_NHBMOTOR / _NHBTRIPT)*100  ;Relative Motorized Share
        _NHBNONMO_SREL = (_NHBNONMO / _NHBTRIPT)*100  ;Relative Non-Motorized Share
      endif
      if (_NHBMOTOR!=0)  
          _NHBAUTOT_SREL = (_NHBAUTOT / _NHBMOTOR)*100  ;Relative Auto Share
          _NHBTRANT_SREL = (_NHBTRANT / _NHBMOTOR)*100  ;Relative Transit Share
      endif
      if (_NHBAUTOT!=0)  
            _NHBAUTO1_SREL = (_NHBAUTO1 / _NHBAUTOT)*100  ;Relative Drive-Alone Share
            _NHBAUTO2_SREL = (_NHBAUTO2 / _NHBAUTOT)*100  ;Relative Shared ride 2 pers Share
            _NHBAUTO3_SREL = (_NHBAUTO3 / _NHBAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      if (_NHBAUTO1!=0)  
              _NHB_DANON_SREL = (_NHB_DANON / _NHBAUTO1)*100  ;Relative DA non-tol
              _NHB_DATOL_SREL = (_NHB_DATOL / _NHBAUTO1)*100  ;Relative DA tol
      endif  
      if (_NHBAUTO2!=0)  
              _NHB_SR2NON_SREL = (_NHB_SR2NON / _NHBAUTO2)*100  
              _NHB_SR2TOL_SREL = (_NHB_SR2TOL / _NHBAUTO2)*100  
              _NHB_SR2HOV_SREL = (_NHB_SR2HOV / _NHBAUTO2)*100  
      endif    
      if (_NHBAUTO3!=0)  
              _NHB_SR3NON_SREL = (_NHB_SR3NON / _NHBAUTO3)*100  
              _NHB_SR3TOL_SREL = (_NHB_SR3TOL / _NHBAUTO3)*100  
              _NHB_SR3HOV_SREL = (_NHB_SR3HOV / _NHBAUTO3)*100  
      endif   
      if (_NHBTRANT!=0)  
            _NHBLCLT_SREL = (_NHBLCLT / _NHBTRANT)*100  ;Relative Transit Local Share
            _NHBCORT_SREL = (_NHBCORT / _NHBTRANT)*100  ;Relative Transit COR Share
            _NHBEXPT_SREL = (_NHBEXPT / _NHBTRANT)*100  ;Relative Transit Express Share
            _NHBLRTT_SREL = (_NHBLRTT / _NHBTRANT)*100  ;Relative Transit Light-Rail Share
            _NHBCRTT_SREL = (_NHBCRTT / _NHBTRANT)*100  ;Relative Transit Commuter rail Share
            _NHBBRTT_SREL = (_NHBBRTT / _NHBTRANT)*100  ;Relative Transit BRT Share
      endif
      if (_NHBLCLT!=0)  
              _NHBLCLW_SREL = (_NHBLCLW / _NHBLCLT)*100  ;Relative Transit Local-Walk Share
              _NHBLCLD_SREL = (_NHBLCLD / _NHBLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _NHBLCLW_SREL = .0001
              _NHBLCLD_SREL = .0001          
      endif
      if (_NHBCORT!=0)  
              _NHBCORW_SREL = (_NHBCORW / _NHBCORT)*100  ;Relative Transit COR-Walk Share
              _NHBCORD_SREL = (_NHBCORD / _NHBCORT)*100  ;Relative Transit COR-Drive Share
      else
              _NHBCORW_SREL = .0001
              _NHBCORD_SREL = .0001          
      endif
      if (_NHBEXPT!=0)  
              _NHBEXPW_SREL = (_NHBEXPW / _NHBEXPT)*100  ;Relative Transit EXP-Walk Share
              _NHBEXPD_SREL = (_NHBEXPD / _NHBEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _NHBEXPW_SREL = .0001
              _NHBEXPD_SREL = .0001
      endif 
      if (_NHBLRTT!=0)  
              _NHBLRTW_SREL = (_NHBLRTW / _NHBLRTT)*100  ;Relative Transit LRT-Walk Share
              _NHBLRTD_SREL = (_NHBLRTD / _NHBLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _NHBLRTW_SREL = .0001
              _NHBLRTD_SREL = .0001
      endif      
      if (_NHBCRTT!=0)  
              _NHBCRTW_SREL = (_NHBCRTW / _NHBCRTT)*100  ;Relative Transit CRT-Walk Share
              _NHBCRTD_SREL = (_NHBCRTD / _NHBCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _NHBCRTW_SREL = .0001
              _NHBCRTD_SREL = .0001
      endif
      if (_NHBBRTT!=0)  
              _NHBBRTW_SREL = (_NHBBRTW / _NHBBRTT)*100  ;Relative Transit BRT-Walk Share
              _NHBBRTD_SREL = (_NHBBRTD / _NHBBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _NHBBRTW_SREL = .0001
              _NHBBRTD_SREL = .0001
      endif
    
      ;*********************** Compute NHB absolute share info
      if (_NHBTRIPT!=0)  
        _NHBNONMO_SABS = (_NHBNONMO / _NHBTRIPT)*100  ;Absolute Non-Motorized Share
        _NHBMOTOR_SABS = (_NHBMOTOR / _NHBTRIPT)*100  ;Absolute Motorized Share
          _NHBAUTOT_SABS = (_NHBAUTOT / _NHBTRIPT)*100  ;Absolute Auto Share
            _NHBAUTO1_SABS = (_NHBAUTO1 / _NHBTRIPT)*100  ;Absolute Drive-Alone Share
              _NHB_DANON_SABS = (_NHB_DANON / _NHBTRIPT)*100  ;Absolute Drive-Alone, non managed
              _NHB_DATOL_SABS = (_NHB_DATOL / _NHBTRIPT)*100  ;Absolute Drive-Alone, toll
            _NHBAUTO2_SABS = (_NHBAUTO2 / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _NHB_SR2NON_SABS = (_NHB_SR2NON / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, non managed
              _NHB_SR2TOL_SABS = (_NHB_SR2TOL / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, toll
              _NHB_SR2HOV_SABS = (_NHB_SR2HOV / _NHBTRIPT)*100  ;Absolute Shared ride 2 pers, hov
            _NHBAUTO3_SABS = (_NHBAUTO3 / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _NHB_SR3NON_SABS = (_NHB_SR3NON / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, non managed
              _NHB_SR3TOL_SABS = (_NHB_SR3TOL / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, toll
              _NHB_SR3HOV_SABS = (_NHB_SR3HOV / _NHBTRIPT)*100  ;Absolute Shared ride 3+ pers, hov
    
     
          _NHBTRANT_SABS = (_NHBTRANT / _NHBTRIPT)*100  ;Absolute Transit Share
            _NHBLCLT_SABS = (_NHBLCLT / _NHBTRIPT)*100  ;Absolute Transit Local Share
              _NHBLCLW_SABS = (_NHBLCLW / _NHBTRIPT)*100  ;Absolute Transit Local-Walk Share
              _NHBLCLD_SABS = (_NHBLCLD / _NHBTRIPT)*100  ;Absolute Transit Local-Drive Share
            _NHBCORT_SABS = (_NHBCORT / _NHBTRIPT)*100  ;Absolute Transit COR Share
              _NHBCORW_SABS = (_NHBCORW / _NHBTRIPT)*100  ;Absolute Transit COR-Walk Share
              _NHBCORD_SABS = (_NHBCORD / _NHBTRIPT)*100  ;Absolute Transit COR-Drive Share
            _NHBEXPT_SABS = (_NHBEXPT / _NHBTRIPT)*100  ;Absolute Transit Express Share
              _NHBEXPW_SABS = (_NHBEXPW / _NHBTRIPT)*100  ;Absolute Transit Express-Walk Share
              _NHBEXPD_SABS = (_NHBEXPD / _NHBTRIPT)*100  ;Absolute Transit Express-Drive Share
            _NHBLRTT_SABS = (_NHBLRTT / _NHBTRIPT)*100  ;Absolute Transit Light-Rail Share
              _NHBLRTW_SABS = (_NHBLRTW / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _NHBLRTD_SABS = (_NHBLRTD / _NHBTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _NHBCRTT_SABS = (_NHBCRTT / _NHBTRIPT)*100  ;Absolute Transit Commuter rail Share
              _NHBCRTW_SABS = (_NHBCRTW / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _NHBCRTD_SABS = (_NHBCRTD / _NHBTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _NHBBRTT_SABS = (_NHBBRTT / _NHBTRIPT)*100  ;Absolute Transit BRT Share
              _NHBBRTW_SABS = (_NHBBRTW / _NHBTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _NHBBRTD_SABS = (_NHBBRTD / _NHBTRIPT)*100  ;Absolute Transit BRT-Drive Share        
      endif
    
      
      ;*********************** Compute HBS share - relative
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_REL = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_REL = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
      endif
      
      if (_HBSMOTOR!=0)  
          PR_HBS_Rel = _HBSMOTOR_PR / _HBSMOTOR * 100
          SC_HBS_Rel = _HBSMOTOR_SC / _HBSMOTOR * 100
          
          HBS_SchBus_Rel = _HBS_SB / _HBSMOTOR * 100
          HBS_DrSelf_Rel = _HBS_DS / _HBSMOTOR * 100
          HBS_DrpOff_Rel = _HBS_DO / _HBSMOTOR * 100
      endif
      
      if (_HBSMOTOR_PR!=0)  
          PR_HBS_SchBus_Rel = PR_HBSch_SB / _HBSMOTOR_PR * 100
          PR_HBS_DrSelf_Rel = PR_HBSch_DS / _HBSMOTOR_PR * 100
          PR_HBS_DrpOff_Rel = PR_HBSch_DO / _HBSMOTOR_PR * 100
      endif
      
      if (_HBSMOTOR_SC!=0)  
          SC_HBS_SchBus_Rel = SC_HBSch_SB / _HBSMOTOR_SC * 100
          SC_HBS_DrSelf_Rel = SC_HBSch_DS / _HBSMOTOR_SC * 100
          SC_HBS_DrpOff_Rel = SC_HBSch_DO / _HBSMOTOR_SC * 100
      endif
      
      ;*********************** Compute HBS share - absolute
      if (_HBSTRIPT!=0)  
          HBS_MOTOR_Abs = _HBSMOTOR / _HBSTRIPT * 100  ;Relative Motorized Share
          HBS_NONMO_Abs = _HBSNONMO / _HBSTRIPT * 100  ;Relative Non-Motorized Share
          
          PR_HBS_Abs = _HBSMOTOR_PR / _HBSTRIPT * 100
          SC_HBS_Abs = _HBSMOTOR_SC / _HBSTRIPT * 100
          
          HBS_SchBus_Abs = _HBS_SB / _HBSTRIPT * 100
          HBS_DrSelf_Abs = _HBS_DS / _HBSTRIPT * 100
          HBS_DrpOff_Abs = _HBS_DO   / _HBSTRIPT * 100
          
          PR_HBS_SchBus_Abs = PR_HBSch_SB / _HBSTRIPT * 100
          PR_HBS_DrSelf_Abs = PR_HBSch_DS / _HBSTRIPT * 100
          PR_HBS_DrpOff_Abs = PR_HBSch_DO   / _HBSTRIPT * 100
          
          SC_HBS_SchBus_Abs = SC_HBSch_SB / _HBSTRIPT * 100
          SC_HBS_DrSelf_Abs = SC_HBSch_DS / _HBSTRIPT * 100
          SC_HBS_DrpOff_Abs = SC_HBSch_DO   / _HBSTRIPT * 100
      endif
      
    
      ;*********************** Compute TOT absolute share info
      if (_TOTTRIPT!=0)  
        _TOTNONMO_SABS = (_TOTNONMO / _TOTTRIPT)*100  ;Absolute Non-Motorized Share
        _TOTMOTOR_SABS = (_TOTMOTOR / _TOTTRIPT)*100  ;Absolute Motorized Share
          _TOTAUTOT_SABS = (_TOTAUTOT / _TOTTRIPT)*100  ;Absolute Auto Share
            _TOTAUTO1_SABS = (_TOTAUTO1 / _TOTTRIPT)*100  ;Absolute Drive-Alone Share
              _TOT_DANON_SABS = (_TOT_DANON / _TOTTRIPT)*100  
              _TOT_DATOL_SABS = (_TOT_DATOL / _TOTTRIPT)*100  
            _TOTAUTO2_SABS = (_TOTAUTO2 / _TOTTRIPT)*100  ;Absolute Shared ride 2 pers Share
              _TOT_SR2NON_SABS = (_TOT_SR2NON / _TOTTRIPT)*100  
              _TOT_SR2TOL_SABS = (_TOT_SR2TOL / _TOTTRIPT)*100  
              _TOT_SR2HOV_SABS = (_TOT_SR2HOV / _TOTTRIPT)*100  
            _TOTAUTO3_SABS = (_TOTAUTO3 / _TOTTRIPT)*100  ;Absolute Shared ride 3+ pers Share
              _TOT_SR3NON_SABS = (_TOT_SR3NON / _TOTTRIPT)*100  
              _TOT_SR3TOL_SABS = (_TOT_SR3TOL / _TOTTRIPT)*100  
              _TOT_SR3HOV_SABS = (_TOT_SR3HOV / _TOTTRIPT)*100   
          _TOTTRANT_SABS = (_TOTTRANT / _TOTTRIPT)*100  ;Absolute Transit Share
            _TOTLCLT_SABS = (_TOTLCLT / _TOTTRIPT)*100  ;Absolute Transit Local Share
              _TOTLCLW_SABS = (_TOTLCLW / _TOTTRIPT)*100  ;Absolute Transit Local-Walk Share
              _TOTLCLD_SABS = (_TOTLCLD / _TOTTRIPT)*100  ;Absolute Transit Local-Drive Share
            _TOTCORT_SABS = (_TOTCORT / _TOTTRIPT)*100  ;Absolute Transit COR Share
              _TOTCORW_SABS = (_TOTCORW / _TOTTRIPT)*100  ;Absolute Transit COR-Walk Share
              _TOTCORD_SABS = (_TOTCORD / _TOTTRIPT)*100  ;Absolute Transit COR-Drive Share
            _TOTEXPT_SABS = (_TOTEXPT / _TOTTRIPT)*100  ;Absolute Transit Express Share
              _TOTEXPW_SABS = (_TOTEXPW / _TOTTRIPT)*100  ;Absolute Transit Express-Walk Share
              _TOTEXPD_SABS = (_TOTEXPD / _TOTTRIPT)*100  ;Absolute Transit Express-Drive Share
            _TOTLRTT_SABS = (_TOTLRTT / _TOTTRIPT)*100  ;Absolute Transit Light-Rail Share
              _TOTLRTW_SABS = (_TOTLRTW / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Walk Share
              _TOTLRTD_SABS = (_TOTLRTD / _TOTTRIPT)*100  ;Absolute Transit Light-Rail-Drive Share
            _TOTCRTT_SABS = (_TOTCRTT / _TOTTRIPT)*100  ;Absolute Transit Commuter rail Share
              _TOTCRTW_SABS = (_TOTCRTW / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Walk Share
              _TOTCRTD_SABS = (_TOTCRTD / _TOTTRIPT)*100  ;Absolute Transit Commuter rail-Drive Share
            _TOTBRTT_SABS = (_TOTBRTT / _TOTTRIPT)*100  ;Absolute Transit BRT Share
              _TOTBRTW_SABS = (_TOTBRTW / _TOTTRIPT)*100  ;Absolute Transit BRT-Walk Share
              _TOTBRTD_SABS = (_TOTBRTD / _TOTTRIPT)*100  ;Absolute Transit BRT-Drive Share
              
          TOT_HBSMOTOR_Abs = _HBSMOTOR / (_TOTTRIPT/100) * 100
          
          PR_TOT_Abs = _HBSMOTOR_PR / (_TOTTRIPT/100) * 100
          SC_TOT_Abs = _HBSMOTOR_SC / (_TOTTRIPT/100) * 100
          
          TOT_SchBus_Abs = _HBS_SB / (_TOTTRIPT/100) * 100
          TOT_DrSelf_Abs = _HBS_DS / (_TOTTRIPT/100) * 100
          TOT_DrpOff_Abs = _HBS_DO / (_TOTTRIPT/100) * 100
          
          PR_TOT_SchBus_Abs = PR_HBSch_SB / (_TOTTRIPT/100) * 100
          PR_TOT_DrSelf_Abs = PR_HBSch_DS / (_TOTTRIPT/100) * 100
          PR_TOT_DrpOff_Abs = PR_HBSch_DO / (_TOTTRIPT/100) * 100
          
          SC_TOT_SchBus_Abs = SC_HBSch_SB / (_TOTTRIPT/100) * 100
          SC_TOT_DrSelf_Abs = SC_HBSch_DS / (_TOTTRIPT/100) * 100
          SC_TOT_DrpOff_Abs = SC_HBSch_DO / (_TOTTRIPT/100) * 100
      endif
    
      ;*********************** Compute TOT relative share info
      if (_TOTTRIPT!=0)  
        _TOTMOTOR_SREL = (_TOTMOTOR / _TOTTRIPT)*100  ;Relative Motorized Share
        _TOTNONMO_SREL = (_TOTNONMO / _TOTTRIPT)*100  ;Relative Non-Motorized Share
      endif
      
      if (_TOTMOTOR!=0)  
          _TOTAUTOT_SREL = (_TOTAUTOT / _TOTMOTOR)*100  ;Relative Auto Share
          _TOTTRANT_SREL = (_TOTTRANT / _TOTMOTOR)*100  ;Relative Transit Share
      endif
      
      if (_TOTAUTOT!=0)  
            _TOTAUTO1_SREL = (_TOTAUTO1 / _TOTAUTOT)*100  ;Relative Drive-Alone Share
            _TOTAUTO2_SREL = (_TOTAUTO2 / _TOTAUTOT)*100  ;Relative Shared ride 2 pers Share
            _TOTAUTO3_SREL = (_TOTAUTO3 / _TOTAUTOT)*100  ;Relative Shared ride 3+ pers Share
      endif
      
      if (_TOTAUTO1!=0)  
              _TOT_DANON_SREL = (_TOT_DANON / _TOTAUTO1)*100 
              _TOT_DATOL_SREL = (_TOT_DATOL / _TOTAUTO1)*100 
      endif
      
      if (_TOTAUTO2!=0)  
              _TOT_SR2NON_SREL = (_TOT_SR2NON / _TOTAUTO2)*100 
              _TOT_SR2TOL_SREL = (_TOT_SR2TOL / _TOTAUTO2)*100 
              _TOT_SR2HOV_SREL = (_TOT_SR2HOV / _TOTAUTO2)*100 
      endif
      
      if (_TOTAUTO3!=0)  
              _TOT_SR3NON_SREL = (_TOT_SR3NON / _TOTAUTO3)*100 
              _TOT_SR3TOL_SREL = (_TOT_SR3TOL / _TOTAUTO3)*100 
              _TOT_SR3HOV_SREL = (_TOT_SR3HOV / _TOTAUTO3)*100 
      endif
      
      if (_TOTTRANT!=0)  
            _TOTLCLT_SREL = (_TOTLCLT / _TOTTRANT)*100  ;Relative Transit Local Share
            _TOTCORT_SREL = (_TOTCORT / _TOTTRANT)*100  ;Relative Transit COR Share
            _TOTEXPT_SREL = (_TOTEXPT / _TOTTRANT)*100  ;Relative Transit Express Share
            _TOTLRTT_SREL = (_TOTLRTT / _TOTTRANT)*100  ;Relative Transit Light-Rail Share
            _TOTCRTT_SREL = (_TOTCRTT / _TOTTRANT)*100  ;Relative Transit Commuter rail Share
            _TOTBRTT_SREL = (_TOTBRTT / _TOTTRANT)*100  ;Relative Transit BRT Share
      endif
      
      if (_TOTLCLT!=0)  
              _TOTLCLW_SREL = (_TOTLCLW / _TOTLCLT)*100  ;Relative Transit Local-Walk Share
              _TOTLCLD_SREL = (_TOTLCLD / _TOTLCLT)*100  ;Relative Transit Local-Drive Share
      else
              _TOTLCLW_SREL = .0001
              _TOTLCLD_SREL = .0001          
      endif
      
      if (_TOTCORT!=0)  
              _TOTCORW_SREL = (_TOTCORW / _TOTCORT)*100  ;Relative Transit COR-Walk Share
              _TOTCORD_SREL = (_TOTCORD / _TOTCORT)*100  ;Relative Transit COR-Drive Share
      else
              _TOTCORW_SREL = .0001
              _TOTCORD_SREL = .0001          
      endif
      if (_TOTEXPT!=0)  
              _TOTEXPW_SREL = (_TOTEXPW / _TOTEXPT)*100  ;Relative Transit EXP-Walk Share
              _TOTEXPD_SREL = (_TOTEXPD / _TOTEXPT)*100  ;Relative Transit EXP-Drive Share
      else
              _TOTEXPW_SREL = .0001
              _TOTEXPD_SREL = .0001
      endif 
      if (_TOTLRTT!=0)  
              _TOTLRTW_SREL = (_TOTLRTW / _TOTLRTT)*100  ;Relative Transit LRT-Walk Share
              _TOTLRTD_SREL = (_TOTLRTD / _TOTLRTT)*100  ;Relative Transit LRT-Drive Share
      else
              _TOTLRTW_SREL = .0001
              _TOTLRTD_SREL = .0001
      endif      
      if (_TOTCRTT!=0)  
              _TOTCRTW_SREL = (_TOTCRTW / _TOTCRTT)*100  ;Relative Transit CRT-Walk Share
              _TOTCRTD_SREL = (_TOTCRTD / _TOTCRTT)*100  ;Relative Transit CRT-Drive Share
      else
              _TOTCRTW_SREL = .0001
              _TOTCRTD_SREL = .0001
      endif
      if (_TOTBRTT!=0)  
              _TOTBRTW_SREL = (_TOTBRTW / _TOTBRTT)*100  ;Relative Transit BRT-Walk Share
              _TOTBRTD_SREL = (_TOTBRTD / _TOTBRTT)*100  ;Relative Transit BRT-Drive Share
      else
              _TOTBRTW_SREL = .0001
              _TOTBRTD_SREL = .0001
      endif    
      
      
      ;***********************************************************************************
      ;**********  Begin CSV print (for easy import to Excel)  
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'TripCategory',   'HBWtrip',   'HBWabs',   'HBWrel',
    			          ,   'HBCtrip',   'HBCabs',   'HBCrel',
    			          ,   'HBOtrip',   'HBOabs',   'HBOrel',
    			          ,   'NHBtrip',   'NHBabs',   'NHBrel',
    			          ,   'HBSchtrip', 'HBSchabs', 'HBSchrel',
    			          ,   'TOTtrip',   'TOTabs',   'TOTrel',
    	
    	'\n1) Total Trips', 
    	    _HBWTRIPT/100(10.0), 100, 100,
    			_HBCTRIPT/100(10.0), 100, 100,
    			_HBOTRIPT/100(10.0), 100, 100,
    			_NHBTRIPT/100(10.0), 100, 100,
    			    _HBSTRIPT(10.0), 100, 100,
    			_TOTTRIPT/100(10.0), 100, 100,
    
    	'\n    2) Non-Motorized', 
    	    _HBWNONMO/100(10.0), _HBWNONMO_SABS, _HBWNONMO_SREL,
    			_HBCNONMO/100(10.0), _HBCNONMO_SABS, _HBCNONMO_SREL,
    			_HBONONMO/100(10.0), _HBONONMO_SABS, _HBONONMO_SREL,
    			_NHBNONMO/100(10.0), _NHBNONMO_SABS, _NHBNONMO_SREL,
    			    _HBSNONMO(10.0),  HBS_NONMO_Abs, HBS_NONMO_Rel,
    			_TOTNONMO/100(10.0), _TOTNONMO_SABS, _TOTNONMO_SREL,
    
    	'\n    2) Motorized', 
    	    _HBWMOTOR/100(10.0), _HBWMOTOR_SABS, _HBWMOTOR_SREL,
    			_HBCMOTOR/100(10.0), _HBCMOTOR_SABS, _HBCMOTOR_SREL,
    			_HBOMOTOR/100(10.0), _HBOMOTOR_SABS, _HBOMOTOR_SREL,
    			_NHBMOTOR/100(10.0), _NHBMOTOR_SABS, _NHBMOTOR_SREL,
    			    _HBSMOTOR(10.0),  HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_TOTMOTOR/100(10.0), _TOTMOTOR_SABS, _TOTMOTOR_SREL
    			         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n        3) Auto', 
    	    _HBWAUTOT/100(10.0), _HBWAUTOT_SABS, _HBWAUTOT_SREL,
    			_HBCAUTOT/100(10.0), _HBCAUTOT_SABS, _HBCAUTOT_SREL,
    			_HBOAUTOT/100(10.0), _HBOAUTOT_SABS, _HBOAUTOT_SREL,
    			_NHBAUTOT/100(10.0), _NHBAUTOT_SABS, _NHBAUTOT_SREL,
    			'-', '-', '-',
    			_TOTAUTOT/100(10.0), _TOTAUTOT_SABS, _TOTAUTOT_SREL,
    	'\n            4) Auto 1 pers', 
    	    _HBWAUTO1/100(10.0), _HBWAUTO1_SABS, _HBWAUTO1_SREL,
    			_HBCAUTO1/100(10.0), _HBCAUTO1_SABS, _HBCAUTO1_SREL,
    			_HBOAUTO1/100(10.0), _HBOAUTO1_SABS, _HBOAUTO1_SREL,
    			_NHBAUTO1/100(10.0), _NHBAUTO1_SABS, _NHBAUTO1_SREL,
    			'-', '-', '-',
    			_TOTAUTO1/100(10.0), _TOTAUTO1_SABS, _TOTAUTO1_SREL,
    
    	'\n                    GP use', 
    	    _HBW_DANON/100(10.0), _HBW_DANON_SABS, _HBW_DANON_SREL,
    			_HBC_DANON/100(10.0), _HBC_DANON_SABS, _HBC_DANON_SREL,
    			_HBO_DANON/100(10.0), _HBO_DANON_SABS, _HBO_DANON_SREL,
    			_NHB_DANON/100(10.0), _NHB_DANON_SABS, _NHB_DANON_SREL,
    			'-', '-', '-',
    			_TOT_DANON/100(10.0), _TOT_DANON_SABS, _TOT_DANON_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_DATOL/100(10.0), _HBW_DATOL_SABS, _HBW_DATOL_SREL,
    			_HBC_DATOL/100(10.0), _HBC_DATOL_SABS, _HBC_DATOL_SREL,
    			_HBO_DATOL/100(10.0), _HBO_DATOL_SABS, _HBO_DATOL_SREL,
    			_NHB_DATOL/100(10.0), _NHB_DATOL_SABS, _NHB_DATOL_SREL,
    			'-', '-', '-',
    			_TOT_DATOL/100(10.0), _TOT_DATOL_SABS, _TOT_DATOL_SREL
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Auto 2 pers', 
    	    _HBWAUTO2/100(10.0), _HBWAUTO2_SABS, _HBWAUTO2_SREL,
    			_HBCAUTO2/100(10.0), _HBCAUTO2_SABS, _HBCAUTO2_SREL,
    			_HBOAUTO2/100(10.0), _HBOAUTO2_SABS, _HBOAUTO2_SREL,
    			_NHBAUTO2/100(10.0), _NHBAUTO2_SABS, _NHBAUTO2_SREL,
    			'-', '-', '-',
    			_TOTAUTO2/100(10.0), _TOTAUTO2_SABS, _TOTAUTO2_SREL,
    			         
    	'\n                    GP use', 
    	    _HBW_SR2NON/100(10.0), _HBW_SR2NON_SABS, _HBW_SR2NON_SREL,
    			_HBC_SR2NON/100(10.0), _HBC_SR2NON_SABS, _HBC_SR2NON_SREL,
    			_HBO_SR2NON/100(10.0), _HBO_SR2NON_SABS, _HBO_SR2NON_SREL,
    			_NHB_SR2NON/100(10.0), _NHB_SR2NON_SABS, _NHB_SR2NON_SREL,
    			'-', '-', '-',
    			_TOT_SR2NON/100(10.0), _TOT_SR2NON_SABS, _TOT_SR2NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR2HOV/100(10.0), _HBW_SR2HOV_SABS, _HBW_SR2HOV_SREL,
    			_HBC_SR2HOV/100(10.0), _HBC_SR2HOV_SABS, _HBC_SR2HOV_SREL,
    			_HBO_SR2HOV/100(10.0), _HBO_SR2HOV_SABS, _HBO_SR2HOV_SREL,
    			_NHB_SR2HOV/100(10.0), _NHB_SR2HOV_SABS, _NHB_SR2HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR2HOV/100(10.0), _TOT_SR2HOV_SABS, _TOT_SR2HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR2TOL/100(10.0), _HBW_SR2TOL_SABS, _HBW_SR2TOL_SREL,
    			_HBC_SR2TOL/100(10.0), _HBC_SR2TOL_SABS, _HBC_SR2TOL_SREL,
    			_HBO_SR2TOL/100(10.0), _HBO_SR2TOL_SABS, _HBO_SR2TOL_SREL,
    			_NHB_SR2TOL/100(10.0), _NHB_SR2TOL_SABS, _NHB_SR2TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR2TOL/100(10.0), _TOT_SR2TOL_SABS, _TOT_SR2TOL_SREL
    	
    			
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Auto 3+pers', 
    	    _HBWAUTO3/100(10.0), _HBWAUTO3_SABS, _HBWAUTO3_SREL,
    			_HBCAUTO3/100(10.0), _HBCAUTO3_SABS, _HBCAUTO3_SREL,
    			_HBOAUTO3/100(10.0), _HBOAUTO3_SABS, _HBOAUTO3_SREL,
    			_NHBAUTO3/100(10.0), _NHBAUTO3_SABS, _NHBAUTO3_SREL,	
    			'-', '-', '-',
    			_TOTAUTO3/100(10.0), _TOTAUTO3_SABS, _TOTAUTO3_SREL,	
    			         
    	'\n                    GP use', 
    	    _HBW_SR3NON/100(10.0), _HBW_SR3NON_SABS, _HBW_SR3NON_SREL,
    			_HBC_SR3NON/100(10.0), _HBC_SR3NON_SABS, _HBC_SR3NON_SREL,
    			_HBO_SR3NON/100(10.0), _HBO_SR3NON_SABS, _HBO_SR3NON_SREL,
    			_NHB_SR3NON/100(10.0), _NHB_SR3NON_SABS, _NHB_SR3NON_SREL,
    			'-', '-', '-',
    		  _TOT_SR3NON/100(10.0), _TOT_SR3NON_SABS, _TOT_SR3NON_SREL,
    
    	'\n                    HOV use', 
    	    _HBW_SR3HOV/100(10.0), _HBW_SR3HOV_SABS, _HBW_SR3HOV_SREL,
    			_HBC_SR3HOV/100(10.0), _HBC_SR3HOV_SABS, _HBC_SR3HOV_SREL,
    			_HBO_SR3HOV/100(10.0), _HBO_SR3HOV_SABS, _HBO_SR3HOV_SREL,
    			_NHB_SR3HOV/100(10.0), _NHB_SR3HOV_SABS, _NHB_SR3HOV_SREL,
    			'-', '-', '-',
    			_TOT_SR3HOV/100(10.0), _TOT_SR3HOV_SABS, _TOT_SR3HOV_SREL,
    
    	'\n                    Toll use', 
    	    _HBW_SR3TOL/100(10.0), _HBW_SR3TOL_SABS, _HBW_SR3TOL_SREL,
    			_HBC_SR3TOL/100(10.0), _HBC_SR3TOL_SABS, _HBC_SR3TOL_SREL,
    			_HBO_SR3TOL/100(10.0), _HBO_SR3TOL_SABS, _HBO_SR3TOL_SREL,
    			_NHB_SR3TOL/100(10.0), _NHB_SR3TOL_SABS, _NHB_SR3TOL_SREL,
    			'-', '-', '-',
    			_TOT_SR3TOL/100(10.0), _TOT_SR3TOL_SABS, _TOT_SR3TOL_SREL
    	
          
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) School Trips', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR(10.0), HBS_MOTOR_Abs, HBS_MOTOR_Rel,
    			_HBSMOTOR(10.0), TOT_HBSMOTOR_Abs, HBS_MOTOR_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_SB(10.0), HBS_SchBus_Abs, HBS_SchBus_Rel,
    			_HBS_SB(10.0), TOT_SchBus_Abs, HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DS(10.0), HBS_DrSelf_Abs, HBS_DrSelf_Rel,
    			_HBS_DS(10.0), TOT_DrSelf_Abs, HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBS_DO(10.0), HBS_DrpOff_Abs, HBS_DrpOff_Rel,
    			_HBS_DO(10.0), TOT_DrpOff_Abs, HBS_DrpOff_Rel,
    			
    	'\n                    K-6', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_PR(10.0), PR_HBS_Abs, PR_HBS_Rel,
    			_HBSMOTOR_PR(10.0), PR_TOT_Abs, PR_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_SB(10.0), PR_HBS_SchBus_Abs, PR_HBS_SchBus_Rel,
    			PR_HBSch_SB(10.0), PR_TOT_SchBus_Abs, PR_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DS(10.0), PR_HBS_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			PR_HBSch_DS(10.0), PR_TOT_DrSelf_Abs, PR_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			PR_HBSch_DO(10.0), PR_HBS_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			PR_HBSch_DO(10.0), PR_TOT_DrpOff_Abs, PR_HBS_DrpOff_Rel,
    			
    	'\n                    7-12', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			_HBSMOTOR_SC(10.0), SC_HBS_Abs, SC_HBS_Rel,
    			_HBSMOTOR_SC(10.0), SC_TOT_Abs, SC_HBS_Rel,
    			
    	'\n                        School Bus', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_SB(10.0), SC_HBS_SchBus_Abs, SC_HBS_SchBus_Rel,
    			SC_HBSch_SB(10.0), SC_TOT_SchBus_Abs, SC_HBS_SchBus_Rel,
    			
    	'\n                        Drive Self', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DS(10.0), SC_HBS_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			SC_HBSch_DS(10.0), SC_TOT_DrSelf_Abs, SC_HBS_DrSelf_Rel,
    			
    	'\n                        Drop Off', 
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			'-', '-', '-',
    			SC_HBSch_DO(10.0), SC_HBS_DrpOff_Abs, SC_HBS_DrpOff_Rel,
    			SC_HBSch_DO(10.0), SC_TOT_DrpOff_Abs, SC_HBS_DrpOff_Rel
    	
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n        3) Transit', 
    	    _HBWTRANT/100(10.0), _HBWTRANT_SABS, _HBWTRANT_SREL,
    			_HBCTRANT/100(10.0), _HBCTRANT_SABS, _HBCTRANT_SREL,
    			_HBOTRANT/100(10.0), _HBOTRANT_SABS, _HBOTRANT_SREL,
    			_NHBTRANT/100(10.0), _NHBTRANT_SABS, _NHBTRANT_SREL,
    			'-', '-', '-',
    			_TOTTRANT/100(10.0), _TOTTRANT_SABS, _TOTTRANT_SREL
    	
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Local Bus (LCL)', 
    	    _HBWLCLT/100(10.0), _HBWLCLT_SABS, _HBWLCLT_SREL,
    			_HBCLCLT/100(10.0), _HBCLCLT_SABS, _HBCLCLT_SREL,
    			_HBOLCLT/100(10.0), _HBOLCLT_SABS, _HBOLCLT_SREL,
    			_NHBLCLT/100(10.0), _NHBLCLT_SABS, _NHBLCLT_SREL,
    			'-', '-', '-',
    			_TOTLCLT/100(10.0), _TOTLCLT_SABS, _TOTLCLT_SREL,
    
    	'\n                    LCL Walk', 
    	    _HBWLCLW/100(10.0), _HBWLCLW_SABS, _HBWLCLW_SREL,
    			_HBCLCLW/100(10.0), _HBCLCLW_SABS, _HBCLCLW_SREL,
    			_HBOLCLW/100(10.0), _HBOLCLW_SABS, _HBOLCLW_SREL,
    			_NHBLCLW/100(10.0), _NHBLCLW_SABS, _NHBLCLW_SREL,
    			'-', '-', '-',
    			_TOTLCLW/100(10.0), _TOTLCLW_SABS, _TOTLCLW_SREL,
    
    	'\n                    LCL Drive', 
    	    _HBWLCLD/100(10.0), _HBWLCLD_SABS, _HBWLCLD_SREL,
    			_HBCLCLD/100(10.0), _HBCLCLD_SABS, _HBCLCLD_SREL,
    			_HBOLCLD/100(10.0), _HBOLCLD_SABS, _HBOLCLD_SREL,
    			_NHBLCLD/100(10.0), _NHBLCLD_SABS, _NHBLCLD_SREL,	
    			'-', '-', '-',
    			_TOTLCLD/100(10.0), _TOTLCLD_SABS, _TOTLCLD_SREL
    
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Core Bus (COR)', 
    	    _HBWCORT/100(10.0), _HBWCORT_SABS, _HBWCORT_SREL,
    			_HBCCORT/100(10.0), _HBCCORT_SABS, _HBCCORT_SREL,
    			_HBOCORT/100(10.0), _HBOCORT_SABS, _HBOCORT_SREL,
    			_NHBCORT/100(10.0), _NHBCORT_SABS, _NHBCORT_SREL,
    			'-', '-', '-',
    			_TOTCORT/100(10.0), _TOTCORT_SABS, _TOTCORT_SREL,
    
    	'\n                    COR Walk', 
    	    _HBWCORW/100(10.0), _HBWCORW_SABS, _HBWCORW_SREL,
    			_HBCCORW/100(10.0), _HBCCORW_SABS, _HBCCORW_SREL,
    			_HBOCORW/100(10.0), _HBOCORW_SABS, _HBOCORW_SREL,
    			_NHBCORW/100(10.0), _NHBCORW_SABS, _NHBCORW_SREL,
    			'-', '-', '-',
    			_TOTCORW/100(10.0), _TOTCORW_SABS, _TOTCORW_SREL,
    
    	'\n                    COR Drive', 
    	    _HBWCORD/100(10.0), _HBWCORD_SABS, _HBWCORD_SREL,
    			_HBCCORD/100(10.0), _HBCCORD_SABS, _HBCCORD_SREL,
    			_HBOCORD/100(10.0), _HBOCORD_SABS, _HBOCORD_SREL,
    			_NHBCORD/100(10.0), _NHBCORD_SABS, _NHBCORD_SREL,	
    			'-', '-', '-',
    			_TOTCORD/100(10.0), _TOTCORD_SABS, _TOTCORD_SREL
    			
    
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Bus-Rapid Transit (BRT)',
    	    _HBWBRTT/100(10.0), _HBWBRTT_SABS, _HBWBRTT_SREL,
    			_HBCBRTT/100(10.0), _HBCBRTT_SABS, _HBCBRTT_SREL,
    			_HBOBRTT/100(10.0), _HBOBRTT_SABS, _HBOBRTT_SREL,
    			_NHBBRTT/100(10.0), _NHBBRTT_SABS, _NHBBRTT_SREL,
    			'-', '-', '-',
    			_TOTBRTT/100(10.0), _TOTBRTT_SABS, _TOTBRTT_SREL,
    
    	'\n                    BRT Walk', 
    	    _HBWBRTW/100(10.0), _HBWBRTW_SABS, _HBWBRTW_SREL,
    			_HBCBRTW/100(10.0), _HBCBRTW_SABS, _HBCBRTW_SREL,
    			_HBOBRTW/100(10.0), _HBOBRTW_SABS, _HBOBRTW_SREL,
    			_NHBBRTW/100(10.0), _NHBBRTW_SABS, _NHBBRTW_SREL,
    			'-', '-', '-',
    			_TOTBRTW/100(10.0), _TOTBRTW_SABS, _TOTBRTW_SREL,
    
    	'\n                    BRT Drive', 
    	    _HBWBRTD/100(10.0), _HBWBRTD_SABS, _HBWBRTD_SREL,
    			_HBCBRTD/100(10.0), _HBCBRTD_SABS, _HBCBRTD_SREL,
    			_HBOBRTD/100(10.0), _HBOBRTD_SABS, _HBOBRTD_SREL,
    			_NHBBRTD/100(10.0), _NHBBRTD_SABS, _NHBBRTD_SREL,	
    			'-', '-', '-',
    			_TOTBRTD/100(10.0), _TOTBRTD_SABS, _TOTBRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Express Bus (EXP)', 
    	    _HBWEXPT/100(10.0), _HBWEXPT_SABS, _HBWEXPT_SREL,
    			_HBCEXPT/100(10.0), _HBCEXPT_SABS, _HBCEXPT_SREL,
    			_HBOEXPT/100(10.0), _HBOEXPT_SABS, _HBOEXPT_SREL,
    			_NHBEXPT/100(10.0), _NHBEXPT_SABS, _NHBEXPT_SREL,
    			'-', '-', '-',
    			_TOTEXPT/100(10.0), _TOTEXPT_SABS, _TOTEXPT_SREL,
    
    	'\n                    EXP Walk', 
    	    _HBWEXPW/100(10.0), _HBWEXPW_SABS, _HBWEXPW_SREL,
    			_HBCEXPW/100(10.0), _HBCEXPW_SABS, _HBCEXPW_SREL,
    			_HBOEXPW/100(10.0), _HBOEXPW_SABS, _HBOEXPW_SREL,
    			_NHBEXPW/100(10.0), _NHBEXPW_SABS, _NHBEXPW_SREL,
    			'-', '-', '-',
    			_TOTEXPW/100(10.0), _TOTEXPW_SABS, _TOTEXPW_SREL,
    
    	'\n                    EXP Drive', 
    	    _HBWEXPD/100(10.0), _HBWEXPD_SABS, _HBWEXPD_SREL,
    			_HBCEXPD/100(10.0), _HBCEXPD_SABS, _HBCEXPD_SREL,
    			_HBOEXPD/100(10.0), _HBOEXPD_SABS, _HBOEXPD_SREL,
    			_NHBEXPD/100(10.0), _NHBEXPD_SABS, _NHBEXPD_SREL,
    			'-', '-', '-',
    			_TOTEXPD/100(10.0), _TOTEXPD_SABS, _TOTEXPD_SREL
    			
    		         
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Light-Rail Transit (LRT)', 
    	    _HBWLRTT/100(10.0), _HBWLRTT_SABS, _HBWLRTT_SREL,
    			_HBCLRTT/100(10.0), _HBCLRTT_SABS, _HBCLRTT_SREL,
    			_HBOLRTT/100(10.0), _HBOLRTT_SABS, _HBOLRTT_SREL,
    			_NHBLRTT/100(10.0), _NHBLRTT_SABS, _NHBLRTT_SREL,
    			'-', '-', '-',
    			_TOTLRTT/100(10.0), _TOTLRTT_SABS, _TOTLRTT_SREL,
    
    	'\n                    LRT Walk', 
    	    _HBWLRTW/100(10.0), _HBWLRTW_SABS, _HBWLRTW_SREL,
    			_HBCLRTW/100(10.0), _HBCLRTW_SABS, _HBCLRTW_SREL,
    			_HBOLRTW/100(10.0), _HBOLRTW_SABS, _HBOLRTW_SREL,
    			_NHBLRTW/100(10.0), _NHBLRTW_SABS, _NHBLRTW_SREL,
    			'-', '-', '-',
    			_TOTLRTW/100(10.0), _TOTLRTW_SABS, _TOTLRTW_SREL,
    
    	'\n                    LRT Drive', 
    	    _HBWLRTD/100(10.0), _HBWLRTD_SABS, _HBWLRTD_SREL,
    			_HBCLRTD/100(10.0), _HBCLRTD_SABS, _HBCLRTD_SREL,
    			_HBOLRTD/100(10.0), _HBOLRTD_SABS, _HBOLRTD_SREL,
    			_NHBLRTD/100(10.0), _NHBLRTD_SABS, _NHBLRTD_SREL,
    			'-', '-', '-',
    			_TOTLRTD/100(10.0), _TOTLRTD_SABS, _TOTLRTD_SREL
    			
    	
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n            4) Commuter-Rail Transit (CRT)', 
    	    _HBWCRTT/100(10.0), _HBWCRTT_SABS, _HBWCRTT_SREL,
    			_HBCCRTT/100(10.0), _HBCCRTT_SABS, _HBCCRTT_SREL,
    			_HBOCRTT/100(10.0), _HBOCRTT_SABS, _HBOCRTT_SREL,
    			_NHBCRTT/100(10.0), _NHBCRTT_SABS, _NHBCRTT_SREL,
    			'-', '-', '-',
    			_TOTCRTT/100(10.0), _TOTCRTT_SABS, _TOTCRTT_SREL,
    
    	'\n                    CRT Walk', 
    	    _HBWCRTW/100(10.0), _HBWCRTW_SABS, _HBWCRTW_SREL,
    			_HBCCRTW/100(10.0), _HBCCRTW_SABS, _HBCCRTW_SREL,
    			_HBOCRTW/100(10.0), _HBOCRTW_SABS, _HBOCRTW_SREL,
    			_NHBCRTW/100(10.0), _NHBCRTW_SABS, _NHBCRTW_SREL,
    			'-', '-', '-',
    			_TOTCRTW/100(10.0), _TOTCRTW_SABS, _TOTCRTW_SREL,
    
    	'\n                    CRT Drive', 
    	    _HBWCRTD/100(10.0), _HBWCRTD_SABS, _HBWCRTD_SREL,
    			_HBCCRTD/100(10.0), _HBCCRTD_SABS, _HBCCRTD_SREL,
    			_HBOCRTD/100(10.0), _HBOCRTD_SABS, _HBOCRTD_SREL,
    			_NHBCRTD/100(10.0), _NHBCRTD_SABS, _NHBCRTD_SREL,	
    			'-', '-', '-',
    			_TOTCRTD/100(10.0), _TOTCRTD_SABS, _TOTCRTD_SREL,	
      '\n  '
      
            
      PRINT CSV=T, FORM=7.2 FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_RegionShares_Daily.csv' LIST=
    	'\n   Run ID (RID card): @RID@', 
    	'\n   Socio-Economic year modeled:         @demographicyear@', 
    	'\n   Network infrastructure year modeled: @networkyear@',
    	'\n   Period the results apply to:  Daily (Peak and Off-Peak combined) Period',
    	'\n   Shares\@RID@_RegionShares_Daily.csv', 
    	'\n   For this run Mode Choice was run in its regular form (i.e. not bypassed with approximation).',
    	'\n   NOTE:  Indentations correspond with each level in the nested Logit choice model.'
      
    endif  ;i=zones
    
    ENDRUN
    
;Cluster: end of group distributed to processor 4
EndDistributeMULTISTEP




;Cluster: distrubute MATRIX call onto processor 5
DistributeMultiStep Alias='Shares_Proc5'
    
    ;calculate trips <=cutoff
    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - summary'
    FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Pk.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Pk.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Pk.mtx'
    FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Pk.mtx'
    
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Ok.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Ok.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Ok.mtx'
    FILEI MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Ok.mtx'
    
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
    
    FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    FILEI MATI[12] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Ok.mtx'
    
    
    FILEO MATO[01] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBW_trips_allsegs_Pk.mtx',
        mo=101-115,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[02] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBC_trips_allsegs_Pk.mtx',
        mo=201-215,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[03] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBO_trips_allsegs_Pk.mtx',
        mo=301-315,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[04] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_NHB_trips_allsegs_Pk.mtx',
        mo=401-415,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[05] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBW_trips_allsegs_Ok.mtx',
        mo=501-515,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[06] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBC_trips_allsegs_Ok.mtx',
        mo=601-615,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[07] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBO_trips_allsegs_Ok.mtx',
        mo=701-715,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[08] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_NHB_trips_allsegs_Ok.mtx',
        mo=801-815,
        name=walk, bike, auto,
             wLCL, wCOR, wEXP, wLRT, wCRT, wBRT,
             dLCL, dCOR, dEXP, dLRT, dCRT, dBRT
    
    FILEO MATO[09] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBSch_PR_ModeShare.mtx',
        mo=911-915, 931-935,
        name=Pk_SchoolBus, Pk_DriveSelf, Pk_DropOff, Pk_Walk, Pk_Bike,
             Ok_SchoolBus, Ok_DriveSelf, Ok_DropOff, Ok_Walk, Ok_Bike
    
    FILEO MATO[10] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBSch_SC_ModeShare.mtx',
        mo=921-925, 941-945,
        name=Pk_SchoolBus, Pk_DriveSelf, Pk_DropOff, Pk_Walk, Pk_Bike,
             Ok_SchoolBus, Ok_DriveSelf, Ok_DropOff, Ok_Walk, Ok_Bike
        
        
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
        ZONES = @UsedZones@
        ZONEMSG = 10
        
        
        
        ;assign working matrices for trips <=3 miles =========================================================
        JLOOP
            
            ;peak --------------------------------------------------------------------------------------------
            if (mi.11.dist_GP[j]<=@trip_cutoff@)
                
                ;HBW
                mw[101] = mi.01.walk[j]  
                mw[102] = mi.01.bike[j]  
                
                mw[103] = mi.01.auto[j]  
                
                mw[104] = mi.01.wLCL[j]  
                mw[105] = mi.01.wCOR[j]  
                mw[106] = mi.01.wEXP[j]  
                mw[107] = mi.01.wLRT[j]  
                mw[108] = mi.01.wCRT[j]  
                mw[109] = mi.01.wBRT[j]
                
                mw[110] = mi.01.dLCL[j]  
                mw[111] = mi.01.dCOR[j]  
                mw[112] = mi.01.dEXP[j]  
                mw[113] = mi.01.dLRT[j]  
                mw[114] = mi.01.dCRT[j]  
                mw[115] = mi.01.dBRT[j]
                
                
                ;HBC
                mw[201] = mi.02.walk[j]  
                mw[202] = mi.02.bike[j]  
                
                mw[203] = mi.02.auto[j]  
                
                mw[204] = mi.02.wLCL[j]  
                mw[205] = mi.02.wCOR[j]  
                mw[206] = mi.02.wEXP[j]  
                mw[207] = mi.02.wLRT[j]  
                mw[208] = mi.02.wCRT[j]  
                mw[209] = mi.02.wBRT[j]
                
                mw[210] = mi.02.dLCL[j]  
                mw[211] = mi.02.dCOR[j]  
                mw[212] = mi.02.dEXP[j]  
                mw[213] = mi.02.dLRT[j]  
                mw[214] = mi.02.dCRT[j]  
                mw[215] = mi.02.dBRT[j]
                
                
                ;HBO
                mw[301] = mi.03.walk[j]  
                mw[302] = mi.03.bike[j]  
                
                mw[303] = mi.03.auto[j]  
                
                mw[304] = mi.03.wLCL[j]  
                mw[305] = mi.03.wCOR[j]  
                mw[306] = mi.03.wEXP[j]  
                mw[307] = mi.03.wLRT[j]  
                mw[308] = mi.03.wCRT[j]  
                mw[309] = mi.03.wBRT[j]
                
                mw[310] = mi.03.dLCL[j]  
                mw[311] = mi.03.dCOR[j]  
                mw[312] = mi.03.dEXP[j]  
                mw[313] = mi.03.dLRT[j]  
                mw[314] = mi.03.dCRT[j]  
                mw[315] = mi.03.dBRT[j]
                
                
                ;NHB
                mw[401] = mi.04.walk[j]  
                mw[402] = mi.04.bike[j]  
                
                mw[403] = mi.04.auto[j]  
                
                mw[404] = mi.04.wLCL[j]  
                mw[405] = mi.04.wCOR[j]  
                mw[406] = mi.04.wEXP[j]  
                mw[407] = mi.04.wLRT[j]  
                mw[408] = mi.04.wCRT[j]  
                mw[409] = mi.04.wBRT[j]
                
                mw[410] = mi.04.dLCL[j]  
                mw[411] = mi.04.dCOR[j]  
                mw[412] = mi.04.dEXP[j]  
                mw[413] = mi.04.dLRT[j]  
                mw[414] = mi.04.dCRT[j]  
                mw[415] = mi.04.dBRT[j]
                
                
                ;HBS - Primary
                mw[911] = mi.09.Pk_SchoolBus[j]
                mw[912] = mi.09.Pk_DriveSelf[j]
                mw[913] = mi.09.Pk_DropOff[j]
                mw[914] = mi.09.Pk_Walk[j]
                mw[915] = mi.09.Pk_Bike[j]
                
                ;HBS - Secondary
                mw[921] = mi.10.Pk_SchoolBus[j]
                mw[922] = mi.10.Pk_DriveSelf[j]
                mw[923] = mi.10.Pk_DropOff[j]
                mw[924] = mi.10.Pk_Walk[j]
                mw[925] = mi.10.Pk_Bike[j]
                
            endif  ;mi.11.dist_GP[j]<=@trip_cutoff@
                        
            
            ;off peak ----------------------------------------------------------------------------------------
            if (mi.12.dist_GP[j]<=@trip_cutoff@)
                
                ;HBW
                mw[501] = mi.05.walk[j]  
                mw[502] = mi.05.bike[j]  
                
                mw[503] = mi.05.auto[j]  
                
                mw[504] = mi.05.wLCL[j]  
                mw[505] = mi.05.wCOR[j]  
                mw[506] = mi.05.wEXP[j]  
                mw[507] = mi.05.wLRT[j]  
                mw[508] = mi.05.wCRT[j]  
                mw[509] = mi.05.wBRT[j]
                
                mw[510] = mi.05.dLCL[j]  
                mw[511] = mi.05.dCOR[j]  
                mw[512] = mi.05.dEXP[j]  
                mw[513] = mi.05.dLRT[j]  
                mw[514] = mi.05.dCRT[j]  
                mw[515] = mi.05.dBRT[j]
                
                
                ;HBC
                mw[601] = mi.06.walk[j]  
                mw[602] = mi.06.bike[j]  
                
                mw[603] = mi.06.auto[j]  
                
                mw[604] = mi.06.wLCL[j]  
                mw[605] = mi.06.wCOR[j]  
                mw[606] = mi.06.wEXP[j]  
                mw[607] = mi.06.wLRT[j]  
                mw[608] = mi.06.wCRT[j]  
                mw[609] = mi.06.wBRT[j]
                
                mw[610] = mi.06.dLCL[j]  
                mw[611] = mi.06.dCOR[j]  
                mw[612] = mi.06.dEXP[j]  
                mw[613] = mi.06.dLRT[j]  
                mw[614] = mi.06.dCRT[j]  
                mw[615] = mi.06.dBRT[j]
                
                
                ;HBO
                mw[701] = mi.07.walk[j]  
                mw[702] = mi.07.bike[j]  
                
                mw[703] = mi.07.auto[j]  
                
                mw[704] = mi.07.wLCL[j]  
                mw[705] = mi.07.wCOR[j]  
                mw[706] = mi.07.wEXP[j]  
                mw[707] = mi.07.wLRT[j]  
                mw[708] = mi.07.wCRT[j]  
                mw[709] = mi.07.wBRT[j]
                
                mw[710] = mi.07.dLCL[j]  
                mw[711] = mi.07.dCOR[j]  
                mw[712] = mi.07.dEXP[j]  
                mw[713] = mi.07.dLRT[j]  
                mw[714] = mi.07.dCRT[j]  
                mw[715] = mi.07.dBRT[j]
                
                
                ;NHB
                mw[801] = mi.08.walk[j]  
                mw[802] = mi.08.bike[j]  
                
                mw[803] = mi.08.auto[j]  
                
                mw[804] = mi.08.wLCL[j]  
                mw[805] = mi.08.wCOR[j]  
                mw[806] = mi.08.wEXP[j]  
                mw[807] = mi.08.wLRT[j]  
                mw[808] = mi.08.wCRT[j]  
                mw[809] = mi.08.wBRT[j]
                
                mw[810] = mi.08.dLCL[j]  
                mw[811] = mi.08.dCOR[j]  
                mw[812] = mi.08.dEXP[j]  
                mw[813] = mi.08.dLRT[j]  
                mw[814] = mi.08.dCRT[j]  
                mw[815] = mi.08.dBRT[j]
                
                
                ;HBS - Primary
                mw[931] = mi.09.Ok_SchoolBus[j]
                mw[932] = mi.09.Ok_DriveSelf[j]
                mw[933] = mi.09.Ok_DropOff[j]
                mw[934] = mi.09.Ok_Walk[j]
                mw[935] = mi.09.Ok_Bike[j]
                
                ;HBS - Secondary
                mw[941] = mi.10.Ok_SchoolBus[j]
                mw[942] = mi.10.Ok_DriveSelf[j]
                mw[943] = mi.10.Ok_DropOff[j]
                mw[944] = mi.10.Ok_Walk[j]
                mw[945] = mi.10.Ok_Bike[j]
            endif  ;mi.12.dist_GP[j]<=@trip_cutoff@
            
        ENDJLOOP
        
    ENDRUN
    
    
    ;calculate specialized mode share summary report
    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - summary - LT@trip_cutoff@mi'
    FILEI MATI[01] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBW_trips_allsegs_Pk.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBC_trips_allsegs_Pk.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBO_trips_allsegs_Pk.mtx'
    FILEI MATI[04] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_NHB_trips_allsegs_Pk.mtx'
    
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBW_trips_allsegs_Ok.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBC_trips_allsegs_Ok.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBO_trips_allsegs_Ok.mtx'
    FILEI MATI[08] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_NHB_trips_allsegs_Ok.mtx'
    
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBSch_PR_ModeShare.mtx'
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\LT@trip_cutoff@mi_HBSch_SC_ModeShare.mtx'
    
    
        ZONES = @UsedZones@
        ZONEMSG = 10
        
        
        ;read in working matrices ============================================================================
        ;peak ------------------------------------------------------------------------------------------------
        ;HBW
        mw[101] = mi.01.walk / 100
        mw[102] = mi.01.bike / 100
        mw[103] = mi.01.auto / 100
        mw[104] = mi.01.wLCL / 100
        mw[105] = mi.01.dLCL / 100
        mw[106] = mi.01.wCOR / 100
        mw[107] = mi.01.dCOR / 100
        mw[108] = mi.01.wBRT / 100
        mw[109] = mi.01.dBRT / 100
        mw[110] = mi.01.wEXP / 100
        mw[111] = mi.01.dEXP / 100
        mw[112] = mi.01.wLRT / 100
        mw[113] = mi.01.dLRT / 100
        mw[114] = mi.01.wCRT / 100
        mw[115] = mi.01.dCRT / 100
        
        ;HBC
        mw[201] = mi.02.walk / 100
        mw[202] = mi.02.bike / 100
        mw[203] = mi.02.auto / 100
        mw[204] = mi.02.wLCL / 100
        mw[205] = mi.02.dLCL / 100
        mw[206] = mi.02.wCOR / 100
        mw[207] = mi.02.dCOR / 100
        mw[208] = mi.02.wBRT / 100
        mw[209] = mi.02.dBRT / 100
        mw[210] = mi.02.wEXP / 100
        mw[211] = mi.02.dEXP / 100
        mw[212] = mi.02.wLRT / 100
        mw[213] = mi.02.dLRT / 100
        mw[214] = mi.02.wCRT / 100
        mw[215] = mi.02.dCRT / 100
        
        ;HBO
        mw[301] = mi.03.walk / 100
        mw[302] = mi.03.bike / 100
        mw[303] = mi.03.auto / 100
        mw[304] = mi.03.wLCL / 100
        mw[305] = mi.03.dLCL / 100
        mw[306] = mi.03.wCOR / 100
        mw[307] = mi.03.dCOR / 100
        mw[308] = mi.03.wBRT / 100
        mw[309] = mi.03.dBRT / 100
        mw[310] = mi.03.wEXP / 100
        mw[311] = mi.03.dEXP / 100
        mw[312] = mi.03.wLRT / 100
        mw[313] = mi.03.dLRT / 100
        mw[314] = mi.03.wCRT / 100
        mw[315] = mi.03.dCRT / 100
        
        ;NHB
        mw[401] = mi.04.walk / 100
        mw[402] = mi.04.bike / 100
        mw[403] = mi.04.auto / 100
        mw[404] = mi.04.wLCL / 100
        mw[405] = mi.04.dLCL / 100
        mw[406] = mi.04.wCOR / 100
        mw[407] = mi.04.dCOR / 100
        mw[408] = mi.04.wBRT / 100
        mw[409] = mi.04.dBRT / 100
        mw[410] = mi.04.wEXP / 100
        mw[411] = mi.04.dEXP / 100
        mw[412] = mi.04.wLRT / 100
        mw[413] = mi.04.dLRT / 100
        mw[414] = mi.04.wCRT / 100
        mw[415] = mi.04.dCRT / 100
        
        ;HBS - Primary
        mw[911] = mi.09.Pk_SchoolBus
        mw[912] = mi.09.Pk_DriveSelf
        mw[913] = mi.09.Pk_DropOff
        mw[914] = mi.09.Pk_Walk
        mw[915] = mi.09.Pk_Bike
        
        ;HBS - Secondary
        mw[921] = mi.10.Pk_SchoolBus
        mw[922] = mi.10.Pk_DriveSelf
        mw[923] = mi.10.Pk_DropOff
        mw[924] = mi.10.Pk_Walk
        mw[925] = mi.10.Pk_Bike
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        ;HBW
        mw[501] = mi.05.walk / 100
        mw[502] = mi.05.bike / 100
        mw[503] = mi.05.auto / 100
        mw[504] = mi.05.wLCL / 100
        mw[505] = mi.05.dLCL / 100
        mw[506] = mi.05.wCOR / 100
        mw[507] = mi.05.dCOR / 100
        mw[508] = mi.05.wBRT / 100
        mw[509] = mi.05.dBRT / 100
        mw[510] = mi.05.wEXP / 100
        mw[511] = mi.05.dEXP / 100
        mw[512] = mi.05.wLRT / 100
        mw[513] = mi.05.dLRT / 100
        mw[514] = mi.05.wCRT / 100
        mw[515] = mi.05.dCRT / 100
        
        ;HBC
        mw[601] = mi.06.walk / 100
        mw[602] = mi.06.bike / 100
        mw[603] = mi.06.auto / 100
        mw[604] = mi.06.wLCL / 100
        mw[605] = mi.06.dLCL / 100
        mw[606] = mi.06.wCOR / 100
        mw[607] = mi.06.dCOR / 100
        mw[608] = mi.06.wBRT / 100
        mw[609] = mi.06.dBRT / 100
        mw[610] = mi.06.wEXP / 100
        mw[611] = mi.06.dEXP / 100
        mw[612] = mi.06.wLRT / 100
        mw[613] = mi.06.dLRT / 100
        mw[614] = mi.06.wCRT / 100
        mw[615] = mi.06.dCRT / 100
        
        ;HBO
        mw[701] = mi.07.walk / 100
        mw[702] = mi.07.bike / 100
        mw[703] = mi.07.auto / 100
        mw[704] = mi.07.wLCL / 100
        mw[705] = mi.07.dLCL / 100
        mw[706] = mi.07.wCOR / 100
        mw[707] = mi.07.dCOR / 100
        mw[708] = mi.07.wBRT / 100
        mw[709] = mi.07.dBRT / 100
        mw[710] = mi.07.wEXP / 100
        mw[711] = mi.07.dEXP / 100
        mw[712] = mi.07.wLRT / 100
        mw[713] = mi.07.dLRT / 100
        mw[714] = mi.07.wCRT / 100
        mw[715] = mi.07.dCRT / 100
        
        ;NHB
        mw[801] = mi.08.walk / 100
        mw[802] = mi.08.bike / 100
        mw[803] = mi.08.auto / 100
        mw[804] = mi.08.wLCL / 100
        mw[805] = mi.08.dLCL / 100
        mw[806] = mi.08.wCOR / 100
        mw[807] = mi.08.dCOR / 100
        mw[808] = mi.08.wBRT / 100
        mw[809] = mi.08.dBRT / 100
        mw[810] = mi.08.wEXP / 100
        mw[811] = mi.08.dEXP / 100
        mw[812] = mi.08.wLRT / 100
        mw[813] = mi.08.dLRT / 100
        mw[814] = mi.08.wCRT / 100
        mw[815] = mi.08.dCRT / 100
        
        ;HBS - Primary
        mw[931] = mi.09.Ok_SchoolBus
        mw[932] = mi.09.Ok_DriveSelf
        mw[933] = mi.09.Ok_DropOff
        mw[934] = mi.09.Ok_Walk
        mw[935] = mi.09.Ok_Bike
        
        ;HBS - Secondary
        mw[941] = mi.10.Ok_SchoolBus
        mw[942] = mi.10.Ok_DriveSelf
        mw[943] = mi.10.Ok_DropOff
        mw[944] = mi.10.Ok_Walk
        mw[945] = mi.10.Ok_Bike
        
        
        
        ;summarize working matrices ==========================================================================
        ;peak ------------------------------------------------------------------------------------------------
        Pk_HBW_walk = Pk_HBW_walk + ROWSUM(101)
        Pk_HBW_bike = Pk_HBW_bike + ROWSUM(102)
        Pk_HBW_auto = Pk_HBW_auto + ROWSUM(103)
        Pk_HBW_wLCL = Pk_HBW_wLCL + ROWSUM(104)
        Pk_HBW_dLCL = Pk_HBW_dLCL + ROWSUM(105)
        Pk_HBW_wCOR = Pk_HBW_wCOR + ROWSUM(106)
        Pk_HBW_dCOR = Pk_HBW_dCOR + ROWSUM(107)
        Pk_HBW_wBRT = Pk_HBW_wBRT + ROWSUM(108)
        Pk_HBW_dBRT = Pk_HBW_dBRT + ROWSUM(109)
        Pk_HBW_wEXP = Pk_HBW_wEXP + ROWSUM(110)
        Pk_HBW_dEXP = Pk_HBW_dEXP + ROWSUM(111)
        Pk_HBW_wLRT = Pk_HBW_wLRT + ROWSUM(112)
        Pk_HBW_dLRT = Pk_HBW_dLRT + ROWSUM(113)
        Pk_HBW_wCRT = Pk_HBW_wCRT + ROWSUM(114)
        Pk_HBW_dCRT = Pk_HBW_dCRT + ROWSUM(115)
        
        Pk_HBC_walk = Pk_HBC_walk + ROWSUM(201)
        Pk_HBC_bike = Pk_HBC_bike + ROWSUM(202)
        Pk_HBC_auto = Pk_HBC_auto + ROWSUM(203)
        Pk_HBC_wLCL = Pk_HBC_wLCL + ROWSUM(204)
        Pk_HBC_dLCL = Pk_HBC_dLCL + ROWSUM(205)
        Pk_HBC_wCOR = Pk_HBC_wCOR + ROWSUM(206)
        Pk_HBC_dCOR = Pk_HBC_dCOR + ROWSUM(207)
        Pk_HBC_wBRT = Pk_HBC_wBRT + ROWSUM(208)
        Pk_HBC_dBRT = Pk_HBC_dBRT + ROWSUM(209)
        Pk_HBC_wEXP = Pk_HBC_wEXP + ROWSUM(210)
        Pk_HBC_dEXP = Pk_HBC_dEXP + ROWSUM(211)
        Pk_HBC_wLRT = Pk_HBC_wLRT + ROWSUM(212)
        Pk_HBC_dLRT = Pk_HBC_dLRT + ROWSUM(213)
        Pk_HBC_wCRT = Pk_HBC_wCRT + ROWSUM(214)
        Pk_HBC_dCRT = Pk_HBC_dCRT + ROWSUM(215)
        
        Pk_HBO_walk = Pk_HBO_walk + ROWSUM(301)
        Pk_HBO_bike = Pk_HBO_bike + ROWSUM(302)
        Pk_HBO_auto = Pk_HBO_auto + ROWSUM(303)
        Pk_HBO_wLCL = Pk_HBO_wLCL + ROWSUM(304)
        Pk_HBO_dLCL = Pk_HBO_dLCL + ROWSUM(305)
        Pk_HBO_wCOR = Pk_HBO_wCOR + ROWSUM(306)
        Pk_HBO_dCOR = Pk_HBO_dCOR + ROWSUM(307)
        Pk_HBO_wBRT = Pk_HBO_wBRT + ROWSUM(308)
        Pk_HBO_dBRT = Pk_HBO_dBRT + ROWSUM(309)
        Pk_HBO_wEXP = Pk_HBO_wEXP + ROWSUM(310)
        Pk_HBO_dEXP = Pk_HBO_dEXP + ROWSUM(311)
        Pk_HBO_wLRT = Pk_HBO_wLRT + ROWSUM(312)
        Pk_HBO_dLRT = Pk_HBO_dLRT + ROWSUM(313)
        Pk_HBO_wCRT = Pk_HBO_wCRT + ROWSUM(314)
        Pk_HBO_dCRT = Pk_HBO_dCRT + ROWSUM(315)
        
        Pk_NHB_walk = Pk_NHB_walk + ROWSUM(401)
        Pk_NHB_bike = Pk_NHB_bike + ROWSUM(402)
        Pk_NHB_auto = Pk_NHB_auto + ROWSUM(403)
        Pk_NHB_wLCL = Pk_NHB_wLCL + ROWSUM(404)
        Pk_NHB_dLCL = Pk_NHB_dLCL + ROWSUM(405)
        Pk_NHB_wCOR = Pk_NHB_wCOR + ROWSUM(406)
        Pk_NHB_dCOR = Pk_NHB_dCOR + ROWSUM(407)
        Pk_NHB_wBRT = Pk_NHB_wBRT + ROWSUM(408)
        Pk_NHB_dBRT = Pk_NHB_dBRT + ROWSUM(409)
        Pk_NHB_wEXP = Pk_NHB_wEXP + ROWSUM(410)
        Pk_NHB_dEXP = Pk_NHB_dEXP + ROWSUM(411)
        Pk_NHB_wLRT = Pk_NHB_wLRT + ROWSUM(412)
        Pk_NHB_dLRT = Pk_NHB_dLRT + ROWSUM(413)
        Pk_NHB_wCRT = Pk_NHB_wCRT + ROWSUM(414)
        Pk_NHB_dCRT = Pk_NHB_dCRT + ROWSUM(415)
        
        Pk_HBSPr_SchoolBus = Pk_HBSPr_SchoolBus + ROWSUM(911)
        Pk_HBSPr_DriveSelf = Pk_HBSPr_DriveSelf + ROWSUM(912)
        Pk_HBSPr_DropOff   = Pk_HBSPr_DropOff   + ROWSUM(913)
        Pk_HBSPr_Walk      = Pk_HBSPr_Walk      + ROWSUM(914)
        Pk_HBSPr_Bike      = Pk_HBSPr_Bike      + ROWSUM(915)
        
        Pk_HBSSc_SchoolBus = Pk_HBSSc_SchoolBus + ROWSUM(921)
        Pk_HBSSc_DriveSelf = Pk_HBSSc_DriveSelf + ROWSUM(922)
        Pk_HBSSc_DropOff   = Pk_HBSSc_DropOff   + ROWSUM(923)
        Pk_HBSSc_Walk      = Pk_HBSSc_Walk      + ROWSUM(924)
        Pk_HBSSc_Bike      = Pk_HBSSc_Bike      + ROWSUM(925)
        
        Pk_HBS_wLCL      = 0
        Pk_HBS_dLCL      = 0
        Pk_HBS_wCOR      = 0
        Pk_HBS_dCOR      = 0
        Pk_HBS_wBRT      = 0
        Pk_HBS_dBRT      = 0
        Pk_HBS_wEXP      = 0
        Pk_HBS_dEXP      = 0
        Pk_HBS_wLRT      = 0
        Pk_HBS_dLRT      = 0
        Pk_HBS_wCRT      = 0
        Pk_HBS_dCRT      = 0
        
        Pk_HBW_SchoolBus = 0
        Pk_HBC_SchoolBus = 0
        Pk_HBO_SchoolBus = 0
        Pk_NHB_SchoolBus = 0
        
        Pk_HBS_Walk      = Pk_HBSPr_Walk +
                           Pk_HBSSc_Walk 
        
        Pk_HBS_Bike      = Pk_HBSPr_Bike +
                           Pk_HBSSc_Bike
        
        Pk_HBS_Auto      = Pk_HBSPr_DriveSelf +
                           Pk_HBSPr_DropOff   +
                           Pk_HBSSc_DriveSelf +
                           Pk_HBSSc_DropOff  
        
        Pk_HBS_SchoolBus = Pk_HBSPr_SchoolBus +
                           Pk_HBSSc_SchoolBus
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        Ok_HBW_walk = Ok_HBW_walk + ROWSUM(501)
        Ok_HBW_bike = Ok_HBW_bike + ROWSUM(502)
        Ok_HBW_auto = Ok_HBW_auto + ROWSUM(503)
        Ok_HBW_wLCL = Ok_HBW_wLCL + ROWSUM(504)
        Ok_HBW_dLCL = Ok_HBW_dLCL + ROWSUM(505)
        Ok_HBW_wCOR = Ok_HBW_wCOR + ROWSUM(506)
        Ok_HBW_dCOR = Ok_HBW_dCOR + ROWSUM(507)
        Ok_HBW_wBRT = Ok_HBW_wBRT + ROWSUM(508)
        Ok_HBW_dBRT = Ok_HBW_dBRT + ROWSUM(509)
        Ok_HBW_wEXP = Ok_HBW_wEXP + ROWSUM(510)
        Ok_HBW_dEXP = Ok_HBW_dEXP + ROWSUM(511)
        Ok_HBW_wLRT = Ok_HBW_wLRT + ROWSUM(512)
        Ok_HBW_dLRT = Ok_HBW_dLRT + ROWSUM(513)
        Ok_HBW_wCRT = Ok_HBW_wCRT + ROWSUM(514)
        Ok_HBW_dCRT = Ok_HBW_dCRT + ROWSUM(515)
        
        Ok_HBC_walk = Ok_HBC_walk + ROWSUM(601)
        Ok_HBC_bike = Ok_HBC_bike + ROWSUM(602)
        Ok_HBC_auto = Ok_HBC_auto + ROWSUM(603)
        Ok_HBC_wLCL = Ok_HBC_wLCL + ROWSUM(604)
        Ok_HBC_dLCL = Ok_HBC_dLCL + ROWSUM(605)
        Ok_HBC_wCOR = Ok_HBC_wCOR + ROWSUM(606)
        Ok_HBC_dCOR = Ok_HBC_dCOR + ROWSUM(607)
        Ok_HBC_wBRT = Ok_HBC_wBRT + ROWSUM(608)
        Ok_HBC_dBRT = Ok_HBC_dBRT + ROWSUM(609)
        Ok_HBC_wEXP = Ok_HBC_wEXP + ROWSUM(610)
        Ok_HBC_dEXP = Ok_HBC_dEXP + ROWSUM(611)
        Ok_HBC_wLRT = Ok_HBC_wLRT + ROWSUM(612)
        Ok_HBC_dLRT = Ok_HBC_dLRT + ROWSUM(613)
        Ok_HBC_wCRT = Ok_HBC_wCRT + ROWSUM(614)
        Ok_HBC_dCRT = Ok_HBC_dCRT + ROWSUM(615)
        
        Ok_HBO_walk = Ok_HBO_walk + ROWSUM(701)
        Ok_HBO_bike = Ok_HBO_bike + ROWSUM(702)
        Ok_HBO_auto = Ok_HBO_auto + ROWSUM(703)
        Ok_HBO_wLCL = Ok_HBO_wLCL + ROWSUM(704)
        Ok_HBO_dLCL = Ok_HBO_dLCL + ROWSUM(705)
        Ok_HBO_wCOR = Ok_HBO_wCOR + ROWSUM(706)
        Ok_HBO_dCOR = Ok_HBO_dCOR + ROWSUM(707)
        Ok_HBO_wBRT = Ok_HBO_wBRT + ROWSUM(708)
        Ok_HBO_dBRT = Ok_HBO_dBRT + ROWSUM(709)
        Ok_HBO_wEXP = Ok_HBO_wEXP + ROWSUM(710)
        Ok_HBO_dEXP = Ok_HBO_dEXP + ROWSUM(711)
        Ok_HBO_wLRT = Ok_HBO_wLRT + ROWSUM(712)
        Ok_HBO_dLRT = Ok_HBO_dLRT + ROWSUM(713)
        Ok_HBO_wCRT = Ok_HBO_wCRT + ROWSUM(714)
        Ok_HBO_dCRT = Ok_HBO_dCRT + ROWSUM(715)
        
        Ok_NHB_walk = Ok_NHB_walk + ROWSUM(801)
        Ok_NHB_bike = Ok_NHB_bike + ROWSUM(802)
        Ok_NHB_auto = Ok_NHB_auto + ROWSUM(803)
        Ok_NHB_wLCL = Ok_NHB_wLCL + ROWSUM(804)
        Ok_NHB_dLCL = Ok_NHB_dLCL + ROWSUM(805)
        Ok_NHB_wCOR = Ok_NHB_wCOR + ROWSUM(806)
        Ok_NHB_dCOR = Ok_NHB_dCOR + ROWSUM(807)
        Ok_NHB_wBRT = Ok_NHB_wBRT + ROWSUM(808)
        Ok_NHB_dBRT = Ok_NHB_dBRT + ROWSUM(809)
        Ok_NHB_wEXP = Ok_NHB_wEXP + ROWSUM(810)
        Ok_NHB_dEXP = Ok_NHB_dEXP + ROWSUM(811)
        Ok_NHB_wLRT = Ok_NHB_wLRT + ROWSUM(812)
        Ok_NHB_dLRT = Ok_NHB_dLRT + ROWSUM(813)
        Ok_NHB_wCRT = Ok_NHB_wCRT + ROWSUM(814)
        Ok_NHB_dCRT = Ok_NHB_dCRT + ROWSUM(815)
        
        Ok_HBSPr_SchoolBus = Ok_HBSPr_SchoolBus + ROWSUM(931)
        Ok_HBSPr_DriveSelf = Ok_HBSPr_DriveSelf + ROWSUM(932)
        Ok_HBSPr_DropOff   = Ok_HBSPr_DropOff   + ROWSUM(933)
        Ok_HBSPr_Walk      = Ok_HBSPr_Walk      + ROWSUM(934)
        Ok_HBSPr_Bike      = Ok_HBSPr_Bike      + ROWSUM(935)
        
        Ok_HBSSc_SchoolBus = Ok_HBSSc_SchoolBus + ROWSUM(941)
        Ok_HBSSc_DriveSelf = Ok_HBSSc_DriveSelf + ROWSUM(942)
        Ok_HBSSc_DropOff   = Ok_HBSSc_DropOff   + ROWSUM(943)
        Ok_HBSSc_Walk      = Ok_HBSSc_Walk      + ROWSUM(944)
        Ok_HBSSc_Bike      = Ok_HBSSc_Bike      + ROWSUM(945)
        
        Ok_HBS_wLCL      = 0
        Ok_HBS_dLCL      = 0
        Ok_HBS_wCOR      = 0
        Ok_HBS_dCOR      = 0
        Ok_HBS_wBRT      = 0
        Ok_HBS_dBRT      = 0
        Ok_HBS_wEXP      = 0
        Ok_HBS_dEXP      = 0
        Ok_HBS_wLRT      = 0
        Ok_HBS_dLRT      = 0
        Ok_HBS_wCRT      = 0
        Ok_HBS_dCRT      = 0
        
        Ok_HBW_SchoolBus = 0
        Ok_HBC_SchoolBus = 0
        Ok_HBO_SchoolBus = 0
        Ok_NHB_SchoolBus = 0
        
        Ok_HBS_Walk      = Ok_HBSPr_Walk +
                           Ok_HBSSc_Walk 
        
        Ok_HBS_Bike      = Ok_HBSPr_Bike +
                           Ok_HBSSc_Bike
        
        Ok_HBS_Auto      = Ok_HBSPr_DriveSelf +
                           Ok_HBSPr_DropOff   +
                           Ok_HBSSc_DriveSelf +
                           Ok_HBSSc_DropOff  
        
        Ok_HBS_SchoolBus = Ok_HBSPr_SchoolBus +
                           Ok_HBSSc_SchoolBus
        
        
        
        ;calculate trip totals ===============================================================================
        ;peak ------------------------------------------------------------------------------------------------
        Pk_HBW_NonMoto   =  Pk_HBW_walk  +  Pk_HBW_bike
        Pk_HBC_NonMoto   =  Pk_HBC_walk  +  Pk_HBC_bike
        Pk_HBO_NonMoto   =  Pk_HBO_walk  +  Pk_HBO_bike
        Pk_NHB_NonMoto   =  Pk_NHB_walk  +  Pk_NHB_bike
        Pk_HBS_NonMoto   =  Pk_HBS_Walk  +  Pk_HBS_Bike
        
        Pk_HBW_LCL       =  Pk_HBW_wLCL  +  Pk_HBW_dLCL
        Pk_HBC_LCL       =  Pk_HBC_wLCL  +  Pk_HBC_dLCL
        Pk_HBO_LCL       =  Pk_HBO_wLCL  +  Pk_HBO_dLCL
        Pk_NHB_LCL       =  Pk_NHB_wLCL  +  Pk_NHB_dLCL
        Pk_HBS_LCL       =  Pk_HBS_wLCL  +  Pk_HBS_dLCL
        
        Pk_HBW_COR       =  Pk_HBW_wCOR  +  Pk_HBW_dCOR
        Pk_HBC_COR       =  Pk_HBC_wCOR  +  Pk_HBC_dCOR
        Pk_HBO_COR       =  Pk_HBO_wCOR  +  Pk_HBO_dCOR
        Pk_NHB_COR       =  Pk_NHB_wCOR  +  Pk_NHB_dCOR
        Pk_HBS_COR       =  Pk_HBS_wCOR  +  Pk_HBS_dCOR
        
        Pk_HBW_BRT       =  Pk_HBW_wBRT  +  Pk_HBW_dBRT
        Pk_HBC_BRT       =  Pk_HBC_wBRT  +  Pk_HBC_dBRT
        Pk_HBO_BRT       =  Pk_HBO_wBRT  +  Pk_HBO_dBRT
        Pk_NHB_BRT       =  Pk_NHB_wBRT  +  Pk_NHB_dBRT
        Pk_HBS_BRT       =  Pk_HBS_wBRT  +  Pk_HBS_dBRT
        
        Pk_HBW_EXP       =  Pk_HBW_wEXP  +  Pk_HBW_dEXP
        Pk_HBC_EXP       =  Pk_HBC_wEXP  +  Pk_HBC_dEXP
        Pk_HBO_EXP       =  Pk_HBO_wEXP  +  Pk_HBO_dEXP
        Pk_NHB_EXP       =  Pk_NHB_wEXP  +  Pk_NHB_dEXP
        Pk_HBS_EXP       =  Pk_HBS_wEXP  +  Pk_HBS_dEXP
        
        Pk_HBW_LRT       =  Pk_HBW_wLRT  +  Pk_HBW_dLRT
        Pk_HBC_LRT       =  Pk_HBC_wLRT  +  Pk_HBC_dLRT
        Pk_HBO_LRT       =  Pk_HBO_wLRT  +  Pk_HBO_dLRT
        Pk_NHB_LRT       =  Pk_NHB_wLRT  +  Pk_NHB_dLRT
        Pk_HBS_LRT       =  Pk_HBS_wLRT  +  Pk_HBS_dLRT
        
        Pk_HBW_CRT       =  Pk_HBW_wCRT  +  Pk_HBW_dCRT
        Pk_HBC_CRT       =  Pk_HBC_wCRT  +  Pk_HBC_dCRT
        Pk_HBO_CRT       =  Pk_HBO_wCRT  +  Pk_HBO_dCRT
        Pk_NHB_CRT       =  Pk_NHB_wCRT  +  Pk_NHB_dCRT
        Pk_HBS_CRT       =  Pk_HBS_wCRT  +  Pk_HBS_dCRT
        
        Pk_HBW_Transit   =  Pk_HBW_LCL  +  Pk_HBW_COR  +  Pk_HBW_BRT  +  Pk_HBW_EXP  +  Pk_HBW_LRT   +  Pk_HBW_CRT
        Pk_HBC_Transit   =  Pk_HBC_LCL  +  Pk_HBC_COR  +  Pk_HBC_BRT  +  Pk_HBC_EXP  +  Pk_HBC_LRT   +  Pk_HBC_CRT
        Pk_HBO_Transit   =  Pk_HBO_LCL  +  Pk_HBO_COR  +  Pk_HBO_BRT  +  Pk_HBO_EXP  +  Pk_HBO_LRT   +  Pk_HBO_CRT
        Pk_NHB_Transit   =  Pk_NHB_LCL  +  Pk_NHB_COR  +  Pk_NHB_BRT  +  Pk_NHB_EXP  +  Pk_NHB_LRT   +  Pk_NHB_CRT
        Pk_HBS_Transit   =  Pk_HBS_LCL  +  Pk_HBS_COR  +  Pk_HBS_BRT  +  Pk_HBS_EXP  +  Pk_HBS_LRT   +  Pk_HBS_CRT
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        Ok_HBW_NonMoto   =  Ok_HBW_walk  +  Ok_HBW_bike
        Ok_HBC_NonMoto   =  Ok_HBC_walk  +  Ok_HBC_bike
        Ok_HBO_NonMoto   =  Ok_HBO_walk  +  Ok_HBO_bike
        Ok_NHB_NonMoto   =  Ok_NHB_walk  +  Ok_NHB_bike
        Ok_HBS_NonMoto   =  Ok_HBS_Walk  +  Ok_HBS_Bike
        
        Ok_HBW_LCL       =  Ok_HBW_wLCL  +  Ok_HBW_dLCL
        Ok_HBC_LCL       =  Ok_HBC_wLCL  +  Ok_HBC_dLCL
        Ok_HBO_LCL       =  Ok_HBO_wLCL  +  Ok_HBO_dLCL
        Ok_NHB_LCL       =  Ok_NHB_wLCL  +  Ok_NHB_dLCL
        Ok_HBS_LCL       =  Ok_HBS_wLCL  +  Ok_HBS_dLCL
        
        Ok_HBW_COR       =  Ok_HBW_wCOR  +  Ok_HBW_dCOR
        Ok_HBC_COR       =  Ok_HBC_wCOR  +  Ok_HBC_dCOR
        Ok_HBO_COR       =  Ok_HBO_wCOR  +  Ok_HBO_dCOR
        Ok_NHB_COR       =  Ok_NHB_wCOR  +  Ok_NHB_dCOR
        Ok_HBS_COR       =  Ok_HBS_wCOR  +  Ok_HBS_dCOR
        
        Ok_HBW_BRT       =  Ok_HBW_wBRT  +  Ok_HBW_dBRT
        Ok_HBC_BRT       =  Ok_HBC_wBRT  +  Ok_HBC_dBRT
        Ok_HBO_BRT       =  Ok_HBO_wBRT  +  Ok_HBO_dBRT
        Ok_NHB_BRT       =  Ok_NHB_wBRT  +  Ok_NHB_dBRT
        Ok_HBS_BRT       =  Ok_HBS_wBRT  +  Ok_HBS_dBRT
        
        Ok_HBW_EXP       =  Ok_HBW_wEXP  +  Ok_HBW_dEXP
        Ok_HBC_EXP       =  Ok_HBC_wEXP  +  Ok_HBC_dEXP
        Ok_HBO_EXP       =  Ok_HBO_wEXP  +  Ok_HBO_dEXP
        Ok_NHB_EXP       =  Ok_NHB_wEXP  +  Ok_NHB_dEXP
        Ok_HBS_EXP       =  Ok_HBS_wEXP  +  Ok_HBS_dEXP
        
        Ok_HBW_LRT       =  Ok_HBW_wLRT  +  Ok_HBW_dLRT
        Ok_HBC_LRT       =  Ok_HBC_wLRT  +  Ok_HBC_dLRT
        Ok_HBO_LRT       =  Ok_HBO_wLRT  +  Ok_HBO_dLRT
        Ok_NHB_LRT       =  Ok_NHB_wLRT  +  Ok_NHB_dLRT
        Ok_HBS_LRT       =  Ok_HBS_wLRT  +  Ok_HBS_dLRT
        
        Ok_HBW_CRT       =  Ok_HBW_wCRT  +  Ok_HBW_dCRT
        Ok_HBC_CRT       =  Ok_HBC_wCRT  +  Ok_HBC_dCRT
        Ok_HBO_CRT       =  Ok_HBO_wCRT  +  Ok_HBO_dCRT
        Ok_NHB_CRT       =  Ok_NHB_wCRT  +  Ok_NHB_dCRT
        Ok_HBS_CRT       =  Ok_HBS_wCRT  +  Ok_HBS_dCRT
        
        Ok_HBW_Transit   =  Ok_HBW_LCL  +  Ok_HBW_COR  +  Ok_HBW_BRT  +  Ok_HBW_EXP  +  Ok_HBW_LRT  +  Ok_HBW_CRT
        Ok_HBC_Transit   =  Ok_HBC_LCL  +  Ok_HBC_COR  +  Ok_HBC_BRT  +  Ok_HBC_EXP  +  Ok_HBC_LRT  +  Ok_HBC_CRT
        Ok_HBO_Transit   =  Ok_HBO_LCL  +  Ok_HBO_COR  +  Ok_HBO_BRT  +  Ok_HBO_EXP  +  Ok_HBO_LRT  +  Ok_HBO_CRT
        Ok_NHB_Transit   =  Ok_NHB_LCL  +  Ok_NHB_COR  +  Ok_NHB_BRT  +  Ok_NHB_EXP  +  Ok_NHB_LRT  +  Ok_NHB_CRT
        Ok_HBS_Transit   =  Ok_HBS_LCL  +  Ok_HBS_COR  +  Ok_HBS_BRT  +  Ok_HBS_EXP  +  Ok_HBS_LRT  +  Ok_HBS_CRT
        
        
        
        ;calculate trip totals and print summary file ========================================================
        if (i=ZONES)
            ;calculate daily trips by purpose and mode -------------------------------------------------------
            ;HBW
            Dy_HBW_NonMoto   =  Pk_HBW_NonMoto     +  Ok_HBW_NonMoto
            Dy_HBW_Walk      =  Pk_HBW_Walk        +  Ok_HBW_Walk
            Dy_HBW_Bike      =  Pk_HBW_Bike        +  Ok_HBW_Bike
            Dy_HBW_Auto      =  Pk_HBW_Auto        +  Ok_HBW_Auto
            Dy_HBW_SchoolBus =  Pk_HBW_SchoolBus   +  Ok_HBW_SchoolBus
            Dy_HBW_Transit   =  Pk_HBW_Transit     +  Ok_HBW_Transit
            Dy_HBW_LCL       =  Pk_HBW_LCL         +  Ok_HBW_LCL
            Dy_HBW_COR       =  Pk_HBW_COR         +  Ok_HBW_COR
            Dy_HBW_BRT       =  Pk_HBW_BRT         +  Ok_HBW_BRT
            Dy_HBW_EXP       =  Pk_HBW_EXP         +  Ok_HBW_EXP
            Dy_HBW_LRT       =  Pk_HBW_LRT         +  Ok_HBW_LRT
            Dy_HBW_CRT       =  Pk_HBW_CRT         +  Ok_HBW_CRT
            
            ;HBC
            Dy_HBC_NonMoto   =  Pk_HBC_NonMoto     +  Ok_HBC_NonMoto
            Dy_HBC_Walk      =  Pk_HBC_Walk        +  Ok_HBC_Walk
            Dy_HBC_Bike      =  Pk_HBC_Bike        +  Ok_HBC_Bike
            Dy_HBC_Auto      =  Pk_HBC_Auto        +  Ok_HBC_Auto
            Dy_HBC_SchoolBus =  Pk_HBC_SchoolBus   +  Ok_HBC_SchoolBus
            Dy_HBC_Transit   =  Pk_HBC_Transit     +  Ok_HBC_Transit
            Dy_HBC_LCL       =  Pk_HBC_LCL         +  Ok_HBC_LCL
            Dy_HBC_COR       =  Pk_HBC_COR         +  Ok_HBC_COR
            Dy_HBC_BRT       =  Pk_HBC_BRT         +  Ok_HBC_BRT
            Dy_HBC_EXP       =  Pk_HBC_EXP         +  Ok_HBC_EXP
            Dy_HBC_LRT       =  Pk_HBC_LRT         +  Ok_HBC_LRT
            Dy_HBC_CRT       =  Pk_HBC_CRT         +  Ok_HBC_CRT
            
            ;HBO
            Dy_HBO_NonMoto   =  Pk_HBO_NonMoto     +  Ok_HBO_NonMoto
            Dy_HBO_Walk      =  Pk_HBO_Walk        +  Ok_HBO_Walk
            Dy_HBO_Bike      =  Pk_HBO_Bike        +  Ok_HBO_Bike
            Dy_HBO_Auto      =  Pk_HBO_Auto        +  Ok_HBO_Auto
            Dy_HBO_SchoolBus =  Pk_HBO_SchoolBus   +  Ok_HBO_SchoolBus
            Dy_HBO_Transit   =  Pk_HBO_Transit     +  Ok_HBO_Transit
            Dy_HBO_LCL       =  Pk_HBO_LCL         +  Ok_HBO_LCL
            Dy_HBO_COR       =  Pk_HBO_COR         +  Ok_HBO_COR
            Dy_HBO_BRT       =  Pk_HBO_BRT         +  Ok_HBO_BRT
            Dy_HBO_EXP       =  Pk_HBO_EXP         +  Ok_HBO_EXP
            Dy_HBO_LRT       =  Pk_HBO_LRT         +  Ok_HBO_LRT
            Dy_HBO_CRT       =  Pk_HBO_CRT         +  Ok_HBO_CRT
            
            ;NHB
            Dy_NHB_NonMoto   =  Pk_NHB_NonMoto     +  Ok_NHB_NonMoto
            Dy_NHB_Walk      =  Pk_NHB_Walk        +  Ok_NHB_Walk
            Dy_NHB_Bike      =  Pk_NHB_Bike        +  Ok_NHB_Bike
            Dy_NHB_Auto      =  Pk_NHB_Auto        +  Ok_NHB_Auto
            Dy_NHB_SchoolBus =  Pk_NHB_SchoolBus   +  Ok_NHB_SchoolBus
            Dy_NHB_Transit   =  Pk_NHB_Transit     +  Ok_NHB_Transit
            Dy_NHB_LCL       =  Pk_NHB_LCL         +  Ok_NHB_LCL
            Dy_NHB_COR       =  Pk_NHB_COR         +  Ok_NHB_COR
            Dy_NHB_BRT       =  Pk_NHB_BRT         +  Ok_NHB_BRT
            Dy_NHB_EXP       =  Pk_NHB_EXP         +  Ok_NHB_EXP
            Dy_NHB_LRT       =  Pk_NHB_LRT         +  Ok_NHB_LRT
            Dy_NHB_CRT       =  Pk_NHB_CRT         +  Ok_NHB_CRT
            
            ;HBS
            Dy_HBS_NonMoto   =  Pk_HBS_NonMoto     +  Ok_HBS_NonMoto
            Dy_HBS_Walk      =  Pk_HBS_Walk        +  Ok_HBS_Walk
            Dy_HBS_Bike      =  Pk_HBS_Bike        +  Ok_HBS_Bike
            Dy_HBS_Auto      =  Pk_HBS_Auto        +  Ok_HBS_Auto
            Dy_HBS_SchoolBus =  Pk_HBS_SchoolBus   +  Ok_HBS_SchoolBus
            Dy_HBS_Transit   =  Pk_HBS_Transit     +  Ok_HBS_Transit
            Dy_HBS_LCL       =  Pk_HBS_LCL         +  Ok_HBS_LCL
            Dy_HBS_COR       =  Pk_HBS_COR         +  Ok_HBS_COR
            Dy_HBS_BRT       =  Pk_HBS_BRT         +  Ok_HBS_BRT
            Dy_HBS_EXP       =  Pk_HBS_EXP         +  Ok_HBS_EXP
            Dy_HBS_LRT       =  Pk_HBS_LRT         +  Ok_HBS_LRT
            Dy_HBS_CRT       =  Pk_HBS_CRT         +  Ok_HBS_CRT
            
            
            ;calculate total trips by purpose ----------------------------------------------------------------
            ;  e.g. Column totals
            ;peak
            Pk_HBW_Tot  =  Pk_HBW_NonMoto  +  Pk_HBW_Auto  +  Pk_HBW_SchoolBus  +  Pk_HBW_LCL  +  Pk_HBW_COR  +  Pk_HBW_BRT  +  Pk_HBW_EXP  +  Pk_HBW_LRT  +  Pk_HBW_CRT
            Pk_HBC_Tot  =  Pk_HBC_NonMoto  +  Pk_HBC_Auto  +  Pk_HBC_SchoolBus  +  Pk_HBC_LCL  +  Pk_HBC_COR  +  Pk_HBC_BRT  +  Pk_HBC_EXP  +  Pk_HBC_LRT  +  Pk_HBC_CRT
            Pk_HBO_Tot  =  Pk_HBO_NonMoto  +  Pk_HBO_Auto  +  Pk_HBO_SchoolBus  +  Pk_HBO_LCL  +  Pk_HBO_COR  +  Pk_HBO_BRT  +  Pk_HBO_EXP  +  Pk_HBO_LRT  +  Pk_HBO_CRT
            Pk_NHB_Tot  =  Pk_NHB_NonMoto  +  Pk_NHB_Auto  +  Pk_NHB_SchoolBus  +  Pk_NHB_LCL  +  Pk_NHB_COR  +  Pk_NHB_BRT  +  Pk_NHB_EXP  +  Pk_NHB_LRT  +  Pk_NHB_CRT
            Pk_HBS_Tot  =  Pk_HBS_NonMoto  +  Pk_HBS_Auto  +  Pk_HBS_SchoolBus  +  Pk_HBS_LCL  +  Pk_HBS_COR  +  Pk_HBS_BRT  +  Pk_HBS_EXP  +  Pk_HBS_LRT  +  Pk_HBS_CRT
            
            ;off-peak
            Ok_HBW_Tot  =  Ok_HBW_NonMoto  +  Ok_HBW_Auto  +  Ok_HBW_SchoolBus  +  Ok_HBW_LCL  +  Ok_HBW_COR  +  Ok_HBW_BRT  +  Ok_HBW_EXP  +  Ok_HBW_LRT  +  Ok_HBW_CRT
            Ok_HBC_Tot  =  Ok_HBC_NonMoto  +  Ok_HBC_Auto  +  Ok_HBC_SchoolBus  +  Ok_HBC_LCL  +  Ok_HBC_COR  +  Ok_HBC_BRT  +  Ok_HBC_EXP  +  Ok_HBC_LRT  +  Ok_HBC_CRT
            Ok_HBO_Tot  =  Ok_HBO_NonMoto  +  Ok_HBO_Auto  +  Ok_HBO_SchoolBus  +  Ok_HBO_LCL  +  Ok_HBO_COR  +  Ok_HBO_BRT  +  Ok_HBO_EXP  +  Ok_HBO_LRT  +  Ok_HBO_CRT
            Ok_NHB_Tot  =  Ok_NHB_NonMoto  +  Ok_NHB_Auto  +  Ok_NHB_SchoolBus  +  Ok_NHB_LCL  +  Ok_NHB_COR  +  Ok_NHB_BRT  +  Ok_NHB_EXP  +  Ok_NHB_LRT  +  Ok_NHB_CRT
            Ok_HBS_Tot  =  Ok_HBS_NonMoto  +  Ok_HBS_Auto  +  Ok_HBS_SchoolBus  +  Ok_HBS_LCL  +  Ok_HBS_COR  +  Ok_HBS_BRT  +  Ok_HBS_EXP  +  Ok_HBS_LRT  +  Ok_HBS_CRT
            
            ;daily
            Dy_HBW_Tot  =  Pk_HBW_Tot  +  Ok_HBW_Tot
            Dy_HBC_Tot  =  Pk_HBC_Tot  +  Ok_HBC_Tot
            Dy_HBO_Tot  =  Pk_HBO_Tot  +  Ok_HBO_Tot
            Dy_NHB_Tot  =  Pk_NHB_Tot  +  Ok_NHB_Tot
            Dy_HBS_Tot  =  Pk_HBS_Tot  +  Ok_HBS_Tot
            
            
            ;sum total trips by mode -------------------------------------------------------------------------
            ;  e.g. row totals
            ;peak
            Pk_Sum_NonMoto    =  Pk_HBW_NonMoto    +  Pk_HBC_NonMoto    +  Pk_HBO_NonMoto    +  Pk_NHB_NonMoto    +  Pk_HBS_NonMoto  
            Pk_Sum_Walk       =  Pk_HBW_Walk       +  Pk_HBC_Walk       +  Pk_HBO_Walk       +  Pk_NHB_Walk       +  Pk_HBS_Walk     
            Pk_Sum_Bike       =  Pk_HBW_Bike       +  Pk_HBC_Bike       +  Pk_HBO_Bike       +  Pk_NHB_Bike       +  Pk_HBS_Bike     
            Pk_Sum_Auto       =  Pk_HBW_Auto       +  Pk_HBC_Auto       +  Pk_HBO_Auto       +  Pk_NHB_Auto       +  Pk_HBS_Auto     
            Pk_Sum_SchoolBus  =  Pk_HBW_SchoolBus  +  Pk_HBC_SchoolBus  +  Pk_HBO_SchoolBus  +  Pk_NHB_SchoolBus  +  Pk_HBS_SchoolBus
            Pk_Sum_Transit    =  Pk_HBW_Transit    +  Pk_HBC_Transit    +  Pk_HBO_Transit    +  Pk_NHB_Transit    +  Pk_HBS_Transit  
            Pk_Sum_LCL        =  Pk_HBW_LCL        +  Pk_HBC_LCL        +  Pk_HBO_LCL        +  Pk_NHB_LCL        +  Pk_HBS_LCL    
            Pk_Sum_COR        =  Pk_HBW_COR        +  Pk_HBC_COR        +  Pk_HBO_COR        +  Pk_NHB_COR        +  Pk_HBS_COR     
            Pk_Sum_BRT        =  Pk_HBW_BRT        +  Pk_HBC_BRT        +  Pk_HBO_BRT        +  Pk_NHB_BRT        +  Pk_HBS_BRT     
            Pk_Sum_EXP        =  Pk_HBW_EXP        +  Pk_HBC_EXP        +  Pk_HBO_EXP        +  Pk_NHB_EXP        +  Pk_HBS_EXP      
            Pk_Sum_LRT        =  Pk_HBW_LRT        +  Pk_HBC_LRT        +  Pk_HBO_LRT        +  Pk_NHB_LRT        +  Pk_HBS_LRT      
            Pk_Sum_CRT        =  Pk_HBW_CRT        +  Pk_HBC_CRT        +  Pk_HBO_CRT        +  Pk_NHB_CRT        +  Pk_HBS_CRT      
            Pk_Sum_Tot        =  Pk_HBW_Tot        +  Pk_HBC_Tot        +  Pk_HBO_Tot        +  Pk_NHB_Tot        +  Pk_HBS_Tot      
            
            ;off-peak
            Ok_Sum_NonMoto    =  Ok_HBW_NonMoto    +  Ok_HBC_NonMoto    +  Ok_HBO_NonMoto    +  Ok_NHB_NonMoto    +  Ok_HBS_NonMoto  
            Ok_Sum_Walk       =  Ok_HBW_Walk       +  Ok_HBC_Walk       +  Ok_HBO_Walk       +  Ok_NHB_Walk       +  Ok_HBS_Walk     
            Ok_Sum_Bike       =  Ok_HBW_Bike       +  Ok_HBC_Bike       +  Ok_HBO_Bike       +  Ok_NHB_Bike       +  Ok_HBS_Bike     
            Ok_Sum_Auto       =  Ok_HBW_Auto       +  Ok_HBC_Auto       +  Ok_HBO_Auto       +  Ok_NHB_Auto       +  Ok_HBS_Auto     
            Ok_Sum_SchoolBus  =  Ok_HBW_SchoolBus  +  Ok_HBC_SchoolBus  +  Ok_HBO_SchoolBus  +  Ok_NHB_SchoolBus  +  Ok_HBS_SchoolBus
            Ok_Sum_Transit    =  Ok_HBW_Transit    +  Ok_HBC_Transit    +  Ok_HBO_Transit    +  Ok_NHB_Transit    +  Ok_HBS_Transit  
            Ok_Sum_LCL        =  Ok_HBW_LCL        +  Ok_HBC_LCL        +  Ok_HBO_LCL        +  Ok_NHB_LCL        +  Ok_HBS_LCL    
            Ok_Sum_COR        =  Ok_HBW_COR        +  Ok_HBC_COR        +  Ok_HBO_COR       +   Ok_NHB_COR        +  Ok_HBS_COR     
            Ok_Sum_BRT        =  Ok_HBW_BRT        +  Ok_HBC_BRT        +  Ok_HBO_BRT        +  Ok_NHB_BRT        +  Ok_HBS_BRT     
            Ok_Sum_EXP        =  Ok_HBW_EXP        +  Ok_HBC_EXP        +  Ok_HBO_EXP        +  Ok_NHB_EXP        +  Ok_HBS_EXP      
            Ok_Sum_LRT        =  Ok_HBW_LRT        +  Ok_HBC_LRT        +  Ok_HBO_LRT        +  Ok_NHB_LRT        +  Ok_HBS_LRT      
            Ok_Sum_CRT        =  Ok_HBW_CRT        +  Ok_HBC_CRT        +  Ok_HBO_CRT        +  Ok_NHB_CRT        +  Ok_HBS_CRT      
            Ok_Sum_Tot        =  Ok_HBW_Tot        +  Ok_HBC_Tot        +  Ok_HBO_Tot        +  Ok_NHB_Tot        +  Ok_HBS_Tot      
            
            ;daily
            Dy_Sum_NonMoto    =  Dy_HBW_NonMoto    +  Dy_HBC_NonMoto    +  Dy_HBO_NonMoto    +  Dy_NHB_NonMoto    +  Dy_HBS_NonMoto  
            Dy_Sum_Walk       =  Dy_HBW_Walk       +  Dy_HBC_Walk       +  Dy_HBO_Walk       +  Dy_NHB_Walk       +  Dy_HBS_Walk     
            Dy_Sum_Bike       =  Dy_HBW_Bike       +  Dy_HBC_Bike       +  Dy_HBO_Bike       +  Dy_NHB_Bike       +  Dy_HBS_Bike     
            Dy_Sum_Auto       =  Dy_HBW_Auto       +  Dy_HBC_Auto       +  Dy_HBO_Auto       +  Dy_NHB_Auto       +  Dy_HBS_Auto     
            Dy_Sum_SchoolBus  =  Dy_HBW_SchoolBus  +  Dy_HBC_SchoolBus  +  Dy_HBO_SchoolBus  +  Dy_NHB_SchoolBus  +  Dy_HBS_SchoolBus
            Dy_Sum_Transit    =  Dy_HBW_Transit    +  Dy_HBC_Transit    +  Dy_HBO_Transit    +  Dy_NHB_Transit    +  Dy_HBS_Transit  
            Dy_Sum_LCL        =  Dy_HBW_LCL        +  Dy_HBC_LCL        +  Dy_HBO_LCL        +  Dy_NHB_LCL        +  Dy_HBS_LCL    
            Dy_Sum_COR        =  Dy_HBW_COR        +  Dy_HBC_COR        +  Dy_HBO_COR        +  Dy_NHB_COR        +  Dy_HBS_COR     
            Dy_Sum_BRT        =  Dy_HBW_BRT        +  Dy_HBC_BRT        +  Dy_HBO_BRT        +  Dy_NHB_BRT        +  Dy_HBS_BRT     
            Dy_Sum_EXP        =  Dy_HBW_EXP        +  Dy_HBC_EXP        +  Dy_HBO_EXP        +  Dy_NHB_EXP        +  Dy_HBS_EXP      
            Dy_Sum_LRT        =  Dy_HBW_LRT        +  Dy_HBC_LRT        +  Dy_HBO_LRT        +  Dy_NHB_LRT        +  Dy_HBS_LRT      
            Dy_Sum_CRT        =  Dy_HBW_CRT        +  Dy_HBC_CRT        +  Dy_HBO_CRT        +  Dy_NHB_CRT        +  Dy_HBS_CRT      
            Dy_Sum_Tot        =  Dy_HBW_Tot        +  Dy_HBC_Tot        +  Dy_HBO_Tot        +  Dy_NHB_Tot        +  Dy_HBS_Tot      
            
            
            
            ;print trip share summary --------------------------------------------------------------------------------
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_Shares_Summary_LT@trip_cutoff@mi.csv',
                CSV=T, 
                FORM=10.2,
                LIST='@ScenarioDir@'  ,
                     '\n'             ,
                     '\nPeak'         ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Pk_HBW_NonMoto  ,  Pk_HBC_NonMoto  ,  Pk_HBO_NonMoto  ,  Pk_NHB_NonMoto  ,  Pk_HBS_NonMoto  ,  Pk_Sum_NonMoto  ,
                     '\n  Walk'       ,  Pk_HBW_Walk     ,  Pk_HBC_Walk     ,  Pk_HBO_Walk     ,  Pk_NHB_Walk     ,  Pk_HBS_Walk     ,  Pk_Sum_Walk     ,
                     '\n  Bike'       ,  Pk_HBW_Bike     ,  Pk_HBC_Bike     ,  Pk_HBO_Bike     ,  Pk_NHB_Bike     ,  Pk_HBS_Bike     ,  Pk_Sum_Bike     ,
                     '\nAuto'         ,  Pk_HBW_Auto     ,  Pk_HBC_Auto     ,  Pk_HBO_Auto     ,  Pk_NHB_Auto     ,  Pk_HBS_Auto     ,  Pk_Sum_Auto     ,
                     '\nSchool Bus'   ,  Pk_HBW_SchoolBus,  Pk_HBC_SchoolBus,  Pk_HBO_SchoolBus,  Pk_NHB_SchoolBus,  Pk_HBS_SchoolBus,  Pk_Sum_SchoolBus,
                     '\nTransit'      ,  Pk_HBW_Transit  ,  Pk_HBC_Transit  ,  Pk_HBO_Transit  ,  Pk_NHB_Transit  ,  Pk_HBS_Transit  ,  Pk_Sum_Transit  ,
                     '\n  Local'      ,  Pk_HBW_LCL      ,  Pk_HBC_LCL      ,  Pk_HBO_LCL      ,  Pk_NHB_LCL      ,  Pk_HBS_LCL      ,  Pk_Sum_LCL      ,
                     '\n  COR 1'      ,  Pk_HBW_COR      ,  Pk_HBC_COR      ,  Pk_HBO_COR      ,  Pk_NHB_COR      ,  Pk_HBS_COR      ,  Pk_Sum_COR      ,
                     '\n  COR 3'      ,  Pk_HBW_BRT      ,  Pk_HBC_BRT      ,  Pk_HBO_BRT      ,  Pk_NHB_BRT      ,  Pk_HBS_BRT      ,  Pk_Sum_BRT      ,
                     '\n  Express'    ,  Pk_HBW_EXP      ,  Pk_HBC_EXP      ,  Pk_HBO_EXP      ,  Pk_NHB_EXP      ,  Pk_HBS_EXP      ,  Pk_Sum_EXP      ,
                     '\n  LRT'        ,  Pk_HBW_LRT      ,  Pk_HBC_LRT      ,  Pk_HBO_LRT      ,  Pk_NHB_LRT      ,  Pk_HBS_LRT      ,  Pk_Sum_LRT      ,
                     '\n  CRT'        ,  Pk_HBW_CRT      ,  Pk_HBC_CRT      ,  Pk_HBO_CRT      ,  Pk_NHB_CRT      ,  Pk_HBS_CRT      ,  Pk_Sum_CRT      ,
                     '\nTotal Trips'  ,  Pk_HBW_Tot      ,  Pk_HBC_Tot      ,  Pk_HBO_Tot      ,  Pk_NHB_Tot      ,  Pk_HBS_Tot      ,  Pk_Sum_Tot      ,
                     '\n'             ,
                     '\n'             ,
                     '\nOff-Peak'     ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Ok_HBW_NonMoto  ,  Ok_HBC_NonMoto  ,  Ok_HBO_NonMoto  ,  Ok_NHB_NonMoto  ,  Ok_HBS_NonMoto  ,  Ok_Sum_NonMoto  ,
                     '\n  Walk'       ,  Ok_HBW_Walk     ,  Ok_HBC_Walk     ,  Ok_HBO_Walk     ,  Ok_NHB_Walk     ,  Ok_HBS_Walk     ,  Ok_Sum_Walk     ,
                     '\n  Bike'       ,  Ok_HBW_Bike     ,  Ok_HBC_Bike     ,  Ok_HBO_Bike     ,  Ok_NHB_Bike     ,  Ok_HBS_Bike     ,  Ok_Sum_Bike     ,
                     '\nAuto'         ,  Ok_HBW_Auto     ,  Ok_HBC_Auto     ,  Ok_HBO_Auto     ,  Ok_NHB_Auto     ,  Ok_HBS_Auto     ,  Ok_Sum_Auto     ,
                     '\nSchool Bus'   ,  Ok_HBW_SchoolBus,  Ok_HBC_SchoolBus,  Ok_HBO_SchoolBus,  Ok_NHB_SchoolBus,  Ok_HBS_SchoolBus,  Ok_Sum_SchoolBus,
                     '\nTransit'      ,  Ok_HBW_Transit  ,  Ok_HBC_Transit  ,  Ok_HBO_Transit  ,  Ok_NHB_Transit  ,  Ok_HBS_Transit  ,  Ok_Sum_Transit  ,
                     '\n  Local'      ,  Ok_HBW_LCL      ,  Ok_HBC_LCL      ,  Ok_HBO_LCL      ,  Ok_NHB_LCL      ,  Ok_HBS_LCL      ,  Ok_Sum_LCL      ,
                     '\n  COR 1'      ,  Ok_HBW_COR      ,  Ok_HBC_COR      ,  Ok_HBO_COR      ,  Ok_NHB_COR      ,  Ok_HBS_COR      ,  Ok_Sum_COR     , 
                     '\n  COR 3'      ,  Ok_HBW_BRT      ,  Ok_HBC_BRT      ,  Ok_HBO_BRT      ,  Ok_NHB_BRT      ,  Ok_HBS_BRT      ,  Ok_Sum_BRT      ,
                     '\n  Express'    ,  Ok_HBW_EXP      ,  Ok_HBC_EXP      ,  Ok_HBO_EXP      ,  Ok_NHB_EXP      ,  Ok_HBS_EXP      ,  Ok_Sum_EXP      ,
                     '\n  LRT'        ,  Ok_HBW_LRT      ,  Ok_HBC_LRT      ,  Ok_HBO_LRT      ,  Ok_NHB_LRT      ,  Ok_HBS_LRT      ,  Ok_Sum_LRT      ,
                     '\n  CRT'        ,  Ok_HBW_CRT      ,  Ok_HBC_CRT      ,  Ok_HBO_CRT      ,  Ok_NHB_CRT      ,  Ok_HBS_CRT      ,  Ok_Sum_CRT      ,
                     '\nTotal Trips'  ,  Ok_HBW_Tot      ,  Ok_HBC_Tot      ,  Ok_HBO_Tot      ,  Ok_NHB_Tot      ,  Ok_HBS_Tot      ,  Ok_Sum_Tot      ,
                     '\n'             ,
                     '\n'             ,
                     '\nDaily'        ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Dy_HBW_NonMoto  ,  Dy_HBC_NonMoto  ,  Dy_HBO_NonMoto  ,  Dy_NHB_NonMoto  ,  Dy_HBS_NonMoto  ,  Dy_Sum_NonMoto  ,
                     '\n  Walk'       ,  Dy_HBW_Walk     ,  Dy_HBC_Walk     ,  Dy_HBO_Walk     ,  Dy_NHB_Walk     ,  Dy_HBS_Walk     ,  Dy_Sum_Walk     ,
                     '\n  Bike'       ,  Dy_HBW_Bike     ,  Dy_HBC_Bike     ,  Dy_HBO_Bike     ,  Dy_NHB_Bike     ,  Dy_HBS_Bike     ,  Dy_Sum_Bike     ,
                     '\nAuto'         ,  Dy_HBW_Auto     ,  Dy_HBC_Auto     ,  Dy_HBO_Auto     ,  Dy_NHB_Auto     ,  Dy_HBS_Auto     ,  Dy_Sum_Auto     ,
                     '\nSchool Bus'   ,  Dy_HBW_SchoolBus,  Dy_HBC_SchoolBus,  Dy_HBO_SchoolBus,  Dy_NHB_SchoolBus,  Dy_HBS_SchoolBus,  Dy_Sum_SchoolBus,
                     '\nTransit'      ,  Dy_HBW_Transit  ,  Dy_HBC_Transit  ,  Dy_HBO_Transit  ,  Dy_NHB_Transit  ,  Dy_HBS_Transit  ,  Dy_Sum_Transit  ,
                     '\n  Local'      ,  Dy_HBW_LCL      ,  Dy_HBC_LCL      ,  Dy_HBO_LCL      ,  Dy_NHB_LCL      ,  Dy_HBS_LCL      ,  Dy_Sum_LCL      ,
                     '\n  COR 1'      ,  Dy_HBW_COR      ,  Dy_HBC_COR      ,  Dy_HBO_COR      ,  Dy_NHB_COR      ,  Dy_HBS_COR      ,  Dy_Sum_COR      ,
                     '\n  COR 3'      ,  Dy_HBW_BRT      ,  Dy_HBC_BRT      ,  Dy_HBO_BRT      ,  Dy_NHB_BRT      ,  Dy_HBS_BRT      ,  Dy_Sum_BRT      ,
                     '\n  Express'    ,  Dy_HBW_EXP      ,  Dy_HBC_EXP      ,  Dy_HBO_EXP      ,  Dy_NHB_EXP      ,  Dy_HBS_EXP      ,  Dy_Sum_EXP      ,
                     '\n  LRT'        ,  Dy_HBW_LRT      ,  Dy_HBC_LRT      ,  Dy_HBO_LRT      ,  Dy_NHB_LRT      ,  Dy_HBS_LRT      ,  Dy_Sum_LRT      ,
                     '\n  CRT'        ,  Dy_HBW_CRT      ,  Dy_HBC_CRT      ,  Dy_HBO_CRT      ,  Dy_NHB_CRT      ,  Dy_HBS_CRT      ,  Dy_Sum_CRT      ,
                     '\nTotal Trips'  ,  Dy_HBW_Tot      ,  Dy_HBC_Tot      ,  Dy_HBO_Tot      ,  Dy_NHB_Tot      ,  Dy_HBS_Tot      ,  Dy_Sum_Tot      ,
                     '\n'
            

        endif  ;i=ZONES
        
    ENDRUN
    
;Cluster: end of group distributed to processor 5
EndDistributeMULTISTEP




;Cluster: keep processing on processor 1 (Main)

    RUN PGM=MATRIX   MSG='Mode Choice 16: compute mode shares - summary'
    FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Pk.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Pk.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Pk.mtx'
    FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Pk.mtx'
    
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Ok.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Ok.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Ok.mtx'
    FILEI MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Ok.mtx'
    
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
    
    
        ZONES = @UsedZones@
        ZONEMSG = 10
        
        
        ;read in working matrices ============================================================================
        ;peak ------------------------------------------------------------------------------------------------
        ;HBW
        mw[101] = mi.01.walk / 100
        mw[102] = mi.01.bike / 100
        mw[103] = mi.01.auto / 100
        mw[104] = mi.01.wLCL / 100
        mw[105] = mi.01.dLCL / 100
        mw[106] = mi.01.wCOR / 100
        mw[107] = mi.01.dCOR / 100
        mw[108] = mi.01.wBRT / 100
        mw[109] = mi.01.dBRT / 100
        mw[110] = mi.01.wEXP / 100
        mw[111] = mi.01.dEXP / 100
        mw[112] = mi.01.wLRT / 100
        mw[113] = mi.01.dLRT / 100
        mw[114] = mi.01.wCRT / 100
        mw[115] = mi.01.dCRT / 100
        
        ;HBC
        mw[201] = mi.02.walk / 100
        mw[202] = mi.02.bike / 100
        mw[203] = mi.02.auto / 100
        mw[204] = mi.02.wLCL / 100
        mw[205] = mi.02.dLCL / 100
        mw[206] = mi.02.wCOR / 100
        mw[207] = mi.02.dCOR / 100
        mw[208] = mi.02.wBRT / 100
        mw[209] = mi.02.dBRT / 100
        mw[210] = mi.02.wEXP / 100
        mw[211] = mi.02.dEXP / 100
        mw[212] = mi.02.wLRT / 100
        mw[213] = mi.02.dLRT / 100
        mw[214] = mi.02.wCRT / 100
        mw[215] = mi.02.dCRT / 100
        
        ;HBO
        mw[301] = mi.03.walk / 100
        mw[302] = mi.03.bike / 100
        mw[303] = mi.03.auto / 100
        mw[304] = mi.03.wLCL / 100
        mw[305] = mi.03.dLCL / 100
        mw[306] = mi.03.wCOR / 100
        mw[307] = mi.03.dCOR / 100
        mw[308] = mi.03.wBRT / 100
        mw[309] = mi.03.dBRT / 100
        mw[310] = mi.03.wEXP / 100
        mw[311] = mi.03.dEXP / 100
        mw[312] = mi.03.wLRT / 100
        mw[313] = mi.03.dLRT / 100
        mw[314] = mi.03.wCRT / 100
        mw[315] = mi.03.dCRT / 100
        
        ;NHB
        mw[401] = mi.04.walk / 100
        mw[402] = mi.04.bike / 100
        mw[403] = mi.04.auto / 100
        mw[404] = mi.04.wLCL / 100
        mw[405] = mi.04.dLCL / 100
        mw[406] = mi.04.wCOR / 100
        mw[407] = mi.04.dCOR / 100
        mw[408] = mi.04.wBRT / 100
        mw[409] = mi.04.dBRT / 100
        mw[410] = mi.04.wEXP / 100
        mw[411] = mi.04.dEXP / 100
        mw[412] = mi.04.wLRT / 100
        mw[413] = mi.04.dLRT / 100
        mw[414] = mi.04.wCRT / 100
        mw[415] = mi.04.dCRT / 100
        
        ;HBS - Primary
        mw[911] = mi.09.Pk_SchoolBus
        mw[912] = mi.09.Pk_DriveSelf
        mw[913] = mi.09.Pk_DropOff
        mw[914] = mi.09.Pk_Walk
        mw[915] = mi.09.Pk_Bike
        
        ;HBS - Secondary
        mw[921] = mi.10.Pk_SchoolBus
        mw[922] = mi.10.Pk_DriveSelf
        mw[923] = mi.10.Pk_DropOff
        mw[924] = mi.10.Pk_Walk
        mw[925] = mi.10.Pk_Bike
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        ;HBW
        mw[501] = mi.05.walk / 100
        mw[502] = mi.05.bike / 100
        mw[503] = mi.05.auto / 100
        mw[504] = mi.05.wLCL / 100
        mw[505] = mi.05.dLCL / 100
        mw[506] = mi.05.wCOR / 100
        mw[507] = mi.05.dCOR / 100
        mw[508] = mi.05.wBRT / 100
        mw[509] = mi.05.dBRT / 100
        mw[510] = mi.05.wEXP / 100
        mw[511] = mi.05.dEXP / 100
        mw[512] = mi.05.wLRT / 100
        mw[513] = mi.05.dLRT / 100
        mw[514] = mi.05.wCRT / 100
        mw[515] = mi.05.dCRT / 100
        
        ;HBC
        mw[601] = mi.06.walk / 100
        mw[602] = mi.06.bike / 100
        mw[603] = mi.06.auto / 100
        mw[604] = mi.06.wLCL / 100
        mw[605] = mi.06.dLCL / 100
        mw[606] = mi.06.wCOR / 100
        mw[607] = mi.06.dCOR / 100
        mw[608] = mi.06.wBRT / 100
        mw[609] = mi.06.dBRT / 100
        mw[610] = mi.06.wEXP / 100
        mw[611] = mi.06.dEXP / 100
        mw[612] = mi.06.wLRT / 100
        mw[613] = mi.06.dLRT / 100
        mw[614] = mi.06.wCRT / 100
        mw[615] = mi.06.dCRT / 100
        
        ;HBO
        mw[701] = mi.07.walk / 100
        mw[702] = mi.07.bike / 100
        mw[703] = mi.07.auto / 100
        mw[704] = mi.07.wLCL / 100
        mw[705] = mi.07.dLCL / 100
        mw[706] = mi.07.wCOR / 100
        mw[707] = mi.07.dCOR / 100
        mw[708] = mi.07.wBRT / 100
        mw[709] = mi.07.dBRT / 100
        mw[710] = mi.07.wEXP / 100
        mw[711] = mi.07.dEXP / 100
        mw[712] = mi.07.wLRT / 100
        mw[713] = mi.07.dLRT / 100
        mw[714] = mi.07.wCRT / 100
        mw[715] = mi.07.dCRT / 100
        
        ;NHB
        mw[801] = mi.08.walk / 100
        mw[802] = mi.08.bike / 100
        mw[803] = mi.08.auto / 100
        mw[804] = mi.08.wLCL / 100
        mw[805] = mi.08.dLCL / 100
        mw[806] = mi.08.wCOR / 100
        mw[807] = mi.08.dCOR / 100
        mw[808] = mi.08.wBRT / 100
        mw[809] = mi.08.dBRT / 100
        mw[810] = mi.08.wEXP / 100
        mw[811] = mi.08.dEXP / 100
        mw[812] = mi.08.wLRT / 100
        mw[813] = mi.08.dLRT / 100
        mw[814] = mi.08.wCRT / 100
        mw[815] = mi.08.dCRT / 100
        
        ;HBS - Primary
        mw[931] = mi.09.Ok_SchoolBus
        mw[932] = mi.09.Ok_DriveSelf
        mw[933] = mi.09.Ok_DropOff
        mw[934] = mi.09.Ok_Walk
        mw[935] = mi.09.Ok_Bike
        
        ;HBS - Secondary
        mw[941] = mi.10.Ok_SchoolBus
        mw[942] = mi.10.Ok_DriveSelf
        mw[943] = mi.10.Ok_DropOff
        mw[944] = mi.10.Ok_Walk
        mw[945] = mi.10.Ok_Bike
        
        
        
        ;summarize working matrices ==========================================================================
        ;peak ------------------------------------------------------------------------------------------------
        Pk_HBW_walk = Pk_HBW_walk + ROWSUM(101)
        Pk_HBW_bike = Pk_HBW_bike + ROWSUM(102)
        Pk_HBW_auto = Pk_HBW_auto + ROWSUM(103)
        Pk_HBW_wLCL = Pk_HBW_wLCL + ROWSUM(104)
        Pk_HBW_dLCL = Pk_HBW_dLCL + ROWSUM(105)
        Pk_HBW_wCOR = Pk_HBW_wCOR + ROWSUM(106)
        Pk_HBW_dCOR = Pk_HBW_dCOR + ROWSUM(107)
        Pk_HBW_wBRT = Pk_HBW_wBRT + ROWSUM(108)
        Pk_HBW_dBRT = Pk_HBW_dBRT + ROWSUM(109)
        Pk_HBW_wEXP = Pk_HBW_wEXP + ROWSUM(110)
        Pk_HBW_dEXP = Pk_HBW_dEXP + ROWSUM(111)
        Pk_HBW_wLRT = Pk_HBW_wLRT + ROWSUM(112)
        Pk_HBW_dLRT = Pk_HBW_dLRT + ROWSUM(113)
        Pk_HBW_wCRT = Pk_HBW_wCRT + ROWSUM(114)
        Pk_HBW_dCRT = Pk_HBW_dCRT + ROWSUM(115)
        
        Pk_HBC_walk = Pk_HBC_walk + ROWSUM(201)
        Pk_HBC_bike = Pk_HBC_bike + ROWSUM(202)
        Pk_HBC_auto = Pk_HBC_auto + ROWSUM(203)
        Pk_HBC_wLCL = Pk_HBC_wLCL + ROWSUM(204)
        Pk_HBC_dLCL = Pk_HBC_dLCL + ROWSUM(205)
        Pk_HBC_wCOR = Pk_HBC_wCOR + ROWSUM(206)
        Pk_HBC_dCOR = Pk_HBC_dCOR + ROWSUM(207)
        Pk_HBC_wBRT = Pk_HBC_wBRT + ROWSUM(208)
        Pk_HBC_dBRT = Pk_HBC_dBRT + ROWSUM(209)
        Pk_HBC_wEXP = Pk_HBC_wEXP + ROWSUM(210)
        Pk_HBC_dEXP = Pk_HBC_dEXP + ROWSUM(211)
        Pk_HBC_wLRT = Pk_HBC_wLRT + ROWSUM(212)
        Pk_HBC_dLRT = Pk_HBC_dLRT + ROWSUM(213)
        Pk_HBC_wCRT = Pk_HBC_wCRT + ROWSUM(214)
        Pk_HBC_dCRT = Pk_HBC_dCRT + ROWSUM(215)
        
        Pk_HBO_walk = Pk_HBO_walk + ROWSUM(301)
        Pk_HBO_bike = Pk_HBO_bike + ROWSUM(302)
        Pk_HBO_auto = Pk_HBO_auto + ROWSUM(303)
        Pk_HBO_wLCL = Pk_HBO_wLCL + ROWSUM(304)
        Pk_HBO_dLCL = Pk_HBO_dLCL + ROWSUM(305)
        Pk_HBO_wCOR = Pk_HBO_wCOR + ROWSUM(306)
        Pk_HBO_dCOR = Pk_HBO_dCOR + ROWSUM(307)
        Pk_HBO_wBRT = Pk_HBO_wBRT + ROWSUM(308)
        Pk_HBO_dBRT = Pk_HBO_dBRT + ROWSUM(309)
        Pk_HBO_wEXP = Pk_HBO_wEXP + ROWSUM(310)
        Pk_HBO_dEXP = Pk_HBO_dEXP + ROWSUM(311)
        Pk_HBO_wLRT = Pk_HBO_wLRT + ROWSUM(312)
        Pk_HBO_dLRT = Pk_HBO_dLRT + ROWSUM(313)
        Pk_HBO_wCRT = Pk_HBO_wCRT + ROWSUM(314)
        Pk_HBO_dCRT = Pk_HBO_dCRT + ROWSUM(315)
        
        Pk_NHB_walk = Pk_NHB_walk + ROWSUM(401)
        Pk_NHB_bike = Pk_NHB_bike + ROWSUM(402)
        Pk_NHB_auto = Pk_NHB_auto + ROWSUM(403)
        Pk_NHB_wLCL = Pk_NHB_wLCL + ROWSUM(404)
        Pk_NHB_dLCL = Pk_NHB_dLCL + ROWSUM(405)
        Pk_NHB_wCOR = Pk_NHB_wCOR + ROWSUM(406)
        Pk_NHB_dCOR = Pk_NHB_dCOR + ROWSUM(407)
        Pk_NHB_wBRT = Pk_NHB_wBRT + ROWSUM(408)
        Pk_NHB_dBRT = Pk_NHB_dBRT + ROWSUM(409)
        Pk_NHB_wEXP = Pk_NHB_wEXP + ROWSUM(410)
        Pk_NHB_dEXP = Pk_NHB_dEXP + ROWSUM(411)
        Pk_NHB_wLRT = Pk_NHB_wLRT + ROWSUM(412)
        Pk_NHB_dLRT = Pk_NHB_dLRT + ROWSUM(413)
        Pk_NHB_wCRT = Pk_NHB_wCRT + ROWSUM(414)
        Pk_NHB_dCRT = Pk_NHB_dCRT + ROWSUM(415)
        
        Pk_HBSPr_SchoolBus = Pk_HBSPr_SchoolBus + ROWSUM(911)
        Pk_HBSPr_DriveSelf = Pk_HBSPr_DriveSelf + ROWSUM(912)
        Pk_HBSPr_DropOff   = Pk_HBSPr_DropOff   + ROWSUM(913)
        Pk_HBSPr_Walk      = Pk_HBSPr_Walk      + ROWSUM(914)
        Pk_HBSPr_Bike      = Pk_HBSPr_Bike      + ROWSUM(915)
        
        Pk_HBSSc_SchoolBus = Pk_HBSSc_SchoolBus + ROWSUM(921)
        Pk_HBSSc_DriveSelf = Pk_HBSSc_DriveSelf + ROWSUM(922)
        Pk_HBSSc_DropOff   = Pk_HBSSc_DropOff   + ROWSUM(923)
        Pk_HBSSc_Walk      = Pk_HBSSc_Walk      + ROWSUM(924)
        Pk_HBSSc_Bike      = Pk_HBSSc_Bike      + ROWSUM(925)
        
        Pk_HBS_wLCL      = 0
        Pk_HBS_dLCL      = 0
        Pk_HBS_wCOR      = 0
        Pk_HBS_dCOR      = 0
        Pk_HBS_wBRT      = 0
        Pk_HBS_dBRT      = 0
        Pk_HBS_wEXP      = 0
        Pk_HBS_dEXP      = 0
        Pk_HBS_wLRT      = 0
        Pk_HBS_dLRT      = 0
        Pk_HBS_wCRT      = 0
        Pk_HBS_dCRT      = 0
        
        Pk_HBW_SchoolBus = 0
        Pk_HBC_SchoolBus = 0
        Pk_HBO_SchoolBus = 0
        Pk_NHB_SchoolBus = 0
        
        Pk_HBS_Walk      = Pk_HBSPr_Walk +
                           Pk_HBSSc_Walk 
        
        Pk_HBS_Bike      = Pk_HBSPr_Bike +
                           Pk_HBSSc_Bike
        
        Pk_HBS_Auto      = Pk_HBSPr_DriveSelf +
                           Pk_HBSPr_DropOff   +
                           Pk_HBSSc_DriveSelf +
                           Pk_HBSSc_DropOff  
        
        Pk_HBS_SchoolBus = Pk_HBSPr_SchoolBus +
                           Pk_HBSSc_SchoolBus
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        Ok_HBW_walk = Ok_HBW_walk + ROWSUM(501)
        Ok_HBW_bike = Ok_HBW_bike + ROWSUM(502)
        Ok_HBW_auto = Ok_HBW_auto + ROWSUM(503)
        Ok_HBW_wLCL = Ok_HBW_wLCL + ROWSUM(504)
        Ok_HBW_dLCL = Ok_HBW_dLCL + ROWSUM(505)
        Ok_HBW_wCOR = Ok_HBW_wCOR + ROWSUM(506)
        Ok_HBW_dCOR = Ok_HBW_dCOR + ROWSUM(507)
        Ok_HBW_wBRT = Ok_HBW_wBRT + ROWSUM(508)
        Ok_HBW_dBRT = Ok_HBW_dBRT + ROWSUM(509)
        Ok_HBW_wEXP = Ok_HBW_wEXP + ROWSUM(510)
        Ok_HBW_dEXP = Ok_HBW_dEXP + ROWSUM(511)
        Ok_HBW_wLRT = Ok_HBW_wLRT + ROWSUM(512)
        Ok_HBW_dLRT = Ok_HBW_dLRT + ROWSUM(513)
        Ok_HBW_wCRT = Ok_HBW_wCRT + ROWSUM(514)
        Ok_HBW_dCRT = Ok_HBW_dCRT + ROWSUM(515)
        
        Ok_HBC_walk = Ok_HBC_walk + ROWSUM(601)
        Ok_HBC_bike = Ok_HBC_bike + ROWSUM(602)
        Ok_HBC_auto = Ok_HBC_auto + ROWSUM(603)
        Ok_HBC_wLCL = Ok_HBC_wLCL + ROWSUM(604)
        Ok_HBC_dLCL = Ok_HBC_dLCL + ROWSUM(605)
        Ok_HBC_wCOR = Ok_HBC_wCOR + ROWSUM(606)
        Ok_HBC_dCOR = Ok_HBC_dCOR + ROWSUM(607)
        Ok_HBC_wBRT = Ok_HBC_wBRT + ROWSUM(608)
        Ok_HBC_dBRT = Ok_HBC_dBRT + ROWSUM(609)
        Ok_HBC_wEXP = Ok_HBC_wEXP + ROWSUM(610)
        Ok_HBC_dEXP = Ok_HBC_dEXP + ROWSUM(611)
        Ok_HBC_wLRT = Ok_HBC_wLRT + ROWSUM(612)
        Ok_HBC_dLRT = Ok_HBC_dLRT + ROWSUM(613)
        Ok_HBC_wCRT = Ok_HBC_wCRT + ROWSUM(614)
        Ok_HBC_dCRT = Ok_HBC_dCRT + ROWSUM(615)
        
        Ok_HBO_walk = Ok_HBO_walk + ROWSUM(701)
        Ok_HBO_bike = Ok_HBO_bike + ROWSUM(702)
        Ok_HBO_auto = Ok_HBO_auto + ROWSUM(703)
        Ok_HBO_wLCL = Ok_HBO_wLCL + ROWSUM(704)
        Ok_HBO_dLCL = Ok_HBO_dLCL + ROWSUM(705)
        Ok_HBO_wCOR = Ok_HBO_wCOR + ROWSUM(706)
        Ok_HBO_dCOR = Ok_HBO_dCOR + ROWSUM(707)
        Ok_HBO_wBRT = Ok_HBO_wBRT + ROWSUM(708)
        Ok_HBO_dBRT = Ok_HBO_dBRT + ROWSUM(709)
        Ok_HBO_wEXP = Ok_HBO_wEXP + ROWSUM(710)
        Ok_HBO_dEXP = Ok_HBO_dEXP + ROWSUM(711)
        Ok_HBO_wLRT = Ok_HBO_wLRT + ROWSUM(712)
        Ok_HBO_dLRT = Ok_HBO_dLRT + ROWSUM(713)
        Ok_HBO_wCRT = Ok_HBO_wCRT + ROWSUM(714)
        Ok_HBO_dCRT = Ok_HBO_dCRT + ROWSUM(715)
        
        Ok_NHB_walk = Ok_NHB_walk + ROWSUM(801)
        Ok_NHB_bike = Ok_NHB_bike + ROWSUM(802)
        Ok_NHB_auto = Ok_NHB_auto + ROWSUM(803)
        Ok_NHB_wLCL = Ok_NHB_wLCL + ROWSUM(804)
        Ok_NHB_dLCL = Ok_NHB_dLCL + ROWSUM(805)
        Ok_NHB_wCOR = Ok_NHB_wCOR + ROWSUM(806)
        Ok_NHB_dCOR = Ok_NHB_dCOR + ROWSUM(807)
        Ok_NHB_wBRT = Ok_NHB_wBRT + ROWSUM(808)
        Ok_NHB_dBRT = Ok_NHB_dBRT + ROWSUM(809)
        Ok_NHB_wEXP = Ok_NHB_wEXP + ROWSUM(810)
        Ok_NHB_dEXP = Ok_NHB_dEXP + ROWSUM(811)
        Ok_NHB_wLRT = Ok_NHB_wLRT + ROWSUM(812)
        Ok_NHB_dLRT = Ok_NHB_dLRT + ROWSUM(813)
        Ok_NHB_wCRT = Ok_NHB_wCRT + ROWSUM(814)
        Ok_NHB_dCRT = Ok_NHB_dCRT + ROWSUM(815)
        
        Ok_HBSPr_SchoolBus = Ok_HBSPr_SchoolBus + ROWSUM(931)
        Ok_HBSPr_DriveSelf = Ok_HBSPr_DriveSelf + ROWSUM(932)
        Ok_HBSPr_DropOff   = Ok_HBSPr_DropOff   + ROWSUM(933)
        Ok_HBSPr_Walk      = Ok_HBSPr_Walk      + ROWSUM(934)
        Ok_HBSPr_Bike      = Ok_HBSPr_Bike      + ROWSUM(935)
        
        Ok_HBSSc_SchoolBus = Ok_HBSSc_SchoolBus + ROWSUM(941)
        Ok_HBSSc_DriveSelf = Ok_HBSSc_DriveSelf + ROWSUM(942)
        Ok_HBSSc_DropOff   = Ok_HBSSc_DropOff   + ROWSUM(943)
        Ok_HBSSc_Walk      = Ok_HBSSc_Walk      + ROWSUM(944)
        Ok_HBSSc_Bike      = Ok_HBSSc_Bike      + ROWSUM(945)
        
        Ok_HBS_wLCL      = 0
        Ok_HBS_dLCL      = 0
        Ok_HBS_wCOR      = 0
        Ok_HBS_dCOR      = 0
        Ok_HBS_wBRT    = 0
        Ok_HBS_dBRT    = 0
        Ok_HBS_wEXP      = 0
        Ok_HBS_dEXP      = 0
        Ok_HBS_wLRT      = 0
        Ok_HBS_dLRT      = 0
        Ok_HBS_wCRT      = 0
        Ok_HBS_dCRT      = 0
        
        Ok_HBW_SchoolBus = 0
        Ok_HBC_SchoolBus = 0
        Ok_HBO_SchoolBus = 0
        Ok_NHB_SchoolBus = 0
        
        Ok_HBS_Walk      = Ok_HBSPr_Walk +
                           Ok_HBSSc_Walk 
        
        Ok_HBS_Bike      = Ok_HBSPr_Bike +
                           Ok_HBSSc_Bike
        
        Ok_HBS_Auto      = Ok_HBSPr_DriveSelf +
                           Ok_HBSPr_DropOff   +
                           Ok_HBSSc_DriveSelf +
                           Ok_HBSSc_DropOff  
        
        Ok_HBS_SchoolBus = Ok_HBSPr_SchoolBus +
                           Ok_HBSSc_SchoolBus
        
        
        
        ;calculate trip totals ===============================================================================
        ;peak ------------------------------------------------------------------------------------------------
        Pk_HBW_NonMoto   =  Pk_HBW_walk  +  Pk_HBW_bike
        Pk_HBC_NonMoto   =  Pk_HBC_walk  +  Pk_HBC_bike
        Pk_HBO_NonMoto   =  Pk_HBO_walk  +  Pk_HBO_bike
        Pk_NHB_NonMoto   =  Pk_NHB_walk  +  Pk_NHB_bike
        Pk_HBS_NonMoto   =  Pk_HBS_Walk  +  Pk_HBS_Bike
        
        Pk_HBW_LCL       =  Pk_HBW_wLCL  +  Pk_HBW_dLCL
        Pk_HBC_LCL       =  Pk_HBC_wLCL  +  Pk_HBC_dLCL
        Pk_HBO_LCL       =  Pk_HBO_wLCL  +  Pk_HBO_dLCL
        Pk_NHB_LCL       =  Pk_NHB_wLCL  +  Pk_NHB_dLCL
        Pk_HBS_LCL       =  Pk_HBS_wLCL  +  Pk_HBS_dLCL
        
        Pk_HBW_COR       =  Pk_HBW_wCOR  +  Pk_HBW_dCOR
        Pk_HBC_COR       =  Pk_HBC_wCOR  +  Pk_HBC_dCOR
        Pk_HBO_COR       =  Pk_HBO_wCOR  +  Pk_HBO_dCOR
        Pk_NHB_COR       =  Pk_NHB_wCOR  +  Pk_NHB_dCOR
        Pk_HBS_COR       =  Pk_HBS_wCOR  +  Pk_HBS_dCOR
        
        Pk_HBW_BRT       =  Pk_HBW_wBRT  +  Pk_HBW_dBRT
        Pk_HBC_BRT       =  Pk_HBC_wBRT  +  Pk_HBC_dBRT
        Pk_HBO_BRT       =  Pk_HBO_wBRT  +  Pk_HBO_dBRT
        Pk_NHB_BRT       =  Pk_NHB_wBRT  +  Pk_NHB_dBRT
        Pk_HBS_BRT       =  Pk_HBS_wBRT  +  Pk_HBS_dBRT
        
        Pk_HBW_EXP       =  Pk_HBW_wEXP  +  Pk_HBW_dEXP
        Pk_HBC_EXP       =  Pk_HBC_wEXP  +  Pk_HBC_dEXP
        Pk_HBO_EXP       =  Pk_HBO_wEXP  +  Pk_HBO_dEXP
        Pk_NHB_EXP       =  Pk_NHB_wEXP  +  Pk_NHB_dEXP
        Pk_HBS_EXP       =  Pk_HBS_wEXP  +  Pk_HBS_dEXP
        
        Pk_HBW_LRT       =  Pk_HBW_wLRT  +  Pk_HBW_dLRT
        Pk_HBC_LRT       =  Pk_HBC_wLRT  +  Pk_HBC_dLRT
        Pk_HBO_LRT       =  Pk_HBO_wLRT  +  Pk_HBO_dLRT
        Pk_NHB_LRT       =  Pk_NHB_wLRT  +  Pk_NHB_dLRT
        Pk_HBS_LRT       =  Pk_HBS_wLRT  +  Pk_HBS_dLRT
        
        Pk_HBW_CRT       =  Pk_HBW_wCRT  +  Pk_HBW_dCRT
        Pk_HBC_CRT       =  Pk_HBC_wCRT  +  Pk_HBC_dCRT
        Pk_HBO_CRT       =  Pk_HBO_wCRT  +  Pk_HBO_dCRT
        Pk_NHB_CRT       =  Pk_NHB_wCRT  +  Pk_NHB_dCRT
        Pk_HBS_CRT       =  Pk_HBS_wCRT  +  Pk_HBS_dCRT
        
        Pk_HBW_Transit   =  Pk_HBW_LCL  +  Pk_HBW_COR  +  Pk_HBW_BRT  +  Pk_HBW_EXP   +  Pk_HBW_LRT   +  Pk_HBW_CRT
        Pk_HBC_Transit   =  Pk_HBC_LCL  +  Pk_HBC_COR  +  Pk_HBC_BRT  +  Pk_HBC_EXP   +  Pk_HBC_LRT   +  Pk_HBC_CRT
        Pk_HBO_Transit   =  Pk_HBO_LCL  +  Pk_HBO_COR  +  Pk_HBO_BRT  +  Pk_HBO_EXP   +  Pk_HBO_LRT   +  Pk_HBO_CRT
        Pk_NHB_Transit   =  Pk_NHB_LCL  +  Pk_NHB_COR  +  Pk_NHB_BRT  +  Pk_NHB_EXP   +  Pk_NHB_LRT   +  Pk_NHB_CRT
        Pk_HBS_Transit   =  Pk_HBS_LCL  +  Pk_HBS_COR  +  Pk_HBS_BRT  +  Pk_HBS_EXP   +  Pk_HBS_LRT   +  Pk_HBS_CRT
        
        
        ;off-peak --------------------------------------------------------------------------------------------
        Ok_HBW_NonMoto   =  Ok_HBW_walk  +  Ok_HBW_bike
        Ok_HBC_NonMoto   =  Ok_HBC_walk  +  Ok_HBC_bike
        Ok_HBO_NonMoto   =  Ok_HBO_walk  +  Ok_HBO_bike
        Ok_NHB_NonMoto   =  Ok_NHB_walk  +  Ok_NHB_bike
        Ok_HBS_NonMoto   =  Ok_HBS_Walk  +  Ok_HBS_Bike
        
        Ok_HBW_LCL       =  Ok_HBW_wLCL  +  Ok_HBW_dLCL
        Ok_HBC_LCL       =  Ok_HBC_wLCL  +  Ok_HBC_dLCL
        Ok_HBO_LCL       =  Ok_HBO_wLCL  +  Ok_HBO_dLCL
        Ok_NHB_LCL       =  Ok_NHB_wLCL  +  Ok_NHB_dLCL
        Ok_HBS_LCL       =  Ok_HBS_wLCL  +  Ok_HBS_dLCL
        
        Ok_HBW_COR       =  Ok_HBW_wCOR  +  Ok_HBW_dCOR
        Ok_HBC_COR       =  Ok_HBC_wCOR  +  Ok_HBC_dCOR
        Ok_HBO_COR       =  Ok_HBO_wCOR  +  Ok_HBO_dCOR
        Ok_NHB_COR       =  Ok_NHB_wCOR  +  Ok_NHB_dCOR
        Ok_HBS_COR       =  Ok_HBS_wCOR  +  Ok_HBS_dCOR
        
        Ok_HBW_BRT       =  Ok_HBW_wBRT  +  Ok_HBW_dBRT
        Ok_HBC_BRT       =  Ok_HBC_wBRT  +  Ok_HBC_dBRT
        Ok_HBO_BRT       =  Ok_HBO_wBRT  +  Ok_HBO_dBRT
        Ok_NHB_BRT       =  Ok_NHB_wBRT  +  Ok_NHB_dBRT
        Ok_HBS_BRT       =  Ok_HBS_wBRT  +  Ok_HBS_dBRT
        
        Ok_HBW_EXP       =  Ok_HBW_wEXP  +  Ok_HBW_dEXP
        Ok_HBC_EXP       =  Ok_HBC_wEXP  +  Ok_HBC_dEXP
        Ok_HBO_EXP       =  Ok_HBO_wEXP  +  Ok_HBO_dEXP
        Ok_NHB_EXP       =  Ok_NHB_wEXP  +  Ok_NHB_dEXP
        Ok_HBS_EXP       =  Ok_HBS_wEXP  +  Ok_HBS_dEXP
        
        Ok_HBW_LRT       =  Ok_HBW_wLRT  +  Ok_HBW_dLRT
        Ok_HBC_LRT       =  Ok_HBC_wLRT  +  Ok_HBC_dLRT
        Ok_HBO_LRT       =  Ok_HBO_wLRT  +  Ok_HBO_dLRT
        Ok_NHB_LRT       =  Ok_NHB_wLRT  +  Ok_NHB_dLRT
        Ok_HBS_LRT       =  Ok_HBS_wLRT  +  Ok_HBS_dLRT
        
        Ok_HBW_CRT       =  Ok_HBW_wCRT  +  Ok_HBW_dCRT
        Ok_HBC_CRT       =  Ok_HBC_wCRT  +  Ok_HBC_dCRT
        Ok_HBO_CRT       =  Ok_HBO_wCRT  +  Ok_HBO_dCRT
        Ok_NHB_CRT       =  Ok_NHB_wCRT  +  Ok_NHB_dCRT
        Ok_HBS_CRT       =  Ok_HBS_wCRT  +  Ok_HBS_dCRT
        
        Ok_HBW_Transit   =  Ok_HBW_LCL  +  Ok_HBW_COR  +  Ok_HBW_BRT  +  Ok_HBW_EXP   +  Ok_HBW_LRT   +  Ok_HBW_CRT
        Ok_HBC_Transit   =  Ok_HBC_LCL  +  Ok_HBC_COR  +  Ok_HBC_BRT  +  Ok_HBC_EXP   +  Ok_HBC_LRT   +  Ok_HBC_CRT
        Ok_HBO_Transit   =  Ok_HBO_LCL  +  Ok_HBO_COR  +  Ok_HBO_BRT  +  Ok_HBO_EXP   +  Ok_HBO_LRT   +  Ok_HBO_CRT
        Ok_NHB_Transit   =  Ok_NHB_LCL  +  Ok_NHB_COR  +  Ok_NHB_BRT  +  Ok_NHB_EXP   +  Ok_NHB_LRT   +  Ok_NHB_CRT
        Ok_HBS_Transit   =  Ok_HBS_LCL  +  Ok_HBS_COR  +  Ok_HBS_BRT  +  Ok_HBS_EXP   +  Ok_HBS_LRT   +  Ok_HBS_CRT
        
        
        
        ;calculate trip totals and print summary file ========================================================
        if (i=ZONES)
            ;calculate daily trips by purpose and mode -------------------------------------------------------
            ;HBW
            Dy_HBW_NonMoto   =  Pk_HBW_NonMoto     +  Ok_HBW_NonMoto
            Dy_HBW_Walk      =  Pk_HBW_Walk        +  Ok_HBW_Walk
            Dy_HBW_Bike      =  Pk_HBW_Bike        +  Ok_HBW_Bike
            Dy_HBW_Auto      =  Pk_HBW_Auto        +  Ok_HBW_Auto
            Dy_HBW_SchoolBus =  Pk_HBW_SchoolBus   +  Ok_HBW_SchoolBus
            Dy_HBW_Transit   =  Pk_HBW_Transit     +  Ok_HBW_Transit
            Dy_HBW_LCL       =  Pk_HBW_LCL         +  Ok_HBW_LCL
            Dy_HBW_COR       =  Pk_HBW_COR         +  Ok_HBW_COR
            Dy_HBW_BRT       =  Pk_HBW_BRT         +  Ok_HBW_BRT
            Dy_HBW_EXP       =  Pk_HBW_EXP         +  Ok_HBW_EXP
            Dy_HBW_LRT       =  Pk_HBW_LRT         +  Ok_HBW_LRT
            Dy_HBW_CRT       =  Pk_HBW_CRT         +  Ok_HBW_CRT
            
            ;HBC
            Dy_HBC_NonMoto   =  Pk_HBC_NonMoto     +  Ok_HBC_NonMoto
            Dy_HBC_Walk      =  Pk_HBC_Walk        +  Ok_HBC_Walk
            Dy_HBC_Bike      =  Pk_HBC_Bike        +  Ok_HBC_Bike
            Dy_HBC_Auto      =  Pk_HBC_Auto        +  Ok_HBC_Auto
            Dy_HBC_SchoolBus =  Pk_HBC_SchoolBus   +  Ok_HBC_SchoolBus
            Dy_HBC_Transit   =  Pk_HBC_Transit     +  Ok_HBC_Transit
            Dy_HBC_LCL       =  Pk_HBC_LCL         +  Ok_HBC_LCL
            Dy_HBC_COR       =  Pk_HBC_COR         +  Ok_HBC_COR
            Dy_HBC_BRT       =  Pk_HBC_BRT         +  Ok_HBC_BRT
            Dy_HBC_EXP       =  Pk_HBC_EXP         +  Ok_HBC_EXP
            Dy_HBC_LRT       =  Pk_HBC_LRT         +  Ok_HBC_LRT
            Dy_HBC_CRT       =  Pk_HBC_CRT         +  Ok_HBC_CRT
            
            ;HBO
            Dy_HBO_NonMoto   =  Pk_HBO_NonMoto     +  Ok_HBO_NonMoto
            Dy_HBO_Walk      =  Pk_HBO_Walk        +  Ok_HBO_Walk
            Dy_HBO_Bike      =  Pk_HBO_Bike        +  Ok_HBO_Bike
            Dy_HBO_Auto      =  Pk_HBO_Auto        +  Ok_HBO_Auto
            Dy_HBO_SchoolBus =  Pk_HBO_SchoolBus   +  Ok_HBO_SchoolBus
            Dy_HBO_Transit   =  Pk_HBO_Transit     +  Ok_HBO_Transit
            Dy_HBO_LCL       =  Pk_HBO_LCL         +  Ok_HBO_LCL
            Dy_HBO_COR       =  Pk_HBO_COR         +  Ok_HBO_COR
            Dy_HBO_BRT       =  Pk_HBO_BRT         +  Ok_HBO_BRT
            Dy_HBO_EXP       =  Pk_HBO_EXP         +  Ok_HBO_EXP
            Dy_HBO_LRT       =  Pk_HBO_LRT         +  Ok_HBO_LRT
            Dy_HBO_CRT       =  Pk_HBO_CRT         +  Ok_HBO_CRT
            
            ;NHB
            Dy_NHB_NonMoto   =  Pk_NHB_NonMoto     +  Ok_NHB_NonMoto
            Dy_NHB_Walk      =  Pk_NHB_Walk        +  Ok_NHB_Walk
            Dy_NHB_Bike      =  Pk_NHB_Bike        +  Ok_NHB_Bike
            Dy_NHB_Auto      =  Pk_NHB_Auto        +  Ok_NHB_Auto
            Dy_NHB_SchoolBus =  Pk_NHB_SchoolBus   +  Ok_NHB_SchoolBus
            Dy_NHB_Transit   =  Pk_NHB_Transit     +  Ok_NHB_Transit
            Dy_NHB_LCL       =  Pk_NHB_LCL         +  Ok_NHB_LCL
            Dy_NHB_COR       =  Pk_NHB_COR         +  Ok_NHB_COR
            Dy_NHB_BRT       =  Pk_NHB_BRT         +  Ok_NHB_BRT
            Dy_NHB_EXP       =  Pk_NHB_EXP         +  Ok_NHB_EXP
            Dy_NHB_LRT       =  Pk_NHB_LRT         +  Ok_NHB_LRT
            Dy_NHB_CRT       =  Pk_NHB_CRT         +  Ok_NHB_CRT
            
            ;HBS
            Dy_HBS_NonMoto   =  Pk_HBS_NonMoto     +  Ok_HBS_NonMoto
            Dy_HBS_Walk      =  Pk_HBS_Walk        +  Ok_HBS_Walk
            Dy_HBS_Bike      =  Pk_HBS_Bike        +  Ok_HBS_Bike
            Dy_HBS_Auto      =  Pk_HBS_Auto        +  Ok_HBS_Auto
            Dy_HBS_SchoolBus =  Pk_HBS_SchoolBus   +  Ok_HBS_SchoolBus
            Dy_HBS_Transit   =  Pk_HBS_Transit     +  Ok_HBS_Transit
            Dy_HBS_LCL       =  Pk_HBS_LCL         +  Ok_HBS_LCL
            Dy_HBS_COR       =  Pk_HBS_COR         +  Ok_HBS_COR
            Dy_HBS_BRT       =  Pk_HBS_BRT         +  Ok_HBS_BRT
            Dy_HBS_EXP       =  Pk_HBS_EXP         +  Ok_HBS_EXP
            Dy_HBS_LRT       =  Pk_HBS_LRT         +  Ok_HBS_LRT
            Dy_HBS_CRT       =  Pk_HBS_CRT         +  Ok_HBS_CRT
            
            
            ;calculate total trips by purpose ----------------------------------------------------------------
            ;  e.g. Column totals
            ;peak
            Pk_HBW_Tot  =  Pk_HBW_NonMoto  +  Pk_HBW_Auto  +  Pk_HBW_SchoolBus  +  Pk_HBW_LCL  +  Pk_HBW_COR  +  Pk_HBW_BRT  +  Pk_HBW_EXP  +  Pk_HBW_LRT  +  Pk_HBW_CRT
            Pk_HBC_Tot  =  Pk_HBC_NonMoto  +  Pk_HBC_Auto  +  Pk_HBC_SchoolBus  +  Pk_HBC_LCL  +  Pk_HBC_COR  +  Pk_HBC_BRT  +  Pk_HBC_EXP  +  Pk_HBC_LRT  +  Pk_HBC_CRT
            Pk_HBO_Tot  =  Pk_HBO_NonMoto  +  Pk_HBO_Auto  +  Pk_HBO_SchoolBus  +  Pk_HBO_LCL  +  Pk_HBO_COR  +  Pk_HBO_BRT  +  Pk_HBO_EXP  +  Pk_HBO_LRT  +  Pk_HBO_CRT
            Pk_NHB_Tot  =  Pk_NHB_NonMoto  +  Pk_NHB_Auto  +  Pk_NHB_SchoolBus  +  Pk_NHB_LCL  +  Pk_NHB_COR  +  Pk_NHB_BRT  +  Pk_NHB_EXP  +  Pk_NHB_LRT  +  Pk_NHB_CRT
            Pk_HBS_Tot  =  Pk_HBS_NonMoto  +  Pk_HBS_Auto  +  Pk_HBS_SchoolBus  +  Pk_HBS_LCL  +  Pk_HBS_COR  +  Pk_HBS_BRT  +  Pk_HBS_EXP  +  Pk_HBS_LRT  +  Pk_HBS_CRT
            
            ;off-peak
            Ok_HBW_Tot  =  Ok_HBW_NonMoto  +  Ok_HBW_Auto  +  Ok_HBW_SchoolBus  +  Ok_HBW_LCL  +  Ok_HBW_COR  +  Ok_HBW_BRT  +  Ok_HBW_EXP  +  Ok_HBW_LRT  +  Ok_HBW_CRT
            Ok_HBC_Tot  =  Ok_HBC_NonMoto  +  Ok_HBC_Auto  +  Ok_HBC_SchoolBus  +  Ok_HBC_LCL  +  Ok_HBC_COR  +  Ok_HBC_BRT  +  Ok_HBC_EXP  +  Ok_HBC_LRT  +  Ok_HBC_CRT
            Ok_HBO_Tot  =  Ok_HBO_NonMoto  +  Ok_HBO_Auto  +  Ok_HBO_SchoolBus  +  Ok_HBO_LCL  +  Ok_HBO_COR  +  Ok_HBO_BRT  +  Ok_HBO_EXP  +  Ok_HBO_LRT  +  Ok_HBO_CRT
            Ok_NHB_Tot  =  Ok_NHB_NonMoto  +  Ok_NHB_Auto  +  Ok_NHB_SchoolBus  +  Ok_NHB_LCL  +  Ok_NHB_COR  +  Ok_NHB_BRT  +  Ok_NHB_EXP  +  Ok_NHB_LRT  +  Ok_NHB_CRT
            Ok_HBS_Tot  =  Ok_HBS_NonMoto  +  Ok_HBS_Auto  +  Ok_HBS_SchoolBus  +  Ok_HBS_LCL  +  Ok_HBS_COR  +  Ok_HBS_BRT  +  Ok_HBS_EXP  +  Ok_HBS_LRT  +  Ok_HBS_CRT
            
            ;daily
            Dy_HBW_Tot  =  Pk_HBW_Tot  +  Ok_HBW_Tot
            Dy_HBC_Tot  =  Pk_HBC_Tot  +  Ok_HBC_Tot
            Dy_HBO_Tot  =  Pk_HBO_Tot  +  Ok_HBO_Tot
            Dy_NHB_Tot  =  Pk_NHB_Tot  +  Ok_NHB_Tot
            Dy_HBS_Tot  =  Pk_HBS_Tot  +  Ok_HBS_Tot
            
            
            ;sum total trips by mode -------------------------------------------------------------------------
            ;  e.g. row totals
            ;peak
            Pk_Sum_NonMoto    =  Pk_HBW_NonMoto    +  Pk_HBC_NonMoto    +  Pk_HBO_NonMoto    +  Pk_NHB_NonMoto    +  Pk_HBS_NonMoto  
            Pk_Sum_Walk       =  Pk_HBW_Walk       +  Pk_HBC_Walk       +  Pk_HBO_Walk       +  Pk_NHB_Walk       +  Pk_HBS_Walk     
            Pk_Sum_Bike       =  Pk_HBW_Bike       +  Pk_HBC_Bike       +  Pk_HBO_Bike       +  Pk_NHB_Bike       +  Pk_HBS_Bike     
            Pk_Sum_Auto       =  Pk_HBW_Auto       +  Pk_HBC_Auto       +  Pk_HBO_Auto       +  Pk_NHB_Auto       +  Pk_HBS_Auto     
            Pk_Sum_SchoolBus  =  Pk_HBW_SchoolBus  +  Pk_HBC_SchoolBus  +  Pk_HBO_SchoolBus  +  Pk_NHB_SchoolBus  +  Pk_HBS_SchoolBus
            Pk_Sum_Transit    =  Pk_HBW_Transit    +  Pk_HBC_Transit    +  Pk_HBO_Transit    +  Pk_NHB_Transit    +  Pk_HBS_Transit  
            Pk_Sum_LCL        =  Pk_HBW_LCL        +  Pk_HBC_LCL        +  Pk_HBO_LCL        +  Pk_NHB_LCL        +  Pk_HBS_LCL    
            Pk_Sum_COR        =  Pk_HBW_COR        +  Pk_HBC_COR        +  Pk_HBO_COR        +  Pk_NHB_COR        +  Pk_HBS_COR     
            Pk_Sum_BRT        =  Pk_HBW_BRT        +  Pk_HBC_BRT        +  Pk_HBO_BRT        +  Pk_NHB_BRT        +  Pk_HBS_BRT     
            Pk_Sum_EXP        =  Pk_HBW_EXP        +  Pk_HBC_EXP        +  Pk_HBO_EXP        +  Pk_NHB_EXP        +  Pk_HBS_EXP      
            Pk_Sum_LRT        =  Pk_HBW_LRT        +  Pk_HBC_LRT        +  Pk_HBO_LRT        +  Pk_NHB_LRT        +  Pk_HBS_LRT      
            Pk_Sum_CRT        =  Pk_HBW_CRT        +  Pk_HBC_CRT        +  Pk_HBO_CRT        +  Pk_NHB_CRT        +  Pk_HBS_CRT      
            Pk_Sum_Tot        =  Pk_HBW_Tot        +  Pk_HBC_Tot        +  Pk_HBO_Tot        +  Pk_NHB_Tot        +  Pk_HBS_Tot      
            
            ;off-peak
            Ok_Sum_NonMoto    =  Ok_HBW_NonMoto    +  Ok_HBC_NonMoto    +  Ok_HBO_NonMoto    +  Ok_NHB_NonMoto    +  Ok_HBS_NonMoto  
            Ok_Sum_Walk       =  Ok_HBW_Walk       +  Ok_HBC_Walk       +  Ok_HBO_Walk       +  Ok_NHB_Walk       +  Ok_HBS_Walk     
            Ok_Sum_Bike       =  Ok_HBW_Bike       +  Ok_HBC_Bike       +  Ok_HBO_Bike       +  Ok_NHB_Bike       +  Ok_HBS_Bike     
            Ok_Sum_Auto       =  Ok_HBW_Auto       +  Ok_HBC_Auto       +  Ok_HBO_Auto       +  Ok_NHB_Auto       +  Ok_HBS_Auto     
            Ok_Sum_SchoolBus  =  Ok_HBW_SchoolBus  +  Ok_HBC_SchoolBus  +  Ok_HBO_SchoolBus  +  Ok_NHB_SchoolBus  +  Ok_HBS_SchoolBus
            Ok_Sum_Transit    =  Ok_HBW_Transit    +  Ok_HBC_Transit    +  Ok_HBO_Transit    +  Ok_NHB_Transit    +  Ok_HBS_Transit  
            Ok_Sum_LCL        =  Ok_HBW_LCL        +  Ok_HBC_LCL        +  Ok_HBO_LCL        +  Ok_NHB_LCL        +  Ok_HBS_LCL    
            Ok_Sum_COR        =  Ok_HBW_COR        +  Ok_HBC_COR        +  Ok_HBO_COR        +  Ok_NHB_COR        +  Ok_HBS_COR     
            Ok_Sum_BRT        =  Ok_HBW_BRT        +  Ok_HBC_BRT        +  Ok_HBO_BRT        +  Ok_NHB_BRT        +  Ok_HBS_BRT     
            Ok_Sum_EXP        =  Ok_HBW_EXP        +  Ok_HBC_EXP        +  Ok_HBO_EXP        +  Ok_NHB_EXP        +  Ok_HBS_EXP      
            Ok_Sum_LRT        =  Ok_HBW_LRT        +  Ok_HBC_LRT        +  Ok_HBO_LRT        +  Ok_NHB_LRT        +  Ok_HBS_LRT      
            Ok_Sum_CRT        =  Ok_HBW_CRT        +  Ok_HBC_CRT        +  Ok_HBO_CRT        +  Ok_NHB_CRT        +  Ok_HBS_CRT      
            Ok_Sum_Tot        =  Ok_HBW_Tot        +  Ok_HBC_Tot        +  Ok_HBO_Tot        +  Ok_NHB_Tot        +  Ok_HBS_Tot      
            
            ;daily
            Dy_Sum_NonMoto    =  Dy_HBW_NonMoto    +  Dy_HBC_NonMoto    +  Dy_HBO_NonMoto    +  Dy_NHB_NonMoto    +  Dy_HBS_NonMoto  
            Dy_Sum_Walk       =  Dy_HBW_Walk       +  Dy_HBC_Walk       +  Dy_HBO_Walk       +  Dy_NHB_Walk       +  Dy_HBS_Walk     
            Dy_Sum_Bike       =  Dy_HBW_Bike       +  Dy_HBC_Bike       +  Dy_HBO_Bike       +  Dy_NHB_Bike       +  Dy_HBS_Bike     
            Dy_Sum_Auto       =  Dy_HBW_Auto       +  Dy_HBC_Auto       +  Dy_HBO_Auto       +  Dy_NHB_Auto       +  Dy_HBS_Auto     
            Dy_Sum_SchoolBus  =  Dy_HBW_SchoolBus  +  Dy_HBC_SchoolBus  +  Dy_HBO_SchoolBus  +  Dy_NHB_SchoolBus  +  Dy_HBS_SchoolBus
            Dy_Sum_Transit    =  Dy_HBW_Transit    +  Dy_HBC_Transit    +  Dy_HBO_Transit    +  Dy_NHB_Transit    +  Dy_HBS_Transit  
            Dy_Sum_LCL        =  Dy_HBW_LCL        +  Dy_HBC_LCL        +  Dy_HBO_LCL        +  Dy_NHB_LCL        +  Dy_HBS_LCL    
            Dy_Sum_COR        =  Dy_HBW_COR       +   Dy_HBC_COR       +   Dy_HBO_COR        +  Dy_NHB_COR        +  Dy_HBS_COR     
            Dy_Sum_BRT        =  Dy_HBW_BRT       +   Dy_HBC_BRT       +   Dy_HBO_BRT        +  Dy_NHB_BRT        +  Dy_HBS_BRT     
            Dy_Sum_EXP        =  Dy_HBW_EXP        +  Dy_HBC_EXP        +  Dy_HBO_EXP        +  Dy_NHB_EXP        +  Dy_HBS_EXP      
            Dy_Sum_LRT        =  Dy_HBW_LRT        +  Dy_HBC_LRT        +  Dy_HBO_LRT        +  Dy_NHB_LRT        +  Dy_HBS_LRT      
            Dy_Sum_CRT        =  Dy_HBW_CRT        +  Dy_HBC_CRT        +  Dy_HBO_CRT        +  Dy_NHB_CRT        +  Dy_HBS_CRT      
            Dy_Sum_Tot        =  Dy_HBW_Tot        +  Dy_HBC_Tot        +  Dy_HBO_Tot        +  Dy_NHB_Tot        +  Dy_HBS_Tot      
            
            
            
            ;print trip share summary --------------------------------------------------------------------------------
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_Shares_Summary.csv',
                CSV=T, 
                FORM=10.2,
                LIST='@ScenarioDir@'  ,
                     '\n'             ,
                     '\nPeak'         ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Pk_HBW_NonMoto  ,  Pk_HBC_NonMoto  ,  Pk_HBO_NonMoto  ,  Pk_NHB_NonMoto  ,  Pk_HBS_NonMoto  ,  Pk_Sum_NonMoto  ,
                     '\n  Walk'       ,  Pk_HBW_Walk     ,  Pk_HBC_Walk     ,  Pk_HBO_Walk     ,  Pk_NHB_Walk     ,  Pk_HBS_Walk     ,  Pk_Sum_Walk     ,
                     '\n  Bike'       ,  Pk_HBW_Bike     ,  Pk_HBC_Bike     ,  Pk_HBO_Bike     ,  Pk_NHB_Bike     ,  Pk_HBS_Bike     ,  Pk_Sum_Bike     ,
                     '\nAuto'         ,  Pk_HBW_Auto     ,  Pk_HBC_Auto     ,  Pk_HBO_Auto     ,  Pk_NHB_Auto     ,  Pk_HBS_Auto     ,  Pk_Sum_Auto     ,
                     '\nSchool Bus'   ,  Pk_HBW_SchoolBus,  Pk_HBC_SchoolBus,  Pk_HBO_SchoolBus,  Pk_NHB_SchoolBus,  Pk_HBS_SchoolBus,  Pk_Sum_SchoolBus,
                     '\nTransit'      ,  Pk_HBW_Transit  ,  Pk_HBC_Transit  ,  Pk_HBO_Transit  ,  Pk_NHB_Transit  ,  Pk_HBS_Transit  ,  Pk_Sum_Transit  ,
                     '\n  Local'      ,  Pk_HBW_LCL      ,  Pk_HBC_LCL      ,  Pk_HBO_LCL      ,  Pk_NHB_LCL      ,  Pk_HBS_LCL      ,  Pk_Sum_LCL      ,
                     '\n  COR 1'      ,  Pk_HBW_COR      ,  Pk_HBC_COR      ,  Pk_HBO_COR      ,  Pk_NHB_COR      ,  Pk_HBS_COR      ,  Pk_Sum_COR      ,
                     '\n  COR 3'      ,  Pk_HBW_BRT      ,  Pk_HBC_BRT      ,  Pk_HBO_BRT      ,  Pk_NHB_BRT      ,  Pk_HBS_BRT      ,  Pk_Sum_BRT      ,
                     '\n  Express'    ,  Pk_HBW_EXP      ,  Pk_HBC_EXP      ,  Pk_HBO_EXP      ,  Pk_NHB_EXP      ,  Pk_HBS_EXP      ,  Pk_Sum_EXP      ,
                     '\n  LRT'        ,  Pk_HBW_LRT      ,  Pk_HBC_LRT      ,  Pk_HBO_LRT      ,  Pk_NHB_LRT      ,  Pk_HBS_LRT      ,  Pk_Sum_LRT      ,
                     '\n  CRT'        ,  Pk_HBW_CRT      ,  Pk_HBC_CRT      ,  Pk_HBO_CRT      ,  Pk_NHB_CRT      ,  Pk_HBS_CRT      ,  Pk_Sum_CRT      ,
                     '\nTotal Trips'  ,  Pk_HBW_Tot      ,  Pk_HBC_Tot      ,  Pk_HBO_Tot      ,  Pk_NHB_Tot      ,  Pk_HBS_Tot      ,  Pk_Sum_Tot      ,
                     '\n'             ,
                     '\n'             ,
                     '\nOff-Peak'     ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Ok_HBW_NonMoto  ,  Ok_HBC_NonMoto  ,  Ok_HBO_NonMoto  ,  Ok_NHB_NonMoto  ,  Ok_HBS_NonMoto  ,  Ok_Sum_NonMoto  ,
                     '\n  Walk'       ,  Ok_HBW_Walk     ,  Ok_HBC_Walk     ,  Ok_HBO_Walk     ,  Ok_NHB_Walk     ,  Ok_HBS_Walk     ,  Ok_Sum_Walk     ,
                     '\n  Bike'       ,  Ok_HBW_Bike     ,  Ok_HBC_Bike     ,  Ok_HBO_Bike     ,  Ok_NHB_Bike     ,  Ok_HBS_Bike     ,  Ok_Sum_Bike     ,
                     '\nAuto'         ,  Ok_HBW_Auto     ,  Ok_HBC_Auto     ,  Ok_HBO_Auto     ,  Ok_NHB_Auto     ,  Ok_HBS_Auto     ,  Ok_Sum_Auto     ,
                     '\nSchool Bus'   ,  Ok_HBW_SchoolBus,  Ok_HBC_SchoolBus,  Ok_HBO_SchoolBus,  Ok_NHB_SchoolBus,  Ok_HBS_SchoolBus,  Ok_Sum_SchoolBus,
                     '\nTransit'      ,  Ok_HBW_Transit  ,  Ok_HBC_Transit  ,  Ok_HBO_Transit  ,  Ok_NHB_Transit  ,  Ok_HBS_Transit  ,  Ok_Sum_Transit  ,
                     '\n  Local'      ,  Ok_HBW_LCL      ,  Ok_HBC_LCL      ,  Ok_HBO_LCL      ,  Ok_NHB_LCL      ,  Ok_HBS_LCL      ,  Ok_Sum_LCL      ,
                     '\n  COR 1'      ,  Ok_HBW_COR      ,  Ok_HBC_COR      ,  Ok_HBO_COR      ,  Ok_NHB_COR      ,  Ok_HBS_COR      ,  Ok_Sum_COR      ,
                     '\n  COR 3'      ,  Ok_HBW_BRT      ,  Ok_HBC_BRT      ,  Ok_HBO_BRT      ,  Ok_NHB_BRT      ,  Ok_HBS_BRT      ,  Ok_Sum_BRT      ,
                     '\n  Express'    ,  Ok_HBW_EXP      ,  Ok_HBC_EXP      ,  Ok_HBO_EXP      ,  Ok_NHB_EXP      ,  Ok_HBS_EXP      ,  Ok_Sum_EXP      ,
                     '\n  LRT'        ,  Ok_HBW_LRT      ,  Ok_HBC_LRT      ,  Ok_HBO_LRT      ,  Ok_NHB_LRT      ,  Ok_HBS_LRT      ,  Ok_Sum_LRT      ,
                     '\n  CRT'        ,  Ok_HBW_CRT      ,  Ok_HBC_CRT      ,  Ok_HBO_CRT      ,  Ok_NHB_CRT      ,  Ok_HBS_CRT      ,  Ok_Sum_CRT      ,
                     '\nTotal Trips'  ,  Ok_HBW_Tot      ,  Ok_HBC_Tot      ,  Ok_HBO_Tot      ,  Ok_NHB_Tot      ,  Ok_HBS_Tot      ,  Ok_Sum_Tot      ,
                     '\n'             ,
                     '\n'             ,
                     '\nDaily'        ,
                     '\nMode'         ,  'HBW', 'HBC',  'HBO',  'NHB',  'HBSch', 'Total',
                     '\nNon-Motorized',  Dy_HBW_NonMoto  ,  Dy_HBC_NonMoto  ,  Dy_HBO_NonMoto  ,  Dy_NHB_NonMoto  ,  Dy_HBS_NonMoto  ,  Dy_Sum_NonMoto  ,
                     '\n  Walk'       ,  Dy_HBW_Walk     ,  Dy_HBC_Walk     ,  Dy_HBO_Walk     ,  Dy_NHB_Walk     ,  Dy_HBS_Walk     ,  Dy_Sum_Walk     ,
                     '\n  Bike'       ,  Dy_HBW_Bike     ,  Dy_HBC_Bike     ,  Dy_HBO_Bike     ,  Dy_NHB_Bike     ,  Dy_HBS_Bike     ,  Dy_Sum_Bike     ,
                     '\nAuto'         ,  Dy_HBW_Auto     ,  Dy_HBC_Auto     ,  Dy_HBO_Auto     ,  Dy_NHB_Auto     ,  Dy_HBS_Auto     ,  Dy_Sum_Auto     ,
                     '\nSchool Bus'   ,  Dy_HBW_SchoolBus,  Dy_HBC_SchoolBus,  Dy_HBO_SchoolBus,  Dy_NHB_SchoolBus,  Dy_HBS_SchoolBus,  Dy_Sum_SchoolBus,
                     '\nTransit'      ,  Dy_HBW_Transit  ,  Dy_HBC_Transit  ,  Dy_HBO_Transit  ,  Dy_NHB_Transit  ,  Dy_HBS_Transit  ,  Dy_Sum_Transit  ,
                     '\n  Local'      ,  Dy_HBW_LCL      ,  Dy_HBC_LCL      ,  Dy_HBO_LCL      ,  Dy_NHB_LCL      ,  Dy_HBS_LCL      ,  Dy_Sum_LCL      ,
                     '\n  COR 1'      ,  Dy_HBW_COR      ,  Dy_HBC_COR      ,  Dy_HBO_COR      ,  Dy_NHB_COR      ,  Dy_HBS_COR      ,  Dy_Sum_COR      ,
                     '\n  COR 3'      ,  Dy_HBW_BRT      ,  Dy_HBC_BRT      ,  Dy_HBO_BRT      ,  Dy_NHB_BRT      ,  Dy_HBS_BRT      ,  Dy_Sum_BRT      ,
                     '\n  Express'    ,  Dy_HBW_EXP      ,  Dy_HBC_EXP      ,  Dy_HBO_EXP      ,  Dy_NHB_EXP      ,  Dy_HBS_EXP      ,  Dy_Sum_EXP      ,
                     '\n  LRT'        ,  Dy_HBW_LRT      ,  Dy_HBC_LRT      ,  Dy_HBO_LRT      ,  Dy_NHB_LRT      ,  Dy_HBS_LRT      ,  Dy_Sum_LRT      ,
                     '\n  CRT'        ,  Dy_HBW_CRT      ,  Dy_HBC_CRT      ,  Dy_HBO_CRT      ,  Dy_NHB_CRT      ,  Dy_HBS_CRT      ,  Dy_Sum_CRT      ,
                     '\nTotal Trips'  ,  Dy_HBW_Tot      ,  Dy_HBC_Tot      ,  Dy_HBO_Tot      ,  Dy_NHB_Tot      ,  Dy_HBS_Tot      ,  Dy_Sum_Tot      ,
                     '\n'

            ;print trip share summary - normalized for easy combining with other scenarios-----------------------------------------------------------------
            FILEO PRINTO[1]='@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_Shares_Summary_long.csv'

            PRINT FORM=L CSV=T LIST='SUBAREAID', 'PERIOD','TRIPPURP', 'MODE'     ,'TRIPS'           PRINTO=1 ;header row
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'Walk'     , Pk_HBW_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'Walk'     , Pk_HBC_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'Walk'     , Pk_HBO_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'Walk'     , Pk_NHB_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'Walk'     , Pk_HBS_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'Bike'     , Pk_HBW_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'Bike'     , Pk_HBC_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'Bike'     , Pk_HBO_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'Bike'     , Pk_NHB_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'Bike'     , Pk_HBS_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'Auto'     , Pk_HBW_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'Auto'     , Pk_HBC_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'Auto'     , Pk_HBO_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'Auto'     , Pk_NHB_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'Auto'     , Pk_HBS_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'SchoolBus', Pk_HBW_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'SchoolBus', Pk_HBC_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'SchoolBus', Pk_HBO_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'SchoolBus', Pk_NHB_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'SchoolBus', Pk_HBS_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'LCL'      , Pk_HBW_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'LCL'      , Pk_HBC_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'LCL'      , Pk_HBO_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'LCL'      , Pk_NHB_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'LCL'      , Pk_HBS_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'COR'      , Pk_HBW_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'COR'      , Pk_HBC_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'COR'      , Pk_HBO_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'COR'      , Pk_NHB_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'COR'      , Pk_HBS_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'BRT'      , Pk_HBW_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'BRT'      , Pk_HBC_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'BRT'      , Pk_HBO_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'BRT'      , Pk_NHB_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'BRT'      , Pk_HBS_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'EXP'      , Pk_HBW_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'EXP'      , Pk_HBC_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'EXP'      , Pk_HBO_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'EXP'      , Pk_NHB_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'EXP'      , Pk_HBS_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'LRT'      , Pk_HBW_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'LRT'      , Pk_HBC_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'LRT'      , Pk_HBO_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'LRT'      , Pk_NHB_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'LRT'      , Pk_HBS_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBW'     , 'CRT'      , Pk_HBW_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBC'     , 'CRT'      , Pk_HBC_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBO'     , 'CRT'      , Pk_HBO_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'NHB'     , 'CRT'      , Pk_NHB_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'pk'    ,'HBSch'   , 'CRT'      , Pk_HBS_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'Walk'     , Ok_HBW_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'Walk'     , Ok_HBC_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'Walk'     , Ok_HBO_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'Walk'     , Ok_NHB_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'Walk'     , Ok_HBS_Walk      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'Bike'     , Ok_HBW_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'Bike'     , Ok_HBC_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'Bike'     , Ok_HBO_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'Bike'     , Ok_NHB_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'Bike'     , Ok_HBS_Bike      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'Auto'     , Ok_HBW_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'Auto'     , Ok_HBC_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'Auto'     , Ok_HBO_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'Auto'     , Ok_NHB_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'Auto'     , Ok_HBS_Auto      PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'SchoolBus', Ok_HBW_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'SchoolBus', Ok_HBC_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'SchoolBus', Ok_HBO_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'SchoolBus', Ok_NHB_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'SchoolBus', Ok_HBS_SchoolBus PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'LCL'      , Ok_HBW_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'LCL'      , Ok_HBC_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'LCL'      , Ok_HBO_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'LCL'      , Ok_NHB_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'LCL'      , Ok_HBS_LCL       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'COR'      , Ok_HBW_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'COR'      , Ok_HBC_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'COR'      , Ok_HBO_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'COR'      , Ok_NHB_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'COR'      , Ok_HBS_COR       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'BRT'      , Ok_HBW_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'BRT'      , Ok_HBC_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'BRT'      , Ok_HBO_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'BRT'      , Ok_NHB_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'BRT'      , Ok_HBS_BRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'EXP'      , Ok_HBW_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'EXP'      , Ok_HBC_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'EXP'      , Ok_HBO_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'EXP'      , Ok_NHB_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'EXP'      , Ok_HBS_EXP       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'LRT'      , Ok_HBW_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'LRT'      , Ok_HBC_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'LRT'      , Ok_HBO_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'LRT'      , Ok_NHB_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'LRT'      , Ok_HBS_LRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBW'     , 'CRT'      , Ok_HBW_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBC'     , 'CRT'      , Ok_HBC_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBO'     , 'CRT'      , Ok_HBO_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'NHB'     , 'CRT'      , Ok_NHB_CRT       PRINTO=1
            PRINT FORM=L CSV=T LIST=1          , 'ok'    ,'HBSch'   , 'CRT'      , Ok_HBS_CRT       PRINTO=1
            
        endif  ;i=ZONES
        
    ENDRUN


;Cluster: bring together all distributed steps before continuing
BARRIER IDLIST='Shares_Proc2', 'Shares_Proc3', 'Shares_Proc4', 'Shares_Proc5' CheckReturnCode=T




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Mode Shares Report                 ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN


if (Run_vizTool=1)

RUN PGM=MATRIX MSG='0: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "tripshares"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion      = "@ModelVersion@"',
             '\nScenarioGroup     = "@ScenarioGroup@"',
             '\nRunYear           = @RunYear@',
             '\n',
             '\ninputFile         = r"@ParentDir@@ScenarioDir@4_ModeChoice\4_Shares\@RID@_Shares_Summary_long.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json for transit routes
;  note using single asterix minimizes the command window when executed, double asterix executes the command window non-minimized
;  note: the 1>&2 echos the python window output to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ParentDir@@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ParentDir@@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0


;DOS command to delete '__pycache__' folder
;  note: '/s' removes folder & contents of folder includling any subfolders
;  note: '/q' denotes quite mode, meaning doesn't ask for confirmation to delete
*(rmdir /s /q "_Log\__pycache__")
*(rmdir /s /q "@ParentDir@2_ModelScripts\_Python\py-vizTool\__pycache__")


endif  ;Run_vizTool=1




*(del 16_SharesReport.txt)
