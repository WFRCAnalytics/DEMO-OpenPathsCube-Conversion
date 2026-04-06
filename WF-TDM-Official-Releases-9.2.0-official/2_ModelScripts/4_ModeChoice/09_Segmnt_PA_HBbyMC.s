
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 09_Segmnt_PA_HBbyMC.txt)



;get start time
ScriptStartTime = currenttime()




LOOP period = 1,2,1 
 if     (period=1) 
   prd  = 'Pk'
 elseif (period=2) 
   prd = 'Ok'
 endif
 
;FILE: homebased_PA_by_modechoice_segment.s
loop purpose=1,2,1       ;run through script for each home-based trip purpose

  if (purpose==1) 
    purp='HBW'
    XI='_noXI.'
  elseif (purpose==2)
    purp='HBO'
    XI='.'
  endif
  
  
RUN PGM=MATRIX   MSG='Mode Choice 9: separate trips by Veh-Inc market segment - @prd@ @purp@'

zones=@Usedzones@
  ;read in percent of trips by "detailed" market segment (size/income/vehicles/workers)
  FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH1_PercTrips_segment_@purp@.dbf'
  FILEI ZDATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH2_PercTrips_segment_@purp@.dbf'
  FILEI ZDATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH3_PercTrips_segment_@purp@.dbf'
  FILEI ZDATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH4_PercTrips_segment_@purp@.dbf'
  FILEI ZDATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH5_PercTrips_segment_@purp@.dbf'
  FILEI ZDATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH6_PercTrips_segment_@purp@.dbf'
  
  ;read in daily trip table for each purpose
  FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBW_ByPeriod_noXI.mtx'
  FILEI MATI[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_HBO_ByPeriod.mtx'
  
  ;output PA tables for each purpose, by modechoice market segment (vehicles/income)
  FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_@prd@.mtx', MO=11,12, NAME=0veh_lowinc, 0veh_highinc
        MATO[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_@prd@.mtx', MO=13,14, NAME=1veh_lowinc, 1veh_highinc
        MATO[3]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_@prd@@XI@mtx', MO=15,16, NAME=2veh_lowinc, 2veh_highinc
  
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
  ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
     

  /* calculate number of trips by each market segment in mode choice models */
  ;NOTE: each zi file represents a unique HH Size category (i.e. zi.1 - HH1, zi.5 - HH5, etc.)
  ;0 vehicle segment
  ;Lowest income quartile
  percenttrips_0veh_LowInc = zi.1.P_ILW0V0[z] + zi.1.P_ILW1V0[z] + zi.1.P_ILW2V0[z] + zi.1.P_ILW3V0[z] +
                             zi.2.P_ILW0V0[z] + zi.2.P_ILW1V0[z] + zi.2.P_ILW2V0[z] + zi.2.P_ILW3V0[z] +
                             zi.3.P_ILW0V0[z] + zi.3.P_ILW1V0[z] + zi.3.P_ILW2V0[z] + zi.3.P_ILW3V0[z] +
                             zi.4.P_ILW0V0[z] + zi.4.P_ILW1V0[z] + zi.4.P_ILW2V0[z] + zi.4.P_ILW3V0[z] +
                             zi.5.P_ILW0V0[z] + zi.5.P_ILW1V0[z] + zi.5.P_ILW2V0[z] + zi.5.P_ILW3V0[z] +
                             zi.6.P_ILW0V0[z] + zi.6.P_ILW1V0[z] + zi.6.P_ILW2V0[z] + zi.6.P_ILW3V0[z]
  
  
  
  ;3 highest income quartiles                    
  percenttrips_0veh_HighInc = zi.1.P_IHW0V0[z] + zi.1.P_IHW1V0[z] + zi.1.P_IHW2V0[z] + zi.1.P_IHW3V0[z] +
                              zi.2.P_IHW0V0[z] + zi.2.P_IHW1V0[z] + zi.2.P_IHW2V0[z] + zi.2.P_IHW3V0[z] +
                              zi.3.P_IHW0V0[z] + zi.3.P_IHW1V0[z] + zi.3.P_IHW2V0[z] + zi.3.P_IHW3V0[z] +
                              zi.4.P_IHW0V0[z] + zi.4.P_IHW1V0[z] + zi.4.P_IHW2V0[z] + zi.4.P_IHW3V0[z] +
                              zi.5.P_IHW0V0[z] + zi.5.P_IHW1V0[z] + zi.5.P_IHW2V0[z] + zi.5.P_IHW3V0[z] +
                              zi.6.P_IHW0V0[z] + zi.6.P_IHW1V0[z] + zi.6.P_IHW2V0[z] + zi.6.P_IHW3V0[z]
  
                      
                      
  ;1 vehicle segment
  ;Lowest income quartile
  percenttrips_1veh_LowInc = zi.1.P_ILW0V1[z] + zi.1.P_ILW1V1[z] + zi.1.P_ILW2V1[z] + zi.1.P_ILW3V1[z] +
                             zi.2.P_ILW0V1[z] + zi.2.P_ILW1V1[z] + zi.2.P_ILW2V1[z] + zi.2.P_ILW3V1[z] +
                             zi.3.P_ILW0V1[z] + zi.3.P_ILW1V1[z] + zi.3.P_ILW2V1[z] + zi.3.P_ILW3V1[z] +
                             zi.4.P_ILW0V1[z] + zi.4.P_ILW1V1[z] + zi.4.P_ILW2V1[z] + zi.4.P_ILW3V1[z] +
                             zi.5.P_ILW0V1[z] + zi.5.P_ILW1V1[z] + zi.5.P_ILW2V1[z] + zi.5.P_ILW3V1[z] +
                             zi.6.P_ILW0V1[z] + zi.6.P_ILW1V1[z] + zi.6.P_ILW2V1[z] + zi.6.P_ILW3V1[z]
  
  
  
  ;3 highest income quartiles                    
  percenttrips_1veh_HighInc = zi.1.P_IHW0V1[z] + zi.1.P_IHW1V1[z] + zi.1.P_IHW2V1[z] + zi.1.P_IHW3V1[z] +
                              zi.2.P_IHW0V1[z] + zi.2.P_IHW1V1[z] + zi.2.P_IHW2V1[z] + zi.2.P_IHW3V1[z] +
                              zi.3.P_IHW0V1[z] + zi.3.P_IHW1V1[z] + zi.3.P_IHW2V1[z] + zi.3.P_IHW3V1[z] +
                              zi.4.P_IHW0V1[z] + zi.4.P_IHW1V1[z] + zi.4.P_IHW2V1[z] + zi.4.P_IHW3V1[z] +
                              zi.5.P_IHW0V1[z] + zi.5.P_IHW1V1[z] + zi.5.P_IHW2V1[z] + zi.5.P_IHW3V1[z] +
                              zi.6.P_IHW0V1[z] + zi.6.P_IHW1V1[z] + zi.6.P_IHW2V1[z] + zi.6.P_IHW3V1[z]
  
  
                      
  ;2+ vehicle segment
  ;Lowest income quartile
  percenttrips_2veh_LowInc = zi.1.P_ILW0V2[z] + zi.1.P_ILW1V2[z] + zi.1.P_ILW2V2[z] + zi.1.P_ILW3V2[z] +
                             zi.2.P_ILW0V2[z] + zi.2.P_ILW1V2[z] + zi.2.P_ILW2V2[z] + zi.2.P_ILW3V2[z] +
                             zi.3.P_ILW0V2[z] + zi.3.P_ILW1V2[z] + zi.3.P_ILW2V2[z] + zi.3.P_ILW3V2[z] +
                             zi.4.P_ILW0V2[z] + zi.4.P_ILW1V2[z] + zi.4.P_ILW2V2[z] + zi.4.P_ILW3V2[z] +
                             zi.5.P_ILW0V2[z] + zi.5.P_ILW1V2[z] + zi.5.P_ILW2V2[z] + zi.5.P_ILW3V2[z] +
                             zi.6.P_ILW0V2[z] + zi.6.P_ILW1V2[z] + zi.6.P_ILW2V2[z] + zi.6.P_ILW3V2[z] + 
                             zi.1.P_ILW0V3[z] + zi.1.P_ILW1V3[z] + zi.1.P_ILW2V3[z] + zi.1.P_ILW3V3[z] +
                             zi.2.P_ILW0V3[z] + zi.2.P_ILW1V3[z] + zi.2.P_ILW2V3[z] + zi.2.P_ILW3V3[z] +
                             zi.3.P_ILW0V3[z] + zi.3.P_ILW1V3[z] + zi.3.P_ILW2V3[z] + zi.3.P_ILW3V3[z] +
                             zi.4.P_ILW0V3[z] + zi.4.P_ILW1V3[z] + zi.4.P_ILW2V3[z] + zi.4.P_ILW3V3[z] +
                             zi.5.P_ILW0V3[z] + zi.5.P_ILW1V3[z] + zi.5.P_ILW2V3[z] + zi.5.P_ILW3V3[z] +
                             zi.6.P_ILW0V3[z] + zi.6.P_ILW1V3[z] + zi.6.P_ILW2V3[z] + zi.6.P_ILW3V3[z] 
  
  
  
  ;3 highest income quartiles                    
  percenttrips_2veh_HighInc = zi.1.P_IHW0V2[z] + zi.1.P_IHW1V2[z] + zi.1.P_IHW2V2[z] + zi.1.P_IHW3V2[z] +
                              zi.2.P_IHW0V2[z] + zi.2.P_IHW1V2[z] + zi.2.P_IHW2V2[z] + zi.2.P_IHW3V2[z] +
                              zi.3.P_IHW0V2[z] + zi.3.P_IHW1V2[z] + zi.3.P_IHW2V2[z] + zi.3.P_IHW3V2[z] +
                              zi.4.P_IHW0V2[z] + zi.4.P_IHW1V2[z] + zi.4.P_IHW2V2[z] + zi.4.P_IHW3V2[z] +
                              zi.5.P_IHW0V2[z] + zi.5.P_IHW1V2[z] + zi.5.P_IHW2V2[z] + zi.5.P_IHW3V2[z] +
                              zi.6.P_IHW0V2[z] + zi.6.P_IHW1V2[z] + zi.6.P_IHW2V2[z] + zi.6.P_IHW3V2[z] + 
                              zi.1.P_IHW0V3[z] + zi.1.P_IHW1V3[z] + zi.1.P_IHW2V3[z] + zi.1.P_IHW3V3[z] +
                              zi.2.P_IHW0V3[z] + zi.2.P_IHW1V3[z] + zi.2.P_IHW2V3[z] + zi.2.P_IHW3V3[z] +
                              zi.3.P_IHW0V3[z] + zi.3.P_IHW1V3[z] + zi.3.P_IHW2V3[z] + zi.3.P_IHW3V3[z] +
                              zi.4.P_IHW0V3[z] + zi.4.P_IHW1V3[z] + zi.4.P_IHW2V3[z] + zi.4.P_IHW3V3[z] +
                              zi.5.P_IHW0V3[z] + zi.5.P_IHW1V3[z] + zi.5.P_IHW2V3[z] + zi.5.P_IHW3V3[z] +
                              zi.6.P_IHW0V3[z] + zi.6.P_IHW1V3[z] + zi.6.P_IHW2V3[z] + zi.6.P_IHW3V3[z] 
   
   if (percenttrips_0veh_LowInc + percenttrips_0veh_HighInc > 0)
    perc_low_inc_0 = (percenttrips_0veh_LowInc/(percenttrips_0veh_LowInc + percenttrips_0veh_HighInc))
    perc_high_inc_0 = 1-perc_low_inc_0
   else 
    perc_low_inc_0 = 0
    perc_high_inc_0 = 0
   endif 
   
   if (percenttrips_1veh_LowInc + percenttrips_1veh_HighInc > 0)
    perc_low_inc_1 = (percenttrips_1veh_LowInc/(percenttrips_1veh_LowInc + percenttrips_1veh_HighInc))
    perc_high_inc_1 = 1-perc_low_inc_1
   else 
    perc_low_inc_1 = 0
    perc_high_inc_1 = 0
   endif 
   
   if (percenttrips_2veh_LowInc + percenttrips_2veh_HighInc > 0)
    perc_low_inc_2 = (percenttrips_2veh_LowInc/(percenttrips_2veh_LowInc + percenttrips_2veh_HighInc))
    perc_high_inc_2 = 1-perc_low_inc_2
   else 
    perc_low_inc_2 = 0
    perc_high_inc_2 = 0
   endif 
  
  
jloop
 IF (Z==@dummyzones@ || J==@dummyzones@)
  MW[11][j] = 0
  MW[12][j] = 0
  MW[13][j] = 0
  MW[14][j] = 0
  MW[15][j] = 0
  MW[16][j] = 0
 ELSE
   IF (@purpose@==2)
    MW[11][j] = percenttrips_0veh_LowInc*mi.2.ALL_@prd@
    MW[12][j] = percenttrips_0veh_HighInc*mi.2.ALL_@prd@
    MW[13][j] = percenttrips_1veh_LowInc*mi.2.ALL_@prd@
    MW[14][j] = percenttrips_1veh_HighInc*mi.2.ALL_@prd@
    MW[15][j] = percenttrips_2veh_LowInc*mi.2.ALL_@prd@
    MW[16][j] = percenttrips_2veh_HighInc*mi.2.ALL_@prd@
   ELSE ;if hbw
    MW[11][j] = perc_low_inc_0*mi.1.0veh_@prd@
    MW[12][j] = perc_high_inc_0*mi.1.0veh_@prd@
    MW[13][j] = perc_low_inc_1*mi.1.1veh_@prd@
    MW[14][j] = perc_high_inc_1*mi.1.1veh_@prd@
    MW[15][j] = perc_low_inc_2*mi.1.2veh_@prd@
    MW[16][j] = perc_high_inc_2*mi.1.2veh_@prd@
   ENDIF 
 ENDIF  
endjloop 
ENDRUN
  
endloop   ;purpose
ENDLOOP   ;period  




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Segment HBW-HBO Trips              ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN
	
	


*(DEL 09_Segmnt_PA_HBbyMC.txt)
