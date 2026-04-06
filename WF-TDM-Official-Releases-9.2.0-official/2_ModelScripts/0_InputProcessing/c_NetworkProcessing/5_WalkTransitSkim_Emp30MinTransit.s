
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 5_WalkTransitSkim_Emp30MinTransit.txt)



;get start time
ScriptStartTime = currenttime()




; Walk Skim
RUN PGM=PUBLIC TRANSPORT  MSG='Network Processing 4: peform skim walk to transit'
    FILEI NETI    = '@ParentDir@@ScenarioDir@0_InputProcessing\@RID@_withBusRailLinks.net'                                  ;highway network with Rail.link & Bus.link links
    FILEI SYSTEMI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'         ;system file
    FILEI FAREI   = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'           ;fare file
    
    READ  FILE    = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                              ;read in transit line files
    
    FILEI FACTORI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_WalkAllModes.FAC'       ;factors file
    
    FILEI NTLEGI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;read in auto generated transfer links
    FILEI NTLEGI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;read in auto generated walk links
    FILEI NTLEGI[3] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;read in GENERAL hand coded walk links
    FILEI NTLEGI[4] = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;read in SCENARIO-SPECIFIC hand coded walk links
    
    FILEO NETO    = '@ParentDir@@ScenarioDir@0_InputProcessing\PTNET_WalkAccess.NET'                                           ;create PT network with walk access links
    FILEO ROUTEO  = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\AM_LOCAL_WK.RET'                                           ;need to activate SKIMIJ phase
    FILEO REPORTO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\AM_LOCAL_WK.RPT'
    
    FILEO MATO    = '@ParentDir@@ScenarioDir@0_InputProcessing\c_TransitWalkSkim_FF.mtx',
        MO=1-5, 
        NAME=WALKTIME, 
             INITWAIT, 
             XFERWAIT, 
             IVTTime, 
             XFERS
    
    
    ;set parameters
    ZONEMSG     = 50
            
    TRANTIME    = (li.DISTANCE / li.SPEED * 60)    ;enclose expressions in parentheses
    HDWAYPERIOD = 1                                ;headway to use in LINE files
    
    
    ;add walk access links
    PHASE=DATAPREP
       GENERATE READNTLEGI=1                       ;auto generated transfer link
       GENERATE READNTLEGI=2                       ;auto generated walk access link
       GENERATE READNTLEGI=3                       ;general hand coded walk access link
       GENERATE READNTLEGI=4                       ;scenario hand coded walk access link
    ENDPHASE
    
    
    ;perform transit skims
    PHASE=SKIMIJ
        MW[1] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer time
        MW[2] = IWAITA(0)                          ;actual initial wait time
        MW[3] = XWAITA(0)                          ;actual transfer wait time
        MW[4] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT)
        MW[5] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
        
        ;flag odd zones
        if (MW[4]=0 & MW[1]>0)  MW[1] = 99999
        if (MW[4]=0 & MW[2]>0)  MW[2] = 99999
        if (MW[4]=0 & MW[3]>0)  MW[3] = 99999
        
        ;convert from boarding to transfers
        MW[5] = MAX(0, MW[5] - 1)        ;transfer number =total board number - 1
    ENDPHASE
ENDRUN




; Employment within 30 Minutes of Transit
RUN PGM=MATRIX  MSG='Network Processing 4: calculate employment within 30 minutes of transit'
    FILEI ZDATI   = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_TransitWalkSkim_FF.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\No_Transit_XFER.mtx', 
        MO=2, 
        NAME=no_xfer
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Emp30MinTran.txt'
    
    ;general parameters
    ZONEMSG = @ZoneMsgRate@
    
    
    ;define array
    ARRAY JOBS30min=@UsedZones@
    
    
    ;calculate 
    MW[1] = mi.1.WALKTIME + mi.1.INITWAIT + mi.1.XFERWAIT + mi.1.IVTTime + mi.1.XFERS*10
    
    JLOOP
        ;assign 0 transfer matrix
        if (mi.1.XFERS[J]=0 & mi.1.IVTTime[J]>0)  MW[2] = 1
        
        ;calculate employment within 30 min of transit array
        if (MW[1][j]<=30 & mi.1.IVTTime[J]>0)  JOBS30min[I] = JOBS30min[I] + ZI.1.TOTEMP[J]
    ENDJLOOP
    
    PRINT PRINTO=1, 
        FORM=8.0, 
        LIST=I, JOBS30min[I]
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Walk-Tran Skim & Emp30MinTran      ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 5_WalkTransitSkim_Emp30MinTransit.txt)
