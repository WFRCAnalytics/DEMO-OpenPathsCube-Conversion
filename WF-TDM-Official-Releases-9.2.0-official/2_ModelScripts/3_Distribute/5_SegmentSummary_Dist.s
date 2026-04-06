
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_Distrib_SegSummary.txt)




;INITIALIZE DATA ===========================================================================================================================

;get start time
ScriptStartTime_DSegSum = currenttime()




RUN PGM=MATRIX MSG='Distribution: Summarize Link Data by SEGID'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.dbf',
    SORT=SEGID, 
    AUTOARRAY=ALLFIELDS
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Summary_SEGID_Detailed.csv'
    FILEO PRINTO[2] = '@ParentDir@@ScenarioDir@3_Distribute\@RID@_Distrib_Summary_SEGID.csv'
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    ;define arrays
    ARRAY TYPE=C25 SEGID_Name = 99999
    ARRAY TYPE=C25 Direction_Name = 99999
    
    ARRAY SUBAREAID = 99999, 99,          ;2nd index is for histogram
          AREATYPE  = 99999, 99,
          CO_FIPS   = 99999, 99
    
    ARRAY LANES     = 99999, 2, 5, 99,    ;3rd index is for histogram
          FT        = 99999, 2, 5, 99,
          SFF       = 99999, 2, 5, 99
    
    ARRAY NumLinks  = 99999, 2, 5,
          Dist_1Dir = 99999, 2, 5,
          CAP1HR1LN = 99999, 2, 5,
          
          AM_VMT    = 99999, 2, 5,
          MD_VMT    = 99999, 2, 5,
          PM_VMT    = 99999, 2, 5,
          EV_VMT    = 99999, 2, 5,
          DY_VMT    = 99999, 2, 5,
          AM_VMT_LT = 99999, 2, 5,
          MD_VMT_LT = 99999, 2, 5,
          PM_VMT_LT = 99999, 2, 5,
          EV_VMT_LT = 99999, 2, 5,
          DY_VMT_LT = 99999, 2, 5,
          AM_VMT_MD = 99999, 2, 5,
          MD_VMT_MD = 99999, 2, 5,
          PM_VMT_MD = 99999, 2, 5,
          EV_VMT_MD = 99999, 2, 5,
          DY_VMT_MD = 99999, 2, 5,
          AM_VMT_HV = 99999, 2, 5,
          MD_VMT_HV = 99999, 2, 5,
          PM_VMT_HV = 99999, 2, 5,
          EV_VMT_HV = 99999, 2, 5,
          DY_VMT_HV = 99999, 2, 5,
          
          AM_Vol    = 99999, 2, 5,
          MD_Vol    = 99999, 2, 5,
          PM_Vol    = 99999, 2, 5,
          EV_Vol    = 99999, 2, 5,
          DY_Vol    = 99999, 2, 5,
          AM_LT     = 99999, 2, 5,
          MD_LT     = 99999, 2, 5,
          PM_LT     = 99999, 2, 5,
          EV_LT     = 99999, 2, 5,
          DY_LT     = 99999, 2, 5,
          AM_MD     = 99999, 2, 5,
          MD_MD     = 99999, 2, 5,
          PM_MD     = 99999, 2, 5,
          EV_MD     = 99999, 2, 5,
          DY_MD     = 99999, 2, 5,
          AM_HV     = 99999, 2, 5,
          MD_HV     = 99999, 2, 5,
          PM_HV     = 99999, 2, 5,
          EV_HV     = 99999, 2, 5,
          DY_HV     = 99999, 2, 5,
          
          FF_TIME   = 99999, 2, 5,
          AM_TIME   = 99999, 2, 5,
          MD_TIME   = 99999, 2, 5,
          PM_TIME   = 99999, 2, 5,
          EV_TIME   = 99999, 2, 5,
          DY_TIME   = 99999, 2, 5,
          
          FF_SPD    = 99999, 2, 5,
          AM_SPD    = 99999, 2, 5,
          MD_SPD    = 99999, 2, 5,
          PM_SPD    = 99999, 2, 5,
          EV_SPD    = 99999, 2, 5,
          DY_SPD    = 99999, 2, 5
          
          ;note: idx1=num unique seg, idx2=direction, idx3=functional grouping
          ;idx2:
          ;  1 = NB, EB (positive direction)
          ;  2 = SB, WB (negative direction)
          ;
          ;idx3:
          ;  1 = arterial
          ;  2 = freeway
          ;  3 = managed (HOV/HOT/Toll)
          ;  4 = CD
          ;  5 = placeholder
          
    
    
    ;loop through link records =========================================================================================
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;print status to task monitor window (print only when reached whole % for faster processing)
        pct_numrec = round(numrec/dbi.1.NUMRECORDS*100)
        chk_numrec = round(numrec/dbi.1.NUMRECORDS*1000) / 10
        if (pct_numrec-chk_numrec=0)  PRINT PRINTO=0 LIST='Loop through links: ', pct_numrec(5.0), '%'
        
        
        ;assign SEGID & remove trailing and leading spaces
        SEGID = TRIM(LTRIM(dba.1.segid[numrec]))
        
        
        ;process links where SEGID exists
        if (STRLEN(SEGID)>1)
            
            ;create indices --------------------------------------------------------------------------------------------
            
            ;SEGID index
            if (Seg_Idx=0)
                Seg_Idx              = 1
                SEGID_Name[Seg_Idx]  = SEGID
            elseif (SEGID<>SEGID_Name[Seg_Idx])
                Seg_Idx              = Seg_Idx + 1
                SEGID_Name[Seg_Idx]  = SEGID
            endif
            
            
            ;direction index
            Direction = dba.1.DIRECTION[numrec]

            if (Direction='NB' | Direction='EB')
                Dir_Idx = 1
            else
                Dir_Idx = 2
            endif
            
            
            ;maintain direction name for reporting, segments with links of various directions will always retain last value
            if (Direction='NB' | Direction='SB')
                Direction_Name[Seg_Idx]  = 'NB/SB'
            else
                Direction_Name[Seg_Idx]  = 'EB/WB'
            endif

            ;functional group index
            ;CD roads (also includes flyover ramps)
            if (dba.1.FT[numrec]=21,31)
                FunGrp_Idx = 4
                
            ;managed lanes
            elseif (dba.1.FT[numrec]=37-38,40)     ;exclude managed lane connector links (FT=39)
                FunGrp_Idx = 3
                
            ;freeway general purpose lanes and loop/on/off ramps
            elseif (dba.1.FT[numrec]=20,22-29,30,32-36,41-42)
                FunGrp_Idx = 2
                
            ;arterial
            elseif (dba.1.FT[numrec]=2-7,12-15)
                FunGrp_Idx = 1
                
            else
                FunGrp_Idx = 5
                
            endif
            
            
            
            ;summarize link data by segment ----------------------------------------------------------------------------
            
            ;summarize data for segments, exclude ramp data
            if (!(dba.1.FT[numrec]=20,28-29,30,41-42))
                
                ;create histogram with value acting as the second index of the array
                idx_SUBAREAID = INT(dba.1.SUBAREAID[numrec])
                idx_AREATYPE  = INT(dba.1.AREATYPE[numrec])
                idx_CO_FIPS   = INT(dba.1.CO_FIPS[numrec])
                idx_LANES     = INT(dba.1.LANES[numrec])
                idx_FT        = INT(dba.1.FT[numrec])
                idx_SFF       = INT(dba.1.FF_SPD[numrec])
                
                if (idx_SUBAREAID<1 | idx_SUBAREAID>99)  idx_SUBAREAID = 99
                if (idx_AREATYPE <1 | idx_AREATYPE >99)  idx_AREATYPE  = 99
                if (idx_CO_FIPS  <1 | idx_CO_FIPS  >99)  idx_CO_FIPS   = 99
                if (idx_LANES    <1 | idx_LANES    >99)  idx_LANES     = 99
                if (idx_FT       <1 | idx_FT       >99)  idx_FT        = 99
                if (idx_SFF      <1 | idx_SFF      >99)  idx_SFF       = 99
                
                SUBAREAID[Seg_Idx][idx_SUBAREAID]  =  SUBAREAID[Seg_Idx][idx_SUBAREAID] + 1
                AREATYPE[Seg_Idx][idx_AREATYPE]    =  AREATYPE[Seg_Idx][idx_AREATYPE]   + 1
                CO_FIPS[Seg_Idx][idx_CO_FIPS]      =  CO_FIPS[Seg_Idx][idx_CO_FIPS]     + 1
                
                LANES[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_LANES]  =  LANES[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_LANES] + 1
                FT[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_FT]        =  FT[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_FT]       + 1
                SFF[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_SFF]      =  SFF[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_SFF]     + 1
                
                
                
                ;weight by distance & sum data by segment, direction & functional group
                CAP1HR1LN[Seg_Idx][Dir_Idx][FunGrp_Idx]  =  CAP1HR1LN[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  dba.1.CAP1HR1LN[numrec] * dba.1.DISTANCE[numrec]
                
                Dist_1Dir[Seg_Idx][Dir_Idx][FunGrp_Idx]  =  Dist_1Dir[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  dba.1.DISTANCE[numrec]
                
                
                
                ;sum by segment, direction & functional group
                FF_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = FF_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.FF_TIME[numrec]
                
                AM_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.AM_TIME[numrec]
                MD_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.MD_TIME[numrec]
                PM_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.PM_TIME[numrec]
                EV_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.EV_TIME[numrec]
                
                DY_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_TIME[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.DY_TIME[numrec]
                
                
                
                ;count number of links
                NumLinks[Seg_Idx][Dir_Idx][FunGrp_Idx] = NumLinks[Seg_Idx][Dir_Idx][FunGrp_Idx] + 1
                
            endif
            
            
            
            ;sumarized data for segments, include ramps
            
            ;calculate equivalent distance for VMT calculations
            ;  note: if segment includes ramp areas, ramp VMT is added to general purpose VMT but ramp distance is factored
            ;        to make it equivalent to general purpose lane distance
            
            ;loop ramps
            if (dba.1.FT[numrec]=20,30)
                RmpAdjFac = 0.50
                
            ;regular on/off ramps
            elseif (dba.1.FT[numrec]=28-29,41-42)
                RmpAdjFac = 0.90
                
            else
                RmpAdjFac = 1.0
                
            endif
            
            
            ;weight by distance & sum data by segment, direction & functional group
            AM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.AM_VOL[numrec] * dba.1.DISTANCE[numrec] * RmpAdjFac
            MD_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.MD_VOL[numrec] * dba.1.DISTANCE[numrec] * RmpAdjFac
            PM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.PM_VOL[numrec] * dba.1.DISTANCE[numrec] * RmpAdjFac
            EV_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] + dba.1.EV_VOL[numrec] * dba.1.DISTANCE[numrec] * RmpAdjFac
            
            DY_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                   MD_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                   PM_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                   EV_VMT[Seg_Idx][Dir_Idx][FunGrp_Idx]  
            
            AM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.AM_SLT[numrec]                         * dba.1.DISTANCE[numrec] * RmpAdjFac
            AM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SMD[numrec] + dba.1.AM_LMD[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac
            AM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SHV[numrec] + dba.1.AM_LHV[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac

            MD_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.MD_SLT[numrec]                         * dba.1.DISTANCE[numrec] * RmpAdjFac
            MD_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SMD[numrec] + dba.1.MD_LMD[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac
            MD_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SHV[numrec] + dba.1.MD_LHV[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac

            PM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.PM_SLT[numrec]                         * dba.1.DISTANCE[numrec] * RmpAdjFac
            PM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SMD[numrec] + dba.1.PM_LMD[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac
            PM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SHV[numrec] + dba.1.PM_LHV[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac

            EV_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.EV_SLT[numrec]                         * dba.1.DISTANCE[numrec] * RmpAdjFac
            EV_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SMD[numrec] + dba.1.EV_LMD[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac
            EV_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SHV[numrec] + dba.1.EV_LHV[numrec]) * dba.1.DISTANCE[numrec] * RmpAdjFac
            
            DY_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      MD_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      PM_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      EV_VMT_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  
            
            DY_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      MD_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      PM_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      EV_VMT_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  
            
            DY_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      MD_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      PM_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] +
                                                      EV_VMT_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  

        endif  ;STRLEN(SEGID)>1
    
    ENDLOOP  ;loop through link records
    
    
    
    
    ;loop through unique SEGIDs ========================================================================================
    LOOP lp_segidx=1, Seg_Idx
        
        ;print status to task monitor window
        PRINT PRINTO=0 LIST='Loop through segments: ', round(lp_segidx/Seg_Idx*100)(5.0), '%'
        
        
        
        ;find value with the highest count for categorical and count variables
        ;zero out max value for each seg iteration
        MaxCount_SUBAREAID    = 0
        MaxCount_AREATYPE     = 0
        MaxCount_CO_FIPS      = 0
        
        MaxCount_LANES_D1_Art = 0
        MaxCount_LANES_D1_Fwy = 0
        MaxCount_LANES_D1_Man = 0
        MaxCount_LANES_D1__CD = 0
        
        MaxCount_LANES_D2_Art = 0
        MaxCount_LANES_D2_Fwy = 0
        MaxCount_LANES_D2_Man = 0
        MaxCount_LANES_D2__CD = 0
        
        MaxCount_FT_D1_Art    = 0
        MaxCount_FT_D1_Fwy    = 0
        MaxCount_FT_D1_Man    = 0
        MaxCount_FT_D1__CD    = 0
        
        MaxCount_FT_D2_Art    = 0
        MaxCount_FT_D2_Fwy    = 0
        MaxCount_FT_D2_Man    = 0
        MaxCount_FT_D2__CD    = 0
        
        MaxCount_SFF_D1_Art   = 0
        MaxCount_SFF_D1_Fwy   = 0
        MaxCount_SFF_D1_Man   = 0
        MaxCount_SFF_D1__CD   = 0
        
        MaxCount_SFF_D2_Art   = 0
        MaxCount_SFF_D2_Fwy   = 0
        MaxCount_SFF_D2_Man   = 0
        MaxCount_SFF_D2__CD   = 0
        
        
        Value_SUBAREAID    = 0
        Value_AREATYPE     = 0
        Value_CO_FIPS      = 0
        
        Value_LANES_D1_Art = 0
        Value_LANES_D1_Fwy = 0
        Value_LANES_D1_Man = 0
        Value_LANES_D1__CD = 0
        
        Value_LANES_D2_Art = 0
        Value_LANES_D2_Fwy = 0
        Value_LANES_D2_Man = 0
        Value_LANES_D2__CD = 0
        
        Value_FT_D1_Art    = 0
        Value_FT_D1_Fwy    = 0
        Value_FT_D1_Man    = 0
        Value_FT_D1__CD    = 0
        
        Value_FT_D2_Art    = 0
        Value_FT_D2_Fwy    = 0
        Value_FT_D2_Man    = 0
        Value_FT_D2__CD    = 0
        
        Value_SFF_D1_Art   = 0
        Value_SFF_D1_Fwy   = 0
        Value_SFF_D1_Man   = 0
        Value_SFF_D1__CD   = 0
        
        Value_SFF_D2_Art   = 0
        Value_SFF_D2_Fwy   = 0
        Value_SFF_D2_Man   = 0
        Value_SFF_D2__CD   = 0
        
        
        ;loop through variable and find highest (max) count of the variable's value
        LOOP hist_idx=1, 99
            ;subareaid
            if (SUBAREAID[lp_segidx][hist_idx]>MaxCount_SUBAREAID)
                MaxCount_SUBAREAID = SUBAREAID[lp_segidx][hist_idx]
                Value_SUBAREAID    = hist_idx
            endif
            
            
            ;areatype
            if (AREATYPE[lp_segidx][hist_idx]>MaxCount_AREATYPE)
                MaxCount_AREATYPE = AREATYPE[lp_segidx][hist_idx]
                Value_AREATYPE    = hist_idx
            endif
            
            
            ;county FIPS
            if (CO_FIPS[lp_segidx][hist_idx]>MaxCount_CO_FIPS)
                MaxCount_CO_FIPS = CO_FIPS[lp_segidx][hist_idx]
                Value_CO_FIPS    = hist_idx
            endif
            
            
            ;lanes - positive direction
            if (LANES[lp_segidx][1][1][hist_idx]>MaxCount_LANES_D1_Art)
                MaxCount_LANES_D1_Art = LANES[lp_segidx][1][1][hist_idx]
                Value_LANES_D1_Art    = hist_idx
            endif
            
            if (LANES[lp_segidx][1][2][hist_idx]>MaxCount_LANES_D1_Fwy)
                MaxCount_LANES_D1_Fwy = LANES[lp_segidx][1][2][hist_idx]
                Value_LANES_D1_Fwy    = hist_idx
            endif
            
            if (LANES[lp_segidx][1][3][hist_idx]>MaxCount_LANES_D1_Man)
                MaxCount_LANES_D1_Man = LANES[lp_segidx][1][3][hist_idx]
                Value_LANES_D1_Man    = hist_idx
            endif
            
            if (LANES[lp_segidx][1][4][hist_idx]>MaxCount_LANES_D1__CD)
                MaxCount_LANES_D1__CD = LANES[lp_segidx][1][4][hist_idx]
                Value_LANES_D1__CD    = hist_idx
            endif
            
            ;lanes - negaitve direction
            if (LANES[lp_segidx][2][1][hist_idx]>MaxCount_LANES_D2_Art)
                MaxCount_LANES_D2_Art = LANES[lp_segidx][2][1][hist_idx]
                Value_LANES_D2_Art    = hist_idx
            endif
            
            if (LANES[lp_segidx][2][2][hist_idx]>MaxCount_LANES_D2_Fwy)
                MaxCount_LANES_D2_Fwy = LANES[lp_segidx][2][2][hist_idx]
                Value_LANES_D2_Fwy    = hist_idx
            endif
            
            if (LANES[lp_segidx][2][3][hist_idx]>MaxCount_LANES_D2_Man)
                MaxCount_LANES_D2_Man = LANES[lp_segidx][2][3][hist_idx]
                Value_LANES_D2_Man    = hist_idx
            endif
            
            if (LANES[lp_segidx][2][4][hist_idx]>MaxCount_LANES_D2__CD)
                MaxCount_LANES_D2__CD = LANES[lp_segidx][2][4][hist_idx]
                Value_LANES_D2__CD    = hist_idx
            endif
            
            
            ;FT - positive direction
            if (FT[lp_segidx][1][1][hist_idx]>MaxCount_FT_D1_Art)
                MaxCount_FT_D1_Art = FT[lp_segidx][1][1][hist_idx]
                Value_FT_D1_Art    = hist_idx
            endif
            
            if (FT[lp_segidx][1][2][hist_idx]>MaxCount_FT_D1_Fwy)
                MaxCount_FT_D1_Fwy = FT[lp_segidx][1][2][hist_idx]
                Value_FT_D1_Fwy    = hist_idx
            endif
            
            if (FT[lp_segidx][1][3][hist_idx]>MaxCount_FT_D1_Man)
                MaxCount_FT_D1_Man = FT[lp_segidx][1][3][hist_idx]
                Value_FT_D1_Man    = hist_idx
            endif
            
            if (FT[lp_segidx][1][4][hist_idx]>MaxCount_FT_D1__CD)
                MaxCount_FT_D1__CD = FT[lp_segidx][1][4][hist_idx]
                Value_FT_D1__CD    = hist_idx
            endif
            
            ;FT - negaitve direction
            if (FT[lp_segidx][2][1][hist_idx]>MaxCount_FT_D2_Art)
                MaxCount_FT_D2_Art = FT[lp_segidx][2][1][hist_idx]
                Value_FT_D2_Art    = hist_idx
            endif
            
            if (FT[lp_segidx][2][2][hist_idx]>MaxCount_FT_D2_Fwy)
                MaxCount_FT_D2_Fwy = FT[lp_segidx][2][2][hist_idx]
                Value_FT_D2_Fwy    = hist_idx
            endif
            
            if (FT[lp_segidx][2][3][hist_idx]>MaxCount_FT_D2_Man)
                MaxCount_FT_D2_Man = FT[lp_segidx][2][3][hist_idx]
                Value_FT_D2_Man    = hist_idx
            endif
            
            if (FT[lp_segidx][2][4][hist_idx]>MaxCount_FT_D2__CD)
                MaxCount_FT_D2__CD = FT[lp_segidx][2][4][hist_idx]
                Value_FT_D2__CD    = hist_idx
            endif
            
            
            ;free flow speed - positive direction
            if (SFF[lp_segidx][1][1][hist_idx]>MaxCount_SFF_D1_Art)
                MaxCount_SFF_D1_Art = SFF[lp_segidx][1][1][hist_idx]
                Value_SFF_D1_Art    = hist_idx
            endif
            
            if (SFF[lp_segidx][1][2][hist_idx]>MaxCount_SFF_D1_Fwy)
                MaxCount_SFF_D1_Fwy = SFF[lp_segidx][1][2][hist_idx]
                Value_SFF_D1_Fwy    = hist_idx
            endif
            
            if (SFF[lp_segidx][1][3][hist_idx]>MaxCount_SFF_D1_Man)
                MaxCount_SFF_D1_Man = SFF[lp_segidx][1][3][hist_idx]
                Value_SFF_D1_Man    = hist_idx
            endif
            
            if (SFF[lp_segidx][1][4][hist_idx]>MaxCount_SFF_D1__CD)
                MaxCount_SFF_D1__CD = SFF[lp_segidx][1][4][hist_idx]
                Value_SFF_D1__CD    = hist_idx
            endif
            
            ;free flow speed - negaitve direction
            if (SFF[lp_segidx][2][1][hist_idx]>MaxCount_SFF_D2_Art)
                MaxCount_SFF_D2_Art = SFF[lp_segidx][2][1][hist_idx]
                Value_SFF_D2_Art    = hist_idx
            endif
            
            if (SFF[lp_segidx][2][2][hist_idx]>MaxCount_SFF_D2_Fwy)
                MaxCount_SFF_D2_Fwy = SFF[lp_segidx][2][2][hist_idx]
                Value_SFF_D2_Fwy    = hist_idx
            endif
            
            if (SFF[lp_segidx][2][3][hist_idx]>MaxCount_SFF_D2_Man)
                MaxCount_SFF_D2_Man = SFF[lp_segidx][2][3][hist_idx]
                Value_SFF_D2_Man    = hist_idx
            endif
            
            if (SFF[lp_segidx][2][4][hist_idx]>MaxCount_SFF_D2__CD)
                MaxCount_SFF_D2__CD = SFF[lp_segidx][2][4][hist_idx]
                Value_SFF_D2__CD    = hist_idx
            endif
            
        ENDLOOP
        
        
        
        ;calc averages by segment, direction, functional group ---------------------------------------------------------
        
        LOOP Dir_Idx=1,2
            
            LOOP FunGrp_Idx=1,4
                
                ;calc avg speed (use most common free flow speed in segment if volume or time = 0)
                if (FF_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / FF_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                
                else
                    if (Dir_Idx=1)
                        
                        if (FunGrp_Idx=1)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D1_Art
                        
                        elseif (FunGrp_Idx=2)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D1_Fwy
                        
                        elseif (FunGrp_Idx=3)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D1_Man
                        
                        elseif (FunGrp_Idx=4)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D1__CD
                        endif
                        
                    elseif (Dir_Idx=2)
                        
                        if (FunGrp_Idx=1)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D2_Art
                        
                        elseif (FunGrp_Idx=2)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D2_Fwy
                        
                        elseif (FunGrp_Idx=3)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D2_Man
                        
                        elseif (FunGrp_Idx=4)
                            FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Value_SFF_D2__CD
                        endif
                        
                    endif
                    
                endif  ;FF_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0
                
                
                if (AM_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    AM_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / AM_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                else
                    AM_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx]
                endif
                
                
                if (MD_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    MD_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / MD_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                else
                    MD_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx]
                endif
                
                
                if (PM_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    PM_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / PM_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                else
                    PM_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx]
                endif
                
                
                if (EV_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    EV_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / EV_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                else
                    EV_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx]
                endif
                
                
                if (DY_TIME[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    DY_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx] / DY_TIME[lp_segidx][Dir_Idx][FunGrp_Idx] * 60
                else
                    DY_SPD[lp_segidx][Dir_Idx][FunGrp_Idx] = FF_SPD[lp_segidx][Dir_Idx][FunGrp_Idx]
                endif
                
                
                
                ;distance weighted - calculate average CAP, and VOL
                if (Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]>0)
                    
                    ;calc avg CAP1HR1LN
                    CAP1HR1LN[lp_segidx][Dir_Idx][FunGrp_Idx] = CAP1HR1LN[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    
                    
                    ;calc avg volume
                    AM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = AM_VMT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    MD_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = MD_VMT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    PM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = PM_VMT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    EV_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = EV_VMT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    DY_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = AM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                             MD_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                             PM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                             EV_Vol[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    AM_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = AM_VMT_LT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    AM_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = AM_VMT_MD[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    AM_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = AM_VMT_HV[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    MD_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = MD_VMT_LT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    MD_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = MD_VMT_MD[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    MD_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = MD_VMT_HV[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    PM_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = PM_VMT_LT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    PM_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = PM_VMT_MD[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    PM_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = PM_VMT_HV[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    EV_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = EV_VMT_LT[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    EV_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = EV_VMT_MD[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]
                    EV_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = EV_VMT_HV[lp_segidx][Dir_Idx][FunGrp_Idx] / Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]

                    DY_LT[lp_segidx][Dir_Idx][FunGrp_Idx] = AM_LT[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            MD_LT[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            PM_LT[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            EV_LT[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    DY_MD[lp_segidx][Dir_Idx][FunGrp_Idx] = AM_MD[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            MD_MD[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            PM_MD[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            EV_MD[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                    DY_HV[lp_segidx][Dir_Idx][FunGrp_Idx] = AM_HV[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            MD_HV[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            PM_HV[lp_segidx][Dir_Idx][FunGrp_Idx] +
                                                            EV_HV[lp_segidx][Dir_Idx][FunGrp_Idx]
                    
                else
                    
                    ;calc avg CAP1HR1LN
                    CAP1HR1LN[lp_segidx][Dir_Idx][FunGrp_Idx] =  0
                    
                    ;calc avg volume
                    AM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = 0
                    MD_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = 0
                    PM_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = 0
                    EV_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = 0
                    DY_Vol[lp_segidx][Dir_Idx][FunGrp_Idx] = 0

                    
                    AM_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    MD_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    PM_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    EV_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    DY_LT[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    
                    AM_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    MD_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    PM_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    EV_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    DY_MD[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0

                    AM_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    MD_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    PM_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    EV_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                    DY_HV[lp_segidx][Dir_Idx][FunGrp_Idx]  = 0
                
                endif  ;Dist_1Dir[lp_segidx][Dir_Idx][FunGrp_Idx]>0
                
            ENDLOOP  ;FunGrp_Idx=1,4
            
        ENDLOOP  ;Dir_Idx=1,2
        
        
        
        
        ;loop through functional groups to assign variables ============================================================
        LOOP FunGrp_Idx=0,4
            
            if (FunGrp_Idx=0)
                FuncGroup = 'Total'
                AddIdx = 0
                
                ;assign totals (all functional classes) for positive direction -----------------------------------------
                ;sum LINKS, LANES, and Vol
                D1_Links  = NumLinks[lp_segidx][1][1] + NumLinks[lp_segidx][1][2] + NumLinks[lp_segidx][1][3] + NumLinks[lp_segidx][1][4]
                
                
                D1_Lanes  = Value_LANES_D1_Art + Value_LANES_D1_Fwy + Value_LANES_D1_Man + Value_LANES_D1__CD
                
                
                D1_AM_VOL = AM_Vol[lp_segidx][1][1]  + AM_Vol[lp_segidx][1][2]  + AM_Vol[lp_segidx][1][3]  + AM_Vol[lp_segidx][1][4]
                D1_MD_VOL = MD_Vol[lp_segidx][1][1]  + MD_Vol[lp_segidx][1][2]  + MD_Vol[lp_segidx][1][3]  + MD_Vol[lp_segidx][1][4]
                D1_PM_VOL = PM_Vol[lp_segidx][1][1]  + PM_Vol[lp_segidx][1][2]  + PM_Vol[lp_segidx][1][3]  + PM_Vol[lp_segidx][1][4]
                D1_EV_VOL = EV_Vol[lp_segidx][1][1]  + EV_Vol[lp_segidx][1][2]  + EV_Vol[lp_segidx][1][3]  + EV_Vol[lp_segidx][1][4]
                D1_DY_VOL = DY_Vol[lp_segidx][1][1]  + DY_Vol[lp_segidx][1][2]  + DY_Vol[lp_segidx][1][3]  + DY_Vol[lp_segidx][1][4]
                
                D1_AM_LT  = AM_LT[lp_segidx][1][1]   + AM_LT[lp_segidx][1][2]   + AM_LT[lp_segidx][1][3]   + AM_LT[lp_segidx][1][4]
                D1_MD_LT  = MD_LT[lp_segidx][1][1]   + MD_LT[lp_segidx][1][2]   + MD_LT[lp_segidx][1][3]   + MD_LT[lp_segidx][1][4]
                D1_PM_LT  = PM_LT[lp_segidx][1][1]   + PM_LT[lp_segidx][1][2]   + PM_LT[lp_segidx][1][3]   + PM_LT[lp_segidx][1][4]
                D1_EV_LT  = EV_LT[lp_segidx][1][1]   + EV_LT[lp_segidx][1][2]   + EV_LT[lp_segidx][1][3]   + EV_LT[lp_segidx][1][4]
                D1_DY_LT  = DY_LT[lp_segidx][1][1]   + DY_LT[lp_segidx][1][2]   + DY_LT[lp_segidx][1][3]   + DY_LT[lp_segidx][1][4]
                
                D1_AM_MD  = AM_MD[lp_segidx][1][1]   + AM_MD[lp_segidx][1][2]   + AM_MD[lp_segidx][1][3]   + AM_MD[lp_segidx][1][4]
                D1_MD_MD  = MD_MD[lp_segidx][1][1]   + MD_MD[lp_segidx][1][2]   + MD_MD[lp_segidx][1][3]   + MD_MD[lp_segidx][1][4]
                D1_PM_MD  = PM_MD[lp_segidx][1][1]   + PM_MD[lp_segidx][1][2]   + PM_MD[lp_segidx][1][3]   + PM_MD[lp_segidx][1][4]
                D1_EV_MD  = EV_MD[lp_segidx][1][1]   + EV_MD[lp_segidx][1][2]   + EV_MD[lp_segidx][1][3]   + EV_MD[lp_segidx][1][4]
                D1_DY_MD  = DY_MD[lp_segidx][1][1]   + DY_MD[lp_segidx][1][2]   + DY_MD[lp_segidx][1][3]   + DY_MD[lp_segidx][1][4]

                D1_AM_HV  = AM_HV[lp_segidx][1][1]   + AM_HV[lp_segidx][1][2]   + AM_HV[lp_segidx][1][3]   + AM_HV[lp_segidx][1][4]
                D1_MD_HV  = MD_HV[lp_segidx][1][1]   + MD_HV[lp_segidx][1][2]   + MD_HV[lp_segidx][1][3]   + MD_HV[lp_segidx][1][4]
                D1_PM_HV  = PM_HV[lp_segidx][1][1]   + PM_HV[lp_segidx][1][2]   + PM_HV[lp_segidx][1][3]   + PM_HV[lp_segidx][1][4]
                D1_EV_HV  = EV_HV[lp_segidx][1][1]   + EV_HV[lp_segidx][1][2]   + EV_HV[lp_segidx][1][3]   + EV_HV[lp_segidx][1][4]
                D1_DY_HV  = DY_HV[lp_segidx][1][1]   + DY_HV[lp_segidx][1][2]   + DY_HV[lp_segidx][1][3]   + DY_HV[lp_segidx][1][4]  
                
                
                ;sum VMT for weighting
                D1_AM_VMT = AM_VMT[lp_segidx][1][1]     + AM_VMT[lp_segidx][1][2]     + AM_VMT[lp_segidx][1][3]     + AM_VMT[lp_segidx][1][4] 
                D1_MD_VMT = MD_VMT[lp_segidx][1][1]     + MD_VMT[lp_segidx][1][2]     + MD_VMT[lp_segidx][1][3]     + MD_VMT[lp_segidx][1][4] 
                D1_PM_VMT = PM_VMT[lp_segidx][1][1]     + PM_VMT[lp_segidx][1][2]     + PM_VMT[lp_segidx][1][3]     + PM_VMT[lp_segidx][1][4] 
                D1_EV_VMT = EV_VMT[lp_segidx][1][1]     + EV_VMT[lp_segidx][1][2]     + EV_VMT[lp_segidx][1][3]     + EV_VMT[lp_segidx][1][4] 
                D1_DY_VMT = DY_VMT[lp_segidx][1][1]     + DY_VMT[lp_segidx][1][2]     + DY_VMT[lp_segidx][1][3]     + DY_VMT[lp_segidx][1][4] 
                
                D1AMVMTLT = AM_VMT_LT[lp_segidx][1][1]  + AM_VMT_LT[lp_segidx][1][2]  + AM_VMT_LT[lp_segidx][1][3]  + AM_VMT_LT[lp_segidx][1][4] 
                D1MDVMTLT = MD_VMT_LT[lp_segidx][1][1]  + MD_VMT_LT[lp_segidx][1][2]  + MD_VMT_LT[lp_segidx][1][3]  + MD_VMT_LT[lp_segidx][1][4] 
                D1PMVMTLT = PM_VMT_LT[lp_segidx][1][1]  + PM_VMT_LT[lp_segidx][1][2]  + PM_VMT_LT[lp_segidx][1][3]  + PM_VMT_LT[lp_segidx][1][4] 
                D1EVVMTLT = EV_VMT_LT[lp_segidx][1][1]  + EV_VMT_LT[lp_segidx][1][2]  + EV_VMT_LT[lp_segidx][1][3]  + EV_VMT_LT[lp_segidx][1][4] 
                D1DYVMTLT = DY_VMT_LT[lp_segidx][1][1]  + DY_VMT_LT[lp_segidx][1][2]  + DY_VMT_LT[lp_segidx][1][3]  + DY_VMT_LT[lp_segidx][1][4] 
                
                D1AMVMTMD = AM_VMT_MD[lp_segidx][1][1]  + AM_VMT_MD[lp_segidx][1][2]  + AM_VMT_MD[lp_segidx][1][3]  + AM_VMT_MD[lp_segidx][1][4] 
                D1MDVMTMD = MD_VMT_MD[lp_segidx][1][1]  + MD_VMT_MD[lp_segidx][1][2]  + MD_VMT_MD[lp_segidx][1][3]  + MD_VMT_MD[lp_segidx][1][4] 
                D1PMVMTMD = PM_VMT_MD[lp_segidx][1][1]  + PM_VMT_MD[lp_segidx][1][2]  + PM_VMT_MD[lp_segidx][1][3]  + PM_VMT_MD[lp_segidx][1][4] 
                D1EVVMTMD = EV_VMT_MD[lp_segidx][1][1]  + EV_VMT_MD[lp_segidx][1][2]  + EV_VMT_MD[lp_segidx][1][3]  + EV_VMT_MD[lp_segidx][1][4] 
                D1DYVMTMD = DY_VMT_MD[lp_segidx][1][1]  + DY_VMT_MD[lp_segidx][1][2]  + DY_VMT_MD[lp_segidx][1][3]  + DY_VMT_MD[lp_segidx][1][4] 
                
                D1AMVMTHV = AM_VMT_HV[lp_segidx][1][1]  + AM_VMT_HV[lp_segidx][1][2]  + AM_VMT_HV[lp_segidx][1][3]  + AM_VMT_HV[lp_segidx][1][4] 
                D1MDVMTHV = MD_VMT_HV[lp_segidx][1][1]  + MD_VMT_HV[lp_segidx][1][2]  + MD_VMT_HV[lp_segidx][1][3]  + MD_VMT_HV[lp_segidx][1][4] 
                D1PMVMTHV = PM_VMT_HV[lp_segidx][1][1]  + PM_VMT_HV[lp_segidx][1][2]  + PM_VMT_HV[lp_segidx][1][3]  + PM_VMT_HV[lp_segidx][1][4] 
                D1EVVMTHV = EV_VMT_HV[lp_segidx][1][1]  + EV_VMT_HV[lp_segidx][1][2]  + EV_VMT_HV[lp_segidx][1][3]  + EV_VMT_HV[lp_segidx][1][4] 
                D1DYVMTHV = DY_VMT_HV[lp_segidx][1][1]  + DY_VMT_HV[lp_segidx][1][2]  + DY_VMT_HV[lp_segidx][1][3]  + DY_VMT_HV[lp_segidx][1][4] 
                
                ;average 1-hr, 1-lane capacity (weighted by lanes)
                if (D1_Lanes>0)
                    D1_CAP1HL = (CAP1HR1LN[lp_segidx][1][1] * Value_LANES_D1_Art +
                                 CAP1HR1LN[lp_segidx][1][2] * Value_LANES_D1_Fwy +
                                 CAP1HR1LN[lp_segidx][1][3] * Value_LANES_D1_Man +
                                 CAP1HR1LN[lp_segidx][1][4] * Value_LANES_D1__CD  ) / D1_Lanes
                else
                    D1_CAP1HL = 0
                endif
                
                
                ;average time (weighted by VMT)
                ;DY
                if (D1_DY_VOL>0)
                    D1_FF_TME = (FF_TIME[lp_segidx][1][1] * DY_VMT[lp_segidx][1][1] +
                                 FF_TIME[lp_segidx][1][2] * DY_VMT[lp_segidx][1][2] +
                                 FF_TIME[lp_segidx][1][3] * DY_VMT[lp_segidx][1][3] +
                                 FF_TIME[lp_segidx][1][4] * DY_VMT[lp_segidx][1][4]  ) / D1_DY_VMT
                
                    D1_DY_TME = (DY_TIME[lp_segidx][1][1] * DY_VMT[lp_segidx][1][1] +
                                 DY_TIME[lp_segidx][1][2] * DY_VMT[lp_segidx][1][2] +
                                 DY_TIME[lp_segidx][1][3] * DY_VMT[lp_segidx][1][3] +
                                 DY_TIME[lp_segidx][1][4] * DY_VMT[lp_segidx][1][4]  ) / D1_DY_VMT
                else
                    D1_FF_TME = 0
                    D1_DY_TME = 0
                endif
                
                
                ;AM
                if (D1_AM_VOL>0)
                    D1_AM_TME = (AM_TIME[lp_segidx][1][1] * AM_VMT[lp_segidx][1][1] +
                                 AM_TIME[lp_segidx][1][2] * AM_VMT[lp_segidx][1][2] +
                                 AM_TIME[lp_segidx][1][3] * AM_VMT[lp_segidx][1][3] +
                                 AM_TIME[lp_segidx][1][4] * AM_VMT[lp_segidx][1][4]  ) / D1_AM_VMT
                else
                    D1_AM_TME = 0
                endif
                
                
                ;MD
                if (D1_MD_VOL>0)
                    D1_MD_TME = (MD_TIME[lp_segidx][1][1] * MD_VMT[lp_segidx][1][1] +
                                 MD_TIME[lp_segidx][1][2] * MD_VMT[lp_segidx][1][2] +
                                 MD_TIME[lp_segidx][1][3] * MD_VMT[lp_segidx][1][3] +
                                 MD_TIME[lp_segidx][1][4] * MD_VMT[lp_segidx][1][4]  ) / D1_MD_VMT
                else
                    D1_MD_TME = 0
                endif
                
                
                ;PM
                if (D1_PM_VOL>0)
                    D1_PM_TME = (PM_TIME[lp_segidx][1][1] * PM_VMT[lp_segidx][1][1] +
                                 PM_TIME[lp_segidx][1][2] * PM_VMT[lp_segidx][1][2] +
                                 PM_TIME[lp_segidx][1][3] * PM_VMT[lp_segidx][1][3] +
                                 PM_TIME[lp_segidx][1][4] * PM_VMT[lp_segidx][1][4]  ) / D1_PM_VMT
                else
                    D1_PM_TME = 0
                endif
                
                
                ;EV
                if (D1_EV_VOL>0)
                    D1_EV_TME = (EV_TIME[lp_segidx][1][1] * EV_VMT[lp_segidx][1][1] +
                                 EV_TIME[lp_segidx][1][2] * EV_VMT[lp_segidx][1][2] +
                                 EV_TIME[lp_segidx][1][3] * EV_VMT[lp_segidx][1][3] +
                                 EV_TIME[lp_segidx][1][4] * EV_VMT[lp_segidx][1][4]  ) / D1_EV_VMT
                else
                    D1_EV_TME = 0
                endif
                
                
                
                ;assign distance and FT to segment Total classification
                D1_Dist   = 0
                D1_FT     = 0
                
                ;if freeway vol > arterial vol, use freeway to classify, otherwise use arterial to classify
                if (DY_Vol[lp_segidx][1][1]>0 & DY_Vol[lp_segidx][1][2]>0)
                    if (DY_Vol[lp_segidx][1][2] >= DY_Vol[lp_segidx][1][1])
                        D1_Dist   = Dist_1Dir[lp_segidx][1][2]
                        D1_FT     = Value_FT_D1_Fwy
                    else
                        D1_Dist   = Dist_1Dir[lp_segidx][1][1]
                        D1_FT     = Value_FT_D1_Art
                    endif
                    
                ;if not both arterial and freeway volumes present, but there is freeway distance, classify as freeway
                elseif (Dist_1Dir[lp_segidx][1][2]>0)
                    D1_Dist   = Dist_1Dir[lp_segidx][1][2]
                    D1_FT     = Value_FT_D1_Fwy
                    
                ;if not both arterial and freeway volumes present and not freeway distance, but there is arterial distance, classify as arterial
                elseif (Dist_1Dir[lp_segidx][1][1]>0)
                    D1_Dist   = Dist_1Dir[lp_segidx][1][1]
                    D1_FT     = Value_FT_D1_Art
                    
                ;if not arterial nor freeway, but there is managed lane distance, classify as managed
                elseif (Dist_1Dir[lp_segidx][1][3]>0)
                    D1_Dist   = Dist_1Dir[lp_segidx][1][3]
                    D1_FT     = Value_FT_D1_Man
                    
                ;if not arterial, freeway, nor managed, but there is CD distance, classify as CD
                elseif (Dist_1Dir[lp_segidx][1][4]>0)
                    D1_Dist   = Dist_1Dir[lp_segidx][1][4]
                    D1_FT     = Value_FT_D1__CD
                
                endif
                
                
                
                ;calculate avg speed from weighted average of time variables
                ;initially set to free flow speed, then recalculate if time>0
                if (D1_FT=0)
                    D1_FF_SPD = 0
                    D1_AM_SPD = 0
                    D1_MD_SPD = 0
                    D1_PM_SPD = 0
                    D1_EV_SPD = 0
                    D1_DY_SPD = 0
                
                ;CD roads (also includes flyover ramps)
                elseif (D1_FT=21,31)
                    D1_FF_SPD = FF_SPD[lp_segidx][1][4]
                    D1_AM_SPD = FF_SPD[lp_segidx][1][4]
                    D1_MD_SPD = FF_SPD[lp_segidx][1][4]
                    D1_PM_SPD = FF_SPD[lp_segidx][1][4]
                    D1_EV_SPD = FF_SPD[lp_segidx][1][4]
                    D1_DY_SPD = FF_SPD[lp_segidx][1][4]
                
                ;managed lanes
                elseif (D1_FT=37-38,40)     ;exclude managed lane connector links (FT=39)
                    D1_FF_SPD = FF_SPD[lp_segidx][1][3]
                    D1_AM_SPD = FF_SPD[lp_segidx][1][3]
                    D1_MD_SPD = FF_SPD[lp_segidx][1][3]
                    D1_PM_SPD = FF_SPD[lp_segidx][1][3]
                    D1_EV_SPD = FF_SPD[lp_segidx][1][3]
                    D1_DY_SPD = FF_SPD[lp_segidx][1][3]
                
                ;freeway general purpose lanes and loop/on/off ramps
                elseif (D1_FT=20,22-29,30,32-36,41-42)
                    D1_FF_SPD = FF_SPD[lp_segidx][1][2]
                    D1_AM_SPD = FF_SPD[lp_segidx][1][2]
                    D1_MD_SPD = FF_SPD[lp_segidx][1][2]
                    D1_PM_SPD = FF_SPD[lp_segidx][1][2]
                    D1_EV_SPD = FF_SPD[lp_segidx][1][2]
                    D1_DY_SPD = FF_SPD[lp_segidx][1][2]
                
                ;arterial
                else
                    D1_FF_SPD = FF_SPD[lp_segidx][1][1]
                    D1_AM_SPD = FF_SPD[lp_segidx][1][1]
                    D1_MD_SPD = FF_SPD[lp_segidx][1][1]
                    D1_PM_SPD = FF_SPD[lp_segidx][1][1]
                    D1_EV_SPD = FF_SPD[lp_segidx][1][1]
                    D1_DY_SPD = FF_SPD[lp_segidx][1][1]
                
                endif
                
                
                if (D1_FF_TME>0)  D1_FF_SPD = D1_Dist / D1_FF_TME * 60
                if (D1_AM_TME>0)  D1_AM_SPD = D1_Dist / D1_AM_TME * 60
                if (D1_MD_TME>0)  D1_MD_SPD = D1_Dist / D1_MD_TME * 60
                if (D1_PM_TME>0)  D1_PM_SPD = D1_Dist / D1_PM_TME * 60
                if (D1_EV_TME>0)  D1_EV_SPD = D1_Dist / D1_EV_TME * 60
                if (D1_DY_TME>0)  D1_DY_SPD = D1_Dist / D1_DY_TME * 60
                
                
                
                ;assign totals (all functional classes) for negative direction -----------------------------------------
                ;sum LINKS, LANES, and Vol
                D2_Links  = NumLinks[lp_segidx][2][1] + NumLinks[lp_segidx][2][2] + NumLinks[lp_segidx][2][3] + NumLinks[lp_segidx][2][4]
                
                
                D2_Lanes  = Value_LANES_D2_Art + Value_LANES_D2_Fwy + Value_LANES_D2_Man + Value_LANES_D2__CD
                
                
                D2_AM_VOL = AM_Vol[lp_segidx][2][1]  + AM_Vol[lp_segidx][2][2]  + AM_Vol[lp_segidx][2][3]  + AM_Vol[lp_segidx][2][4] 
                D2_MD_VOL = MD_Vol[lp_segidx][2][1]  + MD_Vol[lp_segidx][2][2]  + MD_Vol[lp_segidx][2][3]  + MD_Vol[lp_segidx][2][4] 
                D2_PM_VOL = PM_Vol[lp_segidx][2][1]  + PM_Vol[lp_segidx][2][2]  + PM_Vol[lp_segidx][2][3]  + PM_Vol[lp_segidx][2][4] 
                D2_EV_VOL = EV_Vol[lp_segidx][2][1]  + EV_Vol[lp_segidx][2][2]  + EV_Vol[lp_segidx][2][3]  + EV_Vol[lp_segidx][2][4] 
                D2_DY_VOL = DY_Vol[lp_segidx][2][1]  + DY_Vol[lp_segidx][2][2]  + DY_Vol[lp_segidx][2][3]  + DY_Vol[lp_segidx][2][4]
                
                D2_AM_LT  = AM_LT[lp_segidx][2][1]   + AM_LT[lp_segidx][2][2]   + AM_LT[lp_segidx][2][3]   + AM_LT[lp_segidx][2][4]
                D2_MD_LT  = MD_LT[lp_segidx][2][1]   + MD_LT[lp_segidx][2][2]   + MD_LT[lp_segidx][2][3]   + MD_LT[lp_segidx][2][4]
                D2_PM_LT  = PM_LT[lp_segidx][2][1]   + PM_LT[lp_segidx][2][2]   + PM_LT[lp_segidx][2][3]   + PM_LT[lp_segidx][2][4]
                D2_EV_LT  = EV_LT[lp_segidx][2][1]   + EV_LT[lp_segidx][2][2]   + EV_LT[lp_segidx][2][3]   + EV_LT[lp_segidx][2][4]
                D2_DY_LT  = DY_LT[lp_segidx][2][1]   + DY_LT[lp_segidx][2][2]   + DY_LT[lp_segidx][2][3]   + DY_LT[lp_segidx][2][4]
                
                D2_AM_MD  = AM_MD[lp_segidx][2][1]   + AM_MD[lp_segidx][2][2]   + AM_MD[lp_segidx][2][3]   + AM_MD[lp_segidx][2][4]
                D2_MD_MD  = MD_MD[lp_segidx][2][1]   + MD_MD[lp_segidx][2][2]   + MD_MD[lp_segidx][2][3]   + MD_MD[lp_segidx][2][4]
                D2_PM_MD  = PM_MD[lp_segidx][2][1]   + PM_MD[lp_segidx][2][2]   + PM_MD[lp_segidx][2][3]   + PM_MD[lp_segidx][2][4]
                D2_EV_MD  = EV_MD[lp_segidx][2][1]   + EV_MD[lp_segidx][2][2]   + EV_MD[lp_segidx][2][3]   + EV_MD[lp_segidx][2][4]
                D2_DY_MD  = DY_MD[lp_segidx][2][1]   + DY_MD[lp_segidx][2][2]   + DY_MD[lp_segidx][2][3]   + DY_MD[lp_segidx][2][4]

                D2_AM_HV  = AM_HV[lp_segidx][2][1]   + AM_HV[lp_segidx][2][2]   + AM_HV[lp_segidx][2][3]   + AM_HV[lp_segidx][2][4]
                D2_MD_HV  = MD_HV[lp_segidx][2][1]   + MD_HV[lp_segidx][2][2]   + MD_HV[lp_segidx][2][3]   + MD_HV[lp_segidx][2][4]
                D2_PM_HV  = PM_HV[lp_segidx][2][1]   + PM_HV[lp_segidx][2][2]   + PM_HV[lp_segidx][2][3]   + PM_HV[lp_segidx][2][4]
                D2_EV_HV  = EV_HV[lp_segidx][2][1]   + EV_HV[lp_segidx][2][2]   + EV_HV[lp_segidx][2][3]   + EV_HV[lp_segidx][2][4]
                D2_DY_HV  = DY_HV[lp_segidx][2][1]   + DY_HV[lp_segidx][2][2]   + DY_HV[lp_segidx][2][3]   + DY_HV[lp_segidx][2][4]  
                
                ;sum VMT for checking
                D2_AM_VMT = AM_VMT[lp_segidx][2][1]     + AM_VMT[lp_segidx][2][2]     + AM_VMT[lp_segidx][2][3]     + AM_VMT[lp_segidx][2][4] 
                D2_MD_VMT = MD_VMT[lp_segidx][2][1]     + MD_VMT[lp_segidx][2][2]     + MD_VMT[lp_segidx][2][3]     + MD_VMT[lp_segidx][2][4] 
                D2_PM_VMT = PM_VMT[lp_segidx][2][1]     + PM_VMT[lp_segidx][2][2]     + PM_VMT[lp_segidx][2][3]     + PM_VMT[lp_segidx][2][4] 
                D2_EV_VMT = EV_VMT[lp_segidx][2][1]     + EV_VMT[lp_segidx][2][2]     + EV_VMT[lp_segidx][2][3]     + EV_VMT[lp_segidx][2][4] 
                D2_DY_VMT = DY_VMT[lp_segidx][2][1]     + DY_VMT[lp_segidx][2][2]     + DY_VMT[lp_segidx][2][3]     + DY_VMT[lp_segidx][2][4] 
                
                D2AMVMTLT = AM_VMT_LT[lp_segidx][2][1]  + AM_VMT_LT[lp_segidx][2][2]  + AM_VMT_LT[lp_segidx][2][3]  + AM_VMT_LT[lp_segidx][2][4] 
                D2MDVMTLT = MD_VMT_LT[lp_segidx][2][1]  + MD_VMT_LT[lp_segidx][2][2]  + MD_VMT_LT[lp_segidx][2][3]  + MD_VMT_LT[lp_segidx][2][4] 
                D2PMVMTLT = PM_VMT_LT[lp_segidx][2][1]  + PM_VMT_LT[lp_segidx][2][2]  + PM_VMT_LT[lp_segidx][2][3]  + PM_VMT_LT[lp_segidx][2][4] 
                D2EVVMTLT = EV_VMT_LT[lp_segidx][2][1]  + EV_VMT_LT[lp_segidx][2][2]  + EV_VMT_LT[lp_segidx][2][3]  + EV_VMT_LT[lp_segidx][2][4] 
                D2DYVMTLT = DY_VMT_LT[lp_segidx][2][1]  + DY_VMT_LT[lp_segidx][2][2]  + DY_VMT_LT[lp_segidx][2][3]  + DY_VMT_LT[lp_segidx][2][4] 
                
                D2AMVMTMD = AM_VMT_MD[lp_segidx][2][1]  + AM_VMT_MD[lp_segidx][2][2]  + AM_VMT_MD[lp_segidx][2][3]  + AM_VMT_MD[lp_segidx][2][4] 
                D2MDVMTMD = MD_VMT_MD[lp_segidx][2][1]  + MD_VMT_MD[lp_segidx][2][2]  + MD_VMT_MD[lp_segidx][2][3]  + MD_VMT_MD[lp_segidx][2][4] 
                D2PMVMTMD = PM_VMT_MD[lp_segidx][2][1]  + PM_VMT_MD[lp_segidx][2][2]  + PM_VMT_MD[lp_segidx][2][3]  + PM_VMT_MD[lp_segidx][2][4] 
                D2EVVMTMD = EV_VMT_MD[lp_segidx][2][1]  + EV_VMT_MD[lp_segidx][2][2]  + EV_VMT_MD[lp_segidx][2][3]  + EV_VMT_MD[lp_segidx][2][4] 
                D2DYVMTMD = DY_VMT_MD[lp_segidx][2][1]  + DY_VMT_MD[lp_segidx][2][2]  + DY_VMT_MD[lp_segidx][2][3]  + DY_VMT_MD[lp_segidx][2][4] 

                D2AMVMTHV = AM_VMT_HV[lp_segidx][2][1]  + AM_VMT_HV[lp_segidx][2][2]  + AM_VMT_HV[lp_segidx][2][3]  + AM_VMT_HV[lp_segidx][2][4] 
                D2MDVMTHV = MD_VMT_HV[lp_segidx][2][1]  + MD_VMT_HV[lp_segidx][2][2]  + MD_VMT_HV[lp_segidx][2][3]  + MD_VMT_HV[lp_segidx][2][4] 
                D2PMVMTHV = PM_VMT_HV[lp_segidx][2][1]  + PM_VMT_HV[lp_segidx][2][2]  + PM_VMT_HV[lp_segidx][2][3]  + PM_VMT_HV[lp_segidx][2][4] 
                D2EVVMTHV = EV_VMT_HV[lp_segidx][2][1]  + EV_VMT_HV[lp_segidx][2][2]  + EV_VMT_HV[lp_segidx][2][3]  + EV_VMT_HV[lp_segidx][2][4] 
                D2DYVMTHV = DY_VMT_HV[lp_segidx][2][1]  + DY_VMT_HV[lp_segidx][2][2]  + DY_VMT_HV[lp_segidx][2][3]  + DY_VMT_HV[lp_segidx][2][4] 
                
                ;average 1-hr, 1-ln capacity (weighted by lanes)
                if (D2_Lanes>0)
                    D2_CAP1HL = (CAP1HR1LN[lp_segidx][2][1] * Value_LANES_D2_Art +
                                 CAP1HR1LN[lp_segidx][2][2] * Value_LANES_D2_Fwy +
                                 CAP1HR1LN[lp_segidx][2][3] * Value_LANES_D2_Man +
                                 CAP1HR1LN[lp_segidx][2][4] * Value_LANES_D2__CD  ) / D2_Lanes
                else
                    D2_CAP1HL = 0
                endif
                
                
                ;average time (weighted by volume)
                ;DY
                if (D2_DY_VOL>0)
                    D2_FF_TME = (FF_TIME[lp_segidx][2][1] * DY_VMT[lp_segidx][2][1] +
                                 FF_TIME[lp_segidx][2][2] * DY_VMT[lp_segidx][2][2] +
                                 FF_TIME[lp_segidx][2][3] * DY_VMT[lp_segidx][2][3] +
                                 FF_TIME[lp_segidx][2][4] * DY_VMT[lp_segidx][2][4]  ) / D2_DY_VMT
                                                                                                    
                    D2_DY_TME = (DY_TIME[lp_segidx][2][1] * DY_VMT[lp_segidx][2][1] +
                                 DY_TIME[lp_segidx][2][2] * DY_VMT[lp_segidx][2][2] +
                                 DY_TIME[lp_segidx][2][3] * DY_VMT[lp_segidx][2][3] +
                                 DY_TIME[lp_segidx][2][4] * DY_VMT[lp_segidx][2][4]  ) / D2_DY_VMT
                else                                                                                
                    D2_FF_TME = 0                                                                   
                    D2_DY_TME = 0                                                                   
                endif                                                                               
                                                                                                    
                                                                                                    
                ;AM                                                                                 
                if (D2_AM_VOL>0)                                                                    
                    D2_AM_TME = (AM_TIME[lp_segidx][2][1] * AM_VMT[lp_segidx][2][1] +
                                 AM_TIME[lp_segidx][2][2] * AM_VMT[lp_segidx][2][2] +
                                 AM_TIME[lp_segidx][2][3] * AM_VMT[lp_segidx][2][3] +
                                 AM_TIME[lp_segidx][2][4] * AM_VMT[lp_segidx][2][4]  ) / D2_AM_VMT
                else                                                                                
                    D2_AM_TME = 0                                                                   
                endif                                                                               
                                                                                                    
                                                                                                    
                ;MD                                                                                 
                if (D2_MD_VOL>0)                                                                    
                    D2_MD_TME = (MD_TIME[lp_segidx][2][1] * MD_VMT[lp_segidx][2][1] +
                                 MD_TIME[lp_segidx][2][2] * MD_VMT[lp_segidx][2][2] +
                                 MD_TIME[lp_segidx][2][3] * MD_VMT[lp_segidx][2][3] +
                                 MD_TIME[lp_segidx][2][4] * MD_VMT[lp_segidx][2][4]  ) / D2_MD_VMT
                else                                                                                
                    D2_MD_TME = 0                                                                   
                endif                                                                               
                                                                                                    
                                                                                                    
                ;PM                                                                                 
                if (D2_PM_VOL>0)                                                                    
                    D2_PM_TME = (PM_TIME[lp_segidx][2][1] * PM_VMT[lp_segidx][2][1] +
                                 PM_TIME[lp_segidx][2][2] * PM_VMT[lp_segidx][2][2] +
                                 PM_TIME[lp_segidx][2][3] * PM_VMT[lp_segidx][2][3] +
                                 PM_TIME[lp_segidx][2][4] * PM_VMT[lp_segidx][2][4]  ) / D2_PM_VMT
                else                                                                                
                    D2_PM_TME = 0                                                                   
                endif                                                                               
                                                                                                    
                                                                                                    
                ;EV                                                                                 
                if (D2_EV_VOL>0)                                                                    
                    D2_EV_TME = (EV_TIME[lp_segidx][2][1] * EV_VMT[lp_segidx][2][1] +
                                 EV_TIME[lp_segidx][2][2] * EV_VMT[lp_segidx][2][2] +
                                 EV_TIME[lp_segidx][2][3] * EV_VMT[lp_segidx][2][3] +
                                 EV_TIME[lp_segidx][2][4] * EV_VMT[lp_segidx][2][4]  ) / D2_EV_VMT
                else
                    D2_EV_TME = 0
                endif
                
                
                
                ;assign distance and FT to segment Total classification
                D2_Dist   = 0
                D2_FT     = 0
                
                ;if freeway vol > arterial vol, use freeway to classify, otherwise use arterial to classify
                if (DY_Vol[lp_segidx][2][1]>0 & DY_Vol[lp_segidx][2][2]>0)
                    if (DY_Vol[lp_segidx][2][2] >= DY_Vol[lp_segidx][2][1])
                        D2_Dist   = Dist_1Dir[lp_segidx][2][2]
                        D2_FT     = Value_FT_D2_Fwy
                    else
                        D2_Dist   = Dist_1Dir[lp_segidx][2][1]
                        D2_FT     = Value_FT_D2_Art
                    endif
                    
                ;if not both arterial and freeway volumes present, but there is freeway distance, classify as freeway
                elseif (Dist_1Dir[lp_segidx][2][2]>0)
                    D2_Dist   = Dist_1Dir[lp_segidx][2][2]
                    D2_FT     = Value_FT_D2_Fwy
                    
                ;if not both arterial and freeway volumes present and not freeway distance, but there is arterial distance, classify as arterial
                elseif (Dist_1Dir[lp_segidx][2][1]>0)
                    D2_Dist   = Dist_1Dir[lp_segidx][2][1]
                    D2_FT     = Value_FT_D2_Art
                    
                ;if not arterial nor freeway, but there is managed lane distance, classify as managed
                elseif (Dist_1Dir[lp_segidx][2][3]>0)
                    D2_Dist   = Dist_1Dir[lp_segidx][2][3]
                    D2_FT     = Value_FT_D2_Man
                    
                ;if not arterial, freeway, nor managed, but there is CD distance, classify as CD
                elseif (Dist_1Dir[lp_segidx][2][4]>0)
                    D2_Dist   = Dist_1Dir[lp_segidx][2][4]
                    D2_FT     = Value_FT_D2__CD
                
                endif
                
                
                
                ;calculate avg speed from weighted average of time variables
                ;initially set to free flow speed, then recalculate if time>0
                if (D2_FT=0)
                    D2_FF_SPD = 0
                    D2_AM_SPD = 0
                    D2_MD_SPD = 0
                    D2_PM_SPD = 0
                    D2_EV_SPD = 0
                    D2_DY_SPD = 0
                
                ;CD roads (also includes flyover ramps)
                elseif (D2_FT=21,31)
                    D2_FF_SPD = FF_SPD[lp_segidx][2][4]
                    D2_AM_SPD = FF_SPD[lp_segidx][2][4]
                    D2_MD_SPD = FF_SPD[lp_segidx][2][4]
                    D2_PM_SPD = FF_SPD[lp_segidx][2][4]
                    D2_EV_SPD = FF_SPD[lp_segidx][2][4]
                    D2_DY_SPD = FF_SPD[lp_segidx][2][4]
                
                ;managed lanes
                elseif (D2_FT=37-38,40)     ;exclude managed lane connector links (FT=39)
                    D2_FF_SPD = FF_SPD[lp_segidx][2][3]
                    D2_AM_SPD = FF_SPD[lp_segidx][2][3]
                    D2_MD_SPD = FF_SPD[lp_segidx][2][3]
                    D2_PM_SPD = FF_SPD[lp_segidx][2][3]
                    D2_EV_SPD = FF_SPD[lp_segidx][2][3]
                    D2_DY_SPD = FF_SPD[lp_segidx][2][3]
                
                ;freeway general purpose lanes and loop/on/off ramps
                elseif (D2_FT=20,22-29,30,32-36,41-42)
                    D2_FF_SPD = FF_SPD[lp_segidx][2][2]
                    D2_AM_SPD = FF_SPD[lp_segidx][2][2]
                    D2_MD_SPD = FF_SPD[lp_segidx][2][2]
                    D2_PM_SPD = FF_SPD[lp_segidx][2][2]
                    D2_EV_SPD = FF_SPD[lp_segidx][2][2]
                    D2_DY_SPD = FF_SPD[lp_segidx][2][2]
                
                ;arterial
                else
                    D2_FF_SPD = FF_SPD[lp_segidx][2][1]
                    D2_AM_SPD = FF_SPD[lp_segidx][2][1]
                    D2_MD_SPD = FF_SPD[lp_segidx][2][1]
                    D2_PM_SPD = FF_SPD[lp_segidx][2][1]
                    D2_EV_SPD = FF_SPD[lp_segidx][2][1]
                    D2_DY_SPD = FF_SPD[lp_segidx][2][1]
                
                endif
                
                
                if (D2_FF_TME>0)  D2_FF_SPD = D2_Dist / D2_FF_TME * 60
                if (D2_AM_TME>0)  D2_AM_SPD = D2_Dist / D2_AM_TME * 60
                if (D2_MD_TME>0)  D2_MD_SPD = D2_Dist / D2_MD_TME * 60
                if (D2_PM_TME>0)  D2_PM_SPD = D2_Dist / D2_PM_TME * 60
                if (D2_EV_TME>0)  D2_EV_SPD = D2_Dist / D2_EV_TME * 60
                if (D2_DY_TME>0)  D2_DY_SPD = D2_Dist / D2_DY_TME * 60
                
                
                
                ;totals for both directions ----------------------------------------------------------------------------
                ;sum both directions
                Tot_Links  = D1_Links  + D2_Links
                Tot_Lanes  = D1_Lanes  + D2_Lanes 
                
                Tot_AM_VOL = D1_AM_VOL + D2_AM_VOL
                Tot_MD_VOL = D1_MD_VOL + D2_MD_VOL
                Tot_PM_VOL = D1_PM_VOL + D2_PM_VOL
                Tot_EV_VOL = D1_EV_VOL + D2_EV_VOL
                Tot_DY_VOL = D1_DY_VOL + D2_DY_VOL
                Tot_AM_LT  = D1_AM_LT  + D2_AM_LT
                Tot_MD_LT  = D1_MD_LT  + D2_MD_LT
                Tot_PM_LT  = D1_PM_LT  + D2_PM_LT
                Tot_EV_LT  = D1_EV_LT  + D2_EV_LT
                Tot_DY_LT  = D1_DY_LT  + D2_DY_LT 
                Tot_AM_MD  = D1_AM_MD  + D2_AM_MD
                Tot_MD_MD  = D1_MD_MD  + D2_MD_MD
                Tot_PM_MD  = D1_PM_MD  + D2_PM_MD
                Tot_EV_MD  = D1_EV_MD  + D2_EV_MD
                Tot_DY_MD  = D1_DY_MD  + D2_DY_MD 
                Tot_AM_HV  = D1_AM_HV  + D2_AM_HV
                Tot_MD_HV  = D1_MD_HV  + D2_MD_HV
                Tot_PM_HV  = D1_PM_HV  + D2_PM_HV
                Tot_EV_HV  = D1_EV_HV  + D2_EV_HV
                Tot_DY_HV  = D1_DY_HV  + D2_DY_HV 
                
                Tot_AM_VMT = D1_AM_VMT + D2_AM_VMT
                Tot_MD_VMT = D1_MD_VMT + D2_MD_VMT
                Tot_PM_VMT = D1_PM_VMT + D2_PM_VMT
                Tot_EV_VMT = D1_EV_VMT + D2_EV_VMT
                Tot_DY_VMT = D1_DY_VMT + D2_DY_VMT
                
                TotAMVMTLT = D1AMVMTLT + D2AMVMTLT
                TotMDVMTLT = D1MDVMTLT + D2MDVMTLT
                TotPMVMTLT = D1PMVMTLT + D2PMVMTLT
                TotEVVMTLT = D1EVVMTLT + D2EVVMTLT
                TotDYVMTLT = D1DYVMTLT + D2DYVMTLT
                
                TotAMVMTMD = D1AMVMTMD + D2AMVMTMD
                TotMDVMTMD = D1MDVMTMD + D2MDVMTMD
                TotPMVMTMD = D1PMVMTMD + D2PMVMTMD
                TotEVVMTMD = D1EVVMTMD + D2EVVMTMD
                TotDYVMTMD = D1DYVMTMD + D2DYVMTMD
                
                TotAMVMTHV = D1AMVMTHV + D2AMVMTHV
                TotMDVMTHV = D1MDVMTHV + D2MDVMTHV
                TotPMVMTHV = D1PMVMTHV + D2PMVMTHV
                TotEVVMTHV = D1EVVMTHV + D2EVVMTHV
                TotDYVMTHV = D1DYVMTHV + D2DYVMTHV
                
                ;calculate straight average time for volume=0, else calculate weighted average (use VMT as weight)
                Tot_FF_TME = (D1_FF_TME + D2_FF_TME) / 2
                Tot_AM_TME = (D1_AM_TME + D2_AM_TME) / 2
                Tot_MD_TME = (D1_MD_TME + D2_MD_TME) / 2
                Tot_PM_TME = (D1_PM_TME + D2_PM_TME) / 2
                Tot_EV_TME = (D1_EV_TME + D2_EV_TME) / 2
                Tot_DY_TME = (D1_DY_TME + D2_DY_TME) / 2
                
                ;note, if segment has links in only one direction the following resolves into time in the direction with data
                if (Tot_DY_VMT>0)  Tot_FF_TME = (D1_FF_TME * D1_DY_VMT  +  D2_FF_TME * D2_DY_VMT)  /  Tot_DY_VMT
                if (Tot_AM_VMT>0)  Tot_AM_TME = (D1_AM_TME * D1_AM_VMT  +  D2_AM_TME * D2_AM_VMT)  /  Tot_AM_VMT
                if (Tot_MD_VMT>0)  Tot_MD_TME = (D1_MD_TME * D1_MD_VMT  +  D2_MD_TME * D2_MD_VMT)  /  Tot_MD_VMT
                if (Tot_PM_VMT>0)  Tot_PM_TME = (D1_PM_TME * D1_PM_VMT  +  D2_PM_TME * D2_PM_VMT)  /  Tot_PM_VMT
                if (Tot_EV_VMT>0)  Tot_EV_TME = (D1_EV_TME * D1_EV_VMT  +  D2_EV_TME * D2_EV_VMT)  /  Tot_EV_VMT
                if (Tot_DY_VMT>0)  Tot_DY_TME = (D1_DY_TME * D1_DY_VMT  +  D2_DY_TME * D2_DY_VMT)  /  Tot_DY_VMT
                
                
                
                ;calculate average dist and capacity using straight average for links with data in both directions
                ; else get data from one side (non-existant side is 0)
                if (D1_Dist>0 & D2_Dist>0)
                    Tot_Dist   = (D1_Dist   + D2_Dist  ) / 2
                    Tot_CAP1HL = (D1_CAP1HL + D2_CAP1HL) / 2
                
                else
                    Tot_Dist   = D1_Dist   + D2_Dist  
                    Tot_CAP1HL = D1_CAP1HL + D2_CAP1HL
                endif
                
                
                
                ;recalculate speed
                Tot_FF_SPD = (D1_FF_SPD + D2_FF_SPD) / 2
                Tot_AM_SPD = (D1_AM_SPD + D2_AM_SPD) / 2
                Tot_MD_SPD = (D1_MD_SPD + D2_MD_SPD) / 2
                Tot_PM_SPD = (D1_PM_SPD + D2_PM_SPD) / 2
                Tot_EV_SPD = (D1_EV_SPD + D2_EV_SPD) / 2
                Tot_DY_SPD = (D1_DY_SPD + D2_DY_SPD) / 2
                
                if (Tot_FF_TME>0)  Tot_FF_SPD = Tot_Dist / Tot_FF_TME * 60
                if (Tot_AM_TME>0)  Tot_AM_SPD = Tot_Dist / Tot_AM_TME * 60
                if (Tot_MD_TME>0)  Tot_MD_SPD = Tot_Dist / Tot_MD_TME * 60
                if (Tot_PM_TME>0)  Tot_PM_SPD = Tot_Dist / Tot_PM_TME * 60
                if (Tot_EV_TME>0)  Tot_EV_SPD = Tot_Dist / Tot_EV_TME * 60
                if (Tot_DY_TME>0)  Tot_DY_SPD = Tot_Dist / Tot_DY_TME * 60
                
                
                
                ;pick the highest FT of both sides for combined FT
                if (D1_FT>D2_FT)
                    Tot_FT = D1_FT
                else
                    Tot_FT = D2_FT
                endif
                
                ;segment total for calculations for functional group factor (FGFAC)
                Seg_DY_VOL = Tot_DY_VOL
                
                ;FGFAC by definitions is 1.0 for total
                FGFAC = 1.0

            ;assign variables by functional class ======================================================================
            else
                ;assign label and index --------------------------------------------------------------------------------
                if (FunGrp_Idx=1)
                    FuncGroup = 'Arterial'
                    AddIdx = 0.1
                    
                    D1_Lanes = Value_LANES_D1_Art
                    D1_FT    = Value_FT_D1_Art
                    
                    D2_Lanes = Value_LANES_D2_Art
                    D2_FT    = Value_FT_D2_Art
                
                elseif (FunGrp_Idx=2)
                    FuncGroup = 'Freeway'
                    AddIdx = 0.2
                    
                    D1_Lanes = Value_LANES_D1_Fwy
                    D1_FT    = Value_FT_D1_Fwy
                    
                    D2_Lanes = Value_LANES_D2_Fwy
                    D2_FT    = Value_FT_D2_Fwy
                
                elseif (FunGrp_Idx=3)
                    FuncGroup = 'Managed'
                    AddIdx = 0.3
                    
                    D1_Lanes = Value_LANES_D1_Man
                    D1_FT    = Value_FT_D1_Man
                    
                    D2_Lanes = Value_LANES_D2_Man
                    D2_FT    = Value_FT_D2_Man
                
                elseif (FunGrp_Idx=4)
                    FuncGroup = 'CD Road'
                    AddIdx = 0.4
                    
                    D1_Lanes = Value_LANES_D1__CD
                    D1_FT    = Value_FT_D1__CD
                    
                    D2_Lanes = Value_LANES_D2__CD
                    D2_FT    = Value_FT_D2__CD
                
                endif
                
                
                
                ;assign variables for positive direction ---------------------------------------------------------------
                D1_Links     = NumLinks[lp_segidx][1][FunGrp_Idx] 
                D1_Dist      = Dist_1Dir[lp_segidx][1][FunGrp_Idx]
                D1_CAP1HL    = CAP1HR1LN[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_VMT    = AM_VMT[lp_segidx][1][FunGrp_Idx]
                D1_MD_VMT    = MD_VMT[lp_segidx][1][FunGrp_Idx]
                D1_PM_VMT    = PM_VMT[lp_segidx][1][FunGrp_Idx]
                D1_EV_VMT    = EV_VMT[lp_segidx][1][FunGrp_Idx]
                D1_DY_VMT    = DY_VMT[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_VMT_LT = AM_VMT_LT[lp_segidx][1][FunGrp_Idx]
                D1_MD_VMT_LT = MD_VMT_LT[lp_segidx][1][FunGrp_Idx]
                D1_PM_VMT_LT = PM_VMT_LT[lp_segidx][1][FunGrp_Idx]
                D1_EV_VMT_LT = EV_VMT_LT[lp_segidx][1][FunGrp_Idx]
                D1_DY_VMT_LT = DY_VMT_LT[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_VMT_MD = AM_VMT_MD[lp_segidx][1][FunGrp_Idx]
                D1_MD_VMT_MD = MD_VMT_MD[lp_segidx][1][FunGrp_Idx]
                D1_PM_VMT_MD = PM_VMT_MD[lp_segidx][1][FunGrp_Idx]
                D1_EV_VMT_MD = EV_VMT_MD[lp_segidx][1][FunGrp_Idx]
                D1_DY_VMT_MD = DY_VMT_MD[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_VMT_HV = AM_VMT_HV[lp_segidx][1][FunGrp_Idx]
                D1_MD_VMT_HV = MD_VMT_HV[lp_segidx][1][FunGrp_Idx]
                D1_PM_VMT_HV = PM_VMT_HV[lp_segidx][1][FunGrp_Idx]
                D1_EV_VMT_HV = EV_VMT_HV[lp_segidx][1][FunGrp_Idx]
                D1_DY_VMT_HV = DY_VMT_HV[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_VOL    = AM_Vol[lp_segidx][1][FunGrp_Idx]
                D1_MD_VOL    = MD_Vol[lp_segidx][1][FunGrp_Idx]
                D1_PM_VOL    = PM_Vol[lp_segidx][1][FunGrp_Idx]
                D1_EV_VOL    = EV_Vol[lp_segidx][1][FunGrp_Idx]
                D1_DY_VOL    = DY_Vol[lp_segidx][1][FunGrp_Idx]
                
                D1_AM_LT     = AM_LT[lp_segidx][1][FunGrp_Idx]
                D1_MD_LT     = MD_LT[lp_segidx][1][FunGrp_Idx]
                D1_PM_LT     = PM_LT[lp_segidx][1][FunGrp_Idx]
                D1_EV_LT     = EV_LT[lp_segidx][1][FunGrp_Idx]
                D1_DY_LT     = DY_LT[lp_segidx][1][FunGrp_Idx]

                D1_AM_MD     = AM_MD[lp_segidx][1][FunGrp_Idx]
                D1_MD_MD     = MD_MD[lp_segidx][1][FunGrp_Idx]
                D1_PM_MD     = PM_MD[lp_segidx][1][FunGrp_Idx]
                D1_EV_MD     = EV_MD[lp_segidx][1][FunGrp_Idx]
                D1_DY_MD     = DY_MD[lp_segidx][1][FunGrp_Idx]

                D1_AM_HV     = AM_HV[lp_segidx][1][FunGrp_Idx]
                D1_MD_HV     = MD_HV[lp_segidx][1][FunGrp_Idx]
                D1_PM_HV     = PM_HV[lp_segidx][1][FunGrp_Idx]
                D1_EV_HV     = EV_HV[lp_segidx][1][FunGrp_Idx]
                D1_DY_HV     = DY_HV[lp_segidx][1][FunGrp_Idx]
                
                D1_FF_TME    = FF_TIME[lp_segidx][1][FunGrp_Idx]
                D1_AM_TME    = AM_TIME[lp_segidx][1][FunGrp_Idx]
                D1_MD_TME    = MD_TIME[lp_segidx][1][FunGrp_Idx]
                D1_PM_TME    = PM_TIME[lp_segidx][1][FunGrp_Idx]
                D1_EV_TME    = EV_TIME[lp_segidx][1][FunGrp_Idx]
                D1_DY_TME    = DY_TIME[lp_segidx][1][FunGrp_Idx]
                
                D1_FF_SPD    = FF_SPD[lp_segidx][1][FunGrp_Idx]
                D1_AM_SPD    = AM_SPD[lp_segidx][1][FunGrp_Idx]
                D1_MD_SPD    = MD_SPD[lp_segidx][1][FunGrp_Idx]
                D1_PM_SPD    = PM_SPD[lp_segidx][1][FunGrp_Idx]
                D1_EV_SPD    = EV_SPD[lp_segidx][1][FunGrp_Idx]
                D1_DY_SPD    = DY_SPD[lp_segidx][1][FunGrp_Idx]
                
                
                
                ;assign variables for negative direction ---------------------------------------------------------------
                D2_Links     = NumLinks[lp_segidx][2][FunGrp_Idx] 
                D2_Dist      = Dist_1Dir[lp_segidx][2][FunGrp_Idx]
                D2_CAP1HL    = CAP1HR1LN[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_VMT    = AM_VMT[lp_segidx][2][FunGrp_Idx]
                D2_MD_VMT    = MD_VMT[lp_segidx][2][FunGrp_Idx]
                D2_PM_VMT    = PM_VMT[lp_segidx][2][FunGrp_Idx]
                D2_EV_VMT    = EV_VMT[lp_segidx][2][FunGrp_Idx]
                D2_DY_VMT    = DY_VMT[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_VMT_LT = AM_VMT_LT[lp_segidx][2][FunGrp_Idx]
                D2_MD_VMT_LT = MD_VMT_LT[lp_segidx][2][FunGrp_Idx]
                D2_PM_VMT_LT = PM_VMT_LT[lp_segidx][2][FunGrp_Idx]
                D2_EV_VMT_LT = EV_VMT_LT[lp_segidx][2][FunGrp_Idx]
                D2_DY_VMT_LT = DY_VMT_LT[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_VMT_MD = AM_VMT_MD[lp_segidx][2][FunGrp_Idx]
                D2_MD_VMT_MD = MD_VMT_MD[lp_segidx][2][FunGrp_Idx]
                D2_PM_VMT_MD = PM_VMT_MD[lp_segidx][2][FunGrp_Idx]
                D2_EV_VMT_MD = EV_VMT_MD[lp_segidx][2][FunGrp_Idx]
                D2_DY_VMT_MD = DY_VMT_MD[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_VMT_HV = AM_VMT_HV[lp_segidx][2][FunGrp_Idx]
                D2_MD_VMT_HV = MD_VMT_HV[lp_segidx][2][FunGrp_Idx]
                D2_PM_VMT_HV = PM_VMT_HV[lp_segidx][2][FunGrp_Idx]
                D2_EV_VMT_HV = EV_VMT_HV[lp_segidx][2][FunGrp_Idx]
                D2_DY_VMT_HV = DY_VMT_HV[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_VOL    = AM_Vol[lp_segidx][2][FunGrp_Idx]
                D2_MD_VOL    = MD_Vol[lp_segidx][2][FunGrp_Idx]
                D2_PM_VOL    = PM_Vol[lp_segidx][2][FunGrp_Idx]
                D2_EV_VOL    = EV_Vol[lp_segidx][2][FunGrp_Idx]
                D2_DY_VOL    = DY_Vol[lp_segidx][2][FunGrp_Idx]
                
                D2_AM_LT     = AM_LT[lp_segidx][2][FunGrp_Idx]
                D2_MD_LT     = MD_LT[lp_segidx][2][FunGrp_Idx]
                D2_PM_LT     = PM_LT[lp_segidx][2][FunGrp_Idx]
                D2_EV_LT     = EV_LT[lp_segidx][2][FunGrp_Idx]
                D2_DY_LT     = DY_LT[lp_segidx][2][FunGrp_Idx]

                D2_AM_MD     = AM_MD[lp_segidx][2][FunGrp_Idx]
                D2_MD_MD     = MD_MD[lp_segidx][2][FunGrp_Idx]
                D2_PM_MD     = PM_MD[lp_segidx][2][FunGrp_Idx]
                D2_EV_MD     = EV_MD[lp_segidx][2][FunGrp_Idx]
                D2_DY_MD     = DY_MD[lp_segidx][2][FunGrp_Idx]

                D2_AM_HV     = AM_HV[lp_segidx][2][FunGrp_Idx]
                D2_MD_HV     = MD_HV[lp_segidx][2][FunGrp_Idx]
                D2_PM_HV     = PM_HV[lp_segidx][2][FunGrp_Idx]
                D2_EV_HV     = EV_HV[lp_segidx][2][FunGrp_Idx]
                D2_DY_HV     = DY_HV[lp_segidx][2][FunGrp_Idx]
                
                D2_FF_TME    = FF_TIME[lp_segidx][2][FunGrp_Idx]
                D2_AM_TME    = AM_TIME[lp_segidx][2][FunGrp_Idx]
                D2_MD_TME    = MD_TIME[lp_segidx][2][FunGrp_Idx]
                D2_PM_TME    = PM_TIME[lp_segidx][2][FunGrp_Idx]
                D2_EV_TME    = EV_TIME[lp_segidx][2][FunGrp_Idx]
                D2_DY_TME    = DY_TIME[lp_segidx][2][FunGrp_Idx]
                
                D2_FF_SPD    = FF_SPD[lp_segidx][2][FunGrp_Idx]
                D2_AM_SPD    = AM_SPD[lp_segidx][2][FunGrp_Idx]
                D2_MD_SPD    = MD_SPD[lp_segidx][2][FunGrp_Idx]
                D2_PM_SPD    = PM_SPD[lp_segidx][2][FunGrp_Idx]
                D2_EV_SPD    = EV_SPD[lp_segidx][2][FunGrp_Idx]
                D2_DY_SPD    = DY_SPD[lp_segidx][2][FunGrp_Idx]
                
                
                
                ;totals for both directions ----------------------------------------------------------------------------
                ;sum both directions
                Tot_Links  = D1_Links  + D2_Links
                Tot_Lanes  = D1_Lanes  + D2_Lanes 
                
                Tot_AM_VOL = D1_AM_VOL + D2_AM_VOL
                Tot_MD_VOL = D1_MD_VOL + D2_MD_VOL
                Tot_PM_VOL = D1_PM_VOL + D2_PM_VOL
                Tot_EV_VOL = D1_EV_VOL + D2_EV_VOL
                Tot_DY_VOL = D1_DY_VOL + D2_DY_VOL
                Tot_AM_LT  = D1_AM_LT  + D2_AM_LT 
                Tot_MD_LT  = D1_MD_LT  + D2_MD_LT 
                Tot_PM_LT  = D1_PM_LT  + D2_PM_LT 
                Tot_EV_LT  = D1_EV_LT  + D2_EV_LT 
                Tot_DY_LT  = D1_DY_LT  + D2_DY_LT 
                Tot_AM_MD  = D1_AM_MD  + D2_AM_MD 
                Tot_MD_MD  = D1_MD_MD  + D2_MD_MD 
                Tot_PM_MD  = D1_PM_MD  + D2_PM_MD 
                Tot_EV_MD  = D1_EV_MD  + D2_EV_MD 
                Tot_DY_MD  = D1_DY_MD  + D2_DY_MD 
                Tot_AM_HV  = D1_AM_HV  + D2_AM_HV 
                Tot_MD_HV  = D1_MD_HV  + D2_MD_HV 
                Tot_PM_HV  = D1_PM_HV  + D2_PM_HV 
                Tot_EV_HV  = D1_EV_HV  + D2_EV_HV 
                Tot_DY_HV  = D1_DY_HV  + D2_DY_HV 
                
                Tot_AM_VMT = D1_AM_VMT + D2_AM_VMT
                Tot_MD_VMT = D1_MD_VMT + D2_MD_VMT
                Tot_PM_VMT = D1_PM_VMT + D2_PM_VMT
                Tot_EV_VMT = D1_EV_VMT + D2_EV_VMT
                Tot_DY_VMT = D1_DY_VMT + D2_DY_VMT
                
                TotAMVMTLT = D1AMVMTLT + D2AMVMTLT
                TotMDVMTLT = D1MDVMTLT + D2MDVMTLT
                TotPMVMTLT = D1PMVMTLT + D2PMVMTLT
                TotEVVMTLT = D1EVVMTLT + D2EVVMTLT
                TotDYVMTLT = D1DYVMTLT + D2DYVMTLT
                
                TotAMVMTMD = D1AMVMTMD + D2AMVMTMD
                TotMDVMTMD = D1MDVMTMD + D2MDVMTMD
                TotPMVMTMD = D1PMVMTMD + D2PMVMTMD
                TotEVVMTMD = D1EVVMTMD + D2EVVMTMD
                TotDYVMTMD = D1DYVMTMD + D2DYVMTMD
                
                TotAMVMTHV = D1AMVMTHV + D2AMVMTHV
                TotMDVMTHV = D1MDVMTHV + D2MDVMTHV
                TotPMVMTHV = D1PMVMTHV + D2PMVMTHV
                TotEVVMTHV = D1EVVMTHV + D2EVVMTHV
                TotDYVMTHV = D1DYVMTHV + D2DYVMTHV
                
                
                ;calculate straight average time for volume=0, else calculate weighted average (use VMT as weight)
                Tot_FF_TME = (D1_FF_TME + D2_FF_TME) / 2
                Tot_AM_TME = (D1_AM_TME + D2_AM_TME) / 2
                Tot_MD_TME = (D1_MD_TME + D2_MD_TME) / 2
                Tot_PM_TME = (D1_PM_TME + D2_PM_TME) / 2
                Tot_EV_TME = (D1_EV_TME + D2_EV_TME) / 2
                Tot_DY_TME = (D1_DY_TME + D2_DY_TME) / 2
                
                ;note, if segment has links in only one direction the following resolves into time in the direction with data
                if (Tot_DY_VMT>0)  Tot_FF_TME = (D1_FF_TME * D1_DY_VMT  +  D2_FF_TME * D2_DY_VMT)  /  Tot_DY_VMT
                if (Tot_AM_VMT>0)  Tot_AM_TME = (D1_AM_TME * D1_AM_VMT  +  D2_AM_TME * D2_AM_VMT)  /  Tot_AM_VMT
                if (Tot_MD_VMT>0)  Tot_MD_TME = (D1_MD_TME * D1_MD_VMT  +  D2_MD_TME * D2_MD_VMT)  /  Tot_MD_VMT
                if (Tot_PM_VMT>0)  Tot_PM_TME = (D1_PM_TME * D1_PM_VMT  +  D2_PM_TME * D2_PM_VMT)  /  Tot_PM_VMT
                if (Tot_EV_VMT>0)  Tot_EV_TME = (D1_EV_TME * D1_EV_VMT  +  D2_EV_TME * D2_EV_VMT)  /  Tot_EV_VMT
                if (Tot_DY_VMT>0)  Tot_DY_TME = (D1_DY_TME * D1_DY_VMT  +  D2_DY_TME * D2_DY_VMT)  /  Tot_DY_VMT
                
                
                
                ;calculate average dist and capacity using straight average for links with data in both directions
                ; else get data from one side (non-existant side is 0)
                if (D1_Dist>0 & D2_Dist>0)
                    Tot_Dist   = (D1_Dist   + D2_Dist  ) / 2
                    Tot_CAP1HL = (D1_CAP1HL + D2_CAP1HL) / 2
                
                else
                    Tot_Dist   = D1_Dist   + D2_Dist  
                    Tot_CAP1HL = D1_CAP1HL + D2_CAP1HL
                endif
                
                
                
                ;recalculate speed
                Tot_FF_SPD = (D1_FF_SPD + D2_FF_SPD) / 2
                Tot_AM_SPD = (D1_AM_SPD + D2_AM_SPD) / 2
                Tot_MD_SPD = (D1_MD_SPD + D2_MD_SPD) / 2
                Tot_PM_SPD = (D1_PM_SPD + D2_PM_SPD) / 2
                Tot_EV_SPD = (D1_EV_SPD + D2_EV_SPD) / 2
                Tot_DY_SPD = (D1_DY_SPD + D2_DY_SPD) / 2
                
                if (Tot_FF_TME>0)  Tot_FF_SPD = Tot_Dist / Tot_FF_TME * 60
                if (Tot_AM_TME>0)  Tot_AM_SPD = Tot_Dist / Tot_AM_TME * 60
                if (Tot_MD_TME>0)  Tot_MD_SPD = Tot_Dist / Tot_MD_TME * 60
                if (Tot_PM_TME>0)  Tot_PM_SPD = Tot_Dist / Tot_PM_TME * 60
                if (Tot_EV_TME>0)  Tot_EV_SPD = Tot_Dist / Tot_EV_TME * 60
                if (Tot_DY_TME>0)  Tot_DY_SPD = Tot_Dist / Tot_DY_TME * 60
                
                
                
                ;pick the highest FT of both sides for combined FT
                if (D1_FT>D2_FT)
                    Tot_FT = D1_FT
                else
                    Tot_FT = D2_FT
                endif
                
                ;calculations for functional group factor (FGFAC)
                if (Seg_DY_VOL>0)
                    FGFAC = Tot_DY_VOL / Seg_DY_VOL
                else
                    FGFAC = 0
                endif

            endif  ;FunGrp_Idx
            


            ;assign output variables -----------------------------------------------------------------------------------
            reSEGIDIdx      = lp_segidx + AddIdx
            reSEGID         = SEGID_Name[lp_segidx]
            reDirectionName =  Direction_Name[lp_segidx]
            reFuncGroup     = FuncGroup
            
            reSUBAREAID = Value_SUBAREAID
            reCO_FIPS   = Value_CO_FIPS
            
            
            reAREATYPE  = Value_AREATYPE
            
            if (Value_AREATYPE=1)
                reATYPENAME = 'Rural'
            elseif (Value_AREATYPE=2)
                reATYPENAME = 'Transition'
            elseif (Value_AREATYPE=3)
                reATYPENAME = 'Suburban'
            elseif (Value_AREATYPE=4)
                reATYPENAME = 'Urban'
            elseif (Value_AREATYPE=5)
                reATYPENAME = 'CBD-like'
            else
                reATYPENAME = 'NA'
            endif
            
            
            reLinks      = Tot_Links 
            reDist_1Wy   = Tot_Dist  
            reLanes      = Tot_Lanes 
            reFT         = Tot_FT
            
                        
            if (Tot_FT=2)
                reFTCLASS = 'Principal Arterial'
            elseif (Tot_FT=3)
                reFTCLASS = 'Minor Arterial'
            elseif (Tot_FT=4-5)
                reFTCLASS = 'Collector'
            elseif (Tot_FT=6-7)
                reFTCLASS = 'Local'
            elseif (Tot_FT=12-15)
                reFTCLASS = 'Expressway'
            elseif (Tot_FT=20-42)
                reFTCLASS = 'Freeway'
            else
                reFTCLASS = 'Other'
            endif
            
            
            reCAP1HL     = Tot_CAP1HL
            
            
            reAM_VOL     = Tot_AM_VOL
            reMD_VOL     = Tot_MD_VOL
            rePM_VOL     = Tot_PM_VOL
            reEV_VOL     = Tot_EV_VOL
            reDY_VOL     = Tot_DY_VOL
            reAM_LT      = Tot_AM_LT
            reMD_LT      = Tot_MD_LT
            rePM_LT      = Tot_PM_LT
            reEV_LT      = Tot_EV_LT
            reDY_LT      = Tot_DY_LT
            reAM_MD      = Tot_AM_MD
            reMD_MD      = Tot_MD_MD
            rePM_MD      = Tot_PM_MD
            reEV_MD      = Tot_EV_MD
            reDY_MD      = Tot_DY_MD
            reAM_HV      = Tot_AM_HV
            reMD_HV      = Tot_MD_HV
            rePM_HV      = Tot_PM_HV
            reEV_HV      = Tot_EV_HV
            reDY_HV      = Tot_DY_HV
            
            reFF_SPD     = Tot_FF_SPD
            reAM_SPD     = MIN(Tot_AM_SPD, Tot_FF_SPD)
            reMD_SPD     = MIN(Tot_MD_SPD, Tot_FF_SPD)
            rePM_SPD     = MIN(Tot_PM_SPD, Tot_FF_SPD)
            reEV_SPD     = MIN(Tot_EV_SPD, Tot_FF_SPD)
            reDY_SPD     = MIN(Tot_DY_SPD, Tot_FF_SPD)
            
            ;functional group factors
            reFGFAC = FGFAC

            ;period factors
            if (reDY_VOL>0)
                reAM_PRDFAC = round(reAM_VOL / reDY_VOL * 10000) / 10000
                reMD_PRDFAC = round(reMD_VOL / reDY_VOL * 10000) / 10000
                reEV_PRDFAC = round(reEV_VOL / reDY_VOL * 10000) / 10000
            else
                reAM_PRDFAC = 0
                reMD_PRDFAC = 0
                reEV_PRDFAC = 0
            endif

            rePM_PRDFAC = 1 - reAM_PRDFAC - reMD_PRDFAC - reEV_PRDFAC

           ;reAM_VMT     = Tot_AM_VMT
           ;reMD_VMT     = Tot_MD_VMT
           ;rePM_VMT     = Tot_PM_VMT
           ;reEV_VMT     = Tot_EV_VMT
           ;reDY_VMT     = Tot_DY_VMT
           
           ;reFF_TIME    = Tot_FF_TME
           ;reAM_TIME    = Tot_AM_TME
           ;reMD_TIME    = Tot_MD_TME
           ;rePM_TIME    = Tot_PM_TME
           ;reEV_TIME    = Tot_EV_TME
           ;reDY_TIME    = Tot_DY_TME
            
            
            reD1_Links  = D1_Links 
            reD1_Dist   = D1_Dist  
            reD1_Lanes  = D1_Lanes 
            reD1_FT     = D1_FT    
            
                        
            if (D1_FT=2)
                reD1_FTCLASS = 'Principal Arterial'
            elseif (D1_FT=3)
                reD1_FTCLASS = 'Minor Arterial'
            elseif (D1_FT=4-5)
                reD1_FTCLASS = 'Collector'
            elseif (D1_FT=6-7)
                reD1_FTCLASS = 'Local'
            elseif (D1_FT=12-15)
                reD1_FTCLASS = 'Expressway'
            elseif (D1_FT=20-42)
                reD1_FTCLASS = 'Freeway'
            else
                reD1_FTCLASS = 'Other'
            endif
            
            
            reD1_CAP1HL = D1_CAP1HL
            
            reD1_AM_VOL = D1_AM_VOL
            reD1_MD_VOL = D1_MD_VOL
            reD1_PM_VOL = D1_PM_VOL
            reD1_EV_VOL = D1_EV_VOL
            reD1_DY_VOL = D1_DY_VOL
            reD1_AM_LT  = D1_AM_LT 
            reD1_MD_LT  = D1_MD_LT 
            reD1_PM_LT  = D1_PM_LT 
            reD1_EV_LT  = D1_EV_LT 
            reD1_DY_LT  = D1_DY_LT 
            reD1_AM_MD  = D1_AM_MD 
            reD1_MD_MD  = D1_MD_MD 
            reD1_PM_MD  = D1_PM_MD 
            reD1_EV_MD  = D1_EV_MD 
            reD1_DY_MD  = D1_DY_MD 
            reD1_AM_HV  = D1_AM_HV 
            reD1_MD_HV  = D1_MD_HV 
            reD1_PM_HV  = D1_PM_HV 
            reD1_EV_HV  = D1_EV_HV 
            reD1_DY_HV  = D1_DY_HV 
           
            reD1_FF_SPD = D1_FF_SPD
            reD1_AM_SPD = MIN(D1_AM_SPD, D1_FF_SPD)
            reD1_MD_SPD = MIN(D1_MD_SPD, D1_FF_SPD)
            reD1_PM_SPD = MIN(D1_PM_SPD, D1_FF_SPD)
            reD1_EV_SPD = MIN(D1_EV_SPD, D1_FF_SPD)
            reD1_DY_SPD = MIN(D1_DY_SPD, D1_FF_SPD)
            
           ;reD1_AM_VMT = D1_AM_VMT
           ;reD1_MD_VMT = D1_MD_VMT
           ;reD1_PM_VMT = D1_PM_VMT
           ;reD1_EV_VMT = D1_EV_VMT
           ;reD1_DY_VMT = D1_DY_VMT
            
           ;reD1_FF_TME = D1_FF_TME
           ;reD1_AM_TME = D1_AM_TME
           ;reD1_MD_TME = D1_MD_TME
           ;reD1_PM_TME = D1_PM_TME
           ;reD1_EV_TME = D1_EV_TME
           ;reD1_DY_TME = D1_DY_TME
            
            
            reD2_Links  = D2_Links 
            reD2_Dist   = D2_Dist  
            reD2_Lanes  = D2_Lanes 
            reD2_FT     = D2_FT    
            
                        
            if (D2_FT=2)
                reD2_FTCLASS = 'Principal Arterial'
            elseif (D2_FT=3)
                reD2_FTCLASS = 'Minor Arterial'
            elseif (D2_FT=4-5)
                reD2_FTCLASS = 'Collector'
            elseif (D2_FT=6-7)
                reD2_FTCLASS = 'Local'
            elseif (D2_FT=12-15)
                reD2_FTCLASS = 'Expressway'
            elseif (D2_FT=20-42)
                reD2_FTCLASS = 'Freeway'
            else
                reD2_FTCLASS = 'Other'
            endif
            
            
            reD2_CAP1HL = D2_CAP1HL
            
            reD2_AM_VOL = D2_AM_VOL
            reD2_MD_VOL = D2_MD_VOL
            reD2_PM_VOL = D2_PM_VOL
            reD2_EV_VOL = D2_EV_VOL
            reD2_DY_VOL = D2_DY_VOL
            reD2_AM_LT  = D2_AM_LT 
            reD2_MD_LT  = D2_MD_LT 
            reD2_PM_LT  = D2_PM_LT 
            reD2_EV_LT  = D2_EV_LT 
            reD2_DY_LT  = D2_DY_LT 
            reD2_AM_MD  = D2_AM_MD 
            reD2_MD_MD  = D2_MD_MD 
            reD2_PM_MD  = D2_PM_MD 
            reD2_EV_MD  = D2_EV_MD 
            reD2_DY_MD  = D2_DY_MD 
            reD2_AM_HV  = D2_AM_HV 
            reD2_MD_HV  = D2_MD_HV 
            reD2_PM_HV  = D2_PM_HV 
            reD2_EV_HV  = D2_EV_HV 
            reD2_DY_HV  = D2_DY_HV 
           
            reD2_FF_SPD = D2_FF_SPD
            reD2_AM_SPD = MIN(D2_AM_SPD, D2_FF_SPD)
            reD2_MD_SPD = MIN(D2_MD_SPD, D2_FF_SPD)
            reD2_PM_SPD = MIN(D2_PM_SPD, D2_FF_SPD)
            reD2_EV_SPD = MIN(D2_EV_SPD, D2_FF_SPD)
            reD2_DY_SPD = MIN(D2_DY_SPD, D2_FF_SPD)
            
           ;reD2_AM_VMT = D2_AM_VMT
           ;reD2_MD_VMT = D2_MD_VMT
           ;reD2_PM_VMT = D2_PM_VMT
           ;reD2_EV_VMT = D2_EV_VMT
           ;reD2_DY_VMT = D2_DY_VMT
            
           ;reD2_FF_TME = D2_FF_TME
           ;reD2_AM_TME = D2_AM_TME
           ;reD2_MD_TME = D2_MD_TME
           ;reD2_PM_TME = D2_PM_TME
           ;reD2_EV_TME = D2_EV_TME
           ;reD2_DY_TME = D2_DY_TME

            ;direction factors (DFAC) for D1

            if (D1_AM_VOL + D2_AM_VOL > 0)
                reD1_AM_DFAC = round(D1_AM_VOL / (D1_AM_VOL + D2_AM_VOL) * 10000) / 10000
            else
                reD1_AM_DFAC = 0
            endif

            if (D1_MD_VOL + D2_MD_VOL > 0)
                reD1_MD_DFAC = round(D1_MD_VOL / (D1_MD_VOL + D2_MD_VOL) * 10000) / 10000
            else
                reD1_MD_DFAC = 0
            endif
            
            if (D1_PM_VOL + D2_PM_VOL > 0)
                reD1_PM_DFAC = round(D1_PM_VOL / (D1_PM_VOL + D2_PM_VOL) * 10000) / 10000
            else
                reD1_PM_DFAC = 0
            endif
            
            if (D1_EV_VOL + D2_EV_VOL > 0)
                reD1_EV_DFAC = round(D1_EV_VOL / (D1_EV_VOL + D2_EV_VOL) * 10000) / 10000
            else
                reD1_EV_DFAC = 0
            endif
            
            if (D1_DY_VOL + D2_DY_VOL > 0)
                reD1_DY_DFAC = round(D1_DY_VOL / (D1_DY_VOL + D2_DY_VOL) * 10000) / 10000
            else
                reD1_DY_DFAC = 0
            endif

            ;direction factors (DFAC) for D2

            reD2_AM_DFAC = 1 - reD1_AM_DFAC
            reD2_MD_DFAC = 1 - reD1_MD_DFAC
            reD2_PM_DFAC = 1 - reD1_PM_DFAC
            reD2_EV_DFAC = 1 - reD1_EV_DFAC
            reD2_DY_DFAC = 1 - reD1_DY_DFAC

            ;truck percentages

            reD1_AM_MDPCT = 0
            reD1_MD_MDPCT = 0
            reD1_PM_MDPCT = 0
            reD1_EV_MDPCT = 0
            reD1_DY_MDPCT = 0

            reD1_AM_HVPCT = 0
            reD1_MD_HVPCT = 0
            reD1_PM_HVPCT = 0
            reD1_EV_HVPCT = 0
            reD1_DY_HVPCT = 0

            reD2_AM_MDPCT = 0
            reD2_MD_MDPCT = 0
            reD2_PM_MDPCT = 0
            reD2_EV_MDPCT = 0
            reD2_DY_MDPCT = 0

            reD2_AM_HVPCT = 0
            reD2_MD_HVPCT = 0
            reD2_PM_HVPCT = 0
            reD2_EV_HVPCT = 0
            reD2_DY_HVPCT = 0
            
            if (reD1_AM_VOL>0) reD1_AM_MDPCT = reD1_AM_MD / reD1_AM_VOL * 100
            if (reD1_MD_VOL>0) reD1_MD_MDPCT = reD1_MD_MD / reD1_MD_VOL * 100
            if (reD1_PM_VOL>0) reD1_PM_MDPCT = reD1_PM_MD / reD1_PM_VOL * 100
            if (reD1_EV_VOL>0) reD1_EV_MDPCT = reD1_EV_MD / reD1_EV_VOL * 100
            if (reD1_DY_VOL>0) reD1_DY_MDPCT = reD1_DY_MD / reD1_DY_VOL * 100

            if (reD1_AM_VOL>0) reD1_AM_HVPCT = reD1_AM_HV / reD1_AM_VOL * 100
            if (reD1_MD_VOL>0) reD1_MD_HVPCT = reD1_MD_HV / reD1_MD_VOL * 100
            if (reD1_PM_VOL>0) reD1_PM_HVPCT = reD1_PM_HV / reD1_PM_VOL * 100
            if (reD1_EV_VOL>0) reD1_EV_HVPCT = reD1_EV_HV / reD1_EV_VOL * 100
            if (reD1_DY_VOL>0) reD1_DY_HVPCT = reD1_DY_HV / reD1_DY_VOL * 100

            if (reD2_AM_VOL>0) reD2_AM_MDPCT = reD2_AM_MD / reD2_AM_VOL * 100
            if (reD2_MD_VOL>0) reD2_MD_MDPCT = reD2_MD_MD / reD2_MD_VOL * 100
            if (reD2_PM_VOL>0) reD2_PM_MDPCT = reD2_PM_MD / reD2_PM_VOL * 100
            if (reD2_EV_VOL>0) reD2_EV_MDPCT = reD2_EV_MD / reD2_EV_VOL * 100
            if (reD2_DY_VOL>0) reD2_DY_MDPCT = reD2_DY_MD / reD2_DY_VOL * 100
            
            if (reD2_AM_VOL>0) reD2_AM_HVPCT = reD2_AM_HV / reD2_AM_VOL * 100
            if (reD2_MD_VOL>0) reD2_MD_HVPCT = reD2_MD_HV / reD2_MD_VOL * 100
            if (reD2_PM_VOL>0) reD2_PM_HVPCT = reD2_PM_HV / reD2_PM_VOL * 100
            if (reD2_EV_VOL>0) reD2_EV_HVPCT = reD2_EV_HV / reD2_EV_VOL * 100
            if (reD2_DY_VOL>0) reD2_DY_HVPCT = reD2_DY_HV / reD2_DY_VOL * 100

            ;write out data to files -----------------------------------------------------------------------------------
            
            ;WRITE RECO=1
            
            ;CSV Header for First Segment and First FuncGroup Index
            if (lp_segidx=1 & AddIdx=0)            
                PRINT PRINTO=1, 
                    CSV=T,
                    LIST='SEGIDIDX',
                    'SEGID'        ,
                    'DIRECTIONS'   ,
                    'FUNCGROUP'    ,
                    'SUBAREAID'    ,
                    'CO_FIPS'      ,
                    'AREATYPE'     ,
                    'ATYPENAME'    ,
                    'LINKS'        ,
                    'DIST_1WY'     ,
                    'Lanes'        ,
                    'FT'           ,
                    'FTCLASS'      ,
                    'CAP1HL'       ,
                    'AM_VOL'       ,
                    'MD_VOL'       ,
                    'PM_VOL'       ,
                    'EV_VOL'       ,
                    'DY_VOL'       ,
                    'AM_LT'        ,
                    'MD_LT'        ,
                    'PM_LT'        ,
                    'EV_LT'        ,
                    'DY_LT'        ,
                    'AM_MD'        ,
                    'MD_MD'        ,
                    'PM_MD'        ,
                    'EV_MD'        ,
                    'DY_MD'        ,
                    'AM_HV'        ,
                    'MD_HV'        ,
                    'PM_HV'        ,
                    'EV_HV'        ,
                    'DY_HV'        ,
                    'FF_SPD'       ,
                    'AM_SPD'       ,
                    'MD_SPD'       ,
                    'PM_SPD'       ,
                    'EV_SPD'       ,
                    'DY_SPD'       ,
                    'FGFAC'        ,
                    'AM_PRDFAC'    ,
                    'MD_PRDFAC'    ,
                    'PM_PRDFAC'    ,
                    'EV_PRDFAC'    ,
                   ;'AM_VMT'       ,
                   ;'MD_VMT'       ,
                   ;'PM_VMT'       ,
                   ;'EV_VMT'       ,
                   ;'DY_VMT'       ,
                   ;'FF_TIME'      ,
                   ;'AM_TIME'      ,
                   ;'MD_TIME'      ,
                   ;'PM_TIME'      ,
                   ;'EV_TIME'      ,
                   ;'DY_TIME'      ,
                    'D1_LINKS'     ,
                    'D1_DIST'      ,
                    'D1_LANES'     ,
                    'D1_FT'        ,
                    'D1_FTCLASS'   ,
                    'D1_CAP1HL'    ,
                    'D1_AM_VOL'    ,
                    'D1_MD_VOL'    ,
                    'D1_PM_VOL'    ,
                    'D1_EV_VOL'    ,
                    'D1_DY_VOL'    ,
                    'D1_AM_LT'     ,
                    'D1_MD_LT'     ,
                    'D1_PM_LT'     ,
                    'D1_EV_LT'     ,
                    'D1_DY_LT'     ,
                    'D1_AM_MD'     ,
                    'D1_MD_MD'     ,
                    'D1_PM_MD'     ,
                    'D1_EV_MD'     ,
                    'D1_DY_MD'     ,
                    'D1_AM_HV'     ,
                    'D1_MD_HV'     ,
                    'D1_PM_HV'     ,
                    'D1_EV_HV'     ,
                    'D1_DY_HV'     ,
                    'D1_FF_SPD'    ,
                    'D1_AM_SPD'    ,
                    'D1_MD_SPD'    ,
                    'D1_PM_SPD'    ,
                    'D1_EV_SPD'    ,
                    'D1_DY_SPD'    ,
                    'D1_AM_DFAC'   ,
                    'D1_MD_DFAC'   ,
                    'D1_PM_DFAC'   ,
                    'D1_EV_DFAC'   ,
                    'D1_DY_DFAC'   ,
                   ;'D1_AM_VMT'    ,
                   ;'D1_MD_VMT'    ,
                   ;'D1_PM_VMT'    ,
                   ;'D1_EV_VMT'    ,
                   ;'D1_DY_VMT'    ,
                   ;'D1_FF_TME'    ,
                   ;'D1_AM_TME'    ,
                   ;'D1_MD_TME'    ,
                   ;'D1_PM_TME'    ,
                   ;'D1_EV_TME'    ,
                   ;'D1_DY_TME'    ,
                    'D1_AM_MDPCT'  ,
                    'D1_MD_MDPCT'  ,
                    'D1_PM_MDPCT'  ,
                    'D1_EV_MDPCT'  ,
                    'D1_DY_MDPCT'  ,
                    'D1_AM_HVPCT'  ,
                    'D1_MD_HVPCT'  ,
                    'D1_PM_HVPCT'  ,
                    'D1_EV_HVPCT'  ,
                    'D1_DY_HVPCT'  ,
                    'D2_LINKS'     ,
                    'D2_DIST'      ,
                    'D2_LANES'     ,
                    'D2_FT'        ,
                    'D2_FTCLASS'   ,
                    'D2_CAP1HL'    ,
                    'D2_AM_VOL'    ,
                    'D2_MD_VOL'    ,
                    'D2_PM_VOL'    ,
                    'D2_EV_VOL'    ,
                    'D2_DY_VOL'    ,
                    'D2_AM_LT'     ,
                    'D2_MD_LT'     ,
                    'D2_PM_LT'     ,
                    'D2_EV_LT'     ,
                    'D2_DY_LT'     ,
                    'D2_AM_MD'     ,
                    'D2_MD_MD'     ,
                    'D2_PM_MD'     ,
                    'D2_EV_MD'     ,
                    'D2_DY_MD'     ,
                    'D2_AM_HV'     ,
                    'D2_MD_HV'     ,
                    'D2_PM_HV'     ,
                    'D2_EV_HV'     ,
                    'D2_DY_HV'     ,
                    'D2_FF_SPD'    ,
                    'D2_AM_SPD'    ,
                    'D2_MD_SPD'    ,
                    'D2_PM_SPD'    ,
                    'D2_EV_SPD'    ,
                    'D2_DY_SPD'    ,
                    'D2_AM_DFAC'   ,
                    'D2_MD_DFAC'   ,
                    'D2_PM_DFAC'   ,
                    'D2_EV_DFAC'   ,
                    'D2_DY_DFAC'   ,
                    'D2_AM_MDPCT'  ,
                    'D2_MD_MDPCT'  ,
                    'D2_PM_MDPCT'  ,
                    'D2_EV_MDPCT'  ,
                    'D2_DY_MDPCT'  ,
                    'D2_AM_HVPCT'  ,
                    'D2_MD_HVPCT'  ,
                    'D2_PM_HVPCT'  ,
                    'D2_EV_HVPCT'  ,
                    'D2_DY_HVPCT' ;,
                   ;'D2_AM_VMT'    ,
                   ;'D2_MD_VMT'    ,
                   ;'D2_PM_VMT'    ,
                   ;'D2_EV_VMT'    ,
                   ;'D2_DY_VMT'    ,
                   ;'D2_FF_TME'    ,
                   ;'D2_AM_TME'    ,
                   ;'D2_MD_TME'    ,
                   ;'D2_PM_TME'    ,
                   ;'D2_EV_TME'    ,
                   ;'D2_DY_TME'    
            endif
            
            ;output data for each functional group
            PRINT PRINTO=1, 
                CSV=T,
                FORM=10.1,
                LIST=reSEGIDIdx          ,
                     reSEGID             ,
                     reDirectionName     ,
                     reFuncGroup         ,
                     reSUBAREAID         ,
                     reCO_FIPS           ,
                     reAREATYPE          ,
                     reATYPENAME         ,
                     reLinks(10.0)       ,
                     reDist_1Wy(10.3)    ,
                     reLanes             ,
                     reFT                ,
                     reFTCLASS           ,
                     reCAP1HL(10.0)      ,
                     reAM_VOL            ,
                     reMD_VOL            ,
                     rePM_VOL            ,
                     reEV_VOL            ,
                     reDY_VOL            ,
                     reAM_LT             ,
                     reMD_LT             ,
                     rePM_LT             ,
                     reEV_LT             ,
                     reDY_LT             ,
                     reAM_MD             ,
                     reMD_MD             ,
                     rePM_MD             ,
                     reEV_MD             ,
                     reDY_MD             ,
                     reAM_HV             ,
                     reMD_HV             ,
                     rePM_HV             ,
                     reEV_HV             ,
                     reDY_HV             ,
                     reFF_SPD            ,
                     reAM_SPD            ,
                     reMD_SPD            ,
                     rePM_SPD            ,
                     reEV_SPD            ,
                     reDY_SPD            ,
                     reFGFAC(10.4)       ,
                     reAM_PRDFAC(10.4)   ,
                     reMD_PRDFAC(10.4)   ,
                     rePM_PRDFAC(10.4)   ,
                     reEV_PRDFAC(10.4)   ,
                    ;reAM_VMT(10.3)      ,
                    ;reMD_VMT(10.3)      ,
                    ;rePM_VMT(10.3)      ,
                    ;reEV_VMT(10.3)      ,
                    ;reDY_VMT(10.3)      ,
                    ;reFF_TIME(10.4)     ,
                    ;reAM_TIME(10.4)     ,
                    ;reMD_TIME(10.4)     ,
                    ;rePM_TIME(10.4)     ,
                    ;reEV_TIME(10.4)     ,
                    ;reDY_TIME(10.4)     ,
                     reD1_Links(10.0)    ,
                     reD1_Dist(10.3)     ,
                     reD1_Lanes          ,
                     reD1_FT             ,
                     reD1_FTCLASS        ,
                     reD1_CAP1HL(10.0)   ,
                     reD1_AM_VOL         ,
                     reD1_MD_VOL         ,
                     reD1_PM_VOL         ,
                     reD1_EV_VOL         ,
                     reD1_DY_VOL         ,
                     reD1_AM_LT          ,
                     reD1_MD_LT          ,
                     reD1_PM_LT          ,
                     reD1_EV_LT          ,
                     reD1_DY_LT          ,
                     reD1_AM_MD          ,
                     reD1_MD_MD          ,
                     reD1_PM_MD          ,
                     reD1_EV_MD          ,
                     reD1_DY_MD          ,
                     reD1_AM_HV          ,
                     reD1_MD_HV          ,
                     reD1_PM_HV          ,
                     reD1_EV_HV          ,
                     reD1_DY_HV          ,
                     reD1_FF_SPD         ,
                     reD1_AM_SPD         ,
                     reD1_MD_SPD         ,
                     reD1_PM_SPD         ,
                     reD1_EV_SPD         ,
                     reD1_DY_SPD         ,
                     reD1_AM_DFAC(10.4)  ,
                     reD1_MD_DFAC(10.4)  ,
                     reD1_PM_DFAC(10.4)  ,
                     reD1_EV_DFAC(10.4)  ,
                     reD1_DY_DFAC(10.4)  ,
                     reD1_AM_MDPCT(10.1) ,
                     reD1_MD_MDPCT(10.1) ,
                     reD1_PM_MDPCT(10.1) ,
                     reD1_EV_MDPCT(10.1) ,
                     reD1_DY_MDPCT(10.1) ,
                     reD1_AM_HVPCT(10.1) ,
                     reD1_MD_HVPCT(10.1) ,
                     reD1_PM_HVPCT(10.1) ,
                     reD1_EV_HVPCT(10.1) ,
                     reD1_DY_HVPCT(10.1) ,
                    ;reD1_AM_VMT(10.3)   ,
                    ;reD1_MD_VMT(10.3)   ,
                    ;reD1_PM_VMT(10.3)   ,
                    ;reD1_EV_VMT(10.3)   ,
                    ;reD1_DY_VMT(10.3)   ,
                    ;reD1_FF_TME(10.4)   ,
                    ;reD1_AM_TME(10.4)   ,
                    ;reD1_MD_TME(10.4)   ,
                    ;reD1_PM_TME(10.4)   ,
                    ;reD1_EV_TME(10.4)   ,
                    ;reD1_DY_TME(10.4)   ,
                     reD2_Links(10.0)    ,
                     reD2_Dist(10.3)     ,
                     reD2_Lanes          ,
                     reD2_FT             ,
                     reD2_FTCLASS        ,
                     reD2_CAP1HL(10.0)   ,
                     reD2_AM_VOL         ,
                     reD2_MD_VOL         ,
                     reD2_PM_VOL         ,
                     reD2_EV_VOL         ,
                     reD2_DY_VOL         ,
                     reD2_AM_LT          ,
                     reD2_MD_LT          ,
                     reD2_PM_LT          ,
                     reD2_EV_LT          ,
                     reD2_DY_LT          ,
                     reD2_AM_MD          ,
                     reD2_MD_MD          ,
                     reD2_PM_MD          ,
                     reD2_EV_MD          ,
                     reD2_DY_MD          ,
                     reD2_AM_HV          ,
                     reD2_MD_HV          ,
                     reD2_PM_HV          ,
                     reD2_EV_HV          ,
                     reD2_DY_HV          ,
                     reD2_FF_SPD         ,
                     reD2_AM_SPD         ,
                     reD2_MD_SPD         ,
                     reD2_PM_SPD         ,
                     reD2_EV_SPD         ,
                     reD2_DY_SPD         ,
                     reD2_AM_DFAC(10.4)  ,
                     reD2_MD_DFAC(10.4)  ,
                     reD2_PM_DFAC(10.4)  ,
                     reD2_EV_DFAC(10.4)  ,
                     reD2_DY_DFAC(10.4)  ,
                     reD2_AM_MDPCT(10.1) ,
                     reD2_MD_MDPCT(10.1) ,
                     reD2_PM_MDPCT(10.1) ,
                     reD2_EV_MDPCT(10.1) ,
                     reD2_DY_MDPCT(10.1) ,
                     reD2_AM_HVPCT(10.1) ,
                     reD2_MD_HVPCT(10.1) ,
                     reD2_PM_HVPCT(10.1) ,
                     reD2_EV_HVPCT(10.1) ,
                     reD2_DY_HVPCT(10.1);,
                    ;reD2_AM_VMT(10.3)   ,
                    ;reD2_MD_VMT(10.3)   ,
                    ;reD2_PM_VMT(10.3)   ,
                    ;reD2_EV_VMT(10.3)   ,
                    ;reD2_DY_VMT(10.3)   ,
                    ;reD2_FF_TME(10.4)   ,
                    ;reD2_AM_TME(10.4)   ,
                    ;reD2_MD_TME(10.4)   ,
                    ;reD2_PM_TME(10.4)   ,
                    ;reD2_EV_TME(10.4)   ,
                    ;reD2_DY_TME(10.4)   

            ;only output data for totals
            if (AddIdx=0)
                ;header for csv file
                if (lp_segidx=1)
                    PRINT PRINTO=2,
                        CSV=T,
                        FORM=10.1,
                        LIST='SEGIDIDX'  ,
                             'SEGID'     ,
                             'SUBAREAID' ,
                             'CO_FIPS'   ,
                             'AREATYPE'  ,
                             'ATYPENAME' ,
                             'LINKS'     ,
                             'DIST_1WY'  ,
                             'LANES'     ,
                             'FT'        ,
                             'FTCLASS'   ,
                             'CAP1HL'    ,
                             'AM_VOL'    ,
                             'MD_VOL'    ,
                             'PM_VOL'    ,
                             'EV_VOL'    ,
                             'DY_VOL'    ,
                             'DY_LT'     ,
                             'DY_MD'     ,
                             'DY_HV'     ,
                             'FF_SPD'    ,
                             'AM_SPD'    ,
                             'MD_SPD'    ,
                             'PM_SPD'    ,
                             'EV_SPD'    ,
                             'DY_SPD'    ,
                            ;'AM_VMT'    ,
                            ;'MD_VMT'    ,
                            ;'PM_VMT'    ,
                            ;'EV_VMT'    ,
                            ;'DY_VMT'    ,
                            ;'FF_TIME'   ,
                            ;'AM_TIME'   ,
                            ;'MD_TIME'   ,
                            ;'PM_TIME'   ,
                            ;'EV_TIME'   ,
                            ;'DY_TIME'   ,
                             'D1_LINKS'  ,
                             'D1_DIST'   ,
                             'D1_LANES'  ,
                             'D1_FT'     ,
                             'D1_FTCLASS',
                             'D1_CAP1HL' ,
                             'D1_AM_VOL' ,
                             'D1_MD_VOL' ,
                             'D1_PM_VOL' ,
                             'D1_EV_VOL' ,
                             'D1_DY_VOL' ,
                             'D1_DY_LT'  ,
                             'D1_DY_MD'  ,
                             'D1_DY_HV'  ,
                             'D1_FF_SPD' ,
                             'D1_AM_SPD' ,
                             'D1_MD_SPD' ,
                             'D1_PM_SPD' ,
                             'D1_EV_SPD' ,
                             'D1_DY_SPD' ,
                            ;'D1_AM_VMT' ,
                            ;'D1_MD_VMT' ,
                            ;'D1_PM_VMT' ,
                            ;'D1_EV_VMT' ,
                            ;'D1_DY_VMT' ,
                            ;'D1_FF_TME' ,
                            ;'D1_AM_TME' ,
                            ;'D1_MD_TME' ,
                            ;'D1_PM_TME' ,
                            ;'D1_EV_TME' ,
                            ;'D1_DY_TME' ,
                             'D2_LINKS'  ,
                             'D2_DIST'   ,
                             'D2_LANES'  ,
                             'D2_FT'     ,
                             'D2_FTCLASS',
                             'D2_CAP1HL' ,
                             'D2_AM_VOL' ,
                             'D2_MD_VOL' ,
                             'D2_PM_VOL' ,
                             'D2_EV_VOL' ,
                             'D2_DY_VOL' ,
                             'D2_DY_LT'  ,
                             'D2_DY_MD'  ,
                             'D2_DY_HV'  ,
                             'D2_FF_SPD' ,
                             'D2_AM_SPD' ,
                             'D2_MD_SPD' ,
                             'D2_PM_SPD' ,
                             'D2_EV_SPD' ,
                             'D2_DY_SPD';,
                            ;'D2_AM_VMT' ,
                            ;'D2_MD_VMT' ,
                            ;'D2_PM_VMT' ,
                            ;'D2_EV_VMT' ,
                            ;'D2_DY_VMT' ,
                            ;'D2_FF_TME' ,
                            ;'D2_AM_TME' ,
                            ;'D2_MD_TME' ,
                            ;'D2_PM_TME' ,
                            ;'D2_EV_TME' ,
                            ;'D2_DY_TME' 

                endif ;lp_segidx=1=0

                ;output summary data for each segment total
                PRINT PRINTO=2, 
                    CSV=T,
                    FORM=10.1,
                    LIST=reSEGIDIdx(10.0) ,
                         reSEGID          ,
                         reSUBAREAID      ,
                         reCO_FIPS        ,
                         reAREATYPE       ,
                         reATYPENAME      ,
                         reLinks(10.0)    ,
                         reDist_1Wy(10.3) ,
                         reLanes          ,
                         reFT             ,
                         reFTCLASS        ,
                         reCAP1HL(10.0)   ,
                         reAM_VOL         ,
                         reMD_VOL         ,
                         rePM_VOL         ,
                         reEV_VOL         ,
                         reDY_VOL         ,
                         reDY_LT          ,
                         reDY_MD          ,
                         reDY_HV          ,
                         reFF_SPD         ,
                         reAM_SPD         ,
                         reMD_SPD         ,
                         rePM_SPD         ,
                         reEV_SPD         ,
                         reDY_SPD         ,
                        ;reAM_VMT(10.3)   ,
                        ;reMD_VMT(10.3)   ,
                        ;rePM_VMT(10.3)   ,
                        ;reEV_VMT(10.3)   ,
                        ;reDY_VMT(10.3)   ,
                        ;reFF_TIME(10.4)  ,
                        ;reAM_TIME(10.4)  ,
                        ;reMD_TIME(10.4)  ,
                        ;rePM_TIME(10.4)  ,
                        ;reEV_TIME(10.4)  ,
                        ;reDY_TIME(10.4)  ,
                         reD1_Links(10.0) ,
                         reD1_Dist(10.3)  ,
                         reD1_Lanes       ,
                         reD1_FT          ,
                         reD1_FTCLASS     ,
                         reD1_CAP1HL(10.0),
                         reD1_AM_VOL      ,
                         reD1_MD_VOL      ,
                         reD1_PM_VOL      ,
                         reD1_EV_VOL      ,
                         reD1_DY_VOL      ,
                         reD1_DY_LT       ,
                         reD1_DY_MD       ,
                         reD1_DY_HV       ,
                         reD1_FF_SPD      ,
                         reD1_AM_SPD      ,
                         reD1_MD_SPD      ,
                         reD1_PM_SPD      ,
                         reD1_EV_SPD      ,
                         reD1_DY_SPD      ,
                        ;reD1_AM_VMT(10.3),
                        ;reD1_MD_VMT(10.3),
                        ;reD1_PM_VMT(10.3),
                        ;reD1_EV_VMT(10.3),
                        ;reD1_DY_VMT(10.3),
                        ;reD1_FF_TME(10.4),
                        ;reD1_AM_TME(10.4),
                        ;reD1_MD_TME(10.4),
                        ;reD1_PM_TME(10.4),
                        ;reD1_EV_TME(10.4),
                        ;reD1_DY_TME(10.4),
                         reD2_Links(10.0) ,
                         reD2_Dist(10.3)  ,
                         reD2_Lanes       ,
                         reD2_FT          ,
                         reD2_FTCLASS     ,
                         reD2_CAP1HL(10.0),
                         reD2_AM_VOL      ,
                         reD2_MD_VOL      ,
                         reD2_PM_VOL      ,
                         reD2_EV_VOL      ,
                         reD2_DY_VOL      ,
                         reD2_DY_LT       ,
                         reD2_DY_MD       ,
                         reD2_DY_HV       ,
                         reD2_FF_SPD      ,
                         reD2_AM_SPD      ,
                         reD2_MD_SPD      ,
                         reD2_PM_SPD      ,
                         reD2_EV_SPD      ,
                         reD2_DY_SPD     ;,
                        ;reD2_AM_VMT(10.3),
                        ;reD2_MD_VMT(10.3),
                        ;reD2_PM_VMT(10.3),
                        ;reD2_EV_VMT(10.3),
                        ;reD2_DY_VMT(10.3),
                        ;reD2_FF_TME(10.4),
                        ;reD2_AM_TME(10.4),
                        ;reD2_MD_TME(10.4),
                        ;reD2_PM_TME(10.4),
                        ;reD2_EV_TME(10.4),
                        ;reD2_DY_TME(10.4)
            endif ;AddIdx=0
            
        ENDLOOP  ;FunGrp_Idx=0,4
        
    ENDLOOP  ;loop through segments
    
    
    ;clear status in task monitor window
    PRINT PRINTO=0 LIST=' '

ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime_DSegSum = currenttime()
    ScriptRunTime_DSegSum = ScriptEndTime_DSegSum - @ScriptStartTime_DSegSum@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
       LIST='\n    Summarize to Segments              ', formatdatetime(@ScriptStartTime_DSegSum@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime_DSegSum, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(del 1_Distrib_SegSummary.txt)

