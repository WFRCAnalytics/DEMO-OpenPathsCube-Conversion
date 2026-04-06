
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 04_SummarizeLoadedNetworks.txt)



;get start time
ScriptStartTime = currenttime()




;set controls for which block file to read
if (Use_SelLinkGrp=1)
    SGRPY = ' '
else
    SGRPY = ';'
endif


if (RunPM1hr=1)
    PM1Y = ' '
else
    PM1Y = ';'
endif



RUN PGM=NETWORK   MSG='Final Assign: summarize loaded networks (detailed)'
    FILEI NETI[1]  = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@_tmp_AM.net'
    FILEI GEOMI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Link.shp'
    
    FILEI NETI[2] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@_tmp_MD.net'
    FILEI NETI[3] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@_tmp_PM.net'
    FILEI NETI[4] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@_tmp_EV.net'
    
    @PM1Y@ NETI[5] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@_tmp_PM1hr.net'
    
    LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\BTI_Lookup.csv'
    
    
    FILEO NETO = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Assigned.net',
        EXCLUDE=TIME_1         ,
                VC_1           ,
                VHT_1          ,
                VDT_1          ,
                CSPD_1         ,
                lw_RPen_1      ,
                lw_TPen_1      ,
                lw_Spd_Auto_1  ,
                lw_TrkSpd_MD_1 ,
                lw_TrkSpd_HV_1 ,
                lw_Time_Auto_1 ,
                lw_TrkTime_MD_1,
                lw_TrkTime_HV_1,
                  V_1,   VT_1,            ;Sel Link 1        Sel Link 2
                 V1_1,  V1T_1,    @SGRPY@ V31_1, V31T_1,    V61_1, V61T_1,
                 V2_1,  V2T_1,    @SGRPY@ V32_1, V32T_1,    V62_1, V62T_1,
                 V3_1,  V3T_1,    @SGRPY@ V33_1, V33T_1,    V63_1, V63T_1,
                 V4_1,  V4T_1,    @SGRPY@ V34_1, V34T_1,    V64_1, V64T_1,
                 V5_1,  V5T_1,    @SGRPY@ V35_1, V35T_1,    V65_1, V65T_1,
                 V6_1,  V6T_1,    @SGRPY@ V36_1, V36T_1,    V66_1, V66T_1,
                 V7_1,  V7T_1,    @SGRPY@ V37_1, V37T_1,    V67_1, V67T_1,
                 V8_1,  V8T_1,    @SGRPY@ V38_1, V38T_1,    V68_1, V68T_1,
                 V9_1,  V9T_1,    @SGRPY@ V39_1, V39T_1,    V69_1, V69T_1,
                V10_1, V10T_1,    @SGRPY@ V40_1, V40T_1,    V70_1, V70T_1,
                V11_1, V11T_1,    @SGRPY@ V41_1, V41T_1,    V71_1, V71T_1,
                V12_1, V12T_1,    @SGRPY@ V42_1, V42T_1,    V72_1, V72T_1,
                V13_1, V13T_1,    @SGRPY@ V43_1, V43T_1,    V73_1, V73T_1,
                V14_1, V14T_1,    @SGRPY@ V44_1, V44T_1,    V74_1, V74T_1,
                V15_1, V15T_1,    @SGRPY@ V45_1, V45T_1,    V75_1, V75T_1,
                V16_1, V16T_1,    @SGRPY@ V46_1, V46T_1,    V76_1, V76T_1,
                V17_1, V17T_1,    @SGRPY@ V47_1, V47T_1,    V77_1, V77T_1,
                V18_1, V18T_1,    @SGRPY@ V48_1, V48T_1,    V78_1, V78T_1,
                V19_1, V19T_1,    @SGRPY@ V49_1, V49T_1,    V79_1, V79T_1,
                V20_1, V20T_1,    @SGRPY@ V50_1, V50T_1,    V80_1, V80T_1,
                V21_1, V21T_1,    @SGRPY@ V51_1, V51T_1,    V81_1, V81T_1,
                V22_1, V22T_1,    @SGRPY@ V52_1, V52T_1,    V82_1, V82T_1,
                V23_1, V23T_1,    @SGRPY@ V53_1, V53T_1,    V83_1, V83T_1,
                V24_1, V24T_1,    @SGRPY@ V54_1, V54T_1,    V84_1, V84T_1,
                V25_1, V25T_1,    @SGRPY@ V55_1, V55T_1,    V85_1, V85T_1,
                V26_1, V26T_1,    @SGRPY@ V56_1, V56T_1,    V86_1, V86T_1,
                V27_1, V27T_1,    @SGRPY@ V57_1, V57T_1,    V87_1, V87T_1,
                V28_1, V28T_1,    @SGRPY@ V58_1, V58T_1,    V88_1, V88T_1,
                V29_1, V29T_1,    @SGRPY@ V59_1, V59T_1,    V89_1, V89T_1,
                V30_1, V30T_1     @SGRPY@,V60_1, V60T_1,    V90_1, V90T_1
    
    FILEO LINKO = '@ParentDir@@ScenarioDir@5_AssignHwy\2b_Shapefiles\@RID@_Assigned.shp',
        FORMAT=SHP,
        EXCLUDE=TIME_1         ,
                VC_1           ,
                VHT_1          ,
                VDT_1          ,
                CSPD_1         ,
                lw_RPen_1      ,
                lw_TPen_1      ,
                lw_Spd_Auto_1  ,
                lw_TrkSpd_MD_1 ,
                lw_TrkSpd_HV_1 ,
                lw_Time_Auto_1 ,
                lw_TrkTime_MD_1,
                lw_TrkTime_HV_1,
                  V_1,   VT_1,            ;Sel Link 1        Sel Link 2
                 V1_1,  V1T_1,    @SGRPY@ V31_1, V31T_1,    V61_1, V61T_1,
                 V2_1,  V2T_1,    @SGRPY@ V32_1, V32T_1,    V62_1, V62T_1,
                 V3_1,  V3T_1,    @SGRPY@ V33_1, V33T_1,    V63_1, V63T_1,
                 V4_1,  V4T_1,    @SGRPY@ V34_1, V34T_1,    V64_1, V64T_1,
                 V5_1,  V5T_1,    @SGRPY@ V35_1, V35T_1,    V65_1, V65T_1,
                 V6_1,  V6T_1,    @SGRPY@ V36_1, V36T_1,    V66_1, V66T_1,
                 V7_1,  V7T_1,    @SGRPY@ V37_1, V37T_1,    V67_1, V67T_1,
                 V8_1,  V8T_1,    @SGRPY@ V38_1, V38T_1,    V68_1, V68T_1,
                 V9_1,  V9T_1,    @SGRPY@ V39_1, V39T_1,    V69_1, V69T_1,
                V10_1, V10T_1,    @SGRPY@ V40_1, V40T_1,    V70_1, V70T_1,
                V11_1, V11T_1,    @SGRPY@ V41_1, V41T_1,    V71_1, V71T_1,
                V12_1, V12T_1,    @SGRPY@ V42_1, V42T_1,    V72_1, V72T_1,
                V13_1, V13T_1,    @SGRPY@ V43_1, V43T_1,    V73_1, V73T_1,
                V14_1, V14T_1,    @SGRPY@ V44_1, V44T_1,    V74_1, V74T_1,
                V15_1, V15T_1,    @SGRPY@ V45_1, V45T_1,    V75_1, V75T_1,
                V16_1, V16T_1,    @SGRPY@ V46_1, V46T_1,    V76_1, V76T_1,
                V17_1, V17T_1,    @SGRPY@ V47_1, V47T_1,    V77_1, V77T_1,
                V18_1, V18T_1,    @SGRPY@ V48_1, V48T_1,    V78_1, V78T_1,
                V19_1, V19T_1,    @SGRPY@ V49_1, V49T_1,    V79_1, V79T_1,
                V20_1, V20T_1,    @SGRPY@ V50_1, V50T_1,    V80_1, V80T_1,
                V21_1, V21T_1,    @SGRPY@ V51_1, V51T_1,    V81_1, V81T_1,
                V22_1, V22T_1,    @SGRPY@ V52_1, V52T_1,    V82_1, V82T_1,
                V23_1, V23T_1,    @SGRPY@ V53_1, V53T_1,    V83_1, V83T_1,
                V24_1, V24T_1,    @SGRPY@ V54_1, V54T_1,    V84_1, V84T_1,
                V25_1, V25T_1,    @SGRPY@ V55_1, V55T_1,    V85_1, V85T_1,
                V26_1, V26T_1,    @SGRPY@ V56_1, V56T_1,    V86_1, V86T_1,
                V27_1, V27T_1,    @SGRPY@ V57_1, V57T_1,    V87_1, V87T_1,
                V28_1, V28T_1,    @SGRPY@ V58_1, V58T_1,    V88_1, V88T_1,
                V29_1, V29T_1,    @SGRPY@ V59_1, V59T_1,    V89_1, V89T_1,
                V30_1, V30T_1     @SGRPY@,V60_1, V60T_1,    V90_1, V90T_1
    
    
	;parameters
	ZONES = @Usedzones@
    
    
    ;define arrays
    ARRAY HOT_GP_VMT_AM  = 10000,
          HOT_GP_VMT_MD  = 10000,
          HOT_GP_VMT_PM  = 10000,
          HOT_GP_VMT_EV  = 10000,
          HOT_GP_VMT_PM1 = 10000,
          
          HOT_GP_VHT_AM  = 10000,
          HOT_GP_VHT_MD  = 10000,
          HOT_GP_VHT_PM  = 10000,
          HOT_GP_VHT_EV  = 10000,
          HOT_GP_VHT_PM1 = 10000,
          
          HOT_GP_SPD_AM  = 10000,
          HOT_GP_SPD_MD  = 10000,
          HOT_GP_SPD_PM  = 10000,
          HOT_GP_SPD_EV  = 10000,
          HOT_GP_SPD_PM1 = 10000
    
    
    ;Free flow speed lookup function
    LOOKUP LOOKUPI=1, 
        INTERPOLATE=T, 
        NAME=BTI_pct,
        LOOKUP[1]=01, RESULT=02
    
    
    
    ;process HOTZONEID data - AM
    PHASE=INPUT FILEI = li.1
        
        ;calculate general purpose lane in HOT Zone data
        if (HOT_ZONEID>0 & FT=20-36)
            ;total link volume
            _Link_TotVol = V1_1  +
                           V2_1  +
                           V3_1  +
                           V4_1  +
                           V5_1  +
                           V6_1  +
                           V7_1  +
                           V8_1  +
                           V9_1  +
                           V10_1 +
                           V11_1 +
                           V12_1 +
                           V13_1 +
                           V14_1 +
                           V15_1 +
                           V16_1 +
                           V17_1 +
                           V18_1 +
                           V19_1 +
                           V20_1 +
                           V21_1 +
                           V22_1 +
                           V23_1 +
                           V24_1 +
                           V25_1 +
                           V26_1 +
                           V27_1 +
                           V28_1 +
                           V29_1 +
                           V30_1 
            
            ;HOT Zone VMT (vehicles miles traveled)
            HOT_GP_VMT_AM[HOT_ZONEID] = HOT_GP_VMT_AM[HOT_ZONEID] + DISTANCE * _Link_TotVol
            
            ;HOT Zone VHT (vehicle hours traveled)
            HOT_GP_VHT_AM[HOT_ZONEID] = HOT_GP_VHT_AM[HOT_ZONEID] + (TIME_1 * _Link_TotVol) / 60
            
            ;HOT Zone average speed (miles per hour)
            ;  note: calculation will be correct after last link in HOT Zone is processed
            HOT_GP_SPD_AM[HOT_ZONEID] = HOT_GP_VMT_AM[HOT_ZONEID] / HOT_GP_VHT_AM[HOT_ZONEID]
            
        endif  ;HOT_ZONEID>0 & FT=37-39
        
    ENDPHASE  ;FILEI = li.1
    
    
    ;process HOTZONEID data - MD
    PHASE=INPUT FILEI=li.2
        
        ;calculate general purpose lane in HOT Zone data
        if (HOT_ZONEID>0 & FT=20-36)
            ;total link volume
            _Link_TotVol = V1_1  +
                           V2_1  +
                           V3_1  +
                           V4_1  +
                           V5_1  +
                           V6_1  +
                           V7_1  +
                           V8_1  +
                           V9_1  +
                           V10_1 +
                           V11_1 +
                           V12_1 +
                           V13_1 +
                           V14_1 +
                           V15_1 +
                           V16_1 +
                           V17_1 +
                           V18_1 +
                           V19_1 +
                           V20_1 +
                           V21_1 +
                           V22_1 +
                           V23_1 +
                           V24_1 +
                           V25_1 +
                           V26_1 +
                           V27_1 +
                           V28_1 +
                           V29_1 +
                           V30_1 
            
            ;HOT Zone VMT (vehicles miles traveled)
            HOT_GP_VMT_MD[HOT_ZONEID] = HOT_GP_VMT_MD[HOT_ZONEID] + DISTANCE * _Link_TotVol
            
            ;HOT Zone VHT (vehicle hours traveled)
            HOT_GP_VHT_MD[HOT_ZONEID] = HOT_GP_VHT_MD[HOT_ZONEID] + (TIME_1 * _Link_TotVol) / 60
            
            ;HOT Zone average speed (miles per hour)
            ;  note: calculation will be correct after last link in HOT Zone is processed
            HOT_GP_SPD_MD[HOT_ZONEID] = HOT_GP_VMT_MD[HOT_ZONEID] / HOT_GP_VHT_MD[HOT_ZONEID]
        
        endif  ;HOT_ZONEID>0 & FT=37-39
        
    ENDPHASE  ;  ;FILEI = li.2
    
    
    ;process HOTZONEID data - PM
    PHASE=INPUT FILEI=li.3
        
        ;calculate general purpose lane in HOT Zone data
        if (HOT_ZONEID>0 & FT=20-36)
            ;total link volume
            _Link_TotVol = V1_1  +
                           V2_1  +
                           V3_1  +
                           V4_1  +
                           V5_1  +
                           V6_1  +
                           V7_1  +
                           V8_1  +
                           V9_1  +
                           V10_1 +
                           V11_1 +
                           V12_1 +
                           V13_1 +
                           V14_1 +
                           V15_1 +
                           V16_1 +
                           V17_1 +
                           V18_1 +
                           V19_1 +
                           V20_1 +
                           V21_1 +
                           V22_1 +
                           V23_1 +
                           V24_1 +
                           V25_1 +
                           V26_1 +
                           V27_1 +
                           V28_1 +
                           V29_1 +
                           V30_1 
            
            ;HOT Zone VMT (vehicles miles traveled)
            HOT_GP_VMT_PM[HOT_ZONEID] = HOT_GP_VMT_PM[HOT_ZONEID] + DISTANCE * _Link_TotVol
            
            ;HOT Zone VHT (vehicle hours traveled)
            HOT_GP_VHT_PM[HOT_ZONEID] = HOT_GP_VHT_PM[HOT_ZONEID] + (TIME_1 * _Link_TotVol) / 60
            
            ;HOT Zone average speed (miles per hour)
            ;  note: calculation will be correct after last link in HOT Zone is processed
            HOT_GP_SPD_PM[HOT_ZONEID] = HOT_GP_VMT_PM[HOT_ZONEID] / HOT_GP_VHT_PM[HOT_ZONEID]
        
        endif  ;HOT_ZONEID>0 & FT=37-39
        
    ENDPHASE  ;  ;FILEI = li.3
    
    
    ;process HOTZONEID data - EV
    PHASE=INPUT FILEI=li.4
        
        ;calculate general purpose lane in HOT Zone data
        if (HOT_ZONEID>0 & FT=20-36)
            ;total link volume
            _Link_TotVol = V1_1  +
                           V2_1  +
                           V3_1  +
                           V4_1  +
                           V5_1  +
                           V6_1  +
                           V7_1  +
                           V8_1  +
                           V9_1  +
                           V10_1 +
                           V11_1 +
                           V12_1 +
                           V13_1 +
                           V14_1 +
                           V15_1 +
                           V16_1 +
                           V17_1 +
                           V18_1 +
                           V19_1 +
                           V20_1 +
                           V21_1 +
                           V22_1 +
                           V23_1 +
                           V24_1 +
                           V25_1 +
                           V26_1 +
                           V27_1 +
                           V28_1 +
                           V29_1 +
                           V30_1 
            
            ;HOT Zone VMT (vehicles miles traveled)
            HOT_GP_VMT_EV[HOT_ZONEID] = HOT_GP_VMT_EV[HOT_ZONEID] + DISTANCE * _Link_TotVol
            
            ;HOT Zone VHT (vehicle hours traveled)
            HOT_GP_VHT_EV[HOT_ZONEID] = HOT_GP_VHT_EV[HOT_ZONEID] + (TIME_1 * _Link_TotVol) / 60
            
            ;HOT Zone average speed (miles per hour)
            ;  note: calculation will be correct after last link in HOT Zone is processed
            HOT_GP_SPD_EV[HOT_ZONEID] = HOT_GP_VMT_EV[HOT_ZONEID] / HOT_GP_VHT_EV[HOT_ZONEID]
        
        endif  ;HOT_ZONEID>0 & FT=37-39
        
    ENDPHASE  ;  ;FILEI = li.4
    
    
    @PM1Y@ ;process HOTZONEID data - PM
    @PM1Y@ PHASE=INPUT FILEI=li.5
    @PM1Y@     
    @PM1Y@     ;calculate general purpose lane in HOT Zone data
    @PM1Y@     if (HOT_ZONEID>0 & FT=20-36)
    @PM1Y@         ;total link volume
    @PM1Y@         _Link_TotVol = V1_1  +
    @PM1Y@                        V2_1  +
    @PM1Y@                        V3_1  +
    @PM1Y@                        V4_1  +
    @PM1Y@                        V5_1  +
    @PM1Y@                        V6_1  +
    @PM1Y@                        V7_1  +
    @PM1Y@                        V8_1  +
    @PM1Y@                        V9_1  +
    @PM1Y@                        V10_1 +
    @PM1Y@                        V11_1 +
    @PM1Y@                        V12_1 +
    @PM1Y@                        V13_1 +
    @PM1Y@                        V14_1 +
    @PM1Y@                        V15_1 +
    @PM1Y@                        V16_1 +
    @PM1Y@                        V17_1 +
    @PM1Y@                        V18_1 +
    @PM1Y@                        V19_1 +
    @PM1Y@                        V20_1 +
    @PM1Y@                        V21_1 +
    @PM1Y@                        V22_1 +
    @PM1Y@                        V23_1 +
    @PM1Y@                        V24_1 +
    @PM1Y@                        V25_1 +
    @PM1Y@                        V26_1 +
    @PM1Y@                        V27_1 +
    @PM1Y@                        V28_1 +
    @PM1Y@                        V29_1 +
    @PM1Y@                        V30_1  
    @PM1Y@         
    @PM1Y@         ;HOT Zone VMT (vehicles miles traveled)
    @PM1Y@         HOT_GP_VMT_PM1[HOT_ZONEID] = HOT_GP_VMT_PM1[HOT_ZONEID] + DISTANCE * _Link_TotVol
    @PM1Y@         
    @PM1Y@         ;HOT Zone VHT (vehicle hours traveled)
    @PM1Y@         HOT_GP_VHT_PM1[HOT_ZONEID] = HOT_GP_VHT_PM1[HOT_ZONEID] + (TIME_1 * _Link_TotVol) / 60
    @PM1Y@         
    @PM1Y@         ;HOT Zone average speed (miles per hour)
    @PM1Y@         ;  note: calculation will be correct after last link in HOT Zone is processed
    @PM1Y@         HOT_GP_SPD_PM1[HOT_ZONEID] = HOT_GP_VMT_PM1[HOT_ZONEID] / HOT_GP_VHT_PM1[HOT_ZONEID]
    @PM1Y@     
    @PM1Y@     endif  ;HOT_ZONEID>0 & FT=37-39
    @PM1Y@     
    @PM1Y@ ENDPHASE  ;  ;FILEI = li.5
    
    
    
    PHASE=LINKMERGE
        
        ;process raw volume ----------------------------------------------------------
        ;1 way volume
        _AM_HBW_DA_NON = ROUND(li.1.V1_1  * 10) / 10
        _AM_HBW_SR_NON = ROUND(li.1.V2_1  * 10) / 10
        _AM_HBW_SR_HOV = ROUND(li.1.V3_1  * 10) / 10
        _AM_HBW_DA_TOL = ROUND(li.1.V4_1  * 10) / 10
        _AM_HBW_SR_TOL = ROUND(li.1.V5_1  * 10) / 10
        _AM_HBO_DA_NON = ROUND(li.1.V6_1  * 10) / 10
        _AM_HBO_SR_NON = ROUND(li.1.V7_1  * 10) / 10
        _AM_HBO_SR_HOV = ROUND(li.1.V8_1  * 10) / 10
        _AM_HBO_DA_TOL = ROUND(li.1.V9_1  * 10) / 10
        _AM_HBO_SR_TOL = ROUND(li.1.V10_1 * 10) / 10
        _AM_NHB_DA_NON = ROUND(li.1.V11_1 * 10) / 10
        _AM_NHB_SR_NON = ROUND(li.1.V12_1 * 10) / 10
        _AM_NHB_SR_HOV = ROUND(li.1.V13_1 * 10) / 10
        _AM_NHB_DA_TOL = ROUND(li.1.V14_1 * 10) / 10
        _AM_NHB_SR_TOL = ROUND(li.1.V15_1 * 10) / 10
        _AM_HBC_DA_NON = ROUND(li.1.V16_1 * 10) / 10
        _AM_HBC_SR_NON = ROUND(li.1.V17_1 * 10) / 10
        _AM_HBC_SR_HOV = ROUND(li.1.V18_1 * 10) / 10
        _AM_HBC_DA_TOL = ROUND(li.1.V19_1 * 10) / 10
        _AM_HBC_SR_TOL = ROUND(li.1.V20_1 * 10) / 10
        _AM_HBSch_Pr   = ROUND(li.1.V21_1 * 10) / 10
        _AM_HBSch_Sc   = ROUND(li.1.V22_1 * 10) / 10
        _AM_IX         = ROUND(li.1.V23_1 * 10) / 10
        _AM_XI         = ROUND(li.1.V24_1 * 10) / 10
        _AM_XX         = ROUND(li.1.V25_1 * 10) / 10
        _AM_SLT        = ROUND(li.1.V26_1 * 10) / 10
        _AM_SMD        = ROUND(li.1.V27_1 * 10) / 10
        _AM_SHV        = ROUND(li.1.V28_1 * 10) / 10
        _AM_LMD        = ROUND(li.1.V29_1 * 10) / 10
        _AM_LHV        = ROUND(li.1.V30_1 * 10) / 10
        
        _MD_HBW_DA_NON = ROUND(li.2.V1_1  * 10) / 10
        _MD_HBW_SR_NON = ROUND(li.2.V2_1  * 10) / 10
        _MD_HBW_SR_HOV = ROUND(li.2.V3_1  * 10) / 10
        _MD_HBW_DA_TOL = ROUND(li.2.V4_1  * 10) / 10
        _MD_HBW_SR_TOL = ROUND(li.2.V5_1  * 10) / 10
        _MD_HBO_DA_NON = ROUND(li.2.V6_1  * 10) / 10
        _MD_HBO_SR_NON = ROUND(li.2.V7_1  * 10) / 10
        _MD_HBO_SR_HOV = ROUND(li.2.V8_1  * 10) / 10
        _MD_HBO_DA_TOL = ROUND(li.2.V9_1  * 10) / 10
        _MD_HBO_SR_TOL = ROUND(li.2.V10_1 * 10) / 10
        _MD_NHB_DA_NON = ROUND(li.2.V11_1 * 10) / 10
        _MD_NHB_SR_NON = ROUND(li.2.V12_1 * 10) / 10
        _MD_NHB_SR_HOV = ROUND(li.2.V13_1 * 10) / 10
        _MD_NHB_DA_TOL = ROUND(li.2.V14_1 * 10) / 10
        _MD_NHB_SR_TOL = ROUND(li.2.V15_1 * 10) / 10
        _MD_HBC_DA_NON = ROUND(li.2.V16_1 * 10) / 10
        _MD_HBC_SR_NON = ROUND(li.2.V17_1 * 10) / 10
        _MD_HBC_SR_HOV = ROUND(li.2.V18_1 * 10) / 10
        _MD_HBC_DA_TOL = ROUND(li.2.V19_1 * 10) / 10
        _MD_HBC_SR_TOL = ROUND(li.2.V20_1 * 10) / 10
        _MD_HBSch_Pr   = ROUND(li.2.V21_1 * 10) / 10
        _MD_HBSch_Sc   = ROUND(li.2.V22_1 * 10) / 10
        _MD_IX         = ROUND(li.2.V23_1 * 10) / 10
        _MD_XI         = ROUND(li.2.V24_1 * 10) / 10
        _MD_XX         = ROUND(li.2.V25_1 * 10) / 10
        _MD_SLT        = ROUND(li.2.V26_1 * 10) / 10
        _MD_SMD        = ROUND(li.2.V27_1 * 10) / 10
        _MD_SHV        = ROUND(li.2.V28_1 * 10) / 10
        _MD_LMD        = ROUND(li.2.V29_1 * 10) / 10
        _MD_LHV        = ROUND(li.2.V30_1 * 10) / 10
        
        _PM_HBW_DA_NON = ROUND(li.3.V1_1  * 10) / 10
        _PM_HBW_SR_NON = ROUND(li.3.V2_1  * 10) / 10
        _PM_HBW_SR_HOV = ROUND(li.3.V3_1  * 10) / 10
        _PM_HBW_DA_TOL = ROUND(li.3.V4_1  * 10) / 10
        _PM_HBW_SR_TOL = ROUND(li.3.V5_1  * 10) / 10
        _PM_HBO_DA_NON = ROUND(li.3.V6_1  * 10) / 10
        _PM_HBO_SR_NON = ROUND(li.3.V7_1  * 10) / 10
        _PM_HBO_SR_HOV = ROUND(li.3.V8_1  * 10) / 10
        _PM_HBO_DA_TOL = ROUND(li.3.V9_1  * 10) / 10
        _PM_HBO_SR_TOL = ROUND(li.3.V10_1 * 10) / 10
        _PM_NHB_DA_NON = ROUND(li.3.V11_1 * 10) / 10
        _PM_NHB_SR_NON = ROUND(li.3.V12_1 * 10) / 10
        _PM_NHB_SR_HOV = ROUND(li.3.V13_1 * 10) / 10
        _PM_NHB_DA_TOL = ROUND(li.3.V14_1 * 10) / 10
        _PM_NHB_SR_TOL = ROUND(li.3.V15_1 * 10) / 10
        _PM_HBC_DA_NON = ROUND(li.3.V16_1 * 10) / 10
        _PM_HBC_SR_NON = ROUND(li.3.V17_1 * 10) / 10
        _PM_HBC_SR_HOV = ROUND(li.3.V18_1 * 10) / 10
        _PM_HBC_DA_TOL = ROUND(li.3.V19_1 * 10) / 10
        _PM_HBC_SR_TOL = ROUND(li.3.V20_1 * 10) / 10
        _PM_HBSch_Pr   = ROUND(li.3.V21_1 * 10) / 10
        _PM_HBSch_Sc   = ROUND(li.3.V22_1 * 10) / 10
        _PM_IX         = ROUND(li.3.V23_1 * 10) / 10
        _PM_XI         = ROUND(li.3.V24_1 * 10) / 10
        _PM_XX         = ROUND(li.3.V25_1 * 10) / 10
        _PM_SLT        = ROUND(li.3.V26_1 * 10) / 10
        _PM_SMD        = ROUND(li.3.V27_1 * 10) / 10
        _PM_SHV        = ROUND(li.3.V28_1 * 10) / 10
        _PM_LMD        = ROUND(li.3.V29_1 * 10) / 10
        _PM_LHV        = ROUND(li.3.V30_1 * 10) / 10
        
        _EV_HBW_DA_NON = ROUND(li.4.V1_1  * 10) / 10
        _EV_HBW_SR_NON = ROUND(li.4.V2_1  * 10) / 10
        _EV_HBW_SR_HOV = ROUND(li.4.V3_1  * 10) / 10
        _EV_HBW_DA_TOL = ROUND(li.4.V4_1  * 10) / 10
        _EV_HBW_SR_TOL = ROUND(li.4.V5_1  * 10) / 10
        _EV_HBO_DA_NON = ROUND(li.4.V6_1  * 10) / 10
        _EV_HBO_SR_NON = ROUND(li.4.V7_1  * 10) / 10
        _EV_HBO_SR_HOV = ROUND(li.4.V8_1  * 10) / 10
        _EV_HBO_DA_TOL = ROUND(li.4.V9_1  * 10) / 10
        _EV_HBO_SR_TOL = ROUND(li.4.V10_1 * 10) / 10
        _EV_NHB_DA_NON = ROUND(li.4.V11_1 * 10) / 10
        _EV_NHB_SR_NON = ROUND(li.4.V12_1 * 10) / 10
        _EV_NHB_SR_HOV = ROUND(li.4.V13_1 * 10) / 10
        _EV_NHB_DA_TOL = ROUND(li.4.V14_1 * 10) / 10
        _EV_NHB_SR_TOL = ROUND(li.4.V15_1 * 10) / 10
        _EV_HBC_DA_NON = ROUND(li.4.V16_1 * 10) / 10
        _EV_HBC_SR_NON = ROUND(li.4.V17_1 * 10) / 10
        _EV_HBC_SR_HOV = ROUND(li.4.V18_1 * 10) / 10
        _EV_HBC_DA_TOL = ROUND(li.4.V19_1 * 10) / 10
        _EV_HBC_SR_TOL = ROUND(li.4.V20_1 * 10) / 10
        _EV_HBSch_Pr   = ROUND(li.4.V21_1 * 10) / 10
        _EV_HBSch_Sc   = ROUND(li.4.V22_1 * 10) / 10
        _EV_IX         = ROUND(li.4.V23_1 * 10) / 10
        _EV_XI         = ROUND(li.4.V24_1 * 10) / 10
        _EV_XX         = ROUND(li.4.V25_1 * 10) / 10
        _EV_SLT        = ROUND(li.4.V26_1 * 10) / 10
        _EV_SMD        = ROUND(li.4.V27_1 * 10) / 10
        _EV_SHV        = ROUND(li.4.V28_1 * 10) / 10
        _EV_LMD        = ROUND(li.4.V29_1 * 10) / 10
        _EV_LHV        = ROUND(li.4.V30_1 * 10) / 10
        
        @PM1Y@ _P1_HBW_DA_NON = ROUND(li.5.V1_1  * 10) / 10
        @PM1Y@ _P1_HBW_SR_NON = ROUND(li.5.V2_1  * 10) / 10
        @PM1Y@ _P1_HBW_SR_HOV = ROUND(li.5.V3_1  * 10) / 10
        @PM1Y@ _P1_HBW_DA_TOL = ROUND(li.5.V4_1  * 10) / 10
        @PM1Y@ _P1_HBW_SR_TOL = ROUND(li.5.V5_1  * 10) / 10
        @PM1Y@ _P1_HBO_DA_NON = ROUND(li.5.V6_1  * 10) / 10
        @PM1Y@ _P1_HBO_SR_NON = ROUND(li.5.V7_1  * 10) / 10
        @PM1Y@ _P1_HBO_SR_HOV = ROUND(li.5.V8_1  * 10) / 10
        @PM1Y@ _P1_HBO_DA_TOL = ROUND(li.5.V9_1  * 10) / 10
        @PM1Y@ _P1_HBO_SR_TOL = ROUND(li.5.V10_1 * 10) / 10
        @PM1Y@ _P1_NHB_DA_NON = ROUND(li.5.V11_1 * 10) / 10
        @PM1Y@ _P1_NHB_SR_NON = ROUND(li.5.V12_1 * 10) / 10
        @PM1Y@ _P1_NHB_SR_HOV = ROUND(li.5.V13_1 * 10) / 10
        @PM1Y@ _P1_NHB_DA_TOL = ROUND(li.5.V14_1 * 10) / 10
        @PM1Y@ _P1_NHB_SR_TOL = ROUND(li.5.V15_1 * 10) / 10
        @PM1Y@ _P1_HBC_DA_NON = ROUND(li.5.V16_1 * 10) / 10
        @PM1Y@ _P1_HBC_SR_NON = ROUND(li.5.V17_1 * 10) / 10
        @PM1Y@ _P1_HBC_SR_HOV = ROUND(li.5.V18_1 * 10) / 10
        @PM1Y@ _P1_HBC_DA_TOL = ROUND(li.5.V19_1 * 10) / 10
        @PM1Y@ _P1_HBC_SR_TOL = ROUND(li.5.V20_1 * 10) / 10
        @PM1Y@ _P1_HBSch_Pr   = ROUND(li.5.V21_1 * 10) / 10
        @PM1Y@ _P1_HBSch_Sc   = ROUND(li.5.V22_1 * 10) / 10
        @PM1Y@ _P1_IX         = ROUND(li.5.V23_1 * 10) / 10
        @PM1Y@ _P1_XI         = ROUND(li.5.V24_1 * 10) / 10
        @PM1Y@ _P1_XX         = ROUND(li.5.V25_1 * 10) / 10
        @PM1Y@ _P1_SLT        = ROUND(li.5.V26_1 * 10) / 10
        @PM1Y@ _P1_SMD        = ROUND(li.5.V27_1 * 10) / 10
        @PM1Y@ _P1_SHV        = ROUND(li.5.V28_1 * 10) / 10
        @PM1Y@ _P1_LMD        = ROUND(li.5.V29_1 * 10) / 10
        @PM1Y@ _P1_LHV        = ROUND(li.5.V30_1 * 10) / 10
        
        
        ;2 way volume
        _AM_2w_HBW_DA_N = ROUND(li.1.V1T_1  * 10) / 10
        _AM_2w_HBW_SR_N = ROUND(li.1.V2T_1  * 10) / 10
        _AM_2w_HBW_SR_H = ROUND(li.1.V3T_1  * 10) / 10
        _AM_2w_HBW_DA_T = ROUND(li.1.V4T_1  * 10) / 10
        _AM_2w_HBW_SR_T = ROUND(li.1.V5T_1  * 10) / 10
        _AM_2w_HBO_DA_N = ROUND(li.1.V6T_1  * 10) / 10
        _AM_2w_HBO_SR_N = ROUND(li.1.V7T_1  * 10) / 10
        _AM_2w_HBO_SR_H = ROUND(li.1.V8T_1  * 10) / 10
        _AM_2w_HBO_DA_T = ROUND(li.1.V9T_1  * 10) / 10
        _AM_2w_HBO_SR_T = ROUND(li.1.V10T_1 * 10) / 10
        _AM_2w_NHB_DA_N = ROUND(li.1.V11T_1 * 10) / 10
        _AM_2w_NHB_SR_N = ROUND(li.1.V12T_1 * 10) / 10
        _AM_2w_NHB_SR_H = ROUND(li.1.V13T_1 * 10) / 10
        _AM_2w_NHB_DA_T = ROUND(li.1.V14T_1 * 10) / 10
        _AM_2w_NHB_SR_T = ROUND(li.1.V15T_1 * 10) / 10
        _AM_2w_HBC_DA_N = ROUND(li.1.V16T_1 * 10) / 10
        _AM_2w_HBC_SR_N = ROUND(li.1.V17T_1 * 10) / 10
        _AM_2w_HBC_SR_H = ROUND(li.1.V18T_1 * 10) / 10
        _AM_2w_HBC_DA_T = ROUND(li.1.V19T_1 * 10) / 10
        _AM_2w_HBC_SR_T = ROUND(li.1.V20T_1 * 10) / 10
        _AM_2w_HBSch_Pr = ROUND(li.1.V21T_1 * 10) / 10
        _AM_2w_HBSch_Sc = ROUND(li.1.V22T_1 * 10) / 10
        _AM_2w_IX       = ROUND(li.1.V23T_1 * 10) / 10
        _AM_2w_XI       = ROUND(li.1.V24T_1 * 10) / 10
        _AM_2w_XX       = ROUND(li.1.V25T_1 * 10) / 10
        _AM_2w_SLT      = ROUND(li.1.V26T_1 * 10) / 10
        _AM_2w_SMD      = ROUND(li.1.V27T_1 * 10) / 10
        _AM_2w_SHV      = ROUND(li.1.V28T_1 * 10) / 10
        _AM_2w_LMD      = ROUND(li.1.V29T_1 * 10) / 10
        _AM_2w_LHV      = ROUND(li.1.V30T_1 * 10) / 10
        
        _MD_2w_HBW_DA_N = ROUND(li.2.V1T_1  * 10) / 10
        _MD_2w_HBW_SR_N = ROUND(li.2.V2T_1  * 10) / 10
        _MD_2w_HBW_SR_H = ROUND(li.2.V3T_1  * 10) / 10
        _MD_2w_HBW_DA_T = ROUND(li.2.V4T_1  * 10) / 10
        _MD_2w_HBW_SR_T = ROUND(li.2.V5T_1  * 10) / 10
        _MD_2w_HBO_DA_N = ROUND(li.2.V6T_1  * 10) / 10
        _MD_2w_HBO_SR_N = ROUND(li.2.V7T_1  * 10) / 10
        _MD_2w_HBO_SR_H = ROUND(li.2.V8T_1  * 10) / 10
        _MD_2w_HBO_DA_T = ROUND(li.2.V9T_1  * 10) / 10
        _MD_2w_HBO_SR_T = ROUND(li.2.V10T_1 * 10) / 10
        _MD_2w_NHB_DA_N = ROUND(li.2.V11T_1 * 10) / 10
        _MD_2w_NHB_SR_N = ROUND(li.2.V12T_1 * 10) / 10
        _MD_2w_NHB_SR_H = ROUND(li.2.V13T_1 * 10) / 10
        _MD_2w_NHB_DA_T = ROUND(li.2.V14T_1 * 10) / 10
        _MD_2w_NHB_SR_T = ROUND(li.2.V15T_1 * 10) / 10
        _MD_2w_HBC_DA_N = ROUND(li.2.V16T_1 * 10) / 10
        _MD_2w_HBC_SR_N = ROUND(li.2.V17T_1 * 10) / 10
        _MD_2w_HBC_SR_H = ROUND(li.2.V18T_1 * 10) / 10
        _MD_2w_HBC_DA_T = ROUND(li.2.V19T_1 * 10) / 10
        _MD_2w_HBC_SR_T = ROUND(li.2.V20T_1 * 10) / 10
        _MD_2w_HBSch_Pr = ROUND(li.2.V21T_1 * 10) / 10
        _MD_2w_HBSch_Sc = ROUND(li.2.V22T_1 * 10) / 10
        _MD_2w_IX       = ROUND(li.2.V23T_1 * 10) / 10
        _MD_2w_XI       = ROUND(li.2.V24T_1 * 10) / 10
        _MD_2w_XX       = ROUND(li.2.V25T_1 * 10) / 10
        _MD_2w_SLT      = ROUND(li.2.V26T_1 * 10) / 10
        _MD_2w_SMD      = ROUND(li.2.V27T_1 * 10) / 10
        _MD_2w_SHV      = ROUND(li.2.V28T_1 * 10) / 10
        _MD_2w_LMD      = ROUND(li.2.V29T_1 * 10) / 10
        _MD_2w_LHV      = ROUND(li.2.V30T_1 * 10) / 10
        
        _PM_2w_HBW_DA_N = ROUND(li.3.V1T_1  * 10) / 10
        _PM_2w_HBW_SR_N = ROUND(li.3.V2T_1  * 10) / 10
        _PM_2w_HBW_SR_H = ROUND(li.3.V3T_1  * 10) / 10
        _PM_2w_HBW_DA_T = ROUND(li.3.V4T_1  * 10) / 10
        _PM_2w_HBW_SR_T = ROUND(li.3.V5T_1  * 10) / 10
        _PM_2w_HBO_DA_N = ROUND(li.3.V6T_1  * 10) / 10
        _PM_2w_HBO_SR_N = ROUND(li.3.V7T_1  * 10) / 10
        _PM_2w_HBO_SR_H = ROUND(li.3.V8T_1  * 10) / 10
        _PM_2w_HBO_DA_T = ROUND(li.3.V9T_1  * 10) / 10
        _PM_2w_HBO_SR_T = ROUND(li.3.V10T_1 * 10) / 10
        _PM_2w_NHB_DA_N = ROUND(li.3.V11T_1 * 10) / 10
        _PM_2w_NHB_SR_N = ROUND(li.3.V12T_1 * 10) / 10
        _PM_2w_NHB_SR_H = ROUND(li.3.V13T_1 * 10) / 10
        _PM_2w_NHB_DA_T = ROUND(li.3.V14T_1 * 10) / 10
        _PM_2w_NHB_SR_T = ROUND(li.3.V15T_1 * 10) / 10
        _PM_2w_HBC_DA_N = ROUND(li.3.V16T_1 * 10) / 10
        _PM_2w_HBC_SR_N = ROUND(li.3.V17T_1 * 10) / 10
        _PM_2w_HBC_SR_H = ROUND(li.3.V18T_1 * 10) / 10
        _PM_2w_HBC_DA_T = ROUND(li.3.V19T_1 * 10) / 10
        _PM_2w_HBC_SR_T = ROUND(li.3.V20T_1 * 10) / 10
        _PM_2w_HBSch_Pr = ROUND(li.3.V21T_1 * 10) / 10
        _PM_2w_HBSch_Sc = ROUND(li.3.V22T_1 * 10) / 10
        _PM_2w_IX       = ROUND(li.3.V23T_1 * 10) / 10
        _PM_2w_XI       = ROUND(li.3.V24T_1 * 10) / 10
        _PM_2w_XX       = ROUND(li.3.V25T_1 * 10) / 10
        _PM_2w_SLT      = ROUND(li.3.V26T_1 * 10) / 10
        _PM_2w_SMD      = ROUND(li.3.V27T_1 * 10) / 10
        _PM_2w_SHV      = ROUND(li.3.V28T_1 * 10) / 10
        _PM_2w_LMD      = ROUND(li.3.V29T_1 * 10) / 10
        _PM_2w_LHV      = ROUND(li.3.V30T_1 * 10) / 10
        
        _EV_2w_HBW_DA_N = ROUND(li.4.V1T_1  * 10) / 10
        _EV_2w_HBW_SR_N = ROUND(li.4.V2T_1  * 10) / 10
        _EV_2w_HBW_SR_H = ROUND(li.4.V3T_1  * 10) / 10
        _EV_2w_HBW_DA_T = ROUND(li.4.V4T_1  * 10) / 10
        _EV_2w_HBW_SR_T = ROUND(li.4.V5T_1  * 10) / 10
        _EV_2w_HBO_DA_N = ROUND(li.4.V6T_1  * 10) / 10
        _EV_2w_HBO_SR_N = ROUND(li.4.V7T_1  * 10) / 10
        _EV_2w_HBO_SR_H = ROUND(li.4.V8T_1  * 10) / 10
        _EV_2w_HBO_DA_T = ROUND(li.4.V9T_1  * 10) / 10
        _EV_2w_HBO_SR_T = ROUND(li.4.V10T_1 * 10) / 10
        _EV_2w_NHB_DA_N = ROUND(li.4.V11T_1 * 10) / 10
        _EV_2w_NHB_SR_N = ROUND(li.4.V12T_1 * 10) / 10
        _EV_2w_NHB_SR_H = ROUND(li.4.V13T_1 * 10) / 10
        _EV_2w_NHB_DA_T = ROUND(li.4.V14T_1 * 10) / 10
        _EV_2w_NHB_SR_T = ROUND(li.4.V15T_1 * 10) / 10
        _EV_2w_HBC_DA_N = ROUND(li.4.V16T_1 * 10) / 10
        _EV_2w_HBC_SR_N = ROUND(li.4.V17T_1 * 10) / 10
        _EV_2w_HBC_SR_H = ROUND(li.4.V18T_1 * 10) / 10
        _EV_2w_HBC_DA_T = ROUND(li.4.V19T_1 * 10) / 10
        _EV_2w_HBC_SR_T = ROUND(li.4.V20T_1 * 10) / 10
        _EV_2w_HBSch_Pr = ROUND(li.4.V21T_1 * 10) / 10
        _EV_2w_HBSch_Sc = ROUND(li.4.V22T_1 * 10) / 10
        _EV_2w_IX       = ROUND(li.4.V23T_1 * 10) / 10
        _EV_2w_XI       = ROUND(li.4.V24T_1 * 10) / 10
        _EV_2w_XX       = ROUND(li.4.V25T_1 * 10) / 10
        _EV_2w_SLT      = ROUND(li.4.V26T_1 * 10) / 10
        _EV_2w_SMD      = ROUND(li.4.V27T_1 * 10) / 10
        _EV_2w_SHV      = ROUND(li.4.V28T_1 * 10) / 10
        _EV_2w_LMD      = ROUND(li.4.V29T_1 * 10) / 10
        _EV_2w_LHV      = ROUND(li.4.V30T_1 * 10) / 10
        
        
        ;summarize truck volume
        _DY_SLT   = _AM_SLT   + _MD_SLT   + _PM_SLT   + _EV_SLT
        _DY_SMD   = _AM_SMD   + _MD_SMD   + _PM_SMD   + _EV_SMD
        _DY_SHV   = _AM_SHV   + _MD_SHV   + _PM_SHV   + _EV_SHV
        _DY_LMD   = _AM_LMD   + _MD_LMD   + _PM_LMD   + _EV_LMD
        _DY_LHV   = _AM_LHV   + _MD_LHV   + _PM_LHV   + _EV_LHV
        
        _AM_Trk_MD = _AM_SMD + _AM_LMD
        _MD_Trk_MD = _MD_SMD + _MD_LMD
        _PM_Trk_MD = _PM_SMD + _PM_LMD
        _EV_Trk_MD = _EV_SMD + _EV_LMD
        _DY_Trk_MD = _DY_SMD + _DY_LMD
        
        _AM_Trk_HV = _AM_SHV + _AM_LHV
        _MD_Trk_HV = _MD_SHV + _MD_LHV
        _PM_Trk_HV = _PM_SHV + _PM_LHV
        _EV_Trk_HV = _EV_SHV + _EV_LHV
        _DY_Trk_HV = _DY_SHV + _DY_LHV
        
        
        
        ;summarize volumes -----------------------------------------------------------
        ;by period
        AM_VOL = _AM_HBW_DA_NON +
                 _AM_HBW_SR_NON +
                 _AM_HBW_SR_HOV +
                 _AM_HBW_DA_TOL +
                 _AM_HBW_SR_TOL +
                 _AM_HBO_DA_NON +
                 _AM_HBO_SR_NON +
                 _AM_HBO_SR_HOV +
                 _AM_HBO_DA_TOL +
                 _AM_HBO_SR_TOL +
                 _AM_NHB_DA_NON +
                 _AM_NHB_SR_NON +
                 _AM_NHB_SR_HOV +
                 _AM_NHB_DA_TOL +
                 _AM_NHB_SR_TOL +
                 _AM_HBC_DA_NON +
                 _AM_HBC_SR_NON +
                 _AM_HBC_SR_HOV +
                 _AM_HBC_DA_TOL +
                 _AM_HBC_SR_TOL +
                 _AM_HBSch_Pr   +
                 _AM_HBSch_Sc   +
                 _AM_IX         +
                 _AM_XI         +
                 _AM_XX         +
                 _AM_SLT        +
                 _AM_SMD        +
                 _AM_SHV        +
                 _AM_LMD        +
                 _AM_LHV        

        
        MD_VOL = _MD_HBW_DA_NON +
                 _MD_HBW_SR_NON +
                 _MD_HBW_SR_HOV +
                 _MD_HBW_DA_TOL +
                 _MD_HBW_SR_TOL +
                 _MD_HBO_DA_NON +
                 _MD_HBO_SR_NON +
                 _MD_HBO_SR_HOV +
                 _MD_HBO_DA_TOL +
                 _MD_HBO_SR_TOL +
                 _MD_NHB_DA_NON +
                 _MD_NHB_SR_NON +
                 _MD_NHB_SR_HOV +
                 _MD_NHB_DA_TOL +
                 _MD_NHB_SR_TOL +
                 _MD_HBC_DA_NON +
                 _MD_HBC_SR_NON +
                 _MD_HBC_SR_HOV +
                 _MD_HBC_DA_TOL +
                 _MD_HBC_SR_TOL +
                 _MD_HBSch_Pr   +
                 _MD_HBSch_Sc   +
                 _MD_IX         +
                 _MD_XI         +
                 _MD_XX         +
                 _MD_SLT        +
                 _MD_SMD        +
                 _MD_SHV        +
                 _MD_LMD        +
                 _MD_LHV        
        
        PM_VOL = _PM_HBW_DA_NON +
                 _PM_HBW_SR_NON +
                 _PM_HBW_SR_HOV +
                 _PM_HBW_DA_TOL +
                 _PM_HBW_SR_TOL +
                 _PM_HBO_DA_NON +
                 _PM_HBO_SR_NON +
                 _PM_HBO_SR_HOV +
                 _PM_HBO_DA_TOL +
                 _PM_HBO_SR_TOL +
                 _PM_NHB_DA_NON +
                 _PM_NHB_SR_NON +
                 _PM_NHB_SR_HOV +
                 _PM_NHB_DA_TOL +
                 _PM_NHB_SR_TOL +
                 _PM_HBC_DA_NON +
                 _PM_HBC_SR_NON +
                 _PM_HBC_SR_HOV +
                 _PM_HBC_DA_TOL +
                 _PM_HBC_SR_TOL +
                 _PM_HBSch_Pr   +
                 _PM_HBSch_Sc   +
                 _PM_IX         +
                 _PM_XI         +
                 _PM_XX         +
                 _PM_SLT        +
                 _PM_SMD        +
                 _PM_SHV        +
                 _PM_LMD        +
                 _PM_LHV        
        
        EV_VOL = _EV_HBW_DA_NON +
                 _EV_HBW_SR_NON +
                 _EV_HBW_SR_HOV +
                 _EV_HBW_DA_TOL +
                 _EV_HBW_SR_TOL +
                 _EV_HBO_DA_NON +
                 _EV_HBO_SR_NON +
                 _EV_HBO_SR_HOV +
                 _EV_HBO_DA_TOL +
                 _EV_HBO_SR_TOL +
                 _EV_NHB_DA_NON +
                 _EV_NHB_SR_NON +
                 _EV_NHB_SR_HOV +
                 _EV_NHB_DA_TOL +
                 _EV_NHB_SR_TOL +
                 _EV_HBC_DA_NON +
                 _EV_HBC_SR_NON +
                 _EV_HBC_SR_HOV +
                 _EV_HBC_DA_TOL +
                 _EV_HBC_SR_TOL +
                 _EV_HBSch_Pr   +
                 _EV_HBSch_Sc   +
                 _EV_IX         +
                 _EV_XI         +
                 _EV_XX         +
                 _EV_SLT        +
                 _EV_SMD        +
                 _EV_SHV        +
                 _EV_LMD        +
                 _EV_LHV        
        
        
        DY_VOL = AM_VOL +
                 MD_VOL +
                 PM_VOL +
                 EV_VOL 
        
        DY_VOL2Wy = _AM_2w_HBW_DA_N + _MD_2w_HBW_DA_N + _PM_2w_HBW_DA_N + _EV_2w_HBW_DA_N +
                    _AM_2w_HBW_SR_N + _MD_2w_HBW_SR_N + _PM_2w_HBW_SR_N + _EV_2w_HBW_SR_N +
                    _AM_2w_HBW_SR_H + _MD_2w_HBW_SR_H + _PM_2w_HBW_SR_H + _EV_2w_HBW_SR_H +
                    _AM_2w_HBW_DA_T + _MD_2w_HBW_DA_T + _PM_2w_HBW_DA_T + _EV_2w_HBW_DA_T +
                    _AM_2w_HBW_SR_T + _MD_2w_HBW_SR_T + _PM_2w_HBW_SR_T + _EV_2w_HBW_SR_T +
                    _AM_2w_HBO_DA_N + _MD_2w_HBO_DA_N + _PM_2w_HBO_DA_N + _EV_2w_HBO_DA_N +
                    _AM_2w_HBO_SR_N + _MD_2w_HBO_SR_N + _PM_2w_HBO_SR_N + _EV_2w_HBO_SR_N +
                    _AM_2w_HBO_SR_H + _MD_2w_HBO_SR_H + _PM_2w_HBO_SR_H + _EV_2w_HBO_SR_H +
                    _AM_2w_HBO_DA_T + _MD_2w_HBO_DA_T + _PM_2w_HBO_DA_T + _EV_2w_HBO_DA_T +
                    _AM_2w_HBO_SR_T + _MD_2w_HBO_SR_T + _PM_2w_HBO_SR_T + _EV_2w_HBO_SR_T +
                    _AM_2w_NHB_DA_N + _MD_2w_NHB_DA_N + _PM_2w_NHB_DA_N + _EV_2w_NHB_DA_N +
                    _AM_2w_NHB_SR_N + _MD_2w_NHB_SR_N + _PM_2w_NHB_SR_N + _EV_2w_NHB_SR_N +
                    _AM_2w_NHB_SR_H + _MD_2w_NHB_SR_H + _PM_2w_NHB_SR_H + _EV_2w_NHB_SR_H +
                    _AM_2w_NHB_DA_T + _MD_2w_NHB_DA_T + _PM_2w_NHB_DA_T + _EV_2w_NHB_DA_T +
                    _AM_2w_NHB_SR_T + _MD_2w_NHB_SR_T + _PM_2w_NHB_SR_T + _EV_2w_NHB_SR_T +
                    _AM_2w_HBC_DA_N + _MD_2w_HBC_DA_N + _PM_2w_HBC_DA_N + _EV_2w_HBC_DA_N +
                    _AM_2w_HBC_SR_N + _MD_2w_HBC_SR_N + _PM_2w_HBC_SR_N + _EV_2w_HBC_SR_N +
                    _AM_2w_HBC_SR_H + _MD_2w_HBC_SR_H + _PM_2w_HBC_SR_H + _EV_2w_HBC_SR_H +
                    _AM_2w_HBC_DA_T + _MD_2w_HBC_DA_T + _PM_2w_HBC_DA_T + _EV_2w_HBC_DA_T +
                    _AM_2w_HBC_SR_T + _MD_2w_HBC_SR_T + _PM_2w_HBC_SR_T + _EV_2w_HBC_SR_T +
                    _AM_2w_HBSch_Pr + _MD_2w_HBSch_Pr + _PM_2w_HBSch_Pr + _EV_2w_HBSch_Pr +
                    _AM_2w_HBSch_Sc + _MD_2w_HBSch_Sc + _PM_2w_HBSch_Sc + _EV_2w_HBSch_Sc +
                    _AM_2w_IX       + _MD_2w_IX       + _PM_2w_IX       + _EV_2w_IX       +
                    _AM_2w_XI       + _MD_2w_XI       + _PM_2w_XI       + _EV_2w_XI       +
                    _AM_2w_XX       + _MD_2w_XX       + _PM_2w_XX       + _EV_2w_XX       +
                    _AM_2w_SLT      + _MD_2w_SLT      + _PM_2w_SLT      + _EV_2w_SLT      +
                    _AM_2w_SMD      + _MD_2w_SMD      + _PM_2w_SMD      + _EV_2w_SMD      +
                    _AM_2w_SHV      + _MD_2w_SHV      + _PM_2w_SHV      + _EV_2w_SHV      +
                    _AM_2w_LMD      + _MD_2w_LMD      + _PM_2w_LMD      + _EV_2w_LMD      +
                    _AM_2w_LHV      + _MD_2w_LHV      + _PM_2w_LHV      + _EV_2w_LHV      
        
        DY_1k     = ROUND(DY_VOL / 1000)
        
        DY_1k_2wy = ROUND(DY_VOL2Wy / 1000)
        
        
        @PM1Y@ PM1_VOL = _P1_HBW_DA_NON +
        @PM1Y@           _P1_HBW_SR_NON +
        @PM1Y@           _P1_HBW_SR_HOV +
        @PM1Y@           _P1_HBW_DA_TOL +
        @PM1Y@           _P1_HBW_SR_TOL +
        @PM1Y@           _P1_HBO_DA_NON +
        @PM1Y@           _P1_HBO_SR_NON +
        @PM1Y@           _P1_HBO_SR_HOV +
        @PM1Y@           _P1_HBO_DA_TOL +
        @PM1Y@           _P1_HBO_SR_TOL +
        @PM1Y@           _P1_NHB_DA_NON +
        @PM1Y@           _P1_NHB_SR_NON +
        @PM1Y@           _P1_NHB_SR_HOV +
        @PM1Y@           _P1_NHB_DA_TOL +
        @PM1Y@           _P1_NHB_SR_TOL +
        @PM1Y@           _P1_HBC_DA_NON +
        @PM1Y@           _P1_HBC_SR_NON +
        @PM1Y@           _P1_HBC_SR_HOV +
        @PM1Y@           _P1_HBC_DA_TOL +
        @PM1Y@           _P1_HBC_SR_TOL +
        @PM1Y@           _P1_HBSch_Pr   +
        @PM1Y@           _P1_HBSch_Sc   +
        @PM1Y@           _P1_IX         +
        @PM1Y@           _P1_XI         +
        @PM1Y@           _P1_XX         +
        @PM1Y@           _P1_SLT        +
        @PM1Y@           _P1_SMD        +
        @PM1Y@           _P1_SHV        +
        @PM1Y@           _P1_LMD        +
        @PM1Y@           _P1_LHV        
        
        
        
        ;summarize other link fields -----------------------------------------------------
        ;v/c
        AM_VC = ROUND(li.1.VC_1 * 1000) / 1000
        MD_VC = ROUND(li.2.VC_1 * 1000) / 1000
        PM_VC = ROUND(li.3.VC_1 * 1000) / 1000
        EV_VC = ROUND(li.4.VC_1 * 1000) / 1000
        
        @PM1Y@ ROUND(PM1_VC = li.5.VC_1 * 1000) / 1000
        
        
        ;update ramp penalty
        AM_RampPen = ROUND(li.1.LW_RPEN_1 * 100) / 100
        MD_RampPen = ROUND(li.2.LW_RPEN_1 * 100) / 100
        PM_RampPen = ROUND(li.3.LW_RPEN_1 * 100) / 100
        EV_RampPen = ROUND(li.4.LW_RPEN_1 * 100) / 100
            
        ;calculate average daily ramp penalty
        if (DY_VOL<1)
            
            DY_RampPen  = EV_RampPen
        
        else
            
            DY_RampPen = ROUND( (AM_RampPen * AM_VOL +
                                 MD_RampPen * MD_VOL +
                                 PM_RampPen * PM_VOL +
                                 EV_RampPen * EV_VOL  ) / DY_VOL * 100) / 100
            
        endif  ;DY_VOL<1
        
        @PM1Y@ PM1_RampPen = ROUND(li.5.LW_RPEN_1 * 100) / 100
        
        
        
        ;update congested speed & time
        ;  note: DY_SPD & DY_TIME calculations are done after HOV/HOT lane speed/time update
        ;congested speed
        AM_SPD  = li.1.CSPD_1
        MD_SPD  = li.2.CSPD_1
        PM_SPD  = li.3.CSPD_1
        EV_SPD  = li.4.CSPD_1
        @PM1Y@ PM1_SPD = li.5.CSPD_1
        
        ;congested time
        AM_TIME = li.1.TIME_1
        MD_TIME = li.2.TIME_1
        PM_TIME = li.3.TIME_1
        EV_TIME = li.4.TIME_1
        @PM1Y@ PM1_TIME = li.5.TIME_1
        
        ;update speed & time on HOV & HOT lanes
        ;  note: Assignment uses an approximate LOS C capacity for HOV/HOT lanes as a proxy to set volume limits in managed lanes. The VDF 
        ;        curves then follow regular freeway reduction in speed with increased v/c ratio to make the lane less attractive at higher
        ;        volumes. Once correct volumes are set (HOT tolls are also set using the HOT volumes), HOV/HOT speeds need be updated to 
        ;        reflect the correct capacity or operations of the managed lane: 
        ;        (1) If the HOV/HOT lane is barrier separated from the GP lanes, speed is set based on a full freeway lane capacity and
        ;            the freeway VDF curve.
        ;        (2) If HOV/HOT is not barrier separated from the GP lanes, speed is a function of the GP lane speed and is set based on an
        ;            equations regressed from UDOT observed data of HOT speed to GP lane speed:
        ;                HOT_Speed = 115.48 * GP_Speed / (33.9 + GP_Speed)
        
        ;update speed (HOV & HOT)
        if (li.1.HOT_ZONEID>0 & li.1.FT=37-39)  AM_SPD = 115.48 * HOT_GP_SPD_AM[li.1.HOT_ZONEID] / (33.9 + HOT_GP_SPD_AM[li.1.HOT_ZONEID])
        if (li.2.HOT_ZONEID>0 & li.2.FT=37-39)  MD_SPD = 115.48 * HOT_GP_SPD_MD[li.2.HOT_ZONEID] / (33.9 + HOT_GP_SPD_MD[li.2.HOT_ZONEID])
        if (li.3.HOT_ZONEID>0 & li.3.FT=37-39)  PM_SPD = 115.48 * HOT_GP_SPD_PM[li.3.HOT_ZONEID] / (33.9 + HOT_GP_SPD_PM[li.3.HOT_ZONEID])
        if (li.4.HOT_ZONEID>0 & li.4.FT=37-39)  EV_SPD = 115.48 * HOT_GP_SPD_EV[li.4.HOT_ZONEID] / (33.9 + HOT_GP_SPD_EV[li.4.HOT_ZONEID])
        @PM1Y@ if (li.5.HOT_ZONEID>0 & li.5.FT=37-39)  PM1_SPD = 115.48 * HOT_GP_SPD_PM1[li.5.HOT_ZONEID] / (33.9 + HOT_GP_SPD_PM1[li.5.HOT_ZONEID])
        
        ;update time (HOV & HOT)
        if (li.1.HOT_ZONEID>0 & li.1.FT=37-39)  AM_TIME = li.1.DISTANCE / AM_SPD * 60
        if (li.2.HOT_ZONEID>0 & li.2.FT=37-39)  MD_TIME = li.2.DISTANCE / MD_SPD * 60
        if (li.3.HOT_ZONEID>0 & li.3.FT=37-39)  PM_TIME = li.3.DISTANCE / PM_SPD * 60
        if (li.4.HOT_ZONEID>0 & li.4.FT=37-39)  EV_TIME = li.4.DISTANCE / EV_SPD * 60
        @PM1Y@ if (li.5.HOT_ZONEID>0 & li.5.FT=37-39)  PM1_TIME = li.5.DISTANCE / PM1_SPD * 60
        
        ;ensure times and speeds are slower than free flow
        AM_SPD  = MIN(li.1.FF_SPD,  AM_SPD)
        MD_SPD  = MIN(li.2.FF_SPD,  MD_SPD)
        PM_SPD  = MIN(li.3.FF_SPD,  PM_SPD)
        EV_SPD  = MIN(li.4.FF_SPD,  EV_SPD)
        @PM1Y@ PM1_SPD = MIN(li.5.FF_SPD,  PM1_SPD)
        
        AM_TIME  = MAX(li.1.FF_TIME,  AM_TIME)
        MD_TIME  = MAX(li.2.FF_TIME,  MD_TIME)
        PM_TIME  = MAX(li.3.FF_TIME,  PM_TIME)
        EV_TIME  = MAX(li.4.FF_TIME,  EV_TIME)
        @PM1Y@ PM1_SPD = MAX(li.5.FF_TIME,  PM1_TIME)
        
        ;round period congested speed & time
        AM_SPD  = ROUND(AM_SPD * 10) / 10
        MD_SPD  = ROUND(MD_SPD * 10) / 10
        PM_SPD  = ROUND(PM_SPD * 10) / 10
        EV_SPD  = ROUND(EV_SPD * 10) / 10
        @PM1Y@ PM1_SPD = ROUND(PM1_SPD * 10) / 10
        
        AM_TIME = ROUND(AM_TIME * 10000) / 10000
        MD_TIME = ROUND(MD_TIME * 10000) / 10000
        PM_TIME = ROUND(PM_TIME * 10000) / 10000
        EV_TIME = ROUND(EV_TIME * 10000) / 10000
        @PM1Y@ PM1_TIME = ROUND(PM1_TIME * 10000) / 10000
        
        ;calculate average daily time and speed
        if (DY_VOL<1)
            
            DY_SPD  = li.1.FF_SPD
            DY_TIME = li.1.FF_TIME
        
        else
            
            DY_TIME = (AM_TIME * AM_VOL + 
                       MD_TIME * MD_VOL + 
                       PM_TIME * PM_VOL + 
                       EV_TIME * EV_VOL  ) / DY_VOL
            
            DY_SPD = li.1.DISTANCE / (DY_TIME / 60)
        
        endif  ;DY_VOL<1
        
        ;round daily congested speed & time
        DY_SPD  = ROUND(DY_SPD * 10) / 10
        DY_TIME = ROUND(DY_TIME * 10000) / 10000
        
        
        
        ;calculate VMT
        AM_VMT = ROUND(AM_VOL * li.1.DISTANCE * 100) / 100
        MD_VMT = ROUND(MD_VOL * li.2.DISTANCE * 100) / 100
        PM_VMT = ROUND(PM_VOL * li.3.DISTANCE * 100) / 100
        EV_VMT = ROUND(EV_VOL * li.4.DISTANCE * 100) / 100
        
        DY_VMT = ROUND( (AM_VMT +
                         MD_VMT +
                         PM_VMT +
                         EV_VMT  ) * 100) / 100
        
        @PM1Y@ PM1_VMT = ROUND(PM1_VOL * li.5.DISTANCE * 100) / 100
        
        
        
        ;calculate VHT
        FF_VHT = ROUND(DY_VOL * (FF_TIME / 60) * 100) / 100
        AM_VHT = ROUND(AM_VOL * (AM_TIME / 60) * 100) / 100
        MD_VHT = ROUND(MD_VOL * (MD_TIME / 60) * 100) / 100
        PM_VHT = ROUND(PM_VOL * (PM_TIME / 60) * 100) / 100
        EV_VHT = ROUND(EV_VOL * (EV_TIME / 60) * 100) / 100
        
        DY_VHT = ROUND( (AM_VHT +
                         MD_VHT +
                         PM_VHT +
                         EV_VHT  ) * 100) / 100
        
        @PM1Y@ PM1_VHT = ROUND(PM1_VOL * (PM1_TIME / 60) * 100) / 100
        
        
        
        ;calculate delay (veh-hrs)
        AM_Delay = ROUND( MAX(0, (AM_TIME - FF_TIME) / 60 * AM_VOL) * 1000) / 1000
        MD_Delay = ROUND( MAX(0, (MD_TIME - FF_TIME) / 60 * MD_VOL) * 1000) / 1000
        PM_Delay = ROUND( MAX(0, (PM_TIME - FF_TIME) / 60 * PM_VOL) * 1000) / 1000
        EV_Delay = ROUND( MAX(0, (EV_TIME - FF_TIME) / 60 * EV_VOL) * 1000) / 1000
        
        DY_Delay = ROUND( (AM_Delay + 
                           MD_Delay + 
                           PM_Delay + 
                           EV_Delay  ) * 1000) / 1000
        
        @PM1Y@ PM1_Delay = ROUND( MAX(0, (PM1_TIME - FF_TIME) / 60 * PM1_VOL) * 1000) / 1000
        
        
        
        ;calculate buffer time
        ;  (freeway general purpose, Managed Motorways and toll lanes only)
        if (li.1.FT=22-27,32-37,40)
            
            FF_BTI_tme = ROUND(FF_TIME * BTI_pct(1, 0)     * 1000) / 1000
            AM_BTI_tme = ROUND(AM_TIME * BTI_pct(1, AM_VC) * 1000) / 1000
            MD_BTI_tme = ROUND(MD_TIME * BTI_pct(1, MD_VC) * 1000) / 1000
            PM_BTI_tme = ROUND(PM_TIME * BTI_pct(1, PM_VC) * 1000) / 1000
            EV_BTI_tme = ROUND(EV_TIME * BTI_pct(1, EV_VC) * 1000) / 1000
            @PM1Y@ P1_BTI_tme = ROUND(PM1_TIME * BTI_pct(1, PM1_VC) * 1000) / 1000
            
        else
            
            FF_BTI_tme = 0
            AM_BTI_tme = 0
            MD_BTI_tme = 0
            PM_BTI_tme = 0
            EV_BTI_tme = 0
            @PM1Y@ P1_BTI_tme = 0
            
        endif  ;FT=22-27,32-37,40
        
        ;calculate average daily buffer
        if (DY_VOL<1)
            
            DY_BTI_tme  = FF_BTI_tme
        
        else
            
            DY_BTI_tme = ROUND( (AM_BTI_tme * AM_VOL + 
                                 MD_BTI_tme * MD_VOL + 
                                 PM_BTI_tme * PM_VOL + 
                                 EV_BTI_tme * EV_VOL  ) / DY_VOL * 1000) / 1000
            
        endif  ;DY_VOL<1
        
        
        
        ;calculate truck speed and time
        ;  note: slow down trucks by 3mph for MD, 5mph for HV
        ;    Medium Truck
        ;                   Auto   Truck  Speed   Time 
        ;                   Speed  Speed  Factor  Factor
        ;      Freeway       70      67    0.96    1.04
        ;      Expressway    50      47    0.94    1.06
        ;      Arterial      40      37    0.93    1.08
        ;      Collector     30      27    0.90    1.11
        ;    
        ;    Heavy Truck
        ;                   Auto   Truck  Speed   Time 
        ;                   Speed  Speed  Factor  Factor
        ;      Freeway       70      65    0.93    1.08
        ;      Expressway    50      45    0.90    1.11
        ;      Arterial      40      35    0.88    1.14
        ;      Collector     30      25    0.83    1.20
            
        ;set truck speed (minimum truck speed: MD=4mph, HV=3mph)
        FF_TkSpd_M = ROUND( MAX(4, (FF_SPD - 3)) * 10) / 10
        AM_TkSpd_M = ROUND( MAX(4, (AM_SPD - 3)) * 10) / 10
        MD_TkSpd_M = ROUND( MAX(4, (MD_SPD - 3)) * 10) / 10
        PM_TkSpd_M = ROUND( MAX(4, (PM_SPD - 3)) * 10) / 10
        EV_TkSpd_M = ROUND( MAX(4, (EV_SPD - 3)) * 10) / 10
        @PM1Y@ P1_TkSpd_M = ROUND( MAX(4, (PM1_SPD - 3)) * 10) / 10
        
        FF_TkSpd_H = ROUND( MAX(3, (FF_SPD - 5)) * 10) / 10
        AM_TkSpd_H = ROUND( MAX(3, (AM_SPD - 5)) * 10) / 10
        MD_TkSpd_H = ROUND( MAX(3, (MD_SPD - 5)) * 10) / 10
        PM_TkSpd_H = ROUND( MAX(3, (PM_SPD - 5)) * 10) / 10
        EV_TkSpd_H = ROUND( MAX(3, (EV_SPD - 5)) * 10) / 10
        @PM1Y@ P1_TkSpd_H = ROUND( MAX(3, (PM1_SPD - 5)) * 10) / 10
        
        ;calculate truck time (in minutes)
        FF_TkTme_M = ROUND(li.1.DISTANCE * 60 / FF_TkSpd_M * 10000) / 10000
        AM_TkTme_M = ROUND(li.1.DISTANCE * 60 / AM_TkSpd_M * 10000) / 10000
        MD_TkTme_M = ROUND(li.2.DISTANCE * 60 / MD_TkSpd_M * 10000) / 10000
        PM_TkTme_M = ROUND(li.3.DISTANCE * 60 / PM_TkSpd_M * 10000) / 10000
        EV_TkTme_M = ROUND(li.4.DISTANCE * 60 / EV_TkSpd_M * 10000) / 10000
        @PM1Y@ P1_TkTme_M = ROUND(li.1.DISTANCE * 60 / P1_TkSpd_M * 10000) / 10000
                                                                           
        FF_TkTme_H = ROUND(li.1.DISTANCE * 60 / FF_TkSpd_H * 10000) / 10000
        AM_TkTme_H = ROUND(li.1.DISTANCE * 60 / AM_TkSpd_H * 10000) / 10000
        MD_TkTme_H = ROUND(li.2.DISTANCE * 60 / MD_TkSpd_H * 10000) / 10000
        PM_TkTme_H = ROUND(li.3.DISTANCE * 60 / PM_TkSpd_H * 10000) / 10000
        EV_TkTme_H = ROUND(li.4.DISTANCE * 60 / EV_TkSpd_H * 10000) / 10000
        @PM1Y@ P1_TkTme_H = ROUND(li.1.DISTANCE * 60 / P1_TkSpd_H * 10000) / 10000
        
        ;calculate average daily MD truck time and speed
        if (_DY_Trk_MD<1)
            
            DY_TkTme_M = FF_TkTme_M
            DY_TkSpd_M = FF_TkSpd_M
        
        else
            
            DY_TkTme_M = (AM_TkTme_M * _AM_Trk_MD + 
                          MD_TkTme_M * _MD_Trk_MD + 
                          PM_TkTme_M * _PM_Trk_MD + 
                          EV_TkTme_M * _EV_Trk_MD  ) / _DY_Trk_MD
            
            DY_TkSpd_M = li.1.DISTANCE / (DY_TkTme_M / 60)
        
        endif  ;_DY_Trk_MD<1
        
        ;calculate average daily HV truck time and speed
        if (_DY_Trk_HV<1)
            
            DY_TkTme_H = FF_TkTme_H
            DY_TkSpd_H = FF_TkSpd_H
        
        else
            
            DY_TkTme_H = (AM_TkTme_H * _AM_Trk_HV + 
                          MD_TkTme_H * _MD_Trk_HV + 
                          PM_TkTme_H * _PM_Trk_HV + 
                          EV_TkTme_H * _EV_Trk_HV  ) / _DY_Trk_HV
            
            DY_TkSpd_H = li.1.DISTANCE / (DY_TkTme_H / 60)
        
        endif  ;_DY_Trk_HV<1
        
        ;round MD & HV truck daily congested speed & time
        DY_TkSpd_M = ROUND(DY_TkSpd_M * 10 ) / 10
        DY_TkSpd_H = ROUND(DY_TkSpd_H * 10 ) / 10
        
        DY_TkTme_M = ROUND(DY_TkTme_M * 10000) / 10000
        DY_TkTme_H = ROUND(DY_TkTme_H * 10000) / 10000
        
        
        
        ;add generalized -------------------------------------------------------------
        byGenPurp_ = '__by Generalized Purpose'      ;field name separator
        
        
        AM_PER = _AM_HBW_DA_NON +
                 _AM_HBW_SR_NON +
                 _AM_HBW_SR_HOV +
                 _AM_HBW_DA_TOL +
                 _AM_HBW_SR_TOL +
                 _AM_HBO_DA_NON +
                 _AM_HBO_SR_NON +
                 _AM_HBO_SR_HOV +
                 _AM_HBO_DA_TOL +
                 _AM_HBO_SR_TOL +
                 _AM_NHB_DA_NON +
                 _AM_NHB_SR_NON +
                 _AM_NHB_SR_HOV +
                 _AM_NHB_DA_TOL +
                 _AM_NHB_SR_TOL +
                 _AM_HBC_DA_NON +
                 _AM_HBC_SR_NON +
                 _AM_HBC_SR_HOV +
                 _AM_HBC_DA_TOL +
                 _AM_HBC_SR_TOL +
                 _AM_HBSch_Pr   +
                 _AM_HBSch_Sc       
        
        AM_EXT = _AM_IX +
                 _AM_XI +
                 _AM_XX  
        
        AM_CV  = _AM_SLT
        
        AM_TRK = _AM_SMD +
                 _AM_SHV +
                 _AM_LMD +
                 _AM_LHV
        
        AM_TOT_GPR = AM_PER +
                     AM_EXT +
                     AM_CV  +
                     AM_TRK  
        
        
        MD_PER = _MD_HBW_DA_NON +
                 _MD_HBW_SR_NON +
                 _MD_HBW_SR_HOV +
                 _MD_HBW_DA_TOL +
                 _MD_HBW_SR_TOL +
                 _MD_HBO_DA_NON +
                 _MD_HBO_SR_NON +
                 _MD_HBO_SR_HOV +
                 _MD_HBO_DA_TOL +
                 _MD_HBO_SR_TOL +
                 _MD_NHB_DA_NON +
                 _MD_NHB_SR_NON +
                 _MD_NHB_SR_HOV +
                 _MD_NHB_DA_TOL +
                 _MD_NHB_SR_TOL +
                 _MD_HBC_DA_NON +
                 _MD_HBC_SR_NON +
                 _MD_HBC_SR_HOV +
                 _MD_HBC_DA_TOL +
                 _MD_HBC_SR_TOL +
                 _MD_HBSch_Pr   +
                 _MD_HBSch_Sc   
        
        MD_EXT = _MD_IX +
                 _MD_XI +
                 _MD_XX  
        
        MD_CV  = _MD_SLT
        
        MD_TRK = _MD_SMD +
                 _MD_SHV +
                 _MD_LMD +
                 _MD_LHV
        
        MD_TOT_GPR = MD_PER +
                     MD_EXT +
                     MD_CV  +
                     MD_TRK  
        
        
        PM_PER = _PM_HBW_DA_NON +
                 _PM_HBW_SR_NON +
                 _PM_HBW_SR_HOV +
                 _PM_HBW_DA_TOL +
                 _PM_HBW_SR_TOL +
                 _PM_HBO_DA_NON +
                 _PM_HBO_SR_NON +
                 _PM_HBO_SR_HOV +
                 _PM_HBO_DA_TOL +
                 _PM_HBO_SR_TOL +
                 _PM_NHB_DA_NON +
                 _PM_NHB_SR_NON +
                 _PM_NHB_SR_HOV +
                 _PM_NHB_DA_TOL +
                 _PM_NHB_SR_TOL +
                 _PM_HBC_DA_NON +
                 _PM_HBC_SR_NON +
                 _PM_HBC_SR_HOV +
                 _PM_HBC_DA_TOL +
                 _PM_HBC_SR_TOL +
                 _PM_HBSch_Pr   +
                 _PM_HBSch_Sc   
        
        PM_EXT = _PM_IX +
                 _PM_XI +
                 _PM_XX  
        
        PM_CV  = _PM_SLT
        
        PM_TRK = _PM_SMD +
                 _PM_SHV +
                 _PM_LMD +
                 _PM_LHV
        
        PM_TOT_GPR = PM_PER +
                     PM_EXT +
                     PM_CV  +
                     PM_TRK  
        
        
        EV_PER = _EV_HBW_DA_NON +
                 _EV_HBW_SR_NON +
                 _EV_HBW_SR_HOV +
                 _EV_HBW_DA_TOL +
                 _EV_HBW_SR_TOL +
                 _EV_HBO_DA_NON +
                 _EV_HBO_SR_NON +
                 _EV_HBO_SR_HOV +
                 _EV_HBO_DA_TOL +
                 _EV_HBO_SR_TOL +
                 _EV_NHB_DA_NON +
                 _EV_NHB_SR_NON +
                 _EV_NHB_SR_HOV +
                 _EV_NHB_DA_TOL +
                 _EV_NHB_SR_TOL +
                 _EV_HBC_DA_NON +
                 _EV_HBC_SR_NON +
                 _EV_HBC_SR_HOV +
                 _EV_HBC_DA_TOL +
                 _EV_HBC_SR_TOL +
                 _EV_HBSch_Pr   +
                 _EV_HBSch_Sc   
        
        EV_EXT = _EV_IX +
                 _EV_XI +
                 _EV_XX  
        
        EV_CV  = _EV_SLT
        
        EV_TRK = _EV_SMD +
                 _EV_SHV +
                 _EV_LMD +
                 _EV_LHV
        
        EV_TOT_GPR = EV_PER +
                     EV_EXT +
                     EV_CV  +
                     EV_TRK  
        
        
        DY_PER = AM_PER  + 
                 MD_PER  + 
                 PM_PER  + 
                 EV_PER   
        
        DY_EXT = AM_EXT  + 
                 MD_EXT  + 
                 PM_EXT  + 
                 EV_EXT   
        
        DY_CV  = AM_CV   + 
                 MD_CV   + 
                 PM_CV   + 
                 EV_CV         
        
        DY_TRK = AM_TRK  + 
                 MD_TRK  + 
                 PM_TRK  + 
                 EV_TRK   
        
        DY_TOT_GPR = DY_PER +
                     DY_EXT +
                     DY_CV  +
                     DY_TRK  
        
        ;PM1Hr
        @PM1Y@ PM1_PER = ROUND(li.5.V1_1  +       ;HBW_DA_NON
        @PM1Y@                 li.5.V2_1  +       ;HBW_SR_NON
        @PM1Y@                 li.5.V3_1  +       ;HBW_SR_HOV
        @PM1Y@                 li.5.V4_1  +       ;HBW_DA_TOL
        @PM1Y@                 li.5.V5_1  +       ;HBW_SR_TOL
        @PM1Y@                 li.5.V6_1  +       ;HBO_DA_NON
        @PM1Y@                 li.5.V7_1  +       ;HBO_SR_NON
        @PM1Y@                 li.5.V8_1  +       ;HBO_SR_HOV
        @PM1Y@                 li.5.V9_1  +       ;HBO_DA_TOL
        @PM1Y@                 li.5.V10_1 +       ;HBO_SR_TOL
        @PM1Y@                 li.5.V11_1 +       ;NHB_DA_NON
        @PM1Y@                 li.5.V12_1 +       ;NHB_SR_NON
        @PM1Y@                 li.5.V13_1 +       ;NHB_SR_HOV
        @PM1Y@                 li.5.V14_1 +       ;NHB_DA_TOL
        @PM1Y@                 li.5.V15_1 +       ;NHB_SR_TOL
        @PM1Y@                 li.5.V16_1 +       ;HBC_DA_NON
        @PM1Y@                 li.5.V17_1 +       ;HBC_SR_NON
        @PM1Y@                 li.5.V18_1 +       ;HBC_SR_HOV
        @PM1Y@                 li.5.V19_1 +       ;HBC_DA_TOL
        @PM1Y@                 li.5.V20_1 +       ;HBC_SR_TOL
        @PM1Y@                 li.5.V21_1 +       ;HBSch_Pr
        @PM1Y@                 li.5.V22_1  )      ;HBSch_Sc
       
        @PM1Y@ PM1_EXT = ROUND(li.5.V23_1 +       ;IX
        @PM1Y@                 li.5.V24_1 +       ;XI
        @PM1Y@                 li.5.V25_1  )      ;XX
        
        @PM1Y@ PM1_CV  = ROUND(li.5.V26_1)        ;SLT     
        
        @PM1Y@ PM1_TRK = ROUND(li.5.V27_1 +       ;SMD  
        @PM1Y@                 li.5.V28_1 +       ;SHV  
        @PM1Y@                 li.5.V29_1 +       ;LMD 
        @PM1Y@                 li.5.V30_1  )      ;LHV 
        
        @PM1Y@ P1_TOT_GPR = ROUND(PM1_PER +
        @PM1Y@                    PM1_EXT +
        @PM1Y@                    PM1_CV  +
        @PM1Y@                    PM1_TRK  )
        
        
        
        ;add detailed by vehicly type ----------------------------------------------------
        byGenVeh__ = '__by Generalized Vehicle'      ;field name separator
        
        
        AM_DA_NON  = _AM_HBW_DA_NON +
                     _AM_HBO_DA_NON +
                     _AM_NHB_DA_NON +
                     _AM_HBC_DA_NON +
                     _AM_IX         +
                     _AM_XI         +
                     _AM_XX         +
                     _AM_SLT        +
                     _AM_SMD        +
                     _AM_SHV        +
                     _AM_LMD        +
                     _AM_LHV       
        
        AM_SR_NON  = _AM_HBW_SR_NON +
                     _AM_HBO_SR_NON +
                     _AM_NHB_SR_NON +
                     _AM_HBC_SR_NON +
                     _AM_HBSch_Pr   +
                     _AM_HBSch_Sc   
        
        AM_HOV     = _AM_HBW_SR_HOV +
                     _AM_HBO_SR_HOV +
                     _AM_NHB_SR_HOV +
                     _AM_HBC_SR_HOV
        
        AM_TOL     = _AM_HBW_DA_TOL +
                     _AM_HBW_SR_TOL +
                     _AM_HBO_DA_TOL +
                     _AM_HBO_SR_TOL +
                     _AM_NHB_DA_TOL +
                     _AM_NHB_SR_TOL +
                     _AM_HBC_DA_TOL +
                     _AM_HBC_SR_TOL 
        
        AM_TOT_GVH = AM_DA_NON +
                     AM_SR_NON +
                     AM_HOV    +
                     AM_TOL
        
        
        MD_DA_NON  = _MD_HBW_DA_NON +
                     _MD_HBO_DA_NON +
                     _MD_NHB_DA_NON +
                     _MD_HBC_DA_NON +
                     _MD_IX         +
                     _MD_XI         +
                     _MD_XX         +
                     _MD_SLT        +
                     _MD_SMD        +
                     _MD_SHV        +
                     _MD_LMD        +
                     _MD_LHV       
        
        MD_SR_NON  = _MD_HBW_SR_NON +
                     _MD_HBO_SR_NON +
                     _MD_NHB_SR_NON +
                     _MD_HBC_SR_NON +
                     _MD_HBSch_Pr   +
                     _MD_HBSch_Sc   
        
        MD_HOV     = _MD_HBW_SR_HOV +
                     _MD_HBO_SR_HOV +
                     _MD_NHB_SR_HOV +
                     _MD_HBC_SR_HOV
        
        MD_TOL     = _MD_HBW_DA_TOL +
                     _MD_HBW_SR_TOL +
                     _MD_HBO_DA_TOL +
                     _MD_HBO_SR_TOL +
                     _MD_NHB_DA_TOL +
                     _MD_NHB_SR_TOL +
                     _MD_HBC_DA_TOL +
                     _MD_HBC_SR_TOL 
        
        MD_TOT_GVH = MD_DA_NON +
                     MD_SR_NON +
                     MD_HOV    +
                     MD_TOL
        
        
        PM_DA_NON  = _PM_HBW_DA_NON +
                     _PM_HBO_DA_NON +
                     _PM_NHB_DA_NON +
                     _PM_HBC_DA_NON +
                     _PM_IX         +
                     _PM_XI         +
                     _PM_XX         +
                     _PM_SLT        +
                     _PM_SMD        +
                     _PM_SHV        +
                     _PM_LMD        +
                     _PM_LHV       
        
        PM_SR_NON  = _PM_HBW_SR_NON +
                     _PM_HBO_SR_NON +
                     _PM_NHB_SR_NON +
                     _PM_HBC_SR_NON +
                     _PM_HBSch_Pr   +
                     _PM_HBSch_Sc   
        
        PM_HOV     = _PM_HBW_SR_HOV +
                     _PM_HBO_SR_HOV +
                     _PM_NHB_SR_HOV +
                     _PM_HBC_SR_HOV
        
        PM_TOL     = _PM_HBW_DA_TOL +
                     _PM_HBW_SR_TOL +
                     _PM_HBO_DA_TOL +
                     _PM_HBO_SR_TOL +
                     _PM_NHB_DA_TOL +
                     _PM_NHB_SR_TOL +
                     _PM_HBC_DA_TOL +
                     _PM_HBC_SR_TOL 
        
        PM_TOT_GVH = PM_DA_NON +
                     PM_SR_NON +
                     PM_HOV    +
                     PM_TOL
        
        
        EV_DA_NON  = _EV_HBW_DA_NON +
                     _EV_HBO_DA_NON +
                     _EV_NHB_DA_NON +
                     _EV_HBC_DA_NON +
                     _EV_IX         +
                     _EV_XI         +
                     _EV_XX         +
                     _EV_SLT        +
                     _EV_SMD        +
                     _EV_SHV        +
                     _EV_LMD        +
                     _EV_LHV       
        
        EV_SR_NON  = _EV_HBW_SR_NON +
                     _EV_HBO_SR_NON +
                     _EV_NHB_SR_NON +
                     _EV_HBC_SR_NON +
                     _EV_HBSch_Pr   +
                     _EV_HBSch_Sc   
        
        EV_HOV     = _EV_HBW_SR_HOV +
                     _EV_HBO_SR_HOV +
                     _EV_NHB_SR_HOV +
                     _EV_HBC_SR_HOV
        
        EV_TOL     = _EV_HBW_DA_TOL +
                     _EV_HBW_SR_TOL +
                     _EV_HBO_DA_TOL +
                     _EV_HBO_SR_TOL +
                     _EV_NHB_DA_TOL +
                     _EV_NHB_SR_TOL +
                     _EV_HBC_DA_TOL +
                     _EV_HBC_SR_TOL 
        
        EV_TOT_GVH = EV_DA_NON +
                     EV_SR_NON +
                     EV_HOV    +
                     EV_TOL
        
        ;DY
        DY_DA_NON  = AM_DA_NON +
                     MD_DA_NON +
                     PM_DA_NON +
                     EV_DA_NON 
                 
        DY_SR_NON  = AM_SR_NON +
                     MD_SR_NON +
                     PM_SR_NON +
                     EV_SR_NON
        
        DY_HOV     = AM_HOV +
                     MD_HOV +
                     PM_HOV +
                     EV_HOV
        
        DY_TOL     = AM_TOL +
                     MD_TOL +
                     PM_TOL +
                     EV_TOL
        
        DY_TOT_GVH = DY_DA_NON +
                     DY_SR_NON +
                     DY_HOV    +
                     DY_TOL     
                     
        ;PM1Hr
        @PM1Y@ PM1_DA_NON = ROUND(li.5.V1_1  +       ;HBW_DA_NON
        @PM1Y@                    li.5.V6_1  +       ;HBO_DA_NON
        @PM1Y@                    li.5.V11_1 +       ;NHB_DA_NON
        @PM1Y@                    li.5.V16_1 +       ;HBC_DA_NON
        @PM1Y@                    li.5.V23_1 +       ;IX
        @PM1Y@                    li.5.V24_1 +       ;XI
        @PM1Y@                    li.5.V25_1 +       ;XX
        @PM1Y@                    li.5.V26_1 +       ;SLT
        @PM1Y@                    li.5.V27_1 +       ;SMD  
        @PM1Y@                    li.5.V28_1 +       ;SHV  
        @PM1Y@                    li.5.V29_1 +       ;LMD 
        @PM1Y@                    li.5.V30_1  )      ;LHV 
        
        @PM1Y@ PM1_SR_NON = ROUND(li.5.V2_1  +       ;HBW_SR_NON
        @PM1Y@                    li.5.V7_1  +       ;HBO_SR_NON
        @PM1Y@                    li.5.V12_1 +       ;NHB_SR_NON
        @PM1Y@                    li.5.V17_1 +       ;HBC_SR_NON
        @PM1Y@                    li.5.V21_1 +       ;HBSch_Pr
        @PM1Y@                    li.5.V22_1 )       ;HBSch_Sc
        
        @PM1Y@ PM1_HOV    = ROUND(li.5.V3_1  +       ;HBW_SR_HOV
        @PM1Y@                    li.5.V8_1  +       ;HBO_SR_HOV
        @PM1Y@                    li.5.V13_1 +       ;NHB_SR_HOV
        @PM1Y@                    li.5.V18_1  )      ;HBC_SR_HOV
        
        @PM1Y@ PM1_TOL    = ROUND(li.5.V4_1  +       ;HBW_DA_TOL
        @PM1Y@                    li.5.V5_1  +       ;HBW_SR_TOL
        @PM1Y@                    li.5.V9_1  +       ;HBO_DA_TOL
        @PM1Y@                    li.5.V10_1 +       ;HBO_SR_TOL
        @PM1Y@                    li.5.V14_1 +       ;NHB_DA_TOL
        @PM1Y@                    li.5.V15_1 +       ;NHB_SR_TOL
        @PM1Y@                    li.5.V19_1 +       ;HBC_DA_TOL
        @PM1Y@                    li.5.V20_1  )      ;HBC_SR_TOL
        
        @PM1Y@ P1_TOT_GVH = PM1_DA_NON +
        @PM1Y@              PM1_SR_NON +
        @PM1Y@              PM1_HOV    +
        @PM1Y@              PM1_TOL     
        
        
        
        ;add detailed by purpose ---------------------------------------------------------
        byPURP____ = '__by Purpose'      ;field name separator
        
        
        AM_HBW = _AM_HBW_DA_NON  +
                 _AM_HBW_SR_NON  +
                 _AM_HBW_SR_HOV  +
                 _AM_HBW_DA_TOL  +
                 _AM_HBW_SR_TOL   
        
        AM_HBO = _AM_HBO_DA_NON +
                 _AM_HBO_SR_NON +
                 _AM_HBO_SR_HOV +
                 _AM_HBO_DA_TOL +
                 _AM_HBO_SR_TOL  
        
        AM_NHB = _AM_NHB_DA_NON +
                 _AM_NHB_SR_NON +
                 _AM_NHB_SR_HOV +
                 _AM_NHB_DA_TOL +
                 _AM_NHB_SR_TOL  
        
        AM_HBC = _AM_HBC_DA_NON +
                 _AM_HBC_SR_NON +
                 _AM_HBC_SR_HOV +
                 _AM_HBC_DA_TOL +
                 _AM_HBC_SR_TOL  
        
        AM_HBS_P = _AM_HBSch_Pr
        AM_HBS_S = _AM_HBSch_Sc
        AM_IX    = _AM_IX     
        AM_XI    = _AM_XI     
        AM_XX    = _AM_XX     
        AM_SLT   = _AM_SLT 
        AM_SMD   = _AM_SMD
        AM_SHV   = _AM_SHV
        AM_LMD   = _AM_LMD
        AM_LHV   = _AM_LHV
        
        AM_TOT_PUR = AM_HBW   +
                     AM_HBO   +
                     AM_NHB   +
                     AM_HBC   +
                     AM_HBS_P +
                     AM_HBS_S +
                     AM_IX    +
                     AM_XI    +
                     AM_XX    +
                     AM_SLT   +
                     AM_SMD   +
                     AM_SHV   +
                     AM_LMD   +
                     AM_LHV   
        
        
        MD_HBW = _MD_HBW_DA_NON  +
                 _MD_HBW_SR_NON  +
                 _MD_HBW_SR_HOV  +
                 _MD_HBW_DA_TOL  +
                 _MD_HBW_SR_TOL   

        MD_HBO = _MD_HBO_DA_NON +
                 _MD_HBO_SR_NON +
                 _MD_HBO_SR_HOV +
                 _MD_HBO_DA_TOL +
                 _MD_HBO_SR_TOL  

        MD_NHB = _MD_NHB_DA_NON +
                 _MD_NHB_SR_NON +
                 _MD_NHB_SR_HOV +
                 _MD_NHB_DA_TOL +
                 _MD_NHB_SR_TOL  

        MD_HBC = _MD_HBC_DA_NON +
                 _MD_HBC_SR_NON +
                 _MD_HBC_SR_HOV +
                 _MD_HBC_DA_TOL +
                 _MD_HBC_SR_TOL 
        
        MD_HBS_P = _MD_HBSch_Pr
        MD_HBS_S = _MD_HBSch_Sc
        MD_IX    = _MD_IX     
        MD_XI    = _MD_XI     
        MD_XX    = _MD_XX     
        MD_SLT   = _MD_SLT 
        MD_SMD   = _MD_SMD
        MD_SHV   = _MD_SHV
        MD_LMD   = _MD_LMD
        MD_LHV   = _MD_LHV
        
        MD_TOT_PUR = MD_HBW   +
                     MD_HBO   +
                     MD_NHB   +
                     MD_HBC   +
                     MD_HBS_P +
                     MD_HBS_S +
                     MD_IX    +
                     MD_XI    +
                     MD_XX    +
                     MD_SLT   +
                     MD_SMD   +
                     MD_SHV   +
                     MD_LMD   +
                     MD_LHV   

        
        PM_HBW = _PM_HBW_DA_NON  +
                 _PM_HBW_SR_NON  +
                 _PM_HBW_SR_HOV  +
                 _PM_HBW_DA_TOL  +
                 _PM_HBW_SR_TOL   

        PM_HBO = _PM_HBO_DA_NON +
                 _PM_HBO_SR_NON +
                 _PM_HBO_SR_HOV +
                 _PM_HBO_DA_TOL +
                 _PM_HBO_SR_TOL  

        PM_NHB = _PM_NHB_DA_NON +
                 _PM_NHB_SR_NON +
                 _PM_NHB_SR_HOV +
                 _PM_NHB_DA_TOL +
                 _PM_NHB_SR_TOL  

        PM_HBC = _PM_HBC_DA_NON +
                 _PM_HBC_SR_NON +
                 _PM_HBC_SR_HOV +
                 _PM_HBC_DA_TOL +
                 _PM_HBC_SR_TOL 
        
        PM_HBS_P = _PM_HBSch_Pr
        PM_HBS_S = _PM_HBSch_Sc
        PM_IX    = _PM_IX     
        PM_XI    = _PM_XI     
        PM_XX    = _PM_XX     
        PM_SLT   = _PM_SLT 
        PM_SMD   = _PM_SMD
        PM_SHV   = _PM_SHV
        PM_LMD   = _PM_LMD
        PM_LHV   = _PM_LHV
        
        PM_TOT_PUR = PM_HBW   +
                     PM_HBO   +
                     PM_NHB   +
                     PM_HBC   +
                     PM_HBS_P +
                     PM_HBS_S +
                     PM_IX    +
                     PM_XI    +
                     PM_XX    +
                     PM_SLT   +
                     PM_SMD   +
                     PM_SHV   +
                     PM_LMD   +
                     PM_LHV   

        
        EV_HBW = _EV_HBW_DA_NON  +
                 _EV_HBW_SR_NON  +
                 _EV_HBW_SR_HOV  +
                 _EV_HBW_DA_TOL  +
                 _EV_HBW_SR_TOL   

        EV_HBO = _EV_HBO_DA_NON +
                 _EV_HBO_SR_NON +
                 _EV_HBO_SR_HOV +
                 _EV_HBO_DA_TOL +
                 _EV_HBO_SR_TOL  

        EV_NHB = _EV_NHB_DA_NON +
                 _EV_NHB_SR_NON +
                 _EV_NHB_SR_HOV +
                 _EV_NHB_DA_TOL +
                 _EV_NHB_SR_TOL  

        EV_HBC = _EV_HBC_DA_NON +
                 _EV_HBC_SR_NON +
                 _EV_HBC_SR_HOV +
                 _EV_HBC_DA_TOL +
                 _EV_HBC_SR_TOL 
        
        EV_HBS_P = _EV_HBSch_Pr
        EV_HBS_S = _EV_HBSch_Sc
        EV_IX    = _EV_IX     
        EV_XI    = _EV_XI     
        EV_XX    = _EV_XX     
        EV_SLT   = _EV_SLT 
        EV_SMD   = _EV_SMD
        EV_SHV   = _EV_SHV
        EV_LMD   = _EV_LMD
        EV_LHV   = _EV_LHV
        
        EV_TOT_PUR = EV_HBW   +
                     EV_HBO   +
                     EV_NHB   +
                     EV_HBC   +
                     EV_HBS_P +
                     EV_HBS_S +
                     EV_IX    +
                     EV_XI    +
                     EV_XX    +
                     EV_SLT   +
                     EV_SMD   +
                     EV_SHV   +
                     EV_LMD   +
                     EV_LHV   

        
        DY_HBW = AM_HBW +
                 MD_HBW +
                 PM_HBW +
                 EV_HBW  
        
        DY_HBO = AM_HBO +
                 MD_HBO +
                 PM_HBO +
                 EV_HBO  
        
        DY_NHB = AM_NHB +
                 MD_NHB +
                 PM_NHB +
                 EV_NHB  
        
        DY_HBC = AM_HBC +
                 MD_HBC +
                 PM_HBC +
                 EV_HBC  
        
        DY_HBS_P = AM_HBS_P +
                   MD_HBS_P +
                   PM_HBS_P +
                   EV_HBS_P  
        
        DY_HBS_S = AM_HBS_S +
                   MD_HBS_S +
                   PM_HBS_S +
                   EV_HBS_S  
        
        DY_IX  = AM_IX  +
                 MD_IX  +
                 PM_IX  +
                 EV_IX   
        
        DY_XI  = AM_XI  +
                 MD_XI  +
                 PM_XI  +
                 EV_XI   
        
        DY_XX  = AM_XX  +
                 MD_XX  +
                 PM_XX  +
                 EV_XX   
        
        DY_SLT = AM_SLT +
                 MD_SLT +
                 PM_SLT +
                 EV_SLT  
        
        DY_SMD = AM_SMD +
                 MD_SMD +
                 PM_SMD +
                 EV_SMD  
        
        DY_SHV = AM_SHV +
                 MD_SHV +
                 PM_SHV +
                 EV_SHV  
        
        DY_LMD = AM_LMD +
                 MD_LMD +
                 PM_LMD +
                 EV_LMD  
        
        DY_LHV = AM_LHV +
                 MD_LHV +
                 PM_LHV +
                 EV_LHV  
        
        DY_TOT_PUR = DY_HBW   +
                     DY_HBO   +
                     DY_NHB   +
                     DY_HBC   +
                     DY_HBS_P +
                     DY_HBS_S +
                     DY_IX    +
                     DY_XI    +
                     DY_XX    +
                     DY_SLT   +
                     DY_SMD   +
                     DY_SHV   +
                     DY_LMD   +
                     DY_LHV   
        
        ;PM1Hr
        @PM1Y@ PM1_HBW = ROUND((li.5.V1_1  +                  ;HBW_DA_NON
        @PM1Y@                  li.5.V2_1  +                  ;HBW_SR_NON
        @PM1Y@                  li.5.V3_1  +                  ;HBW_SR_HOV
        @PM1Y@                  li.5.V4_1  +                  ;HBW_DA_TOL
        @PM1Y@                  li.5.V5_1   ) * 10) / 10      ;HBW_SR_TOL
        
        @PM1Y@ PM1_HBO = ROUND((li.5.V6_1  +                  ;HBO_DA_NON
        @PM1Y@                  li.5.V7_1  +                  ;HBO_SR_NON
        @PM1Y@                  li.5.V8_1  +                  ;HBO_SR_HOV
        @PM1Y@                  li.5.V9_1  +                  ;HBO_DA_TOL
        @PM1Y@                  li.5.V10_1  ) * 10) / 10      ;HBO_SR_TOL
        
        @PM1Y@ PM1_NHB = ROUND((li.5.V11_1 +                  ;NHB_DA_NON
        @PM1Y@                  li.5.V12_1 +                  ;NHB_SR_NON
        @PM1Y@                  li.5.V13_1 +                  ;NHB_SR_HOV
        @PM1Y@                  li.5.V14_1 +                  ;NHB_DA_TOL
        @PM1Y@                  li.5.V15_1  ) * 10) / 10      ;NHB_SR_TOL
        
        @PM1Y@ PM1_HBC = ROUND((li.5.V16_1 +                  ;HBC_DA_NON
        @PM1Y@                  li.5.V17_1 +                  ;HBC_SR_NON
        @PM1Y@                  li.5.V18_1 +                  ;HBC_SR_HOV
        @PM1Y@                  li.5.V19_1 +                  ;HBC_DA_TOL
        @PM1Y@                  li.5.V20_1  ) * 10) / 10      ;HBC_SR_TOL
        
        @PM1Y@ PM1_HBS_P = ROUND(li.5.V21_1 * 10) / 10          ;HBSch_Pr
        @PM1Y@ PM1_HBS_S = ROUND(li.5.V22_1 * 10) / 10          ;HBSch_Sc
        @PM1Y@ PM1_IX    = ROUND(li.5.V23_1 * 10) / 10          ;IX        
        @PM1Y@ PM1_XI    = ROUND(li.5.V24_1 * 10) / 10          ;XI        
        @PM1Y@ PM1_XX    = ROUND(li.5.V25_1 * 10) / 10          ;XX        
        @PM1Y@ PM1_SLT   = ROUND(li.5.V26_1 * 10) / 10          ;SLT     
        @PM1Y@ PM1_SMD   = ROUND(li.5.V27_1 * 10) / 10          ;SMD     
        @PM1Y@ PM1_SHV   = ROUND(li.5.V28_1 * 10) / 10          ;SHV     
        @PM1Y@ PM1_LMD   = ROUND(li.5.V29_1 * 10) / 10          ;LMD    
        @PM1Y@ PM1_LHV   = ROUND(li.5.V30_1 * 10) / 10          ;LHV    
        
        @PM1Y@ P1_TOT_PUR = ROUND((PM1_HBW   +
        @PM1Y@                     PM1_HBO   +
        @PM1Y@                     PM1_NHB   +
        @PM1Y@                     PM1_HBC   +
        @PM1Y@                     PM1_HBS_P +
        @PM1Y@                     PM1_HBS_S +
        @PM1Y@                     PM1_IX    +
        @PM1Y@                     PM1_XI    +
        @PM1Y@                     PM1_XX    +
        @PM1Y@                     PM1_SLT   +
        @PM1Y@                     PM1_SMD   +
        @PM1Y@                     PM1_SHV   +
        @PM1Y@                     PM1_LMD   +
        @PM1Y@                     PM1_LHV    ) * 10) / 10
        
        
        
        ;add detailed by vehicle type ---------------------------------------------------------
        byVeh_____ = '__by Vehicle'      ;field name separator
        
        
        ;non-managed lane
        AM_DAN_PER   = _AM_HBW_DA_NON +
                       _AM_HBO_DA_NON +
                       _AM_NHB_DA_NON +
                       _AM_HBC_DA_NON
        
        AM_SRN_PER   = _AM_HBW_SR_NON +
                       _AM_HBO_SR_NON +
                       _AM_NHB_SR_NON +
                       _AM_HBC_SR_NON +
                       _AM_HBSch_Pr   +
                       _AM_HBSch_Sc   
        
        AM_DAN_EXT   = _AM_IX +
                       _AM_XI +
                       _AM_XX  
        
        AM_DAN_CVT   = _AM_SLT +
                       _AM_SMD +
                       _AM_SHV +
                       _AM_LMD +
                       _AM_LHV  
        
        ;HOV eligible
        AM_SR_HOV    = _AM_HBW_SR_HOV +
                       _AM_HBO_SR_HOV +
                       _AM_NHB_SR_HOV +
                       _AM_HBC_SR_HOV  
        
        ;toll
        AM_DA_TOL    = _AM_HBW_DA_TOL +
                       _AM_HBO_DA_TOL +
                       _AM_NHB_DA_TOL +
                       _AM_HBC_DA_TOL  
        
        AM_SR_TOL    = _AM_HBW_SR_TOL +
                       _AM_HBO_SR_TOL +
                       _AM_NHB_SR_TOL +
                       _AM_HBC_SR_TOL  
        
        ;total
        AM_TOT_VEH   = AM_DAN_PER +
                       AM_SRN_PER +
                       AM_DAN_EXT +
                       AM_DAN_CVT +
                       AM_SR_HOV  +
                       AM_DA_TOL  +
                       AM_SR_TOL  
        
        
        ;non-managed lane
        MD_DAN_PER   = _MD_HBW_DA_NON +
                       _MD_HBO_DA_NON +
                       _MD_NHB_DA_NON +
                       _MD_HBC_DA_NON
        
        MD_SRN_PER   = _MD_HBW_SR_NON +
                       _MD_HBO_SR_NON +
                       _MD_NHB_SR_NON +
                       _MD_HBC_SR_NON +
                       _MD_HBSch_Pr   +
                       _MD_HBSch_Sc   
        
        MD_DAN_EXT   = _MD_IX +
                       _MD_XI +
                       _MD_XX  
        
        MD_DAN_CVT   = _MD_SLT +
                       _MD_SMD +
                       _MD_SHV +
                       _MD_LMD +
                       _MD_LHV  
        
        ;HOV eligible
        MD_SR_HOV    = _MD_HBW_SR_HOV +
                       _MD_HBO_SR_HOV +
                       _MD_NHB_SR_HOV +
                       _MD_HBC_SR_HOV  
        
        ;toll
        MD_DA_TOL    = _MD_HBW_DA_TOL +
                       _MD_HBO_DA_TOL +
                       _MD_NHB_DA_TOL +
                       _MD_HBC_DA_TOL  
        
        MD_SR_TOL    = _MD_HBW_SR_TOL +
                       _MD_HBO_SR_TOL +
                       _MD_NHB_SR_TOL +
                       _MD_HBC_SR_TOL  
        
        ;total
        MD_TOT_VEH   = MD_DAN_PER +
                       MD_SRN_PER +
                       MD_DAN_EXT +
                       MD_DAN_CVT +
                       MD_SR_HOV  +
                       MD_DA_TOL  +
                       MD_SR_TOL   
        
        
        ;non-managed lane
        PM_DAN_PER   = _PM_HBW_DA_NON +
                       _PM_HBO_DA_NON +
                       _PM_NHB_DA_NON +
                       _PM_HBC_DA_NON
        
        PM_SRN_PER   = _PM_HBW_SR_NON +
                       _PM_HBO_SR_NON +
                       _PM_NHB_SR_NON +
                       _PM_HBC_SR_NON +
                       _PM_HBSch_Pr   +
                       _PM_HBSch_Sc   
        
        PM_DAN_EXT   = _PM_IX +
                       _PM_XI +
                       _PM_XX  
        
        PM_DAN_CVT   = _PM_SLT +
                       _PM_SMD +
                       _PM_SHV +
                       _PM_LMD +
                       _PM_LHV  
        
        ;HOV eligible
        PM_SR_HOV    = _PM_HBW_SR_HOV +
                       _PM_HBO_SR_HOV +
                       _PM_NHB_SR_HOV +
                       _PM_HBC_SR_HOV  
        
        ;toll
        PM_DA_TOL    = _PM_HBW_DA_TOL +
                       _PM_HBO_DA_TOL +
                       _PM_NHB_DA_TOL +
                       _PM_HBC_DA_TOL  
        
        PM_SR_TOL    = _PM_HBW_SR_TOL +
                       _PM_HBO_SR_TOL +
                       _PM_NHB_SR_TOL +
                       _PM_HBC_SR_TOL  
        
        ;total
        PM_TOT_VEH   = PM_DAN_PER +
                       PM_SRN_PER +
                       PM_DAN_EXT +
                       PM_DAN_CVT +
                       PM_SR_HOV  +
                       PM_DA_TOL  +
                       PM_SR_TOL   
        
        
        ;non-managed lane
        EV_DAN_PER   = _EV_HBW_DA_NON +
                       _EV_HBO_DA_NON +
                       _EV_NHB_DA_NON +
                       _EV_HBC_DA_NON
        
        EV_SRN_PER   = _EV_HBW_SR_NON +
                       _EV_HBO_SR_NON +
                       _EV_NHB_SR_NON +
                       _EV_HBC_SR_NON +
                       _EV_HBSch_Pr   +
                       _EV_HBSch_Sc   
        
        EV_DAN_EXT   = _EV_IX +
                       _EV_XI +
                       _EV_XX  
        
        EV_DAN_CVT   = _EV_SLT +
                       _EV_SMD +
                       _EV_SHV +
                       _EV_LMD +
                       _EV_LHV  
        
        ;HOV eligible
        EV_SR_HOV    = _EV_HBW_SR_HOV +
                       _EV_HBO_SR_HOV +
                       _EV_NHB_SR_HOV +
                       _EV_HBC_SR_HOV  
        
        ;toll
        EV_DA_TOL    = _EV_HBW_DA_TOL +
                       _EV_HBO_DA_TOL +
                       _EV_NHB_DA_TOL +
                       _EV_HBC_DA_TOL  
        
        EV_SR_TOL    = _EV_HBW_SR_TOL +
                       _EV_HBO_SR_TOL +
                       _EV_NHB_SR_TOL +
                       _EV_HBC_SR_TOL  
        
        ;total
        EV_TOT_VEH   = EV_DAN_PER +
                       EV_SRN_PER +
                       EV_DAN_EXT +
                       EV_DAN_CVT +
                       EV_SR_HOV  +
                       EV_DA_TOL  +
                       EV_SR_TOL   
        
        
        ;non-managed lane
        DY_DAN_PER   = AM_DAN_PER +
                       MD_DAN_PER +
                       PM_DAN_PER +
                       EV_DAN_PER  
        
        DY_SRN_PER   = AM_SRN_PER +
                       MD_SRN_PER +
                       PM_SRN_PER +
                       EV_SRN_PER  
        
        DY_DAN_EXT   = AM_DAN_EXT +
                       MD_DAN_EXT +
                       PM_DAN_EXT +
                       EV_DAN_EXT  
        
        DY_DAN_CVT   = AM_DAN_CVT +
                       MD_DAN_CVT +
                       PM_DAN_CVT +
                       EV_DAN_CVT  
        
        ;HOV eligible
        DY_SR_HOV    = AM_SR_HOV +
                       MD_SR_HOV +
                       PM_SR_HOV +
                       EV_SR_HOV  
        
        ;toll
        DY_DA_TOL    = AM_DA_TOL +
                       MD_DA_TOL +
                       PM_DA_TOL +
                       EV_DA_TOL  
        
        DY_SR_TOL    = AM_SR_TOL +
                       MD_SR_TOL +
                       PM_SR_TOL +
                       EV_SR_TOL  
        
        ;total
        DY_TOT_VEH   = DY_DAN_PER +
                       DY_SRN_PER +
                       DY_DAN_EXT +
                       DY_DAN_CVT +
                       DY_SR_HOV  +
                       DY_DA_TOL  +
                       DY_SR_TOL     
        
        
        ;PM1Hr
        ;non-managed lane
        @PM1Y@ P1_DAN_PER = ROUND((li.5.V1_1  +                  ;HBW_DA_NON  
        @PM1Y@                     li.5.V6_1  +                  ;HBO_DA_NON
        @PM1Y@                     li.5.V11_1 +                  ;NHB_DA_NON
        @PM1Y@                     li.5.V16_1  ) * 10) / 10      ;HBC_DA_NON
         
        @PM1Y@ P1_SRN_PER = ROUND((li.5.V2_1  +                  ;HBW_SR_NON
        @PM1Y@                     li.5.V7_1  +                  ;HBO_SR_NON
        @PM1Y@                     li.5.V12_1 +                  ;NHB_SR_NON
        @PM1Y@                     li.5.V17_1 +                  ;HBC_SR_NON
        @PM1Y@                     li.5.V21_1 +                  ;HBSch_Pr
        @PM1Y@                     li.5.V22_1  ) * 10) / 10      ;HBSch_Sc
         
        @PM1Y@ P1_DAN_EXT = ROUND((li.5.V23_1 +                  ;IX
        @PM1Y@                     li.5.V24_1 +                  ;XI
        @PM1Y@                     li.5.V25_1  ) * 10) / 10      ;XX
         
        @PM1Y@ P1_DAN_CVT = ROUND((li.5.V26_1 +                  ;SLT
        @PM1Y@                     li.5.V27_1 +                  ;SMD
        @PM1Y@                     li.5.V28_1 +                  ;SHV
        @PM1Y@                     li.5.V29_1 +                  ;LMD
        @PM1Y@                     li.5.V30_1  ) * 10) / 10      ;LHV
         
        @PM1Y@ ;HOV eligible
        @PM1Y@ P1_SR_HOV    = ROUND((li.5.V3_1  +                  ;HBW_SR_HOV
        @PM1Y@                       li.5.V8_1  +                  ;HBO_SR_HOV
        @PM1Y@                       li.5.V13_1 +                  ;NHB_SR_HOV
        @PM1Y@                       li.5.V18_1  ) * 10) / 10      ;HBC_SR_HOV
         
        @PM1Y@ ;toll
        @PM1Y@ P1_DA_TOL    = ROUND((li.5.V4_1  +                  ;HBW_DA_TOL
        @PM1Y@                       li.5.V9_1  +                  ;HBO_DA_TOL
        @PM1Y@                       li.5.V14_1 +                  ;NHB_DA_TOL
        @PM1Y@                       li.5.V19_1  ) * 10) / 10      ;HBC_DA_TOL
         
        @PM1Y@ P1_SR_TOL    = ROUND((li.5.V5_1  +                  ;HBW_SR_TOL
        @PM1Y@                       li.5.V10_1 +                  ;HBO_SR_TOL
        @PM1Y@                       li.5.V15_1 +                  ;NHB_SR_TOL
        @PM1Y@                       li.5.V20_1  ) * 10) / 10      ;HBC_SR_TOL
         
        @PM1Y@ P1_TOT_VEH   = ROUND((P1_DAN_PER +
        @PM1Y@                       P1_SRN_PER +
        @PM1Y@                       P1_DAN_EXT +
        @PM1Y@                       P1_DAN_CVT +
        @PM1Y@                       P1_SR_HOV  +
        @PM1Y@                       P1_DA_TOL  +
        @PM1Y@                       P1_SR_TOL   ) * 10) / 10
        
        
        ;Process the select link fields to assigned net
        @SGRPY@ READ FILE='@ParentDir@2_ModelScripts\5_AssignHwy\block\SummarizeNet_SelectLink.block'
        
    ENDPHASE
    
