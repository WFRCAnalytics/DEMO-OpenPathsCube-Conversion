
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 07_PerformFinalNetSkim.txt)



;get start time
ScriptStartTime = currenttime()



;build generalized cost path & skim times, distance, toll distance, & generalized cost
RUN PGM=HIGHWAY  MSG='Final Assign: Perform Skim of Final Loaded Network'
    
    FILEI  NETI     = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Summary.net'
           TURNPENI = '@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt'
           ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
          
    LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\BTI_Lookup.csv'
    
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_FF.mtx',
        mo=1, 100-104, 110-115, 120-123, 130-133,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    

    FILEO MATO[2] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_AM.mtx',
        mo=1, 200-204, 210-215, 220-223, 230-233,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    

    FILEO MATO[3] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_MD.mtx',
        mo=1, 300-304, 310-315, 320-323, 330-333,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    

    FILEO MATO[4] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_PM.mtx',
        mo=1, 400-404, 410-415, 420-423, 430-433,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    

    FILEO MATO[5] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_EV.mtx',
        mo=1, 500-504, 510-515, 520-523, 530-533,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    

    FILEO MATO[6] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_DY.mtx',
        mo=1, 600-604, 610-615, 620-623, 630-633,
        NAME=OVT        ,
             
             GP_TotTime ,
             GP_IVT     ,
             GP_RmpPen  ,
             GP_Dist    ,
             GP_BTI_Time,
             
             MG_TotTime ,
             MG_IVT     ,
             MG_RmpPen  ,
             MG_Dist    ,
             MG_BTI_Time,
             MG_Toll    ,
             
             MD_TotTime ,
             MD_IVT     ,
             MD_RmpPen  ,
             MD_Dist    ,
             
             HV_TotTime ,
             HV_IVT     ,
             HV_RmpPen  ,
             HV_Dist    
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    
    ZONES   = @UsedZones@
    ZONEMSG = 1
    
    
    
    ;define arrays
    ARRAY ConnectedZone = @UsedZones@
    
    
    
    PHASE=LINKREAD
        
        ;set lane GROUPS -------------------------------------------------------------------------------------
        if (li.FT=37)          ADDTOGROUP = 1           ;HOV
        if (li.FT=38)          ADDTOGROUP = 2           ;HOT
        if (li.FT=39)          ADDTOGROUP = 3           ;HOV & HOT access links
        if (li.FT=40)          ADDTOGROUP = 4           ;Tollway
        if (li.TRK_RSTRCT<>0)  ADDTOGROUP = 5           ;truck restricted links
        
        
        ;;relibility lane 11-19 (reversible lanes) on freeways, exclude off-peak direction from path choice
        ;  note: for inbound peak direction = AM & EV, for outbound peak direction = MD & PM
        if (li.Rel_LN=10-19 & li.FT>=20)
            
            if (li.IB_OB='IB')  ADDTOGROUP = 7
            if (li.IB_OB='OB')  ADDTOGROUP = 8
            
        endif  ;li.Rel_LN=10-19 & li.FT>=20
        
        
        
        ;calculate managed lane time -------------------------------------------------------------------------
        lw.FF_MG_Time = li.FF_Time
        lw.AM_MG_Time = li.AM_Time
        lw.MD_MG_Time = li.MD_Time
        lw.PM_MG_Time = li.PM_Time
        lw.EV_MG_Time = li.EV_Time
        lw.DY_MG_Time = li.DY_Time
        
        
        ;reduce time on arterial reliability lanes (do not go below free flow time)
        ;  note: assume reliability lane travels 15% less time than adjacent GP lanes
        if (li.Rel_LN>0 & li.FT<20)
            
            lw.AM_MG_Time = MAX(li.FF_Time, (li.AM_Time * 0.85))
            lw.MD_MG_Time = MAX(li.FF_Time, (li.MD_Time * 0.85))
            lw.PM_MG_Time = MAX(li.FF_Time, (li.PM_Time * 0.85))
            lw.EV_MG_Time = MAX(li.FF_Time, (li.EV_Time * 0.85))
            
            
            ;for relibility lane 11-19, reset off-peak so benefit is in peak direction only
            ;  note: for inbound peak direction = AM & EV, for outbound peak direction = MD & PM
            if (li.Rel_LN=11-19)
                
                if (li.IB_OB='IB')
                    
                    lw.MD_MG_Time = li.MD_Time   ;remove benifit in off-peak diection
                    lw.PM_MG_Time = li.PM_Time
                    
                else
                    
                    lw.AM_MG_Time = li.AM_Time
                    lw.EV_MG_Time = li.EV_Time
                    
                endif  ;li.IB_OB='IB'
                
            endif  ;li.Rel_LN=11-19
            
        endif  ;li.Rel_LN>0 & li.FT<20
        
        
        ;calculate daily time for managed lanes
        if (li.DY_VOL<1)
            
            lw.DY_MG_Time = lw.FF_MG_Time
            
        else
            
            lw.DY_MG_Time = (lw.AM_MG_Time * li.AM_VOL +
                             lw.MD_MG_Time * li.MD_VOL +
                             lw.PM_MG_Time * li.PM_VOL +
                             lw.EV_MG_Time * li.EV_VOL  ) / li.DY_VOL
            
        endif  ;li.DY_VOL<1
        
        
        
        ;toll costs (in cents) -------------------------------------------------------------------------------
        ;HOT lanes
        if (li.HOT_ZONEID>0 & li.HOT_CHRGPT>0)
            
            lw.FF_TPen = @HOT_Toll_Min@
            lw.AM_TPen = li.HOT_CHRGAM
            lw.MD_TPen = li.HOT_CHRGMD
            lw.PM_TPen = li.HOT_CHRGPM
            lw.EV_TPen = li.HOT_CHRGEV
            
        endif  ;li.HOT_ZONEID>0 & li.HOT_CHRGPT>0
        
        
        ;Tollways
        if (li.FT=40)
            
            lw.AM_TPen = li.DISTANCE * @Cost_Toll_Pk@
            lw.PM_TPen = li.DISTANCE * @Cost_Toll_Pk@
            
            lw.FF_TPen = li.DISTANCE * @Cost_Toll_Ok@
            lw.MD_TPen = li.DISTANCE * @Cost_Toll_Ok@
            lw.EV_TPen = li.DISTANCE * @Cost_Toll_Ok@
            
        endif  ;li.FT=40
        
        
        ;calculate average daily HOT & Toll costs
        if (li.DY_VOL<1)
            
            lw.DY_TPen = lw.FF_TPen
            
        else
            
            lw.DY_TPen = (lw.AM_TPen * li.AM_VOL +
                          lw.MD_TPen * li.MD_VOL +
                          lw.PM_TPen * li.PM_VOL +
                          lw.EV_TPen * li.EV_VOL  ) / li.DY_VOL
            
        endif  ;li.DY_VOL<1
        
        
        
        ;calculate total time, including ramp penalties ------------------------------------------------------
        ;general purpose
        lw.FF_TotTime = li.FF_TIME + li.FF_RampPen
        lw.AM_TotTime = li.AM_TIME + li.AM_RampPen
        lw.MD_TotTime = li.MD_TIME + li.MD_RampPen
        lw.PM_TotTime = li.PM_TIME + li.PM_RampPen
        lw.EV_TotTime = li.EV_TIME + li.EV_RampPen
        lw.DY_TotTime = li.DY_TIME + li.DY_RampPen
        
        ;managed lanes
        lw.FF_TotTime_MG = lw.FF_MG_Time + li.FF_RampPen
        lw.AM_TotTime_MG = lw.AM_MG_Time + li.AM_RampPen
        lw.MD_TotTime_MG = lw.MD_MG_Time + li.MD_RampPen
        lw.PM_TotTime_MG = lw.PM_MG_Time + li.PM_RampPen
        lw.EV_TotTime_MG = lw.EV_MG_Time + li.EV_RampPen
        lw.DY_TotTime_MG = lw.DY_MG_Time + li.DY_RampPen
        
        ;MD truck
        lw.FF_TotTime_MD = li.FF_TkTme_M + li.FF_RampPen
        lw.AM_TotTime_MD = li.AM_TkTme_M + li.AM_RampPen
        lw.MD_TotTime_MD = li.MD_TkTme_M + li.MD_RampPen
        lw.PM_TotTime_MD = li.PM_TkTme_M + li.PM_RampPen
        lw.EV_TotTime_MD = li.EV_TkTme_M + li.EV_RampPen
        lw.DY_TotTime_MD = li.DY_TkTme_M + li.DY_RampPen
        
        ;HV truck
        lw.FF_TotTime_HV = li.FF_TkTme_H + li.FF_RampPen
        lw.AM_TotTime_HV = li.AM_TkTme_H + li.AM_RampPen
        lw.MD_TotTime_HV = li.MD_TkTme_H + li.MD_RampPen
        lw.PM_TotTime_HV = li.PM_TkTme_H + li.PM_RampPen
        lw.EV_TotTime_HV = li.EV_TkTme_H + li.EV_RampPen
        lw.DY_TotTime_HV = li.DY_TkTme_H + li.DY_RampPen
        
    ENDPHASE
    
    
    
    PHASE=ILOOP
        
        ;perform skims ---------------------------------------------------------------------------------------
        
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
        
        
        ;free flow ---------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.FF_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[101]=PATHTRACE(li.FF_TIME),        NOACCESS=9999,
            mw[102]=PATHTRACE(li.FF_RampPen),     NOACCESS=0   ,
            mw[103]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[104]=PATHTRACE(li.FF_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.FF_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[111]=PATHTRACE(lw.FF_MG_Time),     NOACCESS=9999,
            mw[112]=PATHTRACE(li.FF_RampPen),     NOACCESS=0   ,
            mw[113]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[114]=PATHTRACE(li.FF_BTI_tme),     NOACCESS=0   ,
            mw[115]=PATHTRACE(lw.FF_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.FF_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[121]=PATHTRACE(li.FF_TkTme_M),     NOACCESS=9999,
            mw[122]=PATHTRACE(li.FF_RampPen),     NOACCESS=0   ,
            mw[123]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.FF_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[131]=PATHTRACE(li.FF_TkTme_H),     NOACCESS=9999,
            mw[132]=PATHTRACE(li.FF_RampPen),     NOACCESS=0   ,
            mw[133]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;AM ----------------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.AM_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[201]=PATHTRACE(li.AM_TIME),        NOACCESS=9999,
            mw[202]=PATHTRACE(li.AM_RampPen),     NOACCESS=0   ,
            mw[203]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[204]=PATHTRACE(li.AM_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.AM_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[211]=PATHTRACE(lw.AM_MG_Time),     NOACCESS=9999,
            mw[212]=PATHTRACE(li.AM_RampPen),     NOACCESS=0   ,
            mw[213]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[214]=PATHTRACE(li.AM_BTI_tme),     NOACCESS=0   ,
            mw[215]=PATHTRACE(lw.AM_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.AM_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[221]=PATHTRACE(li.AM_TkTme_M),     NOACCESS=9999,
            mw[222]=PATHTRACE(li.AM_RampPen),     NOACCESS=0   ,
            mw[223]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.AM_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[231]=PATHTRACE(li.AM_TkTme_H),     NOACCESS=9999,
            mw[232]=PATHTRACE(li.AM_RampPen),     NOACCESS=0   ,
            mw[233]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;MD ----------------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.MD_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[301]=PATHTRACE(li.MD_TIME),        NOACCESS=9999,
            mw[302]=PATHTRACE(li.MD_RampPen),     NOACCESS=0   ,
            mw[303]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[304]=PATHTRACE(li.MD_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.MD_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[311]=PATHTRACE(lw.MD_MG_Time),     NOACCESS=9999,
            mw[312]=PATHTRACE(li.MD_RampPen),     NOACCESS=0   ,
            mw[313]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[314]=PATHTRACE(li.MD_BTI_tme),     NOACCESS=0   ,
            mw[315]=PATHTRACE(lw.MD_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.MD_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[321]=PATHTRACE(li.MD_TkTme_M),     NOACCESS=9999,
            mw[322]=PATHTRACE(li.MD_RampPen),     NOACCESS=0   ,
            mw[323]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.MD_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[331]=PATHTRACE(li.MD_TkTme_H),     NOACCESS=9999,
            mw[332]=PATHTRACE(li.MD_RampPen),     NOACCESS=0   ,
            mw[333]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;PM ----------------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.PM_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[401]=PATHTRACE(li.PM_TIME),        NOACCESS=9999,
            mw[402]=PATHTRACE(li.PM_RampPen),     NOACCESS=0   ,
            mw[403]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[404]=PATHTRACE(li.PM_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.PM_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[411]=PATHTRACE(lw.PM_MG_Time),     NOACCESS=9999,
            mw[412]=PATHTRACE(li.PM_RampPen),     NOACCESS=0   ,
            mw[413]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[414]=PATHTRACE(li.PM_BTI_tme),     NOACCESS=0   ,
            mw[415]=PATHTRACE(lw.PM_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.PM_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[421]=PATHTRACE(li.PM_TkTme_M),     NOACCESS=9999,
            mw[422]=PATHTRACE(li.PM_RampPen),     NOACCESS=0   ,
            mw[423]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.PM_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[431]=PATHTRACE(li.PM_TkTme_H),     NOACCESS=9999,
            mw[432]=PATHTRACE(li.PM_RampPen),     NOACCESS=0   ,
            mw[433]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;EV ----------------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.EV_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[501]=PATHTRACE(li.EV_TIME),        NOACCESS=9999,
            mw[502]=PATHTRACE(li.EV_RampPen),     NOACCESS=0   ,
            mw[503]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[504]=PATHTRACE(li.EV_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.EV_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[511]=PATHTRACE(lw.EV_MG_Time),     NOACCESS=9999,
            mw[512]=PATHTRACE(li.EV_RampPen),     NOACCESS=0   ,
            mw[513]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[514]=PATHTRACE(li.EV_BTI_tme),     NOACCESS=0   ,
            mw[515]=PATHTRACE(lw.EV_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.EV_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[521]=PATHTRACE(li.EV_TkTme_M),     NOACCESS=9999,
            mw[522]=PATHTRACE(li.EV_RampPen),     NOACCESS=0   ,
            mw[523]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.EV_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[531]=PATHTRACE(li.EV_TkTme_H),     NOACCESS=9999,
            mw[532]=PATHTRACE(li.EV_RampPen),     NOACCESS=0   ,
            mw[533]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;DY ----------------------------------------------------------
        ;general purpose lanes
        PATHLOAD PATH=lw.DY_TotTime,
            CONSOLIDATE=T,
            PENI=1,
            EXCLUDEGROUP=1-4,7-8,                                     ;exclude HOV & HOT (& access links), Tollway & freeway reversible HOT lanes
            mw[601]=PATHTRACE(li.DY_TIME),        NOACCESS=9999,
            mw[602]=PATHTRACE(li.DY_RampPen),     NOACCESS=0   ,
            mw[603]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[604]=PATHTRACE(li.DY_BTI_tme),     NOACCESS=0   
        
        
        ;managed lanes
        PATHLOAD PATH=lw.DY_TotTime_MG,
            CONSOLIDATE=T,
            PENI=1,
           ;EXCLUDEGROUP=,                                            ;allow all managed lanes (for free flow skim)
            mw[611]=PATHTRACE(lw.DY_MG_Time),     NOACCESS=9999,
            mw[612]=PATHTRACE(li.DY_RampPen),     NOACCESS=0   ,
            mw[613]=PATHTRACE(li.DISTANCE),       NOACCESS=9999,
            mw[614]=PATHTRACE(li.DY_BTI_tme),     NOACCESS=0   ,
            mw[615]=PATHTRACE(lw.DY_TPen),        NOACCESS=0   
        
        
        ;MD truck
        PATHLOAD PATH=lw.DY_TotTime_MD, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[621]=PATHTRACE(li.DY_TkTme_M),     NOACCESS=9999,
            mw[622]=PATHTRACE(li.DY_RampPen),     NOACCESS=0   ,
            mw[623]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        ;HV truck
        PATHLOAD PATH=lw.DY_TotTime_HV, 
            CONSOLIDATE=T, 
            PENI=1,
            EXCLUDEGROUP=1-2,5,7-8,                                   ;exclude HOV, HOT, freeway reversible HOT lanes, & truck restricted facilities (but allow Tollways)
            mw[631]=PATHTRACE(li.DY_TkTme_H),     NOACCESS=9999,
            mw[632]=PATHTRACE(li.DY_RampPen),     NOACCESS=0   ,
            mw[633]=PATHTRACE(li.DISTANCE),       NOACCESS=9999
        
        
        
        ;check for TAZ connection ----------------------------------------------------------------------------
        if (i=FIRSTZONE)
            
            JLOOP
                
                ;flag connected zones
                ;  note: unconnected zones are determined if ivt = 9999
                ;        skip j=1 (intrazonal which is by definition unconnected)
                ;        this assumes TAZ=1 must be connected to network
                ConnectedZone[j] = 1
                if (j>1 & mw[101]=9999)  ConnectedZone[j] = 0
                ;PRINT FILE='test.txt', LIST=j, ConnectedZone[j]
                
            ENDJLOOP
            
        endif  ;(i=FIRSTZONE)
        
        
        
        ;calculate terminal times & intrazonal data ----------------------------------------------------------
        JLOOP
            
            ;calculate for connected zones only
            if (ConnectedZone[i]=1 & ConnectedZone[j]=1)
                
                ;calculate out of vehicle time (OVT) or terminal times -------------
                mw[1] = zi.1.TERMTIME[i] + zi.1.TERMTIME[j]
                
                
                ;add intrazonal times and distances --------------------------------
                if (i=j)
                    
                    ;calc intrazonal distance (half square root of square miles = average distance, in miles)
                    Dist_Intrazonal = 0.5 * zi.1.SQMILE[J]^0.5
                    
                    ;calc intrazonal time (assume intrazonal speed is 20 mph)
                    Time_Intrazonal = Dist_Intrazonal / @IntrazonalSpeed@ * 60
                    
                    
                    ;add intrazonal time and distance to skims
                    ;free flow
                    mw[101] = Time_Intrazonal    ;ivt GP
                    mw[111] = Time_Intrazonal    ;ivt managed
                    mw[121] = Time_Intrazonal    ;ivt MD truck
                    mw[131] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[103] = Dist_Intrazonal    ;dist GP
                    mw[113] = Dist_Intrazonal    ;dist managed
                    mw[123] = Dist_Intrazonal    ;dist MD truck
                    mw[133] = Dist_Intrazonal    ;dist HV truck
                    
                    ;AM
                    mw[201] = Time_Intrazonal    ;ivt GP
                    mw[211] = Time_Intrazonal    ;ivt managed
                    mw[221] = Time_Intrazonal    ;ivt MD truck
                    mw[231] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[203] = Dist_Intrazonal    ;dist GP
                    mw[213] = Dist_Intrazonal    ;dist managed
                    mw[223] = Dist_Intrazonal    ;dist MD truck
                    mw[233] = Dist_Intrazonal    ;dist HV truck
                    
                    ;MD
                    mw[301] = Time_Intrazonal    ;ivt GP
                    mw[311] = Time_Intrazonal    ;ivt managed
                    mw[321] = Time_Intrazonal    ;ivt MD truck
                    mw[331] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[303] = Dist_Intrazonal    ;dist GP
                    mw[313] = Dist_Intrazonal    ;dist managed
                    mw[323] = Dist_Intrazonal    ;dist MD truck
                    mw[333] = Dist_Intrazonal    ;dist HV truck
                    
                    ;PM
                    mw[401] = Time_Intrazonal    ;ivt GP
                    mw[411] = Time_Intrazonal    ;ivt managed
                    mw[421] = Time_Intrazonal    ;ivt MD truck
                    mw[431] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[403] = Dist_Intrazonal    ;dist GP
                    mw[413] = Dist_Intrazonal    ;dist managed
                    mw[423] = Dist_Intrazonal    ;dist MD truck
                    mw[433] = Dist_Intrazonal    ;dist HV truck
                    
                    ;EV
                    mw[501] = Time_Intrazonal    ;ivt GP
                    mw[511] = Time_Intrazonal    ;ivt managed
                    mw[521] = Time_Intrazonal    ;ivt MD truck
                    mw[531] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[503] = Dist_Intrazonal    ;dist GP
                    mw[513] = Dist_Intrazonal    ;dist managed
                    mw[523] = Dist_Intrazonal    ;dist MD truck
                    mw[533] = Dist_Intrazonal    ;dist HV truck
                    
                    ;DY
                    mw[601] = Time_Intrazonal    ;ivt GP
                    mw[611] = Time_Intrazonal    ;ivt managed
                    mw[621] = Time_Intrazonal    ;ivt MD truck
                    mw[631] = Time_Intrazonal    ;ivt HV truck
                    
                    mw[603] = Dist_Intrazonal    ;dist GP
                    mw[613] = Dist_Intrazonal    ;dist managed
                    mw[623] = Dist_Intrazonal    ;dist MD truck
                    mw[633] = Dist_Intrazonal    ;dist HV truck
                    
                endif  ;(i=j)
                
            endif  ;(ConnectedZone[i]=1 & ConnectedZone[j]=1)
            
        ENDJLOOP
        
        
        
        ;calculate total time ------------------------------------------------------------------------------------------
        ;  total time = ivt + RampPenalty + ovt
        ;FF
        mw[100] = mw[101] + mw[102] + mw[1]
        mw[110] = mw[111] + mw[112] + mw[1]
        mw[120] = mw[121] + mw[122] + mw[1]
        mw[130] = mw[131] + mw[132] + mw[1]
        
        ;AM
        mw[200] = mw[201] + mw[202] + mw[1]
        mw[210] = mw[211] + mw[212] + mw[1]
        mw[220] = mw[221] + mw[222] + mw[1]
        mw[230] = mw[231] + mw[232] + mw[1]
          
        ;MD
        mw[300] = mw[301] + mw[302] + mw[1]
        mw[310] = mw[311] + mw[312] + mw[1]
        mw[320] = mw[321] + mw[322] + mw[1]
        mw[330] = mw[331] + mw[332] + mw[1]
        
        ;PM
        mw[400] = mw[401] + mw[402] + mw[1]
        mw[410] = mw[411] + mw[412] + mw[1]
        mw[420] = mw[421] + mw[422] + mw[1]
        mw[430] = mw[431] + mw[432] + mw[1]
        
        ;EV
        mw[500] = mw[501] + mw[502] + mw[1]
        mw[510] = mw[511] + mw[512] + mw[1]
        mw[520] = mw[521] + mw[522] + mw[1]
        mw[530] = mw[531] + mw[532] + mw[1]
        
        ;DY
        mw[600] = mw[601] + mw[602] + mw[1]
        mw[610] = mw[611] + mw[612] + mw[1]
        mw[620] = mw[621] + mw[622] + mw[1]
        mw[630] = mw[631] + mw[632] + mw[1]
        
    ENDPHASE   
    
ENDRUN



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Final Network Skims                ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



*(del 07_PerformFinalNetSkim.txt)
