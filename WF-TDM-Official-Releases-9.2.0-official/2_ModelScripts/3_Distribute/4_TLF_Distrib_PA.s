
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 4_TLF_Distrib_PA.txt)



;get start time
ScriptStartTime = currenttime()



;CREATE TLF INDEX (USE CLUSTER) ==============================================================================

;set max index variables
MaxIdx_time = 200
MaxIdx_dist = 200
MaxIdx_cost = 400


RUN PGM=MATRIX  MSG='Distribution 3: Calculate TLF Index - Time'

FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_Time.mtx'

FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Time.mtx',
    mo=101-118,
    name=Idx_HBW     ,
         Idx_HBShp   ,
         Idx_HBOth   ,
         Idx_HBSch_Pr,
         Idx_HBSch_Sc,
         Idx_NHBW    ,
         Idx_NHBNW   ,
         Idx_LT      ,
         Idx_MD      ,
         Idx_HV      ,
         Idx_IX      ,
         Idx_IX_LT   ,
         Idx_IX_MD   ,
         Idx_IX_HV   ,
         Idx_XI      ,
         Idx_XI_LT   ,
         Idx_XI_MD   ,
         Idx_XI_HV   
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
    
    
    
    ;print status to task monitor window
    PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
    PrintProgInc = 1
    
    if (i=FIRSTZONE)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = PrintProgInc
    elseif (PrintProgress=CheckProgress)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = CheckProgress + PrintProgInc
    endif  ;PrintProgress=CheckProgressress
    
    
    
    ;set script specific parameters
    MaxIdx = @MaxIdx_time@
    
    
    
    ;assign time/dist/gencost skims
    mw[201] = mi.1.HBW       ;HBW
    mw[202] = mi.1.HBShp     ;HBShp
    mw[203] = mi.1.HBOth     ;HBOth
    mw[204] = mi.1.HBS       ;HBSch_Pr
    mw[205] = mi.1.HBS       ;HBSch_Sc
    mw[206] = mi.1.NHBW      ;NHBW
    mw[207] = mi.1.NHBNW     ;NHBNW
    mw[208] = mi.1.LT        ;LT
    mw[209] = mi.1.MD        ;MD
    mw[210] = mi.1.HV        ;HV
    mw[211] = mi.1.Ext       ;IX
    mw[212] = mi.1.LT        ;IX_LT
    mw[213] = mi.1.MD        ;IX_MD
    mw[214] = mi.1.HV        ;IX_HV
    mw[215] = mi.1.Ext       ;XI
    mw[216] = mi.1.LT        ;XI_LT
    mw[217] = mi.1.MD        ;XI_MD
    mw[218] = mi.1.HV        ;XI_HV
    
    
    
    ;create TLF index
    ; 1) intergerize the weighted average daily time/dist/gencost
    ; 2) cap at max time or distance
    ; 3) add 1 to avoid a zero index in the arrays
    mw[101] = MIN(INT(mw[201]), MaxIdx) + 1     ;HBW
    mw[102] = MIN(INT(mw[202]), MaxIdx) + 1     ;HBShp
    mw[103] = MIN(INT(mw[203]), MaxIdx) + 1     ;HBOth
    mw[104] = MIN(INT(mw[204]), MaxIdx) + 1     ;HBSch_Pr
    mw[105] = MIN(INT(mw[205]), MaxIdx) + 1     ;HBSch_Sc
    mw[106] = MIN(INT(mw[206]), MaxIdx) + 1     ;NHBW
    mw[107] = MIN(INT(mw[207]), MaxIdx) + 1     ;NHBNW
    mw[108] = MIN(INT(mw[208]), MaxIdx) + 1     ;LT
    mw[109] = MIN(INT(mw[209]), MaxIdx) + 1     ;MD
    mw[110] = MIN(INT(mw[210]), MaxIdx) + 1     ;HV
    mw[111] = MIN(INT(mw[211]), MaxIdx) + 1     ;IX
    mw[112] = MIN(INT(mw[212]), MaxIdx) + 1     ;IX_LT
    mw[113] = MIN(INT(mw[213]), MaxIdx) + 1     ;IX_MD
    mw[114] = MIN(INT(mw[214]), MaxIdx) + 1     ;IX_HV
    mw[115] = MIN(INT(mw[215]), MaxIdx) + 1     ;XI
    mw[116] = MIN(INT(mw[216]), MaxIdx) + 1     ;XI_LT
    mw[117] = MIN(INT(mw[217]), MaxIdx) + 1     ;XI_MD
    mw[118] = MIN(INT(mw[218]), MaxIdx) + 1     ;XI_HV
    
ENDRUN




RUN PGM=MATRIX  MSG='Distribution 3: Calculate TLF Index - Dist'

FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_Dist.mtx'

FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Dist.mtx',
    mo=101-118,
    name=Idx_HBW     ,
         Idx_HBShp   ,
         Idx_HBOth   ,
         Idx_HBSch_Pr,
         Idx_HBSch_Sc,
         Idx_NHBW    ,
         Idx_NHBNW   ,
         Idx_LT      ,
         Idx_MD      ,
         Idx_HV      ,
         Idx_IX      ,
         Idx_IX_LT   ,
         Idx_IX_MD   ,
         Idx_IX_HV   ,
         Idx_XI      ,
         Idx_XI_LT   ,
         Idx_XI_MD   ,
         Idx_XI_HV   
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
    
    
    
    ;print status to task monitor window
    PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
    PrintProgInc = 1
    
    if (i=FIRSTZONE)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = PrintProgInc
    elseif (PrintProgress=CheckProgress)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = CheckProgress + PrintProgInc
    endif  ;PrintProgress=CheckProgressress
    
    
    
    ;set script specific parameters
    MaxIdx = @MaxIdx_dist@
    
    
    
    ;assign time/dist/gencost skims
    mw[201] = mi.1.HBW       ;HBW
    mw[202] = mi.1.HBShp     ;HBShp
    mw[203] = mi.1.HBOth     ;HBOth
    mw[204] = mi.1.HBS       ;HBSch_Pr
    mw[205] = mi.1.HBS       ;HBSch_Sc
    mw[206] = mi.1.NHBW      ;NHBW
    mw[207] = mi.1.NHBNW     ;NHBNW
    mw[208] = mi.1.LT        ;LT
    mw[209] = mi.1.MD        ;MD
    mw[210] = mi.1.HV        ;HV
    mw[211] = mi.1.Ext       ;IX
    mw[212] = mi.1.LT        ;IX_LT
    mw[213] = mi.1.MD        ;IX_MD
    mw[214] = mi.1.HV        ;IX_HV
    mw[215] = mi.1.Ext       ;XI
    mw[216] = mi.1.LT        ;XI_LT
    mw[217] = mi.1.MD        ;XI_MD
    mw[218] = mi.1.HV        ;XI_HV
    
    
    
    ;create TLF index
    ; 1) intergerize the weighted average daily time/dist/gencost
    ; 2) cap at max time or distance
    ; 3) add 1 to avoid a zero index in the arrays
    mw[101] = MIN(INT(mw[201]), MaxIdx) + 1     ;HBW
    mw[102] = MIN(INT(mw[202]), MaxIdx) + 1     ;HBShp
    mw[103] = MIN(INT(mw[203]), MaxIdx) + 1     ;HBOth
    mw[104] = MIN(INT(mw[204]), MaxIdx) + 1     ;HBSch_Pr
    mw[105] = MIN(INT(mw[205]), MaxIdx) + 1     ;HBSch_Sc
    mw[106] = MIN(INT(mw[206]), MaxIdx) + 1     ;NHBW
    mw[107] = MIN(INT(mw[207]), MaxIdx) + 1     ;NHBNW
    mw[108] = MIN(INT(mw[208]), MaxIdx) + 1     ;LT
    mw[109] = MIN(INT(mw[209]), MaxIdx) + 1     ;MD
    mw[110] = MIN(INT(mw[210]), MaxIdx) + 1     ;HV
    mw[111] = MIN(INT(mw[211]), MaxIdx) + 1     ;IX
    mw[112] = MIN(INT(mw[212]), MaxIdx) + 1     ;IX_LT
    mw[113] = MIN(INT(mw[213]), MaxIdx) + 1     ;IX_MD
    mw[114] = MIN(INT(mw[214]), MaxIdx) + 1     ;IX_HV
    mw[115] = MIN(INT(mw[215]), MaxIdx) + 1     ;XI
    mw[116] = MIN(INT(mw[216]), MaxIdx) + 1     ;XI_LT
    mw[117] = MIN(INT(mw[217]), MaxIdx) + 1     ;XI_MD
    mw[118] = MIN(INT(mw[218]), MaxIdx) + 1     ;XI_HV
    
ENDRUN




RUN PGM=MATRIX  MSG='Distribution 3: Calculate TLF Index - Cost'

FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\skm_DY_GC.mtx'

