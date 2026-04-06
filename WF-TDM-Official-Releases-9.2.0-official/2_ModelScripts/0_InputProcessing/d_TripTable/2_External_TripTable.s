
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 2_External_TripTable.txt)



;get get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX MSG='External Trip Table: Get External Volumes for Scenario Year'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\5_External\@Ext_Vol_Count@'

FILEO RECO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_Volume_@DemographicYear@.dbf',
    FORM=10.0,
    FIELDS=TAZID          ,
           AWDT           ,
           PASS_VOL       ,
           TRUCK_MD       ,
           TRUCK_HV       ,
           AWDT_FAC(10.3) ,
           AADT           ,
           PASSENGER      ,
           TRUCK_SU       ,
           TRUCK_MU       ,
           PctTrk_SU(10.3),
           PctTrk_MU(10.3)
    
    
    ZONES = @UsedZones@
    ZONEMSG = 10
    
    
    ;define lookup functions
    LOOKUP LOOKUPI=1, 
        INTERPOLATE=F, 
        FAIL[1]=0,
        FAIL[2]=0,
        FAIL[3]=0,
        NAME=lu_ExtVol,
        LOOKUP[01]=01, RESULT=04,    ;AWDT     
        LOOKUP[02]=01, RESULT=05,    ;PASS_VOL 
        LOOKUP[03]=01, RESULT=06,    ;TRUCK_MD 
        LOOKUP[04]=01, RESULT=07,    ;TRUCK_HV 
        LOOKUP[05]=01, RESULT=08,    ;AWDT_FAC 
        LOOKUP[06]=01, RESULT=09,    ;AADT     
        LOOKUP[07]=01, RESULT=10,    ;PASSENGER
        LOOKUP[08]=01, RESULT=11,    ;TRUCK_SU 
        LOOKUP[09]=01, RESULT=12,    ;TRUCK_MU 
        LOOKUP[10]=01, RESULT=13,    ;PctTrk_SU
        LOOKUP[11]=01, RESULT=14     ;PctTrk_MU

    
    if (i=@externalzones@)
        
        ;calculate index
        Index = i * 10000 + @DemographicYear@
            
        ;assign output variables from external volume data
        RO.TAZID = i
        
        RO.AWDT      = lu_ExtVol(01, Index)
        RO.PASS_VOL  = lu_ExtVol(02, Index)
        RO.TRUCK_MD  = lu_ExtVol(03, Index)
        RO.TRUCK_HV  = lu_ExtVol(04, Index)
        RO.AWDT_FAC  = lu_ExtVol(05, Index)
        RO.AADT      = lu_ExtVol(06, Index)
        RO.PASSENGER = lu_ExtVol(07, Index)
        RO.TRUCK_SU  = lu_ExtVol(08, Index)
        RO.TRUCK_MU  = lu_ExtVol(09, Index)
        RO.PctTrk_SU = lu_ExtVol(10, Index)
        RO.PctTrk_MU = lu_ExtVol(11, Index)
        
        ;write output file
        WRITE RECO=1
        
    endif  ;i=@externalzones@
    
ENDRUN




RUN PGM=MATRIX MSG='External Trip Table: Calculate External Trip Ends'

FILEI DBI[1] = '@ParentDir@1_Inputs\5_External\WF_External\@Ext_TripEndPattern@',
    DELIMITER=',',
    TAZID      =#01,
    A_IX_HBW   = 19,
    A_IX_HBO   = 20,
    A_IX_NHB   = 21,
    A_IX_HBS   = 22,
    A_IX_HBC   = 23,
    A_IX_Rec   = 24,
    A_IX_LT    = 25,
    A_IX_MD    = 26,
    A_IX_HV    = 27,
    A_IX_LH_MD = 28,
    A_IX_LH_HV = 29,
    P_XI_HBW   = 33,
    P_XI_HBO   = 34,
    P_XI_NHB   = 35,
    P_XI_HBS   = 36,
    P_XI_HBC   = 37,
    P_XI_Rec   = 38,
    P_XI_LT    = 39,
    P_XI_MD    = 40,
    P_XI_HV    = 41,
    P_XI_LH_MD = 42,
    P_XI_LH_HV = 43,
    P_XX_HBW   = 61,
    P_XX_HBO   = 62,
    P_XX_NHB   = 63,
    P_XX_HBS   = 64,
    P_XX_HBC   = 65,
    P_XX_Rec   = 66,
    P_XX_LT    = 67,
    P_XX_MD    = 68,
    P_XX_HV    = 69,
    P_XX_LH_MD = 70,
    P_XX_LH_HV = 71,
    A_XX_HBW   = 75,
    A_XX_HBO   = 76,
    A_XX_NHB   = 77,
    A_XX_HBS   = 78,
    A_XX_HBC   = 79,
    A_XX_Rec   = 80,
    A_XX_LT    = 81,
    A_XX_MD    = 82,
    A_XX_HV    = 83,
    A_XX_LH_MD = 84,
    A_XX_LH_HV = 85,
    AUTOARRAY=ALLFIELDS, 
    SORT=TAZID

FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_Volume_@DemographicYear@.dbf',
    AUTOARRAY=ALLFIELDS, 
    SORT=TAZID


FILEO RECO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_TripEnds_@DemographicYear@.dbf',
    FORM=10.0,
    FIELDS=TAZID    ,
           AWDT     ,
           PASS_VOL ,
           TRUCK_MD ,
           TRUCK_HV ,
           
           A_IX_PL  ,
           P_XI_PL  ,
           P_XX_PL  ,
           A_XX_PL  ,
           
           A_IX_MD  ,
           P_XI_MD  ,
           P_XX_MD  ,
           A_XX_MD  ,
           
           A_IX_HV  ,
           P_XI_HV  ,
           P_XX_HV  ,
           A_XX_HV  
    
    
    ZONES = 1
    
    
    ;define arrays
    ARRAY A_IX_PL = @UsedZones@,
          A_IX_MD = @UsedZones@,
          A_IX_HV = @UsedZones@,
          
          P_XI_PL = @UsedZones@,
          P_XI_MD = @UsedZones@,
          P_XI_HV = @UsedZones@,
          
          P_XX_PL = @UsedZones@,
          P_XX_MD = @UsedZones@,
          P_XX_HV = @UsedZones@,
          
          A_XX_PL = @UsedZones@,
          A_XX_MD = @UsedZones@,
          A_XX_HV = @UsedZones@

    
    
    ;initialize minTAZID
    minTAZID = 999999
    
    ;loop through subarea trip end input file & calculate trip end percents
    ;  note: start LOOP at iter=2 to skip header row
    LOOP iter=2, dbi.1.NUMRECORDS
        
        ;identify external TAZID
        TAZID = dba.1.TAZID[iter]
        
        maxTAZID = MAX(TAZID, maxTAZID)
        minTAZID = MIN(TAZID, minTAZID)
        
        ;calculate external trip ends from subarea extraction & store in arrays at TAZID
        ;IX attractions
        A_IX_PL[TAZID]  = dba.1.A_IX_HBW[iter] +
                          dba.1.A_IX_HBO[iter] +
                          dba.1.A_IX_NHB[iter] +
                          dba.1.A_IX_HBS[iter] +
                          dba.1.A_IX_HBC[iter] +
                          dba.1.A_IX_Rec[iter] +
                          dba.1.A_IX_LT[iter] 
        
        A_IX_MD[TAZID]  = dba.1.A_IX_MD[iter]    +
                          dba.1.A_IX_LH_MD[iter] 
        
        A_IX_HV[TAZID]  = dba.1.A_IX_HV[iter]    +
                          dba.1.A_IX_LH_HV[iter] 
        
        
        ;XI productions
        P_XI_PL[TAZID]  = dba.1.P_XI_HBW[iter] +
                          dba.1.P_XI_HBO[iter] +
                          dba.1.P_XI_NHB[iter] +
                          dba.1.P_XI_HBS[iter] +
                          dba.1.P_XI_HBC[iter] +
                          dba.1.P_XI_Rec[iter] +
                          dba.1.P_XI_LT[iter] 
        
        P_XI_MD[TAZID]  = dba.1.P_XI_MD[iter]    +
                          dba.1.P_XI_LH_MD[iter] 
        
        P_XI_HV[TAZID]  = dba.1.P_XI_HV[iter]    +
                          dba.1.P_XI_LH_HV[iter] 
        
        
        ;XX productions
        P_XX_PL[TAZID]  = dba.1.P_XX_HBW[iter] +
                          dba.1.P_XX_HBO[iter] +
                          dba.1.P_XX_NHB[iter] +
                          dba.1.P_XX_HBS[iter] +
                          dba.1.P_XX_HBC[iter] +
                          dba.1.P_XX_Rec[iter] +
                          dba.1.P_XX_LT[iter] 
        
        P_XX_MD[TAZID]  = dba.1.P_XX_MD[iter]    +
                          dba.1.P_XX_LH_MD[iter] 
        
        P_XX_HV[TAZID]  = dba.1.P_XX_HV[iter]    +
                          dba.1.P_XX_LH_HV[iter] 
        
        
        ;XX attractions
        A_XX_PL[TAZID]  = dba.1.A_XX_HBW[iter] +
                          dba.1.A_XX_HBO[iter] +
                          dba.1.A_XX_NHB[iter] +
                          dba.1.A_XX_HBS[iter] +
                          dba.1.A_XX_HBC[iter] +
                          dba.1.A_XX_Rec[iter] +
                          dba.1.A_XX_LT[iter] 
        
        A_XX_MD[TAZID]  = dba.1.A_XX_MD[iter]    +
                          dba.1.A_XX_LH_MD[iter] 
        
        A_XX_HV[TAZID]  = dba.1.A_XX_HV[iter]    +
                          dba.1.A_XX_LH_HV[iter] 
        
        
        ;calculate total of all externals
        All_A_IX_PL = All_A_IX_PL + A_IX_PL[TAZID]
        All_A_IX_MD = All_A_IX_MD + A_IX_MD[TAZID]
        All_A_IX_HV = All_A_IX_HV + A_IX_HV[TAZID]
        
        All_P_XI_PL = All_P_XI_PL + P_XI_PL[TAZID]
        All_P_XI_MD = All_P_XI_MD + P_XI_MD[TAZID]
        All_P_XI_HV = All_P_XI_HV + P_XI_HV[TAZID]
        
        All_P_XX_PL = All_P_XX_PL + P_XX_PL[TAZID]
        All_P_XX_MD = All_P_XX_MD + P_XX_MD[TAZID]
        All_P_XX_HV = All_P_XX_HV + P_XX_HV[TAZID]
        
        All_A_XX_PL = All_A_XX_PL + A_XX_PL[TAZID]
        All_A_XX_MD = All_A_XX_MD + A_XX_MD[TAZID]
        All_A_XX_HV = All_A_XX_HV + A_XX_HV[TAZID]
        
    ENDLOOP  ;iter=2, dbi.1.NUMRECORDS
    
    
    ;calculate adjustment factor to scale IX attractions & XI productions to be 45% IX & 55% XI
    ;  (IX & XI shares for all person trips from 2012 HTS, MD & HV shares come from 2019 USTM)
    Target_A_IX_PL = (All_P_XI_PL + All_A_IX_PL) * 0.45
    Target_A_IX_MD = (All_P_XI_MD + All_A_IX_MD) * 0.43
    Target_A_IX_HV = (All_P_XI_HV + All_A_IX_HV) * 0.41
    
    Target_P_XI_PL = (All_P_XI_PL + All_A_IX_PL) * 0.55
    Target_P_XI_MD = (All_P_XI_MD + All_A_IX_MD) * 0.57
    Target_P_XI_HV = (All_P_XI_HV + All_A_IX_HV) * 0.59
    
    Adj_A_IX_PL = 1
    Adj_A_IX_MD = 1
    Adj_A_IX_HV = 1
    
    Adj_P_XI_PL = 1
    Adj_P_XI_MD = 1
    Adj_P_XI_HV = 1
    
    if (All_A_IX_PL>0)  Adj_A_IX_PL = Target_A_IX_PL / All_A_IX_PL
    if (All_A_IX_MD>0)  Adj_A_IX_MD = Target_A_IX_MD / All_A_IX_MD
    if (All_A_IX_HV>0)  Adj_A_IX_HV = Target_A_IX_HV / All_A_IX_HV
    
    if (All_P_XI_PL>0)  Adj_P_XI_PL = Target_P_XI_PL / All_P_XI_PL
    if (All_P_XI_MD>0)  Adj_P_XI_MD = Target_P_XI_MD / All_P_XI_MD
    if (All_P_XI_HV>0)  Adj_P_XI_HV = Target_P_XI_HV / All_P_XI_HV
    
    
    ;calculate adjustment factor to scale XX productions & attractions to average
    Avg_PA_XX_PL = (All_P_XX_PL + All_A_XX_PL) / 2
    Avg_PA_XX_MD = (All_P_XX_MD + All_A_XX_MD) / 2
    Avg_PA_XX_HV = (All_P_XX_HV + All_A_XX_HV) / 2
    
    Adj_P_XX_PL = 1
    Adj_P_XX_MD = 1
    Adj_P_XX_HV = 1
    
    Adj_A_XX_PL = 1
    Adj_A_XX_MD = 1
    Adj_A_XX_HV = 1
    
    if (All_P_XX_PL>0)  Adj_P_XX_PL = Avg_PA_XX_PL / All_P_XX_PL
    if (All_P_XX_MD>0)  Adj_P_XX_MD = Avg_PA_XX_MD / All_P_XX_MD
    if (All_P_XX_HV>0)  Adj_P_XX_HV = Avg_PA_XX_HV / All_P_XX_HV
    
    if (All_A_XX_PL>0)  Adj_A_XX_PL = Avg_PA_XX_PL / All_A_XX_PL
    if (All_A_XX_MD>0)  Adj_A_XX_MD = Avg_PA_XX_MD / All_A_XX_MD
    if (All_A_XX_HV>0)  Adj_A_XX_HV = Avg_PA_XX_HV / All_A_XX_HV
    
    
    ;loop through external arrays and rebalance P's & A's
    LOOP iter=minTAZID, maxTAZID
        
        if (iter=@externalzones@)
            
            ;adjust P's & A's
            A_IX_PL[iter] = A_IX_PL[iter] * Adj_A_IX_PL
            A_IX_MD[iter] = A_IX_MD[iter] * Adj_A_IX_MD
            A_IX_HV[iter] = A_IX_HV[iter] * Adj_A_IX_HV
            
            P_XI_PL[iter] = P_XI_PL[iter] * Adj_P_XI_PL
            P_XI_MD[iter] = P_XI_MD[iter] * Adj_P_XI_MD
            P_XI_HV[iter] = P_XI_HV[iter] * Adj_P_XI_HV
            
            P_XX_PL[iter] = P_XX_PL[iter] * Adj_P_XX_PL
            P_XX_MD[iter] = P_XX_MD[iter] * Adj_P_XX_MD
            P_XX_HV[iter] = P_XX_HV[iter] * Adj_P_XX_HV
            
            A_XX_PL[iter] = A_XX_PL[iter] * Adj_A_XX_PL
            A_XX_MD[iter] = A_XX_MD[iter] * Adj_A_XX_MD
            A_XX_HV[iter] = A_XX_HV[iter] * Adj_A_XX_HV
            
            
            ;calculate BALANCED total of all externals
            All_A_IX_PL = All_A_IX_PL + A_IX_PL[iter]
            All_A_IX_MD = All_A_IX_MD + A_IX_MD[iter]
            All_A_IX_HV = All_A_IX_HV + A_IX_HV[iter]
            
            All_P_XI_PL = All_P_XI_PL + P_XI_PL[iter]
            All_P_XI_MD = All_P_XI_MD + P_XI_MD[iter]
            All_P_XI_HV = All_P_XI_HV + P_XI_HV[iter]
            
            All_P_XX_PL = All_P_XX_PL + P_XX_PL[iter]
            All_P_XX_MD = All_P_XX_MD + P_XX_MD[iter]
            All_P_XX_HV = All_P_XX_HV + P_XX_HV[iter]
            
            All_A_XX_PL = All_A_XX_PL + A_XX_PL[iter]
            All_A_XX_MD = All_A_XX_MD + A_XX_MD[iter]
            All_A_XX_HV = All_A_XX_HV + A_XX_HV[iter]
            
        endif  ;iter=@externalzones@
        
    ENDLOOP  ;iter=minTAZID, maxTAZID
    
    
    ;sum BALANCED trip end totals for all externals by purpose
    All_PL = All_A_IX_PL +
             All_P_XI_PL +
             All_P_XX_PL +
             All_A_XX_PL 
    
    All_MD = All_A_IX_MD +
             All_P_XI_MD +
             All_P_XX_MD +
             All_A_XX_MD 
    
    All_HV = All_A_IX_HV +
             All_P_XI_HV +
             All_P_XX_HV +
             All_A_XX_HV 
    
    All_Trips = All_PL +
                All_MD +
                All_HV 
    
    
    ;loop through external volume records & calculate model trip ends at external
    ;  using external volumes & pattern from subarea extraction
    LOOP iter=1, dbi.2.NUMRECORDS
        
        ;identify external TAZID
        TAZID = dba.2.TAZID[iter]
        
        
        ;sum trip ends from subarea extraction by purpose for external
        Ext_PL = A_IX_PL[TAZID] +
                 P_XI_PL[TAZID] +
                 P_XX_PL[TAZID] +
                 A_XX_PL[TAZID] 
        
        Ext_MD = A_IX_MD[TAZID] +
                 P_XI_MD[TAZID] +
                 P_XX_MD[TAZID] +
                 A_XX_MD[TAZID] 
        
        Ext_HV = A_IX_HV[TAZID] +
                 P_XI_HV[TAZID] +
                 P_XX_HV[TAZID] +
                 A_XX_HV[TAZID] 
        
        Ext_Trips = Ext_PL +
                    Ext_MD +
                    Ext_HV 
        
        
        ;check if no data at external from subarea extraction matrix
        if (Ext_Trips=0)
            
            ;use regional trip share for externals with no volume from external matrix
            ;pct_PL = All_PL / All_Trips
            ;pct_MD = All_MD / All_Trips
            ;pct_HV = All_HV / All_Trips
            
            ;assume no XX trips and IX & XI trips have an equal share for both passenger cars & trucks
            pct_A_IX_PL = 0.5
            pct_P_XI_PL = 0.5
            pct_P_XX_PL = 0
            pct_A_XX_PL = 0
            
            pct_A_IX_MD = 0.5
            pct_P_XI_MD = 0.5
            pct_P_XX_MD = 0
            pct_A_XX_MD = 0
            
            pct_A_IX_HV = 0.5
            pct_P_XI_HV = 0.5
            pct_P_XX_HV = 0
            pct_A_XX_HV = 0
            
        else
            
            ;calculate trip share by purpose
            ;pct_PL = Ext_PL / Ext_Trips
            ;pct_MD = Ext_MD / Ext_Trips
            ;pct_HV = Ext_HV / Ext_Trips
            
            
            ;initialize then calculate IX, XI & XX shares of PL, MD & HV
            pct_A_IX_PL = 0
            pct_P_XI_PL = 0
            pct_P_XX_PL = 0
            pct_A_XX_PL = 0
            
            pct_A_IX_MD = 0
            pct_P_XI_MD = 0
            pct_P_XX_MD = 0
            pct_A_XX_MD = 0
            
            pct_A_IX_HV = 0
            pct_P_XI_HV = 0
            pct_P_XX_HV = 0
            pct_A_XX_HV = 0
            
            if (Ext_PL>0)  pct_A_IX_PL = A_IX_PL[TAZID] / Ext_PL
            if (Ext_PL>0)  pct_P_XI_PL = P_XI_PL[TAZID] / Ext_PL
            if (Ext_PL>0)  pct_P_XX_PL = P_XX_PL[TAZID] / Ext_PL
            if (Ext_PL>0)  pct_A_XX_PL = A_XX_PL[TAZID] / Ext_PL
            
            if (Ext_MD>0)  pct_A_IX_MD = A_IX_MD[TAZID] / Ext_MD
            if (Ext_MD>0)  pct_P_XI_MD = P_XI_MD[TAZID] / Ext_MD
            if (Ext_MD>0)  pct_P_XX_MD = P_XX_MD[TAZID] / Ext_MD
            if (Ext_MD>0)  pct_A_XX_MD = A_XX_MD[TAZID] / Ext_MD
            
            if (Ext_HV>0)  pct_A_IX_HV = A_IX_HV[TAZID] / Ext_HV
            if (Ext_HV>0)  pct_P_XI_HV = P_XI_HV[TAZID] / Ext_HV
            if (Ext_HV>0)  pct_P_XX_HV = P_XX_HV[TAZID] / Ext_HV
            if (Ext_HV>0)  pct_A_XX_HV = A_XX_HV[TAZID] / Ext_HV
            
        endif  ;Ext_Trips=0
        
        
        ;calculate model trip ends & write to output file
        ;passenger car & light truck
        RO.AWDT     = dba.2.AWDT[iter]
        RO.PASS_VOL = dba.2.PASS_VOL[iter]
        RO.TRUCK_MD = dba.2.TRUCK_MD[iter]
        RO.TRUCK_HV = dba.2.TRUCK_HV[iter]
        
        RO.P_XI_PL = ROUND(RO.PASS_VOL * pct_P_XI_PL)
        RO.P_XX_PL = ROUND(RO.PASS_VOL * pct_P_XX_PL)
        RO.A_XX_PL = ROUND(RO.PASS_VOL * pct_A_XX_PL)
        RO.A_IX_PL = RO.PASS_VOL - RO.P_XI_PL - RO.P_XX_PL - RO.A_XX_PL
        
        RO.P_XI_MD = ROUND(RO.TRUCK_MD * pct_P_XI_MD)
        RO.P_XX_MD = ROUND(RO.TRUCK_MD * pct_P_XX_MD)
        RO.A_XX_MD = ROUND(RO.TRUCK_MD * pct_A_XX_MD)
        RO.A_IX_MD = RO.TRUCK_MD - RO.P_XI_MD - RO.P_XX_MD - RO.A_XX_MD
        
        RO.P_XI_HV = ROUND(RO.TRUCK_HV * pct_P_XI_HV)
        RO.P_XX_HV = ROUND(RO.TRUCK_HV * pct_P_XX_HV)
        RO.A_XX_HV = ROUND(RO.TRUCK_HV * pct_A_XX_HV)
        RO.A_IX_HV = RO.TRUCK_HV - RO.P_XI_HV - RO.P_XX_HV - RO.A_XX_HV 
        
        ;write output file
        WRITE RECO=1
        
    ENDLOOP  ;iter=1, dbi.2.NUMRECORDS
    
