
;System
    ;file to halt the model run if model crashes
    *(ECHO 'model crashed' > 12_EstimateHBSchModeShare.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX  MSG='Mode Choice 15: calculate HBSch mode share'
    FILEI MATI[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx'
    FILEI MATI[2] = '@ParentDir@@ScenarioDir@3_Distribute\skm_AM.mtx'
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx',
        MO=111-116,121-126,131-136,
        NAME=SchoolBus,
             DriveSelf,
             DropOff, 
             Walk,
             Bike,
             TotHBSch,
             
             Pk_SchoolBus,
             Pk_DriveSelf,
             Pk_DropOff, 
             Pk_Walk,
             Pk_Bike,
             Pk_TotHBSch,
             
             Ok_SchoolBus,
             Ok_DriveSelf,
             Ok_DropOff, 
             Ok_Walk,
             Ok_Bike,
             Ok_TotHBSch
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx',
        MO=211-216,221-226,231-236,
        NAME=SchoolBus,
             DriveSelf,
             DropOff, 
             Walk,
             Bike,
             TotHBSch,
             
             Pk_SchoolBus,
             Pk_DriveSelf,
             Pk_DropOff, 
             Pk_Walk,
             Pk_Bike,
             Pk_TotHBSch,
             
             Ok_SchoolBus,
             Ok_DriveSelf,
             Ok_DropOff, 
             Ok_Walk,
             Ok_Bike,
             Ok_TotHBSch
    
    
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
        
    
    
    ZONES   = @Usedzones@
    ZONEMSG = 10
   
	;read in calculated diurnal factors from file
	if (i=FIRSTZONE)
		
		;read in calculate diurnal factors block file
		READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
		
	endif  ;i=FIRSTZONE
    
    JLOOP
        ;daily ----------------------------------------------------------------------
        ;primary school (K-5)
        if (mi.2.distance_Auto_Per[j]<=@SchoolbusDist_PR@)
            mw[111] = mi.1.HBSch_PR[j] * @in_PR_Schoolbus@             ;School bus
            mw[112] = mi.1.HBSch_PR[j] * @in_PR_Drive@                 ;Drive
            mw[113] = mi.1.HBSch_PR[j] * @in_PR_DropOff@               ;Drop off
            mw[114] = mi.1.HBSch_PR[j] * @in_PR_Walk@                  ;Walk
            mw[115] = mi.1.HBSch_PR[j] * @in_PR_Bike@                  ;Bike
            
            mw[116] = mw[111] +
                      mw[112] +
                      mw[113] +
                      mw[114] +
                      mw[115]
        else
            mw[111] = mi.1.HBSch_PR[j] * @out_PR_Schoolbus@            ;School bus
            mw[112] = mi.1.HBSch_PR[j] * @out_PR_Drive@                ;Drive
            mw[113] = mi.1.HBSch_PR[j] * @out_PR_DropOff@              ;Drop off
            mw[114] = mi.1.HBSch_PR[j] * @out_PR_Walk@                 ;Walk
            mw[115] = mi.1.HBSch_PR[j] * @out_PR_Bike@                 ;Bike
            
            mw[116] = mw[111] +
                      mw[112] +
                      mw[113] +
                      mw[114] +
                      mw[115]
        endif
        
        ;secondary school (7-12)
        if (mi.2.distance_Auto_Per[j]<=@SchoolbusDist_SC@)
            mw[211] = mi.1.HBSch_SC[j] * @in_SC_Schoolbus@             ;School bus
            mw[212] = mi.1.HBSch_SC[j] * @in_SC_Drive@                 ;Drive
            mw[213] = mi.1.HBSch_SC[j] * @in_SC_DropOff@               ;Drop off
            mw[214] = mi.1.HBSch_SC[j] * @in_SC_Walk@                  ;Walk
            mw[215] = mi.1.HBSch_SC[j] * @in_SC_Bike@                  ;Bike
            
            mw[216] = mw[211] +
                      mw[212] +
                      mw[213] +
                      mw[214] +
                      mw[215]
        else
            ;secondary school (7-12)
            mw[211] = mi.1.HBSch_SC[j] * @out_SC_Schoolbus@            ;School bus
            mw[212] = mi.1.HBSch_SC[j] * @out_SC_Drive@                ;Drive
            mw[213] = mi.1.HBSch_SC[j] * @out_SC_DropOff@              ;Drop off
            mw[214] = mi.1.HBSch_SC[j] * @out_SC_Walk@                 ;Walk
            mw[215] = mi.1.HBSch_SC[j] * @out_SC_Bike@                 ;Bike
            
            mw[216] = mw[211] +
                      mw[212] +
                      mw[213] +
                      mw[214] +
                      mw[215]
        endif
        
        
        ;peak -----------------------------------------------------------------------
        ;primary school (K-5)
        mw[121] = mw[111] * (Pct_AM_HBS + Pct_PM_HBS)           ;School bus
        mw[122] = mw[112] * (Pct_AM_HBS + Pct_PM_HBS)           ;Drive     
        mw[123] = mw[113] * (Pct_AM_HBS + Pct_PM_HBS)           ;Drop off  
        mw[124] = mw[114] * (Pct_AM_HBS + Pct_PM_HBS)           ;Walk      
        mw[125] = mw[115] * (Pct_AM_HBS + Pct_PM_HBS)           ;Bike      
            
        mw[126] = mw[121] +
                  mw[122] +
                  mw[123] +
                  mw[124] +
                  mw[125]
        
        ;secondary school (7-12)
        mw[221] = mw[211] * (Pct_AM_HBS + Pct_PM_HBS)           ;School bus
        mw[222] = mw[212] * (Pct_AM_HBS + Pct_PM_HBS)           ;Drive     
        mw[223] = mw[213] * (Pct_AM_HBS + Pct_PM_HBS)           ;Drop off  
        mw[224] = mw[214] * (Pct_AM_HBS + Pct_PM_HBS)           ;Walk      
        mw[225] = mw[215] * (Pct_AM_HBS + Pct_PM_HBS)           ;Bike      
            
        mw[226] = mw[221] +
                  mw[222] +
                  mw[223] +
                  mw[224] +
                  mw[225]
        
        
        ;off-peak -------------------------------------------------------------------
        ;primary school (K-5)
        mw[131] = mw[111] * (Pct_MD_HBS + Pct_EV_HBS)           ;School bus
        mw[132] = mw[112] * (Pct_MD_HBS + Pct_EV_HBS)           ;Drive     
        mw[133] = mw[113] * (Pct_MD_HBS + Pct_EV_HBS)           ;Drop off  
        mw[134] = mw[114] * (Pct_MD_HBS + Pct_EV_HBS)           ;Walk      
        mw[135] = mw[115] * (Pct_MD_HBS + Pct_EV_HBS)           ;Bike      
            
        mw[136] = mw[131] +
                  mw[132] +
                  mw[133] +
                  mw[134] +
                  mw[135]
        
        ;secondary school (7-12)
        mw[231] = mw[211] * (Pct_MD_HBS + Pct_EV_HBS)           ;School bus
        mw[232] = mw[212] * (Pct_MD_HBS + Pct_EV_HBS)           ;Drive     
        mw[233] = mw[213] * (Pct_MD_HBS + Pct_EV_HBS)           ;Drop off  
        mw[234] = mw[214] * (Pct_MD_HBS + Pct_EV_HBS)           ;Walk      
        mw[235] = mw[215] * (Pct_MD_HBS + Pct_EV_HBS)           ;Bike      
            
        mw[236] = mw[231] +
                  mw[232] +
                  mw[233] +
                  mw[234] +
                  mw[235]
        
        
    ENDJLOOP
    
ENDRUN



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
  *(DEL 12_EstimateHBSchModeShare.txt)
