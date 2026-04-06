
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_DemographicAnalysis.txt)



;get start time
ScriptStartTime = currenttime()



RUN PGM=MATRIX  MSG='SE Processing 1: demographic analysis - create SE data for this scenario'
    FILEI DBI[1] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
        AUTOARRAY=ALLFIELDS,
        SORT=TAZID
    
    FILEI DBI[2] = '@ParentDir@1_Inputs\2_SEData\@BE_SEFile@',
        DELIMITER =',',
        CO_TAZID     = #01,
        Index        =  02,
        TOTHH        =  03,
        HHPOP        =  04,
        HHSIZE       =  05,
        TOTEMP       =  06,
        RETEMP       =  07,
        INDEMP       =  08,
        OTHEMP       =  09,
        ALLEMP       =  10,
        RETL         =  11,
        FOOD         =  12,
        MANU         =  13,
        WSLE         =  14,
        OFFI         =  15,
        GVED         =  16,
        HLTH         =  17,
        OTHR         =  18,
        AGRI         =  19,
        MING         =  20,
        CONS         =  21,
        HBJ          =  22,
        SEC_HOME     =  23,
        CABIN        =  24,
        CONDO        =  25,
        HOTEL        =  26,
        AVGINCOME    =  27,
        Enrol_Elem   =  28,
        Enrol_Midl   =  29,
        Enrol_High   =  30,
        Sub_Area     =  31,
        CO_FIPS      =  32,
        CO_NAME(C)   =  33,
        DISTLRG      =  34,
        DLRG_NAME(C) =  35,
        DISTMED      =  36,
        DMED_NAME(C) =  37,
        DISTSML      =  38,
        DSML_NAME(C) =  39,
        CITY_NAME(C) =  40,
        AUTOARRAY=ALLFIELDS,
        SORT=CO_TAZID
    
    FILEI DBI[3] = '@ParentDir@1_Inputs\2_SEData\@WFRC_SEFile@',
        DELIMITER =',',
        TAZID      = #01,
        CO_TAZID   =  02,
        TOTHH      =  03,
        HHPOP      =  04,
        HHSIZE     =  05,
        TOTEMP     =  06,
        RETEMP     =  07,
        INDEMP     =  08,
        OTHEMP     =  09,
        ALLEMP     =  10,
        RETL       =  11,
        FOOD       =  12,
        MANU       =  13,
        WSLE       =  14,
        OFFI       =  15,
        GVED       =  16,
        HLTH       =  17,
        OTHR       =  18,
        AGRI       =  19,
        MING       =  20,
        CONS       =  21,
        HBJ        =  22,
        AVGINCOME  =  23,
        Enrol_Elem =  24,
        Enrol_Midl =  25,
        Enrol_High =  26,
        CO_FIPS    =  27,
        CO_NAME(C) =  28,
        AUTOARRAY=ALLFIELDS,
        SORT=CO_TAZID
    
    FILEI DBI[4] = '@ParentDir@1_Inputs\2_SEData\@MAG_SEFile@',
        DELIMITER =',',
        TAZID      = #01,
        CO_TAZID   =  02,
        TOTHH      =  03,
        HHPOP      =  04,
        HHSIZE     =  05,
        TOTEMP     =  06,
        RETEMP     =  07,
        INDEMP     =  08,
        OTHEMP     =  09,
        ALLEMP     =  10,
        RETL       =  11,
        FOOD       =  12,
        MANU       =  13,
        WSLE       =  14,
        OFFI       =  15,
        GVED       =  16,
        HLTH       =  17,
        OTHR       =  18,
        AGRI       =  19,
        MING       =  20,
        CONS       =  21,
        HBJ        =  22,
        AVGINCOME  =  23,
        Enrol_Elem =  24,
        Enrol_Midl =  25,
        Enrol_High =  26,
        CO_FIPS    =  27,
        CO_NAME(C) =  28,
        AUTOARRAY=ALLFIELDS,
        SORT=CO_TAZID
    
    FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\2_SEData\_ControlTotals\ControlTotal_SE_AllCounties.csv'
    
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf',
        FORM=10.1, 
        FIELDS=Z(8.0)         ,
               CO_TAZID(8.0)  ,
               SUBAREAID(4.0) ,
               TOTHH          ,
               HHPOP          ,
               HHSIZE(8.2)    ,
               TOTEMP         ,
               RETEMP         ,
               INDEMP         ,
               OTHEMP         ,
               ALLEMP         ,
               RETL           ,
               FOOD           ,
               MANU           ,
               WSLE           ,
               OFFI           ,
               GVED           ,
               HLTH           ,
               OTHR           ,
               AGRI           ,
               MING           ,
               CONS           ,
               HBJ            ,
               AVGINCOME(8.0) ,
               Enrol_Elem(8.0),
               Enrol_Midl(8.0),
               Enrol_High(8.0),
               CO_FIPS(4.0)   ,
               CO_NAME(31)    ,
               CITY_NAME(60)  ,
               DISTLRG(4.0)   ,
               DLRG_NAME(31)  ,
               DISTMED(4.0)   ,
               DMED_NAME(31)  ,
               DISTSML(4.0)   ,
               DSML_NAME(45)  ,
               HHJOBINT         ; HH and Job Intensity
    
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt'
    
    
    
    ;set MATRIX parameters
    ZONES = 1
    
    
    ;begin LOG SE section
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
        APPEND=T, 
        LIST=';*********************************************************************',
             '\n',
             '\nDemographic Summary',
             '\n'
    
    
    
    ;define lookup functions -------------------------------------------------------------
    
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
        INTERPOLATE=T, 
        NAME=SE_ContTot,
        LOOKUP[01]=1, RESULT=07,    ;HH
        LOOKUP[02]=1, RESULT=06,    ;HH_Pop
        LOOKUP[03]=1, RESULT=12,    ;ALLEMP 
        LOOKUP[04]=1, RESULT=13,    ;RETL
        LOOKUP[05]=1, RESULT=14,    ;FOOD
        LOOKUP[06]=1, RESULT=15,    ;MANU
        LOOKUP[07]=1, RESULT=16,    ;WSLE
        LOOKUP[08]=1, RESULT=17,    ;OFFI
        LOOKUP[09]=1, RESULT=18,    ;GVED
        LOOKUP[10]=1, RESULT=19,    ;HLTH
        LOOKUP[11]=1, RESULT=20,    ;OTHR
        LOOKUP[12]=1, RESULT=21,    ;AGRI
        LOOKUP[13]=1, RESULT=22,    ;MING
        LOOKUP[14]=1, RESULT=23,    ;CONS
        LOOKUP[15]=1, RESULT=24     ;HBJ
    
    
    
    ;process SE file data --------------------------------------------------------------------------
    ;loop through TAZ (1 through Used Zones)
    LOOP TAZ=1, @Usedzones@
        ;find record index in TAZ dbf input file of the TAZID that matches the TAZ number in the loop
        BSEARCH dba.1.TAZID=TAZ
        _idx_TAZID = _BSEARCH
        
        ;output: assign TAZ number
        RO.Z = TAZ
        
        ;output: assign variables from TAZ dbf input file
        RO.CO_TAZID  = dba.1.CO_TAZID[_idx_TAZID]
        RO.SUBAREAID = dba.1.SUBAREAID[_idx_TAZID]
        RO.CO_FIPS   = dba.1.CO_FIPS[_idx_TAZID]
        RO.CO_NAME   = dba.1.CO_NAME[_idx_TAZID]
        RO.CITY_NAME = dba.1.CITY_NAME[_idx_TAZID]
        RO.DISTLRG   = dba.1.DISTLRG[_idx_TAZID]
        RO.DLRG_NAME = dba.1.DLRG_NAME[_idx_TAZID]
        RO.DISTMED   = dba.1.DISTMED[_idx_TAZID]
        RO.DMED_NAME = dba.1.DMED_NAME[_idx_TAZID]
        RO.DISTSML   = dba.1.DISTSML[_idx_TAZID]
        RO.DSML_NAME = dba.1.DSML_NAME[_idx_TAZID]
        
        
        ;find record index in SE input file of the CO_TAZID that matches the CO_TAZID for the TAZ represented in the loop
        BSEARCH dba.2.CO_TAZID=RO.CO_TAZID
        _idx_SEFile_BoxElder = _BSEARCH
        
        BSEARCH dba.3.CO_TAZID=RO.CO_TAZID
        _idx_SEFile_WFRC = _BSEARCH
        
        BSEARCH dba.4.CO_TAZID=RO.CO_TAZID
        _idx_SEFile_MAG = _BSEARCH
        
        ;assign output variables
        if (RO.CO_FIPS=3)
            RO.TOTHH      = dba.2.TOTHH[_idx_SEFile_BoxElder]
            RO.HHPOP      = dba.2.HHPOP[_idx_SEFile_BoxElder]
            RO.HHSIZE     = dba.2.HHSIZE[_idx_SEFile_BoxElder]
            RO.ALLEMP     = dba.2.ALLEMP[_idx_SEFile_BoxElder]
            RO.RETL       = dba.2.RETL[_idx_SEFile_BoxElder]
            RO.FOOD       = dba.2.FOOD[_idx_SEFile_BoxElder]
            RO.MANU       = dba.2.MANU[_idx_SEFile_BoxElder]
            RO.WSLE       = dba.2.WSLE[_idx_SEFile_BoxElder]
            RO.OFFI       = dba.2.OFFI[_idx_SEFile_BoxElder]
            RO.GVED       = dba.2.GVED[_idx_SEFile_BoxElder]
            RO.HLTH       = dba.2.HLTH[_idx_SEFile_BoxElder]
            RO.OTHR       = dba.2.OTHR[_idx_SEFile_BoxElder]
            RO.AGRI       = dba.2.AGRI[_idx_SEFile_BoxElder]
            RO.MING       = dba.2.MING[_idx_SEFile_BoxElder]
            RO.CONS       = dba.2.CONS[_idx_SEFile_BoxElder]
            RO.HBJ        = dba.2.HBJ[_idx_SEFile_BoxElder]
            RO.AVGINCOME  = dba.2.AVGINCOME[_idx_SEFile_BoxElder]
            RO.Enrol_Elem = dba.2.Enrol_Elem[_idx_SEFile_BoxElder]
            RO.Enrol_Midl = dba.2.Enrol_Midl[_idx_SEFile_BoxElder]
            RO.Enrol_High = dba.2.Enrol_High[_idx_SEFile_BoxElder]
        
        elseif (RO.CO_FIPS=11 | RO.CO_FIPS=35 | RO.CO_FIPS=57)
            RO.TOTHH      = dba.3.TOTHH[_idx_SEFile_WFRC]
            RO.HHPOP      = dba.3.HHPOP[_idx_SEFile_WFRC]
            RO.HHSIZE     = dba.3.HHSIZE[_idx_SEFile_WFRC]
            RO.ALLEMP     = dba.3.ALLEMP[_idx_SEFile_WFRC]
            RO.RETL       = dba.3.RETL[_idx_SEFile_WFRC]
            RO.FOOD       = dba.3.FOOD[_idx_SEFile_WFRC]
            RO.MANU       = dba.3.MANU[_idx_SEFile_WFRC]
            RO.WSLE       = dba.3.WSLE[_idx_SEFile_WFRC]
            RO.OFFI       = dba.3.OFFI[_idx_SEFile_WFRC]
            RO.GVED       = dba.3.GVED[_idx_SEFile_WFRC]
            RO.HLTH       = dba.3.HLTH[_idx_SEFile_WFRC]
            RO.OTHR       = dba.3.OTHR[_idx_SEFile_WFRC]
            RO.AGRI       = dba.3.AGRI[_idx_SEFile_WFRC]
            RO.MING       = dba.3.MING[_idx_SEFile_WFRC]
            RO.CONS       = dba.3.CONS[_idx_SEFile_WFRC]
            RO.HBJ        = dba.3.HBJ[_idx_SEFile_WFRC]
            RO.AVGINCOME  = dba.3.AVGINCOME[_idx_SEFile_WFRC]
            RO.Enrol_Elem = dba.3.Enrol_Elem[_idx_SEFile_WFRC]
            RO.Enrol_Midl = dba.3.Enrol_Midl[_idx_SEFile_WFRC]
            RO.Enrol_High = dba.3.Enrol_High[_idx_SEFile_WFRC]
        
        elseif (RO.CO_FIPS=49)
            RO.TOTHH      = dba.4.TOTHH[_idx_SEFile_MAG]
            RO.HHPOP      = dba.4.HHPOP[_idx_SEFile_MAG]
            RO.HHSIZE     = dba.4.HHSIZE[_idx_SEFile_MAG]
            RO.ALLEMP     = dba.4.ALLEMP[_idx_SEFile_MAG]
            RO.RETL       = dba.4.RETL[_idx_SEFile_MAG]
            RO.FOOD       = dba.4.FOOD[_idx_SEFile_MAG]
            RO.MANU       = dba.4.MANU[_idx_SEFile_MAG]
            RO.WSLE       = dba.4.WSLE[_idx_SEFile_MAG]
            RO.OFFI       = dba.4.OFFI[_idx_SEFile_MAG]
            RO.GVED       = dba.4.GVED[_idx_SEFile_MAG]
            RO.HLTH       = dba.4.HLTH[_idx_SEFile_MAG]
            RO.OTHR       = dba.4.OTHR[_idx_SEFile_MAG]
            RO.AGRI       = dba.4.AGRI[_idx_SEFile_MAG]
            RO.MING       = dba.4.MING[_idx_SEFile_MAG]
            RO.CONS       = dba.4.CONS[_idx_SEFile_MAG]
            RO.HBJ        = dba.4.HBJ[_idx_SEFile_MAG]
            RO.AVGINCOME  = dba.4.AVGINCOME[_idx_SEFile_MAG]
            RO.Enrol_Elem = dba.4.Enrol_Elem[_idx_SEFile_MAG]
            RO.Enrol_Midl = dba.4.Enrol_Midl[_idx_SEFile_MAG]
            RO.Enrol_High = dba.4.Enrol_High[_idx_SEFile_MAG]
        
        else
            RO.TOTHH      = 0
            RO.HHPOP      = 0
            RO.HHSIZE     = 0
            RO.ALLEMP     = 0
            RO.RETL       = 0
            RO.FOOD       = 0
            RO.MANU       = 0
            RO.WSLE       = 0
            RO.OFFI       = 0
            RO.GVED       = 0
            RO.HLTH       = 0
            RO.OTHR       = 0
            RO.AGRI       = 0
            RO.MING       = 0
            RO.CONS       = 0
            RO.HBJ        = 0
            RO.AVGINCOME  = 0
            RO.Enrol_Elem = 0
            RO.Enrol_Midl = 0
            RO.Enrol_High = 0
        endif
        
        
        if (RO.TOTHH=0)
            RO.HHSIZE = 0
        else
            RO.HHSIZE = RO.HHPOP / RO.TOTHH
        endif
        
        RO.RETEMP = RO.RETL +
                    RO.FOOD
        
        RO.INDEMP = RO.MANU +
                    RO.WSLE
        
        RO.OTHEMP = RO.OFFI +
                    RO.GVED +
                    RO.HLTH +
                    RO.OTHR
        
        RO.TOTEMP = RO.RETEMP +
                    RO.INDEMP +
                    RO.OTHEMP
        
        RO.HHJOBINT   = (RO.TOTHH * @HH_JOB_INTENSITY_FACTOR@) + RO.TOTEMP

        ;write output file & caluclate county summaries
        if (RO.CO_TAZID>0)
            ;write to output file
            WRITE RECO=1
            
            ;sum SE variables for LOG file
            ;Box Elder
            if (RO.CO_FIPS=3)
                sum_BE_HH     = sum_BE_HH  + RO.TOTHH
                sum_BE_POP    = sum_BE_POP + RO.HHPOP
                
                sum_BE_ALLEMP = sum_BE_ALLEMP + RO.ALLEMP
                sum_BE_RETL   = sum_BE_RETL   + RO.RETL
                sum_BE_FOOD   = sum_BE_FOOD   + RO.FOOD
                sum_BE_MANU   = sum_BE_MANU   + RO.MANU
                sum_BE_WSLE   = sum_BE_WSLE   + RO.WSLE
                sum_BE_OFFI   = sum_BE_OFFI   + RO.OFFI
                sum_BE_GVED   = sum_BE_GVED   + RO.GVED
                sum_BE_HLTH   = sum_BE_HLTH   + RO.HLTH
                sum_BE_OTHR   = sum_BE_OTHR   + RO.OTHR
                sum_BE_AGRI   = sum_BE_AGRI   + RO.AGRI
                sum_BE_MING   = sum_BE_MING   + RO.MING
                sum_BE_CONS   = sum_BE_CONS   + RO.CONS
                sum_BE_HBJ    = sum_BE_HBJ    + RO.HBJ
            
                sum_BE_Enrol_Elem = sum_BE_Enrol_Elem + RO.Enrol_Elem
                sum_BE_Enrol_Midl = sum_BE_Enrol_Midl + RO.Enrol_Midl
                sum_BE_Enrol_High = sum_BE_Enrol_High + RO.Enrol_High
                
            ;Weber
            elseif  (RO.CO_FIPS=57)
                sum_WE_HH     = sum_WE_HH  + RO.TOTHH
                sum_WE_POP    = sum_WE_POP + RO.HHPOP
                
                sum_WE_ALLEMP = sum_WE_ALLEMP + RO.ALLEMP
                sum_WE_RETL   = sum_WE_RETL   + RO.RETL
                sum_WE_FOOD   = sum_WE_FOOD   + RO.FOOD
                sum_WE_MANU   = sum_WE_MANU   + RO.MANU
                sum_WE_WSLE   = sum_WE_WSLE   + RO.WSLE
                sum_WE_OFFI   = sum_WE_OFFI   + RO.OFFI
                sum_WE_GVED   = sum_WE_GVED   + RO.GVED
                sum_WE_HLTH   = sum_WE_HLTH   + RO.HLTH
                sum_WE_OTHR   = sum_WE_OTHR   + RO.OTHR
                sum_WE_AGRI   = sum_WE_AGRI   + RO.AGRI
                sum_WE_MING   = sum_WE_MING   + RO.MING
                sum_WE_CONS   = sum_WE_CONS   + RO.CONS
                sum_WE_HBJ    = sum_WE_HBJ    + RO.HBJ
            
                sum_WE_Enrol_Elem = sum_WE_Enrol_Elem + RO.Enrol_Elem
                sum_WE_Enrol_Midl = sum_WE_Enrol_Midl + RO.Enrol_Midl
                sum_WE_Enrol_High = sum_WE_Enrol_High + RO.Enrol_High
                
            ;Davis
            elseif  (RO.CO_FIPS=11)
                sum_DA_HH     = sum_DA_HH  + RO.TOTHH
                sum_DA_POP    = sum_DA_POP + RO.HHPOP
                
                sum_DA_ALLEMP = sum_DA_ALLEMP + RO.ALLEMP
                sum_DA_RETL   = sum_DA_RETL   + RO.RETL
                sum_DA_FOOD   = sum_DA_FOOD   + RO.FOOD
                sum_DA_MANU   = sum_DA_MANU   + RO.MANU
                sum_DA_WSLE   = sum_DA_WSLE   + RO.WSLE
                sum_DA_OFFI   = sum_DA_OFFI   + RO.OFFI
                sum_DA_GVED   = sum_DA_GVED   + RO.GVED
                sum_DA_HLTH   = sum_DA_HLTH   + RO.HLTH
                sum_DA_OTHR   = sum_DA_OTHR   + RO.OTHR
                sum_DA_AGRI   = sum_DA_AGRI   + RO.AGRI
                sum_DA_MING   = sum_DA_MING   + RO.MING
                sum_DA_CONS   = sum_DA_CONS   + RO.CONS
                sum_DA_HBJ    = sum_DA_HBJ    + RO.HBJ
            
                sum_DA_Enrol_Elem = sum_DA_Enrol_Elem + RO.Enrol_Elem
                sum_DA_Enrol_Midl = sum_DA_Enrol_Midl + RO.Enrol_Midl
                sum_DA_Enrol_High = sum_DA_Enrol_High + RO.Enrol_High
                
            ;Salt Lake
            elseif  (RO.CO_FIPS=35)
                sum_SL_HH     = sum_SL_HH  + RO.TOTHH
                sum_SL_POP    = sum_SL_POP + RO.HHPOP
                
                sum_SL_ALLEMP = sum_SL_ALLEMP + RO.ALLEMP
                sum_SL_RETL   = sum_SL_RETL   + RO.RETL
                sum_SL_FOOD   = sum_SL_FOOD   + RO.FOOD
                sum_SL_MANU   = sum_SL_MANU   + RO.MANU
                sum_SL_WSLE   = sum_SL_WSLE   + RO.WSLE
                sum_SL_OFFI   = sum_SL_OFFI   + RO.OFFI
                sum_SL_GVED   = sum_SL_GVED   + RO.GVED
                sum_SL_HLTH   = sum_SL_HLTH   + RO.HLTH
                sum_SL_OTHR   = sum_SL_OTHR   + RO.OTHR
                sum_SL_AGRI   = sum_SL_AGRI   + RO.AGRI
                sum_SL_MING   = sum_SL_MING   + RO.MING
                sum_SL_CONS   = sum_SL_CONS   + RO.CONS
                sum_SL_HBJ    = sum_SL_HBJ    + RO.HBJ
            
                sum_SL_Enrol_Elem = sum_SL_Enrol_Elem + RO.Enrol_Elem
                sum_SL_Enrol_Midl = sum_SL_Enrol_Midl + RO.Enrol_Midl
                sum_SL_Enrol_High = sum_SL_Enrol_High + RO.Enrol_High
                
            ;Utah
            elseif  (RO.CO_FIPS=49)
                sum_UT_HH     = sum_UT_HH  + RO.TOTHH
                sum_UT_POP    = sum_UT_POP + RO.HHPOP
                
                sum_UT_ALLEMP = sum_UT_ALLEMP + RO.ALLEMP
                sum_UT_RETL   = sum_UT_RETL   + RO.RETL
                sum_UT_FOOD   = sum_UT_FOOD   + RO.FOOD
                sum_UT_MANU   = sum_UT_MANU   + RO.MANU
                sum_UT_WSLE   = sum_UT_WSLE   + RO.WSLE
                sum_UT_OFFI   = sum_UT_OFFI   + RO.OFFI
                sum_UT_GVED   = sum_UT_GVED   + RO.GVED
                sum_UT_HLTH   = sum_UT_HLTH   + RO.HLTH
                sum_UT_OTHR   = sum_UT_OTHR   + RO.OTHR
                sum_UT_AGRI   = sum_UT_AGRI   + RO.AGRI
                sum_UT_MING   = sum_UT_MING   + RO.MING
                sum_UT_CONS   = sum_UT_CONS   + RO.CONS
                sum_UT_HBJ    = sum_UT_HBJ    + RO.HBJ
            
                sum_UT_Enrol_Elem = sum_UT_Enrol_Elem + RO.Enrol_Elem
                sum_UT_Enrol_Midl = sum_UT_Enrol_Midl + RO.Enrol_Midl
                sum_UT_Enrol_High = sum_UT_Enrol_High + RO.Enrol_High
            endif
            
        endif  ;RO.CO_TAZID>0
        
    ENDLOOP
    
    
    
    ;look up county control totals -----------------------------------------------------------------
    ;  note: Weber Co control total uses the following CO_FIPS convention:
    ;        57 = all county   (CO_FIPS)
    ;      9057 = WFRC portion (90 prefix + CO_FIPS - 9=sub-county total, 0=UDOT SubareaID)
    ;      9157 = WFRC portion (91 prefix + CO_FIPS - 9=sub-county total, 1=UDOT SubareaID)
    BE_Index =    3 * 10000  +  @DemographicYear@
    WE_Index = 9157 * 10000  +  @DemographicYear@
    DA_Index =   11 * 10000  +  @DemographicYear@
    SL_Index =   35 * 10000  +  @DemographicYear@
    UT_Index =   49 * 10000  +  @DemographicYear@
    
    CT_BE_HH     = SE_ContTot(01, BE_Index)
    CT_BE_Pop    = SE_ContTot(02, BE_Index)
    CT_BE_ALLEMP = SE_ContTot(03, BE_Index)
    CT_BE_RETL   = SE_ContTot(04, BE_Index)
    CT_BE_FOOD   = SE_ContTot(05, BE_Index)
    CT_BE_MANU   = SE_ContTot(06, BE_Index)
    CT_BE_WSLE   = SE_ContTot(07, BE_Index)
    CT_BE_OFFI   = SE_ContTot(08, BE_Index)
    CT_BE_GVED   = SE_ContTot(09, BE_Index)
    CT_BE_HLTH   = SE_ContTot(10, BE_Index)
    CT_BE_OTHR   = SE_ContTot(11, BE_Index)
    CT_BE_AGRI   = SE_ContTot(12, BE_Index)
    CT_BE_MING   = SE_ContTot(13, BE_Index)
    CT_BE_CONS   = SE_ContTot(14, BE_Index)
    CT_BE_HBJ    = SE_ContTot(15, BE_Index)
    
    CT_WE_HH     = SE_ContTot(01, WE_Index)
    CT_WE_Pop    = SE_ContTot(02, WE_Index)
    CT_WE_ALLEMP = SE_ContTot(03, WE_Index)
    CT_WE_RETL   = SE_ContTot(04, WE_Index)
    CT_WE_FOOD   = SE_ContTot(05, WE_Index)
    CT_WE_MANU   = SE_ContTot(06, WE_Index)
    CT_WE_WSLE   = SE_ContTot(07, WE_Index)
    CT_WE_OFFI   = SE_ContTot(08, WE_Index)
    CT_WE_GVED   = SE_ContTot(09, WE_Index)
    CT_WE_HLTH   = SE_ContTot(10, WE_Index)
    CT_WE_OTHR   = SE_ContTot(11, WE_Index)
    CT_WE_AGRI   = SE_ContTot(12, WE_Index)
    CT_WE_MING   = SE_ContTot(13, WE_Index)
    CT_WE_CONS   = SE_ContTot(14, WE_Index)
    CT_WE_HBJ    = SE_ContTot(15, WE_Index)
    
    CT_DA_HH     = SE_ContTot(01, DA_Index)
    CT_DA_Pop    = SE_ContTot(02, DA_Index)
    CT_DA_ALLEMP = SE_ContTot(03, DA_Index)
    CT_DA_RETL   = SE_ContTot(04, DA_Index)
    CT_DA_FOOD   = SE_ContTot(05, DA_Index)
    CT_DA_MANU   = SE_ContTot(06, DA_Index)
    CT_DA_WSLE   = SE_ContTot(07, DA_Index)
    CT_DA_OFFI   = SE_ContTot(08, DA_Index)
    CT_DA_GVED   = SE_ContTot(09, DA_Index)
    CT_DA_HLTH   = SE_ContTot(10, DA_Index)
    CT_DA_OTHR   = SE_ContTot(11, DA_Index)
    CT_DA_AGRI   = SE_ContTot(12, DA_Index)
    CT_DA_MING   = SE_ContTot(13, DA_Index)
    CT_DA_CONS   = SE_ContTot(14, DA_Index)
    CT_DA_HBJ    = SE_ContTot(15, DA_Index)
    
    CT_SL_HH     = SE_ContTot(01, SL_Index)
    CT_SL_Pop    = SE_ContTot(02, SL_Index)
    CT_SL_ALLEMP = SE_ContTot(03, SL_Index)
    CT_SL_RETL   = SE_ContTot(04, SL_Index)
    CT_SL_FOOD   = SE_ContTot(05, SL_Index)
    CT_SL_MANU   = SE_ContTot(06, SL_Index)
    CT_SL_WSLE   = SE_ContTot(07, SL_Index)
    CT_SL_OFFI   = SE_ContTot(08, SL_Index)
    CT_SL_GVED   = SE_ContTot(09, SL_Index)
    CT_SL_HLTH   = SE_ContTot(10, SL_Index)
    CT_SL_OTHR   = SE_ContTot(11, SL_Index)
    CT_SL_AGRI   = SE_ContTot(12, SL_Index)
    CT_SL_MING   = SE_ContTot(13, SL_Index)
    CT_SL_CONS   = SE_ContTot(14, SL_Index)
    CT_SL_HBJ    = SE_ContTot(15, SL_Index)
    
    CT_UT_HH     = SE_ContTot(01, UT_Index)
    CT_UT_Pop    = SE_ContTot(02, UT_Index)
    CT_UT_ALLEMP = SE_ContTot(03, UT_Index)
    CT_UT_RETL   = SE_ContTot(04, UT_Index)
    CT_UT_FOOD   = SE_ContTot(05, UT_Index)
    CT_UT_MANU   = SE_ContTot(06, UT_Index)
    CT_UT_WSLE   = SE_ContTot(07, UT_Index)
    CT_UT_OFFI   = SE_ContTot(08, UT_Index)
    CT_UT_GVED   = SE_ContTot(09, UT_Index)
    CT_UT_HLTH   = SE_ContTot(10, UT_Index)
    CT_UT_OTHR   = SE_ContTot(11, UT_Index)
    CT_UT_AGRI   = SE_ContTot(12, UT_Index)
    CT_UT_MING   = SE_ContTot(13, UT_Index)
    CT_UT_CONS   = SE_ContTot(14, UT_Index)
    CT_UT_HBJ    = SE_ContTot(15, UT_Index)
    
    
    CT_BE_HHSize = CT_BE_Pop / CT_BE_HH
    CT_WE_HHSize = CT_WE_Pop / CT_WE_HH
    CT_DA_HHSize = CT_DA_Pop / CT_DA_HH
    CT_SL_HHSize = CT_SL_Pop / CT_SL_HH
    CT_UT_HHSize = CT_UT_Pop / CT_UT_HH
    
    CT_BE_EmpHH  = CT_BE_ALLEMP / CT_BE_HH
    CT_WE_EmpHH  = CT_WE_ALLEMP / CT_WE_HH
    CT_DA_EmpHH  = CT_DA_ALLEMP / CT_DA_HH
    CT_SL_EmpHH  = CT_SL_ALLEMP / CT_SL_HH
    CT_UT_EmpHH  = CT_UT_ALLEMP / CT_UT_HH
    
    
    
    ;compare SE sum to county control total --------------------------------------------------------
    ;calculate HH Size and Emp per HH ratios
    if (sum_BE_HH>0)  sum_BE_HHSize = sum_BE_POP / sum_BE_HH
    if (sum_WE_HH>0)  sum_WE_HHSize = sum_WE_POP / sum_WE_HH
    if (sum_DA_HH>0)  sum_DA_HHSize = sum_DA_POP / sum_DA_HH
    if (sum_SL_HH>0)  sum_SL_HHSize = sum_SL_POP / sum_SL_HH
    if (sum_UT_HH>0)  sum_UT_HHSize = sum_UT_POP / sum_UT_HH
    
    if (sum_BE_HH>0)  sum_BE_EmpHH  = sum_BE_ALLEMP / sum_BE_HH
    if (sum_WE_HH>0)  sum_WE_EmpHH  = sum_WE_ALLEMP / sum_WE_HH
    if (sum_DA_HH>0)  sum_DA_EmpHH  = sum_DA_ALLEMP / sum_DA_HH
    if (sum_SL_HH>0)  sum_SL_EmpHH  = sum_SL_ALLEMP / sum_SL_HH
    if (sum_UT_HH>0)  sum_UT_EmpHH  = sum_UT_ALLEMP / sum_UT_HH
    
    
    ;calculate difference of model from control total
    ;Box Elder
    Dif_BE_HH       = sum_BE_HH    - CT_BE_HH
    Dif_BE_Pop      = sum_BE_POP   - CT_BE_Pop
    
    Diff_BE_ALLEMP = sum_BE_ALLEMP - CT_BE_ALLEMP
    Diff_BE_RETL   = sum_BE_RETL   - CT_BE_RETL
    Diff_BE_FOOD   = sum_BE_FOOD   - CT_BE_FOOD
    Diff_BE_MANU   = sum_BE_MANU   - CT_BE_MANU
    Diff_BE_WSLE   = sum_BE_WSLE   - CT_BE_WSLE
    Diff_BE_OFFI   = sum_BE_OFFI   - CT_BE_OFFI
    Diff_BE_GVED   = sum_BE_GVED   - CT_BE_GVED
    Diff_BE_HLTH   = sum_BE_HLTH   - CT_BE_HLTH
    Diff_BE_OTHR   = sum_BE_OTHR   - CT_BE_OTHR
    Diff_BE_AGRI   = sum_BE_AGRI   - CT_BE_AGRI
    Diff_BE_MING   = sum_BE_MING   - CT_BE_MING
    Diff_BE_CONS   = sum_BE_CONS   - CT_BE_CONS
    Diff_BE_HBJ    = sum_BE_HBJ    - CT_BE_HBJ 
    
    Dif_BE_HHSize = sum_BE_HHSize  - CT_BE_HHSize
    Dif_BE_EmpHH  = sum_BE_EmpHH   - CT_BE_EmpHH
    
    ;Weber
    Dif_WE_HH       = sum_WE_HH    - CT_WE_HH
    Dif_WE_Pop      = sum_WE_POP   - CT_WE_Pop
    
    Diff_WE_ALLEMP = sum_WE_ALLEMP - CT_WE_ALLEMP
    Diff_WE_RETL   = sum_WE_RETL   - CT_WE_RETL
    Diff_WE_FOOD   = sum_WE_FOOD   - CT_WE_FOOD
    Diff_WE_MANU   = sum_WE_MANU   - CT_WE_MANU
    Diff_WE_WSLE   = sum_WE_WSLE   - CT_WE_WSLE
    Diff_WE_OFFI   = sum_WE_OFFI   - CT_WE_OFFI
    Diff_WE_GVED   = sum_WE_GVED   - CT_WE_GVED
    Diff_WE_HLTH   = sum_WE_HLTH   - CT_WE_HLTH
    Diff_WE_OTHR   = sum_WE_OTHR   - CT_WE_OTHR
    Diff_WE_AGRI   = sum_WE_AGRI   - CT_WE_AGRI
    Diff_WE_MING   = sum_WE_MING   - CT_WE_MING
    Diff_WE_CONS   = sum_WE_CONS   - CT_WE_CONS
    Diff_WE_HBJ    = sum_WE_HBJ    - CT_WE_HBJ 
    
    Dif_WE_HHSize = sum_WE_HHSize  - CT_WE_HHSize
    Dif_WE_EmpHH  = sum_WE_EmpHH   - CT_WE_EmpHH
    
    ;Davis
    Dif_DA_HH       = sum_DA_HH    - CT_DA_HH
    Dif_DA_Pop      = sum_DA_POP   - CT_DA_Pop
    
    Diff_DA_ALLEMP = sum_DA_ALLEMP - CT_DA_ALLEMP
    Diff_DA_RETL   = sum_DA_RETL   - CT_DA_RETL
    Diff_DA_FOOD   = sum_DA_FOOD   - CT_DA_FOOD
    Diff_DA_MANU   = sum_DA_MANU   - CT_DA_MANU
    Diff_DA_WSLE   = sum_DA_WSLE   - CT_DA_WSLE
    Diff_DA_OFFI   = sum_DA_OFFI   - CT_DA_OFFI
    Diff_DA_GVED   = sum_DA_GVED   - CT_DA_GVED
    Diff_DA_HLTH   = sum_DA_HLTH   - CT_DA_HLTH
    Diff_DA_OTHR   = sum_DA_OTHR   - CT_DA_OTHR
    Diff_DA_AGRI   = sum_DA_AGRI   - CT_DA_AGRI
    Diff_DA_MING   = sum_DA_MING   - CT_DA_MING
    Diff_DA_CONS   = sum_DA_CONS   - CT_DA_CONS
    Diff_DA_HBJ    = sum_DA_HBJ    - CT_DA_HBJ 
    
    Dif_DA_HHSize = sum_DA_HHSize  - CT_DA_HHSize
    Dif_DA_EmpHH  = sum_DA_EmpHH   - CT_DA_EmpHH
    
    ;Salt Lake
    Dif_SL_HH       = sum_SL_HH    - CT_SL_HH
    Dif_SL_Pop      = sum_SL_POP   - CT_SL_Pop
    
    Diff_SL_ALLEMP = sum_SL_ALLEMP - CT_SL_ALLEMP
    Diff_SL_RETL   = sum_SL_RETL   - CT_SL_RETL
    Diff_SL_FOOD   = sum_SL_FOOD   - CT_SL_FOOD
    Diff_SL_MANU   = sum_SL_MANU   - CT_SL_MANU
    Diff_SL_WSLE   = sum_SL_WSLE   - CT_SL_WSLE
    Diff_SL_OFFI   = sum_SL_OFFI   - CT_SL_OFFI
    Diff_SL_GVED   = sum_SL_GVED   - CT_SL_GVED
    Diff_SL_HLTH   = sum_SL_HLTH   - CT_SL_HLTH
    Diff_SL_OTHR   = sum_SL_OTHR   - CT_SL_OTHR
    Diff_SL_AGRI   = sum_SL_AGRI   - CT_SL_AGRI
    Diff_SL_MING   = sum_SL_MING   - CT_SL_MING
    Diff_SL_CONS   = sum_SL_CONS   - CT_SL_CONS
    Diff_SL_HBJ    = sum_SL_HBJ    - CT_SL_HBJ 
    
    Dif_SL_HHSize = sum_SL_HHSize  - CT_SL_HHSize
    Dif_SL_EmpHH  = sum_SL_EmpHH   - CT_SL_EmpHH
    
    ;Utah
    Dif_UT_HH       = sum_UT_HH    - CT_UT_HH
    Dif_UT_Pop      = sum_UT_POP   - CT_UT_Pop
    
    Diff_UT_ALLEMP = sum_UT_ALLEMP - CT_UT_ALLEMP
    Diff_UT_RETL   = sum_UT_RETL   - CT_UT_RETL
    Diff_UT_FOOD   = sum_UT_FOOD   - CT_UT_FOOD
    Diff_UT_MANU   = sum_UT_MANU   - CT_UT_MANU
    Diff_UT_WSLE   = sum_UT_WSLE   - CT_UT_WSLE
    Diff_UT_OFFI   = sum_UT_OFFI   - CT_UT_OFFI
    Diff_UT_GVED   = sum_UT_GVED   - CT_UT_GVED
    Diff_UT_HLTH   = sum_UT_HLTH   - CT_UT_HLTH
    Diff_UT_OTHR   = sum_UT_OTHR   - CT_UT_OTHR
    Diff_UT_AGRI   = sum_UT_AGRI   - CT_UT_AGRI
    Diff_UT_MING   = sum_UT_MING   - CT_UT_MING
    Diff_UT_CONS   = sum_UT_CONS   - CT_UT_CONS
    Diff_UT_HBJ    = sum_UT_HBJ    - CT_UT_HBJ 
    
    Dif_UT_HHSize = sum_UT_HHSize  - CT_UT_HHSize
    Dif_UT_EmpHH  = sum_UT_EmpHH   - CT_UT_EmpHH
    
    
    ;print region results to LOG file
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
        APPEND=T, 
        FORM=11.0C, 
        LIST='  Box Elder:\n',
             '                         Model    Con Tot       Diff      % Diff\n',
             '      Households   ', sum_BE_HH ,           CT_BE_HH ,           Dif_BE_HH ,           Dif_BE_HH/CT_BE_HH*100(11.1)  ,       '%\n',
             '      Population   ', sum_BE_POP,           CT_BE_Pop,           Dif_BE_POP,           Dif_BE_POP/CT_BE_Pop*100(11.1),       '%\n', 
             '      Avg HH Size  ', sum_BE_HHSize(11.2),  CT_BE_HHSize(11.2),  Dif_BE_HHSize(11.2),  Dif_BE_HHSize/CT_BE_HHSize*100(11.1), '%\n',
             '\n', 
             '                         Model    Con Tot       Diff      % Diff\n',
             '      All Emp      ', sum_BE_ALLEMP,   CT_BE_ALLEMP,   Diff_BE_ALLEMP,   Diff_BE_ALLEMP/CT_BE_ALLEMP*100(11.1),   '%\n',
             '        RETL       ', sum_BE_RETL  ,   CT_BE_RETL  ,   Diff_BE_RETL  ,   Diff_BE_RETL/CT_BE_RETL*100(11.1),       '%\n',
             '        FOOD       ', sum_BE_FOOD  ,   CT_BE_FOOD  ,   Diff_BE_FOOD  ,   Diff_BE_FOOD/CT_BE_FOOD*100(11.1),       '%\n',
             '        Manu       ', sum_BE_MANU  ,   CT_BE_MANU  ,   Diff_BE_MANU  ,   Diff_BE_MANU/CT_BE_MANU*100(11.1),       '%\n',
             '        WSLE       ', sum_BE_WSLE  ,   CT_BE_WSLE  ,   Diff_BE_WSLE  ,   Diff_BE_WSLE/CT_BE_WSLE*100(11.1),       '%\n',
             '        OFFI       ', sum_BE_OFFI  ,   CT_BE_OFFI  ,   Diff_BE_OFFI  ,   Diff_BE_OFFI/CT_BE_OFFI*100(11.1),       '%\n',
             '        GVED       ', sum_BE_GVED  ,   CT_BE_GVED  ,   Diff_BE_GVED  ,   Diff_BE_GVED/CT_BE_GVED*100(11.1),       '%\n',
             '        HLTH       ', sum_BE_HLTH  ,   CT_BE_HLTH  ,   Diff_BE_HLTH  ,   Diff_BE_HLTH/CT_BE_HLTH*100(11.1),       '%\n',
             '        OTHR       ', sum_BE_OTHR  ,   CT_BE_OTHR  ,   Diff_BE_OTHR  ,   Diff_BE_OTHR/CT_BE_OTHR*100(11.1),       '%\n',
             '        AGRI       ', sum_BE_AGRI  ,   CT_BE_AGRI  ,   Diff_BE_AGRI  ,   Diff_BE_AGRI/CT_BE_AGRI*100(11.1),       '%\n',
             '        MING       ', sum_BE_MING  ,   CT_BE_MING  ,   Diff_BE_MING  ,   Diff_BE_MING/CT_BE_MING*100(11.1),       '%\n',
             '        CONS       ', sum_BE_CONS  ,   CT_BE_CONS  ,   Diff_BE_CONS  ,   Diff_BE_CONS/CT_BE_CONS*100(11.1),       '%\n',
             '        HBJ        ', sum_BE_HBJ   ,   CT_BE_HBJ   ,   Diff_BE_HBJ   ,   Diff_BE_HBJ/CT_BE_HBJ*100(11.1),         '%\n',
             '\n',  
             '                         Model    Con Tot       Diff      % Diff\n',                                  
             '      Emp/HH Ratio ', sum_BE_EmpHH(11.2),  CT_BE_EmpHH(11.2),  Dif_BE_EmpHH(11.2),  Dif_BE_EmpHH/CT_BE_EmpHH*100(11.1),  '%\n',
             '\n',
             '      Enrollment - Elementary    ', sum_BE_Enrol_Elem, '\n',
             '      Enrollment - Middle School ', sum_BE_Enrol_Midl, '\n',
             '      Enrollment - High School   ', sum_BE_Enrol_High, '\n',
             '\n',
             '  Weber:\n',
             '                         Model    Con Tot       Diff      % Diff\n',
             '      Households   ', sum_WE_HH ,           CT_WE_HH ,           Dif_WE_HH ,           Dif_WE_HH/CT_WE_HH*100(11.1)  ,       '%\n',
             '      Population   ', sum_WE_POP,           CT_WE_Pop,           Dif_WE_POP,           Dif_WE_POP/CT_WE_Pop*100(11.1),       '%\n', 
             '      Avg HH Size  ', sum_WE_HHSize(11.2),  CT_WE_HHSize(11.2),  Dif_WE_HHSize(11.2),  Dif_WE_HHSize/CT_WE_HHSize*100(11.1), '%\n',
             '\n', 
             '                         Model    Con Tot       Diff      % Diff\n',
             '      All Emp      ', sum_WE_ALLEMP,   CT_WE_ALLEMP,   Diff_WE_ALLEMP,   Diff_WE_ALLEMP/CT_WE_ALLEMP*100(11.1),   '%\n',
             '        RETL       ', sum_WE_RETL  ,   CT_WE_RETL  ,   Diff_WE_RETL  ,   Diff_WE_RETL/CT_WE_RETL*100(11.1),       '%\n',
             '        FOOD       ', sum_WE_FOOD  ,   CT_WE_FOOD  ,   Diff_WE_FOOD  ,   Diff_WE_FOOD/CT_WE_FOOD*100(11.1),       '%\n',
             '        Manu       ', sum_WE_MANU  ,   CT_WE_MANU  ,   Diff_WE_MANU  ,   Diff_WE_MANU/CT_WE_MANU*100(11.1),       '%\n',
             '        WSLE       ', sum_WE_WSLE  ,   CT_WE_WSLE  ,   Diff_WE_WSLE  ,   Diff_WE_WSLE/CT_WE_WSLE*100(11.1),       '%\n',
             '        OFFI       ', sum_WE_OFFI  ,   CT_WE_OFFI  ,   Diff_WE_OFFI  ,   Diff_WE_OFFI/CT_WE_OFFI*100(11.1),       '%\n',
             '        GVED       ', sum_WE_GVED  ,   CT_WE_GVED  ,   Diff_WE_GVED  ,   Diff_WE_GVED/CT_WE_GVED*100(11.1),       '%\n',
             '        HLTH       ', sum_WE_HLTH  ,   CT_WE_HLTH  ,   Diff_WE_HLTH  ,   Diff_WE_HLTH/CT_WE_HLTH*100(11.1),       '%\n',
             '        OTHR       ', sum_WE_OTHR  ,   CT_WE_OTHR  ,   Diff_WE_OTHR  ,   Diff_WE_OTHR/CT_WE_OTHR*100(11.1),       '%\n',
             '        AGRI       ', sum_WE_AGRI  ,   CT_WE_AGRI  ,   Diff_WE_AGRI  ,   Diff_WE_AGRI/CT_WE_AGRI*100(11.1),       '%\n',
             '        MING       ', sum_WE_MING  ,   CT_WE_MING  ,   Diff_WE_MING  ,   Diff_WE_MING/CT_WE_MING*100(11.1),       '%\n',
             '        CONS       ', sum_WE_CONS  ,   CT_WE_CONS  ,   Diff_WE_CONS  ,   Diff_WE_CONS/CT_WE_CONS*100(11.1),       '%\n',
             '        HBJ        ', sum_WE_HBJ   ,   CT_WE_HBJ   ,   Diff_WE_HBJ   ,   Diff_WE_HBJ/CT_WE_HBJ*100(11.1),         '%\n',
             '\n',  
             '                         Model    Con Tot       Diff      % Diff\n',                                  
             '      Emp/HH Ratio ', sum_WE_EmpHH(11.2),  CT_WE_EmpHH(11.2),  Dif_WE_EmpHH(11.2),  Dif_WE_EmpHH/CT_WE_EmpHH*100(11.1),  '%\n',
             '\n',
             '      Enrollment - Elementary    ', sum_WE_Enrol_Elem, '\n',
             '      Enrollment - Middle School ', sum_WE_Enrol_Midl, '\n',
             '      Enrollment - High School   ', sum_WE_Enrol_High, '\n',
             '\n',
             '  Davis:\n',
             '                         Model    Con Tot       Diff      % Diff\n',
             '      Households   ', sum_DA_HH ,           CT_DA_HH ,           Dif_DA_HH ,           Dif_DA_HH/CT_DA_HH*100(11.1)  ,       '%\n',
             '      Population   ', sum_DA_POP,           CT_DA_Pop,           Dif_DA_POP,           Dif_DA_POP/CT_DA_Pop*100(11.1),       '%\n', 
             '      Avg HH Size  ', sum_DA_HHSize(11.2),  CT_DA_HHSize(11.2),  Dif_DA_HHSize(11.2),  Dif_DA_HHSize/CT_DA_HHSize*100(11.1), '%\n',
             '\n', 
             '                         Model    Con Tot       Diff      % Diff\n',
             '      All Emp      ', sum_DA_ALLEMP,   CT_DA_ALLEMP,   Diff_DA_ALLEMP,   Diff_DA_ALLEMP/CT_DA_ALLEMP*100(11.1),   '%\n',
             '        RETL       ', sum_DA_RETL  ,   CT_DA_RETL  ,   Diff_DA_RETL  ,   Diff_DA_RETL/CT_DA_RETL*100(11.1),       '%\n',
             '        FOOD       ', sum_DA_FOOD  ,   CT_DA_FOOD  ,   Diff_DA_FOOD  ,   Diff_DA_FOOD/CT_DA_FOOD*100(11.1),       '%\n',
             '        Manu       ', sum_DA_MANU  ,   CT_DA_MANU  ,   Diff_DA_MANU  ,   Diff_DA_MANU/CT_DA_MANU*100(11.1),       '%\n',
             '        WSLE       ', sum_DA_WSLE  ,   CT_DA_WSLE  ,   Diff_DA_WSLE  ,   Diff_DA_WSLE/CT_DA_WSLE*100(11.1),       '%\n',
             '        OFFI       ', sum_DA_OFFI  ,   CT_DA_OFFI  ,   Diff_DA_OFFI  ,   Diff_DA_OFFI/CT_DA_OFFI*100(11.1),       '%\n',
             '        GVED       ', sum_DA_GVED  ,   CT_DA_GVED  ,   Diff_DA_GVED  ,   Diff_DA_GVED/CT_DA_GVED*100(11.1),       '%\n',
             '        HLTH       ', sum_DA_HLTH  ,   CT_DA_HLTH  ,   Diff_DA_HLTH  ,   Diff_DA_HLTH/CT_DA_HLTH*100(11.1),       '%\n',
             '        OTHR       ', sum_DA_OTHR  ,   CT_DA_OTHR  ,   Diff_DA_OTHR  ,   Diff_DA_OTHR/CT_DA_OTHR*100(11.1),       '%\n',
             '        AGRI       ', sum_DA_AGRI  ,   CT_DA_AGRI  ,   Diff_DA_AGRI  ,   Diff_DA_AGRI/CT_DA_AGRI*100(11.1),       '%\n',
             '        MING       ', sum_DA_MING  ,   CT_DA_MING  ,   Diff_DA_MING  ,   Diff_DA_MING/CT_DA_MING*100(11.1),       '%\n',
             '        CONS       ', sum_DA_CONS  ,   CT_DA_CONS  ,   Diff_DA_CONS  ,   Diff_DA_CONS/CT_DA_CONS*100(11.1),       '%\n',
             '        HBJ        ', sum_DA_HBJ   ,   CT_DA_HBJ   ,   Diff_DA_HBJ   ,   Diff_DA_HBJ/CT_DA_HBJ*100(11.1),         '%\n',
             '\n',  
             '                         Model    Con Tot       Diff      % Diff\n',                                  
             '      Emp/HH Ratio ', sum_DA_EmpHH(11.2),  CT_DA_EmpHH(11.2),  Dif_DA_EmpHH(11.2),  Dif_DA_EmpHH/CT_DA_EmpHH*100(11.1),  '%\n',
             '\n',
             '      Enrollment - Elementary    ', sum_DA_Enrol_Elem, '\n',
             '      Enrollment - Middle School ', sum_DA_Enrol_Midl, '\n',
             '      Enrollment - High School   ', sum_DA_Enrol_High, '\n',
             '\n',
             '  Salt Lake:\n',
             '                         Model    Con Tot       Diff      % Diff\n',
             '      Households   ', sum_SL_HH ,           CT_SL_HH ,           Dif_SL_HH ,           Dif_SL_HH/CT_SL_HH*100(11.1)  ,       '%\n',
             '      Population   ', sum_SL_POP,           CT_SL_Pop,           Dif_SL_POP,           Dif_SL_POP/CT_SL_Pop*100(11.1),       '%\n', 
             '      Avg HH Size  ', sum_SL_HHSize(11.2),  CT_SL_HHSize(11.2),  Dif_SL_HHSize(11.2),  Dif_SL_HHSize/CT_SL_HHSize*100(11.1), '%\n',
             '\n', 
             '                         Model    Con Tot       Diff      % Diff\n',
             '      All Emp      ', sum_SL_ALLEMP,   CT_SL_ALLEMP,   Diff_SL_ALLEMP,   Diff_SL_ALLEMP/CT_SL_ALLEMP*100(11.1),   '%\n',
             '        RETL       ', sum_SL_RETL  ,   CT_SL_RETL  ,   Diff_SL_RETL  ,   Diff_SL_RETL/CT_SL_RETL*100(11.1),       '%\n',
             '        FOOD       ', sum_SL_FOOD  ,   CT_SL_FOOD  ,   Diff_SL_FOOD  ,   Diff_SL_FOOD/CT_SL_FOOD*100(11.1),       '%\n',
             '        Manu       ', sum_SL_MANU  ,   CT_SL_MANU  ,   Diff_SL_MANU  ,   Diff_SL_MANU/CT_SL_MANU*100(11.1),       '%\n',
             '        WSLE       ', sum_SL_WSLE  ,   CT_SL_WSLE  ,   Diff_SL_WSLE  ,   Diff_SL_WSLE/CT_SL_WSLE*100(11.1),       '%\n',
             '        OFFI       ', sum_SL_OFFI  ,   CT_SL_OFFI  ,   Diff_SL_OFFI  ,   Diff_SL_OFFI/CT_SL_OFFI*100(11.1),       '%\n',
             '        GVED       ', sum_SL_GVED  ,   CT_SL_GVED  ,   Diff_SL_GVED  ,   Diff_SL_GVED/CT_SL_GVED*100(11.1),       '%\n',
             '        HLTH       ', sum_SL_HLTH  ,   CT_SL_HLTH  ,   Diff_SL_HLTH  ,   Diff_SL_HLTH/CT_SL_HLTH*100(11.1),       '%\n',
             '        OTHR       ', sum_SL_OTHR  ,   CT_SL_OTHR  ,   Diff_SL_OTHR  ,   Diff_SL_OTHR/CT_SL_OTHR*100(11.1),       '%\n',
             '        AGRI       ', sum_SL_AGRI  ,   CT_SL_AGRI  ,   Diff_SL_AGRI  ,   Diff_SL_AGRI/CT_SL_AGRI*100(11.1),       '%\n',
             '        MING       ', sum_SL_MING  ,   CT_SL_MING  ,   Diff_SL_MING  ,   Diff_SL_MING/CT_SL_MING*100(11.1),       '%\n',
             '        CONS       ', sum_SL_CONS  ,   CT_SL_CONS  ,   Diff_SL_CONS  ,   Diff_SL_CONS/CT_SL_CONS*100(11.1),       '%\n',
             '        HBJ        ', sum_SL_HBJ   ,   CT_SL_HBJ   ,   Diff_SL_HBJ   ,   Diff_SL_HBJ/CT_SL_HBJ*100(11.1),         '%\n',
             '\n',  
             '                         Model    Con Tot       Diff      % Diff\n',                                  
             '      Emp/HH Ratio ', sum_SL_EmpHH(11.2),  CT_SL_EmpHH(11.2),  Dif_SL_EmpHH(11.2),  Dif_SL_EmpHH/CT_SL_EmpHH*100(11.1),  '%\n',
             '\n',
             '      Enrollment - Elementary    ', sum_SL_Enrol_Elem, '\n',
             '      Enrollment - Middle School ', sum_SL_Enrol_Midl, '\n',
             '      Enrollment - High School   ', sum_SL_Enrol_High, '\n'
    
    ;print region results to LOG file (split into two sections because print statement too long for Cube)
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
        APPEND=T, 
        FORM=11.0C, 
        LIST='  Utah:\n',
             '                         Model    Con Tot       Diff      % Diff\n',
             '      Households   ', sum_UT_HH ,           CT_UT_HH ,           Dif_UT_HH ,           Dif_UT_HH/CT_UT_HH*100(11.1)  ,       '%\n',
             '      Population   ', sum_UT_POP,           CT_UT_Pop,           Dif_UT_POP,           Dif_UT_POP/CT_UT_Pop*100(11.1),       '%\n', 
             '      Avg HH Size  ', sum_UT_HHSize(11.2),  CT_UT_HHSize(11.2),  Dif_UT_HHSize(11.2),  Dif_UT_HHSize/CT_UT_HHSize*100(11.1), '%\n',
             '\n', 
             '                         Model    Con Tot       Diff      % Diff\n',
             '      All Emp      ', sum_UT_ALLEMP,   CT_UT_ALLEMP,   Diff_UT_ALLEMP,   Diff_UT_ALLEMP/CT_UT_ALLEMP*100(11.1),   '%\n',
             '        RETL       ', sum_UT_RETL  ,   CT_UT_RETL  ,   Diff_UT_RETL  ,   Diff_UT_RETL/CT_UT_RETL*100(11.1),       '%\n',
             '        FOOD       ', sum_UT_FOOD  ,   CT_UT_FOOD  ,   Diff_UT_FOOD  ,   Diff_UT_FOOD/CT_UT_FOOD*100(11.1),       '%\n', 
             '        Manu       ', sum_UT_MANU  ,   CT_UT_MANU  ,   Diff_UT_MANU  ,   Diff_UT_MANU/CT_UT_MANU*100(11.1),       '%\n',
             '        WSLE       ', sum_UT_WSLE  ,   CT_UT_WSLE  ,   Diff_UT_WSLE  ,   Diff_UT_WSLE/CT_UT_WSLE*100(11.1),       '%\n',
             '        OFFI       ', sum_UT_OFFI  ,   CT_UT_OFFI  ,   Diff_UT_OFFI  ,   Diff_UT_OFFI/CT_UT_OFFI*100(11.1),       '%\n',
             '        GVED       ', sum_UT_GVED  ,   CT_UT_GVED  ,   Diff_UT_GVED  ,   Diff_UT_GVED/CT_UT_GVED*100(11.1),       '%\n',
             '        HLTH       ', sum_UT_HLTH  ,   CT_UT_HLTH  ,   Diff_UT_HLTH  ,   Diff_UT_HLTH/CT_UT_HLTH*100(11.1),       '%\n',
             '        OTHR       ', sum_UT_OTHR  ,   CT_UT_OTHR  ,   Diff_UT_OTHR  ,   Diff_UT_OTHR/CT_UT_OTHR*100(11.1),       '%\n',
             '        AGRI       ', sum_UT_AGRI  ,   CT_UT_AGRI  ,   Diff_UT_AGRI  ,   Diff_UT_AGRI/CT_UT_AGRI*100(11.1),       '%\n',
             '        MING       ', sum_UT_MING  ,   CT_UT_MING  ,   Diff_UT_MING  ,   Diff_UT_MING/CT_UT_MING*100(11.1),       '%\n',
             '        CONS       ', sum_UT_CONS  ,   CT_UT_CONS  ,   Diff_UT_CONS  ,   Diff_UT_CONS/CT_UT_CONS*100(11.1),       '%\n',
             '        HBJ        ', sum_UT_HBJ   ,   CT_UT_HBJ   ,   Diff_UT_HBJ   ,   Diff_UT_HBJ/CT_UT_HBJ*100(11.1),         '%\n',
             '\n',  
             '                         Model    Con Tot       Diff      % Diff\n',                                  
             '      Emp/HH Ratio ', sum_UT_EmpHH(11.2),  CT_UT_EmpHH(11.2),  Dif_UT_EmpHH(11.2),  Dif_UT_EmpHH/CT_UT_EmpHH*100(11.1),  '%\n',
             '\n',
             '      Enrollment - Elementary    ', sum_UT_Enrol_Elem, '\n',
             '      Enrollment - Middle School ', sum_UT_Enrol_Midl, '\n',
             '      Enrollment - High School   ', sum_UT_Enrol_High, '\n',
             '\n'
    
