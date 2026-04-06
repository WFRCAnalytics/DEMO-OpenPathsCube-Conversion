
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 2_HHDisaggregation.txt)



;get start time
ScriptStartTime = currenttime()




;Local variables
    Convergence_Tolerance   = 0.0001
    Maximum_Iterations      = 15


RUN PGM=MATRIX  MSG='HH Disaggregation: HH by Size'
    FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
          ZDATI[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\LifeCycle_Households_Population.dbf'
    
    FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - HH Size.csv'
    FILEI LOOKUPI[2] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - HH Size_LC1.csv'
    FILEI LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - HH Size_LC2.csv'
    FILEI LOOKUPI[4] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - HH Size_LC3.csv'
    
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_HHSize_by_LifeCycle.dbf', 
        FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           TOTHH,
           SumHH, Sum_HH1, Sum_HH2, Sum_HH3, Sum_HH4, Sum_HH5, Sum_HH6, 
           SumHH_LC1, HH1_LC1, HH2_LC1, HH3_LC1, HH4_LC1, HH5_LC1, HH6_LC1, HHSize_LC1,
           SumHH_LC2, HH1_LC2, HH2_LC2, HH3_LC2, HH4_LC2, HH5_LC2, HH6_LC2, HHSize_LC2,
           SumHH_LC3, HH1_LC3, HH2_LC3, HH3_LC3, HH4_LC3, HH5_LC3, HH6_LC3, HHSize_LC3,
           SumHH_Reg, HH1_RegAvg, HH2_RegAvg, HH3_RegAvg, HH4_RegAvg, HH5_RegAvg, HH6_RegAvg, HHSIZE_Reg  


    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = 1
    
 
    ;define lookup functions
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=HHPercentLookup,
        Lookup[1]=01, RESULT=02,    ;PCT_HH1
        Lookup[2]=01, RESULT=03,    ;PCT_HH2
        Lookup[3]=01, RESULT=04,    ;PCT_HH3
        Lookup[4]=01, RESULT=05,    ;PCT_HH4
        Lookup[5]=01, RESULT=06,    ;PCT_HH5
        Lookup[6]=01, RESULT=07     ;PCT_HH6
    
    
    ;Box Elder
    LOOKUP LOOKUPI=2, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=BE_HHPctLookup_LC1,
        Lookup[1]=01, RESULT=02,    ;PCT_HH1
        Lookup[2]=01, RESULT=03,    ;PCT_HH2
        Lookup[3]=01, RESULT=04,    ;PCT_HH3
        Lookup[4]=01, RESULT=05,    ;PCT_HH4
        Lookup[5]=01, RESULT=06,    ;PCT_HH5
        Lookup[6]=01, RESULT=07     ;PCT_HH6
    
    LOOKUP LOOKUPI=3, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=BE_HHPctLookup_LC2,
        Lookup[1]=01, RESULT=02,    ;PCT_HH1
        Lookup[2]=01, RESULT=03,    ;PCT_HH2
        Lookup[3]=01, RESULT=04,    ;PCT_HH3
        Lookup[4]=01, RESULT=05,    ;PCT_HH4
        Lookup[5]=01, RESULT=06,    ;PCT_HH5
        Lookup[6]=01, RESULT=07     ;PCT_HH6
    
    LOOKUP LOOKUPI=4, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=BE_HHPctLookup_LC3,
        Lookup[1]=01, RESULT=02,    ;PCT_HH1
        Lookup[2]=01, RESULT=03,    ;PCT_HH2
        Lookup[3]=01, RESULT=04,    ;PCT_HH3
        Lookup[4]=01, RESULT=05,    ;PCT_HH4
        Lookup[5]=01, RESULT=06,    ;PCT_HH5
        Lookup[6]=01, RESULT=07     ;PCT_HH6
    
    
    ;Weber
    LOOKUP LOOKUPI=2, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=WE_HHPctLookup_LC1,
        Lookup[1]=01, RESULT=37,    ;PCT_HH1
        Lookup[2]=01, RESULT=38,    ;PCT_HH2
        Lookup[3]=01, RESULT=39,    ;PCT_HH3
        Lookup[4]=01, RESULT=40,    ;PCT_HH4
        Lookup[5]=01, RESULT=41,    ;PCT_HH5
        Lookup[6]=01, RESULT=42     ;PCT_HH6
    
    LOOKUP LOOKUPI=3, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=WE_HHPctLookup_LC2,
        Lookup[1]=01, RESULT=37,    ;PCT_HH1
        Lookup[2]=01, RESULT=38,    ;PCT_HH2
        Lookup[3]=01, RESULT=39,    ;PCT_HH3
        Lookup[4]=01, RESULT=40,    ;PCT_HH4
        Lookup[5]=01, RESULT=41,    ;PCT_HH5
        Lookup[6]=01, RESULT=42     ;PCT_HH6
    
    LOOKUP LOOKUPI=4, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=WE_HHPctLookup_LC3,
        Lookup[1]=01, RESULT=37,    ;PCT_HH1
        Lookup[2]=01, RESULT=38,    ;PCT_HH2
        Lookup[3]=01, RESULT=39,    ;PCT_HH3
        Lookup[4]=01, RESULT=40,    ;PCT_HH4
        Lookup[5]=01, RESULT=41,    ;PCT_HH5
        Lookup[6]=01, RESULT=42     ;PCT_HH6
    
    
    ;Davis
    LOOKUP LOOKUPI=2, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=DA_HHPctLookup_LC1,
        Lookup[1]=01, RESULT=44,    ;PCT_HH1
        Lookup[2]=01, RESULT=45,    ;PCT_HH2
        Lookup[3]=01, RESULT=46,    ;PCT_HH3
        Lookup[4]=01, RESULT=47,    ;PCT_HH4
        Lookup[5]=01, RESULT=48,    ;PCT_HH5
        Lookup[6]=01, RESULT=49     ;PCT_HH6
    
    LOOKUP LOOKUPI=3, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=DA_HHPctLookup_LC2,
        Lookup[1]=01, RESULT=44,    ;PCT_HH1
        Lookup[2]=01, RESULT=45,    ;PCT_HH2
        Lookup[3]=01, RESULT=46,    ;PCT_HH3
        Lookup[4]=01, RESULT=47,    ;PCT_HH4
        Lookup[5]=01, RESULT=48,    ;PCT_HH5
        Lookup[6]=01, RESULT=49     ;PCT_HH6
    
    LOOKUP LOOKUPI=4, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=DA_HHPctLookup_LC3,
        Lookup[1]=01, RESULT=44,    ;PCT_HH1
        Lookup[2]=01, RESULT=45,    ;PCT_HH2
        Lookup[3]=01, RESULT=46,    ;PCT_HH3
        Lookup[4]=01, RESULT=47,    ;PCT_HH4
        Lookup[5]=01, RESULT=48,    ;PCT_HH5
        Lookup[6]=01, RESULT=49     ;PCT_HH6
    
    
    ;Salt Lake
    LOOKUP LOOKUPI=2, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=SL_HHPctLookup_LC1,
        Lookup[1]=01, RESULT=51,    ;PCT_HH1
        Lookup[2]=01, RESULT=52,    ;PCT_HH2
        Lookup[3]=01, RESULT=53,    ;PCT_HH3
        Lookup[4]=01, RESULT=54,    ;PCT_HH4
        Lookup[5]=01, RESULT=55,    ;PCT_HH5
        Lookup[6]=01, RESULT=56     ;PCT_HH6
    
    LOOKUP LOOKUPI=3, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=SL_HHPctLookup_LC2,
        Lookup[1]=01, RESULT=51,    ;PCT_HH1
        Lookup[2]=01, RESULT=52,    ;PCT_HH2
        Lookup[3]=01, RESULT=53,    ;PCT_HH3
        Lookup[4]=01, RESULT=54,    ;PCT_HH4
        Lookup[5]=01, RESULT=55,    ;PCT_HH5
        Lookup[6]=01, RESULT=56     ;PCT_HH6
    
    LOOKUP LOOKUPI=4, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=SL_HHPctLookup_LC3,
        Lookup[1]=01, RESULT=51,    ;PCT_HH1
        Lookup[2]=01, RESULT=52,    ;PCT_HH2
        Lookup[3]=01, RESULT=53,    ;PCT_HH3
        Lookup[4]=01, RESULT=54,    ;PCT_HH4
        Lookup[5]=01, RESULT=55,    ;PCT_HH5
        Lookup[6]=01, RESULT=56     ;PCT_HH6
    
    
    ;Utah
    LOOKUP LOOKUPI=2, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=UT_HHPctLookup_LC1,
        Lookup[1]=01, RESULT=58,    ;PCT_HH1
        Lookup[2]=01, RESULT=59,    ;PCT_HH2
        Lookup[3]=01, RESULT=60,    ;PCT_HH3
        Lookup[4]=01, RESULT=61,    ;PCT_HH4
        Lookup[5]=01, RESULT=62,    ;PCT_HH5
        Lookup[6]=01, RESULT=63     ;PCT_HH6
    
    LOOKUP LOOKUPI=3, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=UT_HHPctLookup_LC2,
        Lookup[1]=01, RESULT=58,    ;PCT_HH1
        Lookup[2]=01, RESULT=59,    ;PCT_HH2
        Lookup[3]=01, RESULT=60,    ;PCT_HH3
        Lookup[4]=01, RESULT=61,    ;PCT_HH4
        Lookup[5]=01, RESULT=62,    ;PCT_HH5
        Lookup[6]=01, RESULT=63     ;PCT_HH6
    
    LOOKUP LOOKUPI=4, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=UT_HHPctLookup_LC3,
        Lookup[1]=01, RESULT=58,    ;PCT_HH1
        Lookup[2]=01, RESULT=59,    ;PCT_HH2
        Lookup[3]=01, RESULT=60,    ;PCT_HH3
        Lookup[4]=01, RESULT=61,    ;PCT_HH4
        Lookup[5]=01, RESULT=62,    ;PCT_HH5
        Lookup[6]=01, RESULT=63     ;PCT_HH6
    
    
    ;assign output variable
    RO.Z = i
    
    RO.CO_TAZID  = zi.1.CO_TAZID
    RO.CO_FIPS   = zi.1.CO_FIPS
    
    
    RO.TOTHH = zi.1.TOTHH
    TotalHH  = TotalHH + RO.TOTHH
    
    RO.HHSIZE_LC1  = zi.2.HHSIZE_LC1
    RO.HHSIZE_LC2  = zi.2.HHSIZE_LC2
    RO.HHSIZE_LC3  = zi.2.HHSIZE_LC3
    RO.HHSIZE_Reg  = zi.2.HHSIZE
    
    
    ;Calculate HH size based on SizeGrp & HHSize lookup table
    ;life cycle 1 HH
    if (zi.1.CO_FIPS=57)
        RO.HH1_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(1,RO.HHSIZE_LC1)
        RO.HH2_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(2,RO.HHSIZE_LC1)
        RO.HH3_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(3,RO.HHSIZE_LC1)
        RO.HH4_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(4,RO.HHSIZE_LC1)
        RO.HH5_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(5,RO.HHSIZE_LC1)
        RO.HH6_LC1 = zi.2.HH_LC1 * WE_HHPctLookup_LC1(6,RO.HHSIZE_LC1)
    
    elseif (zi.1.CO_FIPS=11)
        RO.HH1_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(1,RO.HHSIZE_LC1)
        RO.HH2_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(2,RO.HHSIZE_LC1)
        RO.HH3_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(3,RO.HHSIZE_LC1)
        RO.HH4_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(4,RO.HHSIZE_LC1)
        RO.HH5_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(5,RO.HHSIZE_LC1)
        RO.HH6_LC1 = zi.2.HH_LC1 * DA_HHPctLookup_LC1(6,RO.HHSIZE_LC1)
    
    elseif (zi.1.CO_FIPS=35)
        RO.HH1_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(1,RO.HHSIZE_LC1)
        RO.HH2_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(2,RO.HHSIZE_LC1)
        RO.HH3_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(3,RO.HHSIZE_LC1)
        RO.HH4_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(4,RO.HHSIZE_LC1)
        RO.HH5_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(5,RO.HHSIZE_LC1)
        RO.HH6_LC1 = zi.2.HH_LC1 * SL_HHPctLookup_LC1(6,RO.HHSIZE_LC1)
    
    elseif (zi.1.CO_FIPS=49)
        RO.HH1_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(1,RO.HHSIZE_LC1)
        RO.HH2_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(2,RO.HHSIZE_LC1)
        RO.HH3_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(3,RO.HHSIZE_LC1)
        RO.HH4_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(4,RO.HHSIZE_LC1)
        RO.HH5_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(5,RO.HHSIZE_LC1)
        RO.HH6_LC1 = zi.2.HH_LC1 * UT_HHPctLookup_LC1(6,RO.HHSIZE_LC1)
    
    else
        RO.HH1_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(1,RO.HHSIZE_LC1)
        RO.HH2_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(2,RO.HHSIZE_LC1)
        RO.HH3_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(3,RO.HHSIZE_LC1)
        RO.HH4_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(4,RO.HHSIZE_LC1)
        RO.HH5_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(5,RO.HHSIZE_LC1)
        RO.HH6_LC1 = zi.2.HH_LC1 * BE_HHPctLookup_LC1(6,RO.HHSIZE_LC1)
    endif
    
    
    RO.SumHH_LC1 = RO.HH1_LC1 + 
                   RO.HH2_LC1 + 
                   RO.HH3_LC1 + 
                   RO.HH4_LC1 + 
                   RO.HH5_LC1 + 
                   RO.HH6_LC1 
    
    TotHH1_LC1 = TotHH1_LC1 + RO.HH1_LC1
    TotHH2_LC1 = TotHH2_LC1 + RO.HH2_LC1
    TotHH3_LC1 = TotHH3_LC1 + RO.HH3_LC1
    TotHH4_LC1 = TotHH4_LC1 + RO.HH4_LC1
    TotHH5_LC1 = TotHH5_LC1 + RO.HH5_LC1
    TotHH6_LC1 = TotHH6_LC1 + RO.HH6_LC1
    TotHH_LC1  = TotHH_LC1  + RO.SumHH_LC1
    
    ;life cycle 2 HH
    if (zi.1.CO_FIPS=57)
        RO.HH1_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(1,RO.HHSIZE_LC2)
        RO.HH2_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(2,RO.HHSIZE_LC2)
        RO.HH3_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(3,RO.HHSIZE_LC2)
        RO.HH4_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(4,RO.HHSIZE_LC2)
        RO.HH5_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(5,RO.HHSIZE_LC2)
        RO.HH6_LC2 = zi.2.HH_LC2 * WE_HHPctLookup_LC2(6,RO.HHSIZE_LC2)
    
    elseif (zi.1.CO_FIPS=11)
        RO.HH1_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(1,RO.HHSIZE_LC2)
        RO.HH2_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(2,RO.HHSIZE_LC2)
        RO.HH3_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(3,RO.HHSIZE_LC2)
        RO.HH4_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(4,RO.HHSIZE_LC2)
        RO.HH5_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(5,RO.HHSIZE_LC2)
        RO.HH6_LC2 = zi.2.HH_LC2 * DA_HHPctLookup_LC2(6,RO.HHSIZE_LC2)
    
    elseif (zi.1.CO_FIPS=35)
        RO.HH1_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(1,RO.HHSIZE_LC2)
        RO.HH2_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(2,RO.HHSIZE_LC2)
        RO.HH3_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(3,RO.HHSIZE_LC2)
        RO.HH4_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(4,RO.HHSIZE_LC2)
        RO.HH5_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(5,RO.HHSIZE_LC2)
        RO.HH6_LC2 = zi.2.HH_LC2 * SL_HHPctLookup_LC2(6,RO.HHSIZE_LC2)
    
    elseif (zi.1.CO_FIPS=49)
        RO.HH1_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(1,RO.HHSIZE_LC2)
        RO.HH2_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(2,RO.HHSIZE_LC2)
        RO.HH3_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(3,RO.HHSIZE_LC2)
        RO.HH4_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(4,RO.HHSIZE_LC2)
        RO.HH5_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(5,RO.HHSIZE_LC2)
        RO.HH6_LC2 = zi.2.HH_LC2 * UT_HHPctLookup_LC2(6,RO.HHSIZE_LC2)
    
    else
        RO.HH1_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(1,RO.HHSIZE_LC2)
        RO.HH2_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(2,RO.HHSIZE_LC2)
        RO.HH3_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(3,RO.HHSIZE_LC2)
        RO.HH4_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(4,RO.HHSIZE_LC2)
        RO.HH5_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(5,RO.HHSIZE_LC2)
        RO.HH6_LC2 = zi.2.HH_LC2 * BE_HHPctLookup_LC2(6,RO.HHSIZE_LC2)
    endif
    
    
    RO.SumHH_LC2 = RO.HH1_LC2 + 
                   RO.HH2_LC2 + 
                   RO.HH3_LC2 + 
                   RO.HH4_LC2 + 
                   RO.HH5_LC2 + 
                   RO.HH6_LC2 
    
    TotHH1_LC2 = TotHH1_LC2 + RO.HH1_LC2
    TotHH2_LC2 = TotHH2_LC2 + RO.HH2_LC2
    TotHH3_LC2 = TotHH3_LC2 + RO.HH3_LC2
    TotHH4_LC2 = TotHH4_LC2 + RO.HH4_LC2
    TotHH5_LC2 = TotHH5_LC2 + RO.HH5_LC2
    TotHH6_LC2 = TotHH6_LC2 + RO.HH6_LC2
    TotHH_LC2  = TotHH_LC2  + RO.SumHH_LC2
    
    ;life cycle 3 HH
    if (zi.1.CO_FIPS=57)
        RO.HH1_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(1,RO.HHSIZE_LC3)
        RO.HH2_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(2,RO.HHSIZE_LC3)
        RO.HH3_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(3,RO.HHSIZE_LC3)
        RO.HH4_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(4,RO.HHSIZE_LC3)
        RO.HH5_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(5,RO.HHSIZE_LC3)
        RO.HH6_LC3 = zi.2.HH_LC3 * WE_HHPctLookup_LC3(6,RO.HHSIZE_LC3)
    
    elseif (zi.1.CO_FIPS=11)
        RO.HH1_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(1,RO.HHSIZE_LC3)
        RO.HH2_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(2,RO.HHSIZE_LC3)
        RO.HH3_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(3,RO.HHSIZE_LC3)
        RO.HH4_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(4,RO.HHSIZE_LC3)
        RO.HH5_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(5,RO.HHSIZE_LC3)
        RO.HH6_LC3 = zi.2.HH_LC3 * DA_HHPctLookup_LC3(6,RO.HHSIZE_LC3)
    
    elseif (zi.1.CO_FIPS=35)
        RO.HH1_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(1,RO.HHSIZE_LC3)
        RO.HH2_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(2,RO.HHSIZE_LC3)
        RO.HH3_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(3,RO.HHSIZE_LC3)
        RO.HH4_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(4,RO.HHSIZE_LC3)
        RO.HH5_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(5,RO.HHSIZE_LC3)
        RO.HH6_LC3 = zi.2.HH_LC3 * SL_HHPctLookup_LC3(6,RO.HHSIZE_LC3)
    
    elseif (zi.1.CO_FIPS=49)
        RO.HH1_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(1,RO.HHSIZE_LC3)
        RO.HH2_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(2,RO.HHSIZE_LC3)
        RO.HH3_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(3,RO.HHSIZE_LC3)
        RO.HH4_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(4,RO.HHSIZE_LC3)
        RO.HH5_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(5,RO.HHSIZE_LC3)
        RO.HH6_LC3 = zi.2.HH_LC3 * UT_HHPctLookup_LC3(6,RO.HHSIZE_LC3)
    
    else
        RO.HH1_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(1,RO.HHSIZE_LC3)
        RO.HH2_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(2,RO.HHSIZE_LC3)
        RO.HH3_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(3,RO.HHSIZE_LC3)
        RO.HH4_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(4,RO.HHSIZE_LC3)
        RO.HH5_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(5,RO.HHSIZE_LC3)
        RO.HH6_LC3 = zi.2.HH_LC3 * BE_HHPctLookup_LC3(6,RO.HHSIZE_LC3)
    endif
    
    
    RO.SumHH_LC3 = RO.HH1_LC3 + 
                   RO.HH2_LC3 + 
                   RO.HH3_LC3 + 
                   RO.HH4_LC3 + 
                   RO.HH5_LC3 + 
                   RO.HH6_LC3 
    
    TotHH1_LC3 = TotHH1_LC3 + RO.HH1_LC3
    TotHH2_LC3 = TotHH2_LC3 + RO.HH2_LC3
    TotHH3_LC3 = TotHH3_LC3 + RO.HH3_LC3
    TotHH4_LC3 = TotHH4_LC3 + RO.HH4_LC3
    TotHH5_LC3 = TotHH5_LC3 + RO.HH5_LC3
    TotHH6_LC3 = TotHH6_LC3 + RO.HH6_LC3
    TotHH_LC3  = TotHH_LC3  + RO.SumHH_LC3
    
    ;sum all life cycles
    RO.Sum_HH1 = RO.HH1_LC1 + RO.HH1_LC2 + RO.HH1_LC3
    RO.Sum_HH2 = RO.HH2_LC1 + RO.HH2_LC2 + RO.HH2_LC3
    RO.Sum_HH3 = RO.HH3_LC1 + RO.HH3_LC2 + RO.HH3_LC3
    RO.Sum_HH4 = RO.HH4_LC1 + RO.HH4_LC2 + RO.HH4_LC3
    RO.Sum_HH5 = RO.HH5_LC1 + RO.HH5_LC2 + RO.HH5_LC3
    RO.Sum_HH6 = RO.HH6_LC1 + RO.HH6_LC2 + RO.HH6_LC3
    
    RO.SumHH = RO.Sum_HH1 + 
               RO.Sum_HH2 + 
               RO.Sum_HH3 + 
               RO.Sum_HH4 + 
               RO.Sum_HH5 + 
               RO.Sum_HH6 
    
    TotHH1_SumLC = TotHH1_SumLC + RO.Sum_HH1
    TotHH2_SumLC = TotHH2_SumLC + RO.Sum_HH2
    TotHH3_SumLC = TotHH3_SumLC + RO.Sum_HH3
    TotHH4_SumLC = TotHH4_SumLC + RO.Sum_HH4
    TotHH5_SumLC = TotHH5_SumLC + RO.Sum_HH5
    TotHH6_SumLC = TotHH6_SumLC + RO.Sum_HH6
    TotHH_SumLC  = TotHH_SumLC  + RO.SumHH
    
    ;region average (not currently being used - informational only)
    RO.HH1_RegAvg = RO.TOTHH * HHPercentLookup(1,RO.HHSIZE_Reg)
    RO.HH2_RegAvg = RO.TOTHH * HHPercentLookup(2,RO.HHSIZE_Reg)
    RO.HH3_RegAvg = RO.TOTHH * HHPercentLookup(3,RO.HHSIZE_Reg)
    RO.HH4_RegAvg = RO.TOTHH * HHPercentLookup(4,RO.HHSIZE_Reg)
    RO.HH5_RegAvg = RO.TOTHH * HHPercentLookup(5,RO.HHSIZE_Reg)
    RO.HH6_RegAvg = RO.TOTHH * HHPercentLookup(6,RO.HHSIZE_Reg)
    
    RO.SumHH_Reg = RO.HH1_RegAvg + 
                   RO.HH2_RegAvg + 
                   RO.HH3_RegAvg + 
                   RO.HH4_RegAvg + 
                   RO.HH5_RegAvg + 
                   RO.HH6_RegAvg 
    
    TotHH1_RegAvg = TotHH1_RegAvg + RO.HH1_RegAvg
    TotHH2_RegAvg = TotHH2_RegAvg + RO.HH2_RegAvg
    TotHH3_RegAvg = TotHH3_RegAvg + RO.HH3_RegAvg
    TotHH4_RegAvg = TotHH4_RegAvg + RO.HH4_RegAvg
    TotHH5_RegAvg = TotHH5_RegAvg + RO.HH5_RegAvg
    TotHH6_RegAvg = TotHH6_RegAvg + RO.HH6_RegAvg
    TotHH_RegAvg  = TotHH_RegAvg  + RO.SumHH_Reg
    
    
    ;write output files
    WRITE  RECO=1
    
    
    
    ;print to LOG file
    if (I=ZONES)
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
            APPEND=T,
            LIST=';*********************************************************************\n',
                 '\n',
                 'Household Disaggregation\n',
                 '\n',
                 '    Total HH from SE file:  ', TotalHH(10.0C), '\n',
                 '\n',
                 'HH Size by Life Cycle Totals\n',
                 '    HH in Life Cycle 1:         ', TotHH_LC1(10.0C), TotHH_LC1/TotHH_SumLC*100(10.1), '%\n',
                 '        HH1:  ', TotHH1_LC1(10.0C), TotHH1_LC1/TotHH_LC1*100(10.1), '%\n',
                 '        HH2:  ', TotHH2_LC1(10.0C), TotHH2_LC1/TotHH_LC1*100(10.1), '%\n',
                 '        HH3:  ', TotHH3_LC1(10.0C), TotHH3_LC1/TotHH_LC1*100(10.1), '%\n',
                 '        HH4:  ', TotHH4_LC1(10.0C), TotHH4_LC1/TotHH_LC1*100(10.1), '%\n',
                 '        HH5:  ', TotHH5_LC1(10.0C), TotHH5_LC1/TotHH_LC1*100(10.1), '%\n',
                 '        HH6:  ', TotHH6_LC1(10.0C), TotHH6_LC1/TotHH_LC1*100(10.1), '%\n',
                 '    HH in Life Cycle 2:         ', TotHH_LC2(10.0C), TotHH_LC2/TotHH_SumLC*100(10.1), '%\n',
                 '        HH1:  ', TotHH1_LC2(10.0C), TotHH1_LC2/TotHH_LC2*100(10.1), '%\n',
                 '        HH2:  ', TotHH2_LC2(10.0C), TotHH2_LC2/TotHH_LC2*100(10.1), '%\n',
                 '        HH3:  ', TotHH3_LC2(10.0C), TotHH3_LC2/TotHH_LC2*100(10.1), '%\n',
                 '        HH4:  ', TotHH4_LC2(10.0C), TotHH4_LC2/TotHH_LC2*100(10.1), '%\n',
                 '        HH5:  ', TotHH5_LC2(10.0C), TotHH5_LC2/TotHH_LC2*100(10.1), '%\n',
                 '        HH6:  ', TotHH6_LC2(10.0C), TotHH6_LC2/TotHH_LC2*100(10.1), '%\n',
                 '    HH in Life Cycle 3:         ', TotHH_LC3(10.0C), TotHH_LC3/TotHH_SumLC*100(10.1), '%\n',
                 '        HH1:  ', TotHH1_LC3(10.0C), TotHH1_LC3/TotHH_LC3*100(10.1), '%\n',
                 '        HH2:  ', TotHH2_LC3(10.0C), TotHH2_LC3/TotHH_LC3*100(10.1), '%\n',
                 '        HH3:  ', TotHH3_LC3(10.0C), TotHH3_LC3/TotHH_LC3*100(10.1), '%\n',
                 '        HH4:  ', TotHH4_LC3(10.0C), TotHH4_LC3/TotHH_LC3*100(10.1), '%\n',
                 '        HH5:  ', TotHH5_LC3(10.0C), TotHH5_LC3/TotHH_LC3*100(10.1), '%\n',
                 '        HH6:  ', TotHH6_LC3(10.0C), TotHH6_LC3/TotHH_LC3*100(10.1), '%\n',
                 '    Total HH (sum Life Cycles): ', TotHH_SumLC(10.0C), TotHH_SumLC/TotalHH(10.4), '\n',
                 '        HH1:  ', TotHH1_SumLC(10.0C), TotHH1_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '        HH2:  ', TotHH2_SumLC(10.0C), TotHH2_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '        HH3:  ', TotHH3_SumLC(10.0C), TotHH3_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '        HH4:  ', TotHH4_SumLC(10.0C), TotHH4_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '        HH5:  ', TotHH5_SumLC(10.0C), TotHH5_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '        HH6:  ', TotHH6_SumLC(10.0C), TotHH6_SumLC/TotHH_SumLC*100(10.1), '%\n',
                 '\n'
                 
    endif

ENDRUN




RUN PGM=MATRIX MSG='HH Disaggregation: HH by Income Group'
FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
FILEI ZDATI[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_HHSize_by_LifeCycle.dbf'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - Income.csv'


FILEO RECO[1] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_Income.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           AVGINCOME(10.0),
           Inc1, Inc2, Inc3, Inc4, SumInc, TOTHH

FILEO RECO[2] = '@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\Tmp_Joint_HHSize_Income.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           AVGINCOME(10.0),
           S1I1, S1I2, S1I3, S1I4,
           S2I1, S2I2, S2I3, S2I4,
           S3I1, S3I2, S3I3, S3I4, 
           S4I1, S4I2, S4I3, S4I4,
           S5I1, S5I2, S5I3, S5I4,
           S6I1, S6I2, S6I3, S6I4, SumHH

FILEO RECO[3] = '@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\Tmp_Marginal_Income_beforeIPF.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           Inc1, Inc2, Inc3, Inc4, SumInc, TOTHH,
           AVGINCOME(10.0), IncRatio(8.1)

FILEO RECO[4] = '@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\Tmp_Marginal_HHSize_afterIPF.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           AVGINCOME(10.0),
           HHSIZE_Reg, SizeGrp_Reg(8.1), HH1, HH2, HH3, HH4, HH5, HH6, SumHH, TOTHH


    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = 1
    
 
    ;define lookup functions
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=T, 
        NAME=IncPctLookup_WFr,
        Lookup[1]=01, RESULT=07,    ;PCT_INC1
        Lookup[2]=01, RESULT=08,    ;PCT_INC2
        Lookup[3]=01, RESULT=09,    ;PCT_INC3
        Lookup[4]=01, RESULT=10     ;PCT_INC4
    
    
    ;define arrays
    ARRAY SeedRow1     = 4,
          SeedRow2     = 4,
          SeedRow3     = 4,
          SeedRow4     = 4,
          SeedRow5     = 4,
          SeedRow6     = 4,
          HH_Inc1      = 7,
          HH_Inc2      = 7,
          HH_Inc3      = 7,
          HH_Inc4      = 7,
          HH_Inc5      = 7,
          HH_Inc6      = 7,
          ColumnSum    = 4,
          ColumnTarget = 4,
          ColumnFactor = 4
    
    
    ;assign output variable
    RO.Z = i
    
    RO.CO_TAZID  = zi.1.CO_TAZID
    RO.CO_FIPS   = zi.1.CO_FIPS
    RO.AVGINCOME = zi.1.AVGINCOME
    
    RO.TOTHH = zi.1.TOTHH
    TotalHH  = TotalHH + RO.TOTHH
    
    
    ;calculate income groups based on IncRatio & HHIncome lookup table
    RO.IncRatio = zi.1.AVGINCOME / @Reg_Median_Inc@
    
    RO.Inc1 = RO.TOTHH * IncPctLookup_WFr(1,RO.IncRatio)
    RO.Inc2 = RO.TOTHH * IncPctLookup_WFr(2,RO.IncRatio)
    RO.Inc3 = RO.TOTHH * IncPctLookup_WFr(3,RO.IncRatio)
    RO.Inc4 = RO.TOTHH * IncPctLookup_WFr(4,RO.IncRatio)
    
    
    RO.SumInc = RO.Inc1 + 
                RO.Inc2 + 
                RO.Inc3 + 
                RO.Inc4
    
    ;write output files
    WRITE  RECO=3

    
    ;determine joint HHSize_Income
    
    ;assign row percent splits to SeedRow array; these will be used to seed the joint 
    ;HH_Income table before the balancing process (source: 2012 HH Survey)
    SeedRow1[1] = 0.591
    SeedRow1[2] = 0.167
    SeedRow1[3] = 0.210
    SeedRow1[4] = 0.032
    SeedRow2[1] = 0.286
    SeedRow2[2] = 0.155
    SeedRow2[3] = 0.351
    SeedRow2[4] = 0.208
    SeedRow3[1] = 0.253
    SeedRow3[2] = 0.180
    SeedRow3[3] = 0.351
    SeedRow3[4] = 0.216
    SeedRow4[1] = 0.211
    SeedRow4[2] = 0.151
    SeedRow4[3] = 0.395
    SeedRow4[4] = 0.243
    SeedRow5[1] = 0.154
    SeedRow5[2] = 0.157
    SeedRow5[3] = 0.460
    SeedRow5[4] = 0.229
    SeedRow6[1] = 0.118
    SeedRow6[2] = 0.122
    SeedRow6[3] = 0.479
    SeedRow6[4] = 0.281
    
    
    ;assign HH target values into position 6 of the HH_Income arrays (use sum of Life Cycle for HH totals)
    HH_Inc1[6] = zi.2.Sum_HH1
    HH_Inc2[6] = zi.2.Sum_HH2
    HH_Inc3[6] = zi.2.Sum_HH3
    HH_Inc4[6] = zi.2.Sum_HH4
    HH_Inc5[6] = zi.2.Sum_HH5
    HH_Inc6[6] = zi.2.Sum_HH6
    
    
    ;assign Income Group targets into the target array
    ColumnTarget[1] = RO.Inc1
    ColumnTarget[2] = RO.Inc2
    ColumnTarget[3] = RO.Inc3
    ColumnTarget[4] = RO.Inc4
    
    
    ;seed the joint distribution table
    LOOP col=1,4
        HH_Inc1[col] = SeedRow1[col] * HH_Inc1[6]
        HH_Inc2[col] = SeedRow2[col] * HH_Inc2[6]
        HH_Inc3[col] = SeedRow3[col] * HH_Inc3[6]
        HH_Inc4[col] = SeedRow4[col] * HH_Inc4[6]
        HH_Inc5[col] = SeedRow5[col] * HH_Inc5[6]
        HH_Inc6[col] = SeedRow6[col] * HH_Inc6[6]
    ENDLOOP
    
    
    ;loop through balancing routine until convergence criteria or max iterations is met
    LOOP iter=1,15
        
        ;reset max column factor variable to 0 before processing data for new iteration
        MaxColFactor = 0
        
        ;loop through columns, sum column totals, calculate column adjustment factors,
        ;then determine the most extreme (higest or lowest) column adjustment factor
        LOOP col=1,4
            ColumnSum[col] = HH_Inc1[col] + 
                             HH_Inc2[col] + 
                             HH_Inc3[col] + 
                             HH_Inc4[col] + 
                             HH_Inc5[col] + 
                             HH_Inc6[col]
            
            if (ColumnSum[col]=0)
                ColumnFactor[col]=0
            else
                ColumnFactor[col] = ColumnTarget[col]/ColumnSum[col]
            endif
            
            if (abs(ColumnFactor[col]-1) > MaxColFactor)  MaxColFactor=ColumnFactor[col]
        ENDLOOP
        
        ;check convergenc criteria, if MaxRatio is within Convergence Tolerance break out
        ;of Iteration Loop
        if (abs(MaxColFactor-1)<=0.0001)  BREAK
        
        ;factor columns
        LOOP col=1,4
            HH_Inc1[col] = HH_Inc1[col] * ColumnFactor[col]
            HH_Inc2[col] = HH_Inc2[col] * ColumnFactor[col]
            HH_Inc3[col] = HH_Inc3[col] * ColumnFactor[col]
            HH_Inc4[col] = HH_Inc4[col] * ColumnFactor[col]
            HH_Inc5[col] = HH_Inc5[col] * ColumnFactor[col]
            HH_Inc6[col] = HH_Inc6[col] * ColumnFactor[col]
        ENDLOOP
        
        ;sum row totals, put into position 5 in the HH_Income array
        HH_Inc1[5] = HH_Inc1[1] + HH_Inc1[2] + HH_Inc1[3] + HH_Inc1[4]
        HH_Inc2[5] = HH_Inc2[1] + HH_Inc2[2] + HH_Inc2[3] + HH_Inc2[4]
        HH_Inc3[5] = HH_Inc3[1] + HH_Inc3[2] + HH_Inc3[3] + HH_Inc3[4]
        HH_Inc4[5] = HH_Inc4[1] + HH_Inc4[2] + HH_Inc4[3] + HH_Inc4[4]
        HH_Inc5[5] = HH_Inc5[1] + HH_Inc5[2] + HH_Inc5[3] + HH_Inc5[4]
        HH_Inc6[5] = HH_Inc6[1] + HH_Inc6[2] + HH_Inc6[3] + HH_Inc6[4]
        
        
        ;calculate row adjustment factors, put into position 7 in the HH_Income array
        ;row 1
        if (HH_Inc1[5]=0)
            HH_Inc1[7] = 0
        else
            HH_Inc1[7] = HH_Inc1[6] / HH_Inc1[5]
        endif
        
        ;row 2
        if (HH_Inc2[5]=0)
            HH_Inc2[7] = 0
        else
            HH_Inc2[7] = HH_Inc2[6] / HH_Inc2[5]
        endif
        
        ;row 3
        if (HH_Inc3[5]=0)
            HH_Inc3[7] = 0
        else
            HH_Inc3[7] = HH_Inc3[6] / HH_Inc3[5]
        endif
        
        ;row 4
        if (HH_Inc4[5]=0)
            HH_Inc4[7] = 0
        else
            HH_Inc4[7] = HH_Inc4[6] / HH_Inc4[5]
        endif
        
        ;row 5
        if (HH_Inc5[5]=0)
            HH_Inc5[7] = 0
        else
            HH_Inc5[7] = HH_Inc5[6] / HH_Inc5[5]
        endif
        
        ;row 6
        if (HH_Inc6[5]=0)
            HH_Inc6[7] = 0
        else
            HH_Inc6[7] = HH_Inc6[6] / HH_Inc6[5]
        endif
        
        
        ;factor rows
        LOOP col=1,4
            HH_Inc1[col] = HH_Inc1[col] * HH_Inc1[7]
            HH_Inc2[col] = HH_Inc2[col] * HH_Inc2[7]
            HH_Inc3[col] = HH_Inc3[col] * HH_Inc3[7]
            HH_Inc4[col] = HH_Inc4[col] * HH_Inc4[7]
            HH_Inc5[col] = HH_Inc5[col] * HH_Inc5[7]
            HH_Inc6[col] = HH_Inc6[col] * HH_Inc6[7]
        ENDLOOP
    ENDLOOP
    
    
    ;sum row totals for marginal HHSize file
    RO.HH1 = HH_Inc1[1] + HH_Inc1[2] + HH_Inc1[3] + HH_Inc1[4]
    RO.HH2 = HH_Inc2[1] + HH_Inc2[2] + HH_Inc2[3] + HH_Inc2[4]
    RO.HH3 = HH_Inc3[1] + HH_Inc3[2] + HH_Inc3[3] + HH_Inc3[4]
    RO.HH4 = HH_Inc4[1] + HH_Inc4[2] + HH_Inc4[3] + HH_Inc4[4]
    RO.HH5 = HH_Inc5[1] + HH_Inc5[2] + HH_Inc5[3] + HH_Inc5[4]
    RO.HH6 = HH_Inc6[1] + HH_Inc6[2] + HH_Inc6[3] + HH_Inc6[4]
    
    RO.SumHH = RO.HH1 + 
               RO.HH2 + 
               RO.HH3 + 
               RO.HH4 + 
               RO.HH5 + 
               RO.HH6 
    
    
    ;sum column totals for maginal Income file
    RO.Inc1  = HH_Inc1[1] + HH_Inc2[1] + HH_Inc3[1] + HH_Inc4[1] + HH_Inc5[1] + HH_Inc6[1]
    RO.Inc2  = HH_Inc1[2] + HH_Inc2[2] + HH_Inc3[2] + HH_Inc4[2] + HH_Inc5[2] + HH_Inc6[2]
    RO.Inc3  = HH_Inc1[3] + HH_Inc2[3] + HH_Inc3[3] + HH_Inc4[3] + HH_Inc5[3] + HH_Inc6[3]
    RO.Inc4  = HH_Inc1[4] + HH_Inc2[4] + HH_Inc3[4] + HH_Inc4[4] + HH_Inc5[4] + HH_Inc6[4]
    
    RO.SumInc = RO.Inc1 + 
                RO.Inc2 + 
                RO.Inc3 + 
                RO.Inc4
    
    TotHH_Inc1   = TotHH_Inc1 + RO.Inc1
    TotHH_Inc2   = TotHH_Inc2 + RO.Inc2
    TotHH_Inc3   = TotHH_Inc3 + RO.Inc3
    TotHH_Inc4   = TotHH_Inc4 + RO.Inc4
    TotHH_SumInc = TotHH_SumInc + RO.SumInc
    
    ;assign remaining output variables
    RO.S1I1 = HH_Inc1[1]
    RO.S1I2 = HH_Inc1[2]
    RO.S1I3 = HH_Inc1[3]
    RO.S1I4 = HH_Inc1[4]
    RO.S2I1 = HH_Inc2[1]
    RO.S2I2 = HH_Inc2[2]
    RO.S2I3 = HH_Inc2[3]
    RO.S2I4 = HH_Inc2[4]
    RO.S3I1 = HH_Inc3[1]
    RO.S3I2 = HH_Inc3[2]
    RO.S3I3 = HH_Inc3[3]
    RO.S3I4 = HH_Inc3[4]
    RO.S4I1 = HH_Inc4[1]
    RO.S4I2 = HH_Inc4[2]
    RO.S4I3 = HH_Inc4[3]
    RO.S4I4 = HH_Inc4[4]
    RO.S5I1 = HH_Inc5[1]
    RO.S5I2 = HH_Inc5[2]
    RO.S5I3 = HH_Inc5[3]
    RO.S5I4 = HH_Inc5[4]
    RO.S6I1 = HH_Inc6[1]
    RO.S6I2 = HH_Inc6[2]
    RO.S6I3 = HH_Inc6[3]
    RO.S6I4 = HH_Inc6[4]
    
    
    ;write output files
    WRITE  RECO=1-2, 4
    
    
    
    ;print to LOG file
    if (I=ZONES)
        PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
            APPEND=T,
            LIST='Income Group Totals\n',
                 '    Total HH in Inc1:           ', TotHH_Inc1(10.0C), TotHH_Inc1/TotHH_SumInc*100(10.1), '%\n',
                 '    Total HH in Inc2:           ', TotHH_Inc2(10.0C), TotHH_Inc2/TotHH_SumInc*100(10.1), '%\n',
                 '    Total HH in Inc3:           ', TotHH_Inc3(10.0C), TotHH_Inc3/TotHH_SumInc*100(10.1), '%\n',
                 '    Total HH in Inc4:           ', TotHH_Inc4(10.0C), TotHH_Inc4/TotHH_SumInc*100(10.1), '%\n',
                 '    Total HH (sum Inc Groups):  ', TotHH_SumInc(10.0C), TotHH_SumInc/TotalHH(10.4), '\n',
                 '\n'
    endif

ENDRUN




RUN PGM=MATRIX MSG='HH Disaggregation: HH by Workers'
FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
FILEI ZDATI[2] = '@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\Tmp_Joint_HHSize_Income.dbf'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\1_HHDisag_AutoOwn\Lookup - Worker.csv'


FILEO RECO[1] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_Worker.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           Wrk0, Wrk1, Wrk2, Wrk3, SumHH, TOTHH, TOTWRK

FILEO RECO[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Joint_HHSize_IncHiLo_Wrk.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           S1ILW0, S1ILW1, S1ILW2, S1ILW3, 
           S1IHW0, S1IHW1, S1IHW2, S1IHW3, 
           S2ILW0, S2ILW1, S2ILW2, S2ILW3, 
           S2IHW0, S2IHW1, S2IHW2, S2IHW3, 
           S3ILW0, S3ILW1, S3ILW2, S3ILW3, 
           S3IHW0, S3IHW1, S3IHW2, S3IHW3, 
           S4ILW0, S4ILW1, S4ILW2, S4ILW3, 
           S4IHW0, S4IHW1, S4IHW2, S4IHW3, 
           S5ILW0, S5ILW1, S5ILW2, S5ILW3, 
           S5IHW0, S5IHW1, S5IHW2, S5IHW3, 
           S6ILW0, S6ILW1, S6ILW2, S6ILW3, 
           S6IHW0, S6IHW1, S6IHW2, S6IHW3, 
           SumHH, TOTHH

FILEO RECO[3] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Joint_HHSize_Income_Worker.dbf',
    FIELDS=Z(5.0), 
           CO_TAZID(10.0),
           CO_FIPS(6.0),
           S1I1W0, S1I1W1, S1I1W2, S1I1W3, 
           S1I2W0, S1I2W1, S1I2W2, S1I2W3, 
           S1I3W0, S1I3W1, S1I3W2, S1I3W3, 
           S1I4W0, S1I4W1, S1I4W2, S1I4W3, 
           S2I1W0, S2I1W1, S2I1W2, S2I1W3, 
           S2I2W0, S2I2W1, S2I2W2, S2I2W3, 
           S2I3W0, S2I3W1, S2I3W2, S2I3W3, 
           S2I4W0, S2I4W1, S2I4W2, S2I4W3, 
           S3I1W0, S3I1W1, S3I1W2, S3I1W3, 
           S3I2W0, S3I2W1, S3I2W2, S3I2W3, 
           S3I3W0, S3I3W1, S3I3W2, S3I3W3, 
           S3I4W0, S3I4W1, S3I4W2, S3I4W3, 
           S4I1W0, S4I1W1, S4I1W2, S4I1W3, 
           S4I2W0, S4I2W1, S4I2W2, S4I2W3, 
           S4I3W0, S4I3W1, S4I3W2, S4I3W3, 
           S4I4W0, S4I4W1, S4I4W2, S4I4W3, 
           S5I1W0, S5I1W1, S5I1W2, S5I1W3, 
           S5I2W0, S5I2W1, S5I2W2, S5I2W3, 
           S5I3W0, S5I3W1, S5I3W2, S5I3W3, 
           S5I4W0, S5I4W1, S5I4W2, S5I4W3, 
           S6I1W0, S6I1W1, S6I1W2, S6I1W3, 
           S6I2W0, S6I2W1, S6I2W2, S6I2W3, 
           S6I3W0, S6I3W1, S6I3W2, S6I3W3, 
           S6I4W0, S6I4W1, S6I4W2, S6I4W3,
           SumHH, TOTHH


    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = 1
    
    
    ;define lookup functions
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=F, 
        NAME=WrkPctLookup_WE,
        Lookup[1]=01, RESULT=09,
        Lookup[2]=01, RESULT=10,
        Lookup[3]=01, RESULT=11,
        Lookup[4]=01, RESULT=12
    
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=F, 
        NAME=WrkPctLookup_DA,
        Lookup[1]=01, RESULT=14,
        Lookup[2]=01, RESULT=15,
        Lookup[3]=01, RESULT=16,
        Lookup[4]=01, RESULT=17
    
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=F, 
        NAME=WrkPctLookup_SL,
        Lookup[1]=01, RESULT=19,
        Lookup[2]=01, RESULT=20,
        Lookup[3]=01, RESULT=21,
        Lookup[4]=01, RESULT=22
    
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=F, 
        NAME=WrkPctLookup_UT,
        Lookup[1]=01, RESULT=24,
        Lookup[2]=01, RESULT=25,
        Lookup[3]=01, RESULT=26,
        Lookup[4]=01, RESULT=27
    
    LOOKUP LOOKUPI=1, 
        LIST=T,
        INTERPOLATE=F, 
        NAME=WrkPctLookup_BE,
        Lookup[1]=01, RESULT=39,
        Lookup[2]=01, RESULT=40,
        Lookup[3]=01, RESULT=41,
        Lookup[4]=01, RESULT=42
    
    
    ;assign output variable
    RO.Z = i
    
    RO.CO_TAZID  = zi.1.CO_TAZID
    RO.CO_FIPS   = zi.1.CO_FIPS
    
    
    RO.TOTHH = zi.1.TOTHH
    TotalHH  = TotalHH + RO.TOTHH
    
    
    ;determine joint HHSize-Income-Worker distribution based on HHSize-Income-Worker lookup curves
    ;Weber (WFRC MPO) --------------------------------------------------------------------
    if (zi.1.CO_FIPS=57)
        RO.S1I1W0 = zi.2.S1I1 * WrkPctLookup_WE(1,11)
        RO.S1I1W1 = zi.2.S1I1 * WrkPctLookup_WE(2,11)
        RO.S1I1W2 = zi.2.S1I1 * WrkPctLookup_WE(3,11)
        RO.S1I1W3 = zi.2.S1I1 * WrkPctLookup_WE(4,11)
        
        RO.S1I2W0 = zi.2.S1I2 * WrkPctLookup_WE(1,12)
        RO.S1I2W1 = zi.2.S1I2 * WrkPctLookup_WE(2,12)
        RO.S1I2W2 = zi.2.S1I2 * WrkPctLookup_WE(3,12)
        RO.S1I2W3 = zi.2.S1I2 * WrkPctLookup_WE(4,12)
        
        RO.S1I3W0 = zi.2.S1I3 * WrkPctLookup_WE(1,13)
        RO.S1I3W1 = zi.2.S1I3 * WrkPctLookup_WE(2,13)
        RO.S1I3W2 = zi.2.S1I3 * WrkPctLookup_WE(3,13)
        RO.S1I3W3 = zi.2.S1I3 * WrkPctLookup_WE(4,13)
        
        RO.S1I4W0 = zi.2.S1I4 * WrkPctLookup_WE(1,14)
        RO.S1I4W1 = zi.2.S1I4 * WrkPctLookup_WE(2,14)
        RO.S1I4W2 = zi.2.S1I4 * WrkPctLookup_WE(3,14)
        RO.S1I4W3 = zi.2.S1I4 * WrkPctLookup_WE(4,14)
        
        
        RO.S2I1W0 = zi.2.S2I1 * WrkPctLookup_WE(1,21)
        RO.S2I1W1 = zi.2.S2I1 * WrkPctLookup_WE(2,21)
        RO.S2I1W2 = zi.2.S2I1 * WrkPctLookup_WE(3,21)
        RO.S2I1W3 = zi.2.S2I1 * WrkPctLookup_WE(4,21)
        
        RO.S2I2W0 = zi.2.S2I2 * WrkPctLookup_WE(1,22)
        RO.S2I2W1 = zi.2.S2I2 * WrkPctLookup_WE(2,22)
        RO.S2I2W2 = zi.2.S2I2 * WrkPctLookup_WE(3,22)
        RO.S2I2W3 = zi.2.S2I2 * WrkPctLookup_WE(4,22)
        
        RO.S2I3W0 = zi.2.S2I3 * WrkPctLookup_WE(1,23)
        RO.S2I3W1 = zi.2.S2I3 * WrkPctLookup_WE(2,23)
        RO.S2I3W2 = zi.2.S2I3 * WrkPctLookup_WE(3,23)
        RO.S2I3W3 = zi.2.S2I3 * WrkPctLookup_WE(4,23)
        
        RO.S2I4W0 = zi.2.S2I4 * WrkPctLookup_WE(1,24)
        RO.S2I4W1 = zi.2.S2I4 * WrkPctLookup_WE(2,24)
        RO.S2I4W2 = zi.2.S2I4 * WrkPctLookup_WE(3,24)
        RO.S2I4W3 = zi.2.S2I4 * WrkPctLookup_WE(4,24)
        
        
        RO.S3I1W0 = zi.2.S3I1 * WrkPctLookup_WE(1,31)
        RO.S3I1W1 = zi.2.S3I1 * WrkPctLookup_WE(2,31)
        RO.S3I1W2 = zi.2.S3I1 * WrkPctLookup_WE(3,31)
        RO.S3I1W3 = zi.2.S3I1 * WrkPctLookup_WE(4,31)
        
        RO.S3I2W0 = zi.2.S3I2 * WrkPctLookup_WE(1,32)
        RO.S3I2W1 = zi.2.S3I2 * WrkPctLookup_WE(2,32)
        RO.S3I2W2 = zi.2.S3I2 * WrkPctLookup_WE(3,32)
        RO.S3I2W3 = zi.2.S3I2 * WrkPctLookup_WE(4,32)
        
        RO.S3I3W0 = zi.2.S3I3 * WrkPctLookup_WE(1,33)
        RO.S3I3W1 = zi.2.S3I3 * WrkPctLookup_WE(2,33)
        RO.S3I3W2 = zi.2.S3I3 * WrkPctLookup_WE(3,33)
        RO.S3I3W3 = zi.2.S3I3 * WrkPctLookup_WE(4,33)
        
        RO.S3I4W0 = zi.2.S3I4 * WrkPctLookup_WE(1,34)
        RO.S3I4W1 = zi.2.S3I4 * WrkPctLookup_WE(2,34)
        RO.S3I4W2 = zi.2.S3I4 * WrkPctLookup_WE(3,34)
        RO.S3I4W3 = zi.2.S3I4 * WrkPctLookup_WE(4,34)
        
        
        RO.S4I1W0 = zi.2.S4I1 * WrkPctLookup_WE(1,41)
        RO.S4I1W1 = zi.2.S4I1 * WrkPctLookup_WE(2,41)
        RO.S4I1W2 = zi.2.S4I1 * WrkPctLookup_WE(3,41)
        RO.S4I1W3 = zi.2.S4I1 * WrkPctLookup_WE(4,41)
        
        RO.S4I2W0 = zi.2.S4I2 * WrkPctLookup_WE(1,42)
        RO.S4I2W1 = zi.2.S4I2 * WrkPctLookup_WE(2,42)
        RO.S4I2W2 = zi.2.S4I2 * WrkPctLookup_WE(3,42)
        RO.S4I2W3 = zi.2.S4I2 * WrkPctLookup_WE(4,42)
        
        RO.S4I3W0 = zi.2.S4I3 * WrkPctLookup_WE(1,43)
        RO.S4I3W1 = zi.2.S4I3 * WrkPctLookup_WE(2,43)
        RO.S4I3W2 = zi.2.S4I3 * WrkPctLookup_WE(3,43)
        RO.S4I3W3 = zi.2.S4I3 * WrkPctLookup_WE(4,43)
        
        RO.S4I4W0 = zi.2.S4I4 * WrkPctLookup_WE(1,44)
        RO.S4I4W1 = zi.2.S4I4 * WrkPctLookup_WE(2,44)
        RO.S4I4W2 = zi.2.S4I4 * WrkPctLookup_WE(3,44)
        RO.S4I4W3 = zi.2.S4I4 * WrkPctLookup_WE(4,44)
        
        
        RO.S5I1W0 = zi.2.S5I1 * WrkPctLookup_WE(1,51)
        RO.S5I1W1 = zi.2.S5I1 * WrkPctLookup_WE(2,51)
        RO.S5I1W2 = zi.2.S5I1 * WrkPctLookup_WE(3,51)
        RO.S5I1W3 = zi.2.S5I1 * WrkPctLookup_WE(4,51)
        
        RO.S5I2W0 = zi.2.S5I2 * WrkPctLookup_WE(1,52)
        RO.S5I2W1 = zi.2.S5I2 * WrkPctLookup_WE(2,52)
        RO.S5I2W2 = zi.2.S5I2 * WrkPctLookup_WE(3,52)
        RO.S5I2W3 = zi.2.S5I2 * WrkPctLookup_WE(4,52)
        
        RO.S5I3W0 = zi.2.S5I3 * WrkPctLookup_WE(1,53)
        RO.S5I3W1 = zi.2.S5I3 * WrkPctLookup_WE(2,53)
        RO.S5I3W2 = zi.2.S5I3 * WrkPctLookup_WE(3,53)
        RO.S5I3W3 = zi.2.S5I3 * WrkPctLookup_WE(4,53)
        
        RO.S5I4W0 = zi.2.S5I4 * WrkPctLookup_WE(1,54)
        RO.S5I4W1 = zi.2.S5I4 * WrkPctLookup_WE(2,54)
        RO.S5I4W2 = zi.2.S5I4 * WrkPctLookup_WE(3,54)
        RO.S5I4W3 = zi.2.S5I4 * WrkPctLookup_WE(4,54)
        
        
        RO.S6I1W0 = zi.2.S6I1 * WrkPctLookup_WE(1,61)
        RO.S6I1W1 = zi.2.S6I1 * WrkPctLookup_WE(2,61)
        RO.S6I1W2 = zi.2.S6I1 * WrkPctLookup_WE(3,61)
        RO.S6I1W3 = zi.2.S6I1 * WrkPctLookup_WE(4,61)
        
        RO.S6I2W0 = zi.2.S6I2 * WrkPctLookup_WE(1,62)
        RO.S6I2W1 = zi.2.S6I2 * WrkPctLookup_WE(2,62)
        RO.S6I2W2 = zi.2.S6I2 * WrkPctLookup_WE(3,62)
        RO.S6I2W3 = zi.2.S6I2 * WrkPctLookup_WE(4,62)
        
        RO.S6I3W0 = zi.2.S6I3 * WrkPctLookup_WE(1,63)
        RO.S6I3W1 = zi.2.S6I3 * WrkPctLookup_WE(2,63)
        RO.S6I3W2 = zi.2.S6I3 * WrkPctLookup_WE(3,63)
        RO.S6I3W3 = zi.2.S6I3 * WrkPctLookup_WE(4,63)
        
        RO.S6I4W0 = zi.2.S6I4 * WrkPctLookup_WE(1,64)
        RO.S6I4W1 = zi.2.S6I4 * WrkPctLookup_WE(2,64)
        RO.S6I4W2 = zi.2.S6I4 * WrkPctLookup_WE(3,64)
        RO.S6I4W3 = zi.2.S6I4 * WrkPctLookup_WE(4,64)
    
    ;Davis
    elseif (zi.1.CO_FIPS=11)
        RO.S1I1W0 = zi.2.S1I1 * WrkPctLookup_DA(1,11)
        RO.S1I1W1 = zi.2.S1I1 * WrkPctLookup_DA(2,11)
        RO.S1I1W2 = zi.2.S1I1 * WrkPctLookup_DA(3,11)
        RO.S1I1W3 = zi.2.S1I1 * WrkPctLookup_DA(4,11)
        
        RO.S1I2W0 = zi.2.S1I2 * WrkPctLookup_DA(1,12)
        RO.S1I2W1 = zi.2.S1I2 * WrkPctLookup_DA(2,12)
        RO.S1I2W2 = zi.2.S1I2 * WrkPctLookup_DA(3,12)
        RO.S1I2W3 = zi.2.S1I2 * WrkPctLookup_DA(4,12)
        
        RO.S1I3W0 = zi.2.S1I3 * WrkPctLookup_DA(1,13)
        RO.S1I3W1 = zi.2.S1I3 * WrkPctLookup_DA(2,13)
        RO.S1I3W2 = zi.2.S1I3 * WrkPctLookup_DA(3,13)
        RO.S1I3W3 = zi.2.S1I3 * WrkPctLookup_DA(4,13)
        
        RO.S1I4W0 = zi.2.S1I4 * WrkPctLookup_DA(1,14)
        RO.S1I4W1 = zi.2.S1I4 * WrkPctLookup_DA(2,14)
        RO.S1I4W2 = zi.2.S1I4 * WrkPctLookup_DA(3,14)
        RO.S1I4W3 = zi.2.S1I4 * WrkPctLookup_DA(4,14)
        
        
        RO.S2I1W0 = zi.2.S2I1 * WrkPctLookup_DA(1,21)
        RO.S2I1W1 = zi.2.S2I1 * WrkPctLookup_DA(2,21)
        RO.S2I1W2 = zi.2.S2I1 * WrkPctLookup_DA(3,21)
        RO.S2I1W3 = zi.2.S2I1 * WrkPctLookup_DA(4,21)
        
        RO.S2I2W0 = zi.2.S2I2 * WrkPctLookup_DA(1,22)
        RO.S2I2W1 = zi.2.S2I2 * WrkPctLookup_DA(2,22)
        RO.S2I2W2 = zi.2.S2I2 * WrkPctLookup_DA(3,22)
        RO.S2I2W3 = zi.2.S2I2 * WrkPctLookup_DA(4,22)
        
        RO.S2I3W0 = zi.2.S2I3 * WrkPctLookup_DA(1,23)
        RO.S2I3W1 = zi.2.S2I3 * WrkPctLookup_DA(2,23)
        RO.S2I3W2 = zi.2.S2I3 * WrkPctLookup_DA(3,23)
        RO.S2I3W3 = zi.2.S2I3 * WrkPctLookup_DA(4,23)
        
        RO.S2I4W0 = zi.2.S2I4 * WrkPctLookup_DA(1,24)
        RO.S2I4W1 = zi.2.S2I4 * WrkPctLookup_DA(2,24)
        RO.S2I4W2 = zi.2.S2I4 * WrkPctLookup_DA(3,24)
        RO.S2I4W3 = zi.2.S2I4 * WrkPctLookup_DA(4,24)
        
        
        RO.S3I1W0 = zi.2.S3I1 * WrkPctLookup_DA(1,31)
        RO.S3I1W1 = zi.2.S3I1 * WrkPctLookup_DA(2,31)
        RO.S3I1W2 = zi.2.S3I1 * WrkPctLookup_DA(3,31)
        RO.S3I1W3 = zi.2.S3I1 * WrkPctLookup_DA(4,31)
        
        RO.S3I2W0 = zi.2.S3I2 * WrkPctLookup_DA(1,32)
        RO.S3I2W1 = zi.2.S3I2 * WrkPctLookup_DA(2,32)
        RO.S3I2W2 = zi.2.S3I2 * WrkPctLookup_DA(3,32)
        RO.S3I2W3 = zi.2.S3I2 * WrkPctLookup_DA(4,32)
        
        RO.S3I3W0 = zi.2.S3I3 * WrkPctLookup_DA(1,33)
        RO.S3I3W1 = zi.2.S3I3 * WrkPctLookup_DA(2,33)
        RO.S3I3W2 = zi.2.S3I3 * WrkPctLookup_DA(3,33)
        RO.S3I3W3 = zi.2.S3I3 * WrkPctLookup_DA(4,33)
        
        RO.S3I4W0 = zi.2.S3I4 * WrkPctLookup_DA(1,34)
        RO.S3I4W1 = zi.2.S3I4 * WrkPctLookup_DA(2,34)
        RO.S3I4W2 = zi.2.S3I4 * WrkPctLookup_DA(3,34)
        RO.S3I4W3 = zi.2.S3I4 * WrkPctLookup_DA(4,34)
        
        
        RO.S4I1W0 = zi.2.S4I1 * WrkPctLookup_DA(1,41)
        RO.S4I1W1 = zi.2.S4I1 * WrkPctLookup_DA(2,41)
        RO.S4I1W2 = zi.2.S4I1 * WrkPctLookup_DA(3,41)
        RO.S4I1W3 = zi.2.S4I1 * WrkPctLookup_DA(4,41)
        
        RO.S4I2W0 = zi.2.S4I2 * WrkPctLookup_DA(1,42)
        RO.S4I2W1 = zi.2.S4I2 * WrkPctLookup_DA(2,42)
        RO.S4I2W2 = zi.2.S4I2 * WrkPctLookup_DA(3,42)
        RO.S4I2W3 = zi.2.S4I2 * WrkPctLookup_DA(4,42)
        
        RO.S4I3W0 = zi.2.S4I3 * WrkPctLookup_DA(1,43)
        RO.S4I3W1 = zi.2.S4I3 * WrkPctLookup_DA(2,43)
        RO.S4I3W2 = zi.2.S4I3 * WrkPctLookup_DA(3,43)
        RO.S4I3W3 = zi.2.S4I3 * WrkPctLookup_DA(4,43)
        
        RO.S4I4W0 = zi.2.S4I4 * WrkPctLookup_DA(1,44)
        RO.S4I4W1 = zi.2.S4I4 * WrkPctLookup_DA(2,44)
        RO.S4I4W2 = zi.2.S4I4 * WrkPctLookup_DA(3,44)
        RO.S4I4W3 = zi.2.S4I4 * WrkPctLookup_DA(4,44)
        
        
        RO.S5I1W0 = zi.2.S5I1 * WrkPctLookup_DA(1,51)
        RO.S5I1W1 = zi.2.S5I1 * WrkPctLookup_DA(2,51)
        RO.S5I1W2 = zi.2.S5I1 * WrkPctLookup_DA(3,51)
        RO.S5I1W3 = zi.2.S5I1 * WrkPctLookup_DA(4,51)
        
        RO.S5I2W0 = zi.2.S5I2 * WrkPctLookup_DA(1,52)
        RO.S5I2W1 = zi.2.S5I2 * WrkPctLookup_DA(2,52)
        RO.S5I2W2 = zi.2.S5I2 * WrkPctLookup_DA(3,52)
        RO.S5I2W3 = zi.2.S5I2 * WrkPctLookup_DA(4,52)
        
        RO.S5I3W0 = zi.2.S5I3 * WrkPctLookup_DA(1,53)
        RO.S5I3W1 = zi.2.S5I3 * WrkPctLookup_DA(2,53)
        RO.S5I3W2 = zi.2.S5I3 * WrkPctLookup_DA(3,53)
        RO.S5I3W3 = zi.2.S5I3 * WrkPctLookup_DA(4,53)
        
        RO.S5I4W0 = zi.2.S5I4 * WrkPctLookup_DA(1,54)
        RO.S5I4W1 = zi.2.S5I4 * WrkPctLookup_DA(2,54)
        RO.S5I4W2 = zi.2.S5I4 * WrkPctLookup_DA(3,54)
        RO.S5I4W3 = zi.2.S5I4 * WrkPctLookup_DA(4,54)
        
        
        RO.S6I1W0 = zi.2.S6I1 * WrkPctLookup_DA(1,61)
        RO.S6I1W1 = zi.2.S6I1 * WrkPctLookup_DA(2,61)
        RO.S6I1W2 = zi.2.S6I1 * WrkPctLookup_DA(3,61)
        RO.S6I1W3 = zi.2.S6I1 * WrkPctLookup_DA(4,61)
        
        RO.S6I2W0 = zi.2.S6I2 * WrkPctLookup_DA(1,62)
        RO.S6I2W1 = zi.2.S6I2 * WrkPctLookup_DA(2,62)
        RO.S6I2W2 = zi.2.S6I2 * WrkPctLookup_DA(3,62)
        RO.S6I2W3 = zi.2.S6I2 * WrkPctLookup_DA(4,62)
        
        RO.S6I3W0 = zi.2.S6I3 * WrkPctLookup_DA(1,63)
        RO.S6I3W1 = zi.2.S6I3 * WrkPctLookup_DA(2,63)
        RO.S6I3W2 = zi.2.S6I3 * WrkPctLookup_DA(3,63)
        RO.S6I3W3 = zi.2.S6I3 * WrkPctLookup_DA(4,63)
        
        RO.S6I4W0 = zi.2.S6I4 * WrkPctLookup_DA(1,64)
        RO.S6I4W1 = zi.2.S6I4 * WrkPctLookup_DA(2,64)
        RO.S6I4W2 = zi.2.S6I4 * WrkPctLookup_DA(3,64)
        RO.S6I4W3 = zi.2.S6I4 * WrkPctLookup_DA(4,64)
    
    ;Salt Lake
    elseif (zi.1.CO_FIPS=35)
        RO.S1I1W0 = zi.2.S1I1 * WrkPctLookup_SL(1,11)
        RO.S1I1W1 = zi.2.S1I1 * WrkPctLookup_SL(2,11)
        RO.S1I1W2 = zi.2.S1I1 * WrkPctLookup_SL(3,11)
        RO.S1I1W3 = zi.2.S1I1 * WrkPctLookup_SL(4,11)
        
        RO.S1I2W0 = zi.2.S1I2 * WrkPctLookup_SL(1,12)
        RO.S1I2W1 = zi.2.S1I2 * WrkPctLookup_SL(2,12)
        RO.S1I2W2 = zi.2.S1I2 * WrkPctLookup_SL(3,12)
        RO.S1I2W3 = zi.2.S1I2 * WrkPctLookup_SL(4,12)
        
        RO.S1I3W0 = zi.2.S1I3 * WrkPctLookup_SL(1,13)
        RO.S1I3W1 = zi.2.S1I3 * WrkPctLookup_SL(2,13)
        RO.S1I3W2 = zi.2.S1I3 * WrkPctLookup_SL(3,13)
        RO.S1I3W3 = zi.2.S1I3 * WrkPctLookup_SL(4,13)
        
        RO.S1I4W0 = zi.2.S1I4 * WrkPctLookup_SL(1,14)
        RO.S1I4W1 = zi.2.S1I4 * WrkPctLookup_SL(2,14)
        RO.S1I4W2 = zi.2.S1I4 * WrkPctLookup_SL(3,14)
        RO.S1I4W3 = zi.2.S1I4 * WrkPctLookup_SL(4,14)
        
        
        RO.S2I1W0 = zi.2.S2I1 * WrkPctLookup_SL(1,21)
        RO.S2I1W1 = zi.2.S2I1 * WrkPctLookup_SL(2,21)
        RO.S2I1W2 = zi.2.S2I1 * WrkPctLookup_SL(3,21)
        RO.S2I1W3 = zi.2.S2I1 * WrkPctLookup_SL(4,21)
        
        RO.S2I2W0 = zi.2.S2I2 * WrkPctLookup_SL(1,22)
        RO.S2I2W1 = zi.2.S2I2 * WrkPctLookup_SL(2,22)
        RO.S2I2W2 = zi.2.S2I2 * WrkPctLookup_SL(3,22)
        RO.S2I2W3 = zi.2.S2I2 * WrkPctLookup_SL(4,22)
        
        RO.S2I3W0 = zi.2.S2I3 * WrkPctLookup_SL(1,23)
        RO.S2I3W1 = zi.2.S2I3 * WrkPctLookup_SL(2,23)
        RO.S2I3W2 = zi.2.S2I3 * WrkPctLookup_SL(3,23)
        RO.S2I3W3 = zi.2.S2I3 * WrkPctLookup_SL(4,23)
        
        RO.S2I4W0 = zi.2.S2I4 * WrkPctLookup_SL(1,24)
        RO.S2I4W1 = zi.2.S2I4 * WrkPctLookup_SL(2,24)
        RO.S2I4W2 = zi.2.S2I4 * WrkPctLookup_SL(3,24)
        RO.S2I4W3 = zi.2.S2I4 * WrkPctLookup_SL(4,24)
        
        
        RO.S3I1W0 = zi.2.S3I1 * WrkPctLookup_SL(1,31)
        RO.S3I1W1 = zi.2.S3I1 * WrkPctLookup_SL(2,31)
        RO.S3I1W2 = zi.2.S3I1 * WrkPctLookup_SL(3,31)
        RO.S3I1W3 = zi.2.S3I1 * WrkPctLookup_SL(4,31)
        
        RO.S3I2W0 = zi.2.S3I2 * WrkPctLookup_SL(1,32)
        RO.S3I2W1 = zi.2.S3I2 * WrkPctLookup_SL(2,32)
        RO.S3I2W2 = zi.2.S3I2 * WrkPctLookup_SL(3,32)
        RO.S3I2W3 = zi.2.S3I2 * WrkPctLookup_SL(4,32)
        
        RO.S3I3W0 = zi.2.S3I3 * WrkPctLookup_SL(1,33)
        RO.S3I3W1 = zi.2.S3I3 * WrkPctLookup_SL(2,33)
        RO.S3I3W2 = zi.2.S3I3 * WrkPctLookup_SL(3,33)
        RO.S3I3W3 = zi.2.S3I3 * WrkPctLookup_SL(4,33)
        
        RO.S3I4W0 = zi.2.S3I4 * WrkPctLookup_SL(1,34)
        RO.S3I4W1 = zi.2.S3I4 * WrkPctLookup_SL(2,34)
        RO.S3I4W2 = zi.2.S3I4 * WrkPctLookup_SL(3,34)
        RO.S3I4W3 = zi.2.S3I4 * WrkPctLookup_SL(4,34)
        
        
        RO.S4I1W0 = zi.2.S4I1 * WrkPctLookup_SL(1,41)
        RO.S4I1W1 = zi.2.S4I1 * WrkPctLookup_SL(2,41)
        RO.S4I1W2 = zi.2.S4I1 * WrkPctLookup_SL(3,41)
        RO.S4I1W3 = zi.2.S4I1 * WrkPctLookup_SL(4,41)
        
        RO.S4I2W0 = zi.2.S4I2 * WrkPctLookup_SL(1,42)
        RO.S4I2W1 = zi.2.S4I2 * WrkPctLookup_SL(2,42)
        RO.S4I2W2 = zi.2.S4I2 * WrkPctLookup_SL(3,42)
        RO.S4I2W3 = zi.2.S4I2 * WrkPctLookup_SL(4,42)
        
        RO.S4I3W0 = zi.2.S4I3 * WrkPctLookup_SL(1,43)
        RO.S4I3W1 = zi.2.S4I3 * WrkPctLookup_SL(2,43)
        RO.S4I3W2 = zi.2.S4I3 * WrkPctLookup_SL(3,43)
        RO.S4I3W3 = zi.2.S4I3 * WrkPctLookup_SL(4,43)
        
        RO.S4I4W0 = zi.2.S4I4 * WrkPctLookup_SL(1,44)
        RO.S4I4W1 = zi.2.S4I4 * WrkPctLookup_SL(2,44)
        RO.S4I4W2 = zi.2.S4I4 * WrkPctLookup_SL(3,44)
        RO.S4I4W3 = zi.2.S4I4 * WrkPctLookup_SL(4,44)
        
        
        RO.S5I1W0 = zi.2.S5I1 * WrkPctLookup_SL(1,51)
        RO.S5I1W1 = zi.2.S5I1 * WrkPctLookup_SL(2,51)
        RO.S5I1W2 = zi.2.S5I1 * WrkPctLookup_SL(3,51)
        RO.S5I1W3 = zi.2.S5I1 * WrkPctLookup_SL(4,51)
        
        RO.S5I2W0 = zi.2.S5I2 * WrkPctLookup_SL(1,52)
        RO.S5I2W1 = zi.2.S5I2 * WrkPctLookup_SL(2,52)
        RO.S5I2W2 = zi.2.S5I2 * WrkPctLookup_SL(3,52)
        RO.S5I2W3 = zi.2.S5I2 * WrkPctLookup_SL(4,52)
        
        RO.S5I3W0 = zi.2.S5I3 * WrkPctLookup_SL(1,53)
        RO.S5I3W1 = zi.2.S5I3 * WrkPctLookup_SL(2,53)
        RO.S5I3W2 = zi.2.S5I3 * WrkPctLookup_SL(3,53)
        RO.S5I3W3 = zi.2.S5I3 * WrkPctLookup_SL(4,53)
        
        RO.S5I4W0 = zi.2.S5I4 * WrkPctLookup_SL(1,54)
        RO.S5I4W1 = zi.2.S5I4 * WrkPctLookup_SL(2,54)
        RO.S5I4W2 = zi.2.S5I4 * WrkPctLookup_SL(3,54)
        RO.S5I4W3 = zi.2.S5I4 * WrkPctLookup_SL(4,54)
        
        
        RO.S6I1W0 = zi.2.S6I1 * WrkPctLookup_SL(1,61)
        RO.S6I1W1 = zi.2.S6I1 * WrkPctLookup_SL(2,61)
        RO.S6I1W2 = zi.2.S6I1 * WrkPctLookup_SL(3,61)
        RO.S6I1W3 = zi.2.S6I1 * WrkPctLookup_SL(4,61)
        
        RO.S6I2W0 = zi.2.S6I2 * WrkPctLookup_SL(1,62)
        RO.S6I2W1 = zi.2.S6I2 * WrkPctLookup_SL(2,62)
        RO.S6I2W2 = zi.2.S6I2 * WrkPctLookup_SL(3,62)
        RO.S6I2W3 = zi.2.S6I2 * WrkPctLookup_SL(4,62)
        
        RO.S6I3W0 = zi.2.S6I3 * WrkPctLookup_SL(1,63)
        RO.S6I3W1 = zi.2.S6I3 * WrkPctLookup_SL(2,63)
        RO.S6I3W2 = zi.2.S6I3 * WrkPctLookup_SL(3,63)
        RO.S6I3W3 = zi.2.S6I3 * WrkPctLookup_SL(4,63)
        
        RO.S6I4W0 = zi.2.S6I4 * WrkPctLookup_SL(1,64)
        RO.S6I4W1 = zi.2.S6I4 * WrkPctLookup_SL(2,64)
        RO.S6I4W2 = zi.2.S6I4 * WrkPctLookup_SL(3,64)
        RO.S6I4W3 = zi.2.S6I4 * WrkPctLookup_SL(4,64)
    
    ;Utah (MAG MPO) ----------------------------------------------------------------------
    elseif (zi.1.CO_FIPS=49)
        RO.S1I1W0 = zi.2.S1I1 * WrkPctLookup_UT(1,11)
        RO.S1I1W1 = zi.2.S1I1 * WrkPctLookup_UT(2,11)
        RO.S1I1W2 = zi.2.S1I1 * WrkPctLookup_UT(3,11)
        RO.S1I1W3 = zi.2.S1I1 * WrkPctLookup_UT(4,11)
        
        RO.S1I2W0 = zi.2.S1I2 * WrkPctLookup_UT(1,12)
        RO.S1I2W1 = zi.2.S1I2 * WrkPctLookup_UT(2,12)
        RO.S1I2W2 = zi.2.S1I2 * WrkPctLookup_UT(3,12)
        RO.S1I2W3 = zi.2.S1I2 * WrkPctLookup_UT(4,12)
        
        RO.S1I3W0 = zi.2.S1I3 * WrkPctLookup_UT(1,13)
        RO.S1I3W1 = zi.2.S1I3 * WrkPctLookup_UT(2,13)
        RO.S1I3W2 = zi.2.S1I3 * WrkPctLookup_UT(3,13)
        RO.S1I3W3 = zi.2.S1I3 * WrkPctLookup_UT(4,13)
        
        RO.S1I4W0 = zi.2.S1I4 * WrkPctLookup_UT(1,14)
        RO.S1I4W1 = zi.2.S1I4 * WrkPctLookup_UT(2,14)
        RO.S1I4W2 = zi.2.S1I4 * WrkPctLookup_UT(3,14)
        RO.S1I4W3 = zi.2.S1I4 * WrkPctLookup_UT(4,14)
        
        
        RO.S2I1W0 = zi.2.S2I1 * WrkPctLookup_UT(1,21)
        RO.S2I1W1 = zi.2.S2I1 * WrkPctLookup_UT(2,21)
        RO.S2I1W2 = zi.2.S2I1 * WrkPctLookup_UT(3,21)
        RO.S2I1W3 = zi.2.S2I1 * WrkPctLookup_UT(4,21)
        
        RO.S2I2W0 = zi.2.S2I2 * WrkPctLookup_UT(1,22)
        RO.S2I2W1 = zi.2.S2I2 * WrkPctLookup_UT(2,22)
        RO.S2I2W2 = zi.2.S2I2 * WrkPctLookup_UT(3,22)
        RO.S2I2W3 = zi.2.S2I2 * WrkPctLookup_UT(4,22)
        
        RO.S2I3W0 = zi.2.S2I3 * WrkPctLookup_UT(1,23)
        RO.S2I3W1 = zi.2.S2I3 * WrkPctLookup_UT(2,23)
        RO.S2I3W2 = zi.2.S2I3 * WrkPctLookup_UT(3,23)
        RO.S2I3W3 = zi.2.S2I3 * WrkPctLookup_UT(4,23)
        
        RO.S2I4W0 = zi.2.S2I4 * WrkPctLookup_UT(1,24)
        RO.S2I4W1 = zi.2.S2I4 * WrkPctLookup_UT(2,24)
        RO.S2I4W2 = zi.2.S2I4 * WrkPctLookup_UT(3,24)
        RO.S2I4W3 = zi.2.S2I4 * WrkPctLookup_UT(4,24)
        
        
        RO.S3I1W0 = zi.2.S3I1 * WrkPctLookup_UT(1,31)
        RO.S3I1W1 = zi.2.S3I1 * WrkPctLookup_UT(2,31)
        RO.S3I1W2 = zi.2.S3I1 * WrkPctLookup_UT(3,31)
        RO.S3I1W3 = zi.2.S3I1 * WrkPctLookup_UT(4,31)
        
        RO.S3I2W0 = zi.2.S3I2 * WrkPctLookup_UT(1,32)
        RO.S3I2W1 = zi.2.S3I2 * WrkPctLookup_UT(2,32)
        RO.S3I2W2 = zi.2.S3I2 * WrkPctLookup_UT(3,32)
        RO.S3I2W3 = zi.2.S3I2 * WrkPctLookup_UT(4,32)
        
        RO.S3I3W0 = zi.2.S3I3 * WrkPctLookup_UT(1,33)
        RO.S3I3W1 = zi.2.S3I3 * WrkPctLookup_UT(2,33)
        RO.S3I3W2 = zi.2.S3I3 * WrkPctLookup_UT(3,33)
        RO.S3I3W3 = zi.2.S3I3 * WrkPctLookup_UT(4,33)
        
        RO.S3I4W0 = zi.2.S3I4 * WrkPctLookup_UT(1,34)
        RO.S3I4W1 = zi.2.S3I4 * WrkPctLookup_UT(2,34)
        RO.S3I4W2 = zi.2.S3I4 * WrkPctLookup_UT(3,34)
        RO.S3I4W3 = zi.2.S3I4 * WrkPctLookup_UT(4,34)
        
        
        RO.S4I1W0 = zi.2.S4I1 * WrkPctLookup_UT(1,41)
        RO.S4I1W1 = zi.2.S4I1 * WrkPctLookup_UT(2,41)
        RO.S4I1W2 = zi.2.S4I1 * WrkPctLookup_UT(3,41)
        RO.S4I1W3 = zi.2.S4I1 * WrkPctLookup_UT(4,41)
        
        RO.S4I2W0 = zi.2.S4I2 * WrkPctLookup_UT(1,42)
        RO.S4I2W1 = zi.2.S4I2 * WrkPctLookup_UT(2,42)
        RO.S4I2W2 = zi.2.S4I2 * WrkPctLookup_UT(3,42)
        RO.S4I2W3 = zi.2.S4I2 * WrkPctLookup_UT(4,42)
        
        RO.S4I3W0 = zi.2.S4I3 * WrkPctLookup_UT(1,43)
        RO.S4I3W1 = zi.2.S4I3 * WrkPctLookup_UT(2,43)
        RO.S4I3W2 = zi.2.S4I3 * WrkPctLookup_UT(3,43)
        RO.S4I3W3 = zi.2.S4I3 * WrkPctLookup_UT(4,43)
        
        RO.S4I4W0 = zi.2.S4I4 * WrkPctLookup_UT(1,44)
        RO.S4I4W1 = zi.2.S4I4 * WrkPctLookup_UT(2,44)
        RO.S4I4W2 = zi.2.S4I4 * WrkPctLookup_UT(3,44)
        RO.S4I4W3 = zi.2.S4I4 * WrkPctLookup_UT(4,44)
        
        
        RO.S5I1W0 = zi.2.S5I1 * WrkPctLookup_UT(1,51)
        RO.S5I1W1 = zi.2.S5I1 * WrkPctLookup_UT(2,51)
        RO.S5I1W2 = zi.2.S5I1 * WrkPctLookup_UT(3,51)
        RO.S5I1W3 = zi.2.S5I1 * WrkPctLookup_UT(4,51)
        
        RO.S5I2W0 = zi.2.S5I2 * WrkPctLookup_UT(1,52)
        RO.S5I2W1 = zi.2.S5I2 * WrkPctLookup_UT(2,52)
        RO.S5I2W2 = zi.2.S5I2 * WrkPctLookup_UT(3,52)
        RO.S5I2W3 = zi.2.S5I2 * WrkPctLookup_UT(4,52)
        
        RO.S5I3W0 = zi.2.S5I3 * WrkPctLookup_UT(1,53)
        RO.S5I3W1 = zi.2.S5I3 * WrkPctLookup_UT(2,53)
        RO.S5I3W2 = zi.2.S5I3 * WrkPctLookup_UT(3,53)
        RO.S5I3W3 = zi.2.S5I3 * WrkPctLookup_UT(4,53)
        
        RO.S5I4W0 = zi.2.S5I4 * WrkPctLookup_UT(1,54)
        RO.S5I4W1 = zi.2.S5I4 * WrkPctLookup_UT(2,54)
        RO.S5I4W2 = zi.2.S5I4 * WrkPctLookup_UT(3,54)
        RO.S5I4W3 = zi.2.S5I4 * WrkPctLookup_UT(4,54)
        
        
        RO.S6I1W0 = zi.2.S6I1 * WrkPctLookup_UT(1,61)
        RO.S6I1W1 = zi.2.S6I1 * WrkPctLookup_UT(2,61)
        RO.S6I1W2 = zi.2.S6I1 * WrkPctLookup_UT(3,61)
        RO.S6I1W3 = zi.2.S6I1 * WrkPctLookup_UT(4,61)
        
        RO.S6I2W0 = zi.2.S6I2 * WrkPctLookup_UT(1,62)
        RO.S6I2W1 = zi.2.S6I2 * WrkPctLookup_UT(2,62)
        RO.S6I2W2 = zi.2.S6I2 * WrkPctLookup_UT(3,62)
        RO.S6I2W3 = zi.2.S6I2 * WrkPctLookup_UT(4,62)
        
        RO.S6I3W0 = zi.2.S6I3 * WrkPctLookup_UT(1,63)
        RO.S6I3W1 = zi.2.S6I3 * WrkPctLookup_UT(2,63)
        RO.S6I3W2 = zi.2.S6I3 * WrkPctLookup_UT(3,63)
        RO.S6I3W3 = zi.2.S6I3 * WrkPctLookup_UT(4,63)
        
        RO.S6I4W0 = zi.2.S6I4 * WrkPctLookup_UT(1,64)
        RO.S6I4W1 = zi.2.S6I4 * WrkPctLookup_UT(2,64)
        RO.S6I4W2 = zi.2.S6I4 * WrkPctLookup_UT(3,64)
        RO.S6I4W3 = zi.2.S6I4 * WrkPctLookup_UT(4,64)
    
    ;Box Elder
    else
        RO.S1I1W0 = zi.2.S1I1 * WrkPctLookup_BE(1,11)
        RO.S1I1W1 = zi.2.S1I1 * WrkPctLookup_BE(2,11)
        RO.S1I1W2 = zi.2.S1I1 * WrkPctLookup_BE(3,11)
        RO.S1I1W3 = zi.2.S1I1 * WrkPctLookup_BE(4,11)
        
        RO.S1I2W0 = zi.2.S1I2 * WrkPctLookup_BE(1,12)
        RO.S1I2W1 = zi.2.S1I2 * WrkPctLookup_BE(2,12)
        RO.S1I2W2 = zi.2.S1I2 * WrkPctLookup_BE(3,12)
        RO.S1I2W3 = zi.2.S1I2 * WrkPctLookup_BE(4,12)
        
        RO.S1I3W0 = zi.2.S1I3 * WrkPctLookup_BE(1,13)
        RO.S1I3W1 = zi.2.S1I3 * WrkPctLookup_BE(2,13)
        RO.S1I3W2 = zi.2.S1I3 * WrkPctLookup_BE(3,13)
        RO.S1I3W3 = zi.2.S1I3 * WrkPctLookup_BE(4,13)
        
        RO.S1I4W0 = zi.2.S1I4 * WrkPctLookup_BE(1,14)
        RO.S1I4W1 = zi.2.S1I4 * WrkPctLookup_BE(2,14)
        RO.S1I4W2 = zi.2.S1I4 * WrkPctLookup_BE(3,14)
        RO.S1I4W3 = zi.2.S1I4 * WrkPctLookup_BE(4,14)
        
        
        RO.S2I1W0 = zi.2.S2I1 * WrkPctLookup_BE(1,21)
        RO.S2I1W1 = zi.2.S2I1 * WrkPctLookup_BE(2,21)
        RO.S2I1W2 = zi.2.S2I1 * WrkPctLookup_BE(3,21)
        RO.S2I1W3 = zi.2.S2I1 * WrkPctLookup_BE(4,21)
        
        RO.S2I2W0 = zi.2.S2I2 * WrkPctLookup_BE(1,22)
        RO.S2I2W1 = zi.2.S2I2 * WrkPctLookup_BE(2,22)
        RO.S2I2W2 = zi.2.S2I2 * WrkPctLookup_BE(3,22)
        RO.S2I2W3 = zi.2.S2I2 * WrkPctLookup_BE(4,22)
        
        RO.S2I3W0 = zi.2.S2I3 * WrkPctLookup_BE(1,23)
        RO.S2I3W1 = zi.2.S2I3 * WrkPctLookup_BE(2,23)
        RO.S2I3W2 = zi.2.S2I3 * WrkPctLookup_BE(3,23)
        RO.S2I3W3 = zi.2.S2I3 * WrkPctLookup_BE(4,23)
        
        RO.S2I4W0 = zi.2.S2I4 * WrkPctLookup_BE(1,24)
        RO.S2I4W1 = zi.2.S2I4 * WrkPctLookup_BE(2,24)
        RO.S2I4W2 = zi.2.S2I4 * WrkPctLookup_BE(3,24)
        RO.S2I4W3 = zi.2.S2I4 * WrkPctLookup_BE(4,24)
        
        
        RO.S3I1W0 = zi.2.S3I1 * WrkPctLookup_BE(1,31)
        RO.S3I1W1 = zi.2.S3I1 * WrkPctLookup_BE(2,31)
        RO.S3I1W2 = zi.2.S3I1 * WrkPctLookup_BE(3,31)
        RO.S3I1W3 = zi.2.S3I1 * WrkPctLookup_BE(4,31)
        
        RO.S3I2W0 = zi.2.S3I2 * WrkPctLookup_BE(1,32)
        RO.S3I2W1 = zi.2.S3I2 * WrkPctLookup_BE(2,32)
        RO.S3I2W2 = zi.2.S3I2 * WrkPctLookup_BE(3,32)
        RO.S3I2W3 = zi.2.S3I2 * WrkPctLookup_BE(4,32)
        
        RO.S3I3W0 = zi.2.S3I3 * WrkPctLookup_BE(1,33)
        RO.S3I3W1 = zi.2.S3I3 * WrkPctLookup_BE(2,33)
        RO.S3I3W2 = zi.2.S3I3 * WrkPctLookup_BE(3,33)
        RO.S3I3W3 = zi.2.S3I3 * WrkPctLookup_BE(4,33)
        
        RO.S3I4W0 = zi.2.S3I4 * WrkPctLookup_BE(1,34)
        RO.S3I4W1 = zi.2.S3I4 * WrkPctLookup_BE(2,34)
        RO.S3I4W2 = zi.2.S3I4 * WrkPctLookup_BE(3,34)
        RO.S3I4W3 = zi.2.S3I4 * WrkPctLookup_BE(4,34)
        
        
        RO.S4I1W0 = zi.2.S4I1 * WrkPctLookup_BE(1,41)
        RO.S4I1W1 = zi.2.S4I1 * WrkPctLookup_BE(2,41)
        RO.S4I1W2 = zi.2.S4I1 * WrkPctLookup_BE(3,41)
        RO.S4I1W3 = zi.2.S4I1 * WrkPctLookup_BE(4,41)
        
        RO.S4I2W0 = zi.2.S4I2 * WrkPctLookup_BE(1,42)
        RO.S4I2W1 = zi.2.S4I2 * WrkPctLookup_BE(2,42)
        RO.S4I2W2 = zi.2.S4I2 * WrkPctLookup_BE(3,42)
        RO.S4I2W3 = zi.2.S4I2 * WrkPctLookup_BE(4,42)
        
        RO.S4I3W0 = zi.2.S4I3 * WrkPctLookup_BE(1,43)
        RO.S4I3W1 = zi.2.S4I3 * WrkPctLookup_BE(2,43)
        RO.S4I3W2 = zi.2.S4I3 * WrkPctLookup_BE(3,43)
        RO.S4I3W3 = zi.2.S4I3 * WrkPctLookup_BE(4,43)
        
        RO.S4I4W0 = zi.2.S4I4 * WrkPctLookup_BE(1,44)
        RO.S4I4W1 = zi.2.S4I4 * WrkPctLookup_BE(2,44)
        RO.S4I4W2 = zi.2.S4I4 * WrkPctLookup_BE(3,44)
        RO.S4I4W3 = zi.2.S4I4 * WrkPctLookup_BE(4,44)
        
        
        RO.S5I1W0 = zi.2.S5I1 * WrkPctLookup_BE(1,51)
        RO.S5I1W1 = zi.2.S5I1 * WrkPctLookup_BE(2,51)
        RO.S5I1W2 = zi.2.S5I1 * WrkPctLookup_BE(3,51)
        RO.S5I1W3 = zi.2.S5I1 * WrkPctLookup_BE(4,51)
        
        RO.S5I2W0 = zi.2.S5I2 * WrkPctLookup_BE(1,52)
        RO.S5I2W1 = zi.2.S5I2 * WrkPctLookup_BE(2,52)
        RO.S5I2W2 = zi.2.S5I2 * WrkPctLookup_BE(3,52)
        RO.S5I2W3 = zi.2.S5I2 * WrkPctLookup_BE(4,52)
        
        RO.S5I3W0 = zi.2.S5I3 * WrkPctLookup_BE(1,53)
        RO.S5I3W1 = zi.2.S5I3 * WrkPctLookup_BE(2,53)
        RO.S5I3W2 = zi.2.S5I3 * WrkPctLookup_BE(3,53)
        RO.S5I3W3 = zi.2.S5I3 * WrkPctLookup_BE(4,53)
        
        RO.S5I4W0 = zi.2.S5I4 * WrkPctLookup_BE(1,54)
        RO.S5I4W1 = zi.2.S5I4 * WrkPctLookup_BE(2,54)
        RO.S5I4W2 = zi.2.S5I4 * WrkPctLookup_BE(3,54)
        RO.S5I4W3 = zi.2.S5I4 * WrkPctLookup_BE(4,54)
        
        
        RO.S6I1W0 = zi.2.S6I1 * WrkPctLookup_BE(1,61)
        RO.S6I1W1 = zi.2.S6I1 * WrkPctLookup_BE(2,61)
        RO.S6I1W2 = zi.2.S6I1 * WrkPctLookup_BE(3,61)
        RO.S6I1W3 = zi.2.S6I1 * WrkPctLookup_BE(4,61)
        
        RO.S6I2W0 = zi.2.S6I2 * WrkPctLookup_BE(1,62)
        RO.S6I2W1 = zi.2.S6I2 * WrkPctLookup_BE(2,62)
        RO.S6I2W2 = zi.2.S6I2 * WrkPctLookup_BE(3,62)
        RO.S6I2W3 = zi.2.S6I2 * WrkPctLookup_BE(4,62)
        
        RO.S6I3W0 = zi.2.S6I3 * WrkPctLookup_BE(1,63)
        RO.S6I3W1 = zi.2.S6I3 * WrkPctLookup_BE(2,63)
        RO.S6I3W2 = zi.2.S6I3 * WrkPctLookup_BE(3,63)
        RO.S6I3W3 = zi.2.S6I3 * WrkPctLookup_BE(4,63)
        
        RO.S6I4W0 = zi.2.S6I4 * WrkPctLookup_BE(1,64)
        RO.S6I4W1 = zi.2.S6I4 * WrkPctLookup_BE(2,64)
        RO.S6I4W2 = zi.2.S6I4 * WrkPctLookup_BE(3,64)
        RO.S6I4W3 = zi.2.S6I4 * WrkPctLookup_BE(4,64)
    
    endif
    
    
    RO.SumHH = RO.S1I1W0 + RO.S1I1W1 + RO.S1I1W2 + RO.S1I1W3 + 
               RO.S1I2W0 + RO.S1I2W1 + RO.S1I2W2 + RO.S1I2W3 + 
               RO.S1I3W0 + RO.S1I3W1 + RO.S1I3W2 + RO.S1I3W3 + 
               RO.S1I4W0 + RO.S1I4W1 + RO.S1I4W2 + RO.S1I4W3 +
                
               RO.S2I1W0 + RO.S2I1W1 + RO.S2I1W2 + RO.S2I1W3 + 
               RO.S2I2W0 + RO.S2I2W1 + RO.S2I2W2 + RO.S2I2W3 + 
               RO.S2I3W0 + RO.S2I3W1 + RO.S2I3W2 + RO.S2I3W3 + 
               RO.S2I4W0 + RO.S2I4W1 + RO.S2I4W2 + RO.S2I4W3 + 
               
               RO.S3I1W0 + RO.S3I1W1 + RO.S3I1W2 + RO.S3I1W3 + 
               RO.S3I2W0 + RO.S3I2W1 + RO.S3I2W2 + RO.S3I2W3 + 
               RO.S3I3W0 + RO.S3I3W1 + RO.S3I3W2 + RO.S3I3W3 + 
               RO.S3I4W0 + RO.S3I4W1 + RO.S3I4W2 + RO.S3I4W3 + 
               
               RO.S4I1W0 + RO.S4I1W1 + RO.S4I1W2 + RO.S4I1W3 + 
               RO.S4I2W0 + RO.S4I2W1 + RO.S4I2W2 + RO.S4I2W3 + 
               RO.S4I3W0 + RO.S4I3W1 + RO.S4I3W2 + RO.S4I3W3 + 
               RO.S4I4W0 + RO.S4I4W1 + RO.S4I4W2 + RO.S4I4W3 + 
               
               RO.S5I1W0 + RO.S5I1W1 + RO.S5I1W2 + RO.S5I1W3 + 
               RO.S5I2W0 + RO.S5I2W1 + RO.S5I2W2 + RO.S5I2W3 + 
               RO.S5I3W0 + RO.S5I3W1 + RO.S5I3W2 + RO.S5I3W3 + 
               RO.S5I4W0 + RO.S5I4W1 + RO.S5I4W2 + RO.S5I4W3 + 
               
               RO.S6I1W0 + RO.S6I1W1 + RO.S6I1W2 + RO.S6I1W3 + 
               RO.S6I2W0 + RO.S6I2W1 + RO.S6I2W2 + RO.S6I2W3 + 
               RO.S6I3W0 + RO.S6I3W1 + RO.S6I3W2 + RO.S6I3W3 + 
               RO.S6I4W0 + RO.S6I4W1 + RO.S6I4W2 + RO.S6I4W3
    
    
    ;write output files
    WRITE  RECO=3
    
    
    ;calculate joint HHSize_IncomeHiLo_Worker distribution
    RO.S1ILW0 = RO.S1I1W0
    RO.S1ILW1 = RO.S1I1W1
    RO.S1ILW2 = RO.S1I1W2
    RO.S1ILW3 = RO.S1I1W3
    
    RO.S1IHW0 = RO.S1I2W0 + RO.S1I3W0 + RO.S1I4W0
    RO.S1IHW1 = RO.S1I2W1 + RO.S1I3W1 + RO.S1I4W1
    RO.S1IHW2 = RO.S1I2W2 + RO.S1I3W2 + RO.S1I4W2
    RO.S1IHW3 = RO.S1I2W3 + RO.S1I3W3 + RO.S1I4W3
    
    RO.S2ILW0 = RO.S2I1W0
    RO.S2ILW1 = RO.S2I1W1
    RO.S2ILW2 = RO.S2I1W2
    RO.S2ILW3 = RO.S2I1W3
    
    RO.S2IHW0 = RO.S2I2W0 + RO.S2I3W0 + RO.S2I4W0
    RO.S2IHW1 = RO.S2I2W1 + RO.S2I3W1 + RO.S2I4W1
    RO.S2IHW2 = RO.S2I2W2 + RO.S2I3W2 + RO.S2I4W2
    RO.S2IHW3 = RO.S2I2W3 + RO.S2I3W3 + RO.S2I4W3
    
    RO.S3ILW0 = RO.S3I1W0
    RO.S3ILW1 = RO.S3I1W1
    RO.S3ILW2 = RO.S3I1W2
    RO.S3ILW3 = RO.S3I1W3
    
    RO.S3IHW0 = RO.S3I2W0 + RO.S3I3W0 + RO.S3I4W0
    RO.S3IHW1 = RO.S3I2W1 + RO.S3I3W1 + RO.S3I4W1
    RO.S3IHW2 = RO.S3I2W2 + RO.S3I3W2 + RO.S3I4W2
    RO.S3IHW3 = RO.S3I2W3 + RO.S3I3W3 + RO.S3I4W3
    
    RO.S4ILW0 = RO.S4I1W0
    RO.S4ILW1 = RO.S4I1W1
    RO.S4ILW2 = RO.S4I1W2
    RO.S4ILW3 = RO.S4I1W3
    
    RO.S4IHW0 = RO.S4I2W0 + RO.S4I3W0 + RO.S4I4W0
    RO.S4IHW1 = RO.S4I2W1 + RO.S4I3W1 + RO.S4I4W1
    RO.S4IHW2 = RO.S4I2W2 + RO.S4I3W2 + RO.S4I4W2
    RO.S4IHW3 = RO.S4I2W3 + RO.S4I3W3 + RO.S4I4W3
    
    RO.S5ILW0 = RO.S5I1W0
    RO.S5ILW1 = RO.S5I1W1
    RO.S5ILW2 = RO.S5I1W2
    RO.S5ILW3 = RO.S5I1W3
    
    RO.S5IHW0 = RO.S5I2W0 + RO.S5I3W0 + RO.S5I4W0
    RO.S5IHW1 = RO.S5I2W1 + RO.S5I3W1 + RO.S5I4W1
    RO.S5IHW2 = RO.S5I2W2 + RO.S5I3W2 + RO.S5I4W2
    RO.S5IHW3 = RO.S5I2W3 + RO.S5I3W3 + RO.S5I4W3
    
    RO.S6ILW0 = RO.S6I1W0
    RO.S6ILW1 = RO.S6I1W1
    RO.S6ILW2 = RO.S6I1W2
    RO.S6ILW3 = RO.S6I1W3
    
    RO.S6IHW0 = RO.S6I2W0 + RO.S6I3W0 + RO.S6I4W0
    RO.S6IHW1 = RO.S6I2W1 + RO.S6I3W1 + RO.S6I4W1
    RO.S6IHW2 = RO.S6I2W2 + RO.S6I3W2 + RO.S6I4W2
    RO.S6IHW3 = RO.S6I2W3 + RO.S6I3W3 + RO.S6I4W3
    
    RO.SumHH = RO.S1ILW0 + RO.S1ILW1 + RO.S1ILW2 + RO.S1ILW3 + 
               RO.S1IHW0 + RO.S1IHW1 + RO.S1IHW2 + RO.S1IHW3 + 
               
               RO.S2ILW0 + RO.S2ILW1 + RO.S2ILW2 + RO.S2ILW3 + 
               RO.S2IHW0 + RO.S2IHW1 + RO.S2IHW2 + RO.S2IHW3 + 
               
               RO.S3ILW0 + RO.S3ILW1 + RO.S3ILW2 + RO.S3ILW3 + 
               RO.S3IHW0 + RO.S3IHW1 + RO.S3IHW2 + RO.S3IHW3 + 
               
               RO.S4ILW0 + RO.S4ILW1 + RO.S4ILW2 + RO.S4ILW3 + 
               RO.S4IHW0 + RO.S4IHW1 + RO.S4IHW2 + RO.S4IHW3 + 
               
               RO.S5ILW0 + RO.S5ILW1 + RO.S5ILW2 + RO.S5ILW3 + 
               RO.S5IHW0 + RO.S5IHW1 + RO.S5IHW2 + RO.S5IHW3 + 
               
               RO.S6ILW0 + RO.S6ILW1 + RO.S6ILW2 + RO.S6ILW3 + 
               RO.S6IHW0 + RO.S6IHW1 + RO.S6IHW2 + RO.S6IHW3
    
    
    ;write out joint HHSize_IncomeHiLo_Worker file
    WRITE  RECO=2
    
    
    
    ;calculate marginal worker distribution
    RO.Wrk0 = RO.S1ILW0 + RO.S1IHW0 + RO.S2ILW0 + RO.S2IHW0 + RO.S3ILW0 + RO.S3IHW0 + 
              RO.S4ILW0 + RO.S4IHW0 + RO.S5ILW0 + RO.S5IHW0 + RO.S6ILW0 + RO.S6IHW0
    
    RO.Wrk1 = RO.S1ILW1 + RO.S1IHW1 + RO.S2ILW1 + RO.S2IHW1 + RO.S3ILW1 + RO.S3IHW1 + 
              RO.S4ILW1 + RO.S4IHW1 + RO.S5ILW1 + RO.S5IHW1 + RO.S6ILW1 + RO.S6IHW1
    
    RO.Wrk2 = RO.S1ILW2 + RO.S1IHW2 + RO.S2ILW2 + RO.S2IHW2 + RO.S3ILW2 + RO.S3IHW2 + 
              RO.S4ILW2 + RO.S4IHW2 + RO.S5ILW2 + RO.S5IHW2 + RO.S6ILW2 + RO.S6IHW2
    
    RO.Wrk3 = RO.S1ILW3 + RO.S1IHW3 + RO.S2ILW3 + RO.S2IHW3 + RO.S3ILW3 + RO.S3IHW3 + 
              RO.S4ILW3 + RO.S4IHW3 + RO.S5ILW3 + RO.S5IHW3 + RO.S6ILW3 + RO.S6IHW3
    
    RO.SumHH = RO.Wrk0 + 
               RO.Wrk1 + 
               RO.Wrk2 + 
               RO.Wrk3
    
    RO.TOTWRK = (RO.Wrk0 * 0) + 
                (RO.Wrk1 * 1) + 
                (RO.Wrk2 * 2)+ 
                (RO.Wrk3 * @AveNum3PlusWrks@)
    
    TotHH_Wrk0   = TotHH_Wrk0   + RO.Wrk0
    TotHH_Wrk1   = TotHH_Wrk1   + RO.Wrk1
    TotHH_Wrk2   = TotHH_Wrk2   + RO.Wrk2
    TotHH_Wrk3   = TotHH_Wrk3   + RO.Wrk3
    TotHH_SumWrk = TotHH_SumWrk + RO.SumHH
    
    
    ;write out marginal worker file
    WRITE  RECO=1
    
    
    ;print to LOG file
    if (I=ZONES)
        PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
            APPEND=T,
            LIST='Worker Group Totals\n',
                 '    Total HH in Wrk0:           ', TotHH_Wrk0(10.0C), TotHH_Wrk0/TotHH_SumWrk*100(10.1), '%\n',
                 '    Total HH in Wrk1:           ', TotHH_Wrk1(10.0C), TotHH_Wrk1/TotHH_SumWrk*100(10.1), '%\n',
                 '    Total HH in Wrk2:           ', TotHH_Wrk2(10.0C), TotHH_Wrk2/TotHH_SumWrk*100(10.1), '%\n',
                 '    Total HH in Wrk3:           ', TotHH_Wrk3(10.0C), TotHH_Wrk3/TotHH_SumWrk*100(10.1), '%\n',
                 '    Total HH (sum Wrk Groups):  ', TotHH_SumWrk(10.0C), TotHH_SumWrk/TotalHH(10.4), '\n',
                 '\n'
    endif

ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Household Disaggregation           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 2_HHDisaggregation.txt)
