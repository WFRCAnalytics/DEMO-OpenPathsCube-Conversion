
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 3_TurnPenalty.txt)



;get start time
ScriptStartTime = currenttime()




;create file listing only centriod connectors
RUN PGM=NETWORK  MSG='Network Processing 3: Identify Centroid Connectors'
FILEI NETI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@.net'
 
FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\C3_CENTROIDS.TXT'

    PHASE=LINKMERGE
        ;delete all but centroids before writing out temp file
        if (li.1.FT>1)  DELETE
        
        ;write out temp file of A & B nodes for centroid connectors
        if (li.1.A<=@UsedZones@)
            PRINT PRINTO=1, LIST=A(8.0), ',', B(8.0)
            
            _NUMRECORDS = _NUMRECORDS + 1
     endif
    ENDPHASE
    
    PHASE=SUMMARY
        _NUMRECORDS = _NUMRECORDS + 1
        LOG PREFIX=ToLOG, VAR=_NUMRECORDS
    ENDPHASE
ENDRUN




;create turn penalty file
RUN PGM=MATRIX   MSG='Network Processing 3: Create Turn Penalty File'
    FILEI RECI='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\C3_CENTROIDS.TXT', A=1, B=2
    
    ARRAY nodea=@ToLOG._NUMRECORDS@
    ARRAY nodeb=@ToLOG._NUMRECORDS@
    
    
    index = index + 1
    
    nodea[index]=RI.A
    nodeb[index]=RI.B
    
    
    if (I=0)
        LOOP first=1,index
            
            procrec = ROUND(first / index * 100)
            PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
            onecentroid_first=1
            
            if (first>1 & first<index & (nodea[first]=nodea[first-1] | nodea[first]=nodea[first+1]))  onecentroid_first=0 
            
            LOOP second=1,index
            
                onecentroid_second=1
                if (second>1 & second<index & (nodea[second]=nodea[second-1] | nodea[second]=nodea[second+1]))  onecentroid_second=0 
                
                if (nodeb[first]=nodeb[second] & nodea[first]!=nodea[second] & (onecentroid_first+onecentroid_second<2))
                    PRINT FILE='@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt', 
                        LIST=nodea[first](6.0),',',nodeb[first](6.0),',',nodea[second](6.0),', 1, -1'
                    
                endif
            
            ENDLOOP
        ENDLOOP
		
	    ;Restrict turns at certain locations (namely freeway directional ramps)
        PRINT FILE='@ParentDir@@ScenarioDir@0_InputProcessing\turnpenalties.txt', 
            LIST='  \n',
            '23603, 23574, 23595, 1, -1\n',	;3500 S & I-215
            '23629, 23603, 23638, 1, -1\n',
            '23630, 23638, 23603, 1, -1\n',
            '23638, 23648, 23659, 1, -1\n',
            '23026, 23062, 23123, 1, -1\n',	;4700 S & I-215
            '23081, 23062, 23065, 1, -1\n',
            '22807, 22831, 22811, 1, -1\n',	;Redwood & I-215 (South)
            '22847, 22831, 22894, 1, -1\n',
            '22895, 22857, 22793, 1, -1\n',	;SB 7200 South Ramps
            '25381, 25368, 25361, 1, -1\n',	;3900 S & I-215
            '25685, 25669, 25591, 1, -1\n',	;3300 S & I-215
            '60351, 60343, 60344, 1, -1\n',	;University Ave & I-15
            '60343, 60351, 60344, 1, -1'
    
    endif
	
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Create Turn Penalty File           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 3_TurnPenalty.txt)
    