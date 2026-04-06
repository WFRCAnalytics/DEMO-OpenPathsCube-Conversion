
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 14_AsnTran.txt)



;get start time
ScriptStartTime = currenttime()



    
LOOP period = 1,2
    ;set name variable for output files
    if (period=1)
        prd       = 'Pk'
        TranSpeed = 'SPEED_AM'
    else
        prd       = 'Ok'
        TranSpeed = 'SPEED_MD'
    endif
    
    
    ;Cluster: distrubute MATRIX call onto processor 2
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2
     
        ;========================================================================================
        ;                             WALK & DRIVE to LCL (MODE 4)
        ;========================================================================================
        ;walk to local
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to LCL - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_LCL_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w4_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw4_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wLCL_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wLCL_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wLCL_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wLCL_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wLCL
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;drive to local
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to LCL - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_LCL_skims_@prd@.NET'
            FILEI ROUTEI[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d4_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd4_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dLCL_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dLCL_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dLCL_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dLCL_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 2
            PARAMETERS TRIPSIJ[2] = MI.1.dLCL
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
         
         
        ;========================================================================================
        ;                             WALK & DRIVE to COR (MODE 5)
        ;========================================================================================
        ;walk to COR
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to COR - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_COR_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w5_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw5_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wCOR_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wCOR_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wCOR_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wCOR_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wCOR
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;drive to COR
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to COR - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_COR_skims_@prd@.NET'
            FILEI ROUTEI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d5_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd5_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dCOR_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dCOR_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dCOR_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dCOR_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 3
            PARAMETERS TRIPSIJ[3]  = MI.1.dCOR
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
         
    ;Cluster: end of group distributed to processor 2
    EndDistributeMULTISTEP
    
    
     
    ;Cluster: distrubute MATRIX call onto processor 3
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=3
         
         
        ;========================================================================================
        ;                             WALK & DRIVE to COR (BRT)
        ;========================================================================================
        ;walk to BRT
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to BRT - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_BRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w9_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw9_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wBRT_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wBRT_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wBRT_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wBRT_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wBRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;drive to BRT
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to BRT - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_BRT_skims_@prd@.NET'
            FILEI ROUTEI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d9_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd9_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dBRT_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dBRT_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dBRT_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dBRT_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 3
            PARAMETERS TRIPSIJ[3]  = MI.1.dBRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
     
        ;========================================================================================
        ;                             WALK & DRIVE to EXP (MODE 6)
        ;========================================================================================
        ;walk to express
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to EXP - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_EXP_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w6_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw6_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wEXP_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wEXP_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wEXP_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wEXP_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wEXP
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;drive to express
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to EXP - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_EXP_skims_@prd@.NET'
            FILEI ROUTEI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d6_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd6_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dEXP_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dEXP_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dEXP_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dEXP_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 3
            PARAMETERS TRIPSIJ[3]  = MI.1.dEXP
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
         
    ;Cluster: end of group distributed to processor 3
    EndDistributeMULTISTEP
    
    
     
    ;Cluster: distrubute MATRIX call onto processor 4
    DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=4
     
         
        ;========================================================================================
        ;                             WALK & DRIVE to LRT (MODE 7)
        ;========================================================================================
        ;divide walk to LRT trips into CBD and non-CBD
        RUN PGM=MATRIX   MSG='Mode Choice 14: divide walk to LRT trips into CBD & non-CBD - @prd@'

            FILEI ZDATI   = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
                Z=TAZID
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
                        
            FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkLrt_outsideCBD_@prd@.mtx', 
                MO=1, 
                NAME=wLRT
            
            FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkLrt_CBD_@prd@.mtx', 
                MO=2, 
                NAME=wLRT
              
            ZONES   = @usedzones@
            ZONEMSG = 100 
            
           JLOOP 
              if (zi.1.CBD[j] = 1) 
                  mw[1][j] = mi.1.wLRT[j]
                  mw[2][j] = 0
              else
                  mw[1][j] = 0
                  mw[2][j] = mi.1.wLRT[j]
              endif
           ENDJLOOP 
        ENDRUN
        
        ;walk to LRT (non-CBD)
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to LRT (non-CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_WLRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkLrt_outsideCBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_outsideCBD_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wLRT_outsideCBD_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wLRT_outsideCBD_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wLRT_outsideCBD_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wLRT_outsideCBD_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wLRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        ;walk to LRT CBD
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to LRT (CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_WLRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w7_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkLrt_CBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw7_cbd_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wLRT_cbd_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wLRT_cbd_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wLRT_cbd_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wLRT_cbd_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wLRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;drive to LRT
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to LRT - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_DLRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d7_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd7_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dLRT_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dLRT_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dLRT_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dLRT_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.dLRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
         
    ;Cluster: end of group distributed to processor 4
    EndDistributeMULTISTEP
        
     
    ;Cluster: keep processing on processor 1 (Main)
         
        ;========================================================================================
        ;                             WALK & DRIVE to CRT (MODE 8)
        ;========================================================================================
        ;divide walk to CRT trips into CBD & non-CBD
        RUN PGM=MATRIX   MSG='Mode Choice 14: divide walk to CRT trips into CBD & non-CBD - @prd@'

            
            FILEI ZDATI   = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
                Z=TAZID
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'            
            FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkCRT_outsideCBD_@prd@.mtx', 
                MO=1, 
                NAME=wCRT
            
            FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkCRT_CBD_@prd@.mtx', 
                MO=2, 
                NAME=wCRT
              
            ZONES   = @usedzones@
            ZONEMSG = 100 
            
           JLOOP 
              if (zi.1.CBD[j] = 1) 
                  mw[1][j] = mi.1.wCRT[j]
                  mw[2][j] = 0
              else
                  mw[1][j] = 0
                  mw[2][j] = mi.1.wCRT[j]
              endif
           ENDJLOOP 
        ENDRUN
        
        ;walk to CRT (non-CBD)
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to CRT (non-CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_CRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w8_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkCRT_outsideCBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_outsideCBD_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wCRT_outsideCBDassign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wCRT_outsideCBDassign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wCRT_outsideCBDassign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wCRT_outsideCBDassign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wCRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        ;walk to CRT CBD
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign walk to CRT (CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_CRT_skims_@prd@.NET'
            FILEI ROUTEI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_w8_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\WalkCRT_CBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkw8_cbd_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_wCRT_cbd_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_wCRT_cbd_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_wCRT_cbd_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_wCRT_cbd_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 1
            PARAMETERS TRIPSIJ[1]  = MI.1.wCRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        
        ;divide drive to CRT trips into CBD & non-CBD
        RUN PGM=MATRIX   MSG='Mode Choice 14: divide drive to CRT trips into CBD & non-CBD - @prd@'

            
            FILEI ZDATI   = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
                Z=TAZID
            FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_@prd@.mtx'            
            FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\DriveCRT_outsideCBD_@prd@.mtx', 
                MO=1, 
                NAME=dCRT
            
            FILEO MATO[2] = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\DriveCRT_CBD_@prd@.mtx', 
                MO=2, 
                NAME=dCRT
              
            ZONES   = @usedzones@
            ZONEMSG = 100 
            
           JLOOP 
              if (zi.1.CBD[j] = 1) 
                  mw[1][j] = mi.1.dCRT[j]
                  mw[2][j] = 0
              else
                  mw[1][j] = 0
                  mw[2][j] = mi.1.dCRT[j]
              endif
           ENDJLOOP 
        ENDRUN
        
        ;drive to CRT (non-CBD)
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to CRT (non-CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_CRT_skims_@prd@.NET'
            FILEI ROUTEI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d8_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\DriveCRT_outsideCBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_outsideCBD_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dCRT_outsideCBDassign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dCRT_outsideCBDassign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dCRT_outsideCBDassign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dCRT_outsideCBDassign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 3
            PARAMETERS TRIPSIJ[3]  = MI.1.dCRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
        
        ;drive to CRT CBD
        RUN PGM=PUBLIC TRANSPORT   MSG='Mode Choice 14: assign drive to CRT (CBD) - @prd@'
            FILEI NETI      = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\PTNetOut_CRT_skims_@prd@.NET'
            FILEI ROUTEI[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\1b_EnumeratedRoutes\ROUTEO_skm_d8_@prd@.RET'
            
            FILEI MATI[1]   = '@ParentDir@@ScenarioDir@Temp\4_ModeChoice\DriveCRT_CBD_@prd@.mtx'
            
            FILEO LINKO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\asn_linkd8_cbd_@prd@.dbf',
                ONOFFS=Y
            FILEO NETO    = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNet_dCRT_cbd_assign_@prd@.NET'
            FILEO LINEO   = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTLine_dCRT_cbd_assign_@prd@.txt'
            FILEO NTLEGO  = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTNTLeg_dCRT_cbd_assign_@prd@.txt'
            FILEO REPORTO = '@ParentDir@@ScenarioDir@4_ModeChoice\3_TransitAssign\PTReport_dCRT_cbd_assign_@prd@.txt'
            
            ;set parameters
            PARAMETERS HDWAYPERIOD = @period@
            PARAMETERS USERCLASSES = 3
            PARAMETERS TRIPSIJ[3]  = MI.1.dCRT
            
            ;Selection of Loading Reports
            REPORT LINES=T, SORT=MODE, LINEVOLS=T, STOPSONLY=T, SKIP0=TENDRUN
        ENDRUN
         
     
    ;Cluster: bring together all distributed steps before continuing
    WAIT4FILES, FILES="ClusterNodeID2.Script.End", FILES="ClusterNodeID3.Script.End", FILES="ClusterNodeID4.Script.End", CheckReturnCode=T
        
        
ENDLOOP ;period




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Assign Transit Trips               ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 14_AsnTran.txt)
