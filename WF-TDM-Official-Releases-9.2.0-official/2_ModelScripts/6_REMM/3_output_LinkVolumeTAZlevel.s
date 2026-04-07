
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 03_REMM_Output_Nets.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=NETWORK   MSG='REMM: Write out Ramps shapefile from Distribution loaded network'
    FILEI NETI[1]  = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.net'
    
    FILEO LINKO = '@ParentDir@@ScenarioDir@6_REMM\FreewayExits.dbf', 
        FORM=20.0,
        Include=A, 
                B, 
                FT
     
    ZONES = @UsedZones@
     
    if (li.1.FT=28-29,41-42)
        ;do nothing
    else
        DELETE
    endif
ENDRUN


RUN PGM=NETWORK   MSG='REMM: Write out Arterials and Ramps shapefile from Distribution loaded network'
    FILEI NETI[1]  = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Assigned.net'
    
    FILEO LINKO = '@ParentDir@@ScenarioDir@6_REMM\volumeshapefile.dbf', 
        FORM=20.0,
        Include=A, 
                B, 
                DY_VOL
    
    ZONES = @UsedZones@
    
    if (li.1.FT=2-4,13-15,28-29,41-42)
        ;do nothing
    else
        DELETE
    endif
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Convert Net to Shapefile           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 03_REMM_Output_Nets.txt)
