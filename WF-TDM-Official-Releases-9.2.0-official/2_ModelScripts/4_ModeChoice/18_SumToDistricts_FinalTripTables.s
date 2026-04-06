
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 18_SumToDistricts_FinalTripTables.txt)



;get start time
ScriptStartTime = currenttime()




;verify DISTLRG & DISTMED values
RUN PGM=MATRIX  MSG='Distribution 2: District Summary - DISTLRG'
FILEI ZDATI[1] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
    Z=TAZID

FILEO RECO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf',
    FORM=10.0, 
    FIELDS=Z, 
           DISTLRG,
           DISTMED,
           DISTSML,
           CO_FIPS

    
    
    ;set MATRIX parameters
    ZONES   = @UsedZones@
    ZONEMSG = 50
    
    
    
    ;find max DISTLRG & DISTMED
    if (i=1)
        JLOOP
            max_DISTLRG = MAX(max_DISTLRG, zi.1.DISTLRG[j])
            max_DISTMED = MAX(max_DISTMED, zi.1.DISTMED[j])
            max_DISTSML = MAX(max_DISTSML, zi.1.DISTSML[j])
            max_CO_FIPS = MAX(max_CO_FIPS, zi.1.CO_FIPS[j])
        ENDJLOOP
    endif
    
    
    
    ;check DISTLRG values
    if (zi.1.DISTLRG<=0)
        out_DistLrg = INT(max_DISTLRG) + 1
    else
        out_DistLrg = INT(zi.1.DISTLRG[i])
    endif
    
    
    
    ;check DISTMED values
    if (zi.1.DISTMED<=0)
        out_DistMed = INT(max_DISTMED) + 1
    else
        out_DistMed = INT(zi.1.DISTMED[i])
    endif
    
    
    
    ;check DISTMED values
    if (zi.1.DISTSML<=0)
        out_DistSml = INT(max_DISTSML) + 1
    else
        out_DistSml = INT(zi.1.DISTSML[i])
    endif
    
    
    
    ;check COUNTY values
    if (zi.1.CO_FIPS<=0)
        out_CO_FIPS = 99
    else
        out_CO_FIPS = INT(zi.1.CO_FIPS[i])
    endif
    
    
    
    ;write output file
    RO.Z       = i
    RO.DISTLRG = out_DistLrg
    RO.DISTMED = out_DistMed
    RO.DISTSML = out_DistSml
    RO.CO_FIPS = out_CO_FIPS
    
    WRITE RECO=1
    
ENDRUN




;Cluster: distrubute MATRIX call onto processor 2
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2

    ;summarize final PURPOSE Trip Table to LARGE Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTLRG districts'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx'
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_PA_AllPurp.mtx', 
            MO=1-14, 
            NAME=HBW,
                 HBC,
                 HBSch,
                 HBO,
                 NHB,
                 IX,
                 XI,
                 XX,
                 SH_LT,
                 SH_MD,
                 SH_HV,
                 Ext_MD,
                 Ext_HV,
                 TOT
        
        
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        
        
        ;assign work matrices
        FILLMW mw[1] = mi.1.1(14)
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.DISTLRG, missingzi=m, missingzo=w
    ENDRUN
    
    
    
    ;Convert to LARGE District PURPOSE matrix to CSV format
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTLRG districts - CSV format'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_PA_AllPurp.mtx'
        
        
        ;set MATRIX parameters
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        FILLMW mw[1] = mi.1.1(14)
        
        
        ;print header to output file
        if (I=1)
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_PA_AllPurp.csv',
                CSV=T,
                LIST='I', 'J', 'HBW', 'HBC', 'HBSch', 'HBO', 'NHB', 'IX', 'XI', 'XX', 'SH_LT', 'SH_MD', 'SH_HV', 'Ext_MD', 'Ext_HV', 'TOT'
        endif
        
        JLOOP
            ;print matrix data to a linear csv file
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_PA_AllPurp.csv',
                CSV=T,
                LIST=I(5.0), J(5.0), mw[1], mw[2], mw[3], mw[4], mw[5], mw[6], mw[7], mw[8], mw[9], mw[10], mw[11], mw[12], mw[13], mw[14]
        ENDJLOOP
    ENDRUN
    
    
    
    ;summarize final PURPOSE Trip Table to MEDIUM Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTMED districts'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx'
        
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_PA_AllPurp.mtx',
            MO=1-14, 
            NAME=HBW,
                 HBC,
                 HBSch,
                 HBO,
                 NHB,
                 IX,
                 XI,
                 XX,
                 SH_LT,
                 SH_MD,
                 SH_HV,
                 Ext_MD,
                 Ext_HV,
                 TOT
        
        
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        
        
        ;assign work matrices
        FILLMW mw[1] = mi.1.1(14)
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.DISTMED, missingzi=m, missingzo=w
    ENDRUN
    
    
    
    ;Convert to MEDIUM District PURPOSE matrix to CSV format
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTMED districts - CSV format'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_PA_AllPurp.mtx'
        
        
        ;set MATRIX parameters
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        FILLMW mw[1] = mi.1.1(14)
        
        
        ;print header to output file
        if (I=1)
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_PA_AllPurp.csv',
                CSV=T,
                LIST='I', 'J', 'HBW', 'HBC', 'HBSch', 'HBO', 'NHB', 'IX', 'XI', 'XX', 'SH_LT', 'SH_MD', 'SH_HV', 'Ext_MD', 'Ext_HV', 'TOT'
        endif
        
        JLOOP
            ;print matrix data to a linear csv file
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_PA_AllPurp.csv',
                CSV=T,
                LIST=I(5.0), J(5.0), mw[1], mw[2], mw[3], mw[4], mw[5], mw[6], mw[7], mw[8], mw[9], mw[10], mw[11], mw[12], mw[13], mw[14]
        ENDJLOOP
    ENDRUN
    
    
;Cluster: end of group distributed to processor 2
EndDistributeMULTISTEP




