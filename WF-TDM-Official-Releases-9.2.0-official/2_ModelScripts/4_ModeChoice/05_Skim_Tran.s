
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 05_Skim_Tran.txt)



;get start time
ScriptStartTime = currenttime()




;========================================================================================
;             Prepare NETWORK for transit skims (use Distrib loaded net)
;========================================================================================

;add rail-bus transit network to distribution network & calculate congested bus speeds
RUN PGM=NETWORK   MSG='Mode Choice 5: add rail-bus net to Distrib net & calc congested bus speeds'
    FILEI NETI[1] = '@ParentDir@@ScenarioDir@3_Distribute\Distrib_Network__Summary.net'
    FILEI NETI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_BusRailLinks.net'
    
    FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\4_ModeChoice\bus_speed_ratios.csv'
    
    FILEO NETO  = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'
    FILEO LINKO = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.dbf'
    
    
    
    ;set NETWORK parameters
    ZONES = @UsedZones@
    MERGE RECORD=T
    
    
    
    LOOKUP LOOKUPI=1,
        INTERPOLATE=F,
        NAME=Bus_Speed_Ratio,
        LOOKUP[01]=1, RESULT=02,    ;Peak - Rural
        LOOKUP[02]=1, RESULT=03,    ;Peak - Transition
        LOOKUP[03]=1, RESULT=04,    ;Peak - Suburban
        LOOKUP[04]=1, RESULT=05,    ;Peak - Urban
        LOOKUP[05]=1, RESULT=06,    ;Peak - CBD-Like
        LOOKUP[06]=1, RESULT=07,    ;Off-Peak - Rural
        LOOKUP[07]=1, RESULT=08,    ;Off-Peak - Transition
        LOOKUP[08]=1, RESULT=09,    ;Off-Peak - Suburban
        LOOKUP[09]=1, RESULT=10,    ;Off-Peak - Urban
        LOOKUP[10]=1, RESULT=11     ;Off-Peak - CBD-Like
    
    
    
    ;set default functional class
    _FuncClass = 3
    
    ;define functional class (used as lookup index in 'Bus_Speed_Ratio' lookup function)
    if (li.1.FT=1,4-10)  _FuncClass = 1    ;collectors & locals
    if (li.1.FT=3)       _FuncClass = 2    ;minor arterials
    if (li.1.FT=2)       _FuncClass = 3    ;principal arterials
    if (li.1.FT=11-19)   _FuncClass = 4    ;expressways
    if (li.1.FT=20-49)   _FuncClass = 5    ;freeways & ramps
    
    
    ;calculate peak and off-peak area type index (used as function index 'Bus_Speed_Ratio' lookup function)
    _AT_PK = li.1.AREATYPE
    _AT_OK = li.1.AREATYPE + 5
    
    
    ;lookup bus speed ratio
    BusSpdRatio_PK = Bus_Speed_Ratio(_AT_PK, _FuncClass)
    BusSpdRatio_OK = Bus_Speed_Ratio(_AT_OK, _FuncClass)
    
    
    ;calculate transit speed
    if (li.2.FT>=50)
        
        ;rail & bus only links - use original speed from Master Network
        SPEED_AM = li.2.SPEED
        SPEED_MD = li.2.SPEED
        
    else
        
        ;highway links - congested auto speed * bus speed factor
        SPEED_AM = li.1.AM_SPD * BusSpdRatio_PK
        SPEED_MD = li.1.MD_SPD * BusSpdRatio_OK
        
    endif  ;li.2.FT>=50
    
