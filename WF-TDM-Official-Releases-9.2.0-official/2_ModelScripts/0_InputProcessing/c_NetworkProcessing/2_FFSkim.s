
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 2_FFSkim.txt)



;get start time
ScriptStartTime = currenttime()




;calculate free flow time and distance skims based on time minimized paths
RUN PGM=HIGHWAY  MSG='Network Processing 2: free flow skims'
    FILEI  NETI        = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'
           ZDATI[1]     = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
           
    FILEO  MATO     = '@ParentDir@@ScenarioDir@0_InputProcessing\skm_FF.mtx', mo=1-2, name=time, distance
        
  ;Cluster: distribute intrastep processing
  DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    ;set HIGHWAY parameters
    ZONES   = @UsedZones@
    ZONEMSG = @ZoneMsgRate@
    
    
    PHASE=LINKREAD
        ;assign free flow time working variable
        LW.TFF = (LI.DISTANCE/LI.FF_SPD) * 60
        
        ;exclude HOV links, HOV/HOT access links, HOT links, toll-way links from free
        ;flow skim
        if (LI.FT=37,38-40)  ADDTOGROUP = 6
    ENDPHASE
    
    
    ;build time minimized paths
    PHASE=ILOOP
        
        ;initialize time skim matrices
        mw[1]=0
        
        
        ;find time minimized paths and trace time and distance
        PATHLOAD CONSOLIDATE=T, PATH=LW.TFF, EXCLUDEGROUP=6,
                mw[1]=PATHCOST, NOACCESS=10000,               ;zone-to-zone times
                mw[2]=PATHTRACE(li.DISTANCE), NOACCESS=10000  ;zone-to-zone distances of best time path
        
        
        ;adjust intrazonal data and add terminal times to all but unconnected zones
        JLOOP
            if (mw[1]<>10000)
                if (I=J)
                    ;calculate average inrazonal disatance as half square root of area
                    mw[2][J]= 0.5 * (zi.1.SQMILE)^0.5
                    
                    ;calculate intrazonal time (time = distance / 20mph * 60min/hr)
                    mw[1][J] = mw[2][J] / 20 * 60
                endif
                
                ;add origin and destination terminal times to all zones
                mw[1] = mw[1] + zi.1.TERMTIME[I] + zi.1.TERMTIME[J]
            endif
        ENDJLOOP
        
    ENDPHASE
ENDRUN