ENDRUN




;create final assigned summary network
RUN PGM=NETWORK   MSG='Final Assign: extract summary fields from detailed network'
    FILEI NETI[1]  = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Assigned.net'
    FILEI GEOMI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Link.shp'
    
    
    FILEO NETO = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Summary.net', 
        EXCLUDE=byPurp____,
                AM_HBW    ,   MD_HBW    ,   PM_HBW    ,   EV_HBW    ,   DY_HBW    ,   @PM1Y@ PM1_HBW   ,
                AM_HBO    ,   MD_HBO    ,   PM_HBO    ,   EV_HBO    ,   DY_HBO    ,   @PM1Y@ PM1_HBO   ,
                AM_NHB    ,   MD_NHB    ,   PM_NHB    ,   EV_NHB    ,   DY_NHB    ,   @PM1Y@ PM1_NHB   ,
                AM_HBC    ,   MD_HBC    ,   PM_HBC    ,   EV_HBC    ,   DY_HBC    ,   @PM1Y@ PM1_HBC   ,
                AM_HBS_P  ,   MD_HBS_P  ,   PM_HBS_P  ,   EV_HBS_P  ,   DY_HBS_P  ,   @PM1Y@ PM1_HBS   ,
                AM_HBS_S  ,   MD_HBS_S  ,   PM_HBS_S  ,   EV_HBS_S  ,   DY_HBS_S  ,   @PM1Y@ PM1_HBS   ,
                AM_IX     ,   MD_IX     ,   PM_IX     ,   EV_IX     ,   DY_IX     ,   @PM1Y@ PM1_IX    ,
                AM_XI     ,   MD_XI     ,   PM_XI     ,   EV_XI     ,   DY_XI     ,   @PM1Y@ PM1_XI    ,
                AM_XX     ,   MD_XX     ,   PM_XX     ,   EV_XX     ,   DY_XX     ,   @PM1Y@ PM1_XX    ,
                AM_SLT    ,   MD_SLT    ,   PM_SLT    ,   EV_SLT    ,   DY_SLT    ,   @PM1Y@ PM1_SLT   ,
                AM_SMD    ,   MD_SMD    ,   PM_SMD    ,   EV_SMD    ,   DY_SMD    ,   @PM1Y@ PM1_SMD   ,
                AM_SHV    ,   MD_SHV    ,   PM_SHV    ,   EV_SHV    ,   DY_SHV    ,   @PM1Y@ PM1_SHV   ,
                AM_LMD    ,   MD_LMD    ,   PM_LMD    ,   EV_LMD    ,   DY_LMD    ,   @PM1Y@ PM1_LMD   ,
                AM_LHV    ,   MD_LHV    ,   PM_LHV    ,   EV_LHV    ,   DY_LHV    ,   @PM1Y@ PM1_LHV   ,
                AM_TOT_PUR,   MD_TOT_PUR,   PM_TOT_PUR,   EV_TOT_PUR,   DY_TOT_PUR,   @PM1Y@ P1_TOT_PUR,
                
                byVeh_____,
                AM_DAN_PER,   MD_DAN_PER,   PM_DAN_PER,   EV_DAN_PER,   DY_DAN_PER,   @PM1Y@ P1_DAN_PER,
                AM_SRN_PER,   MD_SRN_PER,   PM_SRN_PER,   EV_SRN_PER,   DY_SRN_PER,   @PM1Y@ P1_SRN_PER,
                AM_DAN_EXT,   MD_DAN_EXT,   PM_DAN_EXT,   EV_DAN_EXT,   DY_DAN_EXT,   @PM1Y@ P1_DAN_EXT,
                AM_DAN_CVT,   MD_DAN_CVT,   PM_DAN_CVT,   EV_DAN_CVT,   DY_DAN_CVT,   @PM1Y@ P1_DAN_CVT,
                AM_SR_HOV ,   MD_SR_HOV ,   PM_SR_HOV ,   EV_SR_HOV ,   DY_SR_HOV ,   @PM1Y@ P1_SR_HOV ,
                AM_DA_TOL ,   MD_DA_TOL ,   PM_DA_TOL ,   EV_DA_TOL ,   DY_DA_TOL ,   @PM1Y@ P1_DA_TOL ,
                AM_SR_TOL ,   MD_SR_TOL ,   PM_SR_TOL ,   EV_SR_TOL ,   DY_SR_TOL ,   @PM1Y@ P1_SR_TOL ,
                AM_TOT_VEH,   MD_TOT_VEH,   PM_TOT_VEH,   EV_TOT_VEH,   DY_TOT_VEH    @PM1Y@,P1_TOT_VEH
        
    
    FILEO LINKO = '@ParentDir@@ScenarioDir@5_AssignHwy\2b_Shapefiles\@RID@_Summary.shp',
        FORMAT=SHP,
        EXCLUDE=byPurp____,
                AM_HBW    ,   MD_HBW    ,   PM_HBW    ,   EV_HBW    ,   DY_HBW    ,   @PM1Y@ PM1_HBW   ,
                AM_HBO    ,   MD_HBO    ,   PM_HBO    ,   EV_HBO    ,   DY_HBO    ,   @PM1Y@ PM1_HBO   ,
                AM_NHB    ,   MD_NHB    ,   PM_NHB    ,   EV_NHB    ,   DY_NHB    ,   @PM1Y@ PM1_NHB   ,
                AM_HBC    ,   MD_HBC    ,   PM_HBC    ,   EV_HBC    ,   DY_HBC    ,   @PM1Y@ PM1_HBC   ,
                AM_HBS_P  ,   MD_HBS_P  ,   PM_HBS_P  ,   EV_HBS_P  ,   DY_HBS_P  ,   @PM1Y@ PM1_HBS   ,
                AM_HBS_S  ,   MD_HBS_S  ,   PM_HBS_S  ,   EV_HBS_S  ,   DY_HBS_S  ,   @PM1Y@ PM1_HBS   ,
                AM_IX     ,   MD_IX     ,   PM_IX     ,   EV_IX     ,   DY_IX     ,   @PM1Y@ PM1_IX    ,
                AM_XI     ,   MD_XI     ,   PM_XI     ,   EV_XI     ,   DY_XI     ,   @PM1Y@ PM1_XI    ,
                AM_XX     ,   MD_XX     ,   PM_XX     ,   EV_XX     ,   DY_XX     ,   @PM1Y@ PM1_XX    ,
                AM_SLT    ,   MD_SLT    ,   PM_SLT    ,   EV_SLT    ,   DY_SLT    ,   @PM1Y@ PM1_SLT   ,
                AM_SMD    ,   MD_SMD    ,   PM_SMD    ,   EV_SMD    ,   DY_SMD    ,   @PM1Y@ PM1_SMD   ,
                AM_SHV    ,   MD_SHV    ,   PM_SHV    ,   EV_SHV    ,   DY_SHV    ,   @PM1Y@ PM1_SHV   ,
                AM_LMD    ,   MD_LMD    ,   PM_LMD    ,   EV_LMD    ,   DY_LMD    ,   @PM1Y@ PM1_LMD   ,
                AM_LHV    ,   MD_LHV    ,   PM_LHV    ,   EV_LHV    ,   DY_LHV    ,   @PM1Y@ PM1_LHV   ,
                AM_TOT_PUR,   MD_TOT_PUR,   PM_TOT_PUR,   EV_TOT_PUR,   DY_TOT_PUR,   @PM1Y@ PM1_TOT_PR,
                
                byVeh_____,
                AM_DAN_PER,   MD_DAN_PER,   PM_DAN_PER,   EV_DAN_PER,   DY_DAN_PER,   @PM1Y@ P1_DAN_PER,
                AM_SRN_PER,   MD_SRN_PER,   PM_SRN_PER,   EV_SRN_PER,   DY_SRN_PER,   @PM1Y@ P1_SRN_PER,
                AM_DAN_EXT,   MD_DAN_EXT,   PM_DAN_EXT,   EV_DAN_EXT,   DY_DAN_EXT,   @PM1Y@ P1_DAN_EXT,
                AM_DAN_CVT,   MD_DAN_CVT,   PM_DAN_CVT,   EV_DAN_CVT,   DY_DAN_CVT,   @PM1Y@ P1_DAN_CVT,
                AM_SR_HOV ,   MD_SR_HOV ,   PM_SR_HOV ,   EV_SR_HOV ,   DY_SR_HOV ,   @PM1Y@ P1_SR_HOV ,
                AM_DA_TOL ,   MD_DA_TOL ,   PM_DA_TOL ,   EV_DA_TOL ,   DY_DA_TOL ,   @PM1Y@ P1_DA_TOL ,
                AM_SR_TOL ,   MD_SR_TOL ,   PM_SR_TOL ,   EV_SR_TOL ,   DY_SR_TOL ,   @PM1Y@ P1_SR_TOL ,
                AM_TOT_VEH,   MD_TOT_VEH,   PM_TOT_VEH,   EV_TOT_VEH,   DY_TOT_VEH    @PM1Y@, P1_TOT_VEH
    
    
    ZONES = @Usedzones@
    
