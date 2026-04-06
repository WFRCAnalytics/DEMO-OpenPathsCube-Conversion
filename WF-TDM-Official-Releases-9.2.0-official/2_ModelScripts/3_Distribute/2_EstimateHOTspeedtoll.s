
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(echo model crashed > 2_EstimateHOTSpeedToll.txt)  ;In case TP+ crashes during batch, this will halt process & help identify error location.



;get start time
ScriptStartTime = currenttime()



RUN PGM=NETWORK MSG='Distribution: Extract subset of Loaded Network and fields for HOT system with five speeds'
FILEI LINKI = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Link_tmp.dbf'

FILEO LINKO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_LoadedNet_HOTsystem.dbf',
    INCLUDE=LINKID          ,
            A               ,
            B               ,
            Distance        ,
            FT              ,
            HOT_ZONEID(10.0),
            FF_TIME(10.2)   ,
            AM_TIME(10.2)   ,
            MD_TIME(10.2)   ,
            PM_TIME(10.2)   ,
            EV_TIME(10.2)   ,
            FF_SPD(10.2)    ,
            AM_SPD(10.2)    ,
            MD_SPD(10.2)    ,
            PM_SPD(10.2)    ,
            EV_SPD(10.2)   
   
    PHASE=LINKMERGE
        if (li.1.HOT_ZONEID=0 | li.1.FT=39)  DELETE
    ENDPHASE

ENDRUN



RUN PGM=MATRIX  MSG='Distribution: Average Link speed Data by HOT_ZONEID'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_LoadedNet_HOTsystem.dbf',
    SORT=HOT_ZONEID, 
    AUTOARRAY=ALLFIELDS

