
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 0_DeleteTempFiles.txt)



;get start time
ScriptStartTime = currenttime()





RUN PGM=MATRIX
    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@\7_PostProcessing\_DeleteTempFiles.py',
        LIST='#Python input file variables and paths',
             '\n',
             '\nimport os, shutil',
             '\n',
             '\ntmp_0_InputProcessing = r"@ParentDir@@ScenarioDir@Temp\0_InputProcessing"',
             '\ntmp_1_HHDisag_AutoOwn = r"@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn"',
             '\ntmp_2_TripGen         = r"@ParentDir@@ScenarioDir@Temp\2_TripGen"'        ,
             '\ntmp_3_Distribute      = r"@ParentDir@@ScenarioDir@Temp\3_Distribute"'     ,
             '\ntmp_4_ModeChoice      = r"@ParentDir@@ScenarioDir@Temp\4_ModeChoice"'     ,
             '\ntmp_5_AssignHwy       = r"@ParentDir@@ScenarioDir@Temp\5_AssignHwy"'      ,
             '\ntmp_6_REMM            = r"@ParentDir@@ScenarioDir@Temp\6_REMM"'           ,
             '\ntmp_7_PostProcessing  = r"@ParentDir@@ScenarioDir@Temp\7_PostProcessing"' ,
             '\n',
             '\nshutil.rmtree(tmp_0_InputProcessing)',
             '\nshutil.rmtree(tmp_1_HHDisag_AutoOwn)',
             '\nshutil.rmtree(tmp_2_TripGen        )',
             '\nshutil.rmtree(tmp_3_Distribute     )',
             '\nshutil.rmtree(tmp_4_ModeChoice     )',
             '\nshutil.rmtree(tmp_5_AssignHwy      )',
             '\nshutil.rmtree(tmp_6_REMM           )',
             '\nshutil.rmtree(tmp_7_PostProcessing )',
             '\n',
             '\nos.mkdir(tmp_0_InputProcessing)',
             '\nos.mkdir(tmp_1_HHDisag_AutoOwn)',
             '\nos.mkdir(tmp_2_TripGen        )',
             '\nos.mkdir(tmp_3_Distribute     )',
             '\nos.mkdir(tmp_4_ModeChoice     )',
             '\nos.mkdir(tmp_5_AssignHwy      )',
             '\nos.mkdir(tmp_6_REMM           )',
             '\nos.mkdir(tmp_7_PostProcessing )',
             '\n',
             '\n'
    
ENDRUN




;unless user specifies to keep the temp files in the control center, run the batch file to delete the temp files
if (KeepTempFiles<>1)
    
    ;Python script: update TAZID on highway link and nodes
    ;  note using single asterix minimizes the command window when executed, double asterix executes the command window non-minimized
    ;  note: the 1>&2 echos the python window output to the one started by Cube
    **@PythonPath@ "@ParentDir@@ScenarioDir@\7_PostProcessing\_DeleteTempFiles.py" 1>&2
    
endif




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n----------------------------------------------------------------------',
             '\nPOST PROCESSING',
             '\n    Delete Temp Files                  ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 0_DeleteTempFiles.txt)