;Cluster: distrubute MATRIX call onto processor 3
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=3

    ;summarize final MODE SHARES Trip Tables to LARGE Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize mode choice trip table to DISTLRG districts'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
              MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
              MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
              MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx'
              MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx'  ;This is a summation of the 4 purposes above.
              
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_Daily_PA_AutoTransit_HBW.mtx', 
                  MO=11-39, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_Daily_PA_AutoTransit_HBC.mtx',
                  MO=41-69, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_Daily_PA_AutoTransit_HBO.mtx',
                  MO=71-99, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_Daily_PA_AutoTransit_NHB.mtx',
                  MO=101-129, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTLRG_Daily_PA_AutoTransit_ALL.mtx',
                  MO=131-159, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN

    
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        ;HBW trips
        mw[11] = (mi.1.MOTOR + mi.1.NONMOTOR) / 100
        mw[12] =  mi.1.MOTOR / 100
        mw[13] =  mi.1.NONMOTOR / 100
        mw[14] =  mi.1.TRANSIT / 100
        mw[15] =  mi.1.AUTO / 100
        mw[16] =  mi.1.DA / 100
        mw[17] =  mi.1.SR2 / 100
        mw[18] =  mi.1.SR3p / 100
        mw[19] =  mi.1.wLCL / 100
        mw[20] =  mi.1.dLCL / 100
        mw[21] = (mi.1.wLCL + mi.1.dLCL) / 100
        mw[22] =  mi.1.wCOR / 100
        mw[23] =  mi.1.dCOR / 100
        mw[24] = (mi.1.wCOR + mi.1.dCOR) / 100
        mw[25] =  mi.1.wEXP / 100
        mw[26] =  mi.1.dEXP / 100
        mw[27] = (mi.1.wEXP + mi.1.dEXP) / 100
        mw[28] =  mi.1.wLRT / 100
        mw[29] =  mi.1.dLRT / 100
        mw[30] = (mi.1.wLRT + mi.1.dLRT) / 100
        mw[31] =  mi.1.wCRT / 100
        mw[32] =  mi.1.dCRT / 100
        mw[33] = (mi.1.wCRT + mi.1.dCRT) / 100
        mw[34] =  mi.1.wBRT / 100
        mw[35] =  mi.1.dBRT / 100
        mw[36] = (mi.1.wBRT + mi.1.dBRT) / 100
        mw[37] =  mi.1.wTRN / 100
        mw[38] =  mi.1.dTRN / 100
        mw[39] = (mi.1.wTRN + mi.1.dTRN) / 100
        
        ;HBC trips
        mw[41] = (mi.2.MOTOR + mi.2.NONMOTOR) / 100
        mw[42] =  mi.2.MOTOR / 100
        mw[43] =  mi.2.NONMOTOR / 100
        mw[44] =  mi.2.TRANSIT / 100
        mw[45] =  mi.2.AUTO / 100
        mw[46] =  mi.2.DA / 100
        mw[47] =  mi.2.SR2 / 100
        mw[48] =  mi.2.SR3p / 100
        mw[49] =  mi.2.wLCL / 100
        mw[50] =  mi.2.dLCL / 100
        mw[51] = (mi.2.wLCL + mi.2.dLCL) / 100
        mw[52] =  mi.2.wCOR / 100
        mw[53] =  mi.2.dCOR / 100
        mw[54] = (mi.2.wCOR + mi.2.dCOR) / 100
        mw[55] =  mi.2.wEXP / 100
        mw[56] =  mi.2.dEXP / 100
        mw[57] = (mi.2.wEXP + mi.2.dEXP) / 100
        mw[58] =  mi.2.wLRT / 100
        mw[59] =  mi.2.dLRT / 100
        mw[60] = (mi.2.wLRT + mi.2.dLRT) / 100
        mw[61] =  mi.2.wCRT / 100
        mw[62] =  mi.2.dCRT / 100
        mw[63] = (mi.2.wCRT + mi.2.dCRT) / 100
        mw[64] =  mi.2.wBRT / 100
        mw[65] =  mi.2.dBRT / 100
        mw[66] = (mi.2.wBRT + mi.2.dBRT) / 100
        mw[67] =  mi.2.wTRN / 100
        mw[68] =  mi.2.dTRN / 100
        mw[69] = (mi.2.wTRN + mi.2.dTRN) / 100
                
        ;HBO trips
        mw[71] = (mi.3.MOTOR + mi.3.NONMOTOR) / 100
        mw[72] =  mi.3.MOTOR / 100
        mw[73] =  mi.3.NONMOTOR / 100
        mw[74] =  mi.3.TRANSIT / 100
        mw[75] =  mi.3.AUTO / 100
        mw[76] =  mi.3.DA / 100
        mw[77] =  mi.3.SR2 / 100
        mw[78] =  mi.3.SR3p / 100
        mw[79] =  mi.3.wLCL / 100
        mw[80] =  mi.3.dLCL / 100
        mw[81] = (mi.3.wLCL + mi.3.dLCL) / 100
        mw[82] =  mi.3.wCOR / 100
        mw[83] =  mi.3.dCOR / 100
        mw[84] = (mi.3.wCOR + mi.3.dCOR) / 100
        mw[85] =  mi.3.wEXP / 100
        mw[86] =  mi.3.dEXP / 100
        mw[87] = (mi.3.wEXP + mi.3.dEXP) / 100
        mw[88] =  mi.3.wLRT / 100
        mw[89] =  mi.3.dLRT / 100
        mw[90] = (mi.3.wLRT + mi.3.dLRT) / 100
        mw[91] =  mi.3.wCRT / 100
        mw[92] =  mi.3.dCRT / 100
        mw[93] = (mi.3.wCRT + mi.3.dCRT) / 100
        mw[94] =  mi.3.wBRT / 100
        mw[95] =  mi.3.dBRT / 100
        mw[96] = (mi.3.wBRT + mi.3.dBRT) / 100
        mw[97] =  mi.3.wTRN / 100
        mw[98] =  mi.3.dTRN / 100
        mw[99] = (mi.3.wTRN + mi.3.dTRN) / 100
        
        ;NHB trips
        mw[101] = (mi.4.MOTOR + mi.4.NONMOTOR) / 100
        mw[102] =  mi.4.MOTOR / 100
        mw[103] =  mi.4.NONMOTOR / 100
        mw[104] =  mi.4.TRANSIT / 100
        mw[105] =  mi.4.AUTO / 100
        mw[106] =  mi.4.DA / 100
        mw[107] =  mi.4.SR2 / 100
        mw[108] =  mi.4.SR3p / 100
        mw[109] =  mi.4.wLCL / 100
        mw[110] =  mi.4.dLCL / 100
        mw[111] = (mi.4.wLCL + mi.4.dLCL) / 100
        mw[112] =  mi.4.wCOR / 100
        mw[113] =  mi.4.dCOR / 100
        mw[114] = (mi.4.wCOR + mi.4.dCOR) / 100
        mw[115] =  mi.4.wEXP / 100
        mw[116] =  mi.4.dEXP / 100
        mw[117] = (mi.4.wEXP + mi.4.dEXP) / 100
        mw[118] =  mi.4.wLRT / 100
        mw[119] =  mi.4.dLRT / 100
        mw[120] = (mi.4.wLRT + mi.4.dLRT) / 100
        mw[121] =  mi.4.wCRT / 100
        mw[122] =  mi.4.dCRT / 100
        mw[123] = (mi.4.wCRT + mi.4.dCRT) / 100
        mw[124] =  mi.4.wBRT / 100
        mw[125] =  mi.4.dBRT / 100
        mw[126] = (mi.4.wBRT + mi.4.dBRT) / 100
        mw[127] =  mi.4.wTRN / 100
        mw[128] =  mi.4.dTRN / 100
        mw[129] = (mi.4.wTRN + mi.4.dTRN) / 100
        
        ;ALL trips
        mw[131] = (mi.5.MOTOR + mi.5.NONMOTOR) / 100
        mw[132] =  mi.5.MOTOR / 100
        mw[133] =  mi.5.NONMOTOR / 100
        mw[134] =  mi.5.TRANSIT / 100
        mw[135] =  mi.5.AUTO / 100
        mw[136] =  mi.5.DA / 100
        mw[137] =  mi.5.SR2 / 100
        mw[138] =  mi.5.SR3p / 100
        mw[139] =  mi.5.wLCL / 100
        mw[140] =  mi.5.dLCL / 100
        mw[141] = (mi.5.wLCL + mi.5.dLCL) / 100
        mw[142] =  mi.5.wCOR / 100
        mw[143] =  mi.5.dCOR / 100
        mw[144] = (mi.5.wCOR + mi.5.dCOR) / 100
        mw[145] =  mi.5.wEXP / 100
        mw[146] =  mi.5.dEXP / 100
        mw[147] = (mi.5.wEXP + mi.5.dEXP) / 100
        mw[148] =  mi.5.wLRT / 100
        mw[149] =  mi.5.dLRT / 100
        mw[150] = (mi.5.wLRT + mi.5.dLRT) / 100
        mw[151] =  mi.5.wCRT / 100
        mw[152] =  mi.5.dCRT / 100
        mw[153] = (mi.5.wCRT + mi.5.dCRT) / 100
        mw[154] =  mi.5.wBRT / 100
        mw[155] =  mi.5.dBRT / 100
        mw[156] = (mi.5.wBRT + mi.5.dBRT) / 100
        mw[157] =  mi.5.wTRN / 100
        mw[158] =  mi.5.dTRN / 100
        mw[159] = (mi.5.wTRN + mi.5.dTRN) / 100
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.DISTLRG, missingzi=m, missingzo=w
    ENDRUN
    
;Cluster: end of group distributed to processor 3
EndDistributeMULTISTEP




