;=============================================================================================================
; General Setup
;=============================================================================================================

;System
;In case TP+ crashes during batch, this will halt process & help identify error.
*(ECHO model crashed > 1_NetProcessor.txt)


;get start time
ScriptStartTime = currenttime()



;=============================================================================================================
; Update Master Network, create Transit shapefiles, & create Walk Buffers
;=============================================================================================================

;-----------------------------------------------------------------------------------------
; export temp master network node & link shapefiles
;-----------------------------------------------------------------------------------------

RUN PGM=NETWORK MSG='Network Processing 1: export temp Master Network link and node shapefiles'
FILEI NETI[1]  = '@ParentDir@1_Inputs\3_Highway\@MasterPrefix@.net'

FILEO NODEO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Master_Node_tmp0.dbf',
    INCLUDE=N         ,
            X         ,
            Y         ,
            TAZID     ,
            HOT_ZONEID

FILEO LINKO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Master_Link_tmp0.dbf',
    INCLUDE=A         ,
            B         ,
            DISTANCE  ,
            LINKID    ,
            TAZID     ,
            HOT_ZONEID,
            LANES     ,
            FT        ,
            SEGID     
    
    
    ;set parameters
    ZONES = @Usedzones@
    
    
    PHASE=NODEMERGE
        
        ;initialize field
        TAZID      = 0
        HOT_ZONEID = 0
        
    ENDPHASE
    
    
    PHASE=LINKMERGE
        
        ;update LINKID
        _ANode = LTRIM(STR(li.1.A, 10, 0))
        _BNode = LTRIM(STR(li.1.B, 10, 0))
        LINKID = _ANode + '_' + _BNode
        
        ;initialize fields
        DISTANCE   = 0
        TAZID      = 0
        HOT_ZONEID = 0
        
        ;calculat Lanes and Functional Type fields for scenario
        LANES = li.1.@LNfield@
        FT    = li.1.@FTfield@
        
    ENDPHASE
    
ENDRUN



;-----------------------------------------------------------------------------------------
; export temp transit link dbf
;-----------------------------------------------------------------------------------------

RUN PGM=PUBLIC TRANSPORT  MSG='Network Processing 1: export transit link dbf'
FILEI NETI    = '@ParentDir@1_Inputs\3_Highway\@MasterPrefix@.net'
FILEI SYSTEMI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_System.PTS'
FILEI FAREI   = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\GENERAL_Fare.FAR'
FILEI FACTORI = '@ParentDir@1_Inputs\4_Transit\@Mlin@PT_Parameter\FAC_WalkAllModes.FAC'

;read in transit lines
READ FILE     = '@ParentDir@1_Inputs\4_Transit\@Mlin@Readlines.block'

FILEI NTLEGI[1] = '@ParentDir@1_Inputs\4_Transit\_General Hand-Coded Support Links\General_hand_coded_walk_links.NTL'


;export links with stops
FILEO LINKO  = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\TransitLinks_tmp0.dbf',
    ONOFFS=Y
    
    
    ;set parameters
    ;  note: TRANTIME is a reqired parameter to make PT work but is not used in this script
    ZONEMSG  = @ZoneMsgRate@
    TRANTIME = 25
    
    
    PHASE=DATAPREP
        
        ;this is a required step to make PT work but is not used in this script
        GENERATE READNTLEGI=1
        
    ENDPHASE
    
ENDRUN



;-----------------------------------------------------------------------------------------
; run python script
;-----------------------------------------------------------------------------------------

;create globabl variable input file for python ---------------------------------
RUN PGM=MATRIX MSG='Network Processing 1: (python) update Master Network and create Walk Buffer file'

FILEO PRINTO = '@ParentDir@@ScenarioDir@_Log\py_Variables - ip_GlobalVars.txt'
     
     
    ;set parameters
    ZONES = 1
    
    
    ;create control input file for this Python script
    PRINT PRINTO=1,
        LIST='# ------------------------------------------------------------------------------',
             '\n# Python input file variables and paths',
             '\n# ------------------------------------------------------------------------------',
             '\n',
             '\n# global parameters ------------------------------------------------------------',
             '\nUsedZones       = @Usedzones@',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nTAZ_shp         = r"@TAZ_DBF@"',
             '\n',
             '\nTollZoneID_shp  = r"@tollz_shp@"',
             '\nTollZoneField   = r"@TollZoneID@"',
             '\n',
             '\nMaster_Link_dbf = r"Master_Link_tmp0.dbf"',
             '\nMaster_Node_dbf = r"Master_Node_tmp0.dbf"',
             '\n',
             '\nTransit_dbf     = r"TransitLinks_tmp0.dbf"',
             '\n',
             '\nSegment_dbf     = r"WFv910_Segments.dbf"',    ;r"@Segments_DBF@"',
             '\n'
    
ENDRUN


;run python script -------------------------------------------------------------
;  note: one asterix minimizes the command window, two asterix executes the command window non-minimized
;  note: the 1>&2 echos the command window output from pyton to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\ip_UpdateNetwork_WalkBuffers.py" 1>&2


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0


;DOS command to delete '__pycache__' folder
;  note: '/s' removes folder & contents of folder includling any subfolders
;  note: '/q' denotes quite mode, meaning doesn't ask for confirmation to delete
*(rmdir /s /q "_Log\__pycache__")
*(rmdir /s /q "@ParentDir@2_ModelScripts\_Python\__pycache__")



;-----------------------------------------------------------------------------------------
; update Master Network
;-----------------------------------------------------------------------------------------

;create Master Network from updated Link & Node shapefiles
RUN PGM=NETWORK MSG='Network Processing 1: write out updated Master Network to scenario folder'
FILEI NETI[1]  = '@ParentDir@1_Inputs\3_Highway\@MasterPrefix@.net'

;note: read in master network twice for ONEWAY calculation
FILEI NETI[2]  = '@ParentDir@1_Inputs\3_Highway\@MasterPrefix@.net'

FILEI NODEI[3] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Updated_Master_Node.csv',
    VAR = N         ,
          X         ,
          Y         ,
          TAZID     
    
FILEI LINKI[3] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Updated_Master_Link.csv',
    VAR = A         ,
          B         ,
          DISTANCE  ,
          LINKID(C) ,
          TAZID     


FILEO NETO  = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\@MasterPrefix@.net'

FILEO NODEO = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Node.dbf'

FILEO LINKO = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Link.dbf'
    
    
    ;set parameters
    ZONES = @Usedzones@
    MERGE RECORD=F
    
    
    ;reverse A and B nodes in 2nd input network (used to set ONEWAY)
    PHASE=INPUT, FILEI=li.2
        
        _temp = A
        A     = B
        B     = _temp
        
    ENDPHASE
    
    
    PHASE=NODEMERGE
        
        ;update node fields
        TAZID = ni.3.TAZID
        
        ;calculate externals
        if (N=@externalzones@)  EXTERNAL = 1
        
        ;calculate SUBAREAID
        SUBAREAID = 1
        
    ENDPHASE
    
    
    PHASE=LINKMERGE
        
        ;update link fields
        DISTANCE = li.3.DISTANCE
        LINKID   = li.3.LINKID
        TAZID    = li.3.TAZID
        
        
        ;assign ONEWAY from master net & transposed Master Network
        ONEWAY = 2
        if (li.1.@LNfield@>0 & li.2.@LNfield@=0)  ONEWAY = 1
        
        
        ;calculate EXTERNAL
        if (A.EXTERNAL=1 | B.EXTERNAL=1)  EXTERNAL = 1
        
        
        ;calculate SUBAREAID
        SUBAREAID = 1
        
    ENDPHASE
    
