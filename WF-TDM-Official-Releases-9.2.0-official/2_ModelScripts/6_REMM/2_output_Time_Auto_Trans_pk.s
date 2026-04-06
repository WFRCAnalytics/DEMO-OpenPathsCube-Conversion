
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 02_REMM_Output_Skims.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX   MSG='REMM: Write out Peak skim (auto and walk to transit) matrices to dbf'
    FILEI MATI[1]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w4_pk.mtx'
    FILEI MATI[2]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w5_pk.mtx'
    FILEI MATI[3]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w6_pk.mtx'
    FILEI MATI[4]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w7_pk.mtx'
    FILEI MATI[5]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w8_pk.mtx'
    FILEI MATI[6]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_w9_pk.mtx'    
    FILEI MATI[7]  = '@ParentDir@@ScenarioDir@4_ModeChoice\1a_Skims\skm_auto_pk.mtx'
    
    MATO[1] = '@ParentDir@@ScenarioDir@6_REMM\MinAuto_Trans_pk.mtx',
        MO=10-11,1-6,
        NAME=Auto_Pk   ,
             Min_W_tran,
             W_LCL     ,
             W_BRT     ,
             W_EXP     ,
             W_LRT     ,
             W_CRT     ,
             W_mode9   
        
    FILEO RECO[1] = '@ParentDir@@ScenarioDir@6_REMM\MinAuto_Trans_pk.dbf',
        FORM=15.5,
        FIELDS = I(10.0), 
                 J(10.0),
                 minauto,
                 mintransit 
    
    
    ZONES   = @UsedZones@
    ZONEMSG = 10
    
    
    mw[1] = CmpNumRetNum(mi.1.T456789,'<=',0,5000,(mi.1.WALKTIME + mi.1.INITWAIT + mi.1.T456789 + mi.1.xferwait))
    mw[2] = CmpNumRetNum(mi.2.T456789,'<=',0,5000,(mi.2.WALKTIME + mi.2.INITWAIT + mi.2.T456789 + mi.2.xferwait))
    mw[3] = CmpNumRetNum(mi.3.T456789,'<=',0,5000,(mi.3.WALKTIME + mi.3.INITWAIT + mi.3.T456789 + mi.3.xferwait))
    mw[4] = CmpNumRetNum(mi.4.T456789,'<=',0,5000,(mi.4.WALKTIME + mi.4.INITWAIT + mi.4.T456789 + mi.4.xferwait))
    mw[5] = CmpNumRetNum(mi.5.T456789,'<=',0,5000,(mi.5.WALKTIME + mi.5.INITWAIT + mi.5.T456789 + mi.5.xferwait))
    mw[6] = CmpNumRetNum(mi.6.T456789,'<=',0,5000,(mi.6.WALKTIME + mi.6.INITWAIT + mi.6.T456789 + mi.6.xferwait))
    
    mw[10] = CmpNumRetNum(mi.7.ivt_GP,'<=',0,50000,(mi.7.ivt_GP + mi.7.ovt)) 
    
    mw[11] = min(mw[1],mw[2],mw[3],mw[4],mw[5],mw[6])
    
    
    JLOOP
        RO.minauto    = mw[10][j]
        RO.mintransit = mw[11][j]
        RO.I          = i
        RO.J          = j
        
        WRITE RECO = 1
    
    ENDJLOOP
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Convert Peak skims to DBF          ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(DEL 02_REMM_Output_Skims.txt)
