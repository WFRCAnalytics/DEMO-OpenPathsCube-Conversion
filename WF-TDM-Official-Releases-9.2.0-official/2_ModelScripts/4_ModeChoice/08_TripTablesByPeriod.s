
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 08_TripTablesByPeriod.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX   MSG='Mode Choice 8: separate daily trips into peak and off peak'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\Time Of Day Factors.csv'

FILEI MATI[1]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_AllPurp.2.DestChoice.mtx'
FILEI MATI[2]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBW_NumVeh_noXI.mtx'

FILEO MATO[1]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBW_ByPeriod_noXI.mtx', 
    MO=11-13,21-23, 
    NAME=0VEH_PK,  
         1VEH_PK,
         2VEH_PK, 
         0VEH_OK, 
         1VEH_OK, 
         2VEH_OK

FILEO MATO[2]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBC_ByPeriod.mtx', 
    MO=14,24, 
    NAME=ALL_PK, 
         ALL_OK

FILEO MATO[3]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBO_ByPeriod.mtx', 
    MO=15,25, 
    NAME=ALL_PK, 
         ALL_OK

FILEO MATO[4]='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_NHB_ByPeriod.mtx', 
    MO=16,26, 
    NAME=ALL_PK, 
         ALL_OK


    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    
    ZONES = @UsedZones@
    ZONEMSG = 5
    
    
    
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
    
    
    
    ;read in calculated diurnal factors from file
    if (i=FIRSTZONE)
        
        ;read in calculate diurnal factors block file
        READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
        
    endif  ;i=FIRSTZONE
    
    
    ;calculate peak and off peak diurnal factors
    HBW_Pk = Pct_AM_HBW + Pct_PM_HBW
    HBO_Pk = Pct_AM_HBO + Pct_PM_HBO
    NHB_Pk = Pct_AM_NHB + Pct_PM_NHB
    HBC_Pk = Pct_AM_HBC + Pct_PM_HBC
    
    HBW_Ok = 1 - HBW_Pk
    HBC_Ok = 1 - HBC_Pk
    HBO_Ok = 1 - HBO_Pk
    NHB_Ok = 1 - NHB_Pk
    
    
    
    ;assign working matrices
    MW[1] = mi.2.hbw0
    MW[2] = mi.2.hbw1
    MW[3] = mi.2.hbw2
    
    MW[4] = mi.1.hbc
    MW[5] = mi.1.hbo
    MW[6] = mi.1.nhb
    
    
    jloop
        if (Z==@dummyzones@ || Z==@externalzones@ || j==@dummyzones@ || j==@externalzones@)
            ;peak
            mw[11] = 0    ;hbw 0-car
            mw[12] = 0    ;hbw 1-car
            mw[13] = 0    ;hbw 2-car
            mw[14] = 0    ;hbc
            mw[15] = 0    ;hbo
            mw[16] = 0    ;nhb
            
            ;off-peak
            mw[21] = 0    ;hbw 0-car
            mw[22] = 0    ;hbw 1-car
            mw[23] = 0    ;hbw 2-car
            mw[24] = 0    ;hbc      
            mw[25] = 0    ;hbo      
            mw[26] = 0    ;nhb      
          
        else
            ;peak
            mw[11] = mw[1] * HBW_Pk    ;hbw 0-car
            mw[12] = mw[2] * HBW_Pk    ;hbw 1-car
            mw[13] = mw[3] * HBW_Pk    ;hbw 2-car
            mw[14] = mw[4] * HBC_Pk    ;hbc
            mw[15] = mw[5] * HBO_Pk    ;hbo
            mw[16] = mw[6] * NHB_Pk    ;nhb
            
            ;off-peak
            mw[21] = mw[1] * HBW_Ok    ;hbw 0-car
            mw[22] = mw[2] * HBW_Ok    ;hbw 1-car
            mw[23] = mw[3] * HBW_Ok    ;hbw 2-car
            mw[24] = mw[4] * HBC_Ok    ;hbc      
            mw[25] = mw[5] * HBO_Ok    ;hbo      
            mw[26] = mw[6] * NHB_Ok    ;nhb      
        endif
        
    endjloop  
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Factor TT by Peak/Off-Peak         ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN
	



*(del 08_TripTablesByPeriod.txt)