ENDRUN



;=============================================================================================================
; Create Scenario Network
;=============================================================================================================

;-----------------------------------------------------------------------------------------
; initialize variables
;-----------------------------------------------------------------------------------------

;if not using speed and capacity override, supply a valid/dummy field name to prevent
;script from crashing
if (SpeedOverride<>1)     SpeedOverrideField    = 'A'
if (CapacityOverride<>1)  CapacityOverrideField = 'A'



;-----------------------------------------------------------------------------------------
; create temp Scenario Network
;-----------------------------------------------------------------------------------------

RUN PGM=NETWORK  MSG='Network Processing 1: delete links from Master Network not in Scenario Network'

FILEI NETI[1]  = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\@MasterPrefix@.net'

;note: HOT_ZONEID updated here so the it is available for the topology functions in the next step
FILEI NODEI[2] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Toll_Node.csv',
    VAR=N         ,
        X         ,
        Y         ,
        HOT_ZONEID
    
FILEI LINKI[2] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Toll_Link.csv',
    VAR=A         ,
        B         ,
        HOT_ZONEID

FILEI LINKI[3] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_Link_Direction.csv',
    VAR = A           ,
          B           ,
          DISTANCE    ,
          LINKID(C)   ,
          LANES       ,
          FT          ,
          DIRECTION(C),
          SEGID(C)    

FILEO NETO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_tmp0.net'
    
    
    ;set parameters
    ZONES = @Usedzones@
    MERGE RECORD=F
    
    
    PHASE=NODEMERGE
        
        ;assign HOT_ZONEID from 'Toll_Node.csv'
        HOT_ZONEID = ni.2.HOT_ZONEID
        
    ENDPHASE
    
    
    PHASE=LINKMERGE
        
        ;delete non-scenario network links if no lanes, FT, or X & Y coordinates
        if (li.1.@LNfield@<=0 | li.1.@FTfield@<=0 | A.X=0 | A.Y=0 | B.X=0 | B.Y=0)  DELETE
        
        ;assign HOT_ZONEID from 'Toll_Link.csv'
        HOT_ZONEID = li.2.HOT_ZONEID
        
        
        ;calculate ANGLE (round to 1 decimal)
        ;  note: angle is measured in degrees based on the start of the link
        ;        North=0 or 360, West=90, South=180, East=270
        ANGLE = ROUND(_L.S_Angle * 10) / 10
        
        
        ;update DIRECTION
        DIRECTION = li.3.DIRECTION
        
        
        ;calculate IB/OB
        IB_OB = 'OB'
        
        ;Ogden travel shed
        if (A.Y>@Og_Cor_Y@)
            if (DIRECTION='NB' & A.Y<@Og_Y@)  IB_OB = 'IB'
            if (DIRECTION='SB' & A.Y>@Og_Y@)  IB_OB = 'IB'
            if (DIRECTION='EB' & A.X<@Og_X@)  IB_OB = 'IB'
            if (DIRECTION='WB' & A.X>@Og_X@)  IB_OB = 'IB'
            
        ;Provo travel shed
        elseif (A.Y<@Pr_Cor_Y@)
            if (DIRECTION='NB' & A.Y<@Pr_Y@)  IB_OB = 'IB'
            if (DIRECTION='SB' & A.Y>@Pr_Y@)  IB_OB = 'IB'
            if (DIRECTION='EB' & A.X<@Pr_X@)  IB_OB = 'IB'
            if (DIRECTION='WB' & A.X>@Pr_X@)  IB_OB = 'IB'
            
        ;Salt Lake City travel shed
        else
            if (DIRECTION='NB' & A.Y<@SL_Y@)  IB_OB = 'IB'
            if (DIRECTION='SB' & A.Y>@SL_Y@)  IB_OB = 'IB'
            if (DIRECTION='EB' & A.X<@SL_X@)  IB_OB = 'IB'
            if (DIRECTION='WB' & A.X>@SL_X@)  IB_OB = 'IB'
            
        endif  ;travel shed
        
        
        ;calculate period of peak direction
        if (IB_OB='IB')  PkDirPrd = 1   ;AM
        if (IB_OB='OB')  PkDirPrd = 3   ;PM
        
    ENDPHASE
    
ENDRUN


RUN PGM=NETWORK  MSG='Network Processing 1: initializing Scenario Network'

FILEI NETI[1]  = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_tmp0.net'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\0_SpeedCap\@SpeedCapLookupFile@'
FILEI LOOKUPI[2] = '@ParentDir@1_Inputs\0_GlobalData\0_SpeedCap\CAV CapFac by MPR - 2 Lanes.csv'
FILEI LOOKUPI[3] = '@ParentDir@1_Inputs\0_GlobalData\0_SpeedCap\CAV CapFac by MPR - 3p Lanes.csv'
FILEI LOOKUPI[4] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'


;note: specifying fields sets the order of fields in output
FILEO NODEO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_node_tmp1.dbf',
    INCLUDE=N             ,
            X             ,
            Y             ,
            NODENAME      ,
            EXTERNAL      ,
            PNR           ,
            CRTFAREZN     ,
            
            TAZID         ,
            SUBAREAID     ,
            HOT_ZONEID    ,
            HOT_CHRGPT    ,
            RMPGPID       ,
            MANFWYID      ,
            
            URBANVAL      ,
            AREATYPE      ,
            ATYPENAME     ,
            ATYPEGRP      ,
            TERMTIME  @AddNodeFields@