;check for unconnected zones
RUN PGM=MATRIX  MSG='Network Processing 2: check for unconnected zones'
    FILEI MATI   = '@ParentDir@@ScenarioDir@0_InputProcessing\skm_FF.mtx'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf', SORT=Z, AUTOARRAY=ALLFIELDS
    FILEO RECO[1]= '@ParentDir@@ScenarioDir@0_InputProcessing\UnconnectedZones.dbf', FORM=8.0,
                    FIELDS=N(5.0), _WARNN, _WARNNTXT    
    
    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = @ZoneMsgRate@
    
    
    ;define array
    ARRAY DummyZoneConnect         = ZONES,
          UnConnectZoneDataNo        = ZONES,  HHNO  = ZONES, EMPNO  = ZONES,
          UnConnectZoneDataYes        = ZONES,  HHYES = ZONES, EMPYES = ZONES
    
    
    ;check if dummy zones are connected or if used zones are unconnected (unconnected
    ;zones will have 10000 for time/distance)
    if (I=@dummyzones@)
        ;check for dummy zones connected to network
        if (mi.1.1[1]<>10000)
            Dummy_chk = 1
            Dummy_cnt = Dummy_cnt + 1
            DummyZoneConnect[Dummy_cnt] = I
        endif
    else
        RO.N = I
        RO._WARNN = 0    
        if (mi.1.1[1]=10000)
                if (dba.1.TOTHH[I] + dba.1.TOTEMP[I]  > 50)
              UnConYes_chk = 1
                UnConYes_cnt = UnConYes_cnt + 1
              UnConnectZoneDataYes[UnConYes_cnt] = I
              HHYES[UnConYes_cnt]  = dba.1.TOTHH[I]                  
              EMPYES[UnConYes_cnt] = dba.1.TOTEMP[I]
              RO._WARNN = 11    
              RO._WARNNTXT = 'NoLinkLrgSE'    
                elseif (dba.1.TOTHH[I] + dba.1.TOTEMP[I]  > 5)
              UnConYes_chk = 1
                UnConYes_cnt = UnConYes_cnt + 1
              UnConnectZoneDataYes[UnConYes_cnt] = I
              HHYES[UnConYes_cnt]  = dba.1.TOTHH[I]                  
              EMPYES[UnConYes_cnt] = dba.1.TOTEMP[I]
              RO._WARNN = 12    
              RO._WARNNTXT = 'NoLinkSmlSE'                                
            else
              UnConNo_chk = 1
                UnConNo_cnt = UnConNo_cnt + 1
              UnConnectZoneDataNo[UnConNo_cnt] = I              
              HHNO[UnConNo_cnt]  = dba.1.TOTHH[I]                  
              EMPNO[UnConNo_cnt] = dba.1.TOTEMP[I]
              RO._WARNN = 13    
              RO._WARNNTXT = 'NoLinkNoSE'    
              
            endif
        endif
        WRITE RECO=1
    endif
    
    
    ;print to LOG
    if (I=ZONES)
    
        ;print list of connected dummy zones to LOG
        if (Dummy_chk=1)
            ;print header
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, FORM=11.0, LIST=
            '\n',
            '\n',
            '    The following dummy zones are connected to the network:\n'
            
            LOOP iter=1, Dummy_cnt
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, LIST=DummyZoneConnect[iter](13)
            ENDLOOP
        endif
        
        
        ;print list of unconnected zones to LOG
        if(UnConYes_chk=1) ;yes, significant demographics
            ;print header
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, FORM=11.0, LIST=
            '\n',
            '\n',
            '    Used zones not connected to the network, but have HH+EMP > 50  (Zone, HH, Emp)\n'
            
            LOOP iter=1, UnConYes_cnt
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, LIST=UnConnectZoneDataYes[iter](13), HHYES[iter](10.1), EMPYES[iter](10.1) 
            ENDLOOP
        endif
        
        ;print list of unconnected zones to LOG
        if(UnConNo_chk=1)
            ;print header
            PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, FORM=11.0, LIST=
            '\n',
            '\n',
            '    Used zones not connected to the network.  May be intentional, because not much HH or EMP  (Zone, HH, Emp)\n'
            
            LOOP iter=1, UnConNo_cnt
                PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', APPEND=T, LIST=UnConnectZoneDataNo[iter](13), HHNO[iter](10.1), EMPNO[iter](10.1) 

            ENDLOOP
        endif
        
    endif
ENDRUN




RUN PGM=NETWORK  MSG='Network Processing 2: process warning labels'
    FILEI  NETI[1]     = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'
    FILEI NODEI[2]     = '@ParentDir@@ScenarioDir@0_InputProcessing\UnconnectedZones.dbf'
    FILEO  NETO    = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\tmp.net', EXCLUDE = _WARNN, _WARNNTXT
    
    PHASE=NODEMERGE
        ;Take care, because WARNN may already be filled with other values
        if (NI.2._WARNN > 0)
            WARNN    = NI.2._WARNN
            WARNNTXT = NI.2._WARNNTXT
        else
        ;    WARNN    = NI.1.WARNN
        ;    WARNNTXT = NI.1.WARNNTXT
        endif        
        
    ENDPHASE

ENDRUN




RUN PGM=NETWORK  MSG='Network Processing 2: process warning labels'  ;can't overwrite the in network, so needed a tmp
    FILEI  NETI[1]     = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\tmp.net'
    FILEO  NETO    = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Free Flow Skims                    ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 2_FFSkim.txt)