FILEO MATO[1] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Cost.mtx',
    mo=101-118,
    name=Idx_HBW     ,
         Idx_HBShp   ,
         Idx_HBOth   ,
         Idx_HBSch_Pr,
         Idx_HBSch_Sc,
         Idx_NHBW    ,
         Idx_NHBNW   ,
         Idx_LT      ,
         Idx_MD      ,
         Idx_HV      ,
         Idx_IX      ,
         Idx_IX_LT   ,
         Idx_IX_MD   ,
         Idx_IX_HV   ,
         Idx_XI      ,
         Idx_XI_LT   ,
         Idx_XI_MD   ,
         Idx_XI_HV   
    
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
    
    
    
    ;print status to task monitor window
    PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
    PrintProgInc = 1
    
    if (i=FIRSTZONE)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = PrintProgInc
    elseif (PrintProgress=CheckProgress)
        PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
        CheckProgress = CheckProgress + PrintProgInc
    endif  ;PrintProgress=CheckProgressress
    
    
    
    ;set script specific parameters
    MaxIdx = @MaxIdx_cost@
    
    
    
    ;assign time/dist/gencost skims
    mw[201] = mi.1.HBW       ;HBW
    mw[202] = mi.1.HBShp     ;HBShp
    mw[203] = mi.1.HBOth     ;HBOth
    mw[204] = mi.1.HBS       ;HBSch_Pr
    mw[205] = mi.1.HBS       ;HBSch_Sc
    mw[206] = mi.1.NHBW      ;NHBW
    mw[207] = mi.1.NHBNW     ;NHBNW
    mw[208] = mi.1.LT        ;LT
    mw[209] = mi.1.MD        ;MD
    mw[210] = mi.1.HV        ;HV
    mw[211] = mi.1.Ext       ;IX
    mw[212] = mi.1.LT        ;IX_LT
    mw[213] = mi.1.MD        ;IX_MD
    mw[214] = mi.1.HV        ;IX_HV
    mw[215] = mi.1.Ext       ;XI
    mw[216] = mi.1.LT        ;XI_LT
    mw[217] = mi.1.MD        ;XI_MD
    mw[218] = mi.1.HV        ;XI_HV
    
    
    
    ;create TLF index
    ; 1) intergerize the weighted average daily time/dist/gencost
    ; 2) cap at max time or distance
    ; 3) add 1 to avoid a zero index in the arrays
    mw[101] = MIN(INT(mw[201]), MaxIdx) + 1     ;HBW
    mw[102] = MIN(INT(mw[202]), MaxIdx) + 1     ;HBShp
    mw[103] = MIN(INT(mw[203]), MaxIdx) + 1     ;HBOth
    mw[104] = MIN(INT(mw[204]), MaxIdx) + 1     ;HBSch_Pr
    mw[105] = MIN(INT(mw[205]), MaxIdx) + 1     ;HBSch_Sc
    mw[106] = MIN(INT(mw[206]), MaxIdx) + 1     ;NHBW
    mw[107] = MIN(INT(mw[207]), MaxIdx) + 1     ;NHBNW
    mw[108] = MIN(INT(mw[208]), MaxIdx) + 1     ;LT
    mw[109] = MIN(INT(mw[209]), MaxIdx) + 1     ;MD
    mw[110] = MIN(INT(mw[210]), MaxIdx) + 1     ;HV
    mw[111] = MIN(INT(mw[211]), MaxIdx) + 1     ;IX
    mw[112] = MIN(INT(mw[212]), MaxIdx) + 1     ;IX_LT
    mw[113] = MIN(INT(mw[213]), MaxIdx) + 1     ;IX_MD
    mw[114] = MIN(INT(mw[214]), MaxIdx) + 1     ;IX_HV
    mw[115] = MIN(INT(mw[215]), MaxIdx) + 1     ;XI
    mw[116] = MIN(INT(mw[216]), MaxIdx) + 1     ;XI_LT
    mw[117] = MIN(INT(mw[217]), MaxIdx) + 1     ;XI_MD
    mw[118] = MIN(INT(mw[218]), MaxIdx) + 1     ;XI_HV
    
ENDRUN




;PRINT TLF FILES =============================================================================================