FILEO RECO[1] = '@ParentDir@@ScenarioDir@3_Distribute\_averageGPspeedBYhotzoneid.dbf',
    FIELDS=GISIDIdx        ,
           HOT_ZONEID(10.0),
           NumLinks(10.0)  ,
           Distance        ,
           FF_TIME         ,
           AM_TIME         ,
           MD_TIME         ,
           PM_TIME         ,
           EV_TIME         ,       
           AV_FF_SPD       ,    ;average speed in corridor (essentially VMT/VHT)
           AV_AM_SPD       ,
           AV_MD_SPD       ,
           AV_PM_SPD       ,
           AV_EV_SPD       ,
           HOTSPD_AM       ,
           HOTSPD_MD       ,           
           HOTSPD_PM       ,           
           HOTSPD_EV       ,           
           HOTTLL_AM(10.0) ,           
           HOTTLL_MD(10.0) ,           
           HOTTLL_PM(10.0) ,           
           HOTTLL_EV(10.0) 
    
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    
    ;define arrays
    ARRAY GISArray     = 99999,
          NumLinks     = 99999,
          Distance     = 99999,
          FF_TIME      = 99999,
          AM_TIME      = 99999,
          MD_TIME      = 99999,
          PM_TIME      = 99999,
          EV_TIME      = 99999,
          AV_FF_SPD    = 99999,
          AV_AM_SPD    = 99999,
          AV_MD_SPD    = 99999,
          AV_PM_SPD    = 99999,
          AV_EV_SPD    = 99999, 
          PrjArray     = 99999
    
    
    
    ;initialize variable
    PrjIdx=0
    
    
    ;loop through link records
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;assign GISID
        HOT_ZONEID = dba.1.HOT_ZONEID[numrec]
            
            ;count number of projects (PrjIdx) and assign GISID to array using PrjIdx as array index
            if (PrjIdx=0)
                PrjIdx           = 1
                PrjArray[PrjIdx] = HOT_ZONEID    
            
            elseif (HOT_ZONEID<>PrjArray[PrjIdx])
                PrjIdx           = PrjIdx + 1
                PrjArray[PrjIdx] = HOT_ZONEID
            endif
            
            
        if (dba.1.FT[numrec]=22-26,32-36)    
            ;count number of links in a segment
            NumLinks[PrjIdx] = NumLinks[PrjIdx] + 1        
            
            ;sum GISID total Volume
            DISTANCE[PrjIdx] = DISTANCE[PrjIdx] + dba.1.DISTANCE[numrec]
            
            FF_TIME[PrjIdx] = FF_TIME[PrjIdx] +  dba.1.FF_TIME[numrec]
            AM_TIME[PrjIdx] = AM_TIME[PrjIdx] +  dba.1.AM_TIME[numrec]
            MD_TIME[PrjIdx] = MD_TIME[PrjIdx] +  dba.1.MD_TIME[numrec]
            PM_TIME[PrjIdx] = PM_TIME[PrjIdx] +  dba.1.PM_TIME[numrec]
            EV_TIME[PrjIdx] = EV_TIME[PrjIdx] +  dba.1.EV_TIME[numrec]
        
        endif
    
    ENDLOOP  ;loop through link records
    
    
    ;loop through unique GISIDs
    LOOP numrec=1, PrjIdx
        
        ;assign output variables
        RO.GISIDIdx   = numrec
        RO.HOT_ZONEID = PrjArray[numrec]
        RO.NumLinks   = NumLinks[numrec]
        
        RO.DISTANCE = DISTANCE[numrec]
        
        
        ;total time
        RO.FF_TIME = FF_TIME[numrec]
        RO.AM_TIME = AM_TIME[numrec]
        RO.MD_TIME = MD_TIME[numrec]
        RO.PM_TIME = PM_TIME[numrec]
        RO.EV_TIME = EV_TIME[numrec]
        
        
        ;average general purpose lane speed in zone
        if (FF_TIME[numrec]=0)
            RO.AV_FF_SPD = 0
        else
            RO.AV_FF_SPD = Distance[numrec] / (FF_TIME[numrec] / 60)
        endif
        
        if (AM_TIME[numrec]=0)
            RO.AV_AM_SPD = 0
        else
            RO.AV_AM_SPD = Distance[numrec] / (AM_TIME[numrec] / 60)
        endif
        
        if (MD_TIME[numrec]=0)
            RO.AV_MD_SPD = 0
        else
            RO.AV_MD_SPD = Distance[numrec] / (MD_TIME[numrec] / 60)
        endif
        
        if (PM_TIME[numrec]=0)
            RO.AV_PM_SPD = 0
        else
            RO.AV_PM_SPD = Distance[numrec] / (PM_TIME[numrec] / 60)
        endif
        
        if (EV_TIME[numrec]=0)
            RO.AV_EV_SPD = 0
        else
            RO.AV_EV_SPD = Distance[numrec] / (EV_TIME[numrec] / 60)
        endif
        
        
        ;HOT speed is a function of average GP lane speed in zone (regressed from UDOT data)
        ;   HOT_Speed = 115.48 * GP_Speed / (33.9 + GP_Speed)
        RO.HOTSPD_AM = 115.48 * RO.AV_AM_SPD / (33.9 + RO.AV_AM_SPD)
        RO.HOTSPD_MD = 115.48 * RO.AV_MD_SPD / (33.9 + RO.AV_MD_SPD)
        RO.HOTSPD_PM = 115.48 * RO.AV_PM_SPD / (33.9 + RO.AV_PM_SPD)
        RO.HOTSPD_EV = 115.48 * RO.AV_EV_SPD / (33.9 + RO.AV_EV_SPD)
        
        ;HOT fee is a function of min/max fee allowed & the GP lane speed in zone (regressed from UDOT data)
        ;   HOT_Toll = MinToll + ((MaxToll - MinToll) / (1 + EXP(-0.15 * (48 - GP_Speed) ) ) )
        _Ini_Toll_AM = ROUND(@HOT_Toll_Min@ + ((@HOT_Toll_Max@ - @HOT_Toll_Min@) / (1 + EXP(-0.15 * (48 - RO.AV_AM_SPD)))) )
        _Ini_Toll_MD = ROUND(@HOT_Toll_Min@ + ((@HOT_Toll_Max@ - @HOT_Toll_Min@) / (1 + EXP(-0.15 * (48 - RO.AV_MD_SPD)))) )
        _Ini_Toll_PM = ROUND(@HOT_Toll_Min@ + ((@HOT_Toll_Max@ - @HOT_Toll_Min@) / (1 + EXP(-0.15 * (48 - RO.AV_PM_SPD)))) )
        _Ini_Toll_EV = ROUND(@HOT_Toll_Min@ + ((@HOT_Toll_Max@ - @HOT_Toll_Min@) / (1 + EXP(-0.15 * (48 - RO.AV_EV_SPD)))) )
        
        
        ;round toll to nearest incrament of 5 cents
        ;set incrament value (i.e. round to nearest x)
        _incrament = 5
        
        ;determine the value in the 'ones' position (i.e. #,##D.##)
        _D_Toll_AM = (_Ini_Toll_AM / 10  -  INT(_Ini_Toll_AM / 10) )  *  10
        _D_Toll_MD = (_Ini_Toll_MD / 10  -  INT(_Ini_Toll_MD / 10) )  *  10
        _D_Toll_PM = (_Ini_Toll_PM / 10  -  INT(_Ini_Toll_PM / 10) )  *  10
        _D_Toll_EV = (_Ini_Toll_EV / 10  -  INT(_Ini_Toll_EV / 10) )  *  10
        
        ;calculate amount to add to the initial value to round to nearest incrament
        if (_D_Toll_AM < 1/2 * _incrament)  _add_Toll_AM = 0 * _incrament - _D_Toll_AM
        if (_D_Toll_MD < 1/2 * _incrament)  _add_Toll_MD = 0 * _incrament - _D_Toll_MD
        if (_D_Toll_PM < 1/2 * _incrament)  _add_Toll_PM = 0 * _incrament - _D_Toll_PM
        if (_D_Toll_EV < 1/2 * _incrament)  _add_Toll_EV = 0 * _incrament - _D_Toll_EV
        
        if (_D_Toll_AM >= 1/2 * _incrament  &  _D_Toll_AM < 3/2 * _incrament)  _add_Toll_AM = 1 * _incrament - _D_Toll_AM
        if (_D_Toll_MD >= 1/2 * _incrament  &  _D_Toll_MD < 3/2 * _incrament)  _add_Toll_MD = 1 * _incrament - _D_Toll_MD
        if (_D_Toll_PM >= 1/2 * _incrament  &  _D_Toll_PM < 3/2 * _incrament)  _add_Toll_PM = 1 * _incrament - _D_Toll_PM
        if (_D_Toll_EV >= 1/2 * _incrament  &  _D_Toll_EV < 3/2 * _incrament)  _add_Toll_EV = 1 * _incrament - _D_Toll_EV
        
        if (_D_Toll_AM >= 3/2 * _incrament)  _add_Toll_AM = 2 * _incrament - _D_Toll_AM
        if (_D_Toll_MD >= 3/2 * _incrament)  _add_Toll_MD = 2 * _incrament - _D_Toll_MD
        if (_D_Toll_PM >= 3/2 * _incrament)  _add_Toll_PM = 2 * _incrament - _D_Toll_PM
        if (_D_Toll_EV >= 3/2 * _incrament)  _add_Toll_EV = 2 * _incrament - _D_Toll_EV
        
        ;calculate toll rounded to nearest incrament
        RO.HOTTLL_AM = _Ini_Toll_AM + _add_Toll_AM
        RO.HOTTLL_MD = _Ini_Toll_MD + _add_Toll_MD
        RO.HOTTLL_PM = _Ini_Toll_PM + _add_Toll_PM
        RO.HOTTLL_EV = _Ini_Toll_EV + _add_Toll_EV
        
        ;write output dbf
        WRITE RECO=1
        
    ENDLOOP  ;PrjIdx

ENDRUN



RUN PGM=NETWORK  MSG='Distribution: Output Distribution Network - Detailed'

FILEI  NODEI = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Node_tmp.dbf'
FILEI  LINKI = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Link_tmp.dbf'

FILEI  LOOKUPI[1] = '@ParentDir@@ScenarioDir@3_Distribute\_averageGPspeedBYhotzoneid.dbf'

FILEO  NETO = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.net'
    
    
    ZONES   = @Usedzones@
    
    
    LOOKUP LOOKUPI=1, 
        INTERPOLATE=F, 
        NAME=HOTSPDtoll,
        LOOKUP[1]=HOT_ZONEID, RESULT=HOTSPD_AM,
        LOOKUP[2]=HOT_ZONEID, RESULT=HOTSPD_MD,
        LOOKUP[3]=HOT_ZONEID, RESULT=HOTSPD_PM,
        LOOKUP[4]=HOT_ZONEID, RESULT=HOTSPD_EV,
        LOOKUP[5]=HOT_ZONEID, RESULT=HOTTLL_AM ,
        LOOKUP[6]=HOT_ZONEID, RESULT=HOTTLL_MD ,
        LOOKUP[7]=HOT_ZONEID, RESULT=HOTTLL_PM ,
        LOOKUP[8]=HOT_ZONEID, RESULT=HOTTLL_EV  
    
    
    PHASE=LINKMERGE
    
       if (li.1.FT=38-39 & li.1.HOT_ZONEID>0)
           ;look up speed for HOT lane
           AM_SPD = HOTSPDtoll(1, li.1.HOT_ZONEID)      ;HOT_Speed_AM
           MD_SPD = HOTSPDtoll(2, li.1.HOT_ZONEID)      ;HOT_Speed_MD
           PM_SPD = HOTSPDtoll(3, li.1.HOT_ZONEID)      ;HOT_Speed_PM
           EV_SPD = HOTSPDtoll(4, li.1.HOT_ZONEID)      ;HOT_Speed_EV
           
           ;calculate HOT lane time
           AM_TIME = 60 * li.1.Distance / AM_SPD
           MD_TIME = 60 * li.1.Distance / MD_SPD
           PM_TIME = 60 * li.1.Distance / PM_SPD
           EV_TIME = 60 * li.1.Distance / EV_SPD
       endif
       
       ;ensure times and speeds are slower than free flow
       AM_SPD = MIN(li.1.FF_SPD,  AM_SPD)
       MD_SPD = MIN(li.1.FF_SPD,  MD_SPD)
       PM_SPD = MIN(li.1.FF_SPD,  PM_SPD)
       EV_SPD = MIN(li.1.FF_SPD,  EV_SPD)
       
       AM_TIME = MAX(li.1.FF_TIME,  AM_TIME)
       MD_TIME = MAX(li.1.FF_TIME,  MD_TIME)
       PM_TIME = MAX(li.1.FF_TIME,  PM_TIME)
       EV_TIME = MAX(li.1.FF_TIME,  EV_TIME)
       
       ;round speed and time
       FF_SPD = ROUND(FF_SPD * 10) / 10
       AM_SPD = ROUND(AM_SPD * 10) / 10
       MD_SPD = ROUND(MD_SPD * 10) / 10
       PM_SPD = ROUND(PM_SPD * 10) / 10
       EV_SPD = ROUND(EV_SPD * 10) / 10
       DY_SPD = ROUND(DY_SPD * 10) / 10
       
       ;calculate HOT lane time
       FF_TIME = ROUND(FF_TIME * 1000) / 1000
       AM_TIME = ROUND(AM_TIME * 1000) / 1000
       MD_TIME = ROUND(MD_TIME * 1000) / 1000
       PM_TIME = ROUND(PM_TIME * 1000) / 1000
       EV_TIME = ROUND(EV_TIME * 1000) / 1000
       DY_TIME = ROUND(DY_TIME * 1000) / 1000
       
       
       ;read in HOT fee
       if (li.1.HOT_CHRGPT>0 & li.1.HOT_ZONEID>0)
           HOT_CHRGAM = HOTSPDtoll(5, li.1.HOT_ZONEID) * li.1.HOT_CHRGPT
           HOT_CHRGMD = HOTSPDtoll(6, li.1.HOT_ZONEID) * li.1.HOT_CHRGPT
           HOT_CHRGPM = HOTSPDtoll(7, li.1.HOT_ZONEID) * li.1.HOT_CHRGPT
           HOT_CHRGEV = HOTSPDtoll(8, li.1.HOT_ZONEID) * li.1.HOT_CHRGPT
       endif
       
    ENDPHASE
         
ENDRUN



;create summary distribution network
RUN PGM=NETWORK  MSG='Distribution: Output Distribution Network - Summary'
FILEI NETI  = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.net'

FILEO LINKO = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.dbf'

FILEO NETO  = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Summary.net',
    INCLUDE=A               ,
            B               ,
            DISTANCE        ,
            STREET          ,
            ONEWAY          ,
            EXTERNAL        ,
            LANES           ,
            FT              ,
            SFAC            ,
            CFAC            ,
            TRK_RSTRCT      ,
            HOV_LYEAR       ,
            Op_Proj         ,
            Rel_Ln          ,
            SEL_LINK        ,
            
            LINKID          ,
            TAZID           ,
            SEGID           ,
            SUBAREAID       ,
            HOT_ZONEID      ,
            HOT_CHRGPT      ,
            RMPGPID         ,
            MANFWYID        ,
            
            FTCLASS         ,
            URBANVAL        ,
            AREATYPE        ,
            ATYPENAME       ,
            ATYPEGRP        ,
            LANE_MILE       ,
            ANGLE           ,
            DIRECTION       ,
            IB_OB           ,
            PkDirPrd        ,
            @AddLinkFields@ ,
            
            CO_TAZID        ,
            CO_FIPS         ,
            CO_NAME         ,
            CITY_FIPS       ,
            CITY_UGRC       ,
            CITY_NAME       ,
            DISTLRG         ,
            DLRG_NAME       ,
            DISTMED         ,
            DMED_NAME       ,
            DISTSML         ,
            DSML_NAME       ,
            REMM            ,
            CBD             ,
            
            CAP1HR1LN       ,
            RelCap1Hr       ,
            AM_CAP          ,
            MD_CAP          ,
            PM_CAP          ,
            EV_CAP          ,
            AdHOVCap1H      ,
            
            FF_RAMPPEN      ,
            AM_RAMPPEN      ,
            MD_RAMPPEN      ,
            PM_RAMPPEN      ,
            EV_RAMPPEN      ,
            DY_RAMPPEN      ,
            
            HOT_CHRGAM      ,
            HOT_CHRGMD      ,
            HOT_CHRGPM      ,
            HOT_CHRGEV      ,
            
            AM_VOL          ,
            MD_VOL          ,
            PM_VOL          ,
            EV_VOL          ,
            DY_VOL          ,
            DY_VOL2WY       ,
            DY_1k           ,
            DY_1k_2wy       ,
            
            AM_VC           ,
            MD_VC           ,
            PM_VC           ,
            EV_VC           ,
            
            FF_SPD          ,
            AM_SPD          ,
            MD_SPD          ,
            PM_SPD          ,
            EV_SPD          ,
            DY_SPD          ,
            FF_TkSpd_M      ,
            AM_TkSpd_M      ,
            MD_TkSpd_M      ,
            PM_TkSpd_M      ,
            EV_TkSpd_M      ,
            DY_TkSpd_M      ,
            FF_TkSpd_H      ,
            AM_TkSpd_H      ,
            MD_TkSpd_H      ,
            PM_TkSpd_H      ,
            EV_TkSpd_H      ,
            DY_TkSpd_H      ,
            
            FF_TIME         ,
            AM_TIME         ,
            MD_TIME         ,
            PM_TIME         ,
            EV_TIME         ,
            DY_TIME         ,
            FF_TkTme_M      ,
            AM_TkTme_M      ,
            MD_TkTme_M      ,
            PM_TkTme_M      ,
            EV_TkTme_M      ,
            DY_TkTme_M      ,
            FF_TkTme_H      ,
            AM_TkTme_H      ,
            MD_TkTme_H      ,
            PM_TkTme_H      ,
            EV_TkTme_H      ,
            DY_TkTme_H      ,
            
            AM_VMT          ,
            MD_VMT          ,
            PM_VMT          ,
            EV_VMT          ,
            DY_VMT          ,
            
            FF_VHT          ,
            AM_VHT          ,
            MD_VHT          ,
            PM_VHT          ,
            EV_VHT          ,
            DY_VHT          ,
            
            AM_DELAY        ,
            MD_DELAY        ,
            PM_DELAY        ,
            EV_DELAY        ,
            DY_DELAY        ,
            
            FF_BTI_TME      ,
            AM_BTI_TME      ,
            MD_BTI_TME      ,
            PM_BTI_TME      ,
            EV_BTI_TME      ,
            DY_BTI_TME      
        
    ZONES = @Usedzones@
    
ENDRUN



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Estimate HOT Speed and Toll        ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



*(del 2_EstimateHOTSpeedToll.txt)