FILEO LINKO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp1.dbf',
    INCLUDE=A             ,
            B             ,
            DISTANCE      ,
            STREET        ,
            ONEWAY        ,
            EXTERNAL      ,
            LANES         ,
            FT            ,
            SFAC(10.3)    ,
            CFAC(10.3)    ,
            TRK_RSTRCT    ,
            HOV_LYEAR     ,
            Op_Proj       ,
            Rel_Ln        ,
            SEL_LINK      ,
            
            LINKID        ,
            TAZID         ,
            SEGID(20)     ,
            SUBAREAID     ,
            HOT_ZONEID    ,
            HOT_CHRGPT    ,
            RMPGPID       ,
            MANFWYID      ,
            
            FTCLASS       ,
            URBANVAL      ,
            AREATYPE      ,
            ATYPENAME     ,
            ATYPEGRP      ,
            LANE_MILE     ,
            ANGLE         ,
            DIRECTION     ,
            IB_OB         ,
            PkDirPrd      ,
            
            FF_SPD        ,
            FF_TIME       ,
            FF_RampPen    ,
            CAP1HR1LN     ,
            RelCap1Hr     ,
            AM_CAP        ,
            MD_CAP        ,
            PM_CAP        ,
            EV_CAP        ,
            AdHOVCap1H  @AddLinkFields@
    
    
    ;set parameters ------------------------------------------------------------
    ZONES = @Usedzones@
    MERGE RECORD=F
    
    
    ;define lookup functions ---------------------------------------------------
    ;free flow speed lookup function
    LOOKUP LOOKUPI=1,
        NAME=lu_FFSpeed,
            LOOKUP[1]=01, RESULT=02,    ;SpdAT1
            LOOKUP[2]=01, RESULT=03,    ;SpdAT2
            LOOKUP[3]=01, RESULT=04,    ;SpdAT3
            LOOKUP[4]=01, RESULT=05,    ;SpdAT4
            LOOKUP[5]=01, RESULT=06,    ;SpdAT5
        INTERPOLATE=F,
        FAIL[1]=-99,
        FAIL[2]=-99,
        FAIL[3]=-99
    
    ;Capacity per hour per lane lookup function
    LOOKUP LOOKUPI=1,
        NAME=lu_Capacity,
            LOOKUP[1]=01, RESULT=07,    ;CAPLN1
            LOOKUP[2]=01, RESULT=08,    ;CAPLN2
            LOOKUP[3]=01, RESULT=09,    ;CAPLN3
            LOOKUP[4]=01, RESULT=10,    ;CAPLN4
            LOOKUP[5]=01, RESULT=11,    ;CAPLN5
            LOOKUP[6]=01, RESULT=12,    ;CAPLN6
            LOOKUP[7]=01, RESULT=13,    ;CAPLN7
        INTERPOLATE=F,
        FAIL[1]=-99,
        FAIL[2]=-99,
        FAIL[3]=-99
    
    
    ;CAV capacity multiplier by MPR for 2 & 3+ Lanes
    LOOKUP LOOKUPI=2,
        NAME=lu_CAVFac_2Ln,
            LOOKUP[01]=01, RESULT=02,    ;MPR_0%  
            LOOKUP[02]=01, RESULT=03,    ;MPR_5%  
            LOOKUP[03]=01, RESULT=04,    ;MPR_10% 
            LOOKUP[04]=01, RESULT=05,    ;MPR_15% 
            LOOKUP[05]=01, RESULT=06,    ;MPR_20% 
            LOOKUP[06]=01, RESULT=07,    ;MPR_25% 
            LOOKUP[07]=01, RESULT=08,    ;MPR_30% 
            LOOKUP[08]=01, RESULT=09,    ;MPR_35% 
            LOOKUP[09]=01, RESULT=10,    ;MPR_40% 
            LOOKUP[10]=01, RESULT=11,    ;MPR_45% 
            LOOKUP[11]=01, RESULT=12,    ;MPR_50% 
            LOOKUP[12]=01, RESULT=13,    ;MPR_55% 
            LOOKUP[13]=01, RESULT=14,    ;MPR_60% 
            LOOKUP[14]=01, RESULT=15,    ;MPR_65% 
            LOOKUP[15]=01, RESULT=16,    ;MPR_70% 
            LOOKUP[16]=01, RESULT=17,    ;MPR_75% 
            LOOKUP[17]=01, RESULT=18,    ;MPR_80% 
            LOOKUP[18]=01, RESULT=19,    ;MPR_85% 
            LOOKUP[19]=01, RESULT=20,    ;MPR_90% 
            LOOKUP[20]=01, RESULT=21,    ;MPR_95% 
            LOOKUP[21]=01, RESULT=22,    ;MPR_100%
        INTERPOLATE=T
    
    LOOKUP LOOKUPI=3,
        NAME=lu_CAVFac_3Ln,
            LOOKUP[01]=01, RESULT=02,    ;MPR_0%  
            LOOKUP[02]=01, RESULT=03,    ;MPR_5%  
            LOOKUP[03]=01, RESULT=04,    ;MPR_10% 
            LOOKUP[04]=01, RESULT=05,    ;MPR_15% 
            LOOKUP[05]=01, RESULT=06,    ;MPR_20% 
            LOOKUP[06]=01, RESULT=07,    ;MPR_25% 
            LOOKUP[07]=01, RESULT=08,    ;MPR_30% 
            LOOKUP[08]=01, RESULT=09,    ;MPR_35% 
            LOOKUP[09]=01, RESULT=10,    ;MPR_40% 
            LOOKUP[10]=01, RESULT=11,    ;MPR_45% 
            LOOKUP[11]=01, RESULT=12,    ;MPR_50% 
            LOOKUP[12]=01, RESULT=13,    ;MPR_55% 
            LOOKUP[13]=01, RESULT=14,    ;MPR_60% 
            LOOKUP[14]=01, RESULT=15,    ;MPR_65% 
            LOOKUP[15]=01, RESULT=16,    ;MPR_70% 
            LOOKUP[16]=01, RESULT=17,    ;MPR_75% 
            LOOKUP[17]=01, RESULT=18,    ;MPR_80% 
            LOOKUP[18]=01, RESULT=19,    ;MPR_85% 
            LOOKUP[19]=01, RESULT=20,    ;MPR_90% 
            LOOKUP[20]=01, RESULT=21,    ;MPR_95% 
            LOOKUP[21]=01, RESULT=22,    ;MPR_100%
        INTERPOLATE=T
    
    
    ;urbanization lookup functions
    LOOKUP LOOKUPI=4,
        NAME=lu_Urbanization,
            LOOKUP[1]=Z, RESULT=URBANVAL,
            LOOKUP[2]=Z, RESULT=ATYPE   ,
            LOOKUP[3]=Z, RESULT=TERMTIME,
        INTERPOLATE=F,
        FAIL[1]=-99,
        FAIL[2]=-99,
        FAIL[3]=-99
    
    
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ; process node data
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    PHASE=NODEMERGE
        
        ;delete non-scenario network nodes if no X & Y coordinates -------------
        ;  or if highway node is unconnected (keep unconnected TAZ centroids)
        _NumConNodes = _N.Connections
        
        if (X=0 | Y=0 | (_NumConNodes=0 & N>@Usedzones@))  DELETE
        
        
        ;assign variables from master net based on control center values -------
        PNR        = ni.1.@pnr_field@
        CRTFAREZN  = ni.1.@CRT_Fare_Zone@
        
        
        ;calculate HOT_CHRGPT --------------------------------------------------
        ; note: HOT charge points are identified as the connection point where
        ;       HOT access links connect with HOT lanes or where HOT lanes
        ;       transitions from one HOT zone to another
        
        ;get number of links connecting to node
        _NumCon = _N.Connections
        
        ;get the node level hot zoneid
        _N_HOTZNID = ni.1.HOT_ZONEID
        _hot_chrgpt = 0
        
        
        ;loop through each inbound link
        LOOP _IBLeg=1, _NumCon
            
            _IB_FT = _NI.@FTfield@[_IBLeg]
            
            
            ;calculate charge point where access link connects to HOT lane
            if (_IB_FT=39)
                
                LOOP _OBLeg=1, _NumCon
                    
                    _OB_FT = _NO.@FTfield@[_OBLeg]
                    
                    if (_OB_FT=38 & _hot_chrgpt<11)
                        
                        _hot_chrgpt = _hot_chrgpt + 10
                        HOT_CHRGPT  = _hot_chrgpt
                        
                    endif
                    
                ENDLOOP  ;_OBLeg=1, _OBLegs
                
            endif  ;(_IB_FT=39)
            
            
            ;calculate charge point where HOT link transitions between HOT zones
            if (_IB_FT=38)
                
                LOOP _OBLeg=1, _NumCon
                    
                    _OB_FT = _NO.@FTfield@[_OBLeg]
                    
                    _IB_HOTZNID = _NI.HOT_ZONEID[_IBLeg]
                    _OB_HOTZNID = _NO.HOT_ZONEID[_OBLeg]
                    
                    if (_OB_FT=38 & _OB_HOTZNID>0 & _IB_HOTZNID<>_OB_HOTZNID)
                        
                        _hot_chrgpt = _hot_chrgpt + 1
                        HOT_CHRGPT  = _hot_chrgpt
                        
                    endif
                    
                    ;if the centroid of the link falls within the current hotzn we need to tag the outbound link instead of the inbound link
                    if (_OB_FT=38 & _OB_HOTZNID>0 & _IB_HOTZNID<>_OB_HOTZNID & _N_HOTZNID<>_OB_HOTZNID)
                        
                        _hot_chrgpt = _hot_chrgpt + 1
                        HOT_CHRGPT  = _hot_chrgpt
                        
                    endif
                    
                ENDLOOP  ;_OBLeg=1, _OBLegs
                
            endif  ;(_IB_FT=38)
            
        ENDLOOP  ;_IBLeg=1, _IBLegs
        
        
        ;calculate ramp group & managed freeway IDs ----------------------------
        ; note: ramp groups are identified as the connection point where a ramp
        ;       connects with a general purpose lane
        
        ;get number of links connecting to node
        _NumCon = _N.Connections
        
        
        ;loop through each inbound link
        LOOP _IBLeg=1, _NumCon
            
            _IB_FT = _NI.@FTfield@[_IBLeg]
            
            
            ;calculate ID where ramp connects to general purpose lane
            if (_IB_FT=@FT_Ramp@, @MF_FT_Ramp@)
                
                LOOP _OBLeg=1, _NumCon
                    
                    _OB_FT = _NO.@FTfield@[_OBLeg]
                    
                    if (_OB_FT=@FT_GP@, @MF_FT_GP@, @FT_Sys@)
                        
                        _RampGrp = _RampGrp + 1
                        RMPGPID  = _RampGrp
                        
                        ;tag if managed freeway
                        if (_IB_FT=@MF_FT_Ramp@ & _OB_FT=@MF_FT_GP@)  MANFWYID = 1
                        
                    endif  ;(_OB_FT=@FT_GP@, @MF_FT_GP@)
                    
                ENDLOOP  ;_OBLeg=1, _OBLegs
                
            endif  ;(_IB_FT=@FT_Ramp@, @MF_FT_Ramp@)
            
            
            ;calculate ID where system-to-system ramp connects to general purpose lane
            if (_IB_FT=@FT_Sys@, @MF_FT_Sys@)
                
                LOOP _OBLeg=1, _NumCon
                    
                    _OB_FT = _NO.@FTfield@[_OBLeg]
                    
                    if (_OB_FT=@FT_GP@, @MF_FT_GP@)
                        
                        _SysRampGrp = _SysRampGrp + 1
                        RMPGPID     = 500 + _SysRampGrp
                        
                        ;tag if managed freeway
                        if (_IB_FT=@FT_Sys@ & _OB_FT=@MF_FT_GP@)  MANFWYID = 2
                        
                    endif  ;(_OB_FT=@FT_GP@, @MF_FT_GP@)
                    
                ENDLOOP  ;_OBLeg=1, _OBLegs
                
            endif  ;(_IB_FT=@FT_Sys@, @MF_FT_Sys@)
            
        ENDLOOP  ;_IBLeg=1, _IBLegs
        
        
        ;assign variables from urbanization lookup file ------------------------
        ;  & calculate other area type variables
        if (ni.1.TAZID=1-@UsedZones@)  URBANVAL = lu_Urbanization(1, TAZID)
        if (ni.1.TAZID=1-@UsedZones@)  AREATYPE = lu_Urbanization(2, TAZID)
        if (ni.1.N    =1-@UsedZones@)  TERMTIME = lu_Urbanization(3, TAZID)
        
        ;assign urbanization variables for external zones
        if (ni.1.N=@externalzones@)  URBANVAL = 0
        if (ni.1.N=@externalzones@)  AREATYPE = 1
        if (ni.1.N=@externalzones@)  TERMTIME = 0
        
        
        ;calculate ATYPENAME
        ATYPENAME = 'na'
        
        if (AREATYPE=1)  ATYPENAME = 'Rural'
        if (AREATYPE=2)  ATYPENAME = 'Transition'
        if (AREATYPE=3)  ATYPENAME = 'Suburban'
        if (AREATYPE=4)  ATYPENAME = 'Urban'
        if (AREATYPE=5)  ATYPENAME = 'CBD-like'
        
        
        ;calculate ATYPEGRP
        ATYPEGRP = 'na'
        
        if (AREATYPE=1-2)  ATYPEGRP = 'Rural'
        if (AREATYPE=3-5)  ATYPEGRP = 'Urban'
        
    ENDPHASE
    
    
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ; process link data
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    PHASE=LINKMERGE
        
        ;assign variables from master net based on control center values -------
        LANES      = li.1.@LNfield@
        FT         = li.1.@FTfield@
        SFAC       = li.1.@SpdFactor@
        CFAC       = li.1.@CapFactor@
        TRK_RSTRCT = li.1.@TruckRestrict@
        HOV_LYEAR  = li.1.@HOVmarker@
        Op_Proj    = li.1.@OpProj_Field@
        Rel_LN     = li.1.@Rel_LN@
        SEL_LINK   = li.1.@SelLinkGrp_Field@

        ;assign SEGID field
        SEGID = li.1.@SEGIDField@
        if (li.1.@SEGIDExField@>' ')  SEGID = li.1.@SEGIDExField@
        
        
        ;calculate HOT_CHRGPT --------------------------------------------------
        if (FT=39 & B.HOT_CHRGPT=10-12)  HOT_CHRGPT = 1
        if (FT=38 & B.HOT_CHRGPT=1, 11)  HOT_CHRGPT = 1
        if (FT=38 & A.HOT_CHRGPT=2, 12)  HOT_CHRGPT = 1
        
        
        ;calculate RMPGPID & MANFWYID variables --------------------------------
        ;calc RMPGPID for on ramps & system-system ramps
        if (B.RMPGPID>0 & FT=@FT_Ramp@, @FT_Sys@, @MF_FT_Ramp@, @MF_FT_Sys@)  RMPGPID = B.RMPGPID
        
        ;calc RMPGPID for general purpose lanes connected to on ramps & system-system ramps
        if (A.RMPGPID>0 & FT=@FT_GP@, @MF_FT_GP@)  RMPGPID = 1000 + A.RMPGPID
        
        ;calc MANFWYID for 'managed freeway' on ramps & system-system ramps
        if (B.RMPGPID>0 & FT=@MF_FT_Ramp@, @MF_FT_Sys@)  MANFWYID = B.MANFWYID
        
        ;calc MANFWYID for 'managed freeway' general purpose lanes connected to on ramps & system-system ramps
        if (A.RMPGPID>0 & FT=@MF_FT_GP@)  MANFWYID = 10
        
        
        ;assign variables from urbanization lookup file ------------------------
        ;  & calculate other area type variables
        if (li.1.TAZID=1-@UsedZones@)  URBANVAL = lu_Urbanization(1, TAZID)
        if (li.1.TAZID=1-@UsedZones@)  AREATYPE = lu_Urbanization(2, TAZID)
        
        ;account for external zones
        if (li.1.A=@externalzones@ | li.1.B=@externalzones@)  URBANVAL = 0
        if (li.1.A=@externalzones@ | li.1.B=@externalzones@)  AREATYPE = 1
        
        
        ;calculate ATYPENAME
        ATYPENAME = 'na'
        
        if (AREATYPE=1)  ATYPENAME = 'Rural'
        if (AREATYPE=2)  ATYPENAME = 'Transition'
        if (AREATYPE=3)  ATYPENAME = 'Suburban'
        if (AREATYPE=4)  ATYPENAME = 'Urban'
        if (AREATYPE=5)  ATYPENAME = 'CBD-like'
        
        
        ;calculate ATYPEGRP
        ATYPEGRP = 'na'
        
        if (AREATYPE=1-2)  ATYPEGRP = 'Rural'
        if (AREATYPE=3-5)  ATYPEGRP = 'Urban'
        
        
        ;calculate FTCLASS -----------------------------------------------------
        FTCLASS = 'Other'
        
        if (FT=1)      FTCLASS = 'Centroid Connector'
        
        if (FT=2)      FTCLASS = 'Principal Arterial'
        if (FT=3)      FTCLASS = 'Minor Arterial'
        if (FT=4-5)    FTCLASS = 'Collector'
        if (FT=6-7)    FTCLASS = 'Local'
        
        if (FT=12-15)  FTCLASS = 'Expressway'
        
        if (FT=20-26)  FTCLASS = 'Managed Motorway'
        if (FT=28-29)  FTCLASS = 'Ramp'
        
        if (FT=30-40)  FTCLASS = 'Freeway'
        if (FT=41-42)  FTCLASS = 'Ramp'
        
        
        ;calculate LANE_MILE (round to 2 decimals) -----------------------------
        LANE_MILE = ROUND(LANES * DISTANCE * 100) / 100
        
        
        ;calculate free flow speed ---------------------------------------------
        ;assign free flow speed from lookup table
        FF_SPD = lu_FFSpeed(AREATYPE, FT)
        
        
        ;adjust for speed factor
        if (SFAC>0)  FF_SPD = FF_SPD * SFAC
        
        
        ;adjust for 1-way arterials
        if (FT=2-7 & ONEWAY=1)  FF_SPD = FF_SPD * @OneWayBump_Spd@
            
        
        ;adjust for arterial grade-separated managed lane
        ;  note: assume speed is 20% higher than regular arterial speed
        if (FT=2-19 & Rel_LN=21-29)  FF_SPD = FF_SPD * 1.20
        
        ;adjust for arterial grade-separated managed lane
        ;  note: assume speed is 20% higher than regular arterial speed
        if (FT=1-29 & Rel_LN=20-29)  FF_SPD = FF_SPD * 1.20
        
        
        ;override calcualted value
        ;  note: if speed 'SpeedOverride' toggle is on, free flow speed is 
        ;        overriden on links where value in 'SpeedOverrideField'>0
        if (@SpeedOverride@=1 & @SpeedOverrideField@>0)   FF_SPD = li.1.@SpeedOverrideField@
        
        
        ;round to  decimal
        FF_SPD = ROUND(FF_SPD * 10) / 10
        

        ;calculate free flow time ----------------------------------------------
        FF_TIME = -99
        if (FF_SPD>0)  FF_TIME = DISTANCE / FF_SPD * 60
        
        ;round to 4 decimals
        FF_TIME = ROUND(FF_TIME * 10000) / 10000
        
        
        ;assign capacity -------------------------------------------------------
        ;assign capacity from lookup table 
        _lanecap = LANES
        if (LANES>7)  _lanecap = 7
        
        CAP1HR1LN = lu_Capacity(_lanecap, FT)
        
        
        ;adjust arterial capacity by area type
        if (FT=2-7)
            
            if (AREATYPE=1)  CAP1HR1LN = CAP1HR1LN * 1.10
            if (AREATYPE=2)  CAP1HR1LN = CAP1HR1LN * 1.05
            if (AREATYPE=3)  CAP1HR1LN = CAP1HR1LN * 1.00
            if (AREATYPE=4)  CAP1HR1LN = CAP1HR1LN * 0.95
            if (AREATYPE=5)  CAP1HR1LN = CAP1HR1LN * 0.90
            
        endif
        
        
        ;adjust for capacity factor
        if (CFAC>0)  CAP1HR1LN = CAP1HR1LN * CFAC
        
        
        ;adjust for 1-way arterials
        if (FT=2-6 & ONEWAY=1)  CAP1HR1LN = CAP1HR1LN * @OneWayBump_Cap@
        
        
        ;adjust for operational projects
        ;  note: assume capacity is 10% higher than regular arterial capacity
        if (@Run_Op_Proj@=1 & Op_Proj>0)  CAP1HR1LN = CAP1HR1LN * 1.10
        
        
        ;use override
        ;  note: if capacity 'CapacityOverride' toggle is on, cap1hr1ln is 
        ;        overriden on links where value in 'CapacityOverrideField'>0
        if (@CapacityOverride@=1 & @CapacityOverrideField@>0)   CAP1HR1LN = li.1.@CapacityOverrideField@
        
        
        ;calculate CAV capacity adjustment
        ;  adjust freeway general purpose lane (including Managed Motorways) capacity based on
        ;  connected-autonomous vehicle market penetration rate
        if (FT=22-26,32-40 & @CAV_MPR@>0)
            
            ;calculate column index for CAVFac lookup table & column interpolation factor
            _CAV_Idx = @CAV_MPR@ / 5
            
            if (_CAV_Idx<0 )  _CAV_Idx = 0
            if (_CAV_Idx>20)  _CAV_Idx = 20
            
            _CAV_Idx_Lower = INT(_CAV_Idx)
            _CAV_Idx_Upper = _CAV_Idx_Lower + 1
            
            if (_CAV_Idx_Upper>20)  _CAV_Idx_Upper = 20
            
            ;lookup the capacity factor for columns above & below input value
            ;  note: shift column indices by 1 to line up with lookup tables
            if (LANES=2)
                
                _CapFac_CAV_Lo = lu_CAVFac_2Ln(_CAV_Idx_Lower+1, Cap1hr1ln)
                _CapFac_CAV_Hi = lu_CAVFac_2Ln(_CAV_Idx_Upper+1, Cap1hr1ln)
                
            elseif (LANES>=3)
                
                _CapFac_CAV_Lo = lu_CAVFac_3Ln(_CAV_Idx_Lower+1, Cap1hr1ln)
                _CapFac_CAV_Hi = lu_CAVFac_3Ln(_CAV_Idx_Upper+1, Cap1hr1ln)
                
            endif  ;LANES
            
            ;calculate CAV capacity factory by interpolating between upper & lower bounds
            _CapFac_CAV = _CapFac_CAV_Lo  +  (_CapFac_CAV_Hi - _CapFac_CAV_Lo) * (_CAV_Idx - _CAV_Idx_Lower)
            
            CAP1HR1LN = CAP1HR1LN * _CapFac_CAV
            
        endif ;FT=22-26,32-40
        
        
        ;use override
        ;  note: if capacity 'CapacityOverride' toggle is on, cap1hr1ln is 
        ;        overriden on links where value in 'CapacityOverrideField'>0
        if (@CapacityOverride@=1 & @CapacityOverrideField@>0)   CAP1HR1LN = li.1.@CapacityOverrideField@
        
        
        ;round to 0 decimals
        CAP1HR1LN = ROUND(CAP1HR1LN)
        
        
        ;calculate period capacity ---------------------------------------------
        AM_CAP = CAP1HR1LN * LANES * 3 
        MD_CAP = CAP1HR1LN * LANES * 6 
        PM_CAP = CAP1HR1LN * LANES * 3 
        EV_CAP = CAP1HR1LN * LANES * 12
        
        
        ;calculate reliability lane capacity -----------------------------------
        ;  note: arterial only
        if (FT=2-19 & Rel_LN>0)
            
            ;calculate number of reliability lanes
            _Rel_NumLanes  = Rel_LN - INT(Rel_LN/10) * 10
            
            ;arterial managed (HOT) lanes
            ;  note: assume managed lane maintiains LOS C, whcih is roughly 65% of LOS E capacity
            ;  note: Rel_LN=1-9 does NOT add to GP capacity
            if (Rel_LN=1-9)    RelCap1Hr = CAP1HR1LN * _Rel_NumLanes * 0.65
            
            ;arterial reversible GP lanes
            ;  note: assume full lane capacity, added to peak directions only
            if (Rel_LN=11-19)  RelCap1Hr = CAP1HR1LN * _Rel_NumLanes
            
            ;arterial grade-separated GP lanes
            ;  note: assume capacity is 20% higher than regular arterial capacity, added to all time periods
            if (Rel_LN=21-29)  RelCap1Hr = CAP1HR1LN * _Rel_NumLanes * 0.20
            
            ;round to 0 decimals
            RelCap1Hr = ROUND(RelCap1Hr)
            
            
            ;reliability lanes
            if (Rel_LN=1-9)
                
                ;for managed lane on arterial, add capacity to AdHOVCap1H (see next section for further calculations)
                AdHOVCap1H = RelCap1Hr
                
            ;reversible lanes
            elseif (Rel_LN=11-19)
                
                ;set factor if reversable lane adds new lanes or replaces off-peak lanes
                _ReplaceLane = @Rel_LN_Toggle@
                _ReplaceLane_Fac = 0
                if (_ReplaceLane=1)  _ReplaceLane_Fac = -1
                
                ;add capacity for reversible lanes to peak direction & possibly remove capacity from off-peak direction
                ;  note: see path builder in assignment to see how reversible managed lanes are handled on freeways
                if (li.1.IB_OB='IB')
                    
                    ;peak direction inbound=AM & EV
                    AM_CAP = AM_CAP + RelCap1Hr * 3 
                    MD_CAP = MD_CAP + RelCap1Hr * 6  * _ReplaceLane_Fac
                    PM_CAP = PM_CAP + RelCap1Hr * 3  * _ReplaceLane_Fac
                    EV_CAP = EV_CAP + RelCap1Hr * 12
                    
                else
                    
                    ;peak direction outbound=MD & PM
                    AM_CAP = AM_CAP + RelCap1Hr * 3  * _ReplaceLane_Fac
                    MD_CAP = MD_CAP + RelCap1Hr * 6 
                    PM_CAP = PM_CAP + RelCap1Hr * 3 
                    EV_CAP = EV_CAP + RelCap1Hr * 12 * _ReplaceLane_Fac
                    
                endif  ;(li.1.IB_OB='IB')
                
                ;ensure capacity not negative
                if (AM_CAP<0)  AM_CAP = 0
                if (MD_CAP<0)  MD_CAP = 0
                if (PM_CAP<0)  PM_CAP = 0
                if (EV_CAP<0)  EV_CAP = 0
                
            ;grade-separated arterials
            elseif (Rel_LN=21-29)
                
                ;add capacity for grade separated arterials to all time periods
                AM_CAP = AM_CAP + RelCap1Hr * 3 
                MD_CAP = MD_CAP + RelCap1Hr * 6 
                PM_CAP = PM_CAP + RelCap1Hr * 3 
                EV_CAP = EV_CAP + RelCap1Hr * 12
                
            endif  ;(Rel_LN=11-19), (Rel_LN=21-29)
            
        endif  ;(FT=2-19 & Rel_LN=>0)
        
        
        ;calculate AdHOVCap1H --------------------------------------------------
        ;  note: in distribution trips are excluded from using HOV/HOT links, so this
        ;        field is used to account for HOV/HOT capacity on general purpose links
        ;        (field is coded on GP links where adjacent HOV/HOT are present)
        
        ;freeway general purpose lanes (including Managed Motorways)
        if (FT=22-26, 32-36)
            
            ;calculate number of managed lanes & year managed lane comes online from HOV_LYEAR value
            _HOVnum  = INT(HOV_LYEAR/10000)
            _HOVyear = HOV_LYEAR - _HOVnum * 10000
            
            ;use HOT functional type (FT=38) to lookup capacity for managed lane
            if (_HOVnum>0 & @networkyear@>=_HOVyear)  AdHOVCap1H = lu_Capacity(_HOVnum, 38) * _HOVnum
            
        endif ;FT=22-26,32-36
        
        ;round to 0 decimals
        AdHOVCap1H = ROUND(AdHOVCap1H)
        
        
        ;set initial ramp penalty ----------------------------------------------
        FF_RampPen = 0
        if (RMPGPID=1-499 & !(FT=@FT_Sys@, @MF_FT_Sys@))  FF_RampPen = @MinRampPen@
        
        
        ;check for dead links (report will show up at end of prn) --------------
        REPORT DEADLINKS= TRUE,
            UNCONNECTED = TRUE,
            DUPLICATES  = TRUE
        
    ENDPHASE
    
    
    PHASE=SUMMARY
        
        ;print net processing header in the LOG file
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, LIST=
        ';*********************************************************************\n',
        '\n',
        'Network Processing\n',
        '\n',
        '  Scenario network file created:\n',
        '    0_InputProcessing\@RID@.net\n'
        
        
        ;output node and link tallies to the .VAR file
        LOG PREFIX=ScenarioNet,
            VAR=_RampGrp   ,
                _SysRampGrp
        
    ENDPHASE
    
