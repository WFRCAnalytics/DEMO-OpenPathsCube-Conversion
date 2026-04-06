
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 4_Create_walk_xfer_access_links.txt)


;get start time
ScriptStartTime = currenttime()



;Create transit network
RUN PGM=NETWORK  MSG='Network Processing 4: create rail link and bus link network'
    FILEI NETI    = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\@MasterPrefix@.net'.
    
    FILEI LINKI[2] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_Link_Direction.csv',
    VAR = A           ,
          B           ,
          DISTANCE    ,
          LINKID(C)   ,
          LANES       ,
          FT          ,
          DIRECTION(C),
          SEGID(C)    
    
    FILEO NETO = '@ParentDir@@ScenarioDir@0_InputProcessing\c_BusRailLinks.net',
        INCLUDE=A,B,LINKID,FT,SPEED,DISTANCE,SEGID,ANGLE,DIRECTION,IB_OB(C),PkDirPrd
    
    
    ;set NETWORK parameters
    ZONES=@UsedZones@
    
    
    PHASE=LINKMERGE
        
        ;delete links with 0 lanes to create scenario network
        if (li.1.@FTfield@<50)
            DELETE
        endif
        
        ;specify fT & speed fields
        FT    = li.1.@FTfield@
        SPEED = li.1.@TranSpeedField@

        ;assign SEGID field
        SEGID = li.1.@SEGIDField@
        if (li.1.@SEGIDExField@>' ')  SEGID = li.1.@SEGIDExField@
        
        
        ;assign direction values -------------------------------------------------------------------
        ;calculate the angle from due north in degrees from the start of the link
        ANGLE = _L.S_Angle
        ANGLE = ROUND(ANGLE * 10) / 10
        
        
        ;update DIRECTION
        DIRECTION = li.2.DIRECTION
        
        
        ;assign inbound/outbound
        ;IB/OB Ogden travel shed
        if (A.Y>@Og_Cor_Y@)
            if (DIRECTION='NB')
                if (A.Y<@Og_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='SB')
                if (A.Y>@Og_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='EB')
                if (A.X<@Og_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='WB')
                if (A.X>@Og_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            endif
            
        ;IB/OB Provo travel shed
        elseif (A.Y<@Pr_Cor_Y@)
            if (DIRECTION='NB')
                if (A.Y<@Pr_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='SB')
                if (A.Y>@Pr_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='EB')
                if (A.X<@Pr_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='WB')
                if (A.X>@Pr_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            endif
            
        ;IB/OB SL travel shed
        else
            if (DIRECTION='NB')
                if (A.Y<@SL_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='SB')
                if (A.Y>@SL_Y@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='EB')
                if (A.X<@SL_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            
            elseif (DIRECTION='WB')
                if (A.X>@SL_X@)
                    IB_OB = 'IB'
                else
                    IB_OB = 'OB'
                endif
            endif
        endif   ;Ogden/Provo/SL travel sheds
        
        ;set peak direction period
        if (IB_OB='IB')  
            PkDirPrd = 1    ;AM
        else
            PkDirPrd = 3    ;PM
        endif
           
    ENDPHASE
    
ENDRUN



;create bus speed on temp network for transit path building
RUN PGM=NETWORK  MSG='Network Processing 4: estimate bus speed for transit path building'
    FILEI NETI = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'
    FILEI NETI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_BusRailLinks.net'
    
    FILEO NETO  = '@ParentDir@@ScenarioDir@0_InputProcessing\@RID@_withBusRailLinks.net'
    FILEO LINKO = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf'
    FILEO NODEO = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf'
    
    
    ;set NETWORK parameters
    ZONES = @UsedZones@
    
    
    MERGE RECORD=T
    
    
    ;calculate transit speed
    if (li.2.FT>=50)
        SPEED = li.2.SPEED
    elseif (li.1.FT>=20)
        ;freeways
        SPEED = li.1.FF_SPD * 0.90
    else
        ;bus travels at 60% of network speed
        SPEED = li.1.FF_SPD * 0.60
    endif
    
    
    ;set barrier=1 for freeway and divided highway funtional types
    if (FT=@BarrierToWalkFT@)
        BARRIER = 1
    endif
    
    
    ;calculate X & Y coordinates for A & B nodes
    AX = A.X
    AY = A.Y
    BX = B.X
    BY = B.Y
    
    
ENDRUN



; Auto-generated transfer support links & export transit line dbf (used to identify transit stops)
RUN PGM=PUBLIC TRANSPORT  MSG='Network Processing 4: create auto-generated transfer links'
    FILEI NETI    = '@ParentDir@@ScenarioDir@0_InputProcessing\@RID@_withBusRailLinks.net'                               ;highway network with rail/bus links
    FILEI SYSTEMI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'      ;system file
    FILEI FAREI   = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'        ;fare file
    
    READ FILE     = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                      ;read in transit lines
    
    FILEI FACTORI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_WalkAllModes.FAC'    ;factors file
    
    FILEO NTLEGO = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                              ;auto generated transfer link file
    FILEO LINKO  = '@ParentDir@@ScenarioDir@0_InputProcessing\c_TransitLinks.dbf', ONOFFS=Y                                 ;export links with stops
    FILEO NETO   = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\PTNET_XFER.NET'                                          ;create PT Network
    
    
    ZONEMSG = @ZoneMsgRate@
    
    
    PARAMETERS TRANTIME = (60 * li.DISTANCE/li.Speed)     ;li.Distance/(li.Speed/60)
    
    
    ;Calculate walk time, default walk speed is set to be 2.5mph
    PHASE=LINKREAD
        lw.WalkTime = 60 * li.DISTANCE / @walkspeed@
    ENDPHASE
    
    
    ;create auto-generated transfer links
    PHASE=DATAPREP
        GENERATE, 
            XFERMETHOD = 1,                            ;prevents transfers to/from same transit line
            NTLEGMODE  = 21,
            COST       = lw.WalkTime,
            MAXCOST    = 9*12,                         ;maxium walk time allowed for first 9 modes, 12 min = 60 * 0.5 mi / 2.5 mph
            ONEWAY     = F,
            FROMNODE   = @HwyNodes@,                   ;highway nodes
            TONODE     = @HwyNodes@                    ;highway nodes
    ENDPHASE
  
ENDRUN



; List transit stop nodes by mode
RUN PGM=MATRIX  MSG='Network Processing 4: list transit stop nodes by mode'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_TransitLinks.dbf',     AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',         AUTOARRAY=ALLFIELDS
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode4.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y
    FILEO RECO[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode5.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y
    FILEO RECO[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode6.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y
    FILEO RECO[4] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode7.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y, ROUTE
    FILEO RECO[5] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode8.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y, ROUTE
    FILEO RECO[6] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode9.dbf',    FORM=15.5, FIELDS=N(10.0), X, Y
    FILEO RECO[7] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsAllModes.dbf', FORM=15.5, FIELDS=N(10.0), X, Y, MODE(10.0)
    FILEO RECO[8] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_Stops_report.dbf',  FORM=10.0, FIELDS=MODE, NUMSTOPS, MAXSTOPNUM
    FILEO RECO[9] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',     FORM=10.0, FIELDS=N, X(15.5), Y(15.5), PNR, CO_FIPS, TAZID
    
    
    ;parameters
    ZONES = 1
    
    
    ;define arrays
    ARRAY STOPS_MODE4    = 99999,
          STOPS_MODE5    = 99999,
          STOPS_MODE6    = 99999,
          STOPS_MODE7    = 99999,
          STOPS_MODE8    = 99999,
          STOPS_MODE9    = 99999,
          STOPS_AllModes = 99999,
          
          X_ARRAY        = 999999,
          Y_ARRAY        = 999999
    
    
    ;loop through highway nodes
    LOOP recnum=1,DBI.2.NUMRECORDS
        ;assign node number to variable to use as array index
        NodeNum = dba.2.N[recnum]
        
        ;assign X & Y coordinate arrays, used in stop distance calculation
        X_ARRAY[NodeNum] = dba.2.X[recnum]
        Y_ARRAY[NodeNum] = dba.2.Y[recnum]
        
        ;write PNR node data to output file
        if (dba.2.@pnr_field@[recnum]>0)
            RO.N       = dba.2.N[recnum]
            RO.X       = dba.2.X[recnum]
            RO.Y       = dba.2.Y[recnum]
            RO.PNR     = dba.2.@pnr_field@[recnum]
            RO.CO_FIPS = dba.2.CO_FIPS[recnum]
            RO.TAZID   = dba.2.TAZID[recnum]
            
            WRITE RECO=9
        endif
    ENDLOOP
    
    
    ;loop through input records to find stops by mode
    LOOP recnum=1,DBI.1.NUMRECORDS
        
        ;local bus
        if (dba.1.MODE[recnum]=4)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
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
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=1
                    
                    MaxStop_Mode4 = MAX(MaxStop_Mode4,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
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
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=1
                    
                    MaxStop_Mode4 = MAX(MaxStop_Mode4,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
        
        ;BRT
        elseif (dba.1.MODE[recnum]=5)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode5=0)
                    PrintStop = 1
                    cnt_Mode5 = 1
                    STOPS_Mode5[cnt_Mode5] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode5
                        if (Stop_Node=STOPS_Mode5[cnt])
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
                        cnt_Mode5 = cnt_Mode5 + 1
                        STOPS_Mode5[cnt_Mode5] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=2
                    
                    MaxStop_Mode5 = MAX(MaxStop_Mode5,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode5=0)
                    PrintStop = 1
                    cnt_Mode5 = 1
                    STOPS_Mode5[cnt_Mode5] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode5
                        if (Stop_Node=STOPS_Mode5[cnt])
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
                        cnt_Mode5 = cnt_Mode5 + 1
                        STOPS_Mode5[cnt_Mode5] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=2
                    
                    MaxStop_Mode5 = MAX(MaxStop_Mode5,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
        
        ;express bus
        elseif (dba.1.MODE[recnum]=6)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode6=0)
                    PrintStop = 1
                    cnt_Mode6 = 1
                    STOPS_Mode6[cnt_Mode6] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode6
                        if (Stop_Node=STOPS_Mode6[cnt])
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
                        cnt_Mode6 = cnt_Mode6 + 1
                        STOPS_Mode6[cnt_Mode6] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=3
                    
                    MaxStop_Mode6 = MAX(MaxStop_Mode6,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode6=0)
                    PrintStop = 1
                    cnt_Mode6 = 1
                    STOPS_Mode6[cnt_Mode6] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode6
                        if (Stop_Node=STOPS_Mode6[cnt])
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
                        cnt_Mode6 = cnt_Mode6 + 1
                        STOPS_Mode6[cnt_Mode6] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=3
                    
                    MaxStop_Mode6 = MAX(MaxStop_Mode6,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
        
        ;LRT
        elseif (dba.1.MODE[recnum]=7)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
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
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N     = Stop_Node
                    RO.X     = X_ARRAY[Stop_Node]
                    RO.Y     = Y_ARRAY[Stop_Node]
                    RO.ROUTE = dba.1.NAME[recnum]
                    
                    WRITE RECO=4
                    
                    MaxStop_Mode7 = MAX(MaxStop_Mode7,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
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
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N     = Stop_Node
                    RO.X     = X_ARRAY[Stop_Node]
                    RO.Y     = Y_ARRAY[Stop_Node]
                    RO.ROUTE = dba.1.NAME[recnum]
                    
                    WRITE RECO=4
                    
                    MaxStop_Mode7 = MAX(MaxStop_Mode7,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
        
        ;CRT
        elseif (dba.1.MODE[recnum]=8)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode8=0)
                    PrintStop = 1
                    cnt_Mode8 = 1
                    STOPS_Mode8[cnt_Mode8] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode8
                        if (Stop_Node=STOPS_Mode8[cnt])
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
                        cnt_Mode8 = cnt_Mode8 + 1
                        STOPS_Mode8[cnt_Mode8] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N     = Stop_Node
                    RO.X     = X_ARRAY[Stop_Node]
                    RO.Y     = Y_ARRAY[Stop_Node]
                    RO.ROUTE = dba.1.NAME[recnum]
                    
                    WRITE RECO=5
                    
                    MaxStop_Mode8 = MAX(MaxStop_Mode8,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode8=0)
                    PrintStop = 1
                    cnt_Mode8 = 1
                    STOPS_Mode8[cnt_Mode8] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode8
                        if (Stop_Node=STOPS_Mode8[cnt])
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
                        cnt_Mode8 = cnt_Mode8 + 1
                        STOPS_Mode8[cnt_Mode8] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N     = Stop_Node
                    RO.X     = X_ARRAY[Stop_Node]
                    RO.Y     = Y_ARRAY[Stop_Node]
                    RO.ROUTE = dba.1.NAME[recnum]
                    
                    WRITE RECO=5
                    
                    MaxStop_Mode8 = MAX(MaxStop_Mode8,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
        
        ;enhanced BRT
        elseif (dba.1.MODE[recnum]=9)
        
            ;check if A node is transit stop
            if (dba.1.STOPA[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.A[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode9=0)
                    PrintStop = 1
                    cnt_Mode9 = 1
                    STOPS_Mode9[cnt_Mode9] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode9
                        if (Stop_Node=STOPS_Mode9[cnt])
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
                        cnt_Mode9 = cnt_Mode9 + 1
                        STOPS_Mode9[cnt_Mode9] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=6
                    
                    MaxStop_Mode9 = MAX(MaxStop_Mode9,RO.N)
                    PrintStop=0
                endif
                
            ;check if B node is transit stop
            elseif (dba.1.STOPB[recnum]=1)
                ;assign stop number to variable
                Stop_Node = dba.1.B[recnum]
                
                ;add first stop to stops array
                if (cnt_Mode9=0)
                    PrintStop = 1
                    cnt_Mode9 = 1
                    STOPS_Mode9[cnt_Mode9] = Stop_Node
                
                ;check to see if already recorded stop node (prevents duplicates)
                else
                    LOOP cnt=1,cnt_Mode9
                        if (Stop_Node=STOPS_Mode9[cnt])
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
                        cnt_Mode9 = cnt_Mode9 + 1
                        STOPS_Mode9[cnt_Mode9] = Stop_Node
                    endif
                endif
                
                ;write stop to output file
                if (PrintStop=1)
                    ;assign N, X & Y vales for stop & print to output file
                    RO.N = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                    
                    WRITE RECO=6
                    
                    MaxStop_Mode9 = MAX(MaxStop_Mode9,RO.N)
                    PrintStop=0
                endif
            
            endif  ;check A or B is stop
            
        endif  ;mode
        
        
        ;add stop node to STOPS_AllModes array
        ;check if A node is transit stop
        if (dba.1.STOPA[recnum]=1)
            ;assign stop number to variable
            Stop_Node = dba.1.A[recnum]
            
            ;add first stop to stops array
            if (cnt_AllModes=0)
                PrintStop = 1
                cnt_AllModes = 1
                STOPS_AllModes[cnt_AllModes] = Stop_Node
            
            ;check to see if already recorded stop node (prevents duplicates)
            else
                LOOP cnt=1,cnt_AllModes
                    if (Stop_Node=STOPS_AllModes[cnt])
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
                    cnt_AllModes = cnt_AllModes + 1
                    STOPS_AllModes[cnt_AllModes] = Stop_Node
                endif
            endif
            
            ;write stop to output file
            if (PrintStop=1)
                ;assign N, X & Y vales for stop & print to output file
                RO.N    = Stop_Node
                    RO.X = X_ARRAY[Stop_Node]
                    RO.Y = Y_ARRAY[Stop_Node]
                RO.MODE = dba.1.MODE[recnum]
                
                WRITE RECO=7
                
                MaxStop_AllModes = MAX(MaxStop_AllModes,RO.N)
                PrintStop=0
            endif
            
        ;check if B node is transit stop
        elseif (dba.1.STOPB[recnum]=1)
            ;assign stop number to variable
            Stop_Node = dba.1.B[recnum]
            
            ;add first stop to stops array
            if (cnt_AllModes=0)
                PrintStop = 1
                cnt_AllModes = 1
                STOPS_AllModes[cnt_AllModes] = Stop_Node
            
            ;check to see if already recorded stop node (prevents duplicates)
            else
                LOOP cnt=1,cnt_AllModes
                    if (Stop_Node=STOPS_AllModes[cnt])
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
                    cnt_AllModes = cnt_AllModes + 1
                    STOPS_AllModes[cnt_AllModes] = Stop_Node
                endif
            endif
            
            ;write stop to output file
            if (PrintStop=1)
                ;assign N, X & Y vales for stop & print to output file
                RO.N    = Stop_Node
                RO.X = X_ARRAY[Stop_Node]
                RO.Y = Y_ARRAY[Stop_Node]
                RO.MODE = dba.1.MODE[recnum]
                
                WRITE RECO=7
                
                MaxStop_AllModes = MAX(MaxStop_AllModes,RO.N)
                PrintStop=0
            endif
        
        endif  ;check A or B is stop
        
    ENDLOOP
    
    
    ;write stops summary report
    ;local bus
    RO.MODE       = 4
    RO.NUMSTOPS   = cnt_Mode4
    RO.MAXSTOPNUM = MaxStop_Mode4
    
    WRITE RECO = 8
    
    ;BRT
    RO.MODE       = 5
    RO.NUMSTOPS   = cnt_Mode5
    RO.MAXSTOPNUM = MaxStop_Mode5
    
    WRITE RECO = 8
    
    ;express bus
    RO.MODE       = 6
    RO.NUMSTOPS   = cnt_Mode6
    RO.MAXSTOPNUM = MaxStop_Mode6
    
    WRITE RECO = 8
    
    ;LRT
    RO.MODE       = 7
    RO.NUMSTOPS   = cnt_Mode7
    RO.MAXSTOPNUM = MaxStop_Mode7
    
    WRITE RECO = 8
    
    ;CRT
    RO.MODE       = 8
    RO.NUMSTOPS   = cnt_Mode8
    RO.MAXSTOPNUM = MaxStop_Mode8
    
    WRITE RECO = 8
    
    ;enhanced BRT
    RO.MODE       = 9
    RO.NUMSTOPS   = cnt_Mode9
    RO.MAXSTOPNUM = MaxStop_Mode9
    
    WRITE RECO = 8
    
    ;all modes
    RO.MODE       = 10
    RO.NUMSTOPS   = cnt_AllModes
    RO.MAXSTOPNUM = MaxStop_AllModes
    
    WRITE RECO = 8
    
    ;log variables for use in downstream modules
    LOG VAR=MaxStop_AllModes
ENDRUN



;check - put stop nodes by mode onto highway network (for checking)
;RUN PGM=NETWORK  MSG='Network Processing 4: put stop nodes (by mode) on highway network'
;    FILEI NETI[1]  = '@ParentDir@@ScenarioDir@0_InputProcessing\@RID@_withBusRailLinks.net'                       ;highway network with Rail.link & Bus.link links
;    FILEI NODEI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode4.dbf'
;    FILEI NODEI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode5.dbf'
;    FILEI NODEI[4] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode6.dbf'
;    FILEI NODEI[5] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode7.dbf'
;    FILEI NODEI[6] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode8.dbf'
;    ;FILEI NODEI[7] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode9.dbf'
;    FILEI NODEI[8] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsAllModes.dbf'
;    
;    FILEO NETO  = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNet_withBusRailLinks2.net'                       ;highway network with Rail.link & Bus.link links
;    
;    PHASE=NODEMERGE
;        if (NI.2.N>0)  STOP_4   = 1
;        if (NI.3.N>0)  STOP_5   = 1
;        if (NI.4.N>0)  STOP_6   = 1
;        if (NI.5.N>0)  STOP_7   = 1
;        if (NI.6.N>0)  STOP_8   = 1
;        ;if (NI.7.N>0)  STOP_9   = 1
;        if (NI.8.N>0)  STOP_All = 1
;    ENDPHASE
;ENDRUN



;create auto-generated walk access links & barrier links
RUN PGM=MATRIX  MSG='Network Processing 4: create auto-generated walk access links'

FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',
    AUTOARRAY=ALLFIELDS

FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsAllModes.dbf',
    AUTOARRAY=ALLFIELDS

FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf',
    AUTOARRAY=ALLFIELDS

FILEI DBI[4] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf',
    AUTOARRAY=ALLFIELDS


FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\barrier_links.NTL'
FILEO PRINTO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    ;print header for NTL files
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    PRINT PRINTO=2, LIST=';;<<PT>>;; \n'
    
    
    ;loop through highway nodes
    LOOP rec_HwyNode=1, dbi.1.NUMRECORDS
        
        TAZ_Node = dba.1.N[rec_HwyNode]
        
        ;process only internal zones (exclude dummy zones & centroids)
        if (TAZ_Node<=@UsedZones@ & !(TAZ_Node=@dummyzones@ | TAZ_Node=@externalzones@))
            
            ;print progress bar
            procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
            PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
            
            
            ;calculate TAZ X & Y coordinates
            TAZ_X   = dba.1.X[rec_HwyNode]
            TAZ_Y   = dba.1.Y[rec_HwyNode]
            
            
            ;calculate max walk distance in miles
            ;  note: allows walk access in larger zones while prevents smaller zones from drawing too many walk access links
            ;        0.0625 = 0.25 * 0.25 square miles
            ;        0.2500 = 0.50 * 0.50 square miles
            
            ;TAZ area in sqare miles
            TAZarea = dba.4.ACRES[rec_HwyNode] * 0.0015625
            
            ;max walk distance
            maxwalk = 0.95
            
            if (TAZarea<=0.0625)                 maxwalk = 0.50
            if (TAZarea>0.0625 & TAZarea<=0.25)  maxwalk = 0.70
            
            
            ;loop through stop nodes
            LOOP rec_StopNode=1, dbi.2.NUMRECORDS
                
                ;calculate stop node number and X & Y coordinates
                Stop_Node = dba.2.N[rec_StopNode]
                Stop_X    = dba.2.X[rec_StopNode]
                Stop_Y    = dba.2.Y[rec_StopNode]
                
                
                ;calculate straight line distance from TAZ to stop node in miles
                xydist = SQRT( (TAZ_X-Stop_X)^2 + (TAZ_Y-Stop_Y)^2 ) / 1609.344
                
                
                ;print walk access link if <= maxdist & not accross barrier
                if (xydist<=maxwalk)
                    
                    ;check if crosses barrier link
                    LOOP HwyLink=1,DBI.3.NUMRECORDS
                        
                        if (dba.3.BARRIER[HwyLink]=1)
                        
                            ;calculate Barrier link X & Y coordinates
                            AX = dba.3.AX[HwyLink]
                            AY = dba.3.AY[HwyLink]
                            BX = dba.3.BX[HwyLink]
                            BY = dba.3.BY[HwyLink]
                            
                            ;calc slope of walk access link
                            if (TAZ_X=Stop_X)
                                verticle1 = 1
                                PX        = TAZ_X                 ;all X have same coordinate
                            else
                                verticle1 = 0
                                slope1    = (Stop_Y-TAZ_Y) / (Stop_X-TAZ_X)
                            endif
                            
                            ;calc slope of highway-barrier link
                            if (AX=BX)
                                verticle2 = 1
                                PX        = AX                    ;all X have same coordinate
                            else
                                verticle2 = 0
                                slope2    = (BY-AY) / (BX-AX)
                            endif
                            
                            ;find intersection point if it exists
                            if (slope1=slope2)                    ;lines are parllel, no intersection
                                Interesect = 0
                                BREAK
                            
                            elseif (verticle1=1)                  ;walk link is verticle, X coordinate already solved
                                PY = slope2*(PX-AX) + AY          ;use point & slope from barrier link to solve Y coordinate
                            
                            elseif (verticle2=1)                  ;barrier link is verticle, X coordinate already solved
                                PY = slope1*(PX-TAZ_X) + TAZ_Y    ;use point & slope from walk link to solve Y coordinate
                            
                            else
                                PX = (slope1*TAZ_X - slope2*AX + AY - TAZ_Y) / (slope1 - slope2)    ;equation y=m(x-x1)+y1, intersect when lines have same X & Y, set eq for line1 = eq for line 2, solve for x
                                PY = slope1*(PX-TAZ_X) + TAZ_Y    ;insert X into either eq1 or eq2 and solve for Y
                            endif
                            
                            ;check if intersection point is within X & Y bounds of endpoints of walk and barrier links
                            if (PX>MIN(TAZ_X,Stop_X) & PX<MAX(TAZ_X,Stop_X) & PY>MIN(TAZ_Y,Stop_Y) & PY<MAX(TAZ_Y,Stop_Y))    ;intersect point within x,y bounds of walk link
                                if (PX>MIN(AX,BX) & PX<MAX(AX,BX) & PY>MIN(AY,BY) & PY<MAX(AY,BY))                            ;intersect point within x,y bounds of barrier link
                                    
                                    ;print out barrier links as NT leg
                                    PRINT PRINTO=1, 
                                        LIST='NT LEG=', TAZ_Node(6.0),' -', Stop_Node(6.0), ',  MODE=11,  COST=', xydist/@walkspeed@*60(6.2), ',  DIST=', xydist(6.2), ',  ONEWAY=F,  SPEED=@walkspeed@'
                                    
                                    Interesect = 1                ;two lines intersect
                                    BREAK
                                endif
                            endif
                            
                        endif  ;if barrier=1
                        
                    ENDLOOP  ;loop through highway links to check barrier intersect
                    
                    ;print walk access link if no barrier intersection
                    if (Interesect=0)
                        ;print out link as NT leg
                        PRINT PRINTO=2, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', Stop_Node(6.0), ',  MODE=11,  COST=', xydist/@walkspeed@*60(6.2), ',  DIST=', xydist(6.2), ',  ONEWAY=F,  SPEED=@walkspeed@'
                    else
                        Interesect = 0
                    endif
                    
                endif  ;if walk distance <= max walk distance for TAZ
                
            ENDLOOP  ;rec_StopNode=1, dbi.2.NUMRECORDS
            
        endif  ;(TAZ_Node<=@UsedZones@ & !(TAZ_Node=@dummyzones@ | TAZ_Node=@externalzones@))
    
    ENDLOOP  ;rec_HwyNode=1, dbi.1.NUMRECORDS
    
ENDRUN



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Transit Pre-processing             ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 4_Create_walk_xfer_access_links.txt)
