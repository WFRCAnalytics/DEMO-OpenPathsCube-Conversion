
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 01_Segmnt_TripsByDetailed.txt)



;get start time
ScriptStartTime = currenttime()




;calculate number of trips by HH size, workers, income and vehicles segment
;This script estimates percent of zonal trips taken by each market segment, 
;          for HBW, HBO purposes
;          For Mode Choice model application (allows market segmentation)

LOOP purpose=1, 2   ;loop through HBW, HBO trip purposes
    
    ;assign purpose tags
    if (purpose=1)  purp = 'HBW'
    if (purpose=2)  purp = 'HBO'
    
    
    RUN PGM=MATRIX  MSG='Mode Choice 1: Trip Mareket Segmentation - @purp@'
    FILEI ZDATI[1]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH1_IncLoHi_Worker_VehOwn.dbf'
    FILEI ZDATI[2]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH2_IncLoHi_Worker_VehOwn.dbf'
    FILEI ZDATI[3]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH3_IncLoHi_Worker_VehOwn.dbf'
    FILEI ZDATI[4]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH4_IncLoHi_Worker_VehOwn.dbf'
    FILEI ZDATI[5]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH5_IncLoHi_Worker_VehOwn.dbf'
    FILEI ZDATI[6]='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH6_IncLoHi_Worker_VehOwn.dbf'
    
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH1_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    FILEO RECO[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH2_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    FILEO RECO[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH3_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    FILEO RECO[4] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH4_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    FILEO RECO[5] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH5_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    FILEO RECO[6] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\HH6_PercTrips_segment_@purp@.dbf',
        FORM=10.4, 
        FIELDS=Z(10.0),
               P_ILW0V0, P_ILW0V1, P_ILW0V2, P_ILW0V3,
               P_ILW1V0, P_ILW1V1, P_ILW1V2, P_ILW1V3,
               P_ILW2V0, P_ILW2V1, P_ILW2V2, P_ILW2V3,
               P_ILW3V0, P_ILW3V1, P_ILW3V2, P_ILW3V3,
               
               P_IHW0V0, P_IHW0V1, P_IHW0V2, P_IHW0V3,
               P_IHW1V0, P_IHW1V1, P_IHW1V2, P_IHW1V3,
               P_IHW2V0, P_IHW2V1, P_IHW2V2, P_IHW2V3,
               P_IHW3V0, P_IHW3V1, P_IHW3V2, P_IHW3V3
    
    
    FILEO RECO[7] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\Productions_by_numveh_@purp@.dbf',
        FORM=10.1, 
        FIELDS=Z(10.0),
               V0     , 
               V1     , 
               V2p    , 
               Vtot
        
        
        
        ZONES=@Usedzones@
        ZONEMSG = @ZoneMsgRate@
        
        
        
        ;read trip generation rates by hhsize and veh ownership segment --------------------------------------
        ;  (former 'Seg_tripgen_rates.block' file)
        
        ;HBW
        HH1_V0_rate_HBW = 0.460
        HH1_V1_rate_HBW = 0.901
        HH1_V2_rate_HBW = 0.935
        HH1_V3_rate_HBW = 0.999
                       
        HH2_V0_rate_HBW = 0.997
        HH2_V1_rate_HBW = 1.438
        HH2_V2_rate_HBW = 1.726
        HH2_V3_rate_HBW = 1.811
                     
        HH3_V0_rate_HBW = 1.299
        HH3_V1_rate_HBW = 1.748
        HH3_V2_rate_HBW = 2.126
        HH3_V3_rate_HBW = 2.803
                       
        HH4_V0_rate_HBW = 1.399
        HH4_V1_rate_HBW = 1.898
        HH4_V2_rate_HBW = 2.214
        HH4_V3_rate_HBW = 2.995
                     
        HH5_V0_rate_HBW = 1.349
        HH5_V1_rate_HBW = 1.698
        HH5_V2_rate_HBW = 1.901
        HH5_V3_rate_HBW = 2.685
                     
        HH6_V0_rate_HBW = 1.299
        HH6_V1_rate_HBW = 1.599
        HH6_V2_rate_HBW = 1.875
        HH6_V3_rate_HBW = 2.797
        
        
        ;HBO (HBShp + HBOth)
        HH1_V0_rate_HBO = 1.683  
        HH1_V1_rate_HBO = 1.817  
        HH1_V2_rate_HBO = 1.800  
        HH1_V3_rate_HBO = 2.050  
                     
        HH2_V0_rate_HBO = 3.000  
        HH2_V1_rate_HBO = 3.028  
        HH2_V2_rate_HBO = 3.312  
        HH2_V3_rate_HBO = 3.500  
                   
        HH3_V0_rate_HBO = 4.600  
        HH3_V1_rate_HBO = 4.600  
        HH3_V2_rate_HBO = 5.105  
        HH3_V3_rate_HBO = 5.000  
                     
        HH4_V0_rate_HBO = 6.350  
        HH4_V1_rate_HBO = 6.400  
        HH4_V2_rate_HBO = 7.237  
        HH4_V3_rate_HBO = 6.600  
                   
        HH5_V0_rate_HBO = 8.300  
        HH5_V1_rate_HBO = 8.600  
        HH5_V2_rate_HBO = 9.566  
        HH5_V3_rate_HBO = 8.393  
                   
        HH6_V0_rate_HBO = 10.500 
        HH6_V1_rate_HBO = 11.000 
        HH6_V2_rate_HBO = 12.100 
        HH6_V3_rate_HBO = 10.250 
        
        
        
        ;estimate the number of trips by size/income/workers/vehicles market segments, using rates -----------
        ;  (former 'Seg_calc_trips_by_segment.block' file)
        
        ;HH1 -------------------------------------------------------------------
        ;low income
        HH1_IL_W0_V0 = zi.1.S1ILW0V0[i] * HH1_V0_rate_@purp@
        HH1_IL_W0_V1 = zi.1.S1ILW0V1[i] * HH1_V1_rate_@purp@
        HH1_IL_W0_V2 = zi.1.S1ILW0V2[i] * HH1_V2_rate_@purp@
        HH1_IL_W0_V3 = zi.1.S1ILW0V3[i] * HH1_V3_rate_@purp@
        
        HH1_IL_W1_V0 = zi.1.S1ILW1V0[i] * HH1_V0_rate_@purp@
        HH1_IL_W1_V1 = zi.1.S1ILW1V1[i] * HH1_V1_rate_@purp@
        HH1_IL_W1_V2 = zi.1.S1ILW1V2[i] * HH1_V2_rate_@purp@
        HH1_IL_W1_V3 = zi.1.S1ILW1V3[i] * HH1_V3_rate_@purp@
        
        HH1_IL_W2_V0 = zi.1.S1ILW2V0[i] * HH1_V0_rate_@purp@
        HH1_IL_W2_V1 = zi.1.S1ILW2V1[i] * HH1_V1_rate_@purp@
        HH1_IL_W2_V2 = zi.1.S1ILW2V2[i] * HH1_V2_rate_@purp@
        HH1_IL_W2_V3 = zi.1.S1ILW2V3[i] * HH1_V3_rate_@purp@
        
        HH1_IL_W3_V0 = zi.1.S1ILW3V0[i] * HH1_V0_rate_@purp@
        HH1_IL_W3_V1 = zi.1.S1ILW3V1[i] * HH1_V1_rate_@purp@
        HH1_IL_W3_V2 = zi.1.S1ILW3V2[i] * HH1_V2_rate_@purp@
        HH1_IL_W3_V3 = zi.1.S1ILW3V3[i] * HH1_V3_rate_@purp@
        
        
        ;high income
        HH1_IH_W0_V0 = zi.1.S1IHW0V0[i] * HH1_V0_rate_@purp@
        HH1_IH_W0_V1 = zi.1.S1IHW0V1[i] * HH1_V1_rate_@purp@
        HH1_IH_W0_V2 = zi.1.S1IHW0V2[i] * HH1_V2_rate_@purp@
        HH1_IH_W0_V3 = zi.1.S1IHW0V3[i] * HH1_V3_rate_@purp@
        
        HH1_IH_W1_V0 = zi.1.S1IHW1V0[i] * HH1_V0_rate_@purp@
        HH1_IH_W1_V1 = zi.1.S1IHW1V1[i] * HH1_V1_rate_@purp@
        HH1_IH_W1_V2 = zi.1.S1IHW1V2[i] * HH1_V2_rate_@purp@
        HH1_IH_W1_V3 = zi.1.S1IHW1V3[i] * HH1_V3_rate_@purp@
        
        HH1_IH_W2_V0 = zi.1.S1IHW2V0[i] * HH1_V0_rate_@purp@
        HH1_IH_W2_V1 = zi.1.S1IHW2V1[i] * HH1_V1_rate_@purp@
        HH1_IH_W2_V2 = zi.1.S1IHW2V2[i] * HH1_V2_rate_@purp@
        HH1_IH_W2_V3 = zi.1.S1IHW2V3[i] * HH1_V3_rate_@purp@
        
        HH1_IH_W3_V0 = zi.1.S1IHW3V0[i] * HH1_V0_rate_@purp@
        HH1_IH_W3_V1 = zi.1.S1IHW3V1[i] * HH1_V1_rate_@purp@
        HH1_IH_W3_V2 = zi.1.S1IHW3V2[i] * HH1_V2_rate_@purp@
        HH1_IH_W3_V3 = zi.1.S1IHW3V3[i] * HH1_V3_rate_@purp@
        
        
        ;HH2 -------------------------------------------------------------------
        ;low income
        HH2_IL_W0_V0 = zi.2.S2ILW0V0[i] * HH2_V0_rate_@purp@
        HH2_IL_W0_V1 = zi.2.S2ILW0V1[i] * HH2_V1_rate_@purp@
        HH2_IL_W0_V2 = zi.2.S2ILW0V2[i] * HH2_V2_rate_@purp@
        HH2_IL_W0_V3 = zi.2.S2ILW0V3[i] * HH2_V3_rate_@purp@
        
        HH2_IL_W1_V0 = zi.2.S2ILW1V0[i] * HH2_V0_rate_@purp@
        HH2_IL_W1_V1 = zi.2.S2ILW1V1[i] * HH2_V1_rate_@purp@
        HH2_IL_W1_V2 = zi.2.S2ILW1V2[i] * HH2_V2_rate_@purp@
        HH2_IL_W1_V3 = zi.2.S2ILW1V3[i] * HH2_V3_rate_@purp@
        
        HH2_IL_W2_V0 = zi.2.S2ILW2V0[i] * HH2_V0_rate_@purp@
        HH2_IL_W2_V1 = zi.2.S2ILW2V1[i] * HH2_V1_rate_@purp@
        HH2_IL_W2_V2 = zi.2.S2ILW2V2[i] * HH2_V2_rate_@purp@
        HH2_IL_W2_V3 = zi.2.S2ILW2V3[i] * HH2_V3_rate_@purp@
        
        HH2_IL_W3_V0 = zi.2.S2ILW3V0[i] * HH2_V0_rate_@purp@
        HH2_IL_W3_V1 = zi.2.S2ILW3V1[i] * HH2_V1_rate_@purp@
        HH2_IL_W3_V2 = zi.2.S2ILW3V2[i] * HH2_V2_rate_@purp@
        HH2_IL_W3_V3 = zi.2.S2ILW3V3[i] * HH2_V3_rate_@purp@
        
        
        ;high income
        HH2_IH_W0_V0 = zi.2.S2IHW0V0[i] * HH2_V0_rate_@purp@
        HH2_IH_W0_V1 = zi.2.S2IHW0V1[i] * HH2_V1_rate_@purp@
        HH2_IH_W0_V2 = zi.2.S2IHW0V2[i] * HH2_V2_rate_@purp@
        HH2_IH_W0_V3 = zi.2.S2IHW0V3[i] * HH2_V3_rate_@purp@
        
        HH2_IH_W1_V0 = zi.2.S2IHW1V0[i] * HH2_V0_rate_@purp@
        HH2_IH_W1_V1 = zi.2.S2IHW1V1[i] * HH2_V1_rate_@purp@
        HH2_IH_W1_V2 = zi.2.S2IHW1V2[i] * HH2_V2_rate_@purp@
        HH2_IH_W1_V3 = zi.2.S2IHW1V3[i] * HH2_V3_rate_@purp@
        
        HH2_IH_W2_V0 = zi.2.S2IHW2V0[i] * HH2_V0_rate_@purp@
        HH2_IH_W2_V1 = zi.2.S2IHW2V1[i] * HH2_V1_rate_@purp@
        HH2_IH_W2_V2 = zi.2.S2IHW2V2[i] * HH2_V2_rate_@purp@
        HH2_IH_W2_V3 = zi.2.S2IHW2V3[i] * HH2_V3_rate_@purp@
        
        HH2_IH_W3_V0 = zi.2.S2IHW3V0[i] * HH2_V0_rate_@purp@
        HH2_IH_W3_V1 = zi.2.S2IHW3V1[i] * HH2_V1_rate_@purp@
        HH2_IH_W3_V2 = zi.2.S2IHW3V2[i] * HH2_V2_rate_@purp@
        HH2_IH_W3_V3 = zi.2.S2IHW3V3[i] * HH2_V3_rate_@purp@
        
        
        ;HH3 -------------------------------------------------------------------
        ;low income
        HH3_IL_W0_V0 = zi.3.S3ILW0V0[i] * HH3_V0_rate_@purp@
        HH3_IL_W0_V1 = zi.3.S3ILW0V1[i] * HH3_V1_rate_@purp@
        HH3_IL_W0_V2 = zi.3.S3ILW0V2[i] * HH3_V2_rate_@purp@
        HH3_IL_W0_V3 = zi.3.S3ILW0V3[i] * HH3_V3_rate_@purp@
        
        HH3_IL_W1_V0 = zi.3.S3ILW1V0[i] * HH3_V0_rate_@purp@
        HH3_IL_W1_V1 = zi.3.S3ILW1V1[i] * HH3_V1_rate_@purp@
        HH3_IL_W1_V2 = zi.3.S3ILW1V2[i] * HH3_V2_rate_@purp@
        HH3_IL_W1_V3 = zi.3.S3ILW1V3[i] * HH3_V3_rate_@purp@
        
        HH3_IL_W2_V0 = zi.3.S3ILW2V0[i] * HH3_V0_rate_@purp@
        HH3_IL_W2_V1 = zi.3.S3ILW2V1[i] * HH3_V1_rate_@purp@
        HH3_IL_W2_V2 = zi.3.S3ILW2V2[i] * HH3_V2_rate_@purp@
        HH3_IL_W2_V3 = zi.3.S3ILW2V3[i] * HH3_V3_rate_@purp@
        
        HH3_IL_W3_V0 = zi.3.S3ILW3V0[i] * HH3_V0_rate_@purp@
        HH3_IL_W3_V1 = zi.3.S3ILW3V1[i] * HH3_V1_rate_@purp@
        HH3_IL_W3_V2 = zi.3.S3ILW3V2[i] * HH3_V2_rate_@purp@
        HH3_IL_W3_V3 = zi.3.S3ILW3V3[i] * HH3_V3_rate_@purp@
        
        
        ;high income
        HH3_IH_W0_V0 = zi.3.S3IHW0V0[i] * HH3_V0_rate_@purp@
        HH3_IH_W0_V1 = zi.3.S3IHW0V1[i] * HH3_V1_rate_@purp@
        HH3_IH_W0_V2 = zi.3.S3IHW0V2[i] * HH3_V2_rate_@purp@
        HH3_IH_W0_V3 = zi.3.S3IHW0V3[i] * HH3_V3_rate_@purp@
        
        HH3_IH_W1_V0 = zi.3.S3IHW1V0[i] * HH3_V0_rate_@purp@
        HH3_IH_W1_V1 = zi.3.S3IHW1V1[i] * HH3_V1_rate_@purp@
        HH3_IH_W1_V2 = zi.3.S3IHW1V2[i] * HH3_V2_rate_@purp@
        HH3_IH_W1_V3 = zi.3.S3IHW1V3[i] * HH3_V3_rate_@purp@
        
        HH3_IH_W2_V0 = zi.3.S3IHW2V0[i] * HH3_V0_rate_@purp@
        HH3_IH_W2_V1 = zi.3.S3IHW2V1[i] * HH3_V1_rate_@purp@
        HH3_IH_W2_V2 = zi.3.S3IHW2V2[i] * HH3_V2_rate_@purp@
        HH3_IH_W2_V3 = zi.3.S3IHW2V3[i] * HH3_V3_rate_@purp@
        
        HH3_IH_W3_V0 = zi.3.S3IHW3V0[i] * HH3_V0_rate_@purp@
        HH3_IH_W3_V1 = zi.3.S3IHW3V1[i] * HH3_V1_rate_@purp@
        HH3_IH_W3_V2 = zi.3.S3IHW3V2[i] * HH3_V2_rate_@purp@
        HH3_IH_W3_V3 = zi.3.S3IHW3V3[i] * HH3_V3_rate_@purp@
        
        
        ;HH4 -------------------------------------------------------------------
        ;low income
        HH4_IL_W0_V0 = zi.4.S4ILW0V0[i] * HH4_V0_rate_@purp@
        HH4_IL_W0_V1 = zi.4.S4ILW0V1[i] * HH4_V1_rate_@purp@
        HH4_IL_W0_V2 = zi.4.S4ILW0V2[i] * HH4_V2_rate_@purp@
        HH4_IL_W0_V3 = zi.4.S4ILW0V3[i] * HH4_V3_rate_@purp@
        
        HH4_IL_W1_V0 = zi.4.S4ILW1V0[i] * HH4_V0_rate_@purp@
        HH4_IL_W1_V1 = zi.4.S4ILW1V1[i] * HH4_V1_rate_@purp@
        HH4_IL_W1_V2 = zi.4.S4ILW1V2[i] * HH4_V2_rate_@purp@
        HH4_IL_W1_V3 = zi.4.S4ILW1V3[i] * HH4_V3_rate_@purp@
        
        HH4_IL_W2_V0 = zi.4.S4ILW2V0[i] * HH4_V0_rate_@purp@
        HH4_IL_W2_V1 = zi.4.S4ILW2V1[i] * HH4_V1_rate_@purp@
        HH4_IL_W2_V2 = zi.4.S4ILW2V2[i] * HH4_V2_rate_@purp@
        HH4_IL_W2_V3 = zi.4.S4ILW2V3[i] * HH4_V3_rate_@purp@
        
        HH4_IL_W3_V0 = zi.4.S4ILW3V0[i] * HH4_V0_rate_@purp@
        HH4_IL_W3_V1 = zi.4.S4ILW3V1[i] * HH4_V1_rate_@purp@
        HH4_IL_W3_V2 = zi.4.S4ILW3V2[i] * HH4_V2_rate_@purp@
        HH4_IL_W3_V3 = zi.4.S4ILW3V3[i] * HH4_V3_rate_@purp@
        
        
        ;high income
        HH4_IH_W0_V0 = zi.4.S4IHW0V0[i] * HH4_V0_rate_@purp@
        HH4_IH_W0_V1 = zi.4.S4IHW0V1[i] * HH4_V1_rate_@purp@
        HH4_IH_W0_V2 = zi.4.S4IHW0V2[i] * HH4_V2_rate_@purp@
        HH4_IH_W0_V3 = zi.4.S4IHW0V3[i] * HH4_V3_rate_@purp@
        
        HH4_IH_W1_V0 = zi.4.S4IHW1V0[i] * HH4_V0_rate_@purp@
        HH4_IH_W1_V1 = zi.4.S4IHW1V1[i] * HH4_V1_rate_@purp@
        HH4_IH_W1_V2 = zi.4.S4IHW1V2[i] * HH4_V2_rate_@purp@
        HH4_IH_W1_V3 = zi.4.S4IHW1V3[i] * HH4_V3_rate_@purp@
        
        HH4_IH_W2_V0 = zi.4.S4IHW2V0[i] * HH4_V0_rate_@purp@
        HH4_IH_W2_V1 = zi.4.S4IHW2V1[i] * HH4_V1_rate_@purp@
        HH4_IH_W2_V2 = zi.4.S4IHW2V2[i] * HH4_V2_rate_@purp@
        HH4_IH_W2_V3 = zi.4.S4IHW2V3[i] * HH4_V3_rate_@purp@
        
        HH4_IH_W3_V0 = zi.4.S4IHW3V0[i] * HH4_V0_rate_@purp@
        HH4_IH_W3_V1 = zi.4.S4IHW3V1[i] * HH4_V1_rate_@purp@
        HH4_IH_W3_V2 = zi.4.S4IHW3V2[i] * HH4_V2_rate_@purp@
        HH4_IH_W3_V3 = zi.4.S4IHW3V3[i] * HH4_V3_rate_@purp@
        
        
        ;HH5 -------------------------------------------------------------------
        ;low income
        HH5_IL_W0_V0 = zi.5.S5ILW0V0[i] * HH5_V0_rate_@purp@
        HH5_IL_W0_V1 = zi.5.S5ILW0V1[i] * HH5_V1_rate_@purp@
        HH5_IL_W0_V2 = zi.5.S5ILW0V2[i] * HH5_V2_rate_@purp@
        HH5_IL_W0_V3 = zi.5.S5ILW0V3[i] * HH5_V3_rate_@purp@
        
        HH5_IL_W1_V0 = zi.5.S5ILW1V0[i] * HH5_V0_rate_@purp@
        HH5_IL_W1_V1 = zi.5.S5ILW1V1[i] * HH5_V1_rate_@purp@
        HH5_IL_W1_V2 = zi.5.S5ILW1V2[i] * HH5_V2_rate_@purp@
        HH5_IL_W1_V3 = zi.5.S5ILW1V3[i] * HH5_V3_rate_@purp@
        
        HH5_IL_W2_V0 = zi.5.S5ILW2V0[i] * HH5_V0_rate_@purp@
        HH5_IL_W2_V1 = zi.5.S5ILW2V1[i] * HH5_V1_rate_@purp@
        HH5_IL_W2_V2 = zi.5.S5ILW2V2[i] * HH5_V2_rate_@purp@
        HH5_IL_W2_V3 = zi.5.S5ILW2V3[i] * HH5_V3_rate_@purp@
        
        HH5_IL_W3_V0 = zi.5.S5ILW3V0[i] * HH5_V0_rate_@purp@
        HH5_IL_W3_V1 = zi.5.S5ILW3V1[i] * HH5_V1_rate_@purp@
        HH5_IL_W3_V2 = zi.5.S5ILW3V2[i] * HH5_V2_rate_@purp@
        HH5_IL_W3_V3 = zi.5.S5ILW3V3[i] * HH5_V3_rate_@purp@
        
        
        ;high income
        HH5_IH_W0_V0 = zi.5.S5IHW0V0[i] * HH5_V0_rate_@purp@
        HH5_IH_W0_V1 = zi.5.S5IHW0V1[i] * HH5_V1_rate_@purp@
        HH5_IH_W0_V2 = zi.5.S5IHW0V2[i] * HH5_V2_rate_@purp@
        HH5_IH_W0_V3 = zi.5.S5IHW0V3[i] * HH5_V3_rate_@purp@
        
        HH5_IH_W1_V0 = zi.5.S5IHW1V0[i] * HH5_V0_rate_@purp@
        HH5_IH_W1_V1 = zi.5.S5IHW1V1[i] * HH5_V1_rate_@purp@
        HH5_IH_W1_V2 = zi.5.S5IHW1V2[i] * HH5_V2_rate_@purp@
        HH5_IH_W1_V3 = zi.5.S5IHW1V3[i] * HH5_V3_rate_@purp@
        
        HH5_IH_W2_V0 = zi.5.S5IHW2V0[i] * HH5_V0_rate_@purp@
        HH5_IH_W2_V1 = zi.5.S5IHW2V1[i] * HH5_V1_rate_@purp@
        HH5_IH_W2_V2 = zi.5.S5IHW2V2[i] * HH5_V2_rate_@purp@
        HH5_IH_W2_V3 = zi.5.S5IHW2V3[i] * HH5_V3_rate_@purp@
        
        HH5_IH_W3_V0 = zi.5.S5IHW3V0[i] * HH5_V0_rate_@purp@
        HH5_IH_W3_V1 = zi.5.S5IHW3V1[i] * HH5_V1_rate_@purp@
        HH5_IH_W3_V2 = zi.5.S5IHW3V2[i] * HH5_V2_rate_@purp@
        HH5_IH_W3_V3 = zi.5.S5IHW3V3[i] * HH5_V3_rate_@purp@
        
        
        ;HH6 -------------------------------------------------------------------
        ;low income
        HH6_IL_W0_V0 = zi.6.S6ILW0V0[i] * HH6_V0_rate_@purp@
        HH6_IL_W0_V1 = zi.6.S6ILW0V1[i] * HH6_V1_rate_@purp@
        HH6_IL_W0_V2 = zi.6.S6ILW0V2[i] * HH6_V2_rate_@purp@
        HH6_IL_W0_V3 = zi.6.S6ILW0V3[i] * HH6_V3_rate_@purp@
        
        HH6_IL_W1_V0 = zi.6.S6ILW1V0[i] * HH6_V0_rate_@purp@
        HH6_IL_W1_V1 = zi.6.S6ILW1V1[i] * HH6_V1_rate_@purp@
        HH6_IL_W1_V2 = zi.6.S6ILW1V2[i] * HH6_V2_rate_@purp@
        HH6_IL_W1_V3 = zi.6.S6ILW1V3[i] * HH6_V3_rate_@purp@
        
        HH6_IL_W2_V0 = zi.6.S6ILW2V0[i] * HH6_V0_rate_@purp@
        HH6_IL_W2_V1 = zi.6.S6ILW2V1[i] * HH6_V1_rate_@purp@
        HH6_IL_W2_V2 = zi.6.S6ILW2V2[i] * HH6_V2_rate_@purp@
        HH6_IL_W2_V3 = zi.6.S6ILW2V3[i] * HH6_V3_rate_@purp@
        
        HH6_IL_W3_V0 = zi.6.S6ILW3V0[i] * HH6_V0_rate_@purp@
        HH6_IL_W3_V1 = zi.6.S6ILW3V1[i] * HH6_V1_rate_@purp@
        HH6_IL_W3_V2 = zi.6.S6ILW3V2[i] * HH6_V2_rate_@purp@
        HH6_IL_W3_V3 = zi.6.S6ILW3V3[i] * HH6_V3_rate_@purp@
        
        
        ;high income
        HH6_IH_W0_V0 = zi.6.S6IHW0V0[i] * HH6_V0_rate_@purp@
        HH6_IH_W0_V1 = zi.6.S6IHW0V1[i] * HH6_V1_rate_@purp@
        HH6_IH_W0_V2 = zi.6.S6IHW0V2[i] * HH6_V2_rate_@purp@
        HH6_IH_W0_V3 = zi.6.S6IHW0V3[i] * HH6_V3_rate_@purp@
        
        HH6_IH_W1_V0 = zi.6.S6IHW1V0[i] * HH6_V0_rate_@purp@
        HH6_IH_W1_V1 = zi.6.S6IHW1V1[i] * HH6_V1_rate_@purp@
        HH6_IH_W1_V2 = zi.6.S6IHW1V2[i] * HH6_V2_rate_@purp@
        HH6_IH_W1_V3 = zi.6.S6IHW1V3[i] * HH6_V3_rate_@purp@
        
        HH6_IH_W2_V0 = zi.6.S6IHW2V0[i] * HH6_V0_rate_@purp@
        HH6_IH_W2_V1 = zi.6.S6IHW2V1[i] * HH6_V1_rate_@purp@
        HH6_IH_W2_V2 = zi.6.S6IHW2V2[i] * HH6_V2_rate_@purp@
        HH6_IH_W2_V3 = zi.6.S6IHW2V3[i] * HH6_V3_rate_@purp@
        
        HH6_IH_W3_V0 = zi.6.S6IHW3V0[i] * HH6_V0_rate_@purp@
        HH6_IH_W3_V1 = zi.6.S6IHW3V1[i] * HH6_V1_rate_@purp@
        HH6_IH_W3_V2 = zi.6.S6IHW3V2[i] * HH6_V2_rate_@purp@
        HH6_IH_W3_V3 = zi.6.S6IHW3V3[i] * HH6_V3_rate_@purp@
        
        
        
        ;sum total trips by zone (for all segments) ----------------------------------------------------------
        ;  (former 'Seg_sum_total_trips.block' file)
        
        numtrips = HH1_IL_W0_V0 + HH1_IL_W1_V0 + HH1_IL_W2_V0 + HH1_IL_W3_V0 +          ;HH1
                   HH1_IL_W0_V1 + HH1_IL_W1_V1 + HH1_IL_W2_V1 + HH1_IL_W3_V1 +
                   HH1_IL_W0_V2 + HH1_IL_W1_V2 + HH1_IL_W2_V2 + HH1_IL_W3_V2 +
                   HH1_IL_W0_V3 + HH1_IL_W1_V3 + HH1_IL_W2_V3 + HH1_IL_W3_V3 +
                   
                   HH1_IH_W0_V0 + HH1_IH_W1_V0 + HH1_IH_W2_V0 + HH1_IH_W3_V0 +
                   HH1_IH_W0_V1 + HH1_IH_W1_V1 + HH1_IH_W2_V1 + HH1_IH_W3_V1 +
                   HH1_IH_W0_V2 + HH1_IH_W1_V2 + HH1_IH_W2_V2 + HH1_IH_W3_V2 +
                   HH1_IH_W0_V3 + HH1_IH_W1_V3 + HH1_IH_W2_V3 + HH1_IH_W3_V3 +
                   
                   HH2_IL_W0_V0 + HH2_IL_W1_V0 + HH2_IL_W2_V0 + HH2_IL_W3_V0 +          ;HH2
                   HH2_IL_W0_V1 + HH2_IL_W1_V1 + HH2_IL_W2_V1 + HH2_IL_W3_V1 +
                   HH2_IL_W0_V2 + HH2_IL_W1_V2 + HH2_IL_W2_V2 + HH2_IL_W3_V2 +
                   HH2_IL_W0_V3 + HH2_IL_W1_V3 + HH2_IL_W2_V3 + HH2_IL_W3_V3 +
                   
                   HH2_IH_W0_V0 + HH2_IH_W1_V0 + HH2_IH_W2_V0 + HH2_IH_W3_V0 +
                   HH2_IH_W0_V1 + HH2_IH_W1_V1 + HH2_IH_W2_V1 + HH2_IH_W3_V1 +
                   HH2_IH_W0_V2 + HH2_IH_W1_V2 + HH2_IH_W2_V2 + HH2_IH_W3_V2 +
                   HH2_IH_W0_V3 + HH2_IH_W1_V3 + HH2_IH_W2_V3 + HH2_IH_W3_V3 +
                   
                   HH3_IL_W0_V0 + HH3_IL_W1_V0 + HH3_IL_W2_V0 + HH3_IL_W3_V0 +          ;HH3
                   HH3_IL_W0_V1 + HH3_IL_W1_V1 + HH3_IL_W2_V1 + HH3_IL_W3_V1 +
                   HH3_IL_W0_V2 + HH3_IL_W1_V2 + HH3_IL_W2_V2 + HH3_IL_W3_V2 +
                   HH3_IL_W0_V3 + HH3_IL_W1_V3 + HH3_IL_W2_V3 + HH3_IL_W3_V3 +
                   
                   HH3_IH_W0_V0 + HH3_IH_W1_V0 + HH3_IH_W2_V0 + HH3_IH_W3_V0 +
                   HH3_IH_W0_V1 + HH3_IH_W1_V1 + HH3_IH_W2_V1 + HH3_IH_W3_V1 +
                   HH3_IH_W0_V2 + HH3_IH_W1_V2 + HH3_IH_W2_V2 + HH3_IH_W3_V2 +
                   HH3_IH_W0_V3 + HH3_IH_W1_V3 + HH3_IH_W2_V3 + HH3_IH_W3_V3 +
                   
                   HH4_IL_W0_V0 + HH4_IL_W1_V0 + HH4_IL_W2_V0 + HH4_IL_W3_V0 +          ;HH4
                   HH4_IL_W0_V1 + HH4_IL_W1_V1 + HH4_IL_W2_V1 + HH4_IL_W3_V1 +
                   HH4_IL_W0_V2 + HH4_IL_W1_V2 + HH4_IL_W2_V2 + HH4_IL_W3_V2 +
                   HH4_IL_W0_V3 + HH4_IL_W1_V3 + HH4_IL_W2_V3 + HH4_IL_W3_V3 +
                   
                   HH4_IH_W0_V0 + HH4_IH_W1_V0 + HH4_IH_W2_V0 + HH4_IH_W3_V0 +
                   HH4_IH_W0_V1 + HH4_IH_W1_V1 + HH4_IH_W2_V1 + HH4_IH_W3_V1 +
                   HH4_IH_W0_V2 + HH4_IH_W1_V2 + HH4_IH_W2_V2 + HH4_IH_W3_V2 +
                   HH4_IH_W0_V3 + HH4_IH_W1_V3 + HH4_IH_W2_V3 + HH4_IH_W3_V3 +
                   
                   HH5_IL_W0_V0 + HH5_IL_W1_V0 + HH5_IL_W2_V0 + HH5_IL_W3_V0 +          ;HH5
                   HH5_IL_W0_V1 + HH5_IL_W1_V1 + HH5_IL_W2_V1 + HH5_IL_W3_V1 +
                   HH5_IL_W0_V2 + HH5_IL_W1_V2 + HH5_IL_W2_V2 + HH5_IL_W3_V2 +
                   HH5_IL_W0_V3 + HH5_IL_W1_V3 + HH5_IL_W2_V3 + HH5_IL_W3_V3 +
                   
                   HH5_IH_W0_V0 + HH5_IH_W1_V0 + HH5_IH_W2_V0 + HH5_IH_W3_V0 +
                   HH5_IH_W0_V1 + HH5_IH_W1_V1 + HH5_IH_W2_V1 + HH5_IH_W3_V1 +
                   HH5_IH_W0_V2 + HH5_IH_W1_V2 + HH5_IH_W2_V2 + HH5_IH_W3_V2 +
                   HH5_IH_W0_V3 + HH5_IH_W1_V3 + HH5_IH_W2_V3 + HH5_IH_W3_V3 +
                   
                   HH6_IL_W0_V0 + HH6_IL_W1_V0 + HH6_IL_W2_V0 + HH6_IL_W3_V0 +          ;HH6
                   HH6_IL_W0_V1 + HH6_IL_W1_V1 + HH6_IL_W2_V1 + HH6_IL_W3_V1 +
                   HH6_IL_W0_V2 + HH6_IL_W1_V2 + HH6_IL_W2_V2 + HH6_IL_W3_V2 +
                   HH6_IL_W0_V3 + HH6_IL_W1_V3 + HH6_IL_W2_V3 + HH6_IL_W3_V3 +
                   
                   HH6_IH_W0_V0 + HH6_IH_W1_V0 + HH6_IH_W2_V0 + HH6_IH_W3_V0 +
                   HH6_IH_W0_V1 + HH6_IH_W1_V1 + HH6_IH_W2_V1 + HH6_IH_W3_V1 +
                   HH6_IH_W0_V2 + HH6_IH_W1_V2 + HH6_IH_W2_V2 + HH6_IH_W3_V2 +
                   HH6_IH_W0_V3 + HH6_IH_W1_V3 + HH6_IH_W2_V3 + HH6_IH_W3_V3 
        
        
        
        ;calculate the % of total trips by size/income/workers/vehicles segment ----------------------------------
        ;  (former 'Seg_calc_percent_trips.block' file)
        
        if (numtrips>0)
            
            ;HH1 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH1_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH1_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH1_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH1_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH1_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH1_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH1_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH1_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH1_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH1_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH1_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH1_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH1_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH1_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH1_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH1_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH1_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH1_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH1_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH1_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH1_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH1_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH1_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH1_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH1_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH1_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH1_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH1_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH1_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH1_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH1_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH1_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=1
            
            
            ;HH2 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH2_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH2_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH2_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH2_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH2_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH2_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH2_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH2_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH2_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH2_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH2_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH2_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH2_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH2_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH2_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH2_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH2_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH2_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH2_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH2_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH2_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH2_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH2_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH2_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH2_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH2_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH2_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH2_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH2_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH2_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH2_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH2_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=2
            
            
            ;HH3 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH3_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH3_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH3_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH3_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH3_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH3_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH3_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH3_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH3_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH3_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH3_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH3_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH3_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH3_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH3_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH3_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH3_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH3_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH3_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH3_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH3_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH3_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH3_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH3_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH3_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH3_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH3_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH3_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH3_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH3_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH3_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH3_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=3
            
            
            ;HH4 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH4_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH4_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH4_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH4_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH4_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH4_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH4_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH4_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH4_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH4_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH4_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH4_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH4_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH4_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH4_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH4_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH4_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH4_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH4_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH4_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH4_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH4_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH4_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH4_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH4_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH4_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH4_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH4_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH4_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH4_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH4_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH4_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=4
            
            
            ;HH5 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH5_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH5_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH5_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH5_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH5_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH5_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH5_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH5_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH5_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH5_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH5_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH5_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH5_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH5_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH5_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH5_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH5_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH5_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH5_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH5_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH5_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH5_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH5_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH5_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH5_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH5_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH5_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH5_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH5_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH5_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH5_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH5_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=5
            
            
            ;HH6 -------------------------------------------------------------------
            ;low income
            RO.P_ILW0V0 = HH6_IL_W0_V0 / numtrips
            RO.P_ILW0V1 = HH6_IL_W0_V1 / numtrips
            RO.P_ILW0V2 = HH6_IL_W0_V2 / numtrips
            RO.P_ILW0V3 = HH6_IL_W0_V3 / numtrips
            
            RO.P_ILW1V0 = HH6_IL_W1_V0 / numtrips
            RO.P_ILW1V1 = HH6_IL_W1_V1 / numtrips
            RO.P_ILW1V2 = HH6_IL_W1_V2 / numtrips
            RO.P_ILW1V3 = HH6_IL_W1_V3 / numtrips
            
            RO.P_ILW2V0 = HH6_IL_W2_V0 / numtrips
            RO.P_ILW2V1 = HH6_IL_W2_V1 / numtrips
            RO.P_ILW2V2 = HH6_IL_W2_V2 / numtrips
            RO.P_ILW2V3 = HH6_IL_W2_V3 / numtrips
            
            RO.P_ILW3V0 = HH6_IL_W3_V0 / numtrips
            RO.P_ILW3V1 = HH6_IL_W3_V1 / numtrips
            RO.P_ILW3V2 = HH6_IL_W3_V2 / numtrips
            RO.P_ILW3V3 = HH6_IL_W3_V3 / numtrips
            
            
            ;high income
            RO.P_IHW0V0 = HH6_IH_W0_V0 / numtrips
            RO.P_IHW0V1 = HH6_IH_W0_V1 / numtrips
            RO.P_IHW0V2 = HH6_IH_W0_V2 / numtrips
            RO.P_IHW0V3 = HH6_IH_W0_V3 / numtrips
            
            RO.P_IHW1V0 = HH6_IH_W1_V0 / numtrips
            RO.P_IHW1V1 = HH6_IH_W1_V1 / numtrips
            RO.P_IHW1V2 = HH6_IH_W1_V2 / numtrips
            RO.P_IHW1V3 = HH6_IH_W1_V3 / numtrips
            
            RO.P_IHW2V0 = HH6_IH_W2_V0 / numtrips
            RO.P_IHW2V1 = HH6_IH_W2_V1 / numtrips
            RO.P_IHW2V2 = HH6_IH_W2_V2 / numtrips
            RO.P_IHW2V3 = HH6_IH_W2_V3 / numtrips
            
            RO.P_IHW3V0 = HH6_IH_W3_V0 / numtrips
            RO.P_IHW3V1 = HH6_IH_W3_V1 / numtrips
            RO.P_IHW3V2 = HH6_IH_W3_V2 / numtrips
            RO.P_IHW3V3 = HH6_IH_W3_V3 / numtrips
            
            
            ;wirte record to output file
            WRITE RECO=6
            
        
        else
            ;low income
            RO.P_ILW0V0 = 0
            RO.P_ILW0V1 = 0
            RO.P_ILW0V2 = 0
            RO.P_ILW0V3 = 0
            
            RO.P_ILW1V0 = 0
            RO.P_ILW1V1 = 0
            RO.P_ILW1V2 = 0
            RO.P_ILW1V3 = 0
            
            RO.P_ILW2V0 = 0
            RO.P_ILW2V1 = 0
            RO.P_ILW2V2 = 0
            RO.P_ILW2V3 = 0
            
            RO.P_ILW3V0 = 0
            RO.P_ILW3V1 = 0
            RO.P_ILW3V2 = 0
            RO.P_ILW3V3 = 0
            
            
            ;high income
            RO.P_IHW0V0 = 0
            RO.P_IHW0V1 = 0
            RO.P_IHW0V2 = 0
            RO.P_IHW0V3 = 0
            
            RO.P_IHW1V0 = 0
            RO.P_IHW1V1 = 0
            RO.P_IHW1V2 = 0
            RO.P_IHW1V3 = 0
            
            RO.P_IHW2V0 = 0
            RO.P_IHW2V1 = 0
            RO.P_IHW2V2 = 0
            RO.P_IHW2V3 = 0
            
            RO.P_IHW3V0 = 0
            RO.P_IHW3V1 = 0
            RO.P_IHW3V2 = 0
            RO.P_IHW3V3 = 0
            
            
            ;wirte record to output file
            WRITE RECO=1-6
            
        endif  ;numtrips>0
        
        
        
        ;estimate the number of trips by autos owned ---------------------------------------------------------
        V0 = HH1_IL_W0_V0  +  HH1_IL_W1_V0  +  HH1_IL_W2_V0  +  HH1_IL_W3_V0  + 
             HH2_IL_W0_V0  +  HH2_IL_W1_V0  +  HH2_IL_W2_V0  +  HH2_IL_W3_V0  + 
             HH3_IL_W0_V0  +  HH3_IL_W1_V0  +  HH3_IL_W2_V0  +  HH3_IL_W3_V0  + 
             HH4_IL_W0_V0  +  HH4_IL_W1_V0  +  HH4_IL_W2_V0  +  HH4_IL_W3_V0  + 
             HH5_IL_W0_V0  +  HH5_IL_W1_V0  +  HH5_IL_W2_V0  +  HH5_IL_W3_V0  + 
             HH6_IL_W0_V0  +  HH6_IL_W1_V0  +  HH6_IL_W2_V0  +  HH6_IL_W3_V0  + 
             
             HH1_IH_W0_V0  +  HH1_IH_W1_V0  +  HH1_IH_W2_V0  +  HH1_IH_W3_V0  + 
             HH2_IH_W0_V0  +  HH2_IH_W1_V0  +  HH2_IH_W2_V0  +  HH2_IH_W3_V0  + 
             HH3_IH_W0_V0  +  HH3_IH_W1_V0  +  HH3_IH_W2_V0  +  HH3_IH_W3_V0  + 
             HH4_IH_W0_V0  +  HH4_IH_W1_V0  +  HH4_IH_W2_V0  +  HH4_IH_W3_V0  + 
             HH5_IH_W0_V0  +  HH5_IH_W1_V0  +  HH5_IH_W2_V0  +  HH5_IH_W3_V0  + 
             HH6_IH_W0_V0  +  HH6_IH_W1_V0  +  HH6_IH_W2_V0  +  HH6_IH_W3_V0  
        
        V1 = HH1_IL_W0_V1  +  HH1_IL_W1_V1  +  HH1_IL_W2_V1  +  HH1_IL_W3_V1  + 
             HH2_IL_W0_V1  +  HH2_IL_W1_V1  +  HH2_IL_W2_V1  +  HH2_IL_W3_V1  + 
             HH3_IL_W0_V1  +  HH3_IL_W1_V1  +  HH3_IL_W2_V1  +  HH3_IL_W3_V1  + 
             HH4_IL_W0_V1  +  HH4_IL_W1_V1  +  HH4_IL_W2_V1  +  HH4_IL_W3_V1  + 
             HH5_IL_W0_V1  +  HH5_IL_W1_V1  +  HH5_IL_W2_V1  +  HH5_IL_W3_V1  + 
             HH6_IL_W0_V1  +  HH6_IL_W1_V1  +  HH6_IL_W2_V1  +  HH6_IL_W3_V1  + 
             
             HH1_IH_W0_V1  +  HH1_IH_W1_V1  +  HH1_IH_W2_V1  +  HH1_IH_W3_V1  + 
             HH2_IH_W0_V1  +  HH2_IH_W1_V1  +  HH2_IH_W2_V1  +  HH2_IH_W3_V1  + 
             HH3_IH_W0_V1  +  HH3_IH_W1_V1  +  HH3_IH_W2_V1  +  HH3_IH_W3_V1  + 
             HH4_IH_W0_V1  +  HH4_IH_W1_V1  +  HH4_IH_W2_V1  +  HH4_IH_W3_V1  + 
             HH5_IH_W0_V1  +  HH5_IH_W1_V1  +  HH5_IH_W2_V1  +  HH5_IH_W3_V1  + 
             HH6_IH_W0_V1  +  HH6_IH_W1_V1  +  HH6_IH_W2_V1  +  HH6_IH_W3_V1  
        
        V2 = HH1_IL_W0_V2  +  HH1_IL_W1_V2  +  HH1_IL_W2_V2  +  HH1_IL_W3_V2  + 
             HH2_IL_W0_V2  +  HH2_IL_W1_V2  +  HH2_IL_W2_V2  +  HH2_IL_W3_V2  + 
             HH3_IL_W0_V2  +  HH3_IL_W1_V2  +  HH3_IL_W2_V2  +  HH3_IL_W3_V2  + 
             HH4_IL_W0_V2  +  HH4_IL_W1_V2  +  HH4_IL_W2_V2  +  HH4_IL_W3_V2  + 
             HH5_IL_W0_V2  +  HH5_IL_W1_V2  +  HH5_IL_W2_V2  +  HH5_IL_W3_V2  + 
             HH6_IL_W0_V2  +  HH6_IL_W1_V2  +  HH6_IL_W2_V2  +  HH6_IL_W3_V2  + 
             
             HH1_IH_W0_V2  +  HH1_IH_W1_V2  +  HH1_IH_W2_V2  +  HH1_IH_W3_V2  + 
             HH2_IH_W0_V2  +  HH2_IH_W1_V2  +  HH2_IH_W2_V2  +  HH2_IH_W3_V2  + 
             HH3_IH_W0_V2  +  HH3_IH_W1_V2  +  HH3_IH_W2_V2  +  HH3_IH_W3_V2  + 
             HH4_IH_W0_V2  +  HH4_IH_W1_V2  +  HH4_IH_W2_V2  +  HH4_IH_W3_V2  + 
             HH5_IH_W0_V2  +  HH5_IH_W1_V2  +  HH5_IH_W2_V2  +  HH5_IH_W3_V2  + 
             HH6_IH_W0_V2  +  HH6_IH_W1_V2  +  HH6_IH_W2_V2  +  HH6_IH_W3_V2  
        
        V3 = HH1_IL_W0_V3  +  HH1_IL_W1_V3  +  HH1_IL_W2_V3  +  HH1_IL_W3_V3  + 
             HH2_IL_W0_V3  +  HH2_IL_W1_V3  +  HH2_IL_W2_V3  +  HH2_IL_W3_V3  + 
             HH3_IL_W0_V3  +  HH3_IL_W1_V3  +  HH3_IL_W2_V3  +  HH3_IL_W3_V3  + 
             HH4_IL_W0_V3  +  HH4_IL_W1_V3  +  HH4_IL_W2_V3  +  HH4_IL_W3_V3  + 
             HH5_IL_W0_V3  +  HH5_IL_W1_V3  +  HH5_IL_W2_V3  +  HH5_IL_W3_V3  + 
             HH6_IL_W0_V3  +  HH6_IL_W1_V3  +  HH6_IL_W2_V3  +  HH6_IL_W3_V3  + 
             
             HH1_IH_W0_V3  +  HH1_IH_W1_V3  +  HH1_IH_W2_V3  +  HH1_IH_W3_V3  + 
             HH2_IH_W0_V3  +  HH2_IH_W1_V3  +  HH2_IH_W2_V3  +  HH2_IH_W3_V3  + 
             HH3_IH_W0_V3  +  HH3_IH_W1_V3  +  HH3_IH_W2_V3  +  HH3_IH_W3_V3  + 
             HH4_IH_W0_V3  +  HH4_IH_W1_V3  +  HH4_IH_W2_V3  +  HH4_IH_W3_V3  + 
             HH5_IH_W0_V3  +  HH5_IH_W1_V3  +  HH5_IH_W2_V3  +  HH5_IH_W3_V3  + 
             HH6_IH_W0_V3  +  HH6_IH_W1_V3  +  HH6_IH_W2_V3  +  HH6_IH_W3_V3  
        
           
        V2p  = V2 + V3
        
        VTot = V0 + V1 + V2p
        
        
        RO.V0   = V0  
        RO.V1   = V1  
        RO.V2p  = V2p 
        RO.Vtot = Vtot
        
        
        ;write to output file
        WRITE RECO=7
        
    ENDRUN
    
ENDLOOP ;purpose=1, 2




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n----------------------------------------------------------------------',
             '\nMODE CHOICE',
             '\n    Seg HBW-HBO Trips by Auto Own      ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN
    



*(DEL 01_Segmnt_TripsByDetailed.txt)
