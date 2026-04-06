
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 04_REMM_TransitStops.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX  MSG='REMM: list transit stop nodes by mode'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_TransitLinks.dbf',
        AUTOARRAY=ALLFIELDS
    
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',
        AUTOARRAY=ALLFIELDS
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@6_REMM\StopsBus.dbf',
        FORM=15.5, 
        FIELDS=Node, 
               Mode
    
    FILEO RECO[2] = '@ParentDir@@ScenarioDir@6_REMM\StopsRail.dbf',
        FORM=15.5, 
        FIELDS=Node, 
               Mode    
    
    
    ;parameters
    ZONES = 1
    
    
    ;define arrays
    ARRAY STOPS_MODE4    = 99999,
          STOPS_MODE7    = 99999
    
    
    ;loop through input records to find stops by mode
    LOOP recnum=1,DBI.1.NUMRECORDS
        
        ;local bus
        if (DBA.1.MODE[recnum]=4,5,6,9)
        
            ;check if A node is transit stop
            if (DBA.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = DBA.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode4=0)
                    PrintStop = 1
                    cnt_Mode4 = 1
                    STOPS_MODE4[cnt_Mode4] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode4
                        if (Stop_Node=STOPS_MODE4[cnt])
                            StopInList = 1
                            BREAK
                        endif
                    ENDLOOP
                    
                    if (StopInList=1)
                        ;reset check variable
                        StopInList = 0
                    else
                        ;add first stop to stops array
                        PrintStop = 1
                        cnt_Mode4 = cnt_Mode4 + 1
                        STOPS_MODE4[cnt_Mode4] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)

            RO.Node=Stop_Node
            RO.Mode='Bus'
              WRITE RECO = 1
              
                    MaxStop_Mode4 = MAX(MaxStop_Mode4,Stop_Node)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop 
            elseif (DBA.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = DBA.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode4=0)
                    PrintStop = 1
                    cnt_Mode4 = 1
                    STOPS_MODE4[cnt_Mode4] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode4
                        if (Stop_Node=STOPS_MODE4[cnt])
                            StopInList = 1
                            BREAK
                        endif
                    ENDLOOP
                    
                    if (StopInList=1)
                        ;reset check variable
                        StopInList = 0
                    else
                        ;add first stop to stops array
                        PrintStop = 1
                        cnt_Mode4 = cnt_Mode4 + 1
                        STOPS_MODE4[cnt_Mode4] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    RO.Node=Stop_Node
                    RO.Mode='Bus'
                    WRITE RECO = 1
                    MaxStop_Mode4 = MAX(MaxStop_Mode4,Stop_Node)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
         elseif (DBA.1.MODE[recnum]=7,8)
        
            ;check if A node is transit stop
            if (DBA.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = DBA.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode7=0)
                    PrintStop = 1
                    cnt_Mode7 = 1
                    STOPS_Mode7[cnt_Mode7] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode7
                        if (Stop_Node=STOPS_Mode7[cnt])
                            StopInList = 1
                            BREAK
                        endif
                    ENDLOOP
                    
                    if (StopInList=1)
                        ;reset check variable
                        StopInList = 0
                    else
                        ;add first stop to stops array
                        PrintStop = 1
                        cnt_Mode7 = cnt_Mode7 + 1
                        STOPS_Mode7[cnt_Mode7] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                  RO.Node=Stop_Node
                  RO.Mode='Rail'
              WRITE RECO = 2
                    
                    MaxStop_Mode7 = MAX(MaxStop_Mode7,Stop_Node)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            
          elseif (DBA.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = DBA.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode7=0)
                    PrintStop = 1
                    cnt_Mode7 = 1
                    STOPS_Mode7[cnt_Mode7] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode7
                        if (Stop_Node=STOPS_Mode7[cnt])
                            StopInList = 1
                            BREAK
                        endif
                    ENDLOOP
                    
                    if (StopInList=1)
                        ;reset check variable
                        StopInList = 0
                    else
                        ;add first stop to stops array
                        PrintStop = 1
                        cnt_Mode7 = cnt_Mode7 + 1
                        STOPS_Mode7[cnt_Mode7] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    RO.Node=Stop_Node
                    RO.Mode='Rail'
                    WRITE RECO = 2                
                    MaxStop_Mode7 = MAX(MaxStop_Mode7,Stop_Node)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
               
        endif  ;mode
        
    ENDLOOP
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    List transit stop nodes            ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 04_REMM_TransitStops.txt)
