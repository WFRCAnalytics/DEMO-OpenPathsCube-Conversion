
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 06_REMM_ParcelVol.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX  MSG='REMM: Running _parcel_volume.py script'
    ZONES = 1
    
	  if (_print_text=0)
        ;toggle print file variable
        _print_text = 1
        
       ;create control input file for this Python script
        PRINT FILE = '@ParentDir@2_ModelScripts\6_REMM\_VarCube_REMM_ParcelVol.txt',
            LIST='#Python input file variables and paths',
                 '\n',
                 '\nScripts_folder   = r"@ParentDir@2_ModelScripts\6_REMM"',
                 '\nScenarios_folder = r"@ParentDir@@ScenarioDir@6_REMM"',
                 '\n'
        
    endif
ENDRUN


;run Python script to update walk buffer dbf
;note using single asterix minimizes the command window when executed, double asterix executes the command window non-minimized
;note: the 1>&2 echos the python window output to the one started by Cube
**@PythonPath@ "@ParentDir@2_ModelScripts\6_REMM\_parcel_volume.py" 1>&2


;Python error handling
if (ReturnCode<>0)
    PROMPT QUESTION='Python failed to run correctly' ANSWER='Please check the  Python for possible causes.  (Python Return Code = @ReturnCode@)'
    ABORT
endif




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Create parcel volumes              ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 06_REMM_ParcelVol.txt)
