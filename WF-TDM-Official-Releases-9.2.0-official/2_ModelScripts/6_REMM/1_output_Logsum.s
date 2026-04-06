
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 01_REMM_Output_Logsum.txt)



;get start time
ScriptStartTime = currenttime()





 RUN PGM=MATRIX  MSG='REMM: Write out HBW-Peak log sum matrix to dbf'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@6_REMM\_logsums_HBW_Pk.mtx'
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@6_REMM\IJ_logsum.dbf',
        FORM=15.5, 
        FIELDS = I(10.0), 
                 J(10.0),
                 log0,
                 log1,
                 log2
               
    
    ZONEMSG = 10

    MW[1] = MI.1.0veh
    MW[2] = MI.1.1veh
    MW[3] = MI.1.2veh
       
    JLOOP
        RO.I    = i
        RO.J    = j
        RO.log0 = MW[1][j]   ;-2.5
        RO.log1 = MW[2][j]   ;-1
        RO.log2 = MW[3][j]   ;-0.25     
        
        WRITE RECO = 1
    
    ENDJLOOP
        
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
             '\nREMM',
             '\n    Convert Logsums to DBF             ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 01_REMM_Output_Logsum.txt)