;Cluster: distrubute NETWORK call onto processor 2
DistributeMultiStep Alias='TLF_Proc2'
    
    ;time ----------------------------------------------------------------------------------------------------
    RUN PGM=MATRIX  MSG='Distribution 3: TLF Summary - Time'
    
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\PA_AllPurp_Gravity.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Time.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@3_Distribute\TLF\TLF_Time.csv'
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif  ;PrintProgress=CheckProgressress
        
        
        
        ;set script specific parameters
        MaxIdx = @MaxIdx_time@
        
        
        
        ;define arrays
        ARRAY  TLF_HBW      = 999,
               TLF_HBShp    = 999,
               TLF_HBOth    = 999,
               TLF_HBSch_Pr = 999,
               TLF_HBSch_Sc = 999,
               TLF_NHBW     = 999,
               TLF_NHBNW    = 999,
               TLF_LT       = 999,
               TLF_MD       = 999,
               TLF_HV       = 999,
               TLF_IX       = 999,
               TLF_IX_LT    = 999,
               TLF_IX_MD    = 999,
               TLF_IX_HV    = 999,
               TLF_XI       = 999,
               TLF_XI_LT    = 999,
               TLF_XI_MD    = 999,
               TLF_XI_HV    = 999,
               TLF_Tel_HBW  = 999,
               TLF_Tel_NHBW = 999
        
        
        
        ;trip tables
        mw[101] = mi.1.HBW       ;HBW
        mw[102] = mi.1.HBShp     ;HBShp
        mw[103] = mi.1.HBOth     ;HBOth
        mw[104] = mi.1.HBSch_Pr  ;HBSch_Pr
        mw[105] = mi.1.HBSch_Sc  ;HBSch_Sc
        mw[106] = mi.1.NHBW      ;NHBW
        mw[107] = mi.1.NHBNW     ;NHBNW
        mw[108] = mi.1.SH_LT     ;LT
        mw[109] = mi.1.SH_MD     ;MD
        mw[110] = mi.1.SH_HV     ;HV
        mw[111] = mi.1.IX        ;IX
        mw[112] = mi.1.IX        ;IX_LT
        mw[113] = mi.1.Ext_MD    ;IX_MD
        mw[114] = mi.1.Ext_HV    ;IX_HV
        mw[115] = mi.1.XI        ;XI
        mw[116] = mi.1.XI        ;XI_LT
        mw[117] = mi.1.Ext_MD    ;XI_MD
        mw[118] = mi.1.Ext_HV    ;XI_HV
        
        mw[131] = mi.1.Tel_HBW 
        mw[141] = mi.1.Tel_NHBW
        
        
        ;TLF Idx
        mw[201] = mi.2.Idx_HBW
        mw[202] = mi.2.Idx_HBShp
        mw[203] = mi.2.Idx_HBOth
        mw[204] = mi.2.Idx_HBSch_Pr
        mw[205] = mi.2.Idx_HBSch_Sc
        mw[206] = mi.2.Idx_NHBW
        mw[207] = mi.2.Idx_NHBNW
        mw[208] = mi.2.Idx_LT
        mw[209] = mi.2.Idx_MD
        mw[210] = mi.2.Idx_HV
        mw[211] = mi.2.Idx_IX
        mw[212] = mi.2.Idx_IX_LT
        mw[213] = mi.2.Idx_IX_MD
        mw[214] = mi.2.Idx_IX_HV
        mw[215] = mi.2.Idx_XI
        mw[216] = mi.2.Idx_XI_LT
        mw[217] = mi.2.Idx_XI_MD
        mw[218] = mi.2.Idx_XI_HV

        
        
        ;calculate TLF
        JLOOP
            
            ;lookup TLF Idx
            Idx_HBW      = mw[201]
            Idx_HBShp    = mw[202]
            Idx_HBOth    = mw[203]
            Idx_HBSch_Pr = mw[204]
            Idx_HBSch_Sc = mw[205]
            Idx_NHBW     = mw[206]
            Idx_NHBNW    = mw[207]
            Idx_LT       = mw[208]
            Idx_MD       = mw[209]
            Idx_HV       = mw[210]
            Idx_IX       = mw[211]
            Idx_IX_LT    = mw[212]
            Idx_IX_MD    = mw[213]
            Idx_IX_HV    = mw[214]
            Idx_XI       = mw[215]
            Idx_XI_LT    = mw[216]
            Idx_XI_MD    = mw[217]
            Idx_XI_HV    = mw[218]

            Idx_Tel_HBW  = Idx_HBW
            Idx_Tel_NHBW = Idx_NHBW
            
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                TLF_HBW[Idx_HBW]           =  TLF_HBW[Idx_HBW]           +  mw[101]
                TLF_HBShp[Idx_HBShp]       =  TLF_HBShp[Idx_HBShp]       +  mw[102]
                TLF_HBOth[Idx_HBOth]       =  TLF_HBOth[Idx_HBOth]       +  mw[103]
                TLF_HBSch_Pr[Idx_HBSch_Pr] =  TLF_HBSch_Pr[Idx_HBSch_Pr] +  mw[104]
                TLF_HBSch_Sc[Idx_HBSch_Sc] =  TLF_HBSch_Sc[Idx_HBSch_Sc] +  mw[105]
                TLF_NHBW[Idx_NHBW]         =  TLF_NHBW[Idx_NHBW]         +  mw[106]
                TLF_NHBNW[Idx_NHBNW]       =  TLF_NHBNW[Idx_NHBNW]       +  mw[107]
                TLF_LT[Idx_LT]             =  TLF_LT[Idx_LT]             +  mw[108]
                TLF_MD[Idx_MD]             =  TLF_MD[Idx_MD]             +  mw[109]
                TLF_HV[Idx_HV]             =  TLF_HV[Idx_HV]             +  mw[110]
                
                TLF_Tel_HBW[Idx_Tel_HBW]   =  TLF_Tel_HBW[Idx_Tel_HBW]   +  mw[131]
                TLF_Tel_NHBW[Idx_Tel_NHBW] =  TLF_Tel_NHBW[Idx_Tel_NHBW] +  mw[141]
                
            ;IX
            elseif (!(i=@externalzones@) & (j=@externalzones@))
                
                TLF_IX[Idx_IX]             =  TLF_IX[Idx_IX]             +  mw[111]
                TLF_IX_LT[Idx_IX_LT]       =  TLF_IX_LT[Idx_IX_LT]       +  mw[112]
                TLF_IX_MD[Idx_IX_MD]       =  TLF_IX_MD[Idx_IX_MD]       +  mw[113]
                TLF_IX_HV[Idx_IX_HV]       =  TLF_IX_HV[Idx_IX_HV]       +  mw[114]

            ;XI
            elseif ((i=@externalzones@) & !(j=@externalzones@))
                
                TLF_XI[Idx_XI]             =  TLF_XI[Idx_XI]             +  mw[115]
                TLF_XI_LT[Idx_XI_LT]       =  TLF_XI_LT[Idx_XI_LT]       +  mw[116]
                TLF_XI_MD[Idx_XI_MD]       =  TLF_XI_MD[Idx_XI_MD]       +  mw[117]
                TLF_XI_HV[Idx_XI_HV]       =  TLF_XI_HV[Idx_XI_HV]       +  mw[118]
            endif
            
        ENDJLOOP
        
        
        
        ;print TLF
        if (i=@UsedZones@)
            
            ;print TLF time & dist output file headers
            PRINT PRINTO=1,
                CSV=T,
                LIST='Bin'      ,
                     'HBW'      ,
                     'HBShp'    ,
                     'HBOth'    ,
                     'HBSch_Pr' ,
                     'HBSch_Sc' ,
                     'NHBW'     ,
                     'NHBNW'    ,
                     'LT'       ,
                     'MD'       ,
                     'HV'       ,
                     'IX'       ,
                     'IX_LT'    ,
                     'IX_MD'    ,
                     'IX_HV'    ,
                     'XI'       ,
                     'XI_LT'    ,
                     'XI_MD'    ,
                     'XI_HV'    ,
                     'Tel_HBW'  ,
                     'Tel_NHBW' 
            
            
            ;print TLF
            LOOP Idx=1, MaxIdx + 1
                
                ;calc bin for printing (start bins at 0)
                Bin = Idx - 1
                
                ;print TLF time to output file
                PRINT CSV=T, PRINTO=1,
                    FORM=15.2,
                    LIST=Bin(10.0)         ,
                         TLF_HBW[Idx]      ,
                         TLF_HBShp[Idx]    ,
                         TLF_HBOth[Idx]    ,
                         TLF_HBSch_Pr[Idx] ,
                         TLF_HBSch_Sc[Idx] ,
                         TLF_NHBW[Idx]     ,
                         TLF_NHBNW[Idx]    ,
                         TLF_LT[Idx]       ,
                         TLF_MD[Idx]       ,
                         TLF_HV[Idx]       ,
                         TLF_IX[Idx]       ,
                         TLF_IX_LT[Idx]    ,
                         TLF_IX_MD[Idx]    ,
                         TLF_IX_HV[Idx]    ,
                         TLF_XI[Idx]       ,
                         TLF_XI_LT[Idx]    ,
                         TLF_XI_MD[Idx]    ,
                         TLF_XI_HV[Idx]    ,
                         TLF_Tel_HBW[Idx]  ,
                         TLF_Tel_NHBW[Idx] 

            ENDLOOP  ;Idx=1, MaxIdx
            
        endif  ;i=UsedZones
     
    ENDRUN
    
