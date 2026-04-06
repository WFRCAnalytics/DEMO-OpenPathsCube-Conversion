;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 13_vizTool_TripsByMode.txt)



;get start time
ScriptStartTime = currenttime()



;create zone summary viztool csv 
RUN PGM=MATRIX  MSG='Mode Choice 13: summarize data for vizTool'
    
    ZONES = 1
    
    PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
            CSV=T,
            LIST='Purpose',
                 'Period',
                 'PA',
                 'TAZID',
                 'All',
                 'Auto',
                 'Bike',
                 'Moto',
                 'NonM',
                 'Walk',
                 'dBRT',
                 'dCOR',
                 'dCRT',
                 'dEXP',
                 'dLCL',
                 'dLRT',
                 'dTrn',
                 'tBRT',
                 'tCOR',
                 'tCRT',
                 'tEXP',
                 'tLCL',
                 'tLRT',
                 'tTrn',
                 'wBRT',
                 'wCOR',
                 'wCRT',
                 'wEXP',
                 'wLCL',
                 'wLRT',
                 'wTrn'

ENDRUN



;loop through peak, off-peak, and daily and write out data from vizTool
LOOP lp=1,3
    
    if (lp=1)  pkok = 'Pk'
    if (lp=2)  pkok = 'Ok'
    if (lp=3)  pkok = 'PkOk'
    
    if (lp=1)  out = 'Pk'
    if (lp=2)  out = 'Ok'
    if (lp=3)  out = 'Dy'
    
    if (lp=2)
        xHBC = ';'
    else
        xHBC = ' '
    endif
    
    if (lp=1)
        x1 = ' '
        x2 = ';'
        x3 = ';'
    elseif (lp=2)
        x1 = ';'
        x2 = ' '
        x3 = ';'
    elseif (lp=3)
        x1 = ';'
        x2 = ';'
        x3 = ' '
    endif

    ;if (purprec=1) Purpose = 'HBW'


    
    RUN PGM=MATRIX   MSG='Mode Choice 13: summarize data for vizTool'
              FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_@pkok@.mtx'
              FILEI MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_@pkok@.mtx'
              FILEI MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_@pkok@.mtx'
        @xHBC@FILEI MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_@pkok@.mtx'
              FILEI MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'
              FILEI MATI[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'
        
        
        ZONES = @Usedzones@
        ZONEMSG = 10  ;reduces print messages in TPP DOS. (i.e. runs faster).
        
        ;HBW
        mw[101] = mi.1.DA
        mw[102] = mi.1.SR2
        mw[103] = mi.1.SR3p
        mw[104] = mi.1.wLCL
        mw[105] = mi.1.dLCL
        mw[106] = mi.1.wCOR
        mw[107] = mi.1.dCOR
        mw[108] = mi.1.wEXP
        mw[109] = mi.1.dEXP
        mw[110] = mi.1.wLRT
        mw[111] = mi.1.dLRT
        mw[112] = mi.1.wCRT
        mw[113] = mi.1.dCRT
        mw[114] = mi.1.wBRT
        mw[115] = mi.1.dBRT
        mw[116] = mi.1.walk
        mw[117] = mi.1.bike
        
        ;HBO
        mw[201] = mi.2.DA
        mw[202] = mi.2.SR2
        mw[203] = mi.2.SR3p
        mw[204] = mi.2.wLCL
        mw[205] = mi.2.dLCL
        mw[206] = mi.2.wCOR
        mw[207] = mi.2.dCOR
        mw[208] = mi.2.wEXP
        mw[209] = mi.2.dEXP
        mw[210] = mi.2.wLRT
        mw[211] = mi.2.dLRT
        mw[212] = mi.2.wCRT
        mw[213] = mi.2.dCRT
        mw[214] = mi.2.wBRT
        mw[215] = mi.2.dBRT
        mw[216] = mi.2.walk
        mw[217] = mi.2.bike
        
        ;NHB
        mw[301] = mi.3.DA
        mw[302] = mi.3.SR2
        mw[303] = mi.3.SR3p
        mw[304] = mi.3.wLCL
        mw[305] = mi.3.dLCL
        mw[306] = mi.3.wCOR
        mw[307] = mi.3.dCOR
        mw[308] = mi.3.wEXP
        mw[309] = mi.3.dEXP
        mw[310] = mi.3.wLRT
        mw[311] = mi.3.dLRT
        mw[312] = mi.3.wCRT
        mw[313] = mi.3.dCRT
        mw[314] = mi.3.wBRT
        mw[315] = mi.3.dBRT
        mw[316] = mi.3.walk
        mw[317] = mi.3.bike
        
        ;HBC
        @xHBC@mw[401] = mi.4.DA
        @xHBC@mw[402] = mi.4.SR2
        @xHBC@mw[403] = mi.4.SR3p
        @xHBC@mw[404] = mi.4.wLCL
        @xHBC@mw[405] = mi.4.dLCL
        @xHBC@mw[406] = mi.4.wCOR
        @xHBC@mw[407] = mi.4.dCOR
        @xHBC@mw[408] = mi.4.wEXP
        @xHBC@mw[409] = mi.4.dEXP
        @xHBC@mw[410] = mi.4.wLRT
        @xHBC@mw[411] = mi.4.dLRT
        @xHBC@mw[412] = mi.4.wCRT
        @xHBC@mw[413] = mi.4.dCRT
        @xHBC@mw[414] = mi.4.wBRT
        @xHBC@mw[415] = mi.4.dBRT
        @xHBC@mw[416] = mi.4.walk
        @xHBC@mw[417] = mi.4.bike
        
        
        ;HBW transposed
        mw[151] = mi.1.DA.T
        mw[152] = mi.1.SR2.T
        mw[153] = mi.1.SR3p.T
        mw[154] = mi.1.wLCL.T
        mw[155] = mi.1.dLCL.T
        mw[156] = mi.1.wCOR.T
        mw[157] = mi.1.dCOR.T
        mw[158] = mi.1.wEXP.T
        mw[159] = mi.1.dEXP.T
        mw[160] = mi.1.wLRT.T
        mw[161] = mi.1.dLRT.T
        mw[162] = mi.1.wCRT.T
        mw[163] = mi.1.dCRT.T
        mw[164] = mi.1.wBRT.T
        mw[165] = mi.1.dBRT.T
        mw[166] = mi.1.walk.T
        mw[167] = mi.1.bike.T
        
        ;HBO transposed
        mw[251] = mi.2.DA.T
        mw[252] = mi.2.SR2.T
        mw[253] = mi.2.SR3p.T
        mw[254] = mi.2.wLCL.T
        mw[255] = mi.2.dLCL.T
        mw[256] = mi.2.wCOR.T
        mw[257] = mi.2.dCOR.T
        mw[258] = mi.2.wEXP.T
        mw[259] = mi.2.dEXP.T
        mw[260] = mi.2.wLRT.T
        mw[261] = mi.2.dLRT.T
        mw[262] = mi.2.wCRT.T
        mw[263] = mi.2.dCRT.T
        mw[264] = mi.2.wBRT.T
        mw[265] = mi.2.dBRT.T
        mw[266] = mi.2.walk.T
        mw[267] = mi.2.bike.T
        
        ;NHB transposed
        mw[301] = mi.3.DA.T
        mw[302] = mi.3.SR2.T
        mw[303] = mi.3.SR3p.T
        mw[304] = mi.3.wLCL.T
        mw[305] = mi.3.dLCL.T
        mw[306] = mi.3.wCOR.T
        mw[307] = mi.3.dCOR.T
        mw[308] = mi.3.wEXP.T
        mw[309] = mi.3.dEXP.T
        mw[310] = mi.3.wLRT.T
        mw[311] = mi.3.dLRT.T
        mw[312] = mi.3.wCRT.T
        mw[313] = mi.3.dCRT.T
        mw[314] = mi.3.wBRT.T
        mw[315] = mi.3.dBRT.T
        mw[316] = mi.3.walk.T
        mw[317] = mi.3.bike.T
        
        ;HBC transposed
        @xHBC@mw[451] = mi.4.DA.T
        @xHBC@mw[452] = mi.4.SR2.T
        @xHBC@mw[453] = mi.4.SR3p.T
        @xHBC@mw[454] = mi.4.wLCL.T
        @xHBC@mw[455] = mi.4.dLCL.T
        @xHBC@mw[456] = mi.4.wCOR.T
        @xHBC@mw[457] = mi.4.dCOR.T
        @xHBC@mw[458] = mi.4.wEXP.T
        @xHBC@mw[459] = mi.4.dEXP.T
        @xHBC@mw[460] = mi.4.wLRT.T
        @xHBC@mw[461] = mi.4.dLRT.T
        @xHBC@mw[462] = mi.4.wCRT.T
        @xHBC@mw[463] = mi.4.dCRT.T
        @xHBC@mw[464] = mi.4.wBRT.T
        @xHBC@mw[465] = mi.4.dBRT.T
        @xHBC@mw[466] = mi.4.walk.T
        @xHBC@mw[467] = mi.4.bike.T
        
        
        ;HBW rowsums
        P_HBW_DA       = ROWSUM(101) / 100
        P_HBW_SR2      = ROWSUM(102) / 100
        P_HBW_SR3p     = ROWSUM(103) / 100
        P_HBW_wLCL     = ROWSUM(104) / 100
        P_HBW_dLCL     = ROWSUM(105) / 100
        P_HBW_wCOR     = ROWSUM(106) / 100
        P_HBW_dCOR     = ROWSUM(107) / 100
        P_HBW_wEXP     = ROWSUM(108) / 100
        P_HBW_dEXP     = ROWSUM(109) / 100
        P_HBW_wLRT     = ROWSUM(110) / 100
        P_HBW_dLRT     = ROWSUM(111) / 100
        P_HBW_wCRT     = ROWSUM(112) / 100
        P_HBW_dCRT     = ROWSUM(113) / 100
        P_HBW_wBRT     = ROWSUM(114) / 100
        P_HBW_dBRT     = ROWSUM(115) / 100
        P_HBW_walk     = ROWSUM(116) / 100
        P_HBW_bike     = ROWSUM(117) / 100
        
        ;HBW totals
        P_HBW_dTrn     = P_HBW_dBRT  + P_HBW_dCOR    + P_HBW_dCRT  + P_HBW_dEXP  + P_HBW_dLCL  + P_HBW_dLRT
        P_HBW_wTrn     = P_HBW_wBRT  + P_HBW_wCOR    + P_HBW_wCRT  + P_HBW_wEXP  + P_HBW_wLCL  + P_HBW_wLRT
        P_HBW_tBRT     = P_HBW_dBRT  + P_HBW_wBRT
        P_HBW_tCOR     = P_HBW_dCOR  + P_HBW_wCOR 
        P_HBW_tCRT     = P_HBW_dCRT  + P_HBW_wCRT
        P_HBW_tEXP     = P_HBW_dEXP  + P_HBW_wEXP
        P_HBW_tLCL     = P_HBW_dLCL  + P_HBW_wLCL
        P_HBW_tLRT     = P_HBW_dLRT  + P_HBW_wLRT
        P_HBW_transit  = P_HBW_dTrn  + P_HBW_wTrn
        P_HBW_auto     = P_HBW_DA    + P_HBW_SR2     + P_HBW_SR3p
        P_HBW_motor    = P_HBW_auto  + P_HBW_transit
        P_HBW_nonmotor = P_HBW_walk  + P_HBW_bike
        P_HBW_all      = P_HBW_motor + P_HBW_nonmotor
        
        A_HBW_DA       = ROWSUM(151) / 100
        A_HBW_SR2      = ROWSUM(152) / 100
        A_HBW_SR3p     = ROWSUM(153) / 100
        A_HBW_wLCL     = ROWSUM(154) / 100
        A_HBW_dLCL     = ROWSUM(155) / 100
        A_HBW_wCOR     = ROWSUM(156) / 100
        A_HBW_dCOR     = ROWSUM(157) / 100
        A_HBW_wEXP     = ROWSUM(158) / 100
        A_HBW_dEXP     = ROWSUM(159) / 100
        A_HBW_wLRT     = ROWSUM(160) / 100
        A_HBW_dLRT     = ROWSUM(161) / 100
        A_HBW_wCRT     = ROWSUM(162) / 100
        A_HBW_dCRT     = ROWSUM(163) / 100
        A_HBW_wBRT     = ROWSUM(164) / 100
        A_HBW_dBRT     = ROWSUM(165) / 100
        A_HBW_walk     = ROWSUM(166) / 100
        A_HBW_bike     = ROWSUM(167) / 100

        ;HBW totals
        A_HBW_dTrn     = A_HBW_dBRT  + A_HBW_dCOR    + A_HBW_dCRT  + A_HBW_dEXP  + A_HBW_dLCL  + A_HBW_dLRT
        A_HBW_wTrn     = A_HBW_wBRT  + A_HBW_wCOR    + A_HBW_wCRT  + A_HBW_wEXP  + A_HBW_wLCL  + A_HBW_wLRT
        A_HBW_tBRT     = A_HBW_dBRT  + A_HBW_wBRT
        A_HBW_tCOR     = A_HBW_dCOR  + A_HBW_wCOR 
        A_HBW_tCRT     = A_HBW_dCRT  + A_HBW_wCRT
        A_HBW_tEXP     = A_HBW_dEXP  + A_HBW_wEXP
        A_HBW_tLCL     = A_HBW_dLCL  + A_HBW_wLCL
        A_HBW_tLRT     = A_HBW_dLRT  + A_HBW_wLRT
        A_HBW_transit  = A_HBW_dTrn  + A_HBW_wTrn
        A_HBW_auto     = A_HBW_DA    + A_HBW_SR2     + A_HBW_SR3p
        A_HBW_motor    = A_HBW_auto  + A_HBW_transit
        A_HBW_nonmotor = A_HBW_walk  + A_HBW_bike
        A_HBW_all      = A_HBW_motor + A_HBW_nonmotor

        ;HBO rowsums
        P_HBO_DA       = ROWSUM(201) / 100
        P_HBO_SR2      = ROWSUM(202) / 100
        P_HBO_SR3p     = ROWSUM(203) / 100
        P_HBO_wLCL     = ROWSUM(204) / 100
        P_HBO_dLCL     = ROWSUM(205) / 100
        P_HBO_wCOR     = ROWSUM(206) / 100
        P_HBO_dCOR     = ROWSUM(207) / 100
        P_HBO_wEXP     = ROWSUM(208) / 100
        P_HBO_dEXP     = ROWSUM(209) / 100
        P_HBO_wLRT     = ROWSUM(210) / 100
        P_HBO_dLRT     = ROWSUM(211) / 100
        P_HBO_wCRT     = ROWSUM(212) / 100
        P_HBO_dCRT     = ROWSUM(213) / 100
        P_HBO_wBRT     = ROWSUM(214) / 100
        P_HBO_dBRT     = ROWSUM(215) / 100
        P_HBO_walk     = ROWSUM(216) / 100
        P_HBO_bike     = ROWSUM(217) / 100

        ;HBO totals
        P_HBO_dTrn     = P_HBO_dBRT  + P_HBO_dCOR    + P_HBO_dCRT  + P_HBO_dEXP  + P_HBO_dLCL  + P_HBO_dLRT
        P_HBO_wTrn     = P_HBO_wBRT  + P_HBO_wCOR    + P_HBO_wCRT  + P_HBO_wEXP  + P_HBO_wLCL  + P_HBO_wLRT
        P_HBO_tBRT     = P_HBO_dBRT  + P_HBO_wBRT
        P_HBO_tCOR     = P_HBO_dCOR  + P_HBO_wCOR 
        P_HBO_tCRT     = P_HBO_dCRT  + P_HBO_wCRT
        P_HBO_tEXP     = P_HBO_dEXP  + P_HBO_wEXP
        P_HBO_tLCL     = P_HBO_dLCL  + P_HBO_wLCL
        P_HBO_tLRT     = P_HBO_dLRT  + P_HBO_wLRT
        P_HBO_transit  = P_HBO_dTrn  + P_HBO_wTrn
        P_HBO_auto     = P_HBO_DA    + P_HBO_SR2     + P_HBO_SR3p
        P_HBO_motor    = P_HBO_auto  + P_HBO_transit
        P_HBO_nonmotor = P_HBO_walk  + P_HBO_bike
        P_HBO_all      = P_HBO_motor + P_HBO_nonmotor
        
        A_HBO_DA       = ROWSUM(251) / 100
        A_HBO_SR2      = ROWSUM(252) / 100
        A_HBO_SR3p     = ROWSUM(253) / 100
        A_HBO_wLCL     = ROWSUM(254) / 100
        A_HBO_dLCL     = ROWSUM(255) / 100
        A_HBO_wCOR     = ROWSUM(256) / 100
        A_HBO_dCOR     = ROWSUM(257) / 100
        A_HBO_wEXP     = ROWSUM(258) / 100
        A_HBO_dEXP     = ROWSUM(259) / 100
        A_HBO_wLRT     = ROWSUM(260) / 100
        A_HBO_dLRT     = ROWSUM(261) / 100
        A_HBO_wCRT     = ROWSUM(262) / 100
        A_HBO_dCRT     = ROWSUM(263) / 100
        A_HBO_wBRT     = ROWSUM(264) / 100
        A_HBO_dBRT     = ROWSUM(265) / 100
        A_HBO_walk     = ROWSUM(266) / 100
        A_HBO_bike     = ROWSUM(267) / 100

        ;HBO totals
        A_HBO_dTrn     = A_HBO_dBRT  + A_HBO_dCOR    + A_HBO_dCRT  + A_HBO_dEXP  + A_HBO_dLCL  + A_HBO_dLRT
        A_HBO_wTrn     = A_HBO_wBRT  + A_HBO_wCOR    + A_HBO_wCRT  + A_HBO_wEXP  + A_HBO_wLCL  + A_HBO_wLRT
        A_HBO_tBRT     = A_HBO_dBRT  + A_HBO_wBRT
        A_HBO_tCOR     = A_HBO_dCOR  + A_HBO_wCOR 
        A_HBO_tCRT     = A_HBO_dCRT  + A_HBO_wCRT
        A_HBO_tEXP     = A_HBO_dEXP  + A_HBO_wEXP
        A_HBO_tLCL     = A_HBO_dLCL  + A_HBO_wLCL
        A_HBO_tLRT     = A_HBO_dLRT  + A_HBO_wLRT
        A_HBO_transit  = A_HBO_dTrn  + A_HBO_wTrn
        A_HBO_auto     = A_HBO_DA    + A_HBO_SR2     + A_HBO_SR3p
        A_HBO_motor    = A_HBO_auto  + A_HBO_transit
        A_HBO_nonmotor = A_HBO_walk  + A_HBO_bike
        A_HBO_all      = A_HBO_motor + A_HBO_nonmotor
        
        ;NHB rowsums
        P_NHB_DA       = ROWSUM(301) / 100
        P_NHB_SR2      = ROWSUM(302) / 100
        P_NHB_SR3p     = ROWSUM(303) / 100
        P_NHB_wLCL     = ROWSUM(304) / 100
        P_NHB_dLCL     = ROWSUM(305) / 100
        P_NHB_wCOR     = ROWSUM(306) / 100
        P_NHB_dCOR     = ROWSUM(307) / 100
        P_NHB_wEXP     = ROWSUM(308) / 100
        P_NHB_dEXP     = ROWSUM(309) / 100
        P_NHB_wLRT     = ROWSUM(310) / 100
        P_NHB_dLRT     = ROWSUM(311) / 100
        P_NHB_wCRT     = ROWSUM(312) / 100
        P_NHB_dCRT     = ROWSUM(313) / 100
        P_NHB_wBRT     = ROWSUM(314) / 100
        P_NHB_dBRT     = ROWSUM(315) / 100
        P_NHB_walk     = ROWSUM(316) / 100
        P_NHB_bike     = ROWSUM(317) / 100

        ;HBO totals
        P_NHB_dTrn     = P_NHB_dBRT  + P_NHB_dCOR    + P_NHB_dCRT  + P_NHB_dEXP  + P_NHB_dLCL  + P_NHB_dLRT
        P_NHB_wTrn     = P_NHB_wBRT  + P_NHB_wCOR    + P_NHB_wCRT  + P_NHB_wEXP  + P_NHB_wLCL  + P_NHB_wLRT
        P_NHB_tBRT     = P_NHB_dBRT  + P_NHB_wBRT
        P_NHB_tCOR     = P_NHB_dCOR  + P_NHB_wCOR 
        P_NHB_tCRT     = P_NHB_dCRT  + P_NHB_wCRT
        P_NHB_tEXP     = P_NHB_dEXP  + P_NHB_wEXP
        P_NHB_tLCL     = P_NHB_dLCL  + P_NHB_wLCL
        P_NHB_tLRT     = P_NHB_dLRT  + P_NHB_wLRT
        P_NHB_transit  = P_NHB_dTrn  + P_NHB_wTrn
        P_NHB_auto     = P_NHB_DA    + P_NHB_SR2     + P_NHB_SR3p
        P_NHB_motor    = P_NHB_auto  + P_NHB_transit
        P_NHB_nonmotor = P_NHB_walk  + P_NHB_bike
        P_NHB_all      = P_NHB_motor + P_NHB_nonmotor
        
        A_NHB_DA       = ROWSUM(351) / 100
        A_NHB_SR2      = ROWSUM(352) / 100
        A_NHB_SR3p     = ROWSUM(353) / 100
        A_NHB_wLCL     = ROWSUM(354) / 100
        A_NHB_dLCL     = ROWSUM(355) / 100
        A_NHB_wCOR     = ROWSUM(356) / 100
        A_NHB_dCOR     = ROWSUM(357) / 100
        A_NHB_wEXP     = ROWSUM(358) / 100
        A_NHB_dEXP     = ROWSUM(359) / 100
        A_NHB_wLRT     = ROWSUM(360) / 100
        A_NHB_dLRT     = ROWSUM(361) / 100
        A_NHB_wCRT     = ROWSUM(362) / 100
        A_NHB_dCRT     = ROWSUM(363) / 100
        A_NHB_wBRT     = ROWSUM(364) / 100
        A_NHB_dBRT     = ROWSUM(365) / 100
        A_NHB_walk     = ROWSUM(366) / 100
        A_NHB_bike     = ROWSUM(367) / 100

        ;HBO totals
        A_NHB_dTrn     = A_NHB_dBRT  + A_NHB_dCOR    + A_NHB_dCRT  + A_NHB_dEXP  + A_NHB_dLCL  + A_NHB_dLRT
        A_NHB_wTrn     = A_NHB_wBRT  + A_NHB_wCOR    + A_NHB_wCRT  + A_NHB_wEXP  + A_NHB_wLCL  + A_NHB_wLRT
        A_NHB_tBRT     = A_NHB_dBRT  + A_NHB_wBRT
        A_NHB_tCOR     = A_NHB_dCOR  + A_NHB_wCOR 
        A_NHB_tCRT     = A_NHB_dCRT  + A_NHB_wCRT
        A_NHB_tEXP     = A_NHB_dEXP  + A_NHB_wEXP
        A_NHB_tLCL     = A_NHB_dLCL  + A_NHB_wLCL
        A_NHB_tLRT     = A_NHB_dLRT  + A_NHB_wLRT
        A_NHB_transit  = A_NHB_dTrn  + A_NHB_wTrn
        A_NHB_auto     = A_NHB_DA    + A_NHB_SR2     + A_NHB_SR3p
        A_NHB_motor    = A_NHB_auto  + A_NHB_transit
        A_NHB_nonmotor = A_NHB_walk  + A_NHB_bike
        A_NHB_all      = A_NHB_motor + A_NHB_nonmotor

        
        ;HBC rowsums
        @xHBC@P_HBC_DA       = ROWSUM(401) / 100
        @xHBC@P_HBC_SR2      = ROWSUM(402) / 100
        @xHBC@P_HBC_SR3p     = ROWSUM(403) / 100
        @xHBC@P_HBC_wLCL     = ROWSUM(404) / 100
        @xHBC@P_HBC_dLCL     = ROWSUM(405) / 100
        @xHBC@P_HBC_wCOR     = ROWSUM(406) / 100
        @xHBC@P_HBC_dCOR     = ROWSUM(407) / 100
        @xHBC@P_HBC_wEXP     = ROWSUM(408) / 100
        @xHBC@P_HBC_dEXP     = ROWSUM(409) / 100
        @xHBC@P_HBC_wLRT     = ROWSUM(410) / 100
        @xHBC@P_HBC_dLRT     = ROWSUM(411) / 100
        @xHBC@P_HBC_wCRT     = ROWSUM(412) / 100
        @xHBC@P_HBC_dCRT     = ROWSUM(413) / 100
        @xHBC@P_HBC_wBRT     = ROWSUM(414) / 100
        @xHBC@P_HBC_dBRT     = ROWSUM(415) / 100
        @xHBC@P_HBC_walk     = ROWSUM(416) / 100
        @xHBC@P_HBC_bike     = ROWSUM(417) / 100

        ;HBC totals
        @xHBC@P_HBC_dTrn     = P_HBC_dBRT  + P_HBC_dCOR    + P_HBC_dCRT  + P_HBC_dEXP  + P_HBC_dLCL  + P_HBC_dLRT
        @xHBC@P_HBC_wTrn     = P_HBC_wBRT  + P_HBC_wCOR    + P_HBC_wCRT  + P_HBC_wEXP  + P_HBC_wLCL  + P_HBC_wLRT
        @xHBC@P_HBC_tBRT     = P_HBC_dBRT  + P_HBC_wBRT
        @xHBC@P_HBC_tCOR     = P_HBC_dCOR  + P_HBC_wCOR 
        @xHBC@P_HBC_tCRT     = P_HBC_dCRT  + P_HBC_wCRT
        @xHBC@P_HBC_tEXP     = P_HBC_dEXP  + P_HBC_wEXP
        @xHBC@P_HBC_tLCL     = P_HBC_dLCL  + P_HBC_wLCL
        @xHBC@P_HBC_tLRT     = P_HBC_dLRT  + P_HBC_wLRT
        @xHBC@P_HBC_transit  = P_HBC_dTrn  + P_HBC_wTrn
        @xHBC@P_HBC_auto     = P_HBC_DA    + P_HBC_SR2     + P_HBC_SR3p
        @xHBC@P_HBC_motor    = P_HBC_auto  + P_HBC_transit
        @xHBC@P_HBC_nonmotor = P_HBC_walk  + P_HBC_bike
        @xHBC@P_HBC_all      = P_HBC_motor + P_HBC_nonmotor
        
        @xHBC@A_HBC_DA       = ROWSUM(451) / 100
        @xHBC@A_HBC_SR2      = ROWSUM(452) / 100
        @xHBC@A_HBC_SR3p     = ROWSUM(453) / 100
        @xHBC@A_HBC_wLCL     = ROWSUM(454) / 100
        @xHBC@A_HBC_dLCL     = ROWSUM(455) / 100
        @xHBC@A_HBC_wCOR     = ROWSUM(456) / 100
        @xHBC@A_HBC_dCOR     = ROWSUM(457) / 100
        @xHBC@A_HBC_wEXP     = ROWSUM(458) / 100
        @xHBC@A_HBC_dEXP     = ROWSUM(459) / 100
        @xHBC@A_HBC_wLRT     = ROWSUM(460) / 100
        @xHBC@A_HBC_dLRT     = ROWSUM(461) / 100
        @xHBC@A_HBC_wCRT     = ROWSUM(462) / 100
        @xHBC@A_HBC_dCRT     = ROWSUM(463) / 100
        @xHBC@A_HBC_wBRT     = ROWSUM(464) / 100
        @xHBC@A_HBC_dBRT     = ROWSUM(465) / 100
        @xHBC@A_HBC_walk     = ROWSUM(466) / 100
        @xHBC@A_HBC_bike     = ROWSUM(467) / 100

        ;HBC totals
        @xHBC@A_HBC_dTrn     = A_HBC_dBRT  + A_HBC_dCOR    + A_HBC_dCRT  + A_HBC_dEXP  + A_HBC_dLCL  + A_HBC_dLRT
        @xHBC@A_HBC_wTrn     = A_HBC_wBRT  + A_HBC_wCOR    + A_HBC_wCRT  + A_HBC_wEXP  + A_HBC_wLCL  + A_HBC_wLRT
        @xHBC@A_HBC_tBRT     = A_HBC_dBRT  + A_HBC_wBRT
        @xHBC@A_HBC_tCOR     = A_HBC_dCOR  + A_HBC_wCOR 
        @xHBC@A_HBC_tCRT     = A_HBC_dCRT  + A_HBC_wCRT
        @xHBC@A_HBC_tEXP     = A_HBC_dEXP  + A_HBC_wEXP
        @xHBC@A_HBC_tLCL     = A_HBC_dLCL  + A_HBC_wLCL
        @xHBC@A_HBC_tLRT     = A_HBC_dLRT  + A_HBC_wLRT
        @xHBC@A_HBC_transit  = A_HBC_dTrn  + A_HBC_wTrn
        @xHBC@A_HBC_auto     = A_HBC_DA    + A_HBC_SR2     + A_HBC_SR3p
        @xHBC@A_HBC_motor    = A_HBC_auto  + A_HBC_transit
        @xHBC@A_HBC_nonmotor = A_HBC_walk  + A_HBC_bike
        @xHBC@A_HBC_all      = A_HBC_motor + A_HBC_nonmotor
        
        
        ;HBSch_PR
        @x3@mw[501] = mi.5.SchoolBus
        @x3@mw[502] = mi.5.DriveSelf
        @x3@mw[503] = mi.5.DropOff
        @x3@mw[504] = mi.5.Walk
        @x3@mw[505] = mi.5.Bike
        @x3@mw[506] = mi.5.TotHBSch
        @x1@mw[501] = mi.5.Pk_SchoolBus
        @x1@mw[502] = mi.5.Pk_DriveSelf
        @x1@mw[503] = mi.5.Pk_DropOff
        @x1@mw[504] = mi.5.Pk_Walk
        @x1@mw[505] = mi.5.Pk_Bike
        @x1@mw[506] = mi.5.Pk_TotHBSch
        @x2@mw[501] = mi.5.Ok_SchoolBus
        @x2@mw[502] = mi.5.Ok_DriveSelf
        @x2@mw[503] = mi.5.Ok_DropOff
        @x2@mw[504] = mi.5.Ok_Walk
        @x2@mw[505] = mi.5.Ok_Bike
        @x2@mw[506] = mi.5.Ok_TotHBSch
        
        ;HBSch_SC
        @x3@mw[601] = mi.6.SchoolBus
        @x3@mw[602] = mi.6.DriveSelf
        @x3@mw[603] = mi.6.DropOff
        @x3@mw[604] = mi.6.Walk
        @x3@mw[605] = mi.6.Bike
        @x3@mw[606] = mi.6.TotHBSch
        @x1@mw[601] = mi.6.Pk_SchoolBus
        @x1@mw[602] = mi.6.Pk_DriveSelf
        @x1@mw[603] = mi.6.Pk_DropOff
        @x1@mw[604] = mi.6.Pk_Walk
        @x1@mw[605] = mi.6.Pk_Bike
        @x1@mw[606] = mi.6.Pk_TotHBSch
        @x2@mw[601] = mi.6.Ok_SchoolBus
        @x2@mw[602] = mi.6.Ok_DriveSelf
        @x2@mw[603] = mi.6.Ok_DropOff
        @x2@mw[604] = mi.6.Ok_Walk
        @x2@mw[605] = mi.6.Ok_Bike
        @x2@mw[606] = mi.6.Ok_TotHBSch
        
        ;HBSch_PR transposed
        @x3@mw[551] = mi.5.SchoolBus.T
        @x3@mw[552] = mi.5.DriveSelf.T
        @x3@mw[553] = mi.5.DropOff.T
        @x3@mw[554] = mi.5.Walk.T
        @x3@mw[555] = mi.5.Bike.T
        @x3@mw[556] = mi.5.TotHBSch.T
        @x1@mw[551] = mi.5.Pk_SchoolBus.T
        @x1@mw[552] = mi.5.Pk_DriveSelf.T
        @x1@mw[553] = mi.5.Pk_DropOff.T
        @x1@mw[554] = mi.5.Pk_Walk.T
        @x1@mw[555] = mi.5.Pk_Bike.T
        @x1@mw[556] = mi.5.Pk_TotHBSch.T
        @x2@mw[551] = mi.5.Ok_SchoolBus.T
        @x2@mw[552] = mi.5.Ok_DriveSelf.T
        @x2@mw[553] = mi.5.Ok_DropOff.T
        @x2@mw[554] = mi.5.Ok_Walk.T
        @x2@mw[555] = mi.5.Ok_Bike.T
        @x2@mw[556] = mi.5.Ok_TotHBSch.T
        
        ;HBSch_SC transposed
        @x3@mw[651] = mi.6.SchoolBus.T
        @x3@mw[652] = mi.6.DriveSelf.T
        @x3@mw[653] = mi.6.DropOff.T
        @x3@mw[654] = mi.6.Walk.T
        @x3@mw[655] = mi.6.Bike.T
        @x3@mw[656] = mi.6.TotHBSch.T
        @x1@mw[651] = mi.6.Pk_SchoolBus.T
        @x1@mw[652] = mi.6.Pk_DriveSelf.T
        @x1@mw[653] = mi.6.Pk_DropOff.T
        @x1@mw[654] = mi.6.Pk_Walk.T
        @x1@mw[655] = mi.6.Pk_Bike.T
        @x1@mw[656] = mi.6.Pk_TotHBSch.T
        @x2@mw[651] = mi.6.Ok_SchoolBus.T
        @x2@mw[652] = mi.6.Ok_DriveSelf.T
        @x2@mw[653] = mi.6.Ok_DropOff.T
        @x2@mw[654] = mi.6.Ok_Walk.T
        @x2@mw[655] = mi.6.Ok_Bike.T
        @x2@mw[656] = mi.6.Ok_TotHBSch.T
        
        
        ;HBSch_PR rowsums
        P_HBSch_PR_motor    = ROWSUM(501) + ROWSUM(502) + ROWSUM(503) / 100
        P_HBSch_PR_nonmotor = ROWSUM(504) + ROWSUM(505)               / 100
        P_HBSch_PR_transit  = 0                                       / 100
        P_HBSch_PR_auto     = ROWSUM(501) + ROWSUM(502) + ROWSUM(503) / 100
        P_HBSch_PR_DA       = 0                                       / 100
        P_HBSch_PR_SR2      = 0                                       / 100
        P_HBSch_PR_SR3p     = 0                                       / 100
        P_HBSch_PR_wLCL     = 0                                       / 100
        P_HBSch_PR_dLCL     = 0                                       / 100
        P_HBSch_PR_wCOR     = 0                                       / 100
        P_HBSch_PR_dCOR     = 0                                       / 100
        P_HBSch_PR_wEXP     = 0                                       / 100
        P_HBSch_PR_dEXP     = 0                                       / 100
        P_HBSch_PR_wLRT     = 0                                       / 100
        P_HBSch_PR_dLRT     = 0                                       / 100
        P_HBSch_PR_wCRT     = 0                                       / 100
        P_HBSch_PR_dCRT     = 0                                       / 100
        P_HBSch_PR_wTRN     = 0                                       / 100
        P_HBSch_PR_dTRN     = 0                                       / 100
        P_HBSch_PR_wBRT     = 0                                       / 100
        P_HBSch_PR_dBRT     = 0                                       / 100
        P_HBSch_PR_walk     = ROWSUM(504)                             / 100
        P_HBSch_PR_bike     = ROWSUM(505)                             / 100
        
        ;HBSch_PR rowsums
        A_HBSch_PR_motor    = ROWSUM(551) + ROWSUM(552) + ROWSUM(553) / 100
        A_HBSch_PR_nonmotor = ROWSUM(554) + ROWSUM(555)               / 100
        A_HBSch_PR_transit  = 0                                       / 100
        A_HBSch_PR_auto     = ROWSUM(551) + ROWSUM(552) + ROWSUM(553) / 100
        A_HBSch_PR_DA       = 0                                       / 100
        A_HBSch_PR_SR2      = 0                                       / 100
        A_HBSch_PR_SR3p     = 0                                       / 100
        A_HBSch_PR_wLCL     = 0                                       / 100
        A_HBSch_PR_dLCL     = 0                                       / 100
        A_HBSch_PR_wCOR     = 0                                       / 100
        A_HBSch_PR_dCOR     = 0                                       / 100
        A_HBSch_PR_wEXP     = 0                                       / 100
        A_HBSch_PR_dEXP     = 0                                       / 100
        A_HBSch_PR_wLRT     = 0                                       / 100
        A_HBSch_PR_dLRT     = 0                                       / 100
        A_HBSch_PR_wCRT     = 0                                       / 100
        A_HBSch_PR_dCRT     = 0                                       / 100
        A_HBSch_PR_wTRN     = 0                                       / 100
        A_HBSch_PR_dTRN     = 0                                       / 100
        A_HBSch_PR_wBRT     = 0                                       / 100
        A_HBSch_PR_dBRT     = 0                                       / 100
        A_HBSch_PR_walk     = ROWSUM(554)                             / 100
        A_HBSch_PR_bike     = ROWSUM(555)                             / 100
        
        ;HBSch_SC rowsums
        P_HBSch_SC_motor    = ROWSUM(601) + ROWSUM(602) + ROWSUM(603) / 100
        P_HBSch_SC_nonmotor = ROWSUM(604) + ROWSUM(605)               / 100
        P_HBSch_SC_transit  = 0                                       / 100
        P_HBSch_SC_auto     = ROWSUM(601) + ROWSUM(602) + ROWSUM(603) / 100
        P_HBSch_SC_DA       = 0                                       / 100
        P_HBSch_SC_SR2      = 0                                       / 100
        P_HBSch_SC_SR3p     = 0                                       / 100
        P_HBSch_SC_wLCL     = 0                                       / 100
        P_HBSch_SC_dLCL     = 0                                       / 100
        P_HBSch_SC_wCOR     = 0                                       / 100
        P_HBSch_SC_dCOR     = 0                                       / 100
        P_HBSch_SC_wEXP     = 0                                       / 100
        P_HBSch_SC_dEXP     = 0                                       / 100
        P_HBSch_SC_wLRT     = 0                                       / 100
        P_HBSch_SC_dLRT     = 0                                       / 100
        P_HBSch_SC_wCRT     = 0                                       / 100
        P_HBSch_SC_dCRT     = 0                                       / 100
        P_HBSch_SC_wTRN     = 0                                       / 100
        P_HBSch_SC_dTRN     = 0                                       / 100
        P_HBSch_SC_wBRT     = 0                                       / 100
        P_HBSch_SC_dBRT     = 0                                       / 100
        P_HBSch_SC_walk     = ROWSUM(604)                             / 100
        P_HBSch_SC_bike     = ROWSUM(605)                             / 100
        
        ;HBSch_SC rowsums
        A_HBSch_SC_motor    = ROWSUM(651) + ROWSUM(652) + ROWSUM(653) / 100
        A_HBSch_SC_nonmotor = ROWSUM(654) + ROWSUM(655)               / 100
        A_HBSch_SC_transit  = 0                                       / 100
        A_HBSch_SC_auto     = ROWSUM(651) + ROWSUM(652) + ROWSUM(653) / 100
        A_HBSch_SC_DA       = 0                                       / 100
        A_HBSch_SC_SR2      = 0                                       / 100
        A_HBSch_SC_SR3p     = 0                                       / 100
        A_HBSch_SC_wLCL     = 0                                       / 100
        A_HBSch_SC_dLCL     = 0                                       / 100
        A_HBSch_SC_wCOR     = 0                                       / 100
        A_HBSch_SC_dCOR     = 0                                       / 100
        A_HBSch_SC_wEXP     = 0                                       / 100
        A_HBSch_SC_dEXP     = 0                                       / 100
        A_HBSch_SC_wLRT     = 0                                       / 100
        A_HBSch_SC_dLRT     = 0                                       / 100
        A_HBSch_SC_wCRT     = 0                                       / 100
        A_HBSch_SC_dCRT     = 0                                       / 100
        A_HBSch_SC_wTRN     = 0                                       / 100
        A_HBSch_SC_dTRN     = 0                                       / 100
        A_HBSch_SC_wBRT     = 0                                       / 100
        A_HBSch_SC_dBRT     = 0                                       / 100
        A_HBSch_SC_walk     = ROWSUM(654)                             / 100
        A_HBSch_SC_bike     = ROWSUM(655)                             / 100
        
        ;HBSch totals
        P_HBSch_motor    = P_HBSch_PR_motor    + P_HBSch_SC_motor
        P_HBSch_nonmotor = P_HBSch_PR_nonmotor + P_HBSch_SC_nonmotor
        P_HBSch_all      = P_HBSch_motor       + P_HBSch_nonmotor
        P_HBSch_auto     = P_HBSch_PR_auto     + P_HBSch_SC_auto
        P_HBSch_bike     = P_HBSch_PR_bike     + P_HBSch_SC_bike
        P_HBSch_walk     = P_HBSch_PR_walk     + P_HBSch_SC_walk
        P_HBSch_transit  = 0
        P_HBSch_dTrn     = 0
        P_HBSch_wTrn     = 0
        P_HBSch_tBRT     = 0
        P_HBSch_tCOR     = 0
        P_HBSch_tCRT     = 0
        P_HBSch_tEXP     = 0
        P_HBSch_tLCL     = 0
        P_HBSch_tLRT     = 0
        P_HBSch_wLCL     = 0
        P_HBSch_dLCL     = 0
        P_HBSch_wCOR     = 0
        P_HBSch_dCOR     = 0
        P_HBSch_wEXP     = 0
        P_HBSch_dEXP     = 0
        P_HBSch_wLRT     = 0
        P_HBSch_dLRT     = 0
        P_HBSch_wCRT     = 0
        P_HBSch_dCRT     = 0
        P_HBSch_wBRT     = 0
        P_HBSch_dBRT     = 0

        A_HBSch_motor    = A_HBSch_PR_motor    + A_HBSch_SC_motor
        A_HBSch_nonmotor = A_HBSch_PR_nonmotor + A_HBSch_SC_nonmotor
        A_HBSch_all      = A_HBSch_motor       + A_HBSch_nonmotor
        A_HBSch_auto     = A_HBSch_PR_auto     + A_HBSch_SC_auto
        A_HBSch_bike     = A_HBSch_PR_bike     + A_HBSch_SC_bike
        A_HBSch_walk     = A_HBSch_PR_walk     + A_HBSch_SC_walk
        A_HBSch_transit  = 0
        A_HBSch_tBRT     = 0
        A_HBSch_tCOR     = 0
        A_HBSch_tCRT     = 0
        A_HBSch_tEXP     = 0
        A_HBSch_tLCL     = 0
        A_HBSch_tLRT     = 0
        A_HBSch_wLCL     = 0
        A_HBSch_dLCL     = 0
        A_HBSch_wCOR     = 0
        A_HBSch_dCOR     = 0
        A_HBSch_wEXP     = 0
        A_HBSch_dEXP     = 0
        A_HBSch_wLRT     = 0
        A_HBSch_dLRT     = 0
        A_HBSch_wCRT     = 0
        A_HBSch_dCRT     = 0
        A_HBSch_wBRT     = 0
        A_HBSch_dBRT     = 0
        A_HBSch_dTrn     = 0
        A_HBSch_wTrn     = 0

        ; Summarize all purposes
        P_All_motor    = P_HBW_motor    + P_HBO_motor    + P_NHB_motor    + P_HBSch_motor    @xHBC@ + P_HBC_motor    
        P_All_nonmotor = P_HBW_nonmotor + P_HBO_nonmotor + P_NHB_nonmotor + P_HBSch_nonmotor @xHBC@ + P_HBC_nonmotor 
        P_All_all      = P_HBW_all      + P_HBO_all      + P_NHB_all      + P_HBSch_all      @xHBC@ + P_HBC_all      
        P_All_auto     = P_HBW_auto     + P_HBO_auto     + P_NHB_auto     + P_HBSch_auto     @xHBC@ + P_HBC_auto     
        P_All_bike     = P_HBW_bike     + P_HBO_bike     + P_NHB_bike     + P_HBSch_bike     @xHBC@ + P_HBC_bike     
        P_All_walk     = P_HBW_walk     + P_HBO_walk     + P_NHB_walk     + P_HBSch_walk     @xHBC@ + P_HBC_walk     
        P_All_transit  = P_HBW_transit  + P_HBO_transit  + P_NHB_transit  + P_HBSch_transit  @xHBC@ + P_HBC_transit  
        P_All_dTrn     = P_HBW_dTrn     + P_HBO_dTrn     + P_NHB_dTrn     + P_HBSch_dTrn     @xHBC@ + P_HBC_dTrn     
        P_All_wTrn     = P_HBW_wTrn     + P_HBO_wTrn     + P_NHB_wTrn     + P_HBSch_wTrn     @xHBC@ + P_HBC_wTrn     
        P_All_tBRT     = P_HBW_tBRT     + P_HBO_tBRT     + P_NHB_tBRT     + P_HBSch_tBRT     @xHBC@ + P_HBC_tBRT     
        P_All_tCOR     = P_HBW_tCOR     + P_HBO_tCOR     + P_NHB_tCOR     + P_HBSch_tCOR     @xHBC@ + P_HBC_tCOR     
        P_All_tCRT     = P_HBW_tCRT     + P_HBO_tCRT     + P_NHB_tCRT     + P_HBSch_tCRT     @xHBC@ + P_HBC_tCRT     
        P_All_tEXP     = P_HBW_tEXP     + P_HBO_tEXP     + P_NHB_tEXP     + P_HBSch_tEXP     @xHBC@ + P_HBC_tEXP     
        P_All_tLCL     = P_HBW_tLCL     + P_HBO_tLCL     + P_NHB_tLCL     + P_HBSch_tLCL     @xHBC@ + P_HBC_tLCL     
        P_All_tLRT     = P_HBW_tLRT     + P_HBO_tLRT     + P_NHB_tLRT     + P_HBSch_tLRT     @xHBC@ + P_HBC_tLRT     
        P_All_wLCL     = P_HBW_wLCL     + P_HBO_wLCL     + P_NHB_wLCL     + P_HBSch_wLCL     @xHBC@ + P_HBC_wLCL     
        P_All_dLCL     = P_HBW_dLCL     + P_HBO_dLCL     + P_NHB_dLCL     + P_HBSch_dLCL     @xHBC@ + P_HBC_dLCL     
        P_All_wCOR     = P_HBW_wCOR     + P_HBO_wCOR     + P_NHB_wCOR     + P_HBSch_wCOR     @xHBC@ + P_HBC_wCOR     
        P_All_dCOR     = P_HBW_dCOR     + P_HBO_dCOR     + P_NHB_dCOR     + P_HBSch_dCOR     @xHBC@ + P_HBC_dCOR     
        P_All_wEXP     = P_HBW_wEXP     + P_HBO_wEXP     + P_NHB_wEXP     + P_HBSch_wEXP     @xHBC@ + P_HBC_wEXP     
        P_All_dEXP     = P_HBW_dEXP     + P_HBO_dEXP     + P_NHB_dEXP     + P_HBSch_dEXP     @xHBC@ + P_HBC_dEXP     
        P_All_wLRT     = P_HBW_wLRT     + P_HBO_wLRT     + P_NHB_wLRT     + P_HBSch_wLRT     @xHBC@ + P_HBC_wLRT     
        P_All_dLRT     = P_HBW_dLRT     + P_HBO_dLRT     + P_NHB_dLRT     + P_HBSch_dLRT     @xHBC@ + P_HBC_dLRT     
        P_All_wCRT     = P_HBW_wCRT     + P_HBO_wCRT     + P_NHB_wCRT     + P_HBSch_wCRT     @xHBC@ + P_HBC_wCRT     
        P_All_dCRT     = P_HBW_dCRT     + P_HBO_dCRT     + P_NHB_dCRT     + P_HBSch_dCRT     @xHBC@ + P_HBC_dCRT     
        P_All_wBRT     = P_HBW_wBRT     + P_HBO_wBRT     + P_NHB_wBRT     + P_HBSch_wBRT     @xHBC@ + P_HBC_wBRT     
        P_All_dBRT     = P_HBW_dBRT     + P_HBO_dBRT     + P_NHB_dBRT     + P_HBSch_dBRT     @xHBC@ + P_HBC_dBRT     

        ; Summarize all purposes
        A_All_motor    = A_HBW_motor    + A_HBO_motor    + A_NHB_motor    + A_HBSch_motor    @xHBC@ + A_HBC_motor    
        A_All_nonmotor = A_HBW_nonmotor + A_HBO_nonmotor + A_NHB_nonmotor + A_HBSch_nonmotor @xHBC@ + A_HBC_nonmotor 
        A_All_all      = A_HBW_all      + A_HBO_all      + A_NHB_all      + A_HBSch_all      @xHBC@ + A_HBC_all      
        A_All_auto     = A_HBW_auto     + A_HBO_auto     + A_NHB_auto     + A_HBSch_auto     @xHBC@ + A_HBC_auto     
        A_All_bike     = A_HBW_bike     + A_HBO_bike     + A_NHB_bike     + A_HBSch_bike     @xHBC@ + A_HBC_bike     
        A_All_walk     = A_HBW_walk     + A_HBO_walk     + A_NHB_walk     + A_HBSch_walk     @xHBC@ + A_HBC_walk     
        A_All_transit  = A_HBW_transit  + A_HBO_transit  + A_NHB_transit  + A_HBSch_transit  @xHBC@ + A_HBC_transit  
        A_All_dTrn     = A_HBW_dTrn     + A_HBO_dTrn     + A_NHB_dTrn     + A_HBSch_dTrn     @xHBC@ + A_HBC_dTrn     
        A_All_wTrn     = A_HBW_wTrn     + A_HBO_wTrn     + A_NHB_wTrn     + A_HBSch_wTrn     @xHBC@ + A_HBC_wTrn     
        A_All_tBRT     = A_HBW_tBRT     + A_HBO_tBRT     + A_NHB_tBRT     + A_HBSch_tBRT     @xHBC@ + A_HBC_tBRT     
        A_All_tCOR     = A_HBW_tCOR     + A_HBO_tCOR     + A_NHB_tCOR     + A_HBSch_tCOR     @xHBC@ + A_HBC_tCOR     
        A_All_tCRT     = A_HBW_tCRT     + A_HBO_tCRT     + A_NHB_tCRT     + A_HBSch_tCRT     @xHBC@ + A_HBC_tCRT     
        A_All_tEXP     = A_HBW_tEXP     + A_HBO_tEXP     + A_NHB_tEXP     + A_HBSch_tEXP     @xHBC@ + A_HBC_tEXP     
        A_All_tLCL     = A_HBW_tLCL     + A_HBO_tLCL     + A_NHB_tLCL     + A_HBSch_tLCL     @xHBC@ + A_HBC_tLCL     
        A_All_tLRT     = A_HBW_tLRT     + A_HBO_tLRT     + A_NHB_tLRT     + A_HBSch_tLRT     @xHBC@ + A_HBC_tLRT     
        A_All_wLCL     = A_HBW_wLCL     + A_HBO_wLCL     + A_NHB_wLCL     + A_HBSch_wLCL     @xHBC@ + A_HBC_wLCL     
        A_All_dLCL     = A_HBW_dLCL     + A_HBO_dLCL     + A_NHB_dLCL     + A_HBSch_dLCL     @xHBC@ + A_HBC_dLCL     
        A_All_wCOR     = A_HBW_wCOR     + A_HBO_wCOR     + A_NHB_wCOR     + A_HBSch_wCOR     @xHBC@ + A_HBC_wCOR     
        A_All_dCOR     = A_HBW_dCOR     + A_HBO_dCOR     + A_NHB_dCOR     + A_HBSch_dCOR     @xHBC@ + A_HBC_dCOR     
        A_All_wEXP     = A_HBW_wEXP     + A_HBO_wEXP     + A_NHB_wEXP     + A_HBSch_wEXP     @xHBC@ + A_HBC_wEXP     
        A_All_dEXP     = A_HBW_dEXP     + A_HBO_dEXP     + A_NHB_dEXP     + A_HBSch_dEXP     @xHBC@ + A_HBC_dEXP     
        A_All_wLRT     = A_HBW_wLRT     + A_HBO_wLRT     + A_NHB_wLRT     + A_HBSch_wLRT     @xHBC@ + A_HBC_wLRT     
        A_All_dLRT     = A_HBW_dLRT     + A_HBO_dLRT     + A_NHB_dLRT     + A_HBSch_dLRT     @xHBC@ + A_HBC_dLRT     
        A_All_wCRT     = A_HBW_wCRT     + A_HBO_wCRT     + A_NHB_wCRT     + A_HBSch_wCRT     @xHBC@ + A_HBC_wCRT     
        A_All_dCRT     = A_HBW_dCRT     + A_HBO_dCRT     + A_NHB_dCRT     + A_HBSch_dCRT     @xHBC@ + A_HBC_dCRT     
        A_All_wBRT     = A_HBW_wBRT     + A_HBO_wBRT     + A_NHB_wBRT     + A_HBSch_wBRT     @xHBC@ + A_HBC_wBRT     
        A_All_dBRT     = A_HBW_dBRT     + A_HBO_dBRT     + A_NHB_dBRT     + A_HBSch_dBRT     @xHBC@ + A_HBC_dBRT     
        

        ;Print out All
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='All',          ;Purpose
             '@out@',        ;Period
             'P',            ;PA
             i,              ;TAZID
             P_All_all,      ;All
             P_All_auto,     ;Auto
             P_All_bike,     ;Bike
             P_All_motor,    ;Moto
             P_All_nonmotor, ;NonM
             P_All_walk,     ;Walk
             P_All_dBRT,     ;dBRT
             P_All_dCOR,     ;dCOR
             P_All_dCRT,     ;dCRT
             P_All_dEXP,     ;dEXP
             P_All_dLCL,     ;dLCL
             P_All_dLRT,     ;dLRT
             P_All_dTrn,     ;dTrn
             P_All_tBRT,     ;tBRT
             P_All_tCOR,     ;tCOR
             P_All_tCRT,     ;tCRT
             P_All_tEXP,     ;tEXP
             P_All_tLCL,     ;tLCL
             P_All_tLRT,     ;tLRT
             P_All_transit,  ;tTrn
             P_All_wBRT,     ;wBRT
             P_All_wCOR,     ;wCOR
             P_All_wCRT,     ;wCRT
             P_All_wEXP,     ;wEXP
             P_All_wLCL,     ;wLCL
             P_All_wLRT,     ;wLRT
             P_All_wTrn      ;wTrn
        

        ;Print out All
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='All',          ;Purpose
             '@out@',        ;Period
             'A',            ;PA
             i,              ;TAZID
             A_All_all,      ;All
             A_All_auto,     ;Auto
             A_All_bike,     ;Bike
             A_All_motor,    ;Moto
             A_All_nonmotor, ;NonM
             A_All_walk,     ;Walk
             A_All_dBRT,     ;dBRT
             A_All_dCOR,     ;dCOR
             A_All_dCRT,     ;dCRT
             A_All_dEXP,     ;dEXP
             A_All_dLCL,     ;dLCL
             A_All_dLRT,     ;dLRT
             A_All_dTrn,     ;dTrn
             A_All_tBRT,     ;tBRT
             A_All_tCOR,     ;tCOR
             A_All_tCRT,     ;tCRT
             A_All_tEXP,     ;tEXP
             A_All_tLCL,     ;tLCL
             A_All_tLRT,     ;tLRT
             A_All_transit,  ;tTrn
             A_All_wBRT,     ;wBRT
             A_All_wCOR,     ;wCOR
             A_All_wCRT,     ;wCRT
             A_All_wEXP,     ;wEXP
             A_All_wLCL,     ;wLCL
             A_All_wLRT,     ;wLRT
             A_All_wTrn      ;wTrn
        

        ;Print out HBW
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBW',          ;Purpose
             '@out@',        ;Period
             'P',            ;PA
             i,              ;TAZID
             P_HBW_all,      ;All
             P_HBW_auto,     ;Auto
             P_HBW_bike,     ;Bike
             P_HBW_motor,    ;Moto
             P_HBW_nonmotor, ;NonM
             P_HBW_walk,     ;Walk
             P_HBW_dBRT,     ;dBRT
             P_HBW_dCOR,     ;dCOR
             P_HBW_dCRT,     ;dCRT
             P_HBW_dEXP,     ;dEXP
             P_HBW_dLCL,     ;dLCL
             P_HBW_dLRT,     ;dLRT
             P_HBW_dTrn,     ;dTrn
             P_HBW_tBRT,     ;tBRT
             P_HBW_tCOR,     ;tCOR
             P_HBW_tCRT,     ;tCRT
             P_HBW_tEXP,     ;tEXP
             P_HBW_tLCL,     ;tLCL
             P_HBW_tLRT,     ;tLRT
             P_HBW_transit,  ;tTrn
             P_HBW_wBRT,     ;wBRT
             P_HBW_wCOR,     ;wCOR
             P_HBW_wCRT,     ;wCRT
             P_HBW_wEXP,     ;wEXP
             P_HBW_wLCL,     ;wLCL
             P_HBW_wLRT,     ;wLRT
             P_HBW_wTrn      ;wTrn

        ;Print out HBW
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBW',          ;Purpose
             '@out@',        ;Period
             'A',            ;PA
             i,              ;TAZID
             A_HBW_all,      ;All
             A_HBW_auto,     ;Auto
             A_HBW_bike,     ;Bike
             A_HBW_motor,    ;Moto
             A_HBW_nonmotor, ;NonM
             A_HBW_walk,     ;Walk
             A_HBW_dBRT,     ;dBRT
             A_HBW_dCOR,     ;dCOR
             A_HBW_dCRT,     ;dCRT
             A_HBW_dEXP,     ;dEXP
             A_HBW_dLCL,     ;dLCL
             A_HBW_dLRT,     ;dLRT
             A_HBW_dTrn,     ;dTrn
             A_HBW_tBRT,     ;tBRT
             A_HBW_tCOR,     ;tCOR
             A_HBW_tCRT,     ;tCRT
             A_HBW_tEXP,     ;tEXP
             A_HBW_tLCL,     ;tLCL
             A_HBW_tLRT,     ;tLRT
             A_HBW_transit,  ;tTrn
             A_HBW_wBRT,     ;wBRT
             A_HBW_wCOR,     ;wCOR
             A_HBW_wCRT,     ;wCRT
             A_HBW_wEXP,     ;wEXP
             A_HBW_wLCL,     ;wLCL
             A_HBW_wLRT,     ;wLRT
             A_HBW_wTrn      ;wTrn

        ;Print out HBO
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBO',          ;Purpose
             '@out@',        ;Period
             'P',            ;PA
             i,              ;TAZID
             P_HBO_all,      ;All
             P_HBO_auto,     ;Auto
             P_HBO_bike,     ;Bike
             P_HBO_motor,    ;Moto
             P_HBO_nonmotor, ;NonM
             P_HBO_walk,     ;Walk
             P_HBO_dBRT,     ;dBRT
             P_HBO_dCOR,     ;dCOR
             P_HBO_dCRT,     ;dCRT
             P_HBO_dEXP,     ;dEXP
             P_HBO_dLCL,     ;dLCL
             P_HBO_dLRT,     ;dLRT
             P_HBO_dTrn,     ;dTrn
             P_HBO_tBRT,     ;tBRT
             P_HBO_tCOR,     ;tCOR
             P_HBO_tCRT,     ;tCRT
             P_HBO_tEXP,     ;tEXP
             P_HBO_tLCL,     ;tLCL
             P_HBO_tLRT,     ;tLRT
             P_HBO_transit,  ;tTrn
             P_HBO_wBRT,     ;wBRT
             P_HBO_wCOR,     ;wCOR
             P_HBO_wCRT,     ;wCRT
             P_HBO_wEXP,     ;wEXP
             P_HBO_wLCL,     ;wLCL
             P_HBO_wLRT,     ;wLRT
             P_HBO_wTrn      ;wTrn

        ;Print out HBO
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBO',          ;Purpose
             '@out@',        ;Period
             'A',            ;PA
             i,              ;TAZID
             A_HBO_all,      ;All
             A_HBO_auto,     ;Auto
             A_HBO_bike,     ;Bike
             A_HBO_motor,    ;Moto
             A_HBO_nonmotor, ;NonM
             A_HBO_walk,     ;Walk
             A_HBO_dBRT,     ;dBRT
             A_HBO_dCOR,     ;dCOR
             A_HBO_dCRT,     ;dCRT
             A_HBO_dEXP,     ;dEXP
             A_HBO_dLCL,     ;dLCL
             A_HBO_dLRT,     ;dLRT
             A_HBO_dTrn,     ;dTrn
             A_HBO_tBRT,     ;tBRT
             A_HBO_tCOR,     ;tCOR
             A_HBO_tCRT,     ;tCRT
             A_HBO_tEXP,     ;tEXP
             A_HBO_tLCL,     ;tLCL
             A_HBO_tLRT,     ;tLRT
             A_HBO_transit,  ;tTrn
             A_HBO_wBRT,     ;wBRT
             A_HBO_wCOR,     ;wCOR
             A_HBO_wCRT,     ;wCRT
             A_HBO_wEXP,     ;wEXP
             A_HBO_wLCL,     ;wLCL
             A_HBO_wLRT,     ;wLRT
             A_HBO_wTrn      ;wTrn

        ;Print out NHB
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='NHB',          ;Purpose
             '@out@',        ;Period
             'P',            ;PA
             i,              ;TAZID
             P_NHB_all,      ;All
             P_NHB_auto,     ;Auto
             P_NHB_bike,     ;Bike
             P_NHB_motor,    ;Moto
             P_NHB_nonmotor, ;NonM
             P_NHB_walk,     ;Walk
             P_NHB_dBRT,     ;dBRT
             P_NHB_dCOR,     ;dCOR
             P_NHB_dCRT,     ;dCRT
             P_NHB_dEXP,     ;dEXP
             P_NHB_dLCL,     ;dLCL
             P_NHB_dLRT,     ;dLRT
             P_NHB_dTrn,     ;dTrn
             P_NHB_tBRT,     ;tBRT
             P_NHB_tCOR,     ;tCOR
             P_NHB_tCRT,     ;tCRT
             P_NHB_tEXP,     ;tEXP
             P_NHB_tLCL,     ;tLCL
             P_NHB_tLRT,     ;tLRT
             P_NHB_transit,  ;tTrn
             P_NHB_wBRT,     ;wBRT
             P_NHB_wCOR,     ;wCOR
             P_NHB_wCRT,     ;wCRT
             P_NHB_wEXP,     ;wEXP
             P_NHB_wLCL,     ;wLCL
             P_NHB_wLRT,     ;wLRT
             P_NHB_wTrn      ;wTrn

        ;Print out NHB
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='NHB',          ;Purpose
             '@out@',        ;Period
             'A',            ;PA
             i,              ;TAZID
             A_NHB_all,      ;All
             A_NHB_auto,     ;Auto
             A_NHB_bike,     ;Bike
             A_NHB_motor,    ;Moto
             A_NHB_nonmotor, ;NonM
             A_NHB_walk,     ;Walk
             A_NHB_dBRT,     ;dBRT
             A_NHB_dCOR,     ;dCOR
             A_NHB_dCRT,     ;dCRT
             A_NHB_dEXP,     ;dEXP
             A_NHB_dLCL,     ;dLCL
             A_NHB_dLRT,     ;dLRT
             A_NHB_dTrn,     ;dTrn
             A_NHB_tBRT,     ;tBRT
             A_NHB_tCOR,     ;tCOR
             A_NHB_tCRT,     ;tCRT
             A_NHB_tEXP,     ;tEXP
             A_NHB_tLCL,     ;tLCL
             A_NHB_tLRT,     ;tLRT
             A_NHB_transit,  ;tTrn
             A_NHB_wBRT,     ;wBRT
             A_NHB_wCOR,     ;wCOR
             A_NHB_wCRT,     ;wCRT
             A_NHB_wEXP,     ;wEXP
             A_NHB_wLCL,     ;wLCL
             A_NHB_wLRT,     ;wLRT
             A_NHB_wTrn      ;wTrn

              ;Print out HBC
        @xHBC@PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        @xHBC@APPEND=T,
        @xHBC@CSV=T,
        @xHBC@LIST='HBC',          ;Purpose
        @xHBC@     '@out@',        ;Period
        @xHBC@     'P',            ;PA
        @xHBC@     i,              ;TAZID
        @xHBC@     P_HBC_all,      ;All
        @xHBC@     P_HBC_auto,     ;Auto
        @xHBC@     P_HBC_bike,     ;Bike
        @xHBC@     P_HBC_motor,    ;Moto
        @xHBC@     P_HBC_nonmotor, ;NonM
        @xHBC@     P_HBC_walk,     ;Walk
        @xHBC@     P_HBC_dBRT,     ;dBRT
        @xHBC@     P_HBC_dCOR,     ;dCOR
        @xHBC@     P_HBC_dCRT,     ;dCRT
        @xHBC@     P_HBC_dEXP,     ;dEXP
        @xHBC@     P_HBC_dLCL,     ;dLCL
        @xHBC@     P_HBC_dLRT,     ;dLRT
        @xHBC@     P_HBC_dTrn,     ;dTrn
        @xHBC@     P_HBC_tBRT,     ;tBRT
        @xHBC@     P_HBC_tCOR,     ;tCOR
        @xHBC@     P_HBC_tCRT,     ;tCRT
        @xHBC@     P_HBC_tEXP,     ;tEXP
        @xHBC@     P_HBC_tLCL,     ;tLCL
        @xHBC@     P_HBC_tLRT,     ;tLRT
        @xHBC@     P_HBC_transit,  ;tTrn
        @xHBC@     P_HBC_wBRT,     ;wBRT
        @xHBC@     P_HBC_wCOR,     ;wCOR
        @xHBC@     P_HBC_wCRT,     ;wCRT
        @xHBC@     P_HBC_wEXP,     ;wEXP
        @xHBC@     P_HBC_wLCL,     ;wLCL
        @xHBC@     P_HBC_wLRT,     ;wLRT
        @xHBC@     P_HBC_wTrn      ;wTrn

              ;Print out HBC
        @xHBC@PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        @xHBC@APPEND=T,
        @xHBC@CSV=T,
        @xHBC@LIST='HBC',          ;Purpose
        @xHBC@     '@out@',        ;Period
        @xHBC@     'A',            ;PA
        @xHBC@     i,              ;TAZID
        @xHBC@     A_HBC_all,      ;All
        @xHBC@     A_HBC_auto,     ;Auto
        @xHBC@     A_HBC_bike,     ;Bike
        @xHBC@     A_HBC_motor,    ;Moto
        @xHBC@     A_HBC_nonmotor, ;NonM
        @xHBC@     A_HBC_walk,     ;Walk
        @xHBC@     A_HBC_dBRT,     ;dBRT
        @xHBC@     A_HBC_dCOR,     ;dCOR
        @xHBC@     A_HBC_dCRT,     ;dCRT
        @xHBC@     A_HBC_dEXP,     ;dEXP
        @xHBC@     A_HBC_dLCL,     ;dLCL
        @xHBC@     A_HBC_dLRT,     ;dLRT
        @xHBC@     A_HBC_dTrn,     ;dTrn
        @xHBC@     A_HBC_tBRT,     ;tBRT
        @xHBC@     A_HBC_tCOR,     ;tCOR
        @xHBC@     A_HBC_tCRT,     ;tCRT
        @xHBC@     A_HBC_tEXP,     ;tEXP
        @xHBC@     A_HBC_tLCL,     ;tLCL
        @xHBC@     A_HBC_tLRT,     ;tLRT
        @xHBC@     A_HBC_transit,  ;tTrn
        @xHBC@     A_HBC_wBRT,     ;wBRT
        @xHBC@     A_HBC_wCOR,     ;wCOR
        @xHBC@     A_HBC_wCRT,     ;wCRT
        @xHBC@     A_HBC_wEXP,     ;wEXP
        @xHBC@     A_HBC_wLCL,     ;wLCL
        @xHBC@     A_HBC_wLRT,     ;wLRT
        @xHBC@     A_HBC_wTrn      ;wTrn

        ;Print out HBSch
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBSch',          ;Purpose
             '@out@',          ;Period
             'P',              ;PA
             i,                ;TAZID
             P_HBSch_all,      ;All
             P_HBSch_auto,     ;Auto
             P_HBSch_bike,     ;Bike
             P_HBSch_motor,    ;Moto
             P_HBSch_nonmotor, ;NonM
             P_HBSch_walk,     ;Walk
             P_HBSch_dBRT,     ;dBRT
             P_HBSch_dCOR,     ;dCOR
             P_HBSch_dCRT,     ;dCRT
             P_HBSch_dEXP,     ;dEXP
             P_HBSch_dLCL,     ;dLCL
             P_HBSch_dLRT,     ;dLRT
             P_HBSch_dTrn,     ;dTrn
             P_HBSch_tBRT,     ;tBRT
             P_HBSch_tCOR,     ;tCOR
             P_HBSch_tCRT,     ;tCRT
             P_HBSch_tEXP,     ;tEXP
             P_HBSch_tLCL,     ;tLCL
             P_HBSch_tLRT,     ;tLRT
             P_HBSch_transit,  ;tTrn
             P_HBSch_wBRT,     ;wBRT
             P_HBSch_wCOR,     ;wCOR
             P_HBSch_wCRT,     ;wCRT
             P_HBSch_wEXP,     ;wEXP
             P_HBSch_wLCL,     ;wLCL
             P_HBSch_wLRT,     ;wLRT
             P_HBSch_wTrn      ;wTrn

        ;Print out HBSch
        PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv',
        APPEND=T,
        CSV=T,
        LIST='HBSch',          ;Purpose
             '@out@',          ;Period
             'A',              ;PA
             i,                ;TAZID
             A_HBSch_all,      ;All
             A_HBSch_auto,     ;Auto
             A_HBSch_bike,     ;Bike
             A_HBSch_motor,    ;Moto
             A_HBSch_nonmotor, ;NonM
             A_HBSch_walk,     ;Walk
             A_HBSch_dBRT,     ;dBRT
             A_HBSch_dCOR,     ;dCOR
             A_HBSch_dCRT,     ;dCRT
             A_HBSch_dEXP,     ;dEXP
             A_HBSch_dLCL,     ;dLCL
             A_HBSch_dLRT,     ;dLRT
             A_HBSch_dTrn,     ;dTrn
             A_HBSch_tBRT,     ;tBRT
             A_HBSch_tCOR,     ;tCOR
             A_HBSch_tCRT,     ;tCRT
             A_HBSch_tEXP,     ;tEXP
             A_HBSch_tLCL,     ;tLCL
             A_HBSch_tLRT,     ;tLRT
             A_HBSch_transit,  ;tTrn
             A_HBSch_wBRT,     ;wBRT
             A_HBSch_wCOR,     ;wCOR
             A_HBSch_wCRT,     ;wCRT
             A_HBSch_wEXP,     ;wEXP
             A_HBSch_wLCL,     ;wLCL
             A_HBSch_wLRT,     ;wLRT
             A_HBSch_wTrn      ;wTrn

    ENDRUN
    
ENDLOOP  ;lp=1,3


if (Run_vizTool=1)

RUN PGM=MATRIX MSG='Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "zonemodetrips"',
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
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\@ScenarioGroup@_@RunYear@_ZoneSummary_TripsByMode.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json for transit node boardings/alightings
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
        LIST='\n    Calc HBSch Trips by Mode           ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
  *(DEL 13_vizTool_TripsByMode.txt)