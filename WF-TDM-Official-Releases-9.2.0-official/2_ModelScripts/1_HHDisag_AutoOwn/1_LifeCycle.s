
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 1_LifeCycle.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX MSG='HH Disaggregation: Households by Life Cycle'
FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'

FILEI ZDATI[2] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@', 
    Z=TAZID

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\2_SEData\_ControlTotals\ControlTotal_SE_AllCounties.csv'
FILEI LOOKUPI[2] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\@Lookup_BYAgePct@'

FILEO RECO[1] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\LifeCycle_Households_Population.dbf',
    FORM=10.1,
    FIELDS=Z(10.0),
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           TOTHH, 
           SUM_HH,
           HH_LC1, 
           HH_LC2, 
           HH_LC3, 
           HHPOP, 
           SUM_POP,
           POP_LC1, 
           POP_LC2, 
           POP_LC3, 
           HHSIZE(10.2), 
           HHSIZE_LC1(10.2), 
           HHSIZE_LC2(10.2), 
           HHSIZE_LC3(10.2), 
           SUM_AGEGRP, 
           POP_AG1, 
           POP_AG2, 
           POP_AG3, 
           SUM_PCTHLC(10.4),
           PCT_HHLC1(10.4),
           PCT_HHLC2(10.4),
           PCT_HHLC3(10.4),
           SUM_PCTPLC(10.4),
           PCT_POPLC1(10.4),
           PCT_POPLC2(10.4),
           PCT_POPLC3(10.4),
           SUM_PCTAG(10.4),
           PCT_AG1(10.4),
           PCT_AG2(10.4),
           PCT_AG3(10.4)

    
    ;set parameters
    ZONES   = @UsedZones@
    
    
    ;define lookup function
    
    ;SE control totals
    ;  note: SE Control Total input file fields
    ;      01 Index
    ;      02 CO_FIPS
    ;      03 YEAR
    ;      04 TOTPOP
    ;      05 GQ_Pop
    ;      06 HH_Pop
    ;      07 HH
    ;      08 HH_Size
    ;      09 POP_00_17
    ;      10 POP_18_64
    ;      11 POP_65P
    ;      12 ALLEMP
    ;      13 RETL
    ;      14 FOOD
    ;      15 MANU
    ;      16 WSLE
    ;      17 OFFI
    ;      18 GVED
    ;      19 HLTH
    ;      20 OTHR
    ;      21 AGRI
    ;      22 MING
    ;      23 CONS
    ;      24 HBJ
    ;      25 Job_HH
    ;      26 WrkPop_Job
    ;      27 CO_NAME
    ;      28 Urban_Rural
    ;      29 Subarea
    LOOKUP LOOKUPI=1,
        INTERPOLATE=F,
        NAME=PopByAgeConTot,
        Lookup[01]=01, RESULT=09,    ;POP_00_17
        Lookup[02]=01, RESULT=10,    ;POP_18_64
        Lookup[03]=01, RESULT=11     ;POP_65P
    
    
    LOOKUP LOOKUPI=2,
        INTERPOLATE=F,
        NAME=PopByAge_TAZ,
        Lookup[01]=01, RESULT=03,
        Lookup[02]=01, RESULT=04,
        Lookup[03]=01, RESULT=05
    
    
    ;define arrays
    ARRAY Pop_0to17  = @UsedZones@,
          Pop_18to64 = @UsedZones@,
          Pop_65P    = @UsedZones@,
          
          CT_Pop_0to17     = 99,
          CT_Pop_18to64    = 99,
          CT_Pop_65P       = 99,
          SumCo_Pop_0to17  = 99,
          SumCo_Pop_18to64 = 99,
          SumCo_Pop_65P    = 99,
          Fac_Pop_0to17    = 99,
          Fac_Pop_18to64   = 99,
          Fac_Pop_65P      = 99
    
    
    
    ;calculate unadjusted population by class & set county control totals ----------------------------------------------
    
    ;set control total variables
    if (i=1)
        LOOP Co_index=1, 57, 2
            lu_index = Co_index * 10000 + @DemographicYear@
            
            ;note: Weber Co control total uses the following CO_FIPS convention:
            ;      57 = all county   (CO_FIPS)
            ;    9057 = WFRC portion (90 prefix + CO_FIPS - 9=sub-county total, 0=UDOT SubareaID)
            ;    9157 = WFRC portion (91 prefix + CO_FIPS - 9=sub-county total, 1=UDOT SubareaID)
            if (Co_index=57)  lu_index = 9157 * 10000 + @DemographicYear@
            
            CT_Pop_0to17[Co_index]  = PopByAgeConTot(1, lu_index)
            CT_Pop_18to64[Co_index] = PopByAgeConTot(2, lu_index)
            CT_Pop_65P[Co_index]    = PopByAgeConTot(3, lu_index)
            
            ;print data to PRN file for checking
            ;PRINT LIST='Co_index=', Co_index(6.0), 
            ;           '          CT_0TO17=' ,  CT_Pop_0to17[Co_index](10.0C), 
            ;           '          CT_18TO64=', CT_Pop_18to64[Co_index](10.0C), 
            ;           '          CT_65P='   ,    CT_Pop_65P[Co_index](10.0C)
        ENDLOOP
        PRINT LIST='\n\n'
    endif
    
    
    ;identify CO_TAZID and lookup base year age % for TAZ
    CO_TAZID = zi.2.CO_TAZID[i]
    
    if (CO_TAZID>0)
        PCT_0TO17  = PopByAge_TAZ(1,CO_TAZID)
        PCT_18TO64 = PopByAge_TAZ(2,CO_TAZID)
        PCT_65P    = PopByAge_TAZ(3,CO_TAZID)
    else
        PCT_0TO17  = 0
        PCT_18TO64 = 0
        PCT_65P    = 0
    endif
    
    
    ;calculate unadjusted age group population
    Pop_0to17[i]  = zi.1.HHPOP[i] * PCT_0TO17 
    Pop_18to64[i] = zi.1.HHPOP[i] * PCT_18TO64
    Pop_65P[i]    = zi.1.HHPOP[i] * PCT_65P   
    
    ;print data to PRN file for checking
    ;if (i=2850-2881)
    ;    PRINT LIST='I=', I(6.0), '           HHPOP', zi.1.HHPOP[i](10.0C),
    ;               '          0TO17=' ,  Pop_0to17[i](10.1C),  PCT_0TO17(10.3) , 
    ;               '          18TO64=', Pop_18to64[i](10.1C), PCT_18TO64(10.3), 
    ;               '          65P='   ,    Pop_65P[i](10.1C),    PCT_65P(10.3)
    ;endif
    
    
    ;sum unadjusted age group population by county
    Co_index = zi.2.CO_FIPS[i]
    
    if (Co_index>=1 & Co_index<=57)
        SumCo_Pop_0to17[Co_index]  = SumCo_Pop_0to17[Co_index]  + Pop_0to17[i] 
        SumCo_Pop_18to64[Co_index] = SumCo_Pop_18to64[Co_index] + Pop_18to64[i]
        SumCo_Pop_65P[Co_index]    = SumCo_Pop_65P[Co_index]    + Pop_65P[i]
    
    else  ;assign error to index 59
        SumCo_Pop_0to17[59]  = SumCo_Pop_0to17[59]  + Pop_0to17[i] 
        SumCo_Pop_18to64[59] = SumCo_Pop_18to64[59] + Pop_18to64[i]
        SumCo_Pop_65P[59]    = SumCo_Pop_65P[59]    + Pop_65P[i]
    endif
    
    ;if (i=ZONES)
    ;    PRINT LIST='\n\n'
    ;    LOOP Co_index=1, 59, 2
    ;        ;print data to PRN file for checking
    ;        PRINT LIST='Co_index=', Co_index(6.0), 
    ;                   '          SumUnAdj_0TO17=' ,  SumCo_Pop_0to17[Co_index](10.0C), 
    ;                   '          SumUnAdj_18TO64=', SumCo_Pop_18to64[Co_index](10.0C), 
    ;                   '          SumUnAdj_65P='   ,    SumCo_Pop_65P[Co_index](10.0C)
    ;    ENDLOOP
    ;endif
    
    
    
    ;calculate adjustment factors and adjusted age group population & households ----------------------------------------
    if (i=@UsedZones@)
        
        PRINT LIST='\n\n'
        
        ;calculate adjustement factors by county
        LOOP Co_index=1, 57, 2
            if (SumCo_Pop_0to17[Co_index]=0)
                Fac_Pop_0to17[Co_index] = 1
            else
                Fac_Pop_0to17[Co_index] = CT_Pop_0to17[Co_index] / SumCo_Pop_0to17[Co_index]
            endif
            
            if (SumCo_Pop_18to64[Co_index]=0)
                Fac_Pop_18to64[Co_index] = 1
            else
                Fac_Pop_18to64[Co_index] = CT_Pop_18to64[Co_index] / SumCo_Pop_18to64[Co_index]
            endif
            
            if (SumCo_Pop_65P[Co_index]=0)
                Fac_Pop_65P[Co_index] = 1
            else
                Fac_Pop_65P[Co_index] = CT_Pop_65P[Co_index] / SumCo_Pop_65P[Co_index]
            endif
            
            ;print data to PRN file for checking
            ;PRINT LIST='Co_index=', Co_index(6.0), 
            ;           '          Fac_0TO17=' ,  Fac_Pop_0to17[Co_index](10.3C), 
            ;           '          Fac_18TO64=', Fac_Pop_18to64[Co_index](10.3C), 
            ;           '          Fac_65P='   ,    Fac_Pop_65P[Co_index](10.3C)
        ENDLOOP
        
        
        ;calculate adjusted age group population, life cycle population, life cycle HH and life cycle HH size
        LOOP iter=1, @UsedZones@
            
            ;calculate adjusted-controlled population and recalculate age group % shares
            Co_index = zi.2.CO_FIPS[iter]
            
            Adj_Pop_0to17  =  Pop_0to17[iter] *  Fac_Pop_0to17[Co_index] 
            Adj_Pop_18to64 = Pop_18to64[iter] * Fac_Pop_18to64[Co_index]
            Adj_Pop_65P    =    Pop_65P[iter] *    Fac_Pop_65P[Co_index]   
            
            Adj_Pop_Sum = Adj_Pop_0to17  + 
                          Adj_Pop_18to64 +
                          Adj_Pop_65P
            
            if (Adj_Pop_Sum>0)
                Pct_Pop_0to17  = round(Adj_Pop_0to17/Adj_Pop_Sum*100)/100
                Pct_Pop_65P    = round(Adj_Pop_65P/Adj_Pop_Sum*100)/100
            else
                Pct_Pop_0to17  = 0
                Pct_Pop_65P    = 0
            endif
            
            Pct_Pop_18to64 = 1 - Pct_Pop_0to17 - Pct_Pop_65P
            
            
            ;calculate age group population
            AGPop_0to17  = zi.1.HHPOP[iter] * Pct_Pop_0to17 
            AGPop_18to64 = zi.1.HHPOP[iter] * Pct_Pop_18to64
            AGPop_65P    = zi.1.HHPOP[iter] * Pct_Pop_65P   
            
            
            ;set factors to convert population & households to life cycles
            if (zi.2.CO_FIPS[iter]=57)
                Fac_LC2Pop_0to17  = @WE_LC2_0to17@ 
                Fac_LC2Pop_18to64 = @WE_LC2_18to64@
                
                Fac_LC1_HHSize    = @WE_HHSize_LC1@
                Fac_LC2_HHSize    = @WE_HHSize_LC2@
                Fac_LC3_HHSize    = @WE_HHSize_LC3@
            
            elseif (zi.2.CO_FIPS[iter]=11)
                Fac_LC2Pop_0to17  = @DA_LC2_0to17@ 
                Fac_LC2Pop_18to64 = @DA_LC2_18to64@
                
                Fac_LC1_HHSize    = @DA_HHSize_LC1@
                Fac_LC2_HHSize    = @DA_HHSize_LC2@
                Fac_LC3_HHSize    = @DA_HHSize_LC3@
            
            elseif (zi.2.CO_FIPS[iter]=35)
                Fac_LC2Pop_0to17  = @SL_LC2_0to17@ 
                Fac_LC2Pop_18to64 = @SL_LC2_18to64@
                
                Fac_LC1_HHSize    = @SL_HHSize_LC1@
                Fac_LC2_HHSize    = @SL_HHSize_LC2@
                Fac_LC3_HHSize    = @SL_HHSize_LC3@
            
            elseif (zi.2.CO_FIPS[iter]=49)
                Fac_LC2Pop_0to17  = @UT_LC2_0to17@ 
                Fac_LC2Pop_18to64 = @UT_LC2_18to64@
                
                Fac_LC1_HHSize    = @UT_HHSize_LC1@
                Fac_LC2_HHSize    = @UT_HHSize_LC2@
                Fac_LC3_HHSize    = @UT_HHSize_LC3@
            
            else
                Fac_LC2Pop_0to17  = @BE_LC2_0to17@ 
                Fac_LC2Pop_18to64 = @BE_LC2_18to64@
                
                Fac_LC1_HHSize    = @BE_HHSize_LC1@
                Fac_LC2_HHSize    = @BE_HHSize_LC2@
                Fac_LC3_HHSize    = @BE_HHSize_LC3@
            
            endif
                
            Fac_LC1_18to64 = 1 - Fac_LC2Pop_18to64           ;Adults 18 to 64 are either in LC1 or LC2
            Fac_LC3_0to17  = 1 - Fac_LC2Pop_0to17            ;adults 65p are either in LC2 or LC3
            
            ;print data to PRN file for checking
            ;if (iter=1)
            ;    PRINT FILE='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\test.csv',
            ;        CSV=T,
            ;        LIST='TAZID', 'CO_FIPS', 'SUBAREAID', 'Fac_LC2Pop_0to17, Fac_LC2Pop_18to64', 'Fac_LC1_HHSize', 'Fac_LC2_HHSize', 'Fac_LC3_HHSize'
            ;endif
            ;
            ;PRINT FILE='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\test.csv',
            ;    CSV=T,
            ;    LIST=iter(6.0), zi.2.CO_FIPS[iter](6.0), zi.2.SUBAREAID[iter](6.0), Fac_LC2Pop_0to17, Fac_LC2Pop_18to64, Fac_LC1_HHSize, Fac_LC2_HHSize, Fac_LC3_HHSize
            
            
            ;calculate population in each life cycle
            Pop_LC1 = AGPop_0to17  * 0                 +     ;life cylce 1 has no children and no seniors
                      AGPop_18to64 * Fac_LC1_18to64    + 
                      AGPop_65P    * 0
            
            Pop_LC2 = AGPop_0to17  * Fac_LC2Pop_0to17  +     ;life cylce 2 has no seniors
                      AGPop_18to64 * Fac_LC2Pop_18to64 + 
                      AGPop_65P    * 0
            
            Pop_LC3 = AGPop_0to17  * Fac_LC3_0to17     +     ;100% of seniors & no adults <65 years old are in life cycle 3
                      AGPop_18to64 * 0                 + 
                      AGPop_65P    * 1
            
            Pop_Sum = Pop_LC1 + Pop_LC2 + Pop_LC3
            
            
            ;calculate % of population in each life cycle
            if (Pop_Sum>0)
                LC1_PopShare = round(Pop_LC1/Pop_Sum*100)/100
                LC3_PopShare = round(Pop_LC3/Pop_Sum*100)/100
            else
                LC1_PopShare = 0
                LC3_PopShare = 0
            endif
            
            LC2_PopShare = 1 - LC1_PopShare - LC3_PopShare
            
            
            ;multiply zonal population by % of population in each life cycle to get actual population in each life cycle
            Pop_LC1 = zi.1.HHPOP[iter] * LC1_PopShare
            Pop_LC2 = zi.1.HHPOP[iter] * LC2_PopShare
            Pop_LC3 = zi.1.HHPOP[iter] * LC3_PopShare
            
            LC_Pop_Sum = Pop_LC1 + 
                         Pop_LC2 + 
                         Pop_LC3
            
            
            ;calculate estimate of HHs in life cycle
            UnAdj_HH_LC1 = Pop_LC1 / Fac_LC1_HHSize
            UnAdj_HH_LC2 = Pop_LC2 / Fac_LC2_HHSize
            UnAdj_HH_LC3 = Pop_LC3 / Fac_LC3_HHSize
            
            UnAdj_HH_Sum = UnAdj_HH_LC1 +
                           UnAdj_HH_LC2 +
                           UnAdj_HH_LC3
            
            
            ;calcualte % of households in each life cycle
            if (UnAdj_HH_Sum>0)
                LC1_HHShare = round(UnAdj_HH_LC1/UnAdj_HH_Sum*100)/100
                LC3_HHShare = round(UnAdj_HH_LC3/UnAdj_HH_Sum*100)/100
            else
                LC1_HHShare = 0
                LC3_HHShare = 0
            endif
            
            LC2_HHShare = 1 - LC1_HHShare - LC3_HHShare
            
            
            ;multiply zonal households by % of households in each life cycle to get actual households in each life cycle
            HH_LC1 = zi.1.TOTHH[iter] * LC1_HHShare
            HH_LC2 = zi.1.TOTHH[iter] * LC2_HHShare
            HH_LC3 = zi.1.TOTHH[iter] * LC3_HHShare
            
            LC_HH_Sum = HH_LC1 +
                        HH_LC3 +
                        HH_LC2
            
            
            if (HH_LC1>0)
                HHSize_LC1 = Pop_LC1 / HH_LC1
            else
                HHSize_LC1 = 0
            endif
            
            if (HH_LC2>0)
                HHSize_LC2 = Pop_LC2 / HH_LC2
            else
                HHSize_LC2 = 0
            endif
            
            if (HH_LC3>0)
                HHSize_LC3 = Pop_LC3 / HH_LC3
            else
                HHSize_LC3 = 0
            endif
            
            
            ;correct for low or high HH Size
            if (LC_Pop_Sum>0)
                if (HHSize_LC1<1.0)
                    HHSize_LC1 = 1.0
                    Pop_LC1    = 1.0
                    HH_LC1     = 1.0
                endif
                
                if (HHSize_LC2<2.0)
                    HHSize_LC2 = 2.0
                    Pop_LC2    = 2
                    HH_LC2     = 1
                endif
                
                if (HHSize_LC3<1.0)
                    HHSize_LC3 = 1.0
                    Pop_LC3    = 1.0
                    HH_LC3     = 1.0
                endif
                
                if (HHSize_LC1>4.0)
                    HHSize_LC1 = 4.0
                    HH_LC1     = Pop_LC1 / 4.0
                endif
                
                if (HHSize_LC2>8.0)
                    HHSize_LC2 = 8.0
                    HH_LC2     = Pop_LC2 / 8.0
                endif
                
                if (HHSize_LC3>4.0)
                    HHSize_LC3 = 4.0
                    HH_LC3     = Pop_LC3 / 4.0
                endif
                
                
                ;sum total HH after adjustement & calculate HH Size
                LC_Pop_Sum = Pop_LC1 + 
                             Pop_LC2 + 
                             Pop_LC3
                
                LC_HH_Sum  = HH_LC1 + 
                             HH_LC2 + 
                             HH_LC3
                
                if (LC_HH_Sum>0)
                    LC_HHSize_Sum  = LC_Pop_Sum / LC_HH_Sum
                else
                    LC_HHSize_Sum  = 0
                endif
            
            endif  ;Pop_Sum>0
            
            
            ;write data to output file
            RO.Z           = iter
            
            RO.TOTHH      = zi.1.TOTHH[iter]
            RO.SUM_HH     = LC_HH_Sum
            RO.HH_LC1     = HH_LC1 
            RO.HH_LC2     = HH_LC2 
            RO.HH_LC3     = HH_LC3 
            
            RO.HHPOP      = zi.1.HHPOP[iter]
            RO.SUM_POP    = LC_Pop_Sum
            RO.POP_LC1    = Pop_LC1
            RO.POP_LC2    = Pop_LC2
            RO.POP_LC3    = Pop_LC3
            
            RO.HHSIZE     = LC_HHSize_Sum 
            RO.HHSIZE_LC1 = HHSize_LC1
            RO.HHSIZE_LC2 = HHSize_LC2
            RO.HHSIZE_LC3 = HHSize_LC3
            
            RO.SUM_AGEGRP = AGPop_0to17 + AGPop_18to64 + AGPop_65P
            RO.POP_AG1    = AGPop_0to17 
            RO.POP_AG2    = AGPop_18to64   
            RO.POP_AG3    = AGPop_65P
            
            RO.SUM_PCTHLC = LC1_HHShare + LC2_HHShare + LC3_HHShare
            RO.PCT_HHLC1  = LC1_HHShare
            RO.PCT_HHLC2  = LC2_HHShare
            RO.PCT_HHLC3  = LC3_HHShare
            
            RO.SUM_PCTPLC = LC1_PopShare + LC2_PopShare + LC3_PopShare
            RO.PCT_POPLC1 = LC1_PopShare
            RO.PCT_POPLC2 = LC2_PopShare
            RO.PCT_POPLC3 = LC3_PopShare
            
            RO.SUM_PCTAG  = Pct_Pop_0to17 + Pct_Pop_18to64 + Pct_Pop_65P
            RO.PCT_AG1    = Pct_Pop_0to17 
            RO.PCT_AG2    = Pct_Pop_18to64   
            RO.PCT_AG3    = Pct_Pop_65P
            
            RO.CO_TAZID  = zi.2.CO_TAZID[iter]
            RO.CO_FIPS   = zi.2.CO_FIPS[iter]
            
            WRITE RECO=1
            
        ENDLOOP  ;iter
        
    endif  ;i=zones
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n----------------------------------------------------------------------',
             '\nHOUSEHOLD DISAGGREGATION & AUTO OWNERSHIP',
             '\n    Life Cycle                         ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 1_LifeCycle.txt)
