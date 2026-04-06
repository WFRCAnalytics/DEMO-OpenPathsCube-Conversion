
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_CalculateTimeOfDayFac.txt)



;get get start time
ScriptStartTime = currenttime()




RUN PGM=MATRIX MSG='Time of Day Factors: Calculate Time of Day Factors'

FILEI LOOKUPI[1] = '@ParentDir@1_Inputs\0_GlobalData\5_Assignment\Time Of Day Factors.csv'

FILEO PRINTO[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\_TimeOfDayFactors.txt'
    
    
    
    ZONES = 1
    
    
    
    ;define lookup function
    LOOKUP LOOKUPI=1,
        LIST=F,
        INTERPOLATE=T,
        NAME=TimeOfDayFac,
        Lookup[01]=01,  RESULT=02,    ;AM_PCT
        Lookup[02]=01,  RESULT=03,    ;MD_PCT
        Lookup[03]=01,  RESULT=04,    ;PM_PCT
        Lookup[04]=01,  RESULT=05,    ;EV_PCT
        Lookup[05]=01,  RESULT=06,    ;AM_PA
        Lookup[06]=01,  RESULT=07,    ;MD_PA
        Lookup[07]=01,  RESULT=08,    ;EV_PA
        Lookup[08]=01,  RESULT=09     ;EV_PA
    
    
    
    ;row index for TimeOfDayFac lookup function --------------------------------------------------------------
    ;   idx   pupr (II)        idx   purp (IX)       idx   purp (XI)       idx   purp (XX)
    ;  10000  (not in use)    20000  IX             30000  XI             40000  XX    
    ;  10100  HBW             20100  IX_HBW         30100  XI_HBW         40100  XX_HBW
    ;  10200  HBO             20200  IX_HBO         30200  XI_HBO         40200  XX_HBO
    ;  10300  NHB             20300  IX_NHB         30300  XI_NHB         40300  XX_NHB
    ;  10400  HBS             20400  IX_HBS         30400  XI_HBS         40400  XX_HBS
    ;  10500  HBC             20500  IX_HBC         30500  XI_HBC         40500  XX_HBC
    ;  10600  Rec             20600  IX_Rec         30600  XI_Rec         40600  XX_Rec
    ;  10700  LT              20700  IX_LT          30700  XI_LT          40700  XX_LT 
    ;  10800  MD              20800  IX_MD          30800  XI_MD          40800  XX_MD 
    ;  10900  HV              20900  IX_HV          30900  XI_HV          40900  XX_HV 
    ;  10210  HBShp
    ;  10220  HBOth
    ;  10310  NHBW
    ;  10320  NHBNW
    ;
    ;col (or curve) index for TimeOfDayFac lookup function
    ;  idx  curve      idx curve 
    ;   01 AM_PCT       05 AM_PA
    ;   02 MD_PCT       06 MD_PA
    ;   03 PM_PCT       07 EV_PA
    ;   04 EV_PCT       08 EV_PA
    
    ;set column indices (parameterized for future weekend & seasonal modeling)
    _prd_AM = 01
    _prd_MD = 02
    _prd_PM = 03
    _prd_EV = 04
    
    _PA_AM = _prd_AM + 4
    _PA_MD = _prd_MD + 4
    _PA_PM = _prd_PM + 4
    _PA_EV = _prd_EV + 4
    
    
    ;set row indices
    ;purpose
    idx_Tot   = 000
    idx_HBW   = 100
    
    idx_HBO   = 200
    idx_HBShp = 210
    idx_HBOth = 220
    
    idx_NHB   = 300
    idx_NHBW  = 310
    idx_NHBNW = 320
    
    idx_HBS   = 400
    
    idx_HBC   = 500
    
    idx_Rec   = 600
    idx_LT    = 700
    idx_MD    = 800
    idx_HV    = 900
    
    ;HBC by separate colleges
    idx_HBC_BYU       = 510
    idx_HBC_ENSIGN    = 520
    idx_HBC_SLCC      = 530
    idx_HBC_SLCC_MAIN = 540
    idx_HBC_SLCC_JD   = 541
    idx_HBC_SLCC_ML   = 542
    idx_HBC_SLCC_SC   = 543
    idx_HBC_UOFU_MAIN = 550
    idx_HBC_WSU       = 560
    idx_HBC_WSU_MAIN  = 561
    idx_HBC_WSU_DAVIS = 562
    idx_HBC_UVU       = 570
    idx_HBC_WESTMIN   = 580
    
    
    ;row index
    ;  note row index = movement + purpose
    idx_II_HBW   = 10000 + idx_HBW
    idx_II_HBO   = 10000 + idx_HBO
    idx_II_NHB   = 10000 + idx_NHB
    idx_II_HBS   = 10000 + idx_HBS
    idx_II_HBC   = 10000 + idx_HBC
    idx_II_Rec   = 10000 + idx_Rec
    idx_II_LT    = 10000 + idx_LT
    idx_II_MD    = 10000 + idx_MD
    idx_II_HV    = 10000 + idx_HV
    idx_II_HBShp = 10000 + idx_HBShp
    idx_II_HBOth = 10000 + idx_HBOth
    idx_II_NHBW  = 10000 + idx_NHBW
    idx_II_NHBNW = 10000 + idx_NHBNW
    
    idx_IX_Tot   = 20000 + idx_Tot
    idx_IX_HBW   = 20000 + idx_HBW
    idx_IX_HBO   = 20000 + idx_HBO
    idx_IX_NHB   = 20000 + idx_NHB
    idx_IX_HBS   = 20000 + idx_HBS
    idx_IX_HBC   = 20000 + idx_HBC
    idx_IX_Rec   = 20000 + idx_Rec
    idx_IX_LT    = 20000 + idx_LT
    idx_IX_MD    = 20000 + idx_MD
    idx_IX_HV    = 20000 + idx_HV
    
    idx_XI_Tot   = 30000 + idx_Tot
    idx_XI_HBW   = 30000 + idx_HBW
    idx_XI_HBO   = 30000 + idx_HBO
    idx_XI_NHB   = 30000 + idx_NHB
    idx_XI_HBS   = 30000 + idx_HBS
    idx_XI_HBC   = 30000 + idx_HBC
    idx_XI_Rec   = 30000 + idx_Rec
    idx_XI_LT    = 30000 + idx_LT
    idx_XI_MD    = 30000 + idx_MD
    idx_XI_HV    = 30000 + idx_HV
    
    idx_XX_Tot   = 40000 + idx_Tot
    idx_XX_HBW   = 40000 + idx_HBW
    idx_XX_HBO   = 40000 + idx_HBO
    idx_XX_NHB   = 40000 + idx_NHB
    idx_XX_HBS   = 40000 + idx_HBS
    idx_XX_HBC   = 40000 + idx_HBC
    idx_XX_Rec   = 40000 + idx_Rec
    idx_XX_LT    = 40000 + idx_LT
    idx_XX_MD    = 40000 + idx_MD
    idx_XX_HV    = 40000 + idx_HV
    
    ;HBC by separate colleges
    idx_II_idx_HBC_BYU       = 10000 + idx_HBC_BYU
    idx_II_idx_HBC_ENSIGN    = 10000 + idx_HBC_ENSIGN
    idx_II_idx_HBC_SLCC      = 10000 + idx_HBC_SLCC
    idx_II_idx_HBC_SLCC_MAIN = 10000 + idx_HBC_SLCC_MAIN
    idx_II_idx_HBC_SLCC_JD   = 10000 + idx_HBC_SLCC_JD
    idx_II_idx_HBC_SLCC_ML   = 10000 + idx_HBC_SLCC_ML
    idx_II_idx_HBC_SLCC_SC   = 10000 + idx_HBC_SLCC_SC
    idx_II_idx_HBC_UOFU_MAIN = 10000 + idx_HBC_UOFU_MAIN
    idx_II_idx_HBC_WSU       = 10000 + idx_HBC_WSU
    idx_II_idx_HBC_WSU_MAIN  = 10000 + idx_HBC_WSU_MAIN
    idx_II_idx_HBC_WSU_DAVIS = 10000 + idx_HBC_WSU_DAVIS
    idx_II_idx_HBC_UVU       = 10000 + idx_HBC_UVU
    idx_II_idx_HBC_WESTMIN   = 10000 + idx_HBC_WESTMIN
    
    
    
    ;calculate period factors by purpose ---------------------------------------------------------------------
    ;AM %
    Pct_AM_HBW    = TimeOfDayFac(_prd_AM, idx_II_HBW  )
    Pct_AM_HBO    = TimeOfDayFac(_prd_AM, idx_II_HBO  )
    Pct_AM_NHB    = TimeOfDayFac(_prd_AM, idx_II_NHB  )
    Pct_AM_HBS    = TimeOfDayFac(_prd_AM, idx_II_HBS  )
    Pct_AM_HBC    = TimeOfDayFac(_prd_AM, idx_II_HBC  )
    Pct_AM_Rec    = TimeOfDayFac(_prd_AM, idx_II_Rec  )
    Pct_AM_LT     = TimeOfDayFac(_prd_AM, idx_II_LT   )
    Pct_AM_MD     = TimeOfDayFac(_prd_AM, idx_II_MD   )
    Pct_AM_HV     = TimeOfDayFac(_prd_AM, idx_II_HV   )
    Pct_AM_HBShp  = TimeOfDayFac(_prd_AM, idx_II_HBShp)
    Pct_AM_HBOth  = TimeOfDayFac(_prd_AM, idx_II_HBOth)
    Pct_AM_NHBW   = TimeOfDayFac(_prd_AM, idx_II_NHBW )
    Pct_AM_NHBNW  = TimeOfDayFac(_prd_AM, idx_II_NHBNW)
    
    Pct_AM_IX     = TimeOfDayFac(_prd_AM, idx_IX_Tot  )
    Pct_AM_IX_HBW = TimeOfDayFac(_prd_AM, idx_IX_HBW  )
    Pct_AM_IX_HBO = TimeOfDayFac(_prd_AM, idx_IX_HBO  )
    Pct_AM_IX_NHB = TimeOfDayFac(_prd_AM, idx_IX_NHB  )
    Pct_AM_IX_HBS = TimeOfDayFac(_prd_AM, idx_IX_HBS  )
    Pct_AM_IX_HBC = TimeOfDayFac(_prd_AM, idx_IX_HBC  )
    Pct_AM_IX_Rec = TimeOfDayFac(_prd_AM, idx_IX_Rec  )
    Pct_AM_IX_LT  = TimeOfDayFac(_prd_AM, idx_IX_LT   )
    Pct_AM_IX_MD  = TimeOfDayFac(_prd_AM, idx_IX_MD   )
    Pct_AM_IX_HV  = TimeOfDayFac(_prd_AM, idx_IX_HV   )
    
    Pct_AM_XI     = TimeOfDayFac(_prd_AM, idx_XI_Tot  )
    Pct_AM_XI_HBW = TimeOfDayFac(_prd_AM, idx_XI_HBW  )
    Pct_AM_XI_HBO = TimeOfDayFac(_prd_AM, idx_XI_HBO  )
    Pct_AM_XI_NHB = TimeOfDayFac(_prd_AM, idx_XI_NHB  )
    Pct_AM_XI_HBS = TimeOfDayFac(_prd_AM, idx_XI_HBS  )
    Pct_AM_XI_HBC = TimeOfDayFac(_prd_AM, idx_XI_HBC  )
    Pct_AM_XI_Rec = TimeOfDayFac(_prd_AM, idx_XI_Rec  )
    Pct_AM_XI_LT  = TimeOfDayFac(_prd_AM, idx_XI_LT   )
    Pct_AM_XI_MD  = TimeOfDayFac(_prd_AM, idx_XI_MD   )
    Pct_AM_XI_HV  = TimeOfDayFac(_prd_AM, idx_XI_HV   )
    
    Pct_AM_XX     = TimeOfDayFac(_prd_AM, idx_XX_Tot  )
    Pct_AM_XX_HBW = TimeOfDayFac(_prd_AM, idx_XX_HBW  )
    Pct_AM_XX_HBO = TimeOfDayFac(_prd_AM, idx_XX_HBO  )
    Pct_AM_XX_NHB = TimeOfDayFac(_prd_AM, idx_XX_NHB  )
    Pct_AM_XX_HBS = TimeOfDayFac(_prd_AM, idx_XX_HBS  )
    Pct_AM_XX_HBC = TimeOfDayFac(_prd_AM, idx_XX_HBC  )
    Pct_AM_XX_Rec = TimeOfDayFac(_prd_AM, idx_XX_Rec  )
    Pct_AM_XX_LT  = TimeOfDayFac(_prd_AM, idx_XX_LT   )
    Pct_AM_XX_MD  = TimeOfDayFac(_prd_AM, idx_XX_MD   )
    Pct_AM_XX_HV  = TimeOfDayFac(_prd_AM, idx_XX_HV   )
    
    ;MD %
    Pct_MD_HBW    = TimeOfDayFac(_prd_MD, idx_II_HBW  )
    Pct_MD_HBO    = TimeOfDayFac(_prd_MD, idx_II_HBO  )
    Pct_MD_NHB    = TimeOfDayFac(_prd_MD, idx_II_NHB  )
    Pct_MD_HBS    = TimeOfDayFac(_prd_MD, idx_II_HBS  )
    Pct_MD_HBC    = TimeOfDayFac(_prd_MD, idx_II_HBC  )
    Pct_MD_Rec    = TimeOfDayFac(_prd_MD, idx_II_Rec  )
    Pct_MD_LT     = TimeOfDayFac(_prd_MD, idx_II_LT   )
    Pct_MD_MD     = TimeOfDayFac(_prd_MD, idx_II_MD   )
    Pct_MD_HV     = TimeOfDayFac(_prd_MD, idx_II_HV   )
    Pct_MD_HBShp  = TimeOfDayFac(_prd_MD, idx_II_HBShp)
    Pct_MD_HBOth  = TimeOfDayFac(_prd_MD, idx_II_HBOth)
    Pct_MD_NHBW   = TimeOfDayFac(_prd_MD, idx_II_NHBW )
    Pct_MD_NHBNW  = TimeOfDayFac(_prd_MD, idx_II_NHBNW)
    
    Pct_MD_IX     = TimeOfDayFac(_prd_MD, idx_IX_Tot  )
    Pct_MD_IX_HBW = TimeOfDayFac(_prd_MD, idx_IX_HBW  )
    Pct_MD_IX_HBO = TimeOfDayFac(_prd_MD, idx_IX_HBO  )
    Pct_MD_IX_NHB = TimeOfDayFac(_prd_MD, idx_IX_NHB  )
    Pct_MD_IX_HBS = TimeOfDayFac(_prd_MD, idx_IX_HBS  )
    Pct_MD_IX_HBC = TimeOfDayFac(_prd_MD, idx_IX_HBC  )
    Pct_MD_IX_Rec = TimeOfDayFac(_prd_MD, idx_IX_Rec  )
    Pct_MD_IX_LT  = TimeOfDayFac(_prd_MD, idx_IX_LT   )
    Pct_MD_IX_MD  = TimeOfDayFac(_prd_MD, idx_IX_MD   )
    Pct_MD_IX_HV  = TimeOfDayFac(_prd_MD, idx_IX_HV   )
    
    Pct_MD_XI     = TimeOfDayFac(_prd_MD, idx_XI_Tot  )
    Pct_MD_XI_HBW = TimeOfDayFac(_prd_MD, idx_XI_HBW  )
    Pct_MD_XI_HBO = TimeOfDayFac(_prd_MD, idx_XI_HBO  )
    Pct_MD_XI_NHB = TimeOfDayFac(_prd_MD, idx_XI_NHB  )
    Pct_MD_XI_HBS = TimeOfDayFac(_prd_MD, idx_XI_HBS  )
    Pct_MD_XI_HBC = TimeOfDayFac(_prd_MD, idx_XI_HBC  )
    Pct_MD_XI_Rec = TimeOfDayFac(_prd_MD, idx_XI_Rec  )
    Pct_MD_XI_LT  = TimeOfDayFac(_prd_MD, idx_XI_LT   )
    Pct_MD_XI_MD  = TimeOfDayFac(_prd_MD, idx_XI_MD   )
    Pct_MD_XI_HV  = TimeOfDayFac(_prd_MD, idx_XI_HV   )
    
    Pct_MD_XX     = TimeOfDayFac(_prd_MD, idx_XX_Tot  )
    Pct_MD_XX_HBW = TimeOfDayFac(_prd_MD, idx_XX_HBW  )
    Pct_MD_XX_HBO = TimeOfDayFac(_prd_MD, idx_XX_HBO  )
    Pct_MD_XX_NHB = TimeOfDayFac(_prd_MD, idx_XX_NHB  )
    Pct_MD_XX_HBS = TimeOfDayFac(_prd_MD, idx_XX_HBS  )
    Pct_MD_XX_HBC = TimeOfDayFac(_prd_MD, idx_XX_HBC  )
    Pct_MD_XX_Rec = TimeOfDayFac(_prd_MD, idx_XX_Rec  )
    Pct_MD_XX_LT  = TimeOfDayFac(_prd_MD, idx_XX_LT   )
    Pct_MD_XX_MD  = TimeOfDayFac(_prd_MD, idx_XX_MD   )
    Pct_MD_XX_HV  = TimeOfDayFac(_prd_MD, idx_XX_HV   )
    
    ;PM %
    Pct_PM_HBW    = TimeOfDayFac(_prd_PM, idx_II_HBW  )
    Pct_PM_HBO    = TimeOfDayFac(_prd_PM, idx_II_HBO  )
    Pct_PM_NHB    = TimeOfDayFac(_prd_PM, idx_II_NHB  )
    Pct_PM_HBS    = TimeOfDayFac(_prd_PM, idx_II_HBS  )
    Pct_PM_HBC    = TimeOfDayFac(_prd_PM, idx_II_HBC  )
    Pct_PM_Rec    = TimeOfDayFac(_prd_PM, idx_II_Rec  )
    Pct_PM_LT     = TimeOfDayFac(_prd_PM, idx_II_LT   )
    Pct_PM_MD     = TimeOfDayFac(_prd_PM, idx_II_MD   )
    Pct_PM_HV     = TimeOfDayFac(_prd_PM, idx_II_HV   )
    Pct_PM_HBShp  = TimeOfDayFac(_prd_PM, idx_II_HBShp)
    Pct_PM_HBOth  = TimeOfDayFac(_prd_PM, idx_II_HBOth)
    Pct_PM_NHBW   = TimeOfDayFac(_prd_PM, idx_II_NHBW )
    Pct_PM_NHBNW  = TimeOfDayFac(_prd_PM, idx_II_NHBNW)
    
    Pct_PM_IX     = TimeOfDayFac(_prd_PM, idx_IX_Tot  )
    Pct_PM_IX_HBW = TimeOfDayFac(_prd_PM, idx_IX_HBW  )
    Pct_PM_IX_HBO = TimeOfDayFac(_prd_PM, idx_IX_HBO  )
    Pct_PM_IX_NHB = TimeOfDayFac(_prd_PM, idx_IX_NHB  )
    Pct_PM_IX_HBS = TimeOfDayFac(_prd_PM, idx_IX_HBS  )
    Pct_PM_IX_HBC = TimeOfDayFac(_prd_PM, idx_IX_HBC  )
    Pct_PM_IX_Rec = TimeOfDayFac(_prd_PM, idx_IX_Rec  )
    Pct_PM_IX_LT  = TimeOfDayFac(_prd_PM, idx_IX_LT   )
    Pct_PM_IX_MD  = TimeOfDayFac(_prd_PM, idx_IX_MD   )
    Pct_PM_IX_HV  = TimeOfDayFac(_prd_PM, idx_IX_HV   )
    
    Pct_PM_XI     = TimeOfDayFac(_prd_PM, idx_XI_Tot  )
    Pct_PM_XI_HBW = TimeOfDayFac(_prd_PM, idx_XI_HBW  )
    Pct_PM_XI_HBO = TimeOfDayFac(_prd_PM, idx_XI_HBO  )
    Pct_PM_XI_NHB = TimeOfDayFac(_prd_PM, idx_XI_NHB  )
    Pct_PM_XI_HBS = TimeOfDayFac(_prd_PM, idx_XI_HBS  )
    Pct_PM_XI_HBC = TimeOfDayFac(_prd_PM, idx_XI_HBC  )
    Pct_PM_XI_Rec = TimeOfDayFac(_prd_PM, idx_XI_Rec  )
    Pct_PM_XI_LT  = TimeOfDayFac(_prd_PM, idx_XI_LT   )
    Pct_PM_XI_MD  = TimeOfDayFac(_prd_PM, idx_XI_MD   )
    Pct_PM_XI_HV  = TimeOfDayFac(_prd_PM, idx_XI_HV   )
    
    Pct_PM_XX     = TimeOfDayFac(_prd_PM, idx_XX_Tot  )
    Pct_PM_XX_HBW = TimeOfDayFac(_prd_PM, idx_XX_HBW  )
    Pct_PM_XX_HBO = TimeOfDayFac(_prd_PM, idx_XX_HBO  )
    Pct_PM_XX_NHB = TimeOfDayFac(_prd_PM, idx_XX_NHB  )
    Pct_PM_XX_HBS = TimeOfDayFac(_prd_PM, idx_XX_HBS  )
    Pct_PM_XX_HBC = TimeOfDayFac(_prd_PM, idx_XX_HBC  )
    Pct_PM_XX_Rec = TimeOfDayFac(_prd_PM, idx_XX_Rec  )
    Pct_PM_XX_LT  = TimeOfDayFac(_prd_PM, idx_XX_LT   )
    Pct_PM_XX_MD  = TimeOfDayFac(_prd_PM, idx_XX_MD   )
    Pct_PM_XX_HV  = TimeOfDayFac(_prd_PM, idx_XX_HV   )
    
    ;EV %
    Pct_EV_HBW    = TimeOfDayFac(_prd_EV, idx_II_HBW  )
    Pct_EV_HBO    = TimeOfDayFac(_prd_EV, idx_II_HBO  )
    Pct_EV_NHB    = TimeOfDayFac(_prd_EV, idx_II_NHB  )
    Pct_EV_HBS    = TimeOfDayFac(_prd_EV, idx_II_HBS  )
    Pct_EV_HBC    = TimeOfDayFac(_prd_EV, idx_II_HBC  )
    Pct_EV_Rec    = TimeOfDayFac(_prd_EV, idx_II_Rec  )
    Pct_EV_LT     = TimeOfDayFac(_prd_EV, idx_II_LT   )
    Pct_EV_MD     = TimeOfDayFac(_prd_EV, idx_II_MD   )
    Pct_EV_HV     = TimeOfDayFac(_prd_EV, idx_II_HV   )
    Pct_EV_HBShp  = TimeOfDayFac(_prd_EV, idx_II_HBShp)
    Pct_EV_HBOth  = TimeOfDayFac(_prd_EV, idx_II_HBOth)
    Pct_EV_NHBW   = TimeOfDayFac(_prd_EV, idx_II_NHBW )
    Pct_EV_NHBNW  = TimeOfDayFac(_prd_EV, idx_II_NHBNW)
    
    Pct_EV_IX     = TimeOfDayFac(_prd_EV, idx_IX_Tot  )
    Pct_EV_IX_HBW = TimeOfDayFac(_prd_EV, idx_IX_HBW  )
    Pct_EV_IX_HBO = TimeOfDayFac(_prd_EV, idx_IX_HBO  )
    Pct_EV_IX_NHB = TimeOfDayFac(_prd_EV, idx_IX_NHB  )
    Pct_EV_IX_HBS = TimeOfDayFac(_prd_EV, idx_IX_HBS  )
    Pct_EV_IX_HBC = TimeOfDayFac(_prd_EV, idx_IX_HBC  )
    Pct_EV_IX_Rec = TimeOfDayFac(_prd_EV, idx_IX_Rec  )
    Pct_EV_IX_LT  = TimeOfDayFac(_prd_EV, idx_IX_LT   )
    Pct_EV_IX_MD  = TimeOfDayFac(_prd_EV, idx_IX_MD   )
    Pct_EV_IX_HV  = TimeOfDayFac(_prd_EV, idx_IX_HV   )
    
    Pct_EV_XI     = TimeOfDayFac(_prd_EV, idx_XI_Tot  )
    Pct_EV_XI_HBW = TimeOfDayFac(_prd_EV, idx_XI_HBW  )
    Pct_EV_XI_HBO = TimeOfDayFac(_prd_EV, idx_XI_HBO  )
    Pct_EV_XI_NHB = TimeOfDayFac(_prd_EV, idx_XI_NHB  )
    Pct_EV_XI_HBS = TimeOfDayFac(_prd_EV, idx_XI_HBS  )
    Pct_EV_XI_HBC = TimeOfDayFac(_prd_EV, idx_XI_HBC  )
    Pct_EV_XI_Rec = TimeOfDayFac(_prd_EV, idx_XI_Rec  )
    Pct_EV_XI_LT  = TimeOfDayFac(_prd_EV, idx_XI_LT   )
    Pct_EV_XI_MD  = TimeOfDayFac(_prd_EV, idx_XI_MD   )
    Pct_EV_XI_HV  = TimeOfDayFac(_prd_EV, idx_XI_HV   )
    
    Pct_EV_XX     = TimeOfDayFac(_prd_EV, idx_XX_Tot  )
    Pct_EV_XX_HBW = TimeOfDayFac(_prd_EV, idx_XX_HBW  )
    Pct_EV_XX_HBO = TimeOfDayFac(_prd_EV, idx_XX_HBO  )
    Pct_EV_XX_NHB = TimeOfDayFac(_prd_EV, idx_XX_NHB  )
    Pct_EV_XX_HBS = TimeOfDayFac(_prd_EV, idx_XX_HBS  )
    Pct_EV_XX_HBC = TimeOfDayFac(_prd_EV, idx_XX_HBC  )
    Pct_EV_XX_Rec = TimeOfDayFac(_prd_EV, idx_XX_Rec  )
    Pct_EV_XX_LT  = TimeOfDayFac(_prd_EV, idx_XX_LT   )
    Pct_EV_XX_MD  = TimeOfDayFac(_prd_EV, idx_XX_MD   )
    Pct_EV_XX_HV  = TimeOfDayFac(_prd_EV, idx_XX_HV   )
    
    
    ;calculate period & directional (PA or AP) factors for HBC by separate colleges
    ;AM %
    Pct_AM_HBC_BYU       = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_BYU      )
    Pct_AM_HBC_ENSIGN    = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_ENSIGN   )
    Pct_AM_HBC_SLCC      = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_SLCC     )
    Pct_AM_HBC_SLCC_MAIN = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_SLCC_MAIN)
    Pct_AM_HBC_SLCC_JD   = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_SLCC_JD  )
    Pct_AM_HBC_SLCC_ML   = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_SLCC_ML  )
    Pct_AM_HBC_SLCC_SC   = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_SLCC_SC  )
    Pct_AM_HBC_UOFU_MAIN = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_UOFU_MAIN)
    Pct_AM_HBC_WSU       = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_WSU      )
    Pct_AM_HBC_WSU_MAIN  = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_WSU_MAIN )
    Pct_AM_HBC_WSU_DAVIS = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_WSU_DAVIS)
    Pct_AM_HBC_UVU       = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_UVU      )
    Pct_AM_HBC_WESTMIN   = TimeOfDayFac(_prd_AM, idx_II_idx_HBC_WESTMIN  )
    
    ;MD %
    Pct_MD_HBC_BYU       = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_BYU      )
    Pct_MD_HBC_ENSIGN    = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_ENSIGN   )
    Pct_MD_HBC_SLCC      = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_SLCC     )
    Pct_MD_HBC_SLCC_MAIN = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_SLCC_MAIN)
    Pct_MD_HBC_SLCC_JD   = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_SLCC_JD  )
    Pct_MD_HBC_SLCC_ML   = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_SLCC_ML  )
    Pct_MD_HBC_SLCC_SC   = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_SLCC_SC  )
    Pct_MD_HBC_UOFU_MAIN = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_UOFU_MAIN)
    Pct_MD_HBC_WSU       = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_WSU      )
    Pct_MD_HBC_WSU_MAIN  = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_WSU_MAIN )
    Pct_MD_HBC_WSU_DAVIS = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_WSU_DAVIS)
    Pct_MD_HBC_UVU       = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_UVU      )
    Pct_MD_HBC_WESTMIN   = TimeOfDayFac(_prd_MD, idx_II_idx_HBC_WESTMIN  )
    
    ;PM %
    Pct_PM_HBC_BYU       = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_BYU      )
    Pct_PM_HBC_ENSIGN    = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_ENSIGN   )
    Pct_PM_HBC_SLCC      = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_SLCC     )
    Pct_PM_HBC_SLCC_MAIN = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_SLCC_MAIN)
    Pct_PM_HBC_SLCC_JD   = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_SLCC_JD  )
    Pct_PM_HBC_SLCC_ML   = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_SLCC_ML  )
    Pct_PM_HBC_SLCC_SC   = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_SLCC_SC  )
    Pct_PM_HBC_UOFU_MAIN = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_UOFU_MAIN)
    Pct_PM_HBC_WSU       = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_WSU      )
    Pct_PM_HBC_WSU_MAIN  = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_WSU_MAIN )
    Pct_PM_HBC_WSU_DAVIS = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_WSU_DAVIS)
    Pct_PM_HBC_UVU       = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_UVU      )
    Pct_PM_HBC_WESTMIN   = TimeOfDayFac(_prd_PM, idx_II_idx_HBC_WESTMIN  )
    
    ;EV %
    Pct_EV_HBC_BYU       = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_BYU      )
    Pct_EV_HBC_ENSIGN    = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_ENSIGN   )
    Pct_EV_HBC_SLCC      = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_SLCC     )
    Pct_EV_HBC_SLCC_MAIN = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_SLCC_MAIN)
    Pct_EV_HBC_SLCC_JD   = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_SLCC_JD  )
    Pct_EV_HBC_SLCC_ML   = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_SLCC_ML  )
    Pct_EV_HBC_SLCC_SC   = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_SLCC_SC  )
    Pct_EV_HBC_UOFU_MAIN = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_UOFU_MAIN)
    Pct_EV_HBC_WSU       = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_WSU      )
    Pct_EV_HBC_WSU_MAIN  = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_WSU_MAIN )
    Pct_EV_HBC_WSU_DAVIS = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_WSU_DAVIS)
    Pct_EV_HBC_UVU       = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_UVU      )
    Pct_EV_HBC_WESTMIN   = TimeOfDayFac(_prd_EV, idx_II_idx_HBC_WESTMIN  )
    
    
    
    ;calculate period & directional (PA or AP) factors by purpose --------------------------------------------
    ;  note:  (AP factor = 1 - PA factor)
    ;AM - PA direction
    PA_AM_HBW    = TimeOfDayFac(_PA_AM, idx_II_HBW  )
    PA_AM_HBO    = TimeOfDayFac(_PA_AM, idx_II_HBO  )
    PA_AM_NHB    = TimeOfDayFac(_PA_AM, idx_II_NHB  )
    PA_AM_HBS    = TimeOfDayFac(_PA_AM, idx_II_HBS  )
    PA_AM_HBC    = TimeOfDayFac(_PA_AM, idx_II_HBC  )
    PA_AM_Rec    = TimeOfDayFac(_PA_AM, idx_II_Rec  )
    PA_AM_LT     = TimeOfDayFac(_PA_AM, idx_II_LT   )
    PA_AM_MD     = TimeOfDayFac(_PA_AM, idx_II_MD   )
    PA_AM_HV     = TimeOfDayFac(_PA_AM, idx_II_HV   )
    PA_AM_HBShp  = TimeOfDayFac(_PA_AM, idx_II_HBShp)
    PA_AM_HBOth  = TimeOfDayFac(_PA_AM, idx_II_HBOth)
    PA_AM_NHBW   = TimeOfDayFac(_PA_AM, idx_II_NHBW )
    PA_AM_NHBNW  = TimeOfDayFac(_PA_AM, idx_II_NHBNW)
    
    PA_AM_IX     = TimeOfDayFac(_PA_AM, idx_IX_Tot  )
    PA_AM_IX_HBW = TimeOfDayFac(_PA_AM, idx_IX_HBW  )
    PA_AM_IX_HBO = TimeOfDayFac(_PA_AM, idx_IX_HBO  )
    PA_AM_IX_NHB = TimeOfDayFac(_PA_AM, idx_IX_NHB  )
    PA_AM_IX_HBS = TimeOfDayFac(_PA_AM, idx_IX_HBS  )
    PA_AM_IX_HBC = TimeOfDayFac(_PA_AM, idx_IX_HBC  )
    PA_AM_IX_Rec = TimeOfDayFac(_PA_AM, idx_IX_Rec  )
    PA_AM_IX_LT  = TimeOfDayFac(_PA_AM, idx_IX_LT   )
    PA_AM_IX_MD  = TimeOfDayFac(_PA_AM, idx_IX_MD   )
    PA_AM_IX_HV  = TimeOfDayFac(_PA_AM, idx_IX_HV   )
    
    PA_AM_XI     = TimeOfDayFac(_PA_AM, idx_XI_Tot  )
    PA_AM_XI_HBW = TimeOfDayFac(_PA_AM, idx_XI_HBW  )
    PA_AM_XI_HBO = TimeOfDayFac(_PA_AM, idx_XI_HBO  )
    PA_AM_XI_NHB = TimeOfDayFac(_PA_AM, idx_XI_NHB  )
    PA_AM_XI_HBS = TimeOfDayFac(_PA_AM, idx_XI_HBS  )
    PA_AM_XI_HBC = TimeOfDayFac(_PA_AM, idx_XI_HBC  )
    PA_AM_XI_Rec = TimeOfDayFac(_PA_AM, idx_XI_Rec  )
    PA_AM_XI_LT  = TimeOfDayFac(_PA_AM, idx_XI_LT   )
    PA_AM_XI_MD  = TimeOfDayFac(_PA_AM, idx_XI_MD   )
    PA_AM_XI_HV  = TimeOfDayFac(_PA_AM, idx_XI_HV   )
    
    PA_AM_XX     = TimeOfDayFac(_PA_AM, idx_XX_Tot  )
    PA_AM_XX_HBW = TimeOfDayFac(_PA_AM, idx_XX_HBW  )
    PA_AM_XX_HBO = TimeOfDayFac(_PA_AM, idx_XX_HBO  )
    PA_AM_XX_NHB = TimeOfDayFac(_PA_AM, idx_XX_NHB  )
    PA_AM_XX_HBS = TimeOfDayFac(_PA_AM, idx_XX_HBS  )
    PA_AM_XX_HBC = TimeOfDayFac(_PA_AM, idx_XX_HBC  )
    PA_AM_XX_Rec = TimeOfDayFac(_PA_AM, idx_XX_Rec  )
    PA_AM_XX_LT  = TimeOfDayFac(_PA_AM, idx_XX_LT   )
    PA_AM_XX_MD  = TimeOfDayFac(_PA_AM, idx_XX_MD   )
    PA_AM_XX_HV  = TimeOfDayFac(_PA_AM, idx_XX_HV   )
    
    ;MD - PA direction
    PA_MD_HBW    = TimeOfDayFac(_PA_MD, idx_II_HBW  )
    PA_MD_HBO    = TimeOfDayFac(_PA_MD, idx_II_HBO  )
    PA_MD_NHB    = TimeOfDayFac(_PA_MD, idx_II_NHB  )
    PA_MD_HBS    = TimeOfDayFac(_PA_MD, idx_II_HBS  )
    PA_MD_HBC    = TimeOfDayFac(_PA_MD, idx_II_HBC  )
    PA_MD_Rec    = TimeOfDayFac(_PA_MD, idx_II_Rec  )
    PA_MD_LT     = TimeOfDayFac(_PA_MD, idx_II_LT   )
    PA_MD_MD     = TimeOfDayFac(_PA_MD, idx_II_MD   )
    PA_MD_HV     = TimeOfDayFac(_PA_MD, idx_II_HV   )
    PA_MD_HBShp  = TimeOfDayFac(_PA_MD, idx_II_HBShp)
    PA_MD_HBOth  = TimeOfDayFac(_PA_MD, idx_II_HBOth)
    PA_MD_NHBW   = TimeOfDayFac(_PA_MD, idx_II_NHBW )
    PA_MD_NHBNW  = TimeOfDayFac(_PA_MD, idx_II_NHBNW)
    
    PA_MD_IX     = TimeOfDayFac(_PA_MD, idx_IX_Tot  )
    PA_MD_IX_HBW = TimeOfDayFac(_PA_MD, idx_IX_HBW  )
    PA_MD_IX_HBO = TimeOfDayFac(_PA_MD, idx_IX_HBO  )
    PA_MD_IX_NHB = TimeOfDayFac(_PA_MD, idx_IX_NHB  )
    PA_MD_IX_HBS = TimeOfDayFac(_PA_MD, idx_IX_HBS  )
    PA_MD_IX_HBC = TimeOfDayFac(_PA_MD, idx_IX_HBC  )
    PA_MD_IX_Rec = TimeOfDayFac(_PA_MD, idx_IX_Rec  )
    PA_MD_IX_LT  = TimeOfDayFac(_PA_MD, idx_IX_LT   )
    PA_MD_IX_MD  = TimeOfDayFac(_PA_MD, idx_IX_MD   )
    PA_MD_IX_HV  = TimeOfDayFac(_PA_MD, idx_IX_HV   )
    
    PA_MD_XI     = TimeOfDayFac(_PA_MD, idx_XI_Tot  )
    PA_MD_XI_HBW = TimeOfDayFac(_PA_MD, idx_XI_HBW  )
    PA_MD_XI_HBO = TimeOfDayFac(_PA_MD, idx_XI_HBO  )
    PA_MD_XI_NHB = TimeOfDayFac(_PA_MD, idx_XI_NHB  )
    PA_MD_XI_HBS = TimeOfDayFac(_PA_MD, idx_XI_HBS  )
    PA_MD_XI_HBC = TimeOfDayFac(_PA_MD, idx_XI_HBC  )
    PA_MD_XI_Rec = TimeOfDayFac(_PA_MD, idx_XI_Rec  )
    PA_MD_XI_LT  = TimeOfDayFac(_PA_MD, idx_XI_LT   )
    PA_MD_XI_MD  = TimeOfDayFac(_PA_MD, idx_XI_MD   )
    PA_MD_XI_HV  = TimeOfDayFac(_PA_MD, idx_XI_HV   )
    
    PA_MD_XX     = TimeOfDayFac(_PA_MD, idx_XX_Tot  )
    PA_MD_XX_HBW = TimeOfDayFac(_PA_MD, idx_XX_HBW  )
    PA_MD_XX_HBO = TimeOfDayFac(_PA_MD, idx_XX_HBO  )
    PA_MD_XX_NHB = TimeOfDayFac(_PA_MD, idx_XX_NHB  )
    PA_MD_XX_HBS = TimeOfDayFac(_PA_MD, idx_XX_HBS  )
    PA_MD_XX_HBC = TimeOfDayFac(_PA_MD, idx_XX_HBC  )
    PA_MD_XX_Rec = TimeOfDayFac(_PA_MD, idx_XX_Rec  )
    PA_MD_XX_LT  = TimeOfDayFac(_PA_MD, idx_XX_LT   )
    PA_MD_XX_MD  = TimeOfDayFac(_PA_MD, idx_XX_MD   )
    PA_MD_XX_HV  = TimeOfDayFac(_PA_MD, idx_XX_HV   )
    
    ;PM - PA direction
    PA_PM_HBW    = TimeOfDayFac(_PA_PM, idx_II_HBW  )
    PA_PM_HBO    = TimeOfDayFac(_PA_PM, idx_II_HBO  )
    PA_PM_NHB    = TimeOfDayFac(_PA_PM, idx_II_NHB  )
    PA_PM_HBS    = TimeOfDayFac(_PA_PM, idx_II_HBS  )
    PA_PM_HBC    = TimeOfDayFac(_PA_PM, idx_II_HBC  )
    PA_PM_Rec    = TimeOfDayFac(_PA_PM, idx_II_Rec  )
    PA_PM_LT     = TimeOfDayFac(_PA_PM, idx_II_LT   )
    PA_PM_MD     = TimeOfDayFac(_PA_PM, idx_II_MD   )
    PA_PM_HV     = TimeOfDayFac(_PA_PM, idx_II_HV   )
    PA_PM_HBShp  = TimeOfDayFac(_PA_PM, idx_II_HBShp)
    PA_PM_HBOth  = TimeOfDayFac(_PA_PM, idx_II_HBOth)
    PA_PM_NHBW   = TimeOfDayFac(_PA_PM, idx_II_NHBW )
    PA_PM_NHBNW  = TimeOfDayFac(_PA_PM, idx_II_NHBNW)
    
    PA_PM_IX     = TimeOfDayFac(_PA_PM, idx_IX_Tot  )
    PA_PM_IX_HBW = TimeOfDayFac(_PA_PM, idx_IX_HBW  )
    PA_PM_IX_HBO = TimeOfDayFac(_PA_PM, idx_IX_HBO  )
    PA_PM_IX_NHB = TimeOfDayFac(_PA_PM, idx_IX_NHB  )
    PA_PM_IX_HBS = TimeOfDayFac(_PA_PM, idx_IX_HBS  )
    PA_PM_IX_HBC = TimeOfDayFac(_PA_PM, idx_IX_HBC  )
    PA_PM_IX_Rec = TimeOfDayFac(_PA_PM, idx_IX_Rec  )
    PA_PM_IX_LT  = TimeOfDayFac(_PA_PM, idx_IX_LT   )
    PA_PM_IX_MD  = TimeOfDayFac(_PA_PM, idx_IX_MD   )
    PA_PM_IX_HV  = TimeOfDayFac(_PA_PM, idx_IX_HV   )
    
    PA_PM_XI     = TimeOfDayFac(_PA_PM, idx_XI_Tot  )
    PA_PM_XI_HBW = TimeOfDayFac(_PA_PM, idx_XI_HBW  )
    PA_PM_XI_HBO = TimeOfDayFac(_PA_PM, idx_XI_HBO  )
    PA_PM_XI_NHB = TimeOfDayFac(_PA_PM, idx_XI_NHB  )
    PA_PM_XI_HBS = TimeOfDayFac(_PA_PM, idx_XI_HBS  )
    PA_PM_XI_HBC = TimeOfDayFac(_PA_PM, idx_XI_HBC  )
    PA_PM_XI_Rec = TimeOfDayFac(_PA_PM, idx_XI_Rec  )
    PA_PM_XI_LT  = TimeOfDayFac(_PA_PM, idx_XI_LT   )
    PA_PM_XI_MD  = TimeOfDayFac(_PA_PM, idx_XI_MD   )
    PA_PM_XI_HV  = TimeOfDayFac(_PA_PM, idx_XI_HV   )
    
    PA_PM_XX     = TimeOfDayFac(_PA_PM, idx_XX_Tot  )
    PA_PM_XX_HBW = TimeOfDayFac(_PA_PM, idx_XX_HBW  )
    PA_PM_XX_HBO = TimeOfDayFac(_PA_PM, idx_XX_HBO  )
    PA_PM_XX_NHB = TimeOfDayFac(_PA_PM, idx_XX_NHB  )
    PA_PM_XX_HBS = TimeOfDayFac(_PA_PM, idx_XX_HBS  )
    PA_PM_XX_HBC = TimeOfDayFac(_PA_PM, idx_XX_HBC  )
    PA_PM_XX_Rec = TimeOfDayFac(_PA_PM, idx_XX_Rec  )
    PA_PM_XX_LT  = TimeOfDayFac(_PA_PM, idx_XX_LT   )
    PA_PM_XX_MD  = TimeOfDayFac(_PA_PM, idx_XX_MD   )
    PA_PM_XX_HV  = TimeOfDayFac(_PA_PM, idx_XX_HV   )
    
    ;EV - PA direction
    PA_EV_HBW    = TimeOfDayFac(_PA_EV, idx_II_HBW  )
    PA_EV_HBO    = TimeOfDayFac(_PA_EV, idx_II_HBO  )
    PA_EV_NHB    = TimeOfDayFac(_PA_EV, idx_II_NHB  )
    PA_EV_HBS    = TimeOfDayFac(_PA_EV, idx_II_HBS  )
    PA_EV_HBC    = TimeOfDayFac(_PA_EV, idx_II_HBC  )
    PA_EV_Rec    = TimeOfDayFac(_PA_EV, idx_II_Rec  )
    PA_EV_LT     = TimeOfDayFac(_PA_EV, idx_II_LT   )
    PA_EV_MD     = TimeOfDayFac(_PA_EV, idx_II_MD   )
    PA_EV_HV     = TimeOfDayFac(_PA_EV, idx_II_HV   )
    PA_EV_HBShp  = TimeOfDayFac(_PA_EV, idx_II_HBShp)
    PA_EV_HBOth  = TimeOfDayFac(_PA_EV, idx_II_HBOth)
    PA_EV_NHBW   = TimeOfDayFac(_PA_EV, idx_II_NHBW )
    PA_EV_NHBNW  = TimeOfDayFac(_PA_EV, idx_II_NHBNW)
    
    PA_EV_IX     = TimeOfDayFac(_PA_EV, idx_IX_Tot  )
    PA_EV_IX_HBW = TimeOfDayFac(_PA_EV, idx_IX_HBW  )
    PA_EV_IX_HBO = TimeOfDayFac(_PA_EV, idx_IX_HBO  )
    PA_EV_IX_NHB = TimeOfDayFac(_PA_EV, idx_IX_NHB  )
    PA_EV_IX_HBS = TimeOfDayFac(_PA_EV, idx_IX_HBS  )
    PA_EV_IX_HBC = TimeOfDayFac(_PA_EV, idx_IX_HBC  )
    PA_EV_IX_Rec = TimeOfDayFac(_PA_EV, idx_IX_Rec  )
    PA_EV_IX_LT  = TimeOfDayFac(_PA_EV, idx_IX_LT   )
    PA_EV_IX_MD  = TimeOfDayFac(_PA_EV, idx_IX_MD   )
    PA_EV_IX_HV  = TimeOfDayFac(_PA_EV, idx_IX_HV   )
    
    PA_EV_XI     = TimeOfDayFac(_PA_EV, idx_XI_Tot  )
    PA_EV_XI_HBW = TimeOfDayFac(_PA_EV, idx_XI_HBW  )
    PA_EV_XI_HBO = TimeOfDayFac(_PA_EV, idx_XI_HBO  )
    PA_EV_XI_NHB = TimeOfDayFac(_PA_EV, idx_XI_NHB  )
    PA_EV_XI_HBS = TimeOfDayFac(_PA_EV, idx_XI_HBS  )
    PA_EV_XI_HBC = TimeOfDayFac(_PA_EV, idx_XI_HBC  )
    PA_EV_XI_Rec = TimeOfDayFac(_PA_EV, idx_XI_Rec  )
    PA_EV_XI_LT  = TimeOfDayFac(_PA_EV, idx_XI_LT   )
    PA_EV_XI_MD  = TimeOfDayFac(_PA_EV, idx_XI_MD   )
    PA_EV_XI_HV  = TimeOfDayFac(_PA_EV, idx_XI_HV   )
    
    PA_EV_XX     = TimeOfDayFac(_PA_EV, idx_XX_Tot  )
    PA_EV_XX_HBW = TimeOfDayFac(_PA_EV, idx_XX_HBW  )
    PA_EV_XX_HBO = TimeOfDayFac(_PA_EV, idx_XX_HBO  )
    PA_EV_XX_NHB = TimeOfDayFac(_PA_EV, idx_XX_NHB  )
    PA_EV_XX_HBS = TimeOfDayFac(_PA_EV, idx_XX_HBS  )
    PA_EV_XX_HBC = TimeOfDayFac(_PA_EV, idx_XX_HBC  )
    PA_EV_XX_Rec = TimeOfDayFac(_PA_EV, idx_XX_Rec  )
    PA_EV_XX_LT  = TimeOfDayFac(_PA_EV, idx_XX_LT   )
    PA_EV_XX_MD  = TimeOfDayFac(_PA_EV, idx_XX_MD   )
    PA_EV_XX_HV  = TimeOfDayFac(_PA_EV, idx_XX_HV   )
    
    
    ;calculate period & directional (PA or AP) factors for HBC by separate colleges
    ;AM - PA direction
    PA_AM_HBC_BYU       = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_BYU      )
    PA_AM_HBC_ENSIGN    = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_ENSIGN   )
    PA_AM_HBC_SLCC      = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_SLCC     )
    PA_AM_HBC_SLCC_MAIN = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_SLCC_MAIN)
    PA_AM_HBC_SLCC_JD   = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_SLCC_JD  )
    PA_AM_HBC_SLCC_ML   = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_SLCC_ML  )
    PA_AM_HBC_SLCC_SC   = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_SLCC_SC  )
    PA_AM_HBC_UOFU_MAIN = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_UOFU_MAIN)
    PA_AM_HBC_WSU       = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_WSU      )
    PA_AM_HBC_WSU_MAIN  = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_WSU_MAIN )
    PA_AM_HBC_WSU_DAVIS = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_WSU_DAVIS)
    PA_AM_HBC_UVU       = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_UVU      )
    PA_AM_HBC_WESTMIN   = TimeOfDayFac(_PA_AM, idx_II_idx_HBC_WESTMIN  )
    
    ;MD - PA direction
    PA_MD_HBC_BYU       = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_BYU      )
    PA_MD_HBC_ENSIGN    = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_ENSIGN   )
    PA_MD_HBC_SLCC      = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_SLCC     )
    PA_MD_HBC_SLCC_MAIN = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_SLCC_MAIN)
    PA_MD_HBC_SLCC_JD   = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_SLCC_JD  )
    PA_MD_HBC_SLCC_ML   = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_SLCC_ML  )
    PA_MD_HBC_SLCC_SC   = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_SLCC_SC  )
    PA_MD_HBC_UOFU_MAIN = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_UOFU_MAIN)
    PA_MD_HBC_WSU       = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_WSU      )
    PA_MD_HBC_WSU_MAIN  = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_WSU_MAIN )
    PA_MD_HBC_WSU_DAVIS = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_WSU_DAVIS)
    PA_MD_HBC_UVU       = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_UVU      )
    PA_MD_HBC_WESTMIN   = TimeOfDayFac(_PA_MD, idx_II_idx_HBC_WESTMIN  )
    
    ;PM - PA direction
    PA_PM_HBC_BYU       = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_BYU      )
    PA_PM_HBC_ENSIGN    = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_ENSIGN   )
    PA_PM_HBC_SLCC      = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_SLCC     )
    PA_PM_HBC_SLCC_MAIN = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_SLCC_MAIN)
    PA_PM_HBC_SLCC_JD   = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_SLCC_JD  )
    PA_PM_HBC_SLCC_ML   = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_SLCC_ML  )
    PA_PM_HBC_SLCC_SC   = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_SLCC_SC  )
    PA_PM_HBC_UOFU_MAIN = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_UOFU_MAIN)
    PA_PM_HBC_WSU       = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_WSU      )
    PA_PM_HBC_WSU_MAIN  = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_WSU_MAIN )
    PA_PM_HBC_WSU_DAVIS = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_WSU_DAVIS)
    PA_PM_HBC_UVU       = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_UVU      )
    PA_PM_HBC_WESTMIN   = TimeOfDayFac(_PA_PM, idx_II_idx_HBC_WESTMIN  )
    
    ;EV - PA direction
    PA_EV_HBC_BYU       = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_BYU      )
    PA_EV_HBC_ENSIGN    = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_ENSIGN   )
    PA_EV_HBC_SLCC      = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_SLCC     )
    PA_EV_HBC_SLCC_MAIN = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_SLCC_MAIN)
    PA_EV_HBC_SLCC_JD   = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_SLCC_JD  )
    PA_EV_HBC_SLCC_ML   = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_SLCC_ML  )
    PA_EV_HBC_SLCC_SC   = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_SLCC_SC  )
    PA_EV_HBC_UOFU_MAIN = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_UOFU_MAIN)
    PA_EV_HBC_WSU       = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_WSU      )
    PA_EV_HBC_WSU_MAIN  = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_WSU_MAIN )
    PA_EV_HBC_WSU_DAVIS = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_WSU_DAVIS)
    PA_EV_HBC_UVU       = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_UVU      )
    PA_EV_HBC_WESTMIN   = TimeOfDayFac(_PA_EV, idx_II_idx_HBC_WESTMIN  )
    
    
    
    ;print factors -------------------------------------------------------------------------------------------
    ;AM
    PRINT PRINTO=1,
        FORM=8.5,
        LIST=';Time of Day Factors -----------------------------------------------------------------------------------------',
             '\nPct_AM_HBW    = ',   Pct_AM_HBW   ,
             '\nPct_AM_HBO    = ',   Pct_AM_HBO   ,
             '\nPct_AM_NHB    = ',   Pct_AM_NHB   ,
             '\nPct_AM_HBS    = ',   Pct_AM_HBS   ,
             '\nPct_AM_HBC    = ',   Pct_AM_HBC   ,
             '\nPct_AM_Rec    = ',   Pct_AM_Rec   ,
             '\nPct_AM_LT     = ',   Pct_AM_LT    ,
             '\nPct_AM_MD     = ',   Pct_AM_MD    ,
             '\nPct_AM_HV     = ',   Pct_AM_HV    ,
             '\nPct_AM_HBShp  = ',   Pct_AM_HBShp ,
             '\nPct_AM_HBOth  = ',   Pct_AM_HBOth ,
             '\nPct_AM_NHBW   = ',   Pct_AM_NHBW  ,
             '\nPct_AM_NHBNW  = ',   Pct_AM_NHBNW ,
             '\n',
             '\nPct_AM_IX     = ',   Pct_AM_IX    ,
             '\nPct_AM_IX_HBW = ',   Pct_AM_IX_HBW,
             '\nPct_AM_IX_HBO = ',   Pct_AM_IX_HBO,
             '\nPct_AM_IX_NHB = ',   Pct_AM_IX_NHB,
             '\nPct_AM_IX_HBS = ',   Pct_AM_IX_HBS,
             '\nPct_AM_IX_HBC = ',   Pct_AM_IX_HBC,
             '\nPct_AM_IX_Rec = ',   Pct_AM_IX_Rec,
             '\nPct_AM_IX_LT  = ',   Pct_AM_IX_LT ,
             '\nPct_AM_IX_MD  = ',   Pct_AM_IX_MD ,
             '\nPct_AM_IX_HV  = ',   Pct_AM_IX_HV ,
             '\n',
             '\nPct_AM_XI     = ',   Pct_AM_XI    ,
             '\nPct_AM_XI_HBW = ',   Pct_AM_XI_HBW,
             '\nPct_AM_XI_HBO = ',   Pct_AM_XI_HBO,
             '\nPct_AM_XI_NHB = ',   Pct_AM_XI_NHB,
             '\nPct_AM_XI_HBS = ',   Pct_AM_XI_HBS,
             '\nPct_AM_XI_HBC = ',   Pct_AM_XI_HBC,
             '\nPct_AM_XI_Rec = ',   Pct_AM_XI_Rec,
             '\nPct_AM_XI_LT  = ',   Pct_AM_XI_LT ,
             '\nPct_AM_XI_MD  = ',   Pct_AM_XI_MD ,
             '\nPct_AM_XI_HV  = ',   Pct_AM_XI_HV ,
             '\n',
             '\nPct_AM_XX     = ',   Pct_AM_XX    ,
             '\nPct_AM_XX_HBW = ',   Pct_AM_XX_HBW,
             '\nPct_AM_XX_HBO = ',   Pct_AM_XX_HBO,
             '\nPct_AM_XX_NHB = ',   Pct_AM_XX_NHB,
             '\nPct_AM_XX_HBS = ',   Pct_AM_XX_HBS,
             '\nPct_AM_XX_HBC = ',   Pct_AM_XX_HBC,
             '\nPct_AM_XX_Rec = ',   Pct_AM_XX_Rec,
             '\nPct_AM_XX_LT  = ',   Pct_AM_XX_LT ,
             '\nPct_AM_XX_MD  = ',   Pct_AM_XX_MD ,
             '\nPct_AM_XX_HV  = ',   Pct_AM_XX_HV ,
             '\n',
             '\n',
             '\nPct_MD_HBW    = ',   Pct_MD_HBW   ,
             '\nPct_MD_HBO    = ',   Pct_MD_HBO   ,
             '\nPct_MD_NHB    = ',   Pct_MD_NHB   ,
             '\nPct_MD_HBS    = ',   Pct_MD_HBS   ,
             '\nPct_MD_HBC    = ',   Pct_MD_HBC   ,
             '\nPct_MD_Rec    = ',   Pct_MD_Rec   ,
             '\nPct_MD_LT     = ',   Pct_MD_LT    ,
             '\nPct_MD_MD     = ',   Pct_MD_MD    ,
             '\nPct_MD_HV     = ',   Pct_MD_HV    ,
             '\nPct_MD_HBShp  = ',   Pct_MD_HBShp ,
             '\nPct_MD_HBOth  = ',   Pct_MD_HBOth ,
             '\nPct_MD_NHBW   = ',   Pct_MD_NHBW  ,
             '\nPct_MD_NHBNW  = ',   Pct_MD_NHBNW ,
             '\n',
             '\nPct_MD_IX     = ',   Pct_MD_IX    ,
             '\nPct_MD_IX_HBW = ',   Pct_MD_IX_HBW,
             '\nPct_MD_IX_HBO = ',   Pct_MD_IX_HBO,
             '\nPct_MD_IX_NHB = ',   Pct_MD_IX_NHB,
             '\nPct_MD_IX_HBS = ',   Pct_MD_IX_HBS,
             '\nPct_MD_IX_HBC = ',   Pct_MD_IX_HBC,
             '\nPct_MD_IX_Rec = ',   Pct_MD_IX_Rec,
             '\nPct_MD_IX_LT  = ',   Pct_MD_IX_LT ,
             '\nPct_MD_IX_MD  = ',   Pct_MD_IX_MD ,
             '\nPct_MD_IX_HV  = ',   Pct_MD_IX_HV ,
             '\n',
             '\nPct_MD_XI     = ',   Pct_MD_XI    ,
             '\nPct_MD_XI_HBW = ',   Pct_MD_XI_HBW,
             '\nPct_MD_XI_HBO = ',   Pct_MD_XI_HBO,
             '\nPct_MD_XI_NHB = ',   Pct_MD_XI_NHB,
             '\nPct_MD_XI_HBS = ',   Pct_MD_XI_HBS,
             '\nPct_MD_XI_HBC = ',   Pct_MD_XI_HBC,
             '\nPct_MD_XI_Rec = ',   Pct_MD_XI_Rec,
             '\nPct_MD_XI_LT  = ',   Pct_MD_XI_LT ,
             '\nPct_MD_XI_MD  = ',   Pct_MD_XI_MD ,
             '\nPct_MD_XI_HV  = ',   Pct_MD_XI_HV ,
             '\n',
             '\nPct_MD_XX     = ',   Pct_MD_XX    ,
             '\nPct_MD_XX_HBW = ',   Pct_MD_XX_HBW,
             '\nPct_MD_XX_HBO = ',   Pct_MD_XX_HBO,
             '\nPct_MD_XX_NHB = ',   Pct_MD_XX_NHB,
             '\nPct_MD_XX_HBS = ',   Pct_MD_XX_HBS,
             '\nPct_MD_XX_HBC = ',   Pct_MD_XX_HBC,
             '\nPct_MD_XX_Rec = ',   Pct_MD_XX_Rec,
             '\nPct_MD_XX_LT  = ',   Pct_MD_XX_LT ,
             '\nPct_MD_XX_MD  = ',   Pct_MD_XX_MD ,
             '\nPct_MD_XX_HV  = ',   Pct_MD_XX_HV ,
             '\n',
             '\n',
             '\nPct_PM_HBW    = ',   Pct_PM_HBW   ,
             '\nPct_PM_HBO    = ',   Pct_PM_HBO   ,
             '\nPct_PM_NHB    = ',   Pct_PM_NHB   ,
             '\nPct_PM_HBS    = ',   Pct_PM_HBS   ,
             '\nPct_PM_HBC    = ',   Pct_PM_HBC   ,
             '\nPct_PM_Rec    = ',   Pct_PM_Rec   ,
             '\nPct_PM_LT     = ',   Pct_PM_LT    ,
             '\nPct_PM_MD     = ',   Pct_PM_MD    ,
             '\nPct_PM_HV     = ',   Pct_PM_HV    ,
             '\nPct_PM_HBShp  = ',   Pct_PM_HBShp ,
             '\nPct_PM_HBOth  = ',   Pct_PM_HBOth ,
             '\nPct_PM_NHBW   = ',   Pct_PM_NHBW  ,
             '\nPct_PM_NHBNW  = ',   Pct_PM_NHBNW ,
             '\n',
             '\nPct_PM_IX     = ',   Pct_PM_IX    ,
             '\nPct_PM_IX_HBW = ',   Pct_PM_IX_HBW,
             '\nPct_PM_IX_HBO = ',   Pct_PM_IX_HBO,
             '\nPct_PM_IX_NHB = ',   Pct_PM_IX_NHB,
             '\nPct_PM_IX_HBS = ',   Pct_PM_IX_HBS,
             '\nPct_PM_IX_HBC = ',   Pct_PM_IX_HBC,
             '\nPct_PM_IX_Rec = ',   Pct_PM_IX_Rec,
             '\nPct_PM_IX_LT  = ',   Pct_PM_IX_LT ,
             '\nPct_PM_IX_MD  = ',   Pct_PM_IX_MD ,
             '\nPct_PM_IX_HV  = ',   Pct_PM_IX_HV ,
             '\n',
             '\nPct_PM_XI     = ',   Pct_PM_XI    ,
             '\nPct_PM_XI_HBW = ',   Pct_PM_XI_HBW,
             '\nPct_PM_XI_HBO = ',   Pct_PM_XI_HBO,
             '\nPct_PM_XI_NHB = ',   Pct_PM_XI_NHB,
             '\nPct_PM_XI_HBS = ',   Pct_PM_XI_HBS,
             '\nPct_PM_XI_HBC = ',   Pct_PM_XI_HBC,
             '\nPct_PM_XI_Rec = ',   Pct_PM_XI_Rec,
             '\nPct_PM_XI_LT  = ',   Pct_PM_XI_LT ,
             '\nPct_PM_XI_MD  = ',   Pct_PM_XI_MD ,
             '\nPct_PM_XI_HV  = ',   Pct_PM_XI_HV ,
             '\n',
             '\nPct_PM_XX     = ',   Pct_PM_XX    ,
             '\nPct_PM_XX_HBW = ',   Pct_PM_XX_HBW,
             '\nPct_PM_XX_HBO = ',   Pct_PM_XX_HBO,
             '\nPct_PM_XX_NHB = ',   Pct_PM_XX_NHB,
             '\nPct_PM_XX_HBS = ',   Pct_PM_XX_HBS,
             '\nPct_PM_XX_HBC = ',   Pct_PM_XX_HBC,
             '\nPct_PM_XX_Rec = ',   Pct_PM_XX_Rec,
             '\nPct_PM_XX_LT  = ',   Pct_PM_XX_LT ,
             '\nPct_PM_XX_MD  = ',   Pct_PM_XX_MD ,
             '\nPct_PM_XX_HV  = ',   Pct_PM_XX_HV ,
             '\n',
             '\n',
             '\nPct_EV_HBW    = ',   Pct_EV_HBW   ,
             '\nPct_EV_HBO    = ',   Pct_EV_HBO   ,
             '\nPct_EV_NHB    = ',   Pct_EV_NHB   ,
             '\nPct_EV_HBS    = ',   Pct_EV_HBS   ,
             '\nPct_EV_HBC    = ',   Pct_EV_HBC   ,
             '\nPct_EV_Rec    = ',   Pct_EV_Rec   ,
             '\nPct_EV_LT     = ',   Pct_EV_LT    ,
             '\nPct_EV_MD     = ',   Pct_EV_MD    ,
             '\nPct_EV_HV     = ',   Pct_EV_HV    ,
             '\nPct_EV_HBShp  = ',   Pct_EV_HBShp ,
             '\nPct_EV_HBOth  = ',   Pct_EV_HBOth ,
             '\nPct_EV_NHBW   = ',   Pct_EV_NHBW  ,
             '\nPct_EV_NHBNW  = ',   Pct_EV_NHBNW ,
             '\n',
             '\nPct_EV_IX     = ',   Pct_EV_IX    ,
             '\nPct_EV_IX_HBW = ',   Pct_EV_IX_HBW,
             '\nPct_EV_IX_HBO = ',   Pct_EV_IX_HBO,
             '\nPct_EV_IX_NHB = ',   Pct_EV_IX_NHB,
             '\nPct_EV_IX_HBS = ',   Pct_EV_IX_HBS,
             '\nPct_EV_IX_HBC = ',   Pct_EV_IX_HBC,
             '\nPct_EV_IX_Rec = ',   Pct_EV_IX_Rec,
             '\nPct_EV_IX_LT  = ',   Pct_EV_IX_LT ,
             '\nPct_EV_IX_MD  = ',   Pct_EV_IX_MD ,
             '\nPct_EV_IX_HV  = ',   Pct_EV_IX_HV ,
             '\n',
             '\nPct_EV_XI     = ',   Pct_EV_XI    ,
             '\nPct_EV_XI_HBW = ',   Pct_EV_XI_HBW,
             '\nPct_EV_XI_HBO = ',   Pct_EV_XI_HBO,
             '\nPct_EV_XI_NHB = ',   Pct_EV_XI_NHB,
             '\nPct_EV_XI_HBS = ',   Pct_EV_XI_HBS,
             '\nPct_EV_XI_HBC = ',   Pct_EV_XI_HBC,
             '\nPct_EV_XI_Rec = ',   Pct_EV_XI_Rec,
             '\nPct_EV_XI_LT  = ',   Pct_EV_XI_LT ,
             '\nPct_EV_XI_MD  = ',   Pct_EV_XI_MD ,
             '\nPct_EV_XI_HV  = ',   Pct_EV_XI_HV ,
             '\n',
             '\nPct_EV_XX     = ',   Pct_EV_XX    ,
             '\nPct_EV_XX_HBW = ',   Pct_EV_XX_HBW,
             '\nPct_EV_XX_HBO = ',   Pct_EV_XX_HBO,
             '\nPct_EV_XX_NHB = ',   Pct_EV_XX_NHB,
             '\nPct_EV_XX_HBS = ',   Pct_EV_XX_HBS,
             '\nPct_EV_XX_HBC = ',   Pct_EV_XX_HBC,
             '\nPct_EV_XX_Rec = ',   Pct_EV_XX_Rec,
             '\nPct_EV_XX_LT  = ',   Pct_EV_XX_LT ,
             '\nPct_EV_XX_MD  = ',   Pct_EV_XX_MD ,
             '\nPct_EV_XX_HV  = ',   Pct_EV_XX_HV ,
             '\n',
             '\n'
    
    ;AM
    PRINT PRINTO=1,
        FORM=8.5,
        LIST=';PA & AP PAtors ---------------------------------------------------------------------------------------------',
             '\nPA_AM_HBW    = ',   PA_AM_HBW   ,
             '\nPA_AM_HBO    = ',   PA_AM_HBO   ,
             '\nPA_AM_NHB    = ',   PA_AM_NHB   ,
             '\nPA_AM_HBS    = ',   PA_AM_HBS   ,
             '\nPA_AM_HBC    = ',   PA_AM_HBC   ,
             '\nPA_AM_Rec    = ',   PA_AM_Rec   ,
             '\nPA_AM_LT     = ',   PA_AM_LT    ,
             '\nPA_AM_MD     = ',   PA_AM_MD    ,
             '\nPA_AM_HV     = ',   PA_AM_HV    ,
             '\nPA_AM_HBShp  = ',   PA_AM_HBShp ,
             '\nPA_AM_HBOth  = ',   PA_AM_HBOth ,
             '\nPA_AM_NHBW   = ',   PA_AM_NHBW  ,
             '\nPA_AM_NHBNW  = ',   PA_AM_NHBNW ,
             '\n',
             '\nPA_AM_IX     = ',   PA_AM_IX    ,
             '\nPA_AM_IX_HBW = ',   PA_AM_IX_HBW,
             '\nPA_AM_IX_HBO = ',   PA_AM_IX_HBO,
             '\nPA_AM_IX_NHB = ',   PA_AM_IX_NHB,
             '\nPA_AM_IX_HBS = ',   PA_AM_IX_HBS,
             '\nPA_AM_IX_HBC = ',   PA_AM_IX_HBC,
             '\nPA_AM_IX_Rec = ',   PA_AM_IX_Rec,
             '\nPA_AM_IX_LT  = ',   PA_AM_IX_LT ,
             '\nPA_AM_IX_MD  = ',   PA_AM_IX_MD ,
             '\nPA_AM_IX_HV  = ',   PA_AM_IX_HV ,
             '\n',
             '\nPA_AM_XI     = ',   PA_AM_XI    ,
             '\nPA_AM_XI_HBW = ',   PA_AM_XI_HBW,
             '\nPA_AM_XI_HBO = ',   PA_AM_XI_HBO,
             '\nPA_AM_XI_NHB = ',   PA_AM_XI_NHB,
             '\nPA_AM_XI_HBS = ',   PA_AM_XI_HBS,
             '\nPA_AM_XI_HBC = ',   PA_AM_XI_HBC,
             '\nPA_AM_XI_Rec = ',   PA_AM_XI_Rec,
             '\nPA_AM_XI_LT  = ',   PA_AM_XI_LT ,
             '\nPA_AM_XI_MD  = ',   PA_AM_XI_MD ,
             '\nPA_AM_XI_HV  = ',   PA_AM_XI_HV ,
             '\n',
             '\nPA_AM_XX     = ',   PA_AM_XX    ,
             '\nPA_AM_XX_HBW = ',   PA_AM_XX_HBW,
             '\nPA_AM_XX_HBO = ',   PA_AM_XX_HBO,
             '\nPA_AM_XX_NHB = ',   PA_AM_XX_NHB,
             '\nPA_AM_XX_HBS = ',   PA_AM_XX_HBS,
             '\nPA_AM_XX_HBC = ',   PA_AM_XX_HBC,
             '\nPA_AM_XX_Rec = ',   PA_AM_XX_Rec,
             '\nPA_AM_XX_LT  = ',   PA_AM_XX_LT ,
             '\nPA_AM_XX_MD  = ',   PA_AM_XX_MD ,
             '\nPA_AM_XX_HV  = ',   PA_AM_XX_HV ,
             '\n',
             '\n'
    
    ;MD
    PRINT PRINTO=1,
        FORM=8.5,
        LIST='\nPA_MD_HBW    = ',   PA_MD_HBW   ,
             '\nPA_MD_HBO    = ',   PA_MD_HBO   ,
             '\nPA_MD_NHB    = ',   PA_MD_NHB   ,
             '\nPA_MD_HBS    = ',   PA_MD_HBS   ,
             '\nPA_MD_HBC    = ',   PA_MD_HBC   ,
             '\nPA_MD_Rec    = ',   PA_MD_Rec   ,
             '\nPA_MD_LT     = ',   PA_MD_LT    ,
             '\nPA_MD_MD     = ',   PA_MD_MD    ,
             '\nPA_MD_HV     = ',   PA_MD_HV    ,
             '\nPA_MD_HBShp  = ',   PA_MD_HBShp ,
             '\nPA_MD_HBOth  = ',   PA_MD_HBOth ,
             '\nPA_MD_NHBW   = ',   PA_MD_NHBW  ,
             '\nPA_MD_NHBNW  = ',   PA_MD_NHBNW ,
             '\n',
             '\nPA_MD_IX     = ',   PA_MD_IX    ,
             '\nPA_MD_IX_HBW = ',   PA_MD_IX_HBW,
             '\nPA_MD_IX_HBO = ',   PA_MD_IX_HBO,
             '\nPA_MD_IX_NHB = ',   PA_MD_IX_NHB,
             '\nPA_MD_IX_HBS = ',   PA_MD_IX_HBS,
             '\nPA_MD_IX_HBC = ',   PA_MD_IX_HBC,
             '\nPA_MD_IX_Rec = ',   PA_MD_IX_Rec,
             '\nPA_MD_IX_LT  = ',   PA_MD_IX_LT ,
             '\nPA_MD_IX_MD  = ',   PA_MD_IX_MD ,
             '\nPA_MD_IX_HV  = ',   PA_MD_IX_HV ,
             '\n',
             '\nPA_MD_XI     = ',   PA_MD_XI    ,
             '\nPA_MD_XI_HBW = ',   PA_MD_XI_HBW,
             '\nPA_MD_XI_HBO = ',   PA_MD_XI_HBO,
             '\nPA_MD_XI_NHB = ',   PA_MD_XI_NHB,
             '\nPA_MD_XI_HBS = ',   PA_MD_XI_HBS,
             '\nPA_MD_XI_HBC = ',   PA_MD_XI_HBC,
             '\nPA_MD_XI_Rec = ',   PA_MD_XI_Rec,
             '\nPA_MD_XI_LT  = ',   PA_MD_XI_LT ,
             '\nPA_MD_XI_MD  = ',   PA_MD_XI_MD ,
             '\nPA_MD_XI_HV  = ',   PA_MD_XI_HV ,
             '\n',
             '\nPA_MD_XX     = ',   PA_MD_XX    ,
             '\nPA_MD_XX_HBW = ',   PA_MD_XX_HBW,
             '\nPA_MD_XX_HBO = ',   PA_MD_XX_HBO,
             '\nPA_MD_XX_NHB = ',   PA_MD_XX_NHB,
             '\nPA_MD_XX_HBS = ',   PA_MD_XX_HBS,
             '\nPA_MD_XX_HBC = ',   PA_MD_XX_HBC,
             '\nPA_MD_XX_Rec = ',   PA_MD_XX_Rec,
             '\nPA_MD_XX_LT  = ',   PA_MD_XX_LT ,
             '\nPA_MD_XX_MD  = ',   PA_MD_XX_MD ,
             '\nPA_MD_XX_HV  = ',   PA_MD_XX_HV ,
             '\n',
             '\n'
    
    ;PM
    PRINT PRINTO=1,
        FORM=8.5,
        LIST='\nPA_PM_HBW    = ',   PA_PM_HBW   ,
             '\nPA_PM_HBO    = ',   PA_PM_HBO   ,
             '\nPA_PM_NHB    = ',   PA_PM_NHB   ,
             '\nPA_PM_HBS    = ',   PA_PM_HBS   ,
             '\nPA_PM_HBC    = ',   PA_PM_HBC   ,
             '\nPA_PM_Rec    = ',   PA_PM_Rec   ,
             '\nPA_PM_LT     = ',   PA_PM_LT    ,
             '\nPA_PM_MD     = ',   PA_PM_MD    ,
             '\nPA_PM_HV     = ',   PA_PM_HV    ,
             '\nPA_PM_HBShp  = ',   PA_PM_HBShp ,
             '\nPA_PM_HBOth  = ',   PA_PM_HBOth ,
             '\nPA_PM_NHBW   = ',   PA_PM_NHBW  ,
             '\nPA_PM_NHBNW  = ',   PA_PM_NHBNW ,
             '\n',
             '\nPA_PM_IX     = ',   PA_PM_IX    ,
             '\nPA_PM_IX_HBW = ',   PA_PM_IX_HBW,
             '\nPA_PM_IX_HBO = ',   PA_PM_IX_HBO,
             '\nPA_PM_IX_NHB = ',   PA_PM_IX_NHB,
             '\nPA_PM_IX_HBS = ',   PA_PM_IX_HBS,
             '\nPA_PM_IX_HBC = ',   PA_PM_IX_HBC,
             '\nPA_PM_IX_Rec = ',   PA_PM_IX_Rec,
             '\nPA_PM_IX_LT  = ',   PA_PM_IX_LT ,
             '\nPA_PM_IX_MD  = ',   PA_PM_IX_MD ,
             '\nPA_PM_IX_HV  = ',   PA_PM_IX_HV ,
             '\n',
             '\nPA_PM_XI     = ',   PA_PM_XI    ,
             '\nPA_PM_XI_HBW = ',   PA_PM_XI_HBW,
             '\nPA_PM_XI_HBO = ',   PA_PM_XI_HBO,
             '\nPA_PM_XI_NHB = ',   PA_PM_XI_NHB,
             '\nPA_PM_XI_HBS = ',   PA_PM_XI_HBS,
             '\nPA_PM_XI_HBC = ',   PA_PM_XI_HBC,
             '\nPA_PM_XI_Rec = ',   PA_PM_XI_Rec,
             '\nPA_PM_XI_LT  = ',   PA_PM_XI_LT ,
             '\nPA_PM_XI_MD  = ',   PA_PM_XI_MD ,
             '\nPA_PM_XI_HV  = ',   PA_PM_XI_HV ,
             '\n',
             '\nPA_PM_XX     = ',   PA_PM_XX    ,
             '\nPA_PM_XX_HBW = ',   PA_PM_XX_HBW,
             '\nPA_PM_XX_HBO = ',   PA_PM_XX_HBO,
             '\nPA_PM_XX_NHB = ',   PA_PM_XX_NHB,
             '\nPA_PM_XX_HBS = ',   PA_PM_XX_HBS,
             '\nPA_PM_XX_HBC = ',   PA_PM_XX_HBC,
             '\nPA_PM_XX_Rec = ',   PA_PM_XX_Rec,
             '\nPA_PM_XX_LT  = ',   PA_PM_XX_LT ,
             '\nPA_PM_XX_MD  = ',   PA_PM_XX_MD ,
             '\nPA_PM_XX_HV  = ',   PA_PM_XX_HV ,
             '\n',
             '\n'
    
    ;EV
    PRINT PRINTO=1,
        FORM=8.5,
        LIST='\nPA_EV_HBW    = ',   PA_EV_HBW   ,
             '\nPA_EV_HBO    = ',   PA_EV_HBO   ,
             '\nPA_EV_NHB    = ',   PA_EV_NHB   ,
             '\nPA_EV_HBS    = ',   PA_EV_HBS   ,
             '\nPA_EV_HBC    = ',   PA_EV_HBC   ,
             '\nPA_EV_Rec    = ',   PA_EV_Rec   ,
             '\nPA_EV_LT     = ',   PA_EV_LT    ,
             '\nPA_EV_MD     = ',   PA_EV_MD    ,
             '\nPA_EV_HV     = ',   PA_EV_HV    ,
             '\nPA_EV_HBShp  = ',   PA_EV_HBShp ,
             '\nPA_EV_HBOth  = ',   PA_EV_HBOth ,
             '\nPA_EV_NHBW   = ',   PA_EV_NHBW  ,
             '\nPA_EV_NHBNW  = ',   PA_EV_NHBNW ,
             '\n',
             '\nPA_EV_IX     = ',   PA_EV_IX    ,
             '\nPA_EV_IX_HBW = ',   PA_EV_IX_HBW,
             '\nPA_EV_IX_HBO = ',   PA_EV_IX_HBO,
             '\nPA_EV_IX_NHB = ',   PA_EV_IX_NHB,
             '\nPA_EV_IX_HBS = ',   PA_EV_IX_HBS,
             '\nPA_EV_IX_HBC = ',   PA_EV_IX_HBC,
             '\nPA_EV_IX_Rec = ',   PA_EV_IX_Rec,
             '\nPA_EV_IX_LT  = ',   PA_EV_IX_LT ,
             '\nPA_EV_IX_MD  = ',   PA_EV_IX_MD ,
             '\nPA_EV_IX_HV  = ',   PA_EV_IX_HV ,
             '\n',
             '\nPA_EV_XI     = ',   PA_EV_XI    ,
             '\nPA_EV_XI_HBW = ',   PA_EV_XI_HBW,
             '\nPA_EV_XI_HBO = ',   PA_EV_XI_HBO,
             '\nPA_EV_XI_NHB = ',   PA_EV_XI_NHB,
             '\nPA_EV_XI_HBS = ',   PA_EV_XI_HBS,
             '\nPA_EV_XI_HBC = ',   PA_EV_XI_HBC,
             '\nPA_EV_XI_Rec = ',   PA_EV_XI_Rec,
             '\nPA_EV_XI_LT  = ',   PA_EV_XI_LT ,
             '\nPA_EV_XI_MD  = ',   PA_EV_XI_MD ,
             '\nPA_EV_XI_HV  = ',   PA_EV_XI_HV ,
             '\n',
             '\nPA_EV_XX     = ',   PA_EV_XX    ,
             '\nPA_EV_XX_HBW = ',   PA_EV_XX_HBW,
             '\nPA_EV_XX_HBO = ',   PA_EV_XX_HBO,
             '\nPA_EV_XX_NHB = ',   PA_EV_XX_NHB,
             '\nPA_EV_XX_HBS = ',   PA_EV_XX_HBS,
             '\nPA_EV_XX_HBC = ',   PA_EV_XX_HBC,
             '\nPA_EV_XX_Rec = ',   PA_EV_XX_Rec,
             '\nPA_EV_XX_LT  = ',   PA_EV_XX_LT ,
             '\nPA_EV_XX_MD  = ',   PA_EV_XX_MD ,
             '\nPA_EV_XX_HV  = ',   PA_EV_XX_HV ,
             '\n',
             '\n'
    
    ;print HBC by college factors
    PRINT PRINTO=1,
        FORM=8.5,
        LIST=';College Factors ---------------------------------------------------------------------------------------------',
             '\nPct_AM_HBC_BYU       = ',   Pct_AM_HBC_BYU       ,
             '\nPct_AM_HBC_ENSIGN    = ',   Pct_AM_HBC_ENSIGN    ,
             '\nPct_AM_HBC_SLCC      = ',   Pct_AM_HBC_SLCC      ,
             '\nPct_AM_HBC_SLCC_MAIN = ',   Pct_AM_HBC_SLCC_MAIN ,
             '\nPct_AM_HBC_SLCC_JD   = ',   Pct_AM_HBC_SLCC_JD   ,
             '\nPct_AM_HBC_SLCC_ML   = ',   Pct_AM_HBC_SLCC_ML   ,
             '\nPct_AM_HBC_SLCC_SC   = ',   Pct_AM_HBC_SLCC_SC   ,
             '\nPct_AM_HBC_UOFU_MAIN = ',   Pct_AM_HBC_UOFU_MAIN ,
             '\nPct_AM_HBC_WSU       = ',   Pct_AM_HBC_WSU       ,
             '\nPct_AM_HBC_WSU_MAIN  = ',   Pct_AM_HBC_WSU_MAIN  ,
             '\nPct_AM_HBC_WSU_DAVIS = ',   Pct_AM_HBC_WSU_DAVIS ,
             '\nPct_AM_HBC_UVU       = ',   Pct_AM_HBC_UVU       ,
             '\nPct_AM_HBC_WESTMIN   = ',   Pct_AM_HBC_WESTMIN   ,
             '\n',
             '\nPct_MD_HBC_BYU       = ',   Pct_MD_HBC_BYU       ,
             '\nPct_MD_HBC_ENSIGN    = ',   Pct_MD_HBC_ENSIGN    ,
             '\nPct_MD_HBC_SLCC      = ',   Pct_MD_HBC_SLCC      ,
             '\nPct_MD_HBC_SLCC_MAIN = ',   Pct_MD_HBC_SLCC_MAIN ,
             '\nPct_MD_HBC_SLCC_JD   = ',   Pct_MD_HBC_SLCC_JD   ,
             '\nPct_MD_HBC_SLCC_ML   = ',   Pct_MD_HBC_SLCC_ML   ,
             '\nPct_MD_HBC_SLCC_SC   = ',   Pct_MD_HBC_SLCC_SC   ,
             '\nPct_MD_HBC_UOFU_MAIN = ',   Pct_MD_HBC_UOFU_MAIN ,
             '\nPct_MD_HBC_WSU       = ',   Pct_MD_HBC_WSU       ,
             '\nPct_MD_HBC_WSU_MAIN  = ',   Pct_MD_HBC_WSU_MAIN  ,
             '\nPct_MD_HBC_WSU_DAVIS = ',   Pct_MD_HBC_WSU_DAVIS ,
             '\nPct_MD_HBC_UVU       = ',   Pct_MD_HBC_UVU       ,
             '\nPct_MD_HBC_WESTMIN   = ',   Pct_MD_HBC_WESTMIN   ,
             '\n',
             '\nPct_PM_HBC_BYU       = ',   Pct_PM_HBC_BYU       ,
             '\nPct_PM_HBC_ENSIGN    = ',   Pct_PM_HBC_ENSIGN    ,
             '\nPct_PM_HBC_SLCC      = ',   Pct_PM_HBC_SLCC      ,
             '\nPct_PM_HBC_SLCC_MAIN = ',   Pct_PM_HBC_SLCC_MAIN ,
             '\nPct_PM_HBC_SLCC_JD   = ',   Pct_PM_HBC_SLCC_JD   ,
             '\nPct_PM_HBC_SLCC_ML   = ',   Pct_PM_HBC_SLCC_ML   ,
             '\nPct_PM_HBC_SLCC_SC   = ',   Pct_PM_HBC_SLCC_SC   ,
             '\nPct_PM_HBC_UOFU_MAIN = ',   Pct_PM_HBC_UOFU_MAIN ,
             '\nPct_PM_HBC_WSU       = ',   Pct_PM_HBC_WSU       ,
             '\nPct_PM_HBC_WSU_MAIN  = ',   Pct_PM_HBC_WSU_MAIN  ,
             '\nPct_PM_HBC_WSU_DAVIS = ',   Pct_PM_HBC_WSU_DAVIS ,
             '\nPct_PM_HBC_UVU       = ',   Pct_PM_HBC_UVU       ,
             '\nPct_PM_HBC_WESTMIN   = ',   Pct_PM_HBC_WESTMIN   ,
             '\n',
             '\nPct_EV_HBC_BYU       = ',   Pct_EV_HBC_BYU       ,
             '\nPct_EV_HBC_ENSIGN    = ',   Pct_EV_HBC_ENSIGN    ,
             '\nPct_EV_HBC_SLCC      = ',   Pct_EV_HBC_SLCC      ,
             '\nPct_EV_HBC_SLCC_MAIN = ',   Pct_EV_HBC_SLCC_MAIN ,
             '\nPct_EV_HBC_SLCC_JD   = ',   Pct_EV_HBC_SLCC_JD   ,
             '\nPct_EV_HBC_SLCC_ML   = ',   Pct_EV_HBC_SLCC_ML   ,
             '\nPct_EV_HBC_SLCC_SC   = ',   Pct_EV_HBC_SLCC_SC   ,
             '\nPct_EV_HBC_UOFU_MAIN = ',   Pct_EV_HBC_UOFU_MAIN ,
             '\nPct_EV_HBC_WSU       = ',   Pct_EV_HBC_WSU       ,
             '\nPct_EV_HBC_WSU_MAIN  = ',   Pct_EV_HBC_WSU_MAIN  ,
             '\nPct_EV_HBC_WSU_DAVIS = ',   Pct_EV_HBC_WSU_DAVIS ,
             '\nPct_EV_HBC_UVU       = ',   Pct_EV_HBC_UVU       ,
             '\nPct_EV_HBC_WESTMIN   = ',   Pct_EV_HBC_WESTMIN   ,
             '\n',
             '\n',
             '\nPA_AM_HBC_BYU        = ',   PA_AM_HBC_BYU        ,
             '\nPA_AM_HBC_ENSIGN     = ',   PA_AM_HBC_ENSIGN     ,
             '\nPA_AM_HBC_SLCC       = ',   PA_AM_HBC_SLCC       ,
             '\nPA_AM_HBC_SLCC_MAIN  = ',   PA_AM_HBC_SLCC_MAIN  ,
             '\nPA_AM_HBC_SLCC_JD    = ',   PA_AM_HBC_SLCC_JD    ,
             '\nPA_AM_HBC_SLCC_ML    = ',   PA_AM_HBC_SLCC_ML    ,
             '\nPA_AM_HBC_SLCC_SC    = ',   PA_AM_HBC_SLCC_SC    ,
             '\nPA_AM_HBC_UOFU_MAIN  = ',   PA_AM_HBC_UOFU_MAIN  ,
             '\nPA_AM_HBC_WSU        = ',   PA_AM_HBC_WSU        ,
             '\nPA_AM_HBC_WSU_MAIN   = ',   PA_AM_HBC_WSU_MAIN   ,
             '\nPA_AM_HBC_WSU_DAVIS  = ',   PA_AM_HBC_WSU_DAVIS  ,
             '\nPA_AM_HBC_UVU        = ',   PA_AM_HBC_UVU        ,
             '\nPA_AM_HBC_WESTMIN    = ',   PA_AM_HBC_WESTMIN    ,
             '\n',
             '\nPA_MD_HBC_BYU        = ',   PA_MD_HBC_BYU        ,
             '\nPA_MD_HBC_ENSIGN     = ',   PA_MD_HBC_ENSIGN     ,
             '\nPA_MD_HBC_SLCC       = ',   PA_MD_HBC_SLCC       ,
             '\nPA_MD_HBC_SLCC_MAIN  = ',   PA_MD_HBC_SLCC_MAIN  ,
             '\nPA_MD_HBC_SLCC_JD    = ',   PA_MD_HBC_SLCC_JD    ,
             '\nPA_MD_HBC_SLCC_ML    = ',   PA_MD_HBC_SLCC_ML    ,
             '\nPA_MD_HBC_SLCC_SC    = ',   PA_MD_HBC_SLCC_SC    ,
             '\nPA_MD_HBC_UOFU_MAIN  = ',   PA_MD_HBC_UOFU_MAIN  ,
             '\nPA_MD_HBC_WSU        = ',   PA_MD_HBC_WSU        ,
             '\nPA_MD_HBC_WSU_MAIN   = ',   PA_MD_HBC_WSU_MAIN   ,
             '\nPA_MD_HBC_WSU_DAVIS  = ',   PA_MD_HBC_WSU_DAVIS  ,
             '\nPA_MD_HBC_UVU        = ',   PA_MD_HBC_UVU        ,
             '\nPA_MD_HBC_WESTMIN    = ',   PA_MD_HBC_WESTMIN    ,
             '\n',
             '\nPA_PM_HBC_BYU        = ',   PA_PM_HBC_BYU        ,
             '\nPA_PM_HBC_ENSIGN     = ',   PA_PM_HBC_ENSIGN     ,
             '\nPA_PM_HBC_SLCC       = ',   PA_PM_HBC_SLCC       ,
             '\nPA_PM_HBC_SLCC_MAIN  = ',   PA_PM_HBC_SLCC_MAIN  ,
             '\nPA_PM_HBC_SLCC_JD    = ',   PA_PM_HBC_SLCC_JD    ,
             '\nPA_PM_HBC_SLCC_ML    = ',   PA_PM_HBC_SLCC_ML    ,
             '\nPA_PM_HBC_SLCC_SC    = ',   PA_PM_HBC_SLCC_SC    ,
             '\nPA_PM_HBC_UOFU_MAIN  = ',   PA_PM_HBC_UOFU_MAIN  ,
             '\nPA_PM_HBC_WSU        = ',   PA_PM_HBC_WSU        ,
             '\nPA_PM_HBC_WSU_MAIN   = ',   PA_PM_HBC_WSU_MAIN   ,
             '\nPA_PM_HBC_WSU_DAVIS  = ',   PA_PM_HBC_WSU_DAVIS  ,
             '\nPA_PM_HBC_UVU        = ',   PA_PM_HBC_UVU        ,
             '\nPA_PM_HBC_WESTMIN    = ',   PA_PM_HBC_WESTMIN    ,
             '\n',
             '\nPA_EV_HBC_BYU        = ',   PA_EV_HBC_BYU        ,
             '\nPA_EV_HBC_ENSIGN     = ',   PA_EV_HBC_ENSIGN     ,
             '\nPA_EV_HBC_SLCC       = ',   PA_EV_HBC_SLCC       ,
             '\nPA_EV_HBC_SLCC_MAIN  = ',   PA_EV_HBC_SLCC_MAIN  ,
             '\nPA_EV_HBC_SLCC_JD    = ',   PA_EV_HBC_SLCC_JD    ,
             '\nPA_EV_HBC_SLCC_ML    = ',   PA_EV_HBC_SLCC_ML    ,
             '\nPA_EV_HBC_SLCC_SC    = ',   PA_EV_HBC_SLCC_SC    ,
             '\nPA_EV_HBC_UOFU_MAIN  = ',   PA_EV_HBC_UOFU_MAIN  ,
             '\nPA_EV_HBC_WSU        = ',   PA_EV_HBC_WSU        ,
             '\nPA_EV_HBC_WSU_MAIN   = ',   PA_EV_HBC_WSU_MAIN   ,
             '\nPA_EV_HBC_WSU_DAVIS  = ',   PA_EV_HBC_WSU_DAVIS  ,
             '\nPA_EV_HBC_UVU        = ',   PA_EV_HBC_UVU        ,
             '\nPA_EV_HBC_WESTMIN    = ',   PA_EV_HBC_WESTMIN    ,
             '\n'
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Calculate Time of Day Factors      ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'),
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN



;System cleanup
    *(DEL 1_CalculateTimeOfDayFac.txt)