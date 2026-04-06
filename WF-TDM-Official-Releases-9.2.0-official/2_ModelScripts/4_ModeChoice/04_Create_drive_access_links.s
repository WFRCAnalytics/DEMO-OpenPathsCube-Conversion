
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 04_Create_drive_access_links.txt)



;get start time
ScriptStartTime = currenttime()




;script specific variables
    ;KNR mode
    ;Mode30
    Mode30_MaxDist     = 1.5      ;mile
    Mode30_MaxDist_SL  = 1.5
    Mode30_MaxDist_UT  = 1.5
    
    ;bus modes
    ;Mode40
    Mode40_NumCon      = 3      ;max number of drive access link
    Mode40_EligiblePNR = '40,50,60,70,80,90'
    Mode40_MaxTime     = 6      ;min
    Mode40_MaxTime_SL  = 5
    Mode40_MaxTime_UT  = 6

    ;Mode50
    Mode50_NumCon      = 2      ;max number of drive access link
    Mode50_EligiblePNR = '40,50,60,70,80,90'
    Mode50_MaxTime     = 8      ;min
    Mode50_MaxTime_SL  = 5
    Mode50_MaxTime_UT  = 8
    
    ;Mode90
    Mode90_NumCon      = 2      ;max number of drive access link
    Mode90_EligiblePNR = '40,50,60,70,80,90'
    Mode90_MaxTime     = 6      ;min
    Mode90_MaxTime_SL  = 3
    Mode90_MaxTime_UT  = 6
    
    ;Mode60            
    Mode60_NumCon      = 2      ;max number of drive access link
    Mode60_EligiblePNR = '40,50,60,70,80,90'
    Mode60_MaxTime     = 12     ;min
    Mode60_MaxTime_SL  = 7
    Mode60_MaxTime_UT  = 12
    
    ;rail modes
    ;Mode70            
    Mode70_NumCon      = 2      ;max number of drive access link
    Mode70_EligiblePNR = '40,50,60,70,80,90'
    Mode70_MaxTime     = 25     ;min
    Mode70_MaxTime_SL  = 20
    Mode70_MaxTime_UT  = 25
    PNR_notfor_DAWE    =20125 ; DA and WE residents do not want to drive to U and PNR and use Trax
    
    ;Mode80            
    Mode80_NumCon      = 2      ;max number of drive access link
    Mode80_EligiblePNR = '40,50,60,70,80,90'
    Mode80_MaxTime     = 30     ;min
    Mode80_MaxTime_SL  = 25
    Mode80_MaxTime_UT  = 35
    




;CREATE KNR DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE30 drive access links
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate KNR (mode 30) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',                 AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsAllModes.dbf',            AUTOARRAY=ALLFIELDS
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode30.NTL'
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;loop through TAZ nodes
    LOOP TAZ_Node=1,@UsedZones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        ;calculate TAZ X & Y coordinates, TAZ area in sqare miles
        TAZ_X  = DBA.1.X[TAZ_Node]
        TAZ_Y  = DBA.1.Y[TAZ_Node]
        County = DBA.1.CO_FIPS[TAZ_Node]
        
        ;calculate max drive distance (min)
        if (County=35)
            maxdrive = @Mode30_MaxDist_SL@
        elseif (County=49)
            maxdrive = @Mode30_MaxDist_UT@
        else
            maxdrive = @Mode30_MaxDist@
        endif
        
        ;loop through stop nodes
        LOOP StopRec=1,DBI.2.NUMRECORDS
            ;calculate stop node number and X & Y coordinates
            Stop_Node = DBA.2.N[StopRec]
            Stop_X    = DBA.2.X[StopRec]
            Stop_Y    = DBA.2.Y[StopRec]
            
            ;calculate distance & from TAZ to stop node in miles
            xydist = SQRT( (TAZ_X-Stop_X)^2 + (TAZ_Y-Stop_Y)^2 ) / 1609.344    ;convert meters to miles
            
            ;print walk access support link if <= 1 max drive distance
            if (xydist<=maxdrive)
                ;print out link as NT leg
                PRINT PRINTO=1, 
                    LIST='NT LEG=', TAZ_Node(6.0),' -', Stop_Node(6.0), ',  MODE=30,  COST=', xydist/25*60(6.2), ',  DIST=', xydist(6.2), ',  ONEWAY=T,  SPEED=25.0'
            endif
            
        ENDLOOP  ;loop through stop records
        
    ENDLOOP  ;loop through TAZ centroids
    
