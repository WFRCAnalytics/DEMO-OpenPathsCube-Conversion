



;get start time
ScriptStartTime = currenttime()


RUN PGM=MATRIX MSG='Final Assign: Summarize Link Data by SEGID'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\2b_Shapefiles\@RID@_Assigned.dbf',
    SORT=SEGID,
    AUTOARRAY=ALLFIELDS

FILEI DBI[2] = '@ParentDir@1_Inputs\6_Segment\@Segments_DBF@',
    AUTOARRAY=ALLFIELDS,
    SORT=SEGID
    
FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Summary_SEGID_Detailed.csv'
FILEO PRINTO[2] = '@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Summary_SEGID.csv'
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    ;define arrays
    ARRAY TYPE=C25 SEGID_Name = 19999
    
    ARRAY SUBAREAID = 19999, 99,          ;2nd index is for histogram
          AREATYPE  = 19999, 99,
          CO_FIPS   = 19999, 99

    ARRAY TYPE=C5  DIRECTION_NAME = 19999, 5

    ARRAY LANES     = 19999, 5, 5, 99,    ;3rd index is for histogram
          FT        = 19999, 5, 5, 99,
          SFF       = 19999, 5, 5, 99
    
    ARRAY NumLinks  = 19999, 5, 5,
          Dist_1Dir = 19999, 5, 5,
          CAP1HR1LN = 19999, 5, 5,
          
          NumLanes  = 19999, 5, 5,
          FTNum     = 19999, 5, 5,
          
          ;directional factors
          AM_DFAC   = 19999, 5, 5,
          MD_DFAC   = 19999, 5, 5,
          PM_DFAC   = 19999, 5, 5,
          EV_DFAC   = 19999, 5, 5,
          DY_DFAC   = 19999, 5, 5,
          
          ;weighted volume, to be normalized by sum of link distance
          AM_WgtVol    = 19999, 5, 5,
          MD_WgtVol    = 19999, 5, 5,
          PM_WgtVol    = 19999, 5, 5,
          EV_WgtVol    = 19999, 5, 5,
          DY_WgtVol    = 19999, 5, 5,
          AM_WgtVol_PC = 19999, 5, 5,
          MD_WgtVol_PC = 19999, 5, 5,
          PM_WgtVol_PC = 19999, 5, 5,
          EV_WgtVol_PC = 19999, 5, 5,
          DY_WgtVol_PC = 19999, 5, 5,
          AM_WgtVol_LT = 19999, 5, 5,
          MD_WgtVol_LT = 19999, 5, 5,
          PM_WgtVol_LT = 19999, 5, 5,
          EV_WgtVol_LT = 19999, 5, 5,
          DY_WgtVol_LT = 19999, 5, 5,
          AM_WgtVol_MD = 19999, 5, 5,
          MD_WgtVol_MD = 19999, 5, 5,
          PM_WgtVol_MD = 19999, 5, 5,
          EV_WgtVol_MD = 19999, 5, 5,
          DY_WgtVol_MD = 19999, 5, 5,
          AM_WgtVol_HV = 19999, 5, 5,
          MD_WgtVol_HV = 19999, 5, 5,
          PM_WgtVol_HV = 19999, 5, 5,
          EV_WgtVol_HV = 19999, 5, 5,
          DY_WgtVol_HV = 19999, 5, 5,
          
          ;weighted time, to be normalized by sum of link volume
          FF_WgtTme    = 19999, 5, 5,
          AM_WgtTme    = 19999, 5, 5,
          MD_WgtTme    = 19999, 5, 5,
          PM_WgtTme    = 19999, 5, 5,
          EV_WgtTme    = 19999, 5, 5,
          FF_WgtTme_PC = 19999, 5, 5,
          AM_WgtTme_PC = 19999, 5, 5,
          MD_WgtTme_PC = 19999, 5, 5,
          PM_WgtTme_PC = 19999, 5, 5,
          EV_WgtTme_PC = 19999, 5, 5,
          FF_WgtTme_LT = 19999, 5, 5,
          AM_WgtTme_LT = 19999, 5, 5,
          MD_WgtTme_LT = 19999, 5, 5,
          PM_WgtTme_LT = 19999, 5, 5,
          EV_WgtTme_LT = 19999, 5, 5,
          FF_WgtTme_MD = 19999, 5, 5,
          AM_WgtTme_MD = 19999, 5, 5,
          MD_WgtTme_MD = 19999, 5, 5,
          PM_WgtTme_MD = 19999, 5, 5,
          EV_WgtTme_MD = 19999, 5, 5,
          FF_WgtTme_HV = 19999, 5, 5,
          AM_WgtTme_HV = 19999, 5, 5,
          MD_WgtTme_HV = 19999, 5, 5,
          PM_WgtTme_HV = 19999, 5, 5,
          EV_WgtTme_HV = 19999, 5, 5,
          
          ;sum of link volume (used to normalized time)
          AM_SumVol    = 19999, 5, 5,
          MD_SumVol    = 19999, 5, 5,
          PM_SumVol    = 19999, 5, 5,
          EV_SumVol    = 19999, 5, 5,
          DY_SumVol    = 19999, 5, 5,
          AM_SumVol_PC = 19999, 5, 5,
          MD_SumVol_PC = 19999, 5, 5,
          PM_SumVol_PC = 19999, 5, 5,
          EV_SumVol_PC = 19999, 5, 5,
          DY_SumVol_PC = 19999, 5, 5,
          AM_SumVol_LT = 19999, 5, 5,
          MD_SumVol_LT = 19999, 5, 5,
          PM_SumVol_LT = 19999, 5, 5,
          EV_SumVol_LT = 19999, 5, 5,
          DY_SumVol_LT = 19999, 5, 5,
          AM_SumVol_MD = 19999, 5, 5,
          MD_SumVol_MD = 19999, 5, 5,
          PM_SumVol_MD = 19999, 5, 5,
          EV_SumVol_MD = 19999, 5, 5,
          DY_SumVol_MD = 19999, 5, 5,
          AM_SumVol_HV = 19999, 5, 5,
          MD_SumVol_HV = 19999, 5, 5,
          PM_SumVol_HV = 19999, 5, 5,
          EV_SumVol_HV = 19999, 5, 5,
          DY_SumVol_HV = 19999, 5, 5,
          
          ;averaged volumes
          AM_Vol    = 19999, 5, 5,
          MD_Vol    = 19999, 5, 5,
          PM_Vol    = 19999, 5, 5,
          EV_Vol    = 19999, 5, 5,
          DY_Vol    = 19999, 5, 5,
          AM_Vol_PC = 19999, 5, 5,
          MD_Vol_PC = 19999, 5, 5,
          PM_Vol_PC = 19999, 5, 5,
          EV_Vol_PC = 19999, 5, 5,
          DY_Vol_PC = 19999, 5, 5,
          AM_Vol_LT = 19999, 5, 5,
          MD_Vol_LT = 19999, 5, 5,
          PM_Vol_LT = 19999, 5, 5,
          EV_Vol_LT = 19999, 5, 5,
          DY_Vol_LT = 19999, 5, 5,
          AM_Vol_MD = 19999, 5, 5,
          MD_Vol_MD = 19999, 5, 5,
          PM_Vol_MD = 19999, 5, 5,
          EV_Vol_MD = 19999, 5, 5,
          DY_Vol_MD = 19999, 5, 5,
          AM_Vol_HV = 19999, 5, 5,
          MD_Vol_HV = 19999, 5, 5,
          PM_Vol_HV = 19999, 5, 5,
          EV_Vol_HV = 19999, 5, 5,
          DY_Vol_HV = 19999, 5, 5,
          
          ;averaged times
          FF_Tme      = 19999, 5, 5,
          AM_Tme      = 19999, 5, 5,
          MD_Tme      = 19999, 5, 5,
          PM_Tme      = 19999, 5, 5,
          EV_Tme      = 19999, 5, 5,
          DY_Tme      = 19999, 5, 5,
          FF_Tme_PC   = 19999, 5, 5,
          AM_Tme_PC   = 19999, 5, 5,
          MD_Tme_PC   = 19999, 5, 5,
          PM_Tme_PC   = 19999, 5, 5,
          EV_Tme_PC   = 19999, 5, 5,
          DY_Tme_PC   = 19999, 5, 5,
          FF_Tme_LT   = 19999, 5, 5,
          AM_Tme_LT   = 19999, 5, 5,
          MD_Tme_LT   = 19999, 5, 5,
          PM_Tme_LT   = 19999, 5, 5,
          EV_Tme_LT   = 19999, 5, 5,
          DY_Tme_LT   = 19999, 5, 5,
          FF_Tme_MD   = 19999, 5, 5,
          AM_Tme_MD   = 19999, 5, 5,
          MD_Tme_MD   = 19999, 5, 5,
          PM_Tme_MD   = 19999, 5, 5,
          EV_Tme_MD   = 19999, 5, 5,
          DY_Tme_MD   = 19999, 5, 5,
          FF_Tme_HV   = 19999, 5, 5,
          AM_Tme_HV   = 19999, 5, 5,
          MD_Tme_HV   = 19999, 5, 5,
          PM_Tme_HV   = 19999, 5, 5,
          EV_Tme_HV   = 19999, 5, 5,
          DY_Tme_HV   = 19999, 5, 5,
          
          ;averaged speed
          FF_Spd      = 19999, 5, 5,
          AM_Spd      = 19999, 5, 5,
          MD_Spd      = 19999, 5, 5,
          PM_Spd      = 19999, 5, 5,
          EV_Spd      = 19999, 5, 5,
          DY_Spd      = 19999, 5, 5,
          FF_Spd_PC   = 19999, 5, 5,
          AM_Spd_PC   = 19999, 5, 5,
          MD_Spd_PC   = 19999, 5, 5,
          PM_Spd_PC   = 19999, 5, 5,
          EV_Spd_PC   = 19999, 5, 5,
          DY_Spd_PC   = 19999, 5, 5,
          FF_Spd_LT   = 19999, 5, 5,
          AM_Spd_LT   = 19999, 5, 5,
          MD_Spd_LT   = 19999, 5, 5,
          PM_Spd_LT   = 19999, 5, 5,
          EV_Spd_LT   = 19999, 5, 5,
          DY_Spd_LT   = 19999, 5, 5,
          FF_Spd_MD   = 19999, 5, 5,
          AM_Spd_MD   = 19999, 5, 5,
          MD_Spd_MD   = 19999, 5, 5,
          PM_Spd_MD   = 19999, 5, 5,
          EV_Spd_MD   = 19999, 5, 5,
          DY_Spd_MD   = 19999, 5, 5,
          FF_Spd_HV   = 19999, 5, 5,
          AM_Spd_HV   = 19999, 5, 5,
          MD_Spd_HV   = 19999, 5, 5,
          PM_Spd_HV   = 19999, 5, 5,
          EV_Spd_HV   = 19999, 5, 5,
          DY_Spd_HV   = 19999, 5, 5,
          
          ;total vmt
          AM_VMT      = 19999, 5, 5,
          MD_VMT      = 19999, 5, 5,
          PM_VMT      = 19999, 5, 5,
          EV_VMT      = 19999, 5, 5,
          DY_VMT      = 19999, 5, 5,
          AM_VMT_PC   = 19999, 5, 5,
          MD_VMT_PC   = 19999, 5, 5,
          PM_VMT_PC   = 19999, 5, 5,
          EV_VMT_PC   = 19999, 5, 5,
          DY_VMT_PC   = 19999, 5, 5,
          AM_VMT_LT   = 19999, 5, 5,
          MD_VMT_LT   = 19999, 5, 5,
          PM_VMT_LT   = 19999, 5, 5,
          EV_VMT_LT   = 19999, 5, 5,
          DY_VMT_LT   = 19999, 5, 5,
          AM_VMT_MD   = 19999, 5, 5,
          MD_VMT_MD   = 19999, 5, 5,
          PM_VMT_MD   = 19999, 5, 5,
          EV_VMT_MD   = 19999, 5, 5,
          DY_VMT_MD   = 19999, 5, 5,
          AM_VMT_HV   = 19999, 5, 5,
          MD_VMT_HV   = 19999, 5, 5,
          PM_VMT_HV   = 19999, 5, 5,
          EV_VMT_HV   = 19999, 5, 5,
          DY_VMT_HV   = 19999, 5, 5,
          
          ;averaged vht
          FF_VHT      = 19999, 5, 5,
          AM_VHT      = 19999, 5, 5,
          MD_VHT      = 19999, 5, 5,
          PM_VHT      = 19999, 5, 5,
          EV_VHT      = 19999, 5, 5,
          DY_VHT      = 19999, 5, 5,
          FF_VHT_PC   = 19999, 5, 5,
          AM_VHT_PC   = 19999, 5, 5,
          MD_VHT_PC   = 19999, 5, 5,
          PM_VHT_PC   = 19999, 5, 5,
          EV_VHT_PC   = 19999, 5, 5,
          DY_VHT_PC   = 19999, 5, 5,
          FF_VHT_LT   = 19999, 5, 5,
          AM_VHT_LT   = 19999, 5, 5,
          MD_VHT_LT   = 19999, 5, 5,
          PM_VHT_LT   = 19999, 5, 5,
          EV_VHT_LT   = 19999, 5, 5,
          DY_VHT_LT   = 19999, 5, 5,
          FF_VHT_MD   = 19999, 5, 5,
          AM_VHT_MD   = 19999, 5, 5,
          MD_VHT_MD   = 19999, 5, 5,
          PM_VHT_MD   = 19999, 5, 5,
          EV_VHT_MD   = 19999, 5, 5,
          DY_VHT_MD   = 19999, 5, 5,
          FF_VHT_HV   = 19999, 5, 5,
          AM_VHT_HV   = 19999, 5, 5,
          MD_VHT_HV   = 19999, 5, 5,
          PM_VHT_HV   = 19999, 5, 5,
          EV_VHT_HV   = 19999, 5, 5,
          DY_VHT_HV   = 19999, 5, 5,
          
          ;passenger car equivalent volumes
          AM_Vol_PCE = 19999, 5, 5,
          MD_Vol_PCE = 19999, 5, 5,
          PM_Vol_PCE = 19999, 5, 5,
          EV_Vol_PCE = 19999, 5, 5,
          DY_Vol_PCE = 19999, 5, 5,
          
          ;Total Capacity
          AM_CAP = 19999, 5, 5,
          MD_CAP = 19999, 5, 5,
          PM_CAP = 19999, 5, 5,
          EV_CAP = 19999, 5, 5,
          DY_CAP = 19999, 5, 5,

          ;VC ratios
          AM_VC  = 19999, 5, 5,
          MD_VC  = 19999, 5, 5,
          PM_VC  = 19999, 5, 5,
          EV_VC  = 19999, 5, 5,
          MAX_VC = 19999, 5, 5
          
          
          ;note: idx1=num unique seg, idx2=direction, idx3=functional grouping
          ;idx2:
          ;  1 = NB, EB (positive direction)
          ;  2 = SB, WB (negative direction)
          ;  5 = Both/All directions
          ;
          ;idx3:
          ;  1 = arterial
          ;  2 = freeway
          ;  3 = managed (HOV/HOT/Toll)
          ;  4 = CD
          ;  5 = Total (all)
          
          
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
            elseif (SEGID<>SEGID_Name[Seg_Idx] & SEGID_Name[Seg_Idx]<>SEGID)
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

                ;maintain direction name for reporting, segments with links of various directions will always retain last value
                DIRECTION_NAME[Seg_Idx][Dir_Idx] = Direction
                
                LANES[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_LANES]  =  LANES[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_LANES] + 1
                FT[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_FT]        =  FT[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_FT]       + 1
                SFF[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_SFF]      =  SFF[Seg_Idx][Dir_Idx][FunGrp_Idx][idx_SFF]     + 1
                
                
                ;weight by distance & sum data by segment, direction & functional group
                CAP1HR1LN[Seg_Idx][Dir_Idx][FunGrp_Idx]  =  CAP1HR1LN[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  dba.1.CAP1HR1LN[numrec] * dba.1.DISTANCE[numrec]
                
                Dist_1Dir[Seg_Idx][Dir_Idx][FunGrp_Idx]  =  Dist_1Dir[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  dba.1.DISTANCE[numrec]
                
                ;count number of links
                NumLinks[Seg_Idx][Dir_Idx][FunGrp_Idx] = NumLinks[Seg_Idx][Dir_Idx][FunGrp_Idx] + 1
                
            endif
            
            
            ;sumarized data for segments, include ramps
            
            ;calculate weighted volume
            AM_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = AM_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.AM_VOL[numrec] * dba.1.DISTANCE[numrec]
            MD_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = MD_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.MD_VOL[numrec] * dba.1.DISTANCE[numrec]
            PM_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = PM_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.PM_VOL[numrec] * dba.1.DISTANCE[numrec]
            EV_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = EV_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.EV_VOL[numrec] * dba.1.DISTANCE[numrec]
            DY_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = DY_WgtVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.DY_VOL[numrec] * dba.1.DISTANCE[numrec]
            
            AM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.AM_SLT[numrec] * dba.1.DISTANCE[numrec]
            MD_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.MD_SLT[numrec] * dba.1.DISTANCE[numrec]
            PM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.PM_SLT[numrec] * dba.1.DISTANCE[numrec]
            EV_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.EV_SLT[numrec] * dba.1.DISTANCE[numrec]
            DY_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.DY_SLT[numrec] * dba.1.DISTANCE[numrec]
            
            AM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SMD[numrec] + dba.1.AM_LMD[numrec]) * dba.1.DISTANCE[numrec]
            MD_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SMD[numrec] + dba.1.MD_LMD[numrec]) * dba.1.DISTANCE[numrec]
            PM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SMD[numrec] + dba.1.PM_LMD[numrec]) * dba.1.DISTANCE[numrec]
            EV_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SMD[numrec] + dba.1.EV_LMD[numrec]) * dba.1.DISTANCE[numrec]
            DY_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SMD[numrec] + dba.1.DY_LMD[numrec]) * dba.1.DISTANCE[numrec]
            
            AM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SHV[numrec] + dba.1.AM_LHV[numrec]) * dba.1.DISTANCE[numrec]
            MD_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SHV[numrec] + dba.1.MD_LHV[numrec]) * dba.1.DISTANCE[numrec]
            PM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SHV[numrec] + dba.1.PM_LHV[numrec]) * dba.1.DISTANCE[numrec]
            EV_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SHV[numrec] + dba.1.EV_LHV[numrec]) * dba.1.DISTANCE[numrec]
            DY_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SHV[numrec] + dba.1.DY_LHV[numrec]) * dba.1.DISTANCE[numrec]
            
            AM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            MD_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            PM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            EV_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            DY_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]

            ;calculate weighted time
            FF_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]    = FF_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.DY_VOL[numrec] * dba.1.FF_TIME[numrec]
            AM_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]    = AM_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.AM_VOL[numrec] * dba.1.AM_TIME[numrec]
            MD_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]    = MD_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.MD_VOL[numrec] * dba.1.MD_TIME[numrec]
            PM_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]    = PM_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.PM_VOL[numrec] * dba.1.PM_TIME[numrec]
            EV_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]    = EV_WgtTme[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.EV_VOL[numrec] * dba.1.EV_TIME[numrec]
            
            FF_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = FF_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.DY_SLT[numrec] * dba.1.FF_TIME[numrec]
            AM_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.AM_SLT[numrec] * dba.1.AM_TIME[numrec]
            MD_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.MD_SLT[numrec] * dba.1.MD_TIME[numrec]
            PM_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.PM_SLT[numrec] * dba.1.PM_TIME[numrec]
            EV_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtTme_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.EV_SLT[numrec] * dba.1.EV_TIME[numrec]
            
            FF_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = FF_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SMD[numrec] + dba.1.DY_LMD[numrec]) * dba.1.FF_TKTME_M[numrec]
            AM_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SMD[numrec] + dba.1.AM_LMD[numrec]) * dba.1.AM_TKTME_M[numrec]
            MD_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SMD[numrec] + dba.1.MD_LMD[numrec]) * dba.1.MD_TKTME_M[numrec]
            PM_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SMD[numrec] + dba.1.PM_LMD[numrec]) * dba.1.PM_TKTME_M[numrec]
            EV_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtTme_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SMD[numrec] + dba.1.EV_LMD[numrec]) * dba.1.EV_TKTME_M[numrec]
            
            FF_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = FF_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SHV[numrec] + dba.1.DY_LHV[numrec]) * dba.1.FF_TKTME_H[numrec]
            AM_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SHV[numrec] + dba.1.AM_LHV[numrec]) * dba.1.AM_TKTME_H[numrec]
            MD_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SHV[numrec] + dba.1.MD_LHV[numrec]) * dba.1.MD_TKTME_H[numrec]
            PM_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SHV[numrec] + dba.1.PM_LHV[numrec]) * dba.1.PM_TKTME_H[numrec]
            EV_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtTme_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SHV[numrec] + dba.1.EV_LHV[numrec]) * dba.1.EV_TKTME_H[numrec]
            
            FF_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = FF_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (DY_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]) * dba.1.FF_TIME[numrec]
            AM_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (AM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]) * dba.1.AM_TIME[numrec]
            MD_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (MD_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]) * dba.1.MD_TIME[numrec]
            PM_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (PM_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]) * dba.1.PM_TIME[numrec]
            EV_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_WgtTme_PC[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (EV_WgtVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]) * dba.1.EV_TIME[numrec]
            
            ;calculate sum of volume (used to normalized time)
            DY_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = DY_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.DY_VOL[numrec]
            AM_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = AM_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.AM_VOL[numrec]
            MD_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = MD_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.MD_VOL[numrec]
            PM_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = PM_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.PM_VOL[numrec]
            EV_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]    = EV_SumVol[Seg_Idx][Dir_Idx][FunGrp_Idx]     +   dba.1.EV_VOL[numrec]
            
            DY_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.DY_SLT[numrec]
            AM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.AM_SLT[numrec]
            MD_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.MD_SLT[numrec]
            PM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.PM_SLT[numrec]
            EV_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx]  +   dba.1.EV_SLT[numrec]
            
            DY_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SMD[numrec] + dba.1.DY_LMD[numrec])
            AM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SMD[numrec] + dba.1.AM_LMD[numrec])
            MD_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SMD[numrec] + dba.1.MD_LMD[numrec])
            PM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SMD[numrec] + dba.1.PM_LMD[numrec])
            EV_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SMD[numrec] + dba.1.EV_LMD[numrec])
            
            DY_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.DY_SHV[numrec] + dba.1.DY_LHV[numrec])
            AM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.AM_SHV[numrec] + dba.1.AM_LHV[numrec])
            MD_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.MD_SHV[numrec] + dba.1.MD_LHV[numrec])
            PM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.PM_SHV[numrec] + dba.1.PM_LHV[numrec])
            EV_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]  +  (dba.1.EV_SHV[numrec] + dba.1.EV_LHV[numrec])

            AM_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = AM_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - AM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            MD_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = MD_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - MD_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            PM_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = PM_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - PM_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            EV_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = EV_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - EV_SumVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]
            DY_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] = DY_SumVol_PC[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_SumVol_LT[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_SumVol_MD[Seg_Idx][Dir_Idx][FunGrp_Idx] - DY_WgtVol_HV[Seg_Idx][Dir_Idx][FunGrp_Idx]

            
        endif  ;STRLEN(SEGID)>1
    
    ENDLOOP  ;loop through link records
    
    
    
    
    ;loop through unique SEGIDs ========================================================================================
    LOOP lp_segidx=1, dbi.2.NUMRECORDS
        
        ;print status to task monitor window
        PRINT PRINTO=0 LIST='Loop through segments: ', round(lp_segidx/dbi.2.NUMRECORDS*100)(5.0), '%'
        
        ;calculate segid from segment dbf input file
        segid2 = TRIM(LTRIM(dba.2.SEGID[lp_segidx]))
        
        ;loop through array of segments from network links
        ;break out of loop if network segment matches segment from dbf input
        ;use _idx_Seg as the correct index for array variables below
        LOOP _idx_Seg=1, Seg_Idx
            
            segid1 = SEGID_Name[_idx_Seg] 
            
            if (segid1 == segid2) BREAK
            
        ENDLOOP
        
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
        
        
        ;loop through variable and find highest (max) count of the variable's value
        LOOP hist_idx=1, 99
            ;subareaid
            if (SUBAREAID[_idx_Seg][hist_idx]>MaxCount_SUBAREAID)
                MaxCount_SUBAREAID = SUBAREAID[_idx_Seg][hist_idx]
                Value_SUBAREAID    = hist_idx
            endif
            
            
            ;areatype
            if (AREATYPE[_idx_Seg][hist_idx]>MaxCount_AREATYPE)
                MaxCount_AREATYPE = AREATYPE[_idx_Seg][hist_idx]
                Value_AREATYPE    = hist_idx
            endif
            
            
            ;county FIPS
            if (CO_FIPS[_idx_Seg][hist_idx]>MaxCount_CO_FIPS)
                MaxCount_CO_FIPS = CO_FIPS[_idx_Seg][hist_idx]
                Value_CO_FIPS    = hist_idx
            endif
            
            
            ;lanes - positive direction
            if (LANES[_idx_Seg][1][1][hist_idx]>MaxCount_LANES_D1_Art)
                MaxCount_LANES_D1_Art = LANES[_idx_Seg][1][1][hist_idx]
                NumLanes[_idx_Seg][1][1]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][1][2][hist_idx]>MaxCount_LANES_D1_Fwy)
                MaxCount_LANES_D1_Fwy = LANES[_idx_Seg][1][2][hist_idx]
                NumLanes[_idx_Seg][1][2]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][1][3][hist_idx]>MaxCount_LANES_D1_Man)
                MaxCount_LANES_D1_Man = LANES[_idx_Seg][1][3][hist_idx]
                NumLanes[_idx_Seg][1][3]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][1][4][hist_idx]>MaxCount_LANES_D1__CD)
                MaxCount_LANES_D1__CD = LANES[_idx_Seg][1][4][hist_idx]
                NumLanes[_idx_Seg][1][4]    = hist_idx
            endif
            
            ;lanes - negaitve direction
            if (LANES[_idx_Seg][2][1][hist_idx]>MaxCount_LANES_D2_Art)
                MaxCount_LANES_D2_Art = LANES[_idx_Seg][2][1][hist_idx]
                NumLanes[_idx_Seg][2][1]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][2][2][hist_idx]>MaxCount_LANES_D2_Fwy)
                MaxCount_LANES_D2_Fwy = LANES[_idx_Seg][2][2][hist_idx]
                NumLanes[_idx_Seg][2][2]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][2][3][hist_idx]>MaxCount_LANES_D2_Man)
                MaxCount_LANES_D2_Man = LANES[_idx_Seg][2][3][hist_idx]
                NumLanes[_idx_Seg][2][3]    = hist_idx
            endif
            
            if (LANES[_idx_Seg][2][4][hist_idx]>MaxCount_LANES_D2__CD)
                MaxCount_LANES_D2__CD = LANES[_idx_Seg][2][4][hist_idx]
                NumLanes[_idx_Seg][2][4]    = hist_idx
            endif
            
            
            ;FT - positive direction
            if (FT[_idx_Seg][1][1][hist_idx]>MaxCount_FT_D1_Art)
                MaxCount_FT_D1_Art = FT[_idx_Seg][1][1][hist_idx]
                FTNum[_idx_Seg][1][1]    = hist_idx
            endif
            
            if (FT[_idx_Seg][1][2][hist_idx]>MaxCount_FT_D1_Fwy)
                MaxCount_FT_D1_Fwy = FT[_idx_Seg][1][2][hist_idx]
                FTNum[_idx_Seg][1][2]    = hist_idx
            endif
            
            if (FT[_idx_Seg][1][3][hist_idx]>MaxCount_FT_D1_Man)
                MaxCount_FT_D1_Man = FT[_idx_Seg][1][3][hist_idx]
                FTNum[_idx_Seg][1][3]    = hist_idx
            endif
            
            if (FT[_idx_Seg][1][4][hist_idx]>MaxCount_FT_D1__CD)
                MaxCount_FT_D1__CD = FT[_idx_Seg][1][4][hist_idx]
                FTNum[_idx_Seg][1][4]    = hist_idx
            endif
            
            ;FT - negative direction
            if (FT[_idx_Seg][2][1][hist_idx]>MaxCount_FT_D2_Art)
                MaxCount_FT_D2_Art = FT[_idx_Seg][2][1][hist_idx]
                FTNum[_idx_Seg][2][1]    = hist_idx
            endif
            
            if (FT[_idx_Seg][2][2][hist_idx]>MaxCount_FT_D2_Fwy)
                MaxCount_FT_D2_Fwy = FT[_idx_Seg][2][2][hist_idx]
                FTNum[_idx_Seg][2][2]    = hist_idx
            endif
            
            if (FT[_idx_Seg][2][3][hist_idx]>MaxCount_FT_D2_Man)
                MaxCount_FT_D2_Man = FT[_idx_Seg][2][3][hist_idx]
                FTNum[_idx_Seg][2][3]    = hist_idx
            endif
            
            if (FT[_idx_Seg][2][4][hist_idx]>MaxCount_FT_D2__CD)
                MaxCount_FT_D2__CD = FT[_idx_Seg][2][4][hist_idx]
                FTNum[_idx_Seg][2][4]    = hist_idx
            endif
            
        ENDLOOP
        
        
        
        ;calc averages by segment, direction, functional group =========================================================
        ;index 5 represents both directiosn or total functional group depending on array dimensions
        
        LOOP Dir_Idx=1,2
            
            ;calc total number of links and landes by adding all functional groups together and storing in 5th dimension of 3rd index
            NumLinks[_idx_Seg][Dir_Idx][5] = 0
            NumLinks[_idx_Seg][Dir_Idx][5] = NumLinks[_idx_Seg][Dir_Idx][1] + NumLinks[_idx_Seg][Dir_Idx][2] + NumLinks[_idx_Seg][Dir_Idx][3] + NumLinks[_idx_Seg][Dir_Idx][4]
            
            NumLanes[_idx_Seg][Dir_Idx][5] = NumLanes[_idx_Seg][Dir_Idx][1] + NumLanes[_idx_Seg][Dir_Idx][2] + NumLanes[_idx_Seg][Dir_Idx][3] + NumLanes[_idx_Seg][Dir_Idx][4]
            
            LOOP FunGrp_Idx=1,4
                
                ;NumLinks and NumLanes for Dir_Idx=5
                NumLinks[_idx_Seg][5][FunGrp_Idx] = NumLinks[_idx_Seg][5][FunGrp_Idx] + NumLinks[_idx_Seg][Dir_Idx][FunGrp_Idx]
                NumLanes[_idx_Seg][5][FunGrp_Idx] = NumLanes[_idx_Seg][5][FunGrp_Idx] + NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx]

                ;Capacity-----------------------------------------------------------------------------------------------
                ;calc average capacity using sum of link distance
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] = CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calc capacity total for all fungrp
                if (NumLanes[_idx_Seg][Dir_Idx][5]>0) CAP1HR1LN[_idx_Seg][Dir_Idx][5] = CAP1HR1LN[_idx_Seg][Dir_Idx][5] + (CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] * NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx] / NumLanes[_idx_Seg][Dir_Idx][5])
                
                
                ;Volume-------------------------------------------------------------------------------------------------
                ;calc avg volume
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = MD_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = PM_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = EV_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]

                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;round to 1 decimal point
                AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                
                AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                ;calc daily total volume
                DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] - AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] - MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] - PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] - EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] - DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]


                ;calc avg volume total for all fungrp
                AM_Vol[_idx_Seg][Dir_Idx][5]    = AM_Vol[_idx_Seg][Dir_Idx][5]    + AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol[_idx_Seg][Dir_Idx][5]    = MD_Vol[_idx_Seg][Dir_Idx][5]    + MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol[_idx_Seg][Dir_Idx][5]    = PM_Vol[_idx_Seg][Dir_Idx][5]    + PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol[_idx_Seg][Dir_Idx][5]    = EV_Vol[_idx_Seg][Dir_Idx][5]    + EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol[_idx_Seg][Dir_Idx][5]    = DY_Vol[_idx_Seg][Dir_Idx][5]    + DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_PC[_idx_Seg][Dir_Idx][5] = AM_Vol_PC[_idx_Seg][Dir_Idx][5] + AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_PC[_idx_Seg][Dir_Idx][5] = MD_Vol_PC[_idx_Seg][Dir_Idx][5] + MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_PC[_idx_Seg][Dir_Idx][5] = PM_Vol_PC[_idx_Seg][Dir_Idx][5] + PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_PC[_idx_Seg][Dir_Idx][5] = EV_Vol_PC[_idx_Seg][Dir_Idx][5] + EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_PC[_idx_Seg][Dir_Idx][5] = DY_Vol_PC[_idx_Seg][Dir_Idx][5] + DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_LT[_idx_Seg][Dir_Idx][5] = AM_Vol_LT[_idx_Seg][Dir_Idx][5] + AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_LT[_idx_Seg][Dir_Idx][5] = MD_Vol_LT[_idx_Seg][Dir_Idx][5] + MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_LT[_idx_Seg][Dir_Idx][5] = PM_Vol_LT[_idx_Seg][Dir_Idx][5] + PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_LT[_idx_Seg][Dir_Idx][5] = EV_Vol_LT[_idx_Seg][Dir_Idx][5] + EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_LT[_idx_Seg][Dir_Idx][5] = DY_Vol_LT[_idx_Seg][Dir_Idx][5] + DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_MD[_idx_Seg][Dir_Idx][5] = AM_Vol_MD[_idx_Seg][Dir_Idx][5] + AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_MD[_idx_Seg][Dir_Idx][5] = MD_Vol_MD[_idx_Seg][Dir_Idx][5] + MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_MD[_idx_Seg][Dir_Idx][5] = PM_Vol_MD[_idx_Seg][Dir_Idx][5] + PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_MD[_idx_Seg][Dir_Idx][5] = EV_Vol_MD[_idx_Seg][Dir_Idx][5] + EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_MD[_idx_Seg][Dir_Idx][5] = DY_Vol_MD[_idx_Seg][Dir_Idx][5] + DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_HV[_idx_Seg][Dir_Idx][5] = AM_Vol_HV[_idx_Seg][Dir_Idx][5] + AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_HV[_idx_Seg][Dir_Idx][5] = MD_Vol_HV[_idx_Seg][Dir_Idx][5] + MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_HV[_idx_Seg][Dir_Idx][5] = PM_Vol_HV[_idx_Seg][Dir_Idx][5] + PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_HV[_idx_Seg][Dir_Idx][5] = EV_Vol_HV[_idx_Seg][Dir_Idx][5] + EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_HV[_idx_Seg][Dir_Idx][5] = DY_Vol_HV[_idx_Seg][Dir_Idx][5] + DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calc avg volume total for both directions
                AM_Vol[_idx_Seg][5][FunGrp_Idx]    = AM_Vol[_idx_Seg][5][FunGrp_Idx]    + AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol[_idx_Seg][5][FunGrp_Idx]    = MD_Vol[_idx_Seg][5][FunGrp_Idx]    + MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol[_idx_Seg][5][FunGrp_Idx]    = PM_Vol[_idx_Seg][5][FunGrp_Idx]    + PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol[_idx_Seg][5][FunGrp_Idx]    = EV_Vol[_idx_Seg][5][FunGrp_Idx]    + EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol[_idx_Seg][5][FunGrp_Idx]    = DY_Vol[_idx_Seg][5][FunGrp_Idx]    + DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_PC[_idx_Seg][5][FunGrp_Idx] = AM_Vol_PC[_idx_Seg][5][FunGrp_Idx] + AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_PC[_idx_Seg][5][FunGrp_Idx] = MD_Vol_PC[_idx_Seg][5][FunGrp_Idx] + MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_PC[_idx_Seg][5][FunGrp_Idx] = PM_Vol_PC[_idx_Seg][5][FunGrp_Idx] + PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_PC[_idx_Seg][5][FunGrp_Idx] = EV_Vol_PC[_idx_Seg][5][FunGrp_Idx] + EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_PC[_idx_Seg][5][FunGrp_Idx] = DY_Vol_PC[_idx_Seg][5][FunGrp_Idx] + DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_LT[_idx_Seg][5][FunGrp_Idx] = AM_Vol_LT[_idx_Seg][5][FunGrp_Idx] + AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_LT[_idx_Seg][5][FunGrp_Idx] = MD_Vol_LT[_idx_Seg][5][FunGrp_Idx] + MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_LT[_idx_Seg][5][FunGrp_Idx] = PM_Vol_LT[_idx_Seg][5][FunGrp_Idx] + PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_LT[_idx_Seg][5][FunGrp_Idx] = EV_Vol_LT[_idx_Seg][5][FunGrp_Idx] + EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_LT[_idx_Seg][5][FunGrp_Idx] = DY_Vol_LT[_idx_Seg][5][FunGrp_Idx] + DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_MD[_idx_Seg][5][FunGrp_Idx] = AM_Vol_MD[_idx_Seg][5][FunGrp_Idx] + AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_MD[_idx_Seg][5][FunGrp_Idx] = MD_Vol_MD[_idx_Seg][5][FunGrp_Idx] + MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_MD[_idx_Seg][5][FunGrp_Idx] = PM_Vol_MD[_idx_Seg][5][FunGrp_Idx] + PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_MD[_idx_Seg][5][FunGrp_Idx] = EV_Vol_MD[_idx_Seg][5][FunGrp_Idx] + EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_MD[_idx_Seg][5][FunGrp_Idx] = DY_Vol_MD[_idx_Seg][5][FunGrp_Idx] + DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_Vol_HV[_idx_Seg][5][FunGrp_Idx] = AM_Vol_HV[_idx_Seg][5][FunGrp_Idx] + AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_Vol_HV[_idx_Seg][5][FunGrp_Idx] = MD_Vol_HV[_idx_Seg][5][FunGrp_Idx] + MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_Vol_HV[_idx_Seg][5][FunGrp_Idx] = PM_Vol_HV[_idx_Seg][5][FunGrp_Idx] + PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_Vol_HV[_idx_Seg][5][FunGrp_Idx] = EV_Vol_HV[_idx_Seg][5][FunGrp_Idx] + EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_Vol_HV[_idx_Seg][5][FunGrp_Idx] = DY_Vol_HV[_idx_Seg][5][FunGrp_Idx] + DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                

                ;Speed---------------------------------------------------------------------------------------------------
                ;calc avg speed
                if (FF_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = DY_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / FF_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 60
                if (AM_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / AM_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 60
                if (MD_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = MD_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / MD_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 60
                if (PM_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = PM_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / PM_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 60
                if (EV_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = EV_WgtVol[_idx_Seg][Dir_Idx][FunGrp_Idx]    / EV_WgtTme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 60
                
                if (FF_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_WgtVol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] / FF_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (AM_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] / AM_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (MD_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] / MD_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (PM_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] / PM_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (EV_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] / EV_WgtTme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                
                if (FF_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / FF_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (AM_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / AM_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (MD_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / MD_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (PM_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / PM_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (EV_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / EV_WgtTme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                
                if (FF_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / FF_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (AM_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / AM_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (MD_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / MD_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (PM_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / PM_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (EV_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / EV_WgtTme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                
                if (FF_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / FF_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (AM_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / AM_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (MD_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / MD_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (PM_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / PM_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                if (EV_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_WgtVol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / EV_WgtTme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 60
                
                ;calc daily ave speed
                if (DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = (AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]    * AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]    * MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]    * PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]    * EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     ) / DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = (AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                
                ;adjust speed to ff speed if too fast
                if (AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx])        AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx])        MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx])        PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx])        EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx])        DY_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                
                ;Time---------------------------------------------------------------------------------------------------
                ;calc avg time by using speed calculation (must use average speed to calculate time since total time along a segment isn't exact in some situations)
                if (FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = dba.2.DISTANCE[lp_segidx] / FF_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     * 60
                if (AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = dba.2.DISTANCE[lp_segidx] / AM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     * 60
                if (MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = dba.2.DISTANCE[lp_segidx] / MD_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     * 60
                if (PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = dba.2.DISTANCE[lp_segidx] / PM_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     * 60
                if (EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)     EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = dba.2.DISTANCE[lp_segidx] / EV_Spd[_idx_Seg][Dir_Idx][FunGrp_Idx]     * 60
                
                if (FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / FF_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / AM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / MD_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / PM_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / EV_Spd_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                
                if (FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / FF_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / AM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / MD_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / PM_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / EV_Spd_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                
                if (FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / FF_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / AM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / MD_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / PM_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / EV_Spd_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                
                if (FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / FF_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / AM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / MD_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / PM_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                if (EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = dba.2.DISTANCE[lp_segidx] / EV_Spd_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  * 60
                
                ;calc daily ave time
                if (DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = (AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    +
                                                                 EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    * EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]     ) / DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                if (DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)
                    DY_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = (AM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 MD_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 PM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                                 EV_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  ) / DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                endif
                
                ;adjust time to ff time if too fast
                if (AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx])        AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx])        MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx])        PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx])        EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx])        DY_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]     = FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                if (AM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  AM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  MD_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  PM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  EV_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (DY_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]<FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx])  DY_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                
                ;VMT----------------------------------------------------------------------------------------------------
                ;calculate total vmt
                AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * dba.2.DISTANCE[lp_segidx]
                MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * dba.2.DISTANCE[lp_segidx]
                PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * dba.2.DISTANCE[lp_segidx]
                EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * dba.2.DISTANCE[lp_segidx]
                
                AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                
                AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                
                AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                
                AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * dba.2.DISTANCE[lp_segidx]
                
                ;round to 1 decimal point
                AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 10) / 10
                
                AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 10) / 10
                
                ;calc daily total vmt
                DY_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                DY_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                            EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calc vmt total for all fungrp
                AM_VMT[_idx_Seg][Dir_Idx][5]    = AM_VMT[_idx_Seg][Dir_Idx][5]    + AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT[_idx_Seg][Dir_Idx][5]    = MD_VMT[_idx_Seg][Dir_Idx][5]    + MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT[_idx_Seg][Dir_Idx][5]    = PM_VMT[_idx_Seg][Dir_Idx][5]    + PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT[_idx_Seg][Dir_Idx][5]    = EV_VMT[_idx_Seg][Dir_Idx][5]    + EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT[_idx_Seg][Dir_Idx][5]    = DY_VMT[_idx_Seg][Dir_Idx][5]    + DY_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                     
                AM_VMT_PC[_idx_Seg][Dir_Idx][5] = AM_VMT_PC[_idx_Seg][Dir_Idx][5] + AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_PC[_idx_Seg][Dir_Idx][5] = MD_VMT_PC[_idx_Seg][Dir_Idx][5] + MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_PC[_idx_Seg][Dir_Idx][5] = PM_VMT_PC[_idx_Seg][Dir_Idx][5] + PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_PC[_idx_Seg][Dir_Idx][5] = EV_VMT_PC[_idx_Seg][Dir_Idx][5] + EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_PC[_idx_Seg][Dir_Idx][5] = DY_VMT_PC[_idx_Seg][Dir_Idx][5] + DY_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                           
                AM_VMT_LT[_idx_Seg][Dir_Idx][5] = AM_VMT_LT[_idx_Seg][Dir_Idx][5] + AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_LT[_idx_Seg][Dir_Idx][5] = MD_VMT_LT[_idx_Seg][Dir_Idx][5] + MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_LT[_idx_Seg][Dir_Idx][5] = PM_VMT_LT[_idx_Seg][Dir_Idx][5] + PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_LT[_idx_Seg][Dir_Idx][5] = EV_VMT_LT[_idx_Seg][Dir_Idx][5] + EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_LT[_idx_Seg][Dir_Idx][5] = DY_VMT_LT[_idx_Seg][Dir_Idx][5] + DY_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_VMT_MD[_idx_Seg][Dir_Idx][5] = AM_VMT_MD[_idx_Seg][Dir_Idx][5] + AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_MD[_idx_Seg][Dir_Idx][5] = MD_VMT_MD[_idx_Seg][Dir_Idx][5] + MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_MD[_idx_Seg][Dir_Idx][5] = PM_VMT_MD[_idx_Seg][Dir_Idx][5] + PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_MD[_idx_Seg][Dir_Idx][5] = EV_VMT_MD[_idx_Seg][Dir_Idx][5] + EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_MD[_idx_Seg][Dir_Idx][5] = DY_VMT_MD[_idx_Seg][Dir_Idx][5] + DY_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_VMT_HV[_idx_Seg][Dir_Idx][5] = AM_VMT_HV[_idx_Seg][Dir_Idx][5] + AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_HV[_idx_Seg][Dir_Idx][5] = MD_VMT_HV[_idx_Seg][Dir_Idx][5] + MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_HV[_idx_Seg][Dir_Idx][5] = PM_VMT_HV[_idx_Seg][Dir_Idx][5] + PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_HV[_idx_Seg][Dir_Idx][5] = EV_VMT_HV[_idx_Seg][Dir_Idx][5] + EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_HV[_idx_Seg][Dir_Idx][5] = DY_VMT_HV[_idx_Seg][Dir_Idx][5] + DY_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calc avg vmt total for both direction
                AM_VMT[_idx_Seg][5][FunGrp_Idx]    = AM_VMT[_idx_Seg][5][FunGrp_Idx]    + AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT[_idx_Seg][5][FunGrp_Idx]    = MD_VMT[_idx_Seg][5][FunGrp_Idx]    + MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT[_idx_Seg][5][FunGrp_Idx]    = PM_VMT[_idx_Seg][5][FunGrp_Idx]    + PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT[_idx_Seg][5][FunGrp_Idx]    = EV_VMT[_idx_Seg][5][FunGrp_Idx]    + EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT[_idx_Seg][5][FunGrp_Idx]    = DY_VMT[_idx_Seg][5][FunGrp_Idx]    + DY_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                   
                AM_VMT_PC[_idx_Seg][5][FunGrp_Idx] = AM_VMT_PC[_idx_Seg][5][FunGrp_Idx] + AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_PC[_idx_Seg][5][FunGrp_Idx] = MD_VMT_PC[_idx_Seg][5][FunGrp_Idx] + MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_PC[_idx_Seg][5][FunGrp_Idx] = PM_VMT_PC[_idx_Seg][5][FunGrp_Idx] + PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_PC[_idx_Seg][5][FunGrp_Idx] = EV_VMT_PC[_idx_Seg][5][FunGrp_Idx] + EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_PC[_idx_Seg][5][FunGrp_Idx] = DY_VMT_PC[_idx_Seg][5][FunGrp_Idx] + DY_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                             
                AM_VMT_LT[_idx_Seg][5][FunGrp_Idx] = AM_VMT_LT[_idx_Seg][5][FunGrp_Idx] + AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_LT[_idx_Seg][5][FunGrp_Idx] = MD_VMT_LT[_idx_Seg][5][FunGrp_Idx] + MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_LT[_idx_Seg][5][FunGrp_Idx] = PM_VMT_LT[_idx_Seg][5][FunGrp_Idx] + PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_LT[_idx_Seg][5][FunGrp_Idx] = EV_VMT_LT[_idx_Seg][5][FunGrp_Idx] + EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_LT[_idx_Seg][5][FunGrp_Idx] = DY_VMT_LT[_idx_Seg][5][FunGrp_Idx] + DY_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_VMT_MD[_idx_Seg][5][FunGrp_Idx] = AM_VMT_MD[_idx_Seg][5][FunGrp_Idx] + AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_MD[_idx_Seg][5][FunGrp_Idx] = MD_VMT_MD[_idx_Seg][5][FunGrp_Idx] + MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_MD[_idx_Seg][5][FunGrp_Idx] = PM_VMT_MD[_idx_Seg][5][FunGrp_Idx] + PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_MD[_idx_Seg][5][FunGrp_Idx] = EV_VMT_MD[_idx_Seg][5][FunGrp_Idx] + EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_MD[_idx_Seg][5][FunGrp_Idx] = DY_VMT_MD[_idx_Seg][5][FunGrp_Idx] + DY_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                AM_VMT_HV[_idx_Seg][5][FunGrp_Idx] = AM_VMT_HV[_idx_Seg][5][FunGrp_Idx] + AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VMT_HV[_idx_Seg][5][FunGrp_Idx] = MD_VMT_HV[_idx_Seg][5][FunGrp_Idx] + MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VMT_HV[_idx_Seg][5][FunGrp_Idx] = PM_VMT_HV[_idx_Seg][5][FunGrp_Idx] + PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VMT_HV[_idx_Seg][5][FunGrp_Idx] = EV_VMT_HV[_idx_Seg][5][FunGrp_Idx] + EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VMT_HV[_idx_Seg][5][FunGrp_Idx] = DY_VMT_HV[_idx_Seg][5][FunGrp_Idx] + DY_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                
                ;VHT----------------------------------------------------------------------------------------------------
                ;calculate average vht
                FF_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]    * EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                
                FF_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * FF_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Tme[_idx_Seg][Dir_Idx][FunGrp_Idx]    / 60
                
                FF_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * FF_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Tme_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                
                FF_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * FF_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Tme_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                
                FF_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * FF_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * AM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * MD_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * PM_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * EV_Tme_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] / 60
                
                ;round to 2 decimal points
                AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 100) / 100
                MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 100) / 100
                PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 100) / 100
                EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]     = ROUND(EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]    * 100) / 100
                
                AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                
                AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                
                AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                
                AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]  = ROUND(EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * 100) / 100
                
                DY_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]    = AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx] 
                
                DY_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx] 
                
                DY_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx] 
                
                DY_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] 
                
                DY_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                           EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] 
                ;calc avg vht total for all fungrp
                FF_VHT[_idx_Seg][Dir_Idx][5]    = FF_VHT[_idx_Seg][Dir_Idx][5]    + FF_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT[_idx_Seg][Dir_Idx][5]    = AM_VHT[_idx_Seg][Dir_Idx][5]    + AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT[_idx_Seg][Dir_Idx][5]    = MD_VHT[_idx_Seg][Dir_Idx][5]    + MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT[_idx_Seg][Dir_Idx][5]    = PM_VHT[_idx_Seg][Dir_Idx][5]    + PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT[_idx_Seg][Dir_Idx][5]    = EV_VHT[_idx_Seg][Dir_Idx][5]    + EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT[_idx_Seg][Dir_Idx][5]    = DY_VHT[_idx_Seg][Dir_Idx][5]    + DY_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_PC[_idx_Seg][Dir_Idx][5] = FF_VHT_PC[_idx_Seg][Dir_Idx][5] + FF_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_PC[_idx_Seg][Dir_Idx][5] = AM_VHT_PC[_idx_Seg][Dir_Idx][5] + AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_PC[_idx_Seg][Dir_Idx][5] = MD_VHT_PC[_idx_Seg][Dir_Idx][5] + MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_PC[_idx_Seg][Dir_Idx][5] = PM_VHT_PC[_idx_Seg][Dir_Idx][5] + PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_PC[_idx_Seg][Dir_Idx][5] = EV_VHT_PC[_idx_Seg][Dir_Idx][5] + EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_PC[_idx_Seg][Dir_Idx][5] = DY_VHT_PC[_idx_Seg][Dir_Idx][5] + DY_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_LT[_idx_Seg][Dir_Idx][5] = FF_VHT_LT[_idx_Seg][Dir_Idx][5] + FF_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_LT[_idx_Seg][Dir_Idx][5] = AM_VHT_LT[_idx_Seg][Dir_Idx][5] + AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_LT[_idx_Seg][Dir_Idx][5] = MD_VHT_LT[_idx_Seg][Dir_Idx][5] + MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_LT[_idx_Seg][Dir_Idx][5] = PM_VHT_LT[_idx_Seg][Dir_Idx][5] + PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_LT[_idx_Seg][Dir_Idx][5] = EV_VHT_LT[_idx_Seg][Dir_Idx][5] + EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_LT[_idx_Seg][Dir_Idx][5] = DY_VHT_LT[_idx_Seg][Dir_Idx][5] + DY_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_MD[_idx_Seg][Dir_Idx][5] = FF_VHT_MD[_idx_Seg][Dir_Idx][5] + FF_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_MD[_idx_Seg][Dir_Idx][5] = AM_VHT_MD[_idx_Seg][Dir_Idx][5] + AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_MD[_idx_Seg][Dir_Idx][5] = MD_VHT_MD[_idx_Seg][Dir_Idx][5] + MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_MD[_idx_Seg][Dir_Idx][5] = PM_VHT_MD[_idx_Seg][Dir_Idx][5] + PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_MD[_idx_Seg][Dir_Idx][5] = EV_VHT_MD[_idx_Seg][Dir_Idx][5] + EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_MD[_idx_Seg][Dir_Idx][5] = DY_VHT_MD[_idx_Seg][Dir_Idx][5] + DY_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_HV[_idx_Seg][Dir_Idx][5] = FF_VHT_HV[_idx_Seg][Dir_Idx][5] + FF_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_HV[_idx_Seg][Dir_Idx][5] = AM_VHT_HV[_idx_Seg][Dir_Idx][5] + AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_HV[_idx_Seg][Dir_Idx][5] = MD_VHT_HV[_idx_Seg][Dir_Idx][5] + MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_HV[_idx_Seg][Dir_Idx][5] = PM_VHT_HV[_idx_Seg][Dir_Idx][5] + PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_HV[_idx_Seg][Dir_Idx][5] = EV_VHT_HV[_idx_Seg][Dir_Idx][5] + EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_HV[_idx_Seg][Dir_Idx][5] = DY_VHT_HV[_idx_Seg][Dir_Idx][5] + DY_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calc avg vht total for both direction
                FF_VHT[_idx_Seg][5][FunGrp_Idx]    = FF_VHT[_idx_Seg][5][FunGrp_Idx]    + FF_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT[_idx_Seg][5][FunGrp_Idx]    = AM_VHT[_idx_Seg][5][FunGrp_Idx]    + AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT[_idx_Seg][5][FunGrp_Idx]    = MD_VHT[_idx_Seg][5][FunGrp_Idx]    + MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT[_idx_Seg][5][FunGrp_Idx]    = PM_VHT[_idx_Seg][5][FunGrp_Idx]    + PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT[_idx_Seg][5][FunGrp_Idx]    = EV_VHT[_idx_Seg][5][FunGrp_Idx]    + EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT[_idx_Seg][5][FunGrp_Idx]    = DY_VHT[_idx_Seg][5][FunGrp_Idx]    + DY_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_PC[_idx_Seg][5][FunGrp_Idx] = FF_VHT_PC[_idx_Seg][5][FunGrp_Idx] + FF_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_PC[_idx_Seg][5][FunGrp_Idx] = AM_VHT_PC[_idx_Seg][5][FunGrp_Idx] + AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_PC[_idx_Seg][5][FunGrp_Idx] = MD_VHT_PC[_idx_Seg][5][FunGrp_Idx] + MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_PC[_idx_Seg][5][FunGrp_Idx] = PM_VHT_PC[_idx_Seg][5][FunGrp_Idx] + PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_PC[_idx_Seg][5][FunGrp_Idx] = EV_VHT_PC[_idx_Seg][5][FunGrp_Idx] + EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_PC[_idx_Seg][5][FunGrp_Idx] = DY_VHT_PC[_idx_Seg][5][FunGrp_Idx] + DY_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_LT[_idx_Seg][5][FunGrp_Idx] = FF_VHT_LT[_idx_Seg][5][FunGrp_Idx] + FF_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_LT[_idx_Seg][5][FunGrp_Idx] = AM_VHT_LT[_idx_Seg][5][FunGrp_Idx] + AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_LT[_idx_Seg][5][FunGrp_Idx] = MD_VHT_LT[_idx_Seg][5][FunGrp_Idx] + MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_LT[_idx_Seg][5][FunGrp_Idx] = PM_VHT_LT[_idx_Seg][5][FunGrp_Idx] + PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_LT[_idx_Seg][5][FunGrp_Idx] = EV_VHT_LT[_idx_Seg][5][FunGrp_Idx] + EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_LT[_idx_Seg][5][FunGrp_Idx] = DY_VHT_LT[_idx_Seg][5][FunGrp_Idx] + DY_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_MD[_idx_Seg][5][FunGrp_Idx] = FF_VHT_MD[_idx_Seg][5][FunGrp_Idx] + FF_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_MD[_idx_Seg][5][FunGrp_Idx] = AM_VHT_MD[_idx_Seg][5][FunGrp_Idx] + AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_MD[_idx_Seg][5][FunGrp_Idx] = MD_VHT_MD[_idx_Seg][5][FunGrp_Idx] + MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_MD[_idx_Seg][5][FunGrp_Idx] = PM_VHT_MD[_idx_Seg][5][FunGrp_Idx] + PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_MD[_idx_Seg][5][FunGrp_Idx] = EV_VHT_MD[_idx_Seg][5][FunGrp_Idx] + EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_MD[_idx_Seg][5][FunGrp_Idx] = DY_VHT_MD[_idx_Seg][5][FunGrp_Idx] + DY_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                FF_VHT_HV[_idx_Seg][5][FunGrp_Idx] = FF_VHT_HV[_idx_Seg][5][FunGrp_Idx] + FF_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                AM_VHT_HV[_idx_Seg][5][FunGrp_Idx] = AM_VHT_HV[_idx_Seg][5][FunGrp_Idx] + AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_VHT_HV[_idx_Seg][5][FunGrp_Idx] = MD_VHT_HV[_idx_Seg][5][FunGrp_Idx] + MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_VHT_HV[_idx_Seg][5][FunGrp_Idx] = PM_VHT_HV[_idx_Seg][5][FunGrp_Idx] + PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_VHT_HV[_idx_Seg][5][FunGrp_Idx] = EV_VHT_HV[_idx_Seg][5][FunGrp_Idx] + EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_VHT_HV[_idx_Seg][5][FunGrp_Idx] = DY_VHT_HV[_idx_Seg][5][FunGrp_Idx] + DY_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                
                ;calculate capacities
                AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] = (CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] * NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx] * 3 )
                MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] = (CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] * NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx] * 6 )
                PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] = (CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] * NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx] * 3 )
                EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] = (CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx] * NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx] * 12)
                DY_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                        MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                        PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx] +
                                                        EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]

                AM_CAP[_idx_Seg][Dir_Idx][5] = AM_CAP[_idx_Seg][Dir_Idx][5] + AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                MD_CAP[_idx_Seg][Dir_Idx][5] = MD_CAP[_idx_Seg][Dir_Idx][5] + MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                PM_CAP[_idx_Seg][Dir_Idx][5] = PM_CAP[_idx_Seg][Dir_Idx][5] + PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                EV_CAP[_idx_Seg][Dir_Idx][5] = EV_CAP[_idx_Seg][Dir_Idx][5] + EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                DY_CAP[_idx_Seg][Dir_Idx][5] = DY_CAP[_idx_Seg][Dir_Idx][5] + DY_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]

                ;VC Ratio------------------------------------------------------------------------------------------------
                ;calculate vc ratios by first calcualting the passenger car volumes
                AM_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] = (AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]) + AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_MD@ + AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_HV@
                MD_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] = (MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]) + MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_MD@ + MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_HV@
                PM_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] = (PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]) + PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_MD@ + PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_HV@
                EV_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] = (EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] - EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] - EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]) + EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_MD@ + EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx] * @PCE_HV@
                
                ;Caclulate capacity
                if (AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  AM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] = AM_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] / AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  MD_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] = MD_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] / MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  PM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] = PM_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] / PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                if (EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]>0)  EV_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] = EV_Vol_PCE[_idx_Seg][Dir_Idx][FunGrp_Idx] / EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]

                ;calculate max vc ratio
                MAX_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] = MAX(AM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] ,
                                                            MD_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] ,
                                                            PM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx] ,
                                                            EV_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]  )
                
                ;calculate total vc ratio by taking the max of fungrp
                AM_VC[_idx_Seg][Dir_Idx][5]  = MAX(AM_VC[_idx_Seg][Dir_Idx][5] , AM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx])
                MD_VC[_idx_Seg][Dir_Idx][5]  = MAX(MD_VC[_idx_Seg][Dir_Idx][5] , MD_VC[_idx_Seg][Dir_Idx][FunGrp_Idx])
                PM_VC[_idx_Seg][Dir_Idx][5]  = MAX(PM_VC[_idx_Seg][Dir_Idx][5] , PM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx])
                EV_VC[_idx_Seg][Dir_Idx][5]  = MAX(EV_VC[_idx_Seg][Dir_Idx][5] , EV_VC[_idx_Seg][Dir_Idx][FunGrp_Idx])
                MAX_VC[_idx_Seg][Dir_Idx][5] = MAX(MAX_VC[_idx_Seg][Dir_Idx][5], MAX_VC[_idx_Seg][Dir_Idx][FunGrp_Idx])
                
                
            ENDLOOP  ;FunGrp_Idx=1,4

            ;calculate link & lane totals for both directions and all functional groups
            NumLinks[_idx_Seg][5][5] = NumLinks[_idx_Seg][5][5] + NumLinks[_idx_Seg][Dir_Idx][5]
            
            NumLanes[_idx_Seg][5][5] = NumLanes[_idx_Seg][5][5] + NumLanes[_idx_Seg][Dir_Idx][5]
            
            ;calculate volume totals for both directions and all functional groups
            AM_Vol[_idx_Seg][5][5]    = AM_Vol[_idx_Seg][5][5]    + AM_Vol[_idx_Seg][Dir_Idx][5]
            MD_Vol[_idx_Seg][5][5]    = MD_Vol[_idx_Seg][5][5]    + MD_Vol[_idx_Seg][Dir_Idx][5]
            PM_Vol[_idx_Seg][5][5]    = PM_Vol[_idx_Seg][5][5]    + PM_Vol[_idx_Seg][Dir_Idx][5]
            EV_Vol[_idx_Seg][5][5]    = EV_Vol[_idx_Seg][5][5]    + EV_Vol[_idx_Seg][Dir_Idx][5]
            DY_Vol[_idx_Seg][5][5]    = DY_Vol[_idx_Seg][5][5]    + DY_Vol[_idx_Seg][Dir_Idx][5]
            
            AM_Vol_PC[_idx_Seg][5][5] = AM_Vol_PC[_idx_Seg][5][5] + AM_Vol_PC[_idx_Seg][Dir_Idx][5]
            MD_Vol_PC[_idx_Seg][5][5] = MD_Vol_PC[_idx_Seg][5][5] + MD_Vol_PC[_idx_Seg][Dir_Idx][5]
            PM_Vol_PC[_idx_Seg][5][5] = PM_Vol_PC[_idx_Seg][5][5] + PM_Vol_PC[_idx_Seg][Dir_Idx][5]
            EV_Vol_PC[_idx_Seg][5][5] = EV_Vol_PC[_idx_Seg][5][5] + EV_Vol_PC[_idx_Seg][Dir_Idx][5]
            DY_Vol_PC[_idx_Seg][5][5] = DY_Vol_PC[_idx_Seg][5][5] + DY_Vol_PC[_idx_Seg][Dir_Idx][5]
            
            AM_Vol_LT[_idx_Seg][5][5] = AM_Vol_LT[_idx_Seg][5][5] + AM_Vol_LT[_idx_Seg][Dir_Idx][5]
            MD_Vol_LT[_idx_Seg][5][5] = MD_Vol_LT[_idx_Seg][5][5] + MD_Vol_LT[_idx_Seg][Dir_Idx][5]
            PM_Vol_LT[_idx_Seg][5][5] = PM_Vol_LT[_idx_Seg][5][5] + PM_Vol_LT[_idx_Seg][Dir_Idx][5]
            EV_Vol_LT[_idx_Seg][5][5] = EV_Vol_LT[_idx_Seg][5][5] + EV_Vol_LT[_idx_Seg][Dir_Idx][5]
            DY_Vol_LT[_idx_Seg][5][5] = DY_Vol_LT[_idx_Seg][5][5] + DY_Vol_LT[_idx_Seg][Dir_Idx][5]
            
            AM_Vol_MD[_idx_Seg][5][5] = AM_Vol_MD[_idx_Seg][5][5] + AM_Vol_MD[_idx_Seg][Dir_Idx][5]
            MD_Vol_MD[_idx_Seg][5][5] = MD_Vol_MD[_idx_Seg][5][5] + MD_Vol_MD[_idx_Seg][Dir_Idx][5]
            PM_Vol_MD[_idx_Seg][5][5] = PM_Vol_MD[_idx_Seg][5][5] + PM_Vol_MD[_idx_Seg][Dir_Idx][5]
            EV_Vol_MD[_idx_Seg][5][5] = EV_Vol_MD[_idx_Seg][5][5] + EV_Vol_MD[_idx_Seg][Dir_Idx][5]
            DY_Vol_MD[_idx_Seg][5][5] = DY_Vol_MD[_idx_Seg][5][5] + DY_Vol_MD[_idx_Seg][Dir_Idx][5]
            
            AM_Vol_HV[_idx_Seg][5][5] = AM_Vol_HV[_idx_Seg][5][5] + AM_Vol_HV[_idx_Seg][Dir_Idx][5]
            MD_Vol_HV[_idx_Seg][5][5] = MD_Vol_HV[_idx_Seg][5][5] + MD_Vol_HV[_idx_Seg][Dir_Idx][5]
            PM_Vol_HV[_idx_Seg][5][5] = PM_Vol_HV[_idx_Seg][5][5] + PM_Vol_HV[_idx_Seg][Dir_Idx][5]
            EV_Vol_HV[_idx_Seg][5][5] = EV_Vol_HV[_idx_Seg][5][5] + EV_Vol_HV[_idx_Seg][Dir_Idx][5]
            DY_Vol_HV[_idx_Seg][5][5] = DY_Vol_HV[_idx_Seg][5][5] + DY_Vol_HV[_idx_Seg][Dir_Idx][5]
            
            ;calculate vmt totals for both directions and all functional groups
            AM_VMT[_idx_Seg][5][5]    = AM_VMT[_idx_Seg][5][5]    + AM_VMT[_idx_Seg][Dir_Idx][5]
            MD_VMT[_idx_Seg][5][5]    = MD_VMT[_idx_Seg][5][5]    + MD_VMT[_idx_Seg][Dir_Idx][5]
            PM_VMT[_idx_Seg][5][5]    = PM_VMT[_idx_Seg][5][5]    + PM_VMT[_idx_Seg][Dir_Idx][5]
            EV_VMT[_idx_Seg][5][5]    = EV_VMT[_idx_Seg][5][5]    + EV_VMT[_idx_Seg][Dir_Idx][5]
            DY_VMT[_idx_Seg][5][5]    = DY_VMT[_idx_Seg][5][5]    + DY_VMT[_idx_Seg][Dir_Idx][5]
            
            AM_VMT_PC[_idx_Seg][5][5] = AM_VMT_PC[_idx_Seg][5][5] + AM_VMT_PC[_idx_Seg][Dir_Idx][5]
            MD_VMT_PC[_idx_Seg][5][5] = MD_VMT_PC[_idx_Seg][5][5] + MD_VMT_PC[_idx_Seg][Dir_Idx][5]
            PM_VMT_PC[_idx_Seg][5][5] = PM_VMT_PC[_idx_Seg][5][5] + PM_VMT_PC[_idx_Seg][Dir_Idx][5]
            EV_VMT_PC[_idx_Seg][5][5] = EV_VMT_PC[_idx_Seg][5][5] + EV_VMT_PC[_idx_Seg][Dir_Idx][5]
            DY_VMT_PC[_idx_Seg][5][5] = DY_VMT_PC[_idx_Seg][5][5] + DY_VMT_PC[_idx_Seg][Dir_Idx][5]
            
            AM_VMT_LT[_idx_Seg][5][5] = AM_VMT_LT[_idx_Seg][5][5] + AM_VMT_LT[_idx_Seg][Dir_Idx][5]
            MD_VMT_LT[_idx_Seg][5][5] = MD_VMT_LT[_idx_Seg][5][5] + MD_VMT_LT[_idx_Seg][Dir_Idx][5]
            PM_VMT_LT[_idx_Seg][5][5] = PM_VMT_LT[_idx_Seg][5][5] + PM_VMT_LT[_idx_Seg][Dir_Idx][5]
            EV_VMT_LT[_idx_Seg][5][5] = EV_VMT_LT[_idx_Seg][5][5] + EV_VMT_LT[_idx_Seg][Dir_Idx][5]
            DY_VMT_LT[_idx_Seg][5][5] = DY_VMT_LT[_idx_Seg][5][5] + DY_VMT_LT[_idx_Seg][Dir_Idx][5]
            
            AM_VMT_MD[_idx_Seg][5][5] = AM_VMT_MD[_idx_Seg][5][5] + AM_VMT_MD[_idx_Seg][Dir_Idx][5]
            MD_VMT_MD[_idx_Seg][5][5] = MD_VMT_MD[_idx_Seg][5][5] + MD_VMT_MD[_idx_Seg][Dir_Idx][5]
            PM_VMT_MD[_idx_Seg][5][5] = PM_VMT_MD[_idx_Seg][5][5] + PM_VMT_MD[_idx_Seg][Dir_Idx][5]
            EV_VMT_MD[_idx_Seg][5][5] = EV_VMT_MD[_idx_Seg][5][5] + EV_VMT_MD[_idx_Seg][Dir_Idx][5]
            DY_VMT_MD[_idx_Seg][5][5] = DY_VMT_MD[_idx_Seg][5][5] + DY_VMT_MD[_idx_Seg][Dir_Idx][5]
            
            AM_VMT_HV[_idx_Seg][5][5] = AM_VMT_HV[_idx_Seg][5][5] + AM_VMT_HV[_idx_Seg][Dir_Idx][5]
            MD_VMT_HV[_idx_Seg][5][5] = MD_VMT_HV[_idx_Seg][5][5] + MD_VMT_HV[_idx_Seg][Dir_Idx][5]
            PM_VMT_HV[_idx_Seg][5][5] = PM_VMT_HV[_idx_Seg][5][5] + PM_VMT_HV[_idx_Seg][Dir_Idx][5]
            EV_VMT_HV[_idx_Seg][5][5] = EV_VMT_HV[_idx_Seg][5][5] + EV_VMT_HV[_idx_Seg][Dir_Idx][5]
            DY_VMT_HV[_idx_Seg][5][5] = DY_VMT_HV[_idx_Seg][5][5] + DY_VMT_HV[_idx_Seg][Dir_Idx][5]
            
            ;calculate vht totals for both directions and all functional groups
            FF_VHT[_idx_Seg][5][5]    = FF_VHT[_idx_Seg][5][5]    + FF_VHT[_idx_Seg][Dir_Idx][5]
            AM_VHT[_idx_Seg][5][5]    = AM_VHT[_idx_Seg][5][5]    + AM_VHT[_idx_Seg][Dir_Idx][5]
            MD_VHT[_idx_Seg][5][5]    = MD_VHT[_idx_Seg][5][5]    + MD_VHT[_idx_Seg][Dir_Idx][5]
            PM_VHT[_idx_Seg][5][5]    = PM_VHT[_idx_Seg][5][5]    + PM_VHT[_idx_Seg][Dir_Idx][5]
            EV_VHT[_idx_Seg][5][5]    = EV_VHT[_idx_Seg][5][5]    + EV_VHT[_idx_Seg][Dir_Idx][5]
            DY_VHT[_idx_Seg][5][5]    = DY_VHT[_idx_Seg][5][5]    + DY_VHT[_idx_Seg][Dir_Idx][5]
            
            FF_VHT_PC[_idx_Seg][5][5] = FF_VHT_PC[_idx_Seg][5][5] + FF_VHT_PC[_idx_Seg][Dir_Idx][5]
            AM_VHT_PC[_idx_Seg][5][5] = AM_VHT_PC[_idx_Seg][5][5] + AM_VHT_PC[_idx_Seg][Dir_Idx][5]
            MD_VHT_PC[_idx_Seg][5][5] = MD_VHT_PC[_idx_Seg][5][5] + MD_VHT_PC[_idx_Seg][Dir_Idx][5]
            PM_VHT_PC[_idx_Seg][5][5] = PM_VHT_PC[_idx_Seg][5][5] + PM_VHT_PC[_idx_Seg][Dir_Idx][5]
            EV_VHT_PC[_idx_Seg][5][5] = EV_VHT_PC[_idx_Seg][5][5] + EV_VHT_PC[_idx_Seg][Dir_Idx][5]
            DY_VHT_PC[_idx_Seg][5][5] = DY_VHT_PC[_idx_Seg][5][5] + DY_VHT_PC[_idx_Seg][Dir_Idx][5]
            
            FF_VHT_LT[_idx_Seg][5][5] = FF_VHT_LT[_idx_Seg][5][5] + FF_VHT_LT[_idx_Seg][Dir_Idx][5]
            AM_VHT_LT[_idx_Seg][5][5] = AM_VHT_LT[_idx_Seg][5][5] + AM_VHT_LT[_idx_Seg][Dir_Idx][5]
            MD_VHT_LT[_idx_Seg][5][5] = MD_VHT_LT[_idx_Seg][5][5] + MD_VHT_LT[_idx_Seg][Dir_Idx][5]
            PM_VHT_LT[_idx_Seg][5][5] = PM_VHT_LT[_idx_Seg][5][5] + PM_VHT_LT[_idx_Seg][Dir_Idx][5]
            EV_VHT_LT[_idx_Seg][5][5] = EV_VHT_LT[_idx_Seg][5][5] + EV_VHT_LT[_idx_Seg][Dir_Idx][5]
            DY_VHT_LT[_idx_Seg][5][5] = DY_VHT_LT[_idx_Seg][5][5] + DY_VHT_LT[_idx_Seg][Dir_Idx][5]
            
            FF_VHT_MD[_idx_Seg][5][5] = FF_VHT_MD[_idx_Seg][5][5] + FF_VHT_MD[_idx_Seg][Dir_Idx][5]
            AM_VHT_MD[_idx_Seg][5][5] = AM_VHT_MD[_idx_Seg][5][5] + AM_VHT_MD[_idx_Seg][Dir_Idx][5]
            MD_VHT_MD[_idx_Seg][5][5] = MD_VHT_MD[_idx_Seg][5][5] + MD_VHT_MD[_idx_Seg][Dir_Idx][5]
            PM_VHT_MD[_idx_Seg][5][5] = PM_VHT_MD[_idx_Seg][5][5] + PM_VHT_MD[_idx_Seg][Dir_Idx][5]
            EV_VHT_MD[_idx_Seg][5][5] = EV_VHT_MD[_idx_Seg][5][5] + EV_VHT_MD[_idx_Seg][Dir_Idx][5]
            DY_VHT_MD[_idx_Seg][5][5] = DY_VHT_MD[_idx_Seg][5][5] + DY_VHT_MD[_idx_Seg][Dir_Idx][5]
            
            FF_VHT_HV[_idx_Seg][5][5] = FF_VHT_HV[_idx_Seg][5][5] + FF_VHT_HV[_idx_Seg][Dir_Idx][5]
            AM_VHT_HV[_idx_Seg][5][5] = AM_VHT_HV[_idx_Seg][5][5] + AM_VHT_HV[_idx_Seg][Dir_Idx][5]
            MD_VHT_HV[_idx_Seg][5][5] = MD_VHT_HV[_idx_Seg][5][5] + MD_VHT_HV[_idx_Seg][Dir_Idx][5]
            PM_VHT_HV[_idx_Seg][5][5] = PM_VHT_HV[_idx_Seg][5][5] + PM_VHT_HV[_idx_Seg][Dir_Idx][5]
            EV_VHT_HV[_idx_Seg][5][5] = EV_VHT_HV[_idx_Seg][5][5] + EV_VHT_HV[_idx_Seg][Dir_Idx][5]
            DY_VHT_HV[_idx_Seg][5][5] = DY_VHT_HV[_idx_Seg][5][5] + DY_VHT_HV[_idx_Seg][Dir_Idx][5]
            
            ;calculate capacities for both directions and all functional groups
            AM_CAP[_idx_Seg][5][5] = AM_CAP[_idx_Seg][5][5] + AM_CAP[_idx_Seg][Dir_Idx][5]
            MD_CAP[_idx_Seg][5][5] = MD_CAP[_idx_Seg][5][5] + MD_CAP[_idx_Seg][Dir_Idx][5]
            PM_CAP[_idx_Seg][5][5] = PM_CAP[_idx_Seg][5][5] + PM_CAP[_idx_Seg][Dir_Idx][5]
            EV_CAP[_idx_Seg][5][5] = EV_CAP[_idx_Seg][5][5] + EV_CAP[_idx_Seg][Dir_Idx][5]
            DY_CAP[_idx_Seg][5][5] = DY_CAP[_idx_Seg][5][5] + DY_CAP[_idx_Seg][Dir_Idx][5]
            
            ;calculate vc ratio maxs for both directions and all functional groups
            AM_VC[_idx_Seg][5][5]  = MAX(AM_VC[_idx_Seg][5][5] , AM_VC[_idx_Seg][Dir_Idx][5])
            MD_VC[_idx_Seg][5][5]  = MAX(MD_VC[_idx_Seg][5][5] , MD_VC[_idx_Seg][Dir_Idx][5])
            PM_VC[_idx_Seg][5][5]  = MAX(PM_VC[_idx_Seg][5][5] , PM_VC[_idx_Seg][Dir_Idx][5])
            EV_VC[_idx_Seg][5][5]  = MAX(EV_VC[_idx_Seg][5][5] , EV_VC[_idx_Seg][Dir_Idx][5])
            MAX_VC[_idx_Seg][5][5] = MAX(MAX_VC[_idx_Seg][5][5], MAX_VC[_idx_Seg][Dir_Idx][5])
            
            
            ;assign distance and FT to segment Total classification
            Dist_1Dir[_idx_Seg][Dir_Idx][5] = 0
            FTNum[_idx_Seg][Dir_Idx][5]     = 0
            
            ;if freeway vol > arterial vol, use freeway to classify, otherwise use arterial to classify
            if (DY_Vol[_idx_Seg][Dir_Idx][1]>0 & DY_Vol[_idx_Seg][Dir_Idx][2]>0)
                if (DY_Vol[_idx_Seg][Dir_Idx][2] >= DY_Vol[_idx_Seg][Dir_Idx][1])
                    Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][2]
                    FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][2]
                else
                    Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][1]
                    FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][1]
                endif
            
            ;if not both arterial and freeway volumes present, but there is freeway distance, classify as freeway
            elseif (Dist_1Dir[_idx_Seg][Dir_Idx][2]>0)
                Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][2]
                FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][2]
            
            ;if not both arterial and freeway volumes present and not freeway distance, but there is arterial distance, classify as arterial
            elseif (Dist_1Dir[_idx_Seg][Dir_Idx][1]>0)
                Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][1]
                FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][1]
            
            ;if not arterial nor freeway, but there is managed lane distance, classify as managed
            elseif (Dist_1Dir[_idx_Seg][Dir_Idx][3]>0)
                Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][3]
                FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][3]
            
            ;if not arterial, freeway, nor managed, but there is CD distance, classify as CD
            elseif (Dist_1Dir[_idx_Seg][Dir_Idx][4]>0)
                Dist_1Dir[_idx_Seg][Dir_Idx][5] = Dist_1Dir[_idx_Seg][Dir_Idx][4]
                FTNum[_idx_Seg][Dir_Idx][5] = FTNum[_idx_Seg][Dir_Idx][4]
                
            endif
            
            
            ;calculate distance and capacity totals for both directions and all functional groups
            Dist_1Dir[_idx_Seg][5][5] = Dist_1Dir[_idx_Seg][5][5] + Dist_1Dir[_idx_Seg][Dir_Idx][5]
            
            CAP1HR1LN[_idx_Seg][5][5] = CAP1HR1LN[_idx_Seg][5][5] + CAP1HR1LN[_idx_Seg][Dir_Idx][5]
            
            if (Dist_1Dir[_idx_Seg][1][5]>0 & Dist_1Dir[_idx_Seg][2][5]>0)
                
                Dist_1Dir[_idx_Seg][5][5] = Dist_1Dir[_idx_Seg][5][5] / 2
                
                CAP1HR1LN[_idx_Seg][5][5] = CAP1HR1LN[_idx_Seg][5][5] / 2
                
            endif
            
            ;calcualte ft total for both directions and all functional groups
            FTNum[_idx_Seg][5][5] = MAX(FTNum[_idx_Seg][5][5], FTNum[_idx_Seg][Dir_Idx][5])
            
            ;calcualte ft total for both directions and each functional groups
            FTNum[_idx_Seg][5][1] = MAX(FTNum[_idx_Seg][5][1], FTNum[_idx_Seg][Dir_Idx][5])
            FTNum[_idx_Seg][5][2] = MAX(FTNum[_idx_Seg][5][2], FTNum[_idx_Seg][Dir_Idx][5])
            FTNum[_idx_Seg][5][3] = MAX(FTNum[_idx_Seg][5][3], FTNum[_idx_Seg][Dir_Idx][5])
            FTNum[_idx_Seg][5][4] = MAX(FTNum[_idx_Seg][5][4], FTNum[_idx_Seg][Dir_Idx][5])
            
            
        ENDLOOP  ;Dir_Idx=1,2
        
        
        
        ;calculate remaining values for direction 5
        LOOP FunGrp_Idx=1,4
            ;calculate capacity for both directions and each functional group
            if(NumLanes[_idx_Seg][5][FunGrp_Idx]>0)  CAP1HR1LN[_idx_Seg][5][FunGrp_Idx] = (CAP1HR1LN[_idx_Seg][1][FunGrp_Idx] * NumLanes[_idx_Seg][1][FunGrp_Idx] / NumLanes[_idx_Seg][5][FunGrp_Idx]) + (CAP1HR1LN[_idx_Seg][2][FunGrp_Idx] * NumLanes[_idx_Seg][2][FunGrp_Idx] / NumLanes[_idx_Seg][5][FunGrp_Idx])
            
            ;calcualte total capacity for both directions and each functional group
            AM_CAP[_idx_Seg][5][FunGrp_Idx] = AM_CAP[_idx_Seg][1][FunGrp_Idx] + AM_CAP[_idx_Seg][2][FunGrp_Idx]
            MD_CAP[_idx_Seg][5][FunGrp_Idx] = MD_CAP[_idx_Seg][1][FunGrp_Idx] + MD_CAP[_idx_Seg][2][FunGrp_Idx]
            PM_CAP[_idx_Seg][5][FunGrp_Idx] = PM_CAP[_idx_Seg][1][FunGrp_Idx] + PM_CAP[_idx_Seg][2][FunGrp_Idx]
            EV_CAP[_idx_Seg][5][FunGrp_Idx] = EV_CAP[_idx_Seg][1][FunGrp_Idx] + EV_CAP[_idx_Seg][2][FunGrp_Idx]
            DY_CAP[_idx_Seg][5][FunGrp_Idx] = DY_CAP[_idx_Seg][1][FunGrp_Idx] + DY_CAP[_idx_Seg][2][FunGrp_Idx]

            ;calcualte vc for both directions and each functional group
            AM_VC[_idx_Seg][5][FunGrp_Idx]  = MAX(AM_VC[_idx_Seg][1][FunGrp_Idx] , AM_VC[_idx_Seg][2][FunGrp_Idx])
            MD_VC[_idx_Seg][5][FunGrp_Idx]  = MAX(MD_VC[_idx_Seg][1][FunGrp_Idx] , MD_VC[_idx_Seg][2][FunGrp_Idx])
            PM_VC[_idx_Seg][5][FunGrp_Idx]  = MAX(PM_VC[_idx_Seg][1][FunGrp_Idx] , PM_VC[_idx_Seg][2][FunGrp_Idx])
            EV_VC[_idx_Seg][5][FunGrp_Idx]  = MAX(EV_VC[_idx_Seg][1][FunGrp_Idx] , EV_VC[_idx_Seg][2][FunGrp_Idx])
            MAX_VC[_idx_Seg][5][FunGrp_Idx] = MAX(MAX_VC[_idx_Seg][1][FunGrp_Idx], MAX_VC[_idx_Seg][2][FunGrp_Idx])
            
        ENDLOOP  ;FunGroup_Idx=1,4
        
        
        
        ;loop through direction and functional groups to assign variables ==============================================
        ;include the 5th dimentions to ensure we grab the total fungrp values and the both direction values
        LOOP Dir_Idx=1,5
            
            ;skip values 3 and 4 since empty
            if (Dir_Idx>2 & Dir_Idx<5) CONTINUE
            
            ;loop through fungrps
            LOOP FunGrp_Idx=1,5
                
                ;initialize output variables----------------------------------------------------------------------------
                ;only initialize variables to null values if segid didn't exist on original link network input
                if (_idx_Seg>Seg_Idx)
                    
                    ;calculate an assign output variables for direction
                    if (Dir_Idx=5) reDIRECTION = 'Both'
                    if (Dir_Idx=1) reDIRECTION = 'D1'
                    if (Dir_Idx=2) reDIRECTION = 'D2'
                    
                    ; calculate and assign output variables for functional group
                    if (FunGrp_Idx=5)
                        reFUNCGROUP = 'Total'
                        AddIdx = 0
                    elseif (FunGrp_Idx=1)
                        reFUNCGROUP = 'Arterial'
                        AddIdx = 0.1
                    elseif (FunGrp_Idx=2)
                        reFUNCGROUP = 'Freeway'
                        AddIdx = 0.2
                    elseif (FunGrp_Idx=3)
                        reFUNCGROUP = 'Managed'
                        AddIdx = 0.3
                    elseif (FunGrp_Idx=4)
                        reFUNCGROUP = 'CD Road'
                        AddIdx = 0.4
                    endif
                    
                    ;assign null values to most of the variables
                    reSEGIDIDX      = 0 + AddIdx
                    reSEGID         = TRIM(LTRIM(dba.2.SEGID[lp_segidx]))
                    reDISTANCE      = dba.2.DISTANCE[lp_segidx]
                    reDIRECTION_NAME= ''
                    reSUBAREAID     = 0
                    reCO_FIPS       = 0
                    reAREATYPE      = 0
                    reATYPENAME     = ''
                    reLINKS         = 0
                    reLANES         = 0
                    reLANEMILES     = 0
                    reFT            = 0
                    reFTCLASS       = ''
                    reCAP1HL        = 0
                    reFG_Share         = 0
                    reAM_Vol        = 0
                    reMD_Vol        = 0
                    rePM_Vol        = 0
                    reEV_Vol        = 0
                    reDY_Vol        = 0
                    reAM_Vol_PC     = 0
                    reMD_Vol_PC     = 0
                    rePM_Vol_PC     = 0
                    reEV_Vol_PC     = 0
                    reDY_Vol_PC     = 0
                    reAM_Vol_LT     = 0
                    reMD_Vol_LT     = 0
                    rePM_Vol_LT     = 0
                    reEV_Vol_LT     = 0
                    reDY_Vol_LT     = 0
                    reAM_Vol_MD     = 0
                    reMD_Vol_MD     = 0
                    rePM_Vol_MD     = 0
                    reEV_Vol_MD     = 0
                    reDY_Vol_MD     = 0
                    reAM_Vol_HV     = 0
                    reMD_Vol_HV     = 0
                    rePM_Vol_HV     = 0
                    reEV_Vol_HV     = 0
                    reDY_Vol_HV     = 0
                    reAM_Spd        = 0
                    reMD_Spd        = 0
                    rePM_Spd        = 0
                    reEV_Spd        = 0
                    reDY_Spd        = 0
                    reFF_Spd        = 0
                    reAM_Tme        = 0
                    reMD_Tme        = 0
                    rePM_Tme        = 0
                    reEV_Tme        = 0
                    reDY_Tme        = 0
                    reFF_Tme        = 0
                    reAM_CAP        = 0
                    reMD_CAP        = 0
                    rePM_CAP        = 0
                    reEV_CAP        = 0
                    reDY_CAP        = 0
                    reAM_VC         = 0
                    reMD_VC         = 0
                    rePM_VC         = 0
                    reEV_VC         = 0
                    reMAX_VC        = 0
                    reAM_VMT        = 0
                    reMD_VMT        = 0
                    rePM_VMT        = 0
                    reEV_VMT        = 0
                    reDY_VMT        = 0
                    reAM_VMT_PC     = 0
                    reMD_VMT_PC     = 0
                    rePM_VMT_PC     = 0
                    reEV_VMT_PC     = 0
                    reDY_VMT_PC     = 0
                    reAM_VMT_LT     = 0
                    reMD_VMT_LT     = 0
                    rePM_VMT_LT     = 0
                    reEV_VMT_LT     = 0
                    reDY_VMT_LT     = 0
                    reAM_VMT_MD     = 0
                    reMD_VMT_MD     = 0
                    rePM_VMT_MD     = 0
                    reEV_VMT_MD     = 0
                    reDY_VMT_MD     = 0
                    reAM_VMT_HV     = 0
                    reMD_VMT_HV     = 0
                    rePM_VMT_HV     = 0
                    reEV_VMT_HV     = 0
                    reDY_VMT_HV     = 0
                    reFF_VHT        = 0
                    reAM_VHT        = 0
                    reMD_VHT        = 0
                    rePM_VHT        = 0
                    reEV_VHT        = 0
                    reDY_VHT        = 0
                    reAM_VHT_PC     = 0
                    reMD_VHT_PC     = 0
                    rePM_VHT_PC     = 0
                    reEV_VHT_PC     = 0
                    reDY_VHT_PC     = 0
                    reAM_VHT_LT     = 0
                    reMD_VHT_LT     = 0
                    rePM_VHT_LT     = 0
                    reEV_VHT_LT     = 0
                    reDY_VHT_LT     = 0
                    reAM_VHT_MD     = 0
                    reMD_VHT_MD     = 0
                    rePM_VHT_MD     = 0
                    reEV_VHT_MD     = 0
                    reDY_VHT_MD     = 0
                    reAM_VHT_HV     = 0
                    reMD_VHT_HV     = 0
                    rePM_VHT_HV     = 0
                    reEV_VHT_HV     = 0
                    reDY_VHT_HV     = 0
                    reAM_VHD        = 0
                    reMD_VHD        = 0
                    rePM_VHD        = 0
                    reEV_VHD        = 0
                    reDY_VHD        = 0
                    reAM_VHD_PC     = 0
                    reMD_VHD_PC     = 0
                    rePM_VHD_PC     = 0
                    reEV_VHD_PC     = 0
                    reDY_VHD_PC     = 0
                    reAM_VHD_LT     = 0
                    reMD_VHD_LT     = 0
                    rePM_VHD_LT     = 0
                    reEV_VHD_LT     = 0
                    reDY_VHD_LT     = 0
                    reAM_VHD_MD     = 0
                    reMD_VHD_MD     = 0
                    rePM_VHD_MD     = 0
                    reEV_VHD_MD     = 0
                    reDY_VHD_MD     = 0
                    reAM_VHD_HV     = 0
                    reMD_VHD_HV     = 0
                    rePM_VHD_HV     = 0
                    reEV_VHD_HV     = 0
                    reDY_VHD_HV     = 0
                    reAM_PRDFAC     = 0
                    reMD_PRDFAC     = 0
                    rePM_PRDFAC     = 0
                    reEV_PRDFAC     = 0
                    reAM_MDPCT      = 0
                    reMD_MDPCT      = 0
                    rePM_MDPCT      = 0
                    reEV_MDPCT      = 0
                    reDY_MDPCT      = 0
                    reAM_HVPCT      = 0
                    reMD_HVPCT      = 0
                    rePM_HVPCT      = 0
                    reEV_HVPCT      = 0
                    reDY_HVPCT      = 0
                    reAM_DFAC       = 0
                    reMD_DFAC       = 0
                    rePM_DFAC       = 0
                    reEV_DFAC       = 0
                    reDY_DFAC       = 0
                    
                ;assign output variables---------------------------------------------------------------------------------
                ;assign to those segments that had data through the network
                else
                    
                    ;calculate and assign output variables for links, lanes, capacity, distance, and ft number
                    reDIRECTION_NAME = DIRECTION_NAME[_idx_Seg][Dir_Idx]
                    reLINKS          = NumLinks[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reLANES          = NumLanes[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reCAP1HL         = CAP1HR1LN[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDIST           = Dist_1Dir[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reFT             = FTNum[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    
                    ;calculate ftclass
                    if (reFT=2)
                        reFTCLASS = 'Principal Arterial'
                    elseif (reFT=3)
                        reFTCLASS = 'Minor Arterial'
                    elseif (reFT=4-5)
                        reFTCLASS = 'Collector'
                    elseif (reFT=6-7)
                        reFTCLASS = 'Local'
                    elseif (reFT=12-15)
                        reFTCLASS = 'Expressway'
                    elseif (reFT=20-42)
                        reFTCLASS = 'Freeway'
                    else
                        reFTCLASS = 'Other'
                    endif
                    
                    
                    ;calculate distance and lanemiles
                    reDISTANCE     = dba.2.DISTANCE[lp_segidx]
                    reLANEMILES    = reLANES * reDISTANCE
                    
                    
                    ;calculate an assign output variables for direction
                    if (Dir_Idx=5) reDIRECTION = 'Both'
                    if (Dir_Idx=1) reDIRECTION = 'D1'
                    if (Dir_Idx=2) reDIRECTION = 'D2'
                    

                    if (Dir_Idx=5)
                        reDIRECTION_NAME = 'All'
                    endif
                    
                    
                    ; calculate and assign output variables for functional group
                    if (FunGrp_Idx=5)
                        reFUNCGROUP = 'Total'
                        AddIdx = 0
                    elseif (FunGrp_Idx=1)
                        reFUNCGROUP = 'Arterial'
                        AddIdx = 0.1
                    elseif (FunGrp_Idx=2)
                        reFUNCGROUP = 'Freeway'
                        AddIdx = 0.2
                    elseif (FunGrp_Idx=3)
                        reFUNCGROUP = 'Managed'
                        AddIdx = 0.3
                    elseif (FunGrp_Idx=4)
                        reFUNCGROUP = 'CD Road'
                        AddIdx = 0.4
                    endif
                    
                    
                    ;calculate functional group factor and assign output variables
                    if (FunGrp_Idx=5)
                        reFG_Share = 1.0
                    elseif (DY_Vol[_idx_Seg][Dir_Idx][5]>0)
                        reFG_Share = DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx] / DY_Vol[_idx_Seg][Dir_Idx][5]
                    else
                        reFG_Share = 0.0
                    endif
                    
                    
                    ;calculate remaining topic variables
                    reSEGIDIDX      = _idx_Seg + AddIdx
                    reSEGID         = SEGID_Name[_idx_Seg]
                    reSUBAREAID     = Value_SUBAREAID
                    reCO_FIPS       = Value_CO_FIPS
                    reAREATYPE      = Value_AREATYPE
                    
                    
                    ;calculate areatype name
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
                    
                    
                    ;assign output variables for volume
                    reAM_Vol    = AM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_Vol    = MD_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_Vol    = PM_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_Vol    = EV_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_Vol    = DY_Vol[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_Vol_PC = AM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_Vol_PC = MD_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_Vol_PC = PM_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_Vol_PC = EV_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_Vol_PC = DY_Vol_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_Vol_LT = AM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_Vol_LT = MD_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_Vol_LT = PM_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_Vol_LT = EV_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_Vol_LT = DY_Vol_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_Vol_MD = AM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_Vol_MD = MD_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_Vol_MD = PM_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_Vol_MD = EV_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_Vol_MD = DY_Vol_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_Vol_HV = AM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_Vol_HV = MD_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_Vol_HV = PM_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_Vol_HV = EV_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_Vol_HV = DY_Vol_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    ;assign output variables for vmt
                    reAM_VMT    = AM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VMT    = MD_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VMT    = PM_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VMT    = EV_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VMT    = DY_VMT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_VMT_PC = AM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VMT_PC = MD_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VMT_PC = PM_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VMT_PC = EV_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VMT_PC = DY_VMT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_VMT_LT = AM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VMT_LT = MD_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VMT_LT = PM_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VMT_LT = EV_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VMT_LT = DY_VMT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_VMT_MD = AM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VMT_MD = MD_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VMT_MD = PM_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VMT_MD = EV_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VMT_MD = DY_VMT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reAM_VMT_HV = AM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VMT_HV = MD_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VMT_HV = PM_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VMT_HV = EV_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VMT_HV = DY_VMT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    ;assign output variables for vht
                    reFF_VHT    = FF_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reAM_VHT    = AM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VHT    = MD_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VHT    = PM_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VHT    = EV_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VHT    = DY_VHT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reFF_VHT_PC = FF_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reAM_VHT_PC = AM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VHT_PC = MD_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VHT_PC = PM_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VHT_PC = EV_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VHT_PC = DY_VHT_PC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reFF_VHT_LT = FF_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reAM_VHT_LT = AM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VHT_LT = MD_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VHT_LT = PM_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VHT_LT = EV_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VHT_LT = DY_VHT_LT[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reFF_VHT_MD = FF_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reAM_VHT_MD = AM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VHT_MD = MD_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VHT_MD = PM_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VHT_MD = EV_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VHT_MD = DY_VHT_MD[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    reFF_VHT_HV = FF_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reAM_VHT_HV = AM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VHT_HV = MD_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VHT_HV = PM_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VHT_HV = EV_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_VHT_HV = DY_VHT_HV[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    ;assign output variables for capacity
                    reAM_CAP = AM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_CAP = MD_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_CAP = PM_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_CAP = EV_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_CAP = DY_CAP[_idx_Seg][Dir_Idx][FunGrp_Idx]

                    ;assign output variables for vc ratios
                    reAM_VC  = AM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_VC  = MD_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_VC  = PM_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_VC  = EV_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMAX_VC = MAX_VC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                    
                    ;calculate and assign output variables for time
                    reFF_Tme     = 0
                    reAM_Tme     = 0
                    reMD_Tme     = 0
                    rePM_Tme     = 0
                    reEV_Tme     = 0
                    reDY_Tme     = 0
                    
                    reFF_Tme_LT  = 0
                    reAM_Tme_LT  = 0
                    reMD_Tme_LT  = 0
                    rePM_Tme_LT  = 0
                    reEV_Tme_LT  = 0
                    reDY_Tme_LT  = 0
                    
                    reFF_Tme_MD  = 0
                    reAM_Tme_MD  = 0
                    reMD_Tme_MD  = 0
                    rePM_Tme_MD  = 0
                    reEV_Tme_MD  = 0
                    reDY_Tme_MD  = 0
                    
                    reFF_Tme_HV  = 0
                    reAM_Tme_HV  = 0
                    reMD_Tme_HV  = 0
                    rePM_Tme_HV  = 0
                    reEV_Tme_HV  = 0
                    reDY_Tme_HV  = 0
                    
                    if (reDY_Vol>0)     reFF_Tme     = reFF_VHT    / reDY_Vol    * 60
                    if (reAM_Vol>0)     reAM_Tme     = reAM_VHT    / reAM_Vol    * 60
                    if (reMD_Vol>0)     reMD_Tme     = reMD_VHT    / reMD_Vol    * 60
                    if (rePM_Vol>0)     rePM_Tme     = rePM_VHT    / rePM_Vol    * 60
                    if (reEV_Vol>0)     reEV_Tme     = reEV_VHT    / reEV_Vol    * 60
                    if (reDY_Vol>0)     reDY_Tme     = reDY_VHT    / reDY_Vol    * 60
                    
                    if (reDY_Vol_PC>0)  reFF_Tme     = reFF_VHT_PC / reDY_Vol_PC * 60
                    if (reAM_Vol_PC>0)  reAM_Tme     = reAM_VHT_PC / reAM_Vol_PC * 60
                    if (reMD_Vol_PC>0)  reMD_Tme     = reMD_VHT_PC / reMD_Vol_PC * 60
                    if (rePM_Vol_PC>0)  rePM_Tme     = rePM_VHT_PC / rePM_Vol_PC * 60
                    if (reEV_Vol_PC>0)  reEV_Tme     = reEV_VHT_PC / reEV_Vol_PC * 60
                    if (reDY_Vol_PC>0)  reDY_Tme     = reDY_VHT_PC / reDY_Vol_PC * 60
                    
                    if (reDY_Vol_LT>0)  reFF_Tme_LT  = reFF_VHT_LT / reDY_Vol_LT * 60
                    if (reAM_Vol_LT>0)  reAM_Tme_LT  = reAM_VHT_LT / reAM_Vol_LT * 60
                    if (reMD_Vol_LT>0)  reMD_Tme_LT  = reMD_VHT_LT / reMD_Vol_LT * 60
                    if (rePM_Vol_LT>0)  rePM_Tme_LT  = rePM_VHT_LT / rePM_Vol_LT * 60
                    if (reEV_Vol_LT>0)  reEV_Tme_LT  = reEV_VHT_LT / reEV_Vol_LT * 60
                    if (reDY_Vol_LT>0)  reDY_Tme_LT  = reDY_VHT_LT / reDY_Vol_LT * 60
                    
                    if (reDY_Vol_MD>0)  reFF_Tme_MD  = reFF_VHT_MD / reDY_Vol_MD * 60
                    if (reAM_Vol_MD>0)  reAM_Tme_MD  = reAM_VHT_MD / reAM_Vol_MD * 60
                    if (reMD_Vol_MD>0)  reMD_Tme_MD  = reMD_VHT_MD / reMD_Vol_MD * 60
                    if (rePM_Vol_MD>0)  rePM_Tme_MD  = rePM_VHT_MD / rePM_Vol_MD * 60
                    if (reEV_Vol_MD>0)  reEV_Tme_MD  = reEV_VHT_MD / reEV_Vol_MD * 60
                    if (reDY_Vol_MD>0)  reDY_Tme_MD  = reDY_VHT_MD / reDY_Vol_MD * 60
                    
                    if (reDY_Vol_HV>0)  reFF_Tme_HV  = reFF_VHT_HV / reDY_Vol_HV * 60
                    if (reAM_Vol_HV>0)  reAM_Tme_HV  = reAM_VHT_HV / reAM_Vol_HV * 60
                    if (reMD_Vol_HV>0)  reMD_Tme_HV  = reMD_VHT_HV / reMD_Vol_HV * 60
                    if (rePM_Vol_HV>0)  rePM_Tme_HV  = rePM_VHT_HV / rePM_Vol_HV * 60
                    if (reEV_Vol_HV>0)  reEV_Tme_HV  = reEV_VHT_HV / reEV_Vol_HV * 60
                    if (reDY_Vol_HV>0)  reDY_Tme_HV  = reDY_VHT_HV / reDY_Vol_HV * 60
                    
                    ;recalculate if shorter than freeflow
                    reAM_Tme     = MAX(reAM_Tme,    reFF_Tme)
                    reMD_Tme     = MAX(reMD_Tme,    reFF_Tme)
                    rePM_Tme     = MAX(rePM_Tme,    reFF_Tme)
                    reEV_Tme     = MAX(reEV_Tme,    reFF_Tme)
                    reDY_Tme     = MAX(reDY_Tme,    reFF_Tme)
                    
                    reAM_Tme_LT  = MAX(reAM_Tme_LT, reFF_Tme_LT)
                    reMD_Tme_LT  = MAX(reMD_Tme_LT, reFF_Tme_LT)
                    rePM_Tme_LT  = MAX(rePM_Tme_LT, reFF_Tme_LT)
                    reEV_Tme_LT  = MAX(reEV_Tme_LT, reFF_Tme_LT)
                    reDY_Tme_LT  = MAX(reDY_Tme_LT, reFF_Tme_LT)
                    
                    reAM_Tme_MD  = MAX(reAM_Tme_MD, reFF_Tme_MD)
                    reMD_Tme_MD  = MAX(reMD_Tme_MD, reFF_Tme_MD)
                    rePM_Tme_MD  = MAX(rePM_Tme_MD, reFF_Tme_MD)
                    reEV_Tme_MD  = MAX(reEV_Tme_MD, reFF_Tme_MD)
                    reDY_Tme_MD  = MAX(reDY_Tme_MD, reFF_Tme_MD)
                    
                    reAM_Tme_HV  = MAX(reAM_Tme_HV, reFF_Tme_HV)
                    reMD_Tme_HV  = MAX(reMD_Tme_HV, reFF_Tme_HV)
                    rePM_Tme_HV  = MAX(rePM_Tme_HV, reFF_Tme_HV)
                    reEV_Tme_HV  = MAX(reEV_Tme_HV, reFF_Tme_HV)
                    reDY_Tme_HV  = MAX(reDY_Tme_HV, reFF_Tme_HV)
                    
                    
                    ;calculate and assign output variables for speed
                    reFF_Spd     = 0
                    reAM_Spd     = 0
                    reMD_Spd     = 0
                    rePM_Spd     = 0
                    reEV_Spd     = 0
                    reDY_Spd     = 0
                    
                    reFF_Spd_LT  = 0
                    reAM_Spd_LT  = 0
                    reMD_Spd_LT  = 0
                    rePM_Spd_LT  = 0
                    reEV_Spd_LT  = 0
                    reDY_Spd_LT  = 0
                    
                    reFF_Spd_MD  = 0
                    reAM_Spd_MD  = 0
                    reMD_Spd_MD  = 0
                    rePM_Spd_MD  = 0
                    reEV_Spd_MD  = 0
                    reDY_Spd_MD  = 0
                    
                    reFF_Spd_HV  = 0
                    reAM_Spd_HV  = 0
                    reMD_Spd_HV  = 0
                    rePM_Spd_HV  = 0
                    reEV_Spd_HV  = 0
                    reDY_Spd_HV  = 0
                    
                    if (reFF_VHT>0)     reFF_Spd     = reDY_VMT    / reFF_VHT
                    if (reAM_VHT>0)     reAM_Spd     = reAM_VMT    / reAM_VHT
                    if (reMD_VHT>0)     reMD_Spd     = reMD_VMT    / reMD_VHT
                    if (rePM_VHT>0)     rePM_Spd     = rePM_VMT    / rePM_VHT
                    if (reEV_VHT>0)     reEV_Spd     = reEV_VMT    / reEV_VHT
                    if (reDY_VHT>0)     reDY_Spd     = reDY_VMT    / reDY_VHT
                    
                    if (reFF_VHT_PC>0)  reFF_Spd    = reDY_VMT     / reFF_VHT
                    if (reAM_VHT_PC>0)  reAM_Spd    = reAM_VMT     / reAM_VHT
                    if (reMD_VHT_PC>0)  reMD_Spd    = reMD_VMT     / reMD_VHT
                    if (rePM_VHT_PC>0)  rePM_Spd    = rePM_VMT     / rePM_VHT
                    if (reEV_VHT_PC>0)  reEV_Spd    = reEV_VMT     / reEV_VHT
                    if (reDY_VHT_PC>0)  reDY_Spd    = reDY_VMT     / reDY_VHT
                    
                    if (reFF_VHT_LT>0)  reFF_Spd_LT  = reDY_VMT_LT / reFF_VHT_LT
                    if (reAM_VHT_LT>0)  reAM_Spd_LT  = reAM_VMT_LT / reAM_VHT_LT
                    if (reMD_VHT_LT>0)  reMD_Spd_LT  = reMD_VMT_LT / reMD_VHT_LT
                    if (rePM_VHT_LT>0)  rePM_Spd_LT  = rePM_VMT_LT / rePM_VHT_LT
                    if (reEV_VHT_LT>0)  reEV_Spd_LT  = reEV_VMT_LT / reEV_VHT_LT
                    if (reDY_VHT_LT>0)  reDY_Spd_LT  = reDY_VMT_LT / reDY_VHT_LT
                    
                    if (reFF_VHT_MD>0)  reFF_Spd_MD  = reDY_VMT_MD / reFF_VHT_MD
                    if (reAM_VHT_MD>0)  reAM_Spd_MD  = reAM_VMT_MD / reAM_VHT_MD
                    if (reMD_VHT_MD>0)  reMD_Spd_MD  = reMD_VMT_MD / reMD_VHT_MD
                    if (rePM_VHT_MD>0)  rePM_Spd_MD  = rePM_VMT_MD / rePM_VHT_MD
                    if (reEV_VHT_MD>0)  reEV_Spd_MD  = reEV_VMT_MD / reEV_VHT_MD
                    if (reDY_VHT_MD>0)  reDY_Spd_MD  = reDY_VMT_MD / reDY_VHT_MD
                    
                    if (reFF_VHT_HV>0)  reFF_Spd_HV  = reDY_VMT_HV / reFF_VHT_HV
                    if (reAM_VHT_HV>0)  reAM_Spd_HV  = reAM_VMT_HV / reAM_VHT_HV
                    if (reMD_VHT_HV>0)  reMD_Spd_HV  = reMD_VMT_HV / reMD_VHT_HV
                    if (rePM_VHT_HV>0)  rePM_Spd_HV  = rePM_VMT_HV / rePM_VHT_HV
                    if (reEV_VHT_HV>0)  reEV_Spd_HV  = reEV_VMT_HV / reEV_VHT_HV
                    if (reDY_VHT_HV>0)  reDY_Spd_HV  = reDY_VMT_HV / reDY_VHT_HV
                    
                    ;recalculate if shorter than freeflow
                    reAM_Spd     = MIN(reAM_Spd,    reFF_Spd)
                    reMD_Spd     = MIN(reMD_Spd,    reFF_Spd)
                    rePM_Spd     = MIN(rePM_Spd,    reFF_Spd)
                    reEV_Spd     = MIN(reEV_Spd,    reFF_Spd)
                    reDY_Spd     = MIN(reDY_Spd,    reFF_Spd)

                    reAM_Spd_LT  = MIN(reAM_Spd_LT, reFF_Spd_LT)
                    reMD_Spd_LT  = MIN(reMD_Spd_LT, reFF_Spd_LT)
                    rePM_Spd_LT  = MIN(rePM_Spd_LT, reFF_Spd_LT)
                    reEV_Spd_LT  = MIN(reEV_Spd_LT, reFF_Spd_LT)
                    reDY_Spd_LT  = MIN(reDY_Spd_LT, reFF_Spd_LT)
                    
                    reAM_Spd_MD  = MIN(reAM_Spd_MD, reFF_Spd_MD)
                    reMD_Spd_MD  = MIN(reMD_Spd_MD, reFF_Spd_MD)
                    rePM_Spd_MD  = MIN(rePM_Spd_MD, reFF_Spd_MD)
                    reEV_Spd_MD  = MIN(reEV_Spd_MD, reFF_Spd_MD)
                    reDY_Spd_MD  = MIN(reDY_Spd_MD, reFF_Spd_MD)
                    
                    reAM_Spd_HV  = MIN(reAM_Spd_HV, reFF_Spd_HV)
                    reMD_Spd_HV  = MIN(reMD_Spd_HV, reFF_Spd_HV)
                    rePM_Spd_HV  = MIN(rePM_Spd_HV, reFF_Spd_HV)
                    reEV_Spd_HV  = MIN(reEV_Spd_HV, reFF_Spd_HV)
                    reDY_Spd_HV  = MIN(reDY_Spd_HV, reFF_Spd_HV)
                    
                    
                    ;calculate and assign output variables for vhd -- include rounding
                    reAM_VHD     = ROUND((reAM_Tme    - reFF_Tme)    / 60 * reAM_Vol    * 1000) / 1000
                    reMD_VHD     = ROUND((reMD_Tme    - reFF_Tme)    / 60 * reMD_Vol    * 1000) / 1000
                    rePM_VHD     = ROUND((rePM_Tme    - reFF_Tme)    / 60 * rePM_Vol    * 1000) / 1000
                    reEV_VHD     = ROUND((reEV_Tme    - reFF_Tme)    / 60 * reEV_Vol    * 1000) / 1000
                    
                    reAM_VHD_PC  = ROUND((reAM_Tme    - reFF_Tme)    / 60 * reAM_Vol_PC * 1000) / 1000
                    reMD_VHD_PC  = ROUND((reMD_Tme    - reFF_Tme)    / 60 * reMD_Vol_PC * 1000) / 1000
                    rePM_VHD_PC  = ROUND((rePM_Tme    - reFF_Tme)    / 60 * rePM_Vol_PC * 1000) / 1000
                    reEV_VHD_PC  = ROUND((reEV_Tme    - reFF_Tme)    / 60 * reEV_Vol_PC * 1000) / 1000
                    
                    reAM_VHD_LT  = ROUND((reAM_Tme_LT - reFF_Tme_LT) / 60 * reAM_Vol_LT * 1000) / 1000
                    reMD_VHD_LT  = ROUND((reMD_Tme_LT - reFF_Tme_LT) / 60 * reMD_Vol_LT * 1000) / 1000
                    rePM_VHD_LT  = ROUND((rePM_Tme_LT - reFF_Tme_LT) / 60 * rePM_Vol_LT * 1000) / 1000
                    reEV_VHD_LT  = ROUND((reEV_Tme_LT - reFF_Tme_LT) / 60 * reEV_Vol_LT * 1000) / 1000
                    
                    reAM_VHD_MD  = ROUND((reAM_Tme_MD - reFF_Tme_MD) / 60 * reAM_Vol_MD * 1000) / 1000
                    reMD_VHD_MD  = ROUND((reMD_Tme_MD - reFF_Tme_MD) / 60 * reMD_Vol_MD * 1000) / 1000
                    rePM_VHD_MD  = ROUND((rePM_Tme_MD - reFF_Tme_MD) / 60 * rePM_Vol_MD * 1000) / 1000
                    reEV_VHD_MD  = ROUND((reEV_Tme_MD - reFF_Tme_MD) / 60 * reEV_Vol_MD * 1000) / 1000
                    
                    reAM_VHD_HV  = ROUND((reAM_Tme_HV - reFF_Tme_HV) / 60 * reAM_Vol_HV * 1000) / 1000
                    reMD_VHD_HV  = ROUND((reMD_Tme_HV - reFF_Tme_HV) / 60 * reMD_Vol_HV * 1000) / 1000
                    rePM_VHD_HV  = ROUND((rePM_Tme_HV - reFF_Tme_HV) / 60 * rePM_Vol_HV * 1000) / 1000
                    reEV_VHD_HV  = ROUND((reEV_Tme_HV - reFF_Tme_HV) / 60 * reEV_Vol_HV * 1000) / 1000
                    
                    reDY_VHD    = reAM_VHD    + reMD_VHD    + rePM_VHD    + reEV_VHD
                    reDY_VHD_PC = reAM_VHD_PC + reMD_VHD_PC + rePM_VHD_PC + reEV_VHD_PC
                    reDY_VHD_LT = reAM_VHD_LT + reMD_VHD_LT + rePM_VHD_LT + reEV_VHD_LT
                    reDY_VHD_MD = reAM_VHD_MD + reMD_VHD_MD + rePM_VHD_MD + reEV_VHD_MD
                    reDY_VHD_HV = reAM_VHD_HV + reMD_VHD_HV + rePM_VHD_HV + reEV_VHD_HV
                    
                    
                    ;assign output variables for period factors -- include rounding
                    if (reDY_VOL>0)
                        reAM_PRDFAC = round(reAM_VOL / reDY_VOL * 1000) / 1000
                        reMD_PRDFAC = round(reMD_VOL / reDY_VOL * 1000) / 1000
                        reEV_PRDFAC = round(reEV_VOL / reDY_VOL * 1000) / 1000
                    else
                        reAM_PRDFAC = 0
                        reMD_PRDFAC = 0
                        rePM_PRDFAC = 0
                        reEV_PRDFAC = 0
                    endif
                    
                    if (reDY_VOL>0)  rePM_PRDFAC = 1 - reAM_PRDFAC - reMD_PRDFAC - reEV_PRDFAC
                    
                    ;assign output variables for truck percentages
                    reAM_MDPCT = 0
                    reMD_MDPCT = 0
                    rePM_MDPCT = 0
                    reEV_MDPCT = 0
                    reDY_MDPCT = 0
                    
                    reAM_HVPCT = 0
                    reMD_HVPCT = 0
                    rePM_HVPCT = 0
                    reEV_HVPCT = 0
                    reDY_HVPCT = 0
                    
                    if (reAM_Vol>0) reAM_MDPCT = reAM_Vol_MD / reAM_Vol * 100
                    if (reMD_Vol>0) reMD_MDPCT = reMD_Vol_MD / reMD_Vol * 100
                    if (rePM_Vol>0) rePM_MDPCT = rePM_Vol_MD / rePM_Vol * 100
                    if (reEV_Vol>0) reEV_MDPCT = reEV_Vol_MD / reEV_Vol * 100
                    if (reDY_Vol>0) reDY_MDPCT = reDY_Vol_MD / reDY_Vol * 100
                    
                    if (reAM_Vol>0) reAM_HVPCT = reAM_Vol_HV / reAM_Vol * 100
                    if (reMD_Vol>0) reMD_HVPCT = reMD_Vol_HV / reMD_Vol * 100
                    if (rePM_Vol>0) rePM_HVPCT = rePM_Vol_HV / rePM_Vol * 100
                    if (reEV_Vol>0) reEV_HVPCT = reEV_Vol_HV / reEV_Vol * 100
                    if (reDY_Vol>0) reDY_HVPCT = reDY_Vol_HV / reDY_Vol * 100
                    
                    
                    ;calculate variables for direction factors (DFAC)
                    if (Dir_Idx=1)
                        
                        if (AM_Vol[_idx_Seg][1][FunGrp_Idx] + AM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)
                            AM_DFAC[_idx_Seg][1][FunGrp_Idx] = ROUND(AM_Vol[_idx_Seg][1][FunGrp_Idx]  / (AM_Vol[_idx_Seg][1][FunGrp_Idx] + AM_Vol[_idx_Seg][2][FunGrp_Idx]) * 10000) / 10000
                        else
                            AM_DFAC[_idx_Seg][1][FunGrp_Idx] = 0
                        endif
                        
                        if (MD_Vol[_idx_Seg][1][FunGrp_Idx] + MD_Vol[_idx_Seg][2][FunGrp_Idx] > 0)
                            MD_DFAC[_idx_Seg][1][FunGrp_Idx] = ROUND(MD_Vol[_idx_Seg][1][FunGrp_Idx]  / (MD_Vol[_idx_Seg][1][FunGrp_Idx] + MD_Vol[_idx_Seg][2][FunGrp_Idx]) * 10000) / 10000
                        else
                            MD_DFAC[_idx_Seg][1][FunGrp_Idx] = 0
                        endif
                        
                        if (PM_Vol[_idx_Seg][1][FunGrp_Idx] + PM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)
                            PM_DFAC[_idx_Seg][1][FunGrp_Idx] = ROUND(PM_Vol[_idx_Seg][1][FunGrp_Idx]  / (PM_Vol[_idx_Seg][1][FunGrp_Idx] + PM_Vol[_idx_Seg][2][FunGrp_Idx]) * 10000) / 10000
                        else
                            PM_DFAC[_idx_Seg][1][FunGrp_Idx] = 0
                        endif
                        
                        if (EV_Vol[_idx_Seg][1][FunGrp_Idx] + EV_Vol[_idx_Seg][2][FunGrp_Idx] > 0)
                            EV_DFAC[_idx_Seg][1][FunGrp_Idx] = ROUND(EV_Vol[_idx_Seg][1][FunGrp_Idx]  / (EV_Vol[_idx_Seg][1][FunGrp_Idx] + EV_Vol[_idx_Seg][2][FunGrp_Idx]) * 10000) / 10000
                        else
                            EV_DFAC[_idx_Seg][1][FunGrp_Idx] = 0
                        endif
                        
                        if (DY_Vol[_idx_Seg][1][FunGrp_Idx] + DY_Vol[_idx_Seg][2][FunGrp_Idx] > 0)
                            DY_DFAC[_idx_Seg][1][FunGrp_Idx] = ROUND(DY_Vol[_idx_Seg][1][FunGrp_Idx]  / (DY_Vol[_idx_Seg][1][FunGrp_Idx] + DY_Vol[_idx_Seg][2][FunGrp_Idx]) * 10000) / 10000
                        else
                            DY_DFAC[_idx_Seg][1][FunGrp_Idx] = 0
                        endif
                    
                    elseif (Dir_Idx=2)
                        
                        if (AM_Vol[_idx_Seg][1][FunGrp_Idx] + AM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  AM_DFAC[_idx_Seg][2][FunGrp_Idx] = 1 - AM_DFAC[_idx_Seg][1][FunGrp_Idx]
                        if (MD_Vol[_idx_Seg][1][FunGrp_Idx] + MD_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  MD_DFAC[_idx_Seg][2][FunGrp_Idx] = 1 - MD_DFAC[_idx_Seg][1][FunGrp_Idx]
                        if (PM_Vol[_idx_Seg][1][FunGrp_Idx] + PM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  PM_DFAC[_idx_Seg][2][FunGrp_Idx] = 1 - PM_DFAC[_idx_Seg][1][FunGrp_Idx]
                        if (EV_Vol[_idx_Seg][1][FunGrp_Idx] + EV_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  EV_DFAC[_idx_Seg][2][FunGrp_Idx] = 1 - EV_DFAC[_idx_Seg][1][FunGrp_Idx]
                        if (DY_Vol[_idx_Seg][1][FunGrp_Idx] + DY_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  DY_DFAC[_idx_Seg][2][FunGrp_Idx] = 1 - DY_DFAC[_idx_Seg][1][FunGrp_Idx]
                        
                    else
                        
                        if (AM_Vol[_idx_Seg][1][FunGrp_Idx] + AM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  AM_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx] = 1
                        if (MD_Vol[_idx_Seg][1][FunGrp_Idx] + MD_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  MD_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx] = 1
                        if (PM_Vol[_idx_Seg][1][FunGrp_Idx] + PM_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  PM_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx] = 1
                        if (EV_Vol[_idx_Seg][1][FunGrp_Idx] + EV_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  EV_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx] = 1
                        if (DY_Vol[_idx_Seg][1][FunGrp_Idx] + DY_Vol[_idx_Seg][2][FunGrp_Idx] > 0)  DY_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx] = 1
                        
                    endif
                    
                    ;assing output variables for DFAC
                    reAM_DFAC = AM_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reMD_DFAC = MD_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    rePM_DFAC = PM_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reEV_DFAC = EV_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    reDY_DFAC = DY_DFAC[_idx_Seg][Dir_Idx][FunGrp_Idx]
                    
                endif
                
                ;write out data to files ==================================================================================
                
                ;CSV Header for First Segment and First FuncGroup Index
                if (lp_segidx=1 & AddIdx=0.1 & Dir_Idx=1)
                    PRINT PRINTO=1, 
                        CSV=T,
                        LIST='SEGIDIDX'      ,
                             'SEGID'         ,
                             'DISTANCE'      ,
                             'DIRECTION'     ,
                             'DIRECTION_NAME',
                             'FUNCGROUP'     ,
                             'SUBAREAID'     ,
                             'CO_FIPS'       ,
                             'AREATYPE'      ,
                             'ATYPENAME'     ,
                             'LINKS'         ,
                             'LANES'         ,
                             'LANEMILES'     ,
                             'FT'            ,
                             'FTCLASS'       ,
                             'CAP1HL'        ,
                             'FG_Share'         ,
                             'AM_Vol'        , 'MD_Vol'   , 'PM_Vol'   , 'EV_Vol'   , 'DY_Vol'   ,
                             'AM_Vol_PC'     , 'MD_Vol_PC', 'PM_Vol_PC', 'EV_Vol_PC', 'DY_Vol_PC',
                             'AM_Vol_LT'     , 'MD_Vol_LT', 'PM_Vol_LT', 'EV_Vol_LT', 'DY_Vol_LT',
                             'AM_Vol_MD'     , 'MD_Vol_MD', 'PM_Vol_MD', 'EV_Vol_MD', 'DY_Vol_MD',
                             'AM_Vol_HV'     , 'MD_Vol_HV', 'PM_Vol_HV', 'EV_Vol_HV', 'DY_Vol_HV', 'FF_Spd' ,
                             'AM_Spd'        , 'MD_Spd'   , 'PM_Spd'   , 'EV_Spd'   , 'DY_Spd'   , 'FF_Tme' ,
                             'AM_Tme'        , 'MD_Tme'   , 'PM_Tme'   , 'EV_Tme'   , 'DY_Tme'   , 
                             'AM_CAP'        , 'MD_CAP'   , 'PM_CAP'   , 'EV_CAP'   , 'DY_CAP'   , 
                             'AM_VC'         , 'MD_VC'    , 'PM_VC'    , 'EV_VC'    , 'MAX_VC'   , 
                             'AM_VMT'        , 'MD_VMT'   , 'PM_VMT'   , 'EV_VMT'   , 'DY_VMT'   , 
                             'AM_VMT_PC'     , 'MD_VMT_PC', 'PM_VMT_PC', 'EV_VMT_PC', 'DY_VMT_PC', 
                             'AM_VMT_LT'     , 'MD_VMT_LT', 'PM_VMT_LT', 'EV_VMT_LT', 'DY_VMT_LT', 
                             'AM_VMT_MD'     , 'MD_VMT_MD', 'PM_VMT_MD', 'EV_VMT_MD', 'DY_VMT_MD', 
                             'AM_VMT_HV'     , 'MD_VMT_HV', 'PM_VMT_HV', 'EV_VMT_HV', 'DY_VMT_HV', 'FF_VHT' ,
                             'AM_VHT'        , 'MD_VHT'   , 'PM_VHT'   , 'EV_VHT'   , 'DY_VHT'   , 
                             'AM_VHT_PC'     , 'MD_VHT_PC', 'PM_VHT_PC', 'EV_VHT_PC', 'DY_VHT_PC', 
                             'AM_VHT_LT'     , 'MD_VHT_LT', 'PM_VHT_LT', 'EV_VHT_LT', 'DY_VHT_LT', 
                             'AM_VHT_MD'     , 'MD_VHT_MD', 'PM_VHT_MD', 'EV_VHT_MD', 'DY_VHT_MD', 
                             'AM_VHT_HV'     , 'MD_VHT_HV', 'PM_VHT_HV', 'EV_VHT_HV', 'DY_VHT_HV', 
                             'AM_VHD'        , 'MD_VHD'   , 'PM_VHD'   , 'EV_VHD'   , 'DY_VHD'   , 
                             'AM_VHD_PC'     , 'MD_VHD_PC', 'PM_VHD_PC', 'EV_VHD_PC', 'DY_VHD_PC', 
                             'AM_VHD_LT'     , 'MD_VHD_LT', 'PM_VHD_LT', 'EV_VHD_LT', 'DY_VHD_LT', 
                             'AM_VHD_MD'     , 'MD_VHD_MD', 'PM_VHD_MD', 'EV_VHD_MD', 'DY_VHD_MD', 
                             'AM_VHD_HV'     , 'MD_VHD_HV', 'PM_VHD_HV', 'EV_VHD_HV', 'DY_VHD_HV', 
                             'AM_PRDFAC'     , 'MD_PRDFAC', 'PM_PRDFAC', 'EV_PRDFAC',
                             'AM_MDPCT'      , 'MD_MDPCT' , 'PM_MDPCT' , 'EV_MDPCT' , 'DY_MDPCT' , 
                             'AM_HVPCT'      , 'MD_HVPCT' , 'PM_HVPCT' , 'EV_HVPCT' , 'DY_HVPCT' , 
                             'AM_DFAC'       , 'MD_DFAC'  , 'PM_DFAC'  , 'EV_DFAC'  , 'DY_DFAC'
                endif
                
                if (reLINKS > 0) ; only print out rows with data
                    ;output data for each functional group
                    PRINT PRINTO=1, 
                        CSV=T,
                        FORM=10.1,
                        LIST=reSEGIDIDX       ,
                            reSEGID          ,
                            reDISTANCE(10.3) ,
                            reDIRECTION      ,
                            reDIRECTION_NAME ,
                            reFUNCGROUP      ,
                            reSUBAREAID      ,
                            reCO_FIPS        ,
                            reAREATYPE       ,
                            reATYPENAME      ,
                            reLINKS(10.0)    ,
                            reLANES          ,
                            reLANEMILES      ,
                            reFT             ,
                            reFTCLASS        ,
                            reCAP1HL(10.0)   ,
                            reFG_Share(10.4)    ,
                            reAM_Vol(10.1)   , reMD_Vol(10.1)   , rePM_Vol(10.1)   , reEV_Vol(10.1)   , reDY_Vol(10.1)   ,
                            reAM_Vol_PC(10.1), reMD_Vol_PC(10.1), rePM_Vol_PC(10.1), reEV_Vol_PC(10.1), reDY_Vol_PC(10.1),
                            reAM_Vol_LT(10.1), reMD_Vol_LT(10.1), rePM_Vol_LT(10.1), reEV_Vol_LT(10.1), reDY_Vol_LT(10.1),
                            reAM_Vol_MD(10.1), reMD_Vol_MD(10.1), rePM_Vol_MD(10.1), reEV_Vol_MD(10.1), reDY_Vol_MD(10.1),
                            reAM_Vol_HV(10.1), reMD_Vol_HV(10.1), rePM_Vol_HV(10.1), reEV_Vol_HV(10.1), reDY_Vol_HV(10.1), reFF_Spd(10.1),
                            reAM_Spd(10.1)   , reMD_Spd(10.1)   , rePM_Spd(10.1)   , reEV_Spd(10.1)   , reDY_Spd(10.1)   , reFF_Tme(10.3),
                            reAM_Tme(10.3)   , reMD_Tme(10.3)   , rePM_Tme(10.3)   , reEV_Tme(10.3)   , reDY_Tme(10.3)   ,
                            reAM_CAP(10.0)   , reMD_CAP(10.0)   , rePM_CAP(10.0)   , reEV_CAP(10.0)   , reDY_CAP(10.0)   ,
                            reAM_VC(10.2)    , reMD_VC(10.2)    , rePM_VC(10.2)    , reEV_VC(10.2)    , reMAX_VC(10.2)   ,
                            reAM_VMT(10.1)   , reMD_VMT(10.1)   , rePM_VMT(10.1)   , reEV_VMT(10.1)   , reDY_VMT(10.1)   ,
                            reAM_VMT_PC(10.1), reMD_VMT_PC(10.1), rePM_VMT_PC(10.1), reEV_VMT_PC(10.1), reDY_VMT_PC(10.1),
                            reAM_VMT_LT(10.1), reMD_VMT_LT(10.1), rePM_VMT_LT(10.1), reEV_VMT_LT(10.1), reDY_VMT_LT(10.1),
                            reAM_VMT_MD(10.1), reMD_VMT_MD(10.1), rePM_VMT_MD(10.1), reEV_VMT_MD(10.1), reDY_VMT_MD(10.1),
                            reAM_VMT_HV(10.1), reMD_VMT_HV(10.1), rePM_VMT_HV(10.1), reEV_VMT_HV(10.1), reDY_VMT_HV(10.1), reFF_VHT(10.2),
                            reAM_VHT(10.2)   , reMD_VHT(10.2)   , rePM_VHT(10.2)   , reEV_VHT(10.2)   , reDY_VHT(10.2)   ,
                            reAM_VHT_PC(10.2), reMD_VHT_PC(10.2), rePM_VHT_PC(10.2), reEV_VHT_PC(10.2), reDY_VHT_PC(10.2),
                            reAM_VHT_LT(10.2), reMD_VHT_LT(10.2), rePM_VHT_LT(10.2), reEV_VHT_LT(10.2), reDY_VHT_LT(10.2),
                            reAM_VHT_MD(10.2), reMD_VHT_MD(10.2), rePM_VHT_MD(10.2), reEV_VHT_MD(10.2), reDY_VHT_MD(10.2),
                            reAM_VHT_HV(10.2), reMD_VHT_HV(10.2), rePM_VHT_HV(10.2), reEV_VHT_HV(10.2), reDY_VHT_HV(10.2),
                            reAM_VHD(10.3)   , reMD_VHD(10.3)   , rePM_VHD(10.3)   , reEV_VHD(10.3)   , reDY_VHD(10.3)   ,
                            reAM_VHD_PC(10.3), reMD_VHD_PC(10.3), rePM_VHD_PC(10.3), reEV_VHD_PC(10.3), reDY_VHD_PC(10.3),
                            reAM_VHD_LT(10.3), reMD_VHD_LT(10.3), rePM_VHD_LT(10.3), reEV_VHD_LT(10.3), reDY_VHD_LT(10.3),
                            reAM_VHD_MD(10.3), reMD_VHD_MD(10.3), rePM_VHD_MD(10.3), reEV_VHD_MD(10.3), reDY_VHD_MD(10.3),
                            reAM_VHD_HV(10.3), reMD_VHD_HV(10.3), rePM_VHD_HV(10.3), reEV_VHD_HV(10.3), reDY_VHD_HV(10.3),
                            reAM_PRDFAC(10.3), reMD_PRDFAC(10.3), rePM_PRDFAC(10.3), reEV_PRDFAC(10.3),
                            reAM_MDPCT       , reMD_MDPCT       , rePM_MDPCT       , reEV_MDPCT       , reDY_MDPCT       ,
                            reAM_HVPCT       , reMD_HVPCT       , rePM_HVPCT       , reEV_HVPCT       , reDY_HVPCT       ,
                            reAM_DFAC(10.4)  , reMD_DFAC(10.4)  , rePM_DFAC(10.4)  , reEV_DFAC(10.4)  , reDY_DFAC(10.4)
                endif
                         
                ;CSV Header for Simplified 
                if (lp_segidx=1 & AddIdx=0 & Dir_Idx=5)
                    PRINT PRINTO=2, 
                        CSV=T,
                        LIST='SEGIDIDX'      ,
                             'SEGID'         ,
                             'DISTANCE'      ,
                             'DIRECTION'     ,
                             'DIRECTION_NAME',
                             'FUNCGROUP'     ,
                             'SUBAREAID'     ,
                             'CO_FIPS'       ,
                             'AREATYPE'      ,
                             'ATYPENAME'     ,
                             'LINKS'         ,
                             'LANES'         ,
                             'LANEMILES'     ,
                             'FT'            ,
                             'FTCLASS'       ,
                             'CAP1HL'        ,
                             'FG_Share'         ,
                             'AM_Vol'        , 'MD_Vol'   , 'PM_Vol'   , 'EV_Vol'   , 'DY_Vol'   ,
                             'AM_Vol_PC'     , 'MD_Vol_PC', 'PM_Vol_PC', 'EV_Vol_PC', 'DY_Vol_PC',
                             'AM_Vol_LT'     , 'MD_Vol_LT', 'PM_Vol_LT', 'EV_Vol_LT', 'DY_Vol_LT',
                             'AM_Vol_MD'     , 'MD_Vol_MD', 'PM_Vol_MD', 'EV_Vol_MD', 'DY_Vol_MD',
                             'AM_Vol_HV'     , 'MD_Vol_HV', 'PM_Vol_HV', 'EV_Vol_HV', 'DY_Vol_HV', 'FF_Spd' ,
                             'AM_Spd'        , 'MD_Spd'   , 'PM_Spd'   , 'EV_Spd'   , 'DY_Spd'   , 'FF_Tme' ,
                             'AM_Tme'        , 'MD_Tme'   , 'PM_Tme'   , 'EV_Tme'   , 'DY_Tme'   , 
                             'AM_CAP'        , 'MD_CAP'   , 'PM_CAP'   , 'EV_CAP'   , 'DY_CAP'   , 
                             'AM_VC'         , 'MD_VC'    , 'PM_VC'    , 'EV_VC'    , 'MAX_VC'   , 
                             'AM_VMT'        , 'MD_VMT'   , 'PM_VMT'   , 'EV_VMT'   , 'DY_VMT'   , 
                             'AM_VMT_PC'     , 'MD_VMT_PC', 'PM_VMT_PC', 'EV_VMT_PC', 'DY_VMT_PC', 
                             'AM_VMT_LT'     , 'MD_VMT_LT', 'PM_VMT_LT', 'EV_VMT_LT', 'DY_VMT_LT', 
                             'AM_VMT_MD'     , 'MD_VMT_MD', 'PM_VMT_MD', 'EV_VMT_MD', 'DY_VMT_MD', 
                             'AM_VMT_HV'     , 'MD_VMT_HV', 'PM_VMT_HV', 'EV_VMT_HV', 'DY_VMT_HV', 'FF_VHT' ,
                             'AM_VHT'        , 'MD_VHT'   , 'PM_VHT'   , 'EV_VHT'   , 'DY_VHT'   , 
                             'AM_VHT_PC'     , 'MD_VHT_PC', 'PM_VHT_PC', 'EV_VHT_PC', 'DY_VHT_PC', 
                             'AM_VHT_LT'     , 'MD_VHT_LT', 'PM_VHT_LT', 'EV_VHT_LT', 'DY_VHT_LT', 
                             'AM_VHT_MD'     , 'MD_VHT_MD', 'PM_VHT_MD', 'EV_VHT_MD', 'DY_VHT_MD', 
                             'AM_VHT_HV'     , 'MD_VHT_HV', 'PM_VHT_HV', 'EV_VHT_HV', 'DY_VHT_HV', 
                             'AM_VHD'        , 'MD_VHD'   , 'PM_VHD'   , 'EV_VHD'   , 'DY_VHD'   , 
                             'AM_VHD_PC'     , 'MD_VHD_PC', 'PM_VHD_PC', 'EV_VHD_PC', 'DY_VHD_PC', 
                             'AM_VHD_LT'     , 'MD_VHD_LT', 'PM_VHD_LT', 'EV_VHD_LT', 'DY_VHD_LT', 
                             'AM_VHD_MD'     , 'MD_VHD_MD', 'PM_VHD_MD', 'EV_VHD_MD', 'DY_VHD_MD', 
                             'AM_VHD_HV'     , 'MD_VHD_HV', 'PM_VHD_HV', 'EV_VHD_HV', 'DY_VHD_HV', 
                             'AM_PRDFAC'     , 'MD_PRDFAC', 'PM_PRDFAC', 'EV_PRDFAC',
                             'AM_MDPCT'      , 'MD_MDPCT' , 'PM_MDPCT' , 'EV_MDPCT' , 'DY_MDPCT' , 
                             'AM_HVPCT'      , 'MD_HVPCT' , 'PM_HVPCT' , 'EV_HVPCT' , 'DY_HVPCT' 
                endif
                
                if (reLINKS > 0) ; only print out rows with data
                    ;output data for each total group
                    if (AddIdx=0 & Dir_Idx=5)
                        PRINT PRINTO=2, 
                            CSV=T,
                            FORM=10.1,
                            LIST=reSEGIDIDX       ,
                                reSEGID          ,
                                reDISTANCE(10.3) ,
                                reDIRECTION      ,
                                reDIRECTION_NAME ,
                                reFUNCGROUP      ,
                                reSUBAREAID      ,
                                reCO_FIPS        ,
                                reAREATYPE       ,
                                reATYPENAME      ,
                                reLINKS(10.0)    ,
                                reLANES          ,
                                reLANEMILES      ,
                                reFT             ,
                                reFTCLASS        ,
                                reCAP1HL(10.0)   ,
                                reFG_Share(10.4)    ,
                                reAM_Vol(10.1)   , reMD_Vol(10.1)   , rePM_Vol(10.1)   , reEV_Vol(10.1)   , reDY_Vol(10.1)   ,
                                reAM_Vol_PC(10.1), reMD_Vol_PC(10.1), rePM_Vol_PC(10.1), reEV_Vol_PC(10.1), reDY_Vol_PC(10.1),
                                reAM_Vol_LT(10.1), reMD_Vol_LT(10.1), rePM_Vol_LT(10.1), reEV_Vol_LT(10.1), reDY_Vol_LT(10.1),
                                reAM_Vol_MD(10.1), reMD_Vol_MD(10.1), rePM_Vol_MD(10.1), reEV_Vol_MD(10.1), reDY_Vol_MD(10.1),
                                reAM_Vol_HV(10.1), reMD_Vol_HV(10.1), rePM_Vol_HV(10.1), reEV_Vol_HV(10.1), reDY_Vol_HV(10.1), reFF_Spd(10.1),
                                reAM_Spd(10.1)   , reMD_Spd(10.1)   , rePM_Spd(10.1)   , reEV_Spd(10.1)   , reDY_Spd(10.1)   , reFF_Tme(10.3),
                                reAM_Tme(10.3)   , reMD_Tme(10.3)   , rePM_Tme(10.3)   , reEV_Tme(10.3)   , reDY_Tme(10.3)   ,
                                reAM_CAP(10.0)   , reMD_CAP(10.0)   , rePM_CAP(10.0)   , reEV_CAP(10.0)   , reDY_CAP(10.0)   ,
                                reAM_VC(10.2)    , reMD_VC(10.2)    , rePM_VC(10.2)    , reEV_VC(10.2)    , reMAX_VC(10.2)   ,
                                reAM_VMT(10.1)   , reMD_VMT(10.1)   , rePM_VMT(10.1)   , reEV_VMT(10.1)   , reDY_VMT(10.1)   ,
                                reAM_VMT_PC(10.1), reMD_VMT_PC(10.1), rePM_VMT_PC(10.1), reEV_VMT_PC(10.1), reDY_VMT_PC(10.1),
                                reAM_VMT_LT(10.1), reMD_VMT_LT(10.1), rePM_VMT_LT(10.1), reEV_VMT_LT(10.1), reDY_VMT_LT(10.1),
                                reAM_VMT_MD(10.1), reMD_VMT_MD(10.1), rePM_VMT_MD(10.1), reEV_VMT_MD(10.1), reDY_VMT_MD(10.1),
                                reAM_VMT_HV(10.1), reMD_VMT_HV(10.1), rePM_VMT_HV(10.1), reEV_VMT_HV(10.1), reDY_VMT_HV(10.1), reFF_VHT(10.2),
                                reAM_VHT(10.2)   , reMD_VHT(10.2)   , rePM_VHT(10.2)   , reEV_VHT(10.2)   , reDY_VHT(10.2)   ,
                                reAM_VHT_PC(10.2), reMD_VHT_PC(10.2), rePM_VHT_PC(10.2), reEV_VHT_PC(10.2), reDY_VHT_PC(10.2),
                                reAM_VHT_LT(10.2), reMD_VHT_LT(10.2), rePM_VHT_LT(10.2), reEV_VHT_LT(10.2), reDY_VHT_LT(10.2),
                                reAM_VHT_MD(10.2), reMD_VHT_MD(10.2), rePM_VHT_MD(10.2), reEV_VHT_MD(10.2), reDY_VHT_MD(10.2),
                                reAM_VHT_HV(10.2), reMD_VHT_HV(10.2), rePM_VHT_HV(10.2), reEV_VHT_HV(10.2), reDY_VHT_HV(10.2),
                                reAM_VHD(10.3)   , reMD_VHD(10.3)   , rePM_VHD(10.3)   , reEV_VHD(10.3)   , reDY_VHD(10.3)   ,
                                reAM_VHD_PC(10.3), reMD_VHD_PC(10.3), rePM_VHD_PC(10.3), reEV_VHD_PC(10.3), reDY_VHD_PC(10.3),
                                reAM_VHD_LT(10.3), reMD_VHD_LT(10.3), rePM_VHD_LT(10.3), reEV_VHD_LT(10.3), reDY_VHD_LT(10.3),
                                reAM_VHD_MD(10.3), reMD_VHD_MD(10.3), rePM_VHD_MD(10.3), reEV_VHD_MD(10.3), reDY_VHD_MD(10.3),
                                reAM_VHD_HV(10.3), reMD_VHD_HV(10.3), rePM_VHD_HV(10.3), reEV_VHD_HV(10.3), reDY_VHD_HV(10.3),
                                reAM_PRDFAC(10.3), reMD_PRDFAC(10.3), rePM_PRDFAC(10.3), reEV_PRDFAC(10.3),
                                reAM_MDPCT       , reMD_MDPCT       , rePM_MDPCT       , reEV_MDPCT       , reDY_MDPCT       ,
                                reAM_HVPCT       , reMD_HVPCT       , rePM_HVPCT       , reEV_HVPCT       , reDY_HVPCT       
                    endif
                endif
            
            ENDLOOP   ;FunGrp_Idx=0,5
            
        ENDLOOP  ;Dir_Idx=0,5
        
        
    ENDLOOP  ;lp_segidx=1, dbi.2.NUMRECORDS
    
    
    ;clear status in task monitor window
    PRINT PRINTO=0 LIST=' '

ENDRUN




if (Run_vizTool=1)

RUN PGM=MATRIX MSG='0: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "roadwaysegments"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Summary_SEGID_Detailed.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json for roadway segment data
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


;DOS command to delete '__pycache__' folder
;  note: '/s' removes folder & contents of folder includling any subfolders
;  note: '/q' denotes quite mode, meaning doesn't ask for confirmation to delete
*(rmdir /s /q "_Log\__pycache__")
*(rmdir /s /q "@ParentDir@2_ModelScripts\_Python\py-vizTool\__pycache__")


RUN PGM=MATRIX MSG='1: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "roadwaytrends"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Summary_SEGID_Detailed.csv"',
             '\n',
             '\n'

ENDRUN

**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


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



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
       LIST='\n    Summarize to Segments              ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN
