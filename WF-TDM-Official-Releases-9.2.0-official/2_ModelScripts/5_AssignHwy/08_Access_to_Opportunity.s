
;print file to help identify error if model crashes
*(ECHO model crashed > 08_Access_to_Opportunity.txt)


;get start time
ScriptStartTime = currenttime()


RUN PGM=MATRIX MSG='Post Processing: Calculate Access to Opportunity - @RID@'
FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'
FILEI ZDATI[2] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@', 
    Z=TAZID
FILEI ZDATI[3] = '@ParentDir@@ScenarioDir@0_InputProcessing\Urbanization.dbf'

FILEI DBI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\ScenarioNet\@RID@ - Node.dbf',
    AUTOARRAY=ALLFIELDS,
    SORT=N

FILEI MATI[01] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_AM.mtx'
FILEI MATI[02] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_PM.mtx'
FILEI MATI[03] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\Skm_FF.mtx'

FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_Pk.mtx'
FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_Pk.mtx'
FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_Pk.mtx'
FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_Pk.mtx'
FILEI MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_Pk.mtx'
FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_Pk.mtx'

FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d4_Pk.mtx'
FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d5_Pk.mtx'
FILEI MATI[12] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d6_Pk.mtx'
FILEI MATI[13] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d7_Pk.mtx'
FILEI MATI[14] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d8_Pk.mtx'
FILEI MATI[15] = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_d9_Pk.mtx'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\7_ATO\ATO_Weight.csv'


FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Access_to_Opportunity.csv'
    
    
    ;=========================================================================================================
    ;define script parameters --------------------------------------------------------------------------------
    ZONES   =  @Usedzones@
    ZONEMSG = 10
    
    
    ;define ATO decay weight lookup
    LOOKUP LOOKUPI=1, 
        INTERPOLATE=T,
        NAME=ATO_Weight,
        LOOKUP[1]=1, RESULT=2,     ;auto
        LOOKUP[2]=1, RESULT=3,     ;w_transit
        LOOKUP[3]=1, RESULT=4,     ;d_transit
        LOOKUP[4]=1, RESULT=5,     ;bike
        LOOKUP[5]=1, RESULT=6      ;walk
    
    
    ;define arrays
    ARRAY Node_X = @UsedZones@,
          Node_Y = @UsedZones@
    
    
    ;print status to console ---------------------------------------------------------------------------------    
    ;print status to task monitor window
    PrintProgress = INT(i / @UsedZones@ * 100)
    PrintProgInc = 1
    
    if (i=1)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = PrintProgInc
    elseif (PrintProgress=CheckProgress)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = CheckProgress + PrintProgInc
    endif
    
    
    ;=========================================================================================================
    ;calculate total SE & populate arrays --------------------------------------------------------------------
    if (i=1)
        
        ;calculate total HH & jobs -------------------------------------------------------
        JLOOP
            
            Sum_HH  = Sum_HH  + zi.1.TOTHH[j]
            Sum_Job = Sum_Job + zi.1.TOTEMP[j]
            
        ENDJLOOP
        
        
        ;populate Node XY coord arrays ---------------------------------------------------
        LOOP numrec=1, dbi.1.NUMRECORDS
            
            NodeNum = dba.1.N[numrec]
            
            if (NodeNum=1-@UsedZones@)  Node_X[NodeNum] = dba.1.X[numrec]
            if (NodeNum=1-@UsedZones@)  Node_Y[NodeNum] = dba.1.Y[numrec]
            
            if (NodeNum=@UsedZones@)  BREAK
            
        ENDLOOP  ;numrec=1, dbi.1.NUMRECORDS
        
    endif  ;(i=1)
    
    
    ;=========================================================================================================
    ;calculate for interal TAZ (skip dummy & external)
    if (!(i=@dummyzones@, @externalzones@))
        
        ;calculate auto travel time/distance -----------------------------------------------------------------
        ;  note: auto ATO calculations use general purpose (GP) path not managed or toll path
        ;        calculations assume travel in both directions from the point of view of the current TAZ by
        ;            taking the average of the forward & reverse directions
        
        ;congested travel time -----------------------------------------------------------
        ;  note: AM used for forward direction & transpose of PM used for reverse direction to represent
        ;            composite 'peak' travel times
        ;in-vehicle time (IVT)
        mw[111] = (mi.1.GP_IVT + mi.2.GP_IVT.T) / 2
        
        ;out-of-vehicle time (OVT)
        mw[112] = (mi.1.OVT + mi.2.OVT.T) / 2
        
        ;total travel time (IVT + OVT)
        mw[110] = mw[111] +     ;IVT
                  mw[112]       ;OVT
        
        
        ;free flow travel time -----------------------------------------------------------
        ;  note: forward and reverse directions should be the same in most cased but average to account
        ;            for possible directional inconsistencies
        ;in-vehicle time (IVT)
        mw[121] = (mi.3.GP_IVT + mi.3.GP_IVT.T) / 2
        
        ;out-of-vehicle time (OVT)
        mw[122] = (mi.3.OVT + mi.3.OVT.T) / 2
        
        ;total travel time (IVT + OVT)
        mw[120] = mw[121] +     ;IVT
                  mw[122]       ;OVT
        
        
        ;free flow distance --------------------------------------------------------------
        ;  note: distance is traced from the shortest free flow time path not shortest distance path
        mw[123] = (mi.3.GP_Dist + mi.3.GP_Dist.T) / 2
        
        
        ;set total time/distance to 9999 if no path exists (ie no IVT) -------------------
        JLOOP EXCLUDE=@dummyzones@, @externalzones@
            
            if (mw[111]<=0 | mw[111]>=9999)  mw[110] = 9999     ;congested time
            if (mw[121]<=0 | mw[121]>=9999)  mw[120] = 9999     ;free flow time
            
            if (mw[123]<=0 | mw[123]>=9999)  mw[123] = 9999     ;free flow distance
            
        ENDJLOOP
        
        
        ;calculate straight line distance & time -------------------------------------------------------------
        JLOOP EXCLUDE=@dummyzones@, @externalzones@
            
            ;calculate straight line distance (in miles) using TAZ centroids (1 mile = 1609.344 meters)
            ;  note: used to calculate straight line time, as well as bike & walk times
            _diffX = Node_X[i] - Node_X[j]
            _diffY = Node_Y[i] - Node_Y[j]
            
            mw[133] = sqrt(pow(_diffX, 2) + pow(_diffY, 2)) / 1609.344
            
            
            ;calculate running average free flow speed by dividing free flow distance by freel flow time (miles/minute)
            ;  note: used to calculate averge straight line travel time
            ;        calculate only if time & distance path exists (default to 9999)
            AvgSpeed_Auto_FF = 9999
            if (mw[123]<>9999 & mw[120]<>9999)  AvgSpeed_Auto_FF = mw[123] / mw[120]
            
            
            ;straight line trave time = straight line distance (miles) / avg running free flow speed (miles/minute)
            ;  note: avg running free flow speed calculated above is based on total travel time & already includes OVT
            mw[130] = 9999
            if (AvgSpeed_Auto_FF>0 & AvgSpeed_Auto_FF<9999)  mw[130] = mw[133] / AvgSpeed_Auto_FF
            
        ENDJLOOP
        
        
        ;calculate bike & walk travel time -------------------------------------------------------------------
        JLOOP EXCLUDE=@dummyzones@, @externalzones@
            
            ;bike & walk travel time = straight line distance (miles) / bike/walk speed (mph) * 60 (min/hr)
            ;        calculate only if time & distance path exists (default to 9999)
            mw[140] = 9999
            mw[150] = 9999
            
            if (mw[133]<>9999)  mw[140] = mw[133] / @bikespeed@ * 60     ;bike
            if (mw[133]<>9999)  mw[150] = mw[133] / @walkspeed@ * 60     ;walk
            
        ENDJLOOP
        
        
        ;calculate transit travel time -----------------------------------------------------------------------
        ;  note: transit ATO uses peak transit service not off-peak
        
        ;walk access - peak --------------------------------------------------------------
        ;calculate IVT
        mw[211] = mi.04.T456789    ;w4_Pk
        mw[212] = mi.05.T456789    ;w5_Pk
        mw[213] = mi.06.T456789    ;w6_Pk
        mw[214] = mi.07.T456789    ;w7_Pk
        mw[215] = mi.08.T456789    ;w8_Pk
        mw[216] = mi.09.T456789    ;w9_Pk
        
        ;calculate total time (IVT + OVT)
        ;  note drive access time for walk skims should be 0
        mw[201] = mw[211] + mi.04.INITWAIT + mi.04.XFERWAIT + mi.04.WALKTIME + mi.04.DRIVETIME    ;w4_Pk
        mw[202] = mw[212] + mi.05.INITWAIT + mi.05.XFERWAIT + mi.05.WALKTIME + mi.05.DRIVETIME    ;w5_Pk
        mw[203] = mw[213] + mi.06.INITWAIT + mi.06.XFERWAIT + mi.06.WALKTIME + mi.06.DRIVETIME    ;w6_Pk
        mw[204] = mw[214] + mi.07.INITWAIT + mi.07.XFERWAIT + mi.07.WALKTIME + mi.07.DRIVETIME    ;w7_Pk
        mw[205] = mw[215] + mi.08.INITWAIT + mi.08.XFERWAIT + mi.08.WALKTIME + mi.08.DRIVETIME    ;w8_Pk
        mw[206] = mw[216] + mi.09.INITWAIT + mi.09.XFERWAIT + mi.09.WALKTIME + mi.09.DRIVETIME    ;w9_Pk
        
        
        ;drive access - peak -------------------------------------------------------------
        ;calculate in-vehicle time
        mw[261] = mi.10.T456789    ;d4_Pk
        mw[262] = mi.11.T456789    ;d5_Pk
        mw[263] = mi.12.T456789    ;d6_Pk
        mw[264] = mi.13.T456789    ;d7_Pk
        mw[265] = mi.14.T456789    ;d8_Pk
        mw[266] = mi.15.T456789    ;d9_Pk
        
        ;calculate total time (IVT + OVT)
        mw[251] = mw[261] + mi.10.INITWAIT + mi.10.XFERWAIT + mi.10.WALKTIME + mi.10.DRIVETIME    ;d4_Pk
        mw[252] = mw[262] + mi.11.INITWAIT + mi.11.XFERWAIT + mi.11.WALKTIME + mi.11.DRIVETIME    ;d5_Pk
        mw[253] = mw[263] + mi.12.INITWAIT + mi.12.XFERWAIT + mi.12.WALKTIME + mi.12.DRIVETIME    ;d6_Pk
        mw[254] = mw[264] + mi.13.INITWAIT + mi.13.XFERWAIT + mi.13.WALKTIME + mi.13.DRIVETIME    ;d7_Pk
        mw[255] = mw[265] + mi.14.INITWAIT + mi.14.XFERWAIT + mi.14.WALKTIME + mi.14.DRIVETIME    ;d8_Pk
        mw[256] = mw[266] + mi.15.INITWAIT + mi.15.XFERWAIT + mi.15.WALKTIME + mi.15.DRIVETIME    ;d9_Pk
        
        
        ;find best transit path ----------------------------------------------------------
        ;set total time to 9999 if no path exists (no IVT)
        JLOOP EXCLUDE=@dummyzones@, @externalzones@
            
            ;walk to transit
            if (mw[211]<=0 | mw[211]>=9999)  mw[201] = 9999    ;w4_Pk
            if (mw[212]<=0 | mw[212]>=9999)  mw[202] = 9999    ;w5_Pk
            if (mw[213]<=0 | mw[213]>=9999)  mw[203] = 9999    ;w6_Pk
            if (mw[214]<=0 | mw[214]>=9999)  mw[204] = 9999    ;w7_Pk
            if (mw[215]<=0 | mw[215]>=9999)  mw[205] = 9999    ;w8_Pk
            if (mw[216]<=0 | mw[216]>=9999)  mw[206] = 9999    ;w9_Pk
            
            ;drive to transit
            if (mw[261]<=0 | mw[261]>=9999)  mw[251] = 9999    ;d4_Pk
            if (mw[262]<=0 | mw[262]>=9999)  mw[252] = 9999    ;d5_Pk
            if (mw[263]<=0 | mw[263]>=9999)  mw[253] = 9999    ;d6_Pk
            if (mw[264]<=0 | mw[264]>=9999)  mw[254] = 9999    ;d7_Pk
            if (mw[265]<=0 | mw[265]>=9999)  mw[255] = 9999    ;d8_Pk
            if (mw[266]<=0 | mw[266]>=9999)  mw[256] = 9999    ;d9_Pk
            
            
            ;calculate minimum transit path
            ;walk to transt
            mw[200] = MIN(mw[201],     ;w4_Pk
                          mw[202],     ;w5_Pk
                          mw[203],     ;w6_Pk
                          mw[204],     ;w7_Pk
                          mw[205],     ;w8_Pk
                          mw[206])     ;w9_Pk
            
            ;walk to transt
            mw[250] = MIN(mw[251],     ;d4_Pk
                          mw[252],     ;d5_Pk
                          mw[253],     ;d6_Pk
                          mw[254],     ;d7_Pk
                          mw[255],     ;d8_Pk
                          mw[256])     ;d9_Pk
            
        ENDJLOOP
        
        
        ;=====================================================================================================
        ;calcualte ATO ---------------------------------------------------------------------------------------
        
        ;reset ATO calculation to 0 for each i zone
        ATO_Job_byAuto    = 0
        ATO_Job_byAuto_FF = 0
        ATO_Job_byAuto_SL = 0
        ATO_Job_byTran_wk = 0
        ATO_Job_byTran_dr = 0
        ATO_Job_byBike    = 0
        ATO_Job_byWalk    = 0
        
        ATO_HH_byAuto     = 0
        ATO_HH_byAuto_FF  = 0
        ATO_HH_byAuto_SL  = 0
        ATO_HH_byTran_wk  = 0
        ATO_HH_byTran_dr  = 0
        ATO_HH_byBike     = 0
        ATO_HH_byWalk     = 0
        
        
        ;loop through columns
        JLOOP EXCLUDE=@dummyzones@, @externalzones@
            
            ;assign variables --------------------------------------------------------------------------------
            ;SE at j zone
            HH_j  = zi.1.TOTHH[j]
            Job_j = zi.1.TOTEMP[j]
            
            
            ;travel times
            Time_Auto       = mw[110]
            Time_Auto_FF    = mw[120]
            Time_Auto_SL    = mw[130]
            Time_bike       = mw[140]
            Time_walk       = mw[150]
            Time_Tran_walk  = mw[200]
            Time_Tran_drive = mw[250]
            
            
            ;calculate weights from decay function -----------------------------------------------------------
            ATO_Weight_Auto    = ATO_Weight(1, Time_Auto   )         ;auto - congested travel time
            ATO_Weight_Auto_FF = ATO_Weight(1, Time_Auto_FF)         ;auto - free flow travel time
            ATO_Weight_Auto_SL = ATO_Weight(1, Time_Auto_SL)         ;auto - straight-line travel time
            ATO_Weight_tran_w  = ATO_Weight(2, Time_Tran_walk)       ;transit - walk access
            ATO_Weight_tran_d  = ATO_Weight(3, Time_Tran_drive)      ;transit - drive access
            ATO_Weight_bike    = ATO_Weight(4, Time_bike)            ;bike
            ATO_Weight_walk    = ATO_Weight(5, Time_walk)            ;walk
            
            
            ;calculate access to opportunity (ATO) -----------------------------------------------------------
            ;jobs
            ATO_Job_byAuto    = ATO_Job_byAuto     +  ATO_Weight_Auto    * Job_j
            ATO_Job_byAuto_FF = ATO_Job_byAuto_FF  +  ATO_Weight_Auto_FF * Job_j
            ATO_Job_byAuto_SL = ATO_Job_byAuto_SL  +  ATO_Weight_Auto_SL * Job_j
            ATO_Job_byTran_wk = ATO_Job_byTran_wk  +  ATO_Weight_tran_w  * Job_j
            ATO_Job_byTran_dr = ATO_Job_byTran_dr  +  ATO_Weight_tran_d  * Job_j
            ATO_Job_byBike    = ATO_Job_byBike     +  ATO_Weight_bike    * Job_j
            ATO_Job_byWalk    = ATO_Job_byWalk     +  ATO_Weight_walk    * Job_j
            
            ;households
            ATO_HH_byAuto     = ATO_HH_byAuto      +  ATO_Weight_Auto    * HH_j
            ATO_HH_byAuto_FF  = ATO_HH_byAuto_FF   +  ATO_Weight_Auto_FF * HH_j
            ATO_HH_byAuto_SL  = ATO_HH_byAuto_SL   +  ATO_Weight_Auto_SL * HH_j
            ATO_HH_byTran_wk  = ATO_HH_byTran_wk   +  ATO_Weight_tran_w  * HH_j
            ATO_HH_byTran_dr  = ATO_HH_byTran_dr   +  ATO_Weight_tran_d  * HH_j
            ATO_HH_byBike     = ATO_HH_byBike      +  ATO_Weight_bike    * HH_j
            ATO_HH_byWalk     = ATO_HH_byWalk      +  ATO_Weight_walk    * HH_j
            
        ENDJLOOP  ;EXCLUDE=@dummyzones@, @externalzones@
        
        
        ;finish transit ATO calculation --------------------------------------------------
        ATO_Job_byTran = MAX(ATO_Job_byTran_wk, ATO_Job_byTran_dr)
        ATO_HH_byTran  = MAX(ATO_HH_byTran_wk , ATO_HH_byTran_dr )
       
        
        ;=====================================================================================================
        ;calculate actual (realized) ATO
        
        ;SE at i zone
        HH_i  = zi.1.TOTHH[i]
        Job_i = zi.1.TOTEMP[i]
        
        
        ;weight access to opportunity by SE in zone
        ;  note: this is the amount of HH or jobs that benefit from the access to opportunity (actual or realized vs potential)
        ;jobs
        act_ATO_Job_byAuto    = ATO_Job_byAuto    * HH_i
        act_ATO_Job_byAuto_FF = ATO_Job_byAuto_FF * HH_i
        act_ATO_Job_byAuto_SL = ATO_Job_byAuto_SL * HH_i
        act_ATO_Job_byTran    = ATO_Job_byTran    * HH_i
        act_ATO_Job_byBike    = ATO_Job_byBike    * HH_i
        act_ATO_Job_byWalk    = ATO_Job_byWalk    * HH_i
        
        ;households
        act_ATO_HH_byAuto     = ATO_HH_byAuto     * Job_i
        act_ATO_HH_byAuto_FF  = ATO_HH_byAuto_FF  * Job_i
        act_ATO_HH_byAuto_SL  = ATO_HH_byAuto_SL  * Job_i
        act_ATO_HH_byTran     = ATO_HH_byTran     * Job_i
        act_ATO_HH_byBike     = ATO_HH_byBike     * Job_i
        act_ATO_HH_byWalk     = ATO_HH_byWalk     * Job_i
        
        
        ;=====================================================================================================
        ;calculate loss in ATO due to congestion
        Loss_Job_Cong = ATO_Job_byAuto - ATO_Job_byAuto_FF
        Loss_HH_Cong  = ATO_HH_byAuto  - ATO_HH_byAuto_FF 
        
        act_Loss_Job_Cong = act_ATO_Job_byAuto - act_ATO_Job_byAuto_FF
        act_Loss_HH_Cong  = act_ATO_HH_byAuto  - act_ATO_HH_byAuto_FF 
        
        
        ;calculate loss in ATO due to circuity
        ;  note: this measure inefficiences in network relative to straight line distance
        Loss_Job_Net = ATO_Job_byAuto_FF - ATO_Job_byAuto_SL
        Loss_HH_Net  = ATO_HH_byAuto_FF  - ATO_HH_byAuto_SL 
        
        act_Loss_Job_Net = act_ATO_Job_byAuto_FF - act_ATO_Job_byAuto_SL
        act_Loss_HH_Net  = act_ATO_HH_byAuto_FF  - act_ATO_HH_byAuto_SL 
        
        
        ;calculate total loss (Cong + Net)
        Loss_Job_Abs = Loss_Job_Cong + Loss_Job_Net
        Loss_HH_Abs  = Loss_HH_Cong  + Loss_HH_Net
        
        act_Loss_Job_Abs = act_Loss_Job_Cong + act_Loss_Job_Net
        act_Loss_HH_Abs  = act_Loss_HH_Cong  + act_Loss_HH_Net
        
        
        ;=====================================================================================================
        ;print ATO file --------------------------------------------------------------------------------------
        ;print header for output file
        if (zi.3.DEVACRES>0)
            if (print_header=0)
                
                print_header=1
                
                PRINT PRINTO=1,
                    CSV=T,
                    FORM=10.0,
                    LIST='TAZID'             ,
                         'CO_TAZID'          ,
                         'DevAcres'          ,
                         'HH'                ,
                         'Job'               ,
                         
                         'Job_byAuto'        ,
                         'Job_byTran'        ,
                         'Job_byBike'        ,
                         'Job_byWalk'        ,
                         'act_Job_byAuto'    ,
                         'act_Job_byTran'    ,
                         'act_Job_byBike'    ,
                         'act_Job_byWalk'    ,
                         'Loss_Job_Cong'     ,
                         'Loss_Job_Net'      ,
                         'Loss_Job_Abs'      ,
                         'act_Loss_Job_Cong' ,
                         'act_Loss_Job_Net'  ,
                         'act_Loss_Job_Abs'  ,
                         
                         'HH_byAuto'         ,
                         'HH_byTran'         ,
                         'HH_byBike'         ,
                         'HH_byWalk'         ,
                         'act_HH_byAuto'     ,
                         'act_HH_byTran'     ,
                         'act_HH_byBike'     ,
                         'act_HH_byWalk'     ,
                         'Loss_HH_Cong'      ,
                         'Loss_HH_Net'       ,
                         'Loss_HH_Abs'       ,
                         'act_Loss_HH_Cong'  ,
                         'act_Loss_HH_Net'   ,
                         'act_Loss_HH_Abs'   ,
                         
                         'tmp_Job_byTran_wk' ,
                         'tmp_Job_byTran_dr' ,
                         'tmp_HH_byTran_wk'  ,
                         'tmp_HH_byTran_dr'  ,
                         
                         'tmp_Job_byAuto_FF' ,
                         'tmp_Job_byAuto_SL' ,
                         'tmp_HH_byAuto_FF'  ,
                         'tmp_HH_byAuto_SL'  
                         
            endif  ;print_header=0
            
            
            ;print output for current zone in i loop
            PRINT PRINTO=1,
                CSV=T,
                FORM=10.0,
                LIST=i                        ,
                     zi.2.CO_TAZID[i]         ,
                     zi.2.DEVACRES[i](10.6)   ,
                     zi.1.TOTHH[i](10.1)      ,
                     zi.1.TOTEMP[i](10.1)     ,
                     
                     ROUND(ATO_Job_byAuto    ),
                     ROUND(ATO_Job_byTran    ),
                     ROUND(ATO_Job_byBike    ),
                     ROUND(ATO_Job_byWalk    ),
                     ROUND(act_ATO_Job_byAuto),
                     ROUND(act_ATO_Job_byTran),
                     ROUND(act_ATO_Job_byBike),
                     ROUND(act_ATO_Job_byWalk),
                     ROUND(Loss_Job_Cong     ),
                     ROUND(Loss_Job_Net      ),
                     ROUND(Loss_Job_Abs      ),
                     ROUND(act_Loss_Job_Cong ),
                     ROUND(act_Loss_Job_Net  ),
                     ROUND(act_Loss_Job_Abs  ),
                     
                     ROUND(ATO_HH_byAuto     ),
                     ROUND(ATO_HH_byTran     ),
                     ROUND(ATO_HH_byBike     ),
                     ROUND(ATO_HH_byWalk     ),
                     ROUND(act_ATO_HH_byAuto ),
                     ROUND(act_ATO_HH_byTran ),
                     ROUND(act_ATO_HH_byBike ),
                     ROUND(act_ATO_HH_byWalk ),
                     ROUND(Loss_HH_Cong      ),
                     ROUND(Loss_HH_Net       ),
                     ROUND(Loss_HH_Abs       ),
                     ROUND(act_Loss_HH_Cong  ),
                     ROUND(act_Loss_HH_Net   ),
                     ROUND(act_Loss_HH_Abs   ),
                     
                     ROUND(ATO_Job_byTran_wk ),
                     ROUND(ATO_Job_byTran_dr ),
                     ROUND(ATO_HH_byTran_wk  ),
                     ROUND(ATO_HH_byTran_dr  ),
                     
                     ROUND(ATO_Job_byAuto_FF ),
                     ROUND(ATO_Job_byAuto_SL ),
                     ROUND(ATO_HH_byAuto_FF  ),
                     ROUND(ATO_HH_byAuto_SL  )
                     
        endif ;(zi.3.DEVACRES>0)
        
    endif  ;(!(i=@dummyzones@, @externalzones@))
    
