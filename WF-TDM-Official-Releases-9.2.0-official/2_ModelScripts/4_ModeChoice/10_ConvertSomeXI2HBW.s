
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 10_ConvertSomeXI2HBW.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX   MSG='Mode Choice 10: convert some XI trips to HBW trips'

    FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_AllPurp.2.DestChoice.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_hbw_2veh_pk_noXI.mtx'             ;Peak HBW trips by income
    FILEI MATI[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_hbw_2veh_ok_noXI.mtx'             ;Off Peak HBW trips by income 
    
    FILEI MATI[4]='@ParentDir@@ScenarioDir@0_InputProcessing\AddTripTable.mtx' 
    
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_xi_adj.mtx', 
        MO=210,
        NAME=XI
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_hbw_2veh_pk.mtx', 
        MO=41,42, 
        NAME=2veh_lowinc, 
             2veh_highinc
    
    FILEO MATO[3] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\pa_hbw_2veh_ok.mtx', 
        MO=43,44, 
        NAME=2veh_lowinc, 
             2veh_highinc
  
    ;Write PA_AllPurp.mtx with all final adjustments to the  directory
    FILEO MATO[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx', 
    mo=100-116, 120-124, 130-133, 141-146, 150-157, 200-202, 300-302,
    name=TOT         ,
         HBW         ,
         HBShp       ,
         HBOth       ,
         HBSch_Pr    ,
         HBSch_Sc    ,
         HBC         ,
         NHBW        ,
         NHBNW       ,
         IX          ,
         XI          ,
         XX          ,
         SH_LT       ,
         SH_MD       ,
         SH_HV       ,
         Ext_MD      ,
         Ext_HV      ,
         
         HBSch       ,
         HBO         ,
         NHB         ,
         TTUNIQUE    ,
         HBOthnTT    ,
         
         Tot_HBW     ,
         Tel_HBW     ,
         Tot_NHBW    ,
         Tel_NHBW    ,
         
         IX_MD       ,
         XI_MD       ,
         XX_MD       ,
         IX_HV       ,
         XI_HV       ,
         XX_HV       ,
         
         D_TOT       ,         ;original values from distribution
         D_HBW       ,
         D_Tot_HBW   ,
         D_Tel_HBW   ,
         dif_TOT     ,
         dif_HBW     ,
         dif_Tot_HBW ,
         dif_Tel_HBW ,
         
         DC_TOT      ,         ;original values from destination choice
         DC_HBW      ,
         DC_XI       ,
         dif_DC_TOT  ,
         dif_DC_HBW  ,
         dif_DC_XI   
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
    
    
    
    ;destination choice output trip table
    mw[102] = mi.1.HBShp
    mw[103] = mi.1.HBOth
    mw[104] = mi.1.HBSch_Pr
    mw[105] = mi.1.HBSch_Sc
    mw[106] = mi.1.HBC
    mw[107] = mi.1.NHBW
    mw[108] = mi.1.NHBNW
    mw[109] = mi.1.IX
    
    mw[111] = mi.1.XX
    mw[112] = mi.1.SH_LT
    mw[113] = mi.1.SH_MD
    mw[114] = mi.1.SH_HV
    mw[115] = mi.1.Ext_MD
    mw[116] = mi.1.Ext_HV
    
    mw[120] = mi.1.HBSch
    mw[121] = mi.1.HBO
    mw[122] = mi.1.NHB
    mw[123] = mi.1.TTUNIQUE
    mw[124] = mi.1.HBOthnTT
    
    mw[130] = mi.1.Tot_HBW
    mw[131] = mi.1.Tel_HBW
    mw[132] = mi.1.Tot_NHBW
    mw[133] = mi.1.Tel_NHBW

    ;IX, XI & XX Truck
    mw[141] = mi.1.IX_MD
    mw[142] = mi.1.XI_MD
    mw[143] = mi.1.XX_MD
    mw[144] = mi.1.IX_HV
    mw[145] = mi.1.XI_HV
    mw[146] = mi.1.XX_HV
    
    mw[150] = mi.1.D_TOT
    mw[151] = mi.1.D_HBW
    mw[152] = mi.1.D_Tot_HBW
    mw[153] = mi.1.D_Tel_HBW
    mw[154] = mi.1.dif_TOT
    mw[155] = mi.1.dif_HBW
    mw[156] = mi.1.dif_Tot_HBW
    mw[157] = mi.1.dif_Tel_HBW
    
    
    ;store original destination choice values
    mw[200] = mi.1.TOT
    mw[201] = mi.1.HBW
    mw[202] = mi.1.XI 
    
    
    ;read in HBW veh trips (peak/off-peak, inc lo/hi)
    mw[21] = mi.2.2veh_lowinc
    mw[22] = mi.2.2veh_highinc
    
    mw[23] = mi.3.2veh_lowinc
    mw[24] = mi.3.2veh_highinc
    
    
    
    ;calculate share of XI trips to add to HBW trips
    ; Concept:  Mick has info that from Box Elder, more HBW trips
    ; go the SLC area (generally zones 500-1200) than you might think.  So
    ; he raises it to 50% of XI's going to SLC area are HBW( Jon and Andy remembered that the survey shows the XI short distiance is for hbw), whereas
    ; only 21% of XI's going to other places are HBW.  25% is
    ; assumed HBW for all XI's at other externals.
    ;
    ; base year external trips are consistent with base year vehicle trips
    ; when external are converted to HBW, the HBW model expects person trips
    ; multiply converted external trips by 1.1 to approximate HBW vehicle occupancy and convert to person trips
    ;
    ; Note: parameters in this script have not been checked
    
    ;assumed share of XI trips that are HBW
    XI_HBW_Share = 0.25
    
    if (i=@NorthBC@)  XI_HBW_Share = 0.21
    
    
    ;calcualte portion of XI trips to convert to HBW & remove from XI total (in vehicle trips)
    mw[302] = mw[202] * XI_HBW_Share
    
    mw[110] = mw[202] - mw[302]
    
    
    
    ;convert XI-HBW vehicle trips to person trips & add to HBW trips
    mw[301] = mw[302] * @VehOcc_HBW@
    
    mw[101] = mw[201] + mw[301]
    
    
    
    ;calculate adjusted total trips
    mw[100] = mw[101] +                 ;HBW (adjusted)
              mw[102] +                 ;HBShp   
              mw[103] +                 ;HBOth   
              mw[104] +                 ;HBSch_Pr
              mw[105] +                 ;HBSch_Sc
              mw[106] +                 ;HBC     
              mw[107] +                 ;NHBW    
              mw[108] +                 ;NHBNW   
              mw[109] +                 ;IX      
              mw[110] +                 ;XI (adjusted)
              mw[111] +                 ;XX      
              mw[112] +                 ;SH_LT   
              mw[113] +                 ;SH_MD   
              mw[114] +                 ;SH_HV   
              mw[115] +                 ;Ext_MD  
              mw[116]                   ;Ext_HV  
    
    
    ;calculate difference in total trips from destination choice
    mw[300] = mw[100] - mw[200]
    
    
    
    ;Set up %'s for mode choice
    Fac_Pk_Lo = 0.08          ; 8% of 2veh HBW is low inc in the peak
    Fac_Pk_Hi = 0.57          ;57% of 2veh HBW is high inc in the peak
    
    Fac_Ok_Lo = 0.04          ; 4% of 2veh HBW is low inc in the off-peak
    Fac_Ok_Hi = 0.31          ;31% of 2veh HBW is high inc in the off-peak
    
    
    ;separate into peak/off-peak & inc lo/hi
    mw[31] = mw[301] * Fac_Pk_Lo
    mw[32] = mw[301] * Fac_Pk_Hi
    
    mw[33] = mw[301] * Fac_Ok_Lo
    mw[34] = mw[301] * Fac_Ok_Hi
    
    
    ;add converted HBW person trips to HBW 2veh from destination choice
    ;peak
    mw[41] = mw[21] + mw[31]    ;lo inc
    mw[42] = mw[22] + mw[32]    ;hi inc
    
    ;off-peak
    mw[43] = mw[23] + mw[33]    ;lo inc
    mw[44] = mw[24] + mw[34]    ;hi inc
    
ENDRUN



;Summarize Final PA Table
RUN PGM=MATRIX  MSG='Mode Choice 10: Summarize Final PA Trip Table'

    ;copy out averaged P/A matrices (for use in Mode Choice or Assign w/o Mode Choice)
    FILEI MATI[1]='@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx' 
        
    FILEO RECO[1]='@ParentDir@@ScenarioDir@4_ModeChoice\_checkPABalance.dbf', 
        FORM=10.1,
        FIELDS=Z(10.0),
             TotPer_P,    TotPer_A,
                HBW_P,       HBW_A,
              HBShp_P,     HBShp_A,
              HBOth_P,     HBOth_A,
           HBSch_Pr_P,  HBSch_Pr_A,
           HBSch_Sc_P,  HBSch_Sc_A,
                HBC_P,       HBC_A,
               NHBW_P,      NHBW_A,
              NHBNW_P,     NHBNW_A,
              
             TotExt_P,    TotExt_A,
                 IX_P,        IX_A,
                 XI_P,        XI_A,
                 XX_P,        XX_A,
                 
             TotTrk_P,    TotTrk_A,
              SH_LT_P,     SH_LT_A,
              SH_MD_P,     SH_MD_A,
              SH_HV_P,     SH_HV_A,
             Ext_MD_P,    Ext_MD_A,
             Ext_HV_P,    Ext_HV_A,
             
              HBSch_P,     HBSch_A,
                HBO_P,       HBO_A,
                NHB_P,       NHB_A,
           TTUNIQUE_P,  TTUNIQUE_A,
           HBOthnTT_P,  HBOthnTT_A,
                
            Tot_HBW_P,   Tot_HBW_A,
            Tel_HBW_P,   Tel_HBW_A,
           Tot_NHBW_P,  Tot_NHBW_A,
           Tel_NHBW_P,  Tel_NHBW_A,
             
             TG_Per_P,    TG_Per_A,
            TG_IXXI_P,   TG_IXXI_A,
             TG_Trk_P,    TG_Trk_A,
           
           D_TOT_P   ,  D_TOT_A   ,       ;original values from distribution
           D_HBW_P   ,  D_HBW_A   ,
           D_TotHBW_P,  D_TotHBW_A,
           D_TelHBW_P,  D_TelHBW_A,
           dif_TOT_P ,  dif_TOT_A ,
           difHBW_P  ,  difHBW_A  ,
           dfTotHBW_P,  dfTotHBW_A,
           dfTelHBW_P,  dfTelHBW_A,
           
           DC_TOT_P  ,  DC_TOT_A  ,       ;original values from destination choice
           DC_HBW_P  ,  DC_HBW_A  ,
           DC_XI_P   ,  DC_XI_A   ,
           dfDC_TOT_P,  dfDC_TOT_A,
           dfDC_HBW_P,  dfDC_HBW_A,
           dfDC_XI_P ,  dfDC_XI_A 
    
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
    
    
    
    ;fill working matrices -------------------------------------------------------------------------------
    ;final trip tables
    mw[100] = mi.1.TOT     
    mw[101] = mi.1.HBW     
    mw[102] = mi.1.HBShp   
    mw[103] = mi.1.HBOth   
    mw[104] = mi.1.HBSch_Pr
    mw[105] = mi.1.HBSch_Sc
    mw[106] = mi.1.HBC     
    mw[107] = mi.1.NHBW    
    mw[108] = mi.1.NHBNW   
    mw[109] = mi.1.IX      
    mw[110] = mi.1.XI      
    mw[111] = mi.1.XX      
    mw[112] = mi.1.SH_LT   
    mw[113] = mi.1.SH_MD   
    mw[114] = mi.1.SH_HV   
    mw[115] = mi.1.Ext_MD  
    mw[116] = mi.1.Ext_HV  
    
    mw[120] = mi.1.HBSch   
    mw[121] = mi.1.HBO     
    mw[122] = mi.1.NHB     
    mw[123] = mi.1.TTUNIQUE
    mw[124] = mi.1.HBOthnTT
    
    mw[130] = mi.1.Tot_HBW 
    mw[131] = mi.1.Tel_HBW 
    mw[132] = mi.1.Tot_NHBW
    mw[133] = mi.1.Tel_NHBW
    
    mw[140] = mi.1.D_TOT                ;original values from distribution
    mw[141] = mi.1.D_HBW      
    mw[142] = mi.1.D_Tot_HBW  
    mw[143] = mi.1.D_Tel_HBW  
    mw[144] = mi.1.dif_TOT    
    mw[145] = mi.1.dif_HBW    
    mw[146] = mi.1.dif_Tot_HBW
    mw[147] = mi.1.dif_Tel_HBW
    
    mw[150] = mi.1.DC_TOT               ;original values from destination choice
    mw[151] = mi.1.DC_HBW    
    mw[152] = mi.1.DC_XI     
    mw[153] = mi.1.dif_DC_TOT
    mw[154] = mi.1.dif_DC_HBW
    mw[155] = mi.1.dif_DC_XI 
    
    
    ;transpose
    mw[200] = mi.1.TOT.T
    mw[201] = mi.1.HBW.T
    mw[202] = mi.1.HBShp.T
    mw[203] = mi.1.HBOth.T
    mw[204] = mi.1.HBSch_Pr.T
    mw[205] = mi.1.HBSch_Sc.T
    mw[206] = mi.1.HBC.T
    mw[207] = mi.1.NHBW.T
    mw[208] = mi.1.NHBNW.T
    mw[209] = mi.1.IX.T
    mw[210] = mi.1.XI.T
    mw[211] = mi.1.XX.T
    mw[212] = mi.1.SH_LT.T
    mw[213] = mi.1.SH_MD.T
    mw[214] = mi.1.SH_HV.T
    mw[215] = mi.1.Ext_MD.T
    mw[216] = mi.1.Ext_HV.T
    
    mw[220] = mi.1.HBSch.T
    mw[221] = mi.1.HBO.T
    mw[222] = mi.1.NHB.T
    mw[223] = mi.1.TTUNIQUE.T
    mw[224] = mi.1.HBOthnTT.T
    
    mw[230] = mi.1.Tot_HBW.T
    mw[231] = mi.1.Tel_HBW.T
    mw[232] = mi.1.Tot_NHBW.T
    mw[233] = mi.1.Tel_NHBW.T
    
    mw[240] = mi.1.D_TOT.T                ;original values from distribution
    mw[241] = mi.1.D_HBW.T      
    mw[242] = mi.1.D_Tot_HBW.T  
    mw[243] = mi.1.D_Tel_HBW.T  
    mw[244] = mi.1.dif_TOT.T    
    mw[245] = mi.1.dif_HBW.T    
    mw[246] = mi.1.dif_Tot_HBW.T
    mw[247] = mi.1.dif_Tel_HBW.T
    
    mw[250] = mi.1.DC_TOT.T               ;original values from destination choice
    mw[251] = mi.1.DC_HBW.T    
    mw[252] = mi.1.DC_XI.T     
    mw[253] = mi.1.dif_DC_TOT.T
    mw[254] = mi.1.dif_DC_HBW.T
    mw[255] = mi.1.dif_DC_XI.T 
    
    
    
    ;calculate P & A row/column sums ---------------------------------------------------------------------
    ;P's
    RO.HBW_P      = rowsum(101)
    RO.HBShp_P    = rowsum(102)
    RO.HBOth_P    = rowsum(103)
    RO.HBSch_Pr_P = rowsum(104)
    RO.HBSch_Sc_P = rowsum(105)
    RO.HBC_P      = rowsum(106)
    RO.NHBW_P     = rowsum(107)
    RO.NHBNW_P    = rowsum(108)
    RO.IX_P       = rowsum(109)
    RO.XI_P       = rowsum(110)
    RO.XX_P       = rowsum(111)
    RO.SH_LT_P    = rowsum(112)
    RO.SH_MD_P    = rowsum(113)
    RO.SH_HV_P    = rowsum(114)
    RO.Ext_MD_P   = rowsum(115)
    RO.Ext_HV_P   = rowsum(116)
    
    RO.HBSch_P    = rowsum(120)
    RO.HBO_P      = rowsum(121)
    RO.NHB_P      = rowsum(122)
    RO.TTUNIQUE_P = rowsum(123)
    RO.HBOthnTT_P = rowsum(124)
    
    RO.Tot_HBW_P  = rowsum(130)
    RO.Tel_HBW_P  = rowsum(131)
    RO.Tot_NHBW_P = rowsum(132)
    RO.Tel_NHBW_P = rowsum(133)
    
    RO.D_TOT_P    = rowsum(140)
    RO.D_HBW_P    = rowsum(141)
    RO.D_TotHBW_P = rowsum(142)
    RO.D_TelHBW_P = rowsum(143)
    RO.dif_TOT_P  = rowsum(144)
    RO.difHBW_P   = rowsum(145)
    RO.dfTotHBW_P = rowsum(146)
    RO.dfTelHBW_P = rowsum(147)
    
    RO.DC_TOT_P   = rowsum(150)
    RO.DC_HBW_P   = rowsum(151)
    RO.DC_XI_P    = rowsum(152)
    RO.dfDC_TOT_P = rowsum(153)
    RO.dfDC_HBW_P = rowsum(154)
    RO.dfDC_XI_P  = rowsum(155)
    
    
    RO.TotPer_P  = RO.HBW_P      +
                   RO.HBShp_P    +
                   RO.HBOth_P    +
                   RO.HBSch_Pr_P +
                   RO.HBSch_Sc_P +
                   RO.HBC_P      +
                   RO.NHBW_P     +
                   RO.NHBNW_P    
    
    
    RO.TotExt_P  = RO.IX_P +
                   RO.XI_P +
                   RO.XX_P 
    
    
    RO.TotTrk_P  = RO.SH_LT_P  +
                   RO.SH_MD_P  +
                   RO.SH_HV_P  +
                   RO.Ext_MD_P +
                   RO.Ext_HV_P 
    
    
    RO.TG_Per_P  = RO.Tot_HBW_P  +          ;use HBW with telecommute
                   RO.HBShp_P    +
                   RO.HBOthnTT_P +          ;use HBOth without TTUNIQUE
                   RO.HBSch_Pr_P +
                   RO.HBSch_Sc_P +
                   RO.HBC_P      +
                   RO.Tot_NHBW_P +          ;use NHBW with telecommute
                   RO.NHBNW_P    
    
    
    RO.TG_IXXI_P = RO.IX_P +                ;exclude XX
                   RO.XI_P 
    
    
    RO.TG_Trk_P  = RO.SH_LT_P  +            ;exclude Ext_MD_P & Ext_HV_P
                   RO.SH_MD_P  +
                   RO.SH_HV_P  
    
    
    ;A's
    RO.HBW_A      = rowsum(201)
    RO.HBShp_A    = rowsum(202)
    RO.HBOth_A    = rowsum(203)
    RO.HBSch_Pr_A = rowsum(204)
    RO.HBSch_Sc_A = rowsum(205)
    RO.HBC_A      = rowsum(206)
    RO.NHBW_A     = rowsum(207)
    RO.NHBNW_A    = rowsum(208)
    RO.IX_A       = rowsum(209)
    RO.XI_A       = rowsum(210)
    RO.XX_A       = rowsum(211)
    RO.SH_LT_A    = rowsum(212)
    RO.SH_MD_A    = rowsum(213)
    RO.SH_HV_A    = rowsum(214)
    RO.Ext_MD_A   = rowsum(215)
    RO.Ext_HV_A   = rowsum(216)
    
    RO.HBSch_A    = rowsum(220)
    RO.HBO_A      = rowsum(221)
    RO.NHB_A      = rowsum(222)
    RO.TTUNIQUE_A = rowsum(223)
    RO.HBOthnTT_A = rowsum(224)
    
    RO.Tot_HBW_A  = rowsum(230)
    RO.Tel_HBW_A  = rowsum(231)
    RO.Tot_NHBW_A = rowsum(232)
    RO.Tel_NHBW_A = rowsum(233)
    
    RO.D_TOT_A    = rowsum(240)
    RO.D_HBW_A    = rowsum(241)
    RO.D_TotHBW_A = rowsum(242)
    RO.D_TelHBW_A = rowsum(243)
    RO.dif_TOT_A  = rowsum(244)
    RO.difHBW_A   = rowsum(245)
    RO.dfTotHBW_A = rowsum(246)
    RO.dfTelHBW_A = rowsum(247)
    
    RO.DC_TOT_A   = rowsum(250)
    RO.DC_HBW_A   = rowsum(251)
    RO.DC_XI_A    = rowsum(252)
    RO.dfDC_TOT_A = rowsum(253)
    RO.dfDC_HBW_A = rowsum(254)
    RO.dfDC_XI_A  = rowsum(255)
    
    
    RO.TotPer_A  = RO.HBW_A      +
                   RO.HBShp_A    +
                   RO.HBOth_A    +
                   RO.HBSch_Pr_A +
                   RO.HBSch_Sc_A +
                   RO.HBC_A      +
                   RO.NHBW_A     +
                   RO.NHBNW_A    
    
    
    RO.TotExt_A  = RO.IX_A +
                   RO.XI_A +
                   RO.XX_A 
    
    
    RO.TotTrk_A  = RO.SH_LT_A  +
                   RO.SH_MD_A  +
                   RO.SH_HV_A  +
                   RO.Ext_MD_A +
                   RO.Ext_HV_A 
    
    
    RO.TG_Per_A  = RO.Tot_HBW_A  +          ;use HBW with telecommute
                   RO.HBShp_A    +
                   RO.HBOthnTT_A +          ;use HBOth without TTUNIQUE
                   RO.HBSch_Pr_A +
                   RO.HBSch_Sc_A +
                   RO.HBC_A      +
                   RO.Tot_NHBW_A +          ;use NHBW with telecommute
                   RO.NHBNW_A    
    
    
    RO.TG_IXXI_A = RO.IX_A +                ;exclude XX
                   RO.XI_A 
    
    
    RO.TG_Trk_A  = RO.SH_LT_A  +            ;exclude Ext_MD_A & Ext_HV_A
                   RO.SH_MD_A  +
                   RO.SH_HV_A  
    
    
    ;write output file
    WRITE RECO=1
    
    
    
    ;calculate matrix totals -----------------------------------------------------------------------------
    ;P's
    sum_HBW_P      = sum_HBW_P      + RO.HBW_P     
    sum_HBShp_P    = sum_HBShp_P    + RO.HBShp_P   
    sum_HBOth_P    = sum_HBOth_P    + RO.HBOth_P   
    sum_HBSch_Pr_P = sum_HBSch_Pr_P + RO.HBSch_Pr_P
    sum_HBSch_Sc_P = sum_HBSch_Sc_P + RO.HBSch_Sc_P
    sum_HBC_P      = sum_HBC_P      + RO.HBC_P     
    sum_NHBW_P     = sum_NHBW_P     + RO.NHBW_P    
    sum_NHBNW_P    = sum_NHBNW_P    + RO.NHBNW_P   
    sum_IX_P       = sum_IX_P       + RO.IX_P      
    sum_XI_P       = sum_XI_P       + RO.XI_P      
    sum_XX_P       = sum_XX_P       + RO.XX_P      
    sum_SH_LT_P    = sum_SH_LT_P    + RO.SH_LT_P   
    sum_SH_MD_P    = sum_SH_MD_P    + RO.SH_MD_P   
    sum_SH_HV_P    = sum_SH_HV_P    + RO.SH_HV_P   
    sum_Ext_MD_P   = sum_Ext_MD_P   + RO.Ext_MD_P  
    sum_Ext_HV_P   = sum_Ext_HV_P   + RO.Ext_HV_P  
    
    sum_HBSch_P    = sum_HBSch_P    + RO.HBSch_P
    sum_HBO_P      = sum_HBO_P      + RO.HBO_P  
    sum_NHB_P      = sum_NHB_P      + RO.NHB_P  
    sum_TTUNIQUE_P = sum_TTUNIQUE_P + RO.TTUNIQUE_P
    sum_HBOthnTT_P = sum_HBOthnTT_P + RO.HBOthnTT_P
    
    sum_Tot_HBW_P  = sum_Tot_HBW_P  + RO.Tot_HBW_P 
    sum_Tel_HBW_P  = sum_Tel_HBW_P  + RO.Tel_HBW_P 
    sum_Tot_NHBW_P = sum_Tot_NHBW_P + RO.Tot_NHBW_P
    sum_Tel_NHBW_P = sum_Tel_NHBW_P + RO.Tel_NHBW_P
    
    sum_D_TOT_P    = sum_D_TOT_P    + RO.D_TOT_P   
    sum_D_HBW_P    = sum_D_HBW_P    + RO.D_HBW_P   
    sum_D_TotHBW_P = sum_D_TotHBW_P + RO.D_TotHBW_P
    sum_D_TelHBW_P = sum_D_TelHBW_P + RO.D_TelHBW_P
    sum_dif_TOT_P  = sum_dif_TOT_P  + RO.dif_TOT_P 
    sum_difHBW_P   = sum_difHBW_P   + RO.difHBW_P  
    sum_dfTotHBW_P = sum_dfTotHBW_P + RO.dfTotHBW_P
    sum_dfTelHBW_P = sum_dfTelHBW_P + RO.dfTelHBW_P
    
    sum_DC_TOT_P   = sum_DC_TOT_P   + RO.DC_TOT_P  
    sum_DC_HBW_P   = sum_DC_HBW_P   + RO.DC_HBW_P  
    sum_DC_XI_P    = sum_DC_XI_P    + RO.DC_XI_P   
    sum_dfDC_TOT_P = sum_dfDC_TOT_P + RO.dfDC_TOT_P
    sum_dfDC_HBW_P = sum_dfDC_HBW_P + RO.dfDC_HBW_P
    sum_dfDC_XI_P  = sum_dfDC_XI_P  + RO.dfDC_XI_P 
    
    
    sum_TotPer_P  = sum_HBW_P      +
                    sum_HBShp_P    +
                    sum_HBOth_P    +
                    sum_HBSch_Pr_P +
                    sum_HBSch_Sc_P +
                    sum_HBC_P      +
                    sum_NHBW_P     +
                    sum_NHBNW_P    
    
    sum_TotExt_P  = sum_IX_P +
                    sum_XI_P +
                    sum_XX_P 
    
    sum_TotTrk_P  = sum_SH_LT_P  +
                    sum_SH_MD_P  +
                    sum_SH_HV_P  +
                    sum_Ext_MD_P +
                    sum_Ext_HV_P 
    
    
    sum_TG_Per_P  = sum_Tot_HBW_P  +          ;use HBW with telecommute
                    sum_HBShp_P    +
                    sum_HBOthnTT_P +          ;use HBOth without TTUNIQUE
                    sum_HBSch_Pr_P +
                    sum_HBSch_Sc_P +
                    sum_HBC_P      +
                    sum_Tot_NHBW_P +          ;use NHBW with telecommute
                    sum_NHBNW_P    
                
    sum_TG_IXXI_P = sum_IX_P +                ;exclude XX
                    sum_XI_P 
    
    sum_TG_Trk_P  = sum_SH_LT_P  +            ;exclude Ext_MD_P & Ext_HV_P
                    sum_SH_MD_P  +
                    sum_SH_HV_P  
    
    
    ;A's
    sum_HBW_A      = sum_HBW_A      + RO.HBW_A     
    sum_HBShp_A    = sum_HBShp_A    + RO.HBShp_A   
    sum_HBOth_A    = sum_HBOth_A    + RO.HBOth_A   
    sum_HBSch_Pr_A = sum_HBSch_Pr_A + RO.HBSch_Pr_A
    sum_HBSch_Sc_A = sum_HBSch_Sc_A + RO.HBSch_Sc_A
    sum_HBC_A      = sum_HBC_A      + RO.HBC_A     
    sum_NHBW_A     = sum_NHBW_A     + RO.NHBW_A    
    sum_NHBNW_A    = sum_NHBNW_A    + RO.NHBNW_A   
    sum_IX_A       = sum_IX_A       + RO.IX_A      
    sum_XI_A       = sum_XI_A       + RO.XI_A      
    sum_XX_A       = sum_XX_A       + RO.XX_A      
    sum_SH_LT_A    = sum_SH_LT_A    + RO.SH_LT_A   
    sum_SH_MD_A    = sum_SH_MD_A    + RO.SH_MD_A   
    sum_SH_HV_A    = sum_SH_HV_A    + RO.SH_HV_A   
    sum_Ext_MD_A   = sum_Ext_MD_A   + RO.Ext_MD_A  
    sum_Ext_HV_A   = sum_Ext_HV_A   + RO.Ext_HV_A  
    
    sum_HBSch_A    = sum_HBSch_A    + RO.HBSch_A   
    sum_HBO_A      = sum_HBO_A      + RO.HBO_A  
    sum_NHB_A      = sum_NHB_A      + RO.NHB_A  
    sum_TTUNIQUE_A = sum_TTUNIQUE_A + RO.TTUNIQUE_A
    sum_HBOthnTT_A = sum_HBOthnTT_A + RO.HBOthnTT_A
    
    sum_Tot_HBW_A  = sum_Tot_HBW_A  + RO.Tot_HBW_A 
    sum_Tel_HBW_A  = sum_Tel_HBW_A  + RO.Tel_HBW_A 
    sum_Tot_NHBW_A = sum_Tot_NHBW_A + RO.Tot_NHBW_A
    sum_Tel_NHBW_A = sum_Tel_NHBW_A + RO.Tel_NHBW_A
    
    sum_D_TOT_A    = sum_D_TOT_A    + RO.D_TOT_A   
    sum_D_HBW_A    = sum_D_HBW_A    + RO.D_HBW_A   
    sum_D_TotHBW_A = sum_D_TotHBW_A + RO.D_TotHBW_A
    sum_D_TelHBW_A = sum_D_TelHBW_A + RO.D_TelHBW_A
    sum_dif_TOT_A  = sum_dif_TOT_A  + RO.dif_TOT_A 
    sum_difHBW_A   = sum_difHBW_A   + RO.difHBW_A  
    sum_dfTotHBW_A = sum_dfTotHBW_A + RO.dfTotHBW_A
    sum_dfTelHBW_A = sum_dfTelHBW_A + RO.dfTelHBW_A
    
    sum_DC_TOT_A   = sum_DC_TOT_A   + RO.DC_TOT_A  
    sum_DC_HBW_A   = sum_DC_HBW_A   + RO.DC_HBW_A  
    sum_DC_XI_A    = sum_DC_XI_A    + RO.DC_XI_A   
    sum_dfDC_TOT_A = sum_dfDC_TOT_A + RO.dfDC_TOT_A
    sum_dfDC_HBW_A = sum_dfDC_HBW_A + RO.dfDC_HBW_A
    sum_dfDC_XI_A  = sum_dfDC_XI_A  + RO.dfDC_XI_A 
    
    
    sum_TotPer_A  = sum_HBW_A      +
                    sum_HBShp_A    +
                    sum_HBOth_A    +
                    sum_HBSch_Pr_A +
                    sum_HBSch_Sc_A +
                    sum_HBC_A      +
                    sum_NHBW_A     +
                    sum_NHBNW_A    
    
    sum_TotExt_A  = sum_IX_A +
                    sum_XI_A +
                    sum_XX_A 
                    
    
    sum_TotTrk_A  = sum_SH_LT_A  +
                    sum_SH_MD_A  +
                    sum_SH_HV_A  +
                    sum_Ext_MD_A +
                    sum_Ext_HV_A 
    
    
    sum_TG_Per_A  = sum_Tot_HBW_A  +          ;use HBW with telecommute
                    sum_HBShp_A    +
                    sum_HBOthnTT_A +          ;use HBOth without TTUNIQUE
                    sum_HBSch_Pr_A +
                    sum_HBSch_Sc_A +
                    sum_HBC_A      +
                    sum_Tot_NHBW_A +          ;use NHBW with telecommute
                    sum_NHBNW_A    
                
    sum_TG_IXXI_A = sum_IX_A +                ;exclude XX
                    sum_XI_A 
    
    sum_TG_Trk_A  = sum_SH_LT_A  +            ;exclude Ext_MD_A & Ext_HV_A
                    sum_SH_MD_A  +
                    sum_SH_HV_A  
    
    
    
    ;calculate intrazonal % ------------------------------------------------------------------------------
    if (i=@BoxElderRange@)
        
        total_HBW_BE = total_HBW_BE + rowsum(101)
        total_HBO_BE = total_HBO_BE + rowsum(121)
        total_NHB_BE = total_NHB_BE + rowsum(122)
        
        intrazonal_HBW_BE = intrazonal_HBW_BE + mw[101][i]
        intrazonal_HBO_BE = intrazonal_HBO_BE + mw[121][i]
        intrazonal_NHB_BE = intrazonal_NHB_BE + mw[122][i]
        
    elseif (i=@WeberRange@)
        
        total_HBW_WE = total_HBW_WE + rowsum(101)
        total_HBO_WE = total_HBO_WE + rowsum(121)
        total_NHB_WE = total_NHB_WE + rowsum(122)
        
        intrazonal_HBW_WE = intrazonal_HBW_WE + mw[101][i]
        intrazonal_HBO_WE = intrazonal_HBO_WE + mw[121][i]
        intrazonal_NHB_WE = intrazonal_NHB_WE + mw[122][i]
        
    elseif (i=@DavisRange@)
        
        total_HBW_DA = total_HBW_DA + rowsum(101)
        total_HBO_DA = total_HBO_DA + rowsum(121)
        total_NHB_DA = total_NHB_DA + rowsum(122)
        
        intrazonal_HBW_DA = intrazonal_HBW_DA + mw[101][i]
        intrazonal_HBO_DA = intrazonal_HBO_DA + mw[121][i]
        intrazonal_NHB_DA = intrazonal_NHB_DA + mw[122][i]
        
    elseif (i=@SLRange@)
        
        total_HBW_SL = total_HBW_SL + rowsum(101)
        total_HBO_SL = total_HBO_SL + rowsum(121)
        total_NHB_SL = total_NHB_SL + rowsum(122)
        
        intrazonal_HBW_SL = intrazonal_HBW_SL + mw[101][i]
        intrazonal_HBO_SL = intrazonal_HBO_SL + mw[121][i]
        intrazonal_NHB_SL = intrazonal_NHB_SL + mw[122][i]
        
    elseif (i=@UtahRange@)
        
        total_HBW_UT = total_HBW_UT + rowsum(101)
        total_HBO_UT = total_HBO_UT + rowsum(121)
        total_NHB_UT = total_NHB_UT + rowsum(122)
        
        intrazonal_HBW_UT = intrazonal_HBW_UT + mw[101][i]
        intrazonal_HBO_UT = intrazonal_HBO_UT + mw[121][i]
        intrazonal_NHB_UT = intrazonal_NHB_UT + mw[122][i]
        
    endif
    
    
    
    if (i=ZONES)
        
        ;calculate regional totals
        total_HBW_RE = total_HBW_BE +
                       total_HBW_WE +
                       total_HBW_DA +
                       total_HBW_SL +
                       total_HBW_UT
                     
        total_HBO_RE = total_HBO_BE +
                       total_HBO_WE +
                       total_HBO_DA +
                       total_HBO_SL +
                       total_HBO_UT
                     
        total_NHB_RE = total_NHB_BE +
                       total_NHB_WE +
                       total_NHB_DA +
                       total_NHB_SL +
                       total_NHB_UT
        
        
        intrazonal_HBW_RE = intrazonal_HBW_BE +
                            intrazonal_HBW_WE +
                            intrazonal_HBW_DA +
                            intrazonal_HBW_SL +
                            intrazonal_HBW_UT
                          
        intrazonal_HBO_RE = intrazonal_HBO_BE +
                            intrazonal_HBO_WE +
                            intrazonal_HBO_DA +
                            intrazonal_HBO_SL +
                            intrazonal_HBO_UT
                          
        intrazonal_NHB_RE = intrazonal_NHB_BE +
                            intrazonal_NHB_WE +
                            intrazonal_NHB_DA +
                            intrazonal_NHB_SL +
                            intrazonal_NHB_UT
        
        
        ;calculate introzonal %
        if (total_HBW_RE>0)  pct_intrazonal_HBW_RE = intrazonal_HBW_RE / total_HBW_RE * 100
        if (total_HBW_BE>0)  pct_intrazonal_HBW_BE = intrazonal_HBW_BE / total_HBW_BE * 100
        if (total_HBW_WE>0)  pct_intrazonal_HBW_WE = intrazonal_HBW_WE / total_HBW_WE * 100
        if (total_HBW_DA>0)  pct_intrazonal_HBW_DA = intrazonal_HBW_DA / total_HBW_DA * 100
        if (total_HBW_SL>0)  pct_intrazonal_HBW_SL = intrazonal_HBW_SL / total_HBW_SL * 100
        if (total_HBW_UT>0)  pct_intrazonal_HBW_UT = intrazonal_HBW_UT / total_HBW_UT * 100
        
        if (total_HBO_RE>0)  pct_intrazonal_HBO_RE = intrazonal_HBO_RE / total_HBO_RE * 100
        if (total_HBO_BE>0)  pct_intrazonal_HBO_BE = intrazonal_HBO_BE / total_HBO_BE * 100
        if (total_HBO_WE>0)  pct_intrazonal_HBO_WE = intrazonal_HBO_WE / total_HBO_WE * 100
        if (total_HBO_DA>0)  pct_intrazonal_HBO_DA = intrazonal_HBO_DA / total_HBO_DA * 100
        if (total_HBO_SL>0)  pct_intrazonal_HBO_SL = intrazonal_HBO_SL / total_HBO_SL * 100
        if (total_HBO_UT>0)  pct_intrazonal_HBO_UT = intrazonal_HBO_UT / total_HBO_UT * 100
        
        if (total_NHB_RE>0)  pct_intrazonal_NHB_RE = intrazonal_NHB_RE / total_NHB_RE * 100
        if (total_NHB_BE>0)  pct_intrazonal_NHB_BE = intrazonal_NHB_BE / total_NHB_BE * 100
        if (total_NHB_WE>0)  pct_intrazonal_NHB_WE = intrazonal_NHB_WE / total_NHB_WE * 100
        if (total_NHB_DA>0)  pct_intrazonal_NHB_DA = intrazonal_NHB_DA / total_NHB_DA * 100
        if (total_NHB_SL>0)  pct_intrazonal_NHB_SL = intrazonal_NHB_SL / total_NHB_SL * 100
        if (total_NHB_UT>0)  pct_intrazonal_NHB_UT = intrazonal_NHB_UT / total_NHB_UT * 100
        
        
        
        ;print output ------------------------------------------------------------------------------------
        PRINT FILE='@ParentDir@@ScenarioDir@_Log\_LogFile - @RID@.txt', 
        APPEND=T,  
        FORM=13.0C,
        LIST='\n;*********************************************************************',
             '\n',
             '\nMODE CHOICE',
             '\n',
             '\nMode Choice - Trip Summary',
             '\n',
             '\n  Matrix Totals',
             '\n                ',  '  Productions',  '  Attractions',  ' P/A Balance ',
             '\n    TotPer      ',   sum_TotPer_P  ,   sum_TotPer_A  ,   sum_TotPer_P/sum_TotPer_A(10.2)    ,
             '\n      HBW       ',   sum_HBW_P     ,   sum_HBW_A     ,   sum_HBW_P/sum_HBW_A(10.2)          ,
             '\n      HBShp     ',   sum_HBShp_P   ,   sum_HBShp_A   ,   sum_HBShp_P/sum_HBShp_A(10.2)      ,
             '\n      HBOth     ',   sum_HBOth_P   ,   sum_HBOth_A   ,   sum_HBOth_P/sum_HBOth_A(10.2)      ,
             '\n      HBSch_Pr  ',   sum_HBSch_Pr_P,   sum_HBSch_Pr_A,   sum_HBSch_Pr_P/sum_HBSch_Pr_A(10.2),
             '\n      HBSch_Sc  ',   sum_HBSch_Sc_P,   sum_HBSch_Sc_A,   sum_HBSch_Sc_P/sum_HBSch_Sc_A(10.2),
             '\n      HBC       ',   sum_HBC_P     ,   sum_HBC_A     ,   sum_HBC_P/sum_HBC_A(10.2)          ,
             '\n      NHBW      ',   sum_NHBW_P    ,   sum_NHBW_A    ,   sum_NHBW_P/sum_NHBW_A(10.2)        ,
             '\n      NHBNW     ',   sum_NHBNW_P   ,   sum_NHBNW_A   ,   sum_NHBNW_P/sum_NHBNW_A(10.2)      ,
             '\n',
             '\n    TotExt      ',   sum_TotExt_P  ,   sum_TotExt_A  ,   sum_TotExt_P/sum_TotExt_A(10.2)    ,
             '\n      IX        ',   sum_IX_P      ,   sum_IX_A      ,   sum_IX_P/sum_IX_A(10.2)            ,
             '\n      XI        ',   sum_XI_P      ,   sum_XI_A      ,   sum_XI_P/sum_XI_A(10.2)            ,
             '\n      XX        ',   sum_XX_P      ,   sum_XX_A      ,   sum_XX_P/sum_XX_A(10.2)            ,
             '\n',
             '\n    TotTrk      ',   sum_TotTrk_P  ,   sum_TotTrk_A  ,   sum_TotTrk_P/sum_TotTrk_A(10.2)    ,
             '\n      SH_LT     ',   sum_SH_LT_P   ,   sum_SH_LT_A   ,   sum_SH_LT_P/sum_SH_LT_A(10.2)      ,
             '\n      SH_MD     ',   sum_SH_MD_P   ,   sum_SH_MD_A   ,   sum_SH_MD_P/sum_SH_MD_A(10.2)      ,
             '\n      SH_HV     ',   sum_SH_HV_P   ,   sum_SH_HV_A   ,   sum_SH_HV_P/sum_SH_HV_A(10.2)      ,
             '\n      Ext_MD    ',   sum_Ext_MD_P  ,   sum_Ext_MD_A  ,   sum_Ext_MD_P/sum_Ext_MD_A(10.2)    ,
             '\n      Ext_HV    ',   sum_Ext_HV_P  ,   sum_Ext_HV_A  ,   sum_Ext_HV_P/sum_Ext_HV_A(10.2)    ,
             '\n',
             '\n    Other summaries',
             '\n      HBSch     ',   sum_HBSch_P   ,   sum_HBSch_A   ,   sum_HBSch_P/sum_HBSch_A(10.2)      ,
             '\n      HBO       ',   sum_HBO_P     ,   sum_HBO_A     ,   sum_HBO_P/sum_HBO_A(10.2)          ,
             '\n      NHB       ',   sum_NHB_P     ,   sum_NHB_A     ,   sum_NHB_P/sum_NHB_A(10.2)          ,
             '\n      TTUNIQUE  ',   sum_TTUNIQUE_P,   sum_TTUNIQUE_A,   sum_TTUNIQUE_P/sum_TTUNIQUE_A(10.2),
             '\n      HBOthnTT  ',   sum_HBOthnTT_P,   sum_HBOthnTT_A,   sum_HBOthnTT_P/sum_HBOthnTT_A(10.2),
             '\n',
             '\n      Tot_HBW   ',   sum_Tot_HBW_P ,   sum_Tot_HBW_A ,   sum_Tot_HBW_P/sum_Tot_HBW_A(10.2)  ,
             '\n      Tel_HBW   ',   sum_Tel_HBW_P ,   sum_Tel_HBW_A ,   sum_Tel_HBW_P/sum_Tel_HBW_A(10.2)  ,
             '\n      Tot_NHBW  ',   sum_Tot_NHBW_P,   sum_Tot_NHBW_A,   sum_Tot_NHBW_P/sum_Tot_NHBW_A(10.2),
             '\n      Tel_NHBW  ',   sum_Tel_NHBW_P,   sum_Tel_NHBW_A,   sum_Tel_NHBW_P/sum_Tel_NHBW_A(10.2),
             '\n',
             '\n      TG_Per    ',   sum_TG_Per_P  ,   sum_TG_Per_A  ,   sum_TG_Per_P/sum_TG_Per_A(10.2)    ,
             '\n      TG_IXXI   ',   sum_TG_IXXI_P ,   sum_TG_IXXI_A ,   sum_TG_IXXI_P/sum_TG_IXXI_A(10.2)  ,
             '\n      TG_Trk    ',   sum_TG_Trk_P  ,   sum_TG_Trk_A  ,   sum_TG_Trk_P/sum_TG_Trk_A(10.2)    ,
             '\n',
             '\n      D_TOT_P   ',   sum_D_TOT_P   ,   sum_D_TOT_A   ,   sum_D_TOT_P/sum_D_TOT_A(10.2)      ,
             '\n      D_HBW_P   ',   sum_D_HBW_P   ,   sum_D_HBW_A   ,   sum_D_HBW_P/sum_D_HBW_A(10.2)      ,
             '\n      D_TotHBW_P',   sum_D_TotHBW_P,   sum_D_TotHBW_A,   sum_D_TotHBW_P/sum_D_TotHBW_A(10.2),
             '\n      D_TelHBW_P',   sum_D_TelHBW_P,   sum_D_TelHBW_A,   sum_D_TelHBW_P/sum_D_TelHBW_A(10.2),
             '\n      dif_TOT_P ',   sum_dif_TOT_P ,   sum_dif_TOT_A ,   sum_dif_TOT_P/sum_dif_TOT_A(10.2)  ,
             '\n      difHBW_P  ',   sum_difHBW_P  ,   sum_difHBW_A  ,   sum_difHBW_P/sum_difHBW_A(10.2)    ,
             '\n      dfTotHBW_P',   sum_dfTotHBW_P,   sum_dfTotHBW_A,   sum_dfTotHBW_P/sum_dfTotHBW_A(10.2),
             '\n      dfTelHBW_P',   sum_dfTelHBW_P,   sum_dfTelHBW_A,   sum_dfTelHBW_P/sum_dfTelHBW_A(10.2),
             '\n',
             '\n      DC_TOT_P  ',   sum_DC_TOT_P  ,   sum_DC_TOT_A  ,   sum_DC_TOT_P/sum_DC_TOT_A(10.2)    ,
             '\n      DC_HBW_P  ',   sum_DC_HBW_P  ,   sum_DC_HBW_A  ,   sum_DC_HBW_P/sum_DC_HBW_A(10.2)    ,
             '\n      DC_XI_P   ',   sum_DC_XI_P   ,   sum_DC_XI_A   ,   sum_DC_XI_P/sum_DC_XI_A(10.2)      ,
             '\n      dfDC_TOT_P',   sum_dfDC_TOT_P,   sum_dfDC_TOT_A,   sum_dfDC_TOT_P/sum_dfDC_TOT_A(10.2),
             '\n      dfDC_HBW_P',   sum_dfDC_HBW_P,   sum_dfDC_HBW_A,   sum_dfDC_HBW_P/sum_dfDC_HBW_A(10.2),
             '\n      dfDC_XI_P ',   sum_dfDC_XI_P ,   sum_dfDC_XI_A ,   sum_dfDC_XI_P/sum_dfDC_XI_A(10.2)  ,
             '\n',
             '\n',
             '\n  Intrazonal Summary',
             '\n    Region    ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_RE,      total_HBW_RE,   pct_intrazonal_HBW_RE(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_RE,      total_HBO_RE,   pct_intrazonal_HBO_RE(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_RE,      total_NHB_RE,   pct_intrazonal_NHB_RE(13.1), '%',
             '\n',                 
             '\n    Box Elder ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_BE,      total_HBW_BE,   pct_intrazonal_HBW_BE(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_BE,      total_HBO_BE,   pct_intrazonal_HBO_BE(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_BE,      total_NHB_BE,   pct_intrazonal_NHB_BE(13.1), '%',
             '\n',                 
             '\n    Weber     ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_WE,      total_HBW_WE,   pct_intrazonal_HBW_WE(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_WE,      total_HBO_WE,   pct_intrazonal_HBO_WE(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_WE,      total_NHB_WE,   pct_intrazonal_NHB_WE(13.1), '%',
             '\n',                 
             '\n    Davis     ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_DA,      total_HBW_DA,   pct_intrazonal_HBW_DA(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_DA,      total_HBO_DA,   pct_intrazonal_HBO_DA(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_DA,      total_NHB_DA,   pct_intrazonal_NHB_DA(13.1), '%',
             '\n',                 
             '\n    Salt Lake ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_SL,      total_HBW_SL,   pct_intrazonal_HBW_SL(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_SL,      total_HBO_SL,   pct_intrazonal_HBO_SL(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_SL,      total_NHB_SL,   pct_intrazonal_NHB_SL(13.1), '%',
             '\n',                 
             '\n    Utah      ',     '   Intrazonal',   '    Tot Trips',              '  % Intrazonal',
             '\n      HBW     ',   intrazonal_HBW_UT,      total_HBW_UT,   pct_intrazonal_HBW_UT(13.1), '%',
             '\n      HBO     ',   intrazonal_HBO_UT,      total_HBO_UT,   pct_intrazonal_HBO_UT(13.1), '%',
             '\n      NHB     ',   intrazonal_NHB_UT,      total_NHB_UT,   pct_intrazonal_NHB_UT(13.1), '%',
             '\n'
    
    endif  ;i=ZONES
    
ENDRUN





;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Convert some XI to HBW             ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 10_ConvertSomeXI2HBW.txt)