ENDRUN



;-----------------------------------------------------------------------------------------
; prepare data to import TAZ shapefile into Scenario Network
;-----------------------------------------------------------------------------------------
;  note: TAZ shapefile data is processed in separte step to preserve text field widths

;prepare node data -------------------------------------------------------------
RUN PGM=MATRIX  MSG='Network Processing 1: prepare data from TAZ shapefile - nodes'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_node_tmp1.dbf',
    AUTOARRAY=ALLFIELDS

FILEI DBI[2] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
    AUTOARRAY=ALLFIELDS,
    SORT=TAZID

FILEO RECO[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_node_tmp2.dbf',
    FORM=8.0,
    FIELDS=N              ,
           CO_TAZID       ,
           CO_FIPS        ,
           CO_NAME(20)    ,
           CITY_FIPS      ,
           CITY_UGRC      ,
           CITY_NAME(40)  ,
           DISTLRG        ,
           DLRG_NAME(60)  ,
           DISTMED        ,
           DMED_NAME(60)  ,
           DISTSML        ,
           DSML_NAME(60)  ,
           REMM           ,
           CBD            ,
           
           DEVACRES(18.10),
           WALK100        ,
           ECOEDPASS      ,
           FREEFARE       
    
    
    ;set parameters
    ZONES = 1
    
    
    LOOP lp_Rec=1, dbi.1.NUMRECORDS
        
        ;print status to task monitor window
        PrintProgress = INT(lp_Rec / dbi.1.NUMRECORDS * 100)
        PrintProgInc = 1
        
        if (lp_Rec=1)
            PRINT PRINTO=0, LIST='Processing Records - Nodes: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing Records - Nodes: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        ;get TAZID from node file
        TAZID = dba.1.TAZID[lp_Rec]
        
        
        ;print data for valid TAZID
        if (TAZID=1-@UsedZones@)
            
            ;get N from node file
            RO.N  = dba.1.N[lp_Rec]
            
            ;get data from TAZ shapefile based node record TAZID
            RO.CO_TAZID  = dba.2.CO_TAZID[TAZID]
            RO.CO_FIPS   = dba.2.CO_FIPS[TAZID]
            RO.CO_NAME   = dba.2.CO_NAME[TAZID]
            RO.CITY_FIPS = dba.2.CITY_FIPS[TAZID]
            RO.CITY_UGRC = dba.2.CITY_UGRC[TAZID]
            RO.CITY_NAME = dba.2.CITY_NAME[TAZID]
            RO.DISTLRG   = dba.2.DISTLRG[TAZID]
            RO.DLRG_NAME = dba.2.DLRG_NAME[TAZID]
            RO.DISTMED   = dba.2.DISTMED[TAZID]
            RO.DMED_NAME = dba.2.DMED_NAME[TAZID]
            RO.DISTSML   = dba.2.DISTSML[TAZID]
            RO.DSML_NAME = dba.2.DSML_NAME[TAZID]
            RO.REMM      = dba.2.REMM[TAZID]
            RO.CBD       = dba.2.CBD[TAZID]
            
            ;store data on TAZ centroids only for these variables
            RO.DEVACRES  = dba.2.DEVACRES[TAZID]
            RO.WALK100   = dba.2.WALK100[TAZID]
            RO.ECOEDPASS = dba.2.ECOEDPASS[TAZID]
            RO.FREEFARE  = dba.2.FREEFARE[TAZID]
            
            if (RO.N>@UsedZones@)  RO.DEVACRES  = 0
            if (RO.N>@UsedZones@)  RO.WALK100   = 0
            if (RO.N>@UsedZones@)  RO.ECOEDPASS = 0
            if (RO.N>@UsedZones@)  RO.FREEFARE  = 0
            
            
            ;write the record to the output file
            WRITE RECO=1
            
        endif  ;TAZID=1-@UsedZones@
        
    ENDLOOP  ;lp_NodeRec=1, dbi.1.NUMRECORDS
    
ENDRUN


;prepare link data -------------------------------------------------------------
RUN PGM=MATRIX  MSG='Network Processing 1: prepare data from TAZ shapefile - links'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp1.dbf',
    AUTOARRAY=ALLFIELDS

FILEI DBI[2] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
    AUTOARRAY=ALLFIELDS,
    SORT=TAZID

FILEO RECO[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp2.dbf',
    FORM=8.0,
    FIELDS=A              ,
           B              ,
           CO_TAZID       ,
           CO_FIPS        ,
           CO_NAME(20)    ,
           CITY_FIPS      ,
           CITY_UGRC      ,
           CITY_NAME(40)  ,
           DISTLRG        ,
           DLRG_NAME(60)  ,
           DISTMED        ,
           DMED_NAME(60)  ,
           DISTSML        ,
           DSML_NAME(60)  ,
           REMM           ,
           CBD            
    
    
    ;set parameters
    ZONES = 1
    
    
    LOOP lp_Rec=1, dbi.1.NUMRECORDS
        
        ;print status to task monitor window
        PrintProgress = INT(lp_Rec / dbi.1.NUMRECORDS * 100)
        PrintProgInc = 1
        
        if (lp_Rec=1)
            PRINT PRINTO=0, LIST='Processing Records - Links: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing Records - Links: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif
        
        
        ;get TAZID from link file
        TAZID = dba.1.TAZID[lp_Rec]
        
        
        ;print data for valid TAZID
        if (TAZID=1-@UsedZones@)
            
            ;get A & B from link file
            RO.A  = dba.1.A[lp_Rec]
            RO.B  = dba.1.B[lp_Rec]
            
            ;get data from TAZ shapefile based link record TAZID
            RO.CO_TAZID  = dba.2.CO_TAZID[TAZID]
            RO.CO_FIPS   = dba.2.CO_FIPS[TAZID]
            RO.CO_NAME   = dba.2.CO_NAME[TAZID]
            RO.CITY_FIPS = dba.2.CITY_FIPS[TAZID]
            RO.CITY_UGRC = dba.2.CITY_UGRC[TAZID]
            RO.CITY_NAME = dba.2.CITY_NAME[TAZID]
            RO.DISTLRG   = dba.2.DISTLRG[TAZID]
            RO.DLRG_NAME = dba.2.DLRG_NAME[TAZID]
            RO.DISTMED   = dba.2.DISTMED[TAZID]
            RO.DMED_NAME = dba.2.DMED_NAME[TAZID]
            RO.DISTSML   = dba.2.DISTSML[TAZID]
            RO.DSML_NAME = dba.2.DSML_NAME[TAZID]
            RO.REMM      = dba.2.REMM[TAZID]
            RO.CBD       = dba.2.CBD[TAZID]
            
            
            ;write the record to the output file
            WRITE RECO=1
            
        endif  ;TAZID=1-@UsedZones@
        
    ENDLOOP  ;lp_NodeRec=1, dbi.1.NUMRECORDS
    
ENDRUN



;-----------------------------------------------------------------------------------------
; create scenario network
;-----------------------------------------------------------------------------------------

;create scenario network from dbf files and load SE data onto centroids
RUN PGM=NETWORK  MSG='Network Processing 1: write out Scenario Network'
;initialized scenario net
FILEI NODEI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_node_tmp1.dbf'
FILEI LINKI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp1.dbf'

;TAZ shapefile data
FILEI NODEI[2] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_node_tmp2.dbf'
FILEI LINKI[2] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp2.dbf'

;SE data
FILEI NODEI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf',
    RENAME=Z-N,
    EXCLUDE=CO_NAME  ,
            CITY_NAME,
            DLRG_NAME,
            DMED_NAME,
            DSML_NAME


FILEO NETO  = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'

FILEO LINKO = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@ - Link.dbf'

FILEO NODEO = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@ - Node.dbf'

    
    ;set parameters
    ZONES = @Usedzones@
    MERGE RECORD=F
    
    
    PHASE=NODEMERGE
        
        ;assign variables from TAZ shapefile input network
        CO_TAZID  = ni.2.CO_TAZID
        CO_FIPS   = ni.2.CO_FIPS
        CO_NAME   = ni.2.CO_NAME
        CITY_FIPS = ni.2.CITY_FIPS
        CITY_UGRC = ni.2.CITY_UGRC
        CITY_NAME = ni.2.CITY_NAME
        DISTLRG   = ni.2.DISTLRG
        DLRG_NAME = ni.2.DLRG_NAME
        DISTMED   = ni.2.DISTMED
        DMED_NAME = ni.2.DMED_NAME
        DISTSML   = ni.2.DISTSML
        DSML_NAME = ni.2.DSML_NAME
        REMM      = ni.2.REMM
        CBD       = ni.2.CBD
        
        DEVACRES  = ni.2.DEVACRES
        WALK100   = ni.2.WALK100
        ECOEDPASS = ni.2.ECOEDPASS
        FREEFARE  = ni.2.FREEFARE
        
        
        ;assign variables from TAZ shapefile input network
        if (ni.1.N=1-@UsedZones@)
            
            TOTHH      = ni.3.TOTHH
            HHPOP      = ni.3.HHPOP
            HHSIZE     = ni.3.HHSIZE
            TOTEMP     = ni.3.TOTEMP
            RETEMP     = ni.3.RETEMP
            INDEMP     = ni.3.INDEMP
            OTHEMP     = ni.3.OTHEMP
            ALLEMP     = ni.3.ALLEMP
            RETL       = ni.3.RETL
            FOOD       = ni.3.FOOD
            MANU       = ni.3.MANU
            WSLE       = ni.3.WSLE
            OFFI       = ni.3.OFFI
            GVED       = ni.3.GVED
            HLTH       = ni.3.HLTH
            OTHR       = ni.3.OTHR
            AGRI       = ni.3.AGRI
            MING       = ni.3.MING
            CONS       = ni.3.CONS
            HBJ        = ni.3.HBJ
            AVGINCOME  = ni.3.AVGINCOME
            ENROL_ELEM = ni.3.ENROL_ELEM
            ENROL_MIDL = ni.3.ENROL_MIDL
            ENROL_HIGH = ni.3.ENROL_HIGH
            
        endif  ;ni.1.N=1-@UsedZones@
        
    ENDPHASE
    
    
    PHASE=LINKMERGE
        
        ;assign variables from TAZ shapefile input network
        CO_TAZID  = li.2.CO_TAZID
        CO_FIPS   = li.2.CO_FIPS
        CO_NAME   = li.2.CO_NAME
        CITY_FIPS = li.2.CITY_FIPS
        CITY_UGRC = li.2.CITY_UGRC
        CITY_NAME = li.2.CITY_NAME
        DISTLRG   = li.2.DISTLRG
        DLRG_NAME = li.2.DLRG_NAME
        DISTMED   = li.2.DISTMED
        DMED_NAME = li.2.DMED_NAME
        DISTSML   = li.2.DISTSML
        DSML_NAME = li.2.DSML_NAME
        REMM      = li.2.REMM
        CBD       = li.2.CBD
        
    ENDPHASE
    
ENDRUN



;=============================================================================================================
; Create Ramp Connection/Downstream Freway Tag File
;=============================================================================================================

;-----------------------------------------------------------------------------------------
; create downstream freeway tags
;-----------------------------------------------------------------------------------------

RUN PGM=NETWORK  MSG='Network Processing 1: export freeway network'
FILEI NETI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'

FILEO LINKO = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp3_FwyOnly.dbf'

    PHASE=LINKMERGE
        
        if (!(li.1.FT=20-42))  DELETE
        
    ENDPHASE

ENDRUN


RUN PGM=MATRIX  MSG='Network Processing 1: determine downstream freeway tags'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\Scenario_link_tmp3_FwyOnly.dbf',
    AUTOARRAY=ALLFIELDS

FILEO RECO[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\RampGP_Connection_tmp.dbf',
    FORM=10.0,
    FIELDS=B_Node,
           RampID, 
           GPID_1, 
           GPID_2, 
           GPID_3, 
           GPID_4, 
           GPID_5, 
           GPID_6, 
           GPID_7, 
           GPID_8, 
           GPID_9, 
           GPID_10
    
    
    ;set MATRIX parameters
    ZONES = 1
    
    
    ARRAY GenPurpID = 999
    
    LOOP CurRec=1, dbi.1.NUMRECORDS
        
        ;print status to task monitor window -----------------------------------
        PrintProgress = INT(CurRec / dbi.1.NUMRECORDS * 100)
        PrintProgInc = 1
        
        if (CurRec=1)
            
            PRINT PRINTO=0, LIST='Processing Records: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
            
        elseif (PrintProgress=CheckProgress)
            
            PRINT PRINTO=0, LIST='Processing Records: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
            
        endif  ;(CurRec=1)
        
        
        ;find downstream general purpose RMPGPIDs ------------------------------
        ;start search at tagged ramp
        RampID = dba.1.RMPGPID[CurRec]
        
        if (RampID=1-999)
            
            ;reset variables for next tagged ramp to be processed
            counter = 0
            
            LOOP iter=1, 10
                GenPurpID[iter] = 0
            ENDLOOP  ;iter=1, 10
            
            keep_checking = 1
            
            
            ;calculate node where current record connects to next record
            ;  note: store B node of ramp for checking
            B_Node = dba.1.B[CurRec]
            connect_node = B_Node
            
            ;beginning of do while loop (return to this spot if convergence criterial not met)
            :CheckLinks
                    
                ;look for next general purpose link in path
                LOOP NextRec=1, dbi.1.NUMRECORDS
                    
                    ;calculate attributes to check if next link record in path
                    next_A       = dba.1.A[NextRec]
                    next_B       = dba.1.B[NextRec]
                    next_FT      = dba.1.FT[NextRec]
                    next_RMPGPID = dba.1.RMPGPID[NextRec]
                    
                    ;identify & classify next downstream link
                    if (next_A=connect_node & next_FT=@FT_GP@, @MF_FT_GP@)
                        
                        ;add RMPGPID to array
                        if (next_RMPGPID>0)
                            
                            counter = counter + 1
                            GenPurpID[counter] = next_RMPGPID
                            
                            ;stop checking for downstream links if found 10 RMPGPIDs
                            keep_checking = 0
                            
                        endif  ;(next_RMPGPID>0)
                        
                        ;change connect_node to next node in chain & stop checking for next link
                        connect_node = next_B
                        BREAK
                        
                    endif  ;(next_A=current_B & next_FT=@FT_GP@, @MF_FT_GP@)
                    
                ENDLOOP  ;NextRec=1, dbi.1.NUMRECORDS
                
                ;check if no more links in path
                if (NextRec>=dbi.1.NUMRECORDS)
                    EndPath = 1
                else
                    EndPath = 0
                endif
                
                ;check convergence criteria
                if (EndPath=0)  GOTO :CheckLinks
                
            
            ;write out ramp record with (up to) 10 downstream general purpose RMPGPIDs
            RO.B_Node  = B_Node
            RO.RampID  = RampID
            RO.GPID_1  = GenPurpID[01]
            RO.GPID_2  = GenPurpID[02]
            RO.GPID_3  = GenPurpID[03]
            RO.GPID_4  = GenPurpID[04]
            RO.GPID_5  = GenPurpID[05]
            RO.GPID_6  = GenPurpID[06]
            RO.GPID_7  = GenPurpID[07]
            RO.GPID_8  = GenPurpID[08]
            RO.GPID_9  = GenPurpID[09]
            RO.GPID_10 = GenPurpID[10]
             
            WRITE RECO=1
            
        endif  ;(RampID=1-999)
        
    ENDLOOP  ;CurRec=1, dbi.1.NUMRECORDS
    
ENDRUN



;-----------------------------------------------------------------------------------------
; create ramp-to-freeway connection file
;-----------------------------------------------------------------------------------------

RUN PGM=MATRIX  MSG='Network Processing 1: write out downstream ramp group ID file'
FILEI DBI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\RampGP_Connection_tmp.dbf',
    AUTOARRAY=ALLFIELDS,
    SORT=RampID

FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\RampGP_Connection - @RID@.csv'
    
    ;set MATRIX parameters
    ZONES = 1
    
    
    ;print header
    PRINT PRINTO=1,
        CSV=T,
        FORM=10.0,
        LIST=';RampID', 
             'GPID_1' , 
             'GPID_2' , 
             'GPID_3' , 
             'GPID_4' , 
             'GPID_5' , 
             'GPID_6' , 
             'GPID_7' , 
             'GPID_8' , 
             'GPID_9' , 
             'GPID_10 '
    
    ;print first ramp record
    PRINT PRINTO=1,
        CSV=T,
        FORM=10.0,
        LIST=dba.1.RampID[1],
             dba.1.GPID_1[1],
             dba.1.GPID_2[1],
             dba.1.GPID_3[1],
             dba.1.GPID_4[1],
             dba.1.GPID_5[1],
             dba.1.GPID_6[1],
             dba.1.GPID_7[1],
             dba.1.GPID_8[1],
             dba.1.GPID_9[1],
             dba.1.GPID_10[1]
    
    ;print remaining ramp records
    LOOP RecNum=2, dbi.1.NUMRECORDS
        
        ;check for duplicates
        if (dba.1.RampID[RecNum]<>dba.1.RampID[RecNum-1])
            
            PRINT PRINTO=1,
                CSV=T,
                FORM=10.0,
                LIST=dba.1.RampID[RecNum],
                     dba.1.GPID_1[RecNum],
                     dba.1.GPID_2[RecNum],
                     dba.1.GPID_3[RecNum],
                     dba.1.GPID_4[RecNum],
                     dba.1.GPID_5[RecNum],
                     dba.1.GPID_6[RecNum],
                     dba.1.GPID_7[RecNum],
                     dba.1.GPID_8[RecNum],
                     dba.1.GPID_9[RecNum],
                     dba.1.GPID_10[RecNum]
            
        endif  ;(RampID[RecNum]<>RampID[RecNum-1])
        
    ENDLOOP  ;RecNum=1, dbi.1.NUMRECORDS
    
    
    ;clear task monitor status
    PRINT PRINTO=0, LIST=" "
    
ENDRUN



;print timestamp
RUN PGM=MATRIX
     
    ;set MATRIX parameters
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Create Scenario Network            ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 1_NetProcessor.txt)