ENDRUN


;create ato input file for additional ato calcs ---------------------------------
RUN PGM=MATRIX MSG='Calculate additional ATO metrics via python'

FILEO PRINTO = '@ParentDir@@ScenarioDir@_Log\py_Variables - as_AccessToOpportunityVars.txt'
     
     
    ;set parameters
    ZONES = 1
    
    
    ;create control input file for this Python script
    PRINT PRINTO=1,
        LIST='# ------------------------------------------------------------------------------',
             '\n# Python input file variables and paths',
             '\n# ------------------------------------------------------------------------------',
             '\n',
             '\n# global parameters ------------------------------------------------------------',
             '\nParentDir         = r"@ParentDir@\"',     ;note: \ added to prevent python from crashing
             '\nScenarioDir       = r"@ScenarioDir@\"',   ;note: \ added to prevent python from crashing
             '\nRID               = r"@RID@"',
             '\n',
             '\nModelVersion      = "@ModelVersion@"',
             '\nScenarioGroup     = "@ScenarioGroup@"',
             '\nRunYear           =  @RunYear@',
             '\n',
             '\nTAZ_DBF           = r"@TAZ_DBF@"',
             '\nATO_CSV           = r"@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Access_to_Opportunity.csv"',
             '\n'
    
ENDRUN


;run python script -------------------------------------------------------------
;  note: one asterix minimizes the command window, two asterix executes the command window non-minimized
;  note: the 1>&2 echos the command window output from pyton to the one started by Cube
**"@ParentDir@2_ModelScripts\_Python\py-tdm-env\python.exe" "@ParentDir@2_ModelScripts\_Python\as_AccessToOpportunity.py" 1>&2


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
*(rmdir /s /q "__pycache__")
*(rmdir /s /q "@ParentDir@2_ModelScripts\_Python\__pycache__")



if (Run_vizTool=1)
    
    RUN PGM=MATRIX MSG='Run Python Script to Create JSON for vizTool'
    
        ZONES = 1
        
        ;create control input file for this Python script
        PRINT FILE = '@ParentDir@@ScenarioDir@_Log\py_Variables - vt_JsonVars.txt',
            LIST='#Python input file variables and paths',
                 '\njsonId          = "zoneato"',
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
                 '\ninputFile       = r"@ParentDir@@ScenarioDir@5_AssignHwy\4_Summaries\@RID@_Access_to_Opportunity_expanded.csv"',
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
        LIST='\n    Access to Opportunity              ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN


*(DEL 08_Access_to_Opportunity.txt)