ENDRUN



if (Use_SelLinkGrp=1)
 
    RUN PGM=MATRIX   MSG='Consolidate select link trip tables'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL1_AM.mtx'
          MATI[2] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL1_MD.mtx'
          MATI[3] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL1_PM.mtx'
          MATI[4] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL1_EV.mtx'
    
          MATI[5] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL2_AM.mtx'
          MATI[6] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL2_MD.mtx'
          MATI[7] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL2_PM.mtx'
          MATI[8] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL2_EV.mtx'   
          
    
    ;TAZ LEVEL                   
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL1_Daily.mtx', 
        mo=11-18, 
        name=HBW,
             HBO,
             NHB,
             HBC,
             HBSCH,
             EXTERNAL,
             COMMERCIAL,
             TOTAL
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@\5_AssignHwy\3_SelectLink\@RID@_SL2_Daily.mtx', 
        mo=21-28, 
        name=HBW,
             HBO,
             NHB,
             HBC,
             HBSCH,
             EXTERNAL,
             COMMERCIAL,
             TOTAL
        
        
        ZONES   = @UsedZones@
        
        
        ;selection set 1 (SL1)
        ;HBW trips
        mw[11] = mi.1.HBW_DA_NON + mi.2.HBW_DA_NON + mi.3.HBW_DA_NON + mi.4.HBW_DA_NON +
                 mi.1.HBW_SR_NON + mi.2.HBW_SR_NON + mi.3.HBW_SR_NON + mi.4.HBW_SR_NON +
                 mi.1.HBW_SR_HOV + mi.2.HBW_SR_HOV + mi.3.HBW_SR_HOV + mi.4.HBW_SR_HOV +
                 mi.1.HBW_DA_TOL + mi.2.HBW_DA_TOL + mi.3.HBW_DA_TOL + mi.4.HBW_DA_TOL +
                 mi.1.HBW_SR_TOL + mi.2.HBW_SR_TOL + mi.3.HBW_SR_TOL + mi.4.HBW_SR_TOL 
           
        ;HBO trips
        mw[12] = mi.1.HBO_DA_NON + mi.2.HBO_DA_NON + mi.3.HBO_DA_NON + mi.4.HBO_DA_NON +
                 mi.1.HBO_SR_NON + mi.2.HBO_SR_NON + mi.3.HBO_SR_NON + mi.4.HBO_SR_NON +
                 mi.1.HBO_SR_HOV + mi.2.HBO_SR_HOV + mi.3.HBO_SR_HOV + mi.4.HBO_SR_HOV +
                 mi.1.HBO_DA_TOL + mi.2.HBO_DA_TOL + mi.3.HBO_DA_TOL + mi.4.HBO_DA_TOL +
                 mi.1.HBO_SR_TOL + mi.2.HBO_SR_TOL + mi.3.HBO_SR_TOL + mi.4.HBO_SR_TOL 
        
        ;NHB trips
        mw[13] = mi.1.NHB_DA_NON + mi.2.NHB_DA_NON + mi.3.NHB_DA_NON + mi.4.NHB_DA_NON +
                 mi.1.NHB_SR_NON + mi.2.NHB_SR_NON + mi.3.NHB_SR_NON + mi.4.NHB_SR_NON +
                 mi.1.NHB_SR_HOV + mi.2.NHB_SR_HOV + mi.3.NHB_SR_HOV + mi.4.NHB_SR_HOV +
                 mi.1.NHB_DA_TOL + mi.2.NHB_DA_TOL + mi.3.NHB_DA_TOL + mi.4.NHB_DA_TOL +
                 mi.1.NHB_SR_TOL + mi.2.NHB_SR_TOL + mi.3.NHB_SR_TOL + mi.4.NHB_SR_TOL 
                 
        ;HBC trips
        mw[14] = mi.1.HBC_DA_NON + mi.2.HBC_DA_NON + mi.3.HBC_DA_NON + mi.4.HBC_DA_NON +
                 mi.1.HBC_SR_NON + mi.2.HBC_SR_NON + mi.3.HBC_SR_NON + mi.4.HBC_SR_NON +
                 mi.1.HBC_SR_HOV + mi.2.HBC_SR_HOV + mi.3.HBC_SR_HOV + mi.4.HBC_SR_HOV +
                 mi.1.HBC_DA_TOL + mi.2.HBC_DA_TOL + mi.3.HBC_DA_TOL + mi.4.HBC_DA_TOL +
                 mi.1.HBC_SR_TOL + mi.2.HBC_SR_TOL + mi.3.HBC_SR_TOL + mi.4.HBC_SR_TOL 
                 
        ;HBSHC trips                                                   
        mw[15] = mi.1.HBSch_Pr + mi.2.HBSch_Pr + mi.3.HBSch_Pr + mi.4.HBSch_Pr +
                 mi.1.HBSch_Sc + mi.2.HBSch_Sc + mi.3.HBSch_Sc + mi.4.HBSch_Sc
        
        ;ix-xi-xx
        mw[16] = mi.1.IX + mi.2.IX + mi.3.IX + mi.4.IX +
                 mi.1.XI + mi.2.XI + mi.3.XI + mi.4.XI +
                 mi.1.XX + mi.2.XX + mi.3.XX + mi.4.XX 
        
        ;COMMERCIAL TRUCKS (LT-MD-HV)
        mw[17] = mi.1.SH_LT  + mi.2.SH_LT  + mi.3.SH_LT  + mi.4.SH_LT  +
                 mi.1.SH_MD  + mi.2.SH_MD  + mi.3.SH_MD  + mi.4.SH_MD  +
                 mi.1.SH_HV  + mi.2.SH_HV  + mi.3.SH_HV  + mi.4.SH_HV  +
                 mi.1.Ext_MD + mi.2.Ext_MD + mi.3.Ext_MD + mi.4.Ext_MD +
                 mi.1.Ext_HV + mi.2.Ext_HV + mi.3.Ext_HV + mi.4.Ext_HV 
        
        ;TOTAL TRIPS 
        mw[18] = mw[11] +
                 mw[12] +
                 mw[13] +
                 mw[14] +
                 mw[15] +
                 mw[16] +
                 mw[17]
        
        
        
        ;selection set 2 (SL2)
        ;HBW trips
        mw[21] = mi.5.HBW_DA_NON + mi.6.HBW_DA_NON + mi.7.HBW_DA_NON + mi.8.HBW_DA_NON +
                 mi.5.HBW_SR_NON + mi.6.HBW_SR_NON + mi.7.HBW_SR_NON + mi.8.HBW_SR_NON +
                 mi.5.HBW_SR_HOV + mi.6.HBW_SR_HOV + mi.7.HBW_SR_HOV + mi.8.HBW_SR_HOV +
                 mi.5.HBW_DA_TOL + mi.6.HBW_DA_TOL + mi.7.HBW_DA_TOL + mi.8.HBW_DA_TOL +
                 mi.5.HBW_SR_TOL + mi.6.HBW_SR_TOL + mi.7.HBW_SR_TOL + mi.8.HBW_SR_TOL 
           
        ;HBO trips
        mw[22] = mi.5.HBO_DA_NON + mi.6.HBO_DA_NON + mi.7.HBO_DA_NON + mi.8.HBO_DA_NON +
                 mi.5.HBO_SR_NON + mi.6.HBO_SR_NON + mi.7.HBO_SR_NON + mi.8.HBO_SR_NON +
                 mi.5.HBO_SR_HOV + mi.6.HBO_SR_HOV + mi.7.HBO_SR_HOV + mi.8.HBO_SR_HOV +
                 mi.5.HBO_DA_TOL + mi.6.HBO_DA_TOL + mi.7.HBO_DA_TOL + mi.8.HBO_DA_TOL +
                 mi.5.HBO_SR_TOL + mi.6.HBO_SR_TOL + mi.7.HBO_SR_TOL + mi.8.HBO_SR_TOL 
        
        ;NHB trips
        mw[23] = mi.5.NHB_DA_NON + mi.6.NHB_DA_NON + mi.7.NHB_DA_NON + mi.8.NHB_DA_NON +
                 mi.5.NHB_SR_NON + mi.6.NHB_SR_NON + mi.7.NHB_SR_NON + mi.8.NHB_SR_NON +
                 mi.5.NHB_SR_HOV + mi.6.NHB_SR_HOV + mi.7.NHB_SR_HOV + mi.8.NHB_SR_HOV +
                 mi.5.NHB_DA_TOL + mi.6.NHB_DA_TOL + mi.7.NHB_DA_TOL + mi.8.NHB_DA_TOL +
                 mi.5.NHB_SR_TOL + mi.6.NHB_SR_TOL + mi.7.NHB_SR_TOL + mi.8.NHB_SR_TOL 
                 
        ;HBC trips
        mw[24] = mi.5.HBC_DA_NON + mi.6.HBC_DA_NON + mi.7.HBC_DA_NON + mi.8.HBC_DA_NON +
                 mi.5.HBC_SR_NON + mi.6.HBC_SR_NON + mi.7.HBC_SR_NON + mi.8.HBC_SR_NON +
                 mi.5.HBC_SR_HOV + mi.6.HBC_SR_HOV + mi.7.HBC_SR_HOV + mi.8.HBC_SR_HOV +
                 mi.5.HBC_DA_TOL + mi.6.HBC_DA_TOL + mi.7.HBC_DA_TOL + mi.8.HBC_DA_TOL +
                 mi.5.HBC_SR_TOL + mi.6.HBC_SR_TOL + mi.7.HBC_SR_TOL + mi.8.HBC_SR_TOL 
                 
        ;HBSHC trips                                                   
        mw[25] = mi.5.HBSch_Pr + mi.6.HBSch_Pr + mi.7.HBSch_Pr + mi.8.HBSch_Pr +
                 mi.5.HBSch_Sc + mi.6.HBSch_Sc + mi.7.HBSch_Sc + mi.8.HBSch_Sc
        
        ;ix-xi-xx
        mw[26] = mi.5.IX + mi.6.IX + mi.7.IX + mi.8.IX +
                 mi.5.XI + mi.6.XI + mi.7.XI + mi.8.XI +
                 mi.5.XX + mi.6.XX + mi.7.XX + mi.8.XX 
        
        ;COMMERCIAL TRUCKS (LT-MD-HV)
        mw[27] = mi.5.SH_LT  + mi.6.SH_LT  + mi.7.SH_LT  + mi.8.SH_LT  +
                 mi.5.SH_MD  + mi.6.SH_MD  + mi.7.SH_MD  + mi.8.SH_MD  +
                 mi.5.SH_HV  + mi.6.SH_HV  + mi.7.SH_HV  + mi.8.SH_HV  +
                 mi.5.Ext_MD + mi.6.Ext_MD + mi.7.Ext_MD + mi.8.Ext_MD +
                 mi.5.Ext_HV + mi.6.Ext_HV + mi.7.Ext_HV + mi.8.Ext_HV 
        
        ;TOTAL TRIPS 
        mw[28] = mw[21] +
                 mw[22] +
                 mw[23] +
                 mw[24] +
                 mw[25] +
                 mw[26] +
                 mw[27]
        
    ENDRUN

endif  ;Use_SelLinkGrp=1



if (Use_SelLinkGrp=1)

    ;create final assigned summary network
    RUN PGM=NETWORK   MSG='Final Assign: create select link network with percentage total volume'
        FILEI NETI[1]  = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Assigned.net'
        
        FILEO NETO = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__SL_TotVolume.net',
            INCLUDE=A              ,
                    B              ,
                    STREET         ,
                    DISTANCE       ,
                    ONEWAY         ,
                    TAZID          ,
                    SEGID          ,
                    LINKID         ,
                    LANES          ,
                    FT             ,
                    HOV_LYEAR      ,
                    HOT_ZONEID     ,
                    HOT_CHRGPT     ,
                    TRK_RSTRCT     ,
                    SFAC           ,
                    CFAC           ,
                    DISTEXCEPT     ,
                    AREATYPE       ,
                    ATYPENAME      ,
                    ATYPEGRP       ,
                    FTCLASS        ,
                    EXTERNAL       ,
                    LANE_MILE      ,
                    RMPGPID        ,
                    MANFWYID       ,
                    CAP1HR1LN      ,
                    RELCAP1HR      ,
                    ADHOVCAP1H     ,
                    ANGLE          ,
                    DIRECTION      ,
                    IB_OB          ,
                    PKDIRPRD       ,
                    REL_LN         ,
                    CBD            ,
                    COUNTY         ,
                    CO_TAZID       ,
                    CO_FIPS        ,
                    CO_NAME        ,
                    CITY           ,
                    CITY_FIPS      ,
                    CITY_NAME      ,
                    DISTLRG        ,
                    DLRG_NAME      ,
                    DISTMED        ,
                    DMED_NAME      ,
                    DISTSML        ,
                    DSML_NAME      ,
                    WARNL          ,
                    WARNLTXT       ,
                    OP_PROJ        ,
                    SEL_LINK       ,
                    @AddLinkFields@,
                    SUBAREAID      ,
                    FF_RAMPPEN     ,
                    AM_RAMPPEN     ,
                    MD_RAMPPEN     ,
                    PM_RAMPPEN     ,
                    EV_RAMPPEN     ,
                    HOT_CHRGAM     ,
                    HOT_CHRGMD     ,
                    HOT_CHRGPM     ,
                    HOT_CHRGEV     ,
                    AM_CAP         ,
                    MD_CAP         ,
                    PM_CAP         ,
                    EV_CAP         ,
                    AM_VC          ,
                    MD_VC          ,
                    PM_VC          ,
                    EV_VC          ,
                    FF_SPD         ,
                    AM_SPD         ,
                    MD_SPD         ,
                    PM_SPD         ,
                    EV_SPD         ,
                    DY_SPD         ,
                    FF_TIME        ,
                    AM_TIME        ,
                    MD_TIME        ,
                    PM_TIME        ,
                    EV_TIME        ,
                    DY_TIME        ,
                    
                    AM_VOL_TOT     , AM_WRK_TOT  , AM_NWK_TOT  , AM_EXT_TOT  , AM_LT_TOT   , AM_MD_TOT   , AM_HV_TOT   ,
                    MD_VOL_TOT     , MD_WRK_TOT  , MD_NWK_TOT  , MD_EXT_TOT  , MD_LT_TOT   , MD_MD_TOT   , MD_HV_TOT   ,
                    PM_VOL_TOT     , PM_WRK_TOT  , PM_NWK_TOT  , PM_EXT_TOT  , PM_LT_TOT   , PM_MD_TOT   , PM_HV_TOT   ,
                    EV_VOL_TOT     , EV_WRK_TOT  , EV_NWK_TOT  , EV_EXT_TOT  , EV_LT_TOT   , EV_MD_TOT   , EV_HV_TOT   ,
                    DY_VOL_TOT     , DY_WRK_TOT  , DY_NWK_TOT  , DY_EXT_TOT  , DY_LT_TOT   , DY_MD_TOT   , DY_HV_TOT   ,
                    
                    AM_VOL_GR1     , AM_WRK_GR1  , AM_NWK_GR1  , AM_EXT_GR1  , AM_LT_GR1   , AM_MD_GR1   , AM_HV_GR1   ,
                    MD_VOL_GR1     , MD_WRK_GR1  , MD_NWK_GR1  , MD_EXT_GR1  , MD_LT_GR1   , MD_MD_GR1   , MD_HV_GR1   ,
                    PM_VOL_GR1     , PM_WRK_GR1  , PM_NWK_GR1  , PM_EXT_GR1  , PM_LT_GR1   , PM_MD_GR1   , PM_HV_GR1   ,
                    EV_VOL_GR1     , EV_WRK_GR1  , EV_NWK_GR1  , EV_EXT_GR1  , EV_LT_GR1   , EV_MD_GR1   , EV_HV_GR1   ,
                    DY_VOL_GR1     , DY_WRK_GR1  , DY_NWK_GR1  , DY_EXT_GR1  , DY_LT_GR1   , DY_MD_GR1   , DY_HV_GR1   ,
                    
                    AM_VOL_GR2     , AM_WRK_GR2  , AM_NWK_GR2  , AM_EXT_GR2  , AM_LT_GR2   , AM_MD_GR2   , AM_HV_GR2   ,
                    MD_VOL_GR2     , MD_WRK_GR2  , MD_NWK_GR2  , MD_EXT_GR2  , MD_LT_GR2   , MD_MD_GR2   , MD_HV_GR2   ,
                    PM_VOL_GR2     , PM_WRK_GR2  , PM_NWK_GR2  , PM_EXT_GR2  , PM_LT_GR2   , PM_MD_GR2   , PM_HV_GR2   ,
                    EV_VOL_GR2     , EV_WRK_GR2  , EV_NWK_GR2  , EV_EXT_GR2  , EV_LT_GR2   , EV_MD_GR2   , EV_HV_GR2   ,
                    DY_VOL_GR2     , DY_WRK_GR2  , DY_NWK_GR2  , DY_EXT_GR2  , DY_LT_GR2   , DY_MD_GR2   , DY_HV_GR2   ,
                    
                    AM_VOL_G1P     , AM_WRK_G1P  , AM_NWK_G1P  , AM_EXT_G1P  , AM_LT_G1P   , AM_MD_G1P   , AM_HV_G1P   ,
                    MD_VOL_G1P     , MD_WRK_G1P  , MD_NWK_G1P  , MD_EXT_G1P  , MD_LT_G1P   , MD_MD_G1P   , MD_HV_G1P   ,
                    PM_VOL_G1P     , PM_WRK_G1P  , PM_NWK_G1P  , PM_EXT_G1P  , PM_LT_G1P   , PM_MD_G1P   , PM_HV_G1P   ,
                    EV_VOL_G1P     , EV_WRK_G1P  , EV_NWK_G1P  , EV_EXT_G1P  , EV_LT_G1P   , EV_MD_G1P   , EV_HV_G1P   ,
                    DY_VOL_G1P     , DY_WRK_G1P  , DY_NWK_G1P  , DY_EXT_G1P  , DY_LT_G1P   , DY_MD_G1P   , DY_HV_G1P   ,
                    
                    AM_VOL_G2P     , AM_WRK_G2P  , AM_NWK_G2P  , AM_EXT_G2P  , AM_LT_G2P   , AM_MD_G2P   , AM_HV_G2P   ,
                    MD_VOL_G2P     , MD_WRK_G2P  , MD_NWK_G2P  , MD_EXT_G2P  , MD_LT_G2P   , MD_MD_G2P   , MD_HV_G2P   ,
                    PM_VOL_G2P     , PM_WRK_G2P  , PM_NWK_G2P  , PM_EXT_G2P  , PM_LT_G2P   , PM_MD_G2P   , PM_HV_G2P   ,
                    EV_VOL_G2P     , EV_WRK_G2P  , EV_NWK_G2P  , EV_EXT_G2P  , EV_LT_G2P   , EV_MD_G2P   , EV_HV_G2P   ,
                    DY_VOL_G2P     , DY_WRK_G2P  , DY_NWK_G2P  , DY_EXT_G2P  , DY_LT_G2P   , DY_MD_G2P   , DY_HV_G2P   
        
        
        ;parameters
        ZONES = @UsedZones@
        

        PHASE=LINKMERGE
            
            ;calculate am total volume by volume class
            AM_WRK_TOT = AM_HBW
            AM_NWK_TOT = AM_HBO   +
                         AM_NHB   +
                         AM_HBC   +
                         AM_HBS_P +
                         AM_HBS_S
            AM_EXT_TOT = AM_EXT
            AM_LT_TOT  = AM_SLT
            AM_MD_TOT  = AM_SMD   +
                         AM_LMD
            AM_HV_TOT  = AM_SHV   +
                         AM_LHV
            AM_VOL_TOT = AM_VOL
            
            ;calculate md total volume by volume class
            MD_WRK_TOT = MD_HBW
            MD_NWK_TOT = MD_HBO   +
                         MD_NHB   +
                         MD_HBC   +
                         MD_HBS_P +
                         MD_HBS_S
            MD_EXT_TOT = MD_EXT
            MD_LT_TOT  = MD_SLT
            MD_MD_TOT  = MD_SMD   +
                         MD_LMD
            MD_HV_TOT  = MD_SHV   +
                         MD_LHV
            MD_VOL_TOT = MD_VOL

            ;calculate pm total volume by volume class
            PM_WRK_TOT = PM_HBW
            PM_NWK_TOT = PM_HBO   +
                         PM_NHB   +
                         PM_HBC   +
                         PM_HBS_P +
                         PM_HBS_S
            PM_EXT_TOT = PM_EXT
            PM_LT_TOT  = PM_SLT
            PM_MD_TOT  = PM_SMD   +
                         PM_LMD
            PM_HV_TOT  = PM_SHV   +
                         PM_LHV
            PM_VOL_TOT = PM_VOL
            
            ;calculate ev total volume by volume class
            EV_WRK_TOT = EV_HBW
            EV_NWK_TOT = EV_HBO   +
                         EV_NHB   +
                         EV_HBC   +
                         EV_HBS_P +
                         EV_HBS_S
            EV_EXT_TOT = EV_EXT
            EV_LT_TOT  = EV_SLT
            EV_MD_TOT  = EV_SMD   +
                         EV_LMD
            EV_HV_TOT  = EV_SHV   +
                         EV_LHV
            EV_VOL_TOT = EV_VOL
            
            ;calculate dy total volume by volume class
            DY_VOL_TOT   = AM_VOL_TOT + MD_VOL_TOT + PM_VOL_TOT + EV_VOL_TOT
            DY_WRK_TOT   = AM_WRK_TOT + MD_WRK_TOT + PM_WRK_TOT + EV_WRK_TOT
            DY_NWK_TOT   = AM_NWK_TOT + MD_NWK_TOT + PM_NWK_TOT + EV_NWK_TOT
            DY_EXT_TOT   = AM_EXT_TOT + MD_EXT_TOT + PM_EXT_TOT + EV_EXT_TOT
            DY_LT_TOT    = AM_LT_TOT  + MD_LT_TOT  + PM_LT_TOT  + EV_LT_TOT
            DY_MD_TOT    = AM_MD_TOT  + MD_MD_TOT  + PM_MD_TOT  + EV_MD_TOT
            DY_HV_TOT    = AM_HV_TOT  + MD_HV_TOT  + PM_HV_TOT  + EV_HV_TOT
            
            ;calcule the percentage of the select link's volume on each link as a ratio to the total volume
            ;select link group 1
            if (AM_VOL_TOT>0)  AM_VOL_G1P   = AM_VOL_GR1  / AM_VOL_TOT
            if (AM_WRK_TOT>0)  AM_WRK_G1P   = AM_WRK_GR1  / AM_WRK_TOT
            if (AM_NWK_TOT>0)  AM_NWK_G1P   = AM_NWK_GR1  / AM_NWK_TOT
            if (AM_EXT_TOT>0)  AM_EXT_G1P   = AM_EXT_GR1  / AM_EXT_TOT
            if (AM_LT_TOT>0)   AM_LT_G1P    = AM_LT_GR1   / AM_LT_TOT
            if (AM_MD_TOT>0)   AM_MD_G1P    = AM_MD_GR1   / AM_MD_TOT
            if (AM_HV_TOT>0)   AM_HV_G1P    = AM_HV_GR1   / AM_HV_TOT
            if (MD_VOL_TOT>0)  MD_VOL_G1P   = MD_VOL_GR1  / MD_VOL_TOT
            if (MD_WRK_TOT>0)  MD_WRK_G1P   = MD_WRK_GR1  / MD_WRK_TOT
            if (MD_NWK_TOT>0)  MD_NWK_G1P   = MD_NWK_GR1  / MD_NWK_TOT
            if (MD_EXT_TOT>0)  MD_EXT_G1P   = MD_EXT_GR1  / MD_EXT_TOT
            if (MD_LT_TOT>0)   MD_LT_G1P    = MD_LT_GR1   / MD_LT_TOT
            if (MD_MD_TOT>0)   MD_MD_G1P    = MD_MD_GR1   / MD_MD_TOT
            if (MD_HV_TOT>0)   MD_HV_G1P    = MD_HV_GR1   / MD_HV_TOT
            if (PM_VOL_TOT>0)  PM_VOL_G1P   = PM_VOL_GR1  / PM_VOL_TOT
            if (PM_WRK_TOT>0)  PM_WRK_G1P   = PM_WRK_GR1  / PM_WRK_TOT
            if (PM_NWK_TOT>0)  PM_NWK_G1P   = PM_NWK_GR1  / PM_NWK_TOT
            if (PM_EXT_TOT>0)  PM_EXT_G1P   = PM_EXT_GR1  / PM_EXT_TOT
            if (PM_LT_TOT>0)   PM_LT_G1P    = PM_LT_GR1   / PM_LT_TOT
            if (PM_MD_TOT>0)   PM_MD_G1P    = PM_MD_GR1   / PM_MD_TOT
            if (PM_HV_TOT>0)   PM_HV_G1P    = PM_HV_GR1   / PM_HV_TOT
            if (EV_VOL_TOT>0)  EV_VOL_G1P   = EV_VOL_GR1  / EV_VOL_TOT
            if (EV_WRK_TOT>0)  EV_WRK_G1P   = EV_WRK_GR1  / EV_WRK_TOT
            if (EV_NWK_TOT>0)  EV_NWK_G1P   = EV_NWK_GR1  / EV_NWK_TOT
            if (EV_EXT_TOT>0)  EV_EXT_G1P   = EV_EXT_GR1  / EV_EXT_TOT
            if (EV_LT_TOT>0)   EV_LT_G1P    = EV_LT_GR1   / EV_LT_TOT
            if (EV_MD_TOT>0)   EV_MD_G1P    = EV_MD_GR1   / EV_MD_TOT
            if (EV_HV_TOT>0)   EV_HV_G1P    = EV_HV_GR1   / EV_HV_TOT
            if (DY_VOL_TOT>0)  DY_VOL_G1P   = DY_VOL_GR1  / DY_VOL_TOT
            if (DY_WRK_TOT>0)  DY_WRK_G1P   = DY_WRK_GR1  / DY_WRK_TOT
            if (DY_NWK_TOT>0)  DY_NWK_G1P   = DY_NWK_GR1  / DY_NWK_TOT
            if (DY_EXT_TOT>0)  DY_EXT_G1P   = DY_EXT_GR1  / DY_EXT_TOT
            if (DY_LT_TOT>0)   DY_LT_G1P    = DY_LT_GR1   / DY_LT_TOT
            if (DY_MD_TOT>0)   DY_MD_G1P    = DY_MD_GR1   / DY_MD_TOT
            if (DY_HV_TOT>0)   DY_HV_G1P    = DY_HV_GR1   / DY_HV_TOT
            
            ;select link group 2
            if (AM_VOL_TOT>0)  AM_VOL_G2P   = AM_VOL_GR2  / AM_VOL_TOT
            if (AM_WRK_TOT>0)  AM_WRK_G2P   = AM_WRK_GR2  / AM_WRK_TOT
            if (AM_NWK_TOT>0)  AM_NWK_G2P   = AM_NWK_GR2  / AM_NWK_TOT
            if (AM_EXT_TOT>0)  AM_EXT_G2P   = AM_EXT_GR2  / AM_EXT_TOT
            if (AM_LT_TOT>0)   AM_LT_G2P    = AM_LT_GR2   / AM_LT_TOT
            if (AM_MD_TOT>0)   AM_MD_G2P    = AM_MD_GR2   / AM_MD_TOT
            if (AM_HV_TOT>0)   AM_HV_G2P    = AM_HV_GR2   / AM_HV_TOT
            if (MD_VOL_TOT>0)  MD_VOL_G2P   = MD_VOL_GR2  / MD_VOL_TOT
            if (MD_WRK_TOT>0)  MD_WRK_G2P   = MD_WRK_GR2  / MD_WRK_TOT
            if (MD_NWK_TOT>0)  MD_NWK_G2P   = MD_NWK_GR2  / MD_NWK_TOT
            if (MD_EXT_TOT>0)  MD_EXT_G2P   = MD_EXT_GR2  / MD_EXT_TOT
            if (MD_LT_TOT>0)   MD_LT_G2P    = MD_LT_GR2   / MD_LT_TOT
            if (MD_MD_TOT>0)   MD_MD_G2P    = MD_MD_GR2   / MD_MD_TOT
            if (MD_HV_TOT>0)   MD_HV_G2P    = MD_HV_GR2   / MD_HV_TOT
            if (PM_VOL_TOT>0)  PM_VOL_G2P   = PM_VOL_GR2  / PM_VOL_TOT
            if (PM_WRK_TOT>0)  PM_WRK_G2P   = PM_WRK_GR2  / PM_WRK_TOT
            if (PM_NWK_TOT>0)  PM_NWK_G2P   = PM_NWK_GR2  / PM_NWK_TOT
            if (PM_EXT_TOT>0)  PM_EXT_G2P   = PM_EXT_GR2  / PM_EXT_TOT
            if (PM_LT_TOT>0)   PM_LT_G2P    = PM_LT_GR2   / PM_LT_TOT
            if (PM_MD_TOT>0)   PM_MD_G2P    = PM_MD_GR2   / PM_MD_TOT
            if (PM_HV_TOT>0)   PM_HV_G2P    = PM_HV_GR2   / PM_HV_TOT
            if (EV_VOL_TOT>0)  EV_VOL_G2P   = EV_VOL_GR2  / EV_VOL_TOT
            if (EV_WRK_TOT>0)  EV_WRK_G2P   = EV_WRK_GR2  / EV_WRK_TOT
            if (EV_NWK_TOT>0)  EV_NWK_G2P   = EV_NWK_GR2  / EV_NWK_TOT
            if (EV_EXT_TOT>0)  EV_EXT_G2P   = EV_EXT_GR2  / EV_EXT_TOT
            if (EV_LT_TOT>0)   EV_LT_G2P    = EV_LT_GR2   / EV_LT_TOT
            if (EV_MD_TOT>0)   EV_MD_G2P    = EV_MD_GR2   / EV_MD_TOT
            if (EV_HV_TOT>0)   EV_HV_G2P    = EV_HV_GR2   / EV_HV_TOT
            if (DY_VOL_TOT>0)  DY_VOL_G2P   = DY_VOL_GR2  / DY_VOL_TOT
            if (DY_WRK_TOT>0)  DY_WRK_G2P   = DY_WRK_GR2  / DY_WRK_TOT
            if (DY_NWK_TOT>0)  DY_NWK_G2P   = DY_NWK_GR2  / DY_NWK_TOT
            if (DY_EXT_TOT>0)  DY_EXT_G2P   = DY_EXT_GR2  / DY_EXT_TOT
            if (DY_LT_TOT>0)   DY_LT_G2P    = DY_LT_GR2   / DY_LT_TOT
            if (DY_MD_TOT>0)   DY_MD_G2P    = DY_MD_GR2   / DY_MD_TOT
            if (DY_HV_TOT>0)   DY_HV_G2P    = DY_HV_GR2   / DY_HV_TOT
            
        ENDPHASE
        
    ENDRUN


    ;create final assigned summary network
    RUN PGM=NETWORK   MSG='Final Assign: create select link network with percentage max volume'
        FILEI NETI[1]  = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Assigned.net'
        
        FILEO NETO = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__SL_MaxVolume.net',
            INCLUDE=A              ,
                    B              ,
                    STREET         ,
                    DISTANCE       ,
                    ONEWAY         ,
                    TAZID          ,
                    SEGID          ,
                    LINKID         ,
                    LANES          ,
                    FT             ,
                    HOV_LYEAR      ,
                    HOT_ZONEID     ,
                    HOT_CHRGPT     ,
                    TRK_RSTRCT     ,
                    SFAC           ,
                    CFAC           ,
                    DISTEXCEPT     ,
                    AREATYPE       ,
                    ATYPENAME      ,
                    ATYPEGRP       ,
                    FTCLASS        ,
                    EXTERNAL       ,
                    LANE_MILE      ,
                    RMPGPID        ,
                    MANFWYID       ,
                    CAP1HR1LN      ,
                    RELCAP1HR      ,
                    ADHOVCAP1H     ,
                    ANGLE          ,
                    DIRECTION      ,
                    IB_OB          ,
                    PKDIRPRD       ,
                    REL_LN         ,
                    CBD            ,
                    COUNTY         ,
                    CO_TAZID       ,
                    CO_FIPS        ,
                    CO_NAME        ,
                    CITY           ,
                    CITY_FIPS      ,
                    CITY_NAME      ,
                    DISTLRG        ,
                    DLRG_NAME      ,
                    DISTMED        ,
                    DMED_NAME      ,
                    DISTSML        ,
                    DSML_NAME      ,
                    WARNL          ,
                    WARNLTXT       ,
                    OP_PROJ        ,
                    SEL_LINK       ,
                    @AddLinkFields@,
                    SUBAREAID      ,
                    FF_RAMPPEN     ,
                    AM_RAMPPEN     ,
                    MD_RAMPPEN     ,
                    PM_RAMPPEN     ,
                    EV_RAMPPEN     ,
                    HOT_CHRGAM     ,
                    HOT_CHRGMD     ,
                    HOT_CHRGPM     ,
                    HOT_CHRGEV     ,
                    AM_CAP         ,
                    MD_CAP         ,
                    PM_CAP         ,
                    EV_CAP         ,
                    AM_VC          ,
                    MD_VC          ,
                    PM_VC          ,
                    EV_VC          ,
                    FF_SPD         ,
                    AM_SPD         ,
                    MD_SPD         ,
                    PM_SPD         ,
                    EV_SPD         ,
                    DY_SPD         ,
                    FF_TIME        ,
                    AM_TIME        ,
                    MD_TIME        ,
                    PM_TIME        ,
                    EV_TIME        ,
                    DY_TIME        ,
                    
                    AM_VOL_TOT     , AM_WRK_TOT  , AM_NWK_TOT  , AM_EXT_TOT  , AM_LT_TOT   , AM_MD_TOT   , AM_HV_TOT   ,
                    MD_VOL_TOT     , MD_WRK_TOT  , MD_NWK_TOT  , MD_EXT_TOT  , MD_LT_TOT   , MD_MD_TOT   , MD_HV_TOT   ,
                    PM_VOL_TOT     , PM_WRK_TOT  , PM_NWK_TOT  , PM_EXT_TOT  , PM_LT_TOT   , PM_MD_TOT   , PM_HV_TOT   ,
                    EV_VOL_TOT     , EV_WRK_TOT  , EV_NWK_TOT  , EV_EXT_TOT  , EV_LT_TOT   , EV_MD_TOT   , EV_HV_TOT   ,
                    DY_VOL_TOT     , DY_WRK_TOT  , DY_NWK_TOT  , DY_EXT_TOT  , DY_LT_TOT   , DY_MD_TOT   , DY_HV_TOT   ,
                    
                    AM_VOL_GR1     , AM_WRK_GR1  , AM_NWK_GR1  , AM_EXT_GR1  , AM_LT_GR1   , AM_MD_GR1   , AM_HV_GR1   ,
                    MD_VOL_GR1     , MD_WRK_GR1  , MD_NWK_GR1  , MD_EXT_GR1  , MD_LT_GR1   , MD_MD_GR1   , MD_HV_GR1   ,
                    PM_VOL_GR1     , PM_WRK_GR1  , PM_NWK_GR1  , PM_EXT_GR1  , PM_LT_GR1   , PM_MD_GR1   , PM_HV_GR1   ,
                    EV_VOL_GR1     , EV_WRK_GR1  , EV_NWK_GR1  , EV_EXT_GR1  , EV_LT_GR1   , EV_MD_GR1   , EV_HV_GR1   ,
                    DY_VOL_GR1     , DY_WRK_GR1  , DY_NWK_GR1  , DY_EXT_GR1  , DY_LT_GR1   , DY_MD_GR1   , DY_HV_GR1   ,
                    
                    AM_VOL_GR2     , AM_WRK_GR2  , AM_NWK_GR2  , AM_EXT_GR2  , AM_LT_GR2   , AM_MD_GR2   , AM_HV_GR2   ,
                    MD_VOL_GR2     , MD_WRK_GR2  , MD_NWK_GR2  , MD_EXT_GR2  , MD_LT_GR2   , MD_MD_GR2   , MD_HV_GR2   ,
                    PM_VOL_GR2     , PM_WRK_GR2  , PM_NWK_GR2  , PM_EXT_GR2  , PM_LT_GR2   , PM_MD_GR2   , PM_HV_GR2   ,
                    EV_VOL_GR2     , EV_WRK_GR2  , EV_NWK_GR2  , EV_EXT_GR2  , EV_LT_GR2   , EV_MD_GR2   , EV_HV_GR2   ,
                    DY_VOL_GR2     , DY_WRK_GR2  , DY_NWK_GR2  , DY_EXT_GR2  , DY_LT_GR2   , DY_MD_GR2   , DY_HV_GR2   ,
                    
                    AM_VOL_G1P     , AM_WRK_G1P  , AM_NWK_G1P  , AM_EXT_G1P  , AM_LT_G1P   , AM_MD_G1P   , AM_HV_G1P   ,
                    MD_VOL_G1P     , MD_WRK_G1P  , MD_NWK_G1P  , MD_EXT_G1P  , MD_LT_G1P   , MD_MD_G1P   , MD_HV_G1P   ,
                    PM_VOL_G1P     , PM_WRK_G1P  , PM_NWK_G1P  , PM_EXT_G1P  , PM_LT_G1P   , PM_MD_G1P   , PM_HV_G1P   ,
                    EV_VOL_G1P     , EV_WRK_G1P  , EV_NWK_G1P  , EV_EXT_G1P  , EV_LT_G1P   , EV_MD_G1P   , EV_HV_G1P   ,
                    DY_VOL_G1P     , DY_WRK_G1P  , DY_NWK_G1P  , DY_EXT_G1P  , DY_LT_G1P   , DY_MD_G1P   , DY_HV_G1P   ,
                    
                    AM_VOL_G2P     , AM_WRK_G2P  , AM_NWK_G2P  , AM_EXT_G2P  , AM_LT_G2P   , AM_MD_G2P   , AM_HV_G2P   ,
                    MD_VOL_G2P     , MD_WRK_G2P  , MD_NWK_G2P  , MD_EXT_G2P  , MD_LT_G2P   , MD_MD_G2P   , MD_HV_G2P   ,
                    PM_VOL_G2P     , PM_WRK_G2P  , PM_NWK_G2P  , PM_EXT_G2P  , PM_LT_G2P   , PM_MD_G2P   , PM_HV_G2P   ,
                    EV_VOL_G2P     , EV_WRK_G2P  , EV_NWK_G2P  , EV_EXT_G2P  , EV_LT_G2P   , EV_MD_G2P   , EV_HV_G2P   ,
                    DY_VOL_G2P     , DY_WRK_G2P  , DY_NWK_G2P  , DY_EXT_G2P  , DY_LT_G2P   , DY_MD_G2P   , DY_HV_G2P   
        
        
        ;parameters
        ZONES = @UsedZones@
        
        ;loop through all link records and determine the volume of the selected link (maximum)
        PHASE=INPUT, FILEI=li.1
            
            ;select link group 1
            _AM_VOL_MAX_GR1 = MAX(_AM_VOL_MAX_GR1 , AM_VOL_GR1)
            _AM_WRK_MAX_GR1 = MAX(_AM_WRK_MAX_GR1 , AM_WRK_GR1)
            _AM_NWK_MAX_GR1 = MAX(_AM_NWK_MAX_GR1 , AM_NWK_GR1)
            _AM_EXT_MAX_GR1 = MAX(_AM_EXT_MAX_GR1 , AM_EXT_GR1)
            _AM_LT_MAX_GR1  = MAX(_AM_LT_MAX_GR1  , AM_LT_GR1 )
            _AM_MD_MAX_GR1  = MAX(_AM_MD_MAX_GR1  , AM_MD_GR1 )
            _AM_HV_MAX_GR1  = MAX(_AM_HV_MAX_GR1  , AM_HV_GR1 )
            _MD_VOL_MAX_GR1 = MAX(_MD_VOL_MAX_GR1 , MD_VOL_GR1)
            _MD_WRK_MAX_GR1 = MAX(_MD_WRK_MAX_GR1 , MD_WRK_GR1)
            _MD_NWK_MAX_GR1 = MAX(_MD_NWK_MAX_GR1 , MD_NWK_GR1)
            _MD_EXT_MAX_GR1 = MAX(_MD_EXT_MAX_GR1 , MD_EXT_GR1)
            _MD_LT_MAX_GR1  = MAX(_MD_LT_MAX_GR1  , MD_LT_GR1 )
            _MD_MD_MAX_GR1  = MAX(_MD_MD_MAX_GR1  , MD_MD_GR1 )
            _MD_HV_MAX_GR1  = MAX(_MD_HV_MAX_GR1  , MD_HV_GR1 )
            _PM_VOL_MAX_GR1 = MAX(_PM_VOL_MAX_GR1 , PM_VOL_GR1)
            _PM_WRK_MAX_GR1 = MAX(_PM_WRK_MAX_GR1 , PM_WRK_GR1)
            _PM_NWK_MAX_GR1 = MAX(_PM_NWK_MAX_GR1 , PM_NWK_GR1)
            _PM_EXT_MAX_GR1 = MAX(_PM_EXT_MAX_GR1 , PM_EXT_GR1)
            _PM_LT_MAX_GR1  = MAX(_PM_LT_MAX_GR1  , PM_LT_GR1 )
            _PM_MD_MAX_GR1  = MAX(_PM_MD_MAX_GR1  , PM_MD_GR1 )
            _PM_HV_MAX_GR1  = MAX(_PM_HV_MAX_GR1  , PM_HV_GR1 )
            _EV_VOL_MAX_GR1 = MAX(_EV_VOL_MAX_GR1 , EV_VOL_GR1)
            _EV_WRK_MAX_GR1 = MAX(_EV_WRK_MAX_GR1 , EV_WRK_GR1)
            _EV_NWK_MAX_GR1 = MAX(_EV_NWK_MAX_GR1 , EV_NWK_GR1)
            _EV_EXT_MAX_GR1 = MAX(_EV_EXT_MAX_GR1 , EV_EXT_GR1)
            _EV_LT_MAX_GR1  = MAX(_EV_LT_MAX_GR1  , EV_LT_GR1 )
            _EV_MD_MAX_GR1  = MAX(_EV_MD_MAX_GR1  , EV_MD_GR1 )
            _EV_HV_MAX_GR1  = MAX(_EV_HV_MAX_GR1  , EV_HV_GR1 )
            _DY_VOL_MAX_GR1 = MAX(_DY_VOL_MAX_GR1 , DY_VOL_GR1)
            _DY_WRK_MAX_GR1 = MAX(_DY_WRK_MAX_GR1 , DY_WRK_GR1)
            _DY_NWK_MAX_GR1 = MAX(_DY_NWK_MAX_GR1 , DY_NWK_GR1)
            _DY_EXT_MAX_GR1 = MAX(_DY_EXT_MAX_GR1 , DY_EXT_GR1)
            _DY_LT_MAX_GR1  = MAX(_DY_LT_MAX_GR1  , DY_LT_GR1 )
            _DY_MD_MAX_GR1  = MAX(_DY_MD_MAX_GR1  , DY_MD_GR1 )
            _DY_HV_MAX_GR1  = MAX(_DY_HV_MAX_GR1  , DY_HV_GR1 )
            
            ;select link group 2
            _AM_VOL_MAX_GR2 = MAX(_AM_VOL_MAX_GR2 , AM_VOL_GR2)
            _AM_WRK_MAX_GR2 = MAX(_AM_WRK_MAX_GR2 , AM_WRK_GR2)
            _AM_NWK_MAX_GR2 = MAX(_AM_NWK_MAX_GR2 , AM_NWK_GR2)
            _AM_EXT_MAX_GR2 = MAX(_AM_EXT_MAX_GR2 , AM_EXT_GR2)
            _AM_LT_MAX_GR2  = MAX(_AM_LT_MAX_GR2  , AM_LT_GR2 )
            _AM_MD_MAX_GR2  = MAX(_AM_MD_MAX_GR2  , AM_MD_GR2 )
            _AM_HV_MAX_GR2  = MAX(_AM_HV_MAX_GR2  , AM_HV_GR2 )
            _MD_VOL_MAX_GR2 = MAX(_MD_VOL_MAX_GR2 , MD_VOL_GR2)
            _MD_WRK_MAX_GR2 = MAX(_MD_WRK_MAX_GR2 , MD_WRK_GR2)
            _MD_NWK_MAX_GR2 = MAX(_MD_NWK_MAX_GR2 , MD_NWK_GR2)
            _MD_EXT_MAX_GR2 = MAX(_MD_EXT_MAX_GR2 , MD_EXT_GR2)
            _MD_LT_MAX_GR2  = MAX(_MD_LT_MAX_GR2  , MD_LT_GR2 )
            _MD_MD_MAX_GR2  = MAX(_MD_MD_MAX_GR2  , MD_MD_GR2 )
            _MD_HV_MAX_GR2  = MAX(_MD_HV_MAX_GR2  , MD_HV_GR2 )
            _PM_VOL_MAX_GR2 = MAX(_PM_VOL_MAX_GR2 , PM_VOL_GR2)
            _PM_WRK_MAX_GR2 = MAX(_PM_WRK_MAX_GR2 , PM_WRK_GR2)
            _PM_NWK_MAX_GR2 = MAX(_PM_NWK_MAX_GR2 , PM_NWK_GR2)
            _PM_EXT_MAX_GR2 = MAX(_PM_EXT_MAX_GR2 , PM_EXT_GR2)
            _PM_LT_MAX_GR2  = MAX(_PM_LT_MAX_GR2  , PM_LT_GR2 )
            _PM_MD_MAX_GR2  = MAX(_PM_MD_MAX_GR2  , PM_MD_GR2 )
            _PM_HV_MAX_GR2  = MAX(_PM_HV_MAX_GR2  , PM_HV_GR2 )
            _EV_VOL_MAX_GR2 = MAX(_EV_VOL_MAX_GR2 , EV_VOL_GR2)
            _EV_WRK_MAX_GR2 = MAX(_EV_WRK_MAX_GR2 , EV_WRK_GR2)
            _EV_NWK_MAX_GR2 = MAX(_EV_NWK_MAX_GR2 , EV_NWK_GR2)
            _EV_EXT_MAX_GR2 = MAX(_EV_EXT_MAX_GR2 , EV_EXT_GR2)
            _EV_LT_MAX_GR2  = MAX(_EV_LT_MAX_GR2  , EV_LT_GR2 )
            _EV_MD_MAX_GR2  = MAX(_EV_MD_MAX_GR2  , EV_MD_GR2 )
            _EV_HV_MAX_GR2  = MAX(_EV_HV_MAX_GR2  , EV_HV_GR2 )
            _DY_VOL_MAX_GR2 = MAX(_DY_VOL_MAX_GR2 , DY_VOL_GR2)
            _DY_WRK_MAX_GR2 = MAX(_DY_WRK_MAX_GR2 , DY_WRK_GR2)
            _DY_NWK_MAX_GR2 = MAX(_DY_NWK_MAX_GR2 , DY_NWK_GR2)
            _DY_EXT_MAX_GR2 = MAX(_DY_EXT_MAX_GR2 , DY_EXT_GR2)
            _DY_LT_MAX_GR2  = MAX(_DY_LT_MAX_GR2  , DY_LT_GR2 )
            _DY_MD_MAX_GR2  = MAX(_DY_MD_MAX_GR2  , DY_MD_GR2 )
            _DY_HV_MAX_GR2  = MAX(_DY_HV_MAX_GR2  , DY_HV_GR2 )
            
        ENDPHASE
        

        PHASE=LINKMERGE
            
            ;calculate am total volume by volume class
            AM_WRK_TOT = AM_HBW
            AM_NWK_TOT = AM_HBO   +
                         AM_NHB   +
                         AM_HBC   +
                         AM_HBS_P +
                         AM_HBS_S
            AM_EXT_TOT = AM_EXT
            AM_LT_TOT  = AM_SLT
            AM_MD_TOT  = AM_SMD   +
                         AM_LMD
            AM_HV_TOT  = AM_SHV   +
                         AM_LHV
            AM_VOL_TOT = AM_VOL
            
            ;calculate md total volume by volume class
            MD_WRK_TOT = MD_HBW
            MD_NWK_TOT = MD_HBO   +
                         MD_NHB   +
                         MD_HBC   +
                         MD_HBS_P +
                         MD_HBS_S
            MD_EXT_TOT = MD_EXT
            MD_LT_TOT  = MD_SLT
            MD_MD_TOT  = MD_SMD   +
                         MD_LMD
            MD_HV_TOT  = MD_SHV   +
                         MD_LHV
            MD_VOL_TOT = MD_VOL
            
            ;calculate pm total volume by volume class
            PM_WRK_TOT = PM_HBW
            PM_NWK_TOT = PM_HBO   +
                         PM_NHB   +
                         PM_HBC   +
                         PM_HBS_P +
                         PM_HBS_S
            PM_EXT_TOT = PM_EXT
            PM_LT_TOT  = PM_SLT
            PM_MD_TOT  = PM_SMD   +
                         PM_LMD
            PM_HV_TOT  = PM_SHV   +
                         PM_LHV
            PM_VOL_TOT = PM_VOL
            
            ;calculate pm total volume by volume class
            EV_WRK_TOT = EV_HBW
            EV_NWK_TOT = EV_HBO   +
                         EV_NHB   +
                         EV_HBC   +
                         EV_HBS_P +
                         EV_HBS_S
            EV_EXT_TOT = EV_EXT
            EV_LT_TOT  = EV_SLT
            EV_MD_TOT  = EV_SMD   +
                         EV_LMD
            EV_HV_TOT  = EV_SHV   +
                         EV_LHV
            EV_VOL_TOT = EV_VOL
            
            ;calculate dy total volume by volume class
            DY_VOL_TOT   = AM_VOL_TOT + MD_VOL_TOT + PM_VOL_TOT + EV_VOL_TOT
            DY_WRK_TOT   = AM_WRK_TOT + MD_WRK_TOT + PM_WRK_TOT + EV_WRK_TOT
            DY_NWK_TOT   = AM_NWK_TOT + MD_NWK_TOT + PM_NWK_TOT + EV_NWK_TOT
            DY_EXT_TOT   = AM_EXT_TOT + MD_EXT_TOT + PM_EXT_TOT + EV_EXT_TOT
            DY_LT_TOT    = AM_LT_TOT  + MD_LT_TOT  + PM_LT_TOT  + EV_LT_TOT
            DY_MD_TOT    = AM_MD_TOT  + MD_MD_TOT  + PM_MD_TOT  + EV_MD_TOT
            DY_HV_TOT    = AM_HV_TOT  + MD_HV_TOT  + PM_HV_TOT  + EV_HV_TOT
            
            ;calcule the percentage of the portion of the select link's volume on each link as a ratio to the volume of the selected link
            ;select link group 1
            if (_AM_VOL_MAX_GR1>0)  AM_VOL_G1P   = AM_VOL_GR1  / _AM_VOL_MAX_GR1
            if (_AM_WRK_MAX_GR1>0)  AM_WRK_G1P   = AM_WRK_GR1  / _AM_WRK_MAX_GR1
            if (_AM_NWK_MAX_GR1>0)  AM_NWK_G1P   = AM_NWK_GR1  / _AM_NWK_MAX_GR1
            if (_AM_EXT_MAX_GR1>0)  AM_EXT_G1P   = AM_EXT_GR1  / _AM_EXT_MAX_GR1
            if (_AM_LT_MAX_GR1>0)   AM_LT_G1P    = AM_LT_GR1   / _AM_LT_MAX_GR1
            if (_AM_MD_MAX_GR1>0)   AM_MD_G1P    = AM_MD_GR1   / _AM_MD_MAX_GR1
            if (_AM_HV_MAX_GR1>0)   AM_HV_G1P    = AM_HV_GR1   / _AM_HV_MAX_GR1
            if (_MD_VOL_MAX_GR1>0)  MD_VOL_G1P   = MD_VOL_GR1  / _MD_VOL_MAX_GR1
            if (_MD_WRK_MAX_GR1>0)  MD_WRK_G1P   = MD_WRK_GR1  / _MD_WRK_MAX_GR1
            if (_MD_NWK_MAX_GR1>0)  MD_NWK_G1P   = MD_NWK_GR1  / _MD_NWK_MAX_GR1
            if (_MD_EXT_MAX_GR1>0)  MD_EXT_G1P   = MD_EXT_GR1  / _MD_EXT_MAX_GR1
            if (_MD_LT_MAX_GR1>0)   MD_LT_G1P    = MD_LT_GR1   / _MD_LT_MAX_GR1
            if (_MD_MD_MAX_GR1>0)   MD_MD_G1P    = MD_MD_GR1   / _MD_MD_MAX_GR1
            if (_MD_HV_MAX_GR1>0)   MD_HV_G1P    = MD_HV_GR1   / _MD_HV_MAX_GR1
            if (_PM_VOL_MAX_GR1>0)  PM_VOL_G1P   = PM_VOL_GR1  / _PM_VOL_MAX_GR1
            if (_PM_WRK_MAX_GR1>0)  PM_WRK_G1P   = PM_WRK_GR1  / _PM_WRK_MAX_GR1
            if (_PM_NWK_MAX_GR1>0)  PM_NWK_G1P   = PM_NWK_GR1  / _PM_NWK_MAX_GR1
            if (_PM_EXT_MAX_GR1>0)  PM_EXT_G1P   = PM_EXT_GR1  / _PM_EXT_MAX_GR1
            if (_PM_LT_MAX_GR1>0)   PM_LT_G1P    = PM_LT_GR1   / _PM_LT_MAX_GR1
            if (_PM_MD_MAX_GR1>0)   PM_MD_G1P    = PM_MD_GR1   / _PM_MD_MAX_GR1
            if (_PM_HV_MAX_GR1>0)   PM_HV_G1P    = PM_HV_GR1   / _PM_HV_MAX_GR1
            if (_EV_VOL_MAX_GR1>0)  EV_VOL_G1P   = EV_VOL_GR1  / _EV_VOL_MAX_GR1
            if (_EV_WRK_MAX_GR1>0)  EV_WRK_G1P   = EV_WRK_GR1  / _EV_WRK_MAX_GR1
            if (_EV_NWK_MAX_GR1>0)  EV_NWK_G1P   = EV_NWK_GR1  / _EV_NWK_MAX_GR1
            if (_EV_EXT_MAX_GR1>0)  EV_EXT_G1P   = EV_EXT_GR1  / _EV_EXT_MAX_GR1
            if (_EV_LT_MAX_GR1>0)   EV_LT_G1P    = EV_LT_GR1   / _EV_LT_MAX_GR1
            if (_EV_MD_MAX_GR1>0)   EV_MD_G1P    = EV_MD_GR1   / _EV_MD_MAX_GR1
            if (_EV_HV_MAX_GR1>0)   EV_HV_G1P    = EV_HV_GR1   / _EV_HV_MAX_GR1
            if (_DY_VOL_MAX_GR1>0)  DY_VOL_G1P   = DY_VOL_GR1  / _DY_VOL_MAX_GR1
            if (_DY_WRK_MAX_GR1>0)  DY_WRK_G1P   = DY_WRK_GR1  / _DY_WRK_MAX_GR1
            if (_DY_NWK_MAX_GR1>0)  DY_NWK_G1P   = DY_NWK_GR1  / _DY_NWK_MAX_GR1
            if (_DY_EXT_MAX_GR1>0)  DY_EXT_G1P   = DY_EXT_GR1  / _DY_EXT_MAX_GR1
            if (_DY_LT_MAX_GR1>0)   DY_LT_G1P    = DY_LT_GR1   / _DY_LT_MAX_GR1
            if (_DY_MD_MAX_GR1>0)   DY_MD_G1P    = DY_MD_GR1   / _DY_MD_MAX_GR1
            if (_DY_HV_MAX_GR1>0)   DY_HV_G1P    = DY_HV_GR1   / _DY_HV_MAX_GR1
            
            ;select link group 2
            if (_AM_VOL_MAX_GR2>0)  AM_VOL_G2P   = AM_VOL_GR2  / _AM_VOL_MAX_GR2
            if (_AM_WRK_MAX_GR2>0)  AM_WRK_G2P   = AM_WRK_GR2  / _AM_WRK_MAX_GR2
            if (_AM_NWK_MAX_GR2>0)  AM_NWK_G2P   = AM_NWK_GR2  / _AM_NWK_MAX_GR2
            if (_AM_EXT_MAX_GR2>0)  AM_EXT_G2P   = AM_EXT_GR2  / _AM_EXT_MAX_GR2
            if (_AM_LT_MAX_GR2>0)   AM_LT_G2P    = AM_LT_GR2   / _AM_LT_MAX_GR2
            if (_AM_MD_MAX_GR2>0)   AM_MD_G2P    = AM_MD_GR2   / _AM_MD_MAX_GR2
            if (_AM_HV_MAX_GR2>0)   AM_HV_G2P    = AM_HV_GR2   / _AM_HV_MAX_GR2
            if (_MD_VOL_MAX_GR2>0)  MD_VOL_G2P   = MD_VOL_GR2  / _MD_VOL_MAX_GR2
            if (_MD_WRK_MAX_GR2>0)  MD_WRK_G2P   = MD_WRK_GR2  / _MD_WRK_MAX_GR2
            if (_MD_NWK_MAX_GR2>0)  MD_NWK_G2P   = MD_NWK_GR2  / _MD_NWK_MAX_GR2
            if (_MD_EXT_MAX_GR2>0)  MD_EXT_G2P   = MD_EXT_GR2  / _MD_EXT_MAX_GR2
            if (_MD_LT_MAX_GR2>0)   MD_LT_G2P    = MD_LT_GR2   / _MD_LT_MAX_GR2
            if (_MD_MD_MAX_GR2>0)   MD_MD_G2P    = MD_MD_GR2   / _MD_MD_MAX_GR2
            if (_MD_HV_MAX_GR2>0)   MD_HV_G2P    = MD_HV_GR2   / _MD_HV_MAX_GR2
            if (_PM_VOL_MAX_GR2>0)  PM_VOL_G2P   = PM_VOL_GR2  / _PM_VOL_MAX_GR2
            if (_PM_WRK_MAX_GR2>0)  PM_WRK_G2P   = PM_WRK_GR2  / _PM_WRK_MAX_GR2
            if (_PM_NWK_MAX_GR2>0)  PM_NWK_G2P   = PM_NWK_GR2  / _PM_NWK_MAX_GR2
            if (_PM_EXT_MAX_GR2>0)  PM_EXT_G2P   = PM_EXT_GR2  / _PM_EXT_MAX_GR2
            if (_PM_LT_MAX_GR2>0)   PM_LT_G2P    = PM_LT_GR2   / _PM_LT_MAX_GR2
            if (_PM_MD_MAX_GR2>0)   PM_MD_G2P    = PM_MD_GR2   / _PM_MD_MAX_GR2
            if (_PM_HV_MAX_GR2>0)   PM_HV_G2P    = PM_HV_GR2   / _PM_HV_MAX_GR2
            if (_EV_VOL_MAX_GR2>0)  EV_VOL_G2P   = EV_VOL_GR2  / _EV_VOL_MAX_GR2
            if (_EV_WRK_MAX_GR2>0)  EV_WRK_G2P   = EV_WRK_GR2  / _EV_WRK_MAX_GR2
            if (_EV_NWK_MAX_GR2>0)  EV_NWK_G2P   = EV_NWK_GR2  / _EV_NWK_MAX_GR2
            if (_EV_EXT_MAX_GR2>0)  EV_EXT_G2P   = EV_EXT_GR2  / _EV_EXT_MAX_GR2
            if (_EV_LT_MAX_GR2>0)   EV_LT_G2P    = EV_LT_GR2   / _EV_LT_MAX_GR2
            if (_EV_MD_MAX_GR2>0)   EV_MD_G2P    = EV_MD_GR2   / _EV_MD_MAX_GR2
            if (_EV_HV_MAX_GR2>0)   EV_HV_G2P    = EV_HV_GR2   / _EV_HV_MAX_GR2
            if (_DY_VOL_MAX_GR2>0)  DY_VOL_G2P   = DY_VOL_GR2  / _DY_VOL_MAX_GR2
            if (_DY_WRK_MAX_GR2>0)  DY_WRK_G2P   = DY_WRK_GR2  / _DY_WRK_MAX_GR2
            if (_DY_NWK_MAX_GR2>0)  DY_NWK_G2P   = DY_NWK_GR2  / _DY_NWK_MAX_GR2
            if (_DY_EXT_MAX_GR2>0)  DY_EXT_G2P   = DY_EXT_GR2  / _DY_EXT_MAX_GR2
            if (_DY_LT_MAX_GR2>0)   DY_LT_G2P    = DY_LT_GR2   / _DY_LT_MAX_GR2
            if (_DY_MD_MAX_GR2>0)   DY_MD_G2P    = DY_MD_GR2   / _DY_MD_MAX_GR2
            if (_DY_HV_MAX_GR2>0)   DY_HV_G2P    = DY_HV_GR2   / _DY_HV_MAX_GR2
            
        ENDPHASE
        
    ENDRUN
    
endif  ;Use_SelLinkGrp=1



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Summarize Loaded Networks          ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



*(del 04_SummarizeLoadedNetworks.txt)
