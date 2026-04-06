
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 1_TripTable.txt)



;get start time
ScriptStartTime = currenttime()




;Create Unique Trip Tables for College zones
RUN PGM=MATRIX  MSG='Trip Table: Calculate Ariport, Lagoon, and HBC Trips'
FILEI ZDATI[1] = '@ParentDir@1_Inputs\0_GlobalData\0_TripTables\BaseDistribution.csv', 
    Z          =#01, 
    Airport    = 02,
    PVU        = 03,
    Lagoon     = 04,
    Ensign     = 05,
    Westmin    = 06,
    UofU_Main  = 07,
    UofU_Med   = 08,
    WSU_Main   = 09,
    WSU_Davis  = 10,
    WSU_West   = 11,
    SLCC_Main  = 12,
    SLCC_SC    = 13,
    SLCC_JD    = 14,
    SLCC_Mead  = 15,
    SLCC_ML    = 16,
    SLCC_LB    = 17,
    SLCC_HL    = 18,
    SLCC_Airp  = 19,
    SLCC_West  = 20,
    SLCC_HM    = 21,
    BYU        = 22,
    UVU_Main   = 23,
    UVU_Geneva = 24,
    UVU_Lehi   = 25,
    UVU_Vine   = 26,
    UVU_Payson = 27

FILEI ZDATI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\SE_File_@RID@.dbf'

FILEI ZDATI[3] = '@ParentDir@1_Inputs\1_TAZ\@TAZ_DBF@',
    Z=TAZID
      
