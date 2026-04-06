;---------------------------------------------------------------------------------------------------
;  EDIT SECTION
;---------------------------------------------------------------------------------------------------

;path to model root folder
;  note: can use absolute or relative path
ParentDir = '..\..\..\'


;transit line folder
;  available line folders:
;    Lin_2019
;    Lin_2023
;    Lin_2024
;    Lin_2028
;    Lin_2032
;    Lin_2042
;    Lin_2050
;    Lin_2032_Needs
;    Lin_2042_Needs
;    Lin_2050_Needs
;    Lin_2032_Needs_MAG
;    Lin_2042_Needs_MAG
;    Lin_2050_Needs_MAG
Mlin = 'Lin_2032_Needs_MAG\'


;master highway network
MasterNet = 'WFv910_MasterNet.net'


;scenario network
ScenarioPrefix = '3 - Needs_MAG_2032'

;scenario selection fields
;  available Lanes, FT & Transit Speed fields:
;    LN_2015          FT_2015          TSPD_2015
;    LN_2019          FT_2019          TSPD_2019
;    LN_2021          FT_2021          TSPD_2021
;    LN_2023          FT_2023          TSPD_2023
;    LN_2024          FT_2024          TSPD_2024
;    LN_2028          FT_2028          TSPD_2028
;    LN23_32          FT23_32          TSPD23_32
;    LN23_42          FT23_42          TSPD23_42
;    LN23_50          FT23_50          TSPD23_50
;    LN23_32UF        FT23_32UF        TSPD23_32U
;    LN23_42UF        FT23_42UF        TSPD23_42U
;    LN23_50UF        FT23_50UF        TSPD23_50U
;    LN23_50UFM
;                                      TSPD_AVE
;                                      TRNSPD_PTC
;                                      TRNSPD_MIS
;                                      TRNSPD_MED
;                                      TRNSPD_HIG
;                                      TRNSPD_HII
LNfield        = 'LN23_32UF'
FTfield        = 'FT23_32UF'
TranSpeedField = 'TSPD23_32U'

;---------------------------------------------------------------------------------------------------




;---------------------------------------------------------------------------------------------------
;  Script SECTION - do not need to edit
;---------------------------------------------------------------------------------------------------

;create scenario highway network with bus-rail links
RUN PGM=NETWORK  MSG='Create scenario network with bus-rail links'
FILEI NETI[1]  = '@ParentDir@1_Inputs\3_Highway\@MasterNet@'

FILEO NETO = 'results\@ScenarioPrefix@.net',
    INCLUDE=A       ,
            B       ,
            DISTANCE,
            LANES   ,
            FT      ,
            TRNSPD  ,
            TRANTIME


    ZONES = 9999
    
    
    PHASE=LINKMERGE
        
        ;delete roadway links with 0 lanes & keep transit-only links
        if (li.1.@LNfield@<=0 & li.1.@FTfield@<50)  DELETE
        
        
        ;specify LANES, FT & TRNSPD (transit speed) fields
        LANES  = li.1.@LNfield@
        
        FT     = li.1.@FTfield@
        
        TRNSPD = li.1.@TranSpeedField@
        
        TRANTIME = 0
        if (TRNSPD>0)  TRANTIME = 60 * li.1.DISTANCE/TRNSPD
        
    ENDPHASE
    
ENDRUN



;create PT network
RUN PGM=PUBLIC TRANSPORT  MSG='Check transit network' PRNFILE='results\@ScenarioPrefix@ - check.txt'
;scenario network with rail/bus links
FILEI NETI    = 'results\@ScenarioPrefix@.net'

;read in transit lines	;local bus lines
READ FILE     = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'


;add hand coded walk & drive access links
FILEI NTLEGI[1] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'
FILEI NTLEGI[2] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_drive_links.NTL'
FILEI NTLEGI[3] = '@ParentDir@\1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_walk_links.NTL'
FILEI NTLEGI[4] = '@ParentDir@\1_Inputs\4_Transit\@Mlin@Scenario_hand_coded_drive_links.NTL'


;read in system, fare & factors parameters
FILEI SYSTEMI = '@ParentDir@\1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'
FILEI FAREI   = '@ParentDir@\1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'
FILEI FACTORI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_WalkAllModes.FAC'


;create PT Network
;FILEO NETO   = 'results\PT_@ScenarioPrefix@.net'


    ZONEMSG = 50
    
    
    PARAMETERS TRANTIME = li.TRANTIME
    
    
    PHASE=DATAPREP
        
        ;add access links
        GENERATE READNTLEGI=1        ;general hand coded walk links
        GENERATE READNTLEGI=2        ;general hand coded drive links
        GENERATE READNTLEGI=3        ;scenario-specific hand coded walk links
        GENERATE READNTLEGI=4        ;scenario-specific hand coded drive links
        
    ENDPHASE
    
ENDRUN



;delete past prn files
*(DEL *.PRN)