;Cluster: distrubute MATRIX call onto processor 4
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=4

    ;summarize final MODE SHARES Trip Tables to MEDIUM Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize mode choice trip table to DISTMED districts'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
              MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
              MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
              MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx'
              MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx'  ;This is a summation of the 4 purposes above.
              
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_Daily_PA_AutoTransit_HBW.mtx', 
                  MO=11-39, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_Daily_PA_AutoTransit_HBC.mtx',
                  MO=41-69, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_Daily_PA_AutoTransit_HBO.mtx',
                  MO=71-99, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_Daily_PA_AutoTransit_NHB.mtx',
                  MO=101-129, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTMED_Daily_PA_AutoTransit_ALL.mtx',
                  MO=131-159, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
    
    
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        ;HBW trips
        mw[11] = (mi.1.MOTOR + mi.1.NONMOTOR) / 100
        mw[12] =  mi.1.MOTOR / 100
        mw[13] =  mi.1.NONMOTOR / 100
        mw[14] =  mi.1.TRANSIT / 100
        mw[15] =  mi.1.AUTO / 100
        mw[16] =  mi.1.DA / 100
        mw[17] =  mi.1.SR2 / 100
        mw[18] =  mi.1.SR3p / 100
        mw[19] =  mi.1.wLCL / 100
        mw[20] =  mi.1.dLCL / 100
        mw[21] = (mi.1.wLCL + mi.1.dLCL) / 100
        mw[22] =  mi.1.wCOR / 100
        mw[23] =  mi.1.dCOR / 100
        mw[24] = (mi.1.wCOR + mi.1.dCOR) / 100
        mw[25] =  mi.1.wEXP / 100
        mw[26] =  mi.1.dEXP / 100
        mw[27] = (mi.1.wEXP + mi.1.dEXP) / 100
        mw[28] =  mi.1.wLRT / 100
        mw[29] =  mi.1.dLRT / 100
        mw[30] = (mi.1.wLRT + mi.1.dLRT) / 100
        mw[31] =  mi.1.wCRT / 100
        mw[32] =  mi.1.dCRT / 100
        mw[33] = (mi.1.wCRT + mi.1.dCRT) / 100
        mw[34] =  mi.1.wBRT / 100
        mw[35] =  mi.1.dBRT / 100
        mw[36] = (mi.1.wBRT + mi.1.dBRT) / 100
        mw[37] =  mi.1.wTRN / 100
        mw[38] =  mi.1.dTRN / 100
        mw[39] = (mi.1.wTRN + mi.1.dTRN) / 100
        
        ;HBC trips
        mw[41] = (mi.2.MOTOR + mi.2.NONMOTOR) / 100
        mw[42] =  mi.2.MOTOR / 100
        mw[43] =  mi.2.NONMOTOR / 100
        mw[44] =  mi.2.TRANSIT / 100
        mw[45] =  mi.2.AUTO / 100
        mw[46] =  mi.2.DA / 100
        mw[47] =  mi.2.SR2 / 100
        mw[48] =  mi.2.SR3p / 100
        mw[49] =  mi.2.wLCL / 100
        mw[50] =  mi.2.dLCL / 100
        mw[51] = (mi.2.wLCL + mi.2.dLCL) / 100
        mw[52] =  mi.2.wCOR / 100
        mw[53] =  mi.2.dCOR / 100
        mw[54] = (mi.2.wCOR + mi.2.dCOR) / 100
        mw[55] =  mi.2.wEXP / 100
        mw[56] =  mi.2.dEXP / 100
        mw[57] = (mi.2.wEXP + mi.2.dEXP) / 100
        mw[58] =  mi.2.wLRT / 100
        mw[59] =  mi.2.dLRT / 100
        mw[60] = (mi.2.wLRT + mi.2.dLRT) / 100
        mw[61] =  mi.2.wCRT / 100
        mw[62] =  mi.2.dCRT / 100
        mw[63] = (mi.2.wCRT + mi.2.dCRT) / 100
        mw[64] =  mi.2.wBRT / 100
        mw[65] =  mi.2.dBRT / 100
        mw[66] = (mi.2.wBRT + mi.2.dBRT) / 100
        mw[67] =  mi.2.wTRN / 100
        mw[68] =  mi.2.dTRN / 100
        mw[69] = (mi.2.wTRN + mi.2.dTRN) / 100
                
        ;HBO trips
        mw[71] = (mi.3.MOTOR + mi.3.NONMOTOR) / 100
        mw[72] =  mi.3.MOTOR / 100
        mw[73] =  mi.3.NONMOTOR / 100
        mw[74] =  mi.3.TRANSIT / 100
        mw[75] =  mi.3.AUTO / 100
        mw[76] =  mi.3.DA / 100
        mw[77] =  mi.3.SR2 / 100
        mw[78] =  mi.3.SR3p / 100
        mw[79] =  mi.3.wLCL / 100
        mw[80] =  mi.3.dLCL / 100
        mw[81] = (mi.3.wLCL + mi.3.dLCL) / 100
        mw[82] =  mi.3.wCOR / 100
        mw[83] =  mi.3.dCOR / 100
        mw[84] = (mi.3.wCOR + mi.3.dCOR) / 100
        mw[85] =  mi.3.wEXP / 100
        mw[86] =  mi.3.dEXP / 100
        mw[87] = (mi.3.wEXP + mi.3.dEXP) / 100
        mw[88] =  mi.3.wLRT / 100
        mw[89] =  mi.3.dLRT / 100
        mw[90] = (mi.3.wLRT + mi.3.dLRT) / 100
        mw[91] =  mi.3.wCRT / 100
        mw[92] =  mi.3.dCRT / 100
        mw[93] = (mi.3.wCRT + mi.3.dCRT) / 100
        mw[94] =  mi.3.wBRT / 100
        mw[95] =  mi.3.dBRT / 100
        mw[96] = (mi.3.wBRT + mi.3.dBRT) / 100
        mw[97] =  mi.3.wTRN / 100
        mw[98] =  mi.3.dTRN / 100
        mw[99] = (mi.3.wTRN + mi.3.dTRN) / 100
        
        ;NHB trips
        mw[101] = (mi.4.MOTOR + mi.4.NONMOTOR) / 100
        mw[102] =  mi.4.MOTOR / 100
        mw[103] =  mi.4.NONMOTOR / 100
        mw[104] =  mi.4.TRANSIT / 100
        mw[105] =  mi.4.AUTO / 100
        mw[106] =  mi.4.DA / 100
        mw[107] =  mi.4.SR2 / 100
        mw[108] =  mi.4.SR3p / 100
        mw[109] =  mi.4.wLCL / 100
        mw[110] =  mi.4.dLCL / 100
        mw[111] = (mi.4.wLCL + mi.4.dLCL) / 100
        mw[112] =  mi.4.wCOR / 100
        mw[113] =  mi.4.dCOR / 100
        mw[114] = (mi.4.wCOR + mi.4.dCOR) / 100
        mw[115] =  mi.4.wEXP / 100
        mw[116] =  mi.4.dEXP / 100
        mw[117] = (mi.4.wEXP + mi.4.dEXP) / 100
        mw[118] =  mi.4.wLRT / 100
        mw[119] =  mi.4.dLRT / 100
        mw[120] = (mi.4.wLRT + mi.4.dLRT) / 100
        mw[121] =  mi.4.wCRT / 100
        mw[122] =  mi.4.dCRT / 100
        mw[123] = (mi.4.wCRT + mi.4.dCRT) / 100
        mw[124] =  mi.4.wBRT / 100
        mw[125] =  mi.4.dBRT / 100
        mw[126] = (mi.4.wBRT + mi.4.dBRT) / 100
        mw[127] =  mi.4.wTRN / 100
        mw[128] =  mi.4.dTRN / 100
        mw[129] = (mi.4.wTRN + mi.4.dTRN) / 100
        
        ;ALL trips
        mw[131] = (mi.5.MOTOR + mi.5.NONMOTOR) / 100
        mw[132] =  mi.5.MOTOR / 100
        mw[133] =  mi.5.NONMOTOR / 100
        mw[134] =  mi.5.TRANSIT / 100
        mw[135] =  mi.5.AUTO / 100
        mw[136] =  mi.5.DA / 100
        mw[137] =  mi.5.SR2 / 100
        mw[138] =  mi.5.SR3p / 100
        mw[139] =  mi.5.wLCL / 100
        mw[140] =  mi.5.dLCL / 100
        mw[141] = (mi.5.wLCL + mi.5.dLCL) / 100
        mw[142] =  mi.5.wCOR / 100
        mw[143] =  mi.5.dCOR / 100
        mw[144] = (mi.5.wCOR + mi.5.dCOR) / 100
        mw[145] =  mi.5.wEXP / 100
        mw[146] =  mi.5.dEXP / 100
        mw[147] = (mi.5.wEXP + mi.5.dEXP) / 100
        mw[148] =  mi.5.wLRT / 100
        mw[149] =  mi.5.dLRT / 100
        mw[150] = (mi.5.wLRT + mi.5.dLRT) / 100
        mw[151] =  mi.5.wCRT / 100
        mw[152] =  mi.5.dCRT / 100
        mw[153] = (mi.5.wCRT + mi.5.dCRT) / 100
        mw[154] =  mi.5.wBRT / 100
        mw[155] =  mi.5.dBRT / 100
        mw[156] = (mi.5.wBRT + mi.5.dBRT) / 100
        mw[157] =  mi.5.wTRN / 100
        mw[158] =  mi.5.dTRN / 100
        mw[159] = (mi.5.wTRN + mi.5.dTRN) / 100
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.DISTMED, missingzi=m, missingzo=w
    ENDRUN
    
;Cluster: end of group distributed to processor 4
EndDistributeMULTISTEP