ENDRUN




;CREATE LCL DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE40 drive access links  
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate LCL (mode 40) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode4.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode40.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx             = DBA.3.N[recnum]
        STOPS_NODE[idx] = recnum
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;initialize PNR variables
        cnt_EligiblePNR = 0
        SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
        
        ;populate closest PNR arrays
        LOOP PNR_recnum=1,DBI.1.NUMRECORDS
            ;assign PNR variables
            PNR_Node   = DBA.1.N[PNR_recnum]
            PNR_X      = DBA.1.X[PNR_recnum]
            PNR_Y      = DBA.1.Y[PNR_recnum]
            PNR_Code   = DBA.1.PNR[PNR_recnum]
            PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
            
            ;check for eligible PNR node
            if (PNR_Code=@Mode40_EligiblePNR@ & STOPS_NODE[PNR_Node]>0)
                ;count eligible PNRs
                cnt_EligiblePNR = cnt_EligiblePNR + 1
                
                ;calculate distance from TAZ to PNR node (not used - calculated for comparison to over-net dist)
                xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                
                ;lookup AM time and distance skim values based on PNR's TAZID
                OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                
                ;calculate total time = in-vehicle time + out-of-vehicle time
                TotalTime   = IVT ;+ OVT
                
                ;check for zero values
                if (IVT=0 | OverNetDist=0)
                    TotalTime   = 9999
                    OverNetDist = 999
                endif
                    
                ;assign initial array element
                Closest_PNR[PNR_recnum]    = PNR_Node
                Closest_Time[PNR_recnum]   = TotalTime
                Closest_Dist[PNR_recnum]   = OverNetDist
                Closest_XYDist[PNR_recnum] = xydist
                
            endif  ;check for eligble PNR node
            
        ENDLOOP  ;populate closest PNR arrays
        
        ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
        SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
        
        ;check array
        ;if (TAZ_Node=11)
        ;    LOOP chk_array=1,cnt_EligiblePNR
        ;        if (chk_array=1)
        ;            PRINT CSV=T, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_closestPNRsorting.csv',
        ;                LIST='     TAZ', '   INDEX', '     PNR', '    TIME', '    DIST', '  XYDIST'
        ;        endif
        ;        
        ;        PRINT CSV=T, FORM=8.0, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_closestPNRsorting.csv',
        ;            LIST=TAZ_Node, chk_array, Closest_PNR[chk_array], Closest_Time[chk_array](8.2), Closest_Dist[chk_array](8.2), Closest_XYDist[chk_array](8.2)
        ;    ENDLOOP
        ;endif
        
        
        ;print drive access links
        LOOP Conct_num=1,@Mode40_NumCon@
            ;assign closest nth eligible PNR node and calculate avg over the network speed
            PNR_Node = Closest_PNR[Conct_num]
            PNR_Time = Closest_Time[Conct_num]
            PNR_Dist = Closest_Dist[Conct_num]
            
            OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
            ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
            if (print_dummy_40=0)
                PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=40,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                print_dummy_40=1
            endif
            
            
            ;print drive access links if less than MaxTime
            if (County=35)
                ;use SL county MaxTime
                if (PNR_Time<=@Mode40_MaxTime_SL@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=40,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            elseif (County=49)
                ;use UT county MaxTime
                if (PNR_Time<=@Mode40_MaxTime_UT@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=40,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            else
                ;use general MaxTime
                if (PNR_Time<=@Mode40_MaxTime@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=40,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
            endif  ;print drive access links if less than MaxTime
            
        ENDLOOP  ;print drive access links
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;CREATE COR DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE50 drive access links  
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate COR (mode 50) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode5.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode50.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx             = DBA.3.N[recnum]
        STOPS_NODE[idx] = recnum
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;initialize PNR variables
        cnt_EligiblePNR = 0
        SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
        
        ;populate closest PNR arrays
        LOOP PNR_recnum=1,DBI.1.NUMRECORDS
            ;assign PNR variables
            PNR_Node   = DBA.1.N[PNR_recnum]
            PNR_X      = DBA.1.X[PNR_recnum]
            PNR_Y      = DBA.1.Y[PNR_recnum]
            PNR_Code   = DBA.1.PNR[PNR_recnum]
            PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
            
            ;check for eligible PNR node
            if (PNR_Code=@Mode50_EligiblePNR@ & STOPS_NODE[PNR_Node]>0)
                ;count eligible PNRs
                cnt_EligiblePNR = cnt_EligiblePNR + 1
                
                ;calculate distance from TAZ to PNR node
                xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                
                ;lookup AM time and distance skim values based on PNR's TAZID
                OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                
                ;calculate total time = in-vehicle time + out-of-vehicle time
                TotalTime   = IVT ;+ OVT
                
                ;check for zero values
                if (IVT=0 | OverNetDist=0)
                    TotalTime   = 9999
                    OverNetDist = 999
                endif
                    
                ;assign initial array element
                Closest_PNR[PNR_recnum]    = PNR_Node
                Closest_Time[PNR_recnum]   = TotalTime
                Closest_Dist[PNR_recnum]   = OverNetDist
                Closest_XYDist[PNR_recnum] = xydist
                
            endif  ;check for eligble PNR node
            
        ENDLOOP  ;populate closest PNR arrays
        
        ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
        SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
        
        ;print drive access links
        LOOP Conct_num=1,@Mode50_NumCon@
            ;assign closest nth eligible PNR node and calculate avg over the network speed
            PNR_Node = Closest_PNR[Conct_num]
            PNR_Time = Closest_Time[Conct_num]
            PNR_Dist = Closest_Dist[Conct_num]
            
            OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
            ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
            if (print_dummy_50=0)
                PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=50,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                print_dummy_50=1
            endif
            
            
            ;print drive access links if less than MaxTime
            if (County=35)
                ;use SL county MaxTime
                if (PNR_Time<=@Mode50_MaxTime_SL@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=50,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            elseif (County=49)
                ;use UT county MaxTime
                if (PNR_Time<=@Mode50_MaxTime_UT@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=50,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            else
                ;use general MaxTime
                if (PNR_Time<=@Mode50_MaxTime@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=50,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
            endif  ;print drive access links if less than MaxTime
            
        ENDLOOP  ;print drive access links
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;CREATE BRT DRIVE ACCESS LINKS ============================================================================================================

;calculate Mode90 drive access links  
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate BRT (Mode90) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode9.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode90.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx             = DBA.3.N[recnum]
        STOPS_NODE[idx] = recnum
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;initialize PNR variables
        cnt_EligiblePNR = 0
        SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
        
        ;populate closest PNR arrays
        LOOP PNR_recnum=1,DBI.1.NUMRECORDS
            ;assign PNR variables
            PNR_Node   = DBA.1.N[PNR_recnum]
            PNR_X      = DBA.1.X[PNR_recnum]
            PNR_Y      = DBA.1.Y[PNR_recnum]
            PNR_Code   = DBA.1.PNR[PNR_recnum]
            PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
            
            ;check for eligible PNR node
            if (PNR_Code=@Mode90_EligiblePNR@ & STOPS_NODE[PNR_Node]>0)
                ;count eligible PNRs
                cnt_EligiblePNR = cnt_EligiblePNR + 1
                
                ;calculate distance from TAZ to PNR node
                xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                
                ;lookup AM time and distance skim values based on PNR's TAZID
                OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                
                ;calculate total time = in-vehicle time + out-of-vehicle time
                TotalTime   = IVT ;+ OVT
                
                ;check for zero values
                if (IVT=0 | OverNetDist=0)
                    TotalTime   = 9999
                    OverNetDist = 999
                endif
                    
                ;assign initial array element
                Closest_PNR[PNR_recnum]    = PNR_Node
                Closest_Time[PNR_recnum]   = TotalTime
                Closest_Dist[PNR_recnum]   = OverNetDist
                Closest_XYDist[PNR_recnum] = xydist
                
            endif  ;check for eligble PNR node
            
        ENDLOOP  ;populate closest PNR arrays
        
        ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
        SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
        
        ;print drive access links
        LOOP Conct_num=1,@Mode90_NumCon@
            ;assign closest nth eligible PNR node and calculate avg over the network speed
            PNR_Node = Closest_PNR[Conct_num]
            PNR_Time = Closest_Time[Conct_num]
            PNR_Dist = Closest_Dist[Conct_num]
            
            OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
            ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
            if (print_dummy_90=0)
                PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=90,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                print_dummy_90=1
            endif
            
            
            ;print drive access links if less than MaxTime
            if (County=35)
                ;use SL county MaxTime
                if (PNR_Time<=@Mode90_MaxTime_SL@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=90,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            elseif (County=49)
                ;use UT county MaxTime
                if (PNR_Time<=@Mode90_MaxTime_UT@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=90,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            else
                ;use general MaxTime
                if (PNR_Time<=@Mode90_MaxTime@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=90,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
            endif  ;print drive access links if less than MaxTime
            
        ENDLOOP  ;print drive access links
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;CREATE EXP DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE60 drive access links  
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate EXP (mode 60) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode6.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode60.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx             = DBA.3.N[recnum]
        STOPS_NODE[idx] = recnum
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;initialize PNR variables
        cnt_EligiblePNR = 0
        SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
        
        ;populate closest PNR arrays
        LOOP PNR_recnum=1,DBI.1.NUMRECORDS
            ;assign PNR variables
            PNR_Node   = DBA.1.N[PNR_recnum]
            PNR_X      = DBA.1.X[PNR_recnum]
            PNR_Y      = DBA.1.Y[PNR_recnum]
            PNR_Code   = DBA.1.PNR[PNR_recnum]
            PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
            
            ;check for eligible PNR node
            if (PNR_Code=@Mode60_EligiblePNR@ & STOPS_NODE[PNR_Node]>0)
                ;count eligible PNRs
                cnt_EligiblePNR = cnt_EligiblePNR + 1
                
                ;calculate distance from TAZ to PNR node
                xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                
                ;lookup AM time and distance skim values based on PNR's TAZID
                OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                
                ;calculate total time = in-vehicle time + out-of-vehicle time
                TotalTime   = IVT ;+ OVT
                
                ;check for zero values
                if (IVT=0 | OverNetDist=0)
                    TotalTime   = 9999
                    OverNetDist = 999
                endif
                    
                ;assign initial array element
                Closest_PNR[PNR_recnum]    = PNR_Node
                Closest_Time[PNR_recnum]   = TotalTime
                Closest_Dist[PNR_recnum]   = OverNetDist
                Closest_XYDist[PNR_recnum] = xydist
                
            endif  ;check for eligble PNR node
            
        ENDLOOP  ;populate closest PNR arrays
        
        ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
        SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
        
        ;print drive access links
        LOOP Conct_num=1,@Mode60_NumCon@
            ;assign closest nth eligible PNR node and calculate avg over the network speed
            PNR_Node = Closest_PNR[Conct_num]
            PNR_Time = Closest_Time[Conct_num]
            PNR_Dist = Closest_Dist[Conct_num]
            
            OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
            ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
            if (print_dummy_60=0)
                PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=60,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                print_dummy_60=1
            endif
            
            
            ;print drive access links if less than MaxTime
            if (County=35)
                ;use SL county MaxTime
                if (PNR_Time<=@Mode60_MaxTime_SL@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=60,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            elseif (County=49)
                ;use UT county MaxTime
                if (PNR_Time<=@Mode60_MaxTime_UT@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=60,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
                
            else
                ;use general MaxTime
                if (PNR_Time<=@Mode60_MaxTime@)
                    ;print out link as NT leg
                    PRINT PRINTO=1, 
                        LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=60,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                endif
            endif  ;print drive access links if less than MaxTime
            
        ENDLOOP  ;print drive access links
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;CREATE LRT DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE70 drive access links
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate light rail (mode 70) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode7.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode70.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define numeric arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    ;define character arrays
    ARRAY TYPE=C55, RailLine_Name  = 99999,
          TYPE=C55, UniqueRailLine = 500
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    ;and identify number of unique rail lines
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx                = DBA.3.N[recnum]
        STOPS_NODE[idx]    = recnum
        RailLine_Name[idx] = DBA.3.ROUTE[recnum]
        
        ;identify unique rail lines
        Unique_Name = DBA.3.ROUTE[recnum]
        inlist      = 0
        
        if (recnum=1)
            cnt_UniqueRail    = 1
            UniqueRailLine[1] = Unique_Name
            
            ;print unique lines to check file
            PRINT CSV=T, FORM=8.0, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_unique_Lines_Mode7.csv',
                LIST=cnt_UniqueRail, UniqueRailLine[1]
            
        else
            LOOP chk_unq=1,cnt_UniqueRail
                if (Unique_Name=UniqueRailLine[chk_unq])
                    ;route name already in list
                    inlist = 1
                    BREAK
                endif
            ENDLOOP
            
            ;add unique rail iine to array
            if (inlist<>1)
                cnt_UniqueRail                 = cnt_UniqueRail + 1
                UniqueRailLine[cnt_UniqueRail] = Unique_Name
            
                ;print unique lines to check file
                PRINT CSV=T, FORM=8.0, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_unique_Lines_Mode7.csv',
                    LIST=cnt_UniqueRail, UniqueRailLine[cnt_UniqueRail]
            endif
        endif
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;loop through unique rail lines
        LOOP lp_Rail=1,cnt_UniqueRail
            ;assign name of unique rail line for this loop iteration
            Check_RailLine = UniqueRailLine[lp_Rail]
            
            ;initialize PNR variables
            cnt_EligiblePNR = 0
            SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
            
            ;populate closest PNR arrays
            LOOP PNR_recnum=1,DBI.1.NUMRECORDS
                ;assign PNR variables
                PNR_Node   = DBA.1.N[PNR_recnum]
                PNR_X      = DBA.1.X[PNR_recnum]
                PNR_Y      = DBA.1.Y[PNR_recnum]
                PNR_Code   = DBA.1.PNR[PNR_recnum]
                PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
                
                ;check for eligible PNR node
                if (PNR_Code=@Mode70_EligiblePNR@ & STOPS_NODE[PNR_Node]>0 & RailLine_Name[PNR_Node]=Check_RailLine)
                    ;count eligible PNRs
                    cnt_EligiblePNR = cnt_EligiblePNR + 1
                    
                    ;calculate distance from TAZ to PNR node
                    xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                    
                    ;lookup AM time and distance skim values based on PNR's TAZID
                    OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                    IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                    OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                    
                    ;calculate total time = in-vehicle time + out-of-vehicle time
                    TotalTime   = IVT ;+ OVT
                    
                    ;check for zero values
                    if (IVT=0 | OverNetDist=0)
                        TotalTime   = 9999
                        OverNetDist = 999
                    endif
                        
                    ;assign initial array element
                    Closest_PNR[PNR_recnum]    = PNR_Node
                    Closest_Time[PNR_recnum]   = TotalTime
                    Closest_Dist[PNR_recnum]   = OverNetDist
                    Closest_XYDist[PNR_recnum] = xydist
                    
                endif  ;check for eligble PNR node
                
            ENDLOOP  ;populate closest PNR arrays
            
            ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
            SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
            
            ;print drive access links
            LOOP Conct_num=1,@Mode70_NumCon@
                ;assign closest nth eligible PNR node and calculate avg over the network speed
                PNR_Node = Closest_PNR[Conct_num]
                PNR_Time = Closest_Time[Conct_num]
                PNR_Dist = Closest_Dist[Conct_num]
                
                OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
                ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
                if (print_dummy_70=0)
                    PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=70,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                    print_dummy_70=1
                endif
                
                
                ;print drive access links if less than MaxTime
                if (County=35)
                    ;use SL county MaxTime
                    if (PNR_Time<=@Mode70_MaxTime_SL@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=70,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                    
                elseif (County=49)
                    ;use UT county MaxTime
                    if (PNR_Time<=@Mode70_MaxTime_UT@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=70,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                    
                else
                    ;use general MaxTime
                    if (PNR_Time<=@Mode70_MaxTime@ && PNR_Node<>@PNR_notfor_DAWE@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=70,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                endif  ;print drive access links if less than MaxTime
                
            ENDLOOP  ;print drive access links
        
        ENDLOOP ;loop through unique rail lines
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;CREATE CRT DRIVE ACCESS LINKS ============================================================================================================

;calculate MODE80 drive access links
RUN PGM=MATRIX  MSG='Mode Choice 4: calculate commuter rail (mode 80) drive access links'
    FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_PNR_nodes.dbf',  AUTOARRAY=ALLFIELDS
    FILEI DBI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_HwyNodes.dbf',   AUTOARRAY=ALLFIELDS
    FILEI DBI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\c_StopsMode8.dbf', AUTOARRAY=ALLFIELDS
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_Pk.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\NTL\auto_generated_drive_links_Mode80.NTL'
    
    
    ;parameters
    ZONES = 1
    
    
    PRINT PRINTO=1, LIST=';;<<PT>>;; \n'
    
    
    ;define numeric arrays
    ARRAY STOPS_NODE     = 99999,
          
          Closest_PNR    = 1000,
          Closest_Time   = 1000,
          Closest_Dist   = 1000,
          Closest_XYDist = 1000
    
    ;define character arrays
    ARRAY TYPE=C55, RailLine_Name  = 99999,
          TYPE=C55, UniqueRailLine = 500
    
    
    ;assign stop node array based on node number as index (reduce need to loop in script)
    ;and identify number of unique rail lines
    LOOP recnum=1,DBI.3.NUMRECORDS
        idx                = DBA.3.N[recnum]
        STOPS_NODE[idx]    = recnum
        RailLine_Name[idx] = DBA.3.ROUTE[recnum]
        
        ;identify unique rail lines
        Unique_Name = DBA.3.ROUTE[recnum]
        inlist      = 0
        
        if (recnum=1)
            cnt_UniqueRail    = 1
            UniqueRailLine[1] = Unique_Name
            
            ;print unique lines to check file
            PRINT CSV=T, FORM=8.0, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_unique_Lines_Mode8.csv',
                LIST=cnt_UniqueRail, UniqueRailLine[1]
            
        else
            LOOP chk_unq=1,cnt_UniqueRail
                if (Unique_Name=UniqueRailLine[chk_unq])
                    ;route name already in list
                    inlist = 1
                    BREAK
                endif
            ENDLOOP
            
            ;add unique rail iine to array
            if (inlist<>1)
                cnt_UniqueRail                 = cnt_UniqueRail + 1
                UniqueRailLine[cnt_UniqueRail] = Unique_Name
            
                ;print unique lines to check file
                PRINT CSV=T, FORM=8.0, FILE='@ParentDir@@ScenarioDir@Temp\4_ModeChoice\_check_unique_Lines_Mode8.csv',
                    LIST=cnt_UniqueRail, UniqueRailLine[cnt_UniqueRail]
            endif
        endif
    ENDLOOP
    
    
    ;calculate drive access links
    ;loop through TAZ
    LOOP TAZ_Node=1,@Usedzones@
        procrec = ROUND(TAZ_Node / @UsedZones@ * 100)
        PRINT PRINTO=0 LIST='Process Completed: ', procrec(4.0), '%'
        
        TAZ_X  = DBA.2.X[TAZ_Node]
        TAZ_Y  = DBA.2.Y[TAZ_Node]
        County = DBA.2.CO_FIPS[TAZ_Node]
        
        ;loop through unique rail lines
        LOOP lp_Rail=1,cnt_UniqueRail
            ;assign name of unique rail line for this loop iteration
            Check_RailLine = UniqueRailLine[lp_Rail]
            
            ;initialize PNR variables
            cnt_EligiblePNR = 0
            SET VAL=9999, VARS=Closest_Time    ;sets all elements in array to 9999 so 0 values in array are sorted to back in the array
            
            ;populate closest PNR arrays
            LOOP PNR_recnum=1,DBI.1.NUMRECORDS
                ;assign PNR variables
                PNR_Node   = DBA.1.N[PNR_recnum]
                PNR_X      = DBA.1.X[PNR_recnum]
                PNR_Y      = DBA.1.Y[PNR_recnum]
                PNR_Code   = DBA.1.PNR[PNR_recnum]
                PNR_TAZID  = DBA.1.TAZID[PNR_recnum]
                
                ;check for eligible PNR node
                if (PNR_Code=@Mode80_EligiblePNR@ & STOPS_NODE[PNR_Node]>0 & RailLine_Name[PNR_Node]=Check_RailLine)
                    ;count eligible PNRs
                    cnt_EligiblePNR = cnt_EligiblePNR + 1
                    
                    ;calculate distance from TAZ to PNR node
                    xydist = SQRT( (TAZ_X-PNR_X)^2 + (TAZ_Y-PNR_Y)^2 ) / 1609.344    ;convert meters to miles
                    
                    ;lookup AM time and distance skim values based on PNR's TAZID
                    OverNetDist = MATVAL(1, 11, TAZ_Node, PNR_TAZID, 0)   ;MATVAL(file#, matrix#, I, J, ReturnCode if error)
                    IVT         = MATVAL(1, 5,  TAZ_Node, PNR_TAZID, 0)
                    OVT         = MATVAL(1, 1,  TAZ_Node, PNR_TAZID, 0)
                    
                    ;calculate total time = in-vehicle time + out-of-vehicle time
                    TotalTime   = IVT ;+ OVT
                    
                    ;check for zero values
                    if (IVT=0 | OverNetDist=0)
                        TotalTime   = 9999
                        OverNetDist = 999
                    endif
                        
                    ;assign initial array element
                    Closest_PNR[PNR_recnum]    = PNR_Node
                    Closest_Time[PNR_recnum]   = TotalTime
                    Closest_Dist[PNR_recnum]   = OverNetDist
                    Closest_XYDist[PNR_recnum] = xydist
                    
                endif  ;check for eligble PNR node
                
            ENDLOOP  ;populate closest PNR arrays
            
            ;sort ascending based on shortest time, then shortest over-net distance, then shortest xy distance, then PNR node number
            SORT ARRAY='+Closest_Time','+Closest_Dist','+Closest_XYDist','+Closest_PNR'
            
            ;print drive access links
            LOOP Conct_num=1,@Mode80_NumCon@
                ;assign closest nth eligible PNR node and calculate avg over the network speed
                PNR_Node = Closest_PNR[Conct_num]
                PNR_Time = Closest_Time[Conct_num]
                PNR_Dist = Closest_Dist[Conct_num]
                
                OverNetSpeed = 60 * PNR_Dist / PNR_Time      ;in mph
            
            
                ;add dummy link in case no transit mode in scenario (need at least 1 to keep from crashing)
                if (print_dummy_80=0)
                    PRINT PRINTO=1, LIST='NT LEG=1-1,  MODE=80,  COST=2.40,  DIST=1.00,  ONEWAY=F,  SPEED=25.0'
                    print_dummy_80=1
                endif
                
                
                ;print drive access links if less than MaxTime
                if (County=35)
                    ;use SL county MaxTime
                    if (PNR_Time<=@Mode80_MaxTime_SL@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=80,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                    
                elseif (County=49)
                    ;use UT county MaxTime
                    if (PNR_Time<=@Mode80_MaxTime_UT@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=80,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                    
                else
                    ;use general MaxTime
                    if (PNR_Time<=@Mode80_MaxTime@)
                        ;print out link as NT leg
                        PRINT PRINTO=1, 
                            LIST='NT LEG=', TAZ_Node(6.0),' -', PNR_Node(6.0), ',  MODE=80,  COST=', PNR_Time(6.2), ',  DIST=', PNR_Dist(6.2), ',  ONEWAY=T,  SPEED=', OverNetSpeed(6.2)
                    endif
                endif  ;print drive access links if less than MaxTime
                
            ENDLOOP  ;print drive access links
        
        ENDLOOP ;loop through unique rail lines
        
    ENDLOOP  ;loop through TAZ
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Create Drive Access Links          ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 04_Create_drive_access_links.txt)               
