
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_Distribution.txt)




;INITIALIZE DATA ===========================================================================================================================

;get start time
ScriptStartTime = currenttime()


;print time stamp
RUN PGM=MATRIX

    ZONES = 1
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n----------------------------------------------------------------------',
             '\nDISTRIBUTION',
             '\n    Begin Distribution Model           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss')
    
ENDRUN



;add K factors
RUN PGM=MATRIX  MSG='Distribution: Create K Factors'
FILEO MATO[1]='@ParentDir@@ScenarioDir@Temp\3_Distribute\K_FACTORS.mtx', 
    mo=1-4,
    name=Wrk,
         Oth,
         Trk,
         Ext
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
    ZONES = @UsedZones@
    
    
    
    ;print status to task monitor window
    PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
    PrintProgInc = 1
    
    if (i=FIRSTZONE)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = PrintProgInc
    elseif (PrintProgress=CheckProgress)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = CheckProgress + PrintProgInc
    endif
    
    
    
    mw[1] = 1    ;Wrk
    mw[2] = 1    ;Oth
    mw[3] = 1    ;Trk
    mw[4] = 1    ;Ext
    
    
    JLOOP
        
        ;set K-factors for county ranges
        if ((i=@SLRange@ & j=@UtahRange@) | (i=@UtahRange@ & j=@SLRange@))
            
            mw[1] = @SL_UT_KFAC_Wrk@    ;Wrk
            mw[2] = @SL_UT_KFAC_Oth@    ;Oth
            mw[3] = @SL_UT_KFAC_Trk@    ;Trk
            mw[4] = @SL_UT_KFAC_Ext@    ;Ext
            
        elseif ((i=@SLRange@ & j=@DavisRange@) | (i=@DavisRange@ & j=@SLRange@))
            
            mw[1] = @SL_DA_KFAC_Wrk@    ;Wrk
            mw[2] = @SL_DA_KFAC_Oth@    ;Oth
            mw[3] = @SL_DA_KFAC_Trk@    ;Trk
            mw[4] = @SL_DA_KFAC_Ext@    ;Ext
            
        elseif ((i=@WeberRange@ & j=@BoxElderRange@) | (i=@BoxElderRange@ & j=@WeberRange@))
            
            mw[1] = @WE_BE_KFAC_Wrk@    ;Wrk
            mw[2] = @WE_BE_KFAC_Oth@    ;Oth
            mw[3] = @WE_BE_KFAC_Trk@    ;Trk
            mw[4] = @WE_BE_KFAC_Ext@    ;Ext
            
        endif  ;i & j = county ranges
        
    ENDJLOOP
    
ENDRUN



;initialize distribution network
RUN PGM=NETWORK  MSG='Distribution: Initialize Network'
FILEI NETI = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'

FILEO NODEO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_0_tmp_Node.dbf'

FILEO LINKO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_0_tmp_Link.dbf',
    INCLUDE=A               ,
            B               ,
            DISTANCE        ,
            STREET          ,
            ONEWAY          ,
            EXTERNAL        ,
            LANES           ,
            FT              ,
            SFAC(10.3)      ,
            CFAC(10.3)      ,
            TRK_RSTRCT      ,
            HOV_LYEAR       ,
            Op_Proj         ,
            Rel_Ln          ,
            SEL_LINK        ,
            
            LINKID          ,
            TAZID           ,
            SEGID(20)       ,
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
            CO_NAME(20)     ,
            CITY_FIPS       ,
            CITY_UGRC       ,
            CITY_NAME(40)   ,
            DISTLRG         ,
            DLRG_NAME(60)   ,
            DISTMED         ,
            DMED_NAME(60)   ,
            DISTSML         ,
            DSML_NAME(60)   ,
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
            
            AM_VOL(10.1)    ,
            MD_VOL(10.1)    ,
            PM_VOL(10.1)    ,
            EV_VOL(10.1)    ,
            DY_VOL(10.1)    ,
            DY_VOL2WY(10.1) ,
            DY_1k(10.1)     ,
            DY_1k_2wy(10.1) ,
            
            AM_VC(10.3)     ,
            MD_VC(10.3)     ,
            PM_VC(10.3)     ,
            EV_VC(10.3)     ,
            
            FF_SPD(10.1)    ,
            AM_SPD(10.1)    ,
            MD_SPD(10.1)    ,
            PM_SPD(10.1)    ,
            EV_SPD(10.1)    ,
            DY_SPD(10.1)    ,
            FF_TkSpd_M(10.1),
            AM_TkSpd_M(10.1),
            MD_TkSpd_M(10.1),
            PM_TkSpd_M(10.1),
            EV_TkSpd_M(10.1),
            DY_TkSpd_M(10.1),
            FF_TkSpd_H(10.1),
            AM_TkSpd_H(10.1),
            MD_TkSpd_H(10.1),
            PM_TkSpd_H(10.1),
            EV_TkSpd_H(10.1),
            DY_TkSpd_H(10.1),
            
            FF_TIME(10.4)   ,
            AM_TIME(10.4)   ,
            MD_TIME(10.4)   ,
            PM_TIME(10.4)   ,
            EV_TIME(10.4)   ,
            DY_TIME(10.4)   ,
            FF_TkTme_M(10.4),
            AM_TkTme_M(10.4),
            MD_TkTme_M(10.4),
            PM_TkTme_M(10.4),
            EV_TkTme_M(10.4),
            DY_TkTme_M(10.4),
            FF_TkTme_H(10.4),
            AM_TkTme_H(10.4),
            MD_TkTme_H(10.4),
            PM_TkTme_H(10.4),
            EV_TkTme_H(10.4),
            DY_TkTme_H(10.4),
            
            AM_VMT(10.2)    ,
            MD_VMT(10.2)    ,
            PM_VMT(10.2)    ,
            EV_VMT(10.2)    ,
            DY_VMT(10.2)    ,
            
            FF_VHT(10.2)    ,
            AM_VHT(10.2)    ,
            MD_VHT(10.2)    ,
            PM_VHT(10.2)    ,
            EV_VHT(10.2)    ,
            DY_VHT(10.2)    ,
            
            AM_DELAY(10.3)  ,
            MD_DELAY(10.3)  ,
            PM_DELAY(10.3)  ,
            EV_DELAY(10.3)  ,
            DY_DELAY(10.3)  ,
            
            FF_BTI_TME(10.2),
            AM_BTI_TME(10.2),
            MD_BTI_TME(10.2),
            PM_BTI_TME(10.2),
            EV_BTI_TME(10.2),
            DY_BTI_TME(10.2)
    
    
    ;parameters
    ZONES = @Usedzones@
    
    
    PHASE = LINKMERGE
        
        ;set subareaid variable
        SUBAREAID = 1
        
        
        ;read in data from distribution loaded network
        AM_RAMPPEN = li.1.FF_RampPen
        MD_RAMPPEN = li.1.FF_RampPen
        PM_RAMPPEN = li.1.FF_RampPen
        EV_RAMPPEN = li.1.FF_RampPen
        DY_RAMPPEN = li.1.FF_RampPen
        
        HOT_CHRGAM = 0
        HOT_CHRGMD = 0
        HOT_CHRGPM = 0
        HOT_CHRGEV = 0
        
        AM_VOL     = 0
        MD_VOL     = 0
        PM_VOL     = 0
        EV_VOL     = 0
        DY_VOL     = 0
        DY_VOL2WY  = 0
        DY_1k      = 0
        DY_1k_2wy  = 0
        
        AM_VC      = 0
        MD_VC      = 0
        PM_VC      = 0
        EV_VC      = 0
        
        FF_SPD     = li.1.FF_SPD
        AM_SPD     = li.1.FF_SPD
        MD_SPD     = li.1.FF_SPD
        PM_SPD     = li.1.FF_SPD
        EV_SPD     = li.1.FF_SPD
        DY_SPD     = li.1.FF_SPD
        
        ;calculate initial truck speed and time
        ;  note: slow down trucks by 3mph for MD, 5mph for HV
        ;    Medium Truck   Auto   Truck  Speed   Time 
        ;                   Speed  Speed  Factor  Factor
        ;      Freeway       70      67    0.96    1.04
        ;      Expressway    50      47    0.94    1.06
        ;      Arterial      40      37    0.93    1.08
        ;      Collector     30      27    0.90    1.11
        ;    
        ;    Heavy Truck    Auto   Truck  Speed   Time 
        ;                   Speed  Speed  Factor  Factor
        ;      Freeway       70      65    0.93    1.08
        ;      Expressway    50      45    0.90    1.11
        ;      Arterial      40      35    0.88    1.14
        ;      Collector     30      25    0.83    1.20
        ;set truck speed - MD travel 3mph slower & HV travel 5mph slower
        ;  note: minimum truck speed: MD=4mph, HV=3mph
        FF_TkSpd_M = MAX(4, (FF_SPD - 3))
        AM_TkSpd_M = MAX(4, (AM_SPD - 3))
        MD_TkSpd_M = MAX(4, (MD_SPD - 3))
        PM_TkSpd_M = MAX(4, (PM_SPD - 3))
        EV_TkSpd_M = MAX(4, (EV_SPD - 3))
        DY_TkSpd_M = MAX(4, (DY_SPD - 3))
        
        FF_TkSpd_H = MAX(3, (FF_SPD - 5))
        AM_TkSpd_H = MAX(3, (AM_SPD - 5))
        MD_TkSpd_H = MAX(3, (MD_SPD - 5))
        PM_TkSpd_H = MAX(3, (PM_SPD - 5))
        EV_TkSpd_H = MAX(3, (EV_SPD - 5))
        DY_TkSpd_H = MAX(3, (DY_SPD - 5))
        
        FF_TIME    = li.1.FF_TIME
        AM_TIME    = li.1.FF_TIME
        MD_TIME    = li.1.FF_TIME
        PM_TIME    = li.1.FF_TIME
        EV_TIME    = li.1.FF_TIME
        DY_TIME    = li.1.FF_TIME
        
        FF_TkTme_M = li.1.DISTANCE * 60 / FF_TkSpd_M
        AM_TkTme_M = li.1.DISTANCE * 60 / AM_TkSpd_M
        MD_TkTme_M = li.1.DISTANCE * 60 / MD_TkSpd_M
        PM_TkTme_M = li.1.DISTANCE * 60 / PM_TkSpd_M
        EV_TkTme_M = li.1.DISTANCE * 60 / EV_TkSpd_M
        DY_TkTme_M = li.1.DISTANCE * 60 / DY_TkSpd_M
        
        FF_TkTme_H = li.1.DISTANCE * 60 / FF_TkSpd_H
        AM_TkTme_H = li.1.DISTANCE * 60 / AM_TkSpd_H
        MD_TkTme_H = li.1.DISTANCE * 60 / MD_TkSpd_H
        PM_TkTme_H = li.1.DISTANCE * 60 / PM_TkSpd_H
        EV_TkTme_H = li.1.DISTANCE * 60 / EV_TkSpd_H
        DY_TkTme_H = li.1.DISTANCE * 60 / DY_TkSpd_H
        
        AM_VMT     = 0
        MD_VMT     = 0
        PM_VMT     = 0
        EV_VMT     = 0
        DY_VMT     = 0
        
        FF_VHT     = 0
        AM_VHT     = 0
        MD_VHT     = 0
        PM_VHT     = 0
        EV_VHT     = 0
        DY_VHT     = 0
        
        AM_DELAY   = 0
        MD_DELAY   = 0
        PM_DELAY   = 0
        EV_DELAY   = 0
        DY_DELAY   = 0
        
        FF_BTI_TME = 0
        AM_BTI_TME = 0
        MD_BTI_TME = 0
        PM_BTI_TME = 0
        EV_BTI_TME = 0
        DY_BTI_TME = 0
        
    ENDPHASE
    
    
    PHASE=SUMMARY
        
        print file='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
            APPEND=T,  
            form=13.0C, 
            list='\n',
                 '\n',
                 '\n;*********************************************************************',
                 '\n',
                 '\nDISTRIBUTION',
                 '\n'
    ENDPHASE
    
ENDRUN


;initialize distribution network
RUN PGM=NETWORK  MSG='Distribution: Initialize Network'
    FILEI NODEI = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_0_tmp_Node.dbf'
    FILEI LINKI = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_0_tmp_Link.dbf'
    
    FILEO  NETO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_0_tmp.net'
    
    ZONES = @UsedZones@
    
ENDRUN



;print time stamp
RUN PGM=MATRIX

    ZONES = 1
    
    SubScriptEndTime_IN = currenttime()
    SubScriptRunTime_IN = SubScriptEndTime_IN - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n        Initialize highway network  ', formatdatetime(SubScriptRunTime_IN, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;begin Distribution Feedback Loop ==========================================================================================================
LOOP n=1, 10
    
    ;get time stamp
    SubScriptStartTime_FB = currenttime()
    
    
    ;print time stamp
    RUN PGM=MATRIX
        
        ZONES = 1
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n',
                 '\n        FB Loop @n@           ', formatdatetime(@SubScriptStartTime_FB@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;calculate previous iteration variables
    n_1 = n-1
    n_2 = n-2
    
    
    
    
    ;SKIMS =================================================================================================================================
    
    ;get start time
    SubScriptStartTime_SK = currenttime()
    
    
    
    ;build generalized cost path & skim times, distance, toll distance, & generalized cost
    RUN PGM=HIGHWAY  MSG='Distribution: Feedback Loop @n@ - Step 1: Perform Skims'
        
        FILEI  NETI     = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'
               TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
               ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF.mtx',
            mo=101-118,  
            NAME=time_Auto_WRK, distance_Auto_WRK, gentime_Auto_WRK,
                 time_Auto_Per, distance_Auto_Per, gentime_Auto_Per,
                 time_Auto_Ext, distance_Auto_Ext, gentime_Auto_Ext,
                 time_Truck_LT, distance_Truck_LT, gentime_Truck_LT,
                 time_Truck_MD, distance_Truck_MD, gentime_Truck_MD,
                 time_Truck_HV, distance_Truck_HV, gentime_Truck_HV
        
        FILEO MATO[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_AM.mtx',
            mo=201-218,  
            NAME=time_Auto_WRK, distance_Auto_WRK, gentime_Auto_WRK,
                 time_Auto_Per, distance_Auto_Per, gentime_Auto_Per,
                 time_Auto_Ext, distance_Auto_Ext, gentime_Auto_Ext,
                 time_Truck_LT, distance_Truck_LT, gentime_Truck_LT,
                 time_Truck_MD, distance_Truck_MD, gentime_Truck_MD,
                 time_Truck_HV, distance_Truck_HV, gentime_Truck_HV
        
        FILEO MATO[3] = '@ParentDir@@ScenarioDir@3_Distribute\skm_MD.mtx',
            mo=301-318,  
            NAME=time_Auto_WRK, distance_Auto_WRK, gentime_Auto_WRK,
                 time_Auto_Per, distance_Auto_Per, gentime_Auto_Per,
                 time_Auto_Ext, distance_Auto_Ext, gentime_Auto_Ext,
                 time_Truck_LT, distance_Truck_LT, gentime_Truck_LT,
                 time_Truck_MD, distance_Truck_MD, gentime_Truck_MD,
                 time_Truck_HV, distance_Truck_HV, gentime_Truck_HV 
        
        FILEO MATO[4] = '@ParentDir@@ScenarioDir@3_Distribute\skm_PM.mtx',
            mo=401-418,  
            NAME=time_Auto_WRK, distance_Auto_WRK, gentime_Auto_WRK,
                 time_Auto_Per, distance_Auto_Per, gentime_Auto_Per,
                 time_Auto_Ext, distance_Auto_Ext, gentime_Auto_Ext,
                 time_Truck_LT, distance_Truck_LT, gentime_Truck_LT,
                 time_Truck_MD, distance_Truck_MD, gentime_Truck_MD,
                 time_Truck_HV, distance_Truck_HV, gentime_Truck_HV
        
        FILEO MATO[5] = '@ParentDir@@ScenarioDir@3_Distribute\skm_EV.mtx',
            mo=501-518,  
            NAME=time_Auto_WRK, distance_Auto_WRK, gentime_Auto_WRK,
                 time_Auto_Per, distance_Auto_Per, gentime_Auto_Per,
                 time_Auto_Ext, distance_Auto_Ext, gentime_Auto_Ext,
                 time_Truck_LT, distance_Truck_LT, gentime_Truck_LT,
                 time_Truck_MD, distance_Truck_MD, gentime_Truck_MD,
                 time_Truck_HV, distance_Truck_HV, gentime_Truck_HV
        
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        
        ZONES    = @UsedZones@
        ZONEMSG  = 1
        
        
        
        PHASE=LINKREAD
            
            ;assign LINKCLASS for VDF lookup ---------------------------------------------------------------------------
            ;centroid connectors
            if (li.FT=1)
                LINKCLASS = 10
            
            ;freeways, including sys-sys ramps and GP, HOV, HOT, HOV-HOT Access & Toll lanes
            elseif (li.FT=20-21, 30-40)
                LINKCLASS = 1
            
            ;managed motorways main line
            elseif (li.FT=22-27)
                LINKCLASS = 6
            
            ;ramps
            elseif (li.FT=28-29, 41-42)
                LINKCLASS = 2
            
            ;expressways
            elseif (li.FT=12-15)
                LINKCLASS = 3
            
            ;principal and minor arterials
            elseif (li.FT=2-3)
                LINKCLASS = 4
            
            ;collectors & locals
            elseif (li.FT=4-7)
                LINKCLASS = 5
            
            ;default to arterial
            else
                LINKCLASS = 4
                
            endif
            
            
            
            ;set lane GROUPS -------------------------------------------------------------------------------------------
            if (li.FT=37)          ADDTOGROUP = 1           ;HOV
            if (li.FT=38)          ADDTOGROUP = 2           ;HOT
            if (li.FT=39)          ADDTOGROUP = 3           ;HOV & HOT access links
            if (li.FT=40)          ADDTOGROUP = 4           ;Tollway
            if (li.TRK_RSTRCT<>0)  ADDTOGROUP = 5           ;truck restricted links
            
            
            ;;relibility lane 11-19 (reversible lanes) on freeways, exclude off-peak direction from path choice
            ;if (li.Rel_LN=10-19 & li.FT>=20)
            ;    
            ;    ;AM & EV lane excluded from OB direction, MD & PM lane excluded from IB direction
            ;    if (li.IB_OB='OB')  ADDTOGROUP = 7          ;whatperiod=1,4
            ;    if (li.IB_OB='IB')  ADDTOGROUP = 8          ;whatperiod=2-3
            ;
            ;endif  ;li.Rel_LN=10-19 & li.FT>=20
            
            
            
            ;add toll penalty for Tollway (in cents) -------------------------------------------------------------------
            if (li.FT=40)
                
                lw.TPen_Pk = li.DISTANCE * @Cost_Toll_Pk@
                lw.TPen_Ok = li.DISTANCE * @Cost_Toll_Ok@
                
            endif  ;li.FT=40
            
            
            
            ;calculate truck penalty -----------------------------------------------------------------------------------
            lw.FF_TrkPen_MD = MAX(0, li.FF_TkTme_M - li.FF_TIME)
            lw.AM_TrkPen_MD = MAX(0, li.AM_TkTme_M - li.AM_TIME)
            lw.MD_TrkPen_MD = MAX(0, li.MD_TkTme_M - li.MD_TIME)
            lw.PM_TrkPen_MD = MAX(0, li.PM_TkTme_M - li.PM_TIME)
            lw.EV_TrkPen_MD = MAX(0, li.EV_TkTme_M - li.EV_TIME)
            
            lw.FF_TrkPen_HV = MAX(0, li.FF_TkTme_H - li.FF_TIME)
            lw.AM_TrkPen_HV = MAX(0, li.AM_TkTme_H - li.AM_TIME)
            lw.MD_TrkPen_HV = MAX(0, li.MD_TkTme_H - li.MD_TIME)
            lw.PM_TrkPen_HV = MAX(0, li.PM_TkTme_H - li.PM_TIME)
            lw.EV_TrkPen_HV = MAX(0, li.EV_TkTme_H - li.EV_TIME)
            
            
            
            ;initialize generalized time values for all links ----------------------------------------------------------
            ; Auto Business Trip
            lw.COST_Auto_WRK_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Wrk@  +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_WRK_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Wrk@  +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_WRK_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Wrk@  +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_WRK_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Wrk@  +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_WRK_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Wrk@  +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            
            ; Auto Non-work
            lw.COST_Auto_PER_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Per@  +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_PER_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Per@  +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_PER_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Per@  +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_PER_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Per@  +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_PER_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Per@  +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            
            ; Auto External Trip
            lw.COST_Auto_Ext_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Ext@  +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_Ext_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Ext@  +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_Ext_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Ext@  +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Auto_Ext_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Ext@  +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Auto_Ext_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_Auto@ / @VOT_Auto_Ext@  +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            
            ; Light truck
            lw.COST_Truck_LT_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_LT@ / @VOT_LT@          +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Truck_LT_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_LT@ / @VOT_LT@          +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Truck_LT_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_LT@ / @VOT_LT@          +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            lw.COST_Truck_LT_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_LT@ / @VOT_LT@          +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@
            lw.COST_Truck_LT_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_LT@ / @VOT_LT@          +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@
            
            ; Medium truck
            lw.COST_Truck_MD_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_MD@ / @VOT_MD@          +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.FF_TrkPen_MD
            lw.COST_Truck_MD_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_MD@ / @VOT_MD@          +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@  +  lw.AM_TrkPen_MD
            lw.COST_Truck_MD_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_MD@ / @VOT_MD@          +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.MD_TrkPen_MD
            lw.COST_Truck_MD_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_MD@ / @VOT_MD@          +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@  +  lw.PM_TrkPen_MD
            lw.COST_Truck_MD_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_MD@ / @VOT_MD@          +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.EV_TrkPen_MD
            
            ; Heavy truck
            lw.COST_Truck_HV_FF  =  li.FF_TIME   +  li.DISTANCE * @AOC_HV@ / @VOT_HV@          +  li.FF_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.FF_TrkPen_HV
            lw.COST_Truck_HV_AM  =  li.AM_TIME   +  li.DISTANCE * @AOC_HV@ / @VOT_HV@          +  li.AM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@  +  lw.AM_TrkPen_HV
            lw.COST_Truck_HV_MD  =  li.MD_TIME   +  li.DISTANCE * @AOC_HV@ / @VOT_HV@          +  li.MD_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.MD_TrkPen_HV
            lw.COST_Truck_HV_PM  =  li.PM_TIME   +  li.DISTANCE * @AOC_HV@ / @VOT_HV@          +  li.PM_RampPen * @RampPenWeight@  +  lw.TPen_Pk / @VOT_Toll@  +  lw.PM_TrkPen_HV
            lw.COST_Truck_HV_EV  =  li.EV_TIME   +  li.DISTANCE * @AOC_HV@ / @VOT_HV@          +  li.EV_RampPen * @RampPenWeight@  +  lw.TPen_Ok / @VOT_Toll@  +  lw.EV_TrkPen_HV
            
            
            ;calculate total time
            lw.TotTime_FF = li.FF_TIME + li.FF_RampPen
            lw.TotTime_AM = li.AM_TIME + li.AM_RampPen
            lw.TotTime_MD = li.MD_TIME + li.MD_RampPen
            lw.TotTime_PM = li.PM_TIME + li.PM_RampPen
            lw.TotTime_EV = li.EV_TIME + li.EV_RampPen
            
            lw.TotTime_TrM_FF = li.FF_TIME + li.FF_RampPen + lw.FF_TrkPen_MD
            lw.TotTime_TrM_AM = li.AM_TIME + li.AM_RampPen + lw.AM_TrkPen_MD
            lw.TotTime_TrM_MD = li.MD_TIME + li.MD_RampPen + lw.MD_TrkPen_MD
            lw.TotTime_TrM_PM = li.PM_TIME + li.PM_RampPen + lw.PM_TrkPen_MD
            lw.TotTime_TrM_EV = li.EV_TIME + li.EV_RampPen + lw.EV_TrkPen_MD
            
            lw.TotTime_TrH_FF = li.FF_TIME + li.FF_RampPen + lw.FF_TrkPen_HV
            lw.TotTime_TrH_AM = li.AM_TIME + li.AM_RampPen + lw.AM_TrkPen_HV
            lw.TotTime_TrH_MD = li.MD_TIME + li.MD_RampPen + lw.MD_TrkPen_HV
            lw.TotTime_TrH_PM = li.PM_TIME + li.PM_RampPen + lw.PM_TrkPen_HV
            lw.TotTime_TrH_EV = li.EV_TIME + li.EV_RampPen + lw.EV_TrkPen_HV
            
        ENDPHASE
        
        
        
        PHASE=ILOOP
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 1
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            ;skim general cost paths (exclude managed lanes: HOV, HOT)
            
            ;free flow ---------------------------------------------------------------------------------
            ;work
            PATHLOAD PATH=lw.COST_Auto_Wrk_FF,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[101]=PATHTRACE(lw.TotTime_FF),          NOACCESS=10000,      ;Travel times
                mw[102]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[103]=PATHTRACE(lw.COST_Auto_Wrk_FF),    NOACCESS=10000       ;The generalized cost matrix
            
            ;non-work 
            PATHLOAD PATH=lw.COST_Auto_Per_FF,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[104]=PATHTRACE(lw.TotTime_FF),          NOACCESS=10000,      ;Travel times
                mw[105]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[106]=PATHTRACE(lw.COST_Auto_Per_FF),    NOACCESS=10000       ;The generalized cost matrix
                
            ;external    
            PATHLOAD PATH=lw.COST_Auto_Ext_FF,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[107]=PATHTRACE(lw.TotTime_FF),          NOACCESS=10000,      ;Travel times
                mw[108]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[109]=PATHTRACE(lw.COST_Auto_Ext_FF),    NOACCESS=10000       ;The generalized cost matrix
                
            ;light truck
            PATHLOAD PATH=lw.COST_Truck_LT_FF,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[110]=PATHTRACE(lw.TotTime_FF),          NOACCESS=10000,      ;Travel times
                mw[111]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[112]=PATHTRACE(lw.COST_Truck_LT_FF),    NOACCESS=10000       ;The generalized cost matrix
            
            ;medium truck
            PATHLOAD PATH=lw.COST_Truck_MD_FF,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[113]=PATHTRACE(lw.TotTime_TrM_FF),      NOACCESS=10000,      ;Travel times
                mw[114]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[115]=PATHTRACE(lw.COST_Truck_MD_FF),    NOACCESS=10000       ;The generalized cost matrix
            
            ;heavy truck
            PATHLOAD PATH=lw.COST_Truck_HV_FF,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[116]=PATHTRACE(lw.TotTime_TrH_FF),      NOACCESS=10000,      ;Travel times
                mw[117]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[118]=PATHTRACE(lw.COST_Truck_HV_FF),    NOACCESS=10000       ;The generalized cost matrix
            
            
            ;AM ----------------------------------------------------------------------------------------
            ;HBW
            PATHLOAD PATH=lw.COST_Auto_Wrk_AM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[201]=PATHTRACE(lw.TotTime_AM),          NOACCESS=10000,      ;Travel times
                mw[202]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[203]=PATHTRACE(lw.COST_Auto_Wrk_AM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;non-work trips 
            PATHLOAD PATH=lw.COST_Auto_Per_AM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[204]=PATHTRACE(lw.TotTime_AM),          NOACCESS=10000,      ;Travel times
                mw[205]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[206]=PATHTRACE(lw.COST_Auto_Per_AM),    NOACCESS=10000       ;The generalized cost matrix
                
            ;external trips    
            PATHLOAD PATH=lw.COST_Auto_Ext_AM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[207]=PATHTRACE(lw.TotTime_AM),          NOACCESS=10000,      ;Travel times
                mw[208]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[209]=PATHTRACE(lw.COST_Auto_Ext_AM),    NOACCESS=10000       ;The generalized cost matrix
                
            ;Assignment for light truck
            PATHLOAD PATH=lw.COST_Truck_LT_AM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[210]=PATHTRACE(lw.TotTime_AM),          NOACCESS=10000,      ;Travel times
                mw[211]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[212]=PATHTRACE(lw.COST_Truck_LT_AM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for medium truck
            PATHLOAD PATH=lw.COST_Truck_MD_AM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[213]=PATHTRACE(lw.TotTime_TrM_AM),      NOACCESS=10000,      ;Travel times
                mw[214]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[215]=PATHTRACE(lw.COST_Truck_MD_AM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for heavy truck
            PATHLOAD PATH=lw.COST_Truck_HV_AM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[216]=PATHTRACE(lw.TotTime_TrH_AM),      NOACCESS=10000,      ;Travel times
                mw[217]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[218]=PATHTRACE(lw.COST_Truck_HV_AM),    NOACCESS=10000       ;The generalized cost matrix
            
            
            ;MD ---------------------------------------------------------------------------------------
            ;HBW
            PATHLOAD PATH=lw.COST_Auto_Wrk_MD,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[301]=PATHTRACE(lw.TotTime_MD),          NOACCESS=10000,      ;Travel times
                mw[302]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[303]=PATHTRACE(lw.COST_Auto_Wrk_MD),    NOACCESS=10000       ;The generalized cost matrix
            
            ;non-work trips 
            PATHLOAD PATH=lw.COST_Auto_Per_MD,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[304]=PATHTRACE(lw.TotTime_MD),          NOACCESS=10000,      ;Travel times
                mw[305]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[306]=PATHTRACE(lw.COST_Auto_Per_MD),    NOACCESS=10000       ;The generalized cost matrix
                
            ;external trips    
            PATHLOAD PATH=lw.COST_Auto_Ext_MD,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[307]=PATHTRACE(lw.TotTime_MD),          NOACCESS=10000,      ;Travel times
                mw[308]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[309]=PATHTRACE(lw.COST_Auto_Ext_MD),    NOACCESS=10000       ;The generalized cost matrix
                
            ;Assignment for light truck
            PATHLOAD PATH=lw.COST_Truck_LT_MD,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[310]=PATHTRACE(lw.TotTime_MD),          NOACCESS=10000,      ;Travel times
                mw[311]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[312]=PATHTRACE(lw.COST_Truck_LT_MD),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for medium truck
            PATHLOAD PATH=lw.COST_Truck_MD_MD,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[313]=PATHTRACE(lw.TotTime_TrM_MD),      NOACCESS=10000,      ;Travel times
                mw[314]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[315]=PATHTRACE(lw.COST_Truck_MD_MD),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for heavy truck
            PATHLOAD PATH=lw.COST_Truck_HV_MD,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[316]=PATHTRACE(lw.TotTime_TrH_MD),      NOACCESS=10000,      ;Travel times
                mw[317]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[318]=PATHTRACE(lw.COST_Truck_HV_MD),    NOACCESS=10000       ;The generalized cost matrix
            
            
            ;PM ----------------------------------------------------------------------------------------
            ;HBW
            PATHLOAD PATH=lw.COST_Auto_Wrk_PM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[401]=PATHTRACE(lw.TotTime_PM),          NOACCESS=10000,      ;Travel times
                mw[402]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[403]=PATHTRACE(lw.COST_Auto_Wrk_PM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;non-work trips 
            PATHLOAD PATH=lw.COST_Auto_Per_PM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[404]=PATHTRACE(lw.TotTime_PM),          NOACCESS=10000,      ;Travel times
                mw[405]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[406]=PATHTRACE(lw.COST_Auto_Per_PM),    NOACCESS=10000       ;The generalized cost matrix
                
            ;external trips    
            PATHLOAD PATH=lw.COST_Auto_Ext_PM,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[407]=PATHTRACE(lw.TotTime_PM),          NOACCESS=10000,      ;Travel times
                mw[408]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[409]=PATHTRACE(lw.COST_Auto_Ext_PM),    NOACCESS=10000       ;The generalized cost matrix
                
            ;Assignment for light truck
            PATHLOAD PATH=lw.COST_Truck_LT_PM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[410]=PATHTRACE(lw.TotTime_PM),          NOACCESS=10000,      ;Travel times
                mw[411]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[412]=PATHTRACE(lw.COST_Truck_LT_PM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for medium truck
            PATHLOAD PATH=lw.COST_Truck_MD_PM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[413]=PATHTRACE(lw.TotTime_TrM_PM),      NOACCESS=10000,      ;Travel times
                mw[414]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[415]=PATHTRACE(lw.COST_Truck_MD_PM),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for heavy truck
            PATHLOAD PATH=lw.COST_Truck_HV_PM,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[416]=PATHTRACE(lw.TotTime_TrH_PM),      NOACCESS=10000,      ;Travel times
                mw[417]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[418]=PATHTRACE(lw.COST_Truck_HV_PM),    NOACCESS=10000       ;The generalized cost matrix
            
            
            ;EV ----------------------------------------------------------------------------------------
            ;HBW
            PATHLOAD PATH=lw.COST_Auto_Wrk_EV,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[501]=PATHTRACE(lw.TotTime_EV),          NOACCESS=10000,      ;Travel times
                mw[502]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[503]=PATHTRACE(lw.COST_Auto_Wrk_EV),    NOACCESS=10000       ;The generalized cost matrix
            
            ;non-work trips 
            PATHLOAD PATH=lw.COST_Auto_Per_EV,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[504]=PATHTRACE(lw.TotTime_EV),          NOACCESS=10000,      ;Travel times
                mw[505]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[506]=PATHTRACE(lw.COST_Auto_Per_EV),    NOACCESS=10000       ;The generalized cost matrix
                
            ;external trips    
            PATHLOAD PATH=lw.COST_Auto_Ext_EV,
                CONSOLIDATE=T, 
                PENI=1,
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[507]=PATHTRACE(lw.TotTime_EV),          NOACCESS=10000,      ;Travel times
                mw[508]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[509]=PATHTRACE(lw.COST_Auto_Ext_EV),    NOACCESS=10000       ;The generalized cost matrix
                
            ;Assignment for light truck
            PATHLOAD PATH=lw.COST_Truck_LT_EV,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,7,                                             ;exclude HOV & HOT lanes
                mw[510]=PATHTRACE(lw.TotTime_EV),          NOACCESS=10000,      ;Travel times
                mw[511]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[512]=PATHTRACE(lw.COST_Truck_LT_EV),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for medium truck
            PATHLOAD PATH=lw.COST_Truck_MD_EV,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[513]=PATHTRACE(lw.TotTime_TrM_EV),      NOACCESS=10000,      ;Travel times
                mw[514]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[515]=PATHTRACE(lw.COST_Truck_MD_EV),    NOACCESS=10000       ;The generalized cost matrix
            
            ;Assignment for heavy truck
            PATHLOAD PATH=lw.COST_Truck_HV_EV,
                CONSOLIDATE=T, 
                PENI=1, 
                EXCLUDEGROUP=1-2,5,7,                                           ;exclude HOV, HOT & truck restriction lanes
                mw[516]=PATHTRACE(lw.TotTime_TrH_EV),      NOACCESS=10000,      ;Travel times
                mw[517]=PATHTRACE(li.DISTANCE),            NOACCESS=10000,      ;Travel distances
                mw[518]=PATHTRACE(lw.COST_Truck_HV_EV),    NOACCESS=10000       ;The generalized cost matrix
            
            
            
            ;add intrazonal times and distances ------------------------------------------------------------------------
            JLOOP
                
                if (i=j)
                    
                    ;add intrazonal distance (half square root of square miles = average distance, in miles)
                    SQMILETOT = zi.1.SQMILE[J]
                    
                    
                    ;distance (average distance estimated at 1/2 square root of area)
                    ;FF
                    mw[102] = 0.5 * SQMILETOT^0.5      ;Auto person 
                    mw[105] = 0.5 * SQMILETOT^0.5      ;Auto business 
                    mw[108] = 0.5 * SQMILETOT^0.5      ;Auto external
                    mw[111] = 0.5 * SQMILETOT^0.5      ;Light truck 
                    mw[114] = 0.5 * SQMILETOT^0.5      ;Medium truck 
                    mw[117] = 0.5 * SQMILETOT^0.5      ;Heavy truck 
                    
                    ;AM
                    mw[202] = 0.5 * SQMILETOT^0.5      ;Auto person 
                    mw[205] = 0.5 * SQMILETOT^0.5      ;Auto business 
                    mw[208] = 0.5 * SQMILETOT^0.5      ;Auto external
                    mw[211] = 0.5 * SQMILETOT^0.5      ;Light truck 
                    mw[214] = 0.5 * SQMILETOT^0.5      ;Medium truck 
                    mw[217] = 0.5 * SQMILETOT^0.5      ;Heavy truck
                    
                    ;MD
                    mw[302] = 0.5 * SQMILETOT^0.5      ;Auto person 
                    mw[305] = 0.5 * SQMILETOT^0.5      ;Auto business     
                    mw[308] = 0.5 * SQMILETOT^0.5      ;Auto external
                    mw[311] = 0.5 * SQMILETOT^0.5      ;Light truck 
                    mw[314] = 0.5 * SQMILETOT^0.5      ;Medium truck 
                    mw[317] = 0.5 * SQMILETOT^0.5      ;Heavy truck
                    
                    ;PM
                    mw[402] = 0.5 * SQMILETOT^0.5      ;Auto person 
                    mw[405] = 0.5 * SQMILETOT^0.5      ;Auto business     
                    mw[408] = 0.5 * SQMILETOT^0.5      ;Auto external
                    mw[411] = 0.5 * SQMILETOT^0.5      ;Light truck 
                    mw[414] = 0.5 * SQMILETOT^0.5      ;Medium truck 
                    mw[417] = 0.5 * SQMILETOT^0.5      ;Heavy truck
                    
                    ;EV
                    mw[502] = 0.5 * SQMILETOT^0.5      ;Auto person 
                    mw[505] = 0.5 * SQMILETOT^0.5      ;Auto business  
                    mw[508] = 0.5 * SQMILETOT^0.5      ;Auto external
                    mw[511] = 0.5 * SQMILETOT^0.5      ;Light truck 
                    mw[514] = 0.5 * SQMILETOT^0.5      ;Medium truck 
                    mw[517] = 0.5 * SQMILETOT^0.5      ;Heavy truck
                    
                    
                    ;time (assume average intrazonal speed is 20 mph)
                    ;FF
                    mw[101] = mw[102] / @IntrazonalSpeed@ * 60  ;Auto person  
                    mw[104] = mw[105] / @IntrazonalSpeed@ * 60  ;Auto business
                    mw[107] = mw[108] / @IntrazonalSpeed@ * 60  ;Auto external
                    mw[110] = mw[111] / @IntrazonalSpeed@ * 60  ;Light truck  
                    mw[113] = mw[114] / @IntrazonalSpeed@ * 60  ;Medium truck 
                    mw[116] = mw[117] / @IntrazonalSpeed@ * 60  ;Heavy truck  
                    
                    ;AM
                    mw[201] = mw[202] / @IntrazonalSpeed@ * 60  ;Auto person   
                    mw[204] = mw[205] / @IntrazonalSpeed@ * 60  ;Auto business 
                    mw[207] = mw[208] / @IntrazonalSpeed@ * 60  ;Auto external 
                    mw[210] = mw[211] / @IntrazonalSpeed@ * 60  ;Light truck   
                    mw[213] = mw[214] / @IntrazonalSpeed@ * 60  ;Medium truck   
                    mw[216] = mw[217] / @IntrazonalSpeed@ * 60  ;Heavy truck   
                    
                    ;MD
                    mw[301] = mw[302] / @IntrazonalSpeed@ * 60  ;Auto person   
                    mw[304] = mw[305] / @IntrazonalSpeed@ * 60  ;Auto business 
                    mw[307] = mw[308] / @IntrazonalSpeed@ * 60  ;Auto external 
                    mw[310] = mw[311] / @IntrazonalSpeed@ * 60  ;Light truck   
                    mw[313] = mw[314] / @IntrazonalSpeed@ * 60  ;Medium truck  
                    mw[316] = mw[317] / @IntrazonalSpeed@ * 60  ;Heavy truck   
                    
                    ;PM
                    mw[401] = mw[402] / @IntrazonalSpeed@ * 60  ;Auto person   
                    mw[404] = mw[405] / @IntrazonalSpeed@ * 60  ;Auto business 
                    mw[407] = mw[408] / @IntrazonalSpeed@ * 60  ;Auto external 
                    mw[410] = mw[411] / @IntrazonalSpeed@ * 60  ;Light truck   
                    mw[413] = mw[414] / @IntrazonalSpeed@ * 60  ;Medium truck   
                    mw[416] = mw[417] / @IntrazonalSpeed@ * 60  ;Heavy truck   
                    
                    ;EV
                    mw[501] = mw[502] / @IntrazonalSpeed@ * 60  ;Auto person    
                    mw[504] = mw[505] / @IntrazonalSpeed@ * 60  ;Auto business  
                    mw[507] = mw[508] / @IntrazonalSpeed@ * 60  ;Auto external  
                    mw[510] = mw[511] / @IntrazonalSpeed@ * 60  ;Light truck    
                    mw[513] = mw[514] / @IntrazonalSpeed@ * 60  ;Medium truck   
                    mw[516] = mw[517] / @IntrazonalSpeed@ * 60  ;Heavy truck    
                    
                    
                    ;generalized cost
                    ;FF
                    mw[103] = mw[101]  +  mw[102] * @AOC_Auto@ / @VOT_Auto_Wrk@  ;Auto person    
                    mw[106] = mw[104]  +  mw[105] * @AOC_Auto@ / @VOT_Auto_Per@  ;Auto business  
                    mw[109] = mw[107]  +  mw[108] * @AOC_Auto@ / @VOT_Auto_Ext@  ;Auto External
                    mw[112] = mw[110]  +  mw[111] * @AOC_LT@ / @VOT_LT@          ;Light truck    
                    mw[115] = mw[113]  +  mw[114] * @AOC_MD@ / @VOT_MD@          ;Medium truck   
                    mw[118] = mw[116]  +  mw[117] * @AOC_HV@ / @VOT_HV@          ;Heavy truck    
                    
                    ;AM               
                    mw[203] = mw[201]  +  mw[202] * @AOC_Auto@ / @VOT_Auto_Wrk@  ;Auto person    
                    mw[206] = mw[204]  +  mw[205] * @AOC_Auto@ / @VOT_Auto_Per@  ;Auto business  
                    mw[209] = mw[207]  +  mw[208] * @AOC_Auto@ / @VOT_Auto_Ext@  ;Auto External  
                    mw[212] = mw[210]  +  mw[211] * @AOC_LT@ / @VOT_LT@          ;Light truck    
                    mw[215] = mw[213]  +  mw[214] * @AOC_MD@ / @VOT_MD@          ;Medium truck   
                    mw[218] = mw[216]  +  mw[217] * @AOC_HV@ / @VOT_HV@          ;Heavy truck    
                    
                    ;MD                     
                    mw[303] = mw[301]  +  mw[302] * @AOC_Auto@ / @VOT_Auto_Wrk@  ;Auto person    
                    mw[306] = mw[304]  +  mw[305] * @AOC_Auto@ / @VOT_Auto_Per@  ;Auto business  
                    mw[309] = mw[307]  +  mw[308] * @AOC_Auto@ / @VOT_Auto_Ext@  ;Auto External  
                    mw[312] = mw[310]  +  mw[311] * @AOC_LT@ / @VOT_LT@          ;Light truck    
                    mw[315] = mw[313]  +  mw[314] * @AOC_MD@ / @VOT_MD@          ;Medium truck   
                    mw[318] = mw[316]  +  mw[317] * @AOC_HV@ / @VOT_HV@          ;Heavy truck    
                    
                    ;PM                  
                    mw[403] = mw[401]  +  mw[402] * @AOC_Auto@ / @VOT_Auto_Wrk@  ;Auto person     
                    mw[406] = mw[404]  +  mw[405] * @AOC_Auto@ / @VOT_Auto_Per@  ;Auto business   
                    mw[409] = mw[407]  +  mw[408] * @AOC_Auto@ / @VOT_Auto_Ext@  ;Auto External   
                    mw[412] = mw[410]  +  mw[411] * @AOC_LT@ / @VOT_LT@          ;Light truck     
                    mw[415] = mw[413]  +  mw[414] * @AOC_MD@ / @VOT_MD@          ;Medium truck   
                    mw[418] = mw[416]  +  mw[417] * @AOC_HV@ / @VOT_HV@          ;Heavy truck    
                    
                    ;EV             
                    mw[503] = mw[501]  +  mw[502] * @AOC_Auto@ / @VOT_Auto_Wrk@  ;Auto person    
                    mw[506] = mw[504]  +  mw[505] * @AOC_Auto@ / @VOT_Auto_Per@  ;Auto business  
                    mw[509] = mw[507]  +  mw[508] * @AOC_Auto@ / @VOT_Auto_Ext@  ;Auto External  
                    mw[512] = mw[510]  +  mw[511] * @AOC_LT@ / @VOT_LT@          ;Light truck    
                    mw[515] = mw[513]  +  mw[514] * @AOC_MD@ / @VOT_MD@          ;Medium truck   
                    mw[518] = mw[516]  +  mw[517] * @AOC_HV@ / @VOT_HV@          ;Heavy truck    
                    
                endif  ;i=j
                
                
                ;add origin and destination terminal times to all zones
                ;time
                ;FF
                mw[101] = mw[101] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[104] = mw[104] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[107] = mw[107] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[110] = mw[110] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[113] = mw[113] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j] 
                mw[116] = mw[116] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;AM
                mw[201] = mw[201] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[204] = mw[204] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[207] = mw[207] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[210] = mw[210] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[213] = mw[213] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[216] = mw[216] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;MD
                mw[301] = mw[301] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[304] = mw[304] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[307] = mw[307] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[310] = mw[310] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[313] = mw[313] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[316] = mw[316] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;PM
                mw[401] = mw[401] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[404] = mw[404] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[407] = mw[407] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[410] = mw[410] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[413] = mw[413] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[416] = mw[416] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;EV
                mw[501] = mw[501] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]   
                mw[504] = mw[504] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[507] = mw[507] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[510] = mw[510] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[513] = mw[513] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[516] = mw[516] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                
                ;cost
                ;FF
                mw[103] = mw[103] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[106] = mw[106] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[109] = mw[109] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[112] = mw[112] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[115] = mw[115] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[118] = mw[118] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;AM
                mw[203] = mw[203] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[206] = mw[206] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[209] = mw[209] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[212] = mw[212] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[215] = mw[215] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[218] = mw[218] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;MD
                mw[303] = mw[303] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[306] = mw[306] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[309] = mw[309] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[312] = mw[312] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[315] = mw[315] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[318] = mw[318] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;PM
                mw[403] = mw[403] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[406] = mw[406] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[409] = mw[409] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[412] = mw[412] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[415] = mw[415] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[418] = mw[418] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                ;EV
                mw[503] = mw[503] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[506] = mw[506] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[509] = mw[509] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[512] = mw[512] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[515] = mw[515] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                mw[518] = mw[518] + zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
            ENDJLOOP
            
        ENDPHASE
        
    ENDRUN
    
    
    
    
    ;calculate Daily PA skims by trip purpose from period OD skims
    ;  note: code block is set up to finish time & distance calculations after feedback loop (to save runtime)
    _LOS = 1
    
    ;output filename tag to differentiate generalized cost, time or distance output matrices
    skim_type = 'GC'
    
    ;prefix to identify which skim type or set of matrices in input skim matrix files
    matrix_prefix = 'gentime'
    
    
    
    RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 1: Create Daily Average Skim - @skim_type@'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_AM.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_MD.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@3_Distribute\skm_PM.mtx'
        FILEI MATI[4] = '@ParentDir@@ScenarioDir@3_Distribute\skm_EV.mtx'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_@skim_type@.mtx',
                mo=510, 520-522, 530-532, 540, 550, 560, 570, 580, 590, 500,
                name=HBW   ,
                     HBO   ,
                     HBShp ,
                     HBOth ,
                     NHB   ,
                     NHBW  ,
                     NHBNW ,
                     HBS   ,
                     HBC   ,
                     Rec   ,
                     LT    ,
                     MD    ,
                     HV    ,
                     Ext   
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        
        ;read in calculated diurnal factors from file
        if (i=FIRSTZONE)
            
            ;read in calculate diurnal factors block file
            READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
            
        endif  ;i=FIRSTZONE
        
        
        
        ;read in skim tables
        ;  note: AP direction is the transpose of PA direction
        ;AM
        mw[101] = mi.1.@matrix_prefix@_Auto_WRK
        mw[102] = mi.1.@matrix_prefix@_Auto_Per
        mw[103] = mi.1.@matrix_prefix@_Auto_Ext
        mw[104] = mi.1.@matrix_prefix@_Truck_LT
        mw[105] = mi.1.@matrix_prefix@_Truck_MD
        mw[106] = mi.1.@matrix_prefix@_Truck_HV
        
        mw[151] = mi.1.@matrix_prefix@_Auto_WRK.T
        mw[152] = mi.1.@matrix_prefix@_Auto_Per.T
        mw[153] = mi.1.@matrix_prefix@_Auto_Ext.T
        mw[154] = mi.1.@matrix_prefix@_Truck_LT.T
        mw[155] = mi.1.@matrix_prefix@_Truck_MD.T
        mw[156] = mi.1.@matrix_prefix@_Truck_HV.T
        
        ;MD
        mw[201] = mi.2.@matrix_prefix@_Auto_WRK
        mw[202] = mi.2.@matrix_prefix@_Auto_Per
        mw[203] = mi.2.@matrix_prefix@_Auto_Ext
        mw[204] = mi.2.@matrix_prefix@_Truck_LT
        mw[205] = mi.2.@matrix_prefix@_Truck_MD
        mw[206] = mi.2.@matrix_prefix@_Truck_HV
        
        mw[251] = mi.2.@matrix_prefix@_Auto_WRK.T
        mw[252] = mi.2.@matrix_prefix@_Auto_Per.T
        mw[253] = mi.2.@matrix_prefix@_Auto_Ext.T
        mw[254] = mi.2.@matrix_prefix@_Truck_LT.T
        mw[255] = mi.2.@matrix_prefix@_Truck_MD.T
        mw[256] = mi.2.@matrix_prefix@_Truck_HV.T
        
        ;PM
        mw[301] = mi.3.@matrix_prefix@_Auto_WRK
        mw[302] = mi.3.@matrix_prefix@_Auto_Per
        mw[303] = mi.3.@matrix_prefix@_Auto_Ext
        mw[304] = mi.3.@matrix_prefix@_Truck_LT
        mw[305] = mi.3.@matrix_prefix@_Truck_MD
        mw[306] = mi.3.@matrix_prefix@_Truck_HV
        
        mw[351] = mi.3.@matrix_prefix@_Auto_WRK.T
        mw[352] = mi.3.@matrix_prefix@_Auto_Per.T
        mw[353] = mi.3.@matrix_prefix@_Auto_Ext.T
        mw[354] = mi.3.@matrix_prefix@_Truck_LT.T
        mw[355] = mi.3.@matrix_prefix@_Truck_MD.T
        mw[356] = mi.3.@matrix_prefix@_Truck_HV.T
        
        ;EV
        mw[401] = mi.4.@matrix_prefix@_Auto_WRK
        mw[402] = mi.4.@matrix_prefix@_Auto_Per
        mw[403] = mi.4.@matrix_prefix@_Auto_Ext
        mw[404] = mi.4.@matrix_prefix@_Truck_LT
        mw[405] = mi.4.@matrix_prefix@_Truck_MD
        mw[406] = mi.4.@matrix_prefix@_Truck_HV
        
        mw[451] = mi.4.@matrix_prefix@_Auto_WRK.T
        mw[452] = mi.4.@matrix_prefix@_Auto_Per.T
        mw[453] = mi.4.@matrix_prefix@_Auto_Ext.T
        mw[454] = mi.4.@matrix_prefix@_Truck_LT.T
        mw[455] = mi.4.@matrix_prefix@_Truck_MD.T
        mw[456] = mi.4.@matrix_prefix@_Truck_HV.T
        
        
        
        ;calculate weighted average daily skim ---------------------------------------------------------------
        ;loop through columns to identify movement (II, IX, XI or XX)
        JLOOP
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_HBW * PA_AM_HBW  +  mw[151] * Pct_AM_HBW * (1 - PA_AM_HBW)  +
                          mw[201] * Pct_MD_HBW * PA_MD_HBW  +  mw[251] * Pct_MD_HBW * (1 - PA_MD_HBW)  +
                          mw[301] * Pct_PM_HBW * PA_PM_HBW  +  mw[351] * Pct_PM_HBW * (1 - PA_PM_HBW)  +
                          mw[401] * Pct_EV_HBW * PA_EV_HBW  +  mw[451] * Pct_EV_HBW * (1 - PA_EV_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_HBO * PA_AM_HBO      +  mw[152] * Pct_AM_HBO   * (1 - PA_AM_HBO)   +
                          mw[202] * Pct_MD_HBO * PA_MD_HBO      +  mw[252] * Pct_MD_HBO   * (1 - PA_MD_HBO)   +
                          mw[302] * Pct_PM_HBO * PA_PM_HBO      +  mw[352] * Pct_PM_HBO   * (1 - PA_PM_HBO)   +
                          mw[402] * Pct_EV_HBO * PA_EV_HBO      +  mw[452] * Pct_EV_HBO   * (1 - PA_EV_HBO)    
                
                mw[521] = mw[102] * Pct_AM_HBShp * PA_AM_HBShp  +  mw[152] * Pct_AM_HBShp * (1 - PA_AM_HBShp) +
                          mw[202] * Pct_MD_HBShp * PA_MD_HBShp  +  mw[252] * Pct_MD_HBShp * (1 - PA_MD_HBShp) +
                          mw[302] * Pct_PM_HBShp * PA_PM_HBShp  +  mw[352] * Pct_PM_HBShp * (1 - PA_PM_HBShp) +
                          mw[402] * Pct_EV_HBShp * PA_EV_HBShp  +  mw[452] * Pct_EV_HBShp * (1 - PA_EV_HBShp)  
                
                mw[522] = mw[102] * Pct_AM_HBOth * PA_AM_HBOth  +  mw[152] * Pct_AM_HBOth * (1 - PA_AM_HBOth) +
                          mw[202] * Pct_MD_HBOth * PA_MD_HBOth  +  mw[252] * Pct_MD_HBOth * (1 - PA_MD_HBOth) +
                          mw[302] * Pct_PM_HBOth * PA_PM_HBOth  +  mw[352] * Pct_PM_HBOth * (1 - PA_PM_HBOth) +
                          mw[402] * Pct_EV_HBOth * PA_EV_HBOth  +  mw[452] * Pct_EV_HBOth * (1 - PA_EV_HBOth)  
                
                mw[530] = mw[102] * Pct_AM_NHB * PA_AM_NHB      +  mw[152] * Pct_AM_NHB   * (1 - PA_AM_NHB)   +
                          mw[202] * Pct_MD_NHB * PA_MD_NHB      +  mw[252] * Pct_MD_NHB   * (1 - PA_MD_NHB)   +
                          mw[302] * Pct_PM_NHB * PA_PM_NHB      +  mw[352] * Pct_PM_NHB   * (1 - PA_PM_NHB)   +
                          mw[402] * Pct_EV_NHB * PA_EV_NHB      +  mw[452] * Pct_EV_NHB   * (1 - PA_EV_NHB)    
                
                mw[531] = mw[102] * Pct_AM_NHBW * PA_AM_NHBW    +  mw[152] * Pct_AM_NHBW  * (1 - PA_AM_NHBW)  +
                          mw[202] * Pct_MD_NHBW * PA_MD_NHBW    +  mw[252] * Pct_MD_NHBW  * (1 - PA_MD_NHBW)  +
                          mw[302] * Pct_PM_NHBW * PA_PM_NHBW    +  mw[352] * Pct_PM_NHBW  * (1 - PA_PM_NHBW)  +
                          mw[402] * Pct_EV_NHBW * PA_EV_NHBW    +  mw[452] * Pct_EV_NHBW  * (1 - PA_EV_NHBW)   
                
                mw[532] = mw[102] * Pct_AM_NHBNW * PA_AM_NHBNW  +  mw[152] * Pct_AM_NHBNW * (1 - PA_AM_NHBNW) +
                          mw[202] * Pct_MD_NHBNW * PA_MD_NHBNW  +  mw[252] * Pct_MD_NHBNW * (1 - PA_MD_NHBNW) +
                          mw[302] * Pct_PM_NHBNW * PA_PM_NHBNW  +  mw[352] * Pct_PM_NHBNW * (1 - PA_PM_NHBNW) +
                          mw[402] * Pct_EV_NHBNW * PA_EV_NHBNW  +  mw[452] * Pct_EV_NHBNW * (1 - PA_EV_NHBNW)  
                
                mw[540] = mw[102] * Pct_AM_HBS * PA_AM_HBS      +  mw[152] * Pct_AM_HBS   * (1 - PA_AM_HBS)   +
                          mw[202] * Pct_MD_HBS * PA_MD_HBS      +  mw[252] * Pct_MD_HBS   * (1 - PA_MD_HBS)   +
                          mw[302] * Pct_PM_HBS * PA_PM_HBS      +  mw[352] * Pct_PM_HBS   * (1 - PA_PM_HBS)   +
                          mw[402] * Pct_EV_HBS * PA_EV_HBS      +  mw[452] * Pct_EV_HBS   * (1 - PA_EV_HBS)    
                
                mw[550] = mw[102] * Pct_AM_HBC * PA_AM_HBC      +  mw[152] * Pct_AM_HBC   * (1 - PA_AM_HBC)   +
                          mw[202] * Pct_MD_HBC * PA_MD_HBC      +  mw[252] * Pct_MD_HBC   * (1 - PA_MD_HBC)   +
                          mw[302] * Pct_PM_HBC * PA_PM_HBC      +  mw[352] * Pct_PM_HBC   * (1 - PA_PM_HBC)   +
                          mw[402] * Pct_EV_HBC * PA_EV_HBC      +  mw[452] * Pct_EV_HBC   * (1 - PA_EV_HBC)    
                
                mw[560] = mw[102] * Pct_AM_Rec * PA_AM_Rec      +  mw[152] * Pct_AM_Rec   * (1 - PA_AM_Rec)   +
                          mw[202] * Pct_MD_Rec * PA_MD_Rec      +  mw[252] * Pct_MD_Rec   * (1 - PA_MD_Rec)   +
                          mw[302] * Pct_PM_Rec * PA_PM_Rec      +  mw[352] * Pct_PM_Rec   * (1 - PA_PM_Rec)   +
                          mw[402] * Pct_EV_Rec * PA_EV_Rec      +  mw[452] * Pct_EV_Rec   * (1 - PA_EV_Rec)    
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_LT * PA_AM_LT  +  mw[154] * Pct_AM_LT * (1 - PA_AM_LT)  +
                          mw[204] * Pct_MD_LT * PA_MD_LT  +  mw[254] * Pct_MD_LT * (1 - PA_MD_LT)  +
                          mw[304] * Pct_PM_LT * PA_PM_LT  +  mw[354] * Pct_PM_LT * (1 - PA_PM_LT)  +
                          mw[404] * Pct_EV_LT * PA_EV_LT  +  mw[454] * Pct_EV_LT * (1 - PA_EV_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_MD * PA_AM_MD  +  mw[155] * Pct_AM_MD * (1 - PA_AM_MD)  +
                          mw[205] * Pct_MD_MD * PA_MD_MD  +  mw[255] * Pct_MD_MD * (1 - PA_MD_MD)  +
                          mw[305] * Pct_PM_MD * PA_PM_MD  +  mw[355] * Pct_PM_MD * (1 - PA_PM_MD)  +
                          mw[405] * Pct_EV_MD * PA_EV_MD  +  mw[455] * Pct_EV_MD * (1 - PA_EV_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_HV * PA_AM_HV  +  mw[156] * Pct_AM_HV * (1 - PA_AM_HV)  +
                          mw[206] * Pct_MD_HV * PA_MD_HV  +  mw[256] * Pct_MD_HV * (1 - PA_MD_HV)  +
                          mw[306] * Pct_PM_HV * PA_PM_HV  +  mw[356] * Pct_PM_HV * (1 - PA_PM_HV)  +
                          mw[406] * Pct_EV_HV * PA_EV_HV  +  mw[456] * Pct_EV_HV * (1 - PA_EV_HV)   
                
                
            ;IX
            elseif (!(i=@externalzones@) & j=@externalzones@)
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_IX * PA_AM_IX  +  mw[153] * Pct_AM_IX * (1 - PA_AM_IX) +
                          mw[203] * Pct_MD_IX * PA_MD_IX  +  mw[253] * Pct_MD_IX * (1 - PA_MD_IX) +
                          mw[303] * Pct_PM_IX * PA_PM_IX  +  mw[353] * Pct_PM_IX * (1 - PA_PM_IX) +
                          mw[403] * Pct_EV_IX * PA_EV_IX  +  mw[453] * Pct_EV_IX * (1 - PA_EV_IX)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_IX_HBW * PA_AM_IX_HBW  +  mw[151] * Pct_AM_IX_HBW * (1 - PA_AM_IX_HBW)  +
                          mw[201] * Pct_MD_IX_HBW * PA_MD_IX_HBW  +  mw[251] * Pct_MD_IX_HBW * (1 - PA_MD_IX_HBW)  +
                          mw[301] * Pct_PM_IX_HBW * PA_PM_IX_HBW  +  mw[351] * Pct_PM_IX_HBW * (1 - PA_PM_IX_HBW)  +
                          mw[401] * Pct_EV_IX_HBW * PA_EV_IX_HBW  +  mw[451] * Pct_EV_IX_HBW * (1 - PA_EV_IX_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_IX_HBO * PA_AM_IX_HBO  +  mw[152] * Pct_AM_IX_HBO * (1 - PA_AM_IX_HBO)  +
                          mw[202] * Pct_MD_IX_HBO * PA_MD_IX_HBO  +  mw[252] * Pct_MD_IX_HBO * (1 - PA_MD_IX_HBO)  +
                          mw[302] * Pct_PM_IX_HBO * PA_PM_IX_HBO  +  mw[352] * Pct_PM_IX_HBO * (1 - PA_PM_IX_HBO)  +
                          mw[402] * Pct_EV_IX_HBO * PA_EV_IX_HBO  +  mw[452] * Pct_EV_IX_HBO * (1 - PA_EV_IX_HBO)   
                
                mw[530] = mw[102] * Pct_AM_IX_NHB * PA_AM_IX_NHB  +  mw[152] * Pct_AM_IX_NHB * (1 - PA_AM_IX_NHB)  +
                          mw[202] * Pct_MD_IX_NHB * PA_MD_IX_NHB  +  mw[252] * Pct_MD_IX_NHB * (1 - PA_MD_IX_NHB)  +
                          mw[302] * Pct_PM_IX_NHB * PA_PM_IX_NHB  +  mw[352] * Pct_PM_IX_NHB * (1 - PA_PM_IX_NHB)  +
                          mw[402] * Pct_EV_IX_NHB * PA_EV_IX_NHB  +  mw[452] * Pct_EV_IX_NHB * (1 - PA_EV_IX_NHB)   
                
                mw[540] = mw[102] * Pct_AM_IX_HBS * PA_AM_IX_HBS  +  mw[152] * Pct_AM_IX_HBS * (1 - PA_AM_IX_HBS)  +
                          mw[202] * Pct_MD_IX_HBS * PA_MD_IX_HBS  +  mw[252] * Pct_MD_IX_HBS * (1 - PA_MD_IX_HBS)  +
                          mw[302] * Pct_PM_IX_HBS * PA_PM_IX_HBS  +  mw[352] * Pct_PM_IX_HBS * (1 - PA_PM_IX_HBS)  +
                          mw[402] * Pct_EV_IX_HBS * PA_EV_IX_HBS  +  mw[452] * Pct_EV_IX_HBS * (1 - PA_EV_IX_HBS)   
                
                mw[550] = mw[102] * Pct_AM_IX_HBC * PA_AM_IX_HBC  +  mw[152] * Pct_AM_IX_HBC * (1 - PA_AM_IX_HBC)  +
                          mw[202] * Pct_MD_IX_HBC * PA_MD_IX_HBC  +  mw[252] * Pct_MD_IX_HBC * (1 - PA_MD_IX_HBC)  +
                          mw[302] * Pct_PM_IX_HBC * PA_PM_IX_HBC  +  mw[352] * Pct_PM_IX_HBC * (1 - PA_PM_IX_HBC)  +
                          mw[402] * Pct_EV_IX_HBC * PA_EV_IX_HBC  +  mw[452] * Pct_EV_IX_HBC * (1 - PA_EV_IX_HBC)   
                
                mw[560] = mw[102] * Pct_AM_IX_Rec * PA_AM_IX_Rec  +  mw[152] * Pct_AM_IX_Rec * (1 - PA_AM_IX_Rec)  +
                          mw[202] * Pct_MD_IX_Rec * PA_MD_IX_Rec  +  mw[252] * Pct_MD_IX_Rec * (1 - PA_MD_IX_Rec)  +
                          mw[302] * Pct_PM_IX_Rec * PA_PM_IX_Rec  +  mw[352] * Pct_PM_IX_Rec * (1 - PA_PM_IX_Rec)  +
                          mw[402] * Pct_EV_IX_Rec * PA_EV_IX_Rec  +  mw[452] * Pct_EV_IX_Rec * (1 - PA_EV_IX_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_IX_LT * PA_AM_IX_LT  +  mw[154] * Pct_AM_IX_LT * (1 - PA_AM_IX_LT)  +
                          mw[204] * Pct_MD_IX_LT * PA_MD_IX_LT  +  mw[254] * Pct_MD_IX_LT * (1 - PA_MD_IX_LT)  +
                          mw[304] * Pct_PM_IX_LT * PA_PM_IX_LT  +  mw[354] * Pct_PM_IX_LT * (1 - PA_PM_IX_LT)  +
                          mw[404] * Pct_EV_IX_LT * PA_EV_IX_LT  +  mw[454] * Pct_EV_IX_LT * (1 - PA_EV_IX_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_IX_MD * PA_AM_IX_MD  +  mw[155] * Pct_AM_IX_MD * (1 - PA_AM_IX_MD)  +
                          mw[205] * Pct_MD_IX_MD * PA_MD_IX_MD  +  mw[255] * Pct_MD_IX_MD * (1 - PA_MD_IX_MD)  +
                          mw[305] * Pct_PM_IX_MD * PA_PM_IX_MD  +  mw[355] * Pct_PM_IX_MD * (1 - PA_PM_IX_MD)  +
                          mw[405] * Pct_EV_IX_MD * PA_EV_IX_MD  +  mw[455] * Pct_EV_IX_MD * (1 - PA_EV_IX_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_IX_HV * PA_AM_IX_HV  +  mw[156] * Pct_AM_IX_HV * (1 - PA_AM_IX_HV)  +
                          mw[206] * Pct_MD_IX_HV * PA_MD_IX_HV  +  mw[256] * Pct_MD_IX_HV * (1 - PA_MD_IX_HV)  +
                          mw[306] * Pct_PM_IX_HV * PA_PM_IX_HV  +  mw[356] * Pct_PM_IX_HV * (1 - PA_PM_IX_HV)  +
                          mw[406] * Pct_EV_IX_HV * PA_EV_IX_HV  +  mw[456] * Pct_EV_IX_HV * (1 - PA_EV_IX_HV)   
                
                
            ;XI
            elseif (i=@externalzones@ & !(j=@externalzones@))
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_XI * PA_AM_XI  +  mw[153] * Pct_AM_XI * (1 - PA_AM_XI) +
                          mw[203] * Pct_MD_XI * PA_MD_XI  +  mw[253] * Pct_MD_XI * (1 - PA_MD_XI) +
                          mw[303] * Pct_PM_XI * PA_PM_XI  +  mw[353] * Pct_PM_XI * (1 - PA_PM_XI) +
                          mw[403] * Pct_EV_XI * PA_EV_XI  +  mw[453] * Pct_EV_XI * (1 - PA_EV_XI)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_XI_HBW * PA_AM_XI_HBW  +  mw[151] * Pct_AM_XI_HBW * (1 - PA_AM_XI_HBW)  +
                          mw[201] * Pct_MD_XI_HBW * PA_MD_XI_HBW  +  mw[251] * Pct_MD_XI_HBW * (1 - PA_MD_XI_HBW)  +
                          mw[301] * Pct_PM_XI_HBW * PA_PM_XI_HBW  +  mw[351] * Pct_PM_XI_HBW * (1 - PA_PM_XI_HBW)  +
                          mw[401] * Pct_EV_XI_HBW * PA_EV_XI_HBW  +  mw[451] * Pct_EV_XI_HBW * (1 - PA_EV_XI_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_XI_HBO * PA_AM_XI_HBO  +  mw[152] * Pct_AM_XI_HBO * (1 - PA_AM_XI_HBO)  +
                          mw[202] * Pct_MD_XI_HBO * PA_MD_XI_HBO  +  mw[252] * Pct_MD_XI_HBO * (1 - PA_MD_XI_HBO)  +
                          mw[302] * Pct_PM_XI_HBO * PA_PM_XI_HBO  +  mw[352] * Pct_PM_XI_HBO * (1 - PA_PM_XI_HBO)  +
                          mw[402] * Pct_EV_XI_HBO * PA_EV_XI_HBO  +  mw[452] * Pct_EV_XI_HBO * (1 - PA_EV_XI_HBO)   
                
                mw[530] = mw[102] * Pct_AM_XI_NHB * PA_AM_XI_NHB  +  mw[152] * Pct_AM_XI_NHB * (1 - PA_AM_XI_NHB)  +
                          mw[202] * Pct_MD_XI_NHB * PA_MD_XI_NHB  +  mw[252] * Pct_MD_XI_NHB * (1 - PA_MD_XI_NHB)  +
                          mw[302] * Pct_PM_XI_NHB * PA_PM_XI_NHB  +  mw[352] * Pct_PM_XI_NHB * (1 - PA_PM_XI_NHB)  +
                          mw[402] * Pct_EV_XI_NHB * PA_EV_XI_NHB  +  mw[452] * Pct_EV_XI_NHB * (1 - PA_EV_XI_NHB)   
                
                mw[540] = mw[102] * Pct_AM_XI_HBS * PA_AM_XI_HBS  +  mw[152] * Pct_AM_XI_HBS * (1 - PA_AM_XI_HBS)  +
                          mw[202] * Pct_MD_XI_HBS * PA_MD_XI_HBS  +  mw[252] * Pct_MD_XI_HBS * (1 - PA_MD_XI_HBS)  +
                          mw[302] * Pct_PM_XI_HBS * PA_PM_XI_HBS  +  mw[352] * Pct_PM_XI_HBS * (1 - PA_PM_XI_HBS)  +
                          mw[402] * Pct_EV_XI_HBS * PA_EV_XI_HBS  +  mw[452] * Pct_EV_XI_HBS * (1 - PA_EV_XI_HBS)   
                
                mw[550] = mw[102] * Pct_AM_XI_HBC * PA_AM_XI_HBC  +  mw[152] * Pct_AM_XI_HBC * (1 - PA_AM_XI_HBC)  +
                          mw[202] * Pct_MD_XI_HBC * PA_MD_XI_HBC  +  mw[252] * Pct_MD_XI_HBC * (1 - PA_MD_XI_HBC)  +
                          mw[302] * Pct_PM_XI_HBC * PA_PM_XI_HBC  +  mw[352] * Pct_PM_XI_HBC * (1 - PA_PM_XI_HBC)  +
                          mw[402] * Pct_EV_XI_HBC * PA_EV_XI_HBC  +  mw[452] * Pct_EV_XI_HBC * (1 - PA_EV_XI_HBC)   
                
                mw[560] = mw[102] * Pct_AM_XI_Rec * PA_AM_XI_Rec  +  mw[152] * Pct_AM_XI_Rec * (1 - PA_AM_XI_Rec)  +
                          mw[202] * Pct_MD_XI_Rec * PA_MD_XI_Rec  +  mw[252] * Pct_MD_XI_Rec * (1 - PA_MD_XI_Rec)  +
                          mw[302] * Pct_PM_XI_Rec * PA_PM_XI_Rec  +  mw[352] * Pct_PM_XI_Rec * (1 - PA_PM_XI_Rec)  +
                          mw[402] * Pct_EV_XI_Rec * PA_EV_XI_Rec  +  mw[452] * Pct_EV_XI_Rec * (1 - PA_EV_XI_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_XI_LT * PA_AM_XI_LT  +  mw[154] * Pct_AM_XI_LT * (1 - PA_AM_XI_LT)  +
                          mw[204] * Pct_MD_XI_LT * PA_MD_XI_LT  +  mw[254] * Pct_MD_XI_LT * (1 - PA_MD_XI_LT)  +
                          mw[304] * Pct_PM_XI_LT * PA_PM_XI_LT  +  mw[354] * Pct_PM_XI_LT * (1 - PA_PM_XI_LT)  +
                          mw[404] * Pct_EV_XI_LT * PA_EV_XI_LT  +  mw[454] * Pct_EV_XI_LT * (1 - PA_EV_XI_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_XI_MD * PA_AM_XI_MD  +  mw[155] * Pct_AM_XI_MD * (1 - PA_AM_XI_MD)  +
                          mw[205] * Pct_MD_XI_MD * PA_MD_XI_MD  +  mw[255] * Pct_MD_XI_MD * (1 - PA_MD_XI_MD)  +
                          mw[305] * Pct_PM_XI_MD * PA_PM_XI_MD  +  mw[355] * Pct_PM_XI_MD * (1 - PA_PM_XI_MD)  +
                          mw[405] * Pct_EV_XI_MD * PA_EV_XI_MD  +  mw[455] * Pct_EV_XI_MD * (1 - PA_EV_XI_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_XI_HV * PA_AM_XI_HV  +  mw[156] * Pct_AM_XI_HV * (1 - PA_AM_XI_HV)  +
                          mw[206] * Pct_MD_XI_HV * PA_MD_XI_HV  +  mw[256] * Pct_MD_XI_HV * (1 - PA_MD_XI_HV)  +
                          mw[306] * Pct_PM_XI_HV * PA_PM_XI_HV  +  mw[356] * Pct_PM_XI_HV * (1 - PA_PM_XI_HV)  +
                          mw[406] * Pct_EV_XI_HV * PA_EV_XI_HV  +  mw[456] * Pct_EV_XI_HV * (1 - PA_EV_XI_HV)   
                
                
            ;XX
            elseif (i=@externalzones@ & j=@externalzones@)
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_XX * PA_AM_XX  +  mw[153] * Pct_AM_XX * (1 - PA_AM_XX) +
                          mw[203] * Pct_MD_XX * PA_MD_XX  +  mw[253] * Pct_MD_XX * (1 - PA_MD_XX) + 
                          mw[303] * Pct_PM_XX * PA_PM_XX  +  mw[353] * Pct_PM_XX * (1 - PA_PM_XX) +
                          mw[403] * Pct_EV_XX * PA_EV_XX  +  mw[453] * Pct_EV_XX * (1 - PA_EV_XX)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_XX_HBW * PA_AM_XX_HBW  +  mw[151] * Pct_AM_XX_HBW * (1 - PA_AM_XX_HBW)  +
                          mw[201] * Pct_MD_XX_HBW * PA_MD_XX_HBW  +  mw[251] * Pct_MD_XX_HBW * (1 - PA_MD_XX_HBW)  +
                          mw[301] * Pct_PM_XX_HBW * PA_PM_XX_HBW  +  mw[351] * Pct_PM_XX_HBW * (1 - PA_PM_XX_HBW)  +
                          mw[401] * Pct_EV_XX_HBW * PA_EV_XX_HBW  +  mw[451] * Pct_EV_XX_HBW * (1 - PA_EV_XX_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_XX_HBO * PA_AM_XX_HBO  +  mw[152] * Pct_AM_XX_HBO * (1 - PA_AM_XX_HBO)  +
                          mw[202] * Pct_MD_XX_HBO * PA_MD_XX_HBO  +  mw[252] * Pct_MD_XX_HBO * (1 - PA_MD_XX_HBO)  +
                          mw[302] * Pct_PM_XX_HBO * PA_PM_XX_HBO  +  mw[352] * Pct_PM_XX_HBO * (1 - PA_PM_XX_HBO)  +
                          mw[402] * Pct_EV_XX_HBO * PA_EV_XX_HBO  +  mw[452] * Pct_EV_XX_HBO * (1 - PA_EV_XX_HBO)   
                
                mw[530] = mw[102] * Pct_AM_XX_NHB * PA_AM_XX_NHB  +  mw[152] * Pct_AM_XX_NHB * (1 - PA_AM_XX_NHB)  +
                          mw[202] * Pct_MD_XX_NHB * PA_MD_XX_NHB  +  mw[252] * Pct_MD_XX_NHB * (1 - PA_MD_XX_NHB)  +
                          mw[302] * Pct_PM_XX_NHB * PA_PM_XX_NHB  +  mw[352] * Pct_PM_XX_NHB * (1 - PA_PM_XX_NHB)  +
                          mw[402] * Pct_EV_XX_NHB * PA_EV_XX_NHB  +  mw[452] * Pct_EV_XX_NHB * (1 - PA_EV_XX_NHB)   
                
                mw[540] = mw[102] * Pct_AM_XX_HBS * PA_AM_XX_HBS  +  mw[152] * Pct_AM_XX_HBS * (1 - PA_AM_XX_HBS)  +
                          mw[202] * Pct_MD_XX_HBS * PA_MD_XX_HBS  +  mw[252] * Pct_MD_XX_HBS * (1 - PA_MD_XX_HBS)  +
                          mw[302] * Pct_PM_XX_HBS * PA_PM_XX_HBS  +  mw[352] * Pct_PM_XX_HBS * (1 - PA_PM_XX_HBS)  +
                          mw[402] * Pct_EV_XX_HBS * PA_EV_XX_HBS  +  mw[452] * Pct_EV_XX_HBS * (1 - PA_EV_XX_HBS)   
                
                mw[550] = mw[102] * Pct_AM_XX_HBC * PA_AM_XX_HBC  +  mw[152] * Pct_AM_XX_HBC * (1 - PA_AM_XX_HBC)  +
                          mw[202] * Pct_MD_XX_HBC * PA_MD_XX_HBC  +  mw[252] * Pct_MD_XX_HBC * (1 - PA_MD_XX_HBC)  +
                          mw[302] * Pct_PM_XX_HBC * PA_PM_XX_HBC  +  mw[352] * Pct_PM_XX_HBC * (1 - PA_PM_XX_HBC)  +
                          mw[402] * Pct_EV_XX_HBC * PA_EV_XX_HBC  +  mw[452] * Pct_EV_XX_HBC * (1 - PA_EV_XX_HBC)   
                
                mw[560] = mw[102] * Pct_AM_XX_Rec * PA_AM_XX_Rec  +  mw[152] * Pct_AM_XX_Rec * (1 - PA_AM_XX_Rec)  +
                          mw[202] * Pct_MD_XX_Rec * PA_MD_XX_Rec  +  mw[252] * Pct_MD_XX_Rec * (1 - PA_MD_XX_Rec)  +
                          mw[302] * Pct_PM_XX_Rec * PA_PM_XX_Rec  +  mw[352] * Pct_PM_XX_Rec * (1 - PA_PM_XX_Rec)  +
                          mw[402] * Pct_EV_XX_Rec * PA_EV_XX_Rec  +  mw[452] * Pct_EV_XX_Rec * (1 - PA_EV_XX_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_XX_LT * PA_AM_XX_LT  +  mw[154] * Pct_AM_XX_LT * (1 - PA_AM_XX_LT)  +
                          mw[204] * Pct_MD_XX_LT * PA_MD_XX_LT  +  mw[254] * Pct_MD_XX_LT * (1 - PA_MD_XX_LT)  +
                          mw[304] * Pct_PM_XX_LT * PA_PM_XX_LT  +  mw[354] * Pct_PM_XX_LT * (1 - PA_PM_XX_LT)  +
                          mw[404] * Pct_EV_XX_LT * PA_EV_XX_LT  +  mw[454] * Pct_EV_XX_LT * (1 - PA_EV_XX_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_XX_MD * PA_AM_XX_MD  +  mw[155] * Pct_AM_XX_MD * (1 - PA_AM_XX_MD)  +
                          mw[205] * Pct_MD_XX_MD * PA_MD_XX_MD  +  mw[255] * Pct_MD_XX_MD * (1 - PA_MD_XX_MD)  +
                          mw[305] * Pct_PM_XX_MD * PA_PM_XX_MD  +  mw[355] * Pct_PM_XX_MD * (1 - PA_PM_XX_MD)  +
                          mw[405] * Pct_EV_XX_MD * PA_EV_XX_MD  +  mw[455] * Pct_EV_XX_MD * (1 - PA_EV_XX_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_XX_HV * PA_AM_XX_HV  +  mw[156] * Pct_AM_XX_HV * (1 - PA_AM_XX_HV)  +
                          mw[206] * Pct_MD_XX_HV * PA_MD_XX_HV  +  mw[256] * Pct_MD_XX_HV * (1 - PA_MD_XX_HV)  +
                          mw[306] * Pct_PM_XX_HV * PA_PM_XX_HV  +  mw[356] * Pct_PM_XX_HV * (1 - PA_PM_XX_HV)  +
                          mw[406] * Pct_EV_XX_HV * PA_EV_XX_HV  +  mw[456] * Pct_EV_XX_HV * (1 - PA_EV_XX_HV)   
                
            endif  ;by movement
            
        ENDJLOOP
        
    ENDRUN
    
    
    
    
    ;make a copy of the daily average time, distance & generalized cost matrices for first iteration of Distrib Loop (FF condition)
    if (n=1)
         
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 1: Copy Free Flow Skim'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF_GC.mtx',
                mo=101-114,
                name=HBW   ,
                     HBO   ,
                     HBShp ,
                     HBOth ,
                     NHB   ,
                     NHBW  ,
                     NHBNW ,
                     HBS   ,
                     HBC   ,
                     Rec   ,
                     LT    ,
                     MD    ,
                     HV    ,
                     Ext   
            
            
            
            ;Cluster: distribute intrastep processing
            DistributeIntrastep MaxProcesses=@CoresAvailable@
            
            
            
            ZONES    = @UsedZones@
            ZONEMSG  = 10
            
            
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 1
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            FILLMW MW[101] = mi.1.1(14)    ;GC
            
        ENDRUN
    
    endif  ;n=1
    
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_SK = currenttime()
        SubScriptRunTime_SK = SubScriptEndTime_SK - @SubScriptStartTime_SK@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            Skims               ', formatdatetime(SubScriptRunTime_SK, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;DISTRIBUTION ==========================================================================================================================
    
    ;get start time
    SubScriptStartTime_DB = currenttime()
    
    
    ;Cluster: distribute MATRIX call onto processor 2
    DistributeMultiStep Alias='Distrib_Proc2'
    
        ;Short Haul LT, MD & HV truck distribution (loosely constrained)
        RUN PGM=DISTRIBUTION  MSG='Distribution: Feedback Loop @n@ - Step 2: Distribute II LT, MD & HV Truck'
        
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_Tripgen\pa.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF_GC.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\K_FACTORS.mtx'
        
        FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\3_Distribute\FricFactor_AllPurp.csv'
        
        
        FILEO MATO   = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_SH_Truck_tmp.mtx', 
            mo=1-3, 
            name=SH_LT, 
                 SH_MD, 
                 SH_HV
            
            
            ;parameters
            ZONES    = @UsedZones@
            ZONEMSG  = 10
            MAXITERS = 3           ;loosely constrained
            MAXRMSE  = 10
            
            
            ;read in friction factors 
            LOOKUP LOOKUPI=1, 
                LIST=N, 
                INTERPOLATE=T, 
                NAME=FF,  
                  LOOKUP[1]=1, RESULT=09,     ;LT
                  LOOKUP[2]=1, RESULT=10,     ;MD
                  LOOKUP[3]=1, RESULT=11      ;HV
            
            
            ;set production & attraction arrays
            SETPA P[1]=zi.1.LT_P,  A[1]=zi.1.LT_A,
                  P[2]=zi.1.MD_P,  A[2]=zi.1.MD_A,
                  P[3]=zi.1.HV_P,  A[3]=zi.1.HV_A
            
            
            ;read in weighted average daily skims
            if (@n@=2)
                
                ;average free-flow and congested skims (for 2nd iteration only)
                mw[101] = (mi.1.LT + mi.2.LT) / 2
                mw[102] = (mi.1.MD + mi.2.MD) / 2
                mw[103] = (mi.1.HV + mi.2.HV) / 2
            
            else
                
                mw[101] = mi.1.LT
                mw[102] = mi.1.MD
                mw[103] = mi.1.HV
                
            endif  ;n=2
            
            
            ;distribute trips
            GRAVITY   PURPOSE=1, LOS=mw[101], FFACTORS=FF, KFACTORS=mi.3.Trk     ;LT
            GRAVITY   PURPOSE=2, LOS=mw[102], FFACTORS=FF, KFACTORS=mi.3.Trk     ;MD
            GRAVITY   PURPOSE=3, LOS=mw[103], FFACTORS=FF, KFACTORS=mi.3.Trk     ;HV
            
            
            ;bucket rounding
            mw[101] = mw[101], Total=ROWFIX(101, i, 0.5)     ;LT
            mw[102] = mw[102], Total=ROWFIX(102, i, 0.5)     ;MD
            mw[103] = mw[103], Total=ROWFIX(103, i, 0.5)     ;HV
            
            
            ;print TLF to prn file
            ;FREQUENCY VALUEMW=1  BASEMW=101,  RANGE=1-200
            ;FREQUENCY VALUEMW=2  BASEMW=102,  RANGE=1-200
            ;FREQUENCY VALUEMW=3  BASEMW=103,  RANGE=1-200
            
        ENDRUN
        
    ;Cluster: end of group distributed to processor 2
    EndDistributeMULTISTEP
    
    
    
    ;Cluster: distribute MATRIX call onto processor 3
    DistributeMultiStep Alias='Distrib_Proc3'
        
        ;HBO, NHB distribution (loosely constrained)
        RUN PGM=DISTRIBUTION  MSG='Distribution: Feedback Loop @n@ - Step 3: Distribute HBO, HBS and NHB'
        
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_Tripgen\pa.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF_GC.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\K_FACTORS.mtx'
        
        FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\3_Distribute\FricFactor_AllPurp.csv'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBO_HBS_NHB_tmp.mtx', 
            mo=1-6, 
            name=HBSHP   , 
                 HBOTH   ,
                 HBSch_Pr, 
                 HBSch_Sc, 
                 NHBW    , 
                 NHBNW   
            
            
            ;parameters
            ZONES    = @UsedZones@
            ZONEMSG  = 10
            MAXITERS = 3           ;loosely constrained
            MAXRMSE  = 10
            
            
            ;read in friction factors by purpose
            LOOKUP LOOKUPI=1, 
                LIST=N, 
                INTERPOLATE=Y, 
                NAME=FF,   
                  LOOKUP[1]=1, RESULT=03,    ;HBSHP
                  LOOKUP[2]=1, RESULT=04,    ;HBOTH
                  LOOKUP[3]=1, RESULT=05,    ;HBSch_Pr  
                  LOOKUP[4]=1, RESULT=06,    ;HBSch_Sc  
                  LOOKUP[5]=1, RESULT=07,    ;NHBW
                  LOOKUP[6]=1, RESULT=08     ;NHBNW
                
            
            ;read in productions/attractions     
            SETPA P[1]=zi.1.HBSHP_P   ,  A[1]=zi.1.HBSHP_A   ,
                  P[2]=zi.1.HBOTH_P   ,  A[2]=zi.1.HBOTH_A   ,
                  P[3]=zi.1.HBSch_Pr_P,  A[3]=zi.1.HBSch_Pr_A,
                  P[4]=zi.1.HBSch_Sc_P,  A[4]=zi.1.HBSch_Sc_A,
                  P[5]=zi.1.NHBW_P    ,  A[5]=zi.1.NHBW_A    ,
                  P[6]=zi.1.NHBNW_P   ,  A[6]=zi.1.NHBNW_A   
            
            
            ;read in weighted average daily skims
            if (@n@=2)
                
                ;average free-flow and congested skims (for 2nd iteration only)
                mw[101] = (mi.1.HBShp + mi.2.HBShp) / 2
                mw[102] = (mi.1.HBOth + mi.2.HBOth) / 2
                mw[103] = (mi.1.HBS   + mi.2.HBS  ) / 2
                mw[104] = (mi.1.HBS   + mi.2.HBS  ) / 2
                mw[105] = (mi.1.NHBW  + mi.2.NHBW ) / 2
                mw[106] = (mi.1.NHBNW + mi.2.NHBNW) / 2
            
            else
                
                mw[101] = mi.1.HBShp
                mw[102] = mi.1.HBOth
                mw[103] = mi.1.HBS
                mw[104] = mi.1.HBS
                mw[105] = mi.1.NHBW
                mw[106] = mi.1.NHBNW
                
            endif  ;n=2
            
            
            ;distribute trips
            GRAVITY PURPOSE=1, LOS=mw[101], FFACTORS=FF, KFACTORS=mi.3.Oth    ;HBSHP
            GRAVITY PURPOSE=2, LOS=mw[102], FFACTORS=FF, KFACTORS=mi.3.Oth    ;HBOTH
            GRAVITY PURPOSE=3, LOS=mw[103], FFACTORS=FF, KFACTORS=mi.3.Oth    ;HBSch_Pr   
            GRAVITY PURPOSE=4, LOS=mw[104], FFACTORS=FF, KFACTORS=mi.3.Oth    ;HBSch_Sc   
            GRAVITY PURPOSE=5, LOS=mw[105], FFACTORS=FF, KFACTORS=mi.3.Oth    ;NHBW
            GRAVITY PURPOSE=6, LOS=mw[106], FFACTORS=FF, KFACTORS=mi.3.Oth    ;NHBNW
            
            
            ;bucket rounding
            mw[101] = mw[101], Total=ROWFIX(101, i, 0.5)     ;HBSHP
            mw[102] = mw[102], Total=ROWFIX(102, i, 0.5)     ;HBOTH
            mw[103] = mw[103], Total=ROWFIX(103, i, 0.5)     ;HBSch_Pr
            mw[104] = mw[104], Total=ROWFIX(104, i, 0.5)     ;HBSch_Sc
            mw[105] = mw[105], Total=ROWFIX(105, i, 0.5)     ;NHBW
            mw[106] = mw[106], Total=ROWFIX(106, i, 0.5)     ;NHBNW
            
            
            ;print TLF to prn file
            ;FREQUENCY VALUEMW=1, BASEMW=101, RANGE=1-200    ;HBSHP
            ;FREQUENCY VALUEMW=2, BASEMW=102, RANGE=1-200    ;HBOTH
            ;FREQUENCY VALUEMW=3, BASEMW=103, RANGE=1-200    ;HBSch_Pr
            ;FREQUENCY VALUEMW=4, BASEMW=104, RANGE=1-200    ;HBSch_Sc
            ;FREQUENCY VALUEMW=5, BASEMW=105, RANGE=1-200    ;NHBW
            ;FREQUENCY VALUEMW=6, BASEMW=106, RANGE=1-200    ;NHBNW
            
        ENDRUN
        
    ;Cluster: end of group distributed to processor 3
    EndDistributeMULTISTEP
    
    
    
    ;Cluster: distribute MATRIX call onto processor 4
    DistributeMultiStep Alias='Distrib_Proc4'
    
        ;IX and XI distribution (singly constrained)
        RUN PGM=DISTRIBUTION  MSG='Distribution: Feedback Loop @n@ - Step 4: Distribute IX and XI Person-LT, MD, and HV'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_Tripgen\pa.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF_GC.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\K_FACTORS.mtx'
        
        FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\3_Distribute\FricFactor_AllPurp.csv'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_IXXI_tmp.mtx', 
            mo=1-6, 
            name=IX   ,
                 IX_MD,
                 IX_HV,
                 XI,
                 XI_MD,
                 XI_HV
            
            
            ;parameters
            ZONES    = @UsedZones@
            ZONEMSG  = 10
            MAXITERS = 1           ;singly constrained
            MAXRMSE  = 10
            
            
            ;read in friction factors 
            LOOKUP LOOKUPI=1, 
                LIST=N, 
                INTERPOLATE=Y, 
                NAME=FF,  
                  LOOKUP[1]=1, RESULT=12,    ;IX
                  LOOKUP[2]=1, RESULT=14,    ;IX_MD
                  LOOKUP[3]=1, RESULT=15,    ;IX_HV
                  LOOKUP[4]=1, RESULT=16,    ;XI   
                  LOOKUP[5]=1, RESULT=18,    ;XI_MD
                  LOOKUP[6]=1, RESULT=19     ;XI_HV
            
            
            ;Because we are singly constraining we need to conserve the IX attraction end
            ;of each trip (the cordon crossing). To accomplish this, set IX_P=IX_A and 
            ;IX_A=IX_P, then transpose IX matrix in matrix combining step
            SETPA P[1]=zi.1.IX_A   ,  A[1]=zi.1.IX_P   ,
                  P[2]=zi.1.IX_MD_A,  A[2]=zi.1.IX_MD_P,
                  P[3]=zi.1.IX_HV_A,  A[3]=zi.1.IX_HV_P,
                  
                  P[4]=zi.1.XI_P   ,  A[4]=zi.1.XI_A   ,
                  P[5]=zi.1.XI_MD_P,  A[5]=zi.1.XI_MD_A,
                  P[6]=zi.1.XI_HV_P,  A[6]=zi.1.XI_HV_A
            
            
            ;read in weighted average daily skims
            if (@n@=2)
                
                ;average free-flow and congested skims (for 2nd iteration only)
                mw[101] = (mi.1.Ext + mi.2.Ext) / 2
                mw[102] = (mi.1.MD  + mi.2.MD ) / 2
                mw[103] = (mi.1.HV  + mi.2.HV ) / 2
                
                mw[104] = (mi.1.Ext + mi.2.Ext) / 2
                mw[105] = (mi.1.MD  + mi.2.MD ) / 2
                mw[106] = (mi.1.HV  + mi.2.HV ) / 2
            
            else
                
                mw[101] = mi.1.Ext
                mw[102] = mi.1.MD
                mw[103] = mi.1.HV
                
                mw[104] = mi.1.Ext
                mw[105] = mi.1.MD
                mw[106] = mi.1.HV
                
            endif  ;n=2
            
            
            ;distribute trips
            GRAVITY PURPOSE=1, LOS=mw[101], FFACTORS=FF, KFACTORS=mi.3.Ext    ;IX
            GRAVITY PURPOSE=2, LOS=mw[102], FFACTORS=FF, KFACTORS=mi.3.Ext    ;IX_MD
            GRAVITY PURPOSE=3, LOS=mw[103], FFACTORS=FF, KFACTORS=mi.3.Ext    ;IX_HV
            
            GRAVITY PURPOSE=4, LOS=mw[104], FFACTORS=FF, KFACTORS=mi.3.Ext    ;XI
            GRAVITY PURPOSE=5, LOS=mw[105], FFACTORS=FF, KFACTORS=mi.3.Ext    ;XI_MD
            GRAVITY PURPOSE=6, LOS=mw[106], FFACTORS=FF, KFACTORS=mi.3.Ext    ;XI_HV
            
            
            ;bucket rounding
            mw[101] = mw[101], Total=ROWFIX(101, i, 0.5)     ;IX
            mw[102] = mw[102], Total=ROWFIX(102, i, 0.5)     ;IX_MD
            mw[103] = mw[103], Total=ROWFIX(103, i, 0.5)     ;IX_HV
            
            mw[104] = mw[104], Total=ROWFIX(104, i, 0.5)     ;XI
            mw[105] = mw[105], Total=ROWFIX(105, i, 0.5)     ;XI_MD
            mw[106] = mw[106], Total=ROWFIX(106, i, 0.5)     ;XI_HV
            
            
            ;print TLF to prn file
            ;FREQUENCY VALUEMW=1, BASEMW=101, RANGE=1-200    ;IX
            ;FREQUENCY VALUEMW=2, BASEMW=102, RANGE=1-200    ;IX_MD
            ;FREQUENCY VALUEMW=3, BASEMW=103, RANGE=1-200    ;IX_HV
            
            ;FREQUENCY VALUEMW=4, BASEMW=104, RANGE=1-200    ;XI
            ;FREQUENCY VALUEMW=5, BASEMW=105, RANGE=1-200    ;XI_MD
            ;FREQUENCY VALUEMW=6, BASEMW=106, RANGE=1-200    ;XI_HV
            
        ENDRUN
        
    ;Cluster: end of group distributed to processor 4
    EndDistributeMULTISTEP
    
    
    
    ;Cluster: keep processing on processor 1 (Main)
    
        ;HBW distribution (doubly constrained)
        RUN PGM=DISTRIBUTION  MSG='Distribution: Feedback Loop @n@ - Step 5: Distribute HBW'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_Tripgen\pa.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_FF_GC.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\K_FACTORS.mtx'
        
        FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\3_Distribute\FricFactor_AllPurp.csv'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBW_tmp.mtx',
            mo=1, 
            name=HBW
            
            
            ;parameters
            ZONES    = @UsedZones@
            ZONEMSG  = 10
            maxiters = 20          ;doubly constrained
            maxrmse  = 10
            
            
            ;read in friction factors
            LOOKUP LOOKUPI=1, 
                LIST=N, 
                INTERPOLATE=Y, 
                NAME=FF, 
                  LOOKUP[1]=1, RESULT=2     ;HBW
            
            
            ;read in productions/attractions    
            SETPA P[1]=zi.1.HBW_P,  A[1]=zi.1.HBW_A
            
            
            ;read in weighted average daily skims
            if (@n@=2)
                
                ;average free-flow and congested skims (for 2nd iteration only)
                mw[101] = (mi.1.HBW + mi.2.HBW) / 2
            
            else
                
                mw[101] = mi.1.HBW
                
            endif  ;n=2
            
            
            ;distribute trips
            GRAVITY PURPOSE=1, LOS=mw[101], FFACTORS=FF, KFACTORS=mi.3.Wrk    ;HBW
            
            
            ;bucket rounding
            mw[101] = mw[101], Total=ROWFIX(101, i, 0.5)     ;HBW
            
            
            ;print TLF to prn file
            ;FREQUENCY VALUEMW=1, BASEMW=101, RANGE=1-200    ;HBW
        ENDRUN
    
    ;Cluster: bring together all distributed steps before continuing
    BARRIER IDLIST='Distrib_Proc2', 'Distrib_Proc3', 'Distrib_Proc4' CheckReturnCode=T
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_DB = currenttime()
        SubScriptRunTime_DB = SubScriptEndTime_DB - @SubScriptStartTime_DB@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            Distribute trips    ', formatdatetime(SubScriptRunTime_DB, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;AVERAGE TRIP TABLE WITH PREVIOUS ITERATION ============================================================================================
    
    ;get start time
    SubScriptStartTime_AV = currenttime()
    
    
    ;set Telecommute adjust Factor to target 2019 Telecommute share of HBW total trips
    CalibFac_Tel = 1
    
    
    ;combine distributed files
    if (n<=2)
        
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 6: Combine Distributed Trips (Iter 1-2 No Averaging)'
            FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_TripGen\pa.dbf'
            
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBW_tmp.mtx'
                  MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBO_HBS_NHB_tmp.mtx'
                  MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_IXXI_tmp.mtx'
                  MATI[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_SH_Truck_tmp.mtx'
                  
                  MATI[5] = '@ParentDir@@ScenarioDir@0_InputProcessing\AddTripTable.mtx'
                  MATI[6] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_TripTable_@DemographicYear@.mtx'
                  
            FILEO MATO   = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx',
                mo=100-116, 120-124, 130-133, 141-146,
                name=TOT      ,
                     HBW      ,
                     HBShp    ,
                     HBOth    ,
                     HBSch_Pr ,
                     HBSch_Sc ,
                     HBC      ,
                     NHBW     ,
                     NHBNW    ,
                     IX       ,
                     XI       ,
                     XX       ,
                     SH_LT    ,
                     SH_MD    ,
                     SH_HV    ,
                     Ext_MD   ,
                     Ext_HV   ,
                     
                     HBSch    ,
                     HBO      ,
                     NHB      ,
                     TTUNIQUE ,
                     HBOthnTT ,
                     
                     Tot_HBW  ,
                     Tel_HBW  ,
                     Tot_NHBW ,
                     Tel_NHBW ,
                     
                     IX_MD    ,
                     XI_MD    ,
                     XX_MD    ,
                     IX_HV    ,
                     XI_HV    ,
                     XX_HV    
            
            ;Cluster: distribute intrastep processing
            DistributeIntrastep MaxProcesses=@CoresAvailable@
            
            
            
            ZONES   = @UsedZones@
            ZONEMSG = 50
            
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 1
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            ;assign working matrices -------------------------------------------------------------------------
            
            ;exogeneous trip table (airport & Lagoon)
            mw[123] = mi.5.TTUNIQUE
            
            ;HBOth trip table without exogenous trip table
            mw[124] = mi.2.HBOth
            
            ;HBW & NHBW trips
            mw[130] = mi.1.HBW
            mw[132] = mi.2.NHBW
            
            
            ;calulate telecommute trips
            JLOOP
                
                mw[131] = mw[130] * zi.1.PctTelHBW[j]  * @CalibFac_Tel@
                mw[133] = mw[132] * zi.1.PctTelNHBW[j] * @CalibFac_Tel@
                
            ENDJLOOP
            
            
            ;assign remaining working matrices
            mw[101] = mw[130] -    ;remove HBW telework trips
                      mw[131] 
            
            mw[102] = mi.2.HBShp
            
            mw[103] = mw[123] +    ;add exogeneous trip table (airport & Lagoon) to HBOth trip table
                      mw[124] 
            
            mw[104] = mi.2.HBSch_Pr
            mw[105] = mi.2.HBSch_Sc
            
            mw[106] = mi.5.HBC
            
            mw[107] = mw[132] -    ;remove NHBW telework trips
                      mw[133] 
            
            mw[108] = mi.2.NHBNW
            
            
            ;IX, XI, XX (note: these are vehicle trips)
            ;  note: LT merged with Passenger for IX, XI & XX trips
            ;  note: see note in IX distribution step for why need to transpose matrix
            mw[109] = mi.3.IX.T
            mw[110] = mi.3.XI
            mw[111] = mi.6.XX_PL
            
            
            ;short haul truck trips (note: these are vehicle trips)
            mw[112] = mi.4.SH_LT
            mw[113] = mi.4.SH_MD
            mw[114] = mi.4.SH_HV
            
            ;external truck
            ;  note: total external truck trips include IX & XI from Distrib & XX from Input Processing
            ;  note: see note in IX distribution step for why need to transpose matrix
            ;  note: also report IX & XI MD & HV trucks separately for averaging, XX matrices are pass through for final calculations
            mw[141] = mi.3.IX_MD.T
            mw[142] = mi.3.XI_MD
            mw[143] = mi.6.XX_MD
            
            mw[144] = mi.3.IX_HV.T
            mw[145] = mi.3.XI_HV
            mw[146] = mi.6.XX_HV
            
            
            mw[115] = mw[141] +    ;IX_MD
                      mw[142] +    ;XI_MD
                      mw[143]      ;XX_MD
            
            mw[116] = mw[144] +    ;IX_HV
                      mw[145] +    ;XI_HV
                      mw[146]      ;XX_HV
            
            
            ;calculate total trips
            mw[100] = mw[101] +    ;HBW
                      mw[102] +    ;HBShp
                      mw[103] +    ;HBOth
                      mw[104] +    ;HBSch_Pr
                      mw[105] +    ;HBSch_Sc
                      mw[106] +    ;HBC
                      mw[107] +    ;NHBW
                      mw[108] +    ;NHBNW
                      mw[109] +    ;IX
                      mw[110] +    ;XI
                      mw[111] +    ;XX
                      mw[112] +    ;SH_LT
                      mw[113] +    ;SH_MD
                      mw[114] +    ;SH_HV
                      mw[115] +    ;Ext_MD
                      mw[116]      ;Ext_HV
            
            
            ;total HBSch
            mw[120] = mw[104] +
                      mw[105] 
            
            ;HBO
            mw[121] = mw[102] +
                      mw[103] 
            
            ;NHB (excludes Tel_NHBW)
            mw[122] = mw[107] +
                      mw[108] 
            
        ENDRUN
        
    
    ;average PA trip tables for each interchange by successive averages, and test for trip table convergence
    else
    
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 6: Summarize and Average Trip Tables (Iter 3+ MSA)'
            FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@2_TripGen\pa.dbf'
            
            ;this iteration
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBW_tmp.mtx'
                  MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_HBO_HBS_NHB_tmp.mtx'
                  MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_IXXI_tmp.mtx'
                  MATI[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_SH_Truck_tmp.mtx'
            
            ;last iteration
            FILEI MATI[8] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n_1@_tmp.mtx'
            
            
            FILEO MATO[1]='@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx',
                mo=100-116, 120-124, 130-133, 141-146,
                name=TOT      ,
                     HBW      ,
                     HBShp    ,
                     HBOth    ,
                     HBSch_Pr ,
                     HBSch_Sc ,
                     HBC      ,
                     NHBW     ,
                     NHBNW    ,
                     IX       ,
                     XI       ,
                     XX       ,
                     SH_LT    ,
                     SH_MD    ,
                     SH_HV    ,
                     Ext_MD   ,
                     Ext_HV   ,
                     
                     HBSch    ,
                     HBO      ,
                     NHB      ,
                     TTUNIQUE ,
                     HBOthnTT ,
                     
                     Tot_HBW  ,
                     Tel_HBW  ,
                     Tot_NHBW ,
                     Tel_NHBW ,
                     
                     IX_MD    ,
                     XI_MD    ,
                     XX_MD    ,
                     IX_HV    ,
                     XI_HV    ,
                     XX_HV    
            
            
            
            ;can't use Cluster because of LOG statement
            DistributeIntrastep MaxProcesses=@CoresAvailable@
            
            
            
            ZONES   = @Usedzones@
            ZONEMSG = 10
            
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 1
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            
            ;assign working matrices for CURRENT iteration trip tables ---------------------------------------
            mw[224] = mi.2.HBOth       ;excludes exogeneous trip table (TTUNIQUE)
            
            mw[230] = mi.1.HBW         ;includes Tel_HBW from Distrib
            mw[232] = mi.2.NHBW        ;includes Tel_NHBW from Distrib
            
            mw[202] = mi.2.HBShp
            mw[204] = mi.2.HBSch_Pr 
            mw[205] = mi.2.HBSch_Sc
            mw[208] = mi.2.NHBNW
            
            ;IX, XI (note: these are vehicle trips)
            ;  note: LT merged with Passenger for IX, XI & XX trips
            ;  note: see note in IX distribution step for why need to transpose matrix
            mw[209] = mi.3.IX.T
            mw[210] = mi.3.XI
            
            mw[212] = mi.4.SH_LT
            mw[213] = mi.4.SH_MD
            mw[214] = mi.4.SH_HV
            
            ;external truck
            mw[241] = mi.3.IX_MD.T
            mw[242] = mi.3.XI_MD
            
            mw[244] = mi.3.IX_HV.T
            mw[245] = mi.3.XI_HV
            
            ;do not average exogenous trip tables
            
            
            ;assign working matrices from LAST iteration trip tables -----------------------------------------
            mw[324] = mi.8.HBOthnTT    ;excludes exogeneous trip table (TTUNIQUE)
            
            mw[330] = mi.8.Tot_HBW     ;includes Tel_HBW
            mw[332] = mi.8.Tot_NHBW    ;includes Tel_NHBW
            
            mw[302] = mi.8.HBShp
            mw[304] = mi.8.HBSch_Pr 
            mw[305] = mi.8.HBSch_Sc
            mw[308] = mi.8.NHBNW
            
            mw[309] = mi.8.IX          ;already transposed from last iteration
            mw[310] = mi.8.XI
            
            mw[312] = mi.8.SH_LT
            mw[313] = mi.8.SH_MD
            mw[314] = mi.8.SH_HV
            
            mw[341] = mi.8.IX_MD       ;already transposed from last iteration
            mw[342] = mi.8.XI_MD
            
            mw[344] = mi.8.IX_HV       ;already transposed from last iteration
            mw[345] = mi.8.XI_HV
            
            
            ;do not average exogenous trip tables
            
            
            
            ;AVERAGE P/A flows (for output to mode choice models) --------------------------------------------
            ;  note: with method of successive averaging (MSA) current round gets less & less weight in favor
            ;  of the average of past iterations
            mw[124]  =  mw[224] * (1/@n_1@)  +  mw[324] * (@n_2@/@n_1@)     ;HBOth - excludes exogeneous trip table (TTUNIQUE)
            
            mw[130]  =  mw[230] * (1/@n_1@)  +  mw[330] * (@n_2@/@n_1@)     ;HBW  - includes Tel_HBW
            mw[132]  =  mw[232] * (1/@n_1@)  +  mw[332] * (@n_2@/@n_1@)     ;NHBW - includes Tel_NHBW
            
            mw[102]  =  mw[202] * (1/@n_1@)  +  mw[302] * (@n_2@/@n_1@)     ;HBShp
            mw[104]  =  mw[204] * (1/@n_1@)  +  mw[304] * (@n_2@/@n_1@)     ;HBSch_Pr
            mw[105]  =  mw[205] * (1/@n_1@)  +  mw[305] * (@n_2@/@n_1@)     ;HBSch_Sc
            mw[108]  =  mw[208] * (1/@n_1@)  +  mw[308] * (@n_2@/@n_1@)     ;NHBNW
            
            mw[109]  =  mw[209] * (1/@n_1@)  +  mw[309] * (@n_2@/@n_1@)     ;IX
            mw[110]  =  mw[210] * (1/@n_1@)  +  mw[310] * (@n_2@/@n_1@)     ;XI
            
            mw[112]  =  mw[212] * (1/@n_1@)  +  mw[312] * (@n_2@/@n_1@)     ;SH_LT
            mw[113]  =  mw[213] * (1/@n_1@)  +  mw[313] * (@n_2@/@n_1@)     ;SH_MD
            mw[114]  =  mw[214] * (1/@n_1@)  +  mw[314] * (@n_2@/@n_1@)     ;SH_HV
            
            mw[141]  =  mw[241] * (1/@n_1@)  +  mw[341] * (@n_2@/@n_1@)     ;IX_MD
            mw[142]  =  mw[242] * (1/@n_1@)  +  mw[342] * (@n_2@/@n_1@)     ;XI_MD
            
            mw[144]  =  mw[244] * (1/@n_1@)  +  mw[344] * (@n_2@/@n_1@)     ;IX_HV
            mw[145]  =  mw[245] * (1/@n_1@)  +  mw[345] * (@n_2@/@n_1@)     ;XI_HV
            
            
            ;assign exogenous working matrices (pass through from last iteration)
            mw[106] = mi.8.HBC
            mw[111] = mi.8.XX
            mw[115] = mi.8.Ext_MD
            mw[116] = mi.8.Ext_HV
            mw[123] = mi.8.TTUNIQUE
            mw[143] = mi.8.XX_MD
            mw[146] = mi.8.XX_HV
            
            
            ;add TTUNIQUE back to HBOth
            mw[103] = mw[123] +    ;TTUNIQUE
                      mw[124]      ;averaged HBOth
            
            
            ;calulate telecommute trips
            JLOOP
                
                mw[131] = mw[130] * zi.1.PctTelHBW[j]  * @CalibFac_Tel@
                mw[133] = mw[132] * zi.1.PctTelNHBW[j] * @CalibFac_Tel@
                
            ENDJLOOP
            
            ;calculate HBW & NHBW trips (Total minus telecommute)
            mw[101] = mw[130] - mw[131]    ;HBW
            mw[107] = mw[132] - mw[133]    ;NHBW
            
            
            ;external truck
            ;  note: external truck trips include IX & XI from Distrib & XX from Input Processing
            mw[115] = mw[141] +    ;IX_MD
                      mw[142] +    ;XI_MD
                      mw[143]      ;XX_MD
            
            mw[116] = mw[144] +    ;IX_HV
                      mw[145] +    ;XI_HV
                      mw[146]      ;XX_HV
            
            
            ;calculate total trips
            mw[100] = mw[101] +    ;HBW
                      mw[102] +    ;HBShp
                      mw[103] +    ;HBOth
                      mw[104] +    ;HBSch_Pr
                      mw[105] +    ;HBSch_Sc
                      mw[106] +    ;HBC
                      mw[107] +    ;NHBW
                      mw[108] +    ;NHBNW
                      mw[109] +    ;IX
                      mw[110] +    ;XI
                      mw[111] +    ;XX
                      mw[112] +    ;SH_LT
                      mw[113] +    ;SH_MD
                      mw[114] +    ;SH_HV
                      mw[115] +    ;Ext_MD
                      mw[116]      ;Ext_HV
            
            
            ;total HBSch
            mw[120] = mw[104] +
                      mw[105] 
            
            ;HBO
            mw[121] = mw[102] +
                      mw[103] 
            
            ;NHB (excludes Tel_NHBW)
            mw[122] = mw[107] +
                      mw[108] 
            
        ENDRUN
        
    endif  ;n<=2 for trip table averaging
    
    
    
    
    ;CALC % CHANGE STATS IN TRIP TABLE ===========================================================================================
    
    if (n=1)
        
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 7: Summarize Trip Table'
            
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx'
            
            
            
            ZONES   = @Usedzones@
            ZONEMSG = 10
            
            
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 5
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            ;read in trips ---------------------------------------------------------------------------------------
            ;daily, averaged PA trip tables - current iteration
            mw[100] = mi.1.TOT
            mw[101] = mi.1.HBW
            mw[102] = mi.1.HBShp
            mw[103] = mi.1.HBOth
            mw[104] = mi.1.HBSch_Pr
            mw[105] = mi.1.HBSch_Sc
            mw[106] = mi.1.HBC
            mw[107] = mi.1.NHBW
            mw[108] = mi.1.NHBNW
            mw[109] = mi.1.IX
            mw[110] = mi.1.XI
            mw[111] = mi.1.XX
            mw[112] = mi.1.SH_LT
            mw[113] = mi.1.SH_MD
            mw[114] = mi.1.SH_HV
            mw[115] = mi.1.Ext_MD
            mw[116] = mi.1.Ext_HV
            
            mw[120] = mi.1.HBSch
            mw[121] = mi.1.HBO
            mw[122] = mi.1.NHB
            mw[123] = mi.1.TTUNIQUE
            mw[124] = mi.1.HBOthnTT
            
            mw[130] = mi.1.Tot_HBW
            mw[131] = mi.1.Tel_HBW
            mw[132] = mi.1.Tot_NHBW
            mw[133] = mi.1.Tel_NHBW
            
            
            
            ;summarize trips for LOG file ------------------------------------------------------------------------
            sum1_TOT      = sum1_TOT      + rowsum(100)
            sum1_HBW      = sum1_HBW      + rowsum(101)
            sum1_HBShp    = sum1_HBShp    + rowsum(102)
            sum1_HBOth    = sum1_HBOth    + rowsum(103)
            sum1_HBSch_Pr = sum1_HBSch_Pr + rowsum(104)
            sum1_HBSch_Sc = sum1_HBSch_Sc + rowsum(105)
            sum1_HBC      = sum1_HBC      + rowsum(106)
            sum1_NHBW     = sum1_NHBW     + rowsum(107)
            sum1_NHBNW    = sum1_NHBNW    + rowsum(108)
            sum1_IX       = sum1_IX       + rowsum(109)
            sum1_XI       = sum1_XI       + rowsum(110)
            sum1_XX       = sum1_XX       + rowsum(111)
            sum1_SH_LT    = sum1_SH_LT    + rowsum(112)
            sum1_SH_MD    = sum1_SH_MD    + rowsum(113)
            sum1_SH_HV    = sum1_SH_HV    + rowsum(114)
            sum1_Ext_MD   = sum1_Ext_MD   + rowsum(115)
            sum1_Ext_HV   = sum1_Ext_HV   + rowsum(116)
            
            sum1_HBSch    = sum1_HBSch    + rowsum(120)
            sum1_HBO      = sum1_HBO      + rowsum(121)
            sum1_NHB      = sum1_NHB      + rowsum(122)
            sum1_TTUNIQUE = sum1_TTUNIQUE + rowsum(123)
            sum1_HBOthnTT = sum1_HBOthnTT + rowsum(124)
            
            sum1_Tot_HBW  = sum1_Tot_HBW  + rowsum(130)
            sum1_Tel_HBW  = sum1_Tel_HBW  + rowsum(131)
            sum1_Tot_NHBW = sum1_Tot_NHBW + rowsum(132)
            sum1_Tel_NHBW = sum1_Tel_NHBW + rowsum(133)
            
            
            
            ;calculate number of cells with trips>0
            JLOOP
                
                ;indicate ij pair is significant
                if (mw[100]>0)  CountSig = CountSig + 1
                
            ENDJLOOP
            
            
            
            ;print to LOG file -------------------------------------------------------------------------------
            if (i=ZONES)
                
                ;set comparison and convergence variables to 0 for iter 1
                Converged    = 0
                PctMatConv   = 0
                
                
                Pct_TOT      = 0
                Pct_HBW      = 0
                Pct_HBShp    = 0
                Pct_HBOth    = 0
                Pct_HBSch_Pr = 0
                Pct_HBSch_Sc = 0
                Pct_HBC      = 0
                Pct_NHBW     = 0
                Pct_NHBNW    = 0
                Pct_IX       = 0
                Pct_XI       = 0
                Pct_XX       = 0
                Pct_SH_LT    = 0
                Pct_SH_MD    = 0
                Pct_SH_HV    = 0
                Pct_Ext_MD   = 0
                Pct_Ext_HV   = 0
                
                Pct_HBSch    = 0
                Pct_HBO      = 0
                Pct_NHB      = 0
                Pct_TTUNIQUE = 0
                Pct_HBOthnTT = 0
                
                Pct_Tot_HBW  = 0
                Pct_Tel_HBW  = 0
                Pct_Tot_NHBW = 0
                Pct_Tel_NHBW = 0
                
                
                
                ;print summary for iter 1 to LOG file
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T,
                    FORM=13.0C,
                    LIST='\nFeedback Iteration: @n@',
                         '\n',
                         '\n  Trip Table Summary',
                         '\n    TOT       ', sum1_TOT      ,
                         '\n    HBW       ', sum1_HBW      ,
                         '\n    HBShp     ', sum1_HBShp    ,
                         '\n    HBOth     ', sum1_HBOth    ,
                         '\n    HBSch_Pr  ', sum1_HBSch_Pr ,
                         '\n    HBSch_Sc  ', sum1_HBSch_Sc ,
                         '\n    HBC       ', sum1_HBC      ,
                         '\n    NHBW      ', sum1_NHBW     ,
                         '\n    NHBNW     ', sum1_NHBNW    ,
                         '\n    IX        ', sum1_IX       ,
                         '\n    XI        ', sum1_XI       ,
                         '\n    XX        ', sum1_XX       ,
                         '\n    SH_LT     ', sum1_SH_LT    ,
                         '\n    SH_MD     ', sum1_SH_MD    ,
                         '\n    SH_HV     ', sum1_SH_HV    ,
                         '\n    Ext_MD    ', sum1_Ext_MD   ,
                         '\n    Ext_HV    ', sum1_Ext_HV   ,
                         '\n', 
                         '\n    HBSch     ', sum1_HBSch    ,
                         '\n    HBO       ', sum1_HBO      ,
                         '\n    NHB       ', sum1_NHB      ,
                         '\n    TTUNIQUE  ', sum1_TTUNIQUE ,
                         '\n    HBOthnTT  ', sum1_HBOthnTT ,
                         '\n', 
                         '\n    Tot_HBW   ', sum1_Tot_HBW  ,
                         '\n    Tel_HBW   ', sum1_Tel_HBW  ,
                         '\n    Tot_NHBW  ', sum1_Tot_NHBW ,
                         '\n    Tel_NHBW  ', sum1_Tel_NHBW 
                
                
                
                ;print data summary to csv file for iter 1
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Trip Table - @RID@.csv',
                    CSV=T,
                    FORM=15.0,
                    LIST='Scenario'     ,
                         'Iter'         ,
                         
                         'ConvCells'    ,
                         'TotSigCells'  ,
                         'PctConv'      ,
                         
                         'TOT'          ,
                         'HBW'          ,
                         'HBShp'        ,
                         'HBOth'        ,
                         'HBSch_Pr'     ,
                         'HBSch_Sc'     ,
                         'HBC'          ,
                         'NHBW'         ,
                         'NHBNW'        ,
                         'IX'           ,
                         'XI'           ,
                         'XX'           ,
                         'SH_LT'        ,
                         'SH_MD'        ,
                         'SH_HV'        ,
                         'Ext_MD'       ,
                         'Ext_HV'       ,
                         'Tel_HBW'      ,
                         'Tel_NHBW'     ,
                         
                         'Pct_TOT'      ,
                         'Pct_HBW'      ,
                         'Pct_HBShp'    ,
                         'Pct_HBOth'    ,
                         'Pct_HBSch_Pr' ,
                         'Pct_HBSch_Sc' ,
                         'Pct_HBC'      ,
                         'Pct_NHBW'     ,
                         'Pct_NHBNW'    ,
                         'Pct_IX'       ,
                         'Pct_XI'       ,
                         'Pct_XX'       ,
                         'Pct_SH_LT'    ,
                         'Pct_SH_MD'    ,
                         'Pct_SH_HV'    ,
                         'Pct_Ext_MD'   ,
                         'Pct_Ext_HV'   ,
                         'Pct_Tel_HBW'  ,
                         'Pct_Tel_NHBW' 
                
                
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Trip Table - @RID@.csv',
                    CSV=T,
                    FORM=13.0,
                    LIST='@ScenarioDir@'        ,
                         @n@(5.0)               ,
                         
                         Converged(9.0)         ,
                         CountSig(9.0)          ,
                         PctMatConv*100(10.2)   ,
                         
                         sum1_TOT               ,
                         sum1_HBW               ,
                         sum1_HBShp             ,
                         sum1_HBOth             ,
                         sum1_HBSch_Pr          ,
                         sum1_HBSch_Sc          ,
                         sum1_HBC               ,
                         sum1_NHBW              ,
                         sum1_NHBNW             ,
                         sum1_IX                ,
                         sum1_XI                ,
                         sum1_XX                ,
                         sum1_SH_LT             ,
                         sum1_SH_MD             ,
                         sum1_SH_HV             ,
                         sum1_Ext_MD            ,
                         sum1_Ext_HV            ,
                         sum1_Tel_HBW           ,
                         sum1_Tel_NHBW          ,
                         
                         Pct_TOT(11.2)          ,
                         Pct_HBW(11.2)          ,
                         Pct_HBShp(11.2)        ,
                         Pct_HBOth(11.2)        ,
                         Pct_HBSch_Pr(11.2)     ,
                         Pct_HBSch_Sc(11.2)     ,
                         Pct_HBC(11.2)          ,
                         Pct_NHBW(11.2)         ,
                         Pct_NHBNW(11.2)        ,
                         Pct_IX(11.2)           ,
                         Pct_XI(11.2)           ,
                         Pct_XX(11.2)           ,
                         Pct_SH_LT(11.2)        ,
                         Pct_SH_MD(11.2)        ,
                         Pct_SH_HV(11.2)        ,
                         Pct_Ext_MD(11.2)       ,
                         Pct_Ext_HV(11.2)       ,
                         Pct_Tel_HBW(11.2)      ,
                         Pct_Tel_NHBW(11.2)     
                
            endif  ;i=ZONES
            
        ENDRUN
        
        
    ;iterations 2+
    else
        
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 7: Summarize Trip Table and Calculate Percent Change'
            
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx'
            FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n_1@_tmp.mtx'
            
            
            
            ZONES   = @Usedzones@
            ZONEMSG = 10
            
            
            
            ;print status to task monitor window
            PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
            PrintProgInc = 1
            
            if (i=FIRSTZONE)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = PrintProgInc
            elseif (PrintProgress=CheckProgress)
                PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
                CheckProgress = CheckProgress + PrintProgInc
            endif
            
            
            
            ;read in trips -----------------------------------------------------------------------------------
            ;daily, averaged PA trip tables - current iteration
            mw[100] = mi.1.TOT
            mw[101] = mi.1.HBW
            mw[102] = mi.1.HBShp
            mw[103] = mi.1.HBOth
            mw[104] = mi.1.HBSch_Pr
            mw[105] = mi.1.HBSch_Sc
            mw[106] = mi.1.HBC
            mw[107] = mi.1.NHBW
            mw[108] = mi.1.NHBNW
            mw[109] = mi.1.IX
            mw[110] = mi.1.XI
            mw[111] = mi.1.XX
            mw[112] = mi.1.SH_LT
            mw[113] = mi.1.SH_MD
            mw[114] = mi.1.SH_HV
            mw[115] = mi.1.Ext_MD
            mw[116] = mi.1.Ext_HV
            
            mw[120] = mi.1.HBSch
            mw[121] = mi.1.HBO
            mw[122] = mi.1.NHB
            mw[123] = mi.1.TTUNIQUE
            mw[124] = mi.1.HBOthnTT
            
            mw[130] = mi.1.Tot_HBW
            mw[131] = mi.1.Tel_HBW
            mw[132] = mi.1.Tot_NHBW
            mw[133] = mi.1.Tel_NHBW
            
            
            ;daily, averaged PA trip tables - last iteration
            mw[200] = mi.2.TOT
            mw[201] = mi.2.HBW
            mw[202] = mi.2.HBShp
            mw[203] = mi.2.HBOth
            mw[204] = mi.2.HBSch_Pr
            mw[205] = mi.2.HBSch_Sc
            mw[206] = mi.2.HBC
            mw[207] = mi.2.NHBW
            mw[208] = mi.2.NHBNW
            mw[209] = mi.2.IX
            mw[210] = mi.2.XI
            mw[211] = mi.2.XX
            mw[212] = mi.2.SH_LT
            mw[213] = mi.2.SH_MD
            mw[214] = mi.2.SH_HV
            mw[215] = mi.2.Ext_MD
            mw[216] = mi.2.Ext_HV
            
            mw[220] = mi.2.HBSch
            mw[221] = mi.2.HBO
            mw[222] = mi.2.NHB
            mw[223] = mi.2.TTUNIQUE
            mw[224] = mi.2.HBOthnTT
            
            mw[230] = mi.2.Tot_HBW
            mw[231] = mi.2.Tel_HBW
            mw[232] = mi.2.Tot_NHBW
            mw[233] = mi.2.Tel_NHBW
            
            
            
            ;summarize trips for LOG file --------------------------------------------------------------------
            sum1_TOT      = sum1_TOT      + rowsum(100)
            sum1_HBW      = sum1_HBW      + rowsum(101)
            sum1_HBShp    = sum1_HBShp    + rowsum(102)
            sum1_HBOth    = sum1_HBOth    + rowsum(103)
            sum1_HBSch_Pr = sum1_HBSch_Pr + rowsum(104)
            sum1_HBSch_Sc = sum1_HBSch_Sc + rowsum(105)
            sum1_HBC      = sum1_HBC      + rowsum(106)
            sum1_NHBW     = sum1_NHBW     + rowsum(107)
            sum1_NHBNW    = sum1_NHBNW    + rowsum(108)
            sum1_IX       = sum1_IX       + rowsum(109)
            sum1_XI       = sum1_XI       + rowsum(110)
            sum1_XX       = sum1_XX       + rowsum(111)
            sum1_SH_LT    = sum1_SH_LT    + rowsum(112)
            sum1_SH_MD    = sum1_SH_MD    + rowsum(113)
            sum1_SH_HV    = sum1_SH_HV    + rowsum(114)
            sum1_Ext_MD   = sum1_Ext_MD   + rowsum(115)
            sum1_Ext_HV   = sum1_Ext_HV   + rowsum(116)
            
            sum1_HBSch    = sum1_HBSch    + rowsum(120)
            sum1_HBO      = sum1_HBO      + rowsum(121)
            sum1_NHB      = sum1_NHB      + rowsum(122)
            sum1_TTUNIQUE = sum1_TTUNIQUE + rowsum(123)
            sum1_HBOthnTT = sum1_HBOthnTT + rowsum(124)
            
            sum1_Tot_HBW  = sum1_Tot_HBW  + rowsum(130)
            sum1_Tel_HBW  = sum1_Tel_HBW  + rowsum(131)
            sum1_Tot_NHBW = sum1_Tot_NHBW + rowsum(132)
            sum1_Tel_NHBW = sum1_Tel_NHBW + rowsum(133)
            
            
            sum2_TOT      = sum2_TOT      + rowsum(200)
            sum2_HBW      = sum2_HBW      + rowsum(201)
            sum2_HBShp    = sum2_HBShp    + rowsum(202)
            sum2_HBOth    = sum2_HBOth    + rowsum(203)
            sum2_HBSch_Pr = sum2_HBSch_Pr + rowsum(204)
            sum2_HBSch_Sc = sum2_HBSch_Sc + rowsum(205)
            sum2_HBC      = sum2_HBC      + rowsum(206)
            sum2_NHBW     = sum2_NHBW     + rowsum(207)
            sum2_NHBNW    = sum2_NHBNW    + rowsum(208)
            sum2_IX       = sum2_IX       + rowsum(209)
            sum2_XI       = sum2_XI       + rowsum(210)
            sum2_XX       = sum2_XX       + rowsum(211)
            sum2_SH_LT    = sum2_SH_LT    + rowsum(212)
            sum2_SH_MD    = sum2_SH_MD    + rowsum(213)
            sum2_SH_HV    = sum2_SH_HV    + rowsum(214)
            sum2_Ext_MD   = sum2_Ext_MD   + rowsum(215)
            sum2_Ext_HV   = sum2_Ext_HV   + rowsum(216)
            
            sum2_HBSch    = sum2_HBSch    + rowsum(220)
            sum2_HBO      = sum2_HBO      + rowsum(221)
            sum2_NHB      = sum2_NHB      + rowsum(222)
            sum2_TTUNIQUE = sum2_TTUNIQUE + rowsum(223)
            sum2_HBOthnTT = sum2_HBOthnTT + rowsum(224)
            
            sum2_Tot_HBW  = sum2_Tot_HBW  + rowsum(230)
            sum2_Tel_HBW  = sum2_Tel_HBW  + rowsum(231)
            sum2_Tot_NHBW = sum2_Tot_NHBW + rowsum(232)
            sum2_Tel_NHBW = sum2_Tel_NHBW + rowsum(233)
            
            
            
            ;calculate % change in trip table ----------------------------------------------------------------
            JLOOP
                
                ;calculate the percent differences for significant (non-zero) trip table flows
                if (mw[100]>0)
                    
                    ;indicate ij pair is significant
                    mw[400] = 1
                    
                    
                    ;determine if last round value wsa greater than zero
                    if (mw[200]>0)
                        
                        ;calculate % change in matrix cells
                        mw[401] = ABS(mw[100] - mw[200]) / mw[200]
                    
                    else
                        
                        ;if previous iter OD flow was 0, % diff is 100%
                        mw[401] = 1
                        
                    endif  ;mw[200]>0
                    
                    
                    ;calculate the number of ij paris with a percent change in daily volume less than or equal to convergence threshold
                    ;  (ij pairs with total trips <1 are considered to meet convergence criteria)
                    PAConvThreshold = 0.075
                    
                    ;identify cells that meet convergence
                    ; note if trips in a cell are >0 but <1 consider this converged
                    if (mw[100]<1 | mw[401]<=PAConvThreshold)  mw[402] = 1
                    
                
                else
                    
                    ;identify ij number of paris that are not significant to avoid over-counting
                    mw[410] = 1 
                    
                endif  ;mw[100]>0
                
            ENDJLOOP
            
            
            ;count number of ij pairs
            CountSig    = CountSig     + ROWSUM(400)     ;sum PAs that are significant
            CountNotSig = CountNotSig  + ROWSUM(410)     ;sum PAs that are not significant
            
            Converged   = Converged    + ROWSUM(402)
            
            
            
            ;print to LOG file -------------------------------------------------------------------------------
            if (i=ZONES)
                
                ;calculate percentage of OD flows that have converged
                PctMatConv = Converged / CountSig
                
                
                ;calculate % change
                Pct_TOT       =  (sum1_TOT      - sum2_TOT     )  /  sum2_TOT      * 100
                Pct_HBW       =  (sum1_HBW      - sum2_HBW     )  /  sum2_HBW      * 100
                Pct_HBShp     =  (sum1_HBShp    - sum2_HBShp   )  /  sum2_HBShp    * 100
                Pct_HBOth     =  (sum1_HBOth    - sum2_HBOth   )  /  sum2_HBOth    * 100
                Pct_HBSch_Pr  =  (sum1_HBSch_Pr - sum2_HBSch_Pr)  /  sum2_HBSch_Pr * 100
                Pct_HBSch_Sc  =  (sum1_HBSch_Sc - sum2_HBSch_Sc)  /  sum2_HBSch_Sc * 100
                Pct_HBC       =  (sum1_HBC      - sum2_HBC     )  /  sum2_HBC      * 100
                Pct_NHBW      =  (sum1_NHBW     - sum2_NHBW    )  /  sum2_NHBW     * 100
                Pct_NHBNW     =  (sum1_NHBNW    - sum2_NHBNW   )  /  sum2_NHBNW    * 100
                Pct_IX        =  (sum1_IX       - sum2_IX      )  /  sum2_IX       * 100
                Pct_XI        =  (sum1_XI       - sum2_XI      )  /  sum2_XI       * 100
                Pct_XX        =  (sum1_XX       - sum2_XX      )  /  sum2_XX       * 100
                Pct_SH_LT     =  (sum1_SH_LT    - sum2_SH_LT   )  /  sum2_SH_LT    * 100
                Pct_SH_MD     =  (sum1_SH_MD    - sum2_SH_MD   )  /  sum2_SH_MD    * 100
                Pct_SH_HV     =  (sum1_SH_HV    - sum2_SH_HV   )  /  sum2_SH_HV    * 100
                Pct_Ext_MD    =  (sum1_Ext_MD   - sum2_Ext_MD  )  /  sum2_Ext_MD   * 100
                Pct_Ext_HV    =  (sum1_Ext_HV   - sum2_Ext_HV  )  /  sum2_Ext_HV   * 100
                
                Pct_HBSch     =  (sum1_HBSch    - sum2_HBSch   )  /  sum2_HBSch    * 100
                Pct_HBO       =  (sum1_HBO      - sum2_HBO     )  /  sum2_HBO      * 100
                Pct_NHB       =  (sum1_NHB      - sum2_NHB     )  /  sum2_NHB      * 100
                Pct_TTUNIQUE  =  (sum1_TTUNIQUE - sum2_TTUNIQUE)  /  sum2_TTUNIQUE * 100
                Pct_HBOthnTT  =  (sum1_HBOthnTT - sum2_HBOthnTT)  /  sum2_HBOthnTT * 100
                
                Pct_Tot_HBW   =  (sum1_Tot_HBW  - sum2_Tot_HBW )  /  sum2_Tot_HBW  * 100
                Pct_Tel_HBW   =  (sum1_Tel_HBW  - sum2_Tel_HBW )  /  sum2_Tel_HBW  * 100
                Pct_Tot_NHBW  =  (sum1_Tot_NHBW - sum2_Tot_NHBW)  /  sum2_Tot_NHBW * 100
                Pct_Tel_NHBW  =  (sum1_Tel_NHBW - sum2_Tel_NHBW)  /  sum2_Tel_NHBW * 100
                
                
                
                ;print summary for iterations 2+ to LOG file
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T,
                    FORM=13.0C,
                    LIST='\n',
                         '\n',
                         '\nFeedback Iteration: @n@',
                         '\n',
                         '\n  Trip Table Summary',
                         '\n              ', '       Iter @n@'  , '       Iter @n_1@',   '    % Change' ,
                         '\n    TOT       ', sum1_TOT      , sum2_TOT      , Pct_TOT(11.2)     , '%',
                         '\n    HBW       ', sum1_HBW      , sum2_HBW      , Pct_HBW(11.2)     , '%',
                         '\n    HBShp     ', sum1_HBShp    , sum2_HBShp    , Pct_HBShp(11.2)   , '%',
                         '\n    HBOth     ', sum1_HBOth    , sum2_HBOth    , Pct_HBOth(11.2)   , '%',
                         '\n    HBSch_Pr  ', sum1_HBSch_Pr , sum2_HBSch_Pr , Pct_HBSch_Pr(11.2), '%',
                         '\n    HBSch_Sc  ', sum1_HBSch_Sc , sum2_HBSch_Sc , Pct_HBSch_Sc(11.2), '%',
                         '\n    HBC       ', sum1_HBC      , sum2_HBC      , Pct_HBC(11.2)     , '%',
                         '\n    NHBW      ', sum1_NHBW     , sum2_NHBW     , Pct_NHBW(11.2)    , '%',
                         '\n    NHBNW     ', sum1_NHBNW    , sum2_NHBNW    , Pct_NHBNW(11.2)   , '%',
                         '\n    IX        ', sum1_IX       , sum2_IX       , Pct_IX(11.2)      , '%',
                         '\n    XI        ', sum1_XI       , sum2_XI       , Pct_XI(11.2)      , '%',
                         '\n    XX        ', sum1_XX       , sum2_XX       , Pct_XX(11.2)      , '%',
                         '\n    SH_LT     ', sum1_SH_LT    , sum2_SH_LT    , Pct_SH_LT(11.2)   , '%',
                         '\n    SH_MD     ', sum1_SH_MD    , sum2_SH_MD    , Pct_SH_MD(11.2)   , '%',
                         '\n    SH_HV     ', sum1_SH_HV    , sum2_SH_HV    , Pct_SH_HV(11.2)   , '%',
                         '\n    Ext_MD    ', sum1_Ext_MD   , sum2_Ext_MD   , Pct_Ext_MD(11.2)  , '%',
                         '\n    Ext_HV    ', sum1_Ext_HV   , sum2_Ext_HV   , Pct_Ext_HV(11.2)  , '%',
                         '\n',
                         '\n    HBSch     ', sum1_HBSch    , sum2_HBSch    , Pct_HBSch(11.2)   , '%',
                         '\n    HBO       ', sum1_HBO      , sum2_HBO      , Pct_HBO(11.2)     , '%',
                         '\n    NHB       ', sum1_NHB      , sum2_NHB      , Pct_NHB(11.2)     , '%',
                         '\n    TTUNIQUE  ', sum1_TTUNIQUE , sum2_TTUNIQUE , Pct_TTUNIQUE(11.2), '%',
                         '\n    HBOthnTT  ', sum1_HBOthnTT , sum2_HBOthnTT , Pct_HBOthnTT(11.2), '%',
                         '\n',
                         '\n    Tot_HBW   ', sum1_Tot_HBW  , sum2_Tot_HBW  , Pct_Tot_HBW(11.2) , '%',
                         '\n    Tel_HBW   ', sum1_Tel_HBW  , sum2_Tel_HBW  , Pct_Tel_HBW(11.2) , '%',
                         '\n    Tot_NHBW  ', sum1_Tot_NHBW , sum2_Tot_NHBW , Pct_Tot_NHBW(11.2), '%',
                         '\n    Tel_NHBW  ', sum1_Tel_NHBW , sum2_Tel_NHBW , Pct_Tel_NHBW(11.2), '%',
                         '\n',
                         '\n   Converged ij pairs',
                         '\n                 Count Conv','    Count Sig','    Pct Conv','   Count NonSig',
                         '\n      PA Cells', Converged, CountSig, PctMatConv*100(10.2), '%', CountNotSig(16.0C)
                
                
                
                ;print data summary to csv file for iterations 2+
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Trip Table - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=13.0,
                    LIST='@ScenarioDir@'        ,
                         @n@(5.0)               ,
                         
                         Converged(9.0)         ,
                         CountSig(9.0)          ,
                         PctMatConv*100(10.2)   ,
                         
                         sum1_TOT               ,
                         sum1_HBW               ,
                         sum1_HBShp             ,
                         sum1_HBOth             ,
                         sum1_HBSch_Pr          ,
                         sum1_HBSch_Sc          ,
                         sum1_HBC               ,
                         sum1_NHBW              ,
                         sum1_NHBNW             ,
                         sum1_IX                ,
                         sum1_XI                ,
                         sum1_XX                ,
                         sum1_SH_LT             ,
                         sum1_SH_MD             ,
                         sum1_SH_HV             ,
                         sum1_Ext_MD            ,
                         sum1_Ext_HV            ,
                         sum1_Tel_HBW           ,
                         sum1_Tel_NHBW          ,
                         
                         Pct_TOT(11.2)          ,
                         Pct_HBW(11.2)          ,
                         Pct_HBShp(11.2)        ,
                         Pct_HBOth(11.2)        ,
                         Pct_HBSch_Pr(11.2)     ,
                         Pct_HBSch_Sc(11.2)     ,
                         Pct_HBC(11.2)          ,
                         Pct_NHBW(11.2)         ,
                         Pct_NHBNW(11.2)        ,
                         Pct_IX(11.2)           ,
                         Pct_XI(11.2)           ,
                         Pct_XX(11.2)           ,
                         Pct_SH_LT(11.2)        ,
                         Pct_SH_MD(11.2)        ,
                         Pct_SH_HV(11.2)        ,
                         Pct_Ext_MD(11.2)       ,
                         Pct_Ext_HV(11.2)       ,
                         Pct_Tel_HBW(11.2)      ,
                         Pct_Tel_NHBW(11.2)     
                
                
                
                ;log converged amount
                LOG VAR=PctMatConv
                
            endif  ;i=ZONES
            
        ENDRUN
        
    endif  ;n=1
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_AV = currenttime()
        SubScriptRunTime_AV = SubScriptEndTime_AV - @SubScriptStartTime_AV@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            Average trip table  ', formatdatetime(SubScriptRunTime_AV, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;CONVERT PA TO OD ======================================================================================================================
    
    ;get start time
    SubScriptStartTime_MX = currenttime()
    
    
    
    RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 7: Convert from PA to OD Matrices'
    
    FILEI ZDATI[1]= '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx'
    
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\am3hr_OD_ByPurp_tmp.mtx',
            mo=100-116, 120-124, 130-133, 141-146,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW ,
                 
                 IX_MD    ,
                 XI_MD    ,
                 XX_MD    ,
                 IX_HV    ,
                 XI_HV    ,
                 XX_HV    
             
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\md6hr_OD_ByPurp_tmp.mtx',
            mo=200-216, 220-224, 230-233, 241-246,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW ,
                 
                 IX_MD    ,
                 XI_MD    ,
                 XX_MD    ,
                 IX_HV    ,
                 XI_HV    ,
                 XX_HV    
             
    FILEO MATO[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pm3hr_OD_ByPurp_tmp.mtx',
            mo=300-316, 320-324, 330-333, 341-346,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW ,
                 
                 IX_MD    ,
                 XI_MD    ,
                 XX_MD    ,
                 IX_HV    ,
                 XI_HV    ,
                 XX_HV    
             
    FILEO MATO[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\ev12hr_OD_ByPurp_tmp.mtx',
            mo=400-416, 420-424, 430-433, 441-446,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW ,
                 
                 IX_MD    ,
                 XI_MD    ,
                 XX_MD    ,
                 IX_HV    ,
                 XI_HV    ,
                 XX_HV    
             
    FILEO MATO[5] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\dy24hr_OD_ByPurp_tmp.mtx',
            mo=500-516, 520-524, 530-533, 541-546,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW ,
                 
                 IX_MD    ,
                 XI_MD    ,
                 XX_MD    ,
                 IX_HV    ,
                 XI_HV    ,
                 XX_HV    
             
    
    FILEO MATO[6] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\OD_4pd_tmp.mtx', 
        mo=500,100,200,300,400,
        name=dy24hr,
             am3hr ,
             md6hr ,
             pm3hr ,
             ev12hr
        
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        
        ;read in calculated diurnal factors from file
        if (i=FIRSTZONE)
            
            ;read in calculate diurnal factors block file
            READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
            
        endif  ;i=FIRSTZONE
        
        
        
        ;read in trip tables ---------------------------------------------------------------------------------
        mw[001] = mi.1.HBW
        mw[002] = mi.1.HBShp
        mw[003] = mi.1.HBOth
        mw[004] = mi.1.HBSch_Pr
        mw[005] = mi.1.HBSch_Sc
        mw[006] = mi.1.HBC
        mw[007] = mi.1.NHBW
        mw[008] = mi.1.NHBNW
        mw[009] = mi.1.IX
        mw[010] = mi.1.XI
        mw[011] = mi.1.XX
        mw[012] = mi.1.SH_LT
        mw[013] = mi.1.SH_MD
        mw[014] = mi.1.SH_HV
        
        mw[023] = mi.1.TTUNIQUE
        
        mw[030] = mi.1.Tot_HBW 
        mw[031] = mi.1.Tel_HBW 
        mw[032] = mi.1.Tot_NHBW
        mw[033] = mi.1.Tel_NHBW
        
        mw[041] = mi.1.IX_MD
        mw[042] = mi.1.XI_MD
        mw[043] = mi.1.XX_MD
        mw[044] = mi.1.IX_HV
        mw[045] = mi.1.XI_HV
        mw[046] = mi.1.XX_HV
        
        
        ;transpose matrices
        mw[051] = mi.1.HBW.T
        mw[052] = mi.1.HBShp.T
        mw[053] = mi.1.HBOth.T
        mw[054] = mi.1.HBSch_Pr.T
        mw[055] = mi.1.HBSch_Sc.T
        mw[056] = mi.1.HBC.T
        mw[057] = mi.1.NHBW.T
        mw[058] = mi.1.NHBNW.T
        mw[059] = mi.1.IX.T
        mw[060] = mi.1.XI.T
        mw[061] = mi.1.XX.T
        mw[062] = mi.1.SH_LT.T
        mw[063] = mi.1.SH_MD.T
        mw[064] = mi.1.SH_HV.T
        mw[065] = mi.1.Ext_MD.T
        mw[066] = mi.1.Ext_HV.T
        
        mw[073] = mi.1.TTUNIQUE.T
        
        mw[080] = mi.1.Tot_HBW.T 
        mw[081] = mi.1.Tel_HBW.T 
        mw[082] = mi.1.Tot_NHBW.T
        mw[083] = mi.1.Tel_NHBW.T
        
        mw[091] = mi.1.IX_MD.T
        mw[092] = mi.1.XI_MD.T
        mw[093] = mi.1.XX_MD.T
        mw[094] = mi.1.IX_HV.T
        mw[095] = mi.1.XI_HV.T
        mw[096] = mi.1.XX_HV.T
        
        
        
        ;convert PA matrices to OD matrices by time period ---------------------------------------------------
        ;loop through columns to identify movement (II, IX, XI or XX)
        JLOOP
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                ;AM
                mw[101]  =  mw[001] * Pct_AM_HBW   * PA_AM_HBW    +  mw[051] * Pct_AM_HBW   * (1 - PA_AM_HBW  )    ;HBW
                mw[102]  =  mw[002] * Pct_AM_HBShp * PA_AM_HBShp  +  mw[052] * Pct_AM_HBShp * (1 - PA_AM_HBShp)    ;HBShp
                mw[103]  =  mw[003] * Pct_AM_HBOth * PA_AM_HBOth  +  mw[053] * Pct_AM_HBOth * (1 - PA_AM_HBOth)    ;HBOth
                mw[104]  =  mw[004] * Pct_AM_HBS   * PA_AM_HBS    +  mw[054] * Pct_AM_HBS   * (1 - PA_AM_HBS  )    ;HBSch_Pr
                mw[105]  =  mw[005] * Pct_AM_HBS   * PA_AM_HBS    +  mw[055] * Pct_AM_HBS   * (1 - PA_AM_HBS  )    ;HBSch_Sc
                mw[106]  =  mw[006] * Pct_AM_HBC   * PA_AM_HBC    +  mw[056] * Pct_AM_HBC   * (1 - PA_AM_HBC  )    ;HBC
                mw[107]  =  mw[007] * Pct_AM_NHBW  * PA_AM_NHBW   +  mw[057] * Pct_AM_NHBW  * (1 - PA_AM_NHBW )    ;NHBW
                mw[108]  =  mw[008] * Pct_AM_NHBNW * PA_AM_NHBNW  +  mw[058] * Pct_AM_NHBNW * (1 - PA_AM_NHBNW)    ;NHBNW
                
                mw[112]  =  mw[012] * Pct_AM_LT    * PA_AM_LT     +  mw[062] * Pct_AM_LT    * (1 - PA_AM_LT   )    ;SH_LT
                mw[113]  =  mw[013] * Pct_AM_MD    * PA_AM_MD     +  mw[063] * Pct_AM_MD    * (1 - PA_AM_MD   )    ;SH_MD
                mw[114]  =  mw[014] * Pct_AM_HV    * PA_AM_HV     +  mw[064] * Pct_AM_HV    * (1 - PA_AM_HV   )    ;SH_HV
                
                mw[115]  =  mw[015] * Pct_AM_MD    * PA_AM_MD     +  mw[065] * Pct_AM_MD    * (1 - PA_AM_MD   )    ;Ext_MD
                mw[116]  =  mw[016] * Pct_AM_HV    * PA_AM_HV     +  mw[066] * Pct_AM_HV    * (1 - PA_AM_HV   )    ;Ext_HV
                
                mw[123]  =  mw[023] * Pct_AM_HBOth * PA_AM_HBOth  +  mw[073] * Pct_AM_HBOth * (1 - PA_AM_HBOth)    ;TTUNIQUE
                
                mw[130]  =  mw[030] * Pct_AM_HBW   * PA_AM_HBW    +  mw[080] * Pct_AM_HBW   * (1 - PA_AM_HBW  )    ;Tot_HBW
                mw[131]  =  mw[031] * Pct_AM_HBW   * PA_AM_HBW    +  mw[081] * Pct_AM_HBW   * (1 - PA_AM_HBW  )    ;Tel_HBW
                mw[132]  =  mw[032] * Pct_AM_NHBW  * PA_AM_NHBW   +  mw[082] * Pct_AM_NHBW  * (1 - PA_AM_NHBW )    ;Tot_NHBW
                mw[133]  =  mw[033] * Pct_AM_NHBW  * PA_AM_NHBW   +  mw[083] * Pct_AM_NHBW  * (1 - PA_AM_NHBW )    ;Tel_NHBW
                
                mw[120]  =  mw[104] + mw[105]                                                                      ;HBSch
                mw[121]  =  mw[102] + mw[103]                                                                      ;HBO
                mw[122]  =  mw[107] + mw[108]                                                                      ;NHB
                mw[124]  =  mw[103] - mw[123]                                                                      ;HBOthnTT
                
                ;MD
                mw[201]  =  mw[001] * Pct_MD_HBW   * PA_MD_HBW    +  mw[051] * Pct_MD_HBW   * (1 - PA_MD_HBW  )    ;HBW
                mw[202]  =  mw[002] * Pct_MD_HBShp * PA_MD_HBShp  +  mw[052] * Pct_MD_HBShp * (1 - PA_MD_HBShp)    ;HBShp
                mw[203]  =  mw[003] * Pct_MD_HBOth * PA_MD_HBOth  +  mw[053] * Pct_MD_HBOth * (1 - PA_MD_HBOth)    ;HBOth
                mw[204]  =  mw[004] * Pct_MD_HBS   * PA_MD_HBS    +  mw[054] * Pct_MD_HBS   * (1 - PA_MD_HBS  )    ;HBSch_Pr
                mw[205]  =  mw[005] * Pct_MD_HBS   * PA_MD_HBS    +  mw[055] * Pct_MD_HBS   * (1 - PA_MD_HBS  )    ;HBSch_Sc
                mw[206]  =  mw[006] * Pct_MD_HBC   * PA_MD_HBC    +  mw[056] * Pct_MD_HBC   * (1 - PA_MD_HBC  )    ;HBC
                mw[207]  =  mw[007] * Pct_MD_NHBW  * PA_MD_NHBW   +  mw[057] * Pct_MD_NHBW  * (1 - PA_MD_NHBW )    ;NHBW
                mw[208]  =  mw[008] * Pct_MD_NHBNW * PA_MD_NHBNW  +  mw[058] * Pct_MD_NHBNW * (1 - PA_MD_NHBNW)    ;NHBNW
                
                mw[212]  =  mw[012] * Pct_MD_LT    * PA_MD_LT     +  mw[062] * Pct_MD_LT    * (1 - PA_MD_LT   )    ;SH_LT
                mw[213]  =  mw[013] * Pct_MD_MD    * PA_MD_MD     +  mw[063] * Pct_MD_MD    * (1 - PA_MD_MD   )    ;SH_MD
                mw[214]  =  mw[014] * Pct_MD_HV    * PA_MD_HV     +  mw[064] * Pct_MD_HV    * (1 - PA_MD_HV   )    ;SH_HV
                
                mw[215]  =  mw[015] * Pct_MD_MD    * PA_MD_MD     +  mw[065] * Pct_MD_MD    * (1 - PA_MD_MD   )    ;Ext_MD
                mw[216]  =  mw[016] * Pct_MD_HV    * PA_MD_HV     +  mw[066] * Pct_MD_HV    * (1 - PA_MD_HV   )    ;Ext_HV
                
                mw[223]  =  mw[023] * Pct_MD_HBOth * PA_MD_HBOth  +  mw[073] * Pct_MD_HBOth * (1 - PA_MD_HBOth)    ;TTUNIQUE
                
                mw[230]  =  mw[030] * Pct_MD_HBW   * PA_MD_HBW    +  mw[080] * Pct_MD_HBW   * (1 - PA_MD_HBW  )    ;Tot_HBW
                mw[231]  =  mw[031] * Pct_MD_HBW   * PA_MD_HBW    +  mw[081] * Pct_MD_HBW   * (1 - PA_MD_HBW  )    ;Tel_HBW
                mw[232]  =  mw[032] * Pct_MD_NHBW  * PA_MD_NHBW   +  mw[082] * Pct_MD_NHBW  * (1 - PA_MD_NHBW )    ;Tot_NHBW
                mw[233]  =  mw[033] * Pct_MD_NHBW  * PA_MD_NHBW   +  mw[083] * Pct_MD_NHBW  * (1 - PA_MD_NHBW )    ;Tel_NHBW
                
                mw[220]  =  mw[204] + mw[205]                                                                      ;HBSch
                mw[221]  =  mw[202] + mw[203]                                                                      ;HBO
                mw[222]  =  mw[207] + mw[208]                                                                      ;NHB
                mw[224]  =  mw[203] - mw[223]                                                                      ;HBOthnTT
                
                ;PM
                mw[301]  =  mw[001] * Pct_PM_HBW   * PA_PM_HBW    +  mw[051] * Pct_PM_HBW   * (1 - PA_PM_HBW  )    ;HBW
                mw[302]  =  mw[002] * Pct_PM_HBShp * PA_PM_HBShp  +  mw[052] * Pct_PM_HBShp * (1 - PA_PM_HBShp)    ;HBShp
                mw[303]  =  mw[003] * Pct_PM_HBOth * PA_PM_HBOth  +  mw[053] * Pct_PM_HBOth * (1 - PA_PM_HBOth)    ;HBOth
                mw[304]  =  mw[004] * Pct_PM_HBS   * PA_PM_HBS    +  mw[054] * Pct_PM_HBS   * (1 - PA_PM_HBS  )    ;HBSch_Pr
                mw[305]  =  mw[005] * Pct_PM_HBS   * PA_PM_HBS    +  mw[055] * Pct_PM_HBS   * (1 - PA_PM_HBS  )    ;HBSch_Sc
                mw[306]  =  mw[006] * Pct_PM_HBC   * PA_PM_HBC    +  mw[056] * Pct_PM_HBC   * (1 - PA_PM_HBC  )    ;HBC
                mw[307]  =  mw[007] * Pct_PM_NHBW  * PA_PM_NHBW   +  mw[057] * Pct_PM_NHBW  * (1 - PA_PM_NHBW )    ;NHBW
                mw[308]  =  mw[008] * Pct_PM_NHBNW * PA_PM_NHBNW  +  mw[058] * Pct_PM_NHBNW * (1 - PA_PM_NHBNW)    ;NHBNW
                
                mw[312]  =  mw[012] * Pct_PM_LT    * PA_PM_LT     +  mw[062] * Pct_PM_LT    * (1 - PA_PM_LT   )    ;SH_LT
                mw[313]  =  mw[013] * Pct_PM_MD    * PA_PM_MD     +  mw[063] * Pct_PM_MD    * (1 - PA_PM_MD   )    ;SH_MD
                mw[314]  =  mw[014] * Pct_PM_HV    * PA_PM_HV     +  mw[064] * Pct_PM_HV    * (1 - PA_PM_HV   )    ;SH_HV
                
                mw[315]  =  mw[015] * Pct_PM_MD    * PA_PM_MD     +  mw[065] * Pct_PM_MD    * (1 - PA_PM_MD   )    ;Ext_MD
                mw[316]  =  mw[016] * Pct_PM_HV    * PA_PM_HV     +  mw[066] * Pct_PM_HV    * (1 - PA_PM_HV   )    ;Ext_HV
                
                mw[323]  =  mw[023] * Pct_PM_HBOth * PA_PM_HBOth  +  mw[073] * Pct_PM_HBOth * (1 - PA_PM_HBOth)    ;TTUNIQUE
                
                mw[330]  =  mw[030] * Pct_PM_HBW   * PA_PM_HBW    +  mw[080] * Pct_PM_HBW   * (1 - PA_PM_HBW  )    ;Tot_HBW
                mw[331]  =  mw[031] * Pct_PM_HBW   * PA_PM_HBW    +  mw[081] * Pct_PM_HBW   * (1 - PA_PM_HBW  )    ;Tel_HBW
                mw[332]  =  mw[032] * Pct_PM_NHBW  * PA_PM_NHBW   +  mw[082] * Pct_PM_NHBW  * (1 - PA_PM_NHBW )    ;Tot_NHBW
                mw[333]  =  mw[033] * Pct_PM_NHBW  * PA_PM_NHBW   +  mw[083] * Pct_PM_NHBW  * (1 - PA_PM_NHBW )    ;Tel_NHBW
                
                mw[320]  =  mw[304] + mw[305]                                                                      ;HBSch
                mw[321]  =  mw[302] + mw[303]                                                                      ;HBO
                mw[322]  =  mw[307] + mw[308]                                                                      ;NHB
                mw[324]  =  mw[303] - mw[323]                                                                      ;HBOthnTT
                
                ;EV
                mw[401]  =  mw[001] * Pct_EV_HBW   * PA_EV_HBW    +  mw[051] * Pct_EV_HBW   * (1 - PA_EV_HBW  )    ;HBW
                mw[402]  =  mw[002] * Pct_EV_HBShp * PA_EV_HBShp  +  mw[052] * Pct_EV_HBShp * (1 - PA_EV_HBShp)    ;HBShp
                mw[403]  =  mw[003] * Pct_EV_HBOth * PA_EV_HBOth  +  mw[053] * Pct_EV_HBOth * (1 - PA_EV_HBOth)    ;HBOth
                mw[404]  =  mw[004] * Pct_EV_HBS   * PA_EV_HBS    +  mw[054] * Pct_EV_HBS   * (1 - PA_EV_HBS  )    ;HBSch_Pr
                mw[405]  =  mw[005] * Pct_EV_HBS   * PA_EV_HBS    +  mw[055] * Pct_EV_HBS   * (1 - PA_EV_HBS  )    ;HBSch_Sc
                mw[406]  =  mw[006] * Pct_EV_HBC   * PA_EV_HBC    +  mw[056] * Pct_EV_HBC   * (1 - PA_EV_HBC  )    ;HBC
                mw[407]  =  mw[007] * Pct_EV_NHBW  * PA_EV_NHBW   +  mw[057] * Pct_EV_NHBW  * (1 - PA_EV_NHBW )    ;NHBW
                mw[408]  =  mw[008] * Pct_EV_NHBNW * PA_EV_NHBNW  +  mw[058] * Pct_EV_NHBNW * (1 - PA_EV_NHBNW)    ;NHBNW
                
                mw[412]  =  mw[012] * Pct_EV_LT    * PA_EV_LT     +  mw[062] * Pct_EV_LT    * (1 - PA_EV_LT   )    ;SH_LT
                mw[413]  =  mw[013] * Pct_EV_MD    * PA_EV_MD     +  mw[063] * Pct_EV_MD    * (1 - PA_EV_MD   )    ;SH_MD
                mw[414]  =  mw[014] * Pct_EV_HV    * PA_EV_HV     +  mw[064] * Pct_EV_HV    * (1 - PA_EV_HV   )    ;SH_HV
                
                mw[415]  =  mw[015] * Pct_EV_MD    * PA_EV_MD     +  mw[065] * Pct_EV_MD    * (1 - PA_EV_MD   )    ;Ext_MD
                mw[416]  =  mw[016] * Pct_EV_HV    * PA_EV_HV     +  mw[066] * Pct_EV_HV    * (1 - PA_EV_HV   )    ;Ext_HV
                
                mw[423]  =  mw[023] * Pct_EV_HBOth * PA_EV_HBOth  +  mw[073] * Pct_EV_HBOth * (1 - PA_EV_HBOth)    ;TTUNIQUE
                
                mw[430]  =  mw[030] * Pct_EV_HBW   * PA_EV_HBW    +  mw[080] * Pct_EV_HBW   * (1 - PA_EV_HBW  )    ;Tot_HBW
                mw[431]  =  mw[031] * Pct_EV_HBW   * PA_EV_HBW    +  mw[081] * Pct_EV_HBW   * (1 - PA_EV_HBW  )    ;Tel_HBW
                mw[432]  =  mw[032] * Pct_EV_NHBW  * PA_EV_NHBW   +  mw[082] * Pct_EV_NHBW  * (1 - PA_EV_NHBW )    ;Tot_NHBW
                mw[433]  =  mw[033] * Pct_EV_NHBW  * PA_EV_NHBW   +  mw[083] * Pct_EV_NHBW  * (1 - PA_EV_NHBW )    ;Tel_NHBW
                
                mw[420]  =  mw[404] + mw[405]                                                                      ;HBSch
                mw[421]  =  mw[402] + mw[403]                                                                      ;HBO
                mw[422]  =  mw[407] + mw[408]                                                                      ;NHB
                mw[424]  =  mw[403] - mw[423]                                                                      ;HBOthnTT
                
                
            ;IX, XI & XX
            else
                
                ;AM
                mw[109]  =  mw[009] * Pct_AM_IX    * PA_AM_IX     +  mw[059] * Pct_AM_IX    * (1 - PA_AM_IX   )    ;IX
                mw[110]  =  mw[010] * Pct_AM_XI    * PA_AM_XI     +  mw[060] * Pct_AM_XI    * (1 - PA_AM_XI   )    ;XI
                mw[111]  =  mw[011] * Pct_AM_XX    * PA_AM_XX     +  mw[061] * Pct_AM_XX    * (1 - PA_AM_XX   )    ;XX
                
                mw[141]  =  mw[041] * Pct_AM_IX_MD * PA_AM_IX_MD  +  mw[091] * Pct_AM_IX_MD * (1 - PA_AM_IX_MD)    ;IX_MD
                mw[142]  =  mw[042] * Pct_AM_XI_MD * PA_AM_XI_MD  +  mw[092] * Pct_AM_XI_MD * (1 - PA_AM_XI_MD)    ;XI_MD
                mw[143]  =  mw[043] * Pct_AM_XX_MD * PA_AM_XX_MD  +  mw[093] * Pct_AM_XX_MD * (1 - PA_AM_XX_MD)    ;XX_MD
                
                mw[144]  =  mw[044] * Pct_AM_IX_HV * PA_AM_IX_HV  +  mw[094] * Pct_AM_IX_HV * (1 - PA_AM_IX_HV)    ;IX_HV
                mw[145]  =  mw[045] * Pct_AM_XI_HV * PA_AM_XI_HV  +  mw[095] * Pct_AM_XI_HV * (1 - PA_AM_XI_HV)    ;XI_HV
                mw[146]  =  mw[046] * Pct_AM_XX_HV * PA_AM_XX_HV  +  mw[096] * Pct_AM_XX_HV * (1 - PA_AM_XX_HV)    ;XX_HV
                
                
                mw[115]  =  mw[141] +    ;Ext_MD
                            mw[142] +
                            mw[143] 
                
                mw[116]  =  mw[144] +    ;Ext_HV
                            mw[145] +
                            mw[146] 
                
                ;MD
                mw[209]  =  mw[009] * Pct_MD_IX    * PA_MD_IX     +  mw[059] * Pct_MD_IX    * (1 - PA_MD_IX   )    ;IX
                mw[210]  =  mw[010] * Pct_MD_XI    * PA_MD_XI     +  mw[060] * Pct_MD_XI    * (1 - PA_MD_XI   )    ;XI
                mw[211]  =  mw[011] * Pct_MD_XX    * PA_MD_XX     +  mw[061] * Pct_MD_XX    * (1 - PA_MD_XX   )    ;XX
                
                mw[241]  =  mw[041] * Pct_MD_IX_MD * PA_MD_IX_MD  +  mw[091] * Pct_MD_IX_MD * (1 - PA_MD_IX_MD)    ;IX_MD
                mw[242]  =  mw[042] * Pct_MD_XI_MD * PA_MD_XI_MD  +  mw[092] * Pct_MD_XI_MD * (1 - PA_MD_XI_MD)    ;XI_MD
                mw[243]  =  mw[043] * Pct_MD_XX_MD * PA_MD_XX_MD  +  mw[093] * Pct_MD_XX_MD * (1 - PA_MD_XX_MD)    ;XX_MD
                
                mw[244]  =  mw[044] * Pct_MD_IX_HV * PA_MD_IX_HV  +  mw[094] * Pct_MD_IX_HV * (1 - PA_MD_IX_HV)    ;IX_HV
                mw[245]  =  mw[045] * Pct_MD_XI_HV * PA_MD_XI_HV  +  mw[095] * Pct_MD_XI_HV * (1 - PA_MD_XI_HV)    ;XI_HV
                mw[246]  =  mw[046] * Pct_MD_XX_HV * PA_MD_XX_HV  +  mw[096] * Pct_MD_XX_HV * (1 - PA_MD_XX_HV)    ;XX_HV
                
                
                mw[215]  =  mw[241] +    ;Ext_MD
                            mw[242] +
                            mw[243] 
                
                mw[216]  =  mw[244] +    ;Ext_HV
                            mw[245] +
                            mw[246] 
                
                ;PM
                mw[309]  =  mw[009] * Pct_PM_IX    * PA_PM_IX     +  mw[059] * Pct_PM_IX    * (1 - PA_PM_IX   )    ;IX
                mw[310]  =  mw[010] * Pct_PM_XI    * PA_PM_XI     +  mw[060] * Pct_PM_XI    * (1 - PA_PM_XI   )    ;XI
                mw[311]  =  mw[011] * Pct_PM_XX    * PA_PM_XX     +  mw[061] * Pct_PM_XX    * (1 - PA_PM_XX   )    ;XX
                
                mw[341]  =  mw[041] * Pct_PM_IX_MD * PA_PM_IX_MD  +  mw[091] * Pct_PM_IX_MD * (1 - PA_PM_IX_MD)    ;IX_MD
                mw[342]  =  mw[042] * Pct_PM_XI_MD * PA_PM_XI_MD  +  mw[092] * Pct_PM_XI_MD * (1 - PA_PM_XI_MD)    ;XI_MD
                mw[343]  =  mw[043] * Pct_PM_XX_MD * PA_PM_XX_MD  +  mw[093] * Pct_PM_XX_MD * (1 - PA_PM_XX_MD)    ;XX_MD
                
                mw[344]  =  mw[044] * Pct_PM_IX_HV * PA_PM_IX_HV  +  mw[094] * Pct_PM_IX_HV * (1 - PA_PM_IX_HV)    ;IX_HV
                mw[345]  =  mw[045] * Pct_PM_XI_HV * PA_PM_XI_HV  +  mw[095] * Pct_PM_XI_HV * (1 - PA_PM_XI_HV)    ;XI_HV
                mw[346]  =  mw[046] * Pct_PM_XX_HV * PA_PM_XX_HV  +  mw[096] * Pct_PM_XX_HV * (1 - PA_PM_XX_HV)    ;XX_HV
                
                
                mw[315]  =  mw[341] +    ;Ext_MD
                            mw[342] +
                            mw[343] 
                
                mw[316]  =  mw[344] +    ;Ext_HV
                            mw[345] +
                            mw[346] 
                
                ;EV
                mw[409]  =  mw[009] * Pct_EV_IX    * PA_EV_IX     +  mw[059] * Pct_EV_IX    * (1 - PA_EV_IX   )    ;IX
                mw[410]  =  mw[010] * Pct_EV_XI    * PA_EV_XI     +  mw[060] * Pct_EV_XI    * (1 - PA_EV_XI   )    ;XI
                mw[411]  =  mw[011] * Pct_EV_XX    * PA_EV_XX     +  mw[061] * Pct_EV_XX    * (1 - PA_EV_XX   )    ;XX
                
                mw[441]  =  mw[041] * Pct_EV_IX_MD * PA_EV_IX_MD  +  mw[091] * Pct_EV_IX_MD * (1 - PA_EV_IX_MD)    ;IX_MD
                mw[442]  =  mw[042] * Pct_EV_XI_MD * PA_EV_XI_MD  +  mw[092] * Pct_EV_XI_MD * (1 - PA_EV_XI_MD)    ;XI_MD
                mw[443]  =  mw[043] * Pct_EV_XX_MD * PA_EV_XX_MD  +  mw[093] * Pct_EV_XX_MD * (1 - PA_EV_XX_MD)    ;XX_MD
                
                mw[444]  =  mw[044] * Pct_EV_IX_HV * PA_EV_IX_HV  +  mw[094] * Pct_EV_IX_HV * (1 - PA_EV_IX_HV)    ;IX_HV
                mw[445]  =  mw[045] * Pct_EV_XI_HV * PA_EV_XI_HV  +  mw[095] * Pct_EV_XI_HV * (1 - PA_EV_XI_HV)    ;XI_HV
                mw[446]  =  mw[046] * Pct_EV_XX_HV * PA_EV_XX_HV  +  mw[096] * Pct_EV_XX_HV * (1 - PA_EV_XX_HV)    ;XX_HV
                
                
                mw[415]  =  mw[441] +    ;Ext_MD
                            mw[442] +
                            mw[443] 
                
                mw[416]  =  mw[444] +    ;Ext_HV
                            mw[445] +
                            mw[446] 
                
            endif  ;by movement
            
        ENDJLOOP
        
        
        ;DY
        mw[501]  =  mw[101] + mw[201] + mw[301] + mw[401]                       ;HBW
        mw[502]  =  mw[102] + mw[202] + mw[302] + mw[402]                       ;HBShp
        mw[503]  =  mw[103] + mw[203] + mw[303] + mw[403]                       ;HBOth
        mw[504]  =  mw[104] + mw[204] + mw[304] + mw[404]                       ;HBSch_Pr
        mw[505]  =  mw[105] + mw[205] + mw[305] + mw[405]                       ;HBSch_Sc
        mw[506]  =  mw[106] + mw[206] + mw[306] + mw[406]                       ;HBC
        mw[507]  =  mw[107] + mw[207] + mw[307] + mw[407]                       ;NHBW
        mw[508]  =  mw[108] + mw[208] + mw[308] + mw[408]                       ;NHBNW
        mw[509]  =  mw[109] + mw[209] + mw[309] + mw[409]                       ;IX
        mw[510]  =  mw[110] + mw[210] + mw[310] + mw[410]                       ;XI
        mw[511]  =  mw[111] + mw[211] + mw[311] + mw[411]                       ;XX
        mw[512]  =  mw[112] + mw[212] + mw[312] + mw[412]                       ;SH_LT
        mw[513]  =  mw[113] + mw[213] + mw[313] + mw[413]                       ;SH_MD
        mw[514]  =  mw[114] + mw[214] + mw[314] + mw[414]                       ;SH_HV
        mw[515]  =  mw[115] + mw[215] + mw[315] + mw[415]                       ;Ext_MD
        mw[516]  =  mw[116] + mw[216] + mw[316] + mw[416]                       ;Ext_HV
        
        mw[520]  =  mw[120] + mw[220] + mw[320] + mw[420]                       ;HBSch
        mw[521]  =  mw[121] + mw[221] + mw[321] + mw[421]                       ;HBO
        mw[522]  =  mw[122] + mw[222] + mw[322] + mw[422]                       ;NHB
        mw[523]  =  mw[123] + mw[223] + mw[323] + mw[423]                       ;TTUNIQUE
        mw[524]  =  mw[124] + mw[224] + mw[324] + mw[424]                       ;HBOthnTT
        
        mw[530]  =  mw[130] + mw[230] + mw[330] + mw[430]                       ;Tot_HBW
        mw[531]  =  mw[131] + mw[231] + mw[331] + mw[431]                       ;Tel_HBW
        mw[532]  =  mw[132] + mw[232] + mw[332] + mw[432]                       ;Tot_NHBW
        mw[533]  =  mw[133] + mw[233] + mw[333] + mw[433]                       ;Tel_NHBW
        
        mw[541]  =  mw[141] + mw[241] + mw[341] + mw[441]                       ;IX_MD
        mw[542]  =  mw[142] + mw[242] + mw[342] + mw[442]                       ;XI_MD
        mw[543]  =  mw[143] + mw[243] + mw[343] + mw[443]                       ;XX_MD
        mw[544]  =  mw[144] + mw[244] + mw[344] + mw[444]                       ;IX_HV
        mw[545]  =  mw[145] + mw[245] + mw[345] + mw[445]                       ;XI_HV
        mw[546]  =  mw[146] + mw[246] + mw[346] + mw[446]                       ;XX_HV
        
        
        ;calculate totals
        ;AM
        mw[100] = mw[101] +     ;HBW     
                  mw[102] +     ;HBShp   
                  mw[103] +     ;HBOth   
                  mw[104] +     ;HBSch_Pr
                  mw[105] +     ;HBSch_Sc
                  mw[106] +     ;HBC     
                  mw[107] +     ;NHBW    
                  mw[108] +     ;NHBNW   
                  mw[109] +     ;IX    
                  mw[110] +     ;XI    
                  mw[111] +     ;XX    
                  mw[112] +     ;SH_LT 
                  mw[113] +     ;SH_MD 
                  mw[114] +     ;SH_HV 
                  mw[115] +     ;Ext_MD
                  mw[116]       ;Ext_HV
        
        ;MD
        mw[200] = mw[201] +     ;HBW     
                  mw[202] +     ;HBShp   
                  mw[203] +     ;HBOth   
                  mw[204] +     ;HBSch_Pr
                  mw[205] +     ;HBSch_Sc
                  mw[206] +     ;HBC     
                  mw[207] +     ;NHBW    
                  mw[208] +     ;NHBNW   
                  mw[209] +     ;IX    
                  mw[210] +     ;XI    
                  mw[211] +     ;XX    
                  mw[212] +     ;SH_LT 
                  mw[213] +     ;SH_MD 
                  mw[214] +     ;SH_HV 
                  mw[215] +     ;Ext_MD
                  mw[216]       ;Ext_HV
        
        ;PM
        mw[300] = mw[301] +     ;HBW     
                  mw[302] +     ;HBShp   
                  mw[303] +     ;HBOth   
                  mw[304] +     ;HBSch_Pr
                  mw[305] +     ;HBSch_Sc
                  mw[306] +     ;HBC     
                  mw[307] +     ;NHBW    
                  mw[308] +     ;NHBNW   
                  mw[309] +     ;IX    
                  mw[310] +     ;XI    
                  mw[311] +     ;XX    
                  mw[312] +     ;SH_LT 
                  mw[313] +     ;SH_MD 
                  mw[314] +     ;SH_HV 
                  mw[315] +     ;Ext_MD
                  mw[316]       ;Ext_HV
        
        ;EV
        mw[400] = mw[401] +     ;HBW     
                  mw[402] +     ;HBShp   
                  mw[403] +     ;HBOth   
                  mw[404] +     ;HBSch_Pr
                  mw[405] +     ;HBSch_Sc
                  mw[406] +     ;HBC     
                  mw[407] +     ;NHBW    
                  mw[408] +     ;NHBNW   
                  mw[409] +     ;IX    
                  mw[410] +     ;XI    
                  mw[411] +     ;XX    
                  mw[412] +     ;SH_LT 
                  mw[413] +     ;SH_MD 
                  mw[414] +     ;SH_HV 
                  mw[415] +     ;Ext_MD
                  mw[416]       ;Ext_HV
        
        ;DY
        mw[500] = mw[100] + 
                  mw[200] + 
                  mw[300] + 
                  mw[400] 
    
    ENDRUN
    
    
    
    RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 8: Finsih Preparing Trip Tables for Highway Assignment'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\am3hr_OD_ByPurp_tmp.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\md6hr_OD_ByPurp_tmp.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pm3hr_OD_ByPurp_tmp.mtx'
        FILEI MATI[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\ev12hr_OD_ByPurp_tmp.mtx'
        
        FILEI MATI[5] = '@ParentDir@@ScenarioDir@3_Distribute\skm_AM.mtx'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\am3hr_ODveh_ByPurp_tmp.mtx',
            mo=100-116, 120-124, 130-133,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW 
                 
        FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\md6hr_ODveh_ByPurp_tmp.mtx',
            mo=200-216, 220-224, 230-233,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW 
                 
        FILEO MATO[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pm3hr_ODveh_ByPurp_tmp.mtx',
            mo=300-316, 320-324, 330-333,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW 
                 
        FILEO MATO[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\ev12hr_ODveh_ByPurp_tmp.mtx',
            mo=400-416, 420-424, 430-433,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW 
                 
        FILEO MATO[5] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\dy24hr_ODveh_ByPurp_tmp.mtx',
            mo=500-516, 520-524, 530-533,
            name=TOT      ,
                 HBW      ,
                 HBShp    ,
                 HBOth    ,
                 HBSch_Pr ,
                 HBSch_Sc ,
                 HBC      ,
                 NHBW     ,
                 NHBNW    ,
                 IX       ,
                 XI       ,
                 XX       ,
                 SH_LT    ,
                 SH_MD    ,
                 SH_HV    ,
                 Ext_MD   ,
                 Ext_HV   ,
                 
                 HBSch    ,
                 HBO      ,
                 NHB      ,
                 TTUNIQUE ,
                 HBOthnTT ,
                 
                 Tot_HBW  ,
                 Tel_HBW  ,
                 Tot_NHBW ,
                 Tel_NHBW 
                 
        
        FILEO MATO[6] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\ODveh_4pd_tmp.mtx', 
            mo=500,100,200,300,400,
            name=dy24hr,
                 am3hr ,
                 md6hr ,
                 pm3hr ,
                 ev12hr
        
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        
        ;calculate factors to reduce trip tables for non-motorized & transit ---------------------------------
        ;pre-mode choice trip table reduction factors (from 2012 HH Survey)
        NM_0_1_mi_HBW   = 0.314
        NM_0_1_mi_HBShp = 0.179
        NM_0_1_mi_HBOth = 0.354
        NM_0_1_mi_HBSch = 0.221
        NM_0_1_mi_HBC   = 0.470
        NM_0_1_mi_NHBW  = 0.338
        NM_0_1_mi_NHBNW = 0.164
        
        NM_1_4_mi_HBW   = 0.074
        NM_1_4_mi_HBShp = 0.021
        NM_1_4_mi_HBOth = 0.060
        NM_1_4_mi_HBSch = 0.021
        NM_1_4_mi_HBC   = 0.283
        NM_1_4_mi_NHBW  = 0.050
        NM_1_4_mi_NHBNW = 0.024
        
        Transit_HBW     = 0.043
        Transit_HBShp   = 0.009
        Transit_HBOth   = 0.007
        Transit_HBSch   = 0.006
        Transit_HBC     = 0.142
        Transit_NHBW    = 0.020
        Transit_NHBNW   = 0.014
        
        
        
        ;calculate reduction factors for each ij pair based on ij distance
        JLOOP
            ;look up work/personal trip distance from skim
            dist_wrk = mi.5.distance_Auto_Wrk[j]
            dist_per = mi.5.distance_Auto_Per[j]
            
            
            ;short trips (<1 mile) have highest share of non-motorized trips
            if (dist_wrk<1)
                
                mw[901] = (1 - NM_0_1_mi_HBW  ) * (1 - Transit_HBW  )     ;HBW     
                mw[902] = (1 - NM_0_1_mi_HBShp) * (1 - Transit_HBShp)     ;HBShp   
                mw[903] = (1 - NM_0_1_mi_HBOth) * (1 - Transit_HBOth)     ;HBOth   
                mw[904] = (1 - NM_0_1_mi_HBSch) * (1 - Transit_HBSch)     ;HBSch_Pr
                mw[905] = (1 - NM_0_1_mi_HBSch) * (1 - Transit_HBSch)     ;HBSch_Sc
                mw[906] = (1 - NM_0_1_mi_HBC  ) * (1 - Transit_HBC  )     ;HBC     
                mw[907] = (1 - NM_0_1_mi_NHBW ) * (1 - Transit_NHBW )     ;NHBW    
                mw[908] = (1 - NM_0_1_mi_NHBNW) * (1 - Transit_NHBNW)     ;NHBNW   
                
            ;relatively short trips (1 to 4 miles) have lower share of non-motorized trips
            elseif (dist_wrk<5 & dist_wrk>=1)
                
                mw[901] = (1 - NM_1_4_mi_HBW  ) * (1 - Transit_HBW  )     ;HBW     
                mw[902] = (1 - NM_1_4_mi_HBShp) * (1 - Transit_HBShp)     ;HBShp   
                mw[903] = (1 - NM_1_4_mi_HBOth) * (1 - Transit_HBOth)     ;HBOth   
                mw[904] = (1 - NM_1_4_mi_HBSch) * (1 - Transit_HBSch)     ;HBSch_Pr
                mw[905] = (1 - NM_1_4_mi_HBSch) * (1 - Transit_HBSch)     ;HBSch_Sc
                mw[906] = (1 - NM_1_4_mi_HBC  ) * (1 - Transit_HBC  )     ;HBC     
                mw[907] = (1 - NM_1_4_mi_NHBW ) * (1 - Transit_NHBW )     ;NHBW    
                mw[908] = (1 - NM_1_4_mi_NHBNW) * (1 - Transit_NHBNW)     ;NHBNW   
                
            ;no non-motorized trip reduction for trips >=5 mile
            elseif (dist_wrk>=5)
                
                mw[901] = (1 - Transit_HBW  )                             ;HBW     
                mw[902] = (1 - Transit_HBShp)                             ;HBShp   
                mw[903] = (1 - Transit_HBOth)                             ;HBOth   
                mw[904] = (1 - Transit_HBSch)                             ;HBSch_Pr
                mw[905] = (1 - Transit_HBSch)                             ;HBSch_Sc
                mw[906] = (1 - Transit_HBC  )                             ;HBC     
                mw[907] = (1 - Transit_NHBW )                             ;NHBW    
                mw[908] = (1 - Transit_NHBNW)                             ;NHBNW    
                
            endif  ;dist_wrk<1; dist_wrk<5 & dist_wrk>=1; dist_wrk>=5
            
        ENDJLOOP
        
        
        
        ;read in trip tables, convert from person to vehicle trips, & ----------------------------------------
        ; skim off NM & transit trips
        ;AM
        mw[101] = (mi.1.HBW      / @VehOcc_HBW@  ) * mw[901]
        mw[102] = (mi.1.HBShp    / @VehOcc_HBShp@) * mw[902]
        mw[103] = (mi.1.HBOth    / @VehOcc_HBOth@) * mw[903]
        mw[104] = (mi.1.HBSch_Pr / @VehOcc_HBSch@) * mw[904]
        mw[105] = (mi.1.HBSch_Sc / @VehOcc_HBSch@) * mw[905]
        mw[106] = (mi.1.HBC      / @VehOcc_HBC@  ) * mw[906]
        mw[107] = (mi.1.NHBW     / @VehOcc_NHBW@ ) * mw[907]
        mw[108] = (mi.1.NHBNW    / @VehOcc_NHBNW@) * mw[908]

        mw[109] = mi.1.IX
        mw[110] = mi.1.XI
        mw[111] = mi.1.XX
        mw[112] = mi.1.SH_LT
        mw[113] = mi.1.SH_MD
        mw[114] = mi.1.SH_HV
        mw[115] = mi.1.Ext_MD
        mw[116] = mi.1.Ext_HV
        
        mw[120] = (mi.1.HBSch    / @VehOcc_HBSch@) * mw[904]
        mw[121] = (mi.1.HBO      / @VehOcc_HBO@)   * mw[903]
        mw[122] = (mi.1.NHB      / @VehOcc_NHB@)   * mw[908]
        mw[123] = (mi.1.TTUNIQUE / @VehOcc_HBOth@) * mw[903]
        mw[124] = (mi.1.HBOthnTT / @VehOcc_HBOth@) * mw[903]
        
        mw[130] = (mi.1.Tot_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[131] = (mi.1.Tel_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[132] = (mi.1.Tot_NHBW / @VehOcc_NHBW@ ) * mw[907]
        mw[133] = (mi.1.Tel_NHBW / @VehOcc_NHBW@ ) * mw[907]
        
        
        ;MD
        mw[201] = (mi.2.HBW      / @VehOcc_HBW@  ) * mw[901]
        mw[202] = (mi.2.HBShp    / @VehOcc_HBShp@) * mw[902]
        mw[203] = (mi.2.HBOth    / @VehOcc_HBOth@) * mw[903]
        mw[204] = (mi.2.HBSch_Pr / @VehOcc_HBSch@) * mw[904]
        mw[205] = (mi.2.HBSch_Sc / @VehOcc_HBSch@) * mw[905]
        mw[206] = (mi.2.HBC      / @VehOcc_HBC@  ) * mw[906]
        mw[207] = (mi.2.NHBW     / @VehOcc_NHBW@ ) * mw[907]
        mw[208] = (mi.2.NHBNW    / @VehOcc_NHBNW@) * mw[908]
        
        mw[209] = mi.2.IX
        mw[210] = mi.2.XI
        mw[211] = mi.2.XX
        mw[212] = mi.2.SH_LT
        mw[213] = mi.2.SH_MD
        mw[214] = mi.2.SH_HV
        mw[215] = mi.2.Ext_MD
        mw[216] = mi.2.Ext_HV
        
        mw[220] = (mi.2.HBSch    / @VehOcc_HBSch@) * mw[904]
        mw[221] = (mi.2.HBO      / @VehOcc_HBO@)   * mw[903]
        mw[222] = (mi.2.NHB      / @VehOcc_NHB@)   * mw[908]
        mw[223] = (mi.2.TTUNIQUE / @VehOcc_HBOth@) * mw[903]
        mw[224] = (mi.2.HBOthnTT / @VehOcc_HBOth@) * mw[903]
        
        mw[230] = (mi.2.Tot_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[231] = (mi.2.Tel_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[232] = (mi.2.Tot_NHBW / @VehOcc_NHBW@ ) * mw[907]
        mw[233] = (mi.2.Tel_NHBW / @VehOcc_NHBW@ ) * mw[907]
        
        
        ;PM
        mw[301] = (mi.3.HBW      / @VehOcc_HBW@  ) * mw[901]
        mw[302] = (mi.3.HBShp    / @VehOcc_HBShp@) * mw[902]
        mw[303] = (mi.3.HBOth    / @VehOcc_HBOth@) * mw[903]
        mw[304] = (mi.3.HBSch_Pr / @VehOcc_HBSch@) * mw[904]
        mw[305] = (mi.3.HBSch_Sc / @VehOcc_HBSch@) * mw[905]
        mw[306] = (mi.3.HBC      / @VehOcc_HBC@  ) * mw[906]
        mw[307] = (mi.3.NHBW     / @VehOcc_NHBW@ ) * mw[907]
        mw[308] = (mi.3.NHBNW    / @VehOcc_NHBNW@) * mw[908]
        
        mw[309] = mi.3.IX
        mw[310] = mi.3.XI
        mw[311] = mi.3.XX
        mw[312] = mi.3.SH_LT
        mw[313] = mi.3.SH_MD
        mw[314] = mi.3.SH_HV
        mw[315] = mi.3.Ext_MD
        mw[316] = mi.3.Ext_HV
        
        mw[320] = (mi.3.HBSch    / @VehOcc_HBSch@) * mw[904]
        mw[321] = (mi.3.HBO      / @VehOcc_HBO@)   * mw[903]
        mw[322] = (mi.3.NHB      / @VehOcc_NHB@)   * mw[908]
        mw[323] = (mi.3.TTUNIQUE / @VehOcc_HBOth@) * mw[903]
        mw[324] = (mi.3.HBOthnTT / @VehOcc_HBOth@) * mw[903]
        
        mw[330] = (mi.3.Tot_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[331] = (mi.3.Tel_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[332] = (mi.3.Tot_NHBW / @VehOcc_NHBW@ ) * mw[907]
        mw[333] = (mi.3.Tel_NHBW / @VehOcc_NHBW@ ) * mw[907]
        
        
        ;EV
        mw[401] = (mi.4.HBW      / @VehOcc_HBW@  ) * mw[901]
        mw[402] = (mi.4.HBShp    / @VehOcc_HBShp@) * mw[902]
        mw[403] = (mi.4.HBOth    / @VehOcc_HBOth@) * mw[903]
        mw[404] = (mi.4.HBSch_Pr / @VehOcc_HBSch@) * mw[904]
        mw[405] = (mi.4.HBSch_Sc / @VehOcc_HBSch@) * mw[905]
        mw[406] = (mi.4.HBC      / @VehOcc_HBC@  ) * mw[906]
        mw[407] = (mi.4.NHBW     / @VehOcc_NHBW@ ) * mw[907]
        mw[408] = (mi.4.NHBNW    / @VehOcc_NHBNW@) * mw[908]
        
        mw[409] = mi.4.IX
        mw[410] = mi.4.XI
        mw[411] = mi.4.XX
        mw[412] = mi.4.SH_LT
        mw[413] = mi.4.SH_MD
        mw[414] = mi.4.SH_HV
        mw[415] = mi.4.Ext_MD
        mw[416] = mi.4.Ext_HV
        
        mw[420] = (mi.4.HBSch    / @VehOcc_HBSch@) * mw[904]
        mw[421] = (mi.4.HBO      / @VehOcc_HBO@)   * mw[903]
        mw[422] = (mi.4.NHB      / @VehOcc_NHB@)   * mw[908]
        mw[423] = (mi.4.TTUNIQUE / @VehOcc_HBOth@) * mw[903]
        mw[424] = (mi.4.HBOthnTT / @VehOcc_HBOth@) * mw[903]
        
        mw[430] = (mi.4.Tot_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[431] = (mi.4.Tel_HBW  / @VehOcc_HBW@  ) * mw[901]
        mw[432] = (mi.4.Tot_NHBW / @VehOcc_NHBW@ ) * mw[907]
        mw[433] = (mi.4.Tel_NHBW / @VehOcc_NHBW@ ) * mw[907]
        
        
        
        ;bucket rounding
        ;AM
        mw[101] = mw[101], Total=ROWFIX(101, i, 0.5)     ;HBW     
        mw[102] = mw[102], Total=ROWFIX(102, i, 0.5)     ;HBShp   
        mw[103] = mw[103], Total=ROWFIX(103, i, 0.5)     ;HBOth   
        mw[104] = mw[104], Total=ROWFIX(104, i, 0.5)     ;HBSch_Pr
        mw[105] = mw[105], Total=ROWFIX(105, i, 0.5)     ;HBSch_Sc
        mw[106] = mw[106], Total=ROWFIX(106, i, 0.5)     ;HBC     
        mw[107] = mw[107], Total=ROWFIX(107, i, 0.5)     ;NHBW    
        mw[108] = mw[108], Total=ROWFIX(108, i, 0.5)     ;NHBNW   
        mw[109] = mw[109], Total=ROWFIX(109, i, 0.5)     ;IX    
        mw[110] = mw[110], Total=ROWFIX(110, i, 0.5)     ;XI    
        mw[111] = mw[111], Total=ROWFIX(111, i, 0.5)     ;XX    
        mw[112] = mw[112], Total=ROWFIX(112, i, 0.5)     ;SH_LT 
        mw[113] = mw[113], Total=ROWFIX(113, i, 0.5)     ;SH_MD 
        mw[114] = mw[114], Total=ROWFIX(114, i, 0.5)     ;SH_HV 
        mw[115] = mw[115], Total=ROWFIX(115, i, 0.5)     ;Ext_MD
        mw[116] = mw[116], Total=ROWFIX(116, i, 0.5)     ;Ext_HV
        
        ;MD
        mw[201] = mw[201], Total=ROWFIX(201, i, 0.5)     ;HBW     
        mw[202] = mw[202], Total=ROWFIX(202, i, 0.5)     ;HBShp   
        mw[203] = mw[203], Total=ROWFIX(203, i, 0.5)     ;HBOth   
        mw[204] = mw[204], Total=ROWFIX(204, i, 0.5)     ;HBSch_Pr
        mw[205] = mw[205], Total=ROWFIX(205, i, 0.5)     ;HBSch_Sc
        mw[206] = mw[206], Total=ROWFIX(206, i, 0.5)     ;HBC     
        mw[207] = mw[207], Total=ROWFIX(207, i, 0.5)     ;NHBW    
        mw[208] = mw[208], Total=ROWFIX(208, i, 0.5)     ;NHBNW   
        mw[209] = mw[209], Total=ROWFIX(209, i, 0.5)     ;IX    
        mw[210] = mw[210], Total=ROWFIX(210, i, 0.5)     ;XI    
        mw[211] = mw[211], Total=ROWFIX(211, i, 0.5)     ;XX    
        mw[212] = mw[212], Total=ROWFIX(212, i, 0.5)     ;SH_LT 
        mw[213] = mw[213], Total=ROWFIX(213, i, 0.5)     ;SH_MD 
        mw[214] = mw[214], Total=ROWFIX(214, i, 0.5)     ;SH_HV 
        mw[215] = mw[215], Total=ROWFIX(215, i, 0.5)     ;Ext_MD
        mw[216] = mw[216], Total=ROWFIX(216, i, 0.5)     ;Ext_HV
        
        ;PM
        mw[301] = mw[301], Total=ROWFIX(301, i, 0.5)     ;HBW     
        mw[302] = mw[302], Total=ROWFIX(302, i, 0.5)     ;HBShp   
        mw[303] = mw[303], Total=ROWFIX(303, i, 0.5)     ;HBOth   
        mw[304] = mw[304], Total=ROWFIX(304, i, 0.5)     ;HBSch_Pr
        mw[305] = mw[305], Total=ROWFIX(305, i, 0.5)     ;HBSch_Sc
        mw[306] = mw[306], Total=ROWFIX(306, i, 0.5)     ;HBC     
        mw[307] = mw[307], Total=ROWFIX(307, i, 0.5)     ;NHBW    
        mw[308] = mw[308], Total=ROWFIX(308, i, 0.5)     ;NHBNW   
        mw[309] = mw[309], Total=ROWFIX(309, i, 0.5)     ;IX    
        mw[310] = mw[310], Total=ROWFIX(310, i, 0.5)     ;XI    
        mw[311] = mw[311], Total=ROWFIX(311, i, 0.5)     ;XX    
        mw[312] = mw[312], Total=ROWFIX(312, i, 0.5)     ;SH_LT 
        mw[313] = mw[313], Total=ROWFIX(313, i, 0.5)     ;SH_MD 
        mw[314] = mw[314], Total=ROWFIX(314, i, 0.5)     ;SH_HV 
        mw[315] = mw[315], Total=ROWFIX(315, i, 0.5)     ;Ext_MD
        mw[316] = mw[316], Total=ROWFIX(316, i, 0.5)     ;Ext_HV
        
        ;EV
        mw[401] = mw[401], Total=ROWFIX(401, i, 0.5)     ;HBW     
        mw[402] = mw[402], Total=ROWFIX(402, i, 0.5)     ;HBShp   
        mw[403] = mw[403], Total=ROWFIX(403, i, 0.5)     ;HBOth   
        mw[404] = mw[404], Total=ROWFIX(404, i, 0.5)     ;HBSch_Pr
        mw[405] = mw[405], Total=ROWFIX(405, i, 0.5)     ;HBSch_Sc
        mw[406] = mw[406], Total=ROWFIX(406, i, 0.5)     ;HBC     
        mw[407] = mw[407], Total=ROWFIX(407, i, 0.5)     ;NHBW    
        mw[408] = mw[408], Total=ROWFIX(408, i, 0.5)     ;NHBNW   
        mw[409] = mw[409], Total=ROWFIX(409, i, 0.5)     ;IX    
        mw[410] = mw[410], Total=ROWFIX(410, i, 0.5)     ;XI    
        mw[411] = mw[411], Total=ROWFIX(411, i, 0.5)     ;XX    
        mw[412] = mw[412], Total=ROWFIX(412, i, 0.5)     ;SH_LT 
        mw[413] = mw[413], Total=ROWFIX(413, i, 0.5)     ;SH_MD 
        mw[414] = mw[414], Total=ROWFIX(414, i, 0.5)     ;SH_HV 
        mw[415] = mw[415], Total=ROWFIX(415, i, 0.5)     ;Ext_MD
        mw[416] = mw[416], Total=ROWFIX(416, i, 0.5)     ;Ext_HV
        
        
        
        ;calculate totals
        ;AM
        mw[100] = mw[101] +     ;HBW     
                  mw[102] +     ;HBShp   
                  mw[103] +     ;HBOth   
                  mw[104] +     ;HBSch_Pr
                  mw[105] +     ;HBSch_Sc
                  mw[106] +     ;HBC     
                  mw[107] +     ;NHBW    
                  mw[108] +     ;NHBNW   
                  mw[109] +     ;IX    
                  mw[110] +     ;XI    
                  mw[111] +     ;XX    
                  mw[112] +     ;SH_LT 
                  mw[113] +     ;SH_MD 
                  mw[114] +     ;SH_HV 
                  mw[115] +     ;Ext_MD
                  mw[116]       ;Ext_HV
        
        ;MD
        mw[200] = mw[201] +     ;HBW     
                  mw[202] +     ;HBShp   
                  mw[203] +     ;HBOth   
                  mw[204] +     ;HBSch_Pr
                  mw[205] +     ;HBSch_Sc
                  mw[206] +     ;HBC     
                  mw[207] +     ;NHBW    
                  mw[208] +     ;NHBNW   
                  mw[209] +     ;IX    
                  mw[210] +     ;XI    
                  mw[211] +     ;XX    
                  mw[212] +     ;SH_LT 
                  mw[213] +     ;SH_MD 
                  mw[214] +     ;SH_HV 
                  mw[215] +     ;Ext_MD
                  mw[216]       ;Ext_HV
        
        ;PM
        mw[300] = mw[301] +     ;HBW     
                  mw[302] +     ;HBShp   
                  mw[303] +     ;HBOth   
                  mw[304] +     ;HBSch_Pr
                  mw[305] +     ;HBSch_Sc
                  mw[306] +     ;HBC     
                  mw[307] +     ;NHBW    
                  mw[308] +     ;NHBNW   
                  mw[309] +     ;IX    
                  mw[310] +     ;XI    
                  mw[311] +     ;XX    
                  mw[312] +     ;SH_LT 
                  mw[313] +     ;SH_MD 
                  mw[314] +     ;SH_HV 
                  mw[315] +     ;Ext_MD
                  mw[316]       ;Ext_HV
        
        ;EV
        mw[400] = mw[401] +     ;HBW     
                  mw[402] +     ;HBShp   
                  mw[403] +     ;HBOth   
                  mw[404] +     ;HBSch_Pr
                  mw[405] +     ;HBSch_Sc
                  mw[406] +     ;HBC     
                  mw[407] +     ;NHBW    
                  mw[408] +     ;NHBNW   
                  mw[409] +     ;IX    
                  mw[410] +     ;XI    
                  mw[411] +     ;XX    
                  mw[412] +     ;SH_LT 
                  mw[413] +     ;SH_MD 
                  mw[414] +     ;SH_HV 
                  mw[415] +     ;Ext_MD
                  mw[416]       ;Ext_HV
        
        ;DY
        mw[500] = mw[100] + 
                  mw[200] + 
                  mw[300] + 
                  mw[400] 
    
    ENDRUN
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_MX = currenttime()
        SubScriptRunTime_MX = SubScriptEndTime_MX - @SubScriptStartTime_MX@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            Prep matrices       ', formatdatetime(SubScriptRunTime_MX, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;ASSIGNMENT ============================================================================================================================
    
    ;get start time
    SubScriptStartTime_AM = currenttime()
    
    
    PrdTag = 'AM'
    
    ;assignment convergence criteria
    if (n<3)  RelGapCriteria = RGAPCriteria_n1_2
    if (n=3)  RelGapCriteria = RGAPCriteria_n3
    if (n>3)  RelGapCriteria = RGAPCriteria_n4p
    
    
    ;load AM period trips
    RUN PGM=HIGHWAY  MSG='Distribution: Feedback Loop @n@ - Step 9: Load @PrdTag@ Trips'
        FILEI NETI     = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'     
              TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
              
              MATI[1]  = '@ParentDir@@ScenarioDir@Temp\3_Distribute\am3hr_ODveh_ByPurp_tmp.mtx'
              
              LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Ramp_Penalty_Lookup.csv'
              LOOKUPI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\RampGP_Connection - @RID@.csv'
              LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Max_Ramp_Penalty.csv'

        
        FILEO NETO    = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_@PrdTag@_tmp.net',
            INCLUDE=lw.RPen, 
                    lw.TPen
             
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        ;parameters
        ZONES       = @UsedZones@
        ZONEMSG     = 10
        
        ;period specific variables
        whatperiod    = 1
        
        READ FILE = '@ParentDir@2_ModelScripts\3_Distribute\block\4pd_mainbody_distribution.block'
        
    ENDRUN
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_AM = currenttime()
        SubScriptRunTime_AM = SubScriptEndTime_AM - @SubScriptStartTime_AM@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            AM assignment       ', formatdatetime(SubScriptRunTime_AM, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;get start time
    SubScriptStartTime_MD = currenttime()
    
    
    PrdTag = 'MD'
    
    ;assignment convergence criteria
    if (n<3)  RelGapCriteria = RGAPCriteria_n1_2 ;/ 10
    if (n=3)  RelGapCriteria = RGAPCriteria_n3   ;/ 10
    if (n>3)  RelGapCriteria = RGAPCriteria_n4p  ;/ 10
    
    
    ;load MD period trips
    RUN PGM=HIGHWAY  MSG='Distribution: Feedback Loop @n@ - Step 10: Load @PrdTag@ Trips'
        FILEI NETI     = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'     
              TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
              
              MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\md6hr_ODveh_ByPurp_tmp.mtx'
              
              LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Ramp_Penalty_Lookup.csv'
              LOOKUPI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\RampGP_Connection - @RID@.csv'
              LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Max_Ramp_Penalty.csv'
        
        FILEO NETO    = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_@PrdTag@_tmp.net',
            INCLUDE=lw.RPen, 
                    lw.TPen
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
    
        ;parameters
        ZONES       = @UsedZones@
        ZONEMSG     = 10
        
        ;period specific variables
        whatperiod    = 2
        
        READ FILE = '@ParentDir@2_ModelScripts\3_Distribute\block\4pd_mainbody_distribution.block'
        
    ENDRUN
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_MD = currenttime()
        SubScriptRunTime_MD = SubScriptEndTime_MD - @SubScriptStartTime_MD@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            MD assignment       ', formatdatetime(SubScriptRunTime_MD, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;get start time
    SubScriptStartTime_PM = currenttime()
    
    
    PrdTag = 'PM'
    
    ;assignment convergence criteria
    if (n<3)  RelGapCriteria = RGAPCriteria_n1_2
    if (n=3)  RelGapCriteria = RGAPCriteria_n3
    if (n>3)  RelGapCriteria = RGAPCriteria_n4p
    
    
    ;load PM period trips
    RUN PGM=HIGHWAY  MSG='Distribution: Feedback Loop @n@ - Step 11: Load @PrdTag@ Trips'
        FILEI NETI     = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'     
              TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
              
              MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\pm3hr_ODveh_ByPurp_tmp.mtx'
              
              LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Ramp_Penalty_Lookup.csv'
              LOOKUPI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\RampGP_Connection - @RID@.csv'
              LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Max_Ramp_Penalty.csv'
        
        FILEO NETO    = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_@PrdTag@_tmp.net',
            INCLUDE=lw.RPen, 
                    lw.TPen
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        ;parameters
        ZONES       = @UsedZones@
        ZONEMSG     = 10
        
        ;period specific variables
        whatperiod    = 3
        
        READ FILE = '@ParentDir@2_ModelScripts\3_Distribute\block\4pd_mainbody_distribution.block'
        
    ENDRUN
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_PM = currenttime()
        SubScriptRunTime_PM = SubScriptEndTime_PM - @SubScriptStartTime_PM@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            PM assignment       ', formatdatetime(SubScriptRunTime_PM, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;get start time
    SubScriptStartTime_EV = currenttime()
    
    
    PrdTag = 'EV'
    
    ;assignment convergence criteria
    if (n<3)  RelGapCriteria = RGAPCriteria_n1_2 / 10
    if (n=3)  RelGapCriteria = RGAPCriteria_n3   / 10
    if (n>3)  RelGapCriteria = RGAPCriteria_n4p  / 10
    
    
    ;load EV period trips
    RUN PGM=HIGHWAY  MSG='Distribution: Feedback Loop @n@ - Step 12: Load @PrdTag@ Trips'
        FILEI NETI     = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'     
              TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
             
              MATI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\ev12hr_ODveh_ByPurp_tmp.mtx'
              
              LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Ramp_Penalty_Lookup.csv'
              LOOKUPI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\RampGP_Connection - @RID@.csv'
              LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\MM_Max_Ramp_Penalty.csv'
        
        FILEO NETO    = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_@PrdTag@_tmp.net',
            INCLUDE=lw.RPen, 
                    lw.TPen
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
    
        ;parameters
        ZONES       = @UsedZones@
        ZONEMSG     = 10
        
        ;period specific variables
        whatperiod    = 4
        
        READ FILE = '@ParentDir@2_ModelScripts\3_Distribute\block\4pd_mainbody_distribution.block'
        
    ENDRUN
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_EV = currenttime()
        SubScriptRunTime_EV = SubScriptEndTime_EV - @SubScriptStartTime_EV@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            EV assignment       ', formatdatetime(SubScriptRunTime_EV, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    ;compile convergence reports
    if (n=1)
        
        RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 12: Compiling Assignment Convergence Reports'
            
            ZONES = 1
            
            ;print header for assignment convergence report
            PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Assign - @RID@.csv',
                CSV=T, 
                FORM=15.0, 
                LIST='FBLoop'     ,
                     'PERIOD'     ,
                     'ITERATION'  ,
                     'LAMBDA'     ,
                     'BALANCE'    ,
                     'RGAP'       ,
                     'RGAPCUTOFF' ,
                     'GAP'        ,
                     'GAPCUTOFF'  ,
                     'RMSE'       ,
                     'RMSECUTOFF' ,
                     'AAD'        ,
                     'AADCUTOFF'  ,
                     'RAAD'       ,
                     'RAADCUTOFF' ,
                     'PDIFF'      ,
                     'PDIFFCUTOFF'
            
        ENDRUN
        
    endif  ;n=1
    
    
    RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@ - Step 12: Compiling Assignment Convergence Reports'
        
        FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_Convergence - FB @n@ - AM.csv',
            DELIMITER =',',
            FBLOOP      = #01,
            ITERATION   =  02,
            LAMBDA      =  03,
            BALANCE     =  04,
            RGAP        =  05,
            RGAPCUTOFF  =  06,
            GAP         =  07,
            GAPCUTOFF   =  08,
            RMSE        =  09,
            RMSECUTOFF  =  10,
            AAD         =  11,
            AADCUTOFF   =  12,
            RAAD        =  13,
            RAADCUTOFF  =  14,
            PDIFF       =  15,
            PDIFFCUTOFF =  16,
            AUTOARRAY=ALLFIELDS
        
        FILEI DBI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_Convergence - FB @n@ - MD.csv',
            DELIMITER =',',
            FBLOOP      = #01,
            ITERATION   =  02,
            LAMBDA      =  03,
            BALANCE     =  04,
            RGAP        =  05,
            RGAPCUTOFF  =  06,
            GAP         =  07,
            GAPCUTOFF   =  08,
            RMSE        =  09,
            RMSECUTOFF  =  10,
            AAD         =  11,
            AADCUTOFF   =  12,
            RAAD        =  13,
            RAADCUTOFF  =  14,
            PDIFF       =  15,
            PDIFFCUTOFF =  16,
            AUTOARRAY=ALLFIELDS
            
        FILEI DBI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_Convergence - FB @n@ - PM.csv',
            DELIMITER =',',
            FBLOOP      = #01,
            ITERATION   =  02,
            LAMBDA      =  03,
            BALANCE     =  04,
            RGAP        =  05,
            RGAPCUTOFF  =  06,
            GAP         =  07,
            GAPCUTOFF   =  08,
            RMSE        =  09,
            RMSECUTOFF  =  10,
            AAD         =  11,
            AADCUTOFF   =  12,
            RAAD        =  13,
            RAADCUTOFF  =  14,
            PDIFF       =  15,
            PDIFFCUTOFF =  16,
            AUTOARRAY=ALLFIELDS
            
        FILEI DBI[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\_Convergence - FB @n@ - EV.csv',
            DELIMITER =',',
            FBLOOP      = #01,
            ITERATION   =  02,
            LAMBDA      =  03,
            BALANCE     =  04,
            RGAP        =  05,
            RGAPCUTOFF  =  06,
            GAP         =  07,
            GAPCUTOFF   =  08,
            RMSE        =  09,
            RMSECUTOFF  =  10,
            AAD         =  11,
            AADCUTOFF   =  12,
            RAAD        =  13,
            RAADCUTOFF  =  14,
            PDIFF       =  15,
            PDIFFCUTOFF =  16,
            AUTOARRAY=ALLFIELDS
        
        
    
        ZONES = 1
        
        
        
        ;get data from temp file convergence reports
        ;AM
        LOOP lp=1, DBI.1.NUMRECORDS
            
            if (dba.1.ITERATION[lp]>0)
                
                ;print data assignment convergence summary to csv file
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Assign - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=10.7,
                    LIST=dba.1.FBLOOP[lp](10.0)   ,
                         'AM',
                         dba.1.ITERATION[lp](10.0),
                         dba.1.LAMBDA[lp](10.4)   ,
                         dba.1.BALANCE[lp](10.0)  ,
                         dba.1.RGAP[lp]           ,
                         dba.1.RGAPCUTOFF[lp]     ,
                         dba.1.GAP[lp]            ,
                         dba.1.GAPCUTOFF[lp]      ,
                         dba.1.RMSE[lp](10.2)     ,
                         dba.1.RMSECUTOFF[lp]     ,
                         dba.1.AAD[lp](10.2)      ,
                         dba.1.AADCUTOFF[lp]      ,
                         dba.1.RAAD[lp]           ,
                         dba.1.RAADCUTOFF[lp]     ,
                         dba.1.PDIFF[lp]          ,
                         dba.1.PDIFFCUTOFF[lp]    
                
            endif  ;dba.1.ITERATION[lp]>0
            
        ENDLOOP  ;1, DBI.1.NUMRECORDS
        
        
        ;MD
        LOOP lp=1, DBI.2.NUMRECORDS
            
            if (dba.2.ITERATION[lp]>0)
                
                ;print data assignment convergence summary to csv file
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Assign - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=10.7,
                    LIST=dba.2.FBLOOP[lp](10.0)   ,
                         'MD',
                         dba.2.ITERATION[lp](10.0),
                         dba.2.LAMBDA[lp](10.4)   ,
                         dba.2.BALANCE[lp](10.0)  ,
                         dba.2.RGAP[lp]           ,
                         dba.2.RGAPCUTOFF[lp]     ,
                         dba.2.GAP[lp]            ,
                         dba.2.GAPCUTOFF[lp]      ,
                         dba.2.RMSE[lp](10.2)     ,
                         dba.2.RMSECUTOFF[lp]     ,
                         dba.2.AAD[lp](10.2)      ,
                         dba.2.AADCUTOFF[lp]      ,
                         dba.2.RAAD[lp]           ,
                         dba.2.RAADCUTOFF[lp]     ,
                         dba.2.PDIFF[lp]          ,
                         dba.2.PDIFFCUTOFF[lp]    
                
            endif  ;dba.2.ITERATION[lp]>0
            
        ENDLOOP  ;1, DBI.2.NUMRECORDS
        
        
        ;PM
        LOOP lp=1, DBI.3.NUMRECORDS
            
            if (dba.3.ITERATION[lp]>0)
                
                ;print data assignment convergence summary to csv file
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Assign - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=10.7,
                    LIST=dba.3.FBLOOP[lp](10.0)   ,
                         'PM',
                         dba.3.ITERATION[lp](10.0),
                         dba.3.LAMBDA[lp](10.4)   ,
                         dba.3.BALANCE[lp](10.0)  ,
                         dba.3.RGAP[lp]           ,
                         dba.3.RGAPCUTOFF[lp]     ,
                         dba.3.GAP[lp]            ,
                         dba.3.GAPCUTOFF[lp]      ,
                         dba.3.RMSE[lp](10.2)     ,
                         dba.3.RMSECUTOFF[lp]     ,
                         dba.3.AAD[lp](10.2)      ,
                         dba.3.AADCUTOFF[lp]      ,
                         dba.3.RAAD[lp]           ,
                         dba.3.RAADCUTOFF[lp]     ,
                         dba.3.PDIFF[lp]          ,
                         dba.3.PDIFFCUTOFF[lp]    
                
            endif  ;dba.3.ITERATION[lp]>0
            
        ENDLOOP  ;1, DBI.3.NUMRECORDS
        
        
        ;EV
        LOOP lp=1, DBI.4.NUMRECORDS
            
            if (dba.4.ITERATION[lp]>0)
                
                ;print data assignment convergence summary to csv file
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Assign - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=10.7,
                    LIST=dba.4.FBLOOP[lp](10.0)   ,
                         'EV',
                         dba.4.ITERATION[lp](10.0),
                         dba.4.LAMBDA[lp](10.4)   ,
                         dba.4.BALANCE[lp](10.0)  ,
                         dba.4.RGAP[lp]           ,
                         dba.4.RGAPCUTOFF[lp]     ,
                         dba.4.GAP[lp]            ,
                         dba.4.GAPCUTOFF[lp]      ,
                         dba.4.RMSE[lp](10.2)     ,
                         dba.4.RMSECUTOFF[lp]     ,
                         dba.4.AAD[lp](10.2)      ,
                         dba.4.AADCUTOFF[lp]      ,
                         dba.4.RAAD[lp]           ,
                         dba.4.RAADCUTOFF[lp]     ,
                         dba.4.PDIFF[lp]          ,
                         dba.4.PDIFFCUTOFF[lp]    
                
            endif  ;dba.4.ITERATION[lp]>0
            
        ENDLOOP  ;1, DBI.4.NUMRECORDS
        
    ENDRUN
    
    
    
    
    ;SUMMARIZE LOADED NETWORKS & CALCULATE STATS ==============================================================================================
    
    ;get start time
    SubScriptStartTime_SN = currenttime()
    
    
    ;process loaded network, calc change from last iter and convergence
    RUN PGM=NETWORK  MSG='Distribution: Feedback Loop @n@ - Step 13: Summarize Loaded Networks'
        FILEI NETI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'
              NETI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_AM_tmp.net'
              NETI[3] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_MD_tmp.net'
              NETI[4] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_PM_tmp.net'
              NETI[5] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_load_EV_tmp.net'
        
        LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\BTI_Lookup.csv'
        
        FILEO NETO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_tmp.net', 
            EXCLUDE=TIME_1   ,
                    VC_1     ,
                    VHT_1    ,
                    VDT_1    ,
                    CSPD_1   ,
                    LW_RPEN_1, 
                    LW_TPEN_1,
                      V_1,        VT_1,
                     V1_1,       V1T_1,  
                     V2_1,       V2T_1, 
                     V3_1,       V3T_1, 
                     V4_1,       V4T_1, 
                     V5_1,       V5T_1, 
                     V6_1,       V6T_1, 
                     V7_1,       V7T_1, 
                     V8_1,       V8T_1, 
                     V9_1,       V9T_1, 
                    V10_1,      V10T_1,
                    V11_1,      V11T_1,
                    V12_1,      V12T_1,
                    V13_1,      V13T_1,
                    V14_1,      V14T_1,
                    V15_1,      V15T_1,
                    V16_1,      V16T_1,
                    V23_1,      V23T_1,
                    V31_1,      V31T_1,
                    V33_1,      V33T_1
        
        
        ZONES   = @Usedzones@
        
        
        ;Free flow speed lookup function
        LOOKUP LOOKUPI=1, 
            INTERPOLATE=T, 
            NAME=BTI_pct,
            LOOKUP[1]=01, RESULT=02
        
        

        PHASE = LINKMERGE
            ;process raw volume ----------------------------------------------------------
            ;1 way volume
            _AM_HBW      = ROUND(li.2.V1_1  * 10) / 10
            _AM_HBShp    = ROUND(li.2.V2_1  * 10) / 10
            _AM_HBOth    = ROUND(li.2.V3_1  * 10) / 10
            _AM_HBSch_Pr = ROUND(li.2.V4_1  * 10) / 10
            _AM_HBSch_Sc = ROUND(li.2.V5_1  * 10) / 10
            _AM_HBC      = ROUND(li.2.V6_1  * 10) / 10
            _AM_NHBW     = ROUND(li.2.V7_1  * 10) / 10
            _AM_NHBNW    = ROUND(li.2.V8_1  * 10) / 10
            _AM_IX       = ROUND(li.2.V9_1  * 10) / 10
            _AM_XI       = ROUND(li.2.V10_1 * 10) / 10
            _AM_XX       = ROUND(li.2.V11_1 * 10) / 10
            _AM_SLT      = ROUND(li.2.V12_1 * 10) / 10
            _AM_SMD      = ROUND(li.2.V13_1 * 10) / 10
            _AM_SHV      = ROUND(li.2.V14_1 * 10) / 10
            _AM_LMD      = ROUND(li.2.V15_1 * 10) / 10
            _AM_LHV      = ROUND(li.2.V16_1 * 10) / 10
            _AM_TTUNIQUE = ROUND(li.2.V23_1 * 10) / 10
            _AM_Tel_HBW  = ROUND(li.2.V31_1 * 10) / 10
            _AM_Tel_NHBW = ROUND(li.2.V33_1 * 10) / 10
            
            _MD_HBW      = ROUND(li.3.V1_1  * 10) / 10
            _MD_HBShp    = ROUND(li.3.V2_1  * 10) / 10
            _MD_HBOth    = ROUND(li.3.V3_1  * 10) / 10
            _MD_HBSch_Pr = ROUND(li.3.V4_1  * 10) / 10
            _MD_HBSch_Sc = ROUND(li.3.V5_1  * 10) / 10
            _MD_HBC      = ROUND(li.3.V6_1  * 10) / 10
            _MD_NHBW     = ROUND(li.3.V7_1  * 10) / 10
            _MD_NHBNW    = ROUND(li.3.V8_1  * 10) / 10
            _MD_IX       = ROUND(li.3.V9_1  * 10) / 10
            _MD_XI       = ROUND(li.3.V10_1 * 10) / 10
            _MD_XX       = ROUND(li.3.V11_1 * 10) / 10
            _MD_SLT      = ROUND(li.3.V12_1 * 10) / 10
            _MD_SMD      = ROUND(li.3.V13_1 * 10) / 10
            _MD_SHV      = ROUND(li.3.V14_1 * 10) / 10
            _MD_LMD      = ROUND(li.3.V15_1 * 10) / 10
            _MD_LHV      = ROUND(li.3.V16_1 * 10) / 10
            _MD_TTUNIQUE = ROUND(li.3.V23_1 * 10) / 10
            _MD_Tel_HBW  = ROUND(li.3.V31_1 * 10) / 10
            _MD_Tel_NHBW = ROUND(li.3.V33_1 * 10) / 10
            
            _PM_HBW      = ROUND(li.4.V1_1  * 10) / 10
            _PM_HBShp    = ROUND(li.4.V2_1  * 10) / 10
            _PM_HBOth    = ROUND(li.4.V3_1  * 10) / 10
            _PM_HBSch_Pr = ROUND(li.4.V4_1  * 10) / 10
            _PM_HBSch_Sc = ROUND(li.4.V5_1  * 10) / 10
            _PM_HBC      = ROUND(li.4.V6_1  * 10) / 10
            _PM_NHBW     = ROUND(li.4.V7_1  * 10) / 10
            _PM_NHBNW    = ROUND(li.4.V8_1  * 10) / 10
            _PM_IX       = ROUND(li.4.V9_1  * 10) / 10
            _PM_XI       = ROUND(li.4.V10_1 * 10) / 10
            _PM_XX       = ROUND(li.4.V11_1 * 10) / 10
            _PM_SLT      = ROUND(li.4.V12_1 * 10) / 10
            _PM_SMD      = ROUND(li.4.V13_1 * 10) / 10
            _PM_SHV      = ROUND(li.4.V14_1 * 10) / 10
            _PM_LMD      = ROUND(li.4.V15_1 * 10) / 10
            _PM_LHV      = ROUND(li.4.V16_1 * 10) / 10
            _PM_TTUNIQUE = ROUND(li.4.V23_1 * 10) / 10
            _PM_Tel_HBW  = ROUND(li.4.V31_1 * 10) / 10
            _PM_Tel_NHBW = ROUND(li.4.V33_1 * 10) / 10
            
            _EV_HBW      = ROUND(li.5.V1_1  * 10) / 10
            _EV_HBShp    = ROUND(li.5.V2_1  * 10) / 10
            _EV_HBOth    = ROUND(li.5.V3_1  * 10) / 10
            _EV_HBSch_Pr = ROUND(li.5.V4_1  * 10) / 10
            _EV_HBSch_Sc = ROUND(li.5.V5_1  * 10) / 10
            _EV_HBC      = ROUND(li.5.V6_1  * 10) / 10
            _EV_NHBW     = ROUND(li.5.V7_1  * 10) / 10
            _EV_NHBNW    = ROUND(li.5.V8_1  * 10) / 10
            _EV_IX       = ROUND(li.5.V9_1  * 10) / 10
            _EV_XI       = ROUND(li.5.V10_1 * 10) / 10
            _EV_XX       = ROUND(li.5.V11_1 * 10) / 10
            _EV_SLT      = ROUND(li.5.V12_1 * 10) / 10
            _EV_SMD      = ROUND(li.5.V13_1 * 10) / 10
            _EV_SHV      = ROUND(li.5.V14_1 * 10) / 10
            _EV_LMD      = ROUND(li.5.V15_1 * 10) / 10
            _EV_LHV      = ROUND(li.5.V16_1 * 10) / 10
            _EV_TTUNIQUE = ROUND(li.5.V23_1 * 10) / 10
            _EV_Tel_HBW  = ROUND(li.5.V31_1 * 10) / 10
            _EV_Tel_NHBW = ROUND(li.5.V33_1 * 10) / 10
            
            ;2 way volume
            ;  note: variables can be up to 15 characters
            _AM_2w_HBW      = ROUND(li.2.V1T_1  * 10) / 10
            _AM_2w_HBShp    = ROUND(li.2.V2T_1  * 10) / 10
            _AM_2w_HBOth    = ROUND(li.2.V3T_1  * 10) / 10
            _AM_2W_HBS_PR   = ROUND(li.2.V4T_1  * 10) / 10
            _AM_2W_HBS_Sc   = ROUND(li.2.V5T_1  * 10) / 10
            _AM_2w_HBC      = ROUND(li.2.V6T_1  * 10) / 10
            _AM_2w_NHBW     = ROUND(li.2.V7T_1  * 10) / 10
            _AM_2w_NHBNW    = ROUND(li.2.V8T_1  * 10) / 10
            _AM_2w_IX       = ROUND(li.2.V9T_1  * 10) / 10
            _AM_2w_XI       = ROUND(li.2.V10T_1 * 10) / 10
            _AM_2w_XX       = ROUND(li.2.V11T_1 * 10) / 10
            _AM_2w_SLT      = ROUND(li.2.V12T_1 * 10) / 10
            _AM_2w_SMD      = ROUND(li.2.V13T_1 * 10) / 10
            _AM_2w_SHV      = ROUND(li.2.V14T_1 * 10) / 10
            _AM_2w_LMD      = ROUND(li.2.V15T_1 * 10) / 10
            _AM_2w_LHV      = ROUND(li.2.V16T_1 * 10) / 10
            _AM_2w_TTUNIQUE = ROUND(li.2.V23T_1 * 10) / 10
            _AM_2w_Tel_HBW  = ROUND(li.2.V31T_1 * 10) / 10
            _AM_2w_Tel_NHBW = ROUND(li.2.V33T_1 * 10) / 10
            
            _MD_2w_HBW      = ROUND(li.3.V1T_1  * 10) / 10
            _MD_2w_HBShp    = ROUND(li.3.V2T_1  * 10) / 10
            _MD_2w_HBOth    = ROUND(li.3.V3T_1  * 10) / 10
            _MD_2w_HBS_Pr   = ROUND(li.3.V4T_1  * 10) / 10
            _MD_2w_HBS_Sc   = ROUND(li.3.V5T_1  * 10) / 10
            _MD_2w_HBC      = ROUND(li.3.V6T_1  * 10) / 10
            _MD_2w_NHBW     = ROUND(li.3.V7T_1  * 10) / 10
            _MD_2w_NHBNW    = ROUND(li.3.V8T_1  * 10) / 10
            _MD_2w_IX       = ROUND(li.3.V9T_1  * 10) / 10
            _MD_2w_XI       = ROUND(li.3.V10T_1 * 10) / 10
            _MD_2w_XX       = ROUND(li.3.V11T_1 * 10) / 10
            _MD_2w_SLT      = ROUND(li.3.V12T_1 * 10) / 10
            _MD_2w_SMD      = ROUND(li.3.V13T_1 * 10) / 10
            _MD_2w_SHV      = ROUND(li.3.V14T_1 * 10) / 10
            _MD_2w_LMD      = ROUND(li.3.V15T_1 * 10) / 10
            _MD_2w_LHV      = ROUND(li.3.V16T_1 * 10) / 10
            _MD_2w_TTUNIQUE = ROUND(li.3.V23T_1 * 10) / 10
            _MD_2w_Tel_HBW  = ROUND(li.3.V31T_1 * 10) / 10
            _MD_2w_Tel_NHBW = ROUND(li.3.V33T_1 * 10) / 10
            
            _PM_2w_HBW      = ROUND(li.4.V1T_1  * 10) / 10
            _PM_2w_HBShp    = ROUND(li.4.V2T_1  * 10) / 10
            _PM_2w_HBOth    = ROUND(li.4.V3T_1  * 10) / 10
            _PM_2w_HBS_Pr   = ROUND(li.4.V4T_1  * 10) / 10
            _PM_2w_HBS_Sc   = ROUND(li.4.V5T_1  * 10) / 10
            _PM_2w_HBC      = ROUND(li.4.V6T_1  * 10) / 10
            _PM_2w_NHBW     = ROUND(li.4.V7T_1  * 10) / 10
            _PM_2w_NHBNW    = ROUND(li.4.V8T_1  * 10) / 10
            _PM_2w_IX       = ROUND(li.4.V9T_1  * 10) / 10
            _PM_2w_XI       = ROUND(li.4.V10T_1 * 10) / 10
            _PM_2w_XX       = ROUND(li.4.V11T_1 * 10) / 10
            _PM_2w_SLT      = ROUND(li.4.V12T_1 * 10) / 10
            _PM_2w_SMD      = ROUND(li.4.V13T_1 * 10) / 10
            _PM_2w_SHV      = ROUND(li.4.V14T_1 * 10) / 10
            _PM_2w_LMD      = ROUND(li.4.V15T_1 * 10) / 10
            _PM_2w_LHV      = ROUND(li.4.V16T_1 * 10) / 10
            _PM_2w_TTUNIQUE = ROUND(li.4.V23T_1 * 10) / 10
            _PM_2w_Tel_HBW  = ROUND(li.4.V31T_1 * 10) / 10
            _PM_2w_Tel_NHBW = ROUND(li.4.V33T_1 * 10) / 10
            
            _EV_2w_HBW      = ROUND(li.5.V1T_1  * 10) / 10
            _EV_2w_HBShp    = ROUND(li.5.V2T_1  * 10) / 10
            _EV_2w_HBOth    = ROUND(li.5.V3T_1  * 10) / 10
            _EV_2w_HBS_Pr   = ROUND(li.5.V4T_1  * 10) / 10
            _EV_2w_HBS_Sc   = ROUND(li.5.V5T_1  * 10) / 10
            _EV_2w_HBC      = ROUND(li.5.V6T_1  * 10) / 10
            _EV_2w_NHBW     = ROUND(li.5.V7T_1  * 10) / 10
            _EV_2w_NHBNW    = ROUND(li.5.V8T_1  * 10) / 10
            _EV_2w_IX       = ROUND(li.5.V9T_1  * 10) / 10
            _EV_2w_XI       = ROUND(li.5.V10T_1 * 10) / 10
            _EV_2w_XX       = ROUND(li.5.V11T_1 * 10) / 10
            _EV_2w_SLT      = ROUND(li.5.V12T_1 * 10) / 10
            _EV_2w_SMD      = ROUND(li.5.V13T_1 * 10) / 10
            _EV_2w_SHV      = ROUND(li.5.V14T_1 * 10) / 10
            _EV_2w_LMD      = ROUND(li.5.V15T_1 * 10) / 10
            _EV_2w_LHV      = ROUND(li.5.V16T_1 * 10) / 10
            _EV_2w_TTUNIQUE = ROUND(li.5.V23T_1 * 10) / 10
            _EV_2w_Tel_HBW  = ROUND(li.5.V31T_1 * 10) / 10
            _EV_2w_Tel_NHBW = ROUND(li.5.V33T_1 * 10) / 10
            
            
            ;summarize truck volume
            _DY_SLT   = _AM_SLT   + _MD_SLT   + _PM_SLT   + _EV_SLT
            _DY_SMD   = _AM_SMD   + _MD_SMD   + _PM_SMD   + _EV_SMD
            _DY_SHV   = _AM_SHV   + _MD_SHV   + _PM_SHV   + _EV_SHV
            _DY_LMD   = _AM_LMD   + _MD_LMD   + _PM_LMD   + _EV_LMD
            _DY_LHV   = _AM_LHV   + _MD_LHV   + _PM_LHV   + _EV_LHV
            
            _AM_Trk_MD = _AM_SMD + _AM_LMD
            _MD_Trk_MD = _MD_SMD + _MD_LMD
            _PM_Trk_MD = _PM_SMD + _PM_LMD
            _EV_Trk_MD = _EV_SMD + _EV_LMD
            _DY_Trk_MD = _DY_SMD + _DY_LMD
            
            _AM_Trk_HV = _AM_SHV + _AM_LHV
            _MD_Trk_HV = _MD_SHV + _MD_LHV
            _PM_Trk_HV = _PM_SHV + _PM_LHV
            _EV_Trk_HV = _EV_SHV + _EV_LHV
            _DY_Trk_HV = _DY_SHV + _DY_LHV
            
            
            
            ;summarize volumes -----------------------------------------------------------
            ;by period
            AM_VOL = _AM_HBW      + 
                     _AM_HBShp    +
                     _AM_HBOth    +
                     _AM_HBSch_Pr +
                     _AM_HBSch_Sc +
                     _AM_HBC      + 
                     _AM_NHBW     + 
                     _AM_NHBNW    +
                     _AM_IX       +
                     _AM_XI       +
                     _AM_XX       +
                     _AM_SLT      +
                     _AM_SMD      +
                     _AM_SHV      +
                     _AM_LMD      +
                     _AM_LHV      
            
            MD_VOL = _MD_HBW      +
                     _MD_HBShp    +
                     _MD_HBOth    +
                     _MD_HBSch_Pr +
                     _MD_HBSch_Sc +
                     _MD_HBC      +
                     _MD_NHBW     +
                     _MD_NHBNW    +
                     _MD_IX       +
                     _MD_XI       +
                     _MD_XX       +
                     _MD_SLT      +
                     _MD_SMD      +
                     _MD_SHV      +
                     _MD_LMD      +
                     _MD_LHV      
            
            PM_VOL = _PM_HBW      +
                     _PM_HBShp    +
                     _PM_HBOth    +
                     _PM_HBSch_Pr +
                     _PM_HBSch_Sc +
                     _PM_HBC      +
                     _PM_NHBW     +
                     _PM_NHBNW    +
                     _PM_IX       +
                     _PM_XI       +
                     _PM_XX       +
                     _PM_SLT      +
                     _PM_SMD      +
                     _PM_SHV      +
                     _PM_LMD      +
                     _PM_LHV      
            
            EV_VOL = _EV_HBW      +
                     _EV_HBShp    +
                     _EV_HBOth    +
                     _EV_HBSch_Pr +
                     _EV_HBSch_Sc +
                     _EV_HBC      +
                     _EV_NHBW     +
                     _EV_NHBNW    +
                     _EV_IX       +
                     _EV_XI       +
                     _EV_XX       +
                     _EV_SLT      +
                     _EV_SMD      +
                     _EV_SHV      +
                     _EV_LMD      +
                     _EV_LHV      
            
            
            DY_VOL = AM_VOL +
                     MD_VOL +
                     PM_VOL +
                     EV_VOL 
            
            DY_VOL2Wy = _AM_2w_HBW      + _MD_2w_HBW      + _PM_2w_HBW      + _EV_2w_HBW      +
                        _AM_2w_HBShp    + _MD_2w_HBShp    + _PM_2w_HBShp    + _EV_2w_HBShp    +
                        _AM_2w_HBOth    + _MD_2w_HBOth    + _PM_2w_HBOth    + _EV_2w_HBOth    +
                        _AM_2W_HBS_PR   + _MD_2w_HBS_Pr   + _PM_2w_HBS_Pr   + _EV_2w_HBS_Pr   +
                        _AM_2W_HBS_Sc   + _MD_2w_HBS_Sc   + _PM_2w_HBS_Sc   + _EV_2w_HBS_Sc   +
                        _AM_2w_HBC      + _MD_2w_HBC      + _PM_2w_HBC      + _EV_2w_HBC      +
                        _AM_2w_NHBW     + _MD_2w_NHBW     + _PM_2w_NHBW     + _EV_2w_NHBW     +
                        _AM_2w_NHBNW    + _MD_2w_NHBNW    + _PM_2w_NHBNW    + _EV_2w_NHBNW    +
                        _AM_2w_IX       + _MD_2w_IX       + _PM_2w_IX       + _EV_2w_IX       +
                        _AM_2w_XI       + _MD_2w_XI       + _PM_2w_XI       + _EV_2w_XI       +
                        _AM_2w_XX       + _MD_2w_XX       + _PM_2w_XX       + _EV_2w_XX       +
                        _AM_2w_SLT      + _MD_2w_SLT      + _PM_2w_SLT      + _EV_2w_SLT      +
                        _AM_2w_SMD      + _MD_2w_SMD      + _PM_2w_SMD      + _EV_2w_SMD      +
                        _AM_2w_SHV      + _MD_2w_SHV      + _PM_2w_SHV      + _EV_2w_SHV      +
                        _AM_2w_LMD      + _MD_2w_LMD      + _PM_2w_LMD      + _EV_2w_LMD      +
                        _AM_2w_LHV      + _MD_2w_LHV      + _PM_2w_LHV      + _EV_2w_LHV     
            
            DY_1k     = ROUND(DY_VOL / 1000)
            
            DY_1k_2wy = ROUND(DY_VOL2Wy / 1000)
            
            
            
            ;summarize other link fields -------------------------------------------------
            ;v/c
            AM_VC = ROUND(li.2.VC_1 * 1000) / 1000
            MD_VC = ROUND(li.3.VC_1 * 1000) / 1000
            PM_VC = ROUND(li.4.VC_1 * 1000) / 1000
            EV_VC = ROUND(li.5.VC_1 * 1000) / 1000
            
            
            ;update ramp penalty
            AM_RampPen = ROUND(li.2.LW_RPEN_1 * 100) / 100
            MD_RampPen = ROUND(li.3.LW_RPEN_1 * 100) / 100
            PM_RampPen = ROUND(li.4.LW_RPEN_1 * 100) / 100
            EV_RampPen = ROUND(li.5.LW_RPEN_1 * 100) / 100
            
            ;calculate average daily ramp penalty
            if (DY_VOL<1)
                
                DY_RampPen  = EV_RampPen
            
            else
                
                DY_RampPen = ROUND( (AM_RampPen * AM_VOL +
                                     MD_RampPen * MD_VOL +
                                     PM_RampPen * PM_VOL +
                                     EV_RampPen * EV_VOL  ) / DY_VOL * 100) / 100
                
            endif  ;DY_VOL<1
            
            
            
            ;update congested speed & time
            ;  note: DY_SPD calculation after DY_TIME calculation
            ;congested speed
            AM_SPD  = ROUND(li.2.CSPD_1 * 10) / 10
            MD_SPD  = ROUND(li.3.CSPD_1 * 10) / 10
            PM_SPD  = ROUND(li.4.CSPD_1 * 10) / 10
            EV_SPD  = ROUND(li.5.CSPD_1 * 10) / 10
            
            ;congested time
            AM_TIME = ROUND(li.2.TIME_1 * 10000) / 10000
            MD_TIME = ROUND(li.3.TIME_1 * 10000) / 10000
            PM_TIME = ROUND(li.4.TIME_1 * 10000) / 10000
            EV_TIME = ROUND(li.5.TIME_1 * 10000) / 10000
            
            ;calculate average daily time and speed
            if (DY_VOL<1)
                
                DY_TIME = li.1.FF_TIME
                DY_SPD  = li.1.FF_SPD
            
            else
                
                DY_TIME = (AM_TIME * AM_VOL + 
                           MD_TIME * MD_VOL + 
                           PM_TIME * PM_VOL + 
                           EV_TIME * EV_VOL  ) / DY_VOL
                
                DY_SPD = li.1.DISTANCE / (DY_TIME / 60)
            
            endif  ;DY_VOL<1
            
            ;round daily congested speed & time
            DY_SPD  = ROUND(DY_SPD * 10) / 10
            DY_TIME = ROUND(DY_TIME * 10000) / 10000
            
            
            
            ;calculate VMT
            AM_VMT = ROUND(AM_VOL * li.2.DISTANCE * 100) / 100
            MD_VMT = ROUND(MD_VOL * li.3.DISTANCE * 100) / 100
            PM_VMT = ROUND(PM_VOL * li.4.DISTANCE * 100) / 100
            EV_VMT = ROUND(EV_VOL * li.5.DISTANCE * 100) / 100
            
            DY_VMT = ROUND( (AM_VMT + 
                             MD_VMT + 
                             PM_VMT + 
                             EV_VMT  ) * 100) / 100
            
            
            
            ;calculate VHT
            FF_VHT = ROUND(DY_VOL * (FF_TIME / 60) * 100) / 100
            AM_VHT = ROUND(AM_VOL * (AM_TIME / 60) * 100) / 100
            MD_VHT = ROUND(MD_VOL * (MD_TIME / 60) * 100) / 100
            PM_VHT = ROUND(PM_VOL * (PM_TIME / 60) * 100) / 100
            EV_VHT = ROUND(EV_VOL * (EV_TIME / 60) * 100) / 100
            
            DY_VHT = ROUND( (AM_VHT + 
                             MD_VHT + 
                             PM_VHT + 
                             EV_VHT  ) * 100) / 100
            
            
            
            ;calculate delay (veh-hrs)
            AM_Delay  = ROUND( MAX(0, (AM_TIME - FF_TIME) / 60 * AM_VOL) * 1000) / 1000
            MD_Delay  = ROUND( MAX(0, (MD_TIME - FF_TIME) / 60 * MD_VOL) * 1000) / 1000
            PM_Delay  = ROUND( MAX(0, (PM_TIME - FF_TIME) / 60 * PM_VOL) * 1000) / 1000
            EV_Delay  = ROUND( MAX(0, (EV_TIME - FF_TIME) / 60 * EV_VOL) * 1000) / 1000
            
            DY_Delay  = ROUND( (AM_Delay + 
                                MD_Delay + 
                                PM_Delay + 
                                EV_Delay  ) * 1000) / 1000
            
            
            
            ;calculate buffer time
            ;  (freeway general purpose, Managed Motorways and toll lanes only)
            if (li.1.FT=22-27,32-37,40)
                
                FF_BTI_tme = ROUND(FF_TIME * BTI_pct(1, 0)     * 1000) / 1000
                AM_BTI_tme = ROUND(AM_TIME * BTI_pct(1, AM_VC) * 1000) / 1000
                MD_BTI_tme = ROUND(MD_TIME * BTI_pct(1, MD_VC) * 1000) / 1000
                PM_BTI_tme = ROUND(PM_TIME * BTI_pct(1, PM_VC) * 1000) / 1000
                EV_BTI_tme = ROUND(EV_TIME * BTI_pct(1, EV_VC) * 1000) / 1000
                
            else
                
                FF_BTI_tme = 0
                AM_BTI_tme = 0
                MD_BTI_tme = 0
                PM_BTI_tme = 0
                EV_BTI_tme = 0
                
            endif  ;FT=22-27,32-37,40
            
            ;calculate average daily buffer
            if (DY_VOL<1)
                
                DY_BTI_tme  = FF_BTI_tme
            
            else
                
                DY_BTI_tme = ROUND( (AM_BTI_tme * AM_VOL + 
                                     MD_BTI_tme * MD_VOL + 
                                     PM_BTI_tme * PM_VOL + 
                                     EV_BTI_tme * EV_VOL  ) / DY_VOL * 1000) / 1000
                
            endif  ;DY_VOL<1
            
            
            
            ;calculate truck speed and time
            ;  note: slow down trucks by 3mph for MD, 5mph for HV
            ;    Medium Truck
            ;                   Auto   Truck  Speed   Time 
            ;                   Speed  Speed  Factor  Factor
            ;      Freeway       70      67    0.96    1.04
            ;      Expressway    50      47    0.94    1.06
            ;      Arterial      40      37    0.93    1.08
            ;      Collector     30      27    0.90    1.11
            ;    
            ;    Heavy Truck
            ;                   Auto   Truck  Speed   Time 
            ;                   Speed  Speed  Factor  Factor
            ;      Freeway       70      65    0.93    1.08
            ;      Expressway    50      45    0.90    1.11
            ;      Arterial      40      35    0.88    1.14
            ;      Collector     30      25    0.83    1.20
            
            ;set truck speed (minimum truck speed: MD=4mph, HV=3mph)
            FF_TkSpd_M = ROUND( MAX(4, (FF_SPD - 3)) * 10) / 10
            AM_TkSpd_M = ROUND( MAX(4, (AM_SPD - 3)) * 10) / 10
            MD_TkSpd_M = ROUND( MAX(4, (MD_SPD - 3)) * 10) / 10
            PM_TkSpd_M = ROUND( MAX(4, (PM_SPD - 3)) * 10) / 10
            EV_TkSpd_M = ROUND( MAX(4, (EV_SPD - 3)) * 10) / 10
            
            FF_TkSpd_H = ROUND( MAX(3, (FF_SPD - 5)) * 10) / 10
            AM_TkSpd_H = ROUND( MAX(3, (AM_SPD - 5)) * 10) / 10
            MD_TkSpd_H = ROUND( MAX(3, (MD_SPD - 5)) * 10) / 10
            PM_TkSpd_H = ROUND( MAX(3, (PM_SPD - 5)) * 10) / 10
            EV_TkSpd_H = ROUND( MAX(3, (EV_SPD - 5)) * 10) / 10
            
            ;calculate truck time (in minutes)
            FF_TkTme_M = ROUND(li.1.DISTANCE * 60 / FF_TkSpd_M * 10000) / 10000
            AM_TkTme_M = ROUND(li.1.DISTANCE * 60 / AM_TkSpd_M * 10000) / 10000
            MD_TkTme_M = ROUND(li.2.DISTANCE * 60 / MD_TkSpd_M * 10000) / 10000
            PM_TkTme_M = ROUND(li.3.DISTANCE * 60 / PM_TkSpd_M * 10000) / 10000
            EV_TkTme_M = ROUND(li.4.DISTANCE * 60 / EV_TkSpd_M * 10000) / 10000
                                                                               
            FF_TkTme_H = ROUND(li.1.DISTANCE * 60 / FF_TkSpd_H * 10000) / 10000
            AM_TkTme_H = ROUND(li.1.DISTANCE * 60 / AM_TkSpd_H * 10000) / 10000
            MD_TkTme_H = ROUND(li.2.DISTANCE * 60 / MD_TkSpd_H * 10000) / 10000
            PM_TkTme_H = ROUND(li.3.DISTANCE * 60 / PM_TkSpd_H * 10000) / 10000
            EV_TkTme_H = ROUND(li.4.DISTANCE * 60 / EV_TkSpd_H * 10000) / 10000
            
            ;calculate average daily MD truck time and speed
            if (_DY_Trk_MD<1)
                
                DY_TkTme_M = FF_TkTme_M
                DY_TkSpd_M = FF_TkSpd_M
            
            else
                
                DY_TkTme_M = (AM_TkTme_M * _AM_Trk_MD + 
                              MD_TkTme_M * _MD_Trk_MD + 
                              PM_TkTme_M * _PM_Trk_MD + 
                              EV_TkTme_M * _EV_Trk_MD  ) / _DY_Trk_MD
                
                DY_TkSpd_M = li.1.DISTANCE / (DY_TkTme_M / 60)
            
            endif  ;_DY_Trk_MD<1
            
            ;calculate average daily HV truck time and speed
            if (_DY_Trk_HV<1)
                
                DY_TkTme_H = FF_TkTme_H
                DY_TkSpd_H = FF_TkSpd_H
            
            else
                
                DY_TkTme_H = (AM_TkTme_H * _AM_Trk_HV + 
                              MD_TkTme_H * _MD_Trk_HV + 
                              PM_TkTme_H * _PM_Trk_HV + 
                              EV_TkTme_H * _EV_Trk_HV  ) / _DY_Trk_HV
                
                DY_TkSpd_H = li.1.DISTANCE / (DY_TkTme_H / 60)
            
            endif  ;_DY_Trk_HV<1
            
            ;round MD & HV truck daily congested speed & time
            DY_TkSpd_M = ROUND(DY_TkSpd_M * 10 ) / 10
            DY_TkSpd_H = ROUND(DY_TkSpd_H * 10 ) / 10
            
            DY_TkTme_M = ROUND(DY_TkTme_M * 10000) / 10000
            DY_TkTme_H = ROUND(DY_TkTme_H * 10000) / 10000
            
            
            
            ;calculate total VMT & VHT ---------------------------------------------------
            ;VMT
            _AM_VMT = _AM_VMT + AM_VMT
            _MD_VMT = _MD_VMT + MD_VMT
            _PM_VMT = _PM_VMT + PM_VMT
            _EV_VMT = _EV_VMT + EV_VMT
            
            ;vHT
            _AM_VHT = _AM_VHT + AM_VHT
            _MD_VHT = _MD_VHT + MD_VHT
            _PM_VHT = _PM_VHT + PM_VHT
            _EV_VHT = _EV_VHT + EV_VHT
            
            
            if (li.1.FT=30-42) ;Freeways & ramps
                
                _AM_VMT_FWY = _AM_VMT_FWY + AM_VMT
                _MD_VMT_FWY = _MD_VMT_FWY + MD_VMT
                _PM_VMT_FWY = _PM_VMT_FWY + PM_VMT
                _EV_VMT_FWY = _EV_VMT_FWY + EV_VMT
                
                _AM_VHT_FWY = _AM_VHT_FWY + AM_VHT
                _MD_VHT_FWY = _MD_VHT_FWY + MD_VHT
                _PM_VHT_FWY = _PM_VHT_FWY + PM_VHT
                _EV_VHT_FWY = _EV_VHT_FWY + EV_VHT
                
            elseif (li.1.FT>1) ;all other non-locals 
                
                _AM_VMT_ART = _AM_VMT_ART + AM_VMT
                _MD_VMT_ART = _MD_VMT_ART + MD_VMT
                _PM_VMT_ART = _PM_VMT_ART + PM_VMT
                _EV_VMT_ART = _EV_VMT_ART + EV_VMT
                
                _AM_VHT_ART = _AM_VHT_ART + AM_VHT
                _MD_VHT_ART = _MD_VHT_ART + MD_VHT
                _PM_VHT_ART = _PM_VHT_ART + PM_VHT
                _EV_VHT_ART = _EV_VHT_ART + EV_VHT
            
            endif
            
            
            
            ;add generalized -------------------------------------------------------------
            byGenPurp_ = '__by Generalized Purpose'      ;field name separator
            
            
            AM_PER     = _AM_HBW      +
                         _AM_HBShp    +
                         _AM_HBOth    +
                         _AM_HBSch_Pr +
                         _AM_HBSch_Sc +
                         _AM_HBC      +
                         _AM_NHBW     +
                         _AM_NHBNW     
            
            AM_EXT     = _AM_IX +
                         _AM_XI +
                         _AM_XX  
                       
            AM_CV      = _AM_SLT   
                       
            AM_TRK     = _AM_SMD +
                         _AM_SHV +
                         _AM_LMD +
                         _AM_LHV  
            
            AM_TOT_GEN = AM_PER +
                         AM_EXT +
                         AM_CV  +
                         AM_TRK  
            
            
            MD_PER     = _MD_HBW       +
                         _MD_HBShp     +
                         _MD_HBOth     +
                         _MD_HBSch_Pr  +
                         _MD_HBSch_Sc  +
                         _MD_HBC       +
                         _MD_NHBW      +
                         _MD_NHBNW      
                       
            MD_EXT     = _MD_IX +
                         _MD_XI +
                         _MD_XX  
                       
            MD_CV      = _MD_SLT   
                       
            MD_TRK     = _MD_SMD +
                         _MD_SHV +
                         _MD_LMD +
                         _MD_LHV  
            
            MD_TOT_GEN = MD_PER +
                         MD_EXT +
                         MD_CV  +
                         MD_TRK  
            
            
            PM_PER     = _PM_HBW       +
                         _PM_HBShp     +
                         _PM_HBOth     +
                         _PM_HBSch_Pr  +
                         _PM_HBSch_Sc  +
                         _PM_HBC       +
                         _PM_NHBW      +
                         _PM_NHBNW      
                       
            PM_EXT     = _PM_IX +
                         _PM_XI +
                         _PM_XX  
                       
            PM_CV      = _PM_SLT   
                       
            PM_TRK     = _PM_SMD +
                         _PM_SHV +
                         _PM_LMD +
                         _PM_LHV  
            
            PM_TOT_GEN = PM_PER +
                         PM_EXT +
                         PM_CV  +
                         PM_TRK  
            
            
            EV_PER     = _EV_HBW       +
                         _EV_HBShp     +
                         _EV_HBOth     +
                         _EV_HBSch_Pr  +
                         _EV_HBSch_Sc  +
                         _EV_HBC       +
                         _EV_NHBW      +
                         _EV_NHBNW      
                       
            EV_EXT     = _EV_IX +
                         _EV_XI +
                         _EV_XX  
                       
            EV_CV      = _EV_SLT   
                       
            EV_TRK     = _EV_SMD +
                         _EV_SHV +
                         _EV_LMD +
                         _EV_LHV  
            
            EV_TOT_GEN = EV_PER +
                         EV_EXT +
                         EV_CV  +
                         EV_TRK  
            
            
            DY_PER     = AM_PER  + 
                         MD_PER  + 
                         PM_PER  + 
                         EV_PER   
            
            DY_EXT     = AM_EXT  + 
                         MD_EXT  + 
                         PM_EXT  + 
                         EV_EXT  
            
            DY_CV      = AM_CV   + 
                         MD_CV   + 
                         PM_CV   + 
                         EV_CV      
            
            DY_TRK     = AM_TRK  + 
                         MD_TRK  + 
                         PM_TRK  + 
                         EV_TRK  
            
            DY_TOT_GEN = DY_PER +
                         DY_EXT +
                         DY_CV  +
                         DY_TRK 
            
            
            
            ;add detailed fields ---------------------------------------------------------
            byPURP____ = '__by Purpose'      ;field name separator
            
            
            AM_WRK   = _AM_HBW     
            AM_HBSHp = _AM_HBShp   
            AM_HBOth = _AM_HBOth   
            AM_HBS_P = _AM_HBSch_Pr
            AM_HBS_S = _AM_HBSch_Sc
            AM_HBC   = _AM_HBC     
            AM_NHBW  = _AM_NHBW    
            AM_NHBNW = _AM_NHBNW   
            AM_IX    = _AM_IX      
            AM_XI    = _AM_XI      
            AM_XX    = _AM_XX      
            AM_SLT   = _AM_SLT     
            AM_SMD   = _AM_SMD     
            AM_SHV   = _AM_SHV     
            AM_LMD   = _AM_LMD     
            AM_LHV   = _AM_LHV     
            
            AM_TOT_PUR = AM_WRK   +
                         AM_HBSHp +
                         AM_HBOth +
                         AM_HBS_P +
                         AM_HBS_S +
                         AM_HBC   +
                         AM_NHBW  +
                         AM_NHBNW +
                         AM_IX    +
                         AM_XI    +
                         AM_XX    +
                         AM_SLT   +
                         AM_SMD   +
                         AM_SHV   +
                         AM_LMD   +
                         AM_LHV    
            
            
            MD_WRK   = _MD_HBW     
            MD_HBSHp = _MD_HBShp   
            MD_HBOth = _MD_HBOth   
            MD_HBS_P = _MD_HBSch_Pr
            MD_HBS_S = _MD_HBSch_Sc
            MD_HBC   = _MD_HBC     
            MD_NHBW  = _MD_NHBW    
            MD_NHBNW = _MD_NHBNW   
            MD_IX    = _MD_IX      
            MD_XI    = _MD_XI      
            MD_XX    = _MD_XX      
            MD_SLT   = _MD_SLT     
            MD_SMD   = _MD_SMD     
            MD_SHV   = _MD_SHV     
            MD_LMD   = _MD_LMD     
            MD_LHV   = _MD_LHV     
            
            MD_TOT_PUR = MD_WRK   +
                         MD_HBSHp +
                         MD_HBOth +
                         MD_HBS_P +
                         MD_HBS_S +
                         MD_HBC   +
                         MD_NHBW  +
                         MD_NHBNW +
                         MD_IX    +
                         MD_XI    +
                         MD_XX    +
                         MD_SLT   +
                         MD_SMD   +
                         MD_SHV   +
                         MD_LMD   +
                         MD_LHV    
            
            
            PM_WRK   = _PM_HBW     
            PM_HBSHp = _PM_HBShp   
            PM_HBOth = _PM_HBOth   
            PM_HBS_P = _PM_HBSch_Pr
            PM_HBS_S = _PM_HBSch_Sc
            PM_HBC   = _PM_HBC     
            PM_NHBW  = _PM_NHBW    
            PM_NHBNW = _PM_NHBNW   
            PM_IX    = _PM_IX      
            PM_XI    = _PM_XI      
            PM_XX    = _PM_XX      
            PM_SLT   = _PM_SLT     
            PM_SMD   = _PM_SMD     
            PM_SHV   = _PM_SHV     
            PM_LMD   = _PM_LMD     
            PM_LHV   = _PM_LHV     
            
            PM_TOT_PUR = PM_WRK   +
                         PM_HBSHp +
                         PM_HBOth +
                         PM_HBS_P +
                         PM_HBS_S +
                         PM_HBC   +
                         PM_NHBW  +
                         PM_NHBNW +
                         PM_IX    +
                         PM_XI    +
                         PM_XX    +
                         PM_SLT   +
                         PM_SMD   +
                         PM_SHV   +
                         PM_LMD   +
                         PM_LHV    
            
            
            EV_WRK   = _EV_HBW     
            EV_HBSHp = _EV_HBShp   
            EV_HBOth = _EV_HBOth   
            EV_HBS_P = _EV_HBSch_Pr
            EV_HBS_S = _EV_HBSch_Sc
            EV_HBC   = _EV_HBC     
            EV_NHBW  = _EV_NHBW    
            EV_NHBNW = _EV_NHBNW   
            EV_IX    = _EV_IX      
            EV_XI    = _EV_XI      
            EV_XX    = _EV_XX      
            EV_SLT   = _EV_SLT     
            EV_SMD   = _EV_SMD     
            EV_SHV   = _EV_SHV     
            EV_LMD   = _EV_LMD     
            EV_LHV   = _EV_LHV     
            
            EV_TOT_PUR = EV_WRK   +
                         EV_HBSHp +
                         EV_HBOth +
                         EV_HBS_P +
                         EV_HBS_S +
                         EV_HBC   +
                         EV_NHBW  +
                         EV_NHBNW +
                         EV_IX    +
                         EV_XI    +
                         EV_XX    +
                         EV_SLT   +
                         EV_SMD   +
                         EV_SHV   +
                         EV_LMD   +
                         EV_LHV    
            
            
            DY_WRK   = AM_WRK   + MD_WRK   + PM_WRK   + EV_WRK   
            DY_HBSHp = AM_HBSHp + MD_HBSHp + PM_HBSHp + EV_HBSHp 
            DY_HBOth = AM_HBOth + MD_HBOth + PM_HBOth + EV_HBOth 
            DY_HBS_P = AM_HBS_P + MD_HBS_P + PM_HBS_P + EV_HBS_P 
            DY_HBS_S = AM_HBS_S + MD_HBS_S + PM_HBS_S + EV_HBS_S 
            DY_HBC   = AM_HBC   + MD_HBC   + PM_HBC   + EV_HBC   
            DY_NHBW  = AM_NHBW  + MD_NHBW  + PM_NHBW  + EV_NHBW  
            DY_NHBNW = AM_NHBNW + MD_NHBNW + PM_NHBNW + EV_NHBNW 
            DY_IX    = AM_IX    + MD_IX    + PM_IX    + EV_IX    
            DY_XI    = AM_XI    + MD_XI    + PM_XI    + EV_XI    
            DY_XX    = AM_XX    + MD_XX    + PM_XX    + EV_XX    
            DY_SLT   = AM_SLT   + MD_SLT   + PM_SLT   + EV_SLT    
            DY_SMD   = AM_SMD   + MD_SMD   + PM_SMD   + EV_SMD    
            DY_SHV   = AM_SHV   + MD_SHV   + PM_SHV   + EV_SHV    
            DY_LMD   = AM_LMD   + MD_LMD   + PM_LMD   + EV_LMD    
            DY_LHV   = AM_LHV   + MD_LHV   + PM_LHV   + EV_LHV    
            
            DY_TOT_PUR = DY_WRK   +
                         DY_HBSHp +
                         DY_HBOth +
                         DY_HBS_P +
                         DY_HBS_S +
                         DY_HBC   +
                         DY_NHBW  +
                         DY_NHBNW +
                         DY_IX    +
                         DY_XI    +
                         DY_XX    +
                         DY_SLT   +
                         DY_SMD   +
                         DY_SHV   +
                         DY_LMD   +
                         DY_LHV    
            
            
            AM_TUNIQUE = _AM_TTUNIQUE
            MD_TUNIQUE = _MD_TTUNIQUE
            PM_TUNIQUE = _PM_TTUNIQUE
            EV_TUNIQUE = _EV_TTUNIQUE
            
            AM_TelHBW  = _AM_Tel_HBW 
            MD_TelHBW  = _MD_Tel_HBW 
            PM_TelHBW  = _PM_Tel_HBW 
            EV_TelHBW  = _EV_Tel_HBW 
            
            AM_TelNHBW = _AM_Tel_NHBW
            MD_TelNHBW = _MD_Tel_NHBW
            PM_TelNHBW = _PM_Tel_NHBW
            EV_TelNHBW = _EV_Tel_NHBW
            
        ENDPHASE
        
    ENDRUN
    
    
    
    ;calculate network statistics
    if (n=1)
        
        ;separate header from other print statements to overwrite previous file (e.g. no APPEND=T statement)
        RUN PGM=MATRIX
            
            ZONES=1
            
            ;print data summary to csv file for iter 1
            PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Loaded Net - @RID@.csv',
                CSV=T,
                FORM=15.0,
                LIST='Scenario'      ,
                     'Iter'          ,
                     'period'        ,
                     
                     'ConvLinks'     ,
                     'TotLinks'      ,
                     'PctConv'       ,
                     
                     'VMT'           ,
                     'VMT_Fwy'       ,
                     'VMT_Art'       ,
                     'PctDif_VMT'    ,
                     'PctDif_VMT_Fwy',
                     'PctDif_VMT_Art',
                     'VHT'           ,
                     'VHT_Fwy'       ,
                     'VHT_Art'       ,
                     'PctDif_VHT'    ,
                     'PctDif_VHT_Fwy',
                     'PctDif_VHT_Art',
                     
                     'AvgSpeed'      ,
                     'AvgSpeed_Fwy'  ,
                     'AvgSpeed_Art'  
            
        ENDRUN
        
        
        
        RUN PGM=NETWORK MSG='Distrib: FB Loop @n@ - Step 5: Calculate Volume Difference'
            
            FILEI NETI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_tmp.net'
            
            FILEO NETO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_convg.net'
            
            
            ZONES   = @Usedzones@
            
            
            PHASE=LINKMERGE
                
                ;calculate total VMT & VHT -------------------------------------------------------------------
                ;VMT
                _AM_VMT_Cur = _AM_VMT_Cur + li.1.AM_VMT
                _MD_VMT_Cur = _MD_VMT_Cur + li.1.MD_VMT
                _PM_VMT_Cur = _PM_VMT_Cur + li.1.PM_VMT
                _EV_VMT_Cur = _EV_VMT_Cur + li.1.EV_VMT
                
                _AM_VMT_Pre = 0
                _MD_VMT_Pre = 0
                _PM_VMT_Pre = 0
                _EV_VMT_Pre = 0
                
                
                ;vHT
                _AM_VHT_Cur = _AM_VHT_Cur + li.1.AM_VHT
                _MD_VHT_Cur = _MD_VHT_Cur + li.1.MD_VHT
                _PM_VHT_Cur = _PM_VHT_Cur + li.1.PM_VHT
                _EV_VHT_Cur = _EV_VHT_Cur + li.1.EV_VHT
                
                _AM_VHT_Pre = 0
                _MD_VHT_Pre = 0
                _PM_VHT_Pre = 0
                _EV_VHT_Pre = 0
                
                
                if (li.1.FT=30-42) ;Freeways & ramps
                    
                    _AM_VMT_FWY_Cur = _AM_VMT_FWY_Cur + li.1.AM_VMT
                    _MD_VMT_FWY_Cur = _MD_VMT_FWY_Cur + li.1.MD_VMT
                    _PM_VMT_FWY_Cur = _PM_VMT_FWY_Cur + li.1.PM_VMT
                    _EV_VMT_FWY_Cur = _EV_VMT_FWY_Cur + li.1.EV_VMT
                    
                    _AM_VMT_FWY_Pre = 0
                    _MD_VMT_FWY_Pre = 0
                    _PM_VMT_FWY_Pre = 0
                    _EV_VMT_FWY_Pre = 0
                    
                    
                    _AM_VHT_FWY_Cur = _AM_VHT_FWY_Cur + li.1.AM_VHT
                    _MD_VHT_FWY_Cur = _MD_VHT_FWY_Cur + li.1.MD_VHT
                    _PM_VHT_FWY_Cur = _PM_VHT_FWY_Cur + li.1.PM_VHT
                    _EV_VHT_FWY_Cur = _EV_VHT_FWY_Cur + li.1.EV_VHT
                    
                    _AM_VHT_FWY_Pre = 0
                    _MD_VHT_FWY_Pre = 0
                    _PM_VHT_FWY_Pre = 0
                    _EV_VHT_FWY_Pre = 0
                    
                    
                elseif (li.1.FT>1) ;all other non-locals 
                    
                    _AM_VMT_ART_Cur = _AM_VMT_ART_Cur + li.1.AM_VMT
                    _MD_VMT_ART_Cur = _MD_VMT_ART_Cur + li.1.MD_VMT
                    _PM_VMT_ART_Cur = _PM_VMT_ART_Cur + li.1.PM_VMT
                    _EV_VMT_ART_Cur = _EV_VMT_ART_Cur + li.1.EV_VMT
                    
                    _AM_VMT_ART_Pre = 0
                    _MD_VMT_ART_Pre = 0
                    _PM_VMT_ART_Pre = 0
                    _EV_VMT_ART_Pre = 0
                    
                    
                    _AM_VHT_ART_Cur = _AM_VHT_ART_Cur + li.1.AM_VHT
                    _MD_VHT_ART_Cur = _MD_VHT_ART_Cur + li.1.MD_VHT
                    _PM_VHT_ART_Cur = _PM_VHT_ART_Cur + li.1.PM_VHT
                    _EV_VHT_ART_Cur = _EV_VHT_ART_Cur + li.1.EV_VHT
                    
                    _AM_VHT_ART_Pre = 0
                    _MD_VHT_ART_Pre = 0
                    _PM_VHT_ART_Pre = 0
                    _EV_VHT_ART_Pre = 0
                    
                endif
                
                
                
                ;calculate change in link volume
                ;process only highway links (ignore centroid connectors)
                if (li.1.FT>1)
                    
                    ;count total number of links
                    _TOTLNKS = _TOTLNKS + 1
                    
                    
                    ;include these variables in output net
                    AM_Cur = li.1.AM_VOL
                    MD_Cur = li.1.MD_VOL
                    PM_Cur = li.1.PM_VOL
                    EV_Cur = li.1.EV_VOL
                    DY_Cur = li.1.DY_VOL
                    
                    AM_Pre = 0
                    MD_Pre = 0
                    PM_Pre = 0
                    EV_Pre = 0
                    DY_Pre = 0
                    
                    AM_Diff = 0
                    MD_Diff = 0
                    PM_Diff = 0
                    EV_Diff = 0
                    DY_Diff = 0
                    
                    ;calculate % difference
                    AM_PctDiff = 1
                    MD_PctDiff = 1
                    PM_PctDiff = 1
                    EV_PctDiff = 1
                    DY_PctDiff = 1
                                        
                    ;sum links meeting convergence criteria
                    _AM_COUNT = 0
                    _MD_COUNT = 0
                    _PM_COUNT = 0
                    _EV_COUNT = 0
                    _DY_COUNT = 0
                    
                    ;for daily converged links, put flag on output network to track congergence
                    CONVLINK = 0
                    
                endif  ;li.2.FT>1
                
            ENDPHASE
            
            
            
            PHASE=SUMMARY
                
                ;calculate daily VMT & VHT
                _DY_VMT_Cur = _AM_VMT_Cur +
                              _MD_VMT_Cur +
                              _PM_VMT_Cur +
                              _EV_VMT_Cur 
                
                
                _DY_VMT_FWY_Cur = _AM_VMT_FWY_Cur +
                                  _MD_VMT_FWY_Cur +
                                  _PM_VMT_FWY_Cur +
                                  _EV_VMT_FWY_Cur 
                
                
                _DY_VMT_ART_Cur = _AM_VMT_ART_Cur +
                                  _MD_VMT_ART_Cur +
                                  _PM_VMT_ART_Cur +
                                  _EV_VMT_ART_Cur 
                
                
                
                _DY_VHT_Cur = _AM_VHT_Cur +
                              _MD_VHT_Cur +
                              _PM_VHT_Cur +
                              _EV_VHT_Cur 
                
                
                _DY_VHT_FWY_Cur = _AM_VHT_FWY_Cur +
                                  _MD_VHT_FWY_Cur +
                                  _PM_VHT_FWY_Cur +
                                  _EV_VHT_FWY_Cur 
                
                
                _DY_VHT_ART_Cur = _AM_VHT_ART_Cur +
                                  _MD_VHT_ART_Cur +
                                  _PM_VHT_ART_Cur +
                                  _EV_VHT_ART_Cur 
                
                
                ;calculate average speed
                _AM_AvgSpd = _AM_VMT_Cur / _AM_VHT_Cur
                _MD_AvgSpd = _MD_VMT_Cur / _MD_VHT_Cur
                _PM_AvgSpd = _PM_VMT_Cur / _PM_VHT_Cur
                _EV_AvgSpd = _EV_VMT_Cur / _EV_VHT_Cur
                _DY_AvgSpd = _DY_VMT_Cur / _DY_VHT_Cur
                
                _AM_AvgSpd_FWY = _AM_VMT_FWY_Cur / _AM_VHT_FWY_Cur
                _MD_AvgSpd_FWY = _MD_VMT_FWY_Cur / _MD_VHT_FWY_Cur
                _PM_AvgSpd_FWY = _PM_VMT_FWY_Cur / _PM_VHT_FWY_Cur
                _EV_AvgSpd_FWY = _EV_VMT_FWY_Cur / _EV_VHT_FWY_Cur
                _DY_AvgSpd_FWY = _DY_VMT_FWY_Cur / _DY_VHT_FWY_Cur
                
                _AM_AvgSpd_ART = _AM_VMT_ART_Cur / _AM_VHT_ART_Cur
                _MD_AvgSpd_ART = _MD_VMT_ART_Cur / _MD_VHT_ART_Cur
                _PM_AvgSpd_ART = _PM_VMT_ART_Cur / _PM_VHT_ART_Cur
                _EV_AvgSpd_ART = _EV_VMT_ART_Cur / _EV_VHT_ART_Cur
                _DY_AvgSpd_ART = _DY_VMT_ART_Cur / _DY_VHT_ART_Cur
               
               
                ;calculate VMT & VHT % change from last iteration
                _AM_PCT_VMT = 0
                _MD_PCT_VMT = 0
                _PM_PCT_VMT = 0
                _EV_PCT_VMT = 0
                _DY_PCT_VMT = 0
                
                _AM_PCT_VMT_FWY = 0
                _MD_PCT_VMT_FWY = 0
                _PM_PCT_VMT_FWY = 0
                _EV_PCT_VMT_FWY = 0
                _DY_PCT_VMT_FWY = 0
                                                                                     
                _AM_PCT_VMT_ART = 0
                _MD_PCT_VMT_ART = 0
                _PM_PCT_VMT_ART = 0
                _EV_PCT_VMT_ART = 0
                _DY_PCT_VMT_ART = 0
                
                
                _AM_PCT_VHT = 0
                _MD_PCT_VHT = 0
                _PM_PCT_VHT = 0
                _EV_PCT_VHT = 0
                _DY_PCT_VHT = 0
                
                _AM_PCT_VHT_FWY = 0
                _MD_PCT_VHT_FWY = 0
                _PM_PCT_VHT_FWY = 0
                _EV_PCT_VHT_FWY = 0
                _DY_PCT_VHT_FWY = 0
                                                                                     
                _AM_PCT_VHT_ART = 0
                _MD_PCT_VHT_ART = 0
                _PM_PCT_VHT_ART = 0
                _EV_PCT_VHT_ART = 0
                _DY_PCT_VHT_ART = 0
                
                
                ;calculate % of links that are converged
                _AM_PCT_COUNT = 0
                _MD_PCT_COUNT = 0
                _PM_PCT_COUNT = 0
                _EV_PCT_COUNT = 0
                _DY_PCT_COUNT = 0
                
                
                
                ;print summary for iterations 2+ to LOG file
                PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
                    APPEND=T,
                    FORM=13.0C,
                    LIST='\n  VMT & VHT',
                         '\n                    VMT', '      VMT_Fwy', '      VMT_Art', '          VHT', '      VHT_Fwy', '      VHT_Art', '       AvgSpd', '   AvgSpd_Fwy', '   AvgSpd_Art',
                         '\n    AM    ',  _AM_VMT_Cur,  _AM_VMT_FWY_Cur,  _AM_VMT_ART_Cur,   _AM_VHT_Cur,  _AM_VHT_FWY_Cur,  _AM_VHT_ART_Cur,   _AM_AvgSpd(13.2),  _AM_AvgSpd_FWY(13.2),  _AM_AvgSpd_ART(13.2),
                         '\n    MD    ',  _MD_VMT_Cur,  _MD_VMT_FWY_Cur,  _MD_VMT_ART_Cur,   _MD_VHT_Cur,  _MD_VHT_FWY_Cur,  _MD_VHT_ART_Cur,   _MD_AvgSpd(13.2),  _MD_AvgSpd_FWY(13.2),  _MD_AvgSpd_ART(13.2),
                         '\n    PM    ',  _PM_VMT_Cur,  _PM_VMT_FWY_Cur,  _PM_VMT_ART_Cur,   _PM_VHT_Cur,  _PM_VHT_FWY_Cur,  _PM_VHT_ART_Cur,   _PM_AvgSpd(13.2),  _PM_AvgSpd_FWY(13.2),  _PM_AvgSpd_ART(13.2),
                         '\n    EV    ',  _EV_VMT_Cur,  _EV_VMT_FWY_Cur,  _EV_VMT_ART_Cur,   _EV_VHT_Cur,  _EV_VHT_FWY_Cur,  _EV_VHT_ART_Cur,   _EV_AvgSpd(13.2),  _EV_AvgSpd_FWY(13.2),  _EV_AvgSpd_ART(13.2),
                         '\n    DY    ',  _DY_VMT_Cur,  _DY_VMT_FWY_Cur,  _DY_VMT_ART_Cur,   _DY_VHT_Cur,  _DY_VHT_FWY_Cur,  _DY_VHT_ART_Cur,   _DY_AvgSpd(13.2),  _DY_AvgSpd_FWY(13.2),  _DY_AvgSpd_ART(13.2)
                
                
                
                ;print data summary to csv file for iterations 2+
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Loaded Net - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=15.0,
                    LIST='@ScenarioDir@'          ,
                         @n@(5.0)                 ,
                         'AM'                     ,
                         _AM_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _AM_PCT_COUNT*100(5.2)   ,
                         _AM_VMT_Cur              ,
                         _AM_VMT_FWY_Cur          ,
                         _AM_VMT_ART_Cur          ,
                         _AM_PCT_VMT(12.2)        ,
                         _AM_PCT_VMT_FWY(12.2)    ,
                         _AM_PCT_VMT_ART(12.2)    ,
                         _AM_VHT_Cur              ,
                         _AM_VHT_FWY_Cur          ,
                         _AM_VHT_ART_Cur          ,
                         _AM_PCT_VHT(12.2)        ,
                         _AM_PCT_VHT_FWY(12.2)    ,
                         _AM_PCT_VHT_ART(12.2)    ,
                         _AM_AvgSpd(6.2)          ,
                         _AM_AvgSpd_FWY(6.2)      ,
                         _AM_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'MD'                     ,
                         _MD_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _MD_PCT_COUNT*100(5.2)   ,
                         _MD_VMT_Cur              ,
                         _MD_VMT_FWY_Cur          ,
                         _MD_VMT_ART_Cur          ,
                         _MD_PCT_VMT(12.2)        ,
                         _MD_PCT_VMT_FWY(12.2)    ,
                         _MD_PCT_VMT_ART(12.2)    ,
                         _MD_VHT_Cur              ,
                         _MD_VHT_FWY_Cur          ,
                         _MD_VHT_ART_Cur          ,
                         _MD_PCT_VHT(12.2)        ,
                         _MD_PCT_VHT_FWY(12.2)    ,
                         _MD_PCT_VHT_ART(12.2)    ,
                         _MD_AvgSpd(6.2)          ,
                         _MD_AvgSpd_FWY(6.2)      ,
                         _MD_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'PM'                     ,
                         _PM_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _PM_PCT_COUNT*100(5.2)   ,
                         _PM_VMT_Cur              ,
                         _PM_VMT_FWY_Cur          ,
                         _PM_VMT_ART_Cur          ,
                         _PM_PCT_VMT(12.2)        ,
                         _PM_PCT_VMT_FWY(12.2)    ,
                         _PM_PCT_VMT_ART(12.2)    ,
                         _PM_VHT_Cur              ,
                         _PM_VHT_FWY_Cur          ,
                         _PM_VHT_ART_Cur          ,
                         _PM_PCT_VHT(12.2)        ,
                         _PM_PCT_VHT_FWY(12.2)    ,
                         _PM_PCT_VHT_ART(12.2)    ,
                         _PM_AvgSpd(6.2)          ,
                         _PM_AvgSpd_FWY(6.2)      ,
                         _PM_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'EV'                     ,
                         _EV_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _EV_PCT_COUNT*100(5.2)   ,
                         _EV_VMT_Cur              ,
                         _EV_VMT_FWY_Cur          ,
                         _EV_VMT_ART_Cur          ,
                         _EV_PCT_VMT(12.2)        ,
                         _EV_PCT_VMT_FWY(12.2)    ,
                         _EV_PCT_VMT_ART(12.2)    ,
                         _EV_VHT_Cur              ,
                         _EV_VHT_FWY_Cur          ,
                         _EV_VHT_ART_Cur          ,
                         _EV_PCT_VHT(12.2)        ,
                         _EV_PCT_VHT_FWY(12.2)    ,
                         _EV_PCT_VHT_ART(12.2)    ,
                         _EV_AvgSpd(6.2)          ,
                         _EV_AvgSpd_FWY(6.2)      ,
                         _EV_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'DY'                     ,
                         _DY_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _DY_PCT_COUNT*100(5.2)   ,
                         _DY_VMT_Cur              ,
                         _DY_VMT_FWY_Cur          ,
                         _DY_VMT_ART_Cur          ,
                         _DY_PCT_VMT(12.2)        ,
                         _DY_PCT_VMT_FWY(12.2)    ,
                         _DY_PCT_VMT_ART(12.2)    ,
                         _DY_VHT_Cur              ,
                         _DY_VHT_FWY_Cur          ,
                         _DY_VHT_ART_Cur          ,
                         _DY_PCT_VHT(12.2)        ,
                         _DY_PCT_VHT_FWY(12.2)    ,
                         _DY_PCT_VHT_ART(12.2)    ,
                         _DY_AvgSpd(6.2)          ,
                         _DY_AvgSpd_FWY(6.2)      ,
                         _DY_AvgSpd_ART(6.2)      
                
            ENDPHASE
            
        ENDRUN
        
        
    else
        
        RUN PGM=NETWORK MSG='Distrib: FB Loop @n@ - Step 5: Calculate Volume Difference'
            
            FILEI NETI[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_tmp.net'
            FILEI NETI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n_1@_tmp.net'
            
            FILEO NETO = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_convg.net'
            
            
            ZONES   = @Usedzones@
            
            
            PHASE=LINKMERGE
                
                ;calculate total VMT & VHT -------------------------------------------------------------------
                ;VMT
                _AM_VMT_Cur = _AM_VMT_Cur + li.1.AM_VMT
                _MD_VMT_Cur = _MD_VMT_Cur + li.1.MD_VMT
                _PM_VMT_Cur = _PM_VMT_Cur + li.1.PM_VMT
                _EV_VMT_Cur = _EV_VMT_Cur + li.1.EV_VMT
                
                _AM_VMT_Pre = _AM_VMT_Pre + li.2.AM_VMT
                _MD_VMT_Pre = _MD_VMT_Pre + li.2.MD_VMT
                _PM_VMT_Pre = _PM_VMT_Pre + li.2.PM_VMT
                _EV_VMT_Pre = _EV_VMT_Pre + li.2.EV_VMT
                
                
                ;vHT
                _AM_VHT_Cur = _AM_VHT_Cur + li.1.AM_VHT
                _MD_VHT_Cur = _MD_VHT_Cur + li.1.MD_VHT
                _PM_VHT_Cur = _PM_VHT_Cur + li.1.PM_VHT
                _EV_VHT_Cur = _EV_VHT_Cur + li.1.EV_VHT
                
                _AM_VHT_Pre = _AM_VHT_Pre + li.2.AM_VHT
                _MD_VHT_Pre = _MD_VHT_Pre + li.2.MD_VHT
                _PM_VHT_Pre = _PM_VHT_Pre + li.2.PM_VHT
                _EV_VHT_Pre = _EV_VHT_Pre + li.2.EV_VHT
                
                
                if (li.1.FT=30-42) ;Freeways & ramps
                    
                    _AM_VMT_FWY_Cur = _AM_VMT_FWY_Cur + li.1.AM_VMT
                    _MD_VMT_FWY_Cur = _MD_VMT_FWY_Cur + li.1.MD_VMT
                    _PM_VMT_FWY_Cur = _PM_VMT_FWY_Cur + li.1.PM_VMT
                    _EV_VMT_FWY_Cur = _EV_VMT_FWY_Cur + li.1.EV_VMT
                    
                    _AM_VMT_FWY_Pre = _AM_VMT_FWY_Pre + li.2.AM_VMT
                    _MD_VMT_FWY_Pre = _MD_VMT_FWY_Pre + li.2.MD_VMT
                    _PM_VMT_FWY_Pre = _PM_VMT_FWY_Pre + li.2.PM_VMT
                    _EV_VMT_FWY_Pre = _EV_VMT_FWY_Pre + li.2.EV_VMT
                    
                    
                    _AM_VHT_FWY_Cur = _AM_VHT_FWY_Cur + li.1.AM_VHT
                    _MD_VHT_FWY_Cur = _MD_VHT_FWY_Cur + li.1.MD_VHT
                    _PM_VHT_FWY_Cur = _PM_VHT_FWY_Cur + li.1.PM_VHT
                    _EV_VHT_FWY_Cur = _EV_VHT_FWY_Cur + li.1.EV_VHT
                    
                    _AM_VHT_FWY_Pre = _AM_VHT_FWY_Pre + li.2.AM_VHT
                    _MD_VHT_FWY_Pre = _MD_VHT_FWY_Pre + li.2.MD_VHT
                    _PM_VHT_FWY_Pre = _PM_VHT_FWY_Pre + li.2.PM_VHT
                    _EV_VHT_FWY_Pre = _EV_VHT_FWY_Pre + li.2.EV_VHT
                    
                    
                elseif (li.1.FT>1) ;all other non-locals 
                    
                    _AM_VMT_ART_Cur = _AM_VMT_ART_Cur + li.1.AM_VMT
                    _MD_VMT_ART_Cur = _MD_VMT_ART_Cur + li.1.MD_VMT
                    _PM_VMT_ART_Cur = _PM_VMT_ART_Cur + li.1.PM_VMT
                    _EV_VMT_ART_Cur = _EV_VMT_ART_Cur + li.1.EV_VMT
                    
                    _AM_VMT_ART_Pre = _AM_VMT_ART_Pre + li.2.AM_VMT
                    _MD_VMT_ART_Pre = _MD_VMT_ART_Pre + li.2.MD_VMT
                    _PM_VMT_ART_Pre = _PM_VMT_ART_Pre + li.2.PM_VMT
                    _EV_VMT_ART_Pre = _EV_VMT_ART_Pre + li.2.EV_VMT
                    
                    
                    _AM_VHT_ART_Cur = _AM_VHT_ART_Cur + li.1.AM_VHT
                    _MD_VHT_ART_Cur = _MD_VHT_ART_Cur + li.1.MD_VHT
                    _PM_VHT_ART_Cur = _PM_VHT_ART_Cur + li.1.PM_VHT
                    _EV_VHT_ART_Cur = _EV_VHT_ART_Cur + li.1.EV_VHT
                    
                    _AM_VHT_ART_Pre = _AM_VHT_ART_Pre + li.2.AM_VHT
                    _MD_VHT_ART_Pre = _MD_VHT_ART_Pre + li.2.MD_VHT
                    _PM_VHT_ART_Pre = _PM_VHT_ART_Pre + li.2.PM_VHT
                    _EV_VHT_ART_Pre = _EV_VHT_ART_Pre + li.2.EV_VHT
                    
                endif
                
                
                
                ;calculate change in link volume
                ;process only highway links (ignore centroid connectors)
                if (li.1.FT>1)
                    
                    ;count total number of links
                    _TOTLNKS = _TOTLNKS + 1
                    
                    
                    ;include these variables in output net
                    AM_Cur = li.1.AM_VOL
                    MD_Cur = li.1.MD_VOL
                    PM_Cur = li.1.PM_VOL
                    EV_Cur = li.1.EV_VOL
                    DY_Cur = li.1.DY_VOL
                    
                    AM_Pre = li.2.AM_VOL
                    MD_Pre = li.2.MD_VOL
                    PM_Pre = li.2.PM_VOL
                    EV_Pre = li.2.EV_VOL
                    DY_Pre = li.2.DY_VOL
                    
                    AM_Diff = AM_Cur - AM_Pre
                    MD_Diff = MD_Cur - MD_Pre
                    PM_Diff = PM_Cur - PM_Pre
                    EV_Diff = EV_Cur - EV_Pre
                    DY_Diff = DY_Cur - DY_Pre
                    
                    
                    ;calculate % difference
                    if (AM_Cur>0 & AM_Pre>0)  AM_PctDiff = ABS(AM_Diff) / AM_Pre
                    if (MD_Cur>0 & MD_Pre>0)  MD_PctDiff = ABS(MD_Diff) / MD_Pre
                    if (PM_Cur>0 & PM_Pre>0)  PM_PctDiff = ABS(PM_Diff) / PM_Pre
                    if (EV_Cur>0 & EV_Pre>0)  EV_PctDiff = ABS(EV_Diff) / EV_Pre
                    if (DY_Cur>0 & DY_Pre>0)  DY_PctDiff = ABS(DY_Diff) / DY_Pre
                    
                    if (AM_Cur=0 & AM_Pre>0)  AM_PctDiff = 1    ;mark as not converged
                    if (MD_Cur=0 & MD_Pre>0)  MD_PctDiff = 1
                    if (PM_Cur=0 & PM_Pre>0)  PM_PctDiff = 1
                    if (EV_Cur=0 & EV_Pre>0)  EV_PctDiff = 1
                    if (DY_Cur=0 & DY_Pre>0)  DY_PctDiff = 1
                    
                    if (AM_Cur>0 & AM_Pre=0)  AM_PctDiff = 1    ;mark as not converged
                    if (MD_Cur>0 & MD_Pre=0)  MD_PctDiff = 1
                    if (PM_Cur>0 & PM_Pre=0)  PM_PctDiff = 1
                    if (EV_Cur>0 & EV_Pre=0)  EV_PctDiff = 1
                    if (DY_Cur>0 & DY_Pre=0)  DY_PctDiff = 1
                    
                    if (AM_Cur=0 & AM_Pre=0)  AM_PctDiff = 0    ;mark as converged
                    if (MD_Cur=0 & MD_Pre=0)  MD_PctDiff = 0
                    if (PM_Cur=0 & PM_Pre=0)  PM_PctDiff = 0
                    if (EV_Cur=0 & EV_Pre=0)  EV_PctDiff = 0
                    if (DY_Cur=0 & DY_Pre=0)  DY_PctDiff = 0
                    
                    
                    ;sum links meeting convergence criteria
                    _ConvThreshold = 0.075
                    
                    if (AM_PctDiff<=_ConvThreshold)  _AM_COUNT = _AM_COUNT + 1
                    if (MD_PctDiff<=_ConvThreshold)  _MD_COUNT = _MD_COUNT + 1
                    if (PM_PctDiff<=_ConvThreshold)  _PM_COUNT = _PM_COUNT + 1
                    if (EV_PctDiff<=_ConvThreshold)  _EV_COUNT = _EV_COUNT + 1
                    if (DY_PctDiff<=_ConvThreshold)  _DY_COUNT = _DY_COUNT + 1
                    
                    
                    ;for daily converged links, put flag on output network to track congergence
                    if (DY_PctDiff<=_ConvThreshold)  CONVLINK = 1
                    
                endif  ;li.1.FT>1
                
            ENDPHASE
            
            
            
            PHASE=SUMMARY
                
                ;calculate daily VMT & VHT
                _DY_VMT_Cur = _AM_VMT_Cur +
                              _MD_VMT_Cur +
                              _PM_VMT_Cur +
                              _EV_VMT_Cur 
                
                _DY_VMT_Pre = _AM_VMT_Pre +
                              _MD_VMT_Pre +
                              _PM_VMT_Pre +
                              _EV_VMT_Pre 
                
                
                _DY_VMT_FWY_Cur = _AM_VMT_FWY_Cur +
                                  _MD_VMT_FWY_Cur +
                                  _PM_VMT_FWY_Cur +
                                  _EV_VMT_FWY_Cur 
                
                _DY_VMT_FWY_Pre = _AM_VMT_FWY_Pre +
                                  _MD_VMT_FWY_Pre +
                                  _PM_VMT_FWY_Pre +
                                  _EV_VMT_FWY_Pre 
                
                
                _DY_VMT_ART_Cur = _AM_VMT_ART_Cur +
                                  _MD_VMT_ART_Cur +
                                  _PM_VMT_ART_Cur +
                                  _EV_VMT_ART_Cur 
                
                _DY_VMT_ART_Pre = _AM_VMT_ART_Pre +
                                  _MD_VMT_ART_Pre +
                                  _PM_VMT_ART_Pre +
                                  _EV_VMT_ART_Pre 
                
                
                
                _DY_VHT_Cur = _AM_VHT_Cur +
                              _MD_VHT_Cur +
                              _PM_VHT_Cur +
                              _EV_VHT_Cur 
                
                _DY_VHT_Pre = _AM_VHT_Pre +
                              _MD_VHT_Pre +
                              _PM_VHT_Pre +
                              _EV_VHT_Pre 
                
                
                _DY_VHT_FWY_Cur = _AM_VHT_FWY_Cur +
                                  _MD_VHT_FWY_Cur +
                                  _PM_VHT_FWY_Cur +
                                  _EV_VHT_FWY_Cur 
                
                _DY_VHT_FWY_Pre = _AM_VHT_FWY_Pre +
                                  _MD_VHT_FWY_Pre +
                                  _PM_VHT_FWY_Pre +
                                  _EV_VHT_FWY_Pre 
                
                
                _DY_VHT_ART_Cur = _AM_VHT_ART_Cur +
                                  _MD_VHT_ART_Cur +
                                  _PM_VHT_ART_Cur +
                                  _EV_VHT_ART_Cur 
                
                _DY_VHT_ART_Pre = _AM_VHT_ART_Pre +
                                  _MD_VHT_ART_Pre +
                                  _PM_VHT_ART_Pre +
                                  _EV_VHT_ART_Pre 
                
                
                ;calculate average speed
                _AM_AvgSpd = _AM_VMT_Cur / _AM_VHT_Cur
                _MD_AvgSpd = _MD_VMT_Cur / _MD_VHT_Cur
                _PM_AvgSpd = _PM_VMT_Cur / _PM_VHT_Cur
                _EV_AvgSpd = _EV_VMT_Cur / _EV_VHT_Cur
                _DY_AvgSpd = _DY_VMT_Cur / _DY_VHT_Cur
                
                _AM_AvgSpd_FWY = _AM_VMT_FWY_Cur / _AM_VHT_FWY_Cur
                _MD_AvgSpd_FWY = _MD_VMT_FWY_Cur / _MD_VHT_FWY_Cur
                _PM_AvgSpd_FWY = _PM_VMT_FWY_Cur / _PM_VHT_FWY_Cur
                _EV_AvgSpd_FWY = _EV_VMT_FWY_Cur / _EV_VHT_FWY_Cur
                _DY_AvgSpd_FWY = _DY_VMT_FWY_Cur / _DY_VHT_FWY_Cur
                
                _AM_AvgSpd_ART = _AM_VMT_ART_Cur / _AM_VHT_ART_Cur
                _MD_AvgSpd_ART = _MD_VMT_ART_Cur / _MD_VHT_ART_Cur
                _PM_AvgSpd_ART = _PM_VMT_ART_Cur / _PM_VHT_ART_Cur
                _EV_AvgSpd_ART = _EV_VMT_ART_Cur / _EV_VHT_ART_Cur
                _DY_AvgSpd_ART = _DY_VMT_ART_Cur / _DY_VHT_ART_Cur
               
               
                ;calculate VMT & VHT % change from last iteration
                _AM_PCT_VMT = (_AM_VMT_Cur - _AM_VMT_Pre) / _AM_VMT_Pre * 100
                _MD_PCT_VMT = (_MD_VMT_Cur - _MD_VMT_Pre) / _MD_VMT_Pre * 100
                _PM_PCT_VMT = (_PM_VMT_Cur - _PM_VMT_Pre) / _PM_VMT_Pre * 100
                _EV_PCT_VMT = (_EV_VMT_Cur - _EV_VMT_Pre) / _EV_VMT_Pre * 100
                _DY_PCT_VMT = (_DY_VMT_Cur - _DY_VMT_Pre) / _DY_VMT_Pre * 100
                
                _AM_PCT_VMT_FWY = (_AM_VMT_FWY_Cur - _AM_VMT_FWY_Pre) / _AM_VMT_FWY_Pre * 100
                _MD_PCT_VMT_FWY = (_MD_VMT_FWY_Cur - _MD_VMT_FWY_Pre) / _MD_VMT_FWY_Pre * 100
                _PM_PCT_VMT_FWY = (_PM_VMT_FWY_Cur - _PM_VMT_FWY_Pre) / _PM_VMT_FWY_Pre * 100
                _EV_PCT_VMT_FWY = (_EV_VMT_FWY_Cur - _EV_VMT_FWY_Pre) / _EV_VMT_FWY_Pre * 100
                _DY_PCT_VMT_FWY = (_DY_VMT_FWY_Cur - _DY_VMT_FWY_Pre) / _DY_VMT_FWY_Pre * 100
                                                                                     
                _AM_PCT_VMT_ART = (_AM_VMT_ART_Cur - _AM_VMT_ART_Pre) / _AM_VMT_ART_Pre * 100
                _MD_PCT_VMT_ART = (_MD_VMT_ART_Cur - _MD_VMT_ART_Pre) / _MD_VMT_ART_Pre * 100
                _PM_PCT_VMT_ART = (_PM_VMT_ART_Cur - _PM_VMT_ART_Pre) / _PM_VMT_ART_Pre * 100
                _EV_PCT_VMT_ART = (_EV_VMT_ART_Cur - _EV_VMT_ART_Pre) / _EV_VMT_ART_Pre * 100
                _DY_PCT_VMT_ART = (_DY_VMT_ART_Cur - _DY_VMT_ART_Pre) / _DY_VMT_ART_Pre * 100
                
                
                _AM_PCT_VHT = (_AM_VHT_Cur - _AM_VHT_Pre) / _AM_VHT_Pre * 100
                _MD_PCT_VHT = (_MD_VHT_Cur - _MD_VHT_Pre) / _MD_VHT_Pre * 100
                _PM_PCT_VHT = (_PM_VHT_Cur - _PM_VHT_Pre) / _PM_VHT_Pre * 100
                _EV_PCT_VHT = (_EV_VHT_Cur - _EV_VHT_Pre) / _EV_VHT_Pre * 100
                _DY_PCT_VHT = (_DY_VHT_Cur - _DY_VHT_Pre) / _DY_VHT_Pre * 100
                
                _AM_PCT_VHT_FWY = (_AM_VHT_FWY_Cur - _AM_VHT_FWY_Pre) / _AM_VHT_FWY_Pre * 100
                _MD_PCT_VHT_FWY = (_MD_VHT_FWY_Cur - _MD_VHT_FWY_Pre) / _MD_VHT_FWY_Pre * 100
                _PM_PCT_VHT_FWY = (_PM_VHT_FWY_Cur - _PM_VHT_FWY_Pre) / _PM_VHT_FWY_Pre * 100
                _EV_PCT_VHT_FWY = (_EV_VHT_FWY_Cur - _EV_VHT_FWY_Pre) / _EV_VHT_FWY_Pre * 100
                _DY_PCT_VHT_FWY = (_DY_VHT_FWY_Cur - _DY_VHT_FWY_Pre) / _DY_VHT_FWY_Pre * 100
                                                                                     
                _AM_PCT_VHT_ART = (_AM_VHT_ART_Cur - _AM_VHT_ART_Pre) / _AM_VHT_ART_Pre * 100
                _MD_PCT_VHT_ART = (_MD_VHT_ART_Cur - _MD_VHT_ART_Pre) / _MD_VHT_ART_Pre * 100
                _PM_PCT_VHT_ART = (_PM_VHT_ART_Cur - _PM_VHT_ART_Pre) / _PM_VHT_ART_Pre * 100
                _EV_PCT_VHT_ART = (_EV_VHT_ART_Cur - _EV_VHT_ART_Pre) / _EV_VHT_ART_Pre * 100
                _DY_PCT_VHT_ART = (_DY_VHT_ART_Cur - _DY_VHT_ART_Pre) / _DY_VHT_ART_Pre * 100
                
                
                ;calculate % of links that are converged
                _AM_PCT_COUNT = _AM_COUNT / _TOTLNKS
                _MD_PCT_COUNT = _MD_COUNT / _TOTLNKS
                _PM_PCT_COUNT = _PM_COUNT / _TOTLNKS
                _EV_PCT_COUNT = _EV_COUNT / _TOTLNKS
                _DY_PCT_COUNT = _DY_COUNT / _TOTLNKS
                
                
                
                ;print summary for iterations 2+ to LOG file
                PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
                    APPEND=T,
                    FORM=13.0C,
                    LIST='\n  VMT & VHT',
                         '\n                    VMT', '      VMT_Fwy', '      VMT_Art', '          VHT', '      VHT_Fwy', '      VHT_Art', '       AvgSpd', '   AvgSpd_Fwy', '   AvgSpd_Art',
                         '\n    AM    ',  _AM_VMT_Cur,  _AM_VMT_FWY_Cur,  _AM_VMT_ART_Cur,   _AM_VHT_Cur,  _AM_VHT_FWY_Cur,  _AM_VHT_ART_Cur,   _AM_AvgSpd(13.2),  _AM_AvgSpd_FWY(13.2),  _AM_AvgSpd_ART(13.2),
                         '\n    MD    ',  _MD_VMT_Cur,  _MD_VMT_FWY_Cur,  _MD_VMT_ART_Cur,   _MD_VHT_Cur,  _MD_VHT_FWY_Cur,  _MD_VHT_ART_Cur,   _MD_AvgSpd(13.2),  _MD_AvgSpd_FWY(13.2),  _MD_AvgSpd_ART(13.2),
                         '\n    PM    ',  _PM_VMT_Cur,  _PM_VMT_FWY_Cur,  _PM_VMT_ART_Cur,   _PM_VHT_Cur,  _PM_VHT_FWY_Cur,  _PM_VHT_ART_Cur,   _PM_AvgSpd(13.2),  _PM_AvgSpd_FWY(13.2),  _PM_AvgSpd_ART(13.2),
                         '\n    EV    ',  _EV_VMT_Cur,  _EV_VMT_FWY_Cur,  _EV_VMT_ART_Cur,   _EV_VHT_Cur,  _EV_VHT_FWY_Cur,  _EV_VHT_ART_Cur,   _EV_AvgSpd(13.2),  _EV_AvgSpd_FWY(13.2),  _EV_AvgSpd_ART(13.2),
                         '\n    DY    ',  _DY_VMT_Cur,  _DY_VMT_FWY_Cur,  _DY_VMT_ART_Cur,   _DY_VHT_Cur,  _DY_VHT_FWY_Cur,  _DY_VHT_ART_Cur,   _DY_AvgSpd(13.2),  _DY_AvgSpd_FWY(13.2),  _DY_AvgSpd_ART(13.2),
                         '\n',
                         '\n  % Change          VMT', '      VMT_Fwy', '      VMT_Art', '          VHT', '      VHT_Fwy', '      VHT_Art',
                         '\n    AM    ', _AM_PCT_VMT(12.2), '%', _AM_PCT_VMT_FWY(12.2), '%', _AM_PCT_VMT_ART(12.2), '%', _AM_PCT_VHT(12.2), '%', _AM_PCT_VHT_FWY(12.2), '%', _AM_PCT_VHT_ART(12.2), '%',
                         '\n    MD    ', _MD_PCT_VMT(12.2), '%', _MD_PCT_VMT_FWY(12.2), '%', _MD_PCT_VMT_ART(12.2), '%', _MD_PCT_VHT(12.2), '%', _MD_PCT_VHT_FWY(12.2), '%', _MD_PCT_VHT_ART(12.2), '%',
                         '\n    PM    ', _PM_PCT_VMT(12.2), '%', _PM_PCT_VMT_FWY(12.2), '%', _PM_PCT_VMT_ART(12.2), '%', _PM_PCT_VHT(12.2), '%', _PM_PCT_VHT_FWY(12.2), '%', _PM_PCT_VHT_ART(12.2), '%',
                         '\n    EV    ', _EV_PCT_VMT(12.2), '%', _EV_PCT_VMT_FWY(12.2), '%', _EV_PCT_VMT_ART(12.2), '%', _EV_PCT_VHT(12.2), '%', _EV_PCT_VHT_FWY(12.2), '%', _EV_PCT_VHT_ART(12.2), '%',
                         '\n    DY    ', _DY_PCT_VMT(12.2), '%', _DY_PCT_VMT_FWY(12.2), '%', _DY_PCT_VMT_ART(12.2), '%', _DY_PCT_VHT(12.2), '%', _DY_PCT_VHT_FWY(12.2), '%', _DY_PCT_VHT_ART(12.2), '%',
                         '\n',
                         '\n  Converged Links',
                         '\n             Count Conv', '    Hwy Links', '      % of Tot',
                         '\n    AM    ', _AM_COUNT, _TOTLNKS, _AM_PCT_COUNT*100(13.2), '%',
                         '\n    MD    ', _MD_COUNT, _TOTLNKS, _MD_PCT_COUNT*100(13.2), '%',
                         '\n    PM    ', _PM_COUNT, _TOTLNKS, _PM_PCT_COUNT*100(13.2), '%',
                         '\n    EV    ', _EV_COUNT, _TOTLNKS, _EV_PCT_COUNT*100(13.2), '%',
                         '\n    DY    ', _DY_COUNT, _TOTLNKS, _DY_PCT_COUNT*100(13.2), '%'
                
                
                
                ;print data summary to csv file for iterations 2+
                PRINT FILE = '@ParentDir@@ScenarioDir@3_Distribute\_Stats - Distrib Loaded Net - @RID@.csv',
                    APPEND=T,
                    CSV=T,
                    FORM=15.0,
                    LIST='@ScenarioDir@'          ,
                         @n@(5.0)                 ,
                         'AM'                     ,
                         _AM_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _AM_PCT_COUNT*100(5.2)   ,
                         _AM_VMT_Cur              ,
                         _AM_VMT_FWY_Cur          ,
                         _AM_VMT_ART_Cur          ,
                         _AM_PCT_VMT(12.2)        ,
                         _AM_PCT_VMT_FWY(12.2)    ,
                         _AM_PCT_VMT_ART(12.2)    ,
                         _AM_VHT_Cur              ,
                         _AM_VHT_FWY_Cur          ,
                         _AM_VHT_ART_Cur          ,
                         _AM_PCT_VHT(12.2)        ,
                         _AM_PCT_VHT_FWY(12.2)    ,
                         _AM_PCT_VHT_ART(12.2)    ,
                         _AM_AvgSpd(6.2)          ,
                         _AM_AvgSpd_FWY(6.2)      ,
                         _AM_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'MD'                     ,
                         _MD_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _MD_PCT_COUNT*100(5.2)   ,
                         _MD_VMT_Cur              ,
                         _MD_VMT_FWY_Cur          ,
                         _MD_VMT_ART_Cur          ,
                         _MD_PCT_VMT(12.2)        ,
                         _MD_PCT_VMT_FWY(12.2)    ,
                         _MD_PCT_VMT_ART(12.2)    ,
                         _MD_VHT_Cur              ,
                         _MD_VHT_FWY_Cur          ,
                         _MD_VHT_ART_Cur          ,
                         _MD_PCT_VHT(12.2)        ,
                         _MD_PCT_VHT_FWY(12.2)    ,
                         _MD_PCT_VHT_ART(12.2)    ,
                         _MD_AvgSpd(6.2)          ,
                         _MD_AvgSpd_FWY(6.2)      ,
                         _MD_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'PM'                     ,
                         _PM_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _PM_PCT_COUNT*100(5.2)   ,
                         _PM_VMT_Cur              ,
                         _PM_VMT_FWY_Cur          ,
                         _PM_VMT_ART_Cur          ,
                         _PM_PCT_VMT(12.2)        ,
                         _PM_PCT_VMT_FWY(12.2)    ,
                         _PM_PCT_VMT_ART(12.2)    ,
                         _PM_VHT_Cur              ,
                         _PM_VHT_FWY_Cur          ,
                         _PM_VHT_ART_Cur          ,
                         _PM_PCT_VHT(12.2)        ,
                         _PM_PCT_VHT_FWY(12.2)    ,
                         _PM_PCT_VHT_ART(12.2)    ,
                         _PM_AvgSpd(6.2)          ,
                         _PM_AvgSpd_FWY(6.2)      ,
                         _PM_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'EV'                     ,
                         _EV_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _EV_PCT_COUNT*100(5.2)   ,
                         _EV_VMT_Cur              ,
                         _EV_VMT_FWY_Cur          ,
                         _EV_VMT_ART_Cur          ,
                         _EV_PCT_VMT(12.2)        ,
                         _EV_PCT_VMT_FWY(12.2)    ,
                         _EV_PCT_VMT_ART(12.2)    ,
                         _EV_VHT_Cur              ,
                         _EV_VHT_FWY_Cur          ,
                         _EV_VHT_ART_Cur          ,
                         _EV_PCT_VHT(12.2)        ,
                         _EV_PCT_VHT_FWY(12.2)    ,
                         _EV_PCT_VHT_ART(12.2)    ,
                         _EV_AvgSpd(6.2)          ,
                         _EV_AvgSpd_FWY(6.2)      ,
                         _EV_AvgSpd_ART(6.2)      ,
                         
                         '\n@ScenarioDir@'        ,
                         @n@(5.0)                 ,
                         'DY'                     ,
                         _DY_COUNT(9.0)           ,
                         _TOTLNKS(9.0)            ,
                         _DY_PCT_COUNT*100(5.2)   ,
                         _DY_VMT_Cur              ,
                         _DY_VMT_FWY_Cur          ,
                         _DY_VMT_ART_Cur          ,
                         _DY_PCT_VMT(12.2)        ,
                         _DY_PCT_VMT_FWY(12.2)    ,
                         _DY_PCT_VMT_ART(12.2)    ,
                         _DY_VHT_Cur              ,
                         _DY_VHT_FWY_Cur          ,
                         _DY_VHT_ART_Cur          ,
                         _DY_PCT_VHT(12.2)        ,
                         _DY_PCT_VHT_FWY(12.2)    ,
                         _DY_PCT_VHT_ART(12.2)    ,
                         _DY_AvgSpd(6.2)          ,
                         _DY_AvgSpd_FWY(6.2)      ,
                         _DY_AvgSpd_ART(6.2)      
                
                
                
                ;use daily percentage of converged network links as convergence criteria and log variable 
                _PctNetConv = _DY_PCT_COUNT
                LOG VAR=_PctNetConv
                
            ENDPHASE
            
        ENDRUN
        
    endif  ;n=1
    
    
    
    ;print time stamp
    RUN PGM=MATRIX
    
        ZONES = 1
        
        SubScriptEndTime_SN = currenttime()
        SubScriptRunTime_SN = SubScriptEndTime_SN - @SubScriptStartTime_SN@
        
        SubScriptEndTime_FB = currenttime()
        SubScriptRunTime_FB = SubScriptEndTime_FB - @SubScriptStartTime_FB@
        
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
            APPEND=T,
            LIST='\n            Summarize networks  ', formatdatetime(SubScriptRunTime_SN, 40, 0, 'hhh:nn:ss'),
                 '\n',
                 '\n            Total FB Loop @n@     ', formatdatetime(SubScriptRunTime_FB, 40, 0, 'hhh:nn:ss')
        
    ENDRUN
    
    
    
    
    ;CHECK FEEDBACK LOOP CONVERGENCE =======================================================================================================
        
    ;test for feedback convergence
    if (MATRIX.PctMatConv>=0.95  &  NETWORK._PctNetConv>=0.95)
        
        FB_Loop_Converged = 1
        BREAK
        
    else
        
        FB_Loop_Converged = 0
        
    endif
    
    
ENDLOOP  ;end feedback loop


;reset n to max iterations if no convergence reached
if (FB_Loop_Converged=0)  n=n-1




;SUMMARIZE FINAL NET AND TRIP TABLE MATRACIES ==============================================================================================

;get start time
SubScriptStartTime_FN = currenttime()


;Cluster: distribute NETWORK call onto processor 2
DistributeMultiStep Alias='FinNet_Proc2'
    
    ;copy distribution network from temp folder
    RUN PGM=NETWORK  MSG='Distribution: Copy Distribution Network from Temp Folder'
    FILEI NETI = '@ParentDir@@ScenarioDir@Temp\3_Distribute\@RID@_@n@_convg.net'
    
    FILEO NODEO = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Node_tmp.dbf'
    
    FILEO LINKO = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Link_tmp.dbf',
        INCLUDE=A               ,
                B               ,
                DISTANCE        ,
                STREET          ,
                ONEWAY          ,
                EXTERNAL        ,
                LANES           ,
                FT              ,
                SFAC(10.3)      ,
                CFAC(10.3)      ,
                TRK_RSTRCT      ,
                HOV_LYEAR       ,
                Op_Proj         ,
                Rel_Ln          ,
                SEL_LINK        ,
                
                LINKID          ,
                TAZID           ,
                SEGID(20)       ,
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
                CO_NAME(20)     ,
                CITY_FIPS       ,
                CITY_UGRC       ,
                CITY_NAME(40)   ,
                DISTLRG         ,
                DLRG_NAME(60)   ,
                DISTMED         ,
                DMED_NAME(60)   ,
                DISTSML         ,
                DSML_NAME(60)   ,
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
                
                AM_VOL(10.1)    ,
                MD_VOL(10.1)    ,
                PM_VOL(10.1)    ,
                EV_VOL(10.1)    ,
                DY_VOL(10.1)    ,
                DY_VOL2WY(10.1) ,
                DY_1k(10.1)     ,
                DY_1k_2wy(10.1) ,
                
                AM_VC(10.3)     ,
                MD_VC(10.3)     ,
                PM_VC(10.3)     ,
                EV_VC(10.3)     ,
                
                FF_SPD(10.1)    ,
                AM_SPD(10.1)    ,
                MD_SPD(10.1)    ,
                PM_SPD(10.1)    ,
                EV_SPD(10.1)    ,
                DY_SPD(10.1)    ,
                FF_TkSpd_M(10.1),
                AM_TkSpd_M(10.1),
                MD_TkSpd_M(10.1),
                PM_TkSpd_M(10.1),
                EV_TkSpd_M(10.1),
                DY_TkSpd_M(10.1),
                FF_TkSpd_H(10.1),
                AM_TkSpd_H(10.1),
                MD_TkSpd_H(10.1),
                PM_TkSpd_H(10.1),
                EV_TkSpd_H(10.1),
                DY_TkSpd_H(10.1),
                
                FF_TIME(10.4)   ,
                AM_TIME(10.4)   ,
                MD_TIME(10.4)   ,
                PM_TIME(10.4)   ,
                EV_TIME(10.4)   ,
                DY_TIME(10.4)   ,
                FF_TkTme_M(10.4),
                AM_TkTme_M(10.4),
                MD_TkTme_M(10.4),
                PM_TkTme_M(10.4),
                EV_TkTme_M(10.4),
                DY_TkTme_M(10.4),
                FF_TkTme_H(10.4),
                AM_TkTme_H(10.4),
                MD_TkTme_H(10.4),
                PM_TkTme_H(10.4),
                EV_TkTme_H(10.4),
                DY_TkTme_H(10.4),
                
                AM_VMT(10.2)    ,
                MD_VMT(10.2)    ,
                PM_VMT(10.2)    ,
                EV_VMT(10.2)    ,
                DY_VMT(10.2)    ,
                
                FF_VHT(10.2)    ,
                AM_VHT(10.2)    ,
                MD_VHT(10.2)    ,
                PM_VHT(10.2)    ,
                EV_VHT(10.2)    ,
                DY_VHT(10.2)    ,
                
                AM_DELAY(10.3)  ,
                MD_DELAY(10.3)  ,
                PM_DELAY(10.3)  ,
                EV_DELAY(10.3)  ,
                DY_DELAY(10.3)  ,
                
                FF_BTI_TME(10.2),
                AM_BTI_TME(10.2),
                MD_BTI_TME(10.2),
                PM_BTI_TME(10.2),
                EV_BTI_TME(10.2),
                DY_BTI_TME(10.2),
                
                byGenPurp_      ,
                AM_PER(10.1)    ,
                AM_EXT(10.1)    ,
                AM_CV(10.1)     ,
                AM_TRK(10.1)    ,
                AM_TOT_GEN(10.1),
                MD_PER(10.1)    ,
                MD_EXT(10.1)    ,
                MD_CV(10.1)     ,
                MD_TRK(10.1)    ,
                MD_TOT_GEN(10.1),
                PM_PER(10.1)    ,
                PM_EXT(10.1)    ,
                PM_CV(10.1)     ,
                PM_TRK(10.1)    ,
                PM_TOT_GEN(10.1),
                EV_PER(10.1)    ,
                EV_EXT(10.1)    ,
                EV_CV(10.1)     ,
                EV_TRK(10.1)    ,
                EV_TOT_GEN(10.1),
                DY_PER(10.1)    ,
                DY_EXT(10.1)    ,
                DY_CV(10.1)     ,
                DY_TRK(10.1)    ,
                DY_TOT_GEN(10.1),
                
                byPURP____      ,
                AM_WRK(10.1)    ,
                AM_HBSHp(10.1)  ,
                AM_HBOth(10.1)  ,
                AM_HBS_P(10.1)  ,
                AM_HBS_S(10.1)  ,
                AM_HBC(10.1)    ,
                AM_NHBW(10.1)   ,
                AM_NHBNW(10.1)  ,
                AM_IX(10.1)     ,
                AM_XI(10.1)     ,
                AM_XX(10.1)     ,
                AM_SLT(10.1)    ,
                AM_SMD(10.1)    ,
                AM_SHV(10.1)    ,
                AM_LMD(10.1)    ,
                AM_LHV(10.1)    ,
                AM_TOT_PUR(10.1),
                
                MD_WRK(10.1)    ,
                MD_HBSHp(10.1)  ,
                MD_HBOth(10.1)  ,
                MD_HBS_P(10.1)  ,
                MD_HBS_S(10.1)  ,
                MD_HBC(10.1)    ,
                MD_NHBW(10.1)   ,
                MD_NHBNW(10.1)  ,
                MD_IX(10.1)     ,
                MD_XI(10.1)     ,
                MD_XX(10.1)     ,
                MD_SLT(10.1)    ,
                MD_SMD(10.1)    ,
                MD_SHV(10.1)    ,
                MD_LMD(10.1)    ,
                MD_LHV(10.1)    ,
                MD_TOT_PUR(10.1),
                
                PM_WRK(10.1)    ,
                PM_HBSHp(10.1)  ,
                PM_HBOth(10.1)  ,
                PM_HBS_P(10.1)  ,
                PM_HBS_S(10.1)  ,
                PM_HBC(10.1)    ,
                PM_NHBW(10.1)   ,
                PM_NHBNW(10.1)  ,
                PM_IX(10.1)     ,
                PM_XI(10.1)     ,
                PM_XX(10.1)     ,
                PM_SLT(10.1)    ,
                PM_SMD(10.1)    ,
                PM_SHV(10.1)    ,
                PM_LMD(10.1)    ,
                PM_LHV(10.1)    ,
                PM_TOT_PUR(10.1),
                
                EV_WRK(10.1)    ,
                EV_HBSHp(10.1)  ,
                EV_HBOth(10.1)  ,
                EV_HBS_P(10.1)  ,
                EV_HBS_S(10.1)  ,
                EV_HBC(10.1)    ,
                EV_NHBW(10.1)   ,
                EV_NHBNW(10.1)  ,
                EV_IX(10.1)     ,
                EV_XI(10.1)     ,
                EV_XX(10.1)     ,
                EV_SLT(10.1)    ,
                EV_SMD(10.1)    ,
                EV_SHV(10.1)    ,
                EV_LMD(10.1)    ,
                EV_LHV(10.1)    ,
                EV_TOT_PUR(10.1),
                
                DY_WRK(10.1)    ,
                DY_HBSHp(10.1)  ,
                DY_HBOth(10.1)  ,
                DY_HBS_P(10.1)  ,
                DY_HBS_S(10.1)  ,
                DY_HBC(10.1)    ,
                DY_NHBW(10.1)   ,
                DY_NHBNW(10.1)  ,
                DY_IX(10.1)     ,
                DY_XI(10.1)     ,
                DY_XX(10.1)     ,
                DY_SLT(10.1)    ,
                DY_SMD(10.1)    ,
                DY_SHV(10.1)    ,
                DY_LMD(10.1)    ,
                DY_LHV(10.1)    ,
                DY_TOT_PUR(10.1),
                
                AM_TUNIQUE(10.1),
                MD_TUNIQUE(10.1),
                PM_TUNIQUE(10.1),
                EV_TUNIQUE(10.1),
                AM_TelHBW(10.1) ,
                MD_TelHBW(10.1) ,
                PM_TelHBW(10.1) ,
                EV_TelHBW(10.1) ,
                AM_TelNHBW(10.1),
                MD_TelNHBW(10.1),
                PM_TelNHBW(10.1),
                EV_TelNHBW(10.1)
            
        ZONES   = @Usedzones@
        
    ENDRUN
    
;Cluster: end of group distributed to processor 2
EndDistributeMULTISTEP





;Cluster: keep processing on processor 1 (Main)
    ;copy final PA table to Do directory
    RUN PGM=MATRIX  MSG='Distribution: Summarize Final PA Trip Table'
    
        ;copy out averaged P/A matrices (for use in Mode Choice or Assign w/o Mode Choice)
        FILEI MATI[1]='@ParentDir@@ScenarioDir@Temp\3_Distribute\pa_AllPurp_@n@_tmp.mtx' 
              
        FILEO MATO[1]='@ParentDir@@ScenarioDir@3_Distribute\PA_AllPurp_GRAVITY.mtx',
                mo=100-116, 120-124, 130-133, 141-146,
                name=TOT      ,
                     HBW      ,
                     HBShp    ,
                     HBOth    ,
                     HBSch_Pr ,
                     HBSch_Sc ,
                     HBC      ,
                     NHBW     ,
                     NHBNW    ,
                     IX       ,
                     XI       ,
                     XX       ,
                     SH_LT    ,
                     SH_MD    ,
                     SH_HV    ,
                     Ext_MD   ,
                     Ext_HV   ,
                     
                     HBSch    ,
                     HBO      ,
                     NHB      ,
                     TTUNIQUE ,
                     HBOthnTT ,
                     
                     Tot_HBW  ,
                     Tel_HBW  ,
                     Tot_NHBW ,
                     Tel_NHBW ,
                 
                     IX_MD    ,
                     XI_MD    ,
                     XX_MD    ,
                     IX_HV    ,
                     XI_HV    ,
                     XX_HV    


        
             RECO[1]='@ParentDir@@ScenarioDir@3_Distribute\_checkPABalance.dbf', 
                 FORM=10.1,
                 FIELDS=Z(10.0),
                      TotPer_P,    TotPer_A,
                         HBW_P,       HBW_A,
                       HBShp_P,     HBShp_A,
                       HBOth_P,     HBOth_A,
                    HBSch_Pr_P,  HBSch_Pr_A,
                    HBSch_Sc_P,  HBSch_Sc_A,
                         HBC_P,       HBC_A,
                        NHBW_P,      NHBW_A,
                       NHBNW_P,     NHBNW_A,
                       
                      TotExt_P,    TotExt_A,
                          IX_P,        IX_A,
                          XI_P,        XI_A,
                          XX_P,        XX_A,
                          
                      TotTrk_P,    TotTrk_A,
                       SH_LT_P,     SH_LT_A,
                       SH_MD_P,     SH_MD_A,
                       SH_HV_P,     SH_HV_A,
                      Ext_MD_P,    Ext_MD_A,
                      Ext_HV_P,    Ext_HV_A,
                      
                       HBSch_P,     HBSch_A,
                         HBO_P,       HBO_A,
                         NHB_P,       NHB_A,
                    TTUNIQUE_P,  TTUNIQUE_A,
                    HBOthnTT_P,  HBOthnTT_A,
                        
                     Tot_HBW_P,   Tot_HBW_A,
                     Tel_HBW_P,   Tel_HBW_A,
                    Tot_NHBW_P,  Tot_NHBW_A,
                    Tel_NHBW_P,  Tel_NHBW_A,
                      
                      TG_Per_P,    TG_Per_A,
                     TG_IXXI_P,   TG_IXXI_A,
                      TG_Trk_P,    TG_Trk_A
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        
        ;fill working matrices -------------------------------------------------------------------------------
        mw[100] = mi.1.TOT
        mw[101] = mi.1.HBW
        mw[102] = mi.1.HBShp
        mw[103] = mi.1.HBOth
        mw[104] = mi.1.HBSch_Pr
        mw[105] = mi.1.HBSch_Sc
        mw[106] = mi.1.HBC
        mw[107] = mi.1.NHBW
        mw[108] = mi.1.NHBNW
        mw[109] = mi.1.IX
        mw[110] = mi.1.XI
        mw[111] = mi.1.XX
        mw[112] = mi.1.SH_LT
        mw[113] = mi.1.SH_MD
        mw[114] = mi.1.SH_HV
        mw[115] = mi.1.Ext_MD
        mw[116] = mi.1.Ext_HV
        
        mw[120] = mi.1.HBSch
        mw[121] = mi.1.HBO
        mw[122] = mi.1.NHB
        mw[123] = mi.1.TTUNIQUE
        mw[124] = mi.1.HBOthnTT
        
        mw[130] = mi.1.Tot_HBW 
        mw[131] = mi.1.Tel_HBW 
        mw[132] = mi.1.Tot_NHBW
        mw[133] = mi.1.Tel_NHBW
                
        mw[141] = mi.1.IX_MD
        mw[142] = mi.1.XI_MD
        mw[143] = mi.1.XX_MD
        mw[144] = mi.1.IX_HV
        mw[145] = mi.1.XI_HV
        mw[146] = mi.1.XX_HV
        
        
        mw[200] = mi.1.TOT.T
        mw[201] = mi.1.HBW.T
        mw[202] = mi.1.HBShp.T
        mw[203] = mi.1.HBOth.T
        mw[204] = mi.1.HBSch_Pr.T
        mw[205] = mi.1.HBSch_Sc.T
        mw[206] = mi.1.HBC.T
        mw[207] = mi.1.NHBW.T
        mw[208] = mi.1.NHBNW.T
        mw[209] = mi.1.IX.T
        mw[210] = mi.1.XI.T
        mw[211] = mi.1.XX.T
        mw[212] = mi.1.SH_LT.T
        mw[213] = mi.1.SH_MD.T
        mw[214] = mi.1.SH_HV.T
        mw[215] = mi.1.Ext_MD.T
        mw[216] = mi.1.Ext_HV.T
        
        mw[220] = mi.1.HBSch.T
        mw[221] = mi.1.HBO.T
        mw[222] = mi.1.NHB.T
        mw[223] = mi.1.TTUNIQUE.T
        mw[224] = mi.1.HBOthnTT.T
        
        mw[230] = mi.1.Tot_HBW.T 
        mw[231] = mi.1.Tel_HBW.T 
        mw[232] = mi.1.Tot_NHBW.T
        mw[233] = mi.1.Tel_NHBW.T
        
        
        
        ;calculate P & A row/column sums ---------------------------------------------------------------------
        ;P's
        RO.HBW_P      = rowsum(101)
        RO.HBShp_P    = rowsum(102)
        RO.HBOth_P    = rowsum(103)
        RO.HBSch_Pr_P = rowsum(104)
        RO.HBSch_Sc_P = rowsum(105)
        RO.HBC_P      = rowsum(106)
        RO.NHBW_P     = rowsum(107)
        RO.NHBNW_P    = rowsum(108)
        RO.IX_P       = rowsum(109)
        RO.XI_P       = rowsum(110)
        RO.XX_P       = rowsum(111)
        RO.SH_LT_P    = rowsum(112)
        RO.SH_MD_P    = rowsum(113)
        RO.SH_HV_P    = rowsum(114)
        RO.Ext_MD_P   = rowsum(115)
        RO.Ext_HV_P   = rowsum(116)
        
        RO.HBSch_P    = rowsum(120)
        RO.HBO_P      = rowsum(121)
        RO.NHB_P      = rowsum(122)
        RO.TTUNIQUE_P = rowsum(123)
        RO.HBOthnTT_P = rowsum(124)
        
        RO.Tot_HBW_P  = rowsum(130)
        RO.Tel_HBW_P  = rowsum(131)
        RO.Tot_NHBW_P = rowsum(132)
        RO.Tel_NHBW_P = rowsum(133)
        
        
        RO.TotPer_P  = RO.HBW_P      +
                       RO.HBShp_P    +
                       RO.HBOth_P    +
                       RO.HBSch_Pr_P +
                       RO.HBSch_Sc_P +
                       RO.HBC_P      +
                       RO.NHBW_P     +
                       RO.NHBNW_P    
        
        
        RO.TotExt_P  = RO.IX_P +
                       RO.XI_P +
                       RO.XX_P 
        
        
        RO.TotTrk_P  = RO.SH_LT_P  +
                       RO.SH_MD_P  +
                       RO.SH_HV_P  +
                       RO.Ext_MD_P +
                       RO.Ext_HV_P 
        
        
        RO.TG_Per_P  = RO.Tot_HBW_P  +          ;use HBW with telecommute
                       RO.HBShp_P    +
                       RO.HBOthnTT_P +          ;use HBOth without TTUNIQUE
                       RO.HBSch_Pr_P +
                       RO.HBSch_Sc_P +
                       RO.HBC_P      +
                       RO.Tot_NHBW_P +          ;use NHBW with telecommute
                       RO.NHBNW_P    
        
        
        RO.TG_IXXI_P = RO.IX_P +                ;exclude XX
                       RO.XI_P 
        
        
        RO.TG_Trk_P  = RO.SH_LT_P  +            ;exclude Ext_MD_P & Ext_HV_P
                       RO.SH_MD_P  +
                       RO.SH_HV_P  
        
        
        ;A's
        RO.HBW_A      = rowsum(201)
        RO.HBShp_A    = rowsum(202)
        RO.HBOth_A    = rowsum(203)
        RO.HBSch_Pr_A = rowsum(204)
        RO.HBSch_Sc_A = rowsum(205)
        RO.HBC_A      = rowsum(206)
        RO.NHBW_A     = rowsum(207)
        RO.NHBNW_A    = rowsum(208)
        RO.IX_A       = rowsum(209)
        RO.XI_A       = rowsum(210)
        RO.XX_A       = rowsum(211)
        RO.SH_LT_A    = rowsum(212)
        RO.SH_MD_A    = rowsum(213)
        RO.SH_HV_A    = rowsum(214)
        RO.Ext_MD_A   = rowsum(215)
        RO.Ext_HV_A   = rowsum(216)
        
        RO.HBSch_A    = rowsum(220)
        RO.HBO_A      = rowsum(221)
        RO.NHB_A      = rowsum(222)
        RO.TTUNIQUE_A = rowsum(223)
        RO.HBOthnTT_A = rowsum(224)
        
        RO.Tot_HBW_A  = rowsum(230)
        RO.Tel_HBW_A  = rowsum(231)
        RO.Tot_NHBW_A = rowsum(232)
        RO.Tel_NHBW_A = rowsum(233)
        
        
        RO.TotPer_A  = RO.HBW_A      +
                       RO.HBShp_A    +
                       RO.HBOth_A    +
                       RO.HBSch_Pr_A +
                       RO.HBSch_Sc_A +
                       RO.HBC_A      +
                       RO.NHBW_A     +
                       RO.NHBNW_A    
        
        
        RO.TotExt_A  = RO.IX_A +
                       RO.XI_A +
                       RO.XX_A 
        
        
        RO.TotTrk_A  = RO.SH_LT_A  +
                       RO.SH_MD_A  +
                       RO.SH_HV_A  +
                       RO.Ext_MD_A +
                       RO.Ext_HV_A 
        
        
        RO.TG_Per_A  = RO.Tot_HBW_A  +          ;use HBW with telecommute
                       RO.HBShp_A    +
                       RO.HBOthnTT_A +          ;use HBOth without TTUNIQUE
                       RO.HBSch_Pr_A +
                       RO.HBSch_Sc_A +
                       RO.HBC_A      +
                       RO.Tot_NHBW_A +          ;use NHBW with telecommute
                       RO.NHBNW_A    
        
        
        RO.TG_IXXI_A = RO.IX_A +                ;exclude XX
                       RO.XI_A 
        
        
        RO.TG_Trk_A  = RO.SH_LT_A  +            ;exclude Ext_MD_A & Ext_HV_A
                       RO.SH_MD_A  +
                       RO.SH_HV_A  
        
        
        ;write output file
        WRITE RECO=1
        
        
        
        ;calculate matrix totals -----------------------------------------------------------------------------
        ;P's
        sum_HBW_P      = sum_HBW_P      + RO.HBW_P     
        sum_HBShp_P    = sum_HBShp_P    + RO.HBShp_P   
        sum_HBOth_P    = sum_HBOth_P    + RO.HBOth_P   
        sum_HBSch_Pr_P = sum_HBSch_Pr_P + RO.HBSch_Pr_P
        sum_HBSch_Sc_P = sum_HBSch_Sc_P + RO.HBSch_Sc_P
        sum_HBC_P      = sum_HBC_P      + RO.HBC_P     
        sum_NHBW_P     = sum_NHBW_P     + RO.NHBW_P    
        sum_NHBNW_P    = sum_NHBNW_P    + RO.NHBNW_P   
        sum_IX_P       = sum_IX_P       + RO.IX_P      
        sum_XI_P       = sum_XI_P       + RO.XI_P      
        sum_XX_P       = sum_XX_P       + RO.XX_P      
        sum_SH_LT_P    = sum_SH_LT_P    + RO.SH_LT_P   
        sum_SH_MD_P    = sum_SH_MD_P    + RO.SH_MD_P   
        sum_SH_HV_P    = sum_SH_HV_P    + RO.SH_HV_P   
        sum_Ext_MD_P   = sum_Ext_MD_P   + RO.Ext_MD_P  
        sum_Ext_HV_P   = sum_Ext_HV_P   + RO.Ext_HV_P  
        
        sum_HBSch_P    = sum_HBSch_P    + RO.HBSch_P   
        sum_HBO_P      = sum_HBO_P      + RO.HBO_P     
        sum_NHB_P      = sum_NHB_P      + RO.NHB_P     
        sum_TTUNIQUE_P = sum_TTUNIQUE_P + RO.TTUNIQUE_P
        sum_HBOthnTT_P = sum_HBOthnTT_P + RO.HBOthnTT_P
        
        sum_Tot_HBW_P  = sum_Tot_HBW_P  + RO.Tot_HBW_P 
        sum_Tel_HBW_P  = sum_Tel_HBW_P  + RO.Tel_HBW_P 
        sum_Tot_NHBW_P = sum_Tot_NHBW_P + RO.Tot_NHBW_P
        sum_Tel_NHBW_P = sum_Tel_NHBW_P + RO.Tel_NHBW_P
        
        
        sum_TotPer_P  = sum_HBW_P      +
                        sum_HBShp_P    +
                        sum_HBOth_P    +
                        sum_HBSch_Pr_P +
                        sum_HBSch_Sc_P +
                        sum_HBC_P      +
                        sum_NHBW_P     +
                        sum_NHBNW_P    
        
        sum_TotExt_P  = sum_IX_P +
                        sum_XI_P +
                        sum_XX_P 
        
        sum_TotTrk_P  = sum_SH_LT_P  +
                        sum_SH_MD_P  +
                        sum_SH_HV_P  +
                        sum_Ext_MD_P +
                        sum_Ext_HV_P 
        
        
        sum_TG_Per_P  = sum_Tot_HBW_P  +          ;use HBW with telecommute
                        sum_HBShp_P    +
                        sum_HBOthnTT_P +          ;use HBOth without TTUNIQUE
                        sum_HBSch_Pr_P +
                        sum_HBSch_Sc_P +
                        sum_HBC_P      +
                        sum_Tot_NHBW_P +          ;use NHBW with telecommute
                        sum_NHBNW_P    
                    
        sum_TG_IXXI_P = sum_IX_P +                ;exclude XX
                        sum_XI_P 
        
        sum_TG_Trk_P  = sum_SH_LT_P  +            ;exclude Ext_MD_P & Ext_HV_P
                        sum_SH_MD_P  +
                        sum_SH_HV_P  
        
        
        ;A's
        sum_HBW_A      = sum_HBW_A      + RO.HBW_A     
        sum_HBShp_A    = sum_HBShp_A    + RO.HBShp_A   
        sum_HBOth_A    = sum_HBOth_A    + RO.HBOth_A   
        sum_HBSch_Pr_A = sum_HBSch_Pr_A + RO.HBSch_Pr_A
        sum_HBSch_Sc_A = sum_HBSch_Sc_A + RO.HBSch_Sc_A
        sum_HBC_A      = sum_HBC_A      + RO.HBC_A     
        sum_NHBW_A     = sum_NHBW_A     + RO.NHBW_A    
        sum_NHBNW_A    = sum_NHBNW_A    + RO.NHBNW_A   
        sum_IX_A       = sum_IX_A       + RO.IX_A      
        sum_XI_A       = sum_XI_A       + RO.XI_A      
        sum_XX_A       = sum_XX_A       + RO.XX_A      
        sum_SH_LT_A    = sum_SH_LT_A    + RO.SH_LT_A   
        sum_SH_MD_A    = sum_SH_MD_A    + RO.SH_MD_A   
        sum_SH_HV_A    = sum_SH_HV_A    + RO.SH_HV_A   
        sum_Ext_MD_A   = sum_Ext_MD_A   + RO.Ext_MD_A  
        sum_Ext_HV_A   = sum_Ext_HV_A   + RO.Ext_HV_A  
        
        sum_HBSch_A    = sum_HBSch_A    + RO.HBSch_A   
        sum_HBO_A      = sum_HBO_A      + RO.HBO_A     
        sum_NHB_A      = sum_NHB_A      + RO.NHB_A     
        sum_TTUNIQUE_A = sum_TTUNIQUE_A + RO.TTUNIQUE_A
        sum_HBOthnTT_A = sum_HBOthnTT_A + RO.HBOthnTT_A
        
        sum_Tot_HBW_A  = sum_Tot_HBW_A  + RO.Tot_HBW_A 
        sum_Tel_HBW_A  = sum_Tel_HBW_A  + RO.Tel_HBW_A 
        
        sum_Tot_NHBW_A = sum_Tot_NHBW_A + RO.Tot_NHBW_A
        sum_Tel_NHBW_A = sum_Tel_NHBW_A + RO.Tel_NHBW_A
        
        
        sum_TotPer_A  = sum_HBW_A      +
                        sum_HBShp_A    +
                        sum_HBOth_A    +
                        sum_HBSch_Pr_A +
                        sum_HBSch_Sc_A +
                        sum_HBC_A      +
                        sum_NHBW_A     +
                        sum_NHBNW_A    
        
        sum_TotExt_A  = sum_IX_A +
                        sum_XI_A +
                        sum_XX_A 
        
        sum_TotTrk_A  = sum_SH_LT_A  +
                        sum_SH_MD_A  +
                        sum_SH_HV_A  +
                        sum_Ext_MD_A +
                        sum_Ext_HV_A 
        
        
        sum_TG_Per_A  = sum_Tot_HBW_A  +          ;use HBW with telecommute
                        sum_HBShp_A    +
                        sum_HBOthnTT_A +          ;use HBOth without TTUNIQUE
                        sum_HBSch_Pr_A +
                        sum_HBSch_Sc_A +
                        sum_HBC_A      +
                        sum_Tot_NHBW_A +          ;use NHBW with telecommute
                        sum_NHBNW_A    
                    
        sum_TG_IXXI_A = sum_IX_A +                ;exclude XX
                        sum_XI_A 
        
        sum_TG_Trk_A  = sum_SH_LT_A  +            ;exclude Ext_MD_A & Ext_HV_A
                        sum_SH_MD_A  +
                        sum_SH_HV_A  
        
        
        
        ;calculate intrazonal % ------------------------------------------------------------------------------
        if (i=@BoxElderRange@)
            
            total_HBW_BE = total_HBW_BE + rowsum(101)
            total_HBO_BE = total_HBO_BE + rowsum(121)
            total_NHB_BE = total_NHB_BE + rowsum(122)
            
            intrazonal_HBW_BE = intrazonal_HBW_BE + mw[101][i]
            intrazonal_HBO_BE = intrazonal_HBO_BE + mw[121][i]
            intrazonal_NHB_BE = intrazonal_NHB_BE + mw[122][i]
            
        elseif (i=@WeberRange@)
            
            total_HBW_WE = total_HBW_WE + rowsum(101)
            total_HBO_WE = total_HBO_WE + rowsum(121)
            total_NHB_WE = total_NHB_WE + rowsum(122)
            
            intrazonal_HBW_WE = intrazonal_HBW_WE + mw[101][i]
            intrazonal_HBO_WE = intrazonal_HBO_WE + mw[121][i]
            intrazonal_NHB_WE = intrazonal_NHB_WE + mw[122][i]
            
        elseif (i=@DavisRange@)
            
            total_HBW_DA = total_HBW_DA + rowsum(101)
            total_HBO_DA = total_HBO_DA + rowsum(121)
            total_NHB_DA = total_NHB_DA + rowsum(122)
            
            intrazonal_HBW_DA = intrazonal_HBW_DA + mw[101][i]
            intrazonal_HBO_DA = intrazonal_HBO_DA + mw[121][i]
            intrazonal_NHB_DA = intrazonal_NHB_DA + mw[122][i]
            
        elseif (i=@SLRange@)
            
            total_HBW_SL = total_HBW_SL + rowsum(101)
            total_HBO_SL = total_HBO_SL + rowsum(121)
            total_NHB_SL = total_NHB_SL + rowsum(122)
            
            intrazonal_HBW_SL = intrazonal_HBW_SL + mw[101][i]
            intrazonal_HBO_SL = intrazonal_HBO_SL + mw[121][i]
            intrazonal_NHB_SL = intrazonal_NHB_SL + mw[122][i]
            
        elseif (i=@UtahRange@)
            
            total_HBW_UT = total_HBW_UT + rowsum(101)
            total_HBO_UT = total_HBO_UT + rowsum(121)
            total_NHB_UT = total_NHB_UT + rowsum(122)
            
            intrazonal_HBW_UT = intrazonal_HBW_UT + mw[101][i]
            intrazonal_HBO_UT = intrazonal_HBO_UT + mw[121][i]
            intrazonal_NHB_UT = intrazonal_NHB_UT + mw[122][i]
            
        endif
        
        
        
        if (i=ZONES)
            
            ;calculate regional totals
            total_HBW_RE = total_HBW_BE +
                           total_HBW_WE +
                           total_HBW_DA +
                           total_HBW_SL +
                           total_HBW_UT
                         
            total_HBO_RE = total_HBO_BE +
                           total_HBO_WE +
                           total_HBO_DA +
                           total_HBO_SL +
                           total_HBO_UT
                         
            total_NHB_RE = total_NHB_BE +
                           total_NHB_WE +
                           total_NHB_DA +
                           total_NHB_SL +
                           total_NHB_UT
            
            
            intrazonal_HBW_RE = intrazonal_HBW_BE +
                                intrazonal_HBW_WE +
                                intrazonal_HBW_DA +
                                intrazonal_HBW_SL +
                                intrazonal_HBW_UT
                              
            intrazonal_HBO_RE = intrazonal_HBO_BE +
                                intrazonal_HBO_WE +
                                intrazonal_HBO_DA +
                                intrazonal_HBO_SL +
                                intrazonal_HBO_UT
                              
            intrazonal_NHB_RE = intrazonal_NHB_BE +
                                intrazonal_NHB_WE +
                                intrazonal_NHB_DA +
                                intrazonal_NHB_SL +
                                intrazonal_NHB_UT
            
            
            ;calculate introzonal %
            if (total_HBW_RE>0)  pct_intrazonal_HBW_RE = intrazonal_HBW_RE / total_HBW_RE * 100
            if (total_HBW_BE>0)  pct_intrazonal_HBW_BE = intrazonal_HBW_BE / total_HBW_BE * 100
            if (total_HBW_WE>0)  pct_intrazonal_HBW_WE = intrazonal_HBW_WE / total_HBW_WE * 100
            if (total_HBW_DA>0)  pct_intrazonal_HBW_DA = intrazonal_HBW_DA / total_HBW_DA * 100
            if (total_HBW_SL>0)  pct_intrazonal_HBW_SL = intrazonal_HBW_SL / total_HBW_SL * 100
            if (total_HBW_UT>0)  pct_intrazonal_HBW_UT = intrazonal_HBW_UT / total_HBW_UT * 100
            
            if (total_HBO_RE>0)  pct_intrazonal_HBO_RE = intrazonal_HBO_RE / total_HBO_RE * 100
            if (total_HBO_BE>0)  pct_intrazonal_HBO_BE = intrazonal_HBO_BE / total_HBO_BE * 100
            if (total_HBO_WE>0)  pct_intrazonal_HBO_WE = intrazonal_HBO_WE / total_HBO_WE * 100
            if (total_HBO_DA>0)  pct_intrazonal_HBO_DA = intrazonal_HBO_DA / total_HBO_DA * 100
            if (total_HBO_SL>0)  pct_intrazonal_HBO_SL = intrazonal_HBO_SL / total_HBO_SL * 100
            if (total_HBO_UT>0)  pct_intrazonal_HBO_UT = intrazonal_HBO_UT / total_HBO_UT * 100
            
            if (total_NHB_RE>0)  pct_intrazonal_NHB_RE = intrazonal_NHB_RE / total_NHB_RE * 100
            if (total_NHB_BE>0)  pct_intrazonal_NHB_BE = intrazonal_NHB_BE / total_NHB_BE * 100
            if (total_NHB_WE>0)  pct_intrazonal_NHB_WE = intrazonal_NHB_WE / total_NHB_WE * 100
            if (total_NHB_DA>0)  pct_intrazonal_NHB_DA = intrazonal_NHB_DA / total_NHB_DA * 100
            if (total_NHB_SL>0)  pct_intrazonal_NHB_SL = intrazonal_NHB_SL / total_NHB_SL * 100
            if (total_NHB_UT>0)  pct_intrazonal_NHB_UT = intrazonal_NHB_UT / total_NHB_UT * 100
            
            
            
            ;print output ------------------------------------------------------------------------------------
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
            APPEND=T,  
            FORM=13.0C,
            LIST='\n',
                 '\n',
                 '\nDistribution - Trip Summary',
                 '\n',
                 '\n  Matrix Totals',
                 '\n              ',  '  Productions',  '  Attractions',  ' P/A Balance ',
                 '\n    TotPer    ',   sum_TotPer_P  ,   sum_TotPer_A  ,   sum_TotPer_P/sum_TotPer_A(10.2)    ,
                 '\n      HBW     ',   sum_HBW_P     ,   sum_HBW_A     ,   sum_HBW_P/sum_HBW_A(10.2)          ,
                 '\n      HBShp   ',   sum_HBShp_P   ,   sum_HBShp_A   ,   sum_HBShp_P/sum_HBShp_A(10.2)      ,
                 '\n      HBOth   ',   sum_HBOth_P   ,   sum_HBOth_A   ,   sum_HBOth_P/sum_HBOth_A(10.2)      ,
                 '\n      HBSch_Pr',   sum_HBSch_Pr_P,   sum_HBSch_Pr_A,   sum_HBSch_Pr_P/sum_HBSch_Pr_A(10.2),
                 '\n      HBSch_Sc',   sum_HBSch_Sc_P,   sum_HBSch_Sc_A,   sum_HBSch_Sc_P/sum_HBSch_Sc_A(10.2),
                 '\n      HBC     ',   sum_HBC_P     ,   sum_HBC_A     ,   sum_HBC_P/sum_HBC_A(10.2)          ,
                 '\n      NHBW    ',   sum_NHBW_P    ,   sum_NHBW_A    ,   sum_NHBW_P/sum_NHBW_A(10.2)        ,
                 '\n      NHBNW   ',   sum_NHBNW_P   ,   sum_NHBNW_A   ,   sum_NHBNW_P/sum_NHBNW_A(10.2)      ,
                 '\n',
                 '\n    TotExt    ',   sum_TotExt_P  ,   sum_TotExt_A  ,   sum_TotExt_P/sum_TotExt_A(10.2)    ,
                 '\n      IX      ',   sum_IX_P      ,   sum_IX_A      ,   sum_IX_P/sum_IX_A(10.2)            ,
                 '\n      XI      ',   sum_XI_P      ,   sum_XI_A      ,   sum_XI_P/sum_XI_A(10.2)            ,
                 '\n      XX      ',   sum_XX_P      ,   sum_XX_A      ,   sum_XX_P/sum_XX_A(10.2)            ,
                 '\n',
                 '\n    TotTrk    ',   sum_TotTrk_P  ,   sum_TotTrk_A  ,   sum_TotTrk_P/sum_TotTrk_A(10.2)    ,
                 '\n      SH_LT   ',   sum_SH_LT_P   ,   sum_SH_LT_A   ,   sum_SH_LT_P/sum_SH_LT_A(10.2)      ,
                 '\n      SH_MD   ',   sum_SH_MD_P   ,   sum_SH_MD_A   ,   sum_SH_MD_P/sum_SH_MD_A(10.2)      ,
                 '\n      SH_HV   ',   sum_SH_HV_P   ,   sum_SH_HV_A   ,   sum_SH_HV_P/sum_SH_HV_A(10.2)      ,
                 '\n      Ext_MD  ',   sum_Ext_MD_P  ,   sum_Ext_MD_A  ,   sum_Ext_MD_P/sum_Ext_MD_A(10.2)    ,
                 '\n      Ext_HV  ',   sum_Ext_HV_P  ,   sum_Ext_HV_A  ,   sum_Ext_HV_P/sum_Ext_HV_A(10.2)    ,
                 '\n',
                 '\n    Other summaries',
                 '\n      HBSch   ',   sum_HBSch_P   ,   sum_HBSch_A   ,   sum_HBSch_P/sum_HBSch_A(10.2)      ,
                 '\n      HBO     ',   sum_HBO_P     ,   sum_HBO_A     ,   sum_HBO_P/sum_HBO_A(10.2)          ,
                 '\n      NHB     ',   sum_NHB_P     ,   sum_NHB_A     ,   sum_NHB_P/sum_NHB_A(10.2)          ,
                 '\n      TTUNIQUE',   sum_TTUNIQUE_P,   sum_TTUNIQUE_A,   sum_TTUNIQUE_P/sum_TTUNIQUE_A(10.2),
                 '\n      HBOthnTT',   sum_HBOthnTT_P,   sum_HBOthnTT_A,   sum_HBOthnTT_P/sum_HBOthnTT_A(10.2),
                 '\n',
                 '\n      Tot_HBW ',   sum_Tot_HBW_P ,   sum_Tot_HBW_A ,   sum_Tot_HBW_P/sum_Tot_HBW_A(10.2)  ,
                 '\n      Tel_HBW ',   sum_Tel_HBW_P ,   sum_Tel_HBW_A ,   sum_Tel_HBW_P/sum_Tel_HBW_A(10.2)  ,
                 '\n      Tot_NHBW',   sum_Tot_NHBW_P,   sum_Tot_NHBW_A,   sum_Tot_NHBW_P/sum_Tot_NHBW_A(10.2),
                 '\n      Tel_NHBW',   sum_Tel_NHBW_P,   sum_Tel_NHBW_A,   sum_Tel_NHBW_P/sum_Tel_NHBW_A(10.2),
                 '\n',
                 '\n      TG_Per  ',   sum_TG_Per_P  ,   sum_TG_Per_A  ,   sum_TG_Per_P/sum_TG_Per_A(10.2)    ,
                 '\n      TG_IXXI ',   sum_TG_IXXI_P ,   sum_TG_IXXI_A ,   sum_TG_IXXI_P/sum_TG_IXXI_A(10.2)  ,
                 '\n      TG_Trk  ',   sum_TG_Trk_P  ,   sum_TG_Trk_A  ,   sum_TG_Trk_P/sum_TG_Trk_A(10.2)    ,
                 '\n',
                 '\n',
                 '\n  Intrazonal Summary',
                 '\n    Region    ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_RE,      total_HBW_RE,   pct_intrazonal_HBW_RE(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_RE,      total_HBO_RE,   pct_intrazonal_HBO_RE(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_RE,      total_NHB_RE,   pct_intrazonal_NHB_RE(13.1), '%',
                 '\n',                 
                 '\n    Box Elder ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_BE,      total_HBW_BE,   pct_intrazonal_HBW_BE(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_BE,      total_HBO_BE,   pct_intrazonal_HBO_BE(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_BE,      total_NHB_BE,   pct_intrazonal_NHB_BE(13.1), '%',
                 '\n',                 
                 '\n    Weber     ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_WE,      total_HBW_WE,   pct_intrazonal_HBW_WE(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_WE,      total_HBO_WE,   pct_intrazonal_HBO_WE(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_WE,      total_NHB_WE,   pct_intrazonal_NHB_WE(13.1), '%',
                 '\n',                 
                 '\n    Davis     ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_DA,      total_HBW_DA,   pct_intrazonal_HBW_DA(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_DA,      total_HBO_DA,   pct_intrazonal_HBO_DA(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_DA,      total_NHB_DA,   pct_intrazonal_NHB_DA(13.1), '%',
                 '\n',                 
                 '\n    Salt Lake ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_SL,      total_HBW_SL,   pct_intrazonal_HBW_SL(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_SL,      total_HBO_SL,   pct_intrazonal_HBO_SL(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_SL,      total_NHB_SL,   pct_intrazonal_NHB_SL(13.1), '%',
                 '\n',                 
                 '\n    Utah      ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
                 '\n      HBW     ',   intrazonal_HBW_UT,      total_HBW_UT,   pct_intrazonal_HBW_UT(13.1), '%',
                 '\n      HBO     ',   intrazonal_HBO_UT,      total_HBO_UT,   pct_intrazonal_HBO_UT(13.1), '%',
                 '\n      NHB     ',   intrazonal_NHB_UT,      total_NHB_UT,   pct_intrazonal_NHB_UT(13.1), '%',
                 '\n',
                 '\n'
            
        endif  ;i=ZONES
        
    ENDRUN

;Cluster: bring together all distributed steps before continuing
BARRIER IDLIST='FinNet_Proc2' CheckReturnCode=T




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    SubScriptEndTime_FN = currenttime()
    SubScriptRunTime_FN = SubScriptEndTime_FN - @SubScriptStartTime_FN@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n        Prepare final loaded net and mtx  ', formatdatetime(SubScriptRunTime_FN, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;calculate Daily PA skims by trip purpose from period OD skims =============================================================================

;get start time
SubScriptStartTime_TD = currenttime()



LOOP _LOS=1, 2
    
    ;output filename tag to differentiate generalized cost, time or distance output matrices
    if (_LOS=1)  skim_type = 'Time'
    if (_LOS=2)  skim_type = 'Dist'
    
    ;prefix to identify which skim type or set of matrices in input skim matrix files
    if (_LOS=1)  matrix_prefix = 'time'
    if (_LOS=2)  matrix_prefix = 'distance'
    
    
    
    RUN PGM=MATRIX  MSG='Distribution: Feedback Loop @n@: Create Daily Average Skim - @skim_type@'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_AM.mtx'
        FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_MD.mtx'
        FILEI MATI[3] = '@ParentDir@@ScenarioDir@3_Distribute\skm_PM.mtx'
        FILEI MATI[4] = '@ParentDir@@ScenarioDir@3_Distribute\skm_EV.mtx'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_@skim_type@.mtx',
                mo=510, 520-522, 530-532, 540, 550, 560, 570, 580, 590, 500,
                name=HBW   ,
                     HBO   ,
                     HBShp ,
                     HBOth ,
                     NHB   ,
                     NHBW  ,
                     NHBNW ,
                     HBS   ,
                     HBC   ,
                     Rec   ,
                     LT    ,
                     MD    ,
                     HV    ,
                     Ext   
        
        
        ;Cluster: distribute intrastep processing
        DistributeIntrastep MaxProcesses=@CoresAvailable@
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        
        ;read in calculated diurnal factors from file
        if (i=FIRSTZONE)
            
            ;read in calculate diurnal factors block file
            READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
            
        endif  ;i=FIRSTZONE
        
        
        
        ;read in skim tables ---------------------------------------------------------------------------------
        ;  note: AP direction is the transpose of PA direction
        
        ;AM
        mw[101] = mi.1.@matrix_prefix@_Auto_WRK
        mw[102] = mi.1.@matrix_prefix@_Auto_Per
        mw[103] = mi.1.@matrix_prefix@_Auto_Ext
        mw[104] = mi.1.@matrix_prefix@_Truck_LT
        mw[105] = mi.1.@matrix_prefix@_Truck_MD
        mw[106] = mi.1.@matrix_prefix@_Truck_HV
        
        mw[151] = mi.1.@matrix_prefix@_Auto_WRK.T
        mw[152] = mi.1.@matrix_prefix@_Auto_Per.T
        mw[153] = mi.1.@matrix_prefix@_Auto_Ext.T
        mw[154] = mi.1.@matrix_prefix@_Truck_LT.T
        mw[155] = mi.1.@matrix_prefix@_Truck_MD.T
        mw[156] = mi.1.@matrix_prefix@_Truck_HV.T
        
        ;MD
        mw[201] = mi.2.@matrix_prefix@_Auto_WRK
        mw[202] = mi.2.@matrix_prefix@_Auto_Per
        mw[203] = mi.2.@matrix_prefix@_Auto_Ext
        mw[204] = mi.2.@matrix_prefix@_Truck_LT
        mw[205] = mi.2.@matrix_prefix@_Truck_MD
        mw[206] = mi.2.@matrix_prefix@_Truck_HV
        
        mw[251] = mi.2.@matrix_prefix@_Auto_WRK.T
        mw[252] = mi.2.@matrix_prefix@_Auto_Per.T
        mw[253] = mi.2.@matrix_prefix@_Auto_Ext.T
        mw[254] = mi.2.@matrix_prefix@_Truck_LT.T
        mw[255] = mi.2.@matrix_prefix@_Truck_MD.T
        mw[256] = mi.2.@matrix_prefix@_Truck_HV.T
        
        ;PM
        mw[301] = mi.3.@matrix_prefix@_Auto_WRK
        mw[302] = mi.3.@matrix_prefix@_Auto_Per
        mw[303] = mi.3.@matrix_prefix@_Auto_Ext
        mw[304] = mi.3.@matrix_prefix@_Truck_LT
        mw[305] = mi.3.@matrix_prefix@_Truck_MD
        mw[306] = mi.3.@matrix_prefix@_Truck_HV
        
        mw[351] = mi.3.@matrix_prefix@_Auto_WRK.T
        mw[352] = mi.3.@matrix_prefix@_Auto_Per.T
        mw[353] = mi.3.@matrix_prefix@_Auto_Ext.T
        mw[354] = mi.3.@matrix_prefix@_Truck_LT.T
        mw[355] = mi.3.@matrix_prefix@_Truck_MD.T
        mw[356] = mi.3.@matrix_prefix@_Truck_HV.T
        
        ;EV
        mw[401] = mi.4.@matrix_prefix@_Auto_WRK
        mw[402] = mi.4.@matrix_prefix@_Auto_Per
        mw[403] = mi.4.@matrix_prefix@_Auto_Ext
        mw[404] = mi.4.@matrix_prefix@_Truck_LT
        mw[405] = mi.4.@matrix_prefix@_Truck_MD
        mw[406] = mi.4.@matrix_prefix@_Truck_HV
        
        mw[451] = mi.4.@matrix_prefix@_Auto_WRK.T
        mw[452] = mi.4.@matrix_prefix@_Auto_Per.T
        mw[453] = mi.4.@matrix_prefix@_Auto_Ext.T
        mw[454] = mi.4.@matrix_prefix@_Truck_LT.T
        mw[455] = mi.4.@matrix_prefix@_Truck_MD.T
        mw[456] = mi.4.@matrix_prefix@_Truck_HV.T
        
        
        
        ;calculate weighted average daily skim ---------------------------------------------------------------
        ;loop through columns to identify movement (II, IX, XI or XX)
        JLOOP
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_HBW * PA_AM_HBW  +  mw[151] * Pct_AM_HBW * (1 - PA_AM_HBW)  +
                          mw[201] * Pct_MD_HBW * PA_MD_HBW  +  mw[251] * Pct_MD_HBW * (1 - PA_MD_HBW)  +
                          mw[301] * Pct_PM_HBW * PA_PM_HBW  +  mw[351] * Pct_PM_HBW * (1 - PA_PM_HBW)  +
                          mw[401] * Pct_EV_HBW * PA_EV_HBW  +  mw[451] * Pct_EV_HBW * (1 - PA_EV_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_HBO * PA_AM_HBO      +  mw[152] * Pct_AM_HBO   * (1 - PA_AM_HBO)   +
                          mw[202] * Pct_MD_HBO * PA_MD_HBO      +  mw[252] * Pct_MD_HBO   * (1 - PA_MD_HBO)   +
                          mw[302] * Pct_PM_HBO * PA_PM_HBO      +  mw[352] * Pct_PM_HBO   * (1 - PA_PM_HBO)   +
                          mw[402] * Pct_EV_HBO * PA_EV_HBO      +  mw[452] * Pct_EV_HBO   * (1 - PA_EV_HBO)    
                
                mw[521] = mw[102] * Pct_AM_HBShp * PA_AM_HBShp  +  mw[152] * Pct_AM_HBShp * (1 - PA_AM_HBShp) +
                          mw[202] * Pct_MD_HBShp * PA_MD_HBShp  +  mw[252] * Pct_MD_HBShp * (1 - PA_MD_HBShp) +
                          mw[302] * Pct_PM_HBShp * PA_PM_HBShp  +  mw[352] * Pct_PM_HBShp * (1 - PA_PM_HBShp) +
                          mw[402] * Pct_EV_HBShp * PA_EV_HBShp  +  mw[452] * Pct_EV_HBShp * (1 - PA_EV_HBShp)  
                
                mw[522] = mw[102] * Pct_AM_HBOth * PA_AM_HBOth  +  mw[152] * Pct_AM_HBOth * (1 - PA_AM_HBOth) +
                          mw[202] * Pct_MD_HBOth * PA_MD_HBOth  +  mw[252] * Pct_MD_HBOth * (1 - PA_MD_HBOth) +
                          mw[302] * Pct_PM_HBOth * PA_PM_HBOth  +  mw[352] * Pct_PM_HBOth * (1 - PA_PM_HBOth) +
                          mw[402] * Pct_EV_HBOth * PA_EV_HBOth  +  mw[452] * Pct_EV_HBOth * (1 - PA_EV_HBOth)  
                
                mw[530] = mw[102] * Pct_AM_NHB * PA_AM_NHB      +  mw[152] * Pct_AM_NHB   * (1 - PA_AM_NHB)   +
                          mw[202] * Pct_MD_NHB * PA_MD_NHB      +  mw[252] * Pct_MD_NHB   * (1 - PA_MD_NHB)   +
                          mw[302] * Pct_PM_NHB * PA_PM_NHB      +  mw[352] * Pct_PM_NHB   * (1 - PA_PM_NHB)   +
                          mw[402] * Pct_EV_NHB * PA_EV_NHB      +  mw[452] * Pct_EV_NHB   * (1 - PA_EV_NHB)    
                
                mw[531] = mw[102] * Pct_AM_NHBW * PA_AM_NHBW    +  mw[152] * Pct_AM_NHBW  * (1 - PA_AM_NHBW)  +
                          mw[202] * Pct_MD_NHBW * PA_MD_NHBW    +  mw[252] * Pct_MD_NHBW  * (1 - PA_MD_NHBW)  +
                          mw[302] * Pct_PM_NHBW * PA_PM_NHBW    +  mw[352] * Pct_PM_NHBW  * (1 - PA_PM_NHBW)  +
                          mw[402] * Pct_EV_NHBW * PA_EV_NHBW    +  mw[452] * Pct_EV_NHBW  * (1 - PA_EV_NHBW)   
                
                mw[532] = mw[102] * Pct_AM_NHBNW * PA_AM_NHBNW  +  mw[152] * Pct_AM_NHBNW * (1 - PA_AM_NHBNW) +
                          mw[202] * Pct_MD_NHBNW * PA_MD_NHBNW  +  mw[252] * Pct_MD_NHBNW * (1 - PA_MD_NHBNW) +
                          mw[302] * Pct_PM_NHBNW * PA_PM_NHBNW  +  mw[352] * Pct_PM_NHBNW * (1 - PA_PM_NHBNW) +
                          mw[402] * Pct_EV_NHBNW * PA_EV_NHBNW  +  mw[452] * Pct_EV_NHBNW * (1 - PA_EV_NHBNW)  
                
                mw[540] = mw[102] * Pct_AM_HBS * PA_AM_HBS      +  mw[152] * Pct_AM_HBS   * (1 - PA_AM_HBS)   +
                          mw[202] * Pct_MD_HBS * PA_MD_HBS      +  mw[252] * Pct_MD_HBS   * (1 - PA_MD_HBS)   +
                          mw[302] * Pct_PM_HBS * PA_PM_HBS      +  mw[352] * Pct_PM_HBS   * (1 - PA_PM_HBS)   +
                          mw[402] * Pct_EV_HBS * PA_EV_HBS      +  mw[452] * Pct_EV_HBS   * (1 - PA_EV_HBS)    
                
                mw[550] = mw[102] * Pct_AM_HBC * PA_AM_HBC      +  mw[152] * Pct_AM_HBC   * (1 - PA_AM_HBC)   +
                          mw[202] * Pct_MD_HBC * PA_MD_HBC      +  mw[252] * Pct_MD_HBC   * (1 - PA_MD_HBC)   +
                          mw[302] * Pct_PM_HBC * PA_PM_HBC      +  mw[352] * Pct_PM_HBC   * (1 - PA_PM_HBC)   +
                          mw[402] * Pct_EV_HBC * PA_EV_HBC      +  mw[452] * Pct_EV_HBC   * (1 - PA_EV_HBC)    
                
                mw[560] = mw[102] * Pct_AM_Rec * PA_AM_Rec      +  mw[152] * Pct_AM_Rec   * (1 - PA_AM_Rec)   +
                          mw[202] * Pct_MD_Rec * PA_MD_Rec      +  mw[252] * Pct_MD_Rec   * (1 - PA_MD_Rec)   +
                          mw[302] * Pct_PM_Rec * PA_PM_Rec      +  mw[352] * Pct_PM_Rec   * (1 - PA_PM_Rec)   +
                          mw[402] * Pct_EV_Rec * PA_EV_Rec      +  mw[452] * Pct_EV_Rec   * (1 - PA_EV_Rec)    
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_LT * PA_AM_LT  +  mw[154] * Pct_AM_LT * (1 - PA_AM_LT)  +
                          mw[204] * Pct_MD_LT * PA_MD_LT  +  mw[254] * Pct_MD_LT * (1 - PA_MD_LT)  +
                          mw[304] * Pct_PM_LT * PA_PM_LT  +  mw[354] * Pct_PM_LT * (1 - PA_PM_LT)  +
                          mw[404] * Pct_EV_LT * PA_EV_LT  +  mw[454] * Pct_EV_LT * (1 - PA_EV_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_MD * PA_AM_MD  +  mw[155] * Pct_AM_MD * (1 - PA_AM_MD)  +
                          mw[205] * Pct_MD_MD * PA_MD_MD  +  mw[255] * Pct_MD_MD * (1 - PA_MD_MD)  +
                          mw[305] * Pct_PM_MD * PA_PM_MD  +  mw[355] * Pct_PM_MD * (1 - PA_PM_MD)  +
                          mw[405] * Pct_EV_MD * PA_EV_MD  +  mw[455] * Pct_EV_MD * (1 - PA_EV_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_HV * PA_AM_HV  +  mw[156] * Pct_AM_HV * (1 - PA_AM_HV)  +
                          mw[206] * Pct_MD_HV * PA_MD_HV  +  mw[256] * Pct_MD_HV * (1 - PA_MD_HV)  +
                          mw[306] * Pct_PM_HV * PA_PM_HV  +  mw[356] * Pct_PM_HV * (1 - PA_PM_HV)  +
                          mw[406] * Pct_EV_HV * PA_EV_HV  +  mw[456] * Pct_EV_HV * (1 - PA_EV_HV)   
                
                
            ;IX
            elseif (!(i=@externalzones@) & j=@externalzones@)
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_IX * PA_AM_IX  +  mw[153] * Pct_AM_IX * (1 - PA_AM_IX) +
                          mw[203] * Pct_MD_IX * PA_MD_IX  +  mw[253] * Pct_MD_IX * (1 - PA_MD_IX) +
                          mw[303] * Pct_PM_IX * PA_PM_IX  +  mw[353] * Pct_PM_IX * (1 - PA_PM_IX) +
                          mw[403] * Pct_EV_IX * PA_EV_IX  +  mw[453] * Pct_EV_IX * (1 - PA_EV_IX)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_IX_HBW * PA_AM_IX_HBW  +  mw[151] * Pct_AM_IX_HBW * (1 - PA_AM_IX_HBW)  +
                          mw[201] * Pct_MD_IX_HBW * PA_MD_IX_HBW  +  mw[251] * Pct_MD_IX_HBW * (1 - PA_MD_IX_HBW)  +
                          mw[301] * Pct_PM_IX_HBW * PA_PM_IX_HBW  +  mw[351] * Pct_PM_IX_HBW * (1 - PA_PM_IX_HBW)  +
                          mw[401] * Pct_EV_IX_HBW * PA_EV_IX_HBW  +  mw[451] * Pct_EV_IX_HBW * (1 - PA_EV_IX_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_IX_HBO * PA_AM_IX_HBO  +  mw[152] * Pct_AM_IX_HBO * (1 - PA_AM_IX_HBO)  +
                          mw[202] * Pct_MD_IX_HBO * PA_MD_IX_HBO  +  mw[252] * Pct_MD_IX_HBO * (1 - PA_MD_IX_HBO)  +
                          mw[302] * Pct_PM_IX_HBO * PA_PM_IX_HBO  +  mw[352] * Pct_PM_IX_HBO * (1 - PA_PM_IX_HBO)  +
                          mw[402] * Pct_EV_IX_HBO * PA_EV_IX_HBO  +  mw[452] * Pct_EV_IX_HBO * (1 - PA_EV_IX_HBO)   
                
                mw[530] = mw[102] * Pct_AM_IX_NHB * PA_AM_IX_NHB  +  mw[152] * Pct_AM_IX_NHB * (1 - PA_AM_IX_NHB)  +
                          mw[202] * Pct_MD_IX_NHB * PA_MD_IX_NHB  +  mw[252] * Pct_MD_IX_NHB * (1 - PA_MD_IX_NHB)  +
                          mw[302] * Pct_PM_IX_NHB * PA_PM_IX_NHB  +  mw[352] * Pct_PM_IX_NHB * (1 - PA_PM_IX_NHB)  +
                          mw[402] * Pct_EV_IX_NHB * PA_EV_IX_NHB  +  mw[452] * Pct_EV_IX_NHB * (1 - PA_EV_IX_NHB)   
                
                mw[540] = mw[102] * Pct_AM_IX_HBS * PA_AM_IX_HBS  +  mw[152] * Pct_AM_IX_HBS * (1 - PA_AM_IX_HBS)  +
                          mw[202] * Pct_MD_IX_HBS * PA_MD_IX_HBS  +  mw[252] * Pct_MD_IX_HBS * (1 - PA_MD_IX_HBS)  +
                          mw[302] * Pct_PM_IX_HBS * PA_PM_IX_HBS  +  mw[352] * Pct_PM_IX_HBS * (1 - PA_PM_IX_HBS)  +
                          mw[402] * Pct_EV_IX_HBS * PA_EV_IX_HBS  +  mw[452] * Pct_EV_IX_HBS * (1 - PA_EV_IX_HBS)   
                
                mw[550] = mw[102] * Pct_AM_IX_HBC * PA_AM_IX_HBC  +  mw[152] * Pct_AM_IX_HBC * (1 - PA_AM_IX_HBC)  +
                          mw[202] * Pct_MD_IX_HBC * PA_MD_IX_HBC  +  mw[252] * Pct_MD_IX_HBC * (1 - PA_MD_IX_HBC)  +
                          mw[302] * Pct_PM_IX_HBC * PA_PM_IX_HBC  +  mw[352] * Pct_PM_IX_HBC * (1 - PA_PM_IX_HBC)  +
                          mw[402] * Pct_EV_IX_HBC * PA_EV_IX_HBC  +  mw[452] * Pct_EV_IX_HBC * (1 - PA_EV_IX_HBC)   
                
                mw[560] = mw[102] * Pct_AM_IX_Rec * PA_AM_IX_Rec  +  mw[152] * Pct_AM_IX_Rec * (1 - PA_AM_IX_Rec)  +
                          mw[202] * Pct_MD_IX_Rec * PA_MD_IX_Rec  +  mw[252] * Pct_MD_IX_Rec * (1 - PA_MD_IX_Rec)  +
                          mw[302] * Pct_PM_IX_Rec * PA_PM_IX_Rec  +  mw[352] * Pct_PM_IX_Rec * (1 - PA_PM_IX_Rec)  +
                          mw[402] * Pct_EV_IX_Rec * PA_EV_IX_Rec  +  mw[452] * Pct_EV_IX_Rec * (1 - PA_EV_IX_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_IX_LT * PA_AM_IX_LT  +  mw[154] * Pct_AM_IX_LT * (1 - PA_AM_IX_LT)  +
                          mw[204] * Pct_MD_IX_LT * PA_MD_IX_LT  +  mw[254] * Pct_MD_IX_LT * (1 - PA_MD_IX_LT)  +
                          mw[304] * Pct_PM_IX_LT * PA_PM_IX_LT  +  mw[354] * Pct_PM_IX_LT * (1 - PA_PM_IX_LT)  +
                          mw[404] * Pct_EV_IX_LT * PA_EV_IX_LT  +  mw[454] * Pct_EV_IX_LT * (1 - PA_EV_IX_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_IX_MD * PA_AM_IX_MD  +  mw[155] * Pct_AM_IX_MD * (1 - PA_AM_IX_MD)  +
                          mw[205] * Pct_MD_IX_MD * PA_MD_IX_MD  +  mw[255] * Pct_MD_IX_MD * (1 - PA_MD_IX_MD)  +
                          mw[305] * Pct_PM_IX_MD * PA_PM_IX_MD  +  mw[355] * Pct_PM_IX_MD * (1 - PA_PM_IX_MD)  +
                          mw[405] * Pct_EV_IX_MD * PA_EV_IX_MD  +  mw[455] * Pct_EV_IX_MD * (1 - PA_EV_IX_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_IX_HV * PA_AM_IX_HV  +  mw[156] * Pct_AM_IX_HV * (1 - PA_AM_IX_HV)  +
                          mw[206] * Pct_MD_IX_HV * PA_MD_IX_HV  +  mw[256] * Pct_MD_IX_HV * (1 - PA_MD_IX_HV)  +
                          mw[306] * Pct_PM_IX_HV * PA_PM_IX_HV  +  mw[356] * Pct_PM_IX_HV * (1 - PA_PM_IX_HV)  +
                          mw[406] * Pct_EV_IX_HV * PA_EV_IX_HV  +  mw[456] * Pct_EV_IX_HV * (1 - PA_EV_IX_HV)   
                
                
            ;XI
            elseif (i=@externalzones@ & !(j=@externalzones@))
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_XI * PA_AM_XI  +  mw[153] * Pct_AM_XI * (1 - PA_AM_XI) +
                          mw[203] * Pct_MD_XI * PA_MD_XI  +  mw[253] * Pct_MD_XI * (1 - PA_MD_XI) +
                          mw[303] * Pct_PM_XI * PA_PM_XI  +  mw[353] * Pct_PM_XI * (1 - PA_PM_XI) +
                          mw[403] * Pct_EV_XI * PA_EV_XI  +  mw[453] * Pct_EV_XI * (1 - PA_EV_XI)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_XI_HBW * PA_AM_XI_HBW  +  mw[151] * Pct_AM_XI_HBW * (1 - PA_AM_XI_HBW)  +
                          mw[201] * Pct_MD_XI_HBW * PA_MD_XI_HBW  +  mw[251] * Pct_MD_XI_HBW * (1 - PA_MD_XI_HBW)  +
                          mw[301] * Pct_PM_XI_HBW * PA_PM_XI_HBW  +  mw[351] * Pct_PM_XI_HBW * (1 - PA_PM_XI_HBW)  +
                          mw[401] * Pct_EV_XI_HBW * PA_EV_XI_HBW  +  mw[451] * Pct_EV_XI_HBW * (1 - PA_EV_XI_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_XI_HBO * PA_AM_XI_HBO  +  mw[152] * Pct_AM_XI_HBO * (1 - PA_AM_XI_HBO)  +
                          mw[202] * Pct_MD_XI_HBO * PA_MD_XI_HBO  +  mw[252] * Pct_MD_XI_HBO * (1 - PA_MD_XI_HBO)  +
                          mw[302] * Pct_PM_XI_HBO * PA_PM_XI_HBO  +  mw[352] * Pct_PM_XI_HBO * (1 - PA_PM_XI_HBO)  +
                          mw[402] * Pct_EV_XI_HBO * PA_EV_XI_HBO  +  mw[452] * Pct_EV_XI_HBO * (1 - PA_EV_XI_HBO)   
                
                mw[530] = mw[102] * Pct_AM_XI_NHB * PA_AM_XI_NHB  +  mw[152] * Pct_AM_XI_NHB * (1 - PA_AM_XI_NHB)  +
                          mw[202] * Pct_MD_XI_NHB * PA_MD_XI_NHB  +  mw[252] * Pct_MD_XI_NHB * (1 - PA_MD_XI_NHB)  +
                          mw[302] * Pct_PM_XI_NHB * PA_PM_XI_NHB  +  mw[352] * Pct_PM_XI_NHB * (1 - PA_PM_XI_NHB)  +
                          mw[402] * Pct_EV_XI_NHB * PA_EV_XI_NHB  +  mw[452] * Pct_EV_XI_NHB * (1 - PA_EV_XI_NHB)   
                
                mw[540] = mw[102] * Pct_AM_XI_HBS * PA_AM_XI_HBS  +  mw[152] * Pct_AM_XI_HBS * (1 - PA_AM_XI_HBS)  +
                          mw[202] * Pct_MD_XI_HBS * PA_MD_XI_HBS  +  mw[252] * Pct_MD_XI_HBS * (1 - PA_MD_XI_HBS)  +
                          mw[302] * Pct_PM_XI_HBS * PA_PM_XI_HBS  +  mw[352] * Pct_PM_XI_HBS * (1 - PA_PM_XI_HBS)  +
                          mw[402] * Pct_EV_XI_HBS * PA_EV_XI_HBS  +  mw[452] * Pct_EV_XI_HBS * (1 - PA_EV_XI_HBS)   
                
                mw[550] = mw[102] * Pct_AM_XI_HBC * PA_AM_XI_HBC  +  mw[152] * Pct_AM_XI_HBC * (1 - PA_AM_XI_HBC)  +
                          mw[202] * Pct_MD_XI_HBC * PA_MD_XI_HBC  +  mw[252] * Pct_MD_XI_HBC * (1 - PA_MD_XI_HBC)  +
                          mw[302] * Pct_PM_XI_HBC * PA_PM_XI_HBC  +  mw[352] * Pct_PM_XI_HBC * (1 - PA_PM_XI_HBC)  +
                          mw[402] * Pct_EV_XI_HBC * PA_EV_XI_HBC  +  mw[452] * Pct_EV_XI_HBC * (1 - PA_EV_XI_HBC)   
                
                mw[560] = mw[102] * Pct_AM_XI_Rec * PA_AM_XI_Rec  +  mw[152] * Pct_AM_XI_Rec * (1 - PA_AM_XI_Rec)  +
                          mw[202] * Pct_MD_XI_Rec * PA_MD_XI_Rec  +  mw[252] * Pct_MD_XI_Rec * (1 - PA_MD_XI_Rec)  +
                          mw[302] * Pct_PM_XI_Rec * PA_PM_XI_Rec  +  mw[352] * Pct_PM_XI_Rec * (1 - PA_PM_XI_Rec)  +
                          mw[402] * Pct_EV_XI_Rec * PA_EV_XI_Rec  +  mw[452] * Pct_EV_XI_Rec * (1 - PA_EV_XI_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_XI_LT * PA_AM_XI_LT  +  mw[154] * Pct_AM_XI_LT * (1 - PA_AM_XI_LT)  +
                          mw[204] * Pct_MD_XI_LT * PA_MD_XI_LT  +  mw[254] * Pct_MD_XI_LT * (1 - PA_MD_XI_LT)  +
                          mw[304] * Pct_PM_XI_LT * PA_PM_XI_LT  +  mw[354] * Pct_PM_XI_LT * (1 - PA_PM_XI_LT)  +
                          mw[404] * Pct_EV_XI_LT * PA_EV_XI_LT  +  mw[454] * Pct_EV_XI_LT * (1 - PA_EV_XI_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_XI_MD * PA_AM_XI_MD  +  mw[155] * Pct_AM_XI_MD * (1 - PA_AM_XI_MD)  +
                          mw[205] * Pct_MD_XI_MD * PA_MD_XI_MD  +  mw[255] * Pct_MD_XI_MD * (1 - PA_MD_XI_MD)  +
                          mw[305] * Pct_PM_XI_MD * PA_PM_XI_MD  +  mw[355] * Pct_PM_XI_MD * (1 - PA_PM_XI_MD)  +
                          mw[405] * Pct_EV_XI_MD * PA_EV_XI_MD  +  mw[455] * Pct_EV_XI_MD * (1 - PA_EV_XI_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_XI_HV * PA_AM_XI_HV  +  mw[156] * Pct_AM_XI_HV * (1 - PA_AM_XI_HV)  +
                          mw[206] * Pct_MD_XI_HV * PA_MD_XI_HV  +  mw[256] * Pct_MD_XI_HV * (1 - PA_MD_XI_HV)  +
                          mw[306] * Pct_PM_XI_HV * PA_PM_XI_HV  +  mw[356] * Pct_PM_XI_HV * (1 - PA_PM_XI_HV)  +
                          mw[406] * Pct_EV_XI_HV * PA_EV_XI_HV  +  mw[456] * Pct_EV_XI_HV * (1 - PA_EV_XI_HV)   
                
                
            ;XX
            elseif (i=@externalzones@ & j=@externalzones@)
                
                ;external skim
                mw[500] = mw[103] * Pct_AM_XX * PA_AM_XX  +  mw[153] * Pct_AM_XX * (1 - PA_AM_XX) +
                          mw[203] * Pct_MD_XX * PA_MD_XX  +  mw[253] * Pct_MD_XX * (1 - PA_MD_XX) + 
                          mw[303] * Pct_PM_XX * PA_PM_XX  +  mw[353] * Pct_PM_XX * (1 - PA_PM_XX) +
                          mw[403] * Pct_EV_XX * PA_EV_XX  +  mw[453] * Pct_EV_XX * (1 - PA_EV_XX)
                
                
                ;work trip skim
                mw[510] = mw[101] * Pct_AM_XX_HBW * PA_AM_XX_HBW  +  mw[151] * Pct_AM_XX_HBW * (1 - PA_AM_XX_HBW)  +
                          mw[201] * Pct_MD_XX_HBW * PA_MD_XX_HBW  +  mw[251] * Pct_MD_XX_HBW * (1 - PA_MD_XX_HBW)  +
                          mw[301] * Pct_PM_XX_HBW * PA_PM_XX_HBW  +  mw[351] * Pct_PM_XX_HBW * (1 - PA_PM_XX_HBW)  +
                          mw[401] * Pct_EV_XX_HBW * PA_EV_XX_HBW  +  mw[451] * Pct_EV_XX_HBW * (1 - PA_EV_XX_HBW)  
                
                
                ;personal trip skim
                mw[520] = mw[102] * Pct_AM_XX_HBO * PA_AM_XX_HBO  +  mw[152] * Pct_AM_XX_HBO * (1 - PA_AM_XX_HBO)  +
                          mw[202] * Pct_MD_XX_HBO * PA_MD_XX_HBO  +  mw[252] * Pct_MD_XX_HBO * (1 - PA_MD_XX_HBO)  +
                          mw[302] * Pct_PM_XX_HBO * PA_PM_XX_HBO  +  mw[352] * Pct_PM_XX_HBO * (1 - PA_PM_XX_HBO)  +
                          mw[402] * Pct_EV_XX_HBO * PA_EV_XX_HBO  +  mw[452] * Pct_EV_XX_HBO * (1 - PA_EV_XX_HBO)   
                
                mw[530] = mw[102] * Pct_AM_XX_NHB * PA_AM_XX_NHB  +  mw[152] * Pct_AM_XX_NHB * (1 - PA_AM_XX_NHB)  +
                          mw[202] * Pct_MD_XX_NHB * PA_MD_XX_NHB  +  mw[252] * Pct_MD_XX_NHB * (1 - PA_MD_XX_NHB)  +
                          mw[302] * Pct_PM_XX_NHB * PA_PM_XX_NHB  +  mw[352] * Pct_PM_XX_NHB * (1 - PA_PM_XX_NHB)  +
                          mw[402] * Pct_EV_XX_NHB * PA_EV_XX_NHB  +  mw[452] * Pct_EV_XX_NHB * (1 - PA_EV_XX_NHB)   
                
                mw[540] = mw[102] * Pct_AM_XX_HBS * PA_AM_XX_HBS  +  mw[152] * Pct_AM_XX_HBS * (1 - PA_AM_XX_HBS)  +
                          mw[202] * Pct_MD_XX_HBS * PA_MD_XX_HBS  +  mw[252] * Pct_MD_XX_HBS * (1 - PA_MD_XX_HBS)  +
                          mw[302] * Pct_PM_XX_HBS * PA_PM_XX_HBS  +  mw[352] * Pct_PM_XX_HBS * (1 - PA_PM_XX_HBS)  +
                          mw[402] * Pct_EV_XX_HBS * PA_EV_XX_HBS  +  mw[452] * Pct_EV_XX_HBS * (1 - PA_EV_XX_HBS)   
                
                mw[550] = mw[102] * Pct_AM_XX_HBC * PA_AM_XX_HBC  +  mw[152] * Pct_AM_XX_HBC * (1 - PA_AM_XX_HBC)  +
                          mw[202] * Pct_MD_XX_HBC * PA_MD_XX_HBC  +  mw[252] * Pct_MD_XX_HBC * (1 - PA_MD_XX_HBC)  +
                          mw[302] * Pct_PM_XX_HBC * PA_PM_XX_HBC  +  mw[352] * Pct_PM_XX_HBC * (1 - PA_PM_XX_HBC)  +
                          mw[402] * Pct_EV_XX_HBC * PA_EV_XX_HBC  +  mw[452] * Pct_EV_XX_HBC * (1 - PA_EV_XX_HBC)   
                
                mw[560] = mw[102] * Pct_AM_XX_Rec * PA_AM_XX_Rec  +  mw[152] * Pct_AM_XX_Rec * (1 - PA_AM_XX_Rec)  +
                          mw[202] * Pct_MD_XX_Rec * PA_MD_XX_Rec  +  mw[252] * Pct_MD_XX_Rec * (1 - PA_MD_XX_Rec)  +
                          mw[302] * Pct_PM_XX_Rec * PA_PM_XX_Rec  +  mw[352] * Pct_PM_XX_Rec * (1 - PA_PM_XX_Rec)  +
                          mw[402] * Pct_EV_XX_Rec * PA_EV_XX_Rec  +  mw[452] * Pct_EV_XX_Rec * (1 - PA_EV_XX_Rec)   
                
                
                ;light truck skim
                mw[570] = mw[104] * Pct_AM_XX_LT * PA_AM_XX_LT  +  mw[154] * Pct_AM_XX_LT * (1 - PA_AM_XX_LT)  +
                          mw[204] * Pct_MD_XX_LT * PA_MD_XX_LT  +  mw[254] * Pct_MD_XX_LT * (1 - PA_MD_XX_LT)  +
                          mw[304] * Pct_PM_XX_LT * PA_PM_XX_LT  +  mw[354] * Pct_PM_XX_LT * (1 - PA_PM_XX_LT)  +
                          mw[404] * Pct_EV_XX_LT * PA_EV_XX_LT  +  mw[454] * Pct_EV_XX_LT * (1 - PA_EV_XX_LT)   
                
                
                ;medium truck skim
                mw[580] = mw[105] * Pct_AM_XX_MD * PA_AM_XX_MD  +  mw[155] * Pct_AM_XX_MD * (1 - PA_AM_XX_MD)  +
                          mw[205] * Pct_MD_XX_MD * PA_MD_XX_MD  +  mw[255] * Pct_MD_XX_MD * (1 - PA_MD_XX_MD)  +
                          mw[305] * Pct_PM_XX_MD * PA_PM_XX_MD  +  mw[355] * Pct_PM_XX_MD * (1 - PA_PM_XX_MD)  +
                          mw[405] * Pct_EV_XX_MD * PA_EV_XX_MD  +  mw[455] * Pct_EV_XX_MD * (1 - PA_EV_XX_MD)   
                
                
                ;heavy truck skim
                mw[590] = mw[106] * Pct_AM_XX_HV * PA_AM_XX_HV  +  mw[156] * Pct_AM_XX_HV * (1 - PA_AM_XX_HV)  +
                          mw[206] * Pct_MD_XX_HV * PA_MD_XX_HV  +  mw[256] * Pct_MD_XX_HV * (1 - PA_MD_XX_HV)  +
                          mw[306] * Pct_PM_XX_HV * PA_PM_XX_HV  +  mw[356] * Pct_PM_XX_HV * (1 - PA_PM_XX_HV)  +
                          mw[406] * Pct_EV_XX_HV * PA_EV_XX_HV  +  mw[456] * Pct_EV_XX_HV * (1 - PA_EV_XX_HV)   
                
            endif  ;by movement
            
        ENDJLOOP
        
    ENDRUN
    
ENDLOOP  ;_LOS=1, 2




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    SubScriptEndTime_TD = currenttime()
    SubScriptRunTime_TD = SubScriptEndTime_TD - @SubScriptStartTime_TD@
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n        Finish time & dist avg DY skims   ', formatdatetime(SubScriptRunTime_TD, 40, 0, 'hhh:nn:ss'),
             '\n',
             '\n        Total Distribution                ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(del 1_Distribution.txt)