;Cluster: end of group distributed to processor 2
EndDistributeMULTISTEP




;Cluster: distrubute NETWORK call onto processor 3
DistributeMultiStep Alias='TLF_Proc3'
    
    ;dist ----------------------------------------------------------------------------------------------------
    RUN PGM=MATRIX  MSG='Distribution 3: TLF Summary - Dist'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\PA_AllPurp_Gravity.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Dist.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@3_Distribute\TLF\TLF_Dist.csv'
        
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif  ;PrintProgress=CheckProgressress
        
        
        
        ;set script specific parameters
        MaxIdx = @MaxIdx_dist@
        
        
        
        ;define arrays
        ARRAY  TLF_HBW      = 999,
               TLF_HBShp    = 999,
               TLF_HBOth    = 999,
               TLF_HBSch_Pr = 999,
               TLF_HBSch_Sc = 999,
               TLF_NHBW     = 999,
               TLF_NHBNW    = 999,
               TLF_LT       = 999,
               TLF_MD       = 999,
               TLF_HV       = 999,
               TLF_IX       = 999,
               TLF_IX_LT    = 999,
               TLF_IX_MD    = 999,
               TLF_IX_HV    = 999,
               TLF_XI       = 999,
               TLF_XI_LT    = 999,
               TLF_XI_MD    = 999,
               TLF_XI_HV    = 999,
               TLF_Tel_HBW  = 999,
               TLF_Tel_NHBW = 999

        
        
        ;trip tables
        mw[101] = mi.1.HBW       ;HBW
        mw[102] = mi.1.HBShp     ;HBShp
        mw[103] = mi.1.HBOth     ;HBOth
        mw[104] = mi.1.HBSch_Pr  ;HBSch_Pr
        mw[105] = mi.1.HBSch_Sc  ;HBSch_Sc
        mw[106] = mi.1.NHBW      ;NHBW
        mw[107] = mi.1.NHBNW     ;NHBNW
        mw[108] = mi.1.SH_LT     ;LT
        mw[109] = mi.1.SH_MD     ;MD
        mw[110] = mi.1.SH_HV     ;HV
        mw[111] = mi.1.IX        ;IX
        mw[112] = mi.1.IX        ;IX_LT
        mw[113] = mi.1.Ext_MD    ;IX_MD
        mw[114] = mi.1.Ext_HV    ;IX_HV
        mw[115] = mi.1.XI        ;XI
        mw[116] = mi.1.XI        ;XI_LT
        mw[117] = mi.1.Ext_MD    ;XI_MD
        mw[118] = mi.1.Ext_HV    ;XI_HV
        
        mw[131] = mi.1.Tel_HBW 
        mw[141] = mi.1.Tel_NHBW
        
        
        ;TLF Idx
        mw[201] = mi.2.Idx_HBW
        mw[202] = mi.2.Idx_HBShp
        mw[203] = mi.2.Idx_HBOth
        mw[204] = mi.2.Idx_HBSch_Pr
        mw[205] = mi.2.Idx_HBSch_Sc
        mw[206] = mi.2.Idx_NHBW
        mw[207] = mi.2.Idx_NHBNW
        mw[208] = mi.2.Idx_LT
        mw[209] = mi.2.Idx_MD
        mw[210] = mi.2.Idx_HV
        mw[211] = mi.2.Idx_IX
        mw[212] = mi.2.Idx_IX_LT
        mw[213] = mi.2.Idx_IX_MD
        mw[214] = mi.2.Idx_IX_HV
        mw[215] = mi.2.Idx_XI
        mw[216] = mi.2.Idx_XI_LT
        mw[217] = mi.2.Idx_XI_MD
        mw[218] = mi.2.Idx_XI_HV
        
        
        
        ;calculate TLF
        JLOOP
            
            ;lookup TLF Idx
            Idx_HBW      = mw[201]
            Idx_HBShp    = mw[202]
            Idx_HBOth    = mw[203]
            Idx_HBSch_Pr = mw[204]
            Idx_HBSch_Sc = mw[205]
            Idx_NHBW     = mw[206]
            Idx_NHBNW    = mw[207]
            Idx_LT       = mw[208]
            Idx_MD       = mw[209]
            Idx_HV       = mw[210]
            Idx_IX       = mw[211]
            Idx_IX_LT    = mw[212]
            Idx_IX_MD    = mw[213]
            Idx_IX_HV    = mw[214]
            Idx_XI       = mw[215]
            Idx_XI_LT    = mw[216]
            Idx_XI_MD    = mw[217]
            Idx_XI_HV    = mw[218]

            Idx_Tel_HBW  = Idx_HBW
            Idx_Tel_NHBW = Idx_NHBW
            
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                TLF_HBW[Idx_HBW]           =  TLF_HBW[Idx_HBW]           +  mw[101]
                TLF_HBShp[Idx_HBShp]       =  TLF_HBShp[Idx_HBShp]       +  mw[102]
                TLF_HBOth[Idx_HBOth]       =  TLF_HBOth[Idx_HBOth]       +  mw[103]
                TLF_HBSch_Pr[Idx_HBSch_Pr] =  TLF_HBSch_Pr[Idx_HBSch_Pr] +  mw[104]
                TLF_HBSch_Sc[Idx_HBSch_Sc] =  TLF_HBSch_Sc[Idx_HBSch_Sc] +  mw[105]
                TLF_NHBW[Idx_NHBW]         =  TLF_NHBW[Idx_NHBW]         +  mw[106]
                TLF_NHBNW[Idx_NHBNW]       =  TLF_NHBNW[Idx_NHBNW]       +  mw[107]
                TLF_LT[Idx_LT]             =  TLF_LT[Idx_LT]             +  mw[108]
                TLF_MD[Idx_MD]             =  TLF_MD[Idx_MD]             +  mw[109]
                TLF_HV[Idx_HV]             =  TLF_HV[Idx_HV]             +  mw[110]
                
                TLF_Tel_HBW[Idx_Tel_HBW]   =  TLF_Tel_HBW[Idx_Tel_HBW]   +  mw[131]
                TLF_Tel_NHBW[Idx_Tel_NHBW] =  TLF_Tel_NHBW[Idx_Tel_NHBW] +  mw[141]
                
            ;IX
            elseif (!(i=@externalzones@) & (j=@externalzones@))
                
                TLF_IX[Idx_IX]             =  TLF_IX[Idx_IX]             +  mw[111]
                TLF_IX_LT[Idx_IX_LT]       =  TLF_IX_LT[Idx_IX_LT]       +  mw[112]
                TLF_IX_MD[Idx_IX_MD]       =  TLF_IX_MD[Idx_IX_MD]       +  mw[113]
                TLF_IX_HV[Idx_IX_HV]       =  TLF_IX_HV[Idx_IX_HV]       +  mw[114]

            ;XI
            elseif ((i=@externalzones@) & !(j=@externalzones@))
                
                TLF_XI[Idx_XI]             =  TLF_XI[Idx_XI]             +  mw[115]
                TLF_XI_LT[Idx_XI_LT]       =  TLF_XI_LT[Idx_XI_LT]       +  mw[116]
                TLF_XI_MD[Idx_XI_MD]       =  TLF_XI_MD[Idx_XI_MD]       +  mw[117]
                TLF_XI_HV[Idx_XI_HV]       =  TLF_XI_HV[Idx_XI_HV]       +  mw[118]
            endif
            
        ENDJLOOP
        
        
        
        ;print TLF
        if (i=@UsedZones@)
            
            ;print TLF time & dist output file headers
            PRINT PRINTO=1,
                CSV=T,
                LIST='Bin'      ,
                     'HBW'      ,
                     'HBShp'    ,
                     'HBOth'    ,
                     'HBSch_Pr' ,
                     'HBSch_Sc' ,
                     'NHBW'     ,
                     'NHBNW'    ,
                     'LT'       ,
                     'MD'       ,
                     'HV'       ,
                     'IX'       ,
                     'IX_LT'    ,
                     'IX_MD'    ,
                     'IX_HV'    ,
                     'XI'       ,
                     'XI_LT'    ,
                     'XI_MD'    ,
                     'XI_HV'    ,
                     'Tel_HBW'  ,
                     'Tel_NHBW' 
            
            
            ;print TLF
            LOOP Idx=1, MaxIdx + 1
                
                ;calc bin for printing (start bins at 0)
                Bin = Idx - 1
                
                ;print TLF time to output file
                PRINT CSV=T, PRINTO=1,
                    FORM=15.2,
                    LIST=Bin(10.0)         ,
                         TLF_HBW[Idx]      ,
                         TLF_HBShp[Idx]    ,
                         TLF_HBOth[Idx]    ,
                         TLF_HBSch_Pr[Idx] ,
                         TLF_HBSch_Sc[Idx] ,
                         TLF_NHBW[Idx]     ,
                         TLF_NHBNW[Idx]    ,
                         TLF_LT[Idx]       ,
                         TLF_MD[Idx]       ,
                         TLF_HV[Idx]       ,
                         TLF_IX[Idx]       ,
                         TLF_IX_LT[Idx]    ,
                         TLF_IX_MD[Idx]    ,
                         TLF_IX_HV[Idx]    ,
                         TLF_XI[Idx]       ,
                         TLF_XI_LT[Idx]    ,
                         TLF_XI_MD[Idx]    ,
                         TLF_XI_HV[Idx]    ,
                         TLF_Tel_HBW[Idx]  ,
                         TLF_Tel_NHBW[Idx] 

            ENDLOOP  ;Idx=1, MaxIdx
            
        endif  ;i=UsedZones
     
    ENDRUN
    
