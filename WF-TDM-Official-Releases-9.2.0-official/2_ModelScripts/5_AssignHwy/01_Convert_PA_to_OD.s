
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 01_Convert_PA_to_OD.txt)



;get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX   MSG='Final Assign: Convert PA tables to OD by period'

    FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[04] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[08] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\NHB_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'                   ;K-6 HBSch 
    FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'                   ;7-12 HBSch
    
    ;***** Matrix names must be identical to standardize their use in the assignment block file.
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pa_am3hr_managed.mtx', 
        mo=101-134, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pa_md6hr_managed.mtx', 
        mo=201-234, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[3] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pa_pm3hr_managed.mtx', 
        mo=301-334, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[4] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pa_ev12hr_managed.mtx',
        mo=401-434, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[5] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pa_pm1hr_managed.mtx', 
        mo=501-534, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[6] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ap_am3hr_managed.mtx', 
        mo=151-184, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[7] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ap_md6hr_managed.mtx', 
        mo=251-284, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[8] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ap_pm3hr_managed.mtx', 
        mo=351-384, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[9] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ap_ev12hr_managed.mtx',
        mo=451-484, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    FILEO MATO[10] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ap_pm1hr_managed.mtx', 
        mo=551-584, 
        name=HBW_DA_NON, HBW_SR_NON, HBW_SR_HOV, HBW_DA_TOL, HBW_SR_TOL, 
             HBO_DA_NON, HBO_SR_NON, HBO_SR_HOV, HBO_DA_TOL, HBO_SR_TOL,
             NHB_DA_NON, NHB_SR_NON, NHB_SR_HOV, NHB_DA_TOL, NHB_SR_TOL,
             HBC_DA_NON, HBC_SR_NON, HBC_SR_HOV, HBC_DA_TOL, HBC_SR_TOL,
             HBS_DriveSelf_Pr, HBS_DriveSelf_Sc, 
             IX, XI, XX, 
             SH_LT, SH_MD, SH_HV, Ext_MD, Ext_HV,
             HBS_DropOff_Pr, HBS_DropOff_Sc,
             SchoolBus_Pr, SchoolBus_Sc
    
    
    ;Cluster: distribute intrastep processing
    DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
    
    
    ;define matrix parameters
    ZONES   = @UsedZones@
    ZONEMSG = 5
    
    
    
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
    
    
    
    ;read in calculated diurnal factors from file
    if (i=FIRSTZONE)
        
        ;read in calculate diurnal factors block file
        READ FILE = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
        
    endif  ;i=FIRSTZONE
    
    
    
    ;read in mode choice matricies (note mode choice matrices are multiplied by 100) -------------------------
    ;HBW PK
    mw[001] = (mi.2.alone_non                ) / 100    ;HBW PK DA NON
    mw[002] = (mi.2.sr2_non  +  mi.2.sr3_non ) / 100    ;HBW PK SR NON
    mw[003] = (mi.2.sr2_hov  +  mi.2.sr3_hov ) / 100    ;HBW PK SR HOV
    mw[004] = (mi.2.alone_toll               ) / 100    ;HBW PK DA TOL
    mw[005] = (mi.2.sr2_toll +  mi.2.sr3_toll) / 100    ;HBW PK SR TOL
    
    ;HBO PK
    mw[006] = (mi.3.alone_non                ) / 100    ;HBO PK DA NON
    mw[007] = (mi.3.sr2_non  +  mi.3.sr3_non ) / 100    ;HBO PK SR NON
    mw[008] = (mi.3.sr2_hov  +  mi.3.sr3_hov ) / 100    ;HBO PK SR HOV
    mw[009] = (mi.3.alone_toll               ) / 100    ;HBO PK DA TOL
    mw[010] = (mi.3.sr2_toll +  mi.3.sr3_toll) / 100    ;HBO PK SR TOL
    
    ;NHB PK                                                           
    mw[011] = (mi.4.alone_non                ) / 100    ;NHB PK DA NON
    mw[012] = (mi.4.sr2_non  +  mi.4.sr3_non ) / 100    ;NHB PK SR NON
    mw[013] = (mi.4.sr2_hov  +  mi.4.sr3_hov ) / 100    ;NHB PK SR HOV
    mw[014] = (mi.4.alone_toll               ) / 100    ;NHB PK DA TOL
    mw[015] = (mi.4.sr2_toll +  mi.4.sr3_toll) / 100    ;NHB PK SR TOL
    
    ;HBC PK                                                           
    mw[016] = (mi.5.alone_non                ) / 100    ;HBC PK DA NON
    mw[017] = (mi.5.sr2_non  +  mi.5.sr3_non ) / 100    ;HBC PK SR NON
    mw[018] = (mi.5.sr2_hov  +  mi.5.sr3_hov ) / 100    ;HBC PK SR HOV
    mw[019] = (mi.5.alone_toll               ) / 100    ;HBC PK DA TOL
    mw[020] = (mi.5.sr2_toll +  mi.5.sr3_toll) / 100    ;HBC PK SR TOL
    
    
    ;transposed HBW PK
    mw[021] = (mi.2.alone_non.T                  ) / 100    ;HBW PK DA NON
    mw[022] = (mi.2.sr2_non.T  +  mi.2.sr3_non.T ) / 100    ;HBW PK SR NON
    mw[023] = (mi.2.sr2_hov.T  +  mi.2.sr3_hov.T ) / 100    ;HBW PK SR HOV
    mw[024] = (mi.2.alone_toll.T                 ) / 100    ;HBW PK DA TOL
    mw[025] = (mi.2.sr2_toll.T +  mi.2.sr3_toll.T) / 100    ;HBW PK SR TOL
    
    ;transposed HBO PK
    mw[026] = (mi.3.alone_non.T                  ) / 100    ;HBO PK DA NON
    mw[027] = (mi.3.sr2_non.T  +  mi.3.sr3_non.T ) / 100    ;HBO PK SR NON
    mw[028] = (mi.3.sr2_hov.T  +  mi.3.sr3_hov.T ) / 100    ;HBO PK SR HOV
    mw[029] = (mi.3.alone_toll.T                 ) / 100    ;HBO PK DA TOL
    mw[030] = (mi.3.sr2_toll.T +  mi.3.sr3_toll.T) / 100    ;HBO PK SR TOL
    
    ;transposed NHB PK                                                    
    mw[031] = (mi.4.alone_non.T                  ) / 100    ;NHB PK DA NON
    mw[032] = (mi.4.sr2_non.T  +  mi.4.sr3_non.T ) / 100    ;NHB PK SR NON
    mw[033] = (mi.4.sr2_hov.T  +  mi.4.sr3_hov.T ) / 100    ;NHB PK SR HOV
    mw[034] = (mi.4.alone_toll.T                 ) / 100    ;NHB PK DA TOL
    mw[035] = (mi.4.sr2_toll.T +  mi.4.sr3_toll.T) / 100    ;NHB PK SR TOL
    
    ;transposed HBC PK                                                    
    mw[036] = (mi.5.alone_non.T                  ) / 100    ;HBC PK DA NON
    mw[037] = (mi.5.sr2_non.T  +  mi.5.sr3_non.T ) / 100    ;HBC PK SR NON
    mw[038] = (mi.5.sr2_hov.T  +  mi.5.sr3_hov.T ) / 100    ;HBC PK SR HOV
    mw[039] = (mi.5.alone_toll.T                 ) / 100    ;HBC PK DA TOL
    mw[040] = (mi.5.sr2_toll.T +  mi.5.sr3_toll.T) / 100    ;HBC PK SR TOL
    
    
    ;HBW OK
    mw[041] = (mi.6.alone_non                ) / 100    ;HBW OK DA NON
    mw[042] = (mi.6.sr2_non  +  mi.6.sr3_non ) / 100    ;HBW OK SR NON
    mw[043] = (mi.6.sr2_hov  +  mi.6.sr3_hov ) / 100    ;HBW OK SR HOV
    mw[044] = (mi.6.alone_toll               ) / 100    ;HBW OK DA TOL
    mw[045] = (mi.6.sr2_toll +  mi.6.sr3_toll) / 100    ;HBW OK SR TOL
    
    ;HBO OK
    mw[046] = (mi.7.alone_non                ) / 100    ;HBO OK DA NON
    mw[047] = (mi.7.sr2_non  +  mi.7.sr3_non ) / 100    ;HBO OK SR NON
    mw[048] = (mi.7.sr2_hov  +  mi.7.sr3_hov ) / 100    ;HBO OK SR HOV
    mw[049] = (mi.7.alone_toll               ) / 100    ;HBO OK DA TOL
    mw[050] = (mi.7.sr2_toll +  mi.7.sr3_toll) / 100    ;HBO OK SR TOL
    
    ;NHB OK                                                           
    mw[051] = (mi.8.alone_non                ) / 100    ;NHB OK DA NON
    mw[052] = (mi.8.sr2_non  +  mi.8.sr3_non ) / 100    ;NHB OK SR NON
    mw[053] = (mi.8.sr2_hov  +  mi.8.sr3_hov ) / 100    ;NHB OK SR HOV
    mw[054] = (mi.8.alone_toll               ) / 100    ;NHB OK DA TOL
    mw[055] = (mi.8.sr2_toll +  mi.8.sr3_toll) / 100    ;NHB OK SR TOL
    
    ;HBC OK                                                           
    mw[056] = (mi.9.alone_non                ) / 100    ;HBC OK DA NON
    mw[057] = (mi.9.sr2_non  +  mi.9.sr3_non ) / 100    ;HBC OK SR NON
    mw[058] = (mi.9.sr2_hov  +  mi.9.sr3_hov ) / 100    ;HBC OK SR HOV
    mw[059] = (mi.9.alone_toll               ) / 100    ;HBC OK DA TOL
    mw[060] = (mi.9.sr2_toll +  mi.9.sr3_toll) / 100    ;HBC OK SR TOL
    
    
    ;transposed HBW OK
    mw[061] = (mi.6.alone_non.T                  ) / 100    ;HBW OK DA NON
    mw[062] = (mi.6.sr2_non.T  +  mi.6.sr3_non.T ) / 100    ;HBW OK SR NON
    mw[063] = (mi.6.sr2_hov.T  +  mi.6.sr3_hov.T ) / 100    ;HBW OK SR HOV
    mw[064] = (mi.6.alone_toll.T                 ) / 100    ;HBW OK DA TOL
    mw[065] = (mi.6.sr2_toll.T +  mi.6.sr3_toll.T) / 100    ;HBW OK SR TOL
    
    ;transposed HBO OK
    mw[066] = (mi.7.alone_non.T                  ) / 100    ;HBO OK DA NON
    mw[067] = (mi.7.sr2_non.T  +  mi.7.sr3_non.T ) / 100    ;HBO OK SR NON
    mw[068] = (mi.7.sr2_hov.T  +  mi.7.sr3_hov.T ) / 100    ;HBO OK SR HOV
    mw[069] = (mi.7.alone_toll.T                 ) / 100    ;HBO OK DA TOL
    mw[070] = (mi.7.sr2_toll.T +  mi.7.sr3_toll.T) / 100    ;HBO OK SR TOL
    
    ;transposed NHB OK                                                    
    mw[071] = (mi.8.alone_non.T                  ) / 100    ;NHB OK DA NON
    mw[072] = (mi.8.sr2_non.T  +  mi.8.sr3_non.T ) / 100    ;NHB OK SR NON
    mw[073] = (mi.8.sr2_hov.T  +  mi.8.sr3_hov.T ) / 100    ;NHB OK SR HOV
    mw[074] = (mi.8.alone_toll.T                 ) / 100    ;NHB OK DA TOL
    mw[075] = (mi.8.sr2_toll.T +  mi.8.sr3_toll.T) / 100    ;NHB OK SR TOL
    
    ;transposed HBC OK                                                    
    mw[076] = (mi.9.alone_non.T                  ) / 100    ;HBC OK DA NON
    mw[077] = (mi.9.sr2_non.T  +  mi.9.sr3_non.T ) / 100    ;HBC OK SR NON
    mw[078] = (mi.9.sr2_hov.T  +  mi.9.sr3_hov.T ) / 100    ;HBC OK SR HOV
    mw[079] = (mi.9.alone_toll.T                 ) / 100    ;HBC OK DA TOL
    mw[080] = (mi.9.sr2_toll.T +  mi.9.sr3_toll.T) / 100    ;HBC OK SR TOL
    
 
    ;external and truck trip matrices
    mw[085] = mi.1.IX
    mw[086] = mi.1.XI
    mw[087] = mi.1.XX
    
    ;transposed external
    mw[088] = mi.1.IX.T
    mw[089] = mi.1.XI.T
    mw[090] = mi.1.XX.T
    
    
    ;truck
    mw[091] = mi.1.SH_LT
    mw[092] = mi.1.SH_MD
    mw[093] = mi.1.SH_HV
    mw[094] = mi.1.Ext_MD
    mw[095] = mi.1.Ext_HV
    
    ;ix/xi truck
    mw[601] = mi.1.IX_MD
    mw[602] = mi.1.XI_MD
    mw[603] = mi.1.XX_MD
    mw[604] = mi.1.IX_HV
    mw[605] = mi.1.XI_HV
    mw[606] = mi.1.XX_HV
    
   ;transposed truck
    mw[096] = mi.1.SH_LT.T
    mw[097] = mi.1.SH_MD.T
    mw[098] = mi.1.SH_HV.T
    mw[099] = mi.1.Ext_MD.T
    mw[100] = mi.1.Ext_HV.T
    
    ;ix/xi truck
    mw[651] = mi.1.IX_MD.T
    mw[652] = mi.1.XI_MD.T
    mw[653] = mi.1.XX_MD.T
    mw[654] = mi.1.IX_HV.T
    mw[655] = mi.1.XI_HV.T
    mw[656] = mi.1.XX_HV.T
    
    ;HBSch_Pr
    mw[911] = mi.10.DriveSelf
    mw[912] = mi.10.DropOff
    mw[913] = mi.10.SchoolBus

    ;HBSch_Sc
    mw[921] = mi.11.DriveSelf
    mw[922] = mi.11.DropOff
    mw[923] = mi.11.SchoolBus
    
    ;Transpose HBSch_Pr
    mw[961] = mi.10.DriveSelf.T
    mw[962] = mi.10.DropOff.T
    mw[963] = mi.10.SchoolBus.T
    
    ;Transpose HBSch_Sc
    mw[971] = mi.11.DriveSelf.T
    mw[972] = mi.11.DropOff.T
    mw[973] = mi.11.SchoolBus.T
    
    
    ;calculate period PA & AP factors for HBW, HBC, BHO & NHB ------------------------------------------------
    ;AM & PM (MC peak = AM + PM)
    _AM_HBW_PA   = Pct_AM_HBW / (Pct_AM_HBW + Pct_PM_HBW)  *  PA_AM_HBW
    _AM_HBO_PA   = Pct_AM_HBO / (Pct_AM_HBO + Pct_PM_HBO)  *  PA_AM_HBO
    _AM_NHB_PA   = Pct_AM_NHB / (Pct_AM_NHB + Pct_PM_NHB)  *  PA_AM_NHB
    _AM_HBC_PA   = Pct_AM_HBC / (Pct_AM_HBC + Pct_PM_HBC)  *  PA_AM_HBC
                                                                    
    _AM_HBW_AP   = Pct_AM_HBW / (Pct_AM_HBW + Pct_PM_HBW)  *  (1 - PA_AM_HBW)
    _AM_HBO_AP   = Pct_AM_HBO / (Pct_AM_HBO + Pct_PM_HBO)  *  (1 - PA_AM_HBO)
    _AM_NHB_AP   = Pct_AM_NHB / (Pct_AM_NHB + Pct_PM_NHB)  *  (1 - PA_AM_NHB)
    _AM_HBC_AP   = Pct_AM_HBC / (Pct_AM_HBC + Pct_PM_HBC)  *  (1 - PA_AM_HBC)
                                                                    
    _PM_HBW_PA   = Pct_PM_HBW / (Pct_AM_HBW + Pct_PM_HBW)  *  PA_PM_HBW
    _PM_HBO_PA   = Pct_PM_HBO / (Pct_AM_HBO + Pct_PM_HBO)  *  PA_PM_HBO
    _PM_NHB_PA   = Pct_PM_NHB / (Pct_AM_NHB + Pct_PM_NHB)  *  PA_PM_NHB
    _PM_HBC_PA   = Pct_PM_HBC / (Pct_AM_HBC + Pct_PM_HBC)  *  PA_PM_HBC
                                                              
    _PM_HBW_AP   = Pct_PM_HBW / (Pct_AM_HBW + Pct_PM_HBW)  *  (1 - PA_PM_HBW)
    _PM_HBO_AP   = Pct_PM_HBO / (Pct_AM_HBO + Pct_PM_HBO)  *  (1 - PA_PM_HBO)
    _PM_NHB_AP   = Pct_PM_NHB / (Pct_AM_NHB + Pct_PM_NHB)  *  (1 - PA_PM_NHB)
    _PM_HBC_AP   = Pct_PM_HBC / (Pct_AM_HBC + Pct_PM_HBC)  *  (1 - PA_PM_HBC)
    
    ;MD & EV (MC off peak = MD + EV)
    _MD_HBW_PA   = Pct_MD_HBW / (Pct_MD_HBW + Pct_EV_HBW)  *  PA_MD_HBW
    _MD_HBO_PA   = Pct_MD_HBO / (Pct_MD_HBO + Pct_EV_HBO)  *  PA_MD_HBO
    _MD_NHB_PA   = Pct_MD_NHB / (Pct_MD_NHB + Pct_EV_NHB)  *  PA_MD_NHB
    _MD_HBC_PA   = Pct_MD_HBC / (Pct_MD_HBC + Pct_EV_HBC)  *  PA_MD_HBC
    
    _MD_HBW_AP   = Pct_MD_HBW / (Pct_MD_HBW + Pct_EV_HBW)  *  (1 - PA_MD_HBW)
    _MD_HBO_AP   = Pct_MD_HBO / (Pct_MD_HBO + Pct_EV_HBO)  *  (1 - PA_MD_HBO)
    _MD_NHB_AP   = Pct_MD_NHB / (Pct_MD_NHB + Pct_EV_NHB)  *  (1 - PA_MD_NHB)
    _MD_HBC_AP   = Pct_MD_HBC / (Pct_MD_HBC + Pct_EV_HBC)  *  (1 - PA_MD_HBC)
                                                                    
    _EV_HBW_PA   = Pct_EV_HBW / (Pct_MD_HBW + Pct_EV_HBW)  *  PA_EV_HBW
    _EV_HBO_PA   = Pct_EV_HBO / (Pct_MD_HBO + Pct_EV_HBO)  *  PA_EV_HBO
    _EV_NHB_PA   = Pct_EV_NHB / (Pct_MD_NHB + Pct_EV_NHB)  *  PA_EV_NHB
    _EV_HBC_PA   = Pct_EV_HBC / (Pct_MD_HBC + Pct_EV_HBC)  *  PA_EV_HBC
                                                            
    _EV_HBW_AP   = Pct_EV_HBW / (Pct_MD_HBW + Pct_EV_HBW)  *  (1 - PA_EV_HBW)
    _EV_HBO_AP   = Pct_EV_HBO / (Pct_MD_HBO + Pct_EV_HBO)  *  (1 - PA_EV_HBO)
    _EV_NHB_AP   = Pct_EV_NHB / (Pct_MD_NHB + Pct_EV_NHB)  *  (1 - PA_EV_NHB)
    _EV_HBC_AP   = Pct_EV_HBC / (Pct_MD_HBC + Pct_EV_HBC)  *  (1 - PA_EV_HBC)
    
    
    ;calculate PA & AP factors for HBSch, LT, MD, HV, externals & external MD/HV trucks
    ;HBSch
    _AM_HBSch_PA = Pct_AM_HBS * PA_AM_HBS
    _MD_HBSch_PA = Pct_MD_HBS * PA_MD_HBS
    _PM_HBSch_PA = Pct_PM_HBS * PA_PM_HBS
    _EV_HBSch_PA = Pct_EV_HBS * PA_EV_HBS
    
    _AM_HBSch_AP = Pct_AM_HBS * (1 - PA_AM_HBS)
    _MD_HBSch_AP = Pct_MD_HBS * (1 - PA_MD_HBS)
    _PM_HBSch_AP = Pct_PM_HBS * (1 - PA_PM_HBS)
    _EV_HBSch_AP = Pct_EV_HBS * (1 - PA_EV_HBS)
    
    ;LT
    _AM_LT_PA = Pct_AM_LT * PA_AM_LT
    _MD_LT_PA = Pct_MD_LT * PA_MD_LT
    _PM_LT_PA = Pct_PM_LT * PA_PM_LT
    _EV_LT_PA = Pct_EV_LT * PA_EV_LT
    
    _AM_LT_AP = Pct_AM_LT * (1 - PA_AM_LT)
    _MD_LT_AP = Pct_MD_LT * (1 - PA_MD_LT)
    _PM_LT_AP = Pct_PM_LT * (1 - PA_PM_LT)
    _EV_LT_AP = Pct_EV_LT * (1 - PA_EV_LT)
    
    ;MD
    _AM_MD_PA = Pct_AM_MD * PA_AM_MD
    _MD_MD_PA = Pct_MD_MD * PA_MD_MD
    _PM_MD_PA = Pct_PM_MD * PA_PM_MD
    _EV_MD_PA = Pct_EV_MD * PA_EV_MD
    
    _AM_MD_AP = Pct_AM_MD * (1 - PA_AM_MD)
    _MD_MD_AP = Pct_MD_MD * (1 - PA_MD_MD)
    _PM_MD_AP = Pct_PM_MD * (1 - PA_PM_MD)
    _EV_MD_AP = Pct_EV_MD * (1 - PA_EV_MD)
    
    ;HV
    _AM_HV_PA = Pct_AM_HV * PA_AM_HV
    _MD_HV_PA = Pct_MD_HV * PA_MD_HV
    _PM_HV_PA = Pct_PM_HV * PA_PM_HV
    _EV_HV_PA = Pct_EV_HV * PA_EV_HV
    
    _AM_HV_AP = Pct_AM_HV * (1 - PA_AM_HV)
    _MD_HV_AP = Pct_MD_HV * (1 - PA_MD_HV)
    _PM_HV_AP = Pct_PM_HV * (1 - PA_PM_HV)
    _EV_HV_AP = Pct_EV_HV * (1 - PA_EV_HV)
    
    
    
    ;calc OD trips -------------------------------------------------------------------------------------------
    
    JLOOP

        ;HBW is outside of II / IXXIXX if statement because some XI trips have been converted to HBW trips

        ;AM
        mw[101] = mw[001] * _AM_HBW_PA      ;HBW PK DA NON      ;use peak matrices
        mw[102] = mw[002] * _AM_HBW_PA      ;HBW PK SR NON
        mw[103] = mw[003] * _AM_HBW_PA      ;HBW PK SR HOV
        mw[104] = mw[004] * _AM_HBW_PA      ;HBW PK DA TOL
        mw[105] = mw[005] * _AM_HBW_PA      ;HBW PK SR TOL

        mw[151] = mw[021] * _AM_HBW_AP      ;HBW PK DA NON      ;use inverted peak matrices
        mw[152] = mw[022] * _AM_HBW_AP      ;HBW PK SR NON
        mw[153] = mw[023] * _AM_HBW_AP      ;HBW PK SR HOV
        mw[154] = mw[024] * _AM_HBW_AP      ;HBW PK DA TOL
        mw[155] = mw[025] * _AM_HBW_AP      ;HBW PK SR TOL

        ;MD
        mw[201] = mw[041] * _MD_HBW_PA      ;HBW PK DA NON      ;use off-peak matrices
        mw[202] = mw[042] * _MD_HBW_PA      ;HBW PK SR NON
        mw[203] = mw[043] * _MD_HBW_PA      ;HBW PK SR HOV
        mw[204] = mw[044] * _MD_HBW_PA      ;HBW PK DA TOL
        mw[205] = mw[045] * _MD_HBW_PA      ;HBW PK SR TOL

        mw[251] = mw[061] * _MD_HBW_AP      ;HBW PK DA NON      ;use inverted off-peak matrices
        mw[252] = mw[062] * _MD_HBW_AP      ;HBW PK SR NON
        mw[253] = mw[063] * _MD_HBW_AP      ;HBW PK SR HOV
        mw[254] = mw[064] * _MD_HBW_AP      ;HBW PK DA TOL
        mw[255] = mw[065] * _MD_HBW_AP      ;HBW PK SR TOL
        
        ;PM
        mw[301] = mw[001] * _PM_HBW_PA      ;HBW PK DA NON      ;use peak matrices
        mw[302] = mw[002] * _PM_HBW_PA      ;HBW PK SR NON
        mw[303] = mw[003] * _PM_HBW_PA      ;HBW PK SR HOV
        mw[304] = mw[004] * _PM_HBW_PA      ;HBW PK DA TOL
        mw[305] = mw[005] * _PM_HBW_PA      ;HBW PK SR TOL

        mw[351] = mw[021] * _PM_HBW_AP      ;HBW PK DA NON      ;use inverted peak matrices
        mw[352] = mw[022] * _PM_HBW_AP      ;HBW PK SR NON
        mw[353] = mw[023] * _PM_HBW_AP      ;HBW PK SR HOV
        mw[354] = mw[024] * _PM_HBW_AP      ;HBW PK DA TOL
        mw[355] = mw[025] * _PM_HBW_AP      ;HBW PK SR TOL

        ;EV
        mw[401] = mw[041] * _EV_HBW_PA      ;HBW PK DA NON      ;use off-peak matrices
        mw[402] = mw[042] * _EV_HBW_PA      ;HBW PK SR NON
        mw[403] = mw[043] * _EV_HBW_PA      ;HBW PK SR HOV
        mw[404] = mw[044] * _EV_HBW_PA      ;HBW PK DA TOL
        mw[405] = mw[045] * _EV_HBW_PA      ;HBW PK SR TOL

        mw[451] = mw[061] * _EV_HBW_AP      ;HBW PK DA NON      ;use inverted off-peak matrices
        mw[452] = mw[062] * _EV_HBW_AP      ;HBW PK SR NON
        mw[453] = mw[063] * _EV_HBW_AP      ;HBW PK SR HOV
        mw[454] = mw[064] * _EV_HBW_AP      ;HBW PK DA TOL
        mw[455] = mw[065] * _EV_HBW_AP      ;HBW PK SR TOL

        
        ;II
        if (!(i=@externalzones@) & !(j=@externalzones@))
            
            ;AM
            mw[106] = mw[006] * _AM_HBO_PA      ;HBO PK DA NON
            mw[107] = mw[007] * _AM_HBO_PA      ;HBO PK SR NON
            mw[108] = mw[008] * _AM_HBO_PA      ;HBO PK SR HOV
            mw[109] = mw[009] * _AM_HBO_PA      ;HBO PK DA TOL
            mw[110] = mw[010] * _AM_HBO_PA      ;HBO PK SR TOL
            
            mw[156] = mw[026] * _AM_HBO_AP      ;HBO PK DA NON inverted
            mw[157] = mw[027] * _AM_HBO_AP      ;HBO PK SR NON inverted
            mw[158] = mw[028] * _AM_HBO_AP      ;HBO PK SR HOV inverted
            mw[159] = mw[029] * _AM_HBO_AP      ;HBO PK DA TOL inverted
            mw[160] = mw[030] * _AM_HBO_AP      ;HBO PK SR TOL inverted
            
            mw[111] = mw[011] * _AM_NHB_PA      ;NHB PK DA NON
            mw[112] = mw[012] * _AM_NHB_PA      ;NHB PK SR NON
            mw[113] = mw[013] * _AM_NHB_PA      ;NHB PK SR HOV
            mw[114] = mw[014] * _AM_NHB_PA      ;NHB PK DA TOL
            mw[115] = mw[015] * _AM_NHB_PA      ;NHB PK SR TOL

            mw[161] = mw[031] * _AM_NHB_AP      ;NHB PK DA NON inverted
            mw[162] = mw[032] * _AM_NHB_AP      ;NHB PK SR NON inverted
            mw[163] = mw[033] * _AM_NHB_AP      ;NHB PK SR HOV inverted
            mw[164] = mw[034] * _AM_NHB_AP      ;NHB PK DA TOL inverted
            mw[165] = mw[035] * _AM_NHB_AP      ;NHB PK SR TOL inverted
            
            mw[116] = mw[016] * _AM_HBC_PA      ;HBC PK DA NON
            mw[117] = mw[017] * _AM_HBC_PA      ;HBC PK SR NON
            mw[118] = mw[018] * _AM_HBC_PA      ;HBC PK SR HOV
            mw[119] = mw[019] * _AM_HBC_PA      ;HBC PK DA TOL
            mw[120] = mw[020] * _AM_HBC_PA      ;HBC PK SR TOL

            mw[166] = mw[036] * _AM_HBC_AP      ;HBC PK DA NON inverted
            mw[167] = mw[037] * _AM_HBC_AP      ;HBC PK SR NON inverted
            mw[168] = mw[038] * _AM_HBC_AP      ;HBC PK SR HOV inverted
            mw[169] = mw[039] * _AM_HBC_AP      ;HBC PK DA TOL inverted
            mw[170] = mw[040] * _AM_HBC_AP      ;HBC PK SR TOL inverted
            
            ;HBSch trips are evaluated from the perspective of the student trip (i.e. PA & AP when based on student trip pattern).
            ;  Drop-off/pick-up trips require two trips per student trip, processing these is slightly different than drive-self trips.
            mw[121] = mw[911]             * _AM_HBSch_PA    ;HBS_DriveSelf_Pr
            mw[122] = mw[921]             * _AM_HBSch_PA    ;HBS_DriveSelf_Sc
            mw[131] = (mw[912] + mw[962]) * _AM_HBSch_PA    ;HBS_DropOff_Pr
            mw[132] = (mw[922] + mw[972]) * _AM_HBSch_PA    ;HBS_DropOff_Sc
            mw[133] = mw[913]             * _AM_HBSch_PA    ;HBS_Pr - school bus
            mw[134] = mw[923]             * _AM_HBSch_PA    ;HBS_Sc - school bus

            mw[171] = mw[961]             * _AM_HBSch_AP    ;HBS_DriveSelf_Pr
            mw[172] = mw[971]             * _AM_HBSch_AP    ;HBS_DriveSelf_Sc
            mw[181] = (mw[912] + mw[962]) * _AM_HBSch_AP    ;HBS_DropOff_Pr
            mw[182] = (mw[922] + mw[972]) * _AM_HBSch_AP    ;HBS_DropOff_Sc
            mw[183] = mw[963]             * _AM_HBSch_AP    ;HBS_Pr - school bus
            mw[184] = mw[973]             * _AM_HBSch_AP    ;HBS_Sc - school bus
            
            mw[126] = mw[091] * _AM_LT_PA       ;SH_LT

            mw[176] = mw[096] * _AM_LT_AP       ;SH_LT inverted
            
            mw[127] = mw[092] * _AM_MD_PA       ;SH_MD 

            mw[177] = mw[097] * _AM_MD_AP       ;SH_MD inverted
            
            mw[128] = mw[093] * _AM_HV_PA       ;SH_HV

            mw[178] = mw[098] * _AM_HV_AP       ;SH_HV inverted
            

            ;MD
            mw[206] = mw[046] * _MD_HBO_PA      ;HBO PK DA NON
            mw[207] = mw[047] * _MD_HBO_PA      ;HBO PK SR NON
            mw[208] = mw[048] * _MD_HBO_PA      ;HBO PK SR HOV
            mw[209] = mw[049] * _MD_HBO_PA      ;HBO PK DA TOL
            mw[210] = mw[050] * _MD_HBO_PA      ;HBO PK SR TOL
            
            mw[256] = mw[066] * _MD_HBO_AP      ;HBO PK DA NON inverted
            mw[257] = mw[067] * _MD_HBO_AP      ;HBO PK SR NON inverted
            mw[258] = mw[068] * _MD_HBO_AP      ;HBO PK SR HOV inverted
            mw[259] = mw[069] * _MD_HBO_AP      ;HBO PK DA TOL inverted
            mw[260] = mw[070] * _MD_HBO_AP      ;HBO PK SR TOL inverted
            
            mw[211] = mw[051] * _MD_NHB_PA      ;NHB PK DA NON
            mw[212] = mw[052] * _MD_NHB_PA      ;NHB PK SR NON
            mw[213] = mw[053] * _MD_NHB_PA      ;NHB PK SR HOV
            mw[214] = mw[054] * _MD_NHB_PA      ;NHB PK DA TOL
            mw[215] = mw[055] * _MD_NHB_PA      ;NHB PK SR TOL

            mw[261] = mw[071] * _MD_NHB_AP      ;NHB PK DA NON inverted
            mw[262] = mw[072] * _MD_NHB_AP      ;NHB PK SR NON inverted
            mw[263] = mw[073] * _MD_NHB_AP      ;NHB PK SR HOV inverted
            mw[264] = mw[074] * _MD_NHB_AP      ;NHB PK DA TOL inverted
            mw[265] = mw[075] * _MD_NHB_AP      ;NHB PK SR TOL inverted
            
            mw[216] = mw[056] * _MD_HBC_PA      ;HBC PK DA NON
            mw[217] = mw[057] * _MD_HBC_PA      ;HBC PK SR NON
            mw[218] = mw[058] * _MD_HBC_PA      ;HBC PK SR HOV
            mw[219] = mw[059] * _MD_HBC_PA      ;HBC PK DA TOL
            mw[220] = mw[060] * _MD_HBC_PA      ;HBC PK SR TOL

            mw[266] = mw[076] * _MD_HBC_AP      ;HBC PK DA NON inverted
            mw[267] = mw[077] * _MD_HBC_AP      ;HBC PK SR NON inverted
            mw[268] = mw[078] * _MD_HBC_AP      ;HBC PK SR HOV inverted
            mw[269] = mw[079] * _MD_HBC_AP      ;HBC PK DA TOL inverted
            mw[270] = mw[080] * _MD_HBC_AP      ;HBC PK SR TOL inverted
            
            ;HBSch trips are evaluated from the perspective of the student trip (i.e. PA & AP when based on student trip pattern).
            ;  Drop-off/pick-up trips require two trips per student trip, processing these is slightly different than drive-self trips.
            mw[221] = mw[911]             * _MD_HBSch_PA    ;HBS_DriveSelf_Pr
            mw[222] = mw[921]             * _MD_HBSch_PA    ;HBS_DriveSelf_Sc
            mw[231] = (mw[912] + mw[962]) * _MD_HBSch_PA    ;HBS_DropOff_Pr
            mw[232] = (mw[922] + mw[972]) * _MD_HBSch_PA    ;HBS_DropOff_Sc
            mw[233] = mw[913]             * _MD_HBSch_PA    ;HBS_Pr - school bus
            mw[234] = mw[923]             * _MD_HBSch_PA    ;HBS_Sc - school bus

            mw[271] = mw[961]             * _MD_HBSch_AP    ;HBS_DriveSelf_Pr
            mw[272] = mw[971]             * _MD_HBSch_AP    ;HBS_DriveSelf_Sc
            mw[281] = (mw[912] + mw[962]) * _MD_HBSch_AP    ;HBS_DropOff_Pr
            mw[282] = (mw[922] + mw[972]) * _MD_HBSch_AP    ;HBS_DropOff_Sc
            mw[283] = mw[963]             * _MD_HBSch_AP    ;HBS_Pr - school bus
            mw[284] = mw[973]             * _MD_HBSch_AP    ;HBS_Sc - school bus
            
            mw[226] = mw[091] * _MD_LT_PA       ;SH_LT

            mw[276] = mw[096] * _MD_LT_AP       ;SH_LT inverted
            
            mw[227] = mw[092] * _MD_MD_PA       ;SH_MD 

            mw[277] = mw[097] * _MD_MD_AP       ;SH_MD inverted
            
            mw[228] = mw[093] * _MD_HV_PA       ;SH_HV

            mw[278] = mw[098] * _MD_HV_AP       ;SH_HV inverted
            
            
            ;PM
            mw[306] = mw[006] * _PM_HBO_PA      ;HBO PK DA NON
            mw[307] = mw[007] * _PM_HBO_PA      ;HBO PK SR NON
            mw[308] = mw[008] * _PM_HBO_PA      ;HBO PK SR HOV
            mw[309] = mw[009] * _PM_HBO_PA      ;HBO PK DA TOL
            mw[310] = mw[010] * _PM_HBO_PA      ;HBO PK SR TOL
            
            mw[356] = mw[026] * _PM_HBO_AP      ;HBO PK DA NON inverted
            mw[357] = mw[027] * _PM_HBO_AP      ;HBO PK SR NON inverted
            mw[358] = mw[028] * _PM_HBO_AP      ;HBO PK SR HOV inverted
            mw[359] = mw[029] * _PM_HBO_AP      ;HBO PK DA TOL inverted
            mw[360] = mw[030] * _PM_HBO_AP      ;HBO PK SR TOL inverted
            
            mw[311] = mw[011] * _PM_NHB_PA      ;NHB PK DA NON
            mw[312] = mw[012] * _PM_NHB_PA      ;NHB PK SR NON
            mw[313] = mw[013] * _PM_NHB_PA      ;NHB PK SR HOV
            mw[314] = mw[014] * _PM_NHB_PA      ;NHB PK DA TOL
            mw[315] = mw[015] * _PM_NHB_PA      ;NHB PK SR TOL

            mw[361] = mw[031] * _PM_NHB_AP      ;NHB PK DA NON inverted
            mw[362] = mw[032] * _PM_NHB_AP      ;NHB PK SR NON inverted
            mw[363] = mw[033] * _PM_NHB_AP      ;NHB PK SR HOV inverted
            mw[364] = mw[034] * _PM_NHB_AP      ;NHB PK DA TOL inverted
            mw[365] = mw[035] * _PM_NHB_AP      ;NHB PK SR TOL inverted
            
            mw[316] = mw[016] * _PM_HBC_PA      ;HBC PK DA NON
            mw[317] = mw[017] * _PM_HBC_PA      ;HBC PK SR NON
            mw[318] = mw[018] * _PM_HBC_PA      ;HBC PK SR HOV
            mw[319] = mw[019] * _PM_HBC_PA      ;HBC PK DA TOL
            mw[320] = mw[020] * _PM_HBC_PA      ;HBC PK SR TOL

            mw[366] = mw[036] * _PM_HBC_AP      ;HBC PK DA NON inverted
            mw[367] = mw[037] * _PM_HBC_AP      ;HBC PK SR NON inverted
            mw[368] = mw[038] * _PM_HBC_AP      ;HBC PK SR HOV inverted
            mw[369] = mw[039] * _PM_HBC_AP      ;HBC PK DA TOL inverted
            mw[370] = mw[040] * _PM_HBC_AP      ;HBC PK SR TOL inverted
            
            ;HBSch trips are evaluated from the perspective of the student trip (i.e. PA & AP when based on student trip pattern).
            ;  Drop-off/pick-up trips require two trips per student trip, processing these is slightly different than drive-self trips.
            mw[321] = mw[911]             * _PM_HBSch_PA    ;HBS_DriveSelf_Pr
            mw[322] = mw[921]             * _PM_HBSch_PA    ;HBS_DriveSelf_Sc
            mw[331] = (mw[912] + mw[962]) * _PM_HBSch_PA    ;HBS_DropOff_Pr
            mw[332] = (mw[922] + mw[972]) * _PM_HBSch_PA    ;HBS_DropOff_Sc
            mw[333] = mw[913]             * _PM_HBSch_PA    ;HBS_Pr - school bus
            mw[334] = mw[923]             * _PM_HBSch_PA    ;HBS_Sc - school bus

            mw[371] = mw[961]             * _PM_HBSch_AP    ;HBS_DriveSelf_Pr
            mw[372] = mw[971]             * _PM_HBSch_AP    ;HBS_DriveSelf_Sc
            mw[381] = (mw[912] + mw[962]) * _PM_HBSch_AP    ;HBS_DropOff_Pr
            mw[382] = (mw[922] + mw[972]) * _PM_HBSch_AP    ;HBS_DropOff_Sc
            mw[383] = mw[963]             * _PM_HBSch_AP    ;HBS_Pr - school bus
            mw[384] = mw[973]             * _PM_HBSch_AP    ;HBS_Sc - school bus
            
            mw[326] = mw[091] * _PM_LT_PA       ;SH_LT

            mw[376] = mw[096] * _PM_LT_AP       ;SH_LT inverted
            
            mw[327] = mw[092] * _PM_MD_PA       ;SH_MD 

            mw[377] = mw[097] * _PM_MD_AP       ;SH_MD inverted
            
            mw[328] = mw[093] * _PM_HV_PA       ;SH_HV

            mw[378] = mw[098] * _PM_HV_AP       ;SH_HV inverted
                                                                                       
                                                                                       
            ;EV
            mw[406] = mw[046] * _EV_HBO_PA      ;HBO PK DA NON
            mw[407] = mw[047] * _EV_HBO_PA      ;HBO PK SR NON
            mw[408] = mw[048] * _EV_HBO_PA      ;HBO PK SR HOV
            mw[409] = mw[049] * _EV_HBO_PA      ;HBO PK DA TOL
            mw[410] = mw[050] * _EV_HBO_PA      ;HBO PK SR TOL
            
            mw[456] = mw[066] * _EV_HBO_AP      ;HBO PK DA NON inverted
            mw[457] = mw[067] * _EV_HBO_AP      ;HBO PK SR NON inverted
            mw[458] = mw[068] * _EV_HBO_AP      ;HBO PK SR HOV inverted
            mw[459] = mw[069] * _EV_HBO_AP      ;HBO PK DA TOL inverted
            mw[460] = mw[070] * _EV_HBO_AP      ;HBO PK SR TOL inverted
            
            mw[411] = mw[051] * _EV_NHB_PA      ;NHB PK DA NON
            mw[412] = mw[052] * _EV_NHB_PA      ;NHB PK SR NON
            mw[413] = mw[053] * _EV_NHB_PA      ;NHB PK SR HOV
            mw[414] = mw[054] * _EV_NHB_PA      ;NHB PK DA TOL
            mw[415] = mw[055] * _EV_NHB_PA      ;NHB PK SR TOL

            mw[461] = mw[071] * _EV_NHB_AP      ;NHB PK DA NON inverted
            mw[462] = mw[072] * _EV_NHB_AP      ;NHB PK SR NON inverted
            mw[463] = mw[073] * _EV_NHB_AP      ;NHB PK SR HOV inverted
            mw[464] = mw[074] * _EV_NHB_AP      ;NHB PK DA TOL inverted
            mw[465] = mw[075] * _EV_NHB_AP      ;NHB PK SR TOL inverted
            
            mw[416] = mw[056] * _EV_HBC_PA      ;HBC PK DA NON
            mw[417] = mw[057] * _EV_HBC_PA      ;HBC PK SR NON
            mw[418] = mw[058] * _EV_HBC_PA      ;HBC PK SR HOV
            mw[419] = mw[059] * _EV_HBC_PA      ;HBC PK DA TOL
            mw[420] = mw[060] * _EV_HBC_PA      ;HBC PK SR TOL

            mw[466] = mw[076] * _EV_HBC_AP      ;HBC PK DA NON inverted
            mw[467] = mw[077] * _EV_HBC_AP      ;HBC PK SR NON inverted
            mw[468] = mw[078] * _EV_HBC_AP      ;HBC PK SR HOV inverted
            mw[469] = mw[079] * _EV_HBC_AP      ;HBC PK DA TOL inverted
            mw[470] = mw[080] * _EV_HBC_AP      ;HBC PK SR TOL inverted
            
            ;HBSch trips are evaluated from the perspective of the student trip (i.e. PA & AP when based on student trip pattern).
            ;  Drop-off/pick-up trips require two trips per student trip, processing these is slightly different than drive-self trips.
            mw[421] = mw[911]             * _EV_HBSch_PA    ;HBS_DriveSelf_Pr
            mw[422] = mw[921]             * _EV_HBSch_PA    ;HBS_DriveSelf_Sc
            mw[431] = (mw[912] + mw[962]) * _EV_HBSch_PA    ;HBS_DropOff_Pr
            mw[432] = (mw[922] + mw[972]) * _EV_HBSch_PA    ;HBS_DropOff_Sc
            mw[433] = mw[913]             * _EV_HBSch_PA    ;HBS_Pr - school bus
            mw[434] = mw[923]             * _EV_HBSch_PA    ;HBS_Sc - school bus

            mw[471] = mw[961]             * _EV_HBSch_AP    ;HBS_DriveSelf_Pr
            mw[472] = mw[971]             * _EV_HBSch_AP    ;HBS_DriveSelf_Sc
            mw[481] = (mw[912] + mw[962]) * _EV_HBSch_AP    ;HBS_DropOff_Pr
            mw[482] = (mw[922] + mw[972]) * _EV_HBSch_AP    ;HBS_DropOff_Sc
            mw[483] = mw[963]             * _EV_HBSch_AP    ;HBS_Pr - school bus
            mw[484] = mw[973]             * _EV_HBSch_AP    ;HBS_Sc - school bus
            
            mw[426] = mw[091] * _EV_LT_PA       ;SH_LT

            mw[476] = mw[096] * _EV_LT_AP       ;SH_LT inverted
            
            mw[427] = mw[092] * _EV_MD_PA       ;SH_MD 

            mw[477] = mw[097] * _EV_MD_AP       ;SH_MD inverted
            
            mw[428] = mw[093] * _EV_HV_PA       ;SH_HV

            mw[478] = mw[098] * _EV_HV_AP       ;SH_HV inverted
            
            
        ;IX, XI & XX
        else    
            
            ;AM
            mw[123]  =  mw[085] * Pct_AM_IX    * PA_AM_IX             ;IX
            mw[124]  =  mw[086] * Pct_AM_XI    * PA_AM_XI             ;XI
            mw[125]  =  mw[087] * Pct_AM_XX    * PA_AM_XX             ;XX
            
            mw[173]  =  mw[088] * Pct_AM_IX    * (1 - PA_AM_IX   )    ;IX inverted
            mw[174]  =  mw[089] * Pct_AM_XI    * (1 - PA_AM_XI   )    ;XI inverted
            mw[175]  =  mw[090] * Pct_AM_XX    * (1 - PA_AM_XX   )    ;XX inverted

            mw[701]  =  mw[601] * Pct_AM_IX_MD * PA_AM_IX_MD          ;Ext_MD
            mw[702]  =  mw[602] * Pct_AM_XI_MD * PA_AM_XI_MD          ;Ext_MD
            mw[703]  =  mw[603] * Pct_AM_XX_MD * PA_AM_XX_MD          ;Ext_MD

            mw[751]  =  mw[651] * Pct_AM_IX_MD * (1 - PA_AM_IX_MD)    ;Ext_MD inverted
            mw[752]  =  mw[652] * Pct_AM_XI_MD * (1 - PA_AM_XI_MD)    ;Ext_MD inverted
            mw[753]  =  mw[653] * Pct_AM_XX_MD * (1 - PA_AM_XX_MD)    ;Ext_MD inverted

            mw[704]  =  mw[604] * Pct_AM_IX_HV * PA_AM_IX_HV          ;Ext_HV
            mw[705]  =  mw[605] * Pct_AM_XI_HV * PA_AM_XI_HV          ;Ext_HV
            mw[706]  =  mw[606] * Pct_AM_XX_HV * PA_AM_XX_HV          ;Ext_HV

            mw[754]  =  mw[654] * Pct_AM_IX_HV * (1 - PA_AM_IX_HV)    ;Ext_HV inverted
            mw[755]  =  mw[655] * Pct_AM_XI_HV * (1 - PA_AM_XI_HV)    ;Ext_HV inverted
            mw[756]  =  mw[656] * Pct_AM_XX_HV * (1 - PA_AM_XX_HV)    ;Ext_HV inverted
            
            mw[129]  =  mw[701] +    ;Ext_MD
                        mw[702] +
                        mw[703] 
            
            mw[179]  =  mw[751] +    ;Ext_MD inverted
                        mw[752] +
                        mw[753] 
            
            mw[130]  =  mw[704] +    ;Ext_HV
                        mw[705] +
                        mw[706] 
            
            mw[180]  =  mw[754] +    ;Ext_HV inverted
                        mw[755] +
                        mw[756] 

            ;MD
            mw[223]  =  mw[085] * Pct_MD_IX    * PA_MD_IX             ;IX
            mw[224]  =  mw[086] * Pct_MD_XI    * PA_MD_XI             ;XI
            mw[225]  =  mw[087] * Pct_MD_XX    * PA_MD_XX             ;XX

            mw[273]  =  mw[088] * Pct_MD_IX    * (1 - PA_MD_IX   )    ;IX inverted
            mw[274]  =  mw[089] * Pct_MD_XI    * (1 - PA_MD_XI   )    ;XI inverted
            mw[275]  =  mw[090] * Pct_MD_XX    * (1 - PA_MD_XX   )    ;XX inverted

            mw[711]  =  mw[601] * Pct_MD_IX_MD * PA_MD_IX_MD          ;Ext_MD
            mw[712]  =  mw[602] * Pct_MD_XI_MD * PA_MD_XI_MD          ;Ext_MD
            mw[713]  =  mw[603] * Pct_MD_XX_MD * PA_MD_XX_MD          ;Ext_MD

            mw[761]  = mw[651] * Pct_MD_IX_MD * (1 - PA_MD_IX_MD)     ;Ext_MD inverted
            mw[762]  = mw[652] * Pct_MD_XI_MD * (1 - PA_MD_XI_MD)     ;Ext_MD inverted
            mw[763]  = mw[653] * Pct_MD_XX_MD * (1 - PA_MD_XX_MD)     ;Ext_MD inverted

            mw[714]  =  mw[604] * Pct_MD_IX_HV * PA_MD_IX_HV          ;Ext_HV
            mw[715]  =  mw[605] * Pct_MD_XI_HV * PA_MD_XI_HV          ;Ext_HV
            mw[716]  =  mw[606] * Pct_MD_XX_HV * PA_MD_XX_HV          ;Ext_HV

            mw[764]  =  mw[654] * Pct_MD_IX_HV * (1 - PA_MD_IX_HV)    ;Ext_HV inverted
            mw[765]  =  mw[655] * Pct_MD_XI_HV * (1 - PA_MD_XI_HV)    ;Ext_HV inverted
            mw[766]  =  mw[656] * Pct_MD_XX_HV * (1 - PA_MD_XX_HV)    ;Ext_HV inverted
            
            mw[229]  =  mw[711] +    ;Ext_MD
                        mw[712] +
                        mw[713] 
            
            mw[279]  =  mw[761] +    ;Ext_MD inverted
                        mw[762] +
                        mw[763] 
            
            mw[230]  =  mw[714] +    ;Ext_HV
                        mw[715] +
                        mw[716] 
            
            mw[280]  =  mw[764] +    ;Ext_HV inverted
                        mw[765] +
                        mw[766] 


            ;PM
            mw[323]  =  mw[085] * Pct_PM_IX    * PA_PM_IX             ;IX
            mw[324]  =  mw[086] * Pct_PM_XI    * PA_PM_XI             ;XI
            mw[325]  =  mw[087] * Pct_PM_XX    * PA_PM_XX             ;XX

            mw[373]  =  mw[088] * Pct_PM_IX    * (1 - PA_PM_IX   )    ;IX inverted
            mw[374]  =  mw[089] * Pct_PM_XI    * (1 - PA_PM_XI   )    ;XI inverted
            mw[375]  =  mw[090] * Pct_PM_XX    * (1 - PA_PM_XX   )    ;XX inverted

            mw[721]  =  mw[601] * Pct_PM_IX_MD * PA_PM_IX_MD          ;Ext_MD
            mw[722]  =  mw[602] * Pct_PM_XI_MD * PA_PM_XI_MD          ;Ext_MD
            mw[723]  =  mw[603] * Pct_PM_XX_MD * PA_PM_XX_MD          ;Ext_MD

            mw[771]  =  mw[651] * Pct_PM_IX_MD * (1 - PA_PM_IX_MD)    ;Ext_MD inverted
            mw[772]  =  mw[652] * Pct_PM_XI_MD * (1 - PA_PM_XI_MD)    ;Ext_MD inverted
            mw[773]  =  mw[653] * Pct_PM_XX_MD * (1 - PA_PM_XX_MD)    ;Ext_MD inverted

            mw[724]  =  mw[604] * Pct_PM_IX_HV * PA_PM_IX_HV          ;Ext_HV
            mw[725]  =  mw[605] * Pct_PM_XI_HV * PA_PM_XI_HV          ;Ext_HV
            mw[726]  =  mw[606] * Pct_PM_XX_HV * PA_PM_XX_HV          ;Ext_HV

            mw[774]  =  mw[654] * Pct_PM_IX_HV * (1 - PA_PM_IX_HV)    ;Ext_HV inverted
            mw[775]  =  mw[655] * Pct_PM_XI_HV * (1 - PA_PM_XI_HV)    ;Ext_HV inverted
            mw[776]  =  mw[656] * Pct_PM_XX_HV * (1 - PA_PM_XX_HV)    ;Ext_HV inverted
            
            mw[329]  =  mw[721] +    ;Ext_MD
                        mw[722] +
                        mw[723] 
            
            mw[379]  =  mw[771] +    ;Ext_MD inverted
                        mw[772] +
                        mw[773] 
            
            mw[330]  =  mw[724] +    ;Ext_HV
                        mw[725] +
                        mw[726] 
            
            mw[380]  =  mw[774] +    ;Ext_HV inverted
                        mw[775] +
                        mw[776] 


            ;EV
            mw[423]  =  mw[085] * Pct_EV_IX    * PA_EV_IX             ;IX
            mw[424]  =  mw[086] * Pct_EV_XI    * PA_EV_XI             ;XI
            mw[425]  =  mw[087] * Pct_EV_XX    * PA_EV_XX             ;XX

            mw[473]  =  mw[088] * Pct_EV_IX    * (1 - PA_EV_IX   )    ;IX inverted
            mw[474]  =  mw[089] * Pct_EV_XI    * (1 - PA_EV_XI   )    ;XI inverted
            mw[475]  =  mw[090] * Pct_EV_XX    * (1 - PA_EV_XX   )    ;XX inverted

            mw[731]  =  mw[601] * Pct_EV_IX_MD * PA_EV_IX_MD          ;Ext_MD
            mw[732]  =  mw[602] * Pct_EV_XI_MD * PA_EV_XI_MD          ;Ext_MD
            mw[733]  =  mw[603] * Pct_EV_XX_MD * PA_EV_XX_MD          ;Ext_MD

            mw[781]  =  mw[651] * Pct_EV_IX_MD * (1 - PA_EV_IX_MD)    ;Ext_MD inverted
            mw[782]  =  mw[652] * Pct_EV_XI_MD * (1 - PA_EV_XI_MD)    ;Ext_MD inverted
            mw[783]  =  mw[653] * Pct_EV_XX_MD * (1 - PA_EV_XX_MD)    ;Ext_MD inverted

            mw[734]  =  mw[604] * Pct_EV_IX_HV * PA_EV_IX_HV          ;Ext_HV
            mw[735]  =  mw[605] * Pct_EV_XI_HV * PA_EV_XI_HV          ;Ext_HV
            mw[736]  =  mw[606] * Pct_EV_XX_HV * PA_EV_XX_HV          ;Ext_HV

            mw[784]  =  mw[654] * Pct_EV_IX_HV * (1 - PA_EV_IX_HV)    ;Ext_HV inverted
            mw[785]  =  mw[655] * Pct_EV_XI_HV * (1 - PA_EV_XI_HV)    ;Ext_HV inverted
            mw[786]  =  mw[656] * Pct_EV_XX_HV * (1 - PA_EV_XX_HV)    ;Ext_HV inverted
            
            mw[429]  =  mw[731] +    ;Ext_MD
                        mw[732] +
                        mw[733] 
            
            mw[479]  =  mw[781] +    ;Ext_MD inverted
                        mw[782] +
                        mw[783] 
            
            mw[430]  =  mw[734] +    ;Ext_HV
                        mw[735] +
                        mw[736] 
            
            mw[480]  =  mw[784] +    ;Ext_HV inverted
                        mw[785] +
                        mw[786] 

        endif  ;by movement
        
    ENDJLOOP
    
    
    ;PM 1 Hour
    mw[501] = mw[301] * @PM_1hr_Fac@          ;HBW PK DA NON
    mw[502] = mw[302] * @PM_1hr_Fac@          ;HBW PK SR NON
    mw[503] = mw[303] * @PM_1hr_Fac@          ;HBW PK SR HOV
    mw[504] = mw[304] * @PM_1hr_Fac@          ;HBW PK DA TOL
    mw[505] = mw[305] * @PM_1hr_Fac@          ;HBW PK SR TOL
    mw[506] = mw[306] * @PM_1hr_Fac@          ;HBO PK DA NON
    mw[507] = mw[307] * @PM_1hr_Fac@          ;HBO PK SR NON
    mw[508] = mw[308] * @PM_1hr_Fac@          ;HBO PK SR HOV
    mw[509] = mw[309] * @PM_1hr_Fac@          ;HBO PK DA TOL
    mw[510] = mw[310] * @PM_1hr_Fac@          ;HBO PK SR TOL
    mw[511] = mw[311] * @PM_1hr_Fac@          ;NHB PK DA NON
    mw[512] = mw[312] * @PM_1hr_Fac@          ;NHB PK SR NON
    mw[513] = mw[313] * @PM_1hr_Fac@          ;NHB PK SR HOV
    mw[514] = mw[314] * @PM_1hr_Fac@          ;NHB PK DA TOL
    mw[515] = mw[315] * @PM_1hr_Fac@          ;NHB PK SR TOL
    mw[516] = mw[316] * @PM_1hr_Fac@          ;HBC PK DA NON
    mw[517] = mw[317] * @PM_1hr_Fac@          ;HBC PK SR NON
    mw[518] = mw[318] * @PM_1hr_Fac@          ;HBC PK SR HOV
    mw[519] = mw[319] * @PM_1hr_Fac@          ;HBC PK DA TOL
    mw[520] = mw[320] * @PM_1hr_Fac@          ;HBC PK SR TOL
    mw[521] = mw[321] * @PM_1hr_Fac@          ;HBS_DriveSelf_Pr
    mw[522] = mw[322] * @PM_1hr_Fac@          ;HBS_DriveSelf_Sc
    mw[523] = mw[323] * @PM_1hr_Fac@          ;IX
    mw[524] = mw[324] * @PM_1hr_Fac@          ;XI
    mw[525] = mw[325] * @PM_1hr_Fac@          ;XX
    mw[526] = mw[326] * @PM_1hr_Fac@          ;SH_LT
    mw[527] = mw[327] * @PM_1hr_Fac@          ;SH_MD 
    mw[528] = mw[328] * @PM_1hr_Fac@          ;SH_HV 
    mw[529] = mw[329] * @PM_1hr_Fac@          ;Ext_MD 
    mw[530] = mw[330] * @PM_1hr_Fac@          ;Ext_HV 
    mw[531] = mw[331] * @PM_1hr_Fac@          ;HBS_DropOff_Pr
    mw[532] = mw[332] * @PM_1hr_Fac@          ;HBS_DropOff_Sc
    mw[533] = mw[333] * @PM_1hr_Fac@          ;SchoolBus_Pr
    mw[534] = mw[334] * @PM_1hr_Fac@          ;SchoolBus_Sc

    ;PM 1 Hour inverted
    mw[551] = mw[351] * @PM_1hr_Fac@          ;HBW PK DA NON inverted
    mw[552] = mw[352] * @PM_1hr_Fac@          ;HBW PK SR NON inverted
    mw[553] = mw[353] * @PM_1hr_Fac@          ;HBW PK SR HOV inverted
    mw[554] = mw[354] * @PM_1hr_Fac@          ;HBW PK DA TOL inverted
    mw[555] = mw[355] * @PM_1hr_Fac@          ;HBW PK SR TOL inverted
    mw[556] = mw[356] * @PM_1hr_Fac@          ;HBO PK DA NON inverted
    mw[557] = mw[357] * @PM_1hr_Fac@          ;HBO PK SR NON inverted
    mw[558] = mw[358] * @PM_1hr_Fac@          ;HBO PK SR HOV inverted
    mw[559] = mw[359] * @PM_1hr_Fac@          ;HBO PK DA TOL inverted
    mw[560] = mw[360] * @PM_1hr_Fac@          ;HBO PK SR TOL inverted
    mw[561] = mw[361] * @PM_1hr_Fac@          ;NHB PK DA NON inverted
    mw[562] = mw[362] * @PM_1hr_Fac@          ;NHB PK SR NON inverted
    mw[563] = mw[363] * @PM_1hr_Fac@          ;NHB PK SR HOV inverted
    mw[564] = mw[364] * @PM_1hr_Fac@          ;NHB PK DA TOL inverted
    mw[565] = mw[365] * @PM_1hr_Fac@          ;NHB PK SR TOL inverted
    mw[566] = mw[366] * @PM_1hr_Fac@          ;HBC PK DA NON inverted
    mw[567] = mw[367] * @PM_1hr_Fac@          ;HBC PK SR NON inverted
    mw[568] = mw[368] * @PM_1hr_Fac@          ;HBC PK SR HOV inverted
    mw[569] = mw[369] * @PM_1hr_Fac@          ;HBC PK DA TOL inverted
    mw[570] = mw[370] * @PM_1hr_Fac@          ;HBC PK SR TOL inverted
    mw[571] = mw[371] * @PM_1hr_Fac@          ;HBSch_DriveSelf_Pr inverted
    mw[572] = mw[372] * @PM_1hr_Fac@          ;HBSch_DriveSelf_Sc inverted
    mw[573] = mw[373] * @PM_1hr_Fac@          ;IX inverted
    mw[574] = mw[374] * @PM_1hr_Fac@          ;XI inverted
    mw[575] = mw[375] * @PM_1hr_Fac@          ;XX inverted
    mw[576] = mw[376] * @PM_1hr_Fac@          ;SH_LT inverted
    mw[577] = mw[377] * @PM_1hr_Fac@          ;SH_MD  inverted
    mw[578] = mw[378] * @PM_1hr_Fac@          ;SH_HV  inverted
    mw[579] = mw[379] * @PM_1hr_Fac@          ;Ext_MD  inverted
    mw[580] = mw[380] * @PM_1hr_Fac@          ;Ext_HV  inverted
    mw[581] = mw[381] * @PM_1hr_Fac@          ;HBSch_DropOff_Pr inverted
    mw[582] = mw[382] * @PM_1hr_Fac@          ;HBSch_DropOff_Sc inverted
    mw[583] = mw[383] * @PM_1hr_Fac@          ;SchoolBus_Pr  inverted
    mw[584] = mw[384] * @PM_1hr_Fac@          ;SchoolBus_Sc  inverted
    
    
    
    ;bucket round trip matrices
    ;  round to nearest integer, take factional amount from rounded and unrounded to following cell, starting with intrazonal cell
    ;AM
    mw[101] = mw[101], Total=ROWFIX(101)          ;HBW PK DA NON
    mw[102] = mw[102], Total=ROWFIX(102)          ;HBW PK SR NON
    mw[103] = mw[103], Total=ROWFIX(103)          ;HBW PK SR HOV
    mw[104] = mw[104], Total=ROWFIX(104)          ;HBW PK DA TOL
    mw[105] = mw[105], Total=ROWFIX(105)          ;HBW PK SR TOL
    mw[106] = mw[106], Total=ROWFIX(106)          ;HBO PK DA NON
    mw[107] = mw[107], Total=ROWFIX(107)          ;HBO PK SR NON
    mw[108] = mw[108], Total=ROWFIX(108)          ;HBO PK SR HOV
    mw[109] = mw[109], Total=ROWFIX(109)          ;HBO PK DA TOL
    mw[110] = mw[110], Total=ROWFIX(110)          ;HBO PK SR TOL
    mw[111] = mw[111], Total=ROWFIX(111)          ;NHB PK DA NON
    mw[112] = mw[112], Total=ROWFIX(112)          ;NHB PK SR NON
    mw[113] = mw[113], Total=ROWFIX(113)          ;NHB PK SR HOV
    mw[114] = mw[114], Total=ROWFIX(114)          ;NHB PK DA TOL
    mw[115] = mw[115], Total=ROWFIX(115)          ;NHB PK SR TOL
    mw[116] = mw[116], Total=ROWFIX(116)          ;HBC PK DA NON
    mw[117] = mw[117], Total=ROWFIX(117)          ;HBC PK SR NON
    mw[118] = mw[118], Total=ROWFIX(118)          ;HBC PK SR HOV
    mw[119] = mw[119], Total=ROWFIX(119)          ;HBC PK DA TOL
    mw[120] = mw[120], Total=ROWFIX(120)          ;HBC PK SR TOL
    mw[121] = mw[121], Total=ROWFIX(121)          ;HBSch_DriveSelf_Pr
    mw[122] = mw[122], Total=ROWFIX(122)          ;HBSch_DriveSelf_Sc
    mw[123] = mw[123], Total=ROWFIX(123)          ;IX
    mw[124] = mw[124], Total=ROWFIX(124)          ;XI
    mw[125] = mw[125], Total=ROWFIX(125)          ;XX
    mw[126] = mw[126], Total=ROWFIX(126)          ;SH_LT
    mw[127] = mw[127], Total=ROWFIX(127)          ;SH_MD 
    mw[128] = mw[128], Total=ROWFIX(128)          ;SH_HV 
    mw[129] = mw[129], Total=ROWFIX(129)          ;Ext_MD 
    mw[130] = mw[130], Total=ROWFIX(130)          ;Ext_HV 
    mw[131] = mw[131], Total=ROWFIX(131)          ;HBSch_DropOff_Pr
    mw[132] = mw[132], Total=ROWFIX(132)          ;HBSch_DropOff_Sc
    mw[133] = mw[133], Total=ROWFIX(133)          ;SchoolBus_Pr
    mw[134] = mw[134], Total=ROWFIX(134)          ;SchoolBus_Sc

    ;AM inverted
    mw[151] = mw[151], Total=ROWFIX(151)          ;HBW PK DA NON inverted
    mw[152] = mw[152], Total=ROWFIX(152)          ;HBW PK SR NON inverted
    mw[153] = mw[153], Total=ROWFIX(153)          ;HBW PK SR HOV inverted
    mw[154] = mw[154], Total=ROWFIX(154)          ;HBW PK DA TOL inverted
    mw[155] = mw[155], Total=ROWFIX(155)          ;HBW PK SR TOL inverted
    mw[156] = mw[156], Total=ROWFIX(156)          ;HBO PK DA NON inverted
    mw[157] = mw[157], Total=ROWFIX(157)          ;HBO PK SR NON inverted
    mw[158] = mw[158], Total=ROWFIX(158)          ;HBO PK SR HOV inverted
    mw[159] = mw[159], Total=ROWFIX(159)          ;HBO PK DA TOL inverted
    mw[160] = mw[160], Total=ROWFIX(160)          ;HBO PK SR TOL inverted
    mw[161] = mw[161], Total=ROWFIX(161)          ;NHB PK DA NON inverted
    mw[162] = mw[162], Total=ROWFIX(162)          ;NHB PK SR NON inverted
    mw[163] = mw[163], Total=ROWFIX(163)          ;NHB PK SR HOV inverted
    mw[164] = mw[164], Total=ROWFIX(164)          ;NHB PK DA TOL inverted
    mw[165] = mw[165], Total=ROWFIX(165)          ;NHB PK SR TOL inverted
    mw[166] = mw[166], Total=ROWFIX(166)          ;HBC PK DA NON inverted
    mw[167] = mw[167], Total=ROWFIX(167)          ;HBC PK SR NON inverted
    mw[168] = mw[168], Total=ROWFIX(168)          ;HBC PK SR HOV inverted
    mw[169] = mw[169], Total=ROWFIX(169)          ;HBC PK DA TOL inverted
    mw[170] = mw[170], Total=ROWFIX(170)          ;HBC PK SR TOL inverted
    mw[171] = mw[171], Total=ROWFIX(171)          ;HBSch_DriveSelf_Pr inverted
    mw[172] = mw[172], Total=ROWFIX(172)          ;HBSch_DriveSelf_Sc inverted
    mw[173] = mw[173], Total=ROWFIX(173)          ;IX inverted
    mw[174] = mw[174], Total=ROWFIX(174)          ;XI inverted
    mw[175] = mw[175], Total=ROWFIX(175)          ;XX inverted
    mw[176] = mw[176], Total=ROWFIX(176)          ;SH_LT inverted
    mw[177] = mw[177], Total=ROWFIX(177)          ;SH_MD  inverted
    mw[178] = mw[178], Total=ROWFIX(178)          ;SH_HV  inverted
    mw[179] = mw[179], Total=ROWFIX(179)          ;Ext_MD  inverted
    mw[180] = mw[180], Total=ROWFIX(180)          ;Ext_HV  inverted
    mw[181] = mw[181], Total=ROWFIX(181)          ;HBSch_DropOff_Pr inverted
    mw[182] = mw[182], Total=ROWFIX(182)          ;HBSch_DropOff_Sc inverted
    mw[183] = mw[183], Total=ROWFIX(183)          ;SchoolBus_Pr inverted
    mw[184] = mw[184], Total=ROWFIX(184)          ;SchoolBus_Sc inverted
    
    ;MD
    mw[201] = mw[201], Total=ROWFIX(201)          ;HBW PK DA NON
    mw[202] = mw[202], Total=ROWFIX(202)          ;HBW PK SR NON
    mw[203] = mw[203], Total=ROWFIX(203)          ;HBW PK SR HOV
    mw[204] = mw[204], Total=ROWFIX(204)          ;HBW PK DA TOL
    mw[205] = mw[205], Total=ROWFIX(205)          ;HBW PK SR TOL
    mw[206] = mw[206], Total=ROWFIX(206)          ;HBO PK DA NON
    mw[207] = mw[207], Total=ROWFIX(207)          ;HBO PK SR NON
    mw[208] = mw[208], Total=ROWFIX(208)          ;HBO PK SR HOV
    mw[209] = mw[209], Total=ROWFIX(209)          ;HBO PK DA TOL
    mw[210] = mw[210], Total=ROWFIX(210)          ;HBO PK SR TOL
    mw[211] = mw[211], Total=ROWFIX(211)          ;NHB PK DA NON
    mw[212] = mw[212], Total=ROWFIX(212)          ;NHB PK SR NON
    mw[213] = mw[213], Total=ROWFIX(213)          ;NHB PK SR HOV
    mw[214] = mw[214], Total=ROWFIX(214)          ;NHB PK DA TOL
    mw[215] = mw[215], Total=ROWFIX(215)          ;NHB PK SR TOL
    mw[216] = mw[216], Total=ROWFIX(216)          ;HBC PK DA NON
    mw[217] = mw[217], Total=ROWFIX(217)          ;HBC PK SR NON
    mw[218] = mw[218], Total=ROWFIX(218)          ;HBC PK SR HOV
    mw[219] = mw[219], Total=ROWFIX(219)          ;HBC PK DA TOL
    mw[220] = mw[220], Total=ROWFIX(220)          ;HBC PK SR TOL
    mw[221] = mw[221], Total=ROWFIX(221)          ;HBSch_DriveSelf_Pr
    mw[222] = mw[222], Total=ROWFIX(222)          ;HBSch_DriveSelf_Sc
    mw[223] = mw[223], Total=ROWFIX(223)          ;IX
    mw[224] = mw[224], Total=ROWFIX(224)          ;XI
    mw[225] = mw[225], Total=ROWFIX(225)          ;XX
    mw[226] = mw[226], Total=ROWFIX(226)          ;SH_LT
    mw[227] = mw[227], Total=ROWFIX(227)          ;SH_MD 
    mw[228] = mw[228], Total=ROWFIX(228)          ;SH_HV 
    mw[229] = mw[229], Total=ROWFIX(229)          ;Ext_MD 
    mw[230] = mw[230], Total=ROWFIX(230)          ;Ext_HV 
    mw[231] = mw[231], Total=ROWFIX(231)          ;HBSch_DropOff_Pr
    mw[232] = mw[232], Total=ROWFIX(232)          ;HBSch_DropOff_Sc
    mw[233] = mw[233], Total=ROWFIX(233)          ;SchoolBus_Pr
    mw[234] = mw[234], Total=ROWFIX(234)          ;SchoolBus_Sc

    ;MD inverted
    mw[251] = mw[251], Total=ROWFIX(251)          ;HBW PK DA NON inverted
    mw[252] = mw[252], Total=ROWFIX(252)          ;HBW PK SR NON inverted
    mw[253] = mw[253], Total=ROWFIX(253)          ;HBW PK SR HOV inverted
    mw[254] = mw[254], Total=ROWFIX(254)          ;HBW PK DA TOL inverted
    mw[255] = mw[255], Total=ROWFIX(255)          ;HBW PK SR TOL inverted
    mw[256] = mw[256], Total=ROWFIX(256)          ;HBO PK DA NON inverted
    mw[257] = mw[257], Total=ROWFIX(257)          ;HBO PK SR NON inverted
    mw[258] = mw[258], Total=ROWFIX(258)          ;HBO PK SR HOV inverted
    mw[259] = mw[259], Total=ROWFIX(259)          ;HBO PK DA TOL inverted
    mw[260] = mw[260], Total=ROWFIX(260)          ;HBO PK SR TOL inverted
    mw[261] = mw[261], Total=ROWFIX(261)          ;NHB PK DA NON inverted
    mw[262] = mw[262], Total=ROWFIX(262)          ;NHB PK SR NON inverted
    mw[263] = mw[263], Total=ROWFIX(263)          ;NHB PK SR HOV inverted
    mw[264] = mw[264], Total=ROWFIX(264)          ;NHB PK DA TOL inverted
    mw[265] = mw[265], Total=ROWFIX(265)          ;NHB PK SR TOL inverted
    mw[266] = mw[266], Total=ROWFIX(266)          ;HBC PK DA NON inverted
    mw[267] = mw[267], Total=ROWFIX(267)          ;HBC PK SR NON inverted
    mw[268] = mw[268], Total=ROWFIX(268)          ;HBC PK SR HOV inverted
    mw[269] = mw[269], Total=ROWFIX(269)          ;HBC PK DA TOL inverted
    mw[270] = mw[270], Total=ROWFIX(270)          ;HBC PK SR TOL inverted
    mw[271] = mw[271], Total=ROWFIX(271)          ;HBSch_DriveSelf_Pr inverted
    mw[272] = mw[272], Total=ROWFIX(272)          ;HBSch_DriveSelf_Sc inverted
    mw[273] = mw[273], Total=ROWFIX(273)          ;IX inverted
    mw[274] = mw[274], Total=ROWFIX(274)          ;XI inverted
    mw[275] = mw[275], Total=ROWFIX(275)          ;XX inverted
    mw[276] = mw[276], Total=ROWFIX(276)          ;SH_LT inverted
    mw[277] = mw[277], Total=ROWFIX(277)          ;SH_MD  inverted
    mw[278] = mw[278], Total=ROWFIX(278)          ;SH_HV  inverted
    mw[279] = mw[279], Total=ROWFIX(279)          ;Ext_MD  inverted
    mw[280] = mw[280], Total=ROWFIX(280)          ;Ext_HV  inverted
    mw[281] = mw[281], Total=ROWFIX(281)          ;HBSch_DropOff_Pr inverted
    mw[282] = mw[282], Total=ROWFIX(282)          ;HBSch_DropOff_Sc inverted
    mw[283] = mw[283], Total=ROWFIX(283)          ;SchoolBus_Pr inverted
    mw[284] = mw[284], Total=ROWFIX(284)          ;SchoolBus_Sc inverted
    
    ;PM
    mw[301] = mw[301], Total=ROWFIX(301)          ;HBW PK DA NON
    mw[302] = mw[302], Total=ROWFIX(302)          ;HBW PK SR NON
    mw[303] = mw[303], Total=ROWFIX(303)          ;HBW PK SR HOV
    mw[304] = mw[304], Total=ROWFIX(304)          ;HBW PK DA TOL
    mw[305] = mw[305], Total=ROWFIX(305)          ;HBW PK SR TOL
    mw[306] = mw[306], Total=ROWFIX(306)          ;HBO PK DA NON
    mw[307] = mw[307], Total=ROWFIX(307)          ;HBO PK SR NON
    mw[308] = mw[308], Total=ROWFIX(308)          ;HBO PK SR HOV
    mw[309] = mw[309], Total=ROWFIX(309)          ;HBO PK DA TOL
    mw[310] = mw[310], Total=ROWFIX(310)          ;HBO PK SR TOL
    mw[311] = mw[311], Total=ROWFIX(311)          ;NHB PK DA NON
    mw[312] = mw[312], Total=ROWFIX(312)          ;NHB PK SR NON
    mw[313] = mw[313], Total=ROWFIX(313)          ;NHB PK SR HOV
    mw[314] = mw[314], Total=ROWFIX(314)          ;NHB PK DA TOL
    mw[315] = mw[315], Total=ROWFIX(315)          ;NHB PK SR TOL
    mw[316] = mw[316], Total=ROWFIX(316)          ;HBC PK DA NON
    mw[317] = mw[317], Total=ROWFIX(317)          ;HBC PK SR NON
    mw[318] = mw[318], Total=ROWFIX(318)          ;HBC PK SR HOV
    mw[319] = mw[319], Total=ROWFIX(319)          ;HBC PK DA TOL
    mw[320] = mw[320], Total=ROWFIX(320)          ;HBC PK SR TOL
    mw[321] = mw[321], Total=ROWFIX(321)          ;HBSch_DriveSelf_Pr
    mw[322] = mw[322], Total=ROWFIX(322)          ;HBSch_DriveSelf_Sc
    mw[323] = mw[323], Total=ROWFIX(323)          ;IX
    mw[324] = mw[324], Total=ROWFIX(324)          ;XI
    mw[325] = mw[325], Total=ROWFIX(325)          ;XX
    mw[326] = mw[326], Total=ROWFIX(326)          ;SH_LT
    mw[327] = mw[327], Total=ROWFIX(327)          ;SH_MD 
    mw[328] = mw[328], Total=ROWFIX(328)          ;SH_HV 
    mw[329] = mw[329], Total=ROWFIX(329)          ;Ext_MD 
    mw[330] = mw[330], Total=ROWFIX(330)          ;Ext_HV 
    mw[331] = mw[331], Total=ROWFIX(331)          ;HBSch_DropOff_Pr
    mw[332] = mw[332], Total=ROWFIX(332)          ;HBSch_DropOff_Sc
    mw[333] = mw[333], Total=ROWFIX(333)          ;SchoolBus_Pr
    mw[334] = mw[334], Total=ROWFIX(334)          ;SchoolBus_Sc
    
    ;PM inverted
    mw[351] = mw[351], Total=ROWFIX(351)          ;HBW PK DA NON inverted
    mw[352] = mw[352], Total=ROWFIX(352)          ;HBW PK SR NON inverted
    mw[353] = mw[353], Total=ROWFIX(353)          ;HBW PK SR HOV inverted
    mw[354] = mw[354], Total=ROWFIX(354)          ;HBW PK DA TOL inverted
    mw[355] = mw[355], Total=ROWFIX(355)          ;HBW PK SR TOL inverted
    mw[356] = mw[356], Total=ROWFIX(356)          ;HBO PK DA NON inverted
    mw[357] = mw[357], Total=ROWFIX(357)          ;HBO PK SR NON inverted
    mw[358] = mw[358], Total=ROWFIX(358)          ;HBO PK SR HOV inverted
    mw[359] = mw[359], Total=ROWFIX(359)          ;HBO PK DA TOL inverted
    mw[360] = mw[360], Total=ROWFIX(360)          ;HBO PK SR TOL inverted
    mw[361] = mw[361], Total=ROWFIX(361)          ;NHB PK DA NON inverted
    mw[362] = mw[362], Total=ROWFIX(362)          ;NHB PK SR NON inverted
    mw[363] = mw[363], Total=ROWFIX(363)          ;NHB PK SR HOV inverted
    mw[364] = mw[364], Total=ROWFIX(364)          ;NHB PK DA TOL inverted
    mw[365] = mw[365], Total=ROWFIX(365)          ;NHB PK SR TOL inverted
    mw[366] = mw[366], Total=ROWFIX(366)          ;HBC PK DA NON inverted
    mw[367] = mw[367], Total=ROWFIX(367)          ;HBC PK SR NON inverted
    mw[368] = mw[368], Total=ROWFIX(368)          ;HBC PK SR HOV inverted
    mw[369] = mw[369], Total=ROWFIX(369)          ;HBC PK DA TOL inverted
    mw[370] = mw[370], Total=ROWFIX(370)          ;HBC PK SR TOL inverted
    mw[371] = mw[371], Total=ROWFIX(371)          ;HBSch_DriveSelf_Pr inverted
    mw[372] = mw[372], Total=ROWFIX(372)          ;HBSch_DriveSelf_Sc inverted
    mw[373] = mw[373], Total=ROWFIX(373)          ;IX inverted
    mw[374] = mw[374], Total=ROWFIX(374)          ;XI inverted
    mw[375] = mw[375], Total=ROWFIX(375)          ;XX inverted
    mw[376] = mw[376], Total=ROWFIX(376)          ;SH_LT inverted
    mw[377] = mw[377], Total=ROWFIX(377)          ;SH_MD  inverted
    mw[378] = mw[378], Total=ROWFIX(378)          ;SH_HV  inverted
    mw[379] = mw[379], Total=ROWFIX(379)          ;Ext_MD  inverted
    mw[380] = mw[380], Total=ROWFIX(380)          ;Ext_HV  inverted
    mw[381] = mw[381], Total=ROWFIX(381)          ;HBSch_DropOff_Pr inverted
    mw[382] = mw[382], Total=ROWFIX(382)          ;HBSch_DropOff_Sc inverted
    mw[383] = mw[383], Total=ROWFIX(383)          ;SchoolBus_Pr inverted
    mw[384] = mw[384], Total=ROWFIX(384)          ;SchoolBus_Sc inverted
    
    ;EV
    mw[401] = mw[401], Total=ROWFIX(401)          ;HBW PK DA NON
    mw[402] = mw[402], Total=ROWFIX(402)          ;HBW PK SR NON
    mw[403] = mw[403], Total=ROWFIX(403)          ;HBW PK SR HOV
    mw[404] = mw[404], Total=ROWFIX(404)          ;HBW PK DA TOL
    mw[405] = mw[405], Total=ROWFIX(405)          ;HBW PK SR TOL
    mw[406] = mw[406], Total=ROWFIX(406)          ;HBO PK DA NON
    mw[407] = mw[407], Total=ROWFIX(407)          ;HBO PK SR NON
    mw[408] = mw[408], Total=ROWFIX(408)          ;HBO PK SR HOV
    mw[409] = mw[409], Total=ROWFIX(409)          ;HBO PK DA TOL
    mw[410] = mw[410], Total=ROWFIX(410)          ;HBO PK SR TOL
    mw[411] = mw[411], Total=ROWFIX(411)          ;NHB PK DA NON
    mw[412] = mw[412], Total=ROWFIX(412)          ;NHB PK SR NON
    mw[413] = mw[413], Total=ROWFIX(413)          ;NHB PK SR HOV
    mw[414] = mw[414], Total=ROWFIX(414)          ;NHB PK DA TOL
    mw[415] = mw[415], Total=ROWFIX(415)          ;NHB PK SR TOL
    mw[416] = mw[416], Total=ROWFIX(416)          ;HBC PK DA NON
    mw[417] = mw[417], Total=ROWFIX(417)          ;HBC PK SR NON
    mw[418] = mw[418], Total=ROWFIX(418)          ;HBC PK SR HOV
    mw[419] = mw[419], Total=ROWFIX(419)          ;HBC PK DA TOL
    mw[420] = mw[420], Total=ROWFIX(420)          ;HBC PK SR TOL
    mw[421] = mw[421], Total=ROWFIX(421)          ;HBSch_DriveSelf_Pr
    mw[422] = mw[422], Total=ROWFIX(422)          ;HBSch_DriveSelf_Sc
    mw[423] = mw[423], Total=ROWFIX(423)          ;IX
    mw[424] = mw[424], Total=ROWFIX(424)          ;XI
    mw[425] = mw[425], Total=ROWFIX(425)          ;XX
    mw[426] = mw[426], Total=ROWFIX(426)          ;SH_LT
    mw[427] = mw[427], Total=ROWFIX(427)          ;SH_MD 
    mw[428] = mw[428], Total=ROWFIX(428)          ;SH_HV 
    mw[429] = mw[429], Total=ROWFIX(429)          ;Ext_MD 
    mw[430] = mw[430], Total=ROWFIX(430)          ;Ext_HV 
    mw[431] = mw[431], Total=ROWFIX(431)          ;HBSch_DropOff_Pr
    mw[432] = mw[432], Total=ROWFIX(432)          ;HBSch_DropOff_Sc
    mw[433] = mw[433], Total=ROWFIX(433)          ;SchoolBus_Pr
    mw[434] = mw[434], Total=ROWFIX(434)          ;SchoolBus_Sc
    
    ;EV inverted
    mw[451] = mw[451], Total=ROWFIX(451)          ;HBW PK DA NON inverted
    mw[452] = mw[452], Total=ROWFIX(452)          ;HBW PK SR NON inverted
    mw[453] = mw[453], Total=ROWFIX(453)          ;HBW PK SR HOV inverted
    mw[454] = mw[454], Total=ROWFIX(454)          ;HBW PK DA TOL inverted
    mw[455] = mw[455], Total=ROWFIX(455)          ;HBW PK SR TOL inverted
    mw[456] = mw[456], Total=ROWFIX(456)          ;HBO PK DA NON inverted
    mw[457] = mw[457], Total=ROWFIX(457)          ;HBO PK SR NON inverted
    mw[458] = mw[458], Total=ROWFIX(458)          ;HBO PK SR HOV inverted
    mw[459] = mw[459], Total=ROWFIX(459)          ;HBO PK DA TOL inverted
    mw[460] = mw[460], Total=ROWFIX(460)          ;HBO PK SR TOL inverted
    mw[461] = mw[461], Total=ROWFIX(461)          ;NHB PK DA NON inverted
    mw[462] = mw[462], Total=ROWFIX(462)          ;NHB PK SR NON inverted
    mw[463] = mw[463], Total=ROWFIX(463)          ;NHB PK SR HOV inverted
    mw[464] = mw[464], Total=ROWFIX(464)          ;NHB PK DA TOL inverted
    mw[465] = mw[465], Total=ROWFIX(465)          ;NHB PK SR TOL inverted
    mw[466] = mw[466], Total=ROWFIX(466)          ;HBC PK DA NON inverted
    mw[467] = mw[467], Total=ROWFIX(467)          ;HBC PK SR NON inverted
    mw[468] = mw[468], Total=ROWFIX(468)          ;HBC PK SR HOV inverted
    mw[469] = mw[469], Total=ROWFIX(469)          ;HBC PK DA TOL inverted
    mw[470] = mw[470], Total=ROWFIX(470)          ;HBC PK SR TOL inverted
    mw[471] = mw[471], Total=ROWFIX(471)          ;HBSch_DriveSelf_Pr inverted
    mw[472] = mw[472], Total=ROWFIX(472)          ;HBSch_DriveSelf_Sc inverted
    mw[473] = mw[473], Total=ROWFIX(473)          ;IX inverted
    mw[474] = mw[474], Total=ROWFIX(474)          ;XI inverted
    mw[475] = mw[475], Total=ROWFIX(475)          ;XX inverted
    mw[476] = mw[476], Total=ROWFIX(476)          ;SH_LT inverted
    mw[477] = mw[477], Total=ROWFIX(477)          ;SH_MD  inverted
    mw[478] = mw[478], Total=ROWFIX(478)          ;SH_HV  inverted
    mw[479] = mw[479], Total=ROWFIX(479)          ;Ext_MD  inverted
    mw[480] = mw[480], Total=ROWFIX(480)          ;Ext_HV  inverted
    mw[481] = mw[481], Total=ROWFIX(481)          ;HBSch_DropOff_Pr inverted
    mw[482] = mw[482], Total=ROWFIX(482)          ;HBSch_DropOff_Sc inverted
    mw[483] = mw[483], Total=ROWFIX(483)          ;SchoolBus_Pr inverted
    mw[484] = mw[484], Total=ROWFIX(484)          ;SchoolBus_Sc inverted
    
    ;PM 1 Hour
    mw[501] = mw[501], Total=ROWFIX(501)          ;HBW PK DA NON
    mw[502] = mw[502], Total=ROWFIX(502)          ;HBW PK SR NON
    mw[503] = mw[503], Total=ROWFIX(503)          ;HBW PK SR HOV
    mw[504] = mw[504], Total=ROWFIX(504)          ;HBW PK DA TOL
    mw[505] = mw[505], Total=ROWFIX(505)          ;HBW PK SR TOL
    mw[506] = mw[506], Total=ROWFIX(506)          ;HBO PK DA NON
    mw[507] = mw[507], Total=ROWFIX(507)          ;HBO PK SR NON
    mw[508] = mw[508], Total=ROWFIX(508)          ;HBO PK SR HOV
    mw[509] = mw[509], Total=ROWFIX(509)          ;HBO PK DA TOL
    mw[510] = mw[510], Total=ROWFIX(510)          ;HBO PK SR TOL
    mw[511] = mw[511], Total=ROWFIX(511)          ;NHB PK DA NON
    mw[512] = mw[512], Total=ROWFIX(512)          ;NHB PK SR NON
    mw[513] = mw[513], Total=ROWFIX(513)          ;NHB PK SR HOV
    mw[514] = mw[514], Total=ROWFIX(514)          ;NHB PK DA TOL
    mw[515] = mw[515], Total=ROWFIX(515)          ;NHB PK SR TOL
    mw[516] = mw[516], Total=ROWFIX(516)          ;HBC PK DA NON
    mw[517] = mw[517], Total=ROWFIX(517)          ;HBC PK SR NON
    mw[518] = mw[518], Total=ROWFIX(518)          ;HBC PK SR HOV
    mw[519] = mw[519], Total=ROWFIX(519)          ;HBC PK DA TOL
    mw[520] = mw[520], Total=ROWFIX(520)          ;HBC PK SR TOL
    mw[521] = mw[521], Total=ROWFIX(521)          ;HBSch_DriveSelf_Pr
    mw[522] = mw[522], Total=ROWFIX(522)          ;HBSch_DriveSelf_Sc
    mw[523] = mw[523], Total=ROWFIX(523)          ;IX
    mw[524] = mw[524], Total=ROWFIX(524)          ;XI
    mw[525] = mw[525], Total=ROWFIX(525)          ;XX
    mw[526] = mw[526], Total=ROWFIX(526)          ;SH_LT
    mw[527] = mw[527], Total=ROWFIX(527)          ;SH_MD 
    mw[528] = mw[528], Total=ROWFIX(528)          ;SH_HV 
    mw[529] = mw[529], Total=ROWFIX(529)          ;Ext_MD 
    mw[530] = mw[530], Total=ROWFIX(530)          ;Ext_HV 
    mw[531] = mw[531], Total=ROWFIX(531)          ;HBSch_DropOff_Pr
    mw[532] = mw[532], Total=ROWFIX(532)          ;HBSch_DropOff_Sc
    mw[533] = mw[533], Total=ROWFIX(533)          ;SchoolBus_Pr
    mw[534] = mw[534], Total=ROWFIX(534)          ;SchoolBus_Sc
    
    ;PM 1 Hour inverted
    mw[551] = mw[551], Total=ROWFIX(551)          ;HBW PK DA NON inverted
    mw[552] = mw[552], Total=ROWFIX(552)          ;HBW PK SR NON inverted
    mw[553] = mw[553], Total=ROWFIX(553)          ;HBW PK SR HOV inverted
    mw[554] = mw[554], Total=ROWFIX(554)          ;HBW PK DA TOL inverted
    mw[555] = mw[555], Total=ROWFIX(555)          ;HBW PK SR TOL inverted
    mw[556] = mw[556], Total=ROWFIX(556)          ;HBO PK DA NON inverted
    mw[557] = mw[557], Total=ROWFIX(557)          ;HBO PK SR NON inverted
    mw[558] = mw[558], Total=ROWFIX(558)          ;HBO PK SR HOV inverted
    mw[559] = mw[559], Total=ROWFIX(559)          ;HBO PK DA TOL inverted
    mw[560] = mw[560], Total=ROWFIX(560)          ;HBO PK SR TOL inverted
    mw[561] = mw[561], Total=ROWFIX(561)          ;NHB PK DA NON inverted
    mw[562] = mw[562], Total=ROWFIX(562)          ;NHB PK SR NON inverted
    mw[563] = mw[563], Total=ROWFIX(563)          ;NHB PK SR HOV inverted
    mw[564] = mw[564], Total=ROWFIX(564)          ;NHB PK DA TOL inverted
    mw[565] = mw[565], Total=ROWFIX(565)          ;NHB PK SR TOL inverted
    mw[566] = mw[566], Total=ROWFIX(566)          ;HBC PK DA NON inverted
    mw[567] = mw[567], Total=ROWFIX(567)          ;HBC PK SR NON inverted
    mw[568] = mw[568], Total=ROWFIX(568)          ;HBC PK SR HOV inverted
    mw[569] = mw[569], Total=ROWFIX(569)          ;HBC PK DA TOL inverted
    mw[570] = mw[570], Total=ROWFIX(570)          ;HBC PK SR TOL inverted
    mw[571] = mw[571], Total=ROWFIX(571)          ;HBSch_DriveSelf_Pr inverted
    mw[572] = mw[572], Total=ROWFIX(572)          ;HBSch_DriveSelf_Sc inverted
    mw[573] = mw[573], Total=ROWFIX(573)          ;IX inverted
    mw[574] = mw[574], Total=ROWFIX(574)          ;XI inverted
    mw[575] = mw[575], Total=ROWFIX(575)          ;XX inverted
    mw[576] = mw[576], Total=ROWFIX(576)          ;SH_LT inverted
    mw[577] = mw[577], Total=ROWFIX(577)          ;SH_MD  inverted
    mw[578] = mw[578], Total=ROWFIX(578)          ;SH_HV  inverted
    mw[579] = mw[579], Total=ROWFIX(579)          ;Ext_MD  inverted
    mw[580] = mw[580], Total=ROWFIX(580)          ;Ext_HV  inverted
    mw[581] = mw[581], Total=ROWFIX(581)          ;HBSch_DropOff_Pr inverted
    mw[582] = mw[582], Total=ROWFIX(582)          ;HBSch_DropOff_Sc inverted
    mw[583] = mw[583], Total=ROWFIX(583)          ;SchoolBus_Pr inverted
    mw[584] = mw[584], Total=ROWFIX(584)          ;SchoolBus_Sc inverted
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n----------------------------------------------------------------------',
             '\nHIGHWAY ASSIGNMENT',
             '\n    Convert PA to OD                   ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(del 01_Convert_PA_to_OD.txt)