;Cluster: distrubute MATRIX call onto processor 5
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=5

    ;summarize final MODE SHARES Trip Tables to SMALL Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize mode choice trip table to DISTSML districts'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
              MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
              MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
              MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx'
              MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx'  ;This is a summation of the 4 purposes above.
              
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_PA_AutoTransit.mtx', 
                  MO=11-39,41-69,71-99,101-129,131-159,
                  NAME=HBW_MNM, HBW_M, HBW_NM, HBW_T, HBW_A, 
                       HBW_DA, HBW_SR2, HBW_SR3p, 
                       HBW_wLCL, HBW_dLCL, HBW_wdLCL, 
                       HBW_wCOR, HBW_dCOR, HBW_wdCOR, 
                       HBW_wEXP, HBW_dEXP, HBW_wdEXP, 
                       HBW_wLRT, HBW_dLRT, HBW_wdLRT, 
                       HBW_wCRT, HBW_dCRT, HBW_wdCRT, 
                       HBW_wBRT, HBW_dBRT, HBW_wdBRT, 
                       HBW_wTRN, HBW_dTRN, HBW_wdTRN,
                       HBC_MNM, HBC_M, HBC_NM, HBC_T, HBC_A, 
                       HBC_DA, HBC_SR2, HBC_SR3p, 
                       HBC_wLCL, HBC_dLCL, HBC_wdLCL, 
                       HBC_wCOR, HBC_dCOR, HBC_wdCOR, 
                       HBC_wEXP, HBC_dEXP, HBC_wdEXP, 
                       HBC_wLRT, HBC_dLRT, HBC_wdLRT, 
                       HBC_wCRT, HBC_dCRT, HBC_wdCRT, 
                       HBC_wBRT, HBC_dBRT, HBC_wdBRT, 
                       HBC_wTRN, HBC_dTRN, HBC_wdTRN,
                       HBO_MNM, HBO_M, HBO_NM, HBO_T, HBO_A, 
                       HBO_DA, HBO_SR2, HBO_SR3p, 
                       HBO_wLCL, HBO_dLCL, HBO_wdLCL, 
                       HBO_wCOR, HBO_dCOR, HBO_wdCOR, 
                       HBO_wEXP, HBO_dEXP, HBO_wdEXP, 
                       HBO_wLRT, HBO_dLRT, HBO_wdLRT, 
                       HBO_wCRT, HBO_dCRT, HBO_wdCRT, 
                       HBO_wBRT, HBO_dBRT, HBO_wdBRT, 
                       HBO_wTRN, HBO_dTRN, HBO_wdTRN,
                       NHB_MNM, NHB_M, NHB_NM, NHB_T, NHB_A, 
                       NHB_DA, NHB_SR2, NHB_SR3p, 
                       NHB_wLCL, NHB_dLCL, NHB_wdLCL, 
                       NHB_wCOR, NHB_dCOR, NHB_wdCOR, 
                       NHB_wEXP, NHB_dEXP, NHB_wdEXP, 
                       NHB_wLRT, NHB_dLRT, NHB_wdLRT, 
                       NHB_wCRT, NHB_dCRT, NHB_wdCRT, 
                       NHB_wBRT, NHB_dBRT, NHB_wdBRT, 
                       NHB_wTRN, NHB_dTRN, NHB_wdTRN,
                       ALL_MNM, ALL_M, ALL_NM, ALL_T, ALL_A, 
                       ALL_DA, ALL_SR2, ALL_SR3p, 
                       ALL_wLCL, ALL_dLCL, ALL_wdLCL, 
                       ALL_wCOR, ALL_dCOR, ALL_wdCOR, 
                       ALL_wEXP, ALL_dEXP, ALL_wdEXP, 
                       ALL_wLRT, ALL_dLRT, ALL_wdLRT, 
                       ALL_wCRT, ALL_dCRT, ALL_wdCRT, 
                       ALL_wBRT, ALL_dBRT, ALL_wdBRT, 
                       ALL_wTRN, ALL_dTRN, ALL_wdTRN
    
    
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        ;HBW trips
        mw[11] = (mi.1.MOTOR + mi.1.NONMOTOR) / 100
        mw[12] =  mi.1.MOTOR / 100
        mw[13] =  mi.1.NONMOTOR / 100
        mw[14] =  mi.1.TRANSIT / 100
        mw[15] =  mi.1.AUTO / 100
        mw[16] =  mi.1.DA / 100
        mw[17] =  mi.1.SR2 / 100
        mw[18] =  mi.1.SR3p / 100
        mw[19] =  mi.1.wLCL / 100
        mw[20] =  mi.1.dLCL / 100
        mw[21] = (mi.1.wLCL + mi.1.dLCL) / 100
        mw[22] =  mi.1.wCOR / 100
        mw[23] =  mi.1.dCOR / 100
        mw[24] = (mi.1.wCOR + mi.1.dCOR) / 100
        mw[25] =  mi.1.wEXP / 100
        mw[26] =  mi.1.dEXP / 100
        mw[27] = (mi.1.wEXP + mi.1.dEXP) / 100
        mw[28] =  mi.1.wLRT / 100
        mw[29] =  mi.1.dLRT / 100
        mw[30] = (mi.1.wLRT + mi.1.dLRT) / 100
        mw[31] =  mi.1.wCRT / 100
        mw[32] =  mi.1.dCRT / 100
        mw[33] = (mi.1.wCRT + mi.1.dCRT) / 100
        mw[34] =  mi.1.wBRT / 100
        mw[35] =  mi.1.dBRT / 100
        mw[36] = (mi.1.wBRT + mi.1.dBRT) / 100
        mw[37] =  mi.1.wTRN / 100
        mw[38] =  mi.1.dTRN / 100
        mw[39] = (mi.1.wTRN + mi.1.dTRN) / 100
        
        ;HBC trips
        mw[41] = (mi.2.MOTOR + mi.2.NONMOTOR) / 100
        mw[42] =  mi.2.MOTOR / 100
        mw[43] =  mi.2.NONMOTOR / 100
        mw[44] =  mi.2.TRANSIT / 100
        mw[45] =  mi.2.AUTO / 100
        mw[46] =  mi.2.DA / 100
        mw[47] =  mi.2.SR2 / 100
        mw[48] =  mi.2.SR3p / 100
        mw[49] =  mi.2.wLCL / 100
        mw[50] =  mi.2.dLCL / 100
        mw[51] = (mi.2.wLCL + mi.2.dLCL) / 100
        mw[52] =  mi.2.wCOR / 100
        mw[53] =  mi.2.dCOR / 100
        mw[54] = (mi.2.wCOR + mi.2.dCOR) / 100
        mw[55] =  mi.2.wEXP / 100
        mw[56] =  mi.2.dEXP / 100
        mw[57] = (mi.2.wEXP + mi.2.dEXP) / 100
        mw[58] =  mi.2.wLRT / 100
        mw[59] =  mi.2.dLRT / 100
        mw[60] = (mi.2.wLRT + mi.2.dLRT) / 100
        mw[61] =  mi.2.wCRT / 100
        mw[62] =  mi.2.dCRT / 100
        mw[63] = (mi.2.wCRT + mi.2.dCRT) / 100
        mw[64] =  mi.2.wBRT / 100
        mw[65] =  mi.2.dBRT / 100
        mw[66] = (mi.2.wBRT + mi.2.dBRT) / 100
        mw[67] =  mi.2.wTRN / 100
        mw[68] =  mi.2.dTRN / 100
        mw[69] = (mi.2.wTRN + mi.2.dTRN) / 100
                
        ;HBO trips
        mw[71] = (mi.3.MOTOR + mi.3.NONMOTOR) / 100
        mw[72] =  mi.3.MOTOR / 100
        mw[73] =  mi.3.NONMOTOR / 100
        mw[74] =  mi.3.TRANSIT / 100
        mw[75] =  mi.3.AUTO / 100
        mw[76] =  mi.3.DA / 100
        mw[77] =  mi.3.SR2 / 100
        mw[78] =  mi.3.SR3p / 100
        mw[79] =  mi.3.wLCL / 100
        mw[80] =  mi.3.dLCL / 100
        mw[81] = (mi.3.wLCL + mi.3.dLCL) / 100
        mw[82] =  mi.3.wCOR / 100
        mw[83] =  mi.3.dCOR / 100
        mw[84] = (mi.3.wCOR + mi.3.dCOR) / 100
        mw[85] =  mi.3.wEXP / 100
        mw[86] =  mi.3.dEXP / 100
        mw[87] = (mi.3.wEXP + mi.3.dEXP) / 100
        mw[88] =  mi.3.wLRT / 100
        mw[89] =  mi.3.dLRT / 100
        mw[90] = (mi.3.wLRT + mi.3.dLRT) / 100
        mw[91] =  mi.3.wCRT / 100
        mw[92] =  mi.3.dCRT / 100
        mw[93] = (mi.3.wCRT + mi.3.dCRT) / 100
        mw[94] =  mi.3.wBRT / 100
        mw[95] =  mi.3.dBRT / 100
        mw[96] = (mi.3.wBRT + mi.3.dBRT) / 100
        mw[97] =  mi.3.wTRN / 100
        mw[98] =  mi.3.dTRN / 100
        mw[99] = (mi.3.wTRN + mi.3.dTRN) / 100
        
        ;NHB trips
        mw[101] = (mi.4.MOTOR + mi.4.NONMOTOR) / 100
        mw[102] =  mi.4.MOTOR / 100
        mw[103] =  mi.4.NONMOTOR / 100
        mw[104] =  mi.4.TRANSIT / 100
        mw[105] =  mi.4.AUTO / 100
        mw[106] =  mi.4.DA / 100
        mw[107] =  mi.4.SR2 / 100
        mw[108] =  mi.4.SR3p / 100
        mw[109] =  mi.4.wLCL / 100
        mw[110] =  mi.4.dLCL / 100
        mw[111] = (mi.4.wLCL + mi.4.dLCL) / 100
        mw[112] =  mi.4.wCOR / 100
        mw[113] =  mi.4.dCOR / 100
        mw[114] = (mi.4.wCOR + mi.4.dCOR) / 100
        mw[115] =  mi.4.wEXP / 100
        mw[116] =  mi.4.dEXP / 100
        mw[117] = (mi.4.wEXP + mi.4.dEXP) / 100
        mw[118] =  mi.4.wLRT / 100
        mw[119] =  mi.4.dLRT / 100
        mw[120] = (mi.4.wLRT + mi.4.dLRT) / 100
        mw[121] =  mi.4.wCRT / 100
        mw[122] =  mi.4.dCRT / 100
        mw[123] = (mi.4.wCRT + mi.4.dCRT) / 100
        mw[124] =  mi.4.wBRT / 100
        mw[125] =  mi.4.dBRT / 100
        mw[126] = (mi.4.wBRT + mi.4.dBRT) / 100
        mw[127] =  mi.4.wTRN / 100
        mw[128] =  mi.4.dTRN / 100
        mw[129] = (mi.4.wTRN + mi.4.dTRN) / 100
        
        ;ALL trips
        mw[131] = (mi.5.MOTOR + mi.5.NONMOTOR) / 100
        mw[132] =  mi.5.MOTOR / 100
        mw[133] =  mi.5.NONMOTOR / 100
        mw[134] =  mi.5.TRANSIT / 100
        mw[135] =  mi.5.AUTO / 100
        mw[136] =  mi.5.DA / 100
        mw[137] =  mi.5.SR2 / 100
        mw[138] =  mi.5.SR3p / 100
        mw[139] =  mi.5.wLCL / 100
        mw[140] =  mi.5.dLCL / 100
        mw[141] = (mi.5.wLCL + mi.5.dLCL) / 100
        mw[142] =  mi.5.wCOR / 100
        mw[143] =  mi.5.dCOR / 100
        mw[144] = (mi.5.wCOR + mi.5.dCOR) / 100
        mw[145] =  mi.5.wEXP / 100
        mw[146] =  mi.5.dEXP / 100
        mw[147] = (mi.5.wEXP + mi.5.dEXP) / 100
        mw[148] =  mi.5.wLRT / 100
        mw[149] =  mi.5.dLRT / 100
        mw[150] = (mi.5.wLRT + mi.5.dLRT) / 100
        mw[151] =  mi.5.wCRT / 100
        mw[152] =  mi.5.dCRT / 100
        mw[153] = (mi.5.wCRT + mi.5.dCRT) / 100
        mw[154] =  mi.5.wBRT / 100
        mw[155] =  mi.5.dBRT / 100
        mw[156] = (mi.5.wBRT + mi.5.dBRT) / 100
        mw[157] =  mi.5.wTRN / 100
        mw[158] =  mi.5.dTRN / 100
        mw[159] = (mi.5.wTRN + mi.5.dTRN) / 100
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.DISTSML, missingzi=m, missingzo=w
    ENDRUN
    
    
    
    ;Convert to SMALL District PURPOSE matrix to CSV format
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTSML districts - CSV format'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_PA_AutoTransit.mtx'
        
        
        ;set MATRIX parameters
        ZONEMSG = @ZoneMsgRate@
        
        
        ;print header to output file
        if (I=1)
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_AutoTransit.csv',
                CSV=T,
                LIST=   'DISTSML'     ,
                        'DISTSML2'    ,
                        'PA'          ,
                        'HBW_MNM'     ,
                        'HBW_M'       ,
                        'HBW_NM'      ,
                        'HBW_T'       ,
                        'HBW_A'       ,
                        'HBW_DA'      ,
                        'HBW_SR2'     ,
                        'HBW_SR3p'    ,
                        'HBW_wLCL'    ,
                        'HBW_dLCL'    ,
                        'HBW_wdLCL'   ,
                        'HBW_wCOR'    ,
                        'HBW_dCOR'    ,
                        'HBW_wdCOR'   ,
                        'HBW_wEXP'    ,
                        'HBW_dEXP'    ,
                        'HBW_wdEXP'   ,
                        'HBW_wLRT'    ,
                        'HBW_dLRT'    ,
                        'HBW_wdLRT'   ,
                        'HBW_wCRT'    ,
                        'HBW_dCRT'    ,
                        'HBW_wdCRT'   ,
                        'HBW_wBRT'    ,
                        'HBW_dBRT'    ,
                        'HBW_wdBRT'   ,
                        'HBW_wTRN'    ,
                        'HBW_dTRN'    ,
                        'HBW_wdTRN'   ,
                        'HBC_MNM'     ,
                        'HBC_M'       ,
                        'HBC_NM'      ,
                        'HBC_T'       ,
                        'HBC_A'       ,
                        'HBC_DA'      ,
                        'HBC_SR2'     ,
                        'HBC_SR3p'    ,
                        'HBC_wLCL'    ,
                        'HBC_dLCL'    ,
                        'HBC_wdLCL'   ,
                        'HBC_wCOR'    ,
                        'HBC_dCOR'    ,
                        'HBC_wdCOR'   ,
                        'HBC_wEXP'    ,
                        'HBC_dEXP'    ,
                        'HBC_wdEXP'   ,
                        'HBC_wLRT'    ,
                        'HBC_dLRT'    ,
                        'HBC_wdLRT'   ,
                        'HBC_wBRT'    ,
                        'HBC_dBRT'    ,
                        'HBC_wdBRT'   ,
                        'HBC_wCRT'    ,
                        'HBC_dCRT'    ,
                        'HBC_wdCRT'   ,
                        'HBC_wTRN'    ,
                        'HBC_dTRN'    ,
                        'HBC_wdTRN'   ,
                        'HBO_MNM'     ,
                        'HBO_M'       ,
                        'HBO_NM'      ,
                        'HBO_T'       ,
                        'HBO_A'       ,
                        'HBO_DA'      ,
                        'HBO_SR2'     ,
                        'HBO_SR3p'    ,
                        'HBO_wLCL'    ,
                        'HBO_dLCL'    ,
                        'HBO_wdLCL'   ,
                        'HBO_wCOR'    ,
                        'HBO_dCOR'    ,
                        'HBO_wdCOR'   ,
                        'HBO_wEXP'    ,
                        'HBO_dEXP'    ,
                        'HBO_wdEXP'   ,
                        'HBO_wLRT'    ,
                        'HBO_dLRT'    ,
                        'HBO_wdLRT'   ,
                        'HBO_wCRT'    ,
                        'HBO_dCRT'    ,
                        'HBO_wdCRT'   ,
                        'HBO_wBRT'    ,
                        'HBO_dBRT'    ,
                        'HBO_wdBRT'   ,
                        'HBO_wTRN'    ,
                        'HBO_dTRN'    ,
                        'HBO_wdTRN'   ,
                        'NHB_MNM'     ,
                        'NHB_M'       ,
                        'NHB_NM'      ,
                        'NHB_T'       ,
                        'NHB_A'       ,
                        'NHB_DA'      ,
                        'NHB_SR2'     ,
                        'NHB_SR3p'    ,
                        'NHB_wLCL'    ,
                        'NHB_dLCL'    ,
                        'NHB_wdLCL'   ,
                        'NHB_wCOR'    ,
                        'NHB_dCOR'    ,
                        'NHB_wdCOR'   ,
                        'NHB_wEXP'    ,
                        'NHB_dEXP'    ,
                        'NHB_wdEXP'   ,
                        'NHB_wLRT'    ,
                        'NHB_dLRT'    ,
                        'NHB_wdLRT'   ,
                        'NHB_wCRT'    ,
                        'NHB_dCRT'    ,
                        'NHB_wdCRT'   ,
                        'NHB_wBRT'    ,
                        'NHB_dBRT'    ,
                        'NHB_wdBRT'   ,
                        'NHB_wTRN'    ,
                        'NHB_dTRN'    ,
                        'NHB_wdTRN'   ,
                        'ALL_MNM'     ,
                        'ALL_M'       ,
                        'ALL_NM'      ,
                        'ALL_T'       ,
                        'ALL_A'       ,
                        'ALL_DA'      ,
                        'ALL_SR2'     ,
                        'ALL_SR3p'    ,
                        'ALL_wLCL'    ,
                        'ALL_dLCL'    ,
                        'ALL_wdLCL'   ,
                        'ALL_wCOR'    ,
                        'ALL_dCOR'    ,
                        'ALL_wdCOR'   ,
                        'ALL_wEXP'    ,
                        'ALL_dEXP'    ,
                        'ALL_wdEXP'   ,
                        'ALL_wLRT'    ,
                        'ALL_dLRT'    ,
                        'ALL_wdLRT'   ,
                        'ALL_wCRT'    ,
                        'ALL_dCRT'    ,
                        'ALL_wdCRT'   ,
                        'ALL_wBRT'    ,
                        'ALL_dBRT'    ,
                        'ALL_wdBRT'   ,
                        'ALL_wTRN'    ,
                        'ALL_dTRN'    ,
                        'ALL_wdTRN'

        endif
        
        JLOOP
            ;print matrix data to a linear csv file
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_AutoTransit.csv',
                CSV=T, 
                LIST=   I(5.0)        ,
                        J(5.0)        ,
                        'P'           ,
                        mi.1.HBW_MNM  ,
                        mi.1.HBW_M    ,
                        mi.1.HBW_NM   ,
                        mi.1.HBW_T    ,
                        mi.1.HBW_A    ,
                        mi.1.HBW_DA   ,
                        mi.1.HBW_SR2  ,
                        mi.1.HBW_SR3p ,
                        mi.1.HBW_wLCL ,
                        mi.1.HBW_dLCL ,
                        mi.1.HBW_wdLCL,
                        mi.1.HBW_wCOR ,
                        mi.1.HBW_dCOR ,
                        mi.1.HBW_wdCOR,
                        mi.1.HBW_wEXP ,
                        mi.1.HBW_dEXP ,
                        mi.1.HBW_wdEXP,
                        mi.1.HBW_wLRT ,
                        mi.1.HBW_dLRT ,
                        mi.1.HBW_wdLRT,
                        mi.1.HBW_wCRT ,
                        mi.1.HBW_dCRT ,
                        mi.1.HBW_wdCRT,
                        mi.1.HBW_wBRT ,
                        mi.1.HBW_dBRT ,
                        mi.1.HBW_wdBRT,
                        mi.1.HBW_wTRN ,
                        mi.1.HBW_dTRN ,
                        mi.1.HBW_wdTRN,
                        mi.1.HBC_MNM  ,
                        mi.1.HBC_M    ,
                        mi.1.HBC_NM   ,
                        mi.1.HBC_T    ,
                        mi.1.HBC_A    ,
                        mi.1.HBC_DA   ,
                        mi.1.HBC_SR2  ,
                        mi.1.HBC_SR3p ,
                        mi.1.HBC_wLCL ,
                        mi.1.HBC_dLCL ,
                        mi.1.HBC_wdLCL,
                        mi.1.HBC_wCOR ,
                        mi.1.HBC_dCOR ,
                        mi.1.HBC_wdCOR,
                        mi.1.HBC_wEXP ,
                        mi.1.HBC_dEXP ,
                        mi.1.HBC_wdEXP,
                        mi.1.HBC_wLRT ,
                        mi.1.HBC_dLRT ,
                        mi.1.HBC_wdLRT,
                        mi.1.HBC_wCRT ,
                        mi.1.HBC_dCRT ,
                        mi.1.HBC_wdCRT,
                        mi.1.HBC_wBRT ,
                        mi.1.HBC_dBRT ,
                        mi.1.HBC_wdBRT,
                        mi.1.HBC_wTRN ,
                        mi.1.HBC_dTRN ,
                        mi.1.HBC_wdTRN,
                        mi.1.HBO_MNM  ,
                        mi.1.HBO_M    ,
                        mi.1.HBO_NM   ,
                        mi.1.HBO_T    ,
                        mi.1.HBO_A    ,
                        mi.1.HBO_DA   ,
                        mi.1.HBO_SR2  ,
                        mi.1.HBO_SR3p ,
                        mi.1.HBO_wLCL ,
                        mi.1.HBO_dLCL ,
                        mi.1.HBO_wdLCL,
                        mi.1.HBO_wCOR ,
                        mi.1.HBO_dCOR ,
                        mi.1.HBO_wdCOR,
                        mi.1.HBO_wEXP ,
                        mi.1.HBO_dEXP ,
                        mi.1.HBO_wdEXP,
                        mi.1.HBO_wLRT ,
                        mi.1.HBO_dLRT ,
                        mi.1.HBO_wdLRT,
                        mi.1.HBO_wCRT ,
                        mi.1.HBO_dCRT ,
                        mi.1.HBO_wdCRT,
                        mi.1.HBO_wBRT ,
                        mi.1.HBO_dBRT ,
                        mi.1.HBO_wdBRT,
                        mi.1.HBO_wTRN ,
                        mi.1.HBO_dTRN ,
                        mi.1.HBO_wdTRN,
                        mi.1.NHB_MNM  ,
                        mi.1.NHB_M    ,
                        mi.1.NHB_NM   ,
                        mi.1.NHB_T    ,
                        mi.1.NHB_A    ,
                        mi.1.NHB_DA   ,
                        mi.1.NHB_SR2  ,
                        mi.1.NHB_SR3p ,
                        mi.1.NHB_wLCL ,
                        mi.1.NHB_dLCL ,
                        mi.1.NHB_wdLCL,
                        mi.1.NHB_wCOR ,
                        mi.1.NHB_dCOR ,
                        mi.1.NHB_wdCOR,
                        mi.1.NHB_wEXP ,
                        mi.1.NHB_dEXP ,
                        mi.1.NHB_wdEXP,
                        mi.1.NHB_wLRT ,
                        mi.1.NHB_dLRT ,
                        mi.1.NHB_wdLRT,
                        mi.1.NHB_wCRT ,
                        mi.1.NHB_dCRT ,
                        mi.1.NHB_wdCRT,
                        mi.1.NHB_wBRT ,
                        mi.1.NHB_dBRT ,
                        mi.1.NHB_wdBRT,
                        mi.1.NHB_wTRN ,
                        mi.1.NHB_dTRN ,
                        mi.1.NHB_wdTRN,
                        mi.1.ALL_MNM  ,
                        mi.1.ALL_M    ,
                        mi.1.ALL_NM   ,
                        mi.1.ALL_T    ,
                        mi.1.ALL_A    ,
                        mi.1.ALL_DA   ,
                        mi.1.ALL_SR2  ,
                        mi.1.ALL_SR3p ,
                        mi.1.ALL_wLCL ,
                        mi.1.ALL_dLCL ,
                        mi.1.ALL_wdLCL,
                        mi.1.ALL_wCOR ,
                        mi.1.ALL_dCOR ,
                        mi.1.ALL_wdCOR,
                        mi.1.ALL_wEXP ,
                        mi.1.ALL_dEXP ,
                        mi.1.ALL_wdEXP,
                        mi.1.ALL_wLRT ,
                        mi.1.ALL_dLRT ,
                        mi.1.ALL_wdLRT,
                        mi.1.ALL_wCRT ,
                        mi.1.ALL_dCRT ,
                        mi.1.ALL_wdCRT,
                        mi.1.ALL_wBRT ,
                        mi.1.ALL_dBRT ,
                        mi.1.ALL_wdBRT,
                        mi.1.ALL_wTRN ,
                        mi.1.ALL_dTRN ,
                        mi.1.ALL_wdTRN
        ENDJLOOP
    ENDRUN

    
    ;Convert to MEDIUM District PURPOSE matrix to CSV format
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize post destinaion choice trip table to DISTSML districts - CSV format'
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_PA_AutoTransit.mtx'
        
        
        ;set MATRIX parameters
        ZONEMSG = @ZoneMsgRate@
        
        ;working matrices for AP is transposed PA matrix
        mw[1]   = mi.1.HBW_MNM.T
        mw[2]   = mi.1.HBW_M.T
        mw[3]   = mi.1.HBW_NM.T
        mw[4]   = mi.1.HBW_T.T
        mw[5]   = mi.1.HBW_A.T
        mw[6]   = mi.1.HBW_DA.T
        mw[7]   = mi.1.HBW_SR2.T
        mw[8]   = mi.1.HBW_SR3p.T
        mw[9]   = mi.1.HBW_wLCL.T
        mw[10]  = mi.1.HBW_dLCL.T
        mw[11]  = mi.1.HBW_wdLCL.T
        mw[12]  = mi.1.HBW_wCOR.T
        mw[13]  = mi.1.HBW_dCOR.T
        mw[14]  = mi.1.HBW_wdCOR.T
        mw[15]  = mi.1.HBW_wEXP.T
        mw[16]  = mi.1.HBW_dEXP.T
        mw[17]  = mi.1.HBW_wdEXP.T
        mw[18]  = mi.1.HBW_wLRT.T
        mw[19]  = mi.1.HBW_dLRT.T
        mw[20]  = mi.1.HBW_wdLRT.T
        mw[21]  = mi.1.HBW_wCRT.T
        mw[22]  = mi.1.HBW_dCRT.T
        mw[23]  = mi.1.HBW_wdCRT.T
        mw[24]  = mi.1.HBW_wBRT.T
        mw[25]  = mi.1.HBW_dBRT.T
        mw[26]  = mi.1.HBW_wdBRT.T
        mw[27]  = mi.1.HBW_wTRN.T
        mw[28]  = mi.1.HBW_dTRN.T
        mw[29]  = mi.1.HBW_wdTRN.T
        mw[30]  = mi.1.HBC_MNM.T
        mw[31]  = mi.1.HBC_M.T
        mw[32]  = mi.1.HBC_NM.T
        mw[33]  = mi.1.HBC_T.T
        mw[34]  = mi.1.HBC_A.T
        mw[35]  = mi.1.HBC_DA.T
        mw[36]  = mi.1.HBC_SR2.T
        mw[37]  = mi.1.HBC_SR3p.T
        mw[38]  = mi.1.HBC_wLCL.T
        mw[39]  = mi.1.HBC_dLCL.T
        mw[40]  = mi.1.HBC_wdLCL.T
        mw[41]  = mi.1.HBC_wCOR.T
        mw[42]  = mi.1.HBC_dCOR.T
        mw[43]  = mi.1.HBC_wdCOR.T
        mw[44]  = mi.1.HBC_wEXP.T
        mw[45]  = mi.1.HBC_dEXP.T
        mw[46]  = mi.1.HBC_wdEXP.T
        mw[47]  = mi.1.HBC_wLRT.T
        mw[48]  = mi.1.HBC_dLRT.T
        mw[49]  = mi.1.HBC_wdLRT.T
        mw[50]  = mi.1.HBC_wCRT.T
        mw[51]  = mi.1.HBC_dCRT.T
        mw[52]  = mi.1.HBC_wdCRT.T
        mw[53]  = mi.1.HBC_wBRT.T
        mw[54]  = mi.1.HBC_dBRT.T
        mw[55]  = mi.1.HBC_wdBRT.T
        mw[56]  = mi.1.HBC_wTRN.T
        mw[57]  = mi.1.HBC_dTRN.T
        mw[58]  = mi.1.HBC_wdTRN.T
        mw[59]  = mi.1.HBO_MNM.T
        mw[60]  = mi.1.HBO_M.T
        mw[61]  = mi.1.HBO_NM.T
        mw[62]  = mi.1.HBO_T.T
        mw[63]  = mi.1.HBO_A.T
        mw[64]  = mi.1.HBO_DA.T
        mw[65]  = mi.1.HBO_SR2.T
        mw[66]  = mi.1.HBO_SR3p.T
        mw[67]  = mi.1.HBO_wLCL.T
        mw[68]  = mi.1.HBO_dLCL.T
        mw[69]  = mi.1.HBO_wdLCL.T
        mw[70]  = mi.1.HBO_wCOR.T
        mw[71]  = mi.1.HBO_dCOR.T
        mw[72]  = mi.1.HBO_wdCOR.T
        mw[73]  = mi.1.HBO_wEXP.T
        mw[74]  = mi.1.HBO_dEXP.T
        mw[75]  = mi.1.HBO_wdEXP.T
        mw[76]  = mi.1.HBO_wLRT.T
        mw[77]  = mi.1.HBO_dLRT.T
        mw[78]  = mi.1.HBO_wdLRT.T
        mw[79]  = mi.1.HBO_wCRT.T
        mw[80]  = mi.1.HBO_dCRT.T
        mw[81]  = mi.1.HBO_wdCRT.T
        mw[82]  = mi.1.HBO_wBRT.T
        mw[83]  = mi.1.HBO_dBRT.T
        mw[84]  = mi.1.HBO_wdBRT.T
        mw[85]  = mi.1.HBO_wTRN.T
        mw[86]  = mi.1.HBO_dTRN.T
        mw[87]  = mi.1.HBO_wdTRN.T
        mw[88]  = mi.1.NHB_MNM.T
        mw[89]  = mi.1.NHB_M.T
        mw[90]  = mi.1.NHB_NM.T
        mw[91]  = mi.1.NHB_T.T
        mw[92]  = mi.1.NHB_A.T
        mw[93]  = mi.1.NHB_DA.T
        mw[94]  = mi.1.NHB_SR2.T
        mw[95]  = mi.1.NHB_SR3p.T
        mw[96]  = mi.1.NHB_wLCL.T
        mw[97]  = mi.1.NHB_dLCL.T
        mw[98]  = mi.1.NHB_wdLCL.T
        mw[99]  = mi.1.NHB_wCOR.T
        mw[100]  = mi.1.NHB_dCOR.T
        mw[101]  = mi.1.NHB_wdCOR.T
        mw[102]  = mi.1.NHB_wEXP.T
        mw[103]  = mi.1.NHB_dEXP.T
        mw[104]  = mi.1.NHB_wdEXP.T
        mw[105]  = mi.1.NHB_wLRT.T
        mw[106]  = mi.1.NHB_dLRT.T
        mw[107]  = mi.1.NHB_wdLRT.T
        mw[108]  = mi.1.NHB_wCRT.T
        mw[109] = mi.1.NHB_dCRT.T
        mw[110] = mi.1.NHB_wdCRT.T
        mw[111] = mi.1.NHB_wBRT.T
        mw[112] = mi.1.NHB_dBRT.T
        mw[113] = mi.1.NHB_wdBRT.T
        mw[114] = mi.1.NHB_wTRN.T
        mw[115] = mi.1.NHB_dTRN.T
        mw[116] = mi.1.NHB_wdTRN.T
        mw[117] = mi.1.ALL_MNM.T
        mw[118] = mi.1.ALL_M.T
        mw[119] = mi.1.ALL_NM.T
        mw[120] = mi.1.ALL_T.T
        mw[121] = mi.1.ALL_A.T
        mw[122] = mi.1.ALL_DA.T
        mw[123] = mi.1.ALL_SR2.T
        mw[124] = mi.1.ALL_SR3p.T
        mw[125] = mi.1.ALL_wLCL.T
        mw[126] = mi.1.ALL_dLCL.T
        mw[127] = mi.1.ALL_wdLCL.T
        mw[128] = mi.1.ALL_wCOR.T
        mw[129] = mi.1.ALL_dCOR.T
        mw[130] = mi.1.ALL_wdCOR.T
        mw[131] = mi.1.ALL_wEXP.T
        mw[132] = mi.1.ALL_dEXP.T
        mw[133] = mi.1.ALL_wdEXP.T
        mw[134] = mi.1.ALL_wLRT.T
        mw[135] = mi.1.ALL_dLRT.T
        mw[136] = mi.1.ALL_wdLRT.T
        mw[137] = mi.1.ALL_wCRT.T
        mw[138] = mi.1.ALL_dCRT.T
        mw[139] = mi.1.ALL_wdCRT.T
        mw[140] = mi.1.ALL_wBRT.T
        mw[141] = mi.1.ALL_dBRT.T
        mw[142] = mi.1.ALL_wdBRT.T
        mw[143] = mi.1.ALL_wTRN.T
        mw[144] = mi.1.ALL_dTRN.T
        mw[145] = mi.1.ALL_wdTRN.T

        ;write out AP direction to same file, so no header
        JLOOP
            ;print matrix data to a linear csv file
            PRINT FILE='@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_AutoTransit.csv',
                APPEND=T,
                CSV=T,
                LIST=   I(5.0),
                        J(5.0),
                        'A',
                        mw[1],
                        mw[2],
                        mw[3],
                        mw[4],
                        mw[5],
                        mw[6],
                        mw[7],
                        mw[8],
                        mw[9],
                        mw[10],
                        mw[11],
                        mw[12],
                        mw[13],
                        mw[14],
                        mw[15],
                        mw[16],
                        mw[17],
                        mw[18],
                        mw[19],
                        mw[20],
                        mw[21],
                        mw[22],
                        mw[23],
                        mw[24],
                        mw[25],
                        mw[26],
                        mw[27],
                        mw[28],
                        mw[29],
                        mw[30],
                        mw[31],
                        mw[32],
                        mw[33],
                        mw[34],
                        mw[35],
                        mw[36],
                        mw[37],
                        mw[38],
                        mw[39],
                        mw[40],
                        mw[41],
                        mw[42],
                        mw[43],
                        mw[44],
                        mw[45],
                        mw[46],
                        mw[47],
                        mw[48],
                        mw[49],
                        mw[50],
                        mw[51],
                        mw[52],
                        mw[53],
                        mw[54],
                        mw[55],
                        mw[56],
                        mw[57],
                        mw[58],
                        mw[59],
                        mw[60],
                        mw[61],
                        mw[62],
                        mw[63],
                        mw[64],
                        mw[65],
                        mw[66],
                        mw[67],
                        mw[68],
                        mw[69],
                        mw[70],
                        mw[71],
                        mw[72],
                        mw[73],
                        mw[74],
                        mw[75],
                        mw[76],
                        mw[77],
                        mw[78],
                        mw[79],
                        mw[80],
                        mw[81],
                        mw[82],
                        mw[83],
                        mw[84],
                        mw[85],
                        mw[86],
                        mw[87],
                        mw[88],
                        mw[89],
                        mw[90],
                        mw[91],
                        mw[92],
                        mw[93],
                        mw[94],
                        mw[95],
                        mw[96],
                        mw[97],
                        mw[98],
                        mw[99],
                        mw[100],
                        mw[101],
                        mw[102],
                        mw[103],
                        mw[104],
                        mw[105],
                        mw[106],
                        mw[107],
                        mw[108],
                        mw[109],
                        mw[110],
                        mw[111],
                        mw[112],
                        mw[113],
                        mw[114],
                        mw[115],
                        mw[116],
                        mw[117],
                        mw[118],
                        mw[119],
                        mw[120],
                        mw[121],
                        mw[122],
                        mw[123],
                        mw[124],
                        mw[125],
                        mw[126],
                        mw[127],
                        mw[128],
                        mw[129],
                        mw[130],
                        mw[131],
                        mw[132],
                        mw[133],
                        mw[134],
                        mw[135],
                        mw[136],
                        mw[137],
                        mw[138],
                        mw[139],
                        mw[140],
                        mw[141],
                        mw[142],
                        mw[143],
                        mw[144],
                        mw[145]
        ENDJLOOP
    ENDRUN
    

