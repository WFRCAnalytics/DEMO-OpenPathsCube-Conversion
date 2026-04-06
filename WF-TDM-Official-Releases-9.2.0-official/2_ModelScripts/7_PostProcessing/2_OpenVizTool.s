
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 0_DeleteTempFiles.txt)


;create globabl variable input file for python ---------------------------------
RUN PGM=MATRIX MSG='Post Processing 2: Create OpenVizTool bat file'

FILEO PRINTO = '@ParentDir@@ScenarioDir@_OpenVizTool.bat'
     
    ;set parameters
    ZONES = 1
    
    ;create control input file for this Python script
    PRINT PRINTO=1,
        LIST='@echo off',
             '\n',
             '\nrem Set the path to the Python executable and the script to run',
             '\nset python_exec=@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe',
             '\nset script=@ParentDir@Scenarios\.vizTool\_start-server-model.py',
             '\n',
             '\nrem Check if the Python executable exists',
             '\nif not exist "%python_exec%" (',
             '\n    echo Python executable not found at "%python_exec%".',
             '\n    pause',
             '\n    exit /b 1',
             '\n)',
             '\n',
             '\nrem Check if the script exists',
             '\nif not exist "%script%" (',
             '\n    echo Script not found at "%script%".',
             '\n    pause',
             '\n    exit /b 1',
             '\n)',
             '\n',
             '\nrem Run the Python script using the specified Python executable',
             '\nstart /b "" "%python_exec%" "%script%"'
    
ENDRUN


;run batch files
*(_OpenVizTool.bat)