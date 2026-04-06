
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_TripGen.txt)



;get start time
ScriptStartTime = currenttime()




;calculate trip ends
RUN PGM=MATRIX  MSG='Trip Generation - calculate trip ends'

FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
FILEI ZDATI[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_HHSize_by_LifeCycle.dbf'
FILEI ZDATI[3] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_Worker.dbf'

FILEI ZDATI[4] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
          Z=TAZID 

FILEI ZDATI[5] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_TripEnds_@DemographicYear@.dbf',
    Z=TAZID

FILEI ZDATI[6] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'

FILEI MATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\AddTripTable.mtx'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\0_TripTables\TripTableControlTotal.csv'
FILEI LOOKUPI[2] = '@ParentDir@1_Inputs\0_GlobalData\0_TripTables\College_Factors.csv'
FILEI LOOKUPI[3] = '@ParentDir@1_Inputs\2_SEData\_ControlTotals\ControlTotal_WorkAtHome.csv'
FILEI LOOKUPI[4] = '@ParentDir@1_Inputs\0_GlobalData\2_TripGen\eCommerce.csv'

FILEO RECO[1] = '@ParentDir@@ScenarioDir@2_TripGen\pa.dbf', 
    FORM=10.1,
    FIELDS= Z(6.0),
            AREATYPE(6.0),
            CO_TAZID(10.0),
            CO_FIPS(6.0),
            SUBAREAID(6.0),
            
          TotPer_P,     TotPer_A,
             HBW_P,        HBW_A, 
           HBShp_P,      HBShp_A, 
           HBOth_P,      HBOth_A, 
        HBSch_PR_P,   HBSch_PR_A,     ;primary education (k to 6)
        HBSch_SC_P,   HBSch_SC_A,     ;secondary education (7 to 12)
            NHBW_P,       NHBW_A, 
           NHBNW_P,      NHBNW_A, 
       
          TotExt_P,     TotExt_A, 
              IX_P,         IX_A, 
              XI_P,         XI_A, 
      
        SH_Truck_P,   SH_Truck_A,
              LT_P,         LT_A, 
              MD_P,         MD_A, 
              HV_P,         HV_A, 
      
          IX_Trk_P,     IX_Trk_A, 
           IX_MD_P,      IX_MD_A, 
           IX_HV_P,      IX_HV_A, 
      
          XI_Trk_P,     XI_Trk_A, 
           XI_MD_P,      XI_MD_A, 
           XI_HV_P,      XI_HV_A, 
        
            TelHBW          ,
            TelNHBW         , 
            PctTelHBW(10.3) ,
            PctTelNHBW(10.3) 
    
    
    
    ;set MATRIX parameters
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
    endif  ;PrintProgress=CheckProgressress
    
    
    
    ;define arrays
    ARRAY HBWp        = @UsedZones@,    ;production arrays
          HBShpp      = @UsedZones@,
          HBOthp      = @UsedZones@,
          HBSchKto6p  = @UsedZones@,
          HBSch7to12p = @UsedZones@,
          HH_NHBWp    = @UsedZones@,
          HH_NHBNWp   = @UsedZones@,
          NHBWp       = @UsedZones@,
          NHBNWp      = @UsedZones@,
          IXp         = @UsedZones@,
          XIp         = @UsedZones@,
          LT_Peop_P   = @UsedZones@,
          MD_Peop_P   = @UsedZones@,
          LT_Good_P   = @UsedZones@,
          MD_Good_P   = @UsedZones@,
          HV_Good_P   = @UsedZones@,
          LT_Serv_P   = @UsedZones@,
          MD_Serv_P   = @UsedZones@,
          HV_Serv_P   = @UsedZones@,
          IX_MDp      = @UsedZones@,
          IX_HVp      = @UsedZones@,
          XI_MDp      = @UsedZones@,
          XI_HVp      = @UsedZones@,
          
          HBWa        = @UsedZones@,    ;attraction arrays
          HBShpa      = @UsedZones@,
          HBOtha      = @UsedZones@,
          HBSchKto6a  = @UsedZones@,
          HBSch7to12a = @UsedZones@,
          NHBWa       = @UsedZones@,
          NHBNWa      = @UsedZones@,
          IXa         = @UsedZones@,
          XIa         = @UsedZones@,
          LT_Peop_A   = @UsedZones@,
          MD_Peop_A   = @UsedZones@,
          LT_Good_A   = @UsedZones@,
          MD_Good_A   = @UsedZones@,
          HV_Good_A   = @UsedZones@,
          LT_Serv_A   = @UsedZones@,
          MD_Serv_A   = @UsedZones@,
          HV_Serv_A   = @UsedZones@,
          IX_MDa      = @UsedZones@,
          IX_HVa      = @UsedZones@,
          XI_MDa      = @UsedZones@,
          XI_HVa      = @UsedZones@,
          
          LT_Good_noAdj = @UsedZones@,
          MD_Good_noAdj = @UsedZones@,
          HV_Good_noAdj = @UsedZones@,
          
          Telecom_HBWa      = @UsedZones@,
          Telecom_NHBWa     = @UsedZones@,
          Pct_Telecom_HBWa  = @UsedZones@,
          Pct_Telecom_NHBWa = @UsedZones@
    
    
    
    ;define lookup functions
    
    ;trip table control totals
    LOOKUP LOOKUPI=1,
        LIST=F,
        INTERPOLATE=T,
        NAME=ControlTotal,
        Lookup[01]=01,  RESULT=02,    ;Airport
        Lookup[02]=01,  RESULT=03,    ;PVU
        Lookup[03]=01,  RESULT=04,    ;Lagoon
        Lookup[04]=01,  RESULT=05,    ;Ensign
        Lookup[05]=01,  RESULT=06,    ;Westmin
        Lookup[06]=01,  RESULT=07,    ;UofU_Main
        Lookup[07]=01,  RESULT=08,    ;UofU_Med
        Lookup[08]=01,  RESULT=09,    ;WSU_Main
        Lookup[09]=01,  RESULT=10,    ;WSU_Davis
        Lookup[10]=01,  RESULT=11,    ;WSU_West
        Lookup[11]=01,  RESULT=12,    ;SLCC_Main
        Lookup[12]=01,  RESULT=13,    ;SLCC_SC
        Lookup[13]=01,  RESULT=14,    ;SLCC_JD
        Lookup[14]=01,  RESULT=15,    ;SLCC_Mead
        Lookup[15]=01,  RESULT=16,    ;SLCC_ML
        Lookup[16]=01,  RESULT=17,    ;SLCC_LB
        Lookup[17]=01,  RESULT=18,    ;SLCC_HL
        Lookup[18]=01,  RESULT=19,    ;SLCC_Airp
        Lookup[19]=01,  RESULT=20,    ;SLCC_West
        Lookup[20]=01,  RESULT=21,    ;SLCC_HM
        Lookup[21]=01,  RESULT=22,    ;BYU
        Lookup[22]=01,  RESULT=23,    ;UVU_Main
        Lookup[23]=01,  RESULT=24,    ;UVU_Geneva
        Lookup[24]=01,  RESULT=25,    ;UVU_Lehi
        Lookup[25]=01,  RESULT=26,    ;UVU_Vine
        Lookup[26]=01,  RESULT=27     ;UVU_Payson
    
    ;Lookup Concurrent/Online degree percent
    ;note: index 1 = Pct_Remove
    ;      index 2 = FTERate   
    ;      index 3 = HBCRates  
    LOOKUP LOOKUPI=2,
        LIST=F,
        INTERPOLATE=F,
        NAME=FTE_Rate,
        Lookup[01]=01,  RESULT=02,    ;Ensign      
        Lookup[02]=01,  RESULT=03,    ;Westmin    
        Lookup[03]=01,  RESULT=04,    ;UofU_Main  
        Lookup[04]=01,  RESULT=05,    ;UofU_Med   
        Lookup[05]=01,  RESULT=06,    ;WSU_Main   
        Lookup[06]=01,  RESULT=07,    ;WSU_Davis  
        Lookup[07]=01,  RESULT=08,    ;WSU_West   
        Lookup[08]=01,  RESULT=09,    ;SLCC_Main    
        Lookup[09]=01,  RESULT=10,    ;SLCC_SC   
        Lookup[10]=01,  RESULT=11,    ;SLCC_JD   
        Lookup[11]=01,  RESULT=12,    ;SLCC_Mead 
        Lookup[12]=01,  RESULT=13,    ;SLCC_ML   
        Lookup[13]=01,  RESULT=14,    ;SLCC_LB   
        Lookup[14]=01,  RESULT=15,    ;SLCC_HL   
        Lookup[15]=01,  RESULT=16,    ;SLCC_Airp 
        Lookup[16]=01,  RESULT=17,    ;SLCC_West 
        Lookup[17]=01,  RESULT=18,    ;SLCC_HM   
        Lookup[18]=01,  RESULT=19,    ;BYU       
        Lookup[19]=01,  RESULT=20,    ;UVU_Main  
        Lookup[20]=01,  RESULT=21,    ;UVU_Geneva
        Lookup[21]=01,  RESULT=22,    ;UVU_Lehi
        Lookup[22]=01,  RESULT=23,    ;UVU_Vine  
        Lookup[23]=01,  RESULT=24     ;UVU_Payson
    
    
    ;Lookup telecommuting rates by employmnet type
    LOOKUP LOOKUPI=3,
        LIST=F,
        INTERPOLATE=F,
        NAME=WAH_Rate,
        Lookup[01]=01,  RESULT=04,    ;Tel_RETL
        Lookup[02]=01,  RESULT=05,    ;Tel_FOOD
        Lookup[03]=01,  RESULT=06,    ;Tel_MANU
        Lookup[04]=01,  RESULT=07,    ;Tel_WSLE
        Lookup[05]=01,  RESULT=08,    ;Tel_OFFI
        Lookup[06]=01,  RESULT=09,    ;Tel_GVED
        Lookup[07]=01,  RESULT=10,    ;Tel_HLTH
        Lookup[08]=01,  RESULT=11,    ;Tel_OTHR
        Lookup[09]=01,  RESULT=12,    ;Tel_AGRI
        Lookup[10]=01,  RESULT=13,    ;Tel_MING
        Lookup[11]=01,  RESULT=14,    ;Tel_CONS
        Lookup[12]=01,  RESULT=15,    ;HBJ_RETL
        Lookup[13]=01,  RESULT=16,    ;HBJ_FOOD
        Lookup[14]=01,  RESULT=17,    ;HBJ_MANU
        Lookup[15]=01,  RESULT=18,    ;HBJ_WSLE
        Lookup[16]=01,  RESULT=19,    ;HBJ_OFFI
        Lookup[17]=01,  RESULT=20,    ;HBJ_GVED
        Lookup[18]=01,  RESULT=21,    ;HBJ_HLTH
        Lookup[19]=01,  RESULT=22,    ;HBJ_OTHR
        Lookup[20]=01,  RESULT=23,    ;HBJ_AGRI
        Lookup[21]=01,  RESULT=24,    ;HBJ_MING
        Lookup[22]=01,  RESULT=25,    ;HBJ_CONS
        Lookup[23]=01,  RESULT=26,    ;Tot_HBJ
        Lookup[24]=01,  RESULT=27,    ;Tot_Tel
        Lookup[25]=01,  RESULT=28     ;Tot_WAH

    
    ;Lookup eCommerce rates by employmnet type
    LOOKUP LOOKUPI=4,
        LIST=F,
        INTERPOLATE=F,
        NAME=Fac_eCommerce,
        Lookup[01]=01,  RESULT=02,    ;LT_Ind
        Lookup[02]=01,  RESULT=03,    ;LT_Ret
        Lookup[03]=01,  RESULT=04,    ;LT_Oth
        Lookup[04]=01,  RESULT=05,    ;LT_HH 
        Lookup[05]=01,  RESULT=06,    ;MD_Ind
        Lookup[06]=01,  RESULT=07,    ;MD_Ret
        Lookup[07]=01,  RESULT=08,    ;MD_Oth
        Lookup[08]=01,  RESULT=09,    ;MD_HH 
        Lookup[09]=01,  RESULT=10,    ;HV_Ind
        Lookup[10]=01,  RESULT=11,    ;HV_Ret
        Lookup[11]=01,  RESULT=12,    ;HV_Oth
        Lookup[12]=01,  RESULT=13     ;HV_HH 
    
    
    
    
    ;process school and college ==============================================================================
    if (i=1)
        
        ;calc HBSch & College Enrollment processing variables
        LOOP iter=1,ZONES
            
            ;sum primary and secondary education enrollment totals
            tot_PrimaryEd   = tot_PrimaryEd   + zi.1.ENROL_ELEM[iter]
            tot_SecondaryEd = tot_SecondaryEd + zi.1.ENROL_MIDL[iter] + zi.1.ENROL_HIGH[iter]
            
            
            ;sum college trips-to-campus totals
            HBCa_Ensign     = HBCa_Ensign     + MATVAL(1, 2, iter, @Ensign@    )
            HBCa_Westmin    = HBCa_Westmin    + MATVAL(1, 2, iter, @Westmin@   )
            HBCa_UofU_Main  = HBCa_UofU_Main  + MATVAL(1, 2, iter, @UOFU_Main@ )
            HBCa_UofU_Med   = HBCa_UofU_Med   + MATVAL(1, 2, iter, @UOFU_Med@  )
            HBCa_WSU_Main   = HBCa_WSU_Main   + MATVAL(1, 2, iter, @WSU_Main@  )
            HBCa_WSU_Davis  = HBCa_WSU_Davis  + MATVAL(1, 2, iter, @WSU_Davis@ )
            HBCa_WSU_West   = HBCa_WSU_West   + MATVAL(1, 2, iter, @WSU_West@  )
            HBCa_SLCC_Main  = HBCa_SLCC_Main  + MATVAL(1, 2, iter, @SLCC_Main@ )
            HBCa_SLCC_SC    = HBCa_SLCC_SC    + MATVAL(1, 2, iter, @SLCC_SC@   )
            HBCa_SLCC_JD    = HBCa_SLCC_JD    + MATVAL(1, 2, iter, @SLCC_JD@   )
            HBCa_SLCC_Mead  = HBCa_SLCC_Mead  + MATVAL(1, 2, iter, @SLCC_Mead@ )
            HBCa_SLCC_ML    = HBCa_SLCC_ML    + MATVAL(1, 2, iter, @SLCC_ML@   )
            HBCa_SLCC_LB    = HBCa_SLCC_LB    + MATVAL(1, 2, iter, @SLCC_LB@   )
            HBCa_SLCC_HL    = HBCa_SLCC_HL    + MATVAL(1, 2, iter, @SLCC_HL@   )
            HBCa_SLCC_Airp  = HBCa_SLCC_Airp  + MATVAL(1, 2, iter, @SLCC_Airp@ )
            HBCa_SLCC_West  = HBCa_SLCC_West  + MATVAL(1, 2, iter, @SLCC_West@ )
            HBCa_SLCC_HM    = HBCa_SLCC_HM    + MATVAL(1, 2, iter, @SLCC_HM@   )
            HBCa_BYU        = HBCa_BYU        + MATVAL(1, 2, iter, @BYU@       )
            HBCa_UVU_Main   = HBCa_UVU_Main   + MATVAL(1, 2, iter, @UVU_Main@  )
            HBCa_UVU_Geneva = HBCa_UVU_Geneva + MATVAL(1, 2, iter, @UVU_Geneva@)
            HBCa_UVU_Lehi   = HBCa_UVU_Lehi   + MATVAL(1, 2, iter, @UVU_Lehi@  )
            HBCa_UVU_Vine   = HBCa_UVU_Vine   + MATVAL(1, 2, iter, @UVU_Vine@  )
            HBCa_UVU_Payson = HBCa_UVU_Payson + MATVAL(1, 2, iter, @UVU_Payson@)
            
        ENDLOOP
        
        
        ;calculate elementary and secondary education ratio
        totEnroll  = tot_PrimaryEd + tot_SecondaryEd
        Elem_Share = tot_PrimaryEd / totEnroll
        
        
        ;calculate college FTE totals
        ;assign forecast year
        Year = @demographicyear@
        
        ;calculate college FTE equivalent
        FTE_Ensign     = ControlTotal(04, Year) / FTE_Rate(01, 2)    ;Ensign    
        FTE_Westmin    = ControlTotal(05, Year) / FTE_Rate(02, 2)    ;Westmin   
        FTE_UOFU_Main  = ControlTotal(06, Year) / FTE_Rate(03, 2)    ;UofU_Main 
        FTE_UOFU_Med   = ControlTotal(07, Year) / FTE_Rate(04, 2)    ;UofU_Med  
        FTE_WSU_Main   = ControlTotal(08, Year) / FTE_Rate(05, 2)    ;WSU_Main  
        FTE_WSU_Davis  = ControlTotal(09, Year) / FTE_Rate(06, 2)    ;WSU_Davis 
        FTE_WSU_West   = ControlTotal(10, Year) / FTE_Rate(07, 2)    ;WSU_West  
        FTE_SLCC_Main  = ControlTotal(11, Year) / FTE_Rate(08, 2)    ;SLCC_Main 
        FTE_SLCC_SC    = ControlTotal(12, Year) / FTE_Rate(09, 2)    ;SLCC_SC   
        FTE_SLCC_JD    = ControlTotal(13, Year) / FTE_Rate(10, 2)    ;SLCC_JD   
        FTE_SLCC_Mead  = ControlTotal(14, Year) / FTE_Rate(11, 2)    ;SLCC_Mead 
        FTE_SLCC_ML    = ControlTotal(15, Year) / FTE_Rate(12, 2)    ;SLCC_ML   
        FTE_SLCC_LB    = ControlTotal(16, Year) / FTE_Rate(13, 2)    ;SLCC_LB   
        FTE_SLCC_HL    = ControlTotal(17, Year) / FTE_Rate(14, 2)    ;SLCC_HL   
        FTE_SLCC_Airp  = ControlTotal(18, Year) / FTE_Rate(15, 2)    ;SLCC_Airp 
        FTE_SLCC_West  = ControlTotal(19, Year) / FTE_Rate(16, 2)    ;SLCC_West 
        FTE_SLCC_HM    = ControlTotal(20, Year) / FTE_Rate(17, 2)    ;SLCC_HM   
        FTE_BYU        = ControlTotal(21, Year) / FTE_Rate(18, 2)    ;BYU       
        FTE_UVU_Main   = ControlTotal(22, Year) / FTE_Rate(19, 2)    ;UVU_Main  
        FTE_UVU_Geneva = ControlTotal(23, Year) / FTE_Rate(20, 2)    ;UVU_Geneva
        FTE_UVU_Lehi   = ControlTotal(24, Year) / FTE_Rate(21, 2)    ;UVU_Lehi  
        FTE_UVU_Vine   = ControlTotal(25, Year) / FTE_Rate(22, 2)    ;UVU_Vine  
        FTE_UVU_Payson = ControlTotal(26, Year) / FTE_Rate(23, 2)    ;UVU_Payson
        
    endif  ;i=1
    
    
    
    
    ;cacluate SE totals ======================================================================================
    TOTHH = zi.1.TOTHH[i]
    RETL  = zi.1.RETL[i]
    FOOD  = zi.1.FOOD[i]
    MANU  = zi.1.MANU[i]
    WSLE  = zi.1.WSLE[i]
    OFFI  = zi.1.OFFI[i]
    GVED  = zi.1.GVED[i]
    HLTH  = zi.1.HLTH[i]
    OTHR  = zi.1.OTHR[i]
    AGRI  = zi.1.AGRI[i]
    MING  = zi.1.MING[i]
    CONS  = zi.1.CONS[i]
    
    
    RETEMP = RETL + 
             FOOD
    
    INDEMP = MANU + 
             WSLE
    
    OTHEMP = OFFI + 
             GVED + 
             HLTH + 
             OTHR
    
    TOTEMP = RETEMP + 
             INDEMP + 
             OTHEMP
    
    ALLEMP = TOTEMP + 
             AGRI   + 
             MING   + 
             CONS
    
    TotalHH  = TotalHH  + TOTHH
    TotalEMP = TotalEmp + TOTEMP
    
    
    
    
    ;calculate trip PRODUCTIONS ==============================================================================
    ;calculate total household productions (II + IX)
    ;person trips
    HBWp[i]      =  0.000 * zi.3.Wrk0[i]    + 
                    1.764 * zi.3.Wrk1[i]    +
                    3.073 * zi.3.Wrk2[i]    +
                    4.698 * zi.3.Wrk3[i]    
                        
    HBShpp[i]    =  0.443 * zi.2.HH1_LC1[i] +
                    0.706 * zi.2.HH2_LC1[i] +
                    0.757 * zi.2.HH3_LC1[i] +
                    1.088 * zi.2.HH4_LC1[i] +
                    1.548 * zi.2.HH5_LC1[i] +
                    2.013 * zi.2.HH6_LC1[i] +
                    0.000 * zi.2.HH1_LC2[i] +
                    0.681 * zi.2.HH2_LC2[i] +
                    1.344 * zi.2.HH3_LC2[i] +
                    1.720 * zi.2.HH4_LC2[i] +
                    1.818 * zi.2.HH5_LC2[i] +
                    1.916 * zi.2.HH6_LC2[i] +
                    0.561 * zi.2.HH1_LC3[i] +  
                    1.149 * zi.2.HH2_LC3[i] +
                    1.272 * zi.2.HH3_LC3[i] +
                    1.404 * zi.2.HH4_LC3[i] +
                    1.683 * zi.2.HH5_LC3[i] +
                    1.960 * zi.2.HH6_LC3[i]  
                        
    HBOthp[i]    =  1.313 * zi.2.HH1_LC1[i] +
                    2.382 * zi.2.HH2_LC1[i] +
                    3.657 * zi.2.HH3_LC1[i] +
                    5.128 * zi.2.HH4_LC1[i] +
                    7.380 * zi.2.HH5_LC1[i] +
                    9.643 * zi.2.HH6_LC1[i] +
                    0.000 * zi.2.HH1_LC2[i] +
                    2.508 * zi.2.HH2_LC2[i] +
                    4.437 * zi.2.HH3_LC2[i] +
                    6.115 * zi.2.HH4_LC2[i] +
                    8.310 * zi.2.HH5_LC2[i] +
                   10.703 * zi.2.HH6_LC2[i] +
                    1.841 * zi.2.HH1_LC3[i] +  
                    3.673 * zi.2.HH2_LC3[i] +
                    4.175 * zi.2.HH3_LC3[i] +
                    4.676 * zi.2.HH4_LC3[i] +
                    6.450 * zi.2.HH5_LC3[i] +
                    8.958 * zi.2.HH6_LC3[i]  
                        
    TAZHBSchp    =  0.000 * zi.2.HH1_LC1[i] +
                    0.000 * zi.2.HH2_LC1[i] +
                    0.000 * zi.2.HH3_LC1[i] +
                    0.000 * zi.2.HH4_LC1[i] +
                    0.000 * zi.2.HH5_LC1[i] +
                    0.000 * zi.2.HH6_LC1[i] +
                    0.000 * zi.2.HH1_LC2[i] +
                    0.530 * zi.2.HH2_LC2[i] +
                    0.675 * zi.2.HH3_LC2[i] +
                    1.117 * zi.2.HH4_LC2[i] +
                    2.473 * zi.2.HH5_LC2[i] +
                    3.819 * zi.2.HH6_LC2[i] +
                    0.000 * zi.2.HH1_LC3[i] +
                    0.009 * zi.2.HH2_LC3[i] +
                    0.067 * zi.2.HH3_LC3[i] +
                    0.427 * zi.2.HH4_LC3[i] +
                    1.446 * zi.2.HH5_LC3[i] +
                    2.865 * zi.2.HH6_LC3[i] 
                        
    HH_NHBWp[i]  =  0.000 * zi.3.Wrk0[i]    +               ;NHB production regional totals are used to scale the magnitude of NHB trip ends 
                    0.856 * zi.3.Wrk1[i]    +               ;NHB productions at the TAZ level are set based on the attraction equations     
                    1.361 * zi.3.Wrk2[i]    +
                    1.781 * zi.3.Wrk3[i]     
                        
    HH_NHBNWp[i] =  0.632 * zi.2.HH1_LC1[i] +
                    1.013 * zi.2.HH2_LC1[i] +
                    1.542 * zi.2.HH3_LC1[i] +
                    1.820 * zi.2.HH4_LC1[i] +
                    1.989 * zi.2.HH5_LC1[i] +
                    2.159 * zi.2.HH6_LC1[i] +
                    0.000 * zi.2.HH1_LC2[i] +
                    1.499 * zi.2.HH2_LC2[i] +
                    1.738 * zi.2.HH3_LC2[i] +
                    2.618 * zi.2.HH4_LC2[i] +
                    3.282 * zi.2.HH5_LC2[i] +
                    3.852 * zi.2.HH6_LC2[i] +
                    0.990 * zi.2.HH1_LC3[i] +  
                    1.928 * zi.2.HH2_LC3[i] +
                    2.408 * zi.2.HH3_LC3[i] +
                    2.676 * zi.2.HH4_LC3[i] +
                    2.890 * zi.2.HH5_LC3[i] +
                    2.997 * zi.2.HH6_LC3[i]  
    
    HBSchKto6p[i]  = TAZHBSchp * Elem_Share
    HBSch7to12p[i] = TAZHBSchp * (1 - Elem_Share)
    
    
    
    ;separate IX and II from total household production ------------------------------------------------------
    
    ;determine IX share factors (from HH Survey)
    if (zi.4.CO_FIPS[i]=3 )  Share_IX_Wrk = 0.196     ;Box Elder
    if (zi.4.CO_FIPS[i]=57)  Share_IX_Wrk = 0.035     ;Weber
    if (zi.4.CO_FIPS[i]=11)  Share_IX_Wrk = 0.009     ;Davis
    if (zi.4.CO_FIPS[i]=35)  Share_IX_Wrk = 0.018     ;Salt Lake
    if (zi.4.CO_FIPS[i]=49)  Share_IX_Wrk = 0.017     ;Utah
    
    if (zi.4.CO_FIPS[i]=3 )  Share_IX_NWk = 0.052     ;Box Elder
    if (zi.4.CO_FIPS[i]=57)  Share_IX_NWk = 0.016     ;Weber
    if (zi.4.CO_FIPS[i]=11)  Share_IX_NWk = 0.011     ;Davis
    if (zi.4.CO_FIPS[i]=35)  Share_IX_NWk = 0.015     ;Salt Lake
    if (zi.4.CO_FIPS[i]=49)  Share_IX_NWk = 0.010     ;Utah
    
    
    ;calculate share of household productions - IX
    IX_HBW   = HBWp[i]      * Share_IX_Wrk
    
    IX_HBShp = HBShpp[i]    * Share_IX_NWk
    IX_HBOth = HBOthp[i]    * Share_IX_NWk
    IX_NHBW  = HH_NHBWp[i]  * Share_IX_NWk
    IX_NHBNW = HH_NHBNWp[i] * Share_IX_NWk
    
    ;assume all HBSch trips stay internal
    
    
    ;determine II productions
    HBWp[i]      = HBWp[i]      - IX_HBW
    HBShpp[i]    = HBShpp[i]    - IX_HBShp
    HBOthp[i]    = HBOthp[i]    - IX_HBOth
    HH_NHBWp[i]  = HH_NHBWp[i]  - IX_NHBW 
    HH_NHBNWp[i] = HH_NHBNWp[i] - IX_NHBNW
    
    
    ;bump up NHB trips to account for visitor NHB trips (from HH Survey)
    HH_NHBWp[i]  = HH_NHBWp[i]  * 1.046
    HH_NHBNWp[i] = HH_NHBNWp[i] * 1.049
    
    
    
    ;calculate IX productions --------------------------------------------------------------------------------
    ; note: IX attractions are in vehicle trips
    IXp[i] = (IX_HBW   +
              IX_HBShp +
              IX_HBOth +
              IX_NHBW  +
              IX_NHBNW  ) / 1.54     ;IX Veh Occupancy = 1.67 (2012 HH Survey)
    
    
    
    ;read in XI productions ----------------------------------------------------------------------------------
    XIp[i]    = zi.5.P_XI_PL[i]
    
    
    
    ;calculate Short Haul CV/Truck productions ---------------------------------------------------------------
    ;set index (scenario) for E-Commerce lookup
    Idx_ECommerce = 1                        ;default to base
    
    if (@ECommerce@=2)  Idx_ECommerce = 2    ;scenario - low
    if (@ECommerce@=3)  Idx_ECommerce = 3    ;scenario - medium
    if (@ECommerce@=4)  Idx_ECommerce = 4    ;scenario - high
    
    
    Fac_ECom_LT_Ind = Fac_eCommerce(01, Idx_ECommerce)    ;LT_Ind
    Fac_ECom_LT_Ret = Fac_eCommerce(02, Idx_ECommerce)    ;LT_Ret
    Fac_ECom_LT_Oth = Fac_eCommerce(03, Idx_ECommerce)    ;LT_Oth
    Fac_ECom_LT_HH  = Fac_eCommerce(04, Idx_ECommerce)    ;LT_HH 
    
    Fac_ECom_MD_Ind = Fac_eCommerce(05, Idx_ECommerce)    ;MD_Ind
    Fac_ECom_MD_Ret = Fac_eCommerce(06, Idx_ECommerce)    ;MD_Ret
    Fac_ECom_MD_Oth = Fac_eCommerce(07, Idx_ECommerce)    ;MD_Oth
    Fac_ECom_MD_HH  = Fac_eCommerce(08, Idx_ECommerce)    ;MD_HH 
    
    Fac_ECom_HV_Ind = Fac_eCommerce(09, Idx_ECommerce)    ;HV_Ind
    Fac_ECom_HV_Ret = Fac_eCommerce(10, Idx_ECommerce)    ;HV_Ret
    Fac_ECom_HV_Oth = Fac_eCommerce(11, Idx_ECommerce)    ;HV_Oth
    Fac_ECom_HV_HH  = Fac_eCommerce(12, Idx_ECommerce)    ;HV_HH 
    
    ;calculate eCommerce average employment factor
    Fac_ECom_LT_Emp = 1
    Fac_ECom_MD_Emp = 1
    Fac_ECom_HV_Emp = 1
    
    if ((INDEMP + RETEMP + OTHEMP)>0)  Fac_ECom_LT_Emp = (Fac_ECom_LT_Ind * INDEMP + Fac_ECom_LT_Ret * RETEMP + Fac_ECom_LT_Oth * OTHEMP) / (INDEMP + RETEMP + OTHEMP)
    if ((INDEMP + RETEMP + OTHEMP)>0)  Fac_ECom_MD_Emp = (Fac_ECom_MD_Ind * INDEMP + Fac_ECom_MD_Ret * RETEMP + Fac_ECom_MD_Oth * OTHEMP) / (INDEMP + RETEMP + OTHEMP)
    if ((INDEMP + RETEMP + OTHEMP)>0)  Fac_ECom_HV_Emp = (Fac_ECom_HV_Ind * INDEMP + Fac_ECom_HV_Ret * RETEMP + Fac_ECom_HV_Oth * OTHEMP) / (INDEMP + RETEMP + OTHEMP)
    
    
    ;proportion of truck trips to apply eCommerce factors
    Share_ECom_LT = 0.55
    Share_ECom_MD = 0.80
    Share_ECom_HV = 0.80
    
    
    ;prod rate for residential variables
    ResRate_LT = 0.74745
    ResRate_MD = 0.44427
    ResRate_HV = 0.17481
    
    ;prod rate for employment variables
    EmpRate_LT = 0.25703
    EmpRate_MD = 0.18750
    EmpRate_HV = 0.11021
    
    
    ;calculate LT, MD & HV productions without adjustment for eCommerce (for reporting)
    LT_Good_noAdj[i] = ResRate_LT * TOTHH  +  EmpRate_LT * TOTEMP
    MD_Good_noAdj[i] = ResRate_MD * TOTHH  +  EmpRate_MD * TOTEMP
    HV_Good_noAdj[i] = ResRate_HV * TOTHH  +  EmpRate_HV * TOTEMP
    
    
    ;calculate LT, MD & HV productions with adjustment for eCommerce (used by the model)
    LT_Good_p[i] = Share_ECom_LT       * (ResRate_LT * TOTHH * Fac_ECom_LT_HH + EmpRate_LT * TOTEMP * Fac_ECom_LT_Emp) +
                   (1 - Share_ECom_LT) * (ResRate_LT * TOTHH                  + EmpRate_LT * TOTEMP                  )
    
    MD_Good_p[i] = Share_ECom_MD       * (ResRate_MD * TOTHH * Fac_ECom_MD_HH + EmpRate_MD * TOTEMP * Fac_ECom_MD_Emp) +
                   (1 - Share_ECom_MD) * (ResRate_MD * TOTHH                  + EmpRate_MD * TOTEMP                  )
    
    HV_Good_p[i] = Share_ECom_HV       * (ResRate_HV * TOTHH * Fac_ECom_HV_HH + EmpRate_HV * TOTEMP * Fac_ECom_HV_Emp) +
                   (1 - Share_ECom_HV) * (ResRate_HV * TOTHH                  + EmpRate_HV * TOTEMP                  )
    
    
    
    ;;moving people
    ;LT_Peop_p[i] = 0.00000 *  TOTHH                         +      ;school bus
    ;               0.00227 * (TOTHH + TOTEMP)               +      ;shuttle service
    ;               0.00642 *          TOTEMP                +      ;private transport
    ;               0.00000 * (TOTHH + TOTEMP)               +      ;Paratransit
    ;               0.05426 * (TOTHH + TOTEMP)                      ;Rental Cars
    ;                                   
    ;MD_Peop_p[i] = 0.00000 *  TOTHH                         +      ;school bus
    ;               0.00026 * (TOTHH + TOTEMP)               +      ;shuttle service
    ;               0.00000 *          TOTEMP                +      ;private transport
    ;               0.00119 * (TOTHH + TOTEMP)               +      ;Paratransit
    ;               0.00627 * (TOTHH + TOTEMP)                      ;Rental Cars
    ;
    ;;goods
    ;;  calculate SH goods trips with no eCommerce adjustments
    ;LT_Good_noAdj[i] = 0.01679 * (TOTHH + TOTEMP)               +      ;package, product, mail   ; 0.16790 / 10 = 0.01679
    ;                   0.32908 * (AGRI + MING)                  +      ;urban freight
    ;                   0.16790 *  INDEMP                        +      ;urban freight            ; 0.33579 / 2 = 0.16790
    ;                   0.48442 *  RETEMP                        +      ;urban freight
    ;                   0.15141 *  OTHEMP                        +      ;urban freight
    ;                   0.27554 *  TOTHH                         +      ;urban freight
    ;                   0.00890 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    ;                                                        
    ;MD_Good_noAdj[i] = 0.00797 * (TOTHH + TOTEMP)               +      ;package, product, mail   ; 0.00199 + (0.05982 / 10 = 0.00598) = 0.00797
    ;                   0.35277 * (AGRI + MING)                  +      ;urban freight
    ;                   0.05982 *  INDEMP                        +      ;urban freight            ; 0.11964 / 2 = 0.05982
    ;                   0.54317 *  RETEMP                        +      ;urban freight
    ;                   0.13447 *  OTHEMP                        +      ;urban freight
    ;                   0.29110 *  TOTHH                         +      ;urban freight
    ;                   0.00278 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    ;                          
    ;HV_Good_noAdj[i] = 0.00688 * (TOTHH + TOTEMP)               +      ;package, product, mail   ; 0.00140 + (0.32868 / 60 = 0.00548) = 0.00688
    ;                   0.54375 * (AGRI + MING)                  +      ;urban freight
    ;                   0.32868 *  INDEMP                        +      ;urban freight            ; 0.65735 / 2 = 0.32868
    ;                   0.41083 *  RETEMP                        +      ;urban freight
    ;                   0.05688 *  OTHEMP                        +      ;urban freight
    ;                   0.00000 *  TOTHH                         +      ;urban freight
    ;                   0.00686 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    ;
    ;;services
    ;LT_Serv_p[i] = 0.01039 * (TOTHH + TOTEMP)               +      ;safety
    ;               0.02272 *  TOTHH                         +      ;utility vehicles
    ;               0.03479 * (TOTHH + TOTEMP)               +      ;public services
    ;               0.05298 * (TOTHH + TOTEMP)                      ;business/Personal Services
    ;                                              
    ;MD_Serv_p[i] = 0.00529 * (TOTHH + TOTEMP)               +      ;safety
    ;               0.01158 *  TOTHH                         +      ;utility vehicles
    ;               0.01338 * (TOTHH + TOTEMP)               +      ;public services
    ;               0.01128 * (TOTHH + TOTEMP)                      ;business/Personal Services
    ;                                              
    ;HV_Serv_p[i] = 0.00630 * (TOTHH + TOTEMP)               +      ;safety
    ;               0.01377 *  TOTHH                         +      ;utility vehicles
    ;               0.00000 * (TOTHH + TOTEMP)               +      ;public services
    ;               0.00000 * (TOTHH + TOTEMP)                      ;business/Personal Services
    
    
    ;re-calculate SH goods with eCommerce adjustments
    ;goods
    ;  calculate SH goods trips with no eCommerce adjustments
    ;LT_Good_p[i] = 0.01679 * (TOTHH + TOTEMP)               +      ;package, product, mail
    ;               0.32908 * (AGRI + MING)                  +      ;urban freight
    ;               0.16790 *  INDEMP * Fac_ECom_LT_Ind      +      ;urban freight
    ;               0.48442 *  RETEMP * Fac_ECom_LT_Ret      +      ;urban freight
    ;               0.15141 *  OTHEMP * Fac_ECom_LT_Oth      +      ;urban freight
    ;               0.27554 *  TOTHH  * Fac_ECom_LT_HH       +      ;urban freight
    ;               0.00890 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    ;                                                        
    ;MD_Good_p[i] = 0.00797 * (TOTHH + TOTEMP)               +      ;package, product, mail
    ;               0.35277 * (AGRI + MING)                  +      ;urban freight
    ;               0.05982 *  INDEMP * Fac_ECom_MD_Ind      +      ;urban freight
    ;               0.54317 *  RETEMP * Fac_ECom_MD_Ret      +      ;urban freight
    ;               0.13447 *  OTHEMP * Fac_ECom_MD_Oth      +      ;urban freight
    ;               0.29110 *  TOTHH  * Fac_ECom_MD_HH       +      ;urban freight
    ;               0.00278 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    ;                      
    ;HV_Good_p[i] = 0.00688 * (TOTHH + TOTEMP)               +      ;package, product, mail
    ;               0.54375 * (AGRI + MING)                  +      ;urban freight
    ;               0.32868 *  INDEMP * Fac_ECom_HV_Ind      +      ;urban freight
    ;               0.41083 *  RETEMP * Fac_ECom_HV_Ret      +      ;urban freight
    ;               0.05688 *  OTHEMP * Fac_ECom_HV_Oth      +      ;urban freight
    ;               0.00000 *  TOTHH  * Fac_ECom_HV_HH       +      ;urban freight
    ;               0.00686 * (TOTHH + TOTEMP + 2 * CONS)           ;construction
    
    
    ;calculate trip ATTRACTIONS ==============================================================================
    ;person trips
    HBWa[i] =   0.957 * RETL  +
                1.017 * FOOD  +
                1.136 * MANU  +
                1.136 * WSLE  +
                1.196 * OFFI  +
                1.196 * GVED  +
                1.136 * HLTH  +
                1.136 * OTHR  +
                1.136 * AGRI  +    ;note: added agriculture, mining & construction jobs to HBW attractions, set rate = OTHR
                1.136 * MING  +
                1.136 * CONS  +
                0.000 * TOTHH 
    
    HBShpa[i] = 3.660 * RETL  +
                3.058 * FOOD  +
                0.000 * MANU  +
                0.000 * WSLE  +
                0.000 * OFFI  +
                0.000 * GVED  +
                0.000 * HLTH  +
                0.000 * OTHR  +
                0.000 * TOTHH 
    
    HBOtha[i] = 0.000 * RETL  +
                0.000 * FOOD  +
                0.019 * MANU  +
                0.126 * WSLE  +
                0.219 * OFFI  +
                2.455 * GVED  +
                1.135 * HLTH  +
                0.902 * OTHR  +
                2.553 * TOTHH 
    
    NHBWa[i] =  1.132 * RETL  +
                1.620 * FOOD  +
                0.231 * MANU  +
                0.410 * WSLE  +
                0.178 * OFFI  +
                0.250 * GVED  +
                0.185 * HLTH  +
                0.200 * OTHR  +
                0.200 * AGRI  +    ;note: added agriculture, mining & construction jobs to NHBW attractions, set rate = OTHR
                0.200 * MING  +
                0.200 * CONS  +
                0.179 * TOTHH 
    
    NHBNWa[i] = 3.419 * RETL  +
                3.264 * FOOD  +
                0.037 * MANU  +
                0.103 * WSLE  +
                0.054 * OFFI  +
                0.452 * GVED  +
                0.446 * HLTH  +
                0.242 * OTHR  +
                0.589 * TOTHH 
    
    HBSchKto6a[i]  = zi.1.ENROL_ELEM[i]
    
    HBSch7to12a[i] = zi.1.ENROL_MIDL[i] + zi.1.ENROL_HIGH[i]
    
    
    
    ;calculate share of attractions that are telecommute -----------------------------------------------------
    ;lookup Telecommute & HBJ share of employment & multiply by telecommute scenario factor, or multiplier, from Control Center
    lu_index = zi.4.CO_FIPS[i] * 10000 + @DemographicYear@
    
    Rate_Tel_RETL = WAH_Rate(01, lu_index) * @Factor_Telecommute@
    Rate_Tel_FOOD = WAH_Rate(02, lu_index) * @Factor_Telecommute@
    Rate_Tel_MANU = WAH_Rate(03, lu_index) * @Factor_Telecommute@
    Rate_Tel_WSLE = WAH_Rate(04, lu_index) * @Factor_Telecommute@
    Rate_Tel_OFFI = WAH_Rate(05, lu_index) * @Factor_Telecommute@
    Rate_Tel_GVED = WAH_Rate(06, lu_index) * @Factor_Telecommute@
    Rate_Tel_HLTH = WAH_Rate(07, lu_index) * @Factor_Telecommute@
    Rate_Tel_OTHR = WAH_Rate(08, lu_index) * @Factor_Telecommute@
    Rate_Tel_AGRI = WAH_Rate(09, lu_index) * @Factor_Telecommute@
    Rate_Tel_MING = WAH_Rate(10, lu_index) * @Factor_Telecommute@
    Rate_Tel_CONS = WAH_Rate(11, lu_index) * @Factor_Telecommute@
    
    Rate_HBJ_RETL = WAH_Rate(12, lu_index) * @Factor_Telecommute@
    Rate_HBJ_FOOD = WAH_Rate(13, lu_index) * @Factor_Telecommute@
    Rate_HBJ_MANU = WAH_Rate(14, lu_index) * @Factor_Telecommute@
    Rate_HBJ_WSLE = WAH_Rate(15, lu_index) * @Factor_Telecommute@
    Rate_HBJ_OFFI = WAH_Rate(16, lu_index) * @Factor_Telecommute@
    Rate_HBJ_GVED = WAH_Rate(17, lu_index) * @Factor_Telecommute@
    Rate_HBJ_HLTH = WAH_Rate(18, lu_index) * @Factor_Telecommute@
    Rate_HBJ_OTHR = WAH_Rate(19, lu_index) * @Factor_Telecommute@
    Rate_HBJ_AGRI = WAH_Rate(20, lu_index) * @Factor_Telecommute@
    Rate_HBJ_MING = WAH_Rate(21, lu_index) * @Factor_Telecommute@
    Rate_HBJ_CONS = WAH_Rate(22, lu_index) * @Factor_Telecommute@
    
    
    ;calculate telecommute attractions (use same rates HBW & NHBW attractions above)
    ; note: Telecommute rates are based off All Employment (before HBJ are removed), so TAZ  
    ;       employment is factored by the HBJ rate to add HBJ employment back in for this calculation
    Telecom_HBWa[i]  = 0.957  *  RETL / (1 - Rate_HBJ_RETL)  *  Rate_Tel_RETL +
                       1.017  *  FOOD / (1 - Rate_HBJ_FOOD)  *  Rate_Tel_FOOD +
                       1.136  *  MANU / (1 - Rate_HBJ_MANU)  *  Rate_Tel_MANU +
                       1.136  *  WSLE / (1 - Rate_HBJ_WSLE)  *  Rate_Tel_WSLE +
                       1.196  *  OFFI / (1 - Rate_HBJ_OFFI)  *  Rate_Tel_OFFI +
                       1.196  *  GVED / (1 - Rate_HBJ_GVED)  *  Rate_Tel_GVED +
                       1.136  *  HLTH / (1 - Rate_HBJ_HLTH)  *  Rate_Tel_HLTH +
                       1.136  *  OTHR / (1 - Rate_HBJ_OTHR)  *  Rate_Tel_OTHR +
                       1.136  *  AGRI / (1 - Rate_HBJ_AGRI)  *  Rate_Tel_AGRI +
                       1.136  *  MING / (1 - Rate_HBJ_MING)  *  Rate_Tel_MING +
                       1.136  *  CONS / (1 - Rate_HBJ_CONS)  *  Rate_Tel_CONS 
    
    Telecom_NHBWa[i] = 1.132  *  RETL / (1 - Rate_HBJ_RETL)  *  Rate_Tel_RETL +
                       1.620  *  FOOD / (1 - Rate_HBJ_FOOD)  *  Rate_Tel_FOOD +
                       0.231  *  MANU / (1 - Rate_HBJ_MANU)  *  Rate_Tel_MANU +
                       0.410  *  WSLE / (1 - Rate_HBJ_WSLE)  *  Rate_Tel_WSLE +
                       0.178  *  OFFI / (1 - Rate_HBJ_OFFI)  *  Rate_Tel_OFFI +
                       0.250  *  GVED / (1 - Rate_HBJ_GVED)  *  Rate_Tel_GVED +
                       0.185  *  HLTH / (1 - Rate_HBJ_HLTH)  *  Rate_Tel_HLTH +
                       0.200  *  OTHR / (1 - Rate_HBJ_OTHR)  *  Rate_Tel_OTHR +
                       0.200  *  AGRI / (1 - Rate_HBJ_AGRI)  *  Rate_Tel_AGRI +
                       0.200  *  MING / (1 - Rate_HBJ_MING)  *  Rate_Tel_MING +
                       0.200  *  CONS / (1 - Rate_HBJ_CONS)  *  Rate_Tel_CONS 
    
    ;set Telecommute adjust Factor to target 2019 Telecommute share of HBW attractions
    CalibFac_Tel = 1  ;0.8745
    
    ;apply calibration factor to adjust telecomute trips
    Telecom_HBWa[i]  = Telecom_HBWa[i]  * CalibFac_Tel
    Telecom_NHBWa[i] = Telecom_NHBWa[i] * CalibFac_Tel
    
    
    ;calculate telecommute share of HBW & NHBW attractions
    if (HBWa[i] >0)  Pct_Telecom_HBWa[i]  = Telecom_HBWa[i]  / HBWa[i]
    if (NHBWa[i]>0)  Pct_Telecom_NHBWa[i] = Telecom_NHBWa[i] / NHBWa[i]
    
    
    
    ;read in IX attractions ----------------------------------------------------------------------------------
    IXa[i]    = zi.5.A_IX_PL[i]
    
    
    
    ;calculate XI attractions --------------------------------------------------------------------------------
    ;% XI Attraction by County
    AdjFac_XIa_BE = 8.5741
    AdjFac_XIa_WE = 1.0061
    AdjFac_XIa_DA = 0.5437
    AdjFac_XIa_SL = 0.9974
    AdjFac_XIa_UT = 0.8972
    
    IXa_ScaleFac = 0.010957
    
    
    ;sum total attractions & scale to XI productions
    totAttractions = (HBWa[i]   +
                      HBShpa[i] +
                      HBOtha[i] +
                      NHBWa[i]  +
                      NHBNWa[i]  ) * IXa_ScaleFac
    
    if (zi.4.CO_FIPS[i]=3 )  XIa[i] = totAttractions * AdjFac_XIa_BE
    if (zi.4.CO_FIPS[i]=57)  XIa[i] = totAttractions * AdjFac_XIa_WE
    if (zi.4.CO_FIPS[i]=11)  XIa[i] = totAttractions * AdjFac_XIa_DA
    if (zi.4.CO_FIPS[i]=35)  XIa[i] = totAttractions * AdjFac_XIa_SL
    if (zi.4.CO_FIPS[i]=49)  XIa[i] = totAttractions * AdjFac_XIa_UT
    
    
    
    ;short haul truck ----------------------------------------------------------------------------------------
    ;set equal to productions after adjustments
    
    
    
    
    ;adjust PRODUCTIONS & ATTRACTIONS  =======================================================================
    
    ;general -----------------------------------------------------------------------------
    ;light truck & 4-tire commercial vehicle (LT)
    LT_Peop_p[i]     = LT_Peop_p[i]     * 1.80
    LT_Good_p[i]     = LT_Good_p[i]     * 1.80
    LT_Serv_p[i]     = LT_Serv_p[i]     * 1.80
    LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.80
    
    ;medium truck (MD)
    MD_Peop_p[i]     = MD_Peop_p[i]     * 1.85
    MD_Good_p[i]     = MD_Good_p[i]     * 1.85
    MD_Serv_p[i]     = MD_Serv_p[i]     * 1.85
    MD_Good_noAdj[i] = MD_Good_noAdj[i] * 1.85
    
    ;heavy truck (HV)
    HV_Good_p[i]     = HV_Good_p[i]     * 1.65   
    HV_Serv_p[i]     = HV_Serv_p[i]     * 1.65   
    HV_Good_noAdj[i] = HV_Good_noAdj[i] * 1.65
    
    
    ;area specific -----------------------------------------------------------------------
    ;urban spaces
    if (zi.6.ATYPE[i]=4-5)
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 1.03
        LT_Good_p[i]     = LT_Good_p[i]     * 1.03
        LT_Serv_p[i]     = LT_Serv_p[i]     * 1.03
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.03
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 0.90
        MD_Good_p[i]     = MD_Good_p[i]     * 0.90
        MD_Serv_p[i]     = MD_Serv_p[i]     * 0.90
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 0.90
        
        HV_Good_p[i]     = HV_Good_p[i]     * 0.90
        HV_Serv_p[i]     = HV_Serv_p[i]     * 0.90
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 0.90
    
    endif  ;zi.6.ATYPE[i]=4-5
    
    
    ;Box Elder
    if (zi.4.CO_FIPS[i]=3)
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 1.50
        LT_Good_p[i]     = LT_Good_p[i]     * 1.50
        LT_Serv_p[i]     = LT_Serv_p[i]     * 1.50
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.50
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 1.17
        MD_Good_p[i]     = MD_Good_p[i]     * 1.17
        MD_Serv_p[i]     = MD_Serv_p[i]     * 1.17
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 1.17
        
        HV_Good_p[i]     = HV_Good_p[i]     * 1.12
        HV_Serv_p[i]     = HV_Serv_p[i]     * 1.12
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 1.12
        
    endif  ;zi.4.CO_FIPS[i]=57
    
    
    ;Weber
    if (zi.4.CO_FIPS[i]=57)
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 1.22
        LT_Good_p[i]     = LT_Good_p[i]     * 1.22
        LT_Serv_p[i]     = LT_Serv_p[i]     * 1.22
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.22
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 0.96
        MD_Good_p[i]     = MD_Good_p[i]     * 0.96
        MD_Serv_p[i]     = MD_Serv_p[i]     * 0.96
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 0.96
        
        HV_Good_p[i]     = HV_Good_p[i]     * 0.96
        HV_Serv_p[i]     = HV_Serv_p[i]     * 0.96
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 0.96
        
    endif  ;zi.4.CO_FIPS[i]=57
    
    
    ;Davis
    if (zi.4.CO_FIPS[i]=11)
        
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 1.14
        LT_Good_p[i]     = LT_Good_p[i]     * 1.14
        LT_Serv_p[i]     = LT_Serv_p[i]     * 1.14
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.14
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 1.08
        MD_Good_p[i]     = MD_Good_p[i]     * 1.08
        MD_Serv_p[i]     = MD_Serv_p[i]     * 1.08
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 1.08
        
        HV_Good_p[i]     = HV_Good_p[i]     * 1.10
        HV_Serv_p[i]     = HV_Serv_p[i]     * 1.10
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 1.10
        
    endif  ;zi.4.CO_FIPS[i]=11
    
    
    ;Salt Lake
    if (zi.4.CO_FIPS[i]=35)
        
        if (zi.4.CBD[i]=1)
            HBShpa[i] = HBShpa[i] * 0.5
        
        elseif (zi.6.ATYPE[i]=5)
            HBWa[i]   = HBWa[i] * 1.25
        
        elseif (zi.6.ATYPE[i]=4)
            HBShpa[i] = HBShpa[i] * 0.75
            HBOtha[i] = HBOtha[i] * 0.7
            NHBNWa[i] = NHBNWa[i] * 0.8
        
        endif  ;zi.4.CBD[i]=1 or zi.6.ATYPE[i]=5-6
        
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 0.59
        LT_Good_p[i]     = LT_Good_p[i]     * 0.59
        LT_Serv_p[i]     = LT_Serv_p[i]     * 0.59
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 0.59
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 0.62
        MD_Good_p[i]     = MD_Good_p[i]     * 0.62
        MD_Serv_p[i]     = MD_Serv_p[i]     * 0.62
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 0.62
        
        HV_Good_p[i]     = HV_Good_p[i]     * 0.54
        HV_Serv_p[i]     = HV_Serv_p[i]     * 0.54
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 0.54
        
    endif  ;zi.4.CO_FIPS[i]=35
    
    
    ;Utah
    if (zi.4.CO_FIPS[i]=49)
        
        ;SH truck
        LT_Peop_p[i]     = LT_Peop_p[i]     * 1.19
        LT_Good_p[i]     = LT_Good_p[i]     * 1.19
        LT_Serv_p[i]     = LT_Serv_p[i]     * 1.19
        LT_Good_noAdj[i] = LT_Good_noAdj[i] * 1.19
        
        MD_Peop_p[i]     = MD_Peop_p[i]     * 0.95
        MD_Good_p[i]     = MD_Good_p[i]     * 0.95
        MD_Serv_p[i]     = MD_Serv_p[i]     * 0.95
        MD_Good_noAdj[i] = MD_Good_noAdj[i] * 0.95
        
        HV_Good_p[i]     = HV_Good_p[i]     * 1.01
        HV_Serv_p[i]     = HV_Serv_p[i]     * 1.01
        HV_Good_noAdj[i] = HV_Good_noAdj[i] * 1.01
        
    endif  ;zi.4.CO_FIPS[i]=49
    
    
    ;set SH truck attractions to productions after adjustment
    ;SH truck - moving people
    LT_Peop_a[i] = LT_Peop_p[i]
    MD_Peop_a[i] = MD_Peop_p[i]
    
    ;SH truck - goods
    LT_Good_a[i] = LT_Good_p[i]
    MD_Good_a[i] = MD_Good_p[i]
    HV_Good_a[i] = HV_Good_p[i]
    
    ;SH truck - services
    LT_Serv_a[i] = LT_Serv_p[i]
    MD_Serv_a[i] = MD_Serv_p[i]
    HV_Serv_a[i] = HV_Serv_p[i]
    
    
    
    ;calculate IX & XI MD & HV trip ends ---------------------------------------------------------------------
    ;read IX attractions & XI productions from external trip end file
    IX_MDa[i] = zi.5.A_IX_MD[i]
    IX_HVa[i] = zi.5.A_IX_HV[i]
    
    XI_MDp[i] = zi.5.P_XI_MD[i]
    XI_HVp[i] = zi.5.P_XI_HV[i]
    
    
    ;set internal end of IX & XI MD & HV truck to SH truck
    IX_MDp[i] = MD_Peop_p[i] + 
                MD_Good_p[i] + 
                MD_Serv_p[i] 
    
    IX_HVp[i] = HV_Good_p[i] +
                HV_Serv_p[i] 
    
    XI_MDa[i] = IX_MDp[i]
    XI_HVa[i] = IX_HVp[i]
    
    
    
    ;global adjustment factors -------------------------------------------------------------------------------
    HBWp[i]        = HBWp[i]        * 1
    HBShpp[i]      = HBShpp[i]      * 1
    HBOthp[i]      = HBOthp[i]      * 1
    HBSchKto6p[i]  = HBSchKto6p[i]  * 1
    HBSch7to12p[i] = HBSch7to12p[i] * 1
    HH_NHBWp[i]    = HH_NHBWp[i]    * 1
    HH_NHBNWp[i]   = HH_NHBNWp[i]   * 1
    
    IXa[i]         = IXa[i]         * 1     ;factor external end
    XIp[i]         = XIp[i]         * 1     ;factor external end
    
    
    
    ;scale trip end to align with base year non-balanced trip end --------------------------------------------
    HBWa[i]        = HBWa[i]        * 0.9047
    
    HBShpa[i]      = HBShpa[i]      * 1.0846
    HBOtha[i]      = HBOtha[i]      * 1.1951
    HBSchKto6a[i]  = HBSchKto6a[i]  * 1.3555
    HBSch7to12a[i] = HBSch7to12a[i] * 1.3555
    
    NHBWa[i]       = NHBWa[i]       * 0.9729
    NHBNWa[i]      = NHBNWa[i]      * 0.9780
    
    IXp[i]         = IXp[i]         / 1.0859          ;scale to external end
    XIa[i]         = XIa[i]         * 1.0450          ;scale to external end
    
    IX_MDp[i]      = IX_MDp[i]      / 64.770          ;scale to external end
    IX_HVp[i]      = IX_HVp[i]      / 34.987          ;scale to external end
    
    XI_MDa[i]      = XI_MDa[i]      * 0.0212          ;scale to external end
    XI_HVa[i]      = XI_HVa[i]      * 0.0427          ;scale to external end
    
    
    
    ;set NHB trip productions to attractions -----------------------------------------------------------------
    NHBWp[i]  = NHBWa[i]
    NHBNWp[i] = NHBNWa[i]
    
    
    
    
    ;summarize unbalanced PA totals and report to log file ===================================================
    ;production ----------------------------------------------------------------------------------------------
    ;work
    totHBWp     = totHBWp + HBWp[i]
    
    
    ;non-work
    totHBShpp   = totHBShpp   + HBShpp[i]
    totHBOthp   = totHBOthp   + HBOthp[i]
    totHBScK6p  = totHBScK6p  + HBSchKto6p[i]
    totHBsc712p = totHBsc712p + HBSch7to12p[i]
    
    totHBOp     = totHBShpp   + 
                  totHBOthp   +
                  totHBScK6p  + 
                  totHBsc712p 
    
    
    ;NHB
    totHHNHBWp  = totHHNHBWp  + HH_NHBWp[i] 
    totHHNHBNWp = totHHNHBNWp + HH_NHBNWp[i]
    
    totHHNHBp   = totHHNHBWp + 
                  totHHNHBNWp 
    
    
    totNHBWp    = totNHBWp  + NHBWp[i] 
    totNHBNWp   = totNHBNWp + NHBNWp[i]
    
    totNHBp     = totNHBWp + 
                  totNHBNWp 
    
    
    ;total person trips
    TotPerP = totHBWp + totHBOp + totHHNHBp  ;totNHBp
    
    
    ;external
    totIXp      = totIXp + IXp[i]
    totXIp      = totXIp + XIp[i]
    
    totExtp     = totIXp + 
                  totXIp 
    
    
    ;short haul
    totLTPeopp  = totLTPeopp + LT_Peop_p[i]
    totMDPeopp  = totMDPeopp + MD_Peop_p[i]
    
    totLTGoodp  = totLTGoodp + LT_Good_p[i]
    totMDGoodp  = totMDGoodp + MD_Good_p[i]
    totHVGoodp  = totHVGoodp + HV_Good_p[i]
    
    totLTServp  = totLTServp + LT_Serv_p[i]
    totMDServp  = totMDServp + MD_Serv_p[i]
    totHVServp  = totHVServp + HV_Serv_p[i]
    
    totLTp      = totLTPeopp + 
                  totLTGoodp + 
                  totLTServp 
                  
    totMDp      = totMDPeopp + 
                  totMDGoodp + 
                  totMDServp 
                  
    totHVp      = totHVGoodp + 
                  totHVServp 
                  
    SH_Truckp   = totLTp + 
                  totMDp + 
                  totHVp 
    
    
    ;external truck
    totIX_MDp = totIX_MDp + IX_MDp[i]
    totIX_HVp = totIX_HVp + IX_HVp[i]
    
    totXI_MDp = totXI_MDp + XI_MDp[i]
    totXI_HVp = totXI_HVp + XI_HVp[i]
    
    totIX_trkp = totIX_MDp + totIX_HVp
    totXI_trkp = totXI_MDp + totXI_HVp
    
    
    ;attraction ----------------------------------------------------------------------------------------------
    ;work
    totHBWa     = totHBWa + HBWa[i]
    
    
    ;non-work
    totHBShpa   = totHBShpa   + HBShpa[i]
    totHBOtha   = totHBOtha   + HBOtha[i]
    totHBScK6a  = totHBScK6a  + HBSchKto6a[i]
    totHBsc712a = totHBsc712a + HBSch7to12a[i]
    
    totHBOa     = totHBShpa   +
                  totHBOtha   +
                  totHBScK6a  +
                  totHBsc712a 
                  
    
    ;NHB
    totNHBWa    = totNHBWa  + NHBWa[i]
    totNHBNWa   = totNHBNWa + NHBNWa[i]
    
    totNHBa     = totNHBWa + 
                  totNHBNWa 
    
    
    ;total person trips
    TotPerA = totHBWa + totHBOa + totNHBa
    
    
    ;external
    totIXa      = totIXa + IXa[i]
    totXIa      = totXIa + XIa[i]
    
    totExta     = totIXa + 
                  totXIa 
    
    
    ;short haul
    totLTPeopa  = totLTPeopa + LT_Peop_a[i]
    totMDPeopa  = totMDPeopa + MD_Peop_a[i]
    totLTGooda  = totLTGooda + LT_Good_a[i]
    totMDGooda  = totMDGooda + MD_Good_a[i]
    totHVGooda  = totHVGooda + HV_Good_a[i]
    totLTServa  = totLTServa + LT_Serv_a[i]
    totMDServa  = totMDServa + MD_Serv_a[i]
    totHVServa  = totHVServa + HV_Serv_a[i]
    
    totLTa      = totLTPeopa + 
                  totLTGooda + 
                  totLTServa 
                  
    totMDa      = totMDPeopa + 
                  totMDGooda + 
                  totMDServa 
                  
    totHVa      = totHVGooda + 
                  totHVServa 
                  
    SH_Trucka   = totLTa + 
                  totMDa + 
                  totHVa 
    
    
    ;external truck
    totIX_MDa = totIX_MDa + IX_MDa[i]
    totIX_HVa = totIX_HVa + IX_HVa[i]
    
    totXI_MDa = totXI_MDa + XI_MDa[i]
    totXI_HVa = totXI_HVa + XI_HVa[i]
    
    totIX_trka = totIX_MDa + totIX_HVa
    totXI_trka = totXI_MDa + totXI_HVa
    
    
    ;telecommute
    totTelecom_HBWa  = totTelecom_HBWa  + Telecom_HBWa[i] 
    totTelecom_NHBWa = totTelecom_NHBWa + Telecom_NHBWa[i]
    
    
    ;eCommerce
    tot_LT_Good_noAdj = tot_LT_Good_noAdj + LT_Good_noAdj[i]
    tot_MD_Good_noAdj = tot_MD_Good_noAdj + MD_Good_noAdj[i]
    tot_HV_Good_noAdj = tot_HV_Good_noAdj + HV_Good_noAdj[i]
                  
    tot_Good_noAdj = tot_LT_Good_noAdj + 
                     tot_MD_Good_noAdj + 
                     tot_HV_Good_noAdj 
    
    
    
    ;print to LOG file ---------------------------------------------------------------------------------------
    if (i=ZONES)
        
        PRINT FORM=12.0C FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt',
            APPEND=T, 
            LIST=
            ';*********************************************************************',
            '\n',
            '\nTRIP GENERATION',
            '\n',
            '\nUnadjusted Productions & Attractions (no special generators, no balancing)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', totHBWp,      totHBWa,     totHBWp/totHBWa(10.2),
            '\n',
            '\n     HBO             ', totHBOp,      totHBOa,     totHBOp/totHBOa(10.2),
            '\n         HBShp       ', totHBShpp  ,  totHBShpa  , totHBShpp/totHBShpa(10.2),
            '\n         HBOth       ', totHBOthp  ,  totHBOtha  , totHBOthp/totHBOtha(10.2),
            '\n         HBScK6      ', totHBScK6p ,  totHBScK6a , totHBScK6p/totHBScK6a(10.2),
            '\n         HBsc712     ', totHBsc712p,  totHBsc712a, totHBsc712p/totHBsc712a(10.2),
            '\n',
            '\n     HH Prod NHB     ', totHHNHBp  ,  totNHBa,     totHHNHBp/totNHBa(10.2),    
            '\n         NHBW        ', totHHNHBWp ,  totNHBWa ,   totHHNHBWp/totNHBWa(10.2),  
            '\n         NHBNW       ', totHHNHBNWp,  totNHBNWa,   totHHNHBNWp/totNHBNWa(10.2),
            '\n',
            '\n     Repositioned NHB', totNHBp,      totNHBa,     totNHBp/totNHBa(10.2),
            '\n         NHBW        ', totNHBWp ,    totNHBWa ,   totNHBWp/totNHBWa(10.2),
            '\n         NHBNW       ', totNHBNWp,    totNHBNWa,   totNHBNWp/totNHBNWa(10.2),
            '\n',
            '\n     Total Person    ', TotPerP,      TotPerA,     TotPerP/TotPerA(10.2),
            '\n',
            '\n     Total External  ', totExtp,      totExta,     totExtp/totExta(10.2),
            '\n         IX          ', totIXp,       totIXa,      totIXp/totIXa(10.2),
            '\n         XI          ', totXIp,       totXIa,      totXIp/totXIa(10.2),
            '\n',
            '\n     Total Truck     ', SH_Truckp, SH_Trucka, SH_Truckp/SH_Trucka(10.2),
            '\n         LT          ', totLTp   , totLTa   , totLTp/totLTa(10.2),
            '\n         MD          ', totMDp   , totMDa   , totMDp/totMDa(10.2),
            '\n         HV          ', totHVp   , totHVa   , totHVp/totHVa(10.2),
            '\n',
            '\n     Total IX Truck  ', totIX_trkp, totIX_trka, totIX_trkp/totIX_trka(10.2),
            '\n         IX MD       ', totIX_MDp , totIX_MDa , totIX_MDp/totIX_MDa(10.2),
            '\n         IX HV       ', totIX_HVp , totIX_HVa , totIX_HVp/totIX_HVa(10.2),
            '\n',
            '\n     Total XI Truck  ', totXI_trkp, totXI_trka, totXI_trkp/totXI_trka(10.2),
            '\n         XI MD       ', totXI_MDp , totXI_MDa , totXI_MDp/totXI_MDa(10.2),
            '\n         XI HV       ', totXI_HVp , totXI_HVa , totXI_HVp/totXI_HVa(10.2),
            '\n'
    endif
    
    
    
    ;print unadjusted PA to temp file ------------------------------------------------------------------------
    TAZ_Per_P = HBWp[i]        + 
                HBShpp[i]      +
                HBOthp[i]      + 
                HBSchKto6p[i]  + 
                HBSch7to12p[i] + 
                NHBWp[i]       + 
                NHBNWp[i]
    
    TAZ_Ext_P = IXp[i] + 
                XIp[i]
    
    TAZ_LT_P  = LT_Peop_p[i] + 
                LT_Good_p[i] + 
                LT_Serv_p[i]
                
    TAZ_MD_P  = MD_Peop_p[i] + 
                MD_Good_p[i] + 
                MD_Serv_p[i]
                
    TAZ_HV_P  = HV_Good_p[i] + 
                HV_Serv_p[i]
    
    TAZ_Trk_P = TAZ_LT_P + 
                TAZ_MD_P + 
                TAZ_HV_P
    
    
    TAZ_Per_A = HBWa[i]        + 
                HBShpa[i]      +
                HBOtha[i]      + 
                HBSchKto6a[i]  + 
                HBSch7to12a[i] + 
                NHBWa[i]       + 
                NHBNWa[i]
    
    TAZ_Ext_A = IXa[i] + 
                XIa[i]
    
    TAZ_LT_A  = LT_Peop_A[i] + 
                LT_Good_A[i] + 
                LT_Serv_A[i]
                
    TAZ_MD_A  = MD_Peop_A[i] + 
                MD_Good_A[i] + 
                MD_Serv_A[i]
                
    TAZ_HV_A  = HV_Good_A[i] + 
                HV_Serv_A[i]
    
    TAZ_Trk_A = TAZ_LT_A + 
                TAZ_MD_A + 
                TAZ_HV_A
    
    
    if (i=1)
        PRINT FORM=12.0, CSV=T, FILE = '@ParentDir@@ScenarioDir@Temp\2_TripGen\PA_NoSG_NoBal.csv',
            LIST='Z', 
                 'TotPer_P'  ,  'TotPer_A'  ,
                 'HBW_P'     ,  'HBW_A'     ,
                 'HBShp_P'   ,  'HBShp_A'   ,
                 'HBOth_P'   ,  'HBOth_A'   ,
                 'HBSch_PR_P',  'HBSch_PR_A',
                 'HBSch_SC_P',  'HBSch_SC_A',
                 'HH_NHBW_P' ,  'NHBW_P'    ,  'NHBW_A' ,
                 'HH_NHBNW_P',  'NHBNW_P'   ,  'NHBNW_A',
                 'TotExt_P'  ,  'TotExt_A'  ,
                 'IX_P'      ,  'IX_A'      ,
                 'XI_P'      ,  'XI_A'      ,
                 'SH_Truck_P',  'SH_Truck_A',
                 'LT_P'      ,  'LT_A'      ,
                 'MD_P'      ,  'MD_A'      ,
                 'HV_P'      ,  'HV_A'      ,
                 'LT_Peop_p' ,  'LT_Peop_a' ,
                 'MD_Peop_p' ,  'MD_Peop_a' ,
                 'LT_Good_p' ,  'LT_Good_a' ,
                 'MD_Good_p' ,  'MD_Good_a' ,
                 'HV_Good_p' ,  'HV_Good_a' ,
                 'LT_Serv_p' ,  'LT_Serv_a' ,
                 'MD_Serv_p' ,  'MD_Serv_a' ,
                 'HV_Serv_p' ,  'HV_Serv_a' ,
                 'IX_MDp'    ,  'IX_MDa'    ,
                 'IX_HVp'    ,  'IX_HVa'    ,
                 'XI_MDp'    ,  'XI_MDa'    ,
                 'XI_HVp'    ,  'XI_HVa'    
    endif
    
    
    PRINT FORM=12.1, CSV=T, FILE = '@ParentDir@@ScenarioDir@Temp\2_TripGen\PA_NoSG_NoBal.csv',
        LIST=Z(6.0), 
             TAZ_Per_P     ,  TAZ_Per_A     ,
             HBWp[i]       ,  HBWa[i]       ,
             HBShpp[i]     ,  HBShpa[i]     ,
             HBOthp[i]     ,  HBOtha[i]     ,
             HBSchKto6p[i] ,  HBSchKto6a[i] ,
             HBSch7to12p[i],  HBSch7to12a[i],
             HH_NHBWp[i]   ,  NHBWp[i]      ,  NHBWa[i] ,
             HH_NHBNWp[i]  ,  NHBNWp[i]     ,  NHBNWa[i],
             TAZ_Ext_P     ,  TAZ_Ext_A     ,
             IXp[i]        ,  IXa[i]        ,
             XIp[i]        ,  XIa[i]        ,
             TAZ_Trk_P     ,  TAZ_Trk_A     ,
             TAZ_LT_P      ,  TAZ_LT_A      ,
             TAZ_MD_P      ,  TAZ_MD_A      ,
             TAZ_HV_P      ,  TAZ_HV_A      ,
             LT_Peop_p[i]  ,  LT_Peop_a[i]  ,
             MD_Peop_p[i]  ,  MD_Peop_a[i]  ,
             LT_Good_p[i]  ,  LT_Good_a[i]  ,
             MD_Good_p[i]  ,  MD_Good_a[i]  ,
             HV_Good_p[i]  ,  HV_Good_a[i]  ,
             LT_Serv_p[i]  ,  LT_Serv_a[i]  ,
             MD_Serv_p[i]  ,  MD_Serv_a[i]  ,
             HV_Serv_p[i]  ,  HV_Serv_a[i]  ,
             IX_MDp[i]     ,  IX_MDa[i]     ,
             IX_HVp[i]     ,  IX_HVa[i]     ,
             XI_MDp[i]     ,  XI_MDa[i]     ,
             XI_HVp[i]     ,  XI_HVa[i]     
    
    
    
    ;special generator adjustments ===========================================================================
    ;assign special generator print variables
    PrintSGFlag    = 0
    
    OrigWrkA    = HBWa[i]
    OrigNWkA    = TAZ_Per_A - HBWa[i]
    OrigExtA    = TAZ_Ext_A
    OrigTrkA    = TAZ_Trk_A
    
    TotOrigWrkA = TotOrigWrkA + OrigWrkA
    TotOrigNWkA = TotOrigNWkA + OrigNWkA
    TotOrigExtA = TotOrigExtA + OrigExtA
    TotOrigTrkA = TotOrigTrkA + OrigTrkA
    
    
    ;adjust special generator zones
    
    ;initialize variables
    ColEmpFactor = 0
    Col_Emp      = 0
    ColEmpRatio  = 0
    HBC_FTE      = 0
    
    
    
    ;adjust special generator attractions --------------------------------------------------------------------
    if (i=@TempleSquare@)
        
        ;Temple Square has an estimated 5 million visitors per year (in 2013)
        ;Visitation has not changed significantly since the last calibration of this data in 2005
        ;therefore the anual growth rate factor was reduced from 1.5% to 1% for 2013 calibration
        ;5M / 365 days/yr = 13,700 visitors per day -> 27,400 trip ends per day
        TS_Visitors = 27400 * (1.01^(@demographicyear@-2013)) * 0.5    ;add adj factor (too many attractions downtown)
        
        ;add visitors to HBOth & NHBNW categoreis
        denominator  = HBOtha[i] + NHBNWa[i]
        
        add_TS_HBOth = TS_Visitors * HBOtha[i] / denominator
        add_TS_NHBNW = TS_Visitors * NHBNWa[i] / denominator
        
        HBOtha[i] = HBOtha[i] + add_TS_HBOth
        NHBNWa[i] = NHBNWa[i] + add_TS_NHBNW
        
        ;recalc attraction totals
        TAZ_Per_A = HBWa[i]        + 
                    HBSchKto6a[i]  + 
                    HBSch7to12a[i] + 
                    HBShpa[i]      +
                    HBOtha[i]      +            ;has adjusted value
                    NHBWa[i]       + 
                    NHBNWa[i]                   ;has adjusted value
        
        ;variables for printing
        PrintSGFlag = 1
        SGName      = 'Temple Square'
    
    
    elseif (i=@SLC_Library@)
        ;SLC library is the 2nd most popular destination in salt lake.  Approx
        ;4 million visitors per year (in 2013)
        ;Similar to temple square, growth rate was changed from 1.5% to 1% for 2013 calibration
        ;4M / 365 days/yr = 11,000 visitors per day -> 22,000 trip ends per day
        Lib_Visitors = 22000 * (1.01^(@demographicyear@-2005)) * 0.5    ;add adj factor (too many attractions downtown)
        
        ;add visitors to HBO & NHB categoreis
        denominator  = HBOtha[i] + NHBWa[i]+ NHBNWa[i]
        
        add_Lib_HBOth = Lib_Visitors * HBOtha[i] / denominator
        add_Lib_NHBW  = Lib_Visitors *  NHBWa[i] / denominator
        add_Lib_NHBNW = Lib_Visitors * NHBNWa[i] / denominator
        
        HBOtha[i] = HBOtha[i] + add_Lib_HBOth
         NHBWa[i] =  NHBWa[i] + add_Lib_NHBW 
        NHBNWa[i] = NHBNWa[i] + add_Lib_NHBNW
        
        ;recalc attraction totals
        TAZ_Per_A = HBWa[i]        + 
                    HBSchKto6a[i]  + 
                    HBSch7to12a[i] + 
                    HBShpa[i]      +
                    HBOtha[i]      +            ;has adjusted value
                    NHBWa[i]       +            ;has adjusted value 
                    NHBNWa[i]                   ;has adjusted value
        
        ;variables for printing
        PrintSGFlag = 1
        SGName      = 'SLC Library'
    
    
    elseif (i=@colleges@)
        
        ;define lookup function containing the college enrollment, airports, and Lagoon control totals
    
        ;Calculate HBC FTE    
        if (i=@Ensign@    )  HBC_FTE = FTE_Ensign     
        if (i=@Westmin@   )  HBC_FTE = FTE_Westmin   
        if (i=@UOFU_Main@ )  HBC_FTE = FTE_UOFU_Main 
        if (i=@UOFU_Med@  )  HBC_FTE = FTE_UOFU_Med  
        if (i=@WSU_Main@  )  HBC_FTE = FTE_WSU_Main  
        if (i=@WSU_Davis@ )  HBC_FTE = FTE_WSU_Davis 
        if (i=@WSU_West@  )  HBC_FTE = FTE_WSU_West  
        if (i=@SLCC_Main@ )  HBC_FTE = FTE_SLCC_Main   
        if (i=@SLCC_SC@   )  HBC_FTE = FTE_SLCC_SC   
        if (i=@SLCC_JD@   )  HBC_FTE = FTE_SLCC_JD   
        if (i=@SLCC_Mead@ )  HBC_FTE = FTE_SLCC_Mead 
        if (i=@SLCC_ML@   )  HBC_FTE = FTE_SLCC_ML   
        if (i=@SLCC_LB@   )  HBC_FTE = FTE_SLCC_LB   
        if (i=@SLCC_HL@   )  HBC_FTE = FTE_SLCC_HL   
        if (i=@SLCC_Airp@ )  HBC_FTE = FTE_SLCC_Airp 
        if (i=@SLCC_West@ )  HBC_FTE = FTE_SLCC_West 
        if (i=@SLCC_HM@   )  HBC_FTE = FTE_SLCC_HM   
        if (i=@BYU@       )  HBC_FTE = FTE_BYU       
        if (i=@UVU_Main@  )  HBC_FTE = FTE_UVU_Main  
        if (i=@UVU_Geneva@)  HBC_FTE = FTE_UVU_Geneva
        if (i=@UVU_Lehi@  )  HBC_FTE = FTE_UVU_Lehi
        if (i=@UVU_Vine@  )  HBC_FTE = FTE_UVU_Vine  
        if (i=@UVU_Payson@)  HBC_FTE = FTE_UVU_Payson
        
        ;Calculate HBC attraction at each campus
        if (i=@Ensign@    )  HBCa = HBCa_Ensign     
        if (i=@Westmin@   )  HBCa = HBCa_Westmin   
        if (i=@UOFU_Main@ )  HBCa = HBCa_UofU_Main 
        if (i=@UOFU_Med@  )  HBCa = HBCa_UofU_Med  
        if (i=@WSU_Main@  )  HBCa = HBCa_WSU_Main  
        if (i=@WSU_Davis@ )  HBCa = HBCa_WSU_Davis 
        if (i=@WSU_West@  )  HBCa = HBCa_WSU_West  
        if (i=@SLCC_Main@ )  HBCa = HBCa_SLCC_Main 
        if (i=@SLCC_SC@   )  HBCa = HBCa_SLCC_SC   
        if (i=@SLCC_JD@   )  HBCa = HBCa_SLCC_JD   
        if (i=@SLCC_Mead@ )  HBCa = HBCa_SLCC_Mead 
        if (i=@SLCC_ML@   )  HBCa = HBCa_SLCC_ML   
        if (i=@SLCC_LB@   )  HBCa = HBCa_SLCC_LB   
        if (i=@SLCC_HL@   )  HBCa = HBCa_SLCC_HL   
        if (i=@SLCC_Airp@ )  HBCa = HBCa_SLCC_Airp 
        if (i=@SLCC_West@ )  HBCa = HBCa_SLCC_West 
        if (i=@SLCC_HM@   )  HBCa = HBCa_SLCC_HM   
        if (i=@BYU@       )  HBCa = HBCa_BYU       
        if (i=@UVU_Main@  )  HBCa = HBCa_UVU_Main  
        if (i=@UVU_Geneva@)  HBCa = HBCa_UVU_Geneva
        if (i=@UVU_Lehi@  )  HBCa = HBCa_UVU_Lehi
        if (i=@UVU_Vine@  )  HBCa = HBCa_UVU_Vine  
        if (i=@UVU_Payson@)  HBCa = HBCa_UVU_Payson
        
        
        ;assign college employment factor (calculated from 2007 FTE, DWS & OTHEMP data)
        if (i=@WSU_Main@,@WSU_Davis@,@WSU_West@, @UVU_Main@,@UVU_Geneva@,@UVU_Lehi@,@UVU_Vine@,@UVU_Payson@)
            ColEmpFactor = 0.25
        
        elseif (i=@SLCC_Main@,@SLCC_SC@,@SLCC_JD@,@SLCC_Mead@,@SLCC_ML@,@SLCC_LB@,@SLCC_HL@,@SLCC_Airp@,@SLCC_West@,@SLCC_HM@)
            ColEmpFactor = 0.29
        
        elseif (i=@Ensign@,@Westmin@)
            ColEmpFactor = 0.33
        
        elseif (i=@UofU_Main@,@UofU_Med@,@BYU@)
            ColEmpFactor = 0.71
        
        else
            ColEmpFactor = 0.48    ;weighted average of all colleges if not specified
        
        endif
        
        
        ;calculate ratio of employment associated with college to OTHEMP for zone
        ;this ratio will be used to establish the attractions associated with the college
        ;vs. attractions from employment not associated with college
        Col_Emp = ColEmpFactor * HBC_FTE
        
        if (TOTEMP>0)  ColEmpRatio = Col_Emp / TOTEMP
        
        if (ColEmpRatio>1)  ColEmpRatio=1.00
         
        ;calc proportion of attractions not associated with college
        NonCol_HBWa   = (1-ColEmpRatio) *  HBWa[i] 
        NonCol_HBOtha = (1-ColEmpRatio) *  HBOtha[i]
        NonCol_NHBWa  = (1-ColEmpRatio) *  NHBWa[i]
        NonCol_NHBNWa = (1-ColEmpRatio) *  NHBNWa[i]
        
        ;calculate new attraction total for college zone based on FTE students
        TotColA = HBC_FTE * 2.4  * 1.7  ;2.4 vehicle attractions/student for all purposes from ITE
                                        ;1.7 person trips to vehicle trips
        
        ;add adjutment factor (some colleges too attractive)
        if (i=@WSU_Main@)   TotColA = TotColA * 0.55
        if (i=@WSU_Davis@)  TotColA = TotColA * 0.6
        
        if (i=@Ensign@)     TotColA = TotColA * 0.6
        
        if (i=@Westmin@)    TotColA = TotColA * 0.6
        
        if (i=@SLCC_Main@)  TotColA = TotColA * 0.45
        if (i=@SLCC_SC@)    TotColA = TotColA * 0.65
        if (i=@SLCC_JD@)    TotColA = TotColA * 0.45
        if (i=@SLCC_ML@)    TotColA = TotColA * 0.5
        
        if (i=@UVU_Main@)   TotColA = TotColA * 0.5
        if (i=@UVU_Geneva@) TotColA = TotColA * 0.7
        
        
        ;calc HBW attractions associated with college
        Col_HBWa = ColEmpRatio * HBWa[i]
        
        ;calc HBO, NHB & COMM attractions from college
        Col_HBOth_NHBW_NHBNWa = TotColA - Col_HBWa - HBCa
        
        Col_HBOtha = Col_HBOth_NHBW_NHBNWa * HBOtha[i]/(HBOtha[i]+NHBWa[i]+NHBNWa[i])
        Col_NHBWa  = Col_HBOth_NHBW_NHBNWa * NHBWa[i] /(HBOtha[i]+NHBWa[i]+NHBNWa[i])
        Col_NHBNWa = Col_HBOth_NHBW_NHBNWa * NHBNWa[i]/(HBOtha[i]+NHBWa[i]+NHBNWa[i])
        
        ;add back attractions not associated with college
        HBWa[i]  = Col_HBWa   + NonCol_HBWa
        HBOtha[i]= Col_HBOtha + NonCol_HBOtha
        NHBWa[i] = Col_NHBWa  + NonCol_NHBWa
        NHBNWa[i]= Col_NHBNWa + NonCol_NHBNWa
        
        ;recalc attraction totals
        TAZ_Per_A = HBWa[i]        + 
                    HBSchKto6a[i]  + 
                    HBSch7to12a[i] + 
                    HBShpa[i]      +
                    HBOtha[i]      +            ;has adjusted value
                    NHBWa[i]       +            ;has adjusted value 
                    NHBNWa[i]                   ;has adjusted value
        
        ;variables for printing
        PrintSGFlag = 1
        
        if (i=@Ensign@    )  SGName = 'Ensign'     
        if (i=@Westmin@   )  SGName = 'Westmin'   
        if (i=@UOFU_Main@ )  SGName = 'UofU_Main' 
        if (i=@UOFU_Med@  )  SGName = 'UofU_Med'  
        if (i=@WSU_Main@  )  SGName = 'WSU Ogden' 
        if (i=@WSU_Davis@ )  SGName = 'WSU Davis' 
        if (i=@WSU_West@  )  SGName = 'WSU West'  
        if (i=@SLCC_Main@ )  SGName = 'SLCC Talorsville'
        if (i=@SLCC_SC@   )  SGName = 'SLCC South city' 
        if (i=@SLCC_JD@   )  SGName = 'SLCC Jordan'     
        if (i=@SLCC_Mead@ )  SGName = 'SLCC Meadowbrook'  
        if (i=@SLCC_ML@   )  SGName = 'SLCC Miller'        
        if (i=@SLCC_LB@   )  SGName = 'SLCC Library square'
        if (i=@SLCC_HL@   )  SGName = 'SLCC Highland'      
        if (i=@SLCC_Airp@ )  SGName = 'SLCC Airport' 
        if (i=@SLCC_West@ )  SGName = 'SLCC West' 
        if (i=@SLCC_HM@   )  SGName = 'SLCC Herriman' 
        if (i=@BYU@       )  SGName = 'BYU'
        if (i=@UVU_Main@  )  SGName = 'UVU Main'  
        if (i=@UVU_Geneva@)  SGName = 'UVU Geneva'
        if (i=@UVU_Lehi@  )  SGName = 'UVU Thanksgiving Point'
        if (i=@UVU_Vine@  )  SGName = 'UVU Vineyard'
        if (i=@UVU_Payson@)  SGName = 'UVU Payson'
    
    endif  ;special generators
    
    
    
    ;calculate total special generator adjustment for reporting ----------------------------------------------
    AdjWrkA   = HBWa[i]
    AdjNWkA   = TAZ_Per_A - HBWa[i]
    AdjExtA   = TAZ_Ext_A
    AdjTrkA   = TAZ_Trk_A
    
    DiffWrkA  = AdjWrkA - OrigWrkA
    DiffNWkA  = AdjNWkA - OrigNWkA
    DiffExtA  = AdjExtA - OrigExtA
    DiffTrkA  = AdjTrkA - OrigTrkA
    
    TotSGWrkA = TotSGWrkA + HBWa[i]             
    TotSGNWkA = TotSGNWkA + TAZ_Per_A - HBWa[i]
    TotSGExtA = TotSGExtA + TAZ_Ext_A           
    TotSGTrkA = TotSGTrkA + TAZ_Trk_A            
    
    
    
    ;print special generator data ----------------------------------------------------------------------------
    if (z=1)
        ;pring special generator to file after balancing
        PRINT FORM=12.0, CSV=T, FILE = '@ParentDir@@ScenarioDir@Temp\2_TripGen\SpecialGenerators.csv',
            LIST='Z', 'SGName', 
                 'Orig_WrkA', 'Adj_WrkA', 'Diff_WrkA', 
                 'Orig_NWkA', 'Adj_NWkA', 'Diff_NWkA',
                 'Orig_ExtA', 'Adj_ExtA', 'Diff_ExtA',
                 'Orig_TrkA', 'Adj_TrkA', 'Diff_TrkA',
                 'ColEmpFact', 
                 'ColEmp', 
                 'ColEmpRat', 
                 'FTE'
    endif
    
    if (PrintSGFlag=1)
        ;print special generator to file after balancing
        PRINT FORM=12.1, CSV=T, FILE = '@ParentDir@@ScenarioDir@Temp\2_TripGen\SpecialGenerators.csv',
            LIST=I(6.0), SGName(20), 
                 OrigWrkA, AdjWrkA, DiffWrkA, 
                 OrigNWkA, AdjNWkA, DiffNWkA,
                 OrigExtA, AdjExtA, DiffExtA,
                 OrigTrkA, AdjTrkA, DiffTrkA,
                 ColEmpFactor(20.2), Col_Emp, ColEmpRatio(20.2), HBC_FTE
    endif
    
    
    
    ;recalculate totals for adjusted purposes ----------------------------------------------------------------
    TotAdjHBOtha = TotAdjHBOtha + HBOtha[i]
    TotAdjNHBWa  = TotAdjNHBWa  + NHBWa[i]
    TotAdjNHBNWa = TotAdjNHBNWa + NHBNWa[i]
    
    
    
    
    ;balance productions and attractions =====================================================================
    if (i=ZONES)
        
        LOOP lp=1,ZONES
            
            ;balance PA --------------------------------------------------------------------------------------
            
            ;balance HBW, HBShp & HBSch A's to P's
            if (totHBWa    <>0)  HBWa[lp]        = HBWa[lp]        * totHBWp     / totHBWa
            if (totHBShpa  <>0)  HBShpa[lp]      = HBShpa[lp]      * totHBShpp   / totHBShpa  
            if (totHBScK6a <>0)  HBSchKto6a[lp]  = HBSchKto6a[lp]  * totHBScK6p  / totHBScK6a 
            if (totHBsc712a<>0)  HBSch7to12a[lp] = HBSch7to12a[lp] * totHBsc712p / totHBsc712a
            
            
            ;balance HBOth A's to P's using adjusted HBO attraction total
            if (TotAdjHBOtha<>0)  HBOtha[lp] = HBOtha[lp] * totHBOthp / TotAdjHBOtha                          ;use adjusted HBOth A total
            
            
            ;balance NHB A's to P's using original household NHB production totals & adjusted attraction totals
            if (TotAdjNHBWa <>0)  NHBWa[lp]  = NHBWa[lp]  * totHHNHBWp  / TotAdjNHBWa         ;use adjusted NHBW A total
            if (TotAdjNHBNWa<>0)  NHBNWa[lp] = NHBNWa[lp] * totHHNHBNWp / TotAdjNHBNWa        ;use adjusted NHBNW A total
            
            NHBWp[lp]  = NHBWa[lp]
            NHBNWp[lp] = NHBNWa[lp]
            
            
            ;II truck trip ends are already balanced
            
            
            ;balance IX P's to A's and XI A's to P's
            if (totIXp<>0)  IXp[lp] = IXp[lp] * totIXa / totIXp
            if (totXIa<>0)  XIa[lp] = XIa[lp] * totXIp / totXIa
            
            if (totIX_MDp<>0)  IX_MDp[lp] = IX_MDp[lp] * totIX_MDa / totIX_MDp
            if (totIX_HVp<>0)  IX_HVp[lp] = IX_HVp[lp] * totIX_HVa / totIX_HVp
            
            if (totXI_MDa<>0)  XI_MDa[lp] = XI_MDa[lp] * totXI_MDp / totXI_MDa
            if (totXI_HVa<>0)  XI_HVa[lp] = XI_HVa[lp] * totXI_HVp / totXI_HVa
            
            
            ;summarize data ----------------------------------------------------------------------------------
            ;productions
            TAZ_Per_P = HBWp[lp]        + 
                        HBSchKto6p[lp]  + 
                        HBSch7to12p[lp] + 
                        HBShpp[lp]      +
                        HBOthp[lp]      + 
                        NHBWp[lp]       + 
                        NHBNWp[lp]
            
            TAZ_Ext_P = IXp[lp] + 
                        XIp[lp]
            
            TAZ_LT_P  = LT_Peop_p[lp] + 
                        LT_Good_p[lp] + 
                        LT_Serv_p[lp]
                        
            TAZ_MD_P  = MD_Peop_p[lp] + 
                        MD_Good_p[lp] + 
                        MD_Serv_p[lp]
                        
            TAZ_HV_P  = HV_Good_p[lp] + 
                        HV_Serv_p[lp]
            
            TAZ_Trk_P = TAZ_LT_P + 
                        TAZ_MD_P + 
                        TAZ_HV_P 
            
            ;attractions
            TAZ_Per_A = HBWa[lp]        + 
                        HBSchKto6a[lp]  + 
                        HBSch7to12a[lp] + 
                        HBShpa[lp]      +
                        HBOtha[lp]      + 
                        NHBWa[lp]       + 
                        NHBNWa[lp]
            
            TAZ_Ext_A = IXa[lp] + 
                        XIa[lp]
            
            TAZ_LT_A  = LT_Peop_A[lp] + 
                        LT_Good_A[lp] + 
                        LT_Serv_A[lp]
                        
            TAZ_MD_A  = MD_Peop_A[lp] + 
                        MD_Good_A[lp] + 
                        MD_Serv_A[lp]
                        
            TAZ_HV_A  = HV_Good_A[lp] + 
                        HV_Serv_A[lp]
            
            TAZ_Trk_A = TAZ_LT_A + 
                        TAZ_MD_A + 
                        TAZ_HV_A 
            
            
            
            ;wirte PA output table ---------------------------------------------------------------------------
            RO.Z          = lp
            RO.AREATYPE   = zi.6.ATYPE[lp]
            RO.CO_TAZID   = zi.4.CO_TAZID[lp]
            RO.CO_FIPS    = zi.4.CO_FIPS[lp]
            RO.SUBAREAID  = zi.4.SUBAREAID[lp]
            
            
            RO.TotPer_P   = TAZ_Per_P
            RO.HBW_P      = HBWp[lp]       
            RO.HBSch_PR_P = HBSchKto6p[lp] 
            RO.HBSch_SC_P = HBSch7to12p[lp]
            RO.HBShp_P    = HBShpp[lp]     
            RO.HBOth_P    = HBOthp[lp]     
            RO.NHBW_P     = NHBWp[lp]      
            RO.NHBNW_P    = NHBNWp[lp]     
            
            RO.TotExt_P   = TAZ_Ext_P
            RO.IX_P       = IXp[lp]
            RO.XI_P       = XIp[lp]
            
            RO.SH_Truck_P = TAZ_Trk_P
            RO.LT_P       = TAZ_LT_P
            RO.MD_P       = TAZ_MD_P
            RO.HV_P       = TAZ_HV_P
      
            RO.IX_MD_P  = IX_MDp[lp]
            RO.IX_HV_P  = IX_HVp[lp]
            
            RO.XI_MD_P  = XI_MDp[lp]
            RO.XI_HV_P  = XI_HVp[lp]
            
            RO.IX_Trk_P = RO.IX_MD_P +
                          RO.IX_HV_P
                          
            RO.XI_Trk_P = RO.XI_MD_P +
                          RO.XI_HV_P 
            
            
            RO.TotPer_A   = TAZ_Per_A
            RO.HBW_A      = HBWa[lp]       
            RO.HBSch_PR_A = HBSchKto6a[lp] 
            RO.HBSch_SC_A = HBSch7to12a[lp]
            RO.HBShp_A    = HBShpa[lp]     
            RO.HBOth_A    = HBOtha[lp]     
            RO.NHBW_A     = NHBWa[lp]      
            RO.NHBNW_A    = NHBNWa[lp]     
            
            RO.TotExt_A   = TAZ_Ext_A
            RO.IX_A       = IXa[lp]
            RO.XI_A       = XIa[lp]
            
            RO.SH_Truck_A = TAZ_Trk_A
            RO.LT_A       = TAZ_LT_A
            RO.MD_A       = TAZ_MD_A
            RO.HV_A       = TAZ_HV_A
      
            RO.IX_MD_A  = IX_MDa[lp]
            RO.IX_HV_A  = IX_HVa[lp]
            
            RO.XI_MD_A  = XI_MDa[lp]
            RO.XI_HV_A  = XI_HVa[lp]
            
            RO.IX_Trk_A = RO.IX_MD_A +
                          RO.IX_HV_A
                          
            RO.XI_Trk_A = RO.XI_MD_A +
                          RO.XI_HV_A 
            
            RO.TelHBW     = Telecom_HBWa[lp] 
            RO.TelNHBW    = Telecom_NHBWa[lp]
            RO.PctTelHBW  = Pct_Telecom_HBWa[lp]
            RO.PctTelNHBW = Pct_Telecom_NHBWa[lp]
            
            WRITE RECO=1
            
            
            
            ;calculate total balanced productions and attractions --------------------------------------------
            ;production
            balHBWp     = balHBWp + HBWp[lp]
            
            balHBScK6p  = balHBScK6p  + HBSchKto6p[lp]
            balHBsc712p = balHBsc712p + HBSch7to12p[lp]
            balHBShpp   = balHBShpp   + HBShpp[lp]
            balHBOthp   = balHBOthp   + HBOthp[lp]
            
            balHBOp     = balHBScK6p  + 
                          balHBsc712p + 
                          balHBShpp   + 
                          balHBOthp 
            
            balNHBWp    = balNHBWp  + NHBWp[lp] 
            balNHBNWp   = balNHBNWp + NHBNWp[lp]
            
            balNHBp     = balNHBWp + 
                          balNHBNWp 
            
            balPerP = balHBWp + balHBOp + balNHBp
            
            balIXp      = balIXp + IXp[lp]
            balXIp      = balXIp + XIp[lp]
            
            balExtp     = balIXp + 
                          balXIp 
            
            balLTPeopp  = balLTPeopp + LT_Peop_p[lp]
            balMDPeopp  = balMDPeopp + MD_Peop_p[lp]
            balLTGoodp  = balLTGoodp + LT_Good_p[lp]
            balMDGoodp  = balMDGoodp + MD_Good_p[lp]
            balHVGoodp  = balHVGoodp + HV_Good_p[lp]
            balLTServp  = balLTServp + LT_Serv_p[lp]
            balMDServp  = balMDServp + MD_Serv_p[lp]
            balHVServp  = balHVServp + HV_Serv_p[lp]
            
            balLTp      = balLTPeopp + 
                          balLTGoodp + 
                          balLTServp 
                          
            balMDp      = balMDPeopp + 
                          balMDGoodp + 
                          balMDServp 
                          
            balHVp      = balHVGoodp + 
                          balHVServp 
                          
            balTruckp   = balLTp + 
                          balMDp + 
                          balHVp 
            
            
            balIX_MDp = balIX_MDp + IX_MDp[lp]
            balIX_HVp = balIX_HVp + IX_HVp[lp]
            
            balXI_MDp = balXI_MDp + XI_MDp[lp]
            balXI_HVp = balXI_HVp + XI_HVp[lp]
            
            balIX_trkp = balIX_MDp + balIX_HVp
            balXI_trkp = balXI_MDp + balXI_HVp
            
            
            ;attraction
            balHBWa     = balHBWa + HBWa[lp]
            
            balHBScK6a  = balHBScK6a  + HBSchKto6a[lp]
            balHBsc712a = balHBsc712a + HBSch7to12a[lp]
            balHBShpa   = balHBShpa   + HBShpa[lp]
            balHBOtha   = balHBOtha   + HBOtha[lp]
            
            balHBOa     = balHBScK6a  + 
                          balHBsc712a + 
                          balHBShpa   + 
                          balHBOtha 
            
            balNHBWa    = balNHBWa  + NHBWa[lp]
            balNHBNWa   = balNHBNWa + NHBNWa[lp]
            
            balNHBa     = balNHBWa + 
                          balNHBNWa 
            
            balPerA = balHBWa + balHBOa + balNHBa
            
            balIXa      = balIXa + IXa[lp]
            balXIa      = balXIa + XIa[lp]
            
            balExta     = balIXa + 
                          balXIa 
            
            balLTPeopa  = balLTPeopa + LT_Peop_a[lp]
            balMDPeopa  = balMDPeopa + MD_Peop_a[lp]
            balLTGooda  = balLTGooda + LT_Good_a[lp]
            balMDGooda  = balMDGooda + MD_Good_a[lp]
            balHVGooda  = balHVGooda + HV_Good_a[lp]
            balLTServa  = balLTServa + LT_Serv_a[lp]
            balMDServa  = balMDServa + MD_Serv_a[lp]
            balHVServa  = balHVServa + HV_Serv_a[lp]
            
            balLTa      = balLTPeopa + 
                          balLTGooda + 
                          balLTServa 
                          
            balMDa      = balMDPeopa + 
                          balMDGooda + 
                          balMDServa 
                          
            balHVa      = balHVGooda + 
                          balHVServa 
                          
            balTrucka   = balLTa + 
                          balMDa + 
                          balHVa 
            
            
            balIX_MDa = balIX_MDa + IX_MDa[lp]
            balIX_HVa = balIX_HVa + IX_HVa[lp]
            
            balXI_MDa = balXI_MDa + XI_MDa[lp]
            balXI_HVa = balXI_HVa + XI_HVa[lp]
            
            balIX_trka = balIX_MDa + balIX_HVa
            balXI_trka = balXI_MDa + balXI_HVa
            
            
            
            ;calcualte area totals (used to check area balance) ----------------------------------------------
            if (lp=@BoxElderRange@)
                BE_HBWp = BE_HBWp + HBWp[lp]
                BE_HBOp = BE_HBOp + HBSchKto6p[lp] + HBSch7to12p[lp] + HBShpp[lp] + HBOthp[lp]
                BE_NHBp = BE_NHBp + NHBWp[lp] + NHBNWp[lp]
                BE_IXp  = BE_IXp  + IXp[lp]
                BE_XIp  = BE_XIp  + XIp[lp]
                BE_TRKp = BE_TRKp + TAZ_Trk_P
                
                BE_HBWa = BE_HBWa + HBWa[lp] 
                BE_HBOa = BE_HBOa + HBSchKto6a[lp] + HBSch7to12a[lp] + HBShpa[lp] + HBOtha[lp] 
                BE_NHBa = BE_NHBa + NHBWa[lp] + NHBNWa[lp] 
                BE_IXa  = BE_IXa  + IXa[lp]
                BE_XIa  = BE_XIa  + XIa[lp]
                BE_TRKa = BE_TRKa + TAZ_Trk_A
                
                BE_NHBWa = BE_NHBWa + NHBWa[lp]
                BE_Telecom_HBWa  = BE_Telecom_HBWa  + Telecom_HBWa[lp] 
                BE_Telecom_NHBWa = BE_Telecom_NHBWa + Telecom_NHBWa[lp]

            
            elseif (lp=@WeberRange@)
                WE_HBWp = WE_HBWp + HBWp[lp]
                WE_HBOp = WE_HBOp + HBSchKto6p[lp] + HBSch7to12p[lp] + HBShpp[lp] + HBOthp[lp]
                WE_NHBp = WE_NHBp + NHBWp[lp] + NHBNWp[lp]
                WE_IXp  = WE_IXp  + IXp[lp]
                WE_XIp  = WE_XIp  + XIp[lp]
                WE_TRKp = WE_TRKp + TAZ_Trk_P
                
                WE_HBWa = WE_HBWa + HBWa[lp] 
                WE_HBOa = WE_HBOa + HBSchKto6a[lp] + HBSch7to12a[lp] + HBShpa[lp] + HBOtha[lp] 
                WE_NHBa = WE_NHBa + NHBWa[lp] + NHBNWa[lp] 
                WE_IXa  = WE_IXa  + IXa[lp]
                WE_XIa  = WE_XIa  + XIa[lp]
                WE_TRKa = WE_TRKa + TAZ_Trk_A
                
                WE_NHBWa = WE_NHBWa + NHBWa[lp]
                WE_Telecom_HBWa  = WE_Telecom_HBWa  + Telecom_HBWa[lp] 
                WE_Telecom_NHBWa = WE_Telecom_NHBWa + Telecom_NHBWa[lp]
            
            elseif (lp=@DavisRange@)
                DA_HBWp = DA_HBWp + HBWp[lp]                                                  
                DA_HBOp = DA_HBOp + HBSchKto6p[lp] + HBSch7to12p[lp] + HBShpp[lp] + HBOthp[lp] 
                DA_NHBp = DA_NHBp + NHBWp[lp] + NHBNWp[lp]                                    
                DA_IXp  = DA_IXp  + IXp[lp]                                                   
                DA_XIp  = DA_XIp  + XIp[lp]                                                   
                DA_TRKp = DA_TRKp + TAZ_Trk_P                                                 
                                                                                              
                DA_HBWa = DA_HBWa + HBWa[lp]                                                  
                DA_HBOa = DA_HBOa + HBSchKto6a[lp] + HBSch7to12a[lp] + HBShpa[lp] + HBOtha[lp]
                DA_NHBa = DA_NHBa + NHBWa[lp] + NHBNWa[lp]                                    
                DA_IXa  = DA_IXa  + IXa[lp]                                                   
                DA_XIa  = DA_XIa  + XIa[lp]                                                   
                DA_TRKa = DA_TRKa + TAZ_Trk_A
                
                DA_NHBWa = DA_NHBWa + NHBWa[lp]
                DA_Telecom_HBWa  = DA_Telecom_HBWa  + Telecom_HBWa[lp] 
                DA_Telecom_NHBWa = DA_Telecom_NHBWa + Telecom_NHBWa[lp]
            
            elseif (lp=@SLRange@)
                SL_HBWp = SL_HBWp + HBWp[lp]                                                  
                SL_HBOp = SL_HBOp + HBSchKto6p[lp] + HBSch7to12p[lp] + HBShpp[lp] + HBOthp[lp] 
                SL_NHBp = SL_NHBp + NHBWp[lp] + NHBNWp[lp]                                    
                SL_IXp  = SL_IXp  + IXp[lp]                                                   
                SL_XIp  = SL_XIp  + XIp[lp]                                                   
                SL_TRKp = SL_TRKp + TAZ_Trk_P                                                 
                                                                                              
                SL_HBWa = SL_HBWa + HBWa[lp]                                                  
                SL_HBOa = SL_HBOa + HBSchKto6a[lp] + HBSch7to12a[lp] + HBShpa[lp] + HBOtha[lp]
                SL_NHBa = SL_NHBa + NHBWa[lp] + NHBNWa[lp]                                    
                SL_IXa  = SL_IXa  + IXa[lp]                                                   
                SL_XIa  = SL_XIa  + XIa[lp]                                                   
                SL_TRKa = SL_TRKa + TAZ_Trk_A
                
                SL_NHBWa = SL_NHBWa + NHBWa[lp]
                SL_Telecom_HBWa  = SL_Telecom_HBWa  + Telecom_HBWa[lp] 
                SL_Telecom_NHBWa = SL_Telecom_NHBWa + Telecom_NHBWa[lp]
            
            elseif (lp=@UtahRange@)
                UT_HBWp = UT_HBWp + HBWp[lp]                                                  
                UT_HBOp = UT_HBOp + HBSchKto6p[lp] + HBSch7to12p[lp] + HBShpp[lp] + HBOthp[lp] 
                UT_NHBp = UT_NHBp + NHBWp[lp] + NHBNWp[lp]                                    
                UT_IXp  = UT_IXp  + IXp[lp]                                                   
                UT_XIp  = UT_XIp  + XIp[lp]                                                   
                UT_TRKp = UT_TRKp + TAZ_Trk_P                                                 
                                                                                              
                UT_HBWa = UT_HBWa + HBWa[lp]                                                  
                UT_HBOa = UT_HBOa + HBSchKto6a[lp] + HBSch7to12a[lp] + HBShpa[lp] + HBOtha[lp]
                UT_NHBa = UT_NHBa + NHBWa[lp] + NHBNWa[lp]                                    
                UT_IXa  = UT_IXa  + IXa[lp]                                                   
                UT_XIa  = UT_XIa  + XIa[lp]                                                   
                UT_TRKa = UT_TRKa + TAZ_Trk_A
                
                UT_NHBWa = UT_NHBWa + NHBWa[lp]
                UT_Telecom_HBWa  = UT_Telecom_HBWa  + Telecom_HBWa[lp] 
                UT_Telecom_NHBWa = UT_Telecom_NHBWa + Telecom_NHBWa[lp]
            endif
            
        ENDLOOP
        
        
        
        ;print final adjusted production and attraction totals to LOG file -----------------------------------
        ;calculate regional average telecommute attraction share
        AvgPctTelecom_HBWa  = totTelecom_HBWa  / balHBWa  * 100
        AvgPctTelecom_NHBWa = totTelecom_NHBWa / balNHBWa * 100
        
        
        BE_PctTelecom_HBWa  = BE_Telecom_HBWa  / BE_HBWa  * 100
        BE_PctTelecom_NHBWa = BE_Telecom_NHBWa / BE_NHBWa * 100
        
        WE_PctTelecom_HBWa  = WE_Telecom_HBWa  / WE_HBWa  * 100
        WE_PctTelecom_NHBWa = WE_Telecom_NHBWa / WE_NHBWa * 100
        
        DA_PctTelecom_HBWa  = DA_Telecom_HBWa  / DA_HBWa  * 100
        DA_PctTelecom_NHBWa = DA_Telecom_NHBWa / DA_NHBWa * 100
        
        SL_PctTelecom_HBWa  = SL_Telecom_HBWa  / SL_HBWa  * 100
        SL_PctTelecom_NHBWa = SL_Telecom_NHBWa / SL_NHBWa * 100
        
        UT_PctTelecom_HBWa  = UT_Telecom_HBWa  / UT_HBWa  * 100
        UT_PctTelecom_NHBWa = UT_Telecom_NHBWa / UT_NHBWa * 100
        
        
        
        ;calculate regional eCommerce difference to Short Haul truck trips
        tot_Good = totLTGoodp +
                   totMDGoodp +
                   totHVGoodp 
        
        dif_Good_noAdj    = tot_Good   - tot_Good_noAdj
        dif_LT_Good_noAdj = totLTGoodp - tot_LT_Good_noAdj
        dif_MD_Good_noAdj = totMDGoodp - tot_MD_Good_noAdj
        dif_HV_Good_noAdj = totHVGoodp - tot_HV_Good_noAdj
        
        if (tot_Good  >0)  Pct_Good_noAdj    = dif_Good_noAdj    / tot_Good   * 100
        if (totLTGoodp>0)  Pct_LT_Good_noAdj = dif_LT_Good_noAdj / totLTGoodp * 100
        if (totMDGoodp>0)  Pct_MD_Good_noAdj = dif_MD_Good_noAdj / totMDGoodp * 100
        if (totHVGoodp>0)  Pct_HV_Good_noAdj = dif_HV_Good_noAdj / totHVGoodp * 100
        
        
        PRINT FORM=12.0C FILE = '@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
            APPEND=T, 
            LIST=
            '\n',
            '\n     Total Special Generator Adjustment',
            '\n                     ', '      SG Adj', '  Unadjusted', '        Diff',
            '\n        HBW          ', TotSGWrkA,  TotOrigWrkA, TotSGWrkA-TotOrigWrkA,
            '\n        Non-work     ', TotSGNWkA,  TotOrigNWkA, TotSGNWkA-TotOrigNWkA,
            '\n        External     ', TotSGExtA,  TotOrigExtA, TotSGExtA-TotOrigExtA,
            '\n        Truck        ', TotSGTrkA,  TotOrigTrkA, TotSGTrkA-TotOrigTrkA,
            '\n',
            '\n',
            '\nAdjusted & Balanced Productions & Attractions',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', balHBWp,      balHBWa,     balHBWp/balHBWa(10.2),
            '\n',
            '\n     HBO             ', balHBOp,      balHBOa,     balHBOp/balHBOa(10.2),
            '\n         HBShp       ', balHBShpp  ,  balHBShpa  , balHBShpp/balHBShpa(10.2),
            '\n         HBOth       ', balHBOthp  ,  balHBOtha  , balHBOthp/balHBOtha(10.2),
            '\n         HBScK6      ', balHBScK6p ,  balHBScK6a , balHBScK6p/balHBScK6a(10.2),
            '\n         HBsc712     ', balHBsc712p,  balHBsc712a, balHBsc712p/balHBsc712a(10.2),
            '\n',
            '\n     NHB             ', balNHBp,      balNHBa,     balNHBp/balNHBa(10.2),
            '\n         NHBW        ', balNHBWp ,    balNHBWa ,   balNHBWp/balNHBWa(10.2),
            '\n         NHBNW       ', balNHBNWp,    balNHBNWa,   balNHBNWp/balNHBNWa(10.2),
            '\n',
            '\n     Total Person    ', balPerP,      balPerA,     balPerP/balPerA(10.2),
            '\n',
            '\n     Total External  ', balExtp,      balExta,     balExtp/balExta(10.2),
            '\n         IX          ', balIXp,       balIXa,      balIXp/balIXa(10.2),
            '\n         XI          ', balXIp,       balXIa,      balXIp/balXIa(10.2),
            '\n',
            '\n     Total Truck     ', balTruckp,    balTrucka,   balTruckp/balTrucka(10.2),
            '\n         LT          ', balLTp   ,    balLTa   ,   balLTp/balLTa(10.2),
            '\n         MD          ', balMDp   ,    balMDa   ,   balMDp/balMDa(10.2),
            '\n         HV          ', balHVp   ,    balHVa   ,   balHVp/balHVa(10.2),
            '\n',
            '\n     Total IX Truck  ', balIX_trkp, balIX_trka, balIX_trkp/balIX_trka(10.2),
            '\n         IX MD       ', balIX_MDp , balIX_MDa , balIX_MDp/balIX_MDa(10.2),
            '\n         IX HV       ', balIX_HVp , balIX_HVa , balIX_HVp/balIX_HVa(10.2),
            '\n',
            '\n     Total XI Truck  ', balXI_trkp, balXI_trka, balXI_trkp/balXI_trka(10.2),
            '\n         XI MD       ', balXI_MDp , balXI_MDa , balXI_MDp/balXI_MDa(10.2),
            '\n         XI HV       ', balXI_HVp , balXI_HVa , balXI_HVp/balXI_HVa(10.2),
            '\n',
            '\n     Telecommute Share of HBW & NHBW Trips',
            '\n                     ', ' Telecommute', '  Attraction', ' % Telecommute',
            '\n       Region',
            '\n         HBW         ', totTelecom_HBWa ,   balHBWa ,   AvgPctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', totTelecom_NHBWa,   balNHBWa,   AvgPctTelecom_NHBWa(10.1),'%',
            '\n',               
            '\n       Box Elder',
            '\n         HBW         ', BE_Telecom_HBWa ,   BE_HBWa  ,   BE_PctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', BE_Telecom_NHBWa,   BE_NHBWa ,   BE_PctTelecom_NHBWa(10.1),'%',
            '\n',
            '\n       Weber',
            '\n         HBW         ', WE_Telecom_HBWa ,   WE_HBWa  ,   WE_PctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', WE_Telecom_NHBWa,   WE_NHBWa ,   WE_PctTelecom_NHBWa(10.1),'%',
            '\n',
            '\n       Davis',
            '\n         HBW         ', DA_Telecom_HBWa ,   DA_HBWa  ,   DA_PctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', DA_Telecom_NHBWa,   DA_NHBWa ,   DA_PctTelecom_NHBWa(10.1),'%',
            '\n',
            '\n       Salt Lake',
            '\n         HBW         ', SL_Telecom_HBWa ,   SL_HBWa  ,   SL_PctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', SL_Telecom_NHBWa,   SL_NHBWa ,   SL_PctTelecom_NHBWa(10.1),'%',
            '\n',
            '\n       Utah',
            '\n         HBW         ', UT_Telecom_HBWa ,   UT_HBWa  ,   UT_PctTelecom_HBWa(10.1), '%',
            '\n         NHBW        ', UT_Telecom_NHBWa,   UT_NHBWa ,   UT_PctTelecom_NHBWa(10.1),'%',
            '\n',
            '\n     eCommerce Increase to Short Haul Truck Trips',
            '\n       Total Truck   ', dif_Good_noAdj   ,  Pct_Good_noAdj(10.1), '%',
            '\n         LT          ', dif_LT_Good_noAdj,  Pct_LT_Good_noAdj(10.1),'%',
            '\n         MD          ', dif_MD_Good_noAdj,  Pct_MD_Good_noAdj(10.1),'%',
            '\n         HV          ', dif_HV_Good_noAdj,  Pct_HV_Good_noAdj(10.1),'%',
            '\n',
            '\n',
            '\nArea Balance (from Adjusted Totals)',
            '\n  Box Elder County (TAZ @BoxElderRange@)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', BE_HBWp, BE_HBWa, BE_HBWp/BE_HBWa(10.2), 
            '\n     HBO             ', BE_HBOp, BE_HBOa, BE_HBOp/BE_HBOa(10.2), 
            '\n     NHB             ', BE_NHBp, BE_NHBa, BE_NHBp/BE_NHBa(10.2), 
            '\n     IX              ', BE_IXp,  BE_IXa,  BE_IXp/BE_IXa(10.2),
            '\n     XI              ', BE_XIp,  BE_XIa,  BE_XIp/BE_XIa(10.2),
            '\n     TRUCK           ', BE_TRKp, BE_TRKa, BE_TRKp/BE_TRKa(10.2),
            '\n',
            '\n  Weber County (TAZ @WeberRange@)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', WE_HBWp, WE_HBWa, WE_HBWp/WE_HBWa(10.2), 
            '\n     HBO             ', WE_HBOp, WE_HBOa, WE_HBOp/WE_HBOa(10.2), 
            '\n     NHB             ', WE_NHBp, WE_NHBa, WE_NHBp/WE_NHBa(10.2), 
            '\n     IX              ', WE_IXp,  WE_IXa,  WE_IXp/WE_IXa(10.2),
            '\n     XI              ', WE_XIp,  WE_XIa,  WE_XIp/WE_XIa(10.2),
            '\n     TRUCK           ', WE_TRKp, WE_TRKa, WE_TRKp/WE_TRKa(10.2),
            '\n',
            '\n  Davis County (TAZ @DavisRange@)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', DA_HBWp, DA_HBWa, DA_HBWp/DA_HBWa(10.2), 
            '\n     HBO             ', DA_HBOp, DA_HBOa, DA_HBOp/DA_HBOa(10.2), 
            '\n     NHB             ', DA_NHBp, DA_NHBa, DA_NHBp/DA_NHBa(10.2), 
            '\n     IX              ', DA_IXp,  DA_IXa,  DA_IXp/DA_IXa(10.2),
            '\n     XI              ', DA_XIp,  DA_XIa,  DA_XIp/DA_XIa(10.2),
            '\n     TRUCK           ', DA_TRKp, DA_TRKa, DA_TRKp/DA_TRKa(10.2),
            '\n',
            '\n  Salt Lake County (TAZ @SLRange@)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', SL_HBWp, SL_HBWa, SL_HBWp/SL_HBWa(10.2), 
            '\n     HBO             ', SL_HBOp, SL_HBOa, SL_HBOp/SL_HBOa(10.2), 
            '\n     NHB             ', SL_NHBp, SL_NHBa, SL_NHBp/SL_NHBa(10.2), 
            '\n     IX              ', SL_IXp,  SL_IXa,  SL_IXp/SL_IXa(10.2),
            '\n     XI              ', SL_XIp,  SL_XIa,  SL_XIp/SL_XIa(10.2),
            '\n     TRUCK           ', SL_TRKp, SL_TRKa, SL_TRKp/SL_TRKa(10.2),
            '\n',
            '\n  Utah County (TAZ @UtahRange@)',
            '\n                     ', '  Production', '  Attraction', '   Balance P/A',
            '\n     HBW             ', UT_HBWp, UT_HBWa, UT_HBWp/UT_HBWa(10.2), 
            '\n     HBO             ', UT_HBOp, UT_HBOa, UT_HBOp/UT_HBOa(10.2), 
            '\n     NHB             ', UT_NHBp, UT_NHBa, UT_NHBp/UT_NHBa(10.2), 
            '\n     IX              ', UT_IXp,  UT_IXa,  UT_IXp/UT_IXa(10.2),
            '\n     XI              ', UT_XIp,  UT_XIa,  UT_XIp/UT_XIa(10.2),
            '\n     TRUCK           ', UT_TRKp, UT_TRKa, UT_TRKp/UT_TRKa(10.2),
            '\n'
        
    endif  ;z=ZONES
    
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
             '\nTRIP GENERATION',
             '\n    Trip Gen                      ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 1_TripGen.txt)