ENDRUN




RUN PGM=MATRIX MSG='External Trip Table: Extract External Pass Through Seed Matrix'

FILEI MATI[1] = '@ParentDir@1_Inputs\5_External\WF_External\@Ext_TripTable@'


FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WF_XX.mtx',
    mo=100-103,
    name=XX_Tot ,
         XX_PL  ,
         XX_MD  ,
         XX_HV  
    
    
    
    ;define matrix parameters
    ZONES   = @UsedZones@
    ZONEMSG = 100
    
    
    
    ;sum all trips going through external node
    ;  note: IX & XI totals are sum of regular & transposed matrices
    ;        and XX trips cross cross external nodes twice
    JLOOP
        
        if (i=@externalzones@ & j=@externalzones@)
            
            ;XX
            mw[101] = mi.1.PA_HBW +
                      mi.1.PA_HBO +
                      mi.1.PA_NHB +
                      mi.1.PA_HBS +
                      mi.1.PA_HBC +
                      mi.1.PA_Rec +
                      mi.1.PA_LT  
            
            mw[102] = mi.1.PA_MD   + 
                      mi.1.PA_LH_MD
            
            mw[103] = mi.1.PA_HV   + 
                      mi.1.PA_LH_HV
            
            
            ;calculate totals
            mw[100] = mw[101] +     ;PL
                      mw[102] +     ;MD
                      mw[103]       ;HV
            
        endif  ;i=externalzones & j=externalzones
        
    ENDJLOOP
    