;Cluster: end of group distributed to processor 3
EndDistributeMULTISTEP




;Cluster: keep processing on processor 1 (Main)
    
    ;cost ----------------------------------------------------------------------------------------------------
    RUN PGM=MATRIX  MSG='Distribution 3: TLF Summary - Cost'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@3_Distribute\PA_AllPurp_Gravity.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@Temp\3_Distribute\tmp_TLF Idx - Cost.mtx'
    
    FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@3_Distribute\TLF\TLF_Cost.csv'
            
        
        
        ZONES   = @Usedzones@
        ZONEMSG = 10
        
        
        
        ;print status to task monitor window
        PrintProgress = INT((i-FIRSTZONE) / (LASTZONE-FIRSTZONE) * 100)
        PrintProgInc = 1
        
        if (i=FIRSTZONE)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = PrintProgInc
        elseif (PrintProgress=CheckProgress)
            PRINT PRINTO=0, LIST='Processing: ', PrintProgress(5.0), '%'
            CheckProgress = CheckProgress + PrintProgInc
        endif  ;PrintProgress=CheckProgressress
        
        
        
        ;set script specific parameters
        MaxIdx = @MaxIdx_cost@
        
        
        
        ;define arrays
        ARRAY  TLF_HBW      = 999,
               TLF_HBShp    = 999,
               TLF_HBOth    = 999,
               TLF_HBSch_Pr = 999,
               TLF_HBSch_Sc = 999,
               TLF_NHBW     = 999,
               TLF_NHBNW    = 999,
               TLF_LT       = 999,
               TLF_MD       = 999,
               TLF_HV       = 999,
               TLF_IX       = 999,
               TLF_IX_LT    = 999,
               TLF_IX_MD    = 999,
               TLF_IX_HV    = 999,
               TLF_XI       = 999,
               TLF_XI_LT    = 999,
               TLF_XI_MD    = 999,
               TLF_XI_HV    = 999,
               TLF_Tel_HBW  = 999,
               TLF_Tel_NHBW = 999

        
        
        ;trip tables
        mw[101] = mi.1.HBW       ;HBW
        mw[102] = mi.1.HBShp     ;HBShp
        mw[103] = mi.1.HBOth     ;HBOth
        mw[104] = mi.1.HBSch_Pr  ;HBSch_Pr
        mw[105] = mi.1.HBSch_Sc  ;HBSch_Sc
        mw[106] = mi.1.NHBW      ;NHBW
        mw[107] = mi.1.NHBNW     ;NHBNW
        mw[108] = mi.1.SH_LT     ;LT
        mw[109] = mi.1.SH_MD     ;MD
        mw[110] = mi.1.SH_HV     ;HV
        mw[111] = mi.1.IX        ;IX
        mw[112] = mi.1.IX        ;IX_LT
        mw[113] = mi.1.Ext_MD    ;IX_MD
        mw[114] = mi.1.Ext_HV    ;IX_HV
        mw[115] = mi.1.XI        ;XI
        mw[116] = mi.1.XI        ;XI_LT
        mw[117] = mi.1.Ext_MD    ;XI_MD
        mw[118] = mi.1.Ext_HV    ;XI_HV
        
        mw[131] = mi.1.Tel_HBW               
        mw[141] = mi.1.Tel_NHBW              
        
        
        ;TLF Idx
        mw[201] = mi.2.Idx_HBW
        mw[202] = mi.2.Idx_HBShp
        mw[203] = mi.2.Idx_HBOth
        mw[204] = mi.2.Idx_HBSch_Pr
        mw[205] = mi.2.Idx_HBSch_Sc
        mw[206] = mi.2.Idx_NHBW
        mw[207] = mi.2.Idx_NHBNW
        mw[208] = mi.2.Idx_LT
        mw[209] = mi.2.Idx_MD
        mw[210] = mi.2.Idx_HV
        mw[211] = mi.2.Idx_IX
        mw[212] = mi.2.Idx_IX_LT
        mw[213] = mi.2.Idx_IX_MD
        mw[214] = mi.2.Idx_IX_HV
        mw[215] = mi.2.Idx_XI
        mw[216] = mi.2.Idx_XI_LT
        mw[217] = mi.2.Idx_XI_MD
        mw[218] = mi.2.Idx_XI_HV

        
        
        ;calculate TLF
        JLOOP
            
            ;lookup TLF Idx
            Idx_HBW      = mw[201]
            Idx_HBShp    = mw[202]
            Idx_HBOth    = mw[203]
            Idx_HBSch_Pr = mw[204]
            Idx_HBSch_Sc = mw[205]
            Idx_NHBW     = mw[206]
            Idx_NHBNW    = mw[207]
            Idx_LT       = mw[208]
            Idx_MD       = mw[209]
            Idx_HV       = mw[210]
            Idx_IX       = mw[211]
            Idx_IX_LT    = mw[212]
            Idx_IX_MD    = mw[213]
            Idx_IX_HV    = mw[214]
            Idx_XI       = mw[215]
            Idx_XI_LT    = mw[216]
            Idx_XI_MD    = mw[217]
            Idx_XI_HV    = mw[218]

            Idx_Tel_HBW  = Idx_HBW
            Idx_Tel_NHBW = Idx_NHBW
            
            
            ;II
            if (!(i=@externalzones@) & !(j=@externalzones@))
                
                TLF_HBW[Idx_HBW]           =  TLF_HBW[Idx_HBW]           +  mw[101]
                TLF_HBShp[Idx_HBShp]       =  TLF_HBShp[Idx_HBShp]       +  mw[102]
                TLF_HBOth[Idx_HBOth]       =  TLF_HBOth[Idx_HBOth]       +  mw[103]
                TLF_HBSch_Pr[Idx_HBSch_Pr] =  TLF_HBSch_Pr[Idx_HBSch_Pr] +  mw[104]
                TLF_HBSch_Sc[Idx_HBSch_Sc] =  TLF_HBSch_Sc[Idx_HBSch_Sc] +  mw[105]
                TLF_NHBW[Idx_NHBW]         =  TLF_NHBW[Idx_NHBW]         +  mw[106]
                TLF_NHBNW[Idx_NHBNW]       =  TLF_NHBNW[Idx_NHBNW]       +  mw[107]
                TLF_LT[Idx_LT]             =  TLF_LT[Idx_LT]             +  mw[108]
                TLF_MD[Idx_MD]             =  TLF_MD[Idx_MD]             +  mw[109]
                TLF_HV[Idx_HV]             =  TLF_HV[Idx_HV]             +  mw[110]
                
                TLF_Tel_HBW[Idx_Tel_HBW]   =  TLF_Tel_HBW[Idx_Tel_HBW]   +  mw[131]
                TLF_Tel_NHBW[Idx_Tel_NHBW] =  TLF_Tel_NHBW[Idx_Tel_NHBW] +  mw[141]
                
            ;IX
            elseif (!(i=@externalzones@) & (j=@externalzones@))
                
                TLF_IX[Idx_IX]             =  TLF_IX[Idx_IX]             +  mw[111]
                TLF_IX_LT[Idx_IX_LT]       =  TLF_IX_LT[Idx_IX_LT]       +  mw[112]
                TLF_IX_MD[Idx_IX_MD]       =  TLF_IX_MD[Idx_IX_MD]       +  mw[113]
                TLF_IX_HV[Idx_IX_HV]       =  TLF_IX_HV[Idx_IX_HV]       +  mw[114]

            ;XI
            elseif ((i=@externalzones@) & !(j=@externalzones@))
                
                TLF_XI[Idx_XI]             =  TLF_XI[Idx_XI]             +  mw[115]
                TLF_XI_LT[Idx_XI_LT]       =  TLF_XI_LT[Idx_XI_LT]       +  mw[116]
                TLF_XI_MD[Idx_XI_MD]       =  TLF_XI_MD[Idx_XI_MD]       +  mw[117]
                TLF_XI_HV[Idx_XI_HV]       =  TLF_XI_HV[Idx_XI_HV]       +  mw[118]
            endif
            
        ENDJLOOP
        
        
        
        ;print TLF
        if (i=@UsedZones@)
            
            ;print TLF time & dist output file headers
            PRINT PRINTO=1,
                CSV=T,
                LIST='Bin'      ,
                     'HBW'      ,
                     'HBShp'    ,
                     'HBOth'    ,
                     'HBSch_Pr' ,
                     'HBSch_Sc' ,
                     'NHBW'     ,
                     'NHBNW'    ,
                     'LT'       ,
                     'MD'       ,
                     'HV'       ,
                     'IX'       ,
                     'IX_LT'    ,
                     'IX_MD'    ,
                     'IX_HV'    ,
                     'XI'       ,
                     'XI_LT'    ,
                     'XI_MD'    ,
                     'XI_HV'    ,
                     'Tel_HBW'  ,
                     'Tel_NHBW' 
            
            
            ;print TLF
            LOOP Idx=1, MaxIdx + 1
                
                ;calc bin for printing (start bins at 0)
                Bin = Idx - 1
                
                ;print TLF time to output file
                PRINT CSV=T, PRINTO=1,
                    FORM=15.2,
                    LIST=Bin(10.0)         ,
                         TLF_HBW[Idx]      ,
                         TLF_HBShp[Idx]    ,
                         TLF_HBOth[Idx]    ,
                         TLF_HBSch_Pr[Idx] ,
                         TLF_HBSch_Sc[Idx] ,
                         TLF_NHBW[Idx]     ,
                         TLF_NHBNW[Idx]    ,
                         TLF_LT[Idx]       ,
                         TLF_MD[Idx]       ,
                         TLF_HV[Idx]       ,
                         TLF_IX[Idx]       ,
                         TLF_IX_LT[Idx]    ,
                         TLF_IX_MD[Idx]    ,
                         TLF_IX_HV[Idx]    ,
                         TLF_XI[Idx]       ,
                         TLF_XI_LT[Idx]    ,
                         TLF_XI_MD[Idx]    ,
                         TLF_XI_HV[Idx]    ,
                         TLF_Tel_HBW[Idx]  ,
                         TLF_Tel_NHBW[Idx] 

            ENDLOOP  ;Idx=1, MaxIdx
            
        endif  ;i=UsedZones
     
    ENDRUN
    
;Cluster: bring together all distributed steps before continuing
BARRIER IDLIST='TLF_Proc2', 'TLF_Proc3', CheckReturnCode=T, PrintFiles=Merge




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Distrib TLF                        ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 4_TLF_Distrib_PA.txt)
