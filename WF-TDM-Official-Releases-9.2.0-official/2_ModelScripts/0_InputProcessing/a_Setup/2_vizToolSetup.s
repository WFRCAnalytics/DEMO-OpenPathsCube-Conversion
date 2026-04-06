
;create global variable input file for viztool inputs ---------------------------------
RUN PGM=MATRIX MSG='Set Up: convert vizTool geodata to geojson format'

FILEO PRINTO = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt'
     
     
    ;set parameters
    ZONES = 1
    
    
    ;create control input file for this Python script
    PRINT PRINTO=1,
        LIST='# ------------------------------------------------------------------------------',
             '\n# Python input file variables and paths',
             '\n# ------------------------------------------------------------------------------',
             '\n',
             '\n# global parameters ------------------------------------------------------------',
             '\nParentDir        = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir      = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\nModelVersion     = r"@ModelVersion@"',
             '\nScenarioGroup    = r"@ScenarioGroup@"',
             '\nRunYear          = r"@RunYear@"',
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nTAZ_DBF          = r"@TAZ_DBF@"',
             '\nSegments_DBF     = r"@Segments_DBF@"',
             '\n',
             '\n'
    
ENDRUN


;run python script -------------------------------------------------------------
;  note: one asterix minimizes the command window, two asterix executes the command window non-minimized
;  note: the 1>&2 echos the command window output from pyton to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CreateGeoJsons.py" 1>&2


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ParentDir@@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0


;run python script -------------------------------------------------------------
;  note: one asterix minimizes the command window, two asterix executes the command window non-minimized
;  note: the 1>&2 echos the command window output from pyton to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CreateScnJson.py" 1>&2


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ParentDir@@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0


;DOS command to delete '__pycache__' folder
;  note: '/s' removes folder & contents of folder includling any subfolders
;  note: '/q' denotes quite mode, meaning doesn't ask for confirmation to delete
*(rmdir /s /q "_Log\__pycache__")
*(rmdir /s /q "@ParentDir@2_ModelScripts\_Python\py-vizTool\__pycache__")