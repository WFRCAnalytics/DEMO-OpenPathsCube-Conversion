
;Parameters
;    READ FILE = '..\..\0GeneralParameters.block'
;    READ FILE = '..\..\1ControlCenter.block'



;get start time
ScriptStartTime = currenttime()



RUN PGM=MATRIX   MSG='Collapse the tables by vechile occupancy'
    FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Pk_auto_managedlanes.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Ok_auto_managedlanes.mtx'
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Ok_auto_managedlanes.mtx'
    
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_PR_ModeShare.mtx'                   ;K-6 HBSch 
    FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_SC_ModeShare.mtx'                   ;7-12 HBSch
    
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp2.mtx', 
        MO=1,
        NAME=IX
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Pk_auto_managedlanes2.mtx', 
        MO=31-33,
        name=DA, SR2, SR3
    
    FILEO MATO[3] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Pk_auto_managedlanes2.mtx',
        MO=41-43,
        name=DA, SR2, SR3
                
    FILEO MATO[5] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Pk_auto_managedlanes2.mtx',
        MO=61-63,
        name=DA, SR2, SR3
        
    FILEO MATO[6] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Ok_auto_managedlanes2.mtx',
        MO=71-73,
        name=DA, SR2, SR3
        
    FILEO MATO[7] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Ok_auto_managedlanes2.mtx',
        MO=81-83,
        name=DA, SR2, SR3
                
    FILEO MATO[9] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Ok_auto_managedlanes2.mtx',
        MO=101-103,
        name=DA, SR2, SR3
               
    FILEO MATO[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_ModeShare2.mtx',
        MO=132,133,135,136,
        NAME=
             Pk_DriveSelf,
             Pk_DropOff, 
             
             Ok_DriveSelf,
             Ok_DropOff
                 
    ZONES   = @UsedZones@
    ZONEMSG = 100
        
    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
       mw[1] = mi.1.IX

       mw[31] = mi.2.alone_non+mi.2.alone_toll
       mw[32] = mi.2.sr2_non+mi.2.sr2_hov+mi.2.sr2_toll
       mw[33] = mi.2.sr3_non+mi.2.sr3_hov+mi.2.sr3_toll

       mw[41] = mi.3.alone_non+mi.3.alone_toll
       mw[42] = mi.3.sr2_non+mi.3.sr2_hov+mi.3.sr2_toll
       mw[43] = mi.3.sr3_non+mi.3.sr3_hov+mi.3.sr3_toll

       mw[61] = mi.5.alone_non+mi.5.alone_toll
       mw[62] = mi.5.sr2_non+mi.5.sr2_hov+mi.5.sr2_toll
       mw[63] = mi.5.sr3_non+mi.5.sr3_hov+mi.5.sr3_toll
       
       mw[71] = mi.6.alone_non+mi.6.alone_toll
       mw[72] = mi.6.sr2_non+mi.6.sr2_hov+mi.6.sr2_toll
       mw[73] = mi.6.sr3_non+mi.6.sr3_hov+mi.6.sr3_toll

       mw[81] = mi.7.alone_non+mi.7.alone_toll
       mw[82] = mi.7.sr2_non+mi.7.sr2_hov+mi.7.sr2_toll
       mw[83] = mi.7.sr3_non+mi.7.sr3_hov+mi.7.sr3_toll

       mw[101] = mi.9.alone_non+mi.9.alone_toll
       mw[102] = mi.9.sr2_non+mi.9.sr2_hov+mi.9.sr2_toll
       mw[103] = mi.9.sr3_non+mi.9.sr3_hov+mi.9.sr3_toll

       mw[132] = mi.10.Pk_DriveSelf+mi.11.Pk_DriveSelf
       mw[133] = mi.10.Pk_DropOff+mi.11.Pk_DropOff
       
       mw[135] = mi.10.Ok_DriveSelf+mi.11.Ok_DriveSelf
       mw[136] = mi.10.Ok_DropOff+mi.11.Ok_DropOff            

         
ENDRUN

;**************************************************************************
;Purpose:   Factor distributed person trips by time period, and convert
;           to vehicle trips
;**************************************************************************

RUN PGM=MATRIX   MSG='Convert PA tables to OD by period*purpose*PA_ODdirection'

    FILEI MATI[01] = '@ParentDir@@ScenarioDir@4_ModeChoice\PA_AllPurp2.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Pk_auto_managedlanes2.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Pk_auto_managedlanes2.mtx'
    
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Pk_auto_managedlanes2.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_Ok_auto_managedlanes2.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_Ok_auto_managedlanes2.mtx'
    
    FILEI MATI[09] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_Ok_auto_managedlanes2.mtx'
    FILEI MATI[10] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBSch_ModeShare2.mtx'                   ;K-6 HBSch    
    
    ;***** Matrix names must be identical to standardize their use in the assignment block file.
    FILEO MATO[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\am3hr_managed3.mtx', 
        mo=100-105, 110-115, 
        name=Total,
             HBW, 
             HBO,
             HBC,
             HBSch,
             IX,
             TotalT,
             HBWT, 
             HBOT,
             HBCT,
             HBScT,
             IXT
    
    FILEO MATO[2] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\md6hr_managed3.mtx', 
        mo=200-205,210-215, 
        name=Total,
             HBW, 
             HBO,
             HBC,
             HBSch,
             IX,
             TotalT,
             HBWT, 
             HBOT,
             HBCT,
             HBScT,
             IXT
    
    FILEO MATO[3] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pm3hr_managed3.mtx',
        mo=300-305,310-315, 
        name=Total,
             HBW, 
             HBO,
             HBC,
             HBSch,
             IX,
             TotalT,
             HBWT, 
             HBOT,
             HBCT,
             HBScT,
             IXT
    
    FILEO MATO[4] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ev12hr_managed3.mtx',
        mo=400-405,410-415,  
        name=Total,
             HBW, 
             HBO,
             HBC,
             HBSch,
             IX,
             TotalT,
             HBWT, 
             HBOT,
             HBCT,
             HBScT,
             IXT

    ;Cluster: distribute intrastep processing
    DistributeIntrastep MaxProcesses=@CoresAvailable@
    
    
    ;define matrix parameters
    ZONES   = @UsedZones@
    ZONEMSG = 100

   ; if (i==@n@)
    ;read in mode choice matricies (note mode choice matrices are multiplied by 100)
    ;HBW PK
    mw[001] = (mi.2.DA) / 100  
    mw[002] = (mi.2.sr2 / 2) / 100  
    mw[003] = (mi.2.sr3 / @VehOcc_3p_HBW@) / 100  
    
    ;HBO PK
    mw[006] = (mi.3.DA                                              ) / 100      ;HBO PK DA NON 
    mw[007] = (mi.3.sr2     / 2    / 100)      ;HBO PK SR NON 
    mw[008] = (  mi.3.sr3   / @VehOcc_3p_HBW@) / 100      ;HBO PK SR HOV 
    
    ;HBC PK                                                            
    mw[016] = (mi.5.DA                                       ) / 100      ;HBC PK DA NON 
    mw[017] = (mi.5.sr2 / 2   ) / 100      ;HBC PK SR NON 
    mw[018] = ( mi.5.sr3  / @VehOcc_3p_HBW@) / 100      ;HBC PK SR HOV 
    
    
    ;transposed HBW PK
    mw[021] = (mi.2.DA.T                                         ) / 100    ;HBW PK DA NON 
    mw[022] = (mi.2.sr2.T / 2  ) / 100    ;HBW PK SR NON 
    mw[023] = (mi.2.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBW PK SR HOV 
    
    ;transposed HBO PK
    mw[026] = (mi.3.DA.T                                         ) / 100    ;HBO PK DA NON 
    mw[027] = (mi.3.sr2.T / 2  ) / 100    ;HBO PK SR NON 
    mw[028] = (mi.3.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBO PK SR HOV 
    
    ;transposed HBC PK                                                            
    mw[036] = (mi.5.DA.T                                         ) / 100    ;HBC PK DA NON 
    mw[037] = (mi.5.sr2.T / 2  ) / 100    ;HBC PK SR NON 
    mw[038] = (mi.5.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBC PK SR HOV 
    
    
    ;HBW OK
    mw[041] = (mi.6.DA                                       ) / 100    ;HBW OK DA NON 
    mw[042] = (mi.6.sr2 / 2 ) / 100    ;HBW OK SR NON 
    mw[043] = (mi.6.sr3/ @VehOcc_3p_HBW@) / 100    ;HBW OK SR HOV 
    
    ;HBO OK
    mw[046] = (mi.7.DA                                       ) / 100    ;HBO OK DA NON 
    mw[047] = (mi.7.sr2/ 2  ) / 100    ;HBO OK SR NON 
    mw[048] = (mi.7.sr3  / @VehOcc_3p_HBW@) / 100    ;HBO OK SR HOV 
    
    ;HBC OK                                                            
    mw[056] = (mi.9.DA                                       ) / 100    ;HBC OK DA NON 
    mw[057] = (mi.9.sr2 / 2  ) / 100    ;HBC OK SR NON 
    mw[058] = (mi.9.sr3  / @VehOcc_3p_HBW@) / 100    ;HBC OK SR HOV 
    
    
    ;transposed HBW OK
    mw[061] = (mi.6.DA.T                                         ) / 100    ;HBW OK DA NON 
    mw[062] = (mi.6.sr2.T / 2) / 100    ;HBW OK SR NON 
    mw[063] = (mi.6.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBW OK SR HOV 
    
    ;transposed HBO OK
    mw[066] = (mi.7.DA.T                                         ) / 100    ;HBO OK DA NON 
    mw[067] = (mi.7.sr2.T / 2) / 100    ;HBO OK SR NON 
    mw[068] = (mi.7.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBO OK SR HOV 
    
    ;transposed HBC OK                                                            
    mw[076] = (mi.9.DA.T                                         ) / 100    ;HBC OK DA NON 
    mw[077] = (mi.9.sr2.T / 2) / 100    ;HBC OK SR NON 
    mw[078] = (mi.9.sr3.T  / @VehOcc_3p_HBW@) / 100    ;HBC OK SR HOV       
    
 
    ;external and truck trip matrices
    mw[085] = mi.1.IX*100 / 100
    
    ;transposed external
    mw[088] = mi.1.IX.T*100 / 100
    
    
    ;HBSch
    mw[901] = (mi.10.PK_DriveSelf+mi.10.Ok_DriveSelf) / @VehOcc_HBSch@                          ;HBSch - 7-12
               
    mw[902] = (mi.10.PK_DropOff+mi.10.Ok_DropOff  ) / @VehOcc_HBSch@ 
    
    ;Transpose HBSch
    mw[911] = (mi.10.PK_DriveSelf.T +mi.10.Ok_DriveSelf.T ) / @VehOcc_HBSch@                          ;HBSch - 7-12
               
    mw[912] = (mi.10.PK_DropOff.T +mi.10.Ok_DropOff.T  ) / @VehOcc_HBSch@ 
    
 
    ;calculate period PA & AP factors for HBW, HBC, BHO & NHB
    ;AM & PM (MC peak = AM + PM)
    _AM_HBW_PA   = @HBW_AM_Pct@ / (@HBW_AM_Pct@ + @HBW_PM_Pct@)  *  @HBW_AM_PA@
    _AM_HBC_PA   = @HBC_AM_Pct@ / (@HBC_AM_Pct@ + @HBC_PM_Pct@)  *  @HBC_AM_PA@
    _AM_HBO_PA   = @HBO_AM_Pct@ / (@HBO_AM_Pct@ + @HBO_PM_Pct@)  *  @HBO_AM_PA@
                                                                    
    _AM_HBW_AP   = @HBW_AM_Pct@ / (@HBW_AM_Pct@ + @HBW_PM_Pct@)  *  (1 - @HBW_AM_PA@)
    _AM_HBC_AP   = @HBC_AM_Pct@ / (@HBC_AM_Pct@ + @HBC_PM_Pct@)  *  (1 - @HBC_AM_PA@)
    _AM_HBO_AP   = @HBO_AM_Pct@ / (@HBO_AM_Pct@ + @HBO_PM_Pct@)  *  (1 - @HBO_AM_PA@)
                                                                    
    _PM_HBW_PA   = @HBW_PM_Pct@ / (@HBW_AM_Pct@ + @HBW_PM_Pct@)  *  @HBW_PM_PA@
    _PM_HBC_PA   = @HBC_PM_Pct@ / (@HBC_AM_Pct@ + @HBC_PM_Pct@)  *  @HBC_PM_PA@
    _PM_HBO_PA   = @HBO_PM_Pct@ / (@HBO_AM_Pct@ + @HBO_PM_Pct@)  *  @HBO_PM_PA@
                                                              
    _PM_HBW_AP   = @HBW_PM_Pct@ / (@HBW_AM_Pct@ + @HBW_PM_Pct@)  *  (1 - @HBW_PM_PA@)
    _PM_HBC_AP   = @HBC_PM_Pct@ / (@HBC_AM_Pct@ + @HBC_PM_Pct@)  *  (1 - @HBC_PM_PA@)
    _PM_HBO_AP   = @HBO_PM_Pct@ / (@HBO_AM_Pct@ + @HBO_PM_Pct@)  *  (1 - @HBO_PM_PA@)
    
    ;MD & PM (MC off peak = MD + EV)
    _MD_HBW_PA   = @HBW_MD_Pct@ / (@HBW_MD_Pct@ + @HBW_EV_Pct@)  *  @HBW_MD_PA@
    _MD_HBC_PA   = @HBC_MD_Pct@ / (@HBC_MD_Pct@ + @HBC_EV_Pct@)  *  @HBC_MD_PA@
    _MD_HBO_PA   = @HBO_MD_Pct@ / (@HBO_MD_Pct@ + @HBO_EV_Pct@)  *  @HBO_MD_PA@
    
    _MD_HBW_AP   = @HBW_MD_Pct@ / (@HBW_MD_Pct@ + @HBW_EV_Pct@)  *  (1 - @HBW_MD_PA@)
    _MD_HBC_AP   = @HBC_MD_Pct@ / (@HBC_MD_Pct@ + @HBC_EV_Pct@)  *  (1 - @HBC_MD_PA@)
    _MD_HBO_AP   = @HBO_MD_Pct@ / (@HBO_MD_Pct@ + @HBO_EV_Pct@)  *  (1 - @HBO_MD_PA@)
                                                                    
    _EV_HBW_PA   = @HBW_EV_Pct@ / (@HBW_MD_Pct@ + @HBW_EV_Pct@)  *  @HBW_EV_PA@
    _EV_HBC_PA   = @HBC_EV_Pct@ / (@HBC_MD_Pct@ + @HBC_EV_Pct@)  *  @HBC_EV_PA@
    _EV_HBO_PA   = @HBO_EV_Pct@ / (@HBO_MD_Pct@ + @HBO_EV_Pct@)  *  @HBO_EV_PA@
                                                              
    _EV_HBW_AP   = @HBW_EV_Pct@ / (@HBW_MD_Pct@ + @HBW_EV_Pct@)  *  (1 - @HBW_EV_PA@)
    _EV_HBC_AP   = @HBC_EV_Pct@ / (@HBC_MD_Pct@ + @HBC_EV_Pct@)  *  (1 - @HBC_EV_PA@)
    _EV_HBO_AP   = @HBO_EV_Pct@ / (@HBO_MD_Pct@ + @HBO_EV_Pct@)  *  (1 - @HBO_EV_PA@)
    
    
    ;calculate PA & AP factors for HBSch
    _AM_HBSch_PA    = @HBSch_AM_Pct@ * @HBSch_AM_PA@
    _MD_HBSch_PA    = @HBSch_MD_Pct@ * @HBSch_MD_PA@
    _PM_HBSch_PA    = @HBSch_PM_Pct@ * @HBSch_PM_PA@
    _EV_HBSch_PA    = @HBSch_EV_Pct@ * @HBSch_EV_PA@
    
    _AM_HBSch_AP    = @HBSch_AM_Pct@ * (1 - @HBSch_AM_PA@)
    _MD_HBSch_AP    = @HBSch_MD_Pct@ * (1 - @HBSch_MD_PA@)
    _PM_HBSch_AP    = @HBSch_PM_Pct@ * (1 - @HBSch_PM_PA@)
    _EV_HBSch_AP    = @HBSch_EV_Pct@ * (1 - @HBSch_EV_PA@)
    
    
    ;calculate PA & AP factors for external and truck
    _AM_IX_PA    = @IX_AM_Pct@ * @IX_AM_PA@
    _AM_IX_AP    = @IX_AM_Pct@ * (1 - @IX_AM_PA@)
    
    _MD_IX_PA    = @IX_MD_Pct@ * @IX_MD_PA@
    _MD_IX_AP    = @IX_MD_Pct@ * (1 - @IX_MD_PA@)
    
    _PM_IX_PA    = @IX_PM_Pct@ * @IX_PM_PA@
    _PM_IX_AP    = @IX_PM_Pct@ * (1 - @IX_PM_PA@)
    
    _EV_IX_PA    = @IX_EV_Pct@ * @IX_EV_PA@
    _EV_IX_AP    = @IX_EV_Pct@ * (1 - @IX_EV_PA@)
    

    ;calc OD trips
    JLOOP
    
        ;i
        ;AM 
        mw[106] = mw[001] * _AM_HBW_PA  ;+  mw[021] * _AM_HBW_AP    ;HBW PK DA NON   
        mw[107] = mw[002] * _AM_HBW_PA  ;+  mw[022] * _AM_HBW_AP    ;HBW PK SR NON   
        mw[108] = mw[003] * _AM_HBW_PA  ;+  mw[023] * _AM_HBW_AP    ;HBW PK SR HOV   
                         
        mw[109] = mw[006] * _AM_HBO_PA  ;+  mw[026] * _AM_HBO_AP    ;HBO PK DA NON   
        mw[110] = mw[007] * _AM_HBO_PA  ;+  mw[027] * _AM_HBO_AP    ;HBO PK SR NON   
        mw[111] = mw[008] * _AM_HBO_PA  ;+  mw[028] * _AM_HBO_AP    ;HBO PK SR HOV   
        
        mw[112] = mw[016] * _AM_HBC_PA  ;+  mw[036] * _AM_HBC_AP    ;HBC PK DA NON   
        mw[113] = mw[017] * _AM_HBC_PA  ;+  mw[037] * _AM_HBC_AP    ;HBC PK SR NON   
        mw[114] = mw[018] * _AM_HBC_PA  ;+  mw[038] * _AM_HBC_AP    ;HBC PK SR HOV   
        
        mw[105] = mw[085] * _AM_IX_PA  ;+  mw[088] * _AM_IX_AP      ;IX
        
        mw[104] = mw[901] * _AM_HBSch_PA  + ; mw[911] * _AM_HBSch_AP  +    ;HBSch - Drop Off
                  mw[911] * _AM_HBSch_PA  + ; mw[901] * _AM_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to AM * (DY + DY.T)
                  mw[902] * _AM_HBSch_PA ; +  mw[912] * _AM_HBSch_AP       ;HBSch - Drive Self
        
        mw[101]=mw[106]+mw[107]+mw[108]
        mw[102]=mw[109]+mw[110]+mw[111]
        mw[103]=mw[112]+mw[113]+mw[114]   
        mw[100]=mw[101]+mw[102]+mw[103]+mw[104]+mw[105]
        
        ;MD
        mw[206] = mw[041] * _MD_HBW_PA ; +  mw[061] * _MD_HBW_AP    ;HBW PK DA NON   
        mw[207] = mw[042] * _MD_HBW_PA ; +  mw[062] * _MD_HBW_AP    ;HBW PK SR NON   
        mw[208] = mw[043] * _MD_HBW_PA ; +  mw[063] * _MD_HBW_AP    ;HBW PK SR HOV   
                         
        mw[209] = mw[046] * _MD_HBO_PA ; +  mw[066] * _MD_HBO_AP    ;HBO PK DA NON   
        mw[210] = mw[047] * _MD_HBO_PA ; +  mw[067] * _MD_HBO_AP    ;HBO PK SR NON   
        mw[211] = mw[048] * _MD_HBO_PA ; +  mw[068] * _MD_HBO_AP    ;HBO PK SR HOV   
        
        mw[212] = mw[056] * _MD_HBC_PA ; +  mw[076] * _MD_HBC_AP    ;HBC PK DA NON   
        mw[213] = mw[057] * _MD_HBC_PA ; +  mw[077] * _MD_HBC_AP    ;HBC PK SR NON   
        mw[214] = mw[058] * _MD_HBC_PA ; +  mw[078] * _MD_HBC_AP    ;HBC PK SR HOV   
        
        mw[205] = mw[085] * _MD_IX_PA ; +  mw[088] * _MD_IX_AP      ;IX
        
        mw[204] = mw[901] * _MD_HBSch_PA  + ; mw[911] * _MD_HBSch_AP  +    ;HBSch - Drop Off
                  mw[911] * _MD_HBSch_PA  + ; mw[901] * _MD_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to MD * (DY + DY.T)
                  mw[902] * _MD_HBSch_PA ; +  mw[912] * _MD_HBSch_AP       ;HBSch - Drive Self
        
        mw[201]=mw[206]+mw[207]+mw[208]
        mw[202]=mw[209]+mw[210]+mw[211]
        mw[203]=mw[212]+mw[213]+mw[214]
        mw[200]=mw[201]+mw[202]+mw[203]+mw[204]+mw[205]
        
        
        ;PM
        mw[306] = mw[001] * _PM_HBW_PA  ;+  mw[021] * _PM_HBW_AP    ;HBW PK DA NON   
        mw[307] = mw[002] * _PM_HBW_PA  ;+  mw[022] * _PM_HBW_AP    ;HBW PK SR NON   
        mw[308] = mw[003] * _PM_HBW_PA  ;+  mw[023] * _PM_HBW_AP    ;HBW PK SR HOV   
                         
        mw[309] = mw[006] * _PM_HBO_PA  ;+  mw[026] * _PM_HBO_AP    ;HBO PK DA NON   
        mw[310] = mw[007] * _PM_HBO_PA  ;+  mw[027] * _PM_HBO_AP    ;HBO PK SR NON   
        mw[311] = mw[008] * _PM_HBO_PA  ;+  mw[028] * _PM_HBO_AP    ;HBO PK SR HOV   
        
        mw[312] = mw[016] * _PM_HBC_PA  ;+  mw[036] * _PM_HBC_AP    ;HBC PK DA NON   
        mw[313] = mw[017] * _PM_HBC_PA  ;+  mw[037] * _PM_HBC_AP    ;HBC PK SR NON   
        mw[314] = mw[018] * _PM_HBC_PA  ;+  mw[038] * _PM_HBC_AP    ;HBC PK SR HOV   
        
        mw[305] = mw[085] * _PM_IX_PA  ;+  mw[088] * _PM_IX_AP      ;IX
        
        mw[304] = mw[901] * _PM_HBSch_PA  + ; mw[911] * _PM_HBSch_AP  +    ;HBSch - Drop Off
                  mw[911] * _PM_HBSch_PA  + ; mw[901] * _PM_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to PM * (DY + DY.T)
                  mw[902] * _PM_HBSch_PA ; +  mw[912] * _PM_HBSch_AP       ;HBSch - Drive Self
        
        mw[301]=mw[306]+mw[307]+mw[308]
        mw[302]=mw[309]+mw[310]+mw[311]
        mw[303]=mw[312]+mw[313]+mw[314]  
        mw[300]=mw[301]+mw[302]+mw[303]+mw[304]+mw[305]
                                                                                   
                                                                                   
        ;EV                                                                        
        mw[406] = mw[041] * _EV_HBW_PA  ;+  mw[061] * _EV_HBW_AP    ;HBW PK DA NON   
        mw[407] = mw[042] * _EV_HBW_PA ; +  mw[062] * _EV_HBW_AP    ;HBW PK SR NON   
        mw[408] = mw[043] * _EV_HBW_PA ; +  mw[063] * _EV_HBW_AP    ;HBW PK SR HOV   
                         
        mw[409] = mw[046] * _EV_HBO_PA ; +  mw[066] * _EV_HBO_AP    ;HBO PK DA NON   
        mw[410] = mw[047] * _EV_HBO_PA ; +  mw[067] * _EV_HBO_AP    ;HBO PK SR NON   
        mw[411] = mw[048] * _EV_HBO_PA  ;+  mw[068] * _EV_HBO_AP    ;HBO PK SR HOV   
        
        mw[412] = mw[056] * _EV_HBC_PA  ;+  mw[076] * _EV_HBC_AP    ;HBC PK DA NON   
        mw[413] = mw[057] * _EV_HBC_PA ; +  mw[077] * _EV_HBC_AP    ;HBC PK SR NON   
        mw[414] = mw[058] * _EV_HBC_PA  ;+  mw[078] * _EV_HBC_AP    ;HBC PK SR HOV   
        
        mw[405] = mw[085] * _EV_IX_PA ; +  mw[088] * _EV_IX_AP      ;IX
        
        mw[404] = mw[901] * _EV_HBSch_PA  + ; mw[911] * _EV_HBSch_AP  +    ;HBSch - Drop Off
                  mw[911] * _EV_HBSch_PA  + ; mw[901] * _EV_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to EV * (DY + DY.T)
                  mw[902] * _EV_HBSch_PA  ;+  mw[912] * _EV_HBSch_AP       ;HBSch - Drive Self
        
        mw[401]=mw[406]+mw[407]+mw[408]
        mw[402]=mw[409]+mw[410]+mw[411]
        mw[403]=mw[412]+mw[413]+mw[414]
        mw[400]=mw[401]+mw[402]+mw[403]+mw[404]+mw[405]
        
        ;j
                ;AM 
        mw[116] = /* mw[001] * _AM_HBW_PA  + */ mw[021] * _AM_HBW_AP    ;HBW PK DA NON   
        mw[117] = /*  mw[002] * _AM_HBW_PA  +  */  mw[022] * _AM_HBW_AP    ;HBW PK SR NON   
        mw[118] = /*  mw[003] * _AM_HBW_PA  +  */  mw[023] * _AM_HBW_AP    ;HBW PK SR HOV   
                         
        mw[119] = /*  mw[006] * _AM_HBO_PA  + */   mw[026] * _AM_HBO_AP    ;HBO PK DA NON   
        mw[120] = /*  mw[007] * _AM_HBO_PA  + */   mw[027] * _AM_HBO_AP    ;HBO PK SR NON   
        mw[121] = /*  mw[008] * _AM_HBO_PA  + */   mw[028] * _AM_HBO_AP    ;HBO PK SR HOV   
        
        mw[122] = /*  mw[016] * _AM_HBC_PA  +  */  mw[036] * _AM_HBC_AP    ;HBC PK DA NON   
        mw[123] = /*  mw[017] * _AM_HBC_PA  +  */  mw[037] * _AM_HBC_AP    ;HBC PK SR NON   
        mw[124] =  /* mw[018] * _AM_HBC_PA  +  */  mw[038] * _AM_HBC_AP    ;HBC PK SR HOV   
        
        mw[115] = /*  mw[085] * _AM_IX_PA  +  */  mw[088] * _AM_IX_AP      ;IX
        
        mw[114] = /*  mw[901] * _AM_HBSch_PA  + */   mw[911] * _AM_HBSch_AP  +    ;HBSch - Drop Off
                  /*  mw[911] * _AM_HBSch_PA  + */   mw[901] * _AM_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to AM * (DY + DY.T)
                  /*  mw[902] * _AM_HBSch_PA  +  */  mw[912] * _AM_HBSch_AP       ;HBSch - Drive Self
        
        mw[111]=mw[116]+mw[117]+mw[118]
        mw[112]=mw[119]+mw[120]+mw[121]
        mw[113]=mw[122]+mw[123]+mw[124]   
        mw[110]=mw[111]+mw[112]+mw[113]+mw[114]+mw[115]
        
        ;MD
        mw[216] = /* mw[041] * _MD_HBW_PA  + */   mw[061] * _MD_HBW_AP    ;HBW PK DA NON   
        mw[217] = /* mw[042] * _MD_HBW_PA +   */  mw[062] * _MD_HBW_AP    ;HBW PK SR NON   
        mw[218] = /* mw[043] * _MD_HBW_PA +   */  mw[063] * _MD_HBW_AP    ;HBW PK SR HOV   
                         
        mw[219] = /* mw[046] * _MD_HBO_PA +   */  mw[066] * _MD_HBO_AP    ;HBO PK DA NON   
        mw[220] = /* mw[047] * _MD_HBO_PA +   */  mw[067] * _MD_HBO_AP    ;HBO PK SR NON   
        mw[221] = /* mw[048] * _MD_HBO_PA +   */  mw[068] * _MD_HBO_AP    ;HBO PK SR HOV   
        
        mw[222] = /* mw[056] * _MD_HBC_PA +   */  mw[076] * _MD_HBC_AP    ;HBC PK DA NON   
        mw[223] = /* mw[057] * _MD_HBC_PA +   */  mw[077] * _MD_HBC_AP    ;HBC PK SR NON   
        mw[224] = /* mw[058] * _MD_HBC_PA +   */  mw[078] * _MD_HBC_AP    ;HBC PK SR HOV   
        
        mw[215] = /* mw[085] * _MD_IX_PA +   */  mw[088] * _MD_IX_AP      ;IX
        
        mw[214] = /* mw[901] * _MD_HBSch_PA +   */  mw[911] * _MD_HBSch_AP  +    ;HBSch - Drop Off
                 /*  mw[911] * _MD_HBSch_PA +   */  mw[901] * _MD_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to MD * (DY + DY.T)
                 /*  mw[902] * _MD_HBSch_PA +   */  mw[912] * _MD_HBSch_AP       ;HBSch - Drive Self
        
        mw[211]=mw[216]+mw[217]+mw[218]
        mw[212]=mw[219]+mw[220]+mw[221]
        mw[213]=mw[222]+mw[223]+mw[224]
        mw[210]=mw[211]+mw[212]+mw[213]+mw[214]+mw[215]
        
        
        ;PM
        mw[316] = /* mw[001] * _PM_HBW_PA +   */  mw[021] * _PM_HBW_AP    ;HBW PK DA NON   
        mw[317] = /* mw[002] * _PM_HBW_PA +   */  mw[022] * _PM_HBW_AP    ;HBW PK SR NON   
        mw[318] = /* mw[003] * _PM_HBW_PA +   */  mw[023] * _PM_HBW_AP    ;HBW PK SR HOV   
                         
        mw[319] = /* mw[006] * _PM_HBO_PA +   */  mw[026] * _PM_HBO_AP    ;HBO PK DA NON   
        mw[320] = /* mw[007] * _PM_HBO_PA +   */  mw[027] * _PM_HBO_AP    ;HBO PK SR NON   
        mw[321] = /* mw[008] * _PM_HBO_PA +   */  mw[028] * _PM_HBO_AP    ;HBO PK SR HOV   
        
        mw[322] = /* mw[016] * _PM_HBC_PA +   */  mw[036] * _PM_HBC_AP    ;HBC PK DA NON   
        mw[323] = /* mw[017] * _PM_HBC_PA +   */  mw[037] * _PM_HBC_AP    ;HBC PK SR NON   
        mw[324] = /* mw[018] * _PM_HBC_PA +   */  mw[038] * _PM_HBC_AP    ;HBC PK SR HOV   
        
        mw[315] = /* mw[085] * _PM_IX_PA +   */  mw[088] * _PM_IX_AP      ;IX
        
        mw[314] = /* mw[901] * _PM_HBSch_PA +   */  mw[911] * _PM_HBSch_AP  +    ;HBSch - Drop Off
                 /*  mw[911] * _PM_HBSch_PA  +   */   mw[901] * _PM_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to PM * (DY + DY.T)
                 /*  mw[902] * _PM_HBSch_PA  +   */   mw[912] * _PM_HBSch_AP       ;HBSch - Drive Self
        
        mw[311]=mw[316]+mw[317]+mw[318]
        mw[312]=mw[319]+mw[320]+mw[321]
        mw[313]=mw[322]+mw[323]+mw[324]  
        mw[310]=mw[311]+mw[312]+mw[313]+mw[314]+mw[315]
                                                                                   
                                                                                   
        ;EV                                                                        
        mw[416] = /* mw[041] * _EV_HBW_PA +   */  mw[061] * _EV_HBW_AP    ;HBW PK DA NON   
        mw[417] = /* mw[042] * _EV_HBW_PA +   */  mw[062] * _EV_HBW_AP    ;HBW PK SR NON   
        mw[418] = /* mw[043] * _EV_HBW_PA +   */  mw[063] * _EV_HBW_AP    ;HBW PK SR HOV   
                         
        mw[419] = /* mw[046] * _EV_HBO_PA +   */  mw[066] * _EV_HBO_AP    ;HBO PK DA NON   
        mw[420] = /* mw[047] * _EV_HBO_PA +   */  mw[067] * _EV_HBO_AP    ;HBO PK SR NON   
        mw[421] = /* mw[048] * _EV_HBO_PA +   */  mw[068] * _EV_HBO_AP    ;HBO PK SR HOV   
        
        mw[422] = /* mw[056] * _EV_HBC_PA +   */  mw[076] * _EV_HBC_AP    ;HBC PK DA NON   
        mw[423] = /* mw[057] * _EV_HBC_PA +   */  mw[077] * _EV_HBC_AP    ;HBC PK SR NON   
        mw[424] = /* mw[058] * _EV_HBC_PA +   */  mw[078] * _EV_HBC_AP    ;HBC PK SR HOV   
        
        mw[415] = /* mw[085] * _EV_IX_PA +   */  mw[088] * _EV_IX_AP      ;IX
        
        mw[414] = /* mw[901] * _EV_HBSch_PA +   */  mw[911] * _EV_HBSch_AP  +    ;HBSch - Drop Off
                  /* mw[911] * _EV_HBSch_PA  +   */   mw[901] * _EV_HBSch_AP  +    ;HBSch - Drop Off Return Trip (note: Drop-Off & Drop-Off-Return resolve to EV * (DY + DY.T)
                  /* mw[902] * _EV_HBSch_PA  +   */   mw[912] * _EV_HBSch_AP       ;HBSch - Drive Self
        
        mw[411]=mw[416]+mw[417]+mw[418]
        mw[412]=mw[419]+mw[420]+mw[421]
        mw[413]=mw[422]+mw[423]+mw[424]
        mw[410]=mw[411]+mw[412]+mw[413]+mw[414]+mw[415]

    ENDJLOOP

ENDRUN


RUN PGM=MATRIX   MSG='VMT calculation for all TAZs'
    FILEI MATI[01] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\am3hr_managed3.mtx'
    FILEI MATI[02] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\md6hr_managed3.mtx'
    FILEI MATI[03] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\pm3hr_managed3.mtx'    
    FILEI MATI[04] = '@ParentDir@@ScenarioDir@5_AssignHwy\1_ODTables\ev12hr_managed3.mtx'  
    FILEI MATI[05] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\skm_AM.mtx'
    FILEI MATI[06] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\skm_MD.mtx'
    FILEI MATI[07] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\skm_PM.mtx'    
    FILEI MATI[08] = '@ParentDir@@ScenarioDir@5_AssignHwy\5_FinalNetSkims\skm_EV.mtx' 
    FILEI MATI[11] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBW_trips_allsegs_pkok.mtx'
    FILEI MATI[12] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBO_trips_allsegs_pkok.mtx'
    FILEI MATI[13] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\HBC_trips_allsegs_pkok.mtx'
    FILEI MATI[14] = '@ParentDir@@ScenarioDir@4_ModeChoice\2_DetailedTripMatrices\AllTrips_pkok.mtx'
    
    ZONES   = @UsedZones@
    ZONEMSG = 100
    mw[1]=mi.1.total*mi.5.GP_dist + mi.2.total*mi.6.GP_dist + mi.3.total*mi.7.GP_dist + mi.4.total*mi.8.GP_dist
    mw[2]=mi.1.HBW*mi.5.GP_dist  + mi.2.HBW*mi.6.GP_dist + mi.3.HBW*mi.7.GP_dist + mi.4.HBW*mi.8.GP_dist
    mw[3]=mi.1.HBO*mi.5.GP_dist  + mi.2.HBO*mi.6.GP_dist + mi.3.HBO*mi.7.GP_dist + mi.4.HBO*mi.8.GP_dist
    mw[4]=mi.1.HBC*mi.5.GP_dist  + mi.2.HBC*mi.6.GP_dist + mi.3.HBC*mi.7.GP_dist + mi.4.HBC*mi.8.GP_dist
    mw[5]=mi.1.HBSch*mi.5.GP_dist  + mi.2.HBSch*mi.6.GP_dist + mi.3.HBSch*mi.7.GP_dist + mi.4.HBSch*mi.8.GP_dist  
    mw[6]=mi.1.IX*mi.5.GP_dist  + mi.2.IX*mi.6.GP_dist + mi.3.IX*mi.7.GP_dist + mi.4.IX*mi.8.GP_dist  
    
    mw[11]=mi.1.totalT.T*mi.5.GP_dist.t  + mi.2.totalT.T*mi.6.GP_dist.t + mi.3.totalT.T*mi.7.GP_dist.t + mi.4.totalT.T*mi.8.GP_dist.t
    mw[12]=mi.1.HBWT.T*mi.5.GP_dist.t + mi.2.HBWT.T*mi.6.GP_dist.t + mi.3.HBWT.T*mi.7.GP_dist.t + mi.4.HBWT.T*mi.8.GP_dist.t
    mw[13]=mi.1.HBOT.T*mi.5.GP_dist.t + mi.2.HBOT.T*mi.6.GP_dist.t + mi.3.HBOT.T*mi.7.GP_dist.t + mi.4.HBOT.T*mi.8.GP_dist.t
    mw[14]=mi.1.HBCT.T*mi.5.GP_dist.t + mi.2.HBCT.T*mi.6.GP_dist.t + mi.3.HBCT.T*mi.7.GP_dist.t + mi.4.HBCT.T*mi.8.GP_dist.t
    mw[15]=mi.1.HBsCT.T*mi.5.GP_dist.t + mi.2.HBsCT.T*mi.6.GP_dist.t + mi.3.HBsCT.T*mi.7.GP_dist.t + mi.4.HBsCT.T*mi.8.GP_dist.t
    mw[16]=mi.1.IXT.T*mi.5.GP_dist.t + mi.2.IXT.T*mi.6.GP_dist.t + mi.3.IXT.T*mi.7.GP_dist.t + mi.4.IXT.T*mi.8.GP_dist.t
      
    mw[101]=mw[1]+mw[11]
    mw[102]=mw[2]+mw[12]
    mw[103]=mw[3]+mw[13]
    mw[104]=mw[4]+mw[14]
    mw[105]=mw[5]+mw[15]
    mw[106]=mw[6]+mw[16]
    
    mw[110]=mi.11.transit+mi.12.transit+mi.13.transit
    mw[111]=mi.14.transit
    
      VMT_Total = ROWSUM(101)
      VMT_HBW   = ROWSUM(102)
      VMT_HBO   = ROWSUM(103)
      VMT_HBC   = ROWSUM(104)
      VMT_HBSC  = ROWSUM(105)
      VMT_IX    = ROWSUM(106)
      TrnTrpsHB = ROWSUM(110)/100
      TrnTrpsal = ROWSUM(111)/100
      
      IF(i==1)
            PRINT FILE='@ParentDir@@ScenarioDir@7_PostProcessing\VMT_Produced_byTAZ_Result.csv', 
            APPEND=T,
                        FORM=10.2, 
                        CSV=T, 
                        LIST='TAZ',
                        'VMT_Total', /*
                        'VMT_HBW', 
                        'VMT_HBO',
                        'VMT_HBC',
                        'VMT_HBSC',
                        'VMT_IX',
                        'TrnTrpsHB', */
                        'TrnTrpsal'
      ENDIF
            PRINT FILE='@ParentDir@@ScenarioDir@7_PostProcessing\VMT_Produced_byTAZ_Result.csv', 
            APPEND=T,
                        FORM=10.2, 
                        CSV=T, 
                        LIST=i,
                        VMT_Total/1, /*
                        VMT_HBW/1, 
                        VMT_HBO/1,
                        VMT_HBC/1,
                        VMT_HBSC/1,
                        VMT_IX/1,
                        TrnTrpsHB , */
                        TrnTrpsal
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    VMT Production by TAZ              ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(del 01_Convert_PA_to_OD.txt)
