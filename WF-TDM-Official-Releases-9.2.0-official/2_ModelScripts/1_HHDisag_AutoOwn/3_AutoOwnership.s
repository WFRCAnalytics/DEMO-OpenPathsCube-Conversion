
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 3_AutoOwnership.txt)



;get start time
ScriptStartTime = currenttime()




;estimates vehicle availability based on demographic data and information describing the
;urban environment
RUN PGM=MATRIX  MSG='Auto Ownership 3: Auto Own - determine number of autos owned in a household'

FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\Emp30MinTran.txt', Z=#1, emp30tran=#2
      ZDATI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'
      ZDATI[3] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Joint_HHSize_IncHiLo_Wrk.dbf'
      ZDATI[4] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
    
FILEO RECO[1] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH1_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S1ILW0V0, S1ILW0V1, S1ILW0V2, S1ILW0V3,
            S1ILW1V0, S1ILW1V1, S1ILW1V2, S1ILW1V3,
            S1ILW2V0, S1ILW2V1, S1ILW2V2, S1ILW2V3,
            S1ILW3V0, S1ILW3V1, S1ILW3V2, S1ILW3V3,
            S1IHW0V0, S1IHW0V1, S1IHW0V2, S1IHW0V3,
            S1IHW1V0, S1IHW1V1, S1IHW1V2, S1IHW1V3,
            S1IHW2V0, S1IHW2V1, S1IHW2V2, S1IHW2V3,
        S1IHW3V0, S1IHW3V1, S1IHW3V2, S1IHW3V3
    
      RECO[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH2_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S2ILW0V0, S2ILW0V1, S2ILW0V2, S2ILW0V3,
            S2ILW1V0, S2ILW1V1, S2ILW1V2, S2ILW1V3,
            S2ILW2V0, S2ILW2V1, S2ILW2V2, S2ILW2V3,
            S2ILW3V0, S2ILW3V1, S2ILW3V2, S2ILW3V3,
            S2IHW0V0, S2IHW0V1, S2IHW0V2, S2IHW0V3,
            S2IHW1V0, S2IHW1V1, S2IHW1V2, S2IHW1V3, 
            S2IHW2V0, S2IHW2V1, S2IHW2V2, S2IHW2V3,
            S2IHW3V0, S2IHW3V1, S2IHW3V2, S2IHW3V3
    
      RECO[3] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH3_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S3ILW0V0, S3ILW0V1, S3ILW0V2, S3ILW0V3,
            S3ILW1V0, S3ILW1V1, S3ILW1V2, S3ILW1V3,
            S3ILW2V0, S3ILW2V1, S3ILW2V2, S3ILW2V3,
            S3ILW3V0, S3ILW3V1, S3ILW3V2, S3ILW3V3,
            S3IHW0V0, S3IHW0V1, S3IHW0V2, S3IHW0V3,
            S3IHW1V0, S3IHW1V1, S3IHW1V2, S3IHW1V3,
            S3IHW2V0, S3IHW2V1, S3IHW2V2, S3IHW2V3,
            S3IHW3V0, S3IHW3V1, S3IHW3V2, S3IHW3V3
    
      RECO[4] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH4_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S4ILW0V0, S4ILW0V1, S4ILW0V2, S4ILW0V3,
            S4ILW1V0, S4ILW1V1, S4ILW1V2, S4ILW1V3,
            S4ILW2V0, S4ILW2V1, S4ILW2V2, S4ILW2V3,
            S4ILW3V0, S4ILW3V1, S4ILW3V2, S4ILW3V3,
            S4IHW0V0, S4IHW0V1, S4IHW0V2, S4IHW0V3,
            S4IHW1V0, S4IHW1V1, S4IHW1V2, S4IHW1V3,
            S4IHW2V0, S4IHW2V1, S4IHW2V2, S4IHW2V3,
            S4IHW3V0, S4IHW3V1, S4IHW3V2, S4IHW3V3
    
      RECO[5] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH5_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S5ILW0V0, S5ILW0V1, S5ILW0V2, S5ILW0V3,
            S5ILW1V0, S5ILW1V1, S5ILW1V2, S5ILW1V3,
            S5ILW2V0, S5ILW2V1, S5ILW2V2, S5ILW2V3,
            S5ILW3V0, S5ILW3V1, S5ILW3V2, S5ILW3V3,
            S5IHW0V0, S5IHW0V1, S5IHW0V2, S5IHW0V3,
            S5IHW1V0, S5IHW1V1, S5IHW1V2, S5IHW1V3,
            S5IHW2V0, S5IHW2V1, S5IHW2V2, S5IHW2V3,
            S5IHW3V0, S5IHW3V1, S5IHW3V2, S5IHW3V3
    
      RECO[6] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HH6_IncLoHi_Worker_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S6ILW0V0, S6ILW0V1, S6ILW0V2, S6ILW0V3,
            S6ILW1V0, S6ILW1V1, S6ILW1V2, S6ILW1V3,
            S6ILW2V0, S6ILW2V1, S6ILW2V2, S6ILW2V3,
            S6ILW3V0, S6ILW3V1, S6ILW3V2, S6ILW3V3,
            S6IHW0V0, S6IHW0V1, S6IHW0V2, S6IHW0V3,
            S6IHW1V0, S6IHW1V1, S6IHW1V2, S6IHW1V3,
            S6IHW2V0, S6IHW2V1, S6IHW2V2, S6IHW2V3,
            S6IHW3V0, S6IHW3V1, S6IHW3V2, S6IHW3V3
    
      RECO[7] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_HHSize_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            S1V0, S1V1, S1V2, S1V3,
            S2V0, S2V1, S2V2, S2V3,
            S3V0, S3V1, S3V2, S3V3,
            S4V0, S4V1, S4V2, S4V3,
            S5V0, S5V1, S5V2, S5V3,
            S6V0, S6V1, S6V2, S6V3,
            AUTOS(6.1), SUMHH(6.1), ApHH(6.2), SEHH(6.1),
            PctV0a(7.0), PctV1a(7.0), PctV2a(7.0), PctV3a(7.0)
        
      RECO[8] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_VehOwn.dbf', FORM=9.1,
        FIELDS=Z(5.0),
            HHV0, HHV1, HHV2, HHV3, V0, V1, V2, V3,
            AUTOS(6.1), SUMHH(6.1), ApHH(6.2), SEHH(6.1),
            PctV0b(7.0), PctV1b(7.0), PctV2b(7.0), PctV3b(7.0)
        

    
    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = @ZoneMsgRate@
    
    
    
    ;define arrays
    ARRAY U0veh     = ZONES,
          U1veh     = ZONES,
          U2veh     = ZONES,
          U3veh     = ZONES
    
    ;utility arrays
    ARRAY S1ILW0U0=ZONES, S1ILW0U1=ZONES, S1ILW0U2=ZONES,  ;low income arrays
          S1ILW1U0=ZONES, S1ILW1U1=ZONES, S1ILW1U2=ZONES,
          S1ILW2U0=ZONES, S1ILW2U1=ZONES, S1ILW2U2=ZONES,
          S1ILW3U0=ZONES, S1ILW3U1=ZONES, S1ILW3U2=ZONES,
          
          S2ILW0U0=ZONES, S2ILW0U1=ZONES, S2ILW0U2=ZONES,
          S2ILW1U0=ZONES, S2ILW1U1=ZONES, S2ILW1U2=ZONES,
          S2ILW2U0=ZONES, S2ILW2U1=ZONES, S2ILW2U2=ZONES,
          S2ILW3U0=ZONES, S2ILW3U1=ZONES, S2ILW3U2=ZONES,
          
          S3ILW0U0=ZONES, S3ILW0U1=ZONES, S3ILW0U2=ZONES,
          S3ILW1U0=ZONES, S3ILW1U1=ZONES, S3ILW1U2=ZONES,
          S3ILW2U0=ZONES, S3ILW2U1=ZONES, S3ILW2U2=ZONES,
          S3ILW3U0=ZONES, S3ILW3U1=ZONES, S3ILW3U2=ZONES,
          
          S4ILW0U0=ZONES, S4ILW0U1=ZONES, S4ILW0U2=ZONES,
          S4ILW1U0=ZONES, S4ILW1U1=ZONES, S4ILW1U2=ZONES,
          S4ILW2U0=ZONES, S4ILW2U1=ZONES, S4ILW2U2=ZONES,
          S4ILW3U0=ZONES, S4ILW3U1=ZONES, S4ILW3U2=ZONES,
          
          S5ILW0U0=ZONES, S5ILW0U1=ZONES, S5ILW0U2=ZONES,
          S5ILW1U0=ZONES, S5ILW1U1=ZONES, S5ILW1U2=ZONES,
          S5ILW2U0=ZONES, S5ILW2U1=ZONES, S5ILW2U2=ZONES,
          S5ILW3U0=ZONES, S5ILW3U1=ZONES, S5ILW3U2=ZONES,
          
          S6ILW0U0=ZONES, S6ILW0U1=ZONES, S6ILW0U2=ZONES,
          S6ILW1U0=ZONES, S6ILW1U1=ZONES, S6ILW1U2=ZONES,
          S6ILW2U0=ZONES, S6ILW2U1=ZONES, S6ILW2U2=ZONES,
          S6ILW3U0=ZONES, S6ILW3U1=ZONES, S6ILW3U2=ZONES,

          S1IHW0U0=ZONES, S1IHW0U1=ZONES, S1IHW0U2=ZONES,  ;high income arrays
          S1IHW1U0=ZONES, S1IHW1U1=ZONES, S1IHW1U2=ZONES,
          S1IHW2U0=ZONES, S1IHW2U1=ZONES, S1IHW2U2=ZONES,
          S1IHW3U0=ZONES, S1IHW3U1=ZONES, S1IHW3U2=ZONES,
          
          S2IHW0U0=ZONES, S2IHW0U1=ZONES, S2IHW0U2=ZONES,
          S2IHW1U0=ZONES, S2IHW1U1=ZONES, S2IHW1U2=ZONES,
          S2IHW2U0=ZONES, S2IHW2U1=ZONES, S2IHW2U2=ZONES,
          S2IHW3U0=ZONES, S2IHW3U1=ZONES, S2IHW3U2=ZONES,
          
          S3IHW0U0=ZONES, S3IHW0U1=ZONES, S3IHW0U2=ZONES,
          S3IHW1U0=ZONES, S3IHW1U1=ZONES, S3IHW1U2=ZONES,
          S3IHW2U0=ZONES, S3IHW2U1=ZONES, S3IHW2U2=ZONES,
          S3IHW3U0=ZONES, S3IHW3U1=ZONES, S3IHW3U2=ZONES,
          
          S4IHW0U0=ZONES, S4IHW0U1=ZONES, S4IHW0U2=ZONES,
          S4IHW1U0=ZONES, S4IHW1U1=ZONES, S4IHW1U2=ZONES,
          S4IHW2U0=ZONES, S4IHW2U1=ZONES, S4IHW2U2=ZONES,
          S4IHW3U0=ZONES, S4IHW3U1=ZONES, S4IHW3U2=ZONES,
          
          S5IHW0U0=ZONES, S5IHW0U1=ZONES, S5IHW0U2=ZONES,
          S5IHW1U0=ZONES, S5IHW1U1=ZONES, S5IHW1U2=ZONES,
          S5IHW2U0=ZONES, S5IHW2U1=ZONES, S5IHW2U2=ZONES,
          S5IHW3U0=ZONES, S5IHW3U1=ZONES, S5IHW3U2=ZONES,
          
          S6IHW0U0=ZONES, S6IHW0U1=ZONES, S6IHW0U2=ZONES,
          S6IHW1U0=ZONES, S6IHW1U1=ZONES, S6IHW1U2=ZONES,
          S6IHW2U0=ZONES, S6IHW2U1=ZONES, S6IHW2U2=ZONES,
          S6IHW3U0=ZONES, S6IHW3U1=ZONES, S6IHW3U2=ZONES
          
    ;probability arrays
    ARRAY S1ILW0P0=ZONES, S1ILW0P1=ZONES, S1ILW0P2=ZONES, S1ILW0P3=ZONES,  ;low income arrays
          S1ILW1P0=ZONES, S1ILW1P1=ZONES, S1ILW1P2=ZONES, S1ILW1P3=ZONES,
          S1ILW2P0=ZONES, S1ILW2P1=ZONES, S1ILW2P2=ZONES, S1ILW2P3=ZONES,
          S1ILW3P0=ZONES, S1ILW3P1=ZONES, S1ILW3P2=ZONES, S1ILW3P3=ZONES,
          
          S2ILW0P0=ZONES, S2ILW0P1=ZONES, S2ILW0P2=ZONES, S2ILW0P3=ZONES,
          S2ILW1P0=ZONES, S2ILW1P1=ZONES, S2ILW1P2=ZONES, S2ILW1P3=ZONES,
          S2ILW2P0=ZONES, S2ILW2P1=ZONES, S2ILW2P2=ZONES, S2ILW2P3=ZONES,
          S2ILW3P0=ZONES, S2ILW3P1=ZONES, S2ILW3P2=ZONES, S2ILW3P3=ZONES,
          
          S3ILW0P0=ZONES, S3ILW0P1=ZONES, S3ILW0P2=ZONES, S3ILW0P3=ZONES,
          S3ILW1P0=ZONES, S3ILW1P1=ZONES, S3ILW1P2=ZONES, S3ILW1P3=ZONES,
          S3ILW2P0=ZONES, S3ILW2P1=ZONES, S3ILW2P2=ZONES, S3ILW2P3=ZONES,
          S3ILW3P0=ZONES, S3ILW3P1=ZONES, S3ILW3P2=ZONES, S3ILW3P3=ZONES,
                                                                         
          S4ILW0P0=ZONES, S4ILW0P1=ZONES, S4ILW0P2=ZONES, S4ILW0P3=ZONES,
          S4ILW1P0=ZONES, S4ILW1P1=ZONES, S4ILW1P2=ZONES, S4ILW1P3=ZONES,
          S4ILW2P0=ZONES, S4ILW2P1=ZONES, S4ILW2P2=ZONES, S4ILW2P3=ZONES,
          S4ILW3P0=ZONES, S4ILW3P1=ZONES, S4ILW3P2=ZONES, S4ILW3P3=ZONES,
                                                                         
          S5ILW0P0=ZONES, S5ILW0P1=ZONES, S5ILW0P2=ZONES, S5ILW0P3=ZONES,
          S5ILW1P0=ZONES, S5ILW1P1=ZONES, S5ILW1P2=ZONES, S5ILW1P3=ZONES,
          S5ILW2P0=ZONES, S5ILW2P1=ZONES, S5ILW2P2=ZONES, S5ILW2P3=ZONES,
          S5ILW3P0=ZONES, S5ILW3P1=ZONES, S5ILW3P2=ZONES, S5ILW3P3=ZONES,
                                                                         
          S6ILW0P0=ZONES, S6ILW0P1=ZONES, S6ILW0P2=ZONES, S6ILW0P3=ZONES,
          S6ILW1P0=ZONES, S6ILW1P1=ZONES, S6ILW1P2=ZONES, S6ILW1P3=ZONES,
          S6ILW2P0=ZONES, S6ILW2P1=ZONES, S6ILW2P2=ZONES, S6ILW2P3=ZONES,
          S6ILW3P0=ZONES, S6ILW3P1=ZONES, S6ILW3P2=ZONES, S6ILW3P3=ZONES,
                                                                         
          S1IHW0P0=ZONES, S1IHW0P1=ZONES, S1IHW0P2=ZONES, S1IHW0P3=ZONES,  ;high income arrays
          S1IHW1P0=ZONES, S1IHW1P1=ZONES, S1IHW1P2=ZONES, S1IHW1P3=ZONES,
          S1IHW2P0=ZONES, S1IHW2P1=ZONES, S1IHW2P2=ZONES, S1IHW2P3=ZONES,
          S1IHW3P0=ZONES, S1IHW3P1=ZONES, S1IHW3P2=ZONES, S1IHW3P3=ZONES,
                                                                         
          S2IHW0P0=ZONES, S2IHW0P1=ZONES, S2IHW0P2=ZONES, S2IHW0P3=ZONES,
          S2IHW1P0=ZONES, S2IHW1P1=ZONES, S2IHW1P2=ZONES, S2IHW1P3=ZONES,
          S2IHW2P0=ZONES, S2IHW2P1=ZONES, S2IHW2P2=ZONES, S2IHW2P3=ZONES,
          S2IHW3P0=ZONES, S2IHW3P1=ZONES, S2IHW3P2=ZONES, S2IHW3P3=ZONES,
                                                                         
          S3IHW0P0=ZONES, S3IHW0P1=ZONES, S3IHW0P2=ZONES, S3IHW0P3=ZONES,
          S3IHW1P0=ZONES, S3IHW1P1=ZONES, S3IHW1P2=ZONES, S3IHW1P3=ZONES,
          S3IHW2P0=ZONES, S3IHW2P1=ZONES, S3IHW2P2=ZONES, S3IHW2P3=ZONES,
          S3IHW3P0=ZONES, S3IHW3P1=ZONES, S3IHW3P2=ZONES, S3IHW3P3=ZONES,
                                                                         
          S4IHW0P0=ZONES, S4IHW0P1=ZONES, S4IHW0P2=ZONES, S4IHW0P3=ZONES,
          S4IHW1P0=ZONES, S4IHW1P1=ZONES, S4IHW1P2=ZONES, S4IHW1P3=ZONES,
          S4IHW2P0=ZONES, S4IHW2P1=ZONES, S4IHW2P2=ZONES, S4IHW2P3=ZONES,
          S4IHW3P0=ZONES, S4IHW3P1=ZONES, S4IHW3P2=ZONES, S4IHW3P3=ZONES,
                                                                         
          S5IHW0P0=ZONES, S5IHW0P1=ZONES, S5IHW0P2=ZONES, S5IHW0P3=ZONES,
          S5IHW1P0=ZONES, S5IHW1P1=ZONES, S5IHW1P2=ZONES, S5IHW1P3=ZONES,
          S5IHW2P0=ZONES, S5IHW2P1=ZONES, S5IHW2P2=ZONES, S5IHW2P3=ZONES,
          S5IHW3P0=ZONES, S5IHW3P1=ZONES, S5IHW3P2=ZONES, S5IHW3P3=ZONES,
                                                                         
          S6IHW0P0=ZONES, S6IHW0P1=ZONES, S6IHW0P2=ZONES, S6IHW0P3=ZONES,
          S6IHW1P0=ZONES, S6IHW1P1=ZONES, S6IHW1P2=ZONES, S6IHW1P3=ZONES,
          S6IHW2P0=ZONES, S6IHW2P1=ZONES, S6IHW2P2=ZONES, S6IHW2P3=ZONES,
          S6IHW3P0=ZONES, S6IHW3P1=ZONES, S6IHW3P2=ZONES, S6IHW3P3=ZONES
    
    
    
    ;calculate population density of nearest 5 zones
    PopDen5Zones = zi.2.POP5 / (zi.2.DEVACRE5+1)
    
    
    
    ;******************************** Utilities ********************************
    ;income loop
    LOOP IncLp=1, 2
        ;set low income flag
        if (IncLp=1)  
            INCL = 1
        else
            INCL = 0
        endif
        
        ;worker loop
        LOOP WorkLp=0, 3
            ;set number of workers flags
            if (WorkLp=0)
                WRK0 = 1
                WRK1 = 0
                WRK2 = 0
            elseif (WorkLp=1)
                WRK0 = 0
                WRK1 = 1
                WRK2 = 0
            elseif (WorkLp=2)
                WRK0 = 0
                WRK1 = 0
                WRK2 = 1
            else               ;parameters relative to 3+ workers, so just exclude WRK3
                WRK0 = 0
                WRK1 = 0
                WRK2 = 0
            endif
            
            ;HH size loop
            LOOP HHSizeLp=1, 6
                if (HHSizeLp=1)
                    HH1 = 1
                    HH2 = 0
                    HH3 = 0
                    HH4 = 0
                elseif (HHSizeLp=2)
                    HH1 = 0
                    HH2 = 1
                    HH3 = 0
                    HH4 = 0
                elseif (HHSizeLp=3)
                    HH1 = 0
                    HH2 = 0
                    HH3 = 1
                    HH4 = 0
                elseif (HHSizeLp=4)
                    HH1 = 0
                    HH2 = 0
                    HH3 = 0
                    HH4 = 1
                else            ;parameters relative to 5+ HH, so just exclude HH5, HH6
                    HH1 = 0
                    HH2 = 0
                    HH3 = 0
                    HH4 = 0
                endif
                
                
                ;calculate auot ownership utility (note POPDEN and EMP30TRAN represent
                ;number of units, the remaining variables represent looping toggles set
                ;to 1 or 0)
                U0veh[I] = -5.007 + 3.671       * HH1            +
                                    1.036       * HH2            +
                                    0.186       * HH3            +
                                    0.001       * HH4            +
                                                                 
                                    0.998       * WRK0           +
                                    0           * WRK1           +
                                    0           * WRK2           +
                                                                 
                                    2.733       * INCL           +
                                                                 
                                    0.05159     * PopDen5Zones   +
                                    0.0000199   * zi.1.emp30tran 
                                                                 
                U1veh[I] = -2.185 + 3.441       * HH1            +
                                    1.016       * HH2            +
                                    0.134       * HH3            +
                                    -0.738      * HH4            +
                                                                
                                    0.514       * WRK0           +
                                    0.552       * WRK1           +
                                    0           * WRK2           +
                                                                 
                                    1.557       * INCL           +
                                                
                                    0.07346     * PopDen5Zones   +
                                    0.000008342 * zi.1.emp30tran 
                                                                 
                                                                 
                U2veh[I] = 0.148  + 0.951       * HH1            +
                                    0.758       * HH2            +
                                    -0.318      * HH3            +
                                    -0.793      * HH4            +
                                                                 
                                    0           * WRK0           +
                                    0.081       * WRK1           +
                                    0.07        * WRK2           +
                                                                 
                                    0.538       * INCL           +
                                    
                                    0.02366     * PopDen5Zones                   
                
                U3veh[I] = 0 ;U3 is 0 for EVERY case, so don't bother creating case specific arrays
                
                
                ;for debugging, make sure switches in loops work
                ;if (I=1 & IncLp=1 & WorkLp = 0 & HHSizeLp = 1)
                ;    PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_DebugUtility.csv', CSV=T, LIST=
                ;        'I', 'IncLp', 'WorkLp', 'HHSizeLp', 'INCL', 'WRK0', 'WRK1',
                ;        'WRK2', 'HH1', 'HH2', 'HH3', 'HH4', 'U0veh', 'U1veh', 'U2veh',
                ;        'U3veh'
                ;endif
                ;
                ;PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_DebugUtility.csv', CSV=T, FORM=5.0, LIST=
                ;    I(6.0), IncLp, WorkLp, HHSizeLp, INCL, WRK0, WRK1, WRK2, HH1, HH2,
                ;    HH3, HH4, U0veh[I](7.3), U1veh[I](7.3), U2veh[I](7.3),
                ;    U3veh[I](7.3)
                
                
                ;set utility arrays
                ;low income
                if (IncLp=1)
                
                    ;0 workers
                    if (WorkLp=0)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1ILW0U0[I] = U0veh[I]
                            S1ILW0U1[I] = U1veh[I]
                            S1ILW0U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2ILW0U0[I] = U0veh[I]
                            S2ILW0U1[I] = U1veh[I]
                            S2ILW0U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3ILW0U0[I] = U0veh[I]
                            S3ILW0U1[I] = U1veh[I]
                            S3ILW0U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4ILW0U0[I] = U0veh[I]
                            S4ILW0U1[I] = U1veh[I]
                            S4ILW0U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5ILW0U0[I] = U0veh[I]
                            S5ILW0U1[I] = U1veh[I]
                            S5ILW0U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6ILW0U0[I] = U0veh[I]
                            S6ILW0U1[I] = U1veh[I]
                            S6ILW0U2[I] = U2veh[I]
                        endif
                    
                    ;1 worker
                    elseif (WorkLp=1)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1ILW1U0[I] = U0veh[I]
                            S1ILW1U1[I] = U1veh[I]
                            S1ILW1U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2ILW1U0[I] = U0veh[I]
                            S2ILW1U1[I] = U1veh[I]
                            S2ILW1U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3ILW1U0[I] = U0veh[I]
                            S3ILW1U1[I] = U1veh[I]
                            S3ILW1U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4ILW1U0[I] = U0veh[I]
                            S4ILW1U1[I] = U1veh[I]
                            S4ILW1U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5ILW1U0[I] = U0veh[I]
                            S5ILW1U1[I] = U1veh[I]
                            S5ILW1U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6ILW1U0[I] = U0veh[I]
                            S6ILW1U1[I] = U1veh[I]
                            S6ILW1U2[I] = U2veh[I]
                        endif
                       
                    ;2 workers
                    elseif (WorkLp=2)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1ILW2U0[I] = U0veh[I]
                            S1ILW2U1[I] = U1veh[I]
                            S1ILW2U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2ILW2U0[I] = U0veh[I]
                            S2ILW2U1[I] = U1veh[I]
                            S2ILW2U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3ILW2U0[I] = U0veh[I]
                            S3ILW2U1[I] = U1veh[I]
                            S3ILW2U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4ILW2U0[I] = U0veh[I]
                            S4ILW2U1[I] = U1veh[I]
                            S4ILW2U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5ILW2U0[I] = U0veh[I]
                            S5ILW2U1[I] = U1veh[I]
                            S5ILW2U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6ILW2U0[I] = U0veh[I]
                            S6ILW2U1[I] = U1veh[I]
                            S6ILW2U2[I] = U2veh[I]
                        endif
                    
                    ;3 workers
                    elseif (WorkLp=3)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1ILW3U0[I] = U0veh[I]
                            S1ILW3U1[I] = U1veh[I]
                            S1ILW3U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2ILW3U0[I] = U0veh[I]
                            S2ILW3U1[I] = U1veh[I]
                            S2ILW3U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3ILW3U0[I] = U0veh[I]
                            S3ILW3U1[I] = U1veh[I]
                            S3ILW3U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4ILW3U0[I] = U0veh[I]
                            S4ILW3U1[I] = U1veh[I]
                            S4ILW3U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5ILW3U0[I] = U0veh[I]
                            S5ILW3U1[I] = U1veh[I]
                            S5ILW3U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6ILW3U0[I] = U0veh[I]
                            S6ILW3U1[I] = U1veh[I]
                            S6ILW3U2[I] = U2veh[I]
                        endif
                        
                    endif  ;worker
                
                ;high income
                else
                
                    ;0 workers
                    if (WorkLp=0)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1IHW0U0[I] = U0veh[I]
                            S1IHW0U1[I] = U1veh[I]
                            S1IHW0U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2IHW0U0[I] = U0veh[I]
                            S2IHW0U1[I] = U1veh[I]
                            S2IHW0U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3IHW0U0[I] = U0veh[I]
                            S3IHW0U1[I] = U1veh[I]
                            S3IHW0U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4IHW0U0[I] = U0veh[I]
                            S4IHW0U1[I] = U1veh[I]
                            S4IHW0U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5IHW0U0[I] = U0veh[I]
                            S5IHW0U1[I] = U1veh[I]
                            S5IHW0U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6IHW0U0[I] = U0veh[I]
                            S6IHW0U1[I] = U1veh[I]
                            S6IHW0U2[I] = U2veh[I]
                        endif
                    
                    ;1 worker
                    elseif (WorkLp=1)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1IHW1U0[I] = U0veh[I]
                            S1IHW1U1[I] = U1veh[I]
                            S1IHW1U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2IHW1U0[I] = U0veh[I]
                            S2IHW1U1[I] = U1veh[I]
                            S2IHW1U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3IHW1U0[I] = U0veh[I]
                            S3IHW1U1[I] = U1veh[I]
                            S3IHW1U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4IHW1U0[I] = U0veh[I]
                            S4IHW1U1[I] = U1veh[I]
                            S4IHW1U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5IHW1U0[I] = U0veh[I]
                            S5IHW1U1[I] = U1veh[I]
                            S5IHW1U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6IHW1U0[I] = U0veh[I]
                            S6IHW1U1[I] = U1veh[I]
                            S6IHW1U2[I] = U2veh[I]
                        endif
                       
                    ;2 workers
                    elseif (WorkLp=2)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1IHW2U0[I] = U0veh[I]
                            S1IHW2U1[I] = U1veh[I]
                            S1IHW2U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2IHW2U0[I] = U0veh[I]
                            S2IHW2U1[I] = U1veh[I]
                            S2IHW2U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3IHW2U0[I] = U0veh[I]
                            S3IHW2U1[I] = U1veh[I]
                            S3IHW2U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4IHW2U0[I] = U0veh[I]
                            S4IHW2U1[I] = U1veh[I]
                            S4IHW2U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5IHW2U0[I] = U0veh[I]
                            S5IHW2U1[I] = U1veh[I]
                            S5IHW2U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6IHW2U0[I] = U0veh[I]
                            S6IHW2U1[I] = U1veh[I]
                            S6IHW2U2[I] = U2veh[I]
                        endif
                    
                    ;3 workers
                    elseif (WorkLp=3)
                        ;1 person HH
                        if (HHSizeLp=1)
                            S1IHW3U0[I] = U0veh[I]
                            S1IHW3U1[I] = U1veh[I]
                            S1IHW3U2[I] = U2veh[I]
                        ;2 person HH
                        elseif (HHSizeLp=2)
                            S2IHW3U0[I] = U0veh[I]
                            S2IHW3U1[I] = U1veh[I]
                            S2IHW3U2[I] = U2veh[I]
                        ;3 person HH
                        elseif (HHSizeLp=3)
                            S3IHW3U0[I] = U0veh[I]
                            S3IHW3U1[I] = U1veh[I]
                            S3IHW3U2[I] = U2veh[I]
                        ;4 person HH
                        elseif (HHSizeLp=4)
                            S4IHW3U0[I] = U0veh[I]
                            S4IHW3U1[I] = U1veh[I]
                            S4IHW3U2[I] = U2veh[I]
                        ;5 person HH
                        elseif (HHSizeLp=5)
                            S5IHW3U0[I] = U0veh[I]
                            S5IHW3U1[I] = U1veh[I]
                            S5IHW3U2[I] = U2veh[I]
                        ;6 person HH
                        elseif (HHSizeLp=6)
                            S6IHW3U0[I] = U0veh[I]
                            S6IHW3U1[I] = U1veh[I]
                            S6IHW3U2[I] = U2veh[I]
                        endif
                        
                    endif  ;worker
                    
                endif  ;income
                
            ENDLOOP ;HHSizeLp
            
        ENDLOOP ;WorkLp
        
    ENDLOOP  ;IncLp
    
    
    ;print low and hight income utilities to temp files
    if (I=1)
        PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Utility_LowInc.csv', CSV=T, FORM=9, LIST=
            ' Z',
            ' S1ILW0U0',' S1ILW0U1',' S1ILW0U2',' S1ILW0U3',
            ' S1ILW1U0',' S1ILW1U1',' S1ILW1U2',' S1ILW1U3',
            ' S1ILW2U0',' S1ILW2U1',' S1ILW2U2',' S1ILW2U3',
            ' S1ILW3U0',' S1ILW3U1',' S1ILW3U2',' S1ILW3U3',
            
            ' S2ILW0U0',' S2ILW0U1',' S2ILW0U2',' S2ILW0U3',
            ' S2ILW1U0',' S2ILW1U1',' S2ILW1U2',' S2ILW1U3',
            ' S2ILW2U0',' S2ILW2U1',' S2ILW2U2',' S2ILW2U3',
            ' S2ILW3U0',' S2ILW3U1',' S2ILW3U2',' S2ILW3U3',
                
            ' S3ILW0U0',' S3ILW0U1',' S3ILW0U2',' S3ILW0U3',
            ' S3ILW1U0',' S3ILW1U1',' S3ILW1U2',' S3ILW1U3',
            ' S3ILW2U0',' S3ILW2U1',' S3ILW2U2',' S3ILW2U3',
            ' S3ILW3U0',' S3ILW3U1',' S3ILW3U2',' S3ILW3U3',
                
            ' S4ILW0U0',' S4ILW0U1',' S4ILW0U2',' S4ILW0U3',
            ' S4ILW1U0',' S4ILW1U1',' S4ILW1U2',' S4ILW1U3',
            ' S4ILW2U0',' S4ILW2U1',' S4ILW2U2',' S4ILW2U3',
            ' S4ILW3U0',' S4ILW3U1',' S4ILW3U2',' S4ILW3U3',
                    
            ' S5ILW0U0',' S5ILW0U1',' S5ILW0U2',' S5ILW0U3',
            ' S5ILW1U0',' S5ILW1U1',' S5ILW1U2',' S5ILW1U3',
            ' S5ILW2U0',' S5ILW2U1',' S5ILW2U2',' S5ILW2U3',
            ' S5ILW3U0',' S5ILW3U1',' S5ILW3U2',' S5ILW3U3',
                    
            ' S6ILW0U0',' S6ILW0U1',' S6ILW0U2',' S6ILW0U3',
            ' S6ILW1U0',' S6ILW1U1',' S6ILW1U2',' S6ILW1U3',
            ' S6ILW2U0',' S6ILW2U1',' S6ILW2U2',' S6ILW2U3',
            ' S6ILW3U0',' S6ILW3U1',' S6ILW3U2',' S6ILW3U3'
        
        PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Utility_HiInc.csv', CSV=T, FORM=9, LIST=
            '     Z',
            ' S1IHW0U0',' S1IHW0U1',' S1IHW0U2',' S1IHW0U3',
            ' S1IHW1U0',' S1IHW1U1',' S1IHW1U2',' S1IHW1U3',
            ' S1IHW2U0',' S1IHW2U1',' S1IHW2U2',' S1IHW2U3',
            ' S1IHW3U0',' S1IHW3U1',' S1IHW3U2',' S1IHW3U3',
            
            ' S2IHW0U0',' S2IHW0U1',' S2IHW0U2',' S2IHW0U3',
            ' S2IHW1U0',' S2IHW1U1',' S2IHW1U2',' S2IHW1U3',
            ' S2IHW2U0',' S2IHW2U1',' S2IHW2U2',' S2IHW2U3',
            ' S2IHW3U0',' S2IHW3U1',' S2IHW3U2',' S2IHW3U3',
                
            ' S3IHW0U0',' S3IHW0U1',' S3IHW0U2',' S3IHW0U3',
            ' S3IHW1U0',' S3IHW1U1',' S3IHW1U2',' S3IHW1U3',
            ' S3IHW2U0',' S3IHW2U1',' S3IHW2U2',' S3IHW2U3',
            ' S3IHW3U0',' S3IHW3U1',' S3IHW3U2',' S3IHW3U3',
                
            ' S4IHW0U0',' S4IHW0U1',' S4IHW0U2',' S4IHW0U3',
            ' S4IHW1U0',' S4IHW1U1',' S4IHW1U2',' S4IHW1U3',
            ' S4IHW2U0',' S4IHW2U1',' S4IHW2U2',' S4IHW2U3',
            ' S4IHW3U0',' S4IHW3U1',' S4IHW3U2',' S4IHW3U3',
                    
            ' S5IHW0U0',' S5IHW0U1',' S5IHW0U2',' S5IHW0U3',
            ' S5IHW1U0',' S5IHW1U1',' S5IHW1U2',' S5IHW1U3',
            ' S5IHW2U0',' S5IHW2U1',' S5IHW2U2',' S5IHW2U3',
            ' S5IHW3U0',' S5IHW3U1',' S5IHW3U2',' S5IHW3U3',
                    
            ' S6IHW0U0',' S6IHW0U1',' S6IHW0U2',' S6IHW0U3',
            ' S6IHW1U0',' S6IHW1U1',' S6IHW1U2',' S6IHW1U3',
            ' S6IHW2U0',' S6IHW2U1',' S6IHW2U2',' S6IHW2U3',
            ' S6IHW3U0',' S6IHW3U1',' S6IHW3U2',' S6IHW3U3'
    endif
    
    PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Utility_LowInc.csv', CSV=T, FORM=9.3, LIST=I(6),
        S1ILW0U0[I], S1ILW0U1[I], S1ILW0U2[I], 0, 
        S1ILW1U0[I], S1ILW1U1[I], S1ILW1U2[I], 0, 
        S1ILW2U0[I], S1ILW2U1[I], S1ILW2U2[I], 0, 
        S1ILW3U0[I], S1ILW3U1[I], S1ILW3U2[I], 0, 
        
        S2ILW0U0[I], S2ILW0U1[I], S2ILW0U2[I], 0, 
        S2ILW1U0[I], S2ILW1U1[I], S2ILW1U2[I], 0, 
        S2ILW2U0[I], S2ILW2U1[I], S2ILW2U2[I], 0, 
        S2ILW3U0[I], S2ILW3U1[I], S2ILW3U2[I], 0, 
            
        S3ILW0U0[I], S3ILW0U1[I], S3ILW0U2[I], 0, 
        S3ILW1U0[I], S3ILW1U1[I], S3ILW1U2[I], 0, 
        S3ILW2U0[I], S3ILW2U1[I], S3ILW2U2[I], 0, 
        S3ILW3U0[I], S3ILW3U1[I], S3ILW3U2[I], 0, 
            
        S4ILW0U0[I], S4ILW0U1[I], S4ILW0U2[I], 0, 
        S4ILW1U0[I], S4ILW1U1[I], S4ILW1U2[I], 0, 
        S4ILW2U0[I], S4ILW2U1[I], S4ILW2U2[I], 0, 
        S4ILW3U0[I], S4ILW3U1[I], S4ILW3U2[I], 0,
                
        S5ILW0U0[I], S5ILW0U1[I], S5ILW0U2[I], 0, 
        S5ILW1U0[I], S5ILW1U1[I], S5ILW1U2[I], 0, 
        S5ILW2U0[I], S5ILW2U1[I], S5ILW2U2[I], 0, 
        S5ILW3U0[I], S5ILW3U1[I], S5ILW3U2[I], 0,
                
        S6ILW0U0[I], S6ILW0U1[I], S6ILW0U2[I], 0, 
        S6ILW1U0[I], S6ILW1U1[I], S6ILW1U2[I], 0, 
        S6ILW2U0[I], S6ILW2U1[I], S6ILW2U2[I], 0, 
        S6ILW3U0[I], S6ILW3U1[I], S6ILW3U2[I], 0
      
    PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Utility_HiInc.csv', CSV=T, FORM=9.3, LIST=I(6),
        S1IHW0U0[I], S1IHW0U1[I], S1IHW0U2[I], 0, 
        S1IHW1U0[I], S1IHW1U1[I], S1IHW1U2[I], 0, 
        S1IHW2U0[I], S1IHW2U1[I], S1IHW2U2[I], 0, 
        S1IHW3U0[I], S1IHW3U1[I], S1IHW3U2[I], 0, 
        
        S2IHW0U0[I], S2IHW0U1[I], S2IHW0U2[I], 0, 
        S2IHW1U0[I], S2IHW1U1[I], S2IHW1U2[I], 0, 
        S2IHW2U0[I], S2IHW2U1[I], S2IHW2U2[I], 0, 
        S2IHW3U0[I], S2IHW3U1[I], S2IHW3U2[I], 0, 
            
        S3IHW0U0[I], S3IHW0U1[I], S3IHW0U2[I], 0, 
        S3IHW1U0[I], S3IHW1U1[I], S3IHW1U2[I], 0, 
        S3IHW2U0[I], S3IHW2U1[I], S3IHW2U2[I], 0, 
        S3IHW3U0[I], S3IHW3U1[I], S3IHW3U2[I], 0, 
            
        S4IHW0U0[I], S4IHW0U1[I], S4IHW0U2[I], 0, 
        S4IHW1U0[I], S4IHW1U1[I], S4IHW1U2[I], 0, 
        S4IHW2U0[I], S4IHW2U1[I], S4IHW2U2[I], 0, 
        S4IHW3U0[I], S4IHW3U1[I], S4IHW3U2[I], 0,
                
        S5IHW0U0[I], S5IHW0U1[I], S5IHW0U2[I], 0, 
        S5IHW1U0[I], S5IHW1U1[I], S5IHW1U2[I], 0, 
        S5IHW2U0[I], S5IHW2U1[I], S5IHW2U2[I], 0, 
        S5IHW3U0[I], S5IHW3U1[I], S5IHW3U2[I], 0,
                
        S6IHW0U0[I], S6IHW0U1[I], S6IHW0U2[I], 0, 
        S6IHW1U0[I], S6IHW1U1[I], S6IHW1U2[I], 0, 
        S6IHW2U0[I], S6IHW2U1[I], S6IHW2U2[I], 0, 
        S6IHW3U0[I], S6IHW3U1[I], S6IHW3U2[I], 0
    
    
    
    ;******************************** Probabilities ********************************
    ;calculate low income
        ;1 person HH
        S1ILW0P0[I] = EXP(S1ILW0U0[I]) / (EXP(S1ILW0U0[I]) + EXP(S1ILW0U1[I]) + EXP(S1ILW0U2[I]) + EXP(U3veh[I]))
        S1ILW0P1[I] = EXP(S1ILW0U1[I]) / (EXP(S1ILW0U0[I]) + EXP(S1ILW0U1[I]) + EXP(S1ILW0U2[I]) + EXP(U3veh[I]))
        S1ILW0P2[I] = EXP(S1ILW0U2[I]) / (EXP(S1ILW0U0[I]) + EXP(S1ILW0U1[I]) + EXP(S1ILW0U2[I]) + EXP(U3veh[I]))
        S1ILW0P3[I] = 1.00 - (S1ILW0P0[I] + S1ILW0P1[I] + S1ILW0P2[I])
        
        S1ILW1P0[I] = EXP(S1ILW1U0[I]) / (EXP(S1ILW1U0[I]) + EXP(S1ILW1U1[I]) + EXP(S1ILW1U2[I]) + EXP(U3veh[I]))
        S1ILW1P1[I] = EXP(S1ILW1U1[I]) / (EXP(S1ILW1U0[I]) + EXP(S1ILW1U1[I]) + EXP(S1ILW1U2[I]) + EXP(U3veh[I]))
        S1ILW1P2[I] = EXP(S1ILW1U2[I]) / (EXP(S1ILW1U0[I]) + EXP(S1ILW1U1[I]) + EXP(S1ILW1U2[I]) + EXP(U3veh[I]))
        S1ILW1P3[I] = 1.00 - (S1ILW1P0[I] + S1ILW1P1[I] + S1ILW1P2[I])
          
        S1ILW2P0[I] = EXP(S1ILW2U0[I]) / (EXP(S1ILW2U0[I]) + EXP(S1ILW2U1[I]) + EXP(S1ILW2U2[I]) + EXP(U3veh[I]))
        S1ILW2P1[I] = EXP(S1ILW2U1[I]) / (EXP(S1ILW2U0[I]) + EXP(S1ILW2U1[I]) + EXP(S1ILW2U2[I]) + EXP(U3veh[I]))
        S1ILW2P2[I] = EXP(S1ILW2U2[I]) / (EXP(S1ILW2U0[I]) + EXP(S1ILW2U1[I]) + EXP(S1ILW2U2[I]) + EXP(U3veh[I]))
        S1ILW2P3[I] = 1.00 - (S1ILW2P0[I] + S1ILW2P1[I] + S1ILW2P2[I])
          
        S1ILW3P0[I] = EXP(S1ILW3U0[I]) / (EXP(S1ILW3U0[I]) + EXP(S1ILW3U1[I]) + EXP(S1ILW3U2[I]) + EXP(U3veh[I]))
        S1ILW3P1[I] = EXP(S1ILW3U1[I]) / (EXP(S1ILW3U0[I]) + EXP(S1ILW3U1[I]) + EXP(S1ILW3U2[I]) + EXP(U3veh[I]))
        S1ILW3P2[I] = EXP(S1ILW3U2[I]) / (EXP(S1ILW3U0[I]) + EXP(S1ILW3U1[I]) + EXP(S1ILW3U2[I]) + EXP(U3veh[I]))
        S1ILW3P3[I] = 1.00 - (S1ILW3P0[I] + S1ILW3P1[I] + S1ILW3P2[I])
        
        
        ;2 person HH
        S2ILW0P0[I] = EXP(S2ILW0U0[I]) / (EXP(S2ILW0U0[I]) + EXP(S2ILW0U1[I]) + EXP(S2ILW0U2[I]) + EXP(U3veh[I]))
        S2ILW0P1[I] = EXP(S2ILW0U1[I]) / (EXP(S2ILW0U0[I]) + EXP(S2ILW0U1[I]) + EXP(S2ILW0U2[I]) + EXP(U3veh[I]))
        S2ILW0P2[I] = EXP(S2ILW0U2[I]) / (EXP(S2ILW0U0[I]) + EXP(S2ILW0U1[I]) + EXP(S2ILW0U2[I]) + EXP(U3veh[I]))
        S2ILW0P3[I] = 1.00 - (S2ILW0P0[I] + S2ILW0P1[I] + S2ILW0P2[I])
          
        S2ILW1P0[I] = EXP(S2ILW1U0[I]) / (EXP(S2ILW1U0[I]) + EXP(S2ILW1U1[I]) + EXP(S2ILW1U2[I]) + EXP(U3veh[I]))
        S2ILW1P1[I] = EXP(S2ILW1U1[I]) / (EXP(S2ILW1U0[I]) + EXP(S2ILW1U1[I]) + EXP(S2ILW1U2[I]) + EXP(U3veh[I]))
        S2ILW1P2[I] = EXP(S2ILW1U2[I]) / (EXP(S2ILW1U0[I]) + EXP(S2ILW1U1[I]) + EXP(S2ILW1U2[I]) + EXP(U3veh[I]))
        S2ILW1P3[I] = 1.00 - (S2ILW1P0[I] + S2ILW1P1[I] + S2ILW1P2[I])
          
        S2ILW2P0[I] = EXP(S2ILW2U0[I]) / (EXP(S2ILW2U0[I]) + EXP(S2ILW2U1[I]) + EXP(S2ILW2U2[I]) + EXP(U3veh[I]))
        S2ILW2P1[I] = EXP(S2ILW2U1[I]) / (EXP(S2ILW2U0[I]) + EXP(S2ILW2U1[I]) + EXP(S2ILW2U2[I]) + EXP(U3veh[I]))
        S2ILW2P2[I] = EXP(S2ILW2U2[I]) / (EXP(S2ILW2U0[I]) + EXP(S2ILW2U1[I]) + EXP(S2ILW2U2[I]) + EXP(U3veh[I]))
        S2ILW2P3[I] = 1.00 - (S2ILW2P0[I] + S2ILW2P1[I] + S2ILW2P2[I])
          
        S2ILW3P0[I] = EXP(S2ILW3U0[I]) / (EXP(S2ILW3U0[I]) + EXP(S2ILW3U1[I]) + EXP(S2ILW3U2[I]) + EXP(U3veh[I]))
        S2ILW3P1[I] = EXP(S2ILW3U1[I]) / (EXP(S2ILW3U0[I]) + EXP(S2ILW3U1[I]) + EXP(S2ILW3U2[I]) + EXP(U3veh[I]))
        S2ILW3P2[I] = EXP(S2ILW3U2[I]) / (EXP(S2ILW3U0[I]) + EXP(S2ILW3U1[I]) + EXP(S2ILW3U2[I]) + EXP(U3veh[I]))
        S2ILW3P3[I] = 1.00 - (S2ILW3P0[I] + S2ILW3P1[I] + S2ILW3P2[I])
        
        
        ;3 person HH
        S3ILW0P0[I] = EXP(S3ILW0U0[I]) / (EXP(S3ILW0U0[I]) + EXP(S3ILW0U1[I]) + EXP(S3ILW0U2[I]) + EXP(U3veh[I]))
        S3ILW0P1[I] = EXP(S3ILW0U1[I]) / (EXP(S3ILW0U0[I]) + EXP(S3ILW0U1[I]) + EXP(S3ILW0U2[I]) + EXP(U3veh[I]))
        S3ILW0P2[I] = EXP(S3ILW0U2[I]) / (EXP(S3ILW0U0[I]) + EXP(S3ILW0U1[I]) + EXP(S3ILW0U2[I]) + EXP(U3veh[I]))
        S3ILW0P3[I] = 1.00 - (S3ILW0P0[I] + S3ILW0P1[I] + S3ILW0P2[I])
          
        S3ILW1P0[I] = EXP(S3ILW1U0[I]) / (EXP(S3ILW1U0[I]) + EXP(S3ILW1U1[I]) + EXP(S3ILW1U2[I]) + EXP(U3veh[I]))
        S3ILW1P1[I] = EXP(S3ILW1U1[I]) / (EXP(S3ILW1U0[I]) + EXP(S3ILW1U1[I]) + EXP(S3ILW1U2[I]) + EXP(U3veh[I]))
        S3ILW1P2[I] = EXP(S3ILW1U2[I]) / (EXP(S3ILW1U0[I]) + EXP(S3ILW1U1[I]) + EXP(S3ILW1U2[I]) + EXP(U3veh[I]))
        S3ILW1P3[I] = 1.00 - (S3ILW1P0[I] + S3ILW1P1[I] + S3ILW1P2[I])
          
        S3ILW2P0[I] = EXP(S3ILW2U0[I]) / (EXP(S3ILW2U0[I]) + EXP(S3ILW2U1[I]) + EXP(S3ILW2U2[I]) + EXP(U3veh[I]))
        S3ILW2P1[I] = EXP(S3ILW2U1[I]) / (EXP(S3ILW2U0[I]) + EXP(S3ILW2U1[I]) + EXP(S3ILW2U2[I]) + EXP(U3veh[I]))
        S3ILW2P2[I] = EXP(S3ILW2U2[I]) / (EXP(S3ILW2U0[I]) + EXP(S3ILW2U1[I]) + EXP(S3ILW2U2[I]) + EXP(U3veh[I]))
        S3ILW2P3[I] = 1.00 - (S3ILW2P0[I] + S3ILW2P1[I] + S3ILW2P2[I])
          
        S3ILW3P0[I] = EXP(S3ILW3U0[I]) / (EXP(S3ILW3U0[I]) + EXP(S3ILW3U1[I]) + EXP(S3ILW3U2[I]) + EXP(U3veh[I]))
        S3ILW3P1[I] = EXP(S3ILW3U1[I]) / (EXP(S3ILW3U0[I]) + EXP(S3ILW3U1[I]) + EXP(S3ILW3U2[I]) + EXP(U3veh[I]))
        S3ILW3P2[I] = EXP(S3ILW3U2[I]) / (EXP(S3ILW3U0[I]) + EXP(S3ILW3U1[I]) + EXP(S3ILW3U2[I]) + EXP(U3veh[I]))
        S3ILW3P3[I] = 1.00 - (S3ILW3P0[I] + S3ILW3P1[I] + S3ILW3P2[I])
        
        
        ;4 person HH
        S4ILW0P0[I] = EXP(S4ILW0U0[I]) / (EXP(S4ILW0U0[I]) + EXP(S4ILW0U1[I]) + EXP(S4ILW0U2[I]) + EXP(U3veh[I]))
        S4ILW0P1[I] = EXP(S4ILW0U1[I]) / (EXP(S4ILW0U0[I]) + EXP(S4ILW0U1[I]) + EXP(S4ILW0U2[I]) + EXP(U3veh[I]))
        S4ILW0P2[I] = EXP(S4ILW0U2[I]) / (EXP(S4ILW0U0[I]) + EXP(S4ILW0U1[I]) + EXP(S4ILW0U2[I]) + EXP(U3veh[I]))
        S4ILW0P3[I] = 1.00 - (S4ILW0P0[I] + S4ILW0P1[I] + S4ILW0P2[I])
          
        S4ILW1P0[I] = EXP(S4ILW1U0[I]) / (EXP(S4ILW1U0[I]) + EXP(S4ILW1U1[I]) + EXP(S4ILW1U2[I]) + EXP(U3veh[I]))
        S4ILW1P1[I] = EXP(S4ILW1U1[I]) / (EXP(S4ILW1U0[I]) + EXP(S4ILW1U1[I]) + EXP(S4ILW1U2[I]) + EXP(U3veh[I]))
        S4ILW1P2[I] = EXP(S4ILW1U2[I]) / (EXP(S4ILW1U0[I]) + EXP(S4ILW1U1[I]) + EXP(S4ILW1U2[I]) + EXP(U3veh[I]))
        S4ILW1P3[I] = 1.00 - (S4ILW1P0[I] + S4ILW1P1[I] + S4ILW1P2[I])
          
        S4ILW2P0[I] = EXP(S4ILW2U0[I]) / (EXP(S4ILW2U0[I]) + EXP(S4ILW2U1[I]) + EXP(S4ILW2U2[I]) + EXP(U3veh[I]))
        S4ILW2P1[I] = EXP(S4ILW2U1[I]) / (EXP(S4ILW2U0[I]) + EXP(S4ILW2U1[I]) + EXP(S4ILW2U2[I]) + EXP(U3veh[I]))
        S4ILW2P2[I] = EXP(S4ILW2U2[I]) / (EXP(S4ILW2U0[I]) + EXP(S4ILW2U1[I]) + EXP(S4ILW2U2[I]) + EXP(U3veh[I]))
        S4ILW2P3[I] = 1.00 - (S4ILW2P0[I] + S4ILW2P1[I] + S4ILW2P2[I])
          
        S4ILW3P0[I] = EXP(S4ILW3U0[I]) / (EXP(S4ILW3U0[I]) + EXP(S4ILW3U1[I]) + EXP(S4ILW3U2[I]) + EXP(U3veh[I]))
        S4ILW3P1[I] = EXP(S4ILW3U1[I]) / (EXP(S4ILW3U0[I]) + EXP(S4ILW3U1[I]) + EXP(S4ILW3U2[I]) + EXP(U3veh[I]))
        S4ILW3P2[I] = EXP(S4ILW3U2[I]) / (EXP(S4ILW3U0[I]) + EXP(S4ILW3U1[I]) + EXP(S4ILW3U2[I]) + EXP(U3veh[I]))
        S4ILW3P3[I] = 1.00 - (S4ILW3P0[I] + S4ILW3P1[I] + S4ILW3P2[I])
        
        
        ;5 person HH
        S5ILW0P0[I] = EXP(S5ILW0U0[I]) / (EXP(S5ILW0U0[I]) + EXP(S5ILW0U1[I]) + EXP(S5ILW0U2[I]) + EXP(U3veh[I]))
        S5ILW0P1[I] = EXP(S5ILW0U1[I]) / (EXP(S5ILW0U0[I]) + EXP(S5ILW0U1[I]) + EXP(S5ILW0U2[I]) + EXP(U3veh[I]))
        S5ILW0P2[I] = EXP(S5ILW0U2[I]) / (EXP(S5ILW0U0[I]) + EXP(S5ILW0U1[I]) + EXP(S5ILW0U2[I]) + EXP(U3veh[I]))
        S5ILW0P3[I] = 1.00 - (S5ILW0P0[I] + S5ILW0P1[I] + S5ILW0P2[I])
          
        S5ILW1P0[I] = EXP(S5ILW1U0[I]) / (EXP(S5ILW1U0[I]) + EXP(S5ILW1U1[I]) + EXP(S5ILW1U2[I]) + EXP(U3veh[I]))
        S5ILW1P1[I] = EXP(S5ILW1U1[I]) / (EXP(S5ILW1U0[I]) + EXP(S5ILW1U1[I]) + EXP(S5ILW1U2[I]) + EXP(U3veh[I]))
        S5ILW1P2[I] = EXP(S5ILW1U2[I]) / (EXP(S5ILW1U0[I]) + EXP(S5ILW1U1[I]) + EXP(S5ILW1U2[I]) + EXP(U3veh[I]))
        S5ILW1P3[I] = 1.00 - (S5ILW1P0[I] + S5ILW1P1[I] + S5ILW1P2[I])
          
        S5ILW2P0[I] = EXP(S5ILW2U0[I]) / (EXP(S5ILW2U0[I]) + EXP(S5ILW2U1[I]) + EXP(S5ILW2U2[I]) + EXP(U3veh[I]))
        S5ILW2P1[I] = EXP(S5ILW2U1[I]) / (EXP(S5ILW2U0[I]) + EXP(S5ILW2U1[I]) + EXP(S5ILW2U2[I]) + EXP(U3veh[I]))
        S5ILW2P2[I] = EXP(S5ILW2U2[I]) / (EXP(S5ILW2U0[I]) + EXP(S5ILW2U1[I]) + EXP(S5ILW2U2[I]) + EXP(U3veh[I]))
        S5ILW2P3[I] = 1.00 - (S5ILW2P0[I] + S5ILW2P1[I] + S5ILW2P2[I])
          
        S5ILW3P0[I] = EXP(S5ILW3U0[I]) / (EXP(S5ILW3U0[I]) + EXP(S5ILW3U1[I]) + EXP(S5ILW3U2[I]) + EXP(U3veh[I]))
        S5ILW3P1[I] = EXP(S5ILW3U1[I]) / (EXP(S5ILW3U0[I]) + EXP(S5ILW3U1[I]) + EXP(S5ILW3U2[I]) + EXP(U3veh[I]))
        S5ILW3P2[I] = EXP(S5ILW3U2[I]) / (EXP(S5ILW3U0[I]) + EXP(S5ILW3U1[I]) + EXP(S5ILW3U2[I]) + EXP(U3veh[I]))
        S5ILW3P3[I] = 1.00 - (S5ILW3P0[I] + S5ILW3P1[I] + S5ILW3P2[I])
        
        
        ;6 person HH
        S6ILW0P0[I] = EXP(S6ILW0U0[I]) / (EXP(S6ILW0U0[I]) + EXP(S6ILW0U1[I]) + EXP(S6ILW0U2[I]) + EXP(U3veh[I]))
        S6ILW0P1[I] = EXP(S6ILW0U1[I]) / (EXP(S6ILW0U0[I]) + EXP(S6ILW0U1[I]) + EXP(S6ILW0U2[I]) + EXP(U3veh[I]))
        S6ILW0P2[I] = EXP(S6ILW0U2[I]) / (EXP(S6ILW0U0[I]) + EXP(S6ILW0U1[I]) + EXP(S6ILW0U2[I]) + EXP(U3veh[I]))
        S6ILW0P3[I] = 1.00 - (S6ILW0P0[I] + S6ILW0P1[I] + S6ILW0P2[I])
          
        S6ILW1P0[I] = EXP(S6ILW1U0[I]) / (EXP(S6ILW1U0[I]) + EXP(S6ILW1U1[I]) + EXP(S6ILW1U2[I]) + EXP(U3veh[I]))
        S6ILW1P1[I] = EXP(S6ILW1U1[I]) / (EXP(S6ILW1U0[I]) + EXP(S6ILW1U1[I]) + EXP(S6ILW1U2[I]) + EXP(U3veh[I]))
        S6ILW1P2[I] = EXP(S6ILW1U2[I]) / (EXP(S6ILW1U0[I]) + EXP(S6ILW1U1[I]) + EXP(S6ILW1U2[I]) + EXP(U3veh[I]))
        S6ILW1P3[I] = 1.00 - (S6ILW1P0[I] + S6ILW1P1[I] + S6ILW1P2[I])
          
        S6ILW2P0[I] = EXP(S6ILW2U0[I]) / (EXP(S6ILW2U0[I]) + EXP(S6ILW2U1[I]) + EXP(S6ILW2U2[I]) + EXP(U3veh[I]))
        S6ILW2P1[I] = EXP(S6ILW2U1[I]) / (EXP(S6ILW2U0[I]) + EXP(S6ILW2U1[I]) + EXP(S6ILW2U2[I]) + EXP(U3veh[I]))
        S6ILW2P2[I] = EXP(S6ILW2U2[I]) / (EXP(S6ILW2U0[I]) + EXP(S6ILW2U1[I]) + EXP(S6ILW2U2[I]) + EXP(U3veh[I]))
        S6ILW2P3[I] = 1.00 - (S6ILW2P0[I] + S6ILW2P1[I] + S6ILW2P2[I])
          
        S6ILW3P0[I] = EXP(S6ILW3U0[I]) / (EXP(S6ILW3U0[I]) + EXP(S6ILW3U1[I]) + EXP(S6ILW3U2[I]) + EXP(U3veh[I]))
        S6ILW3P1[I] = EXP(S6ILW3U1[I]) / (EXP(S6ILW3U0[I]) + EXP(S6ILW3U1[I]) + EXP(S6ILW3U2[I]) + EXP(U3veh[I]))
        S6ILW3P2[I] = EXP(S6ILW3U2[I]) / (EXP(S6ILW3U0[I]) + EXP(S6ILW3U1[I]) + EXP(S6ILW3U2[I]) + EXP(U3veh[I]))
        S6ILW3P3[I] = 1.00 - (S6ILW3P0[I] + S6ILW3P1[I] + S6ILW3P2[I])
    
    
    ;calculate high income
        ;1 person HH
        S1IHW0P0[I] = EXP(S1IHW0U0[I]) / (EXP(S1IHW0U0[I]) + EXP(S1IHW0U1[I]) + EXP(S1IHW0U2[I]) + EXP(U3veh[I]))
        S1IHW0P1[I] = EXP(S1IHW0U1[I]) / (EXP(S1IHW0U0[I]) + EXP(S1IHW0U1[I]) + EXP(S1IHW0U2[I]) + EXP(U3veh[I]))
        S1IHW0P2[I] = EXP(S1IHW0U2[I]) / (EXP(S1IHW0U0[I]) + EXP(S1IHW0U1[I]) + EXP(S1IHW0U2[I]) + EXP(U3veh[I]))
        S1IHW0P3[I] = 1.00 - (S1IHW0P0[I] + S1IHW0P1[I] + S1IHW0P2[I])
        
        S1IHW1P0[I] = EXP(S1IHW1U0[I]) / (EXP(S1IHW1U0[I]) + EXP(S1IHW1U1[I]) + EXP(S1IHW1U2[I]) + EXP(U3veh[I]))
        S1IHW1P1[I] = EXP(S1IHW1U1[I]) / (EXP(S1IHW1U0[I]) + EXP(S1IHW1U1[I]) + EXP(S1IHW1U2[I]) + EXP(U3veh[I]))
        S1IHW1P2[I] = EXP(S1IHW1U2[I]) / (EXP(S1IHW1U0[I]) + EXP(S1IHW1U1[I]) + EXP(S1IHW1U2[I]) + EXP(U3veh[I]))
        S1IHW1P3[I] = 1.00 - (S1IHW1P0[I] + S1IHW1P1[I] + S1IHW1P2[I])
          
        S1IHW2P0[I] = EXP(S1IHW2U0[I]) / (EXP(S1IHW2U0[I]) + EXP(S1IHW2U1[I]) + EXP(S1IHW2U2[I]) + EXP(U3veh[I]))
        S1IHW2P1[I] = EXP(S1IHW2U1[I]) / (EXP(S1IHW2U0[I]) + EXP(S1IHW2U1[I]) + EXP(S1IHW2U2[I]) + EXP(U3veh[I]))
        S1IHW2P2[I] = EXP(S1IHW2U2[I]) / (EXP(S1IHW2U0[I]) + EXP(S1IHW2U1[I]) + EXP(S1IHW2U2[I]) + EXP(U3veh[I]))
        S1IHW2P3[I] = 1.00 - (S1IHW2P0[I] + S1IHW2P1[I] + S1IHW2P2[I])
          
        S1IHW3P0[I] = EXP(S1IHW3U0[I]) / (EXP(S1IHW3U0[I]) + EXP(S1IHW3U1[I]) + EXP(S1IHW3U2[I]) + EXP(U3veh[I]))
        S1IHW3P1[I] = EXP(S1IHW3U1[I]) / (EXP(S1IHW3U0[I]) + EXP(S1IHW3U1[I]) + EXP(S1IHW3U2[I]) + EXP(U3veh[I]))
        S1IHW3P2[I] = EXP(S1IHW3U2[I]) / (EXP(S1IHW3U0[I]) + EXP(S1IHW3U1[I]) + EXP(S1IHW3U2[I]) + EXP(U3veh[I]))
        S1IHW3P3[I] = 1.00 - (S1IHW3P0[I] + S1IHW3P1[I] + S1IHW3P2[I])
        
        
        ;2 person HH
        S2IHW0P0[I] = EXP(S2IHW0U0[I]) / (EXP(S2IHW0U0[I]) + EXP(S2IHW0U1[I]) + EXP(S2IHW0U2[I]) + EXP(U3veh[I]))
        S2IHW0P1[I] = EXP(S2IHW0U1[I]) / (EXP(S2IHW0U0[I]) + EXP(S2IHW0U1[I]) + EXP(S2IHW0U2[I]) + EXP(U3veh[I]))
        S2IHW0P2[I] = EXP(S2IHW0U2[I]) / (EXP(S2IHW0U0[I]) + EXP(S2IHW0U1[I]) + EXP(S2IHW0U2[I]) + EXP(U3veh[I]))
        S2IHW0P3[I] = 1.00 - (S2IHW0P0[I] + S2IHW0P1[I] + S2IHW0P2[I])
          
        S2IHW1P0[I] = EXP(S2IHW1U0[I]) / (EXP(S2IHW1U0[I]) + EXP(S2IHW1U1[I]) + EXP(S2IHW1U2[I]) + EXP(U3veh[I]))
        S2IHW1P1[I] = EXP(S2IHW1U1[I]) / (EXP(S2IHW1U0[I]) + EXP(S2IHW1U1[I]) + EXP(S2IHW1U2[I]) + EXP(U3veh[I]))
        S2IHW1P2[I] = EXP(S2IHW1U2[I]) / (EXP(S2IHW1U0[I]) + EXP(S2IHW1U1[I]) + EXP(S2IHW1U2[I]) + EXP(U3veh[I]))
        S2IHW1P3[I] = 1.00 - (S2IHW1P0[I] + S2IHW1P1[I] + S2IHW1P2[I])
          
        S2IHW2P0[I] = EXP(S2IHW2U0[I]) / (EXP(S2IHW2U0[I]) + EXP(S2IHW2U1[I]) + EXP(S2IHW2U2[I]) + EXP(U3veh[I]))
        S2IHW2P1[I] = EXP(S2IHW2U1[I]) / (EXP(S2IHW2U0[I]) + EXP(S2IHW2U1[I]) + EXP(S2IHW2U2[I]) + EXP(U3veh[I]))
        S2IHW2P2[I] = EXP(S2IHW2U2[I]) / (EXP(S2IHW2U0[I]) + EXP(S2IHW2U1[I]) + EXP(S2IHW2U2[I]) + EXP(U3veh[I]))
        S2IHW2P3[I] = 1.00 - (S2IHW2P0[I] + S2IHW2P1[I] + S2IHW2P2[I])
          
        S2IHW3P0[I] = EXP(S2IHW3U0[I]) / (EXP(S2IHW3U0[I]) + EXP(S2IHW3U1[I]) + EXP(S2IHW3U2[I]) + EXP(U3veh[I]))
        S2IHW3P1[I] = EXP(S2IHW3U1[I]) / (EXP(S2IHW3U0[I]) + EXP(S2IHW3U1[I]) + EXP(S2IHW3U2[I]) + EXP(U3veh[I]))
        S2IHW3P2[I] = EXP(S2IHW3U2[I]) / (EXP(S2IHW3U0[I]) + EXP(S2IHW3U1[I]) + EXP(S2IHW3U2[I]) + EXP(U3veh[I]))
        S2IHW3P3[I] = 1.00 - (S2IHW3P0[I] + S2IHW3P1[I] + S2IHW3P2[I])
        
        
        ;3 person HH
        S3IHW0P0[I] = EXP(S3IHW0U0[I]) / (EXP(S3IHW0U0[I]) + EXP(S3IHW0U1[I]) + EXP(S3IHW0U2[I]) + EXP(U3veh[I]))
        S3IHW0P1[I] = EXP(S3IHW0U1[I]) / (EXP(S3IHW0U0[I]) + EXP(S3IHW0U1[I]) + EXP(S3IHW0U2[I]) + EXP(U3veh[I]))
        S3IHW0P2[I] = EXP(S3IHW0U2[I]) / (EXP(S3IHW0U0[I]) + EXP(S3IHW0U1[I]) + EXP(S3IHW0U2[I]) + EXP(U3veh[I]))
        S3IHW0P3[I] = 1.00 - (S3IHW0P0[I] + S3IHW0P1[I] + S3IHW0P2[I])
          
        S3IHW1P0[I] = EXP(S3IHW1U0[I]) / (EXP(S3IHW1U0[I]) + EXP(S3IHW1U1[I]) + EXP(S3IHW1U2[I]) + EXP(U3veh[I]))
        S3IHW1P1[I] = EXP(S3IHW1U1[I]) / (EXP(S3IHW1U0[I]) + EXP(S3IHW1U1[I]) + EXP(S3IHW1U2[I]) + EXP(U3veh[I]))
        S3IHW1P2[I] = EXP(S3IHW1U2[I]) / (EXP(S3IHW1U0[I]) + EXP(S3IHW1U1[I]) + EXP(S3IHW1U2[I]) + EXP(U3veh[I]))
        S3IHW1P3[I] = 1.00 - (S3IHW1P0[I] + S3IHW1P1[I] + S3IHW1P2[I])
          
        S3IHW2P0[I] = EXP(S3IHW2U0[I]) / (EXP(S3IHW2U0[I]) + EXP(S3IHW2U1[I]) + EXP(S3IHW2U2[I]) + EXP(U3veh[I]))
        S3IHW2P1[I] = EXP(S3IHW2U1[I]) / (EXP(S3IHW2U0[I]) + EXP(S3IHW2U1[I]) + EXP(S3IHW2U2[I]) + EXP(U3veh[I]))
        S3IHW2P2[I] = EXP(S3IHW2U2[I]) / (EXP(S3IHW2U0[I]) + EXP(S3IHW2U1[I]) + EXP(S3IHW2U2[I]) + EXP(U3veh[I]))
        S3IHW2P3[I] = 1.00 - (S3IHW2P0[I] + S3IHW2P1[I] + S3IHW2P2[I])
          
        S3IHW3P0[I] = EXP(S3IHW3U0[I]) / (EXP(S3IHW3U0[I]) + EXP(S3IHW3U1[I]) + EXP(S3IHW3U2[I]) + EXP(U3veh[I]))
        S3IHW3P1[I] = EXP(S3IHW3U1[I]) / (EXP(S3IHW3U0[I]) + EXP(S3IHW3U1[I]) + EXP(S3IHW3U2[I]) + EXP(U3veh[I]))
        S3IHW3P2[I] = EXP(S3IHW3U2[I]) / (EXP(S3IHW3U0[I]) + EXP(S3IHW3U1[I]) + EXP(S3IHW3U2[I]) + EXP(U3veh[I]))
        S3IHW3P3[I] = 1.00 - (S3IHW3P0[I] + S3IHW3P1[I] + S3IHW3P2[I])
        
        
        ;4 person HH
        S4IHW0P0[I] = EXP(S4IHW0U0[I]) / (EXP(S4IHW0U0[I]) + EXP(S4IHW0U1[I]) + EXP(S4IHW0U2[I]) + EXP(U3veh[I]))
        S4IHW0P1[I] = EXP(S4IHW0U1[I]) / (EXP(S4IHW0U0[I]) + EXP(S4IHW0U1[I]) + EXP(S4IHW0U2[I]) + EXP(U3veh[I]))
        S4IHW0P2[I] = EXP(S4IHW0U2[I]) / (EXP(S4IHW0U0[I]) + EXP(S4IHW0U1[I]) + EXP(S4IHW0U2[I]) + EXP(U3veh[I]))
        S4IHW0P3[I] = 1.00 - (S4IHW0P0[I] + S4IHW0P1[I] + S4IHW0P2[I])
          
        S4IHW1P0[I] = EXP(S4IHW1U0[I]) / (EXP(S4IHW1U0[I]) + EXP(S4IHW1U1[I]) + EXP(S4IHW1U2[I]) + EXP(U3veh[I]))
        S4IHW1P1[I] = EXP(S4IHW1U1[I]) / (EXP(S4IHW1U0[I]) + EXP(S4IHW1U1[I]) + EXP(S4IHW1U2[I]) + EXP(U3veh[I]))
        S4IHW1P2[I] = EXP(S4IHW1U2[I]) / (EXP(S4IHW1U0[I]) + EXP(S4IHW1U1[I]) + EXP(S4IHW1U2[I]) + EXP(U3veh[I]))
        S4IHW1P3[I] = 1.00 - (S4IHW1P0[I] + S4IHW1P1[I] + S4IHW1P2[I])
          
        S4IHW2P0[I] = EXP(S4IHW2U0[I]) / (EXP(S4IHW2U0[I]) + EXP(S4IHW2U1[I]) + EXP(S4IHW2U2[I]) + EXP(U3veh[I]))
        S4IHW2P1[I] = EXP(S4IHW2U1[I]) / (EXP(S4IHW2U0[I]) + EXP(S4IHW2U1[I]) + EXP(S4IHW2U2[I]) + EXP(U3veh[I]))
        S4IHW2P2[I] = EXP(S4IHW2U2[I]) / (EXP(S4IHW2U0[I]) + EXP(S4IHW2U1[I]) + EXP(S4IHW2U2[I]) + EXP(U3veh[I]))
        S4IHW2P3[I] = 1.00 - (S4IHW2P0[I] + S4IHW2P1[I] + S4IHW2P2[I])
          
        S4IHW3P0[I] = EXP(S4IHW3U0[I]) / (EXP(S4IHW3U0[I]) + EXP(S4IHW3U1[I]) + EXP(S4IHW3U2[I]) + EXP(U3veh[I]))
        S4IHW3P1[I] = EXP(S4IHW3U1[I]) / (EXP(S4IHW3U0[I]) + EXP(S4IHW3U1[I]) + EXP(S4IHW3U2[I]) + EXP(U3veh[I]))
        S4IHW3P2[I] = EXP(S4IHW3U2[I]) / (EXP(S4IHW3U0[I]) + EXP(S4IHW3U1[I]) + EXP(S4IHW3U2[I]) + EXP(U3veh[I]))
        S4IHW3P3[I] = 1.00 - (S4IHW3P0[I] + S4IHW3P1[I] + S4IHW3P2[I])
        
        
        ;5 person HH
        S5IHW0P0[I] = EXP(S5IHW0U0[I]) / (EXP(S5IHW0U0[I]) + EXP(S5IHW0U1[I]) + EXP(S5IHW0U2[I]) + EXP(U3veh[I]))
        S5IHW0P1[I] = EXP(S5IHW0U1[I]) / (EXP(S5IHW0U0[I]) + EXP(S5IHW0U1[I]) + EXP(S5IHW0U2[I]) + EXP(U3veh[I]))
        S5IHW0P2[I] = EXP(S5IHW0U2[I]) / (EXP(S5IHW0U0[I]) + EXP(S5IHW0U1[I]) + EXP(S5IHW0U2[I]) + EXP(U3veh[I]))
        S5IHW0P3[I] = 1.00 - (S5IHW0P0[I] + S5IHW0P1[I] + S5IHW0P2[I])
          
        S5IHW1P0[I] = EXP(S5IHW1U0[I]) / (EXP(S5IHW1U0[I]) + EXP(S5IHW1U1[I]) + EXP(S5IHW1U2[I]) + EXP(U3veh[I]))
        S5IHW1P1[I] = EXP(S5IHW1U1[I]) / (EXP(S5IHW1U0[I]) + EXP(S5IHW1U1[I]) + EXP(S5IHW1U2[I]) + EXP(U3veh[I]))
        S5IHW1P2[I] = EXP(S5IHW1U2[I]) / (EXP(S5IHW1U0[I]) + EXP(S5IHW1U1[I]) + EXP(S5IHW1U2[I]) + EXP(U3veh[I]))
        S5IHW1P3[I] = 1.00 - (S5IHW1P0[I] + S5IHW1P1[I] + S5IHW1P2[I])
          
        S5IHW2P0[I] = EXP(S5IHW2U0[I]) / (EXP(S5IHW2U0[I]) + EXP(S5IHW2U1[I]) + EXP(S5IHW2U2[I]) + EXP(U3veh[I]))
        S5IHW2P1[I] = EXP(S5IHW2U1[I]) / (EXP(S5IHW2U0[I]) + EXP(S5IHW2U1[I]) + EXP(S5IHW2U2[I]) + EXP(U3veh[I]))
        S5IHW2P2[I] = EXP(S5IHW2U2[I]) / (EXP(S5IHW2U0[I]) + EXP(S5IHW2U1[I]) + EXP(S5IHW2U2[I]) + EXP(U3veh[I]))
        S5IHW2P3[I] = 1.00 - (S5IHW2P0[I] + S5IHW2P1[I] + S5IHW2P2[I])
          
        S5IHW3P0[I] = EXP(S5IHW3U0[I]) / (EXP(S5IHW3U0[I]) + EXP(S5IHW3U1[I]) + EXP(S5IHW3U2[I]) + EXP(U3veh[I]))
        S5IHW3P1[I] = EXP(S5IHW3U1[I]) / (EXP(S5IHW3U0[I]) + EXP(S5IHW3U1[I]) + EXP(S5IHW3U2[I]) + EXP(U3veh[I]))
        S5IHW3P2[I] = EXP(S5IHW3U2[I]) / (EXP(S5IHW3U0[I]) + EXP(S5IHW3U1[I]) + EXP(S5IHW3U2[I]) + EXP(U3veh[I]))
        S5IHW3P3[I] = 1.00 - (S5IHW3P0[I] + S5IHW3P1[I] + S5IHW3P2[I])
        
        
        ;6 person HH
        S6IHW0P0[I] = EXP(S6IHW0U0[I]) / (EXP(S6IHW0U0[I]) + EXP(S6IHW0U1[I]) + EXP(S6IHW0U2[I]) + EXP(U3veh[I]))
        S6IHW0P1[I] = EXP(S6IHW0U1[I]) / (EXP(S6IHW0U0[I]) + EXP(S6IHW0U1[I]) + EXP(S6IHW0U2[I]) + EXP(U3veh[I]))
        S6IHW0P2[I] = EXP(S6IHW0U2[I]) / (EXP(S6IHW0U0[I]) + EXP(S6IHW0U1[I]) + EXP(S6IHW0U2[I]) + EXP(U3veh[I]))
        S6IHW0P3[I] = 1.00 - (S6IHW0P0[I] + S6IHW0P1[I] + S6IHW0P2[I])
          
        S6IHW1P0[I] = EXP(S6IHW1U0[I]) / (EXP(S6IHW1U0[I]) + EXP(S6IHW1U1[I]) + EXP(S6IHW1U2[I]) + EXP(U3veh[I]))
        S6IHW1P1[I] = EXP(S6IHW1U1[I]) / (EXP(S6IHW1U0[I]) + EXP(S6IHW1U1[I]) + EXP(S6IHW1U2[I]) + EXP(U3veh[I]))
        S6IHW1P2[I] = EXP(S6IHW1U2[I]) / (EXP(S6IHW1U0[I]) + EXP(S6IHW1U1[I]) + EXP(S6IHW1U2[I]) + EXP(U3veh[I]))
        S6IHW1P3[I] = 1.00 - (S6IHW1P0[I] + S6IHW1P1[I] + S6IHW1P2[I])
          
        S6IHW2P0[I] = EXP(S6IHW2U0[I]) / (EXP(S6IHW2U0[I]) + EXP(S6IHW2U1[I]) + EXP(S6IHW2U2[I]) + EXP(U3veh[I]))
        S6IHW2P1[I] = EXP(S6IHW2U1[I]) / (EXP(S6IHW2U0[I]) + EXP(S6IHW2U1[I]) + EXP(S6IHW2U2[I]) + EXP(U3veh[I]))
        S6IHW2P2[I] = EXP(S6IHW2U2[I]) / (EXP(S6IHW2U0[I]) + EXP(S6IHW2U1[I]) + EXP(S6IHW2U2[I]) + EXP(U3veh[I]))
        S6IHW2P3[I] = 1.00 - (S6IHW2P0[I] + S6IHW2P1[I] + S6IHW2P2[I])
          
        S6IHW3P0[I] = EXP(S6IHW3U0[I]) / (EXP(S6IHW3U0[I]) + EXP(S6IHW3U1[I]) + EXP(S6IHW3U2[I]) + EXP(U3veh[I]))
        S6IHW3P1[I] = EXP(S6IHW3U1[I]) / (EXP(S6IHW3U0[I]) + EXP(S6IHW3U1[I]) + EXP(S6IHW3U2[I]) + EXP(U3veh[I]))
        S6IHW3P2[I] = EXP(S6IHW3U2[I]) / (EXP(S6IHW3U0[I]) + EXP(S6IHW3U1[I]) + EXP(S6IHW3U2[I]) + EXP(U3veh[I]))
        S6IHW3P3[I] = 1.00 - (S6IHW3P0[I] + S6IHW3P1[I] + S6IHW3P2[I])
    
    
    ;print low and high income probabilities to temp files
    if (I=1)
        PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Probability_LowInc.csv', CSV=T, FORM=9, LIST=
            '     Z',
            ' S1ILW0P0',' S1ILW0P1',' S1ILW0P2',' S1ILW0P3',
            ' S1ILW1P0',' S1ILW1P1',' S1ILW1P2',' S1ILW1P3',
            ' S1ILW2P0',' S1ILW2P1',' S1ILW2P2',' S1ILW2P3',
            ' S1ILW3P0',' S1ILW3P1',' S1ILW3P2',' S1ILW3P3',
            
            ' S2ILW0P0',' S2ILW0P1',' S2ILW0P2',' S2ILW0P3',
            ' S2ILW1P0',' S2ILW1P1',' S2ILW1P2',' S2ILW1P3',
            ' S2ILW2P0',' S2ILW2P1',' S2ILW2P2',' S2ILW2P3',
            ' S2ILW3P0',' S2ILW3P1',' S2ILW3P2',' S2ILW3P3',
                
            ' S3ILW0P0',' S3ILW0P1',' S3ILW0P2',' S3ILW0P3',
            ' S3ILW1P0',' S3ILW1P1',' S3ILW1P2',' S3ILW1P3',
            ' S3ILW2P0',' S3ILW2P1',' S3ILW2P2',' S3ILW2P3',
            ' S3ILW3P0',' S3ILW3P1',' S3ILW3P2',' S3ILW3P3',
                
            ' S4ILW0P0',' S4ILW0P1',' S4ILW0P2',' S4ILW0P3',
            ' S4ILW1P0',' S4ILW1P1',' S4ILW1P2',' S4ILW1P3',
            ' S4ILW2P0',' S4ILW2P1',' S4ILW2P2',' S4ILW2P3',
            ' S4ILW3P0',' S4ILW3P1',' S4ILW3P2',' S4ILW3P3',
                    
            ' S5ILW0P0',' S5ILW0P1',' S5ILW0P2',' S5ILW0P3',
            ' S5ILW1P0',' S5ILW1P1',' S5ILW1P2',' S5ILW1P3',
            ' S5ILW2P0',' S5ILW2P1',' S5ILW2P2',' S5ILW2P3',
            ' S5ILW3P0',' S5ILW3P1',' S5ILW3P2',' S5ILW3P3',
                    
            ' S6ILW0P0',' S6ILW0P1',' S6ILW0P2',' S6ILW0P3',
            ' S6ILW1P0',' S6ILW1P1',' S6ILW1P2',' S6ILW1P3',
            ' S6ILW2P0',' S6ILW2P1',' S6ILW2P2',' S6ILW2P3',
            ' S6ILW3P0',' S6ILW3P1',' S6ILW3P2',' S6ILW3P3'
        
        PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Probability_HiInc.csv', CSV=T, FORM=9, LIST=
            '     Z',
            ' S1IHW0P0',' S1IHW0P1',' S1IHW0P2',' S1IHW0P3',
            ' S1IHW1P0',' S1IHW1P1',' S1IHW1P2',' S1IHW1P3',
            ' S1IHW2P0',' S1IHW2P1',' S1IHW2P2',' S1IHW2P3',
            ' S1IHW3P0',' S1IHW3P1',' S1IHW3P2',' S1IHW3P3',
            
            ' S2IHW0P0',' S2IHW0P1',' S2IHW0P2',' S2IHW0P3',
            ' S2IHW1P0',' S2IHW1P1',' S2IHW1P2',' S2IHW1P3',
            ' S2IHW2P0',' S2IHW2P1',' S2IHW2P2',' S2IHW2P3',
            ' S2IHW3P0',' S2IHW3P1',' S2IHW3P2',' S2IHW3P3',
                
            ' S3IHW0P0',' S3IHW0P1',' S3IHW0P2',' S3IHW0P3',
            ' S3IHW1P0',' S3IHW1P1',' S3IHW1P2',' S3IHW1P3',
            ' S3IHW2P0',' S3IHW2P1',' S3IHW2P2',' S3IHW2P3',
            ' S3IHW3P0',' S3IHW3P1',' S3IHW3P2',' S3IHW3P3',
                
            ' S4IHW0P0',' S4IHW0P1',' S4IHW0P2',' S4IHW0P3',
            ' S4IHW1P0',' S4IHW1P1',' S4IHW1P2',' S4IHW1P3',
            ' S4IHW2P0',' S4IHW2P1',' S4IHW2P2',' S4IHW2P3',
            ' S4IHW3P0',' S4IHW3P1',' S4IHW3P2',' S4IHW3P3',
                    
            ' S5IHW0P0',' S5IHW0P1',' S5IHW0P2',' S5IHW0P3',
            ' S5IHW1P0',' S5IHW1P1',' S5IHW1P2',' S5IHW1P3',
            ' S5IHW2P0',' S5IHW2P1',' S5IHW2P2',' S5IHW2P3',
            ' S5IHW3P0',' S5IHW3P1',' S5IHW3P2',' S5IHW3P3',
                    
            ' S6IHW0P0',' S6IHW0P1',' S6IHW0P2',' S6IHW0P3',
            ' S6IHW1P0',' S6IHW1P1',' S6IHW1P2',' S6IHW1P3',
            ' S6IHW2P0',' S6IHW2P1',' S6IHW2P2',' S6IHW2P3',
            ' S6IHW3P0',' S6IHW3P1',' S6IHW3P2',' S6IHW3P3'
    endif
    
    PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Probability_LowInc.csv', CSV=T, FORM=9.4, LIST=I(6),
        S1ILW0P0[I], S1ILW0P1[I], S1ILW0P2[I], S1ILW0P3[I], 
        S1ILW1P0[I], S1ILW1P1[I], S1ILW1P2[I], S1ILW1P3[I], 
        S1ILW2P0[I], S1ILW2P1[I], S1ILW2P2[I], S1ILW2P3[I], 
        S1ILW3P0[I], S1ILW3P1[I], S1ILW3P2[I], S1ILW3P3[I], 
        
        S2ILW0P0[I], S2ILW0P1[I], S2ILW0P2[I], S2ILW0P3[I], 
        S2ILW1P0[I], S2ILW1P1[I], S2ILW1P2[I], S2ILW1P3[I], 
        S2ILW2P0[I], S2ILW2P1[I], S2ILW2P2[I], S2ILW2P3[I], 
        S2ILW3P0[I], S2ILW3P1[I], S2ILW3P2[I], S2ILW3P3[I], 
            
        S3ILW0P0[I], S3ILW0P1[I], S3ILW0P2[I], S3ILW0P3[I], 
        S3ILW1P0[I], S3ILW1P1[I], S3ILW1P2[I], S3ILW1P3[I], 
        S3ILW2P0[I], S3ILW2P1[I], S3ILW2P2[I], S3ILW2P3[I], 
        S3ILW3P0[I], S3ILW3P1[I], S3ILW3P2[I], S3ILW3P3[I], 
            
        S4ILW0P0[I], S4ILW0P1[I], S4ILW0P2[I], S4ILW0P3[I], 
        S4ILW1P0[I], S4ILW1P1[I], S4ILW1P2[I], S4ILW1P3[I], 
        S4ILW2P0[I], S4ILW2P1[I], S4ILW2P2[I], S4ILW2P3[I], 
        S4ILW3P0[I], S4ILW3P1[I], S4ILW3P2[I], S4ILW3P3[I],
                
        S5ILW0P0[I], S5ILW0P1[I], S5ILW0P2[I], S5ILW0P3[I], 
        S5ILW1P0[I], S5ILW1P1[I], S5ILW1P2[I], S5ILW1P3[I], 
        S5ILW2P0[I], S5ILW2P1[I], S5ILW2P2[I], S5ILW2P3[I], 
        S5ILW3P0[I], S5ILW3P1[I], S5ILW3P2[I], S5ILW3P3[I],
                
        S6ILW0P0[I], S6ILW0P1[I], S6ILW0P2[I], S6ILW0P3[I], 
        S6ILW1P0[I], S6ILW1P1[I], S6ILW1P2[I], S6ILW1P3[I], 
        S6ILW2P0[I], S6ILW2P1[I], S6ILW2P2[I], S6ILW2P3[I], 
        S6ILW3P0[I], S6ILW3P1[I], S6ILW3P2[I], S6ILW3P3[I]
      
    PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Probability_HiInc.csv', CSV=T, FORM=9.4, LIST=I(6),
        S1IHW0P0[I], S1IHW0P1[I], S1IHW0P2[I], S1IHW0P3[I], 
        S1IHW1P0[I], S1IHW1P1[I], S1IHW1P2[I], S1IHW1P3[I], 
        S1IHW2P0[I], S1IHW2P1[I], S1IHW2P2[I], S1IHW2P3[I], 
        S1IHW3P0[I], S1IHW3P1[I], S1IHW3P2[I], S1IHW3P3[I], 
        
        S2IHW0P0[I], S2IHW0P1[I], S2IHW0P2[I], S2IHW0P3[I], 
        S2IHW1P0[I], S2IHW1P1[I], S2IHW1P2[I], S2IHW1P3[I], 
        S2IHW2P0[I], S2IHW2P1[I], S2IHW2P2[I], S2IHW2P3[I], 
        S2IHW3P0[I], S2IHW3P1[I], S2IHW3P2[I], S2IHW3P3[I], 
            
        S3IHW0P0[I], S3IHW0P1[I], S3IHW0P2[I], S3IHW0P3[I], 
        S3IHW1P0[I], S3IHW1P1[I], S3IHW1P2[I], S3IHW1P3[I], 
        S3IHW2P0[I], S3IHW2P1[I], S3IHW2P2[I], S3IHW2P3[I], 
        S3IHW3P0[I], S3IHW3P1[I], S3IHW3P2[I], S3IHW3P3[I], 
            
        S4IHW0P0[I], S4IHW0P1[I], S4IHW0P2[I], S4IHW0P3[I], 
        S4IHW1P0[I], S4IHW1P1[I], S4IHW1P2[I], S4IHW1P3[I], 
        S4IHW2P0[I], S4IHW2P1[I], S4IHW2P2[I], S4IHW2P3[I], 
        S4IHW3P0[I], S4IHW3P1[I], S4IHW3P2[I], S4IHW3P3[I],
                
        S5IHW0P0[I], S5IHW0P1[I], S5IHW0P2[I], S5IHW0P3[I], 
        S5IHW1P0[I], S5IHW1P1[I], S5IHW1P2[I], S5IHW1P3[I], 
        S5IHW2P0[I], S5IHW2P1[I], S5IHW2P2[I], S5IHW2P3[I], 
        S5IHW3P0[I], S5IHW3P1[I], S5IHW3P2[I], S5IHW3P3[I],
                
        S6IHW0P0[I], S6IHW0P1[I], S6IHW0P2[I], S6IHW0P3[I], 
        S6IHW1P0[I], S6IHW1P1[I], S6IHW1P2[I], S6IHW1P3[I], 
        S6IHW2P0[I], S6IHW2P1[I], S6IHW2P2[I], S6IHW2P3[I], 
        S6IHW3P0[I], S6IHW3P1[I], S6IHW3P2[I], S6IHW3P3[I]
    
    
    
    ;*************************** Calculate Auto Ownership ******************************
    ;assign output variables common to RECO files
    RO.Z    = I
    RO.SEHH = zi.4.TOTHH
    
    
    ;1 person HH
    RO.S1ILW0V0 = S1ILW0P0[I] * zi.3.S1ILW0  ;low income
    RO.S1ILW0V1 = S1ILW0P1[I] * zi.3.S1ILW0
    RO.S1ILW0V2 = S1ILW0P2[I] * zi.3.S1ILW0
    RO.S1ILW0V3 = S1ILW0P3[I] * zi.3.S1ILW0
    
    RO.S1ILW1V0 = S1ILW1P0[I] * zi.3.S1ILW1
    RO.S1ILW1V1 = S1ILW1P1[I] * zi.3.S1ILW1
    RO.S1ILW1V2 = S1ILW1P2[I] * zi.3.S1ILW1
    RO.S1ILW1V3 = S1ILW1P3[I] * zi.3.S1ILW1
    
    RO.S1ILW2V0 = S1ILW2P0[I] * zi.3.S1ILW2
    RO.S1ILW2V1 = S1ILW2P1[I] * zi.3.S1ILW2
    RO.S1ILW2V2 = S1ILW2P2[I] * zi.3.S1ILW2
    RO.S1ILW2V3 = S1ILW2P3[I] * zi.3.S1ILW2
    
    RO.S1ILW3V0 = S1ILW3P0[I] * zi.3.S1ILW3
    RO.S1ILW3V1 = S1ILW3P1[I] * zi.3.S1ILW3
    RO.S1ILW3V2 = S1ILW3P2[I] * zi.3.S1ILW3
    RO.S1ILW3V3 = S1ILW3P3[I] * zi.3.S1ILW3
    
    RO.S1IHW0V0 = S1IHW0P0[I] * zi.3.S1IHW0  ;high income
    RO.S1IHW0V1 = S1IHW0P1[I] * zi.3.S1IHW0
    RO.S1IHW0V2 = S1IHW0P2[I] * zi.3.S1IHW0
    RO.S1IHW0V3 = S1IHW0P3[I] * zi.3.S1IHW0
    
    RO.S1IHW1V0 = S1IHW1P0[I] * zi.3.S1IHW1
    RO.S1IHW1V1 = S1IHW1P1[I] * zi.3.S1IHW1
    RO.S1IHW1V2 = S1IHW1P2[I] * zi.3.S1IHW1
    RO.S1IHW1V3 = S1IHW1P3[I] * zi.3.S1IHW1
    
    RO.S1IHW2V0 = S1IHW2P0[I] * zi.3.S1IHW2
    RO.S1IHW2V1 = S1IHW2P1[I] * zi.3.S1IHW2
    RO.S1IHW2V2 = S1IHW2P2[I] * zi.3.S1IHW2
    RO.S1IHW2V3 = S1IHW2P3[I] * zi.3.S1IHW2
    
    RO.S1IHW3V0 = S1IHW3P0[I] * zi.3.S1IHW3
    RO.S1IHW3V1 = S1IHW3P1[I] * zi.3.S1IHW3
    RO.S1IHW3V2 = S1IHW3P2[I] * zi.3.S1IHW3
    RO.S1IHW3V3 = S1IHW3P3[I] * zi.3.S1IHW3
    
    
    ;2 person HH
    RO.S2ILW0V0 = S2ILW0P0[I] * zi.3.S2ILW0  ;low income
    RO.S2ILW0V1 = S2ILW0P1[I] * zi.3.S2ILW0
    RO.S2ILW0V2 = S2ILW0P2[I] * zi.3.S2ILW0
    RO.S2ILW0V3 = S2ILW0P3[I] * zi.3.S2ILW0
    
    RO.S2ILW1V0 = S2ILW1P0[I] * zi.3.S2ILW1
    RO.S2ILW1V1 = S2ILW1P1[I] * zi.3.S2ILW1
    RO.S2ILW1V2 = S2ILW1P2[I] * zi.3.S2ILW1
    RO.S2ILW1V3 = S2ILW1P3[I] * zi.3.S2ILW1
    
    RO.S2ILW2V0 = S2ILW2P0[I] * zi.3.S2ILW2
    RO.S2ILW2V1 = S2ILW2P1[I] * zi.3.S2ILW2
    RO.S2ILW2V2 = S2ILW2P2[I] * zi.3.S2ILW2
    RO.S2ILW2V3 = S2ILW2P3[I] * zi.3.S2ILW2
    
    RO.S2ILW3V0 = S2ILW3P0[I] * zi.3.S2ILW3
    RO.S2ILW3V1 = S2ILW3P1[I] * zi.3.S2ILW3
    RO.S2ILW3V2 = S2ILW3P2[I] * zi.3.S2ILW3
    RO.S2ILW3V3 = S2ILW3P3[I] * zi.3.S2ILW3
    
    RO.S2IHW0V0 = S2IHW0P0[I] * zi.3.S2IHW0  ;high income
    RO.S2IHW0V1 = S2IHW0P1[I] * zi.3.S2IHW0
    RO.S2IHW0V2 = S2IHW0P2[I] * zi.3.S2IHW0
    RO.S2IHW0V3 = S2IHW0P3[I] * zi.3.S2IHW0
    
    RO.S2IHW1V0 = S2IHW1P0[I] * zi.3.S2IHW1
    RO.S2IHW1V1 = S2IHW1P1[I] * zi.3.S2IHW1
    RO.S2IHW1V2 = S2IHW1P2[I] * zi.3.S2IHW1
    RO.S2IHW1V3 = S2IHW1P3[I] * zi.3.S2IHW1
    
    RO.S2IHW2V0 = S2IHW2P0[I] * zi.3.S2IHW2
    RO.S2IHW2V1 = S2IHW2P1[I] * zi.3.S2IHW2
    RO.S2IHW2V2 = S2IHW2P2[I] * zi.3.S2IHW2
    RO.S2IHW2V3 = S2IHW2P3[I] * zi.3.S2IHW2
    
    RO.S2IHW3V0 = S2IHW3P0[I] * zi.3.S2IHW3
    RO.S2IHW3V1 = S2IHW3P1[I] * zi.3.S2IHW3
    RO.S2IHW3V2 = S2IHW3P2[I] * zi.3.S2IHW3
    RO.S2IHW3V3 = S2IHW3P3[I] * zi.3.S2IHW3
    
    
    ;3 person HH
    RO.S3ILW0V0 = S3ILW0P0[I] * zi.3.S3ILW0  ;low income
    RO.S3ILW0V1 = S3ILW0P1[I] * zi.3.S3ILW0
    RO.S3ILW0V2 = S3ILW0P2[I] * zi.3.S3ILW0
    RO.S3ILW0V3 = S3ILW0P3[I] * zi.3.S3ILW0
    
    RO.S3ILW1V0 = S3ILW1P0[I] * zi.3.S3ILW1
    RO.S3ILW1V1 = S3ILW1P1[I] * zi.3.S3ILW1
    RO.S3ILW1V2 = S3ILW1P2[I] * zi.3.S3ILW1
    RO.S3ILW1V3 = S3ILW1P3[I] * zi.3.S3ILW1
    
    RO.S3ILW2V0 = S3ILW2P0[I] * zi.3.S3ILW2
    RO.S3ILW2V1 = S3ILW2P1[I] * zi.3.S3ILW2
    RO.S3ILW2V2 = S3ILW2P2[I] * zi.3.S3ILW2
    RO.S3ILW2V3 = S3ILW2P3[I] * zi.3.S3ILW2
    
    RO.S3ILW3V0 = S3ILW3P0[I] * zi.3.S3ILW3
    RO.S3ILW3V1 = S3ILW3P1[I] * zi.3.S3ILW3
    RO.S3ILW3V2 = S3ILW3P2[I] * zi.3.S3ILW3
    RO.S3ILW3V3 = S3ILW3P3[I] * zi.3.S3ILW3
    
    RO.S3IHW0V0 = S3IHW0P0[I] * zi.3.S3IHW0  ;high income
    RO.S3IHW0V1 = S3IHW0P1[I] * zi.3.S3IHW0
    RO.S3IHW0V2 = S3IHW0P2[I] * zi.3.S3IHW0
    RO.S3IHW0V3 = S3IHW0P3[I] * zi.3.S3IHW0
    
    RO.S3IHW1V0 = S3IHW1P0[I] * zi.3.S3IHW1
    RO.S3IHW1V1 = S3IHW1P1[I] * zi.3.S3IHW1
    RO.S3IHW1V2 = S3IHW1P2[I] * zi.3.S3IHW1
    RO.S3IHW1V3 = S3IHW1P3[I] * zi.3.S3IHW1
    
    RO.S3IHW2V0 = S3IHW2P0[I] * zi.3.S3IHW2
    RO.S3IHW2V1 = S3IHW2P1[I] * zi.3.S3IHW2
    RO.S3IHW2V2 = S3IHW2P2[I] * zi.3.S3IHW2
    RO.S3IHW2V3 = S3IHW2P3[I] * zi.3.S3IHW2
    
    RO.S3IHW3V0 = S3IHW3P0[I] * zi.3.S3IHW3
    RO.S3IHW3V1 = S3IHW3P1[I] * zi.3.S3IHW3
    RO.S3IHW3V2 = S3IHW3P2[I] * zi.3.S3IHW3
    RO.S3IHW3V3 = S3IHW3P3[I] * zi.3.S3IHW3
    
    
    ;4 person HH
    RO.S4ILW0V0 = S4ILW0P0[I] * zi.3.S4ILW0  ;low income
    RO.S4ILW0V1 = S4ILW0P1[I] * zi.3.S4ILW0
    RO.S4ILW0V2 = S4ILW0P2[I] * zi.3.S4ILW0
    RO.S4ILW0V3 = S4ILW0P3[I] * zi.3.S4ILW0
    
    RO.S4ILW1V0 = S4ILW1P0[I] * zi.3.S4ILW1
    RO.S4ILW1V1 = S4ILW1P1[I] * zi.3.S4ILW1
    RO.S4ILW1V2 = S4ILW1P2[I] * zi.3.S4ILW1
    RO.S4ILW1V3 = S4ILW1P3[I] * zi.3.S4ILW1
    
    RO.S4ILW2V0 = S4ILW2P0[I] * zi.3.S4ILW2
    RO.S4ILW2V1 = S4ILW2P1[I] * zi.3.S4ILW2
    RO.S4ILW2V2 = S4ILW2P2[I] * zi.3.S4ILW2
    RO.S4ILW2V3 = S4ILW2P3[I] * zi.3.S4ILW2
    
    RO.S4ILW3V0 = S4ILW3P0[I] * zi.3.S4ILW3
    RO.S4ILW3V1 = S4ILW3P1[I] * zi.3.S4ILW3
    RO.S4ILW3V2 = S4ILW3P2[I] * zi.3.S4ILW3
    RO.S4ILW3V3 = S4ILW3P3[I] * zi.3.S4ILW3
    
    RO.S4IHW0V0 = S4IHW0P0[I] * zi.3.S4IHW0  ;high income
    RO.S4IHW0V1 = S4IHW0P1[I] * zi.3.S4IHW0
    RO.S4IHW0V2 = S4IHW0P2[I] * zi.3.S4IHW0
    RO.S4IHW0V3 = S4IHW0P3[I] * zi.3.S4IHW0
    
    RO.S4IHW1V0 = S4IHW1P0[I] * zi.3.S4IHW1
    RO.S4IHW1V1 = S4IHW1P1[I] * zi.3.S4IHW1
    RO.S4IHW1V2 = S4IHW1P2[I] * zi.3.S4IHW1
    RO.S4IHW1V3 = S4IHW1P3[I] * zi.3.S4IHW1
    
    RO.S4IHW2V0 = S4IHW2P0[I] * zi.3.S4IHW2
    RO.S4IHW2V1 = S4IHW2P1[I] * zi.3.S4IHW2
    RO.S4IHW2V2 = S4IHW2P2[I] * zi.3.S4IHW2
    RO.S4IHW2V3 = S4IHW2P3[I] * zi.3.S4IHW2
    
    RO.S4IHW3V0 = S4IHW3P0[I] * zi.3.S4IHW3
    RO.S4IHW3V1 = S4IHW3P1[I] * zi.3.S4IHW3
    RO.S4IHW3V2 = S4IHW3P2[I] * zi.3.S4IHW3
    RO.S4IHW3V3 = S4IHW3P3[I] * zi.3.S4IHW3
    
    
    ;5 person HH
    RO.S5ILW0V0 = S5ILW0P0[I] * zi.3.S5ILW0  ;low income
    RO.S5ILW0V1 = S5ILW0P1[I] * zi.3.S5ILW0
    RO.S5ILW0V2 = S5ILW0P2[I] * zi.3.S5ILW0
    RO.S5ILW0V3 = S5ILW0P3[I] * zi.3.S5ILW0
    
    RO.S5ILW1V0 = S5ILW1P0[I] * zi.3.S5ILW1
    RO.S5ILW1V1 = S5ILW1P1[I] * zi.3.S5ILW1
    RO.S5ILW1V2 = S5ILW1P2[I] * zi.3.S5ILW1
    RO.S5ILW1V3 = S5ILW1P3[I] * zi.3.S5ILW1
    
    RO.S5ILW2V0 = S5ILW2P0[I] * zi.3.S5ILW2
    RO.S5ILW2V1 = S5ILW2P1[I] * zi.3.S5ILW2
    RO.S5ILW2V2 = S5ILW2P2[I] * zi.3.S5ILW2
    RO.S5ILW2V3 = S5ILW2P3[I] * zi.3.S5ILW2
    
    RO.S5ILW3V0 = S5ILW3P0[I] * zi.3.S5ILW3
    RO.S5ILW3V1 = S5ILW3P1[I] * zi.3.S5ILW3
    RO.S5ILW3V2 = S5ILW3P2[I] * zi.3.S5ILW3
    RO.S5ILW3V3 = S5ILW3P3[I] * zi.3.S5ILW3
    
    RO.S5IHW0V0 = S5IHW0P0[I] * zi.3.S5IHW0  ;high income
    RO.S5IHW0V1 = S5IHW0P1[I] * zi.3.S5IHW0
    RO.S5IHW0V2 = S5IHW0P2[I] * zi.3.S5IHW0
    RO.S5IHW0V3 = S5IHW0P3[I] * zi.3.S5IHW0
    
    RO.S5IHW1V0 = S5IHW1P0[I] * zi.3.S5IHW1
    RO.S5IHW1V1 = S5IHW1P1[I] * zi.3.S5IHW1
    RO.S5IHW1V2 = S5IHW1P2[I] * zi.3.S5IHW1
    RO.S5IHW1V3 = S5IHW1P3[I] * zi.3.S5IHW1
    
    RO.S5IHW2V0 = S5IHW2P0[I] * zi.3.S5IHW2
    RO.S5IHW2V1 = S5IHW2P1[I] * zi.3.S5IHW2
    RO.S5IHW2V2 = S5IHW2P2[I] * zi.3.S5IHW2
    RO.S5IHW2V3 = S5IHW2P3[I] * zi.3.S5IHW2
    
    RO.S5IHW3V0 = S5IHW3P0[I] * zi.3.S5IHW3
    RO.S5IHW3V1 = S5IHW3P1[I] * zi.3.S5IHW3
    RO.S5IHW3V2 = S5IHW3P2[I] * zi.3.S5IHW3
    RO.S5IHW3V3 = S5IHW3P3[I] * zi.3.S5IHW3
    
    
    ;6 person HH
    RO.S6ILW0V0 = S6ILW0P0[I] * zi.3.S6ILW0  ;low income
    RO.S6ILW0V1 = S6ILW0P1[I] * zi.3.S6ILW0
    RO.S6ILW0V2 = S6ILW0P2[I] * zi.3.S6ILW0
    RO.S6ILW0V3 = S6ILW0P3[I] * zi.3.S6ILW0
    
    RO.S6ILW1V0 = S6ILW1P0[I] * zi.3.S6ILW1
    RO.S6ILW1V1 = S6ILW1P1[I] * zi.3.S6ILW1
    RO.S6ILW1V2 = S6ILW1P2[I] * zi.3.S6ILW1
    RO.S6ILW1V3 = S6ILW1P3[I] * zi.3.S6ILW1
    
    RO.S6ILW2V0 = S6ILW2P0[I] * zi.3.S6ILW2
    RO.S6ILW2V1 = S6ILW2P1[I] * zi.3.S6ILW2
    RO.S6ILW2V2 = S6ILW2P2[I] * zi.3.S6ILW2
    RO.S6ILW2V3 = S6ILW2P3[I] * zi.3.S6ILW2
    
    RO.S6ILW3V0 = S6ILW3P0[I] * zi.3.S6ILW3
    RO.S6ILW3V1 = S6ILW3P1[I] * zi.3.S6ILW3
    RO.S6ILW3V2 = S6ILW3P2[I] * zi.3.S6ILW3
    RO.S6ILW3V3 = S6ILW3P3[I] * zi.3.S6ILW3
    
    RO.S6IHW0V0 = S6IHW0P0[I] * zi.3.S6IHW0  ;high income
    RO.S6IHW0V1 = S6IHW0P1[I] * zi.3.S6IHW0
    RO.S6IHW0V2 = S6IHW0P2[I] * zi.3.S6IHW0
    RO.S6IHW0V3 = S6IHW0P3[I] * zi.3.S6IHW0
    
    RO.S6IHW1V0 = S6IHW1P0[I] * zi.3.S6IHW1
    RO.S6IHW1V1 = S6IHW1P1[I] * zi.3.S6IHW1
    RO.S6IHW1V2 = S6IHW1P2[I] * zi.3.S6IHW1
    RO.S6IHW1V3 = S6IHW1P3[I] * zi.3.S6IHW1
    
    RO.S6IHW2V0 = S6IHW2P0[I] * zi.3.S6IHW2
    RO.S6IHW2V1 = S6IHW2P1[I] * zi.3.S6IHW2
    RO.S6IHW2V2 = S6IHW2P2[I] * zi.3.S6IHW2
    RO.S6IHW2V3 = S6IHW2P3[I] * zi.3.S6IHW2
    
    RO.S6IHW3V0 = S6IHW3P0[I] * zi.3.S6IHW3
    RO.S6IHW3V1 = S6IHW3P1[I] * zi.3.S6IHW3
    RO.S6IHW3V2 = S6IHW3P2[I] * zi.3.S6IHW3
    RO.S6IHW3V3 = S6IHW3P3[I] * zi.3.S6IHW3
    
    
    ;write out files
    WRITE  RECO=1-6
    
    
    
    ;*************************** Auto Ownership Summaries ******************************
    ;sumarize to HHSize x VehicleOwn
    RO.S1V0 = RO.S1ILW0V0 + RO.S1ILW1V0 + RO.S1ILW2V0 + RO.S1ILW3V0 + 
              RO.S1IHW0V0 + RO.S1IHW1V0 + RO.S1IHW2V0 + RO.S1IHW3V0
    
    RO.S2V0 = RO.S2ILW0V0 + RO.S2ILW1V0 + RO.S2ILW2V0 + RO.S2ILW3V0 + 
              RO.S2IHW0V0 + RO.S2IHW1V0 + RO.S2IHW2V0 + RO.S2IHW3V0
         
    RO.S3V0 = RO.S3ILW0V0 + RO.S3ILW1V0 + RO.S3ILW2V0 + RO.S3ILW3V0 + 
              RO.S3IHW0V0 + RO.S3IHW1V0 + RO.S3IHW2V0 + RO.S3IHW3V0     
    
    RO.S4V0 = RO.S4ILW0V0 + RO.S4ILW1V0 + RO.S4ILW2V0 + RO.S4ILW3V0 + 
              RO.S4IHW0V0 + RO.S4IHW1V0 + RO.S4IHW2V0 + RO.S4IHW3V0
          
    RO.S5V0 = RO.S5ILW0V0 + RO.S5ILW1V0 + RO.S5ILW2V0 + RO.S5ILW3V0 + 
              RO.S5IHW0V0 + RO.S5IHW1V0 + RO.S5IHW2V0 + RO.S5IHW3V0
          
    RO.S6V0 = RO.S6ILW0V0 + RO.S6ILW1V0 + RO.S6ILW2V0 + RO.S6ILW3V0 + 
              RO.S6IHW0V0 + RO.S6IHW1V0 + RO.S6IHW2V0 + RO.S6IHW3V0
    
    
    RO.S1V1 = RO.S1ILW0V1 + RO.S1ILW1V1 + RO.S1ILW2V1 + RO.S1ILW3V1 + 
              RO.S1IHW0V1 + RO.S1IHW1V1 + RO.S1IHW2V1 + RO.S1IHW3V1
    
    RO.S2V1 = RO.S2ILW0V1 + RO.S2ILW1V1 + RO.S2ILW2V1 + RO.S2ILW3V1 + 
              RO.S2IHW0V1 + RO.S2IHW1V1 + RO.S2IHW2V1 + RO.S2IHW3V1
         
    RO.S3V1 = RO.S3ILW0V1 + RO.S3ILW1V1 + RO.S3ILW2V1 + RO.S3ILW3V1 + 
              RO.S3IHW0V1 + RO.S3IHW1V1 + RO.S3IHW2V1 + RO.S3IHW3V1     
    
    RO.S4V1 = RO.S4ILW0V1 + RO.S4ILW1V1 + RO.S4ILW2V1 + RO.S4ILW3V1 + 
              RO.S4IHW0V1 + RO.S4IHW1V1 + RO.S4IHW2V1 + RO.S4IHW3V1
          
    RO.S5V1 = RO.S5ILW0V1 + RO.S5ILW1V1 + RO.S5ILW2V1 + RO.S5ILW3V1 + 
              RO.S5IHW0V1 + RO.S5IHW1V1 + RO.S5IHW2V1 + RO.S5IHW3V1
          
    RO.S6V1 = RO.S6ILW0V1 + RO.S6ILW1V1 + RO.S6ILW2V1 + RO.S6ILW3V1 + 
              RO.S6IHW0V1 + RO.S6IHW1V1 + RO.S6IHW2V1 + RO.S6IHW3V1
    
    
    RO.S1V2 = RO.S1ILW0V2 + RO.S1ILW1V2 + RO.S1ILW2V2 + RO.S1ILW3V2 + 
              RO.S1IHW0V2 + RO.S1IHW1V2 + RO.S1IHW2V2 + RO.S1IHW3V2
    
    RO.S2V2 = RO.S2ILW0V2 + RO.S2ILW1V2 + RO.S2ILW2V2 + RO.S2ILW3V2 + 
              RO.S2IHW0V2 + RO.S2IHW1V2 + RO.S2IHW2V2 + RO.S2IHW3V2
         
    RO.S3V2 = RO.S3ILW0V2 + RO.S3ILW1V2 + RO.S3ILW2V2 + RO.S3ILW3V2 + 
              RO.S3IHW0V2 + RO.S3IHW1V2 + RO.S3IHW2V2 + RO.S3IHW3V2     
    
    RO.S4V2 = RO.S4ILW0V2 + RO.S4ILW1V2 + RO.S4ILW2V2 + RO.S4ILW3V2 + 
              RO.S4IHW0V2 + RO.S4IHW1V2 + RO.S4IHW2V2 + RO.S4IHW3V2
          
    RO.S5V2 = RO.S5ILW0V2 + RO.S5ILW1V2 + RO.S5ILW2V2 + RO.S5ILW3V2 + 
              RO.S5IHW0V2 + RO.S5IHW1V2 + RO.S5IHW2V2 + RO.S5IHW3V2
          
    RO.S6V2 = RO.S6ILW0V2 + RO.S6ILW1V2 + RO.S6ILW2V2 + RO.S6ILW3V2 + 
              RO.S6IHW0V2 + RO.S6IHW1V2 + RO.S6IHW2V2 + RO.S6IHW3V2
          
    
    RO.S1V3 = RO.S1ILW0V3 + RO.S1ILW1V3 + RO.S1ILW2V3 + RO.S1ILW3V3 + 
              RO.S1IHW0V3 + RO.S1IHW1V3 + RO.S1IHW2V3 + RO.S1IHW3V3
    
    RO.S2V3 = RO.S2ILW0V3 + RO.S2ILW1V3 + RO.S2ILW2V3 + RO.S2ILW3V3 + 
              RO.S2IHW0V3 + RO.S2IHW1V3 + RO.S2IHW2V3 + RO.S2IHW3V3
         
    RO.S3V3 = RO.S3ILW0V3 + RO.S3ILW1V3 + RO.S3ILW2V3 + RO.S3ILW3V3 + 
              RO.S3IHW0V3 + RO.S3IHW1V3 + RO.S3IHW2V3 + RO.S3IHW3V3     
    
    RO.S4V3 = RO.S4ILW0V3 + RO.S4ILW1V3 + RO.S4ILW2V3 + RO.S4ILW3V3 + 
              RO.S4IHW0V3 + RO.S4IHW1V3 + RO.S4IHW2V3 + RO.S4IHW3V3
          
    RO.S5V3 = RO.S5ILW0V3 + RO.S5ILW1V3 + RO.S5ILW2V3 + RO.S5ILW3V3 + 
              RO.S5IHW0V3 + RO.S5IHW1V3 + RO.S5IHW2V3 + RO.S5IHW3V3
          
    RO.S6V3 = RO.S6ILW0V3 + RO.S6ILW1V3 + RO.S6ILW2V3 + RO.S6ILW3V3 + 
              RO.S6IHW0V3 + RO.S6IHW1V3 + RO.S6IHW2V3 + RO.S6IHW3V3 
    
    
    ;summarize into VehiclesOwn
    HHV0a  = RO.S1V0 + RO.S2V0 + RO.S3V0 + RO.S4V0 + RO.S5V0 + RO.S6V0
    HHV1a  = RO.S1V1 + RO.S2V1 + RO.S3V1 + RO.S4V1 + RO.S5V1 + RO.S6V1
    HHV2a  = RO.S1V2 + RO.S2V2 + RO.S3V2 + RO.S4V2 + RO.S5V2 + RO.S6V2
    HHV3a  = RO.S1V3 + RO.S2V3 + RO.S3V3 + RO.S4V3 + RO.S5V3 + RO.S6V3
    TotHHa = HHV0a + HHV1a + HHV2a + HHV3a
    
    
    ;calculate number of vehicles
    V0a = HHV0a * 0
    V1a = HHV1a * 1
    V2a = HHV2a * 2
    V3a = HHV3a * @AveNum3PlusCars@
    
    TotCarsa = V0a + V1a + V2a + V3a
    
    
    ;calculate vehicle / HH
    if (TotHHa=0) 
        CarspHHa = 0
    else
        CarspHHa = TotCarsa / TotHHa
    endif
    
    
    ;calculte % VehicleOwn
    if (TotHHa>0)
        PctV0a = INT(100 * HHV0a / TotHHa)
        PctV1a = INT(100 * HHV1a / TotHHa)
        PctV2a = INT(100 * HHV2a / TotHHa)
        PctV3a = 100 - (PctV0a + PctV1a + PctV2a)
    endif
    
    
    ;assign output variables
    RO.AUTOS  = TotCarsa
    RO.SUMHH  = TotHHa
    RO.ApHH   = CarspHHa
    RO.PctV0a = PctV0a
    RO.PctV1a = PctV1a
    RO.PctV2a = PctV2a
    RO.PctV3a = PctV3a
    
    
    ;write to output file
    WRITE RECO=7

    
    
    ;summarize households in each vehicle ownership category
     RO.HHV0 = RO.S1ILW0V0 + RO.S1ILW1V0 + RO.S1ILW2V0 + RO.S1ILW3V0 +
               RO.S2ILW0V0 + RO.S2ILW1V0 + RO.S2ILW2V0 + RO.S2ILW3V0 +
               RO.S3ILW0V0 + RO.S3ILW1V0 + RO.S3ILW2V0 + RO.S3ILW3V0 +
               RO.S4ILW0V0 + RO.S4ILW1V0 + RO.S4ILW2V0 + RO.S4ILW3V0 + 
               RO.S5ILW0V0 + RO.S5ILW1V0 + RO.S5ILW2V0 + RO.S5ILW3V0 + 
               RO.S6ILW0V0 + RO.S6ILW1V0 + RO.S6ILW2V0 + RO.S6ILW3V0 + 
               
               RO.S1IHW0V0 + RO.S1IHW1V0 + RO.S1IHW2V0 + RO.S1IHW3V0 +
               RO.S2IHW0V0 + RO.S2IHW1V0 + RO.S2IHW2V0 + RO.S2IHW3V0 +
               RO.S3IHW0V0 + RO.S3IHW1V0 + RO.S3IHW2V0 + RO.S3IHW3V0 +
               RO.S4IHW0V0 + RO.S4IHW1V0 + RO.S4IHW2V0 + RO.S4IHW3V0 + 
               RO.S5IHW0V0 + RO.S5IHW1V0 + RO.S5IHW2V0 + RO.S5IHW3V0 + 
               RO.S6IHW0V0 + RO.S6IHW1V0 + RO.S6IHW2V0 + RO.S6IHW3V0
              
     RO.HHV1 = RO.S1ILW0V1 + RO.S1ILW1V1 + RO.S1ILW2V1 + RO.S1ILW3V1 +
               RO.S2ILW0V1 + RO.S2ILW1V1 + RO.S2ILW2V1 + RO.S2ILW3V1 +
               RO.S3ILW0V1 + RO.S3ILW1V1 + RO.S3ILW2V1 + RO.S3ILW3V1 +
               RO.S4ILW0V1 + RO.S4ILW1V1 + RO.S4ILW2V1 + RO.S4ILW3V1 + 
               RO.S5ILW0V1 + RO.S5ILW1V1 + RO.S5ILW2V1 + RO.S5ILW3V1 + 
               RO.S6ILW0V1 + RO.S6ILW1V1 + RO.S6ILW2V1 + RO.S6ILW3V1 + 
               
               RO.S1IHW0V1 + RO.S1IHW1V1 + RO.S1IHW2V1 + RO.S1IHW3V1 +
               RO.S2IHW0V1 + RO.S2IHW1V1 + RO.S2IHW2V1 + RO.S2IHW3V1 +
               RO.S3IHW0V1 + RO.S3IHW1V1 + RO.S3IHW2V1 + RO.S3IHW3V1 +
               RO.S4IHW0V1 + RO.S4IHW1V1 + RO.S4IHW2V1 + RO.S4IHW3V1 + 
               RO.S5IHW0V1 + RO.S5IHW1V1 + RO.S5IHW2V1 + RO.S5IHW3V1 + 
               RO.S6IHW0V1 + RO.S6IHW1V1 + RO.S6IHW2V1 + RO.S6IHW3V1    
              
     RO.HHV2 = RO.S1ILW0V2 + RO.S1ILW1V2 + RO.S1ILW2V2 + RO.S1ILW3V2 +
               RO.S2ILW0V2 + RO.S2ILW1V2 + RO.S2ILW2V2 + RO.S2ILW3V2 +
               RO.S3ILW0V2 + RO.S3ILW1V2 + RO.S3ILW2V2 + RO.S3ILW3V2 +
               RO.S4ILW0V2 + RO.S4ILW1V2 + RO.S4ILW2V2 + RO.S4ILW3V2 + 
               RO.S5ILW0V2 + RO.S5ILW1V2 + RO.S5ILW2V2 + RO.S5ILW3V2 + 
               RO.S6ILW0V2 + RO.S6ILW1V2 + RO.S6ILW2V2 + RO.S6ILW3V2 + 
                
               RO.S1IHW0V2 + RO.S1IHW1V2 + RO.S1IHW2V2 + RO.S1IHW3V2 +
               RO.S2IHW0V2 + RO.S2IHW1V2 + RO.S2IHW2V2 + RO.S2IHW3V2 +
               RO.S3IHW0V2 + RO.S3IHW1V2 + RO.S3IHW2V2 + RO.S3IHW3V2 +
               RO.S4IHW0V2 + RO.S4IHW1V2 + RO.S4IHW2V2 + RO.S4IHW3V2 + 
               RO.S5IHW0V2 + RO.S5IHW1V2 + RO.S5IHW2V2 + RO.S5IHW3V2 + 
               RO.S6IHW0V2 + RO.S6IHW1V2 + RO.S6IHW2V2 + RO.S6IHW3V2 
              
     RO.HHV3 = RO.S1ILW0V3 + RO.S1ILW1V3 + RO.S1ILW2V3 + RO.S1ILW3V3 +
               RO.S2ILW0V3 + RO.S2ILW1V3 + RO.S2ILW2V3 + RO.S2ILW3V3 +
               RO.S3ILW0V3 + RO.S3ILW1V3 + RO.S3ILW2V3 + RO.S3ILW3V3 +
               RO.S4ILW0V3 + RO.S4ILW1V3 + RO.S4ILW2V3 + RO.S4ILW3V3 + 
               RO.S5ILW0V3 + RO.S5ILW1V3 + RO.S5ILW2V3 + RO.S5ILW3V3 + 
               RO.S6ILW0V3 + RO.S6ILW1V3 + RO.S6ILW2V3 + RO.S6ILW3V3 + 
               
               RO.S1IHW0V3 + RO.S1IHW1V3 + RO.S1IHW2V3 + RO.S1IHW3V3 +
               RO.S2IHW0V3 + RO.S2IHW1V3 + RO.S2IHW2V3 + RO.S2IHW3V3 +
               RO.S3IHW0V3 + RO.S3IHW1V3 + RO.S3IHW2V3 + RO.S3IHW3V3 +
               RO.S4IHW0V3 + RO.S4IHW1V3 + RO.S4IHW2V3 + RO.S4IHW3V3 + 
               RO.S5IHW0V3 + RO.S5IHW1V3 + RO.S5IHW2V3 + RO.S5IHW3V3 + 
               RO.S6IHW0V3 + RO.S6IHW1V3 + RO.S6IHW2V3 + RO.S6IHW3V3

    TotHHb = RO.HHV0 + RO.HHV1 + RO.HHV2 + RO.HHV3
    
    
    ;calculate numer of vehicles
    RO.V0 = RO.HHV0 * 0 
    RO.V1 = RO.HHV1 * 1 
    RO.V2 = RO.HHV2 * 2 
    RO.V3 = RO.HHV3 * @AveNum3PlusCars@   
    
    TotCarsb = RO.V0 + RO.V1 + RO.V2 + RO.V3
    
    
    ;calculate vehicle / HH
    if (TotHHb=0) 
        CarspHHb = 0
    else
        CarspHHb = TotCarsb / TotHHb
    endif
    
    
    ;calculte % VehicleOwn
    if (TotHHb>0)
        PctV0b =  INT(100 * RO.HHV0 / TotHHb)
        PctV1b =  INT(100 * RO.HHV1 / TotHHb)
        PctV2b =  INT(100 * RO.HHV2 / TotHHb)
        PctV3b =  100 - (PctV0b + PctV1b + PctV2b)
    endif
    
    
    ;assign output variables
    RO.AUTOS  = TotCarsb
    RO.SUMHH  = TotHHb
    RO.ApHH   = CarspHHb
    RO.PctV0b = PctV0b
    RO.PctV1b = PctV1b
    RO.PctV2b = PctV2b
    RO.PctV3b = PctV3b
    
    
    ;write to output file
    WRITE RECO=8
    
    
    ;total number of vehicles in zone
    GTotHH   = GTotHH   + TotHHb
    GTOTCARS = GTOTCARS + TotCarsb
    
    if (I=@BoxElderRange@) BECARS  = BECARS  + TotCarsb
    if (I=@WeberRange@)    WebCARS = WebCARS + TotCarsb
    if (I=@DavisRange@)    DavCARS = DavCARS + TotCarsb
    if (I=@SLRange@)       SLCARS  = SLCARS  + TotCarsb
    if (I=@UtahRange@)     UtCARS  = UtCARS  + TotCarsb
    
    if (I=ZONES)
        PRINT FILE='@ParentDir@@ScenarioDir@Temp\1_HHDisag_AutoOwn\VO_Tmp_CountyVehicleTotal.txt', FORM=11.0C, LIST=
            GTotHH,   '  Total HH\n', 
            GTOTCARS, '  Total Vehicles\n', 
            BECARS,   '    Box Elder County Vehicles\n',
            WebCARS,  '    Weber County Vehicles\n',
            DavCARS,  '    Davis County Vehicles\n',
            SLCARS,   '    Salt Lake County Vehicles\n',
            UtCARS,   '    Utah County Vehicles\n'
    endif
ENDRUN


RUN PGM=MATRIX
    
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    PRINT FILE='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\expanded_SE_File_@RID@.csv',
    CSV=T,
    LIST='Z',
         'CO_TAZID',
         'SUBAREAID',
         'TOTHH',
         'HHPOP',
         'HHSIZE',
         'TOTWRK',
         'HHV0',
         'HHV1',
         'HHV2',
         'HHV3',
         'AUTOS',
         'TOTEMP',
         'RETEMP',
         'INDEMP',
         'OTHEMP',
         'ALLEMP',
         'RETL',
         'FOOD',
         'MANU',
         'WSLE',
         'OFFI',
         'GVED',
         'HLTH',
         'OTHR',
         'AGRI',
         'MING',
         'CONS',
         'HBJ',
         'AVGINCOME',
         'ENROL_ELEM',
         'ENROL_MIDL',
         'ENROL_HIGH',
         'CO_FIPS',
         'CO_NAME',
         'CITY_NAME',
         'DISTLRG',
         'DLRG_NAME',
         'DISTMED',
         'DMED_NAME',
         'DISTSML',
         'DSML_NAME',
         'HHJOBINT',
         
    ENDRUN

RUN PGM=MATRIX

    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf',
        SORT=Z,
        AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\Marginal_Worker.dbf',
        SORT=Z,
        AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\VO_VehOwn.dbf',
        Sort=Z,
        AUTOARRAY=ALLFIELDS
        
    ;set MATRIX parameters (processes once through MATRIX module)
    ZONES = 1
    
    ;loop through number of records and process/output data
    LOOP numrec=1, dbi.1.NUMRECORDS
        
        ;Add code later to get auto ownnership values if needed
        
        PRINT FILE='@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\expanded_SE_File_@RID@.csv',
                APPEND=T,
                CSV=T,
                LIST=dba.1.Z[numrec],
                     dba.1.CO_TAZID[numrec],
                     dba.1.SUBAREAID[numrec],
                     dba.1.TOTHH[numrec],
                     dba.1.HHPOP[numrec],
                     dba.1.HHSIZE[numrec],
                     dba.2.TOTWRK[numrec],
                     dba.3.HHV0[numrec],
                     dba.3.HHV1[numrec],
                     dba.3.HHV2[numrec],
                     dba.3.HHV3[numrec],
                     dba.3.AUTOS[numrec],
                     dba.1.TOTEMP[numrec],
                     dba.1.RETEMP[numrec],
                     dba.1.INDEMP[numrec],
                     dba.1.OTHEMP[numrec],
                     dba.1.ALLEMP[numrec],
                     dba.1.RETL[numrec],
                     dba.1.FOOD[numrec],
                     dba.1.MANU[numrec],
                     dba.1.WSLE[numrec],
                     dba.1.OFFI[numrec],
                     dba.1.GVED[numrec],
                     dba.1.HLTH[numrec],
                     dba.1.OTHR[numrec],
                     dba.1.AGRI[numrec],
                     dba.1.MING[numrec],
                     dba.1.CONS[numrec],
                     dba.1.HBJ[numrec],
                     dba.1.AVGINCOME[numrec],
                     dba.1.ENROL_ELEM[numrec],
                     dba.1.ENROL_MIDL[numrec],
                     dba.1.ENROL_HIGH[numrec],
                     dba.1.CO_FIPS[numrec],
                     dba.1.CO_NAME[numrec],
                     dba.1.CITY_NAME[numrec],
                     dba.1.DISTLRG[numrec],
                     dba.1.DLRG_NAME[numrec],
                     dba.1.DISTMED[numrec],
                     dba.1.DMED_NAME[numrec],
                     dba.1.DISTSML[numrec],
                     dba.1.DSML_NAME[numrec],
                     dba.1.HHJOBINT[numrec]

    ENDLOOP

ENDRUN



if (Run_vizTool=1)

RUN PGM=MATRIX MSG='Run Python Script to Create JSON for vizTool'

    ZONES = 1

    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='# ------------------------------------------------------------------------------',
             '\n# Python input file variables and paths',
             '\n# ------------------------------------------------------------------------------',
             '\n',
             '\n# global parameters ------------------------------------------------------------',
             '\njsonId          = "zonese"',
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
             '\ninputFile       = r"@ParentDir@@ScenarioDir@1_HHDisag_AutoOwn\expanded_SE_File_@RID@.csv"',
             '\n',
             '\n'

ENDRUN


;Python script: create json for zone se data
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
        LIST='\n    Auto Ownership                     ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



;System cleanup
    *(DEL 3_AutoOwnership.txt)