FILEI MATI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\skm_FF.mtx'
FILEI MATI[2] = '@ParentDir@@ScenarioDir@0_InputProcessing\No_Transit_XFER.mtx'
    
    
    
    ;set MATRIX parameters
    ZONEMSG = @ZoneMsgRate@
    ZONES   = @Usedzones@
    
    
    
    ;define lookup function containing the college enrollment, airports, and Lagoon
    ;control totals
    LOOKUP FILE='@ParentDir@1_Inputs\0_GlobalData\0_TripTables\TripTableControlTotal.csv',
        LIST=F,
        INTERPOLATE=T,
        NAME=ControlTotal,
        Lookup[01]=01,  RESULT=02,    ;Airport
        Lookup[02]=01,  RESULT=03,    ;PVU    
        Lookup[03]=01,  RESULT=04,    ;Lagoon     
        Lookup[04]=01,  RESULT=05,    ;Ensign     
        Lookup[05]=01,  RESULT=06,    ;Westmin    
        Lookup[06]=01,  RESULT=07,    ;UofU_Main  
        Lookup[07]=01,  RESULT=08,    ;UofU_Med   
        Lookup[08]=01,  RESULT=09,    ;WSU_Main   
        Lookup[09]=01,  RESULT=10,    ;WSU_Davis  
        Lookup[10]=01,  RESULT=11,    ;WSU_West  
        Lookup[11]=01,  RESULT=12,    ;SLCC_Main 
        Lookup[12]=01,  RESULT=13,    ;SLCC_SC   
        Lookup[13]=01,  RESULT=14,    ;SLCC_JD   
        Lookup[14]=01,  RESULT=15,    ;SLCC_Mead 
        Lookup[15]=01,  RESULT=16,    ;SLCC_ML   
        Lookup[16]=01,  RESULT=17,    ;SLCC_LB   
        Lookup[17]=01,  RESULT=18,    ;SLCC_HL   
        Lookup[18]=01,  RESULT=19,    ;SLCC_Airp 
        Lookup[19]=01,  RESULT=20,    ;SLCC_West 
        Lookup[20]=01,  RESULT=21,    ;SLCC_HM   
        Lookup[21]=01,  RESULT=22,    ;BYU       
        Lookup[22]=01,  RESULT=23,    ;UVU_Main  
        Lookup[23]=01,  RESULT=24,    ;UVU_Geneva
        Lookup[24]=01,  RESULT=25,    ;UVU_Lehi
        Lookup[25]=01,  RESULT=26,    ;UVU_Vine  
        Lookup[26]=01,  RESULT=27     ;UVU_Payson

    ;Lookup Concurrent/Online degree percent
    ;note: index 1 = Pct_Remove
    ;      index 2 = FTERate   
    ;      index 3 = HBCRates  
    LOOKUP FILE='@ParentDir@1_Inputs\0_GlobalData\0_TripTables\College_Factors.csv',
        LIST=F,
        INTERPOLATE=T,
        NAME=HBC_Remove,
        Lookup[01]=01,  RESULT=02,    ;Ensign     
        Lookup[02]=01,  RESULT=03,    ;Westmin    
        Lookup[03]=01,  RESULT=04,    ;UofU_Main  
        Lookup[04]=01,  RESULT=05,    ;UofU_Med   
        Lookup[05]=01,  RESULT=06,    ;WSU_Main   
        Lookup[06]=01,  RESULT=07,    ;WSU_Davis  
        Lookup[07]=01,  RESULT=08,    ;WSU_West   
        Lookup[08]=01,  RESULT=09,    ;SLCC_Main  
        Lookup[09]=01,  RESULT=10,    ;SLCC_SC   
        Lookup[10]=01,  RESULT=11,    ;SLCC_JD   
        Lookup[11]=01,  RESULT=12,    ;SLCC_Mead 
        Lookup[12]=01,  RESULT=13,    ;SLCC_ML   
        Lookup[13]=01,  RESULT=14,    ;SLCC_LB   
        Lookup[14]=01,  RESULT=15,    ;SLCC_HL   
        Lookup[15]=01,  RESULT=16,    ;SLCC_Airp 
        Lookup[16]=01,  RESULT=17,    ;SLCC_West 
        Lookup[17]=01,  RESULT=18,    ;SLCC_HM   
        Lookup[18]=01,  RESULT=19,    ;BYU       
        Lookup[19]=01,  RESULT=20,    ;UVU_Main  
        Lookup[20]=01,  RESULT=21,    ;UVU_Geneva
        Lookup[21]=01,  RESULT=22,    ;UVU_Lehi
        Lookup[22]=01,  RESULT=23,    ;UVU_Vine  
        Lookup[23]=01,  RESULT=24     ;UVU_Payson
        
    
    
    ;define arrays
    ARRAY Distance_AIRPORT    = ZONES,    ;Airport
          Distance_PVU        = ZONES,    ;PVU   
          Distance_LAGOON     = ZONES,    ;Lagoon    
          Distance_Ensign     = ZONES,    ;Ensign    
          Distance_Westmin    = ZONES,    ;Westmin   
          Distance_UofU_Main  = ZONES,    ;UofU_Main 
          Distance_UofU_Med   = ZONES,    ;UofU_Med  
          Distance_WSU_Main   = ZONES,    ;WSU_Main  
          Distance_WSU_Davis  = ZONES,    ;WSU_Davis 
          Distance_WSU_West   = ZONES,    ;WSU_West  
          Distance_SLCC_Main  = ZONES,    ;SLCC_Main 
          Distance_SLCC_SC    = ZONES,    ;SLCC_SC   
          Distance_SLCC_JD    = ZONES,    ;SLCC_JD   
          Distance_SLCC_Mead  = ZONES,    ;SLCC_Mead 
          Distance_SLCC_ML    = ZONES,    ;SLCC_ML   
          Distance_SLCC_LB    = ZONES,    ;SLCC_LB   
          Distance_SLCC_HL    = ZONES,    ;SLCC_HL   
          Distance_SLCC_Airp  = ZONES,    ;SLCC_Airp 
          Distance_SLCC_West  = ZONES,    ;SLCC_West 
          Distance_SLCC_HM    = ZONES,    ;SLCC_HM   
          Distance_BYU        = ZONES,    ;BYU       
          Distance_UVU_Main   = ZONES,    ;UVU_Main  
          Distance_UVU_Geneva = ZONES,    ;UVU_Geneva
          Distance_UVU_Lehi   = ZONES,    ;UVU_Lehi  
          Distance_UVU_Vine   = ZONES,    ;UVU_Vine  
          Distance_UVU_Payson = ZONES,    ;UVU_Payson

          
          NoXfer_AIRPORT      = ZONES,    ;Airport
          NoXfer_PVU          = ZONES,    ;PVU   
          NoXfer_LAGOON       = ZONES,    ;Lagoon    
          NoXfer_Ensign       = ZONES,    ;Ensign    
          NoXfer_Westmin      = ZONES,    ;Westmin   
          NoXfer_UofU_Main    = ZONES,    ;UofU_Main 
          NoXfer_UofU_Med     = ZONES,    ;UofU_Med  
          NoXfer_WSU_Main     = ZONES,    ;WSU_Main  
          NoXfer_WSU_Davis    = ZONES,    ;WSU_Davis 
          NoXfer_WSU_West     = ZONES,    ;WSU_West  
          NoXfer_SLCC_Main    = ZONES,    ;SLCC_Main 
          NoXfer_SLCC_SC      = ZONES,    ;SLCC_SC   
          NoXfer_SLCC_JD      = ZONES,    ;SLCC_JD   
          NoXfer_SLCC_Mead    = ZONES,    ;SLCC_Mead 
          NoXfer_SLCC_ML      = ZONES,    ;SLCC_ML   
          NoXfer_SLCC_LB      = ZONES,    ;SLCC_LB   
          NoXfer_SLCC_HL      = ZONES,    ;SLCC_HL   
          NoXfer_SLCC_Airp    = ZONES,    ;SLCC_Airp 
          NoXfer_SLCC_West    = ZONES,    ;SLCC_West 
          NoXfer_SLCC_HM      = ZONES,    ;SLCC_HM   
          NoXfer_BYU          = ZONES,    ;BYU       
          NoXfer_UVU_Main     = ZONES,    ;UVU_Main  
          NoXfer_UVU_Geneva   = ZONES,    ;UVU_Geneva
          NoXfer_UVU_Lehi     = ZONES,    ;UVU_Lehi
          NoXfer_UVU_Vine     = ZONES,    ;UVU_Vine  
          NoXfer_UVU_Payson   = ZONES,    ;UVU_Payson
          
          
          Time_AIRPORT        = ZONES,    ;Airport
          Time_PVU            = ZONES,    ;PVU   
          Time_LAGOON         = ZONES,    ;Lagoon    
          Time_Ensign         = ZONES,    ;Ensign    
          Time_Westmin        = ZONES,    ;Westmin   
          Time_UofU_Main      = ZONES,    ;UofU_Main 
          Time_UofU_Med       = ZONES,    ;UofU_Med  
          Time_WSU_Main       = ZONES,    ;WSU_Main  
          Time_WSU_Davis      = ZONES,    ;WSU_Davis 
          Time_WSU_West       = ZONES,    ;WSU_West  
          Time_SLCC_Main      = ZONES,    ;SLCC_Main 
          Time_SLCC_SC        = ZONES,    ;SLCC_SC   
          Time_SLCC_JD        = ZONES,    ;SLCC_JD   
          Time_SLCC_Mead      = ZONES,    ;SLCC_Mead 
          Time_SLCC_ML        = ZONES,    ;SLCC_ML   
          Time_SLCC_LB        = ZONES,    ;SLCC_LB   
          Time_SLCC_HL        = ZONES,    ;SLCC_HL   
          Time_SLCC_Airp      = ZONES,    ;SLCC_Airp 
          Time_SLCC_West      = ZONES,    ;SLCC_West 
          Time_SLCC_HM        = ZONES,    ;SLCC_HM   
          Time_BYU            = ZONES,    ;BYU       
          Time_UVU_Main       = ZONES,    ;UVU_Main  
          Time_UVU_Geneva     = ZONES,    ;UVU_Geneva
          Time_UVU_Lehi       = ZONES,    ;UVU_Lehi
          Time_UVU_Vine       = ZONES,    ;UVU_Vine  
          Time_UVU_Payson     = ZONES,    ;UVU_Payson
          

          Utility_AIRPORT     = ZONES,    ;Airport
          Utility_PVU         = ZONES,    ;PVU   
          Utility_LAGOON      = ZONES,    ;Lagoon    
          Utility_Ensign      = ZONES,    ;Ensign    
          Utility_Westmin     = ZONES,    ;Westmin   
          Utility_UofU_Main   = ZONES,    ;UofU_Main 
          Utility_UofU_Med    = ZONES,    ;UofU_Med  
          Utility_WSU_Main    = ZONES,    ;WSU_Main  
          Utility_WSU_Davis   = ZONES,    ;WSU_Davis 
          Utility_WSU_West    = ZONES,    ;WSU_West  
          Utility_SLCC_Main   = ZONES,    ;SLCC_Main 
          Utility_SLCC_SC     = ZONES,    ;SLCC_SC   
          Utility_SLCC_JD     = ZONES,    ;SLCC_JD   
          Utility_SLCC_Mead   = ZONES,    ;SLCC_Mead 
          Utility_SLCC_ML     = ZONES,    ;SLCC_ML   
          Utility_SLCC_LB     = ZONES,    ;SLCC_LB   
          Utility_SLCC_HL     = ZONES,    ;SLCC_HL   
          Utility_SLCC_Airp   = ZONES,    ;SLCC_Airp 
          Utility_SLCC_West   = ZONES,    ;SLCC_West 
          Utility_SLCC_HM     = ZONES,    ;SLCC_HM   
          Utility_BYU         = ZONES,    ;BYU       
          Utility_UVU_Main    = ZONES,    ;UVU_Main  
          Utility_UVU_Geneva  = ZONES,    ;UVU_Geneva
          Utility_UVU_Lehi    = ZONES,    ;UVU_Lehi  
          Utility_UVU_Vine    = ZONES,    ;UVU_Vine  
          Utility_UVU_Payson  = ZONES,    ;UVU_Payson
          
          
          HC_Ensign           = ZONES,    ;Ensign    
          HC_Westmin          = ZONES,    ;Westmin   
          HC_UofU_Main        = ZONES,    ;UofU_Main 
          HC_UofU_Med         = ZONES,    ;UofU_Med  
          HC_WSU_Main         = ZONES,    ;WSU_Main  
          HC_WSU_Davis        = ZONES,    ;WSU_Davis 
          HC_WSU_West         = ZONES,    ;WSU_West  
          HC_SLCC_Main        = ZONES,    ;SLCC_Main 
          HC_SLCC_SC          = ZONES,    ;SLCC_SC   
          HC_SLCC_JD          = ZONES,    ;SLCC_JD   
          HC_SLCC_Mead        = ZONES,    ;SLCC_Mead 
          HC_SLCC_ML          = ZONES,    ;SLCC_ML   
          HC_SLCC_LB          = ZONES,    ;SLCC_LB   
          HC_SLCC_HL          = ZONES,    ;SLCC_HL   
          HC_SLCC_Airp        = ZONES,    ;SLCC_Airp 
          HC_SLCC_West        = ZONES,    ;SLCC_West 
          HC_SLCC_HM          = ZONES,    ;SLCC_HM   
          HC_BYU              = ZONES,    ;BYU       
          HC_UVU_Main         = ZONES,    ;UVU_Main  
          HC_UVU_Geneva       = ZONES,    ;UVU_Geneva
          HC_UVU_Lehi         = ZONES,    ;UVU_Lehi  
          HC_UVU_Vine         = ZONES,    ;UVU_Vine  
          HC_UVU_Payson       = ZONES,    ;UVU_Payson
          
          Trips_Airport       = ZONES,
          Trips_Pvu           = ZONES,
          Trips_Lagoon        = ZONES
          
    
    
    
    ;assign distance and no transfer arrays *********************************************
    JLOOP
        
        ;assign distance arrays from free flow skim matrix
        if (j=@Lagoon@    )  Distance_Lagoon[i]     = mi.1.DISTANCE[j]
        if (j=@Airport@   )  Distance_Airport[i]    = mi.1.DISTANCE[j]
        if (j=@PVU@       )  Distance_PVU[i]        = mi.1.DISTANCE[j]
        if (j=@Ensign@    )  Distance_Ensign[i]     = mi.1.DISTANCE[j]
        if (j=@Westmin@   )  Distance_Westmin[i]    = mi.1.DISTANCE[j]
        if (j=@UOFU_Main@ )  Distance_UOFU_Main[i]  = mi.1.DISTANCE[j]
        if (j=@UOFU_Med@  )  Distance_UOFU_Med[i]   = mi.1.DISTANCE[j]
        if (j=@WSU_Main@  )  Distance_WSU_Main[i]   = mi.1.DISTANCE[j]
        if (j=@WSU_Davis@ )  Distance_WSU_Davis[i]  = mi.1.DISTANCE[j]
        if (j=@WSU_West@  )  Distance_WSU_West[i]   = mi.1.DISTANCE[j]
        if (j=@SLCC_Main@ )  Distance_SLCC_Main[i]  = mi.1.DISTANCE[j]
        if (j=@SLCC_SC@   )  Distance_SLCC_SC[i]    = mi.1.DISTANCE[j]
        if (j=@SLCC_JD@   )  Distance_SLCC_JD[i]    = mi.1.DISTANCE[j]
        if (j=@SLCC_Mead@ )  Distance_SLCC_Mead[i]  = mi.1.DISTANCE[j]
        if (j=@SLCC_ML@   )  Distance_SLCC_ML[i]    = mi.1.DISTANCE[j]
        if (j=@SLCC_LB@   )  Distance_SLCC_LB[i]    = mi.1.DISTANCE[j]
        if (j=@SLCC_HL@   )  Distance_SLCC_HL[i]    = mi.1.DISTANCE[j]
        if (j=@SLCC_Airp@ )  Distance_SLCC_Airp[i]  = mi.1.DISTANCE[j]
        if (j=@SLCC_West@ )  Distance_SLCC_West[i]  = mi.1.DISTANCE[j]
        if (j=@SLCC_HM@   )  Distance_SLCC_HM[i]    = mi.1.DISTANCE[j]
        if (j=@BYU@       )  Distance_BYU[i]        = mi.1.DISTANCE[j]
        if (j=@UVU_Main@  )  Distance_UVU_Main[i]   = mi.1.DISTANCE[j]
        if (j=@UVU_Geneva@)  Distance_UVU_Geneva[i] = mi.1.DISTANCE[j]
        if (j=@UVU_Lehi@  )  Distance_UVU_Lehi[i]   = mi.1.DISTANCE[j]
        if (j=@UVU_Vine@  )  Distance_UVU_Vine[i]   = mi.1.DISTANCE[j]
        if (j=@UVU_Payson@)  Distance_UVU_Payson[i] = mi.1.DISTANCE[j]
        
        ;assign no transfer arrays
       ;if (j=@Lagoon@    )  NoXfer_Lagoon[i]     = mi.2.NO_XFERs[j]    ;no xfer data needed for airports/Lagoon
       ;if (j=@Airport@   )  NoXfer_Airport[i]    = mi.2.NO_XFER[j]
       ;if (j=@PVU@)         NoXfer_PVU[i]        = mi.2.NO_XFER[j]
        if (j=@Ensign@    )  NoXfer_Ensign[i]     = mi.2.NO_XFER[j]
        if (j=@Westmin@   )  NoXfer_Westmin[i]    = mi.2.NO_XFER[j]
        if (j=@UOFU_Main@ )  NoXfer_UOFU_Main[i]  = mi.2.NO_XFER[j]
        if (j=@UOFU_Med@  )  NoXfer_UOFU_Med[i]   = mi.2.NO_XFER[j]
        if (j=@WSU_Main@  )  NoXfer_WSU_Main[i]   = mi.2.NO_XFER[j]
        if (j=@WSU_Davis@ )  NoXfer_WSU_Davis[i]  = mi.2.NO_XFER[j]
        if (j=@WSU_West@  )  NoXfer_WSU_West[i]   = mi.2.NO_XFER[j]
        if (j=@SLCC_Main@ )  NoXfer_SLCC_Main[i]  = mi.2.NO_XFER[j]
        if (j=@SLCC_SC@   )  NoXfer_SLCC_SC[i]    = mi.2.NO_XFER[j]
        if (j=@SLCC_JD@   )  NoXfer_SLCC_JD[i]    = mi.2.NO_XFER[j]
        if (j=@SLCC_Mead@ )  NoXfer_SLCC_Mead[i]  = mi.2.NO_XFER[j]
        if (j=@SLCC_ML@   )  NoXfer_SLCC_ML[i]    = mi.2.NO_XFER[j]
        if (j=@SLCC_LB@   )  NoXfer_SLCC_LB[i]    = mi.2.NO_XFER[j]
        if (j=@SLCC_HL@   )  NoXfer_SLCC_HL[i]    = mi.2.NO_XFER[j]
        if (j=@SLCC_Airp@ )  NoXfer_SLCC_Airp[i]  = mi.2.NO_XFER[j]
        if (j=@SLCC_West@ )  NoXfer_SLCC_West[i]  = mi.2.NO_XFER[j]
        if (j=@SLCC_HM@   )  NoXfer_SLCC_HM[i]    = mi.2.NO_XFER[j]
        if (j=@BYU@       )  NoXfer_BYU[i]        = mi.2.NO_XFER[j]
        if (j=@UVU_Main@  )  NoXfer_UVU_Main[i]   = mi.2.NO_XFER[j]
        if (j=@UVU_Geneva@)  NoXfer_UVU_Geneva[i] = mi.2.NO_XFER[j]
        if (j=@UVU_Lehi@  )  NoXfer_UVU_Lehi[i]   = mi.2.NO_XFER[j]
        if (j=@UVU_Vine@  )  NoXfer_UVU_Vine[i]   = mi.2.NO_XFER[j]
        if (j=@UVU_Payson@)  NoXfer_UVU_Payson[i] = mi.2.NO_XFER[j]


    ENDJLOOP
    
    
    ;calculate global variables *********************************************************
    if (i=1)
        ;assign forecast year
        Year = @demographicyear@
        
        ;assign control total variables and remove concurrent and online enrollment from colleges
        ContTot_Airport    = ControlTotal(01, Year)                              ;Airport
        ContTot_PVU        = ControlTotal(02, Year)                              ;PVU   
        ContTot_Lagoon     = ControlTotal(03, Year)                              ;Lagoon    
        ContTot_Ensign     = ControlTotal(04, Year) * (1 - HBC_Remove(01, 1))    ;Ensign    
        ContTot_Westmin    = ControlTotal(05, Year) * (1 - HBC_Remove(02, 1))    ;Westmin   
        ContTot_UOFU_Main  = ControlTotal(06, Year) * (1 - HBC_Remove(03, 1))    ;UofU_Main 
        ContTot_UOFU_Med   = ControlTotal(07, Year) * (1 - HBC_Remove(04, 1))    ;UofU_Med  
        ContTot_WSU_Main   = ControlTotal(08, Year) * (1 - HBC_Remove(05, 1))    ;WSU_Main  
        ContTot_WSU_Davis  = ControlTotal(09, Year) * (1 - HBC_Remove(06, 1))    ;WSU_Davis 
        ContTot_WSU_West   = ControlTotal(10, Year) * (1 - HBC_Remove(07, 1))    ;WSU_West  
        ContTot_SLCC_Main  = ControlTotal(11, Year) * (1 - HBC_Remove(08, 1))    ;SLCC_Main 
        ContTot_SLCC_SC    = ControlTotal(12, Year) * (1 - HBC_Remove(09, 1))    ;SLCC_SC   
        ContTot_SLCC_JD    = ControlTotal(13, Year) * (1 - HBC_Remove(10, 1))    ;SLCC_JD   
        ContTot_SLCC_Mead  = ControlTotal(14, Year) * (1 - HBC_Remove(11, 1))    ;SLCC_Mead 
        ContTot_SLCC_ML    = ControlTotal(15, Year) * (1 - HBC_Remove(12, 1))    ;SLCC_ML   
        ContTot_SLCC_LB    = ControlTotal(16, Year) * (1 - HBC_Remove(13, 1))    ;SLCC_LB   
        ContTot_SLCC_HL    = ControlTotal(17, Year) * (1 - HBC_Remove(14, 1))    ;SLCC_HL   
        ContTot_SLCC_Airp  = ControlTotal(18, Year) * (1 - HBC_Remove(15, 1))    ;SLCC_Airp 
        ContTot_SLCC_West  = ControlTotal(19, Year) * (1 - HBC_Remove(16, 1))    ;SLCC_West 
        ContTot_SLCC_HM    = ControlTotal(20, Year) * (1 - HBC_Remove(17, 1))    ;SLCC_HM   
        ContTot_BYU        = ControlTotal(21, Year) * (1 - HBC_Remove(18, 1))    ;BYU       
        ContTot_UVU_Main   = ControlTotal(22, Year) * (1 - HBC_Remove(19, 1))    ;UVU_Main  
        ContTot_UVU_Geneva = ControlTotal(23, Year) * (1 - HBC_Remove(20, 1))    ;UVU_Geneva
        ContTot_UVU_Lehi   = ControlTotal(24, Year) * (1 - HBC_Remove(21, 1))    ;UVU_Lehi
        ContTot_UVU_Vine   = ControlTotal(25, Year) * (1 - HBC_Remove(22, 1))    ;UVU_Vine  
        ContTot_UVU_Payson = ControlTotal(26, Year) * (1 - HBC_Remove(23, 1))    ;UVU_Payson
        

        
        
        ;calculate totals
        JLOOP
            ;sum pop and employment totals
            TotalPop = TotalPop + zi.2.HHPOP[j]
            
            ;sum base year totals
            Base_Airport    = Base_Airport    + zi.1.Airport[j]
            Base_PVU        = Base_PVU        + zi.1.PVU[j]
            Base_Lagoon     = Base_Lagoon     + zi.1.Lagoon[j]
            Base_Ensign     = Base_Ensign     + zi.1.Ensign[j]
            Base_Westmin    = Base_Westmin    + zi.1.Westmin[j]
            Base_UofU_Main  = Base_UofU_Main  + zi.1.UofU_Main[j]
            Base_UofU_Med   = Base_UofU_Med   + zi.1.UofU_Med[j]
            Base_WSU_Main   = Base_WSU_Main   + zi.1.WSU_Main[j] 
            Base_WSU_Davis  = Base_WSU_Davis  + zi.1.WSU_Davis[j]
            Base_WSU_West   = Base_WSU_West   + zi.1.WSU_West[j]
            Base_SLCC_Main  = Base_SLCC_Main  + zi.1.SLCC_Main[j]
            Base_SLCC_SC    = Base_SLCC_SC    + zi.1.SLCC_SC[j]
            Base_SLCC_JD    = Base_SLCC_JD    + zi.1.SLCC_JD[j]
            Base_SLCC_Mead  = Base_SLCC_Mead  + zi.1.SLCC_Mead[j]
            Base_SLCC_ML    = Base_SLCC_ML    + zi.1.SLCC_ML[j]
            Base_SLCC_LB    = Base_SLCC_LB    + zi.1.SLCC_LB[j]
            Base_SLCC_HL    = Base_SLCC_HL    + zi.1.SLCC_HL[j]
            Base_SLCC_Airp  = Base_SLCC_Airp  + zi.1.SLCC_Airp[j]
            Base_SLCC_West  = Base_SLCC_West  + zi.1.SLCC_West[j]
            Base_SLCC_HM    = Base_SLCC_HM    + zi.1.SLCC_HM[j]
            Base_BYU        = Base_BYU        + zi.1.BYU[j]
            Base_UVU_Main   = Base_UVU_Main   + zi.1.UVU_Main[j]
            Base_UVU_Geneva = Base_UVU_Geneva + zi.1.UVU_Geneva[j]
            Base_UVU_Lehi   = Base_UVU_Lehi   + zi.1.UVU_Lehi[j]
            Base_UVU_Vine   = Base_UVU_Vine   + zi.1.UVU_Vine[j]
            Base_UVU_Payson = Base_UVU_Payson + zi.1.UVU_Payson[j]
            

            
        ENDJLOOP
        
    endif  ;i=1
    
    
    ;calculate household density (used in college trip calculations)
    if (zi.3.DEVACRES[i]=0)
        HHDensity = 0
    else
        HHDensity = zi.2.TOTHH[i] / zi.3.DEVACRES[i]
    endif
    
    
    
    ;Calculate utilities ****************************************************************
    ;(utilities are used to establish the probabilities for each zone)
    
    ;Airport -----------------------------------------------------------
    ;set IncomeCoef for airport trip calculation
    if (zi.2.AVGINCOME[i]<@Income_Lo@)
        IncomeCoef = 0.015
    
    elseif (zi.2.AVGINCOME[i]<@Income_Md@)
        IncomeCoef = 0.020
    
    elseif (zi.2.AVGINCOME[i]<@Income_Hi@)
        IncomeCoef = 0.027
    
    else
        IncomeCoef = 0.036
    
    endif
    
    
    ;calculate airport utility
    Utility_Airport[i] = zi.2.HHPOP[i] * IncomeCoef +
                         zi.2.RETEMP[i] * 0.110 +
                         zi.2.INDEMP[i] * 0.040 +
                         zi.2.OTHEMP[i] * 0.040
    
    SumUtility_Airport = SumUtility_Airport + Utility_Airport[i]
    
    ;PVU Airport -----------------------------------------------------------
    ;set IncomeCoef for PVU airport trip calculation
    if (zi.2.AVGINCOME[i]<@Income_Lo@)
        IncomeCoef = 0.015
    
    elseif (zi.2.AVGINCOME[i]<@Income_Md@)
        IncomeCoef = 0.020
    
    elseif (zi.2.AVGINCOME[i]<@Income_Hi@)
        IncomeCoef = 0.027
    
    else
        IncomeCoef = 0.036
    
    endif
    
    ;assign PVU weight factor based on distance
    if (Distance_PVU[i]<25)
        PVUWeight = 3
    
    elseif (Distance_PVU[i]<50)
        PVUWeight = 2
    
    elseif (Distance_PVU[i]<10000)
        PVUWeight = 1
    
    else
        PVUWeight = 0
    
    endif

    ;calculate PVU airport utility
    Utility_PVU[i] = (zi.2.HHPOP[i] * IncomeCoef +
                         zi.2.RETEMP[i] * 0.110 +
                         zi.2.INDEMP[i] * 0.040 +
                         zi.2.OTHEMP[i] * 0.040) * PVUWeight
    
    SumUtility_PVU = SumUtility_PVU + Utility_PVU[i]
    
    
    ;Lagoon -------------------------------------------------------------
    ;calculate populatoin ratio (used in Lagoon trip calculation)
    PopRatio = zi.2.HHPOP[i] / TotalPop
    
    
    ;assign Lagoon weight factor based on distance
    if (Distance_Lagoon[i]<11)
        LagoonWeight = 2
    
    elseif (Distance_Lagoon[i]<26)
        LagoonWeight = 1
    
    elseif (Distance_Lagoon[i]<10000)
        LagoonWeight = 0.5
    
    else
        LagoonWeight = 0
    
    endif
    
    
    ;calculate liklihood of trip to Lagoon
    Utility_Lagoon[i] = PopRatio * LagoonWeight
    
    SumUtility_Lagoon = SumUtility_Lagoon + Utility_Lagoon[i]
    
    
    ;print check files
    ;if (i=1)
    ;    PRINT CSV=T, FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_Lagoon_Check.csv', 
    ;        FORM=11.0 
    ;        LIST='I', 'Distance', 'Weight', 'Pop', 'HHPop', 'PopRatio', 'Utility', 'SumUtil'
    ;endif
    ;
    ;PRINT CSV=T, 
    ;    FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_Lagoon_Check.csv', 
    ;    FORM=11.2 
    ;    LIST=I(11.0), Distance_Lagoon[i], LagoonWeight, zi.2.HHPOP[i], TotalPop, PopRatio(11.8), Utility_Lagoon[i](11.8), SumUtility_Lagoon(11.8)
    
    
    
    ;colleges ============================================================================
    
    ;Ensign-------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_Ensign[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_Ensign[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_Ensign[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_Ensign[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate Ensignutility
    Utility_Ensign[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_Ensign= SumUtility_Ensign+ Utility_Ensign[i]
    
    
    
    ;Westminster -------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_Westmin[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_Westmin[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_Westmin[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_Westmin[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate Westmin utility
    Utility_Westmin[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_Westmin = SumUtility_Westmin + Utility_Westmin[i]
    
    
    
    ;UofU_Main ---------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UofU_Main[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 + 0.0000008858
    
    elseif (Distance_UofU_Main[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 + 0.0000001339
    
    elseif (Distance_UofU_Main[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000010647
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UofU_Main[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UofU_Main utility
    Utility_UofU_Main[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UofU_Main = SumUtility_UofU_Main + Utility_UofU_Main[i]    
    
    
    
    ;UofU_Med ---------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UofU_Med[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 + 0.0000008858
    
    elseif (Distance_UofU_Med[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 + 0.0000001339
    
    elseif (Distance_UofU_Med[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000010647
    
    else
        DistanceCoef_ = 0.0000000205
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UofU_Med[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UofU_Med utility
    Utility_UofU_Med[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UofU_Med = SumUtility_UofU_Med + Utility_UofU_Med[i]    
    
    
        
    ;WSU_Main  ----------------------------------------------------------
    ;Set ColPopCoef for college trip calculation
    if (Distance_WSU_Main[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_WSU_Main[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_WSU_Main[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_WSU_Main[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate WSU_Main  utility
    Utility_WSU_Main[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_WSU_Main = SumUtility_WSU_Main + Utility_WSU_Main[i] 
    
    
    ;print check files
    ;if (i=1)
    ;    PRINT CSV=T, 
    ;        FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_Main_Check.csv', 
    ;        FORM=11.0 
    ;        LIST='I', 'POP', 'DistCoef', 'TranCoef', 'DenCoef', 'Utility', 'SumUtil', 'Distance', 'NoXfer'
    ;endif
    ;
    ;PRINT CSV=T, 
    ;    FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_Main_Check.csv', 
    ;    FORM=11.2 
    ;    LIST=I(11.0), zi.2.HHPOP[i], DistanceCoef_(13.10), TransitCoef_(13.10), DensityCoef_(13.10), Utility_WSU_Main[i] (11.8), SumUtility_WSU_Main(11.8), 
    ;                  Distance_WSU_Main[i] , NoXfer_WSU_Main[i] 
    
    
    
    ;WSU_Davis ----------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_WSU_Davis[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_WSU_Davis[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_WSU_Davis[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_WSU_Davis[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate WSU_Davis utility
    Utility_WSU_Davis[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_WSU_Davis = SumUtility_WSU_Davis + Utility_WSU_Davis[i]
    
    
    ;print check files
    ;if (i=1)
    ;    PRINT CSV=T, 
    ;        FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_Davis_Check.csv', 
    ;        FORM=11.0 
    ;        LIST='I', 'POP', 'DistCoef', 'TranCoef', 'DenCoef', 'Utility', 'SumUtil', 'Distance', 'NoXfer'
    ;endif
    ;
    ;PRINT CSV=T, 
    ;    FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_Davis_Check.csv', 
    ;    FORM=11.2 
    ;    LIST=I(11.0), zi.2.HHPOP[i], DistanceCoef_(13.10), TransitCoef_(13.10), DensityCoef_(13.10), Utility_WSU_Davis[i](11.8), SumUtility_WSU_Davis(11.8), 
    ;         Distance_WSU_Davis[i], NoXfer_WSU_Davis[i]
    
    
    
    ;WSU_West -----------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_WSU_West[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_WSU_West[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_WSU_West[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_WSU_West[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate WSU_West utility
    Utility_WSU_West[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_WSU_West = SumUtility_WSU_West + Utility_WSU_West[i]
    
    
    ;print check files
    ;if (i=1)
    ;    PRINT CSV=T, 
    ;        FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_West_Check.csv', 
    ;        FORM=11.0 
    ;        LIST='I', 'POP', 'DistCoef', 'TranCoef', 'DenCoef', 'Utility', 'SumUtil', 'Distance', 'NoXfer'
    ;endif
    ;
    ;PRINT CSV=T, 
    ;    FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_WSU_West_Check.csv', 
    ;    FORM=11.2 
    ;    LIST=I(11.0), zi.2.HHPOP[i], DistanceCoef_(13.10), TransitCoef_(13.10), DensityCoef_(13.10), Utility_WSU_West[i](11.8), SumUtility_WSU_Davis(11.8), 
    ;         Distance_WSU_West[i], NoXfer_WSU_West[i]
    
    
    

    ;SLCC_Main --------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_Main[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_Main[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_Main[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_Main[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_Main utility
    Utility_SLCC_Main[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_Main = SumUtility_SLCC_Main + Utility_SLCC_Main[i]
    
    
    
    ;SLCC_SC -------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_SC[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_SC[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_SC[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_SC[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_SC utility
    Utility_SLCC_SC[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_SC = SumUtility_SLCC_SC + Utility_SLCC_SC[i]
    
    
    
    ;SLCC_JD -------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_JD[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_JD[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_JD[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_JD[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_JD utility
    Utility_SLCC_JD[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_JD = SumUtility_SLCC_JD + Utility_SLCC_JD[i]
    
    
    
    ;SLCC_Mead -------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_Mead[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_Mead[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_Mead[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_Mead[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_Mead utility
    Utility_SLCC_Mead[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_Mead = SumUtility_SLCC_Mead + Utility_SLCC_Mead[i]
    
    
    
    ;SLCC_ML ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_ML[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_ML[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_ML[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_ML[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_ML utility
    Utility_SLCC_ML[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_ML = SumUtility_SLCC_ML + Utility_SLCC_ML[i]
    
    
    
    ;SLCC_LB ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_LB[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_LB[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_LB[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_LB[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_LB utility
    Utility_SLCC_LB[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_LB = SumUtility_SLCC_LB + Utility_SLCC_LB[i]
    
    
    
    ;SLCC_HL ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_HL[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_HL[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_HL[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_HL[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_HL utility
    Utility_SLCC_HL[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_HL = SumUtility_SLCC_HL + Utility_SLCC_HL[i]
    
    
    
    ;SLCC_Airp ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_Airp[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_Airp[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_Airp[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_Airp[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_Airp utility
    Utility_SLCC_Airp[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_Airp = SumUtility_SLCC_Airp + Utility_SLCC_Airp[i]
    
    
    
    ;SLCC_West ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_West[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_West[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_West[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_West[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_West utility
    Utility_SLCC_West[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_West = SumUtility_SLCC_West + Utility_SLCC_West[i]
    
    
    
    ;SLCC_HM ------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_SLCC_HM[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 - 0.0000028525
    
    elseif (Distance_SLCC_HM[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000013999
    
    elseif (Distance_SLCC_HM[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000008156
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_SLCC_HM[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate SLCC_HM utility
    Utility_SLCC_HM[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_SLCC_HM = SumUtility_SLCC_HM + Utility_SLCC_HM[i]
    
    
    
    ;BYU ----------------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_BYU[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563 + 0.0000027150
    
    elseif (Distance_BYU[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677 - 0.0000009308
    
    elseif (Distance_BYU[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400 - 0.0000014001
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_BYU[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate BYU utility
    Utility_BYU[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_BYU = SumUtility_BYU + Utility_BYU[i]
    
    
    
    ;UVU_Main -----------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UVU_Main[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_UVU_Main[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_UVU_Main[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UVU_Main[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UVU_Main utility
    Utility_UVU_Main[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UVU_Main = SumUtility_UVU_Main + Utility_UVU_Main[i]
    
    
    
    ;UVU_Geneva ---------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UVU_Geneva[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_UVU_Geneva[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_UVU_Geneva[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UVU_Geneva[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UVU_Geneva utility
    Utility_UVU_Geneva[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UVU_Geneva = SumUtility_UVU_Geneva + Utility_UVU_Geneva[i]
    
    
    
    ;UVU_Lehi ---------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UVU_Lehi[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_UVU_Lehi[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_UVU_Lehi[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UVU_Lehi[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UVU_Lehi utility
    Utility_UVU_Lehi[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UVU_Lehi   = SumUtility_UVU_Lehi + Utility_UVU_Lehi[i]
    
    
    
    ;UVU_Vine ---------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UVU_Vine[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_UVU_Vine[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_UVU_Vine[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UVU_Vine[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UVU_Vine utility
    Utility_UVU_Vine[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UVU_Vine = SumUtility_UVU_Vine + Utility_UVU_Vine[i]
    
    
    
    ;UVU_Payson ---------------------------------------------------------
    ;set ColPopCoef for college trip calculation
    if (Distance_UVU_Payson[i]<@Dist_Short@)
        DistanceCoef_ = 0.0000000205 + 0.0000047563
    
    elseif (Distance_UVU_Payson[i]<@Dist_Medium@)
        DistanceCoef_ = 0.0000000205 + 0.0000028677
    
    elseif (Distance_UVU_Payson[i]<@Dist_Long@)
        DistanceCoef_ = 0.0000000205 + 0.0000015400
    
    else
        DistanceCoef_ = 0.0000000205
    
    endif
    
    
    ;set TransitCoef_ for college trip calculation (if transit service with 0 xfers)
    if (NoXfer_UVU_Payson[i]=1)
        TransitCoef_ = 0.0000001251
    else
        TransitCoef_ = 0
    endif
    
    
    ;set DensityCoef_ for college trip calculation 
    if (HHDensity>@HHDen@)
        DensityCoef_ = 0.0000000068
    else
        DensityCoef_ = 0
    endif
    
    
    ;calculate UVU_Payson utility
    Utility_UVU_Payson[i] = zi.2.HHPOP[i] * (DistanceCoef_ + TransitCoef_  + DensityCoef_)
    
    SumUtility_UVU_Payson = SumUtility_UVU_Payson + Utility_UVU_Payson[i]
    
    
    
    
    ;Calculate unadjusted totals =========================================================
    if (i=ZONES)
    
        ;calculate amount of airport trips & college HC's to allocate
        LOOP ZLoop=1, ZONES
            
            ;Airport -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_Airport=0)
                Allocation_Airport = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_Airport = (ContTot_Airport - Base_Airport) * Utility_Airport[ZLoop] / SumUtility_Airport
            endif
            
            ;do not allow trips to go negative
            if (zi.1.AIRPORT[ZLoop]+Allocation_Airport<0)
                Trips_Airport[ZLoop] = 0
            else
                Trips_Airport[ZLoop] = ROUND(zi.1.Airport[ZLoop] + Allocation_Airport)
            endif
            
            ;sum total trips
            SumTrips_Airport = SumTrips_Airport + Trips_Airport[ZLoop]
            
            ;PVU Airport -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_PVU=0)
                Allocation_PVU = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_PVU = (ContTot_PVU - Base_PVU) * Utility_PVU[ZLoop] / SumUtility_PVU
            endif
            
            ;do not allow trips to go negative
            if (zi.1.PVU[ZLoop]+Allocation_PVU<0)
                Trips_PVU[ZLoop] = 0
            else
                Trips_PVU[ZLoop] = ROUND(zi.1.PVU[ZLoop] + Allocation_PVU)
            endif
            
            ;sum total trips
            SumTrips_PVU = SumTrips_PVU + Trips_PVU[ZLoop]
            
            ;Lagoon --------------------------------------------------------
            ;There is no base year data for Lagoon; final adjusting occurs in next step
            
            
    
            ;Ensign---------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_Ensign=0)
                Allocation_Ensign= 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_Ensign= (ContTot_Ensign- Base_Ensign) * Utility_Ensign[ZLoop] / SumUtility_Ensign
            endif
            
            ;do not allow trips to go negative
            if (zi.1.Ensign[ZLoop]+Allocation_Ensign<0)
                HC_Ensign[ZLoop] = 0
            else
                HC_Ensign[ZLoop] = ROUND(zi.1.Ensign[ZLoop] + Allocation_Ensign)
            endif
            
            ;sum total trips
            SumHC_Ensign= SumHC_Ensign+ HC_Ensign[ZLoop]
            
            
            
            ;Westmin -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_Westmin=0)
                Allocation_Westmin = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_Westmin = (ContTot_Westmin - Base_Westmin) * Utility_Westmin[ZLoop] / SumUtility_Westmin
            endif
            
            ;do not allow trips to go negative
            if (zi.1.Westmin[ZLoop]+Allocation_Westmin<0)
                HC_Westmin[ZLoop] = 0
            else
                HC_Westmin[ZLoop] = ROUND(zi.1.Westmin[ZLoop] + Allocation_Westmin)
            endif
            
            ;sum total trips
            SumHC_Westmin = SumHC_Westmin + HC_Westmin[ZLoop]
            
            
            
            ;UofU_Main ----------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UofU_Main=0)
                Allocation_UofU_Main = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UofU_Main = (ContTot_UofU_Main - Base_UofU_Main) * Utility_UofU_Main[ZLoop] / SumUtility_UofU_Main
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UofU_Main[ZLoop]+Allocation_UofU_Main<0)
                HC_UofU_Main[ZLoop] = 0
            else
                HC_UofU_Main[ZLoop] = ROUND(zi.1.UofU_Main[ZLoop] + Allocation_UofU_Main)
            endif
            
            ;sum total trips
            SumHC_UofU_Main = SumHC_UofU_Main + HC_UofU_Main[ZLoop]
            
            
            
            ;UofU_Med ----------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UofU_Med=0)
                Allocation_UofU_Med = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UofU_Med = (ContTot_UofU_Med - Base_UofU_Med) * Utility_UofU_Med[ZLoop] / SumUtility_UofU_Med
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UofU_Med[ZLoop]+Allocation_UofU_Med<0)
                HC_UofU_Med[ZLoop] = 0
            else
                HC_UofU_Med[ZLoop] = ROUND(zi.1.UofU_Med[ZLoop] + Allocation_UofU_Med)
            endif
            
            ;sum total trips
            SumHC_UofU_Med = SumHC_UofU_Med + HC_UofU_Med[ZLoop]
            
            
            
            ;WSU_Main  ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_WSU_Main=0)
                Allocation_WSU_Main = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_WSU_Main = (ContTot_WSU_Main  - Base_WSU_Main) * Utility_WSU_Main[ZLoop] / SumUtility_WSU_Main 
            endif
            
            ;do not allow trips to go negative
            if (zi.1.WSU_Main[ZLoop]+Allocation_WSU_Main<0)
                HC_WSU_Main[ZLoop] = 0
            else
                HC_WSU_Main[ZLoop] = ROUND(zi.1.WSU_Main[ZLoop] + Allocation_WSU_Main)
            endif
            
            ;sum total trips
            SumHC_WSU_Main = SumHC_WSU_Main + HC_WSU_Main[ZLoop]
            
            
            
            ;WSU_Davis ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_WSU_Davis=0)
                Allocation_WSU_Davis = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_WSU_Davis = (ContTot_WSU_Davis - Base_WSU_Davis) * Utility_WSU_Davis[ZLoop] / SumUtility_WSU_Davis
            endif
            
            ;do not allow trips to go negative
            if (zi.1.WSU_Davis[ZLoop]+Allocation_WSU_Davis<0)
                HC_WSU_Davis[ZLoop] = 0
            else
                HC_WSU_Davis[ZLoop] = ROUND(zi.1.WSU_Davis[ZLoop] + Allocation_WSU_Davis)
            endif
            
            ;sum total trips
            SumHC_WSU_Davis = SumHC_WSU_Davis + HC_WSU_Davis[ZLoop]
            
            
            
            ;WSU_West ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_WSU_West=0)
                Allocation_WSU_West = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_WSU_West = (ContTot_WSU_West - Base_WSU_West) * Utility_WSU_West[ZLoop] / SumUtility_WSU_West
            endif
            
            ;do not allow trips to go negative
            if (zi.1.WSU_West[ZLoop]+Allocation_WSU_West<0)
                HC_WSU_West[ZLoop] = 0
            else
                HC_WSU_West[ZLoop] = ROUND(zi.1.WSU_West[ZLoop] + Allocation_WSU_West)
            endif
            
            ;sum total trips
            SumHC_WSU_West = SumHC_WSU_West + HC_WSU_West[ZLoop]
            
            
            
            ;SLCC_Main ---------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_Main=0)
                Allocation_SLCC_Main = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_Main = (ContTot_SLCC_Main - Base_SLCC_Main) * Utility_SLCC_Main[ZLoop] / SumUtility_SLCC_Main
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_Main[ZLoop]+Allocation_SLCC_Main<0)
                HC_SLCC_Main[ZLoop] = 0
            else
                HC_SLCC_Main[ZLoop] = ROUND(zi.1.SLCC_Main[ZLoop] + Allocation_SLCC_Main)
            endif
            
            ;sum total trips
            SumHC_SLCC_Main = SumHC_SLCC_Main + HC_SLCC_Main[ZLoop]
            
            
            
            ;SLCC_SC -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_SC=0)
                Allocation_SLCC_SC = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_SC = (ContTot_SLCC_SC - Base_SLCC_SC) * Utility_SLCC_SC[ZLoop] / SumUtility_SLCC_SC
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_SC[ZLoop]+Allocation_SLCC_SC<0)
                HC_SLCC_SC[ZLoop] = 0
            else
                HC_SLCC_SC[ZLoop] = ROUND(zi.1.SLCC_SC[ZLoop] + Allocation_SLCC_SC)
            endif
            
            ;sum total trips
            SumHC_SLCC_SC = SumHC_SLCC_SC + HC_SLCC_SC[ZLoop]
            
            
            
            ;SLCC_JD -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_JD=0)
                Allocation_SLCC_JD = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_JD = (ContTot_SLCC_JD - Base_SLCC_JD) * Utility_SLCC_JD[ZLoop] / SumUtility_SLCC_JD
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_JD[ZLoop]+Allocation_SLCC_JD<0)
                HC_SLCC_JD[ZLoop] = 0
            else
                HC_SLCC_JD[ZLoop] = ROUND(zi.1.SLCC_JD[ZLoop] + Allocation_SLCC_JD)
            endif
            
            ;sum total trips
            SumHC_SLCC_JD = SumHC_SLCC_JD + HC_SLCC_JD[ZLoop]
            
            
            
            ;SLCC_Mead -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_Mead=0)
                Allocation_SLCC_Mead = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_Mead = (ContTot_SLCC_Mead - Base_SLCC_Mead) * Utility_SLCC_Mead[ZLoop] / SumUtility_SLCC_Mead
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_Mead[ZLoop]+Allocation_SLCC_Mead<0)
                HC_SLCC_Mead[ZLoop] = 0
            else
                HC_SLCC_Mead[ZLoop] = ROUND(zi.1.SLCC_Mead[ZLoop] + Allocation_SLCC_Mead)
            endif
            
            ;sum total trips
            SumHC_SLCC_Mead = SumHC_SLCC_Mead + HC_SLCC_Mead[ZLoop]
            
            
            
            ;SLCC_ML -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_ML=0)
                Allocation_SLCC_ML = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_ML = (ContTot_SLCC_ML - Base_SLCC_ML) * Utility_SLCC_ML[ZLoop] / SumUtility_SLCC_ML
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_ML[ZLoop]+Allocation_SLCC_ML<0)
                HC_SLCC_ML[ZLoop] = 0
            else
                HC_SLCC_ML[ZLoop] = ROUND(zi.1.SLCC_ML[ZLoop] + Allocation_SLCC_ML)
            endif
            
            ;sum total trips
            SumHC_SLCC_ML = SumHC_SLCC_ML + HC_SLCC_ML[ZLoop]
            
            
            ;SLCC_LB -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_LB=0)
                Allocation_SLCC_LB = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_LB = (ContTot_SLCC_LB - Base_SLCC_LB) * Utility_SLCC_LB[ZLoop] / SumUtility_SLCC_LB
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_LB[ZLoop]+Allocation_SLCC_LB<0)
                HC_SLCC_LB[ZLoop] = 0
            else
                HC_SLCC_LB[ZLoop] = ROUND(zi.1.SLCC_LB[ZLoop] + Allocation_SLCC_LB)
            endif
            
            ;sum total trips
            SumHC_SLCC_LB = SumHC_SLCC_LB + HC_SLCC_LB[ZLoop]
            
            
            
            ;SLCC_HL -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_HL=0)
                Allocation_SLCC_HL = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_HL = (ContTot_SLCC_HL - Base_SLCC_HL) * Utility_SLCC_HL[ZLoop] / SumUtility_SLCC_HL
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_HL[ZLoop]+Allocation_SLCC_HL<0)
                HC_SLCC_HL[ZLoop] = 0
            else
                HC_SLCC_HL[ZLoop] = ROUND(zi.1.SLCC_HL[ZLoop] + Allocation_SLCC_HL)
            endif
            
            ;sum total trips
            SumHC_SLCC_HL = SumHC_SLCC_HL + HC_SLCC_HL[ZLoop]
            
            
            
            ;SLCC_Airp -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_Airp=0)
                Allocation_SLCC_Airp = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_Airp = (ContTot_SLCC_Airp - Base_SLCC_Airp) * Utility_SLCC_Airp[ZLoop] / SumUtility_SLCC_Airp
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_Airp[ZLoop]+Allocation_SLCC_Airp<0)
                HC_SLCC_Airp[ZLoop] = 0
            else
                HC_SLCC_Airp[ZLoop] = ROUND(zi.1.SLCC_Airp[ZLoop] + Allocation_SLCC_Airp)
            endif
            
            ;sum total trips
            SumHC_SLCC_Airp = SumHC_SLCC_Airp + HC_SLCC_Airp[ZLoop]
            
            
            
            ;SLCC_West -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_West=0)
                Allocation_SLCC_West = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_West = (ContTot_SLCC_West - Base_SLCC_West) * Utility_SLCC_West[ZLoop] / SumUtility_SLCC_West
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_West[ZLoop]+Allocation_SLCC_West<0)
                HC_SLCC_West[ZLoop] = 0
            else
                HC_SLCC_West[ZLoop] = ROUND(zi.1.SLCC_West[ZLoop] + Allocation_SLCC_West)
            endif
            
            ;sum total trips
            SumHC_SLCC_West = SumHC_SLCC_West + HC_SLCC_West[ZLoop]
            
            
            
            ;SLCC_HM -------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_SLCC_HM=0)
                Allocation_SLCC_HM = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_SLCC_HM = (ContTot_SLCC_HM - Base_SLCC_HM) * Utility_SLCC_HM[ZLoop] / SumUtility_SLCC_HM
            endif
            
            ;do not allow trips to go negative
            if (zi.1.SLCC_HM[ZLoop]+Allocation_SLCC_HM<0)
                HC_SLCC_HM[ZLoop] = 0
            else
                HC_SLCC_HM[ZLoop] = ROUND(zi.1.SLCC_HM[ZLoop] + Allocation_SLCC_HM)
            endif
            
            ;sum total trips
            SumHC_SLCC_HM = SumHC_SLCC_HM + HC_SLCC_HM[ZLoop]
            
            
            
            ;BYU ------------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_BYU=0)
                Allocation_BYU = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_BYU = (ContTot_BYU - Base_BYU) * Utility_BYU[ZLoop] / SumUtility_BYU
            endif
            
            ;do not allow trips to go negative
            if (zi.1.BYU[ZLoop]+Allocation_BYU<0)
                HC_BYU[ZLoop] = 0
            else
                HC_BYU[ZLoop] = ROUND(zi.1.BYU[ZLoop] + Allocation_BYU)
            endif
            
            ;sum total trips
            SumHC_BYU = SumHC_BYU + HC_BYU[ZLoop]
            
            
            
            ;UVU_Main ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UVU_Main=0)
                Allocation_UVU_Main = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UVU_Main = (ContTot_UVU_Main - Base_UVU_Main) * Utility_UVU_Main[ZLoop] / SumUtility_UVU_Main
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UVU_Main[ZLoop]+Allocation_UVU_Main<0)
                HC_UVU_Main[ZLoop] = 0
            else
                HC_UVU_Main[ZLoop] = ROUND(zi.1.UVU_Main[ZLoop] + Allocation_UVU_Main)
            endif
            
            ;sum total trips
            SumHC_UVU_Main = SumHC_UVU_Main + HC_UVU_Main[ZLoop]
            
    
            ;UVU_Geneva ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UVU_Geneva=0)
                Allocation_UVU_Geneva = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UVU_Geneva = (ContTot_UVU_Geneva - Base_UVU_Geneva) * Utility_UVU_Geneva[ZLoop] / SumUtility_UVU_Geneva
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UVU_Geneva[ZLoop]+Allocation_UVU_Geneva<0)
                HC_UVU_Geneva[ZLoop] = 0
            else
                HC_UVU_Geneva[ZLoop] = ROUND(zi.1.UVU_Geneva[ZLoop] + Allocation_UVU_Geneva)
            endif
            
            ;sum total trips
            SumHC_UVU_Geneva = SumHC_UVU_Geneva + HC_UVU_Geneva[ZLoop]
            
            
            
            ;UVU_Lehi ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UVU_Lehi=0)
                Allocation_UVU_Lehi   = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UVU_Lehi   = (ContTot_UVU_Lehi - Base_UVU_Lehi) * Utility_UVU_Lehi[ZLoop] / SumUtility_UVU_Lehi
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UVU_Lehi[ZLoop]+Allocation_UVU_Lehi<0)
                HC_UVU_Lehi[ZLoop] = 0
            else
                HC_UVU_Lehi[ZLoop] = ROUND(zi.1.UVU_Lehi[ZLoop] + Allocation_UVU_Lehi)
            endif
            
            ;sum total trips
            SumHC_UVU_Lehi   = SumHC_UVU_Lehi + HC_UVU_Lehi[ZLoop]  
            
            
            
            ;UVU_Vine ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UVU_Vine=0)
                Allocation_UVU_Vine = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UVU_Vine = (ContTot_UVU_Vine - Base_UVU_Vine) * Utility_UVU_Vine[ZLoop] / SumUtility_UVU_Vine
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UVU_Vine[ZLoop]+Allocation_UVU_Vine<0)
                HC_UVU_Vine[ZLoop] = 0
            else
                HC_UVU_Vine[ZLoop] = ROUND(zi.1.UVU_Vine[ZLoop] + Allocation_UVU_Vine)
            endif
            
            ;sum total trips
            SumHC_UVU_Vine = SumHC_UVU_Vine + HC_UVU_Vine[ZLoop]
            
            
            
            ;UVU_Payson ------------------------------------------------------
            ;check SumUtility to prevent divide by 0 error
            if (SumUtility_UVU_Payson=0)
                Allocation_UVU_Payson = 0
            else
                ;calculate zonal allocation to add to or subtract from the base year
                Allocation_UVU_Payson = (ContTot_UVU_Payson - Base_UVU_Payson) * Utility_UVU_Payson[ZLoop] / SumUtility_UVU_Payson
            endif
            
            ;do not allow trips to go negative
            if (zi.1.UVU_Payson[ZLoop]+Allocation_UVU_Payson<0)
                HC_UVU_Payson[ZLoop] = 0
            else
                HC_UVU_Payson[ZLoop] = ROUND(zi.1.UVU_Payson[ZLoop] + Allocation_UVU_Payson)
            endif
            
            ;sum total trips
            SumHC_UVU_Payson = SumHC_UVU_Payson + HC_UVU_Payson[ZLoop]
            
        ENDLOOP
        
        
        
        
        ;Calculate final controlled totals and write out temp file =======================
        LOOP ZLoop=1, ZONES
            
            ;calculate final trips
            if (SumTrips_Airport=0)
                Final_Airport = 0
            else
                Final_Airport = Trips_Airport[ZLoop] * ContTot_Airport / SumTrips_Airport
            endif    

            if (SumTrips_PVU=0)
                Final_PVU = 0
            else
                Final_PVU = Trips_PVU[ZLoop] * ContTot_PVU / SumTrips_PVU
            endif             
           
            if (SumUtility_Lagoon=0)
                Final_Lagoon = 0
            else
                Final_Lagoon = Utility_Lagoon[ZLoop] * ContTot_Lagoon / SumUtility_Lagoon
            endif
            
            
            if (SumHC_Ensign=0)
                Final_Ensign= 0
            else
                Final_Ensign= HC_Ensign[ZLoop] * ContTot_Ensign/ SumHC_Ensign
            endif
            
            
            if (SumHC_Westmin=0)
                Final_Westmin = 0
            else
                Final_Westmin = HC_Westmin[ZLoop] * ContTot_Westmin / SumHC_Westmin
            endif
            
            
            if (SumHC_UofU_Main=0)
                Final_UofU_Main = 0
            else
                Final_UofU_Main = HC_UofU_Main[ZLoop] * ContTot_UofU_Main / SumHC_UofU_Main
            endif
            
            
            if (SumHC_UofU_Med=0)
                Final_UofU_Med = 0
            else
                Final_UofU_Med = HC_UofU_Med[ZLoop] * ContTot_UofU_Med / SumHC_UofU_Med
            endif
            
            
            if (SumHC_WSU_Main =0)
                Final_WSU_Main = 0
            else
                Final_WSU_Main = HC_WSU_Main[ZLoop] * ContTot_WSU_Main / SumHC_WSU_Main 
            endif
            
            
            if (SumHC_WSU_Davis=0)
                Final_WSU_Davis = 0
            else
                Final_WSU_Davis = HC_WSU_Davis[ZLoop] * ContTot_WSU_Davis / SumHC_WSU_Davis
            endif
            
            
            if (SumHC_WSU_West=0)
                Final_WSU_West = 0
            else
                Final_WSU_West = HC_WSU_West[ZLoop] * ContTot_WSU_West / SumHC_WSU_West
            endif
            
            
            if (SumHC_SLCC_Main=0)
                Final_SLCC_Main = 0
            else
                Final_SLCC_Main = HC_SLCC_Main[ZLoop] * ContTot_SLCC_Main / SumHC_SLCC_Main
            endif
            
            
            if (SumHC_SLCC_SC=0)
                Final_SLCC_SC = 0
            else
                Final_SLCC_SC = HC_SLCC_SC[ZLoop] * ContTot_SLCC_SC / SumHC_SLCC_SC
            endif
            
            
            if (SumHC_SLCC_JD=0)
                Final_SLCC_JD = 0
            else
                Final_SLCC_JD = HC_SLCC_JD[ZLoop] * ContTot_SLCC_JD / SumHC_SLCC_JD
            endif
            
            
            if (SumHC_SLCC_Mead=0)
                Final_SLCC_Mead = 0
            else
                Final_SLCC_Mead = HC_SLCC_Mead[ZLoop] * ContTot_SLCC_Mead / SumHC_SLCC_Mead
            endif
            
            
            if (SumHC_SLCC_ML=0)
                Final_SLCC_ML = 0
            else
                Final_SLCC_ML = HC_SLCC_ML[ZLoop] * ContTot_SLCC_ML / SumHC_SLCC_ML
            endif
            
            
            if (SumHC_SLCC_LB=0)
                Final_SLCC_LB = 0
            else
                Final_SLCC_LB = HC_SLCC_LB[ZLoop] * ContTot_SLCC_LB / SumHC_SLCC_LB
            endif
            
            
            if (SumHC_SLCC_HL=0)
                Final_SLCC_HL = 0
            else
                Final_SLCC_HL = HC_SLCC_HL[ZLoop] * ContTot_SLCC_HL / SumHC_SLCC_HL
            endif
            
            
            if (SumHC_SLCC_Airp=0)
                Final_SLCC_Airp = 0
            else
                Final_SLCC_Airp = HC_SLCC_Airp[ZLoop] * ContTot_SLCC_Airp / SumHC_SLCC_Airp
            endif
            
            
            if (SumHC_SLCC_West=0)
                Final_SLCC_West = 0
            else
                Final_SLCC_West = HC_SLCC_West[ZLoop] * ContTot_SLCC_West / SumHC_SLCC_West
            endif
            
            
            if (SumHC_SLCC_HM=0)
                Final_SLCC_HM = 0
            else
                Final_SLCC_HM = HC_SLCC_HM[ZLoop] * ContTot_SLCC_HM / SumHC_SLCC_HM
            endif
            
            
            if (SumHC_BYU=0)
                Final_BYU = 0
            else
                Final_BYU = HC_BYU[ZLoop] * ContTot_BYU / SumHC_BYU
            endif
            
            
            if (SumHC_UVU_Main=0)
                Final_UVU_Main = 0
            else
                Final_UVU_Main = HC_UVU_Main[ZLoop] * ContTot_UVU_Main / SumHC_UVU_Main
            endif
            
            
            if (SumHC_UVU_Geneva=0)
                Final_UVU_Geneva = 0
            else
                Final_UVU_Geneva = HC_UVU_Geneva[ZLoop] * ContTot_UVU_Geneva / SumHC_UVU_Geneva
            endif
            
            
            if (SumHC_UVU_Lehi=0)
                Final_UVU_Lehi = 0
            else
                Final_UVU_Lehi = HC_UVU_Lehi[ZLoop] * ContTot_UVU_Lehi / SumHC_UVU_Lehi
            endif
            
            
            if (SumHC_UVU_Vine=0)
                Final_UVU_Vine = 0
            else
                Final_UVU_Vine = HC_UVU_Vine[ZLoop] * ContTot_UVU_Vine / SumHC_UVU_Vine
            endif
            
            
            if (SumHC_UVU_Payson=0)
                Final_UVU_Payson = 0
            else
                Final_UVU_Payson = HC_UVU_Payson[ZLoop] * ContTot_UVU_Payson / SumHC_UVU_Payson
            endif
            

            
            
            ;print out airport & Lagoon trips & college headcount allocstions to .csv file
            if (ZLoop=1)
                PRINT CSV=T, 
                    FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_Tmp_TripTable_college.csv', 
                    FORM=11.0,
                    LIST=';Z'        ,
                         'Airport'   ,
                         'PVU'       ,
                         'Lagoon'    ,
                         'Ensign'    ,
                         'Westmin'   ,
                         'UofU_Main' ,
                         'UofU_Med'  ,
                         'WSU_Main'  ,
                         'WSU_Davis' ,
                         'WSU_West'  ,
                         'SLCC_Main' ,
                         'SLCC_SC'   ,
                         'SLCC_JD'   ,
                         'SLCC_Mead' ,
                         'SLCC_ML'   ,
                         'SLCC_LB'   ,
                         'SLCC_HL'   ,
                         'SLCC_Airp' ,
                         'SLCC_West' ,
                         'SLCC_HM'   ,
                         'BYU'       ,
                         'UVU_Main'  ,
                         'UVU_Geneva',
                         'UVU_Lehi'  ,
                         'UVU_Vine'  ,
                         'UVU_Payson'
            endif
            
            PRINT CSV=T, 
                FILE='@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_Tmp_TripTable_college.csv', 
                FORM=11.2,
                LIST=ZLoop(11.0)     ,
                     Final_Airport   ,
                     Final_PVU       ,
                     Final_Lagoon    ,
                     Final_Ensign    ,
                     Final_Westmin   ,
                     Final_UofU_Main ,
                     Final_UofU_Med  ,
                     Final_WSU_Main  ,
                     Final_WSU_Davis ,
                     Final_WSU_West  ,
                     Final_SLCC_Main ,
                     Final_SLCC_SC   ,
                     Final_SLCC_JD   ,
                     Final_SLCC_Mead ,
                     Final_SLCC_ML   ,
                     Final_SLCC_LB   ,
                     Final_SLCC_HL   ,
                     Final_SLCC_Airp ,
                     Final_SLCC_West ,
                     Final_SLCC_HM   ,
                     Final_BYU       ,
                     Final_UVU_Main  ,
                     Final_UVU_Geneva,
                     Final_UVU_Lehi  ,
                     Final_UVU_Vine  ,
                     Final_UVU_Payson
            
        ENDLOOP  ;ZLoop=1, ZONES
        
    endif  ;i=ZONES
    
ENDRUN




;convert college student to college trips, write out trip table matrix
RUN PGM=MATRIX  MSG='Trip Table: Create temp TTUNIQUE and HBC Trip Tables'
FILEI ZDATI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\0d_Tmp_TripTable_college.csv', 
    Z          =#01, 
    Airport    = 02,
    PVU        = 03,
    Lagoon     = 04,
    Ensign     = 05,
    Westmin    = 06,
    UofU_Main  = 07,
    UofU_Med   = 08,
    WSU_Main   = 09,
    WSU_Davis  = 10,
    WSU_West   = 11,
    SLCC_Main  = 12,
    SLCC_SC    = 13,
    SLCC_JD    = 14,
    SLCC_Mead  = 15,
    SLCC_ML    = 16,
    SLCC_LB    = 17,
    SLCC_HL    = 18,
    SLCC_Airp  = 19,
    SLCC_West  = 20,
    SLCC_HM    = 21,
    BYU        = 22,
    UVU_Main   = 23,
    UVU_Geneva = 24,
    UVU_Lehi   = 25,
    UVU_Vine   = 26,
    UVU_Payson = 27
      
FILEO MATO[1]  = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\AddTripTable_inverted.mtx', 
    mo=1-2, 
    name=TTUNIQUE,
         HBC 

    ;set MATRIX parameters
    ZONES   = @Usedzones@
    ;ZONEMSG = @ZoneMsgRate@
    
    
    ;Lookup trip rates
    ;note: index 1 = Pct_Remove
    ;      index 2 = FTERate   
    ;      index 3 = HBCRates  
    LOOKUP FILE='@ParentDir@1_Inputs\0_GlobalData\0_TripTables\College_Factors.csv',
        LIST=F,
        INTERPOLATE=F,
        NAME=HBC_TripRate,
        Lookup[01]=01,  RESULT=02,    ;Ensign     
        Lookup[02]=01,  RESULT=03,    ;Westmin    
        Lookup[03]=01,  RESULT=04,    ;UofU_Main  
        Lookup[04]=01,  RESULT=05,    ;UofU_Med   
        Lookup[05]=01,  RESULT=06,    ;WSU_Main   
        Lookup[06]=01,  RESULT=07,    ;WSU_Davis  
        Lookup[07]=01,  RESULT=08,    ;WSU_West   
        Lookup[08]=01,  RESULT=09,    ;SLCC_Main  
        Lookup[09]=01,  RESULT=10,    ;SLCC_SC   
        Lookup[10]=01,  RESULT=11,    ;SLCC_JD   
        Lookup[11]=01,  RESULT=12,    ;SLCC_Mead 
        Lookup[12]=01,  RESULT=13,    ;SLCC_ML   
        Lookup[13]=01,  RESULT=14,    ;SLCC_LB   
        Lookup[14]=01,  RESULT=15,    ;SLCC_HL   
        Lookup[15]=01,  RESULT=16,    ;SLCC_Airp 
        Lookup[16]=01,  RESULT=17,    ;SLCC_West 
        Lookup[17]=01,  RESULT=18,    ;SLCC_HM   
        Lookup[18]=01,  RESULT=19,    ;BYU       
        Lookup[19]=01,  RESULT=20,    ;UVU_Main  
        Lookup[20]=01,  RESULT=21,    ;UVU_Geneva
        Lookup[21]=01,  RESULT=22,    ;UVU_Lehi
        Lookup[22]=01,  RESULT=23,    ;UVU_Vine  
        Lookup[23]=01,  RESULT=24     ;UVU_Payson
    
    
    ;convert college student to college trips
    JLOOP
        if (i=@Airport@   )  mw[1] = zi.1.AIRPORT[j]
        if (i=@PVU@       )  mw[1] = zi.1.PVU[j]
        if (i=@Lagoon@    )  mw[1] = zi.1.LAGOON[j]

        if (i=@Ensign@    )  mw[2] = zi.1.Ensign[j]     * HBC_TripRate(01, 3)
        if (i=@Westmin@   )  mw[2] = zi.1.Westmin[j]    * HBC_TripRate(02, 3)
        if (i=@UOFU_Main@ )  mw[2] = zi.1.UofU_Main[j]  * HBC_TripRate(03, 3)
        if (i=@UOFU_Med@  )  mw[2] = zi.1.UofU_Med[j]   * HBC_TripRate(04, 3)
        if (i=@WSU_Main@  )  mw[2] = zi.1.WSU_Main[j]   * HBC_TripRate(05, 3)
        if (i=@WSU_Davis@ )  mw[2] = zi.1.WSU_Davis[j]  * HBC_TripRate(06, 3)
        if (i=@WSU_West@  )  mw[2] = zi.1.WSU_West[j]   * HBC_TripRate(07, 3)
        if (i=@SLCC_Main@ )  mw[2] = zi.1.SLCC_Main[j]  * HBC_TripRate(08, 3)
        if (i=@SLCC_SC@   )  mw[2] = zi.1.SLCC_SC[j]    * HBC_TripRate(09, 3)
        if (i=@SLCC_JD@   )  mw[2] = zi.1.SLCC_JD[j]    * HBC_TripRate(10, 3)
        if (i=@SLCC_Mead@ )  mw[2] = zi.1.SLCC_Mead[j]  * HBC_TripRate(11, 3)
        if (i=@SLCC_ML@   )  mw[2] = zi.1.SLCC_ML[j]    * HBC_TripRate(12, 3)
        if (i=@SLCC_LB@   )  mw[2] = zi.1.SLCC_LB[j]    * HBC_TripRate(13, 3)
        if (i=@SLCC_HL@   )  mw[2] = zi.1.SLCC_HL[j]    * HBC_TripRate(14, 3)
        if (i=@SLCC_Airp@ )  mw[2] = zi.1.SLCC_Airp[j]  * HBC_TripRate(15, 3)
        if (i=@SLCC_West@ )  mw[2] = zi.1.SLCC_West[j]  * HBC_TripRate(16, 3)
        if (i=@SLCC_HM@   )  mw[2] = zi.1.SLCC_HM[j]    * HBC_TripRate(17, 3)
        if (i=@BYU@       )  mw[2] = zi.1.BYU[j]        * HBC_TripRate(18, 3)
        if (i=@UVU_Main@  )  mw[2] = zi.1.UVU_Main[j]   * HBC_TripRate(19, 3)
        if (i=@UVU_Geneva@)  mw[2] = zi.1.UVU_Geneva[j] * HBC_TripRate(20, 3)
        if (i=@UVU_Lehi@  )  mw[2] = zi.1.UVU_Lehi[j]   * HBC_TripRate(21, 3)
        if (i=@UVU_Vine@  )  mw[2] = zi.1.UVU_Vine[j]   * HBC_TripRate(22, 3)
        if (i=@UVU_Payson@)  mw[2] = zi.1.UVU_Payson[j] * HBC_TripRate(23, 3)
    ENDJLOOP
    
    
    ;bucket rounding
    mw[01] = mw[01], Total=ROWFIX(01, i, 0.5)
    mw[02] = mw[02], Total=ROWFIX(02, i, 0.5)
    
ENDRUN


;convert college student to college trips, write out trip table matrix
RUN PGM=MATRIX  MSG='Trip Table: Create Final TTUNIQUE and HBC Trip Tables'
FILEI MATI[1] = '@ParentDir@@ScenarioDir@Temp\0_InputProcessing\AddTripTable_inverted.mtx'
      
FILEO MATO[1]  = '@ParentDir@@ScenarioDir@0_InputProcessing\AddTripTable.mtx', 
    mo=1-2, 
    name=TTUNIQUE,
         HBC 

    ;set MATRIX parameters
    ZONES = @Usedzones@
    ZONEMSG = @ZoneMsgRate@
    
    
    mw[1] = mi.1.TTUNIQUE.T
    mw[2] = mi.1.HBC.T
    
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n',
             '\n    Create College & Airport TT        ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




;System cleanup
    *(DEL 1_TripTable.txt)
    