;Cluster: end of group distributed to processor 5
EndDistributeMULTISTEP



;Cluster: keep processing on processor 1 (Main)
    
    ;summarize final MODE SHARES Trip Tables to county Districts
    RUN PGM=MATRIX   MSG='Mode Choice 18: summarize mode choice trip table to County'
        FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\_lookup_DISTLRG_DISTMED_DISTSML.dbf'
        
        FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
              MATI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
              MATI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
              MATI[4] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_allsegs_pkok.mtx'
              MATI[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx'  ;This is a summation of the 4 purposes above.
              
        FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_County_Daily_PA_AutoTransit_HBW.mtx', 
                  MO=11-39, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL, 
                               wCOR, dCOR, wdCOR, 
                               wEXP, dEXP, wdEXP, 
                               wLRT, dLRT, wdLRT, 
                               wCRT, dCRT, wdCRT, 
                               wBRT, dBRT, wdBRT, 
                               wTRN, dTRN, wdTRN
                               
              MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_County_Daily_PA_AutoTransit_HBC.mtx',
                  MO=41-69, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p,
                               wLCL, dLCL, wdLCL,
                               wCOR, dCOR, wdCOR,
                               wEXP, dEXP, wdEXP,
                               wLRT, dLRT, wdLRT,
                               wCRT, dCRT, wdCRT,
                               wBRT, dBRT, wdBRT,
                               wTRN, dTRN, wdTRN
                               
              MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_County_Daily_PA_AutoTransit_HBO.mtx',
                  MO=71-99, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p,
                               wLCL, dLCL, wdLCL,
                               wCOR, dCOR, wdCOR,
                               wEXP, dEXP, wdEXP,
                               wLRT, dLRT, wdLRT,
                               wCRT, dCRT, wdCRT,
                               wBRT, dBRT, wdBRT,
                               wTRN, dTRN, wdTRN
                               
              MATO[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_County_Daily_PA_AutoTransit_NHB.mtx',
                  MO=101-129, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL,
                               wCOR, dCOR, wdCOR,
                               wEXP, dEXP, wdEXP,
                               wLRT, dLRT, wdLRT,
                               wCRT, dCRT, wdCRT,
                               wBRT, dBRT, wdBRT,
                               wTRN, dTRN, wdTRN
                               
              MATO[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_County_Daily_PA_AutoTransit_ALL.mtx',
                  MO=131-159, NAME=MNM, M, NM, T, A, 
                               DA, SR2, SR3p, 
                               wLCL, dLCL, wdLCL,
                               wCOR, dCOR, wdCOR,
                               wEXP, dEXP, wdEXP,
                               wLRT, dLRT, wdLRT,
                               wCRT, dCRT, wdCRT,
                               wBRT, dBRT, wdBRT,
                               wTRN, dTRN, wdTRN
    
    
        ;set MATRIX parameters
        ZONES   = @UsedZones@
        ZONEMSG = @ZoneMsgRate@
        
        
        ;assign work matrices
        ;HBW trips
        mw[11] = (mi.1.MOTOR + mi.1.NONMOTOR) / 100
        mw[12] =  mi.1.MOTOR / 100
        mw[13] =  mi.1.NONMOTOR / 100
        mw[14] =  mi.1.TRANSIT / 100
        mw[15] =  mi.1.AUTO / 100
        mw[16] =  mi.1.DA / 100
        mw[17] =  mi.1.SR2 / 100
        mw[18] =  mi.1.SR3p / 100
        mw[19] =  mi.1.wLCL / 100
        mw[20] =  mi.1.dLCL / 100
        mw[21] = (mi.1.wLCL + mi.1.dLCL) / 100
        mw[22] =  mi.1.wCOR / 100
        mw[23] =  mi.1.dCOR / 100
        mw[24] = (mi.1.wCOR + mi.1.dCOR) / 100
        mw[25] =  mi.1.wEXP / 100
        mw[26] =  mi.1.dEXP / 100
        mw[27] = (mi.1.wEXP + mi.1.dEXP) / 100
        mw[28] =  mi.1.wLRT / 100
        mw[29] =  mi.1.dLRT / 100
        mw[30] = (mi.1.wLRT + mi.1.dLRT) / 100
        mw[31] =  mi.1.wCRT / 100
        mw[32] =  mi.1.dCRT / 100
        mw[33] = (mi.1.wCRT + mi.1.dCRT) / 100
        mw[34] =  mi.1.wBRT / 100
        mw[35] =  mi.1.dBRT / 100
        mw[36] = (mi.1.wBRT + mi.1.dBRT) / 100
        mw[37] =  mi.1.wTRN / 100
        mw[38] =  mi.1.dTRN / 100
        mw[39] = (mi.1.wTRN + mi.1.dTRN) / 100
        
        ;HBC trips
        mw[41] = (mi.2.MOTOR + mi.2.NONMOTOR) / 100
        mw[42] =  mi.2.MOTOR / 100
        mw[43] =  mi.2.NONMOTOR / 100
        mw[44] =  mi.2.TRANSIT / 100
        mw[45] =  mi.2.AUTO / 100
        mw[46] =  mi.2.DA / 100
        mw[47] =  mi.2.SR2 / 100
        mw[48] =  mi.2.SR3p / 100
        mw[49] =  mi.2.wLCL / 100
        mw[50] =  mi.2.dLCL / 100
        mw[51] = (mi.2.wLCL + mi.2.dLCL) / 100
        mw[52] =  mi.2.wCOR / 100
        mw[53] =  mi.2.dCOR / 100
        mw[54] = (mi.2.wCOR + mi.2.dCOR) / 100
        mw[55] =  mi.2.wEXP / 100
        mw[56] =  mi.2.dEXP / 100
        mw[57] = (mi.2.wEXP + mi.2.dEXP) / 100
        mw[58] =  mi.2.wLRT / 100
        mw[59] =  mi.2.dLRT / 100
        mw[60] = (mi.2.wLRT + mi.2.dLRT) / 100
        mw[61] =  mi.2.wCRT / 100
        mw[62] =  mi.2.dCRT / 100
        mw[63] = (mi.2.wCRT + mi.2.dCRT) / 100
        mw[64] =  mi.2.wBRT / 100
        mw[65] =  mi.2.dBRT / 100
        mw[66] = (mi.2.wBRT + mi.2.dBRT) / 100
        mw[67] =  mi.2.wTRN / 100
        mw[68] =  mi.2.dTRN / 100
        mw[69] = (mi.2.wTRN + mi.2.dTRN) / 100
                
        ;HBO trips
        mw[71] = (mi.3.MOTOR + mi.3.NONMOTOR) / 100
        mw[72] =  mi.3.MOTOR / 100
        mw[73] =  mi.3.NONMOTOR / 100
        mw[74] =  mi.3.TRANSIT / 100
        mw[75] =  mi.3.AUTO / 100
        mw[76] =  mi.3.DA / 100
        mw[77] =  mi.3.SR2 / 100
        mw[78] =  mi.3.SR3p / 100
        mw[79] =  mi.3.wLCL / 100
        mw[80] =  mi.3.dLCL / 100
        mw[81] = (mi.3.wLCL + mi.3.dLCL) / 100
        mw[82] =  mi.3.wCOR / 100
        mw[83] =  mi.3.dCOR / 100
        mw[84] = (mi.3.wCOR + mi.3.dCOR) / 100
        mw[85] =  mi.3.wEXP / 100
        mw[86] =  mi.3.dEXP / 100
        mw[87] = (mi.3.wEXP + mi.3.dEXP) / 100
        mw[88] =  mi.3.wLRT / 100
        mw[89] =  mi.3.dLRT / 100
        mw[90] = (mi.3.wLRT + mi.3.dLRT) / 100
        mw[91] =  mi.3.wCRT / 100
        mw[92] =  mi.3.dCRT / 100
        mw[93] = (mi.3.wCRT + mi.3.dCRT) / 100
        mw[94] =  mi.3.wBRT / 100
        mw[95] =  mi.3.dBRT / 100
        mw[96] = (mi.3.wBRT + mi.3.dBRT) / 100
        mw[97] =  mi.3.wTRN / 100
        mw[98] =  mi.3.dTRN / 100
        mw[99] = (mi.3.wTRN + mi.3.dTRN) / 100
        
        ;NHB trips
        mw[101] = (mi.4.MOTOR + mi.4.NONMOTOR) / 100
        mw[102] =  mi.4.MOTOR / 100
        mw[103] =  mi.4.NONMOTOR / 100
        mw[104] =  mi.4.TRANSIT / 100
        mw[105] =  mi.4.AUTO / 100
        mw[106] =  mi.4.DA / 100
        mw[107] =  mi.4.SR2 / 100
        mw[108] =  mi.4.SR3p / 100
        mw[109] =  mi.4.wLCL / 100
        mw[110] =  mi.4.dLCL / 100
        mw[111] = (mi.4.wLCL + mi.4.dLCL) / 100
        mw[112] =  mi.4.wCOR / 100
        mw[113] =  mi.4.dCOR / 100
        mw[114] = (mi.4.wCOR + mi.4.dCOR) / 100
        mw[115] =  mi.4.wEXP / 100
        mw[116] =  mi.4.dEXP / 100
        mw[117] = (mi.4.wEXP + mi.4.dEXP) / 100
        mw[118] =  mi.4.wLRT / 100
        mw[119] =  mi.4.dLRT / 100
        mw[120] = (mi.4.wLRT + mi.4.dLRT) / 100
        mw[121] =  mi.4.wCRT / 100
        mw[122] =  mi.4.dCRT / 100
        mw[123] = (mi.4.wCRT + mi.4.dCRT) / 100
        mw[124] =  mi.4.wBRT / 100
        mw[125] =  mi.4.dBRT / 100
        mw[126] = (mi.4.wBRT + mi.4.dBRT) / 100
        mw[127] =  mi.4.wTRN / 100
        mw[128] =  mi.4.dTRN / 100
        mw[129] = (mi.4.wTRN + mi.4.dTRN) / 100
        
        ;ALL trips
        mw[131] = (mi.5.MOTOR + mi.5.NONMOTOR) / 100
        mw[132] =  mi.5.MOTOR / 100
        mw[133] =  mi.5.NONMOTOR / 100
        mw[134] =  mi.5.TRANSIT / 100
        mw[135] =  mi.5.AUTO / 100
        mw[136] =  mi.5.DA / 100
        mw[137] =  mi.5.SR2 / 100
        mw[138] =  mi.5.SR3p / 100
        mw[139] =  mi.5.wLCL / 100
        mw[140] =  mi.5.dLCL / 100
        mw[141] = (mi.5.wLCL + mi.5.dLCL) / 100
        mw[142] =  mi.5.wCOR / 100
        mw[143] =  mi.5.dCOR / 100
        mw[144] = (mi.5.wCOR + mi.5.dCOR) / 100
        mw[145] =  mi.5.wEXP / 100
        mw[146] =  mi.5.dEXP / 100
        mw[147] = (mi.5.wEXP + mi.5.dEXP) / 100
        mw[148] =  mi.5.wLRT / 100
        mw[149] =  mi.5.dLRT / 100
        mw[150] = (mi.5.wLRT + mi.5.dLRT) / 100
        mw[151] =  mi.5.wCRT / 100
        mw[152] =  mi.5.dCRT / 100
        mw[153] = (mi.5.wCRT + mi.5.dCRT) / 100
        mw[154] =  mi.5.wBRT / 100
        mw[155] =  mi.5.dBRT / 100
        mw[156] = (mi.5.wBRT + mi.5.dBRT) / 100
        mw[157] =  mi.5.wTRN / 100
        mw[158] =  mi.5.dTRN / 100
        mw[159] = (mi.5.wTRN + mi.5.dTRN) / 100
        
        
        ;summarize to districts
        RENUMBER ZONEO=zi.1.CO_FIPS, missingzi=m, missingzo=w
    ENDRUN

;Cluster: bring together all distributed steps before continuing
WAIT4FILES, 
    FILES="ClusterNodeID2.Script.End", 
    FILES="ClusterNodeID3.Script.End", 
    FILES="ClusterNodeID4.Script.End",
    CheckReturnCode=T



RUN PGM=MATRIX MSG='1: Run Python Script to Create JSON for vizTool'

    ZONES = 1
    
    ;create control input file for this Python script
    PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
        LIST='#Python input file variables and paths',
             '\njsonId            = "distsmlod"',
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
             '\ninputFile       = r"@ParentDir@@ScenarioDir@4_ModeChoice\5_DistrictSummary\@RID@_DISTSML_Daily_AutoTransit.csv"',
             '\n',
             '\n'

ENDRUN

;Python script: create json
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\py-vizTool\vt_CompileJson.py" 1>&2



;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Sum to Districts                   ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 18_SumToDistricts_FinalTripTables.txt)