ENDRUN



    
LOOP period = 1,2
    ;set name variable for output files
    if (period=1)
        prd       = 'Pk'
        TranSpeed = 'SPEED_AM'
    else
        prd       = 'Ok'
        TranSpeed = 'SPEED_MD'
    endif
    
    
    ;Cluster: distrubute MATRIX call onto processor 2
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2
     
        ;========================================================================================
        ;                             WALK & DRIVE to LCL (MODE 4) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to LCL - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_4_LCL_walk.FAC'                                   ;walk-to-LCL factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_4_LCL_drive.FAC'                                  ;drive-to-LCL factors file
            
            FILEI NTLEGI[1] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3] = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4] = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode40.NTL'                                                   ;AUTO-GENERATED drive links - LCL
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                               ;pk/ok auto skim
              
            FILEI LOOKUPI   = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_LCL_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w4_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d4_@prd@.RET'                                        ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO REPORTO   = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_LCL_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2]   = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-2                              ;1=walk 2=drive
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            FARE=F                                         ;include fare in choosing best path (turned off)
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - LCL
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (none possible in this skim)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no LCL IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[04][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (none possible in this skim)           
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 25    ;BYU students pay $60/year for a pass

                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
         
        
        
        
        ;========================================================================================
        ;                             WALK & DRIVE to COR (MODE 5) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to COR - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_5_COR_walk.FAC'                                   ;walk-to-COR factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_5_COR_walk_flag.FAC'                              ;direct-walk-to-COR factors file
            FILEI FACTORI[3] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_5_COR_drive.FAC'                                  ;drive-to-COR factors file
            
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode50.NTL'                                                   ;AUTO-GENERATED drive links - COR
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
              
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_COR_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w5_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w5_flag_@prd@.RET'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d5_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_COR_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_flag_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[3]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-3                              ;1=walk 2=direct-walk 3=drive
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - COR
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (none possible in this skim)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no COR IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[05][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (none possible in this skim)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 25    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
         
    ;Cluster: end of group distributed to processor 2
    EndDistributeMULTISTEP
    
    
    
     
    ;Cluster: distrubute MATRIX call onto processor 3
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=3
     
         
        ;========================================================================================
        ;                             WALK & DRIVE to EXP (MODE 6) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to EXP - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_6_EXP_walk.FAC'                                   ;walk-to-EXP factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_6_EXP_walk_flag.FAC'                              ;direct-walk-to-EXP factors file
            FILEI FACTORI[3] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_6_EXP_drive.FAC'                                  ;drive-to-EXP factors file
            
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode60.NTL'                                                   ;AUTO-GENERATED drive links - EXP
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
              
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_EXP_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w6_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w6_flag_@prd@.RET'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d6_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_EXP_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_flag_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[3]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-3                              ;1=walk 2=direct-walk 3=drive
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - EXP
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (none possible in this skim)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no EXP IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[06][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (none possible in this skim)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = mw[12]/2   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = mw[12]/2
                   ;if (j=@BYUmain@) mw[12][j] = mw[12]/2    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
         
    ;Cluster: end of group distributed to processor 3
    EndDistributeMULTISTEP
    
    
    
     
    ;Cluster: distrubute MATRIX call onto processor 4
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=4
     
        ;========================================================================================
        ;                             WALK & DRIVE to LRT ONLY MODE 7) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to LRT - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_7_LRTonly_walk.FAC'                                  ;drive-to-LRT factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_7_LRTonly_drive.FAC'                                  ;drive-to-LRT factors file
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode70.NTL'                                                   ;AUTO-GENERATED drive links - LRT
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
              
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_LRT_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_W_LRTonly_skims_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_D_LRTonly_skims_@prd@.RET'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            ;FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d7_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_LRT_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\W_LRTonly_skims_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            
            FILEO MATO[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\D_LRTonly_skims_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
                     
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-2                              ;1=walk-LRTonly 2=drive-LRTonly
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - LRT
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (set to zero for now)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no LRT IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[07][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (set to zero for now)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 0    ;BYU students pay $60/year for a pass

                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
      
      
      
         
    ;Cluster: end of group distributed to processor 4
  
        ;========================================================================================
        ;                             WALK to LRT (MODE 7) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to LRT - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_7_LRT_walk.FAC'                                   ;walk-to-LRT factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_7_LRT_walk_flag.FAC'                              ;direct-walk-to-LRT factors file
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode70.NTL'                                                   ;AUTO-GENERATED drive links - LRT
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
            FILEI MATI[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\W_LRTonly_skims_@prd@.mtx'                                                                 ;pk/ok walk to LRT only
             
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_WLRT_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_flag_@prd@.RET'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            ;FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d7_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_LRT_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_flag_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
      
                     
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-2                              ;1=walk 2=direct-walk
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - LRT
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (set to zero for now)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                mw[23]=mi.2.TRANSFERS/2
                    ;remove/exclude path if:
                    ;  - no LRT IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[07][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (set to zero for now)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 0    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
        
        
        
        
        ;========================================================================================
        ;                             Drive to LRT (MODE 7) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to LRT - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            

            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_7_LRT_drive.FAC'                                  ;drive-to-LRT factors file
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode70.NTL'                                                   ;AUTO-GENERATED drive links - LRT
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
            FILEI MATI[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\D_LRTonly_skims_@prd@.mtx'                                                                 ;pk/ok walk to LRT only
             
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_DLRT_skims_@prd@.NET'                                          ;create PT network with walk access links
            ;FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            ;FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_flag_@prd@.RE+T'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d7_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_LRT_skims_@prd@.RPT'                                                   ;PT report file
            
            

            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
      
                     
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-1                              ;1=drive to LRT only
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - LRT
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (set to zero for now)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                mw[23]=mi.2.TRANSFERS/2
                    ;remove/exclude path if:
                    ;  - no LRT IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[07][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (set to zero for now)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 0    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN         
    ;Cluster: end of group distributed to processor 4
    EndDistributeMULTISTEP
    
    
        
     
    ;Cluster: keep processing on processor 1 (Main)
         
        ;========================================================================================
        ;                             WALK & DRIVE to CRT (MODE 8) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to CRT - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_8_CRT_walk.FAC'                                   ;walk-to-EXP factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_8_CRT_walk_flag.FAC'                              ;direct-walk-to-EXP factors file
            FILEI FACTORI[3] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_8_CRT_drive.FAC'                                  ;drive-to-EXP factors file
            
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode80.NTL'                                                   ;AUTO-GENERATED drive links - CRT
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
              
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_CRT_skims_@prd@.NET'                                          ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w8_@prd@.RET'                                        ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w8_flag_@prd@.RET'                                   ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d8_@prd@.RET'                                        ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_CRT_skims_@prd@.RPT'                                                   ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_flag_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[3]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-3                              ;1=walk 2=direct-walk 3=drive
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - EXP
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (none possible in this skim)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no CRT IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[08][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (none possible in this skim)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = mw[12]/2   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = mw[12]/2
                   ;if (j=@BYUmain@) mw[12][j] = mw[12]/2    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
         
        
        
        
        ;========================================================================================
        ;                             WALK & DRIVE to COR (BRT) skim
        ;========================================================================================
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 5: skim walk & drive to BRT - @prd@'
            READ  FILE       = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'                                                   ;read in transit line files
            FILEI NETI       = '@ParentDir@@ScenarioDir@4_ModeChoice\_CongestedHwyNet_withBusRailLinks.net'                                                    ;highway network with Rail.link & Bus.link links
            FILEI SYSTEMI    = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'                                   ;system file
            FILEI FAREI      = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'                                     ;fare file
            
            FILEI FACTORI[1] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_9_BRT_walk.FAC'                                   ;walk-to-BRT factors file
            FILEI FACTORI[2] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_9_BRT_walk_flag.FAC'                              ;direct-walk-to-BRT factors file
            FILEI FACTORI[3] = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_9_BRT_drive.FAC'                                  ;drive-to-BRT factors file
            
            FILEI NTLEGI[1]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'      ;GENERAL hand coded walk links
            FILEI NTLEGI[2]  = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'     ;GENERAL hand coded drive links
            FILEI NTLEGI[3]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'                                 ;SCENARIO hand coded walk links
            FILEI NTLEGI[4]  = '@ParentDir@1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'                                ;SCENARIO hand coded drive links
            FILEI NTLEGI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_Xfer_Links.NTL'                                                           ;AUTO-GENERATED transfer links
            FILEI NTLEGI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_walk_links.NTL'                                                           ;AUTO-GENERATED walk links
            FILEI NTLEGI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode90.NTL'                                                   ;AUTO-GENERATED drive links - BRT
            
            FILEI MATI[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'                                                                 ;pk/ok auto skim
              
            FILEI LOOKUPI    = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@'
            
            FILEO NETO       = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNETOUT_BRT_skims_@prd@.NET'                                         ;create PT network with walk access links
            FILEO ROUTEO[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w9_@prd@.RET'                                      ;enumerated route file for userclass 1 (need to activate SKIMIJ phase)
            FILEO ROUTEO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w9_flag_@prd@.RET'                                 ;enumerated route file for userclass 2 (need to activate SKIMIJ phase)
            FILEO ROUTEO[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d9_@prd@.RET'                                      ;enumerated route file for userclass 3 (need to activate SKIMIJ phase)
            FILEO REPORTO    = '@ParentDir@@ScenarioDir@4_ModeChoice\1c_Reports\PTREPORT_BRT_skims_@prd@.RPT'                                                  ;PT report file
            
            FILEO MATO[1]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[2]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_flag_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            FILEO MATO[3]    = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx',
                MO=1-23, 
                NAME=INITWAIT,
                     XFERWAIT,
                     DRIVETIME,
                     T4,
                     T5,
                     T6,
                     T7,
                     T8,
                     T9,
                     T456789,
                     WALKTIME,
                     XFARE,
                     DRIVEDIST,
                     D4,
                     D5,
                     D6,
                     D7,
                     D8,
                     D9,
                     D456789,
                     BOARDINGS,
                     TRANSFERS,
                     RAIL_XFERS
            
            
            ;define lookup function
            LOOKUP LOOKUPI=1,
                LIST=N,
                INTERPOLATE=F,
                NAME=FreeZones,
                LOOKUP[1]=TAZID, RESULT=@EcoEdPassZones@,
                LOOKUP[2]=TAZID, RESULT=@FreeFareZones@
            
            
            ;set parameters
            USERCLASSES = 1-3                              ;1=walk 2=direct-walk 3=drive
            TRANTIME    = (li.DISTANCE / li.@TranSpeed@ * 60)    ;enclose expressions in parentheses
            HDWAYPERIOD = @period@                         ;headway to use in LINE files
            
            
            ;add walk access links
            PHASE=DATAPREP
               GENERATE READNTLEGI=1                       ;GENERAL hand coded walk links         
               GENERATE READNTLEGI=2                       ;GENERAL hand coded drive links        
               GENERATE READNTLEGI=3                       ;SCENARIO hand coded walk links        
               GENERATE READNTLEGI=4                       ;SCENARIO hand coded drive links       
               GENERATE READNTLEGI=5                       ;AUTO-GENERATED transfer links         
               GENERATE READNTLEGI=6                       ;AUTO-GENERATED walk links             
               GENERATE READNTLEGI=7                       ;AUTO-GENERATED drive links - BRT
            ENDPHASE
            
            
            ;perform transit skims
            PHASE=SKIMIJ
                mw[01] = IWAITA(0)                          ;actual initial wait time
                mw[02] = XWAITA(0)                          ;actual transfer wait time
                mw[03] = TIMEA(0,30,40,50,60,70,80,90)      ;actual auto in-vehicle time (IVT)
                mw[04] = TIMEA(0,4)                         ;actual transit in-vehicle time (IVT) - LCL
                mw[05] = TIMEA(0,5)                         ;actual transit in-vehicle time (IVT) - COR
                mw[06] = TIMEA(0,6)                         ;actual transit in-vehicle time (IVT) - EXP
                mw[07] = TIMEA(0,7)                         ;actual transit in-vehicle time (IVT) - LRT
                mw[08] = TIMEA(0,8)                         ;actual transit in-vehicle time (IVT) - CRT
                mw[09] = TIMEA(0,9)                         ;actual transit in-vehicle time (IVT) - COR
                mw[10] = TIMEA(0,4,5,6,7,8,9)               ;actual transit in-vehicle time (IVT) - all transit modes
                mw[11] = TIMEA(0,11,12,21,22)               ;actual walk access and walk transfer out-of-vehicle time (OVT)
                mw[12] = FAREA(0,4,5,6,7,8,9)               ;actual transit mode fare
                mw[13] = DIST(0,30,40,50,60,70,80,90)       ;auto in-vehicle distance
                mw[14] = DIST(0,4)                          ;transit in-vehicle distance - LCL
                mw[15] = DIST(0,5)                          ;transit in-vehicle distance - COR
                mw[16] = DIST(0,6)                          ;transit in-vehicle distance - EXP
                mw[17] = DIST(0,7)                          ;transit in-vehicle distance - LRT
                mw[18] = DIST(0,8)                          ;transit in-vehicle distance - CRT
                mw[19] = DIST(0,9)                          ;transit in-vehicle distance - COR
                mw[20] = DIST(0,4,5,6,7,8,9)                ;transit in-vehicle distance - all transit modes
                mw[21] = BRDINGS(0,4,5,6,7,8,9)             ;number of boardings
                mw[22] = MAX(0, mw[21]-1)                   ;number of transfers (transfers = boardings - 1)
                mw[23] = 0                                  ;rail-to-rail transfers (none possible in this skim)
            ENDPHASE
            
            
            PHASE=MATO
                ;adjust LCL paths
                JLOOP
                    ;remove/exclude path if:
                    ;  - no COR IVT
                    ;  - total auto + transit distnace > 1.5 * auto free-flow skim distance
                    ;  - drive access IVT>0 and auto free-flow skim distance between I & J is <= 3 miles
                    if (mw[09][j]=0  |  (mw[13][j]+mw[20][j]>mi.1.dist_GP[j]*1.5)  |  (mw[03]>0 & mi.1.dist_GP[j]<=3))
                        mw[01] = 0      ;actual initial wait time                                      
                        mw[02] = 0      ;actual transfer wait time                                     
                        mw[03] = 0      ;actual auto in-vehicle time (IVT)                             
                        mw[04] = 0      ;actual transit in-vehicle time (IVT) - LCL              
                        mw[05] = 0      ;actual transit in-vehicle time (IVT) - COR                    
                        mw[06] = 0      ;actual transit in-vehicle time (IVT) - EXP            
                        mw[07] = 0      ;actual transit in-vehicle time (IVT) - LRT                    
                        mw[08] = 0      ;actual transit in-vehicle time (IVT) - CRT                    
                        mw[09] = 0      ;actual transit in-vehicle time (IVT) - COR           
                        mw[10] = 0      ;actual transit in-vehicle time (IVT) - all transit modes      
                        mw[11] = 0      ;actual walk access and walk transfer out-of-vehicle time (OVT)
                        mw[12] = 0      ;actual transit mode fare                                      
                        mw[13] = 0      ;auto in-vehicle distance                                      
                        mw[14] = 0      ;transit in-vehicle distance - LCL                       
                        mw[15] = 0      ;transit in-vehicle distance - COR                             
                        mw[16] = 0      ;transit in-vehicle distance - EXP                     
                        mw[17] = 0      ;transit in-vehicle distance - LRT                             
                        mw[18] = 0      ;transit in-vehicle distance - CRT                             
                        mw[19] = 0      ;transit in-vehicle distance - COR                    
                        mw[20] = 0      ;transit in-vehicle distance - all transit modes               
                        mw[21] = 0      ;number of boardings                                           
                        mw[22] = 0      ;number of transfers (transfers = boardings - 1)               
                        mw[23] = 0      ;rail-to-rail transfers (none possible in this skim)  
                    endif
                   
                   ;make fare free for Ecopass, Edpass and free-fare zones
                   if (FreeZones(1,j)>0 & @demographicyear@>=FreeZones(1,j))  mw[12] = 0   
                   if (FreeZones(2,i)>0 & FreeZones(2,j)>0 & FreeZones(2,i)<=@demographicyear@ & FreeZones(2,j)<=@demographicyear@)  mw[12] = 0
                   ;if (j=@BYUmain@) mw[12][j] = 25    ;BYU students pay $60/year for a pass
                   
                   ;apply fare factor
                   mw[12] = mw[12] * @FARE_DISCOUNT@

                ENDJLOOP
            ENDPHASE
        ENDRUN
         
     
    ;Cluster: bring together all distributed steps before continuing
    WAIT4FILES, FILES="ClusterNodeID2.Script.End", FILES="ClusterNodeID3.Script.End", FILES="ClusterNodeID4.Script.End", CheckReturnCode=T
 
    
    
    
    ;========================================================================================
    ;                             DIRECT WALK TO TRANSIT MATRIX
    ;                & CALCULATE TOTAL TRIP TIME (IVT+OVT - Used in TLF summaries)
    ;========================================================================================
    RUN PGM=MATRIX   MSG='Mode Choice 5: calc direct walk to transit & total trip time - @prd@'
        FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
        FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
        FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
        FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
        FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
        FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
        
        FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
        FILEI MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
        FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
        FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
        FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
        FILEI MATI[12] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
        
        FILEI MATI[13] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_flag_@prd@.mtx'
        FILEI MATI[14] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_flag_@prd@.mtx'
        FILEI MATI[15] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_flag_@prd@.mtx'
        FILEI MATI[16] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_flag_@prd@.mtx'
        FILEI MATI[17] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_flag_@prd@.mtx'
        
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx',
            MO=1-5,
            NAME=WALK_COR,
                 WALK_EXP,
                 WALK_LRT,
                 WALK_CRT,
                 WALK_BRT
        
        FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\1Skm_TotTransitTime_@prd@.mtx',
            MO=101-112,
            NAME=w4time,
                 w5time,
                 w6time,
                 w7time,
                 w8time,
                 w9time,
                 
                 d4time,
                 d5time,
                 d6time,
                 d7time,
                 d8time,
                 d9time
        
        
        ;Cluster: distribute intrastep processing
        DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
        
        
        ZONEMSG = @ZoneMsgRate@
        
        JLOOP
            ;flag if direct walk path is in regular walk path
            if (mi.2.T5[j]>0 & mi.13.T5[j]>0)  mw[1] = 1
            if (mi.3.T6[j]>0 & mi.14.T6[j]>0)  mw[2] = 1
            if (mi.4.T7[j]>0 & mi.15.T7[j]>0)  mw[3] = 1
            if (mi.5.T8[j]>0 & mi.16.T8[j]>0)  mw[4] = 1
            if (mi.6.T9[j]>0 & mi.17.T9[j]>0)  mw[5] = 1
            
            ;summarize travel times by mode and walk or drive access
            MW[101] = MI.01.WALKTIME + MI.01.INITWAIT + MI.01.XFERWAIT + MI.01.T456789                        ;Total w4 time
            MW[102] = MI.02.WALKTIME + MI.02.INITWAIT + MI.02.XFERWAIT + MI.02.T456789                        ;Total w5 time
            MW[103] = MI.03.WALKTIME + MI.03.INITWAIT + MI.03.XFERWAIT + MI.03.T456789                        ;Total w6 time
            MW[104] = MI.04.WALKTIME + MI.04.INITWAIT + MI.04.XFERWAIT + MI.04.T456789                        ;Total w7 time
            MW[105] = MI.05.WALKTIME + MI.05.INITWAIT + MI.05.XFERWAIT + MI.05.T456789                        ;Total w8 time
            MW[106] = MI.06.WALKTIME + MI.06.INITWAIT + MI.06.XFERWAIT + MI.06.T456789                        ;Total w9 time
            
            MW[107] = MI.07.WALKTIME + MI.07.INITWAIT + MI.07.XFERWAIT + MI.07.T456789 + MI.07.DRIVETIME      ;Total d4 time
            MW[108] = MI.08.WALKTIME + MI.08.INITWAIT + MI.08.XFERWAIT + MI.08.T456789 + MI.08.DRIVETIME      ;Total d5 time
            MW[109] = MI.09.WALKTIME + MI.09.INITWAIT + MI.09.XFERWAIT + MI.09.T456789 + MI.09.DRIVETIME      ;Total d6 time
            MW[110] = MI.10.WALKTIME + MI.10.INITWAIT + MI.10.XFERWAIT + MI.10.T456789 + MI.10.DRIVETIME      ;Total d7 time
            MW[111] = MI.11.WALKTIME + MI.11.INITWAIT + MI.11.XFERWAIT + MI.11.T456789 + MI.11.DRIVETIME      ;Total d8 time
            MW[112] = MI.12.WALKTIME + MI.12.INITWAIT + MI.12.XFERWAIT + MI.12.T456789 + MI.12.DRIVETIME      ;Total d9 time
        ENDJLOOP
        
    ENDRUN
    
    
ENDLOOP  ;period (pk/ok)




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Skim Transit                       ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 05_Skim_Tran.txt)