ENDRUN



;check SEfile input file
RUN PGM=MATRIX  MSG='SE Processing 1: demographic analysis - check SE file'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf', 
        SORT=Z, 
        AUTOARRAY=ALLFIELDS
    
    ;set MATRIX parameters
    ZONES = 1
    
    
    ;print errors to LOG file and set check_error variable
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
        APPEND=T, 
        LIST='\nChecking SE file for inconsistencies:'
    
    
    ;check gaps in TAZ numbering are dummy zones
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_Cnt  = TAZ_Cnt + 1
        TAZ_NUM  = dba.1.Z[RecLp]
        TAZ_Prev = dba.1.Z[RecLp-1]
        
        ;check gaps in records
        if (TAZ_Cnt<>TAZ_NUM)
            ;decide how to handle gaps found
            if (TAZ_NUM=TAZ_Prev & RecLp>1)
                ;skip duplicate record, will be checked in next section
                TAZ_Cnt = TAZ_Cnt - 1
            else
                ;determine number of zones missing from check file
                GapVal = TAZ_NUM - TAZ_Cnt
                
                ;loop through missing zones
                LOOP lpGap=1, GapVal
                    ;check if missing TAZ is a dummy or unused zone
                    if (TAZ_Cnt=@dummyzones@ | TAZ_Cnt=@externalzones@)
                        ;gap is unused zone, do not report in log
                    
                    else
                        ;if first error print header
                        if (check_Gap=0)
                            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                                APPEND=T, 
                                FORM=1.0, 
                                LIST='  The following Used Zones are missing in SE_File_@RID@.dbf or, if they are Unused Zones,\n',
                                     '  they are not in the dummyzones list in 0GeneralPrameters.block:'
                            
                            ;toggle check variable
                            check_Gap = 1
                        endif
                            
                        ;print error to LOG
                        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                            APPEND=T, 
                            FORM=10.0, 
                            LIST=TAZ_Cnt
                    endif
                    
                    ;increment count variable
                    TAZ_Cnt = TAZ_Cnt + 1
                ENDLOOP
            endif
        endif
    ENDLOOP
    
    
    ;check for duplicate TAZID
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_NUM  = dba.1.Z[RecLp]
        
        ;check for duplicate records
        if (RecLp<dbi.1.NUMRECORDS)
            TAZ_Next = dba.1.Z[RecLp+1]
            
            if (TAZ_NUM=TAZ_Next & TAZ_NUM>0)
                ;if first error print header
                if(check_Duplicate=0)
                    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                        APPEND=T, 
                        LIST='\n',
                             '\n',
                             '  Duplicate TAZID found:'
                    
                    ;toggle check variable
                    check_Duplicate = 1
                endif
                
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T, 
                    FORM=10.0, 
                    LIST=TAZ_NUM
            endif
        endif
    ENDLOOP
    
    
    ;check if SE field is negative
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_NUM  = dba.1.Z[RecLp]
        
        ;check if SE field is negative
        if (dba.1.TOTHH     <0 |
            dba.1.HHPOP     <0 |
            dba.1.HHSIZE    <0 |
            dba.1.TOTEMP    <0 |
            dba.1.RETEMP    <0 |
            dba.1.INDEMP    <0 |
            dba.1.OTHEMP    <0 |
            dba.1.ALLEMP    <0 |
            dba.1.RETL      <0 |
            dba.1.FOOD      <0 |
            dba.1.MANU      <0 |
            dba.1.WSLE      <0 |
            dba.1.OFFI      <0 |
            dba.1.GVED      <0 |
            dba.1.HLTH      <0 |
            dba.1.OTHR      <0 |
            dba.1.AGRI      <0 |
            dba.1.MING      <0 |
            dba.1.CONS      <0 |
            dba.1.HBJ       <0 |
            dba.1.AVGINCOME <0 |
            dba.1.Enrol_Elem<0 |
            dba.1.Enrol_Midl<0 |
            dba.1.Enrol_High<0  )
            
            if(check_Neg=0)
                ;print error message to LOG
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T, 
                    LIST='\n',
                         '\n',
                         '  TAZID with negative values in the SE data:'
                
                ;toggle check variable
                check_Neg = 1
            endif
                
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                APPEND=T, 
                FORM=10.0, 
                LIST=TAZ_NUM
        endif
    ENDLOOP
    
    
    ;check if HH > Pop
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_NUM  = dba.1.Z[RecLp]
        
        ;check if HH > Pop
        if (dba.1.TOTHH[RecLp]>dba.1.HHPOP[RecLp])
            if(check_HH=0)
                ;print error message to LOG
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T, 
                    LIST='\n',
                         '\n',
                         '  TAZID where TOTHH > HHPOP:'
                
                ;toggle check variable
                check_HH = 1
            endif
                
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                APPEND=T, 
                FORM=10.0, 
                LIST=TAZ_NUM
        endif
    ENDLOOP
    
    
    ;check if HH>0 or Pop>0 if the other is 0
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_NUM  = dba.1.Z[RecLp]
        
        ;check if HH>0 or Pop>0 if the other is 0
        if ((dba.1.TOTHH[RecLp]>0 & dba.1.HHPOP[RecLp]=0) | (dba.1.TOTHH[RecLp]=0 & dba.1.HHPOP[RecLp]>0))
            if(check_POPHH0=0)
                ;print error message to LOG
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T, 
                    LIST='\n',
                         '\n',
                         '  TAZID where HH=0 and POP>0 or HH>0 and POP=0:'
                
                ;toggle check variable
                check_POPHH0 = 1
            endif
                
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                APPEND=T, 
                FORM=10.0, 
                LIST=TAZ_NUM
        endif
    ENDLOOP
    
    
    ;check if SumEmp <> TotEmp
    LOOP RecLp=1, dbi.1.NUMRECORDS
        ;set variables
        TAZ_NUM  = dba.1.Z[RecLp]
        
        ;check if SumEmp <> TotEmp
        SumEmp1  = dba.1.RETEMP[RecLp] + 
                   dba.1.INDEMP[RecLp] + 
                   dba.1.OTHEMP[RecLp]
        
        SumEmp2  = dba.1.RETL[RecLp] +
                   dba.1.FOOD[RecLp] +
                   dba.1.MANU[RecLp] +
                   dba.1.WSLE[RecLp] +
                   dba.1.OFFI[RecLp] +
                   dba.1.GVED[RecLp] +
                   dba.1.HLTH[RecLp] +
                   dba.1.OTHR[RecLp] +
                   dba.1.AGRI[RecLp] +
                   dba.1.MING[RecLp] +
                   dba.1.CONS[RecLp] +
                   dba.1.HBJ[RecLp]
        
        EmpDiff1 = dba.1.TOTEMP[RecLp] - SumEmp1
        EmpDiff2 = dba.1.ALLEMP[RecLp] - SumEmp2
        
        if (EmpDiff1>2 | EmpDiff1<-2 | EmpDiff2>2 | EmpDiff2<-2)
            if(check_EMP=0)
                ;print error message to LOG
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                    APPEND=T, 
                    LIST='\n',
                         '\n',
                         '  TAZID where Sum of Employment Categories <> TOTEMP:'
                
                ;toggle check variable
                check_EMP = 1
            endif
                
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
                APPEND=T, 
                FORM=10.0, 
                LIST=TAZ_NUM
        endif
    ENDLOOP
    
    
    ;if no errors, print message in log
    if (check_Duplicate=0 & check_Gap=0 & check_Neg=0 & check_HH=0 & check_POPHH0=0 & check_EMP=0)
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
            APPEND=T, 
            LIST='  No inconsistencies found'
    endif
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
        APPEND=T, 
        LIST='\n'

ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Demographic Analysis               ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



;System cleanup
    *(DEL 1_DemographicAnalysis.txt)
