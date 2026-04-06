
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 11_MC_HBW_HBO_NHB_HBC.txt)



;get start time
ScriptStartTime = currenttime()




;=====================================================================================================
;PURPOSE:  Mode Choice, Segmented by auto ownership (HBW, HBO)
;=====================================================================================================
;copy ASC file to calibration folder (currently does not work when running with HailMary.bat)
;*COPY "coeffs\HBO_MC_constants_Ok_0.txt" "coeffs\calib_const\HBO_MC_constants_Ok_0.txt"
;*COPY "coeffs\HBO_MC_constants_Pk_0.txt" "coeffs\calib_const\HBO_MC_constants_Pk_0.txt"
;*COPY "coeffs\HBW_MC_constants_Ok_0.txt" "coeffs\calib_const\HBW_MC_constants_Ok_0.txt"
;*COPY "coeffs\HBW_MC_constants_Pk_0.txt" "coeffs\calib_const\HBW_MC_constants_Pk_0.txt"


;Cluster: distrubute MATRIX call onto processor 2
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2

    purpose = 1
    period  = 1
    purp    = 'HBW'
    prd     = 'Pk'

  RUN PGM=MATRIX   MSG='Mode Choice 11: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Pk.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Pk.mtx'
    FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Pk.mtx'
    FILEI MATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Ok.mtx'
    FILEI MATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Ok.mtx'
    FILEI MATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Ok.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j] + mi.2.1[j] + mi.2.2[j] + mi.3.1[j] + mi.3.2[j] + 
         mi.4.1[j] + mi.4.2[j] + mi.5.1[j] + mi.5.2[j] + mi.6.1[j] + mi.6.2[j]) > 0)
      MW[1][j]=1
     endif
    endjloop  
  ENDRUN  


    loop n=1,40     ; calibration loop 
                              ; BREAK statement after MATRIX call - see below
        n_1 = n-1 
           
        RUN PGM=MATRIX   MSG='Mode Choice 11: calculate trip mode choice - @purp@ @prd@ - iter @n@'
          
          ZONES   = @Usedzones@
          ZONEMSG = 10
          
          maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
          
          FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'        
          FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx' 
          FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
          FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
          ;*******************  COR didn't fit in the pattern, SEE BELOW
          FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
          FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
          FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
          FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
          FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
          FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
          FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
          
          FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_@prd@.mtx'
          FILEI MATI[12] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_@prd@.mtx'
          FILEI MATI[13] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_@prd@.mtx'
        
          FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
          FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
          
          FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
          
          ;*******************  COR didn't fit in the pattern
          FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
          FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
          FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              

          
        
          FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_0veh_@prd@_tmp.mtx', MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_1veh_@prd@_tmp.mtx', MO=41,42,45,46,47,49,50,55-56,98-99,57-62,134,135,43-44, 
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[3]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_2veh_@prd@_tmp.mtx', MO=71,72,75,76,77,79,80,85-86,100-101,87-92,139,140,73-74,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          
          FILEO MATO[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                  name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
          
          FILEO MATO[7]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_@prd@_tolltrips_income.mtx', MO=130-133,
                                          name=alone_low, shared_low, alone_high, shared_high
        
          ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        
          ;assign skims and mode choice data into working matrices
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_working_matrices.block'     
          
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
        
          if (i=1)  _count_calib=0   ;counter to check how many constants have been calibrated
          
          loop VEH=1,3,1   ;loop through vehicle ownership segments
             
            ;assign alternative specific constants for each vehicle ownership segment
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_asc.block' 
             
            loop INC=1,2,1   ;loop through income segments
           
              loop ACCESS=1,3,1    ;loop through access-to-transit segments
                
              ;based on market segment (vehicles/income) - assign a trip table        
              ;based on income - assign a cost coefficient
              READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_market_trips.block' 
             
                jloop
                    if (MW[2][j]>0)
        
                     if (i == @dummyzones@ | j == @dummyzones@)
                     else
        
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_utilities.block'  ;calculate utilities, relative probabilities, up the nesting structure
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure 
                     endif
                     
                     ;if (i=834 & j=449)
                     ;  READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_check_calculations.block'
                     ;endif
                    
                    endif
                  
                      
                endjloop  
              endloop   ;ACCESS
            endloop   ;INC
          endloop   ;VEH
             
          IF (I==@Usedzones@)
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_regional_shares.block'   ;computes the probs of each mode (in absolute terms) - for output
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_shares.block'      ;prints the regional shares
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_trips.block'       ;prints the regional trips
        
            IF (@calib@=1) 
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_update_constants.block'                                  ;adjust alternative specific bias constants
            ENDIF  
          ENDIF ;if i==usedzones
           
         ENDRUN
         
         ;check calibration
         n_HBW_Pk = n
         IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
         IF (MATRIX._count_calib == num_calib_HBW_HBO) BREAK  ;if calibrated, break out of calibration loop
    ENDLOOP ;n
    
;Cluster: end of group distributed to processor 2
EndDistributeMULTISTEP
   

;Cluster: distrubute MATRIX call onto processor 3
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=3

    purpose = 1
    period  = 2
    purp    = 'HBW'
    prd     = 'Ok'
   
  RUN PGM=MATRIX   MSG='Mode Choice 11: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Pk.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Pk.mtx'
    FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Pk.mtx'
    FILEI MATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Ok.mtx'
    FILEI MATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Ok.mtx'
    FILEI MATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Ok.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
   
    jloop
     if((mi.1.1[j] + mi.1.2[j] + mi.2.1[j] + mi.2.2[j] + mi.3.1[j] + mi.3.2[j] + 
         mi.4.1[j] + mi.4.2[j] + mi.5.1[j] + mi.5.2[j] + mi.6.1[j] + mi.6.2[j]) > 0)
      MW[1][j]=1
     endif
    endjloop  
  ENDRUN  


    loop n=1,40    ; calibration loop - Set iters to 1 if not calibrating, 50 if calibrating
                              ; BREAK statement after MATRIX call - see below
        n_1 = n-1 
           
        RUN PGM=MATRIX   MSG='Mode Choice 11: calculate trip mode choice - @purp@ @prd@ - iter @n@'
          
          ZONES   = @Usedzones@
          ZONEMSG = 10
          
          maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
          
          FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'        
          FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx' 
          FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
          FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
          ;*******************  COR didn't fit in the pattern, SEE BELOW
          FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
          FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
          FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
          FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
          FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
          FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
          FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
          
          FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_@prd@.mtx'
          FILEI MATI[12] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_@prd@.mtx'
          FILEI MATI[13] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_@prd@.mtx'
        
          FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
          FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
          
          FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
          
          ;*******************  COR didn't fit in the pattern
          FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
          FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
          FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              

          
        
          FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_0veh_@prd@_tmp.mtx', MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_1veh_@prd@_tmp.mtx', MO=41,42,45,46,47,49,50,55-56,98-99,57-62,134,135,43-44,  
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[3]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_2veh_@prd@_tmp.mtx', MO=71,72,75,76,77,79,80,85-86,100-101,87-92,139,140,73-74,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          
          FILEO MATO[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                  name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
          
          FILEO MATO[7]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_@prd@_tolltrips_income.mtx', MO=130-133,
                                          name=alone_low, shared_low, alone_high, shared_high
        
          ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        
          ;assign skims and mode choice data into working matrices
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_working_matrices.block'     
          
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
          
        
          if (i=1)  _count_calib=0   ;counter to check how many constants have been calibrated
          
          loop VEH=1,3,1   ;loop through vehicle ownership segments
             
            ;assign alternative specific constants for each vehicle ownership segment
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_asc.block' 
             
            loop INC=1,2,1   ;loop through income segments
           
              loop ACCESS=1,3,1    ;loop through access-to-transit segments
                
              ;based on market segment (vehicles/income) - assign a trip table        
              ;based on income - assign a cost coefficient
              READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_market_trips.block' 
             
                jloop
                    if (MW[2][j]>0)
        
                     if (i == @dummyzones@ | j == @dummyzones@)
                     else
        
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_utilities.block'  ;calculate utilities, relative probabilities, up the nesting structure
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure 
                     endif
                     
                     ;if (i=834 & j=449)
                     ;  READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_check_calculations.block'
                     ;endif
                    
                    endif
                  
                endjloop  
              endloop   ;ACCESS
            endloop   ;INC
          endloop   ;VEH
             
          IF (I==@Usedzones@)
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_regional_shares.block'   ;computes the probs of each mode (in absolute terms) - for output
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_shares.block'      ;prints the regional shares
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_trips.block'       ;prints the regional trips
        
            IF (@calib@=1) 
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_update_constants.block'                                  ;adjust alternative specific bias constants
            ENDIF  
          ENDIF ;if i==usedzones
           
         ENDRUN
         
         ;check calibration
         n_HBW_Ok = n
         IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
         IF (MATRIX._count_calib == num_calib_HBW_HBO) BREAK  ;if calibrated, break out of calibration loop
    ENDLOOP ;n
    
;Cluster: end of group distributed to processor 3
EndDistributeMULTISTEP
   

;Cluster: distrubute MATRIX call onto processor 4
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=4
    purpose  = 2
    period   = 1
    purp     = 'HBO'
    prd      = 'Pk'

  RUN PGM=MATRIX   MSG='Mode Choice 11: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Pk.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Pk.mtx'
    FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Pk.mtx'
    FILEI MATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Ok.mtx'
    FILEI MATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Ok.mtx'
    FILEI MATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Ok.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j] + mi.2.1[j] + mi.2.2[j] + mi.3.1[j] + mi.3.2[j] + 
         mi.4.1[j] + mi.4.2[j] + mi.5.1[j] + mi.5.2[j] + mi.6.1[j] + mi.6.2[j]) > 0)
      MW[1][j]=1
     endif
    endjloop  
  ENDRUN  


    loop n=1,40    ; calibration loop - Set iters to 1 if not calibrating, 50 if calibrating
                              ; BREAK statement after MATRIX call - see below
        n_1 = n-1 
           
        RUN PGM=MATRIX   MSG='Mode Choice 11: calculate trip mode choice - @purp@ @prd@ - iter @n@'
          
          ZONES   = @Usedzones@
          ZONEMSG = 10
          
          maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
          FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'        
          FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx' 
          FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
          FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
          ;*******************  COR didn't fit in the pattern, SEE BELOW
          FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
          FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
          FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
          FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
          FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
          FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
          FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
          
          FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_@prd@.mtx'
          FILEI MATI[12] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_@prd@.mtx'
          FILEI MATI[13] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_@prd@.mtx'
        
          FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
          FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
          
          FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
          
          ;*******************  COR didn't fit in the pattern
          FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
          FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
          FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              
          

          
        
          FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_0veh_@prd@_tmp.mtx', MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_1veh_@prd@_tmp.mtx', MO=41,42,45,46,47,49,50,55-56,98-99,57-62,134,135,43-44, 
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[3]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_2veh_@prd@_tmp.mtx', MO=71,72,75,76,77,79,80,85-86,100-101,87-92,139,140,73-74,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          
          FILEO MATO[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                  name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
          
          FILEO MATO[7]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_@prd@_tolltrips_income.mtx', MO=130-133,
                                          name=alone_low, shared_low, alone_high, shared_high
        
          ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        
          ;assign skims and mode choice data into working matrices
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_working_matrices.block'     
          
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
          
        
          if (i=1)  _count_calib=0   ;counter to check how many constants have been calibrated
          
          loop VEH=1,3,1   ;loop through vehicle ownership segments
             
            ;assign alternative specific constants for each vehicle ownership segment
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_asc.block' 
             
            loop INC=1,2,1   ;loop through income segments
           
              loop ACCESS=1,3,1    ;loop through access-to-transit segments
                
              ;based on market segment (vehicles/income) - assign a trip table        
              ;based on income - assign a cost coefficient
              READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_market_trips.block' 
             
                jloop
                    if (MW[2][j]>0)
        
                     if (i == @dummyzones@ | j == @dummyzones@)
                     else
        
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_utilities.block'  ;calculate utilities, relative probabilities, up the nesting structure
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure 
                     endif
                     
                     ;if (i=834 & j=449)
                     ;  READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_check_calculations.block'
                     ;endif
                    
                    endif
                      
                endjloop  
              endloop   ;ACCESS
            endloop   ;INC
          endloop   ;VEH
             
          IF (I==@Usedzones@)
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_regional_shares.block'   ;computes the probs of each mode (in absolute terms) - for output
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_shares.block'      ;prints the regional shares
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_trips.block'       ;prints the regional trips
        
            IF (@calib@=1) 
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_update_constants.block'                                  ;adjust alternative specific bias constants
            ENDIF  
          ENDIF ;if i==usedzones
           
         ENDRUN
         
         ;check calibration
         n_HBO_Pk = n
         IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
         IF (MATRIX._count_calib == num_calib_HBW_HBO) BREAK  ;if calibrated, break out of calibration loop
    ENDLOOP ;n
    
;Cluster: end of group distributed to processor 4
EndDistributeMULTISTEP


;Cluster: distrubute MATRIX call onto processor 5
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=5

    purpose  = 2
    period   = 2
    purp     = 'HBO'
    prd      = 'Ok'
   
  RUN PGM=MATRIX   MSG='Mode Choice 11: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Pk.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Pk.mtx'
    FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Pk.mtx'
    FILEI MATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_Ok.mtx'
    FILEI MATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_Ok.mtx'
    FILEI MATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_Ok.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j] + mi.2.1[j] + mi.2.2[j] + mi.3.1[j] + mi.3.2[j] + 
         mi.4.1[j] + mi.4.2[j] + mi.5.1[j] + mi.5.2[j] + mi.6.1[j] + mi.6.2[j]) > 0)
      MW[1][j]=1
     endif
    endjloop  
  ENDRUN  


    loop n=1,40    ; calibration loop - Set iters to 1 if not calibrating, 50 if calibrating
                              ; BREAK statement after MATRIX call - see below
        n_1 = n-1 
           
        RUN PGM=MATRIX   MSG='Mode Choice 11: calculate trip mode choice - @purp@ @prd@ - iter @n@'
          zones=@Usedzones@
          maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
          FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'        
          FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx' 
          FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
          FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
          ;*******************  COR didn't fit in the pattern, SEE BELOW
          FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
          FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
          FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
          FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
          FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
          FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
          FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
          
          FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_0veh_@prd@.mtx'
          FILEI MATI[12] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_1veh_@prd@.mtx'
          FILEI MATI[13] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_2veh_@prd@.mtx'
        
          FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
          FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
          
          FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
          
          ;*******************  COR didn't fit in the pattern
          FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
          FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
          FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              
          

          
        
          FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_0veh_@prd@_tmp.mtx', MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[2]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_1veh_@prd@_tmp.mtx', MO=41,42,45,46,47,49,50,55-56,98-99,57-62,134,135,43-44, 
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          FILEO MATO[3]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_2veh_@prd@_tmp.mtx', MO=71,72,75,76,77,79,80,85-86,100-101,87-92,139,140,73-74,
                                                      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                      wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk,bike
          
          FILEO MATO[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                  name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
          
          FILEO MATO[7]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_@prd@_tolltrips_income.mtx', MO=130-133,
                                          name=alone_low, shared_low, alone_high, shared_high
        
          ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        
          ;assign skims and mode choice data into working matrices
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_working_matrices.block'     
          
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
          
        
          if (i=1)  _count_calib=0   ;counter to check how many constants have been calibrated
          
          loop VEH=1,3,1   ;loop through vehicle ownership segments
             
            ;assign alternative specific constants for each vehicle ownership segment
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_asc.block' 
             
            loop INC=1,2,1   ;loop through income segments
           
              loop ACCESS=1,3,1    ;loop through access-to-transit segments
                
              ;based on market segment (vehicles/income) - assign a trip table        
              ;based on income - assign a cost coefficient
              READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_market_trips.block' 
             
                jloop
                    if (MW[2][j]>0)
        
                     if (i == @dummyzones@ | j == @dummyzones@)
                     else
        
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_utilities.block'  ;calculate utilities, relative probabilities, up the nesting structure
                      READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure 
                     endif
                     
                     ;if (i=834 & j=449)
                     ;  READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_check_calculations.block'
                     ;endif
                    
                    endif
                      
                endjloop  
              endloop   ;ACCESS
            endloop   ;INC
          endloop   ;VEH
             
          IF (I==@Usedzones@)
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_regional_shares.block'   ;computes the probs of each mode (in absolute terms) - for output
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_shares.block'      ;prints the regional shares
            READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_print_trips.block'       ;prints the regional trips
        
            IF (@calib@=1) 
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
              READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\HBW_HBO_update_constants.block'                                  ;adjust alternative specific bias constants
            ENDIF  
          ENDIF ;if i==usedzones
           
         ENDRUN
         
         ;check calibration
         n_HBO_Ok = n
         IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
         IF (MATRIX._count_calib == num_calib_HBW_HBO) BREAK  ;if calibrated, break out of calibration loop
    ENDLOOP ;n
    
;Cluster: end of group distributed to processor 5
EndDistributeMULTISTEP


;=====================================================================================================
;PURPOSE:  Mode Choice, no auto segmentation (NHB and HBC)
;=====================================================================================================
;copy ASC file to calibration folder (currently does not work when running with HailMary.bat)
;*COPY "coeffs\HBC_MC_constants_Pk_0.txt" "coeffs\calib_const\HBC_MC_constants_Pk_0.txt"
;*COPY "coeffs\NHB_MC_constants_Ok_0.txt" "coeffs\calib_const\NHB_MC_constants_Ok_0.txt"
;*COPY "coeffs\NHB_MC_constants_Pk_0.txt" "coeffs\calib_const\NHB_MC_constants_Pk_0.txt"


;Cluster: distrubute MATRIX call onto processor 6
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=6

    ;HBC does not have Ok trips, but fill in zeros anyway so as not to foul up the structure in OD construction
    purpose = 2
    period  = 2
    purp    = 'HBC'
    prd     = 'Ok'

  RUN PGM=MATRIX   MSG='Mode Choice 12: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j]) > 0)
      MW[1][j]=1 
     endif 
    endjloop 
  ENDRUN 
    
    RUN PGM=MATRIX   MSG='Mode Choice 12: calculate trip mode choice - @purp@ @prd@ - iter @n@'
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
        
        FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_allsegs_@prd@_tmp.mtx',  MO=1-19,
                                                 name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                    wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT
                
      FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=1-8,
                name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
    
      MW[1]  = 0
      MW[2]  = 0
      MW[3]  = 0
      MW[4]  = 0
      MW[5]  = 0
      MW[6]  = 0
      MW[7]  = 0
      MW[8]  = 0
      MW[9]  = 0
      MW[10] = 0
      MW[11] = 0
      MW[12] = 0
      MW[13] = 0
      MW[14] = 0
      MW[15] = 0
      MW[16] = 0
      MW[17] = 0
      MW[18] = 0
      MW[19] = 0
    ENDRUN

    
;Cluster: end of group distributed to processor 6
EndDistributeMULTISTEP


;Cluster: distrubute MATRIX call onto processor 7
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=7

    purpose = 2
    period  = 1
    purp    = 'HBC'
    prd     = 'Pk'

  RUN PGM=MATRIX   MSG='Mode Choice 12: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j]) > 0)
      MW[1][j]=1 
     endif 
    endjloop 
  ENDRUN  
    
    
    loop n=1,25    ; calibration loop
                                ; BREAK statement after MATRIX call - see below
      n_1 = n-1 
         
      RUN PGM=MATRIX   MSG='Mode Choice 12: calculate trip mode choice - @purp@ @prd@ - iter @n@'
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
    
        FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
        FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
        FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
        ;*******************  COR didn't fit in the pattern, SEE BELOW
        FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
        FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
        FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
        FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
        FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
        FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
        FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
        FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx'
    
        FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
        FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
       
        FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
        
        ;*******************  COR didn't fit in the pattern, so rather than make the pattern fit, we'll just live with it.
        FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
        FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
        FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
        
        
        FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_allsegs_@prd@_tmp.mtx',  MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                 name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                    wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk, bike
                                                    
        FILEO MATO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
                                
        ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
    
        READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_working_matrices.block'       ;assign skims and mode choice data into working matrices
        
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
        
        if (i=1) 
          _count_calib=0   ;counter to check how many constants have been calibrated
          
        endif
        
        if (@purpose@==1) 
         MW[1] = MI.1.ALL_@prd@    ;person trips by period
        elseif (@purpose@==2) 
         MW[1] = MI.1.ALL_Pk + MI.1.ALL_Ok
        endif 
      
        loop ACCESS=1,3,1    ;loop through access-to-transit segments
          ;multiply trip table for vehicles/income segment by % in access segment
          ;multiply by 100 to minimize rounding error in output matrices
           IF (ACCESS==1)   ;can walk-to-transit
             MW[2] = MW[1] * mi.11.pctwalk * 100
           ELSEIF (ACCESS==2)   ;must drive-to-transit
             MW[2] = MW[1] * mi.11.pctdrive * 100
           ELSEIF (ACCESS==3)   ;no access-to-transit
             MW[2] = MW[1] * mi.11.pctnone * 100 
           ENDIF
                      
           jloop
             if (MW[2][j]>0)  ;if there are trips
               if (i == @dummyzones@ | j == @dummyzones@)
               else
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_utilities.block'   ;calculate utilities, relative probabilities, up the nesting structure
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure
               endif
             endif
             
           endjloop  
         endloop  ;ACCESS
    
         IF (I==@Usedzones@)
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_regional_shares.block '  ;computes the probs of each mode (in absolute terms) - for output
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_shares.block'      ;prints the regional shares
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_trips.block'      ;prints the regional trips
    
    
           IF (@calib@=1) 
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_update_constants.block'    ;adjust alternative specific bias coefficients
           ENDIF  
         ENDIF ;if i==usedzones
      ENDRUN
          
      ;check calibration
      n_HBC_Pk = n
      IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
      IF (MATRIX._count_calib == num_calib_NHB_HBC) BREAK  ;if calibrated, break out of calibration loop
    endloop ;n

   
;Cluster: end of group distributed to processor 7
EndDistributeMULTISTEP
   

;Cluster: distrubute MATRIX call onto processor 8
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=8

    purpose = 1
    period  = 1
    purp    = 'NHB'
    prd     = 'Pk'

  RUN PGM=MATRIX   MSG='Mode Choice 12: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j]) > 0)
      MW[1][j]=1 
     endif 
    endjloop 
  ENDRUN  
    
    
    loop n=1,40    ; calibration loop - Set iters to 1 if not calibrating, 50 if calibrating
                                ; BREAK statement after MATRIX call - see below
      n_1 = n-1 
         
      RUN PGM=MATRIX   MSG='Mode Choice 12: calculate trip mode choice - @purp@ @prd@ - iter @n@'
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
    
        FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
        FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
        FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
        ;*******************  COR didn't fit in the pattern, SEE BELOW
        FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
        FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
        FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
        FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
        FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
        FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
        FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
        FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx'
    
        FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
        FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
       
        FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
        
        ;*******************  COR didn't fit in the pattern, so rather than make the pattern fit, we'll just live with it.
        FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
        FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
        FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
        
        
        FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_allsegs_@prd@_tmp.mtx',  MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                 name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                    wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk, bike
                                                    
        FILEO MATO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
                                
        ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
    
        READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_working_matrices.block'       ;assign skims and mode choice data into working matrices
        
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
        
        if (i=1) 
          _count_calib=0   ;counter to check how many constants have been calibrated
          
        endif
        
        if (@purpose@==1) 
         MW[1] = MI.1.ALL_@prd@    ;person trips by period
        elseif (@purpose@==2) 
         MW[1] = MI.1.ALL_Pk + MI.1.ALL_Ok
        endif 
      
        loop ACCESS=1,3,1    ;loop through access-to-transit segments
          ;multiply trip table for vehicles/income segment by % in access segment
          ;multiply by 100 to minimize rounding error in output matrices
           IF (ACCESS==1)   ;can walk-to-transit
             MW[2] = MW[1] * mi.11.pctwalk * 100
           ELSEIF (ACCESS==2)   ;must drive-to-transit
             MW[2] = MW[1] * mi.11.pctdrive * 100
           ELSEIF (ACCESS==3)   ;no access-to-transit
             MW[2] = MW[1] * mi.11.pctnone * 100 
           ENDIF
                      
           jloop
             if (MW[2][j]>0)  ;if there are trips
               if (i == @dummyzones@ | j == @dummyzones@)
               else
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_utilities.block'   ;calculate utilities, relative probabilities, up the nesting structure
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure
               endif
             endif
             
           endjloop  
         endloop  ;ACCESS
    
         IF (I==@Usedzones@)
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_regional_shares.block '  ;computes the probs of each mode (in absolute terms) - for output
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_shares.block'      ;prints the regional shares
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_trips.block'      ;prints the regional trips
    
    
           IF (@calib@=1) 
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_update_constants.block'    ;adjust alternative specific bias coefficients
           ENDIF  
         ENDIF ;if i==usedzones
      ENDRUN
         
      ;check calibration
      n_NHB_Pk = n
      IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
      IF (MATRIX._count_calib == num_calib_NHB_HBC) BREAK  ;if calibrated, break out of calibration loop
    endloop ;n
    
;Cluster: end of group distributed to processor 8
EndDistributeMULTISTEP
    
    
;Cluster: keep processing on processor 1 (Main)

    purpose = 1
    period  = 2
    purp    = 'NHB'
    prd     = 'Ok'

  RUN PGM=MATRIX   MSG='Mode Choice 12: identify cells with trips - @purp@ @prd@'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx', MO=1
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 100
    
    jloop
     if((mi.1.1[j] + mi.1.2[j]) > 0)
      MW[1][j]=1 
     endif 
    endjloop 
  ENDRUN  
    
    
    loop n=1,40    ; calibration loop - Set iters to 1 if not calibrating, 50 if calibrating
                                ; BREAK statement after MATRIX call - see below
      n_1 = n-1 
         
      RUN PGM=MATRIX   MSG='Mode Choice 12: calculate trip mode choice - @purp@ @prd@ - iter @n@'
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        maxmw=500    ;resets the maximimum number of working matrices from 200 to 500
    
        FILEI MATI[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_ByPeriod.mtx'
        FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_@prd@.mtx'
        FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_@prd@.mtx'
        ;*******************  COR didn't fit in the pattern, SEE BELOW
        FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_@prd@.mtx'
        FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_@prd@.mtx'
        FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_@prd@.mtx'
        FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_@prd@.mtx'
        FILEI MATI[8]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_@prd@.mtx'
        FILEI MATI[9]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_@prd@.mtx'
        FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_@prd@.mtx'
        FILEI MATI[11] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\access_to_transit_markets.mtx'
    
        FILEI MATI[14]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_@prd@.mtx'
        FILEI MATI[15]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_@prd@.mtx'
       
        FILEI MATI[17] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_@purp@_trips.mtx'
        
        ;*******************  COR didn't fit in the pattern, so rather than make the pattern fit, we'll just live with it.
        FILEI MATI[18] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_@prd@.mtx'
        FILEI MATI[19] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_@prd@.mtx'
        FILEI MATI[20] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\direct_walk_premium_@prd@.mtx'
              
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
        
        
        FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\@purp@_trips_allsegs_@prd@_tmp.mtx',  MO=11,12,15,16,17,19,20,25-26,96-97,27-32,112,113,13-14,
                                                 name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
                                                    wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wBRT, dBRT, walk, bike
                                                    
        FILEO MATO[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@purp@_trips_@prd@_auto_managedlanes.mtx', MO=63-70, 
                                name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
                                
        ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
    
        READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_working_matrices.block'       ;assign skims and mode choice data into working matrices
        
          ;read mode choice model coefficients and nesting constants  
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_coefficients.txt'
          READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\1Nesting_Constants.txt'
          
          ;read in mode choice alternative specific constants
          if (@calib@=1)
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_const\@purp@_MC_constants_@prd@_@n_1@.txt'      
          else
              READ FILE = '@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\@purp@_MC_constants_@prd@_0.txt'      
          endif
        
        if (i=1) 
          _count_calib=0   ;counter to check how many constants have been calibrated
          
        endif
        
        if (@purpose@==1) 
         MW[1] = MI.1.ALL_@prd@    ;person trips by period
        elseif (@purpose@==2) 
         MW[1] = MI.1.ALL_Pk + MI.1.ALL_Ok
        endif 
      
        loop ACCESS=1,3,1    ;loop through access-to-transit segments
          ;multiply trip table for vehicles/income segment by % in access segment
          ;multiply by 100 to minimize rounding error in output matrices
           IF (ACCESS==1)   ;can walk-to-transit
             MW[2] = MW[1] * mi.11.pctwalk * 100
           ELSEIF (ACCESS==2)   ;must drive-to-transit
             MW[2] = MW[1] * mi.11.pctdrive * 100
           ELSEIF (ACCESS==3)   ;no access-to-transit
             MW[2] = MW[1] * mi.11.pctnone * 100 
           ENDIF
                      
           jloop
             if (MW[2][j]>0)  ;if there are trips
               if (i == @dummyzones@ | j == @dummyzones@)
               else
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_utilities.block'   ;calculate utilities, relative probabilities, up the nesting structure
                READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_calculate_trips.block'    ;calculate trips by segment, working down the nesting structure
               endif
             endif
             
           endjloop  
         endloop  ;ACCESS
    
         IF (I==@Usedzones@)
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_regional_shares.block '  ;computes the probs of each mode (in absolute terms) - for output
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_shares.block'      ;prints the regional shares
           READ FILE='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_print_trips.block'      ;prints the regional trips
    
    
           IF (@calib@=1) 
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\coeffs\calib_modeshare_targets\calib_target_@purp@_@prd@.txt'          ;read in target shares by mode, by segment
             READ file='@ParentDir@2_ModelScripts\4_ModeChoice\block\NHB_HBC_update_constants.block'    ;adjust alternative specific bias coefficients
           ENDIF  
         ENDIF ;if i==usedzones
      ENDRUN
         
      ;check calibration
      n_NHB_Ok = n
      IF (calib==0) BREAK  ;if not calibrating, don't loop through calibration routine
      IF (MATRIX._count_calib == num_calib_NHB_HBC) BREAK  ;if calibrated, break out of calibration loop
    endloop ;n

;Cluster: bring together all distributed steps before continuing
WAIT4FILES, 
    FILES="ClusterNodeID2.Script.End", 
    FILES="ClusterNodeID3.Script.End", 
    FILES="ClusterNodeID4.Script.End", 
    FILES="ClusterNodeID5.Script.End", 
    FILES="ClusterNodeID6.Script.End", 
    FILES="ClusterNodeID7.Script.End", 
    FILES="ClusterNodeID8.Script.End", 
    CheckReturnCode=T



LOOP periodpkok = 1,2
 if     (periodpkok=1) 
   prd  = 'Pk'
 elseif (periodpkok=2) 
   prd = 'Ok'
 endif

RUN PGM=MATRIX   MSG='Mode Choice 13: summarize mode choice by purpose - @prd@'
  FILEI  MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBW_trips_0veh_@prd@_tmp.mtx'
  FILEI  MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBW_trips_1veh_@prd@_tmp.mtx'
  FILEI  MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBW_trips_2veh_@prd@_tmp.mtx'
  
  FILEI  MATI[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBC_trips_allsegs_Pk_tmp.mtx'
  
  FILEI  MATI[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBO_trips_0veh_@prd@_tmp.mtx'
  FILEI  MATI[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBO_trips_1veh_@prd@_tmp.mtx'
  FILEI  MATI[7] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HBO_trips_2veh_@prd@_tmp.mtx'
  
  FILEI  MATI[8] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\NHB_trips_allsegs_@prd@_tmp.mtx'    
  
  ;Note:  Transit is divided among many types, the further divided between many i-j pairs.
  ;The matrix storage precision is only two decimals, so unless trips are stored at X100, 
  ;many trips will be lost.  The most extreme example is drive to express.  In this particular run
  ;the matrix at X100 = 183100 (1831 total trips), but if the matrix is divided by 100,
  ;it will total only 865! A major loss in this category!
  
  ;The Route Summary post processor has been modified to divide the total boardings on each
  ;route by 100 to better display the results.

  FILEO  MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_@prd@.mtx',
      MO=101-123, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO  MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_@prd@.mtx',
      MO=201-223, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO  MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_@prd@.mtx',
      MO=301-323, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO  MATO[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_@prd@.mtx',
      MO=401-423, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO  MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx',
      MO=501-523, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
  ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
  
  ;HBW
  MW[101] = mi.1.motor    + mi.2.motor    + mi.3.motor 
  MW[102] = mi.1.nonmotor + mi.2.nonmotor + mi.3.nonmotor 
  MW[103] = mi.1.transit  + mi.2.transit  + mi.3.transit 
  MW[104] = mi.1.auto     + mi.2.auto     + mi.3.auto  
  MW[105] = mi.1.DA       + mi.2.DA       + mi.3.DA
  MW[106] = mi.1.SR2      + mi.2.SR2      + mi.3.SR2 
  MW[107] = mi.1.SR3p     + mi.2.SR3p     + mi.3.SR3p
  MW[108] = mi.1.wLCL     + mi.2.wLCL     + mi.3.wLCL  
  MW[109] = mi.1.dLCL     + mi.2.dLCL     + mi.3.dLCL  
  MW[110] = mi.1.wCOR     + mi.2.wCOR     + mi.3.wCOR  
  MW[111] = mi.1.dCOR     + mi.2.dCOR     + mi.3.dCOR 
  MW[112] = mi.1.wEXP     + mi.2.wEXP     + mi.3.wEXP 
  MW[113] = mi.1.dEXP     + mi.2.dEXP     + mi.3.dEXP 
  MW[114] = mi.1.wLRT     + mi.2.wLRT     + mi.3.wLRT 
  MW[115] = mi.1.dLRT     + mi.2.dLRT     + mi.3.dLRT 
  MW[116] = mi.1.wCRT     + mi.2.wCRT     + mi.3.wCRT 
  MW[117] = mi.1.dCRT     + mi.2.dCRT     + mi.3.dCRT    

  MW[120] = mi.1.wBRT   + mi.2.wBRT   + mi.3.wBRT
  MW[121] = mi.1.dBRT   + mi.2.dBRT   + mi.3.dBRT
  MW[122] = mi.1.walk     + mi.2.walk     + mi.3.walk  
  MW[123] = mi.1.bike     + mi.2.bike     + mi.3.bike  

  MW[118] = MW[108]+MW[110]+MW[112]+MW[114]+MW[116]+MW[120]   ;Total wTransit
  MW[119] = MW[109]+MW[111]+MW[113]+MW[115]+MW[117]+MW[121]   ;Total dTransit

  ;HBC
 IF (@periodpkok@ == 1)
  MW[201] = mi.4.motor   
  MW[202] = mi.4.nonmotor
  MW[203] = mi.4.transit 
  MW[204] = mi.4.auto    
  MW[205] = mi.4.DA      
  MW[206] = mi.4.SR2     
  MW[207] = mi.4.SR3p    
  MW[208] = mi.4.wLCL    
  MW[209] = mi.4.dLCL    
  MW[210] = mi.4.wCOR    
  MW[211] = mi.4.dCOR    
  MW[212] = mi.4.wEXP    
  MW[213] = mi.4.dEXP    
  MW[214] = mi.4.wLRT    
  MW[215] = mi.4.dLRT    
  MW[216] = mi.4.wCRT    
  MW[217] = mi.4.dCRT    
  
  MW[220] = mi.4.wBRT  
  MW[221] = mi.4.dBRT  
  MW[222] = mi.4.walk    
  MW[223] = mi.4.bike    

  MW[218] = MW[208]+MW[210]+MW[212]+MW[214]+MW[216]+MW[220]   ;Total wTransit
  MW[219] = MW[209]+MW[211]+MW[213]+MW[215]+MW[217]+MW[221]   ;Total dTransit
 ELSE
  MW[201] = 0
  MW[202] = 0
  MW[203] = 0
  MW[204] = 0
  MW[205] = 0
  MW[206] = 0
  MW[207] = 0
  MW[208] = 0
  MW[209] = 0
  MW[210] = 0
  MW[211] = 0
  MW[212] = 0
  MW[213] = 0
  MW[214] = 0
  MW[215] = 0
  MW[216] = 0
  MW[217] = 0
  MW[218] = 0
  MW[219] = 0
  MW[220] = 0
  MW[221] = 0
  MW[222] = 0
  MW[223] = 0

 ENDIF
    
  ;HBO
  MW[301] = mi.5.motor    + mi.6.motor    + mi.7.motor 
  MW[302] = mi.5.nonmotor + mi.6.nonmotor + mi.7.nonmotor 
  MW[303] = mi.5.transit  + mi.6.transit  + mi.7.transit 
  MW[304] = mi.5.auto     + mi.6.auto     + mi.7.auto  
  MW[305] = mi.5.DA       + mi.6.DA       + mi.7.DA
  MW[306] = mi.5.SR2      + mi.6.SR2      + mi.7.SR2 
  MW[307] = mi.5.SR3p     + mi.6.SR3p     + mi.7.SR3p
  MW[308] = mi.5.wLCL     + mi.6.wLCL     + mi.7.wLCL  
  MW[309] = mi.5.dLCL     + mi.6.dLCL     + mi.7.dLCL  
  MW[310] = mi.5.wCOR     + mi.6.wCOR     + mi.7.wCOR  
  MW[311] = mi.5.dCOR     + mi.6.dCOR     + mi.7.dCOR 
  MW[312] = mi.5.wEXP     + mi.6.wEXP     + mi.7.wEXP 
  MW[313] = mi.5.dEXP     + mi.6.dEXP     + mi.7.dEXP 
  MW[314] = mi.5.wLRT     + mi.6.wLRT     + mi.7.wLRT 
  MW[315] = mi.5.dLRT     + mi.6.dLRT     + mi.7.dLRT 
  MW[316] = mi.5.wCRT     + mi.6.wCRT     + mi.7.wCRT 
  MW[317] = mi.5.dCRT     + mi.6.dCRT     + mi.7.dCRT    
  
  MW[320] = mi.5.wBRT   + mi.6.wBRT   + mi.7.wBRT
  MW[321] = mi.5.dBRT   + mi.6.dBRT   + mi.7.dBRT
  MW[322] = mi.5.walk     + mi.6.walk     + mi.7.walk  
  MW[323] = mi.5.bike     + mi.6.bike     + mi.7.bike  

  MW[318] = MW[308]+MW[310]+MW[312]+MW[314]+MW[316]+MW[320]   ;Total wTransit
  MW[319] = MW[309]+MW[311]+MW[313]+MW[315]+MW[317]+MW[321]   ;Total dTransit
    
  ;NHB
  MW[401] = mi.8.motor   
  MW[402] = mi.8.nonmotor
  MW[403] = mi.8.transit 
  MW[404] = mi.8.auto    
  MW[405] = mi.8.DA      
  MW[406] = mi.8.SR2     
  MW[407] = mi.8.SR3p    
  MW[408] = mi.8.wLCL    
  MW[409] = mi.8.dLCL    
  MW[410] = mi.8.wCOR    
  MW[411] = mi.8.dCOR    
  MW[412] = mi.8.wEXP    
  MW[413] = mi.8.dEXP    
  MW[414] = mi.8.wLRT    
  MW[415] = mi.8.dLRT    
  MW[416] = mi.8.wCRT    
  MW[417] = mi.8.dCRT    
  
  MW[420] = mi.8.wBRT  
  MW[421] = mi.8.dBRT  
  MW[422] = mi.8.walk    
  MW[423] = mi.8.bike    

  MW[418] = MW[408]+MW[410]+MW[412]+MW[414]+MW[416]+MW[420]   ;Total wTransit
  MW[419] = MW[409]+MW[411]+MW[413]+MW[415]+MW[417]+MW[421]   ;Total dTransit
  
  ;ALLTOT 
  MW[501] = MW[101] + MW[201] + MW[301] + MW[401]
  MW[502] = MW[102] + MW[202] + MW[302] + MW[402]
  MW[503] = MW[103] + MW[203] + MW[303] + MW[403]
  MW[504] = MW[104] + MW[204] + MW[304] + MW[404]
  MW[505] = MW[105] + MW[205] + MW[305] + MW[405]
  MW[506] = MW[106] + MW[206] + MW[306] + MW[406]
  MW[507] = MW[107] + MW[207] + MW[307] + MW[407]
  MW[508] = MW[108] + MW[208] + MW[308] + MW[408]
  MW[509] = MW[109] + MW[209] + MW[309] + MW[409]
  MW[510] = MW[110] + MW[210] + MW[310] + MW[410]
  MW[511] = MW[111] + MW[211] + MW[311] + MW[411]
  MW[512] = MW[112] + MW[212] + MW[312] + MW[412]
  MW[513] = MW[113] + MW[213] + MW[313] + MW[413]
  MW[514] = MW[114] + MW[214] + MW[314] + MW[414]
  MW[515] = MW[115] + MW[215] + MW[315] + MW[415]
  MW[516] = MW[116] + MW[216] + MW[316] + MW[416]
  MW[517] = MW[117] + MW[217] + MW[317] + MW[417]
  MW[518] = MW[118] + MW[218] + MW[318] + MW[418]
  MW[519] = MW[119] + MW[219] + MW[319] + MW[419]
  MW[520] = MW[120] + MW[220] + MW[320] + MW[420]
  MW[521] = MW[121] + MW[221] + MW[321] + MW[421]
  MW[522] = MW[122] + MW[222] + MW[322] + MW[422]
  MW[523] = MW[123] + MW[223] + MW[323] + MW[423]

ENDRUN  

ENDLOOP


RUN PGM=MATRIX   MSG='Mode Choice 13: summarize mode choice by purpose - daily'
  FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Pk.mtx'
  FILEI MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Pk.mtx'
  FILEI MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Pk.mtx'
  FILEI MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Pk.mtx'
  
  FILEI MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_Ok.mtx'
 ;FILEI MATI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_Ok.mtx'
  FILEI MATI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_Ok.mtx'
  FILEI MATI[8] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_Ok.mtx'
  
  
  FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx',
      MO=101-123, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx',
      MO=201-223, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx',
      MO=301-323, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO MATO[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx',
      MO=401-423, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  
  FILEO MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx',
      MO=501-523, 
      name=motor,nonmotor,transit,auto,DA,SR2,SR3p,
           wLCL, dLCL, wCOR, dCOR, wEXP, dEXP, wLRT, dLRT, wCRT, dCRT, wTRN, dTRN, wBRT, dBRT, walk, bike
  

  ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
  
  ;HBW
  MW[101] = mi.1.motor    + mi.5.motor   
  MW[102] = mi.1.nonmotor + mi.5.nonmotor
  MW[103] = mi.1.transit  + mi.5.transit 
  MW[104] = mi.1.auto     + mi.5.auto    
  MW[105] = mi.1.DA       + mi.5.DA      
  MW[106] = mi.1.SR2      + mi.5.SR2     
  MW[107] = mi.1.SR3p     + mi.5.SR3p    
  MW[108] = mi.1.wLCL     + mi.5.wLCL    
  MW[109] = mi.1.dLCL     + mi.5.dLCL    
  MW[110] = mi.1.wCOR     + mi.5.wCOR    
  MW[111] = mi.1.dCOR     + mi.5.dCOR    
  MW[112] = mi.1.wEXP     + mi.5.wEXP    
  MW[113] = mi.1.dEXP     + mi.5.dEXP    
  MW[114] = mi.1.wLRT     + mi.5.wLRT    
  MW[115] = mi.1.dLRT     + mi.5.dLRT    
  MW[116] = mi.1.wCRT     + mi.5.wCRT    
  MW[117] = mi.1.dCRT     + mi.5.dCRT    
  MW[118] = mi.1.wTRN     + mi.5.wTRN    
  MW[119] = mi.1.dTRN     + mi.5.dTRN    
  MW[120] = mi.1.wBRT   + mi.5.wBRT  
  MW[121] = mi.1.dBRT   + mi.5.dBRT  
  MW[122] = mi.1.walk     + mi.5.walk    
  MW[123] = mi.1.bike     + mi.5.bike    
  
  ;No off-pk for HBC  
  MW[201] = mi.2.motor   
  MW[202] = mi.2.nonmotor
  MW[203] = mi.2.transit 
  MW[204] = mi.2.auto    
  MW[205] = mi.2.DA      
  MW[206] = mi.2.SR2     
  MW[207] = mi.2.SR3p    
  MW[208] = mi.2.wLCL    
  MW[209] = mi.2.dLCL    
  MW[210] = mi.2.wCOR    
  MW[211] = mi.2.dCOR    
  MW[212] = mi.2.wEXP    
  MW[213] = mi.2.dEXP    
  MW[214] = mi.2.wLRT    
  MW[215] = mi.2.dLRT    
  MW[216] = mi.2.wCRT    
  MW[217] = mi.2.dCRT    
  MW[218] = mi.2.wTRN    
  MW[219] = mi.2.dTRN    
  MW[220] = mi.2.wBRT  
  MW[221] = mi.2.dBRT  
  MW[222] = mi.2.walk    
  MW[223] = mi.2.bike    
  
  ;HBO
  MW[301] = mi.3.motor    + mi.7.motor   
  MW[302] = mi.3.nonmotor + mi.7.nonmotor
  MW[303] = mi.3.transit  + mi.7.transit 
  MW[304] = mi.3.auto     + mi.7.auto    
  MW[305] = mi.3.DA       + mi.7.DA      
  MW[306] = mi.3.SR2      + mi.7.SR2     
  MW[307] = mi.3.SR3p     + mi.7.SR3p    
  MW[308] = mi.3.wLCL     + mi.7.wLCL    
  MW[309] = mi.3.dLCL     + mi.7.dLCL    
  MW[310] = mi.3.wCOR     + mi.7.wCOR    
  MW[311] = mi.3.dCOR     + mi.7.dCOR    
  MW[312] = mi.3.wEXP     + mi.7.wEXP    
  MW[313] = mi.3.dEXP     + mi.7.dEXP    
  MW[314] = mi.3.wLRT     + mi.7.wLRT    
  MW[315] = mi.3.dLRT     + mi.7.dLRT    
  MW[316] = mi.3.wCRT     + mi.7.wCRT    
  MW[317] = mi.3.dCRT     + mi.7.dCRT    
  MW[318] = mi.3.wTRN     + mi.7.wTRN    
  MW[319] = mi.3.dTRN     + mi.7.dTRN    
  MW[320] = mi.3.wBRT   + mi.7.wBRT  
  MW[321] = mi.3.dBRT   + mi.7.dBRT  
  MW[322] = mi.3.walk     + mi.7.walk    
  MW[323] = mi.3.bike     + mi.7.bike    
  
  ;NHB
  MW[401] = mi.4.motor    + mi.8.motor   
  MW[402] = mi.4.nonmotor + mi.8.nonmotor
  MW[403] = mi.4.transit  + mi.8.transit 
  MW[404] = mi.4.auto     + mi.8.auto    
  MW[405] = mi.4.DA       + mi.8.DA      
  MW[406] = mi.4.SR2      + mi.8.SR2     
  MW[407] = mi.4.SR3p     + mi.8.SR3p    
  MW[408] = mi.4.wLCL     + mi.8.wLCL    
  MW[409] = mi.4.dLCL     + mi.8.dLCL    
  MW[410] = mi.4.wCOR     + mi.8.wCOR    
  MW[411] = mi.4.dCOR     + mi.8.dCOR    
  MW[412] = mi.4.wEXP     + mi.8.wEXP    
  MW[413] = mi.4.dEXP     + mi.8.dEXP    
  MW[414] = mi.4.wLRT     + mi.8.wLRT    
  MW[415] = mi.4.dLRT     + mi.8.dLRT    
  MW[416] = mi.4.wCRT     + mi.8.wCRT    
  MW[417] = mi.4.dCRT     + mi.8.dCRT    
  MW[418] = mi.4.wTRN     + mi.8.wTRN    
  MW[419] = mi.4.dTRN     + mi.8.dTRN    
  MW[420] = mi.4.wBRT   + mi.8.wBRT  
  MW[421] = mi.4.dBRT   + mi.8.dBRT  
  MW[422] = mi.4.walk     + mi.8.walk    
  MW[423] = mi.4.bike     + mi.8.bike    
  
  ;ALLTOT 
  MW[501] = MW[101] + MW[201] + MW[301] + MW[401]
  MW[502] = MW[102] + MW[202] + MW[302] + MW[402]
  MW[503] = MW[103] + MW[203] + MW[303] + MW[403]
  MW[504] = MW[104] + MW[204] + MW[304] + MW[404]
  MW[505] = MW[105] + MW[205] + MW[305] + MW[405]
  MW[506] = MW[106] + MW[206] + MW[306] + MW[406]
  MW[507] = MW[107] + MW[207] + MW[307] + MW[407]
  MW[508] = MW[108] + MW[208] + MW[308] + MW[408]
  MW[509] = MW[109] + MW[209] + MW[309] + MW[409]
  MW[510] = MW[110] + MW[210] + MW[310] + MW[410]
  MW[511] = MW[111] + MW[211] + MW[311] + MW[411]
  MW[512] = MW[112] + MW[212] + MW[312] + MW[412]
  MW[513] = MW[113] + MW[213] + MW[313] + MW[413]
  MW[514] = MW[114] + MW[214] + MW[314] + MW[414]
  MW[515] = MW[115] + MW[215] + MW[315] + MW[415]
  MW[516] = MW[116] + MW[216] + MW[316] + MW[416]
  MW[517] = MW[117] + MW[217] + MW[317] + MW[417]
  MW[518] = MW[118] + MW[218] + MW[318] + MW[418]
  MW[519] = MW[119] + MW[219] + MW[319] + MW[419]
  MW[520] = MW[120] + MW[220] + MW[320] + MW[420]
  MW[521] = MW[121] + MW[221] + MW[321] + MW[421]
  MW[522] = MW[122] + MW[222] + MW[322] + MW[422]
  MW[523] = MW[123] + MW[223] + MW[323] + MW[423]
   
  HBWMotor    = HBWMotor    + rowsum(101) / 100
  HBWnonmotor = HBWnonmotor + rowsum(102) / 100
  HBWtransit  = HBWtransit  + rowsum(103) / 100
  HBWauto     = HBWauto     + rowsum(104) / 100
  
  HBWvehtrips = HBWvehtrips + rowsum(105) / 100      +                   ;DA
                              rowsum(106) / 100 / 2  +                   ;SR2
                              rowsum(107) / 100 / @VehOcc_3p_HBW@       ;SR3+
  
  
  HBCMotor    = HBCMotor    + rowsum(201) / 100   
  HBCnonmotor = HBCnonmotor + rowsum(202) / 100   
  HBCtransit  = HBCtransit  + rowsum(203) / 100   
  HBCauto     = HBCauto     + rowsum(204) / 100   
  
  HBCvehtrips = HBCvehtrips + rowsum(205) / 100       +                   ;DA
                              rowsum(206) / 100 / 2  +                   ;SR2
                              rowsum(207) / 100 / @VehOcc_3p_HBC@       ;SR3+
  
  
  HBOMotor    = HBOMotor    + rowsum(301) / 100   
  HBOnonmotor = HBOnonmotor + rowsum(302) / 100   
  HBOtransit  = HBOtransit  + rowsum(303) / 100   
  HBOauto     = HBOauto     + rowsum(304) / 100   
  
  HBOvehtrips = HBOvehtrips + rowsum(305) / 100       +                   ;DA
                              rowsum(306) / 100 / 2  +                   ;SR2
                              rowsum(307) / 100 / @VehOcc_3p_HBO@       ;SR3+
  
  
  NHBMotor    = NHBMotor    + rowsum(401) / 100   
  NHBnonmotor = NHBnonmotor + rowsum(402) / 100   
  NHBtransit  = NHBtransit  + rowsum(403) / 100   
  NHBauto     = NHBauto     + rowsum(404) / 100   
  
  NHBvehtrips = NHBvehtrips + rowsum(405) / 100       +                   ;DA
                              rowsum(406) / 100 / 2  +                   ;SR2
                              rowsum(407) / 100 / @VehOcc_3p_NHB@       ;SR3+
  
  
  ALLMotor    = HBWMotor    + HBCMotor    + HBOMotor    + NHBMotor   
  ALLnonmotor = HBWnonmotor + HBCnonmotor + HBOnonmotor + NHBnonmotor
  ALLtransit  = HBWtransit  + HBCtransit  + HBOtransit  + NHBtransit 
  ALLauto     = HBWauto     + HBCauto     + HBOauto     + NHBauto    
  ALLvehtrips = HBWvehtrips + HBCvehtrips + HBOvehtrips + NHBvehtrips


  if (Z==@Usedzones@)
    HBWAutoOcc = HBWauto    / HBWvehtrips
    HBCAutoOcc = HBCauto    / HBCvehtrips
    HBOAutoOcc = HBOauto    / HBOvehtrips
    NHBAutoOcc = NHBauto    / NHBvehtrips
    ALLAutoOcc = ALLauto    / ALLvehtrips
  
    print file='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
        APPEND=T,
        form=18.0C,
        list='\nSummary of Mode Choice Output',
             '\n',
             '\nTotal Trips',
             '\n  Non-Motorized trips   ',   Allnonmotor     ,
             '\n  Motorized person trips',   AllMotor        ,
             '\n  Transit trips         ',   Alltransit      ,
             '\n  Auto trips            ',   Allauto         ,
             '\n  Vehicle trips         ',   Allvehtrips     ,
             '\n  Avg Auto Occupancy    ',   ALLAutoOcc(18.3),
             '\n',
             '\n',
             '\nHBW',
             '\n  Non-Motorized trips   ',   HBWnonmotor     ,
             '\n  Motorized person trips',   HBWMotor        ,
             '\n  Transit trips         ',   HBWtransit      ,
             '\n  Auto trips            ',   HBWauto         ,
             '\n  Vehicle trips         ',   HBWvehtrips     ,
             '\n  Avg Auto Occupancy    ',   HBWAutoOcc(18.3),
             '\n',
             '\n',
             '\nHBC',
             '\n  Non-Motorized trips   ',   HBCnonmotor     ,
             '\n  Motorized person trips',   HBCMotor        ,
             '\n  Transit trips         ',   HBCtransit      ,
             '\n  Auto trips            ',   HBCauto         ,
             '\n  Vehicle trips         ',   HBCvehtrips     ,
             '\n  Avg Auto Occupancy    ',   HBCAutoOcc(18.3),
             '\n',
             '\n',
             '\nHBO',
             '\n  Non-Motorized trips   ',   HBOnonmotor     ,
             '\n  Motorized person trips',   HBOMotor        ,
             '\n  Transit trips         ',   HBOtransit      ,
             '\n  Auto trips            ',   HBOauto         ,
             '\n  Vehicle trips         ',   HBOvehtrips     ,
             '\n  Avg Auto Occupancy    ',   HBOAutoOcc(18.3),
             '\n',
             '\n',
             '\nNHB',
             '\n  Non-Motorized trips   ',   NHBnonmotor     ,
             '\n  Motorized person trips',   NHBMotor        ,
             '\n  Transit trips         ',   NHBtransit      ,
             '\n  Auto trips            ',   NHBauto         ,
             '\n  Vehicle trips         ',   NHBvehtrips     ,
             '\n  Avg Auto Occupancy    ',   NHBAutoOcc(18.3),
             '\n'
  
  endif  
  
ENDRUN  


RUN PGM=MATRIX   MSG='Mode Choice 13: summarize auto mode choice by purpose - daily'

;********* For running from the directory where files are first produced
  FILEI  MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_pk_auto_managedlanes.mtx'
  FILEI  MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_pk_auto_managedlanes.mtx'
  FILEI  MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_pk_auto_managedlanes.mtx'
  FILEI  MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_pk_auto_managedlanes.mtx'
  
  FILEI  MATI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_ok_auto_managedlanes.mtx'
  FILEI  MATI[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_ok_auto_managedlanes.mtx'
  FILEI  MATI[8] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_ok_auto_managedlanes.mtx'
  FILEI  MATI[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_ok_auto_managedlanes.mtx'

  FILEO  MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_pkok_auto_managedlanes.mtx', MO=11-18,    
    		   name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll

  FILEO  MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_pkok_auto_managedlanes.mtx', MO=21-28,    
    		   name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll

  FILEO  MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_pkok_auto_managedlanes.mtx', MO=31-38,    
    		   name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll

  FILEO  MATO[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_pkok_auto_managedlanes.mtx', MO=41-48,    
    		   name=alone_non,alone_toll,sr2_non,sr2_hov,sr2_toll,sr3_non,sr3_hov,sr3_toll
    		   
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
  ZONEMSG = @ZoneMsgRate@  ;reduces print messages in TPP DOS. (i.e. runs faster).
  
  MW[11] = mi.1.alone_non  + mi.6.alone_non
  MW[12] = mi.1.alone_toll + mi.6.alone_toll
  MW[13] = mi.1.sr2_non + mi.6.sr2_non
  MW[14] = mi.1.sr2_hov + mi.6.sr2_hov
  MW[15] = mi.1.sr2_toll + mi.6.sr2_toll
  MW[16] = mi.1.sr3_non + mi.6.sr3_non
  MW[17] = mi.1.sr3_hov + mi.6.sr3_hov
  MW[18] = mi.1.sr3_toll + mi.6.sr3_toll

  MW[21] = mi.2.alone_non  + mi.7.alone_non
  MW[22] = mi.2.alone_toll + mi.7.alone_toll
  MW[23] = mi.2.sr2_non + mi.7.sr2_non
  MW[24] = mi.2.sr2_hov + mi.7.sr2_hov
  MW[25] = mi.2.sr2_toll + mi.7.sr2_toll
  MW[26] = mi.2.sr3_non + mi.7.sr3_non
  MW[27] = mi.2.sr3_hov + mi.7.sr3_hov
  MW[28] = mi.2.sr3_toll + mi.7.sr3_toll
  
  MW[31] = mi.3.alone_non  + mi.8.alone_non
  MW[32] = mi.3.alone_toll + mi.8.alone_toll
  MW[33] = mi.3.sr2_non + mi.8.sr2_non
  MW[34] = mi.3.sr2_hov + mi.8.sr2_hov
  MW[35] = mi.3.sr2_toll + mi.8.sr2_toll
  MW[36] = mi.3.sr3_non + mi.8.sr3_non
  MW[37] = mi.3.sr3_hov + mi.8.sr3_hov
  MW[38] = mi.3.sr3_toll + mi.8.sr3_toll
  
  MW[41] = mi.4.alone_non  + mi.9.alone_non
  MW[42] = mi.4.alone_toll + mi.9.alone_toll
  MW[43] = mi.4.sr2_non + mi.9.sr2_non
  MW[44] = mi.4.sr2_hov + mi.9.sr2_hov
  MW[45] = mi.4.sr2_toll + mi.9.sr2_toll
  MW[46] = mi.4.sr3_non + mi.9.sr3_non
  MW[47] = mi.4.sr3_hov + mi.9.sr3_hov
  MW[48] = mi.4.sr3_toll + mi.9.sr3_toll

ENDRUN



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Mode Choice Calculations           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN


*(DEL 11_MC_HBW_HBO_NHB_HBC.txt)
