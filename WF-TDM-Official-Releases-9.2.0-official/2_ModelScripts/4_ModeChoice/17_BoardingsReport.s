
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 17_BoardingsReport.txt)



;get start time
ScriptStartTime = currenttime()




;Assign Script-specific general variables
    ;set hours-in-peak variables (used in calculating transit statistics)
    Pk_HrInPrd  = 6     ;number of hours in the peak period
    Ok_HrInPrd  = 10    ;number of hours in the off-peak period
    


;Print Output Header
RUN PGM=MATRIX   MSG='Mode Choice 17: print output header'
    
    ZONES = 1
    
    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\tmp_@RID@_transit_rider_summary_link.csv',
        CSV=T,
        LIST=';Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'LinkID',
             'Direction',
             'IB_OB',
             'A',
             'B',
             'Mode',
             'Name',
             'LongName',
             'RouteDir',
             'Distance',
             'Time',
             'LinkSeq',
             'Headway',
             'StopA',
             'StopB',
             
             'Riders',
             'FromSkim_LCL',
             'FromSkim_COR',
             'FromSkim_BRT',
             'FromSkim_EXP',
             'FromSkim_LRT',
             'FromSkim_CRT'
    
    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\tmp_@RID@_transit_brding_summary_node.csv',
        CSV=T,
        LIST=';Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'LinkID',
             'Direction',
             'IB_OB',
             'N',
             'Mode',
             'Name',
             'LongName',
             'RouteDir',
             'LinkSeq',
             'Headway',
             'Distance',
             
             'Board',
             'Board_FromSkim_LCL',
             'Board_FromSkim_COR',
             'Board_FromSkim_BRT',
             'Board_FromSkim_EXP',
             'Board_FromSkim_LRT',
             'Board_FromSkim_CRT',
             'Alight',
             'Alight_FromSkim_LCL',
             'Alight_FromSkim_COR',
             'Alight_FromSkim_BRT',
             'Alight_FromSkim_EXP',
             'Alight_FromSkim_LRT',
             'Alight_FromSkim_CRT'

    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_link.csv',
        CSV=T,
        LIST='Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'LinkID',
             'Direction',
             'A',
             'B',
             'Mode',
             'Name',
             'LongName',
             'RouteDir',
             'LinkSeq',
             'Headway',
             'StopA',
             'StopB',
             'Distance',
             'Time',
             'Riders',
             'FromSkim_LCL',
             'FromSkim_COR',
             'FromSkim_BRT',
             'FromSkim_EXP',
             'FromSkim_LRT',
             'FromSkim_CRT'
    
    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_segment.csv',
        CSV=T,
        LIST='Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'Direction',
             'SegID_Dir',
             'Mode',
             'DisplayMode',
             'Name',
             'LongName',
             'RouteDir',
             'LinkSeq',
             'Speed',
             'SegDistance',
             'SegTime',
             'Headway',
             'Frequency',
             'TrainBusMiles',
             
             'Riders',
             'FromSkim_LCL',
             'FromSkim_COR',
             'FromSkim_BRT',
             'FromSkim_EXP',
             'FromSkim_LRT',
             'FromSkim_CRT',

             'PMT',
             'PMT_FromSkim_LCL',
             'PMT_FromSkim_COR',
             'PMT_FromSkim_BRT',
             'PMT_FromSkim_EXP',
             'PMT_FromSkim_LRT',
             'PMT_FromSkim_CRT',

             'PHT',
             'PHT_FromSkim_LCL',
             'PHT_FromSkim_COR',
             'PHT_FromSkim_BRT',
             'PHT_FromSkim_EXP',
             'PHT_FromSkim_LRT',
             'PHT_FromSkim_CRT'

    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_node.csv',
        CSV=T,
        LIST='Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'LinkID',
             'Direction',
             'N',
             'Mode',
             'Name',
             'LongName',
             'RouteDir',
             'Headway',
             
             'Board',
             'Board_FromSkim_LCL',
             'Board_FromSkim_COR',
             'Board_FromSkim_BRT',
             'Board_FromSkim_EXP',
             'Board_FromSkim_LRT',
             'Board_FromSkim_CRT',
             'Alight',
             'Alight_FromSkim_LCL',
             'Alight_FromSkim_COR',
             'Alight_FromSkim_BRT',
             'Alight_FromSkim_EXP',
             'Alight_FromSkim_LRT',
             'Alight_FromSkim_CRT'

    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_seg-endpoint.csv',
        CSV=T,
        LIST='Purpose',
             'Period',
             'AccessMode',
             'SegID',
             'Direction',
             'SegID_Dir',
             'Mode',
             'Name',
             'LongName',
             'RouteDir',
             'LinkSeq',
             'Headway',
             
             'Board',
             'Board_FromSkim_LCL',
             'Board_FromSkim_COR',
             'Board_FromSkim_BRT',
             'Board_FromSkim_EXP',
             'Board_FromSkim_LRT',
             'Board_FromSkim_CRT',
             'Alight',
             'Alight_FromSkim_LCL',
             'Alight_FromSkim_COR',
             'Alight_FromSkim_BRT',
             'Alight_FromSkim_EXP',
             'Alight_FromSkim_LRT',
             'Alight_FromSkim_CRT'

    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_route.csv',
        CSV=T,
        LIST='Mode',
             'Name',
             'Period',
             'Distance',
             'Time',
             'Speed',
             'Headway',
             'Frequency',
             'TrainBusMiles',

             'Boardings',
             'Alightings',
             'DriveBoardings',
             'WalkBoardings',
             'DriveAlightings',
             'WalkAlightings'

    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_mode.csv',
        CSV=T,
        LIST='Mode',
             'Period',
             'Distance',
             'Time',
             'TrainBusMiles',

             'Boardings',
             'Alightings',
             'DriveBoardings',
             'WalkBoardings',
             'DriveAlightings',
             'WalkAlightings'
    
ENDRUN


;Combine Drive & Peak for all modes    
Purpose17 = 'All'
Period17  = 'pk'
Access17  = 'drive'
Hdway     = 'HEADWAY_1'