ENDRUN




RUN PGM=FRATAR MSG='External Trip Table: Scale XX Trip Tables to External Volume'

FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_TripEnds_@DemographicYear@.dbf',
    Z=TAZID

FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WF_XX.mtx'


FILEO MATO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\External_TripTable_@DemographicYear@.mtx',
    mo=100, 1-3,
    name=XX_Tot ,
         XX_PL  ,
         XX_MD  ,
         XX_HV  
    
    
    ;set parameters
    ZONEMSG  = 100
    MAXITERS = 51
    MAXRMSE  = 5
    
    
    SETPA P[1]=zi.1.P_XX_PL,  A[1]=zi.1.A_XX_PL,  mw[1]=mi.1.XX_PL,  CONTROL[1]=PA  INCLUDE=@externalzones@
    SETPA P[2]=zi.1.P_XX_MD,  A[2]=zi.1.A_XX_MD,  mw[2]=mi.1.XX_MD,  CONTROL[2]=PA  INCLUDE=@externalzones@
    SETPA P[3]=zi.1.P_XX_HV,  A[3]=zi.1.A_XX_HV,  mw[3]=mi.1.XX_HV,  CONTROL[3]=PA  INCLUDE=@externalzones@
    
    mw[1] = mw[1], Total=ROWFIX(1, i, 0.5)    ;XX_PL
    mw[2] = mw[2], Total=ROWFIX(2, i, 0.5)    ;XX_MD
    mw[3] = mw[3], Total=ROWFIX(3, i, 0.5)    ;XX_HV
    
    mw[100] = mw[1] +     ;XX_PL
              mw[2] +     ;XX_MD
              mw[3]       ;XX_HV
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Process External Trip Table        ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



;System cleanup
    *(DEL 2_External_TripTable.txt)
    