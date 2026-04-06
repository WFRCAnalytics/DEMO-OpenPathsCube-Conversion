
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 02_Segmnt_TransitAccessMarkets.txt)



;get start time
ScriptStartTime = currenttime()



;this script segments each zone pair by walk-to-transit, drive-to-transit and no transit
;    based on walk access buffers for each zone
;Essentially, if 45% of the origin zone area is within walking distance of transit,
;  and 20% of the destination zone area is, then .45*.2 = 9% of trips between those zones have walk-access;
;  .55*.2 = 11% have drive-access (only) and the remaining 80% don't have transit access.
RUN PGM=MATRIX  MSG='Mode Choice 2: Calculate Transit Walk & Drive Accessibility'
  zones=@Usedzones@
  FILEI ZDATI[1]= '@ParentDir@@ScenarioDir@0_InputProcessing\WalkBuffer\WalkBuffer.dbf',
      Z=TAZID
  
  FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx', MO=1-3, NAME=pctwalk, pctdrive, pctnone
  
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        jloop
        
          prod_buff = MIN(1 , zi.1.WALKPCT[i]/100)
          attr_buff = MIN(1 , zi.1.WALKPCT[j]/100)
          
          pctwalk  = prod_buff * attr_buff
          pctdrive = (1 - prod_buff) * attr_buff
          pctnone  = 1 - pctwalk - pctdrive
          
          mw[1][j] = pctwalk
          mw[2][j] = pctdrive
          mw[3][j] = pctnone
          
        endjloop
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Calc Access to Trans Market        ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 02_Segmnt_TransitAccessMarkets.txt)