RUN PGM=MATRIX   MSG='Mode Choice 17: combine drive-peak trips'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd4_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd5_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd9_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd6_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd7_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_cbd_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_outsideCBD_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[10] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf',
        SORT=LINKID,
        AUTOARRAY=ALLFIELDS
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    
    ;loop through number of records and process/output data
    ;note: all records in this class (eg. drive-peak) have same number of records,
    ;record id's, fields, and sort order
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;count number of transit, walk, and transfer mode records
        counter = counter + 1

        ;break out of loop for drive access links
        if (dba.1.MODE[numrec]>=40)
            
            BREAK
            
        endif
        
        ;create linkid
        _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
        _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
        LINKID  = _ANode + '_' + _BNode
        
        ;get segid, direction, and ib/ob from scenario link dbf
        BSEARCH dba.10.LINKID=LINKID
        _idx_LINKID = _BSEARCH

        SEGID     = dba.10.SEGID[_idx_LINKID]
        DIRECTION = dba.10.DIRECTION[_idx_LINKID]
        IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
        ;assign routename variable
        RouteName = dba.1.NAME[numrec]
        RouteLongName = dba.1.LONGNAME[numrec]
        
        ;calculate route direction
        RouteDir = 1
        if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
        
        ;delete '-' in routename
        if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
        if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
        ;initialize demand variables
        VOL_LCL = 0
        VOL_COR = 0
        VOL_BRT = 0
        VOL_EXP = 0
        VOL_LRT = 0
        VOL_CRT = 0

        ONA_LCL = 0
        ONA_COR = 0
        ONA_BRT = 0
        ONA_EXP = 0
        ONA_LRT = 0
        ONA_CRT = 0

        OFB_LCL = 0
        OFB_COR = 0
        OFB_BRT = 0
        OFB_EXP = 0
        OFB_LRT = 0
        OFB_CRT = 0
        

        ;process transit, walk, and transfer mode records
        if (dba.1.MODE[numrec]=1-9 & dba.1.@Hdway@[numrec]>0) 
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            ONA_LCL = ROUND(dba.1.ONA[numrec]) / 100
            OFB_LCL = ROUND(dba.1.OFFB[numrec]) / 100
            
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            ONA_COR = ROUND(dba.2.ONA[numrec]) / 100
            OFB_COR = ROUND(dba.2.OFFB[numrec]) / 100
            
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            ONA_BRT = ROUND(dba.3.ONA[numrec]) / 100
            OFB_BRT = ROUND(dba.3.OFFB[numrec]) / 100
            
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            ONA_EXP = ROUND(dba.4.ONA[numrec]) / 100
            OFB_EXP = ROUND(dba.4.OFFB[numrec]) / 100
            
            VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
            ONA_LRT = ROUND(dba.5.ONA[numrec]) / 100
            OFB_LRT = ROUND(dba.5.OFFB[numrec]) / 100
            
            VOL_CRT = ROUND(dba.6.VOL[numrec]  + dba.7.VOL[numrec]) / 100
            ONA_CRT = ROUND(dba.6.ONA[numrec]  + dba.7.ONA[numrec]) / 100
            OFB_CRT = ROUND(dba.6.OFFB[numrec] + dba.7.OFFB[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT

            Sum_ONA = ONA_LCL +
                      ONA_COR +
                      ONA_BRT +
                      ONA_EXP +
                      ONA_LRT +
                      ONA_CRT

            Sum_OFB = OFB_LCL +
                      OFB_COR +
                      OFB_BRT +
                      OFB_EXP +
                      OFB_LRT +
                      OFB_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            
            ;process node boardings and alightings
            ;process for first link sequence in route
            if (LINKSEQ=1)
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD     = SUM_ONA
                
                ALT_LCL = 0
                ALT_COR = 0
                ALT_BRT = 0
                ALT_EXP = 0
                ALT_LRT = 0
                ALT_CRT = 0
                
                ALT     = 0
                
            ;process for middle to end of link sequences in route
            else
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD = SUM_ONA
                
                ALT_LCL = ROUND(dba.1.OFFB[numrec-1]) / 100
                ALT_COR = ROUND(dba.2.OFFB[numrec-1]) / 100
                ALT_BRT = ROUND(dba.3.OFFB[numrec-1]) / 100
                ALT_EXP = ROUND(dba.4.OFFB[numrec-1]) / 100
                ALT_LRT = ROUND(dba.5.OFFB[numrec-1]) / 100
                ALT_CRT = ROUND(dba.6.OFFB[numrec-1] + dba.7.OFFB[numrec-1]) / 100
                
                ALT = ALT_LCL +
                      ALT_COR +
                      ALT_BRT +
                      ALT_EXP +
                      ALT_LRT +
                      ALT_CRT
                
            endif  ;(LINKSEQ=1)

            if ((BRD>0) | (ALT>0))
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
                
            endif  ;(BRD>0) | (ALT>0)
            
            if ( (dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | (dba.1.MODE[numrec+1]>9 & SUM_OFB>0))
                
                N = B
                
                BRD_LCL = 0
                BRD_COR = 0
                BRD_BRT = 0
                BRD_EXP = 0
                BRD_LRT = 0
                BRD_CRT = 0
                
                BRD = 0
                
                ALT_LCL = OFB_LCL
                ALT_COR = OFB_COR
                ALT_BRT = OFB_BRT
                ALT_EXP = OFB_EXP
                ALT_LRT = OFB_LRT
                ALT_CRT = OFB_CRT
                
                ALT = SUM_OFB
                
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
            
            endif  ;((dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | etc.)
        
        elseif ( (dba.1.MODE[numrec]=11-39) &
                 ((ROUND(dba.1.VOL[numrec])/100)>0 | 
                  (ROUND(dba.2.VOL[numrec])/100)>0 |
                  (ROUND(dba.3.VOL[numrec])/100)>0 |
                  (ROUND(dba.4.VOL[numrec])/100)>0 |
                  (ROUND(dba.5.VOL[numrec])/100)>0 |
                  (ROUND(dba.6.VOL[numrec])/100)>0 |
                  (ROUND(dba.7.VOL[numrec])/100)>0  ) )
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            ;manually override SEGID to be empty, since these mode routes don't correspond to normal segids
            SEGID    = ''
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
            VOL_CRT = ROUND(dba.6.VOL[numrec]  + dba.7.VOL[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            
        endif  ;(dba.1.MODE[numrec]=11-39) & etc.

    ENDLOOP  ;numrec=1, dbi.1.NUMRECORDS
    
    
    ;processing drive access links for drive to local
    LOOP numrec=counter, dbi.1.NUMRECORDS

        VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
        
        if (VOL_LCL>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH

            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2

            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
            
            ;initialize demand variables
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_LCL
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.1.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter, dbi.1.NUMRECORDS
    
    
    ;processing drive access links for drive to core route
    LOOP numrec=counter, dbi.2.NUMRECORDS

        VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
        
        if (VOL_COR>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.2.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.2.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH

            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2

            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
            ;initialize demand variables
            VOL_LCL = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.2.A[numrec]
            B        = dba.2.B[numrec]
            MODE     = dba.2.MODE[numrec]
            DIST     = dba.2.DIST[numrec]
            TIME     = dba.2.TIME[numrec]
            LINKSEQ  = dba.2.LINKSEQ[numrec]
            HEADWAY  = dba.2.@Hdway@[numrec]
            STOPA    = dba.2.STOPA[numrec]
            STOPB    = dba.2.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_COR
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.2.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.2.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.2.NUMRECORDS
    
    
    ;processing drive access links for drive to brt
    LOOP numrec=counter+1, dbi.3.NUMRECORDS

        VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
        
        if (VOL_BRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.3.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.3.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.3.A[numrec]
            B        = dba.3.B[numrec]
            MODE     = dba.3.MODE[numrec]
            DIST     = dba.3.DIST[numrec]
            TIME     = dba.3.TIME[numrec]
            LINKSEQ  = dba.3.LINKSEQ[numrec]
            HEADWAY  = dba.3.@Hdway@[numrec]
            STOPA    = dba.3.STOPA[numrec]
            STOPB    = dba.3.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_BRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.3.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.3.VOL[numrec]>0

    ENDLOOP  ;numrec=counter+1, dbi.3.NUMRECORDS
    
    
    ;processing drive access links for drive to express bus
    LOOP numrec=counter+1, dbi.4.NUMRECORDS

        VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
        
        if (VOL_EXP>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.4.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.4.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.4.A[numrec]
            B        = dba.4.B[numrec]
            MODE     = dba.4.MODE[numrec]
            DIST     = dba.4.DIST[numrec]
            TIME     = dba.4.TIME[numrec]
            LINKSEQ  = dba.4.LINKSEQ[numrec]
            HEADWAY  = dba.4.@Hdway@[numrec]
            STOPA    = dba.4.STOPA[numrec]
            STOPB    = dba.4.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_EXP
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.4.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.4.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.4.NUMRECORDS
    
    
    ;processing drive access links for drive to light rail
    LOOP numrec=counter+1, dbi.5.NUMRECORDS

        VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
        
        if (VOL_LRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.5.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.5.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_CRT = 0

            A        = dba.5.A[numrec]
            B        = dba.5.B[numrec]
            MODE     = dba.5.MODE[numrec]
            DIST     = dba.5.DIST[numrec]
            TIME     = dba.5.TIME[numrec]
            LINKSEQ  = dba.5.LINKSEQ[numrec]
            HEADWAY  = dba.5.@Hdway@[numrec]
            STOPA    = dba.5.STOPA[numrec]
            STOPB    = dba.5.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_LRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.5.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.5.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.5.NUMRECORDS
    
    
    ;processing drive access links for drive to commuter rail
    LOOP numrec=counter+1, dbi.6.NUMRECORDS

        VOL_CRT = ROUND((dba.6.VOL[numrec]  + dba.7.VOL[numrec])) / 100
        
        if (VOL_CRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.6.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.6.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0

            A        = dba.6.A[numrec]
            B        = dba.6.B[numrec]
            MODE     = dba.6.MODE[numrec]
            DIST     = dba.6.DIST[numrec]
            TIME     = dba.6.TIME[numrec]
            LINKSEQ  = dba.6.LINKSEQ[numrec]
            HEADWAY  = dba.6.@Hdway@[numrec]
            STOPA    = dba.6.STOPA[numrec]
            STOPB    = dba.6.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.6.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.6.VOL[numrec]>0 | dba.7.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.6.NUMRECORDS
    
ENDRUN



;Combine Drive & Off-Peak for all modes
Purpose17 = 'All'
Period17  = 'ok'
Access17  = 'drive'
Hdway   = 'HEADWAY_2'

RUN PGM=MATRIX   MSG='Mode Choice 17: combine drive-off-peak trips'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd4_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd5_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd9_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd6_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd7_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_cbd_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_outsideCBD_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[10] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf',
        SORT=LINKID,
        AUTOARRAY=ALLFIELDS
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    
    ;loop through number of records and process/output data
    ;note: all records in this class (eg. drive-peak) have same number of records,
    ;record id's, fields, and sort order
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;count number of transit, walk, and transfer mode records
        counter = counter + 1

        ;break out of loop for drive access links
        if (dba.1.MODE[numrec]>=40)
            
            BREAK
            
        endif
        
        ;create linkid
        _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
        _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
        LINKID  = _ANode + '_' + _BNode
        
        ;get segid, direction, and ib/ob from scenario link dbf
        BSEARCH dba.10.LINKID=LINKID
        _idx_LINKID = _BSEARCH

        SEGID     = dba.10.SEGID[_idx_LINKID]
        DIRECTION = dba.10.DIRECTION[_idx_LINKID]
        IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
        ;assign routename variable
        RouteName = dba.1.NAME[numrec]
        RouteLongName = dba.1.LONGNAME[numrec]
        
        ;calculate route direction
        RouteDir = 1
        if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
        
        ;delete '-' in routename
         if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
         if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
        ;initialize demand variables
        VOL_LCL = 0
        VOL_COR = 0
        VOL_BRT = 0
        VOL_EXP = 0
        VOL_LRT = 0
        VOL_CRT = 0

        ONA_LCL = 0
        ONA_COR = 0
        ONA_BRT = 0
        ONA_EXP = 0
        ONA_LRT = 0
        ONA_CRT = 0

        OFB_LCL = 0
        OFB_COR = 0
        OFB_BRT = 0
        OFB_EXP = 0
        OFB_LRT = 0
        OFB_CRT = 0
        

        ;process transit, walk, and transfer mode records
        if (dba.1.MODE[numrec]=1-9 & dba.1.@Hdway@[numrec]>0) 
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            ONA_LCL = ROUND(dba.1.ONA[numrec]) / 100
            OFB_LCL = ROUND(dba.1.OFFB[numrec]) / 100
            
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            ONA_COR = ROUND(dba.2.ONA[numrec]) / 100
            OFB_COR = ROUND(dba.2.OFFB[numrec]) / 100
            
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            ONA_BRT = ROUND(dba.3.ONA[numrec]) / 100
            OFB_BRT = ROUND(dba.3.OFFB[numrec]) / 100
            
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            ONA_EXP = ROUND(dba.4.ONA[numrec]) / 100
            OFB_EXP = ROUND(dba.4.OFFB[numrec]) / 100
            
            VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
            ONA_LRT = ROUND(dba.5.ONA[numrec]) / 100
            OFB_LRT = ROUND(dba.5.OFFB[numrec]) / 100
            
            VOL_CRT = ROUND(dba.6.VOL[numrec]  + dba.7.VOL[numrec]) / 100
            ONA_CRT = ROUND(dba.6.ONA[numrec]  + dba.7.ONA[numrec]) / 100
            OFB_CRT = ROUND(dba.6.OFFB[numrec] + dba.7.OFFB[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT

            Sum_ONA = ONA_LCL +
                      ONA_COR +
                      ONA_BRT +
                      ONA_EXP +
                      ONA_LRT +
                      ONA_CRT

            Sum_OFB = OFB_LCL +
                      OFB_COR +
                      OFB_BRT +
                      OFB_EXP +
                      OFB_LRT +
                      OFB_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            
            ;process node boardings and alightings
            ;process for first link sequence in route
            if (LINKSEQ=1)
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD     = SUM_ONA
                
                ALT_LCL = 0
                ALT_COR = 0
                ALT_BRT = 0
                ALT_EXP = 0
                ALT_LRT = 0
                ALT_CRT = 0
                
                ALT     = 0
                
            ;process for middle to end of link sequences in route
            else
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD = SUM_ONA
                
                ALT_LCL = ROUND(dba.1.OFFB[numrec-1]) / 100
                ALT_COR = ROUND(dba.2.OFFB[numrec-1]) / 100
                ALT_BRT = ROUND(dba.3.OFFB[numrec-1]) / 100
                ALT_EXP = ROUND(dba.4.OFFB[numrec-1]) / 100
                ALT_LRT = ROUND(dba.5.OFFB[numrec-1]) / 100
                ALT_CRT = ROUND(dba.6.OFFB[numrec-1] + dba.7.OFFB[numrec-1]) / 100
                
                ALT = ALT_LCL +
                      ALT_COR +
                      ALT_BRT +
                      ALT_EXP +
                      ALT_LRT +
                      ALT_CRT

            endif  ;(LINKSEQ=1)

            if ((BRD>0) | (ALT>0))
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
                
            endif  ;(BRD>0) | (ALT>0)
            
            if ( (dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | (dba.1.MODE[numrec+1]>9 & SUM_OFB>0))
                
                N = B
                
                BRD_LCL = 0
                BRD_COR = 0
                BRD_BRT = 0
                BRD_EXP = 0
                BRD_LRT = 0
                BRD_CRT = 0
                
                BRD = 0
                
                ALT_LCL = OFB_LCL
                ALT_COR = OFB_COR
                ALT_BRT = OFB_BRT
                ALT_EXP = OFB_EXP
                ALT_LRT = OFB_LRT
                ALT_CRT = OFB_CRT
                
                ALT = SUM_OFB
                
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
            
            endif  ;((dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | etc.)
        
        elseif ( (dba.1.MODE[numrec]=11-39) &
                 ((ROUND(dba.1.VOL[numrec])/100)>0 | 
                  (ROUND(dba.2.VOL[numrec])/100)>0 |
                  (ROUND(dba.3.VOL[numrec])/100)>0 |
                  (ROUND(dba.4.VOL[numrec])/100)>0 |
                  (ROUND(dba.5.VOL[numrec])/100)>0 |
                  (ROUND(dba.6.VOL[numrec])/100)>0 |
                  (ROUND(dba.7.VOL[numrec])/100)>0  ) )
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            ;manually override SEGID to be empty, since these mode routes don't correspond to normal segids
            SEGID    = ''
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
            VOL_CRT = ROUND(dba.6.VOL[numrec]  + dba.7.VOL[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            
        endif  ;(dba.1.MODE[numrec]=11-39) & etc.

    ENDLOOP  ;numrec=1, dbi.1.NUMRECORDS
    
    
    ;processing drive access links for drive to local
    LOOP numrec=counter, dbi.1.NUMRECORDS

        VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
        
        if (VOL_LCL>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH

            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2

            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
            
            ;initialize demand variables
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_LCL
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.1.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter, dbi.1.NUMRECORDS
    
    
    ;processing drive access links for drive to core route
    LOOP numrec=counter, dbi.2.NUMRECORDS

        VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
        
        if (VOL_COR>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.2.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.2.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH

            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2

            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
            ;initialize demand variables
            VOL_LCL = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.2.A[numrec]
            B        = dba.2.B[numrec]
            MODE     = dba.2.MODE[numrec]
            DIST     = dba.2.DIST[numrec]
            TIME     = dba.2.TIME[numrec]
            LINKSEQ  = dba.2.LINKSEQ[numrec]
            HEADWAY  = dba.2.@Hdway@[numrec]
            STOPA    = dba.2.STOPA[numrec]
            STOPB    = dba.2.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_COR
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.2.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.2.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.2.NUMRECORDS
    
    
    ;processing drive access links for drive to brt
    LOOP numrec=counter+1, dbi.3.NUMRECORDS

        VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
        
        if (VOL_BRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.3.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.3.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_EXP = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.3.A[numrec]
            B        = dba.3.B[numrec]
            MODE     = dba.3.MODE[numrec]
            DIST     = dba.3.DIST[numrec]
            TIME     = dba.3.TIME[numrec]
            LINKSEQ  = dba.3.LINKSEQ[numrec]
            HEADWAY  = dba.3.@Hdway@[numrec]
            STOPA    = dba.3.STOPA[numrec]
            STOPB    = dba.3.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_BRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.3.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.3.VOL[numrec]>0

    ENDLOOP  ;numrec=counter+1, dbi.3.NUMRECORDS
    
    
    ;processing drive access links for drive to express bus
    LOOP numrec=counter+1, dbi.4.NUMRECORDS

        VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
        
        if (VOL_EXP>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.4.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.4.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_LRT = 0
            VOL_CRT = 0

            A        = dba.4.A[numrec]
            B        = dba.4.B[numrec]
            MODE     = dba.4.MODE[numrec]
            DIST     = dba.4.DIST[numrec]
            TIME     = dba.4.TIME[numrec]
            LINKSEQ  = dba.4.LINKSEQ[numrec]
            HEADWAY  = dba.4.@Hdway@[numrec]
            STOPA    = dba.4.STOPA[numrec]
            STOPB    = dba.4.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_EXP
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.4.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.4.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.4.NUMRECORDS
    
    
    ;processing drive access links for drive to light rail
    LOOP numrec=counter+1, dbi.5.NUMRECORDS

        VOL_LRT = ROUND(dba.5.VOL[numrec]) / 100
        
        if (VOL_LRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.5.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.5.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_CRT = 0

            A        = dba.5.A[numrec]
            B        = dba.5.B[numrec]
            MODE     = dba.5.MODE[numrec]
            DIST     = dba.5.DIST[numrec]
            TIME     = dba.5.TIME[numrec]
            LINKSEQ  = dba.5.LINKSEQ[numrec]
            HEADWAY  = dba.5.@Hdway@[numrec]
            STOPA    = dba.5.STOPA[numrec]
            STOPB    = dba.5.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_LRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.5.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.5.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.5.NUMRECORDS
    
    
    ;processing drive access links for drive to commuter rail
    LOOP numrec=counter+1, dbi.6.NUMRECORDS

        VOL_CRT = ROUND((dba.6.VOL[numrec]  + dba.7.VOL[numrec])) / 100
        
        if (VOL_CRT>0)

            ;create linkid
            _ANode  = LTRIM(STR(dba.6.A[numrec], 10, 0))
            _BNode  = LTRIM(STR(dba.6.B[numrec], 10, 0))
            LINKID  = _ANode + '_' + _BNode
        
            ;get segid, direction, and ib/ob from scenario link dbf
            BSEARCH dba.10.LINKID=LINKID
            _idx_LINKID = _BSEARCH
    
            SEGID     = dba.10.SEGID[_idx_LINKID]
            DIRECTION = dba.10.DIRECTION[_idx_LINKID]
            IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
            ;assign routename variable
            RouteName = dba.1.NAME[numrec]
            RouteLongName = dba.1.LONGNAME[numrec]
        
            ;calculate route direction
            RouteDir = 1
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
            
            ;delete '-' in routename
            if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
            if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)

            ;initialize demand variables
            VOL_LCL = 0
            VOL_COR = 0
            VOL_BRT = 0
            VOL_EXP = 0
            VOL_LRT = 0

            A        = dba.6.A[numrec]
            B        = dba.6.B[numrec]
            MODE     = dba.6.MODE[numrec]
            DIST     = dba.6.DIST[numrec]
            TIME     = dba.6.TIME[numrec]
            LINKSEQ  = dba.6.LINKSEQ[numrec]
            HEADWAY  = dba.6.@Hdway@[numrec]
            STOPA    = dba.6.STOPA[numrec]
            STOPB    = dba.6.STOPB[numrec]

            ;calculate sums
            Sum_VOL = VOL_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.6.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID

            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'

        endif  ;dba.6.VOL[numrec]>0 | dba.7.VOL[numrec]>0
        
    ENDLOOP  ;numrec=counter+1, dbi.6.NUMRECORDS
    
ENDRUN



;Combine Walk & Peak for all modes
Purpose17 = 'All'
Period17  = 'pk'
Access17  = 'walk'
Hdway   = 'HEADWAY_1'

RUN PGM=MATRIX   MSG='Mode Choice 17: combine walk-peak trips'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw4_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw5_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw9_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw6_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_cbd_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_outsideCBD_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_cbd_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[8] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_outsideCBD_Pk.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[10] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf',
        SORT=LINKID,
        AUTOARRAY=ALLFIELDS
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    
    ;loop through number of records and process/output data
    ;note: all records in this class (eg. drive-peak) have same number of records,
    ;record id's, fields, and sort order
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;count number of transit, walk, and transfer mode records
        counter = counter + 1

        ;break out of loop for drive access links
        if (dba.1.MODE[numrec]>=40)
            
            BREAK
            
        endif
        
        ;create linkid
        _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
        _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
        LINKID  = _ANode + '_' + _BNode
        
        ;get segid, direction, and ib/ob from scenario link dbf
        BSEARCH dba.10.LINKID=LINKID
        _idx_LINKID = _BSEARCH

        SEGID     = dba.10.SEGID[_idx_LINKID]
        DIRECTION = dba.10.DIRECTION[_idx_LINKID]
        IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
        ;assign routename variable
        RouteName = dba.1.NAME[numrec]
        RouteLongName = dba.1.LONGNAME[numrec]
        
        ;calculate route direction
        RouteDir = 1
        if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
        
        ;delete '-' in routename
         if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
         if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
        ;initialize demand variables
        VOL_LCL = 0
        VOL_COR = 0
        VOL_BRT = 0
        VOL_EXP = 0
        VOL_LRT = 0
        VOL_CRT = 0

        ONA_LCL = 0
        ONA_COR = 0
        ONA_BRT = 0
        ONA_EXP = 0
        ONA_LRT = 0
        ONA_CRT = 0

        OFB_LCL = 0
        OFB_COR = 0
        OFB_BRT = 0
        OFB_EXP = 0
        OFB_LRT = 0
        OFB_CRT = 0
        

        ;process transit, walk, and transfer mode records
        if (dba.1.MODE[numrec]=1-9 & dba.1.@Hdway@[numrec]>0) 
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            ONA_LCL = ROUND(dba.1.ONA[numrec]) / 100
            OFB_LCL = ROUND(dba.1.OFFB[numrec]) / 100
            
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            ONA_COR = ROUND(dba.2.ONA[numrec]) / 100
            OFB_COR = ROUND(dba.2.OFFB[numrec]) / 100
            
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            ONA_BRT = ROUND(dba.3.ONA[numrec]) / 100
            OFB_BRT = ROUND(dba.3.OFFB[numrec]) / 100
            
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            ONA_EXP = ROUND(dba.4.ONA[numrec]) / 100
            OFB_EXP = ROUND(dba.4.OFFB[numrec]) / 100
            
            VOL_LRT = ROUND(dba.5.VOL[numrec] + dba.6.VOL[numrec]) / 100
            ONA_LRT = ROUND(dba.5.ONA[numrec] + dba.6.ONA[numrec]) / 100
            OFB_LRT = ROUND(dba.5.OFFB[numrec] + dba.6.OFFB[numrec]) / 100
            
            VOL_CRT = ROUND(dba.7.VOL[numrec]  + dba.8.VOL[numrec]) / 100
            ONA_CRT = ROUND(dba.7.ONA[numrec]  + dba.8.ONA[numrec]) / 100
            OFB_CRT = ROUND(dba.7.OFFB[numrec] + dba.8.OFFB[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT

            Sum_ONA = ONA_LCL +
                      ONA_COR +
                      ONA_BRT +
                      ONA_EXP +
                      ONA_LRT +
                      ONA_CRT

            Sum_OFB = OFB_LCL +
                      OFB_COR +
                      OFB_BRT +
                      OFB_EXP +
                      OFB_LRT +
                      OFB_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            
            ;process node boardings and alightings
            ;process for first link sequence in route
            if (LINKSEQ=1)
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD     = SUM_ONA
                
                ALT_LCL = 0
                ALT_COR = 0
                ALT_BRT = 0
                ALT_EXP = 0
                ALT_LRT = 0
                ALT_CRT = 0
                
                ALT     = 0
                
            ;process for middle to end of link sequences in route
            else
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD = SUM_ONA
                
                ALT_LCL = ROUND(dba.1.OFFB[numrec-1]) / 100
                ALT_COR = ROUND(dba.2.OFFB[numrec-1]) / 100
                ALT_BRT = ROUND(dba.3.OFFB[numrec-1]) / 100
                ALT_EXP = ROUND(dba.4.OFFB[numrec-1]) / 100
                ALT_LRT = ROUND(dba.5.OFFB[numrec-1] + dba.6.OFFB[numrec-1]) / 100
                ALT_CRT = ROUND(dba.7.OFFB[numrec-1] + dba.8.OFFB[numrec-1]) / 100
                
                ALT = ALT_LCL +
                      ALT_COR +
                      ALT_BRT +
                      ALT_EXP +
                      ALT_LRT +
                      ALT_CRT

            endif  ;(LINKSEQ=1)

            if ((BRD>0) | (ALT>0))
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
                
            endif  ;(BRD>0) | (ALT>0)
            
            if ( (dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | (dba.1.MODE[numrec+1]>9 & SUM_OFB>0))
                
                N = B
                
                BRD_LCL = 0
                BRD_COR = 0
                BRD_BRT = 0
                BRD_EXP = 0
                BRD_LRT = 0
                BRD_CRT = 0
                
                BRD = 0
                
                ALT_LCL = OFB_LCL
                ALT_COR = OFB_COR
                ALT_BRT = OFB_BRT
                ALT_EXP = OFB_EXP
                ALT_LRT = OFB_LRT
                ALT_CRT = OFB_CRT
                
                ALT = SUM_OFB
                
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
            
            endif  ;((dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0 | etc.))
        
        elseif ( (dba.1.MODE[numrec]=11-39) &
                 ((ROUND(dba.1.VOL[numrec])/100)>0 | 
                  (ROUND(dba.2.VOL[numrec])/100)>0 |
                  (ROUND(dba.3.VOL[numrec])/100)>0 |
                  (ROUND(dba.4.VOL[numrec])/100)>0 |
                  (ROUND(dba.5.VOL[numrec])/100)>0 |
                  (ROUND(dba.6.VOL[numrec])/100)>0 |
                  (ROUND(dba.7.VOL[numrec])/100)>0  ) )
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            ;manually override SEGID to be empty, since these mode routes don't correspond to normal segids
            SEGID    = ''
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            VOL_LRT = ROUND(dba.5.VOL[numrec] + dba.6.VOL[numrec]) / 100
            VOL_CRT = ROUND(dba.7.VOL[numrec] + dba.8.VOL[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
        endif  ;(dba.1.MODE[numrec]=11-39) & etc.

    ENDLOOP  ;numrec=1, dbi.1.NUMRECORDS
    
ENDRUN



;Combine Walk & Peak for all modes
Purpose17 = 'All'
Period17  = 'ok'
Access17  = 'walk'
Hdway   = 'HEADWAY_2'

RUN PGM=MATRIX   MSG='Mode Choice 17: combine walk-off-peak trips'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw4_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw5_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw9_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw6_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_cbd_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_outsideCBD_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_cbd_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[8] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_outsideCBD_Ok.dbf', 
        SORT=MODE NAME LINKSEQ, 
        AUTOARRAY=ALLFIELDS
    FILEI DBI[10] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyLink_withBusRailLinks.dbf',
        SORT=LINKID,
        AUTOARRAY=ALLFIELDS
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    
    ;loop through number of records and process/output data
    ;note: all records in this class (eg. drive-peak) have same number of records,
    ;record id's, fields, and sort order
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;count number of transit, walk, and transfer mode records
        counter = counter + 1

        ;break out of loop for drive access links
        if (dba.1.MODE[numrec]>=40)
            
            BREAK
            
        endif
        
        ;create linkid
        _ANode  = LTRIM(STR(dba.1.A[numrec], 10, 0))
        _BNode  = LTRIM(STR(dba.1.B[numrec], 10, 0))
        LINKID  = _ANode + '_' + _BNode
        
        ;get segid, direction, and ib/ob from scenario link dbf
        BSEARCH dba.10.LINKID=LINKID
        _idx_LINKID = _BSEARCH

        SEGID     = dba.10.SEGID[_idx_LINKID]
        DIRECTION = dba.10.DIRECTION[_idx_LINKID]
        IB_OB     = dba.10.IB_OB[_idx_LINKID]
        
        ;assign routename variable
        RouteName = dba.1.NAME[numrec]
        RouteLongName = dba.1.LONGNAME[numrec]
        
        ;calculate route direction
        RouteDir = 1
        if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteDir      = 2
        
        ;delete '-' in routename
         if (RIGHTSTR(TRIM(RouteName),1)='-')     RouteName     = REPLACESTR(RouteName,'-','',0)
         if (RIGHTSTR(TRIM(RouteLongName),1)='-') RouteLongName = REPLACESTR(RouteLongName,'-','',0)
        
        ;initialize demand variables
        VOL_LCL = 0
        VOL_COR = 0
        VOL_BRT = 0
        VOL_EXP = 0
        VOL_LRT = 0
        VOL_CRT = 0

        ONA_LCL = 0
        ONA_COR = 0
        ONA_BRT = 0
        ONA_EXP = 0
        ONA_LRT = 0
        ONA_CRT = 0

        OFB_LCL = 0
        OFB_COR = 0
        OFB_BRT = 0
        OFB_EXP = 0
        OFB_LRT = 0
        OFB_CRT = 0
        

        ;process transit, walk, and transfer mode records
        if (dba.1.MODE[numrec]=1-9 & dba.1.@Hdway@[numrec]>0) 
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            ONA_LCL = ROUND(dba.1.ONA[numrec]) / 100
            OFB_LCL = ROUND(dba.1.OFFB[numrec]) / 100
            
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            ONA_COR = ROUND(dba.2.ONA[numrec]) / 100
            OFB_COR = ROUND(dba.2.OFFB[numrec]) / 100
            
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            ONA_BRT = ROUND(dba.3.ONA[numrec]) / 100
            OFB_BRT = ROUND(dba.3.OFFB[numrec]) / 100
            
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            ONA_EXP = ROUND(dba.4.ONA[numrec]) / 100
            OFB_EXP = ROUND(dba.4.OFFB[numrec]) / 100
            
            VOL_LRT = ROUND(dba.5.VOL[numrec] + dba.6.VOL[numrec]) / 100
            ONA_LRT = ROUND(dba.5.ONA[numrec] + dba.6.ONA[numrec]) / 100
            OFB_LRT = ROUND(dba.5.OFFB[numrec] + dba.6.OFFB[numrec]) / 100
            
            VOL_CRT = ROUND(dba.7.VOL[numrec]  + dba.8.VOL[numrec]) / 100
            ONA_CRT = ROUND(dba.7.ONA[numrec]  + dba.8.ONA[numrec]) / 100
            OFB_CRT = ROUND(dba.7.OFFB[numrec] + dba.8.OFFB[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT

            Sum_ONA = ONA_LCL +
                      ONA_COR +
                      ONA_BRT +
                      ONA_EXP +
                      ONA_LRT +
                      ONA_CRT

            Sum_OFB = OFB_LCL +
                      OFB_COR +
                      OFB_BRT +
                      OFB_EXP +
                      OFB_LRT +
                      OFB_CRT
            
            ;account for empty segments at the end of a route
            nextLINKSEQ = dba.1.LINKSEQ[numrec+1]
            if (STRLEN(TRIM(SEGID))>0)  lastDIRECTION = DIRECTION
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  DIRECTION = lastDIRECTION
            if (nextLINKSEQ=1 & STRLEN(TRIM(SEGID))=0)  SEGID = lastSEGID
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
            ;process node boardings and alightings
            ;process for first link sequence in route
            if (LINKSEQ=1)
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD     = SUM_ONA
                
                ALT_LCL = 0
                ALT_COR = 0
                ALT_BRT = 0
                ALT_EXP = 0
                ALT_LRT = 0
                ALT_CRT = 0
                
                ALT     = 0
                
            ;process for middle to end of link sequences in route
            else
                
                N = A
                
                BRD_LCL = ONA_LCL
                BRD_COR = ONA_COR
                BRD_BRT = ONA_BRT
                BRD_EXP = ONA_EXP
                BRD_LRT = ONA_LRT
                BRD_CRT = ONA_CRT
                
                BRD = SUM_ONA
                
                ALT_LCL = ROUND(dba.1.OFFB[numrec-1]) / 100
                ALT_COR = ROUND(dba.2.OFFB[numrec-1]) / 100
                ALT_BRT = ROUND(dba.3.OFFB[numrec-1]) / 100
                ALT_EXP = ROUND(dba.4.OFFB[numrec-1]) / 100
                ALT_LRT = ROUND(dba.5.OFFB[numrec-1] + dba.6.OFFB[numrec-1]) / 100
                ALT_CRT = ROUND(dba.7.OFFB[numrec-1] + dba.8.OFFB[numrec-1]) / 100
                
                ALT = ALT_LCL +
                      ALT_COR +
                      ALT_BRT +
                      ALT_EXP +
                      ALT_LRT +
                      ALT_CRT

            endif  ;(LINKSEQ=1)

            if ((BRD>0) | (ALT>0))
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
                
            endif  ;(BRD>0) | (ALT>0)
            
            if ( (dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | (dba.1.MODE[numrec+1]>9 & SUM_OFB>0))
                
                N = B
                
                BRD_LCL = 0
                BRD_COR = 0
                BRD_BRT = 0
                BRD_EXP = 0
                BRD_LRT = 0
                BRD_CRT = 0
                
                BRD = 0
                
                ALT_LCL = OFB_LCL
                ALT_COR = OFB_COR
                ALT_BRT = OFB_BRT
                ALT_EXP = OFB_EXP
                ALT_LRT = OFB_LRT
                ALT_CRT = OFB_CRT
                
                ALT = SUM_OFB
                
                
                ;print output file
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitBoardings.block'
            
            endif  ;((dba.1.LINKSEQ[numrec+1]=1 & SUM_OFB>0) | etc.)
        
        elseif ( (dba.1.MODE[numrec]=11-39) &
                 ((ROUND(dba.1.VOL[numrec])/100)>0 | 
                  (ROUND(dba.2.VOL[numrec])/100)>0 |
                  (ROUND(dba.3.VOL[numrec])/100)>0 |
                  (ROUND(dba.4.VOL[numrec])/100)>0 |
                  (ROUND(dba.5.VOL[numrec])/100)>0 |
                  (ROUND(dba.6.VOL[numrec])/100)>0 |
                  (ROUND(dba.7.VOL[numrec])/100)>0  ) )
            
            A        = dba.1.A[numrec]
            B        = dba.1.B[numrec]
            MODE     = dba.1.MODE[numrec]
            DIST     = dba.1.DIST[numrec]
            TIME     = dba.1.TIME[numrec]
            LINKSEQ  = dba.1.LINKSEQ[numrec]
            HEADWAY  = dba.1.@Hdway@[numrec]
            STOPA    = dba.1.STOPA[numrec]
            STOPB    = dba.1.STOPB[numrec]
            
            ;manually override SEGID to be empty, since these mode routes don't correspond to normal segids
            SEGID    = ''
            
            VOL_LCL = ROUND(dba.1.VOL[numrec]) / 100
            VOL_COR = ROUND(dba.2.VOL[numrec]) / 100
            VOL_BRT = ROUND(dba.3.VOL[numrec]) / 100
            VOL_EXP = ROUND(dba.4.VOL[numrec]) / 100
            VOL_LRT = ROUND(dba.5.VOL[numrec] + dba.6.VOL[numrec]) / 100
            VOL_CRT = ROUND(dba.7.VOL[numrec] + dba.8.VOL[numrec]) / 100
            
            ;calculate sums
            Sum_VOL = VOL_LCL +
                      VOL_COR +
                      VOL_BRT +
                      VOL_EXP +
                      VOL_LRT +
                      VOL_CRT
            
            
            ;print output file
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\PrintTransitRiders.block'
            
        endif  ;(dba.1.MODE[numrec]=11-39) & etc.

    ENDLOOP  ;numrec=1, dbi.1.NUMRECORDS
    
ENDRUN



;Calculate transit segment summary and fix duplicates in link summary
RUN PGM=MATRIX   MSG='Creating Transit Segment Summary'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\tmp_@RID@_transit_rider_summary_link.csv', 
        DELIMITER =',',
        Purpose(C)       = #01,
        Period(C)        =  02,
        AccessMode(C)    =  03,
        SegID(C)         =  04,
        LinkID(C)        =  05,
        Direction(C)     =  06,
        IB_OB(C)         =  07,
        A                =  08,
        B                =  09,
        Mode             =  10,
        Name(C)          =  11,
        LongName(C)      =  12,
        RouteDir         =  13,
        Distance         =  14,
        Time             =  15,
        LinkSeq          =  16,
        Headway          =  17,
        StopA            =  18,
        StopB            =  19,
        Riders           =  20,
        FromSkim_LCL     =  21,
        FromSkim_COR     =  22,
        FromSkim_BRT     =  23,
        FromSkim_EXP     =  24,
        FromSkim_LRT     =  25,
        FromSkim_CRT     =  26,
        SORT=Purpose, Period, AccessMode, Mode, Name, RouteDir, LinkSeq,
        SKIPRECS=1,
        AUTOARRAY=ALLFIELDS

    FILEI DBI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\tmp_@RID@_transit_brding_summary_node.csv',
        DELIMITER =',',
        Purpose(C)             = #01,
        Period(C)              =  02,
        AccessMode(C)          =  03,
        SegID(C)               =  04,
        LinkID(C)              =  05,
        Direction(C)           =  06,
        IB_OB(C)               =  07,
        N                      =  08,
        Mode                   =  09,
        Name(C)                =  10,
        LongName(C)            =  11,
        RouteDir               =  12,
        LinkSeq                =  13,
        Headway                =  14,
        Distance               =  15,
        Board                  =  16,
        Board_FromSkim_LCL     =  17,
        Board_FromSkim_COR     =  18,
        Board_FromSkim_BRT     =  19,
        Board_FromSkim_EXP     =  20,
        Board_FromSkim_LRT     =  21,
        Board_FromSkim_CRT     =  22,
        Alight                 =  23,
        Alight_FromSkim_LCL    =  24,
        Alight_FromSkim_COR    =  25,
        Alight_FromSkim_BRT    =  26,
        Alight_FromSkim_EXP    =  27,
        Alight_FromSkim_LRT    =  28,
        Alight_FromSkim_CRT    =  29,
        SORT=Purpose, Period, AccessMode, Mode, Name, RouteDir, LinkSeq,
        SKIPRECS=1,
        AUTOARRAY=ALLFIELDS
    
    
    FILEI DBI[3] = '@ParentDir@1_Inputs\6_Segment\@Segments_DBF@',
        AUTOARRAY=ALLFIELDS,
        SORT=SEGID
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    ;define arrays
    ARRAY TYPE=C50 Rte_Name = 999

    ARRAY Rte_Dst  = 9999, 99, 2, 2,
          Rte_Tme  = 9999, 99, 2, 2,
          Rte_Hwy  = 9999, 99, 2, 2,
          Rte_Brd  = 9999, 99, 2, 2,
          Rte_Alt  = 9999, 99, 2, 2
          
          ;note: idx1=route, idx2=mode, idx3=pkok, idx4=accessmode
    
    
    ; ========================================================================================
    ; Riders Loop
    ; ========================================================================================
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;process segment data to combine duplicate segids to create unique index
        LinkID = dba.1.LinkID[numrec]
        SegID = dba.1.SegID[numrec]
        Direction  = dba.1.Direction[numrec]
        SegID_Dir = SegID + '_' + Direction
        Name = dba.1.Name[numrec]
        RouteDir = dba.1.RouteDir[numrec]
        Riders = dba.1.Riders[numrec]
        Distance = dba.1.Distance[numrec]
        Time = dba.1.Time[numrec]
        
        FromSkim_LCL = dba.1.FromSkim_LCL[numrec]
        FromSkim_COR = dba.1.FromSkim_COR[numrec]
        FromSkim_BRT = dba.1.FromSkim_BRT[numrec]
        FromSkim_EXP = dba.1.FromSkim_EXP[numrec]
        FromSkim_LRT = dba.1.FromSkim_LRT[numrec]
        FromSkim_CRT = dba.1.FromSkim_CRT[numrec]
        
        nextLinkID = dba.1.LinkID[numrec+1]
        nextSegID = dba.1.SegID[numrec+1]
        nextDirection = dba.1.Direction[numrec+1]
        nextName = dba.1.Name[numrec+1]
        nextRouteDir = dba.1.RouteDir[numrec+1]
        nextRiders = dba.1.Riders[numrec+1]
        nextLinkDistance = dba.1.Distance[numrec+1]
        nextLinkTime = dba.1.Time[numrec+1]
        
        nextFromSkim_LCL = dba.1.FromSkim_LCL[numrec+1]
        nextFromSkim_COR = dba.1.FromSkim_COR[numrec+1]
        nextFromSkim_BRT = dba.1.FromSkim_BRT[numrec+1]
        nextFromSkim_EXP = dba.1.FromSkim_EXP[numrec+1]
        nextFromSkim_LRT = dba.1.FromSkim_LRT[numrec+1]
        nextFromSkim_CRT = dba.1.FromSkim_CRT[numrec+1]
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit rider summary -- links
        ; ----------------------------------------------------------------------------------------
        ;initialize rider sum if start of set of repeating link, or just one non-repeating link
        if (sumLinkRiders=0) 
            
            sum_link_lcl = FromSkim_LCL
            sum_link_cor = FromSkim_COR
            sum_link_brt = FromSkim_BRT
            sum_link_exp = FromSkim_EXP
            sum_link_lrt = FromSkim_LRT
            sum_link_crt = FromSkim_CRT
            
            sumLinkRiders = Riders
            
        endif  ;linkSumRiders=0
        
        ;summarize link data for repeating links
        if ((LinkID=nextLinkID & nextLinkID=LinkID) &
            (Name=nextName     & nextName=Name    ) )
            
            sum_link_lcl = sum_link_lcl + nextFromSkim_LCL
            sum_link_cor = sum_link_cor + nextFromSkim_COR
            sum_link_brt = sum_link_brt + nextFromSkim_BRT
            sum_link_exp = sum_link_exp + nextFromSkim_EXP
            sum_link_lrt = sum_link_lrt + nextFromSkim_LRT
            sum_link_crt = sum_link_crt + nextFromSkim_CRT

            sumLinkRiders = sum_link_lcl +
                            sum_link_cor +
                            sum_link_brt +
                            sum_link_exp +
                            sum_link_lrt +
                            sum_link_crt
            
        ;calculate averages, print out link file, and reset variables if last of the repeating link or just one non-repeating link
        else 
            
            if (numrec>1)
                
                PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_link.csv',
                APPEND=T,
                CSV=T,
                LIST=
                    dba.1.Purpose[numrec],
                    dba.1.Period[numrec],
                    dba.1.AccessMode[numrec],
                    SegID,
                    LinkID,
                    dba.1.Direction[numrec],
                    dba.1.A[numrec],
                    dba.1.B[numrec],
                    dba.1.Mode[numrec],
                    Name,
                    dba.1.LongName[numrec],
                    RouteDir,
                    dba.1.LinkSeq[numrec],
                    dba.1.Headway[numrec],
                    dba.1.StopA[numrec],
                    dba.1.StopB[numrec],
                    Distance,
                    Time,
                    sumLinkRiders,
                    sum_link_lcl,
                    sum_link_cor,
                    sum_link_brt,
                    sum_link_exp,
                    sum_link_lrt,
                    sum_link_crt
                
            endif  ;(numrec>1)
            
            sumLinkRiders = 0
            sum_link_lcl  = 0
            sum_link_cor  = 0
            sum_link_brt  = 0
            sum_link_exp  = 0
            sum_link_lrt  = 0
            sum_link_crt  = 0
            
        endif  ;LinkID=nextLinkID & etc.
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit rider summary -- segments
        ; ----------------------------------------------------------------------------------------
        ;only process modes 1-9 for segment output
        if (dba.1.Mode[numrec]=1-9) 
            
            ;initialize sums if start of set of repeating segments, or just one non-repeating segment
            if (sumLinkDistance=0) 
                
                count = 1
                sumLinkDistance = Distance
                sumLinkTime = Time
                
                sum_lclD = FromSkim_LCL * sumLinkDistance
                sum_corD = FromSkim_COR * sumLinkDistance
                sum_brtD = FromSkim_BRT * sumLinkDistance
                sum_expD = FromSkim_EXP * sumLinkDistance
                sum_lrtD = FromSkim_LRT * sumLinkDistance
                sum_crtD = FromSkim_CRT * sumLinkDistance
                
            endif  ;sumLinkDistance=0
            
            
            ;summarize link data for repeating segment
            ;check strings on both sides of equal sign to combat weird voyager string syntax
            if ( ((SegID=nextSegID         & nextSegID=SegID        ) &
                  (Name=nextName           & nextName=Name          ) &
                  (Direction=nextDirection & nextDirection=Direction) ) | 
                 (STRLEN(SegID)=0 ) )
                
                count = count + 1
                sumLinkDistance = sumLinkDistance + nextLinkDistance
                sumLinkTime = sumLinkTime + nextLinkTime
                
                sum_lclD = sum_lclD + (nextFromSkim_LCL * nextLinkDistance)
                sum_corD = sum_corD + (nextFromSkim_COR * nextLinkDistance)
                sum_brtD = sum_brtD + (nextFromSkim_BRT * nextLinkDistance)
                sum_expD = sum_expD + (nextFromSkim_EXP * nextLinkDistance)
                sum_lrtD = sum_lrtD + (nextFromSkim_LRT * nextLinkDistance)
                sum_crtD = sum_crtD + (nextFromSkim_CRT * nextLinkDistance)
                 
                
            ;calculate averages, print out seg file, and reset variables if last of the repeating segment or just one non-repeating segment
            else
                
                ;find record index in shapefile dbf of segment, in order to use distance for passenger-miles traveled, route distance, etc.
                BSEARCH dba.3.SEGID=SegID
                _idx_SEGID = _BSEARCH
                
                
                ;initialize variables
                aveSpeed        = 0
                aveFromSkim_LCL = 0
                aveFromSkim_COR = 0
                aveFromSkim_BRT = 0
                aveFromSkim_EXP = 0
                aveFromSkim_LRT = 0
                aveFromSkim_CRT = 0
                Frequency       = 0
                Headway         = dba.1.Headway[numrec]
                SegDistance     = dba.3.DISTANCE[_idx_SEGID]
                SegTime         = 0
                TrainBusMiles   = 0
                
                ;calculate DisplayMode
                Mode = dba.1.Mode[numrec]
                if (Mode=4)  DisplayMode = 1
                if (Mode=5)  DisplayMode = 2
                if (Mode=6)  DisplayMode = 3
                if (Mode=7)  DisplayMode = 5
                if (Mode=8)  DisplayMode = 6
                if (Mode=9)  DisplayMode = 4
                
                ;calculate average speed
                if (sumLinkTime>0)  aveSpeed = (sumLinkDistance / sumLinkTime) * 60
                
                ;calculate segment time
                if (aveSpeed>0)  SegTime = SegDistance / aveSpeed
                
                ;calculate frequency
                if (Headway>0)  Frequency = 1 / (Headway / 60)
                
                ;calculate train/bus miles traveled
                if (dba.1.Period[numrec]='pk') TrainBusMiles = Frequency * SegDistance * @Pk_HrInPrd@
                if (dba.1.Period[numrec]='ok') TrainBusMiles = Frequency * SegDistance * @Ok_HrInPrd@
                
                ;calculate riders
                if (sumLinkDistance>0)  aveFromSkim_LCL = ROUND(sum_lclD / sumLinkDistance * 10) / 10
                if (sumLinkDistance>0)  aveFromSkim_COR = ROUND(sum_corD / sumLinkDistance * 10) / 10
                if (sumLinkDistance>0)  aveFromSkim_BRT = ROUND(sum_brtD / sumLinkDistance * 10) / 10
                if (sumLinkDistance>0)  aveFromSkim_EXP = ROUND(sum_expD / sumLinkDistance * 10) / 10
                if (sumLinkDistance>0)  aveFromSkim_LRT = ROUND(sum_lrtD / sumLinkDistance * 10) / 10
                if (sumLinkDistance>0)  aveFromSkim_CRT = ROUND(sum_crtD / sumLinkDistance * 10) / 10
                
                aveRiders = aveFromSkim_LCL +
                            aveFromSkim_COR +
                            aveFromSkim_BRT +
                            aveFromSkim_EXP +
                            aveFromSkim_LRT +
                            aveFromSkim_CRT
                
                ;calculate passenger-miles traveled
                pmtFromSkim_LCL = aveFromSkim_LCL * SegDistance
                pmtFromSkim_COR = aveFromSkim_COR * SegDistance
                pmtFromSkim_BRT = aveFromSkim_BRT * SegDistance
                pmtFromSkim_EXP = aveFromSkim_EXP * SegDistance
                pmtFromSkim_LRT = aveFromSkim_LRT * SegDistance
                pmtFromSkim_CRT = aveFromSkim_CRT * SegDistance
                
                pmtRiders = pmtFromSkim_LCL +
                            pmtFromSkim_COR +
                            pmtFromSkim_BRT +
                            pmtFromSkim_EXP +
                            pmtFromSkim_LRT +
                            pmtFromSkim_CRT
                
                ;calculate passenger-hours traveled
                phtFromSkim_LCL = aveFromSkim_LCL * SegTime
                phtFromSkim_COR = aveFromSkim_COR * SegTime
                phtFromSkim_BRT = aveFromSkim_BRT * SegTime
                phtFromSkim_EXP = aveFromSkim_EXP * SegTime
                phtFromSkim_LRT = aveFromSkim_LRT * SegTime
                phtFromSkim_CRT = aveFromSkim_CRT * SegTime
                
                phtRiders = phtFromSkim_LCL +
                            phtFromSkim_COR +
                            phtFromSkim_BRT +
                            phtFromSkim_EXP +
                            phtFromSkim_LRT +
                            phtFromSkim_CRT
                
                if (numrec>1)
                    
                    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_segment.csv',
                    APPEND=T,
                    CSV=T,
                    LIST=
                        dba.1.Purpose[numrec],
                        dba.1.Period[numrec],
                        dba.1.AccessMode[numrec],
                        SegID,
                        Direction,
                        SegID_Dir,
                        Mode,
                        DisplayMode,
                        Name,
                        dba.1.LongName[numrec],
                        RouteDir,
                        dba.1.LinkSeq[numrec],
                        aveSpeed(6.1),
                        SegDistance,
                        SegTime,
                        Headway,
                        Frequency,
                        TrainBusMiles,
                        aveRiders,
                        aveFromSkim_LCL,
                        aveFromSkim_COR,
                        aveFromSkim_BRT,
                        aveFromSkim_EXP,
                        aveFromSkim_LRT,
                        aveFromSkim_CRT,
                        pmtRiders,
                        pmtFromSkim_LCL,
                        pmtFromSkim_COR,
                        pmtFromSkim_BRT,
                        pmtFromSkim_EXP,
                        pmtFromSkim_LRT,
                        pmtFromSkim_CRT,
                        phtRiders,
                        phtFromSkim_LCL,
                        phtFromSkim_COR,
                        phtFromSkim_BRT,
                        phtFromSkim_EXP,
                        phtFromSkim_LRT,
                        phtFromSkim_CRT
                        
                endif  ;(numrec>1)
                
                sumLinkDistance = 0
                sumLinkTime = 0
                sum_lclD = 0
                sum_corD = 0
                sum_brtD = 0
                sum_expD = 0
                sum_lrtD = 0
                sum_crtD = 0
                
            endif  ;SegID=nextSegID & etc.
        else
            
            sumLinkDistance = 0
            sumLinkTime = 0
            sum_lclD = 0
            sum_corD = 0
            sum_brtD = 0
            sum_expD = 0
            sum_lrtD = 0
            sum_crtD = 0

        endif  ;dba.1.Mode[numrec]=1-9
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit rider summary -- routes
        ; ----------------------------------------------------------------------------------------
        ;Rte index
        if (numRte=0)
            numRte              = 1
            Rte_Name[numRte]    = Name
        elseif (Name<>Rte_Name[numRte] & Rte_Name[numRte]<>Name)
            numRte              = numRte + 1
            Rte_Name[numRte]    = Name
        endif
        
        LOOP Rte_Idx=1, numRte
            
            name1 = Rte_Name[Rte_Idx]
            if (name1 == Name) BREAK
            
        ENDLOOP

        ;initialize rider sum if start of set of repeating route
        if (RteDistance=0)
            
            RteDistance = Distance 
            RteTime = Time
            
        endif  ;RteDistance=0
        
        ;summarize node data for repeating routes
        if (Name=nextName & nextName=Name)
            
            RteDistance = RteDistance + nextLinkDistance
            RteTime = RteTime + nextLinkTime
            
        ;calculate sums, assign arrays and reset variables if last of the repeating route
        else 
            
            RteHeadway = dba.1.Headway[numrec]
            Mde = dba.1.Mode[numrec]

            if (dba.1.Period[numrec]='pk') Prd=1
            if (dba.1.Period[numrec]='ok') Prd=2
            if (dba.1.AccessMode[numrec]='drive') Acm=1
            if (dba.1.AccessMode[numrec]='walk')  Acm=2
            
            ;assign values to route arrays
            LOOP _lp_md = 4,9
                
                LOOP _lp_per = 1,2
                    
                    LOOP _lp_access = 1,2
                        
                        if (_lp_md=Mde & _lp_per=Prd & _lp_access=Acm) Rte_Dst[Rte_Idx][_lp_md][_lp_per][_lp_access] = RteDistance
                        if (_lp_md=Mde & _lp_per=Prd & _lp_access=Acm) Rte_Tme[Rte_Idx][_lp_md][_lp_per][_lp_access] = RteTime
                        if (_lp_md=Mde & _lp_per=Prd & _lp_access=Acm) Rte_Hwy[Rte_Idx][_lp_md][_lp_per][_lp_access] = RteHeadway
                    ENDLOOP
                    
                ENDLOOP
                
            ENDLOOP
            
            ;reset variables
            RteDistance = 0
            RteTime = 0
            RteHeadway = 0
            
        endif  ;Name=nextName & etc.
    
    
    ENDLOOP
    
    
    ; ========================================================================================
    ; Boardings/Alightings Loop
    ; ========================================================================================
    LOOP numrec=1, dbi.2.NUMRECORDS
        
        ;process segment data to combine duplicate segments to create unique index
        N = dba.2.N[numrec]
        SegID = dba.2.SegID[numrec]
        Name = dba.2.Name[numrec]
        Direction = dba.2.Direction[numrec]
        RouteDir = dba.2.RouteDir[numrec]
        Distance = dba.2.Distance[numrec]
        Board = dba.2.Board[numrec]
        Alight = dba.2.Alight[numrec]
        
        Board_FromSkim_LCL = dba.2.Board_FromSkim_LCL[numrec]
        Board_FromSkim_COR = dba.2.Board_FromSkim_COR[numrec]
        Board_FromSkim_BRT = dba.2.Board_FromSkim_BRT[numrec]
        Board_FromSkim_EXP = dba.2.Board_FromSkim_EXP[numrec]
        Board_FromSkim_LRT = dba.2.Board_FromSkim_LRT[numrec]
        Board_FromSkim_CRT = dba.2.Board_FromSkim_CRT[numrec]
        
        Alight_FromSkim_LCL = dba.2.Alight_FromSkim_LCL[numrec]
        Alight_FromSkim_COR = dba.2.Alight_FromSkim_COR[numrec]
        Alight_FromSkim_BRT = dba.2.Alight_FromSkim_BRT[numrec]
        Alight_FromSkim_EXP = dba.2.Alight_FromSkim_EXP[numrec]
        Alight_FromSkim_LRT = dba.2.Alight_FromSkim_LRT[numrec]
        Alight_FromSkim_CRT = dba.2.Alight_FromSkim_CRT[numrec]
        
        nextN = dba.2.N[numrec+1]
        nextSegID = dba.2.SegID[numrec+1]
        nextName = dba.2.Name[numrec+1]
        nextDirection = dba.2.Direction[numrec+1]
        nextRouteDir = dba.2.RouteDir[numrec+1]
        nextLinkDistance = dba.2.Distance[numrec+1]
        nextBoard = dba.2.Board[numrec+1]
        nextAlight = dba.2.Alight[numrec+1]
        
        nextBoard_FromSkim_LCL = dba.2.Board_FromSkim_LCL[numrec+1]
        nextBoard_FromSkim_COR = dba.2.Board_FromSkim_COR[numrec+1]
        nextBoard_FromSkim_BRT = dba.2.Board_FromSkim_BRT[numrec+1]
        nextBoard_FromSkim_EXP = dba.2.Board_FromSkim_EXP[numrec+1]
        nextBoard_FromSkim_LRT = dba.2.Board_FromSkim_LRT[numrec+1]
        nextBoard_FromSkim_CRT = dba.2.Board_FromSkim_CRT[numrec+1]
        
        nextAlight_FromSkim_LCL = dba.2.Alight_FromSkim_LCL[numrec+1]
        nextAlight_FromSkim_COR = dba.2.Alight_FromSkim_COR[numrec+1]
        nextAlight_FromSkim_BRT = dba.2.Alight_FromSkim_BRT[numrec+1]
        nextAlight_FromSkim_EXP = dba.2.Alight_FromSkim_EXP[numrec+1]
        nextAlight_FromSkim_LRT = dba.2.Alight_FromSkim_LRT[numrec+1]
        nextAlight_FromSkim_CRT = dba.2.Alight_FromSkim_CRT[numrec+1]
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit boarding summary -- nodes
        ; ----------------------------------------------------------------------------------------
        ;initialize rider sum if start of set of repeating link, or just one non-repeating link
        if (sumNodeBoard=0 & sumNodeAlight=0)
            
            sum_node_board_lcl  = Board_FromSkim_LCL
            sum_node_board_cor  = Board_FromSkim_COR
            sum_node_board_brt  = Board_FromSkim_BRT
            sum_node_board_exp  = Board_FromSkim_EXP
            sum_node_board_lrt  = Board_FromSkim_LRT
            sum_node_board_crt  = Board_FromSkim_CRT
            
            sum_node_alight_lcl = Alight_FromSkim_LCL
            sum_node_alight_cor = Alight_FromSkim_COR
            sum_node_alight_brt = Alight_FromSkim_BRT
            sum_node_alight_exp = Alight_FromSkim_EXP
            sum_node_alight_lrt = Alight_FromSkim_LRT
            sum_node_alight_crt = Alight_FromSkim_CRT

            sumNodeBoard  = Board
            sumNodeAlight = Alight
            
        endif  ;sumNodeBoard=0
        
        ;summarize node data for repeating nodes
        if ( (N=nextN         & nextN=N        ) &
             (Name=nextName   & nextName=Name  ) )
            
            sum_node_board_lcl  = sum_node_board_lcl + nextBoard_FromSkim_LCL
            sum_node_board_cor  = sum_node_board_cor + nextBoard_FromSkim_COR
            sum_node_board_brt  = sum_node_board_brt + nextBoard_FromSkim_BRT
            sum_node_board_exp  = sum_node_board_exp + nextBoard_FromSkim_EXP
            sum_node_board_lrt  = sum_node_board_lrt + nextBoard_FromSkim_LRT
            sum_node_board_crt  = sum_node_board_crt + nextBoard_FromSkim_CRT
            
            sum_node_alight_lcl = sum_node_alight_lcl + nextAlight_FromSkim_LCL
            sum_node_alight_cor = sum_node_alight_cor + nextAlight_FromSkim_COR
            sum_node_alight_brt = sum_node_alight_brt + nextAlight_FromSkim_BRT
            sum_node_alight_exp = sum_node_alight_exp + nextAlight_FromSkim_EXP
            sum_node_alight_lrt = sum_node_alight_lrt + nextAlight_FromSkim_LRT
            sum_node_alight_crt = sum_node_alight_crt + nextAlight_FromSkim_CRT
            
            sumNodeBoard  = sum_node_board_lcl +
                            sum_node_board_cor +
                            sum_node_board_brt +
                            sum_node_board_exp +
                            sum_node_board_lrt +
                            sum_node_board_crt 

            sumNodeAlight = sum_node_alight_lcl +
                            sum_node_alight_cor +
                            sum_node_alight_brt +
                            sum_node_alight_exp +
                            sum_node_alight_lrt +
                            sum_node_alight_crt
            
        ;calculate sums, print out node file, and reset variables if last of the repeating node or just one non-repeating node
        else 
            
            if (numrec>1)
                
                PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_node.csv',
                APPEND=T,
                CSV=T,
                LIST=
                    dba.2.Purpose[numrec],
                    dba.2.Period[numrec],
                    dba.2.AccessMode[numrec],
                    dba.2.SegID[numrec],
                    dba.2.LinkID[numrec],
                    dba.2.Direction[numrec],
                    N,
                    dba.2.Mode[numrec],
                    Name,
                    dba.2.LongName[numrec],
                    RouteDir,
                    dba.2.Headway[numrec],
                    sumNodeBoard,
                    sum_node_board_lcl,
                    sum_node_board_cor,
                    sum_node_board_brt,
                    sum_node_board_exp,
                    sum_node_board_lrt,
                    sum_node_board_crt,
                    sumNodeAlight,
                    sum_node_alight_lcl,
                    sum_node_alight_cor,
                    sum_node_alight_brt,
                    sum_node_alight_exp,
                    sum_node_alight_lrt,
                    sum_node_alight_crt
                    
                endif  ;(numrec>1)
               
            sumNodeBoard = 0
            sumNodeAlight = 0
            sum_node_board_lcl  = 0
            sum_node_board_cor  = 0
            sum_node_board_brt  = 0
            sum_node_board_exp  = 0
            sum_node_board_lrt  = 0
            sum_node_board_crt  = 0
            sum_node_alight_lcl  = 0
            sum_node_alight_cor  = 0
            sum_node_alight_brt  = 0
            sum_node_alight_exp  = 0
            sum_node_alight_lrt  = 0
            sum_node_alight_crt  = 0
            
        endif  ;N=nextN & etc.
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit boarding summary -- segment endpoints
        ; ----------------------------------------------------------------------------------------
        ;initialize rider sum if start of set of repeating segment, or just one non-repeating segment
        if (sumSegBoard=0 & sumSegAlight=0)
            
            sum_seg_board_lcl = Board_FromSkim_LCL
            sum_seg_board_cor = Board_FromSkim_COR
            sum_seg_board_brt = Board_FromSkim_BRT
            sum_seg_board_exp = Board_FromSkim_EXP
            sum_seg_board_lrt = Board_FromSkim_LRT
            sum_seg_board_crt = Board_FromSkim_CRT
            
            sum_seg_alight_lcl = Alight_FromSkim_LCL
            sum_seg_alight_cor = Alight_FromSkim_COR
            sum_seg_alight_brt = Alight_FromSkim_BRT
            sum_seg_alight_exp = Alight_FromSkim_EXP
            sum_seg_alight_lrt = Alight_FromSkim_LRT
            sum_seg_alight_crt = Alight_FromSkim_CRT
            
            sumSegBoard = Board
            sumSegAlight = Alight
            
            ;assign lastSEGID value for blank segids
            if (STRLEN(TRIM(SEGID))>0)  lastSEGID = SEGID
            if (STRLEN(TRIM(SEGID))>0)  lastDirection = DIRECTION
            
        endif  ;sumBoard=0
        
        ;summarize node data for repeating segments
        if ( ( (SegID=nextSegID         & nextSegID=SegID        ) &
               (Name=nextName           & nextName=Name          ) &
               (Direction=nextDirection & nextDirection=Direction) ) |
             ( (STRLEN(nextSegID)=0                              ) &
               (Name=nextName           & nextName=Name          ) ) )
            
            sum_seg_board_lcl =  sum_seg_board_lcl + nextBoard_FromSkim_LCL
            sum_seg_board_cor =  sum_seg_board_cor + nextBoard_FromSkim_COR
            sum_seg_board_brt =  sum_seg_board_brt + nextBoard_FromSkim_BRT
            sum_seg_board_exp =  sum_seg_board_exp + nextBoard_FromSkim_EXP
            sum_seg_board_lrt =  sum_seg_board_lrt + nextBoard_FromSkim_LRT
            sum_seg_board_crt =  sum_seg_board_crt + nextBoard_FromSkim_CRT
            
            sum_seg_alight_lcl = sum_seg_alight_lcl + nextAlight_FromSkim_LCL
            sum_seg_alight_cor = sum_seg_alight_cor + nextAlight_FromSkim_COR
            sum_seg_alight_brt = sum_seg_alight_brt + nextAlight_FromSkim_BRT
            sum_seg_alight_exp = sum_seg_alight_exp + nextAlight_FromSkim_EXP
            sum_seg_alight_lrt = sum_seg_alight_lrt + nextAlight_FromSkim_LRT
            sum_seg_alight_crt = sum_seg_alight_crt + nextAlight_FromSkim_CRT
            
            sumSegBoard  = sum_seg_board_lcl +
                           sum_seg_board_cor +
                           sum_seg_board_brt +
                           sum_seg_board_exp +
                           sum_seg_board_lrt +
                           sum_seg_board_crt 

            sumSegAlight = sum_seg_alight_lcl +
                           sum_seg_alight_cor +
                           sum_seg_alight_brt +
                           sum_seg_alight_exp +
                           sum_seg_alight_lrt +
                           sum_seg_alight_crt
            
        ;calculate sums, print out segment file, and reset variables if last of the repeating segment or just one non-repeating segment
        else 
            
            ;create segment-direction variable
            direct  = dba.2.Direction[numrec]
            if(STRLEN(segment)=0) direct = lastDIRECTION
            segment = dba.2.SegID[numrec]
            if(STRLEN(segment)=0) segment = lastSEGID
            SegID_Dir = segment + '_' + direct
            
            if (numrec>1)
                
                PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_seg-endpoint.csv',
                APPEND=T,
                CSV=T,
                LIST=
                    dba.2.Purpose[numrec],
                    dba.2.Period[numrec],
                    dba.2.AccessMode[numrec],
                    segment,
                    direct,
                    SegID_Dir,
                    dba.2.Mode[numrec],
                    Name,
                    dba.2.LongName[numrec],
                    RouteDir,
                    dba.2.LinkSeq[numrec],
                    dba.2.Headway[numrec],
                    sumSegBoard,
                    sum_seg_board_lcl,
                    sum_seg_board_cor,
                    sum_seg_board_brt,
                    sum_seg_board_exp,
                    sum_seg_board_lrt,
                    sum_seg_board_crt,
                    sumSegAlight,
                    sum_seg_alight_lcl,
                    sum_seg_alight_cor,
                    sum_seg_alight_brt,
                    sum_seg_alight_exp,
                    sum_seg_alight_lrt,
                    sum_seg_alight_crt
                    
                endif  ;(numrec>1)
               
            sumSegBoard = 0
            sumSegAlight = 0
            sum_seg_board_lcl  = 0
            sum_seg_board_cor  = 0
            sum_seg_board_brt  = 0
            sum_seg_board_exp  = 0
            sum_seg_board_lrt  = 0
            sum_seg_board_crt  = 0
            sum_seg_alight_lcl  = 0
            sum_seg_alight_cor  = 0
            sum_seg_alight_brt  = 0
            sum_seg_alight_exp  = 0
            sum_seg_alight_lrt  = 0
            sum_seg_alight_crt  = 0
            
        endif  ;SegID=nextSegID & etc.
        
        
        ; ----------------------------------------------------------------------------------------
        ; transit boarding summary -- routes
        ; ----------------------------------------------------------------------------------------
        ;loop through array of routes names
        ;break out of loop if route array matches route from dbf input
        ;use _idx_Rte as the correct index for array variables below
        LOOP _idx_Rte=1, numRte
            
            name1 = Rte_Name[_idx_Rte] 
            
            if (name1 == Name) BREAK
            
        ENDLOOP
        
        ;initialize rider sum if start of set of repeating route
        if (sumRteBoard=0 & sumRteAlight=0)
            
            sumLinkDistance = Distance 
            
            sum_rte_board_lcl = Board_FromSkim_LCL
            sum_rte_board_cor = Board_FromSkim_COR
            sum_rte_board_brt = Board_FromSkim_BRT
            sum_rte_board_exp = Board_FromSkim_EXP
            sum_rte_board_lrt = Board_FromSkim_LRT
            sum_rte_board_crt = Board_FromSkim_CRT
            
            sum_rte_alight_lcl = Alight_FromSkim_LCL
            sum_rte_alight_cor = Alight_FromSkim_COR
            sum_rte_alight_brt = Alight_FromSkim_BRT
            sum_rte_alight_exp = Alight_FromSkim_EXP
            sum_rte_alight_lrt = Alight_FromSkim_LRT
            sum_rte_alight_crt = Alight_FromSkim_CRT

            sumRteBoard = Board
            sumRteAlight = Alight
            
        endif  ;sumRteBoard=0
        
        ;summarize node data for repeating routes
        if (Name=nextName         & nextName=Name        )
            
            sumLinkDistance = sumLinkDistance + nextLinkDistance 
            
            sum_rte_board_lcl  = sum_rte_board_lcl + nextBoard_FromSkim_LCL
            sum_rte_board_cor  = sum_rte_board_cor + nextBoard_FromSkim_COR
            sum_rte_board_brt  = sum_rte_board_brt + nextBoard_FromSkim_BRT
            sum_rte_board_exp  = sum_rte_board_exp + nextBoard_FromSkim_EXP
            sum_rte_board_lrt  = sum_rte_board_lrt + nextBoard_FromSkim_LRT
            sum_rte_board_crt  = sum_rte_board_crt + nextBoard_FromSkim_CRT
            
            sum_rte_alight_lcl = sum_rte_alight_lcl + nextAlight_FromSkim_LCL
            sum_rte_alight_cor = sum_rte_alight_cor + nextAlight_FromSkim_COR
            sum_rte_alight_brt = sum_rte_alight_brt + nextAlight_FromSkim_BRT
            sum_rte_alight_exp = sum_rte_alight_exp + nextAlight_FromSkim_EXP
            sum_rte_alight_lrt = sum_rte_alight_lrt + nextAlight_FromSkim_LRT
            sum_rte_alight_crt = sum_rte_alight_crt + nextAlight_FromSkim_CRT
            
            sumRteBoard  = sum_rte_board_lcl +
                           sum_rte_board_cor +
                           sum_rte_board_brt +
                           sum_rte_board_exp +
                           sum_rte_board_lrt +
                           sum_rte_board_crt 

            sumRteAlight = sum_rte_alight_lcl +
                           sum_rte_alight_cor +
                           sum_rte_alight_brt +
                           sum_rte_alight_exp +
                           sum_rte_alight_lrt +
                           sum_rte_alight_crt
            
        ;calculate sums, print out route file, and reset variables if last of the repeating route
        else 
            
            Mde = dba.2.Mode[numrec]
            
            if (dba.2.Period[numrec]='pk') Prd=1
            if (dba.2.Period[numrec]='ok') Prd=2
            if (dba.2.AccessMode[numrec]='drive') Acm=1
            if (dba.2.AccessMode[numrec]='walk')  Acm=2
            
            ;assign route level boarding and alighting arrays
            LOOP _lp_md = 4,9
                
                LOOP _lp_per = 1,2
                    
                    LOOP _lp_access = 1,2
                        
                        if (_lp_md=Mde & _lp_per=Prd & _lp_access=Acm) Rte_Brd[_idx_Rte][_lp_md][_lp_per][_lp_access] = sumRteBoard
                        if (_lp_md=Mde & _lp_per=Prd & _lp_access=Acm) Rte_Alt[_idx_Rte][_lp_md][_lp_per][_lp_access] = sumRteAlight
                    ENDLOOP
                    
                ENDLOOP
                
            ENDLOOP
               
            sumRteBoard = 0
            sumRteAlight = 0
            sum_rte_board_lcl  = 0
            sum_rte_board_cor  = 0
            sum_rte_board_brt  = 0
            sum_rte_board_exp  = 0
            sum_rte_board_lrt  = 0
            sum_rte_board_crt  = 0
            sum_rte_alight_lcl = 0
            sum_rte_alight_cor = 0
            sum_rte_alight_brt = 0
            sum_rte_alight_exp = 0
            sum_rte_alight_lrt = 0
            sum_rte_alight_crt = 0
            
        endif  ;Name=nextName & etc.
        
    ENDLOOP
    
    
    ; ----------------------------------------------------------------------------------------
    ; Route and Mode Reports
    ; ----------------------------------------------------------------------------------------
    ;loop through mode, period, and route level arrays and print values to reports
    LOOP md=4, 9
        
        LOOP pk=1, 2
            
            LOOP ir=2, numRte
                
                ;assign array value to route variables
                RteDriveBrd = Rte_Brd[ir][md][pk][1]
                RteWalkBrd  = Rte_Brd[ir][md][pk][2]
                RteDriveAlt = Rte_Alt[ir][md][pk][1]
                RteWalkAlt  = Rte_Alt[ir][md][pk][2]
                
                RteBrd = RteDriveBrd + RteWalkBrd
                RteAlt = RteDriveAlt + RteWalkAlt
                
                RteDistance = Rte_Dst[ir][md][pk][1]
                RteTime     = Rte_Tme[ir][md][pk][1]
                RteHeadway  = Rte_Hwy[ir][md][pk][1]
                
                ;initialize other variables
                aveRteSpeed = 0
                RteFreq     = 0
                RteVehMile  = 0
                
                if (pk=1) Period ='pk'
                if (pk=2) Period ='ok'
                
                ;calculate average speed & frequency
                if (RteTime>0)     aveRteSpeed = (RteDistance / RteTime) * 60
                if (RteHeadway>0)  RteFreq = 1 / (RteHeadway / 60)
                
                ;calculate train/bus miles traveled
                if (Period='pk') RteVehMile = RteFreq * RteDistance * @Pk_HrInPrd@
                if (Period='ok') RteVehMile = RteFreq * RteDistance * @Ok_HrInPrd@
                
                ;print route report if boarding/alighting exists
                if ( (RteBrd>0) | (RteAlt>0) )
                    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_route.csv',
                    APPEND=T,
                    CSV=T,
                    LIST=md,
                         Rte_Name[ir],
                         Period,
                         RteDistance,
                         RteTime,
                         aveRteSpeed,
                         RteHeadway,
                         RteFreq,
                         RteVehMile,
                         RteBrd,
                         RteAlt,
                         RteDriveBrd,
                         RteWalkBrd,
                         RteDriveAlt,
                         RteWalkAlt
                endif
                
                ;sum route level data by mode to print in mode report
                MdeDriveBrd = Rte_Brd[ir][md][pk][1] + MdeDriveBrd
                MdeWalkBrd  = Rte_Brd[ir][md][pk][2] + MdeWalkBrd
                MdeDriveAlt = Rte_Alt[ir][md][pk][1] + MdeDriveAlt
                MdeWalkAlt  = Rte_Alt[ir][md][pk][2] + MdeWalkAlt

                MdeDistance = Rte_Dst[ir][md][pk][1] + MdeDistance
                MdeTime     = Rte_Tme[ir][md][pk][1] + MdeTime
                MdeVehMile  = RteVehMile + MdeVehMile
                
            ENDLOOP
            
            ;calcualte total boarding/alightings by mode
            MdeBrd = MdeDriveBrd + MdeWalkBrd
            MdeAlt = MdeDriveAlt + MdeWalkAlt
            
            ;print mode report
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_mode.csv',
            APPEND=T,
            CSV=T,
            LIST=md,
                 Period,
                 MdeDistance,
                 MdeTime,
                 MdeVehMile,
                 MdeBrd,
                 MdeAlt,
                 MdeDriveBrd,
                 MdeWalkBrd,
                 MdeDriveAlt,
                 MdeWalkAlt
                
            MdeDriveBrd = 0
            MdeWalkBrd  = 0
            MdeDriveAlt = 0
            MdeWalkAlt  = 0
            MdeDistance = 0
            MdeTime     = 0
            MdeVehMile  = 0
            
        ENDLOOP
        
    ENDLOOP

ENDRUN




if (Run_vizTool=1)

RUN PGM=MATRIX MSG='0: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "transitroutes"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion      = "@ModelVersion@"',
             '\nScenarioGroup     = "@ScenarioGroup@"',
             '\nRunYear           = @RunYear@',
             '\n',
             '\ninputFile         = r"@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_segment.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json for transit routes
;  note using single asterix minimizes the command window when executed, double asterix executes the command window non-minimized
;  note: the 1>&2 echos the python window output to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


;handle python script errors
if (ReturnCode<>0)
    
    PROMPT QUESTION='Python failed to run correctly',
        ANSWER="Please check the py log file in '@ParentDir@@ScenarioDir@_Log' for error messages."
    
    GOTO :ONERROR
    
    ABORT
    
endif  ;ReturnCode<>0



RUN PGM=MATRIX MSG='3: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "transitsegments"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_segment.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


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



RUN PGM=MATRIX MSG='1: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "transitsegmenttrends"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_rider_summary_segment.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


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



RUN PGM=MATRIX MSG='1: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "transitstops"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_seg-endpoint.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


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

RUN PGM=MATRIX MSG='1: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "transitroutetrends"',
             '\n',
             '\nParentDir       = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir     = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\n',
             '\n',
             '\n# input files ------------------------------------------------------------------',
             '\nModelVersion    = "@ModelVersion@"',
             '\nScenarioGroup   = "@ScenarioGroup@"',
             '\nRunYear         =  @RunYear@',
             '\n',
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\@RID@_transit_brding_summary_route.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2


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

endif  ;Run_vizTool=1


;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Combine Transit dbf                ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL ..\3_TransitAssign\tmp*) ; this line doesn't work I don't think
    *(DEL 17_BoardingsReport.txt)