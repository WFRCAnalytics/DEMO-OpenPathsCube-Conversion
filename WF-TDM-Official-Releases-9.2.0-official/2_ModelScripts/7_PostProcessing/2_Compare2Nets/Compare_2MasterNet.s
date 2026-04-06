
;set up parameters
net_1 = 'input/WFv901_MasterNet_20240318.net'    ;higher capacity network
net_2 = 'input/MasterNet_v9 - 2023-09-16.net'    ;lower capacity netowrk

CompareNetwork = 'masterv901_masterv900.net'

;difference (net 1 - net 2)
RUN PGM=NETWORK
FILEI NETI[1] = '@net_1@'
FILEI NETI[2] = '@net_2@'
  
FILEO NETO    = 'Output_Master\@CompareNetwork@',
    INCLUDE=A         ,
            B         ,
            chk_dist  ,
            DIST_1    ,
            DIST_2    ,
            STREET_1(C),
            STREET_2(C),
            ONEWAY_1  ,
            ONEWAY_2  ,
            TAZID_1   ,
            TAZID_2   ,
            LINKID_1(C),
            LINKID_2(C),
            SEGID_1(C),
            SEGID_2(C),
            HOTZN_1   ,
            HOTZN_2   ,
            TRKRST15_1,
            TRKRST15_2,
            TRKRST23_1,
            TRKRST23_2,
            DISTEXC_1 ,
            DISTEXC_2 ,
            SFAC_BAS_1,
            SFAC_BAS_2,
            SFAC_FUT_1,
            SFAC_FUT_2,
            CFAC_BAS_1,
            CFAC_BAS_2,
            CFAC_FUT_1,
            CFAC_FUT_2,
            
            LN_2015_1 ,
            LN_2015_2 ,
            LN_2015_D ,
            LN_2019_1 ,
            LN_2019_2 ,
            LN_2019_D ,
            LN_2021_1 ,
            LN_2021_2 ,
            LN_2021_D ,
            LN_2023_1 ,
            LN_2023_2 ,
            LN_2023_D ,
            LN23_32_1 ,
            LN23_32_2 ,
            LN23_32_D ,
            LN23_42_1 ,
            LN23_42_2 ,
            LN23_42_D ,
            LN23_50_1 ,
            LN23_50_2 ,
            LN23_50_D ,
            LN23_32U_1,
            LN23_32U_2,
            LN23_32U_D,
            LN23_42U_1,
            LN23_42U_2,
            LN23_42U_D,
            LN23_50U_1,
            LN23_50U_2,
            LN23_50U_D,
            
            FT_2015_1 ,
            FT_2015_2 ,
            FT_2015_D ,
            FT_2019_1 ,
            FT_2019_2 ,
            FT_2019_D ,
            FT_2021_1 ,
            FT_2021_2 ,
            FT_2021_D ,
            FT_2023_1 ,
            FT_2023_2 ,
            FT_2023_D ,
            FT23_32_1 ,
            FT23_32_2 ,
            FT23_32_D ,
            FT23_42_1 ,
            FT23_42_2 ,
            FT23_42_D ,
            FT23_50_1 ,
            FT23_50_2 ,
            FT23_50_D ,
            FT23_32U_1,
            FT23_32U_2,
            FT23_32U_D,
            FT23_42U_1,
            FT23_42U_2,
            FT23_42U_D,
            FT23_50U_1,
            FT23_50U_2,
            FT23_50U_D,
            
            TSP_2015_1,
            TSP_2015_2,
            TSP_2019_1,
            TSP_2019_2,
            TSP_2021_1,
            TSP_2021_2,
            TSP_2023_1,
            TSP_2023_2,
            TSP23_32_1,
            TSP23_32_2,
            TSP23_42_1,
            TSP23_42_2,
            TSP23_50_1,
            TSP23_50_2,
            
            HOT_2015_1,
            HOT_2015_2,
            HOT_2019_1,
            HOT_2019_2,
            HOT_2021_1,
            HOT_2021_2,
            HOT_2023_1,
            HOT_2023_2,
            HOT23_32_1,
            HOT23_32_2,
            HOT23_42_1,
            HOT23_42_2,
            HOT23_50_1,
            HOT23_50_2,
            
            REL_2015_1,
            REL_2015_2,
            REL_2019_1,
            REL_2019_2,
            REL_2021_1,
            REL_2021_2,
            REL_2023_1,
            REL_2023_2,
            REL23_32_1,
            REL23_32_2,
            REL23_42_1,
            REL23_42_2,
            REL23_50_1,
            REL23_50_2,
            
            OP_2019_1 ,
            OP_2019_2 ,
            OP_2021_1 ,
            OP_2021_2 ,
            OP_2023_1 ,
            OP_2023_2 ,
            OP23_32_1 ,
            OP23_32_2 ,
            OP23_42_1 ,
            OP23_42_2 ,
            OP23_50_1 ,
            OP23_50_2 ,
            OP23_32U_1,
            OP23_32U_2,
            OP23_42U_1,
            OP23_42U_2,
            OP23_50U_1
    
    
    
    MERGE RECORD=T  ;Make sure any new links in one or the other are added to the compare net
    
    
    PHASE=LINKMERGE
        chk_dist = ( (A.X - B.X)^2 + (A.Y - B.Y)^2 )^0.5 / 1609.34
        
        
        DIST_1     = li.1.DISTANCE
        DIST_2     = li.2.DISTANCE
        
        STREET_1   = li.1.STREET
        STREET_2   = li.2.STREET
        
        ONEWAY_1   = li.1.ONEWAY
        ONEWAY_2   = li.2.ONEWAY
        
        TAZID_1    = li.1.TAZID
        TAZID_2    = li.2.TAZID
        
        LINKID_1   = li.1.LINKID
        LINKID_2   = li.2.LINKID
        
        SEGID_1    = li.1.SEGID
        SEGID_2    = li.2.SEGID
        
        HOTZN_1    = li.1.HOTZN
        HOTZN_2    = li.2.HOTZN
        
        TRKRST15_1 = li.1.TRKRST2015
        TRKRST15_2 = li.2.TRKRST2015
        
        TRKRST23_1 = li.1.TRKRST2023
        TRKRST23_2 = li.2.TRKRST2023
        
        SFAC_BAS_1 = li.1.SFAC_BASE
        SFAC_BAS_2 = li.2.SFAC_BASE
        
        SFAC_FUT_1 = li.1.SFAC_FUT
        SFAC_FUT_2 = li.2.SFAC_FUT
        
        CFAC_BAS_1 = li.1.CFAC_BASE
        CFAC_BAS_2 = li.2.CFAC_BASE
        
        CFAC_FUT_1 = li.1.CFAC_FUT
        CFAC_FUT_2 = li.2.CFAC_FUT
        
        
        LN_2015_1  = li.1.LN_2015
        LN_2015_2  = li.2.LN_2015
        LN_2015_D  = li.1.LN_2015 - li.2.LN_2015
        
        LN_2019_1  = li.1.LN_2019
        LN_2019_2  = li.2.LN_2019
        LN_2019_D  = li.1.LN_2019 - li.2.LN_2019
        
        LN_2021_1  = li.1.LN_2021
        LN_2021_2  = li.2.LN_2021
        LN_2021_D  = li.1.LN_2021 - li.2.LN_2021
       
        LN_2023_1  = li.1.LN_2023
        LN_2023_2  = li.2.LN_2023
        LN_2023_D  = li.1.LN_2023 - li.2.LN_2023
        
        LN23_32_1  = li.1.LN23_32
        LN23_32_2  = li.2.LN23_32
        LN23_32_D  = li.1.LN23_32 - li.2.LN23_32
        
        LN23_42_1  = li.1.LN23_42
        LN23_42_2  = li.2.LN23_42
        LN23_42_D  = li.1.LN23_42 - li.2.LN23_42
        
        LN23_50_1  = li.1.LN23_50
        LN23_50_2  = li.2.LN23_50
        LN23_50_D  = li.1.LN23_50 - li.2.LN23_50
        
        LN23_32U_1 = li.1.LN23_32UF
        LN23_32U_2 = li.2.LN23_32UF
        LN23_32U_D = li.1.LN23_32UF - li.2.LN23_32UF
        
        LN23_42U_1 = li.1.LN23_42UF
        LN23_42U_2 = li.2.LN23_42UF
        LN23_42U_D = li.1.LN23_42UF - li.2.LN23_42UF
        
        LN23_50U_1 = li.1.LN23_50UF
        LN23_50U_2 = li.2.LN23_50UF
        LN23_50U_D = li.1.LN23_50UF - li.2.LN23_50UF
        
        FT_2015_1  = li.1.FT_2015
        FT_2015_2  = li.2.FT_2015
        FT_2015_D  = li.1.FT_2015 - li.2.FT_2015
        
        FT_2019_1  = li.1.FT_2019
        FT_2019_2  = li.2.FT_2019
        FT_2019_D  = li.1.FT_2019 - li.2.FT_2019
        
        FT_2021_1  = li.1.FT_2021
        FT_2021_2  = li.2.FT_2021
        FT_2021_D  = li.1.FT_2021 - li.2.FT_2021
       
        FT_2023_1  = li.1.FT_2023
        FT_2023_2  = li.2.FT_2023
        FT_2023_D  = li.1.FT_2023 - li.2.FT_2023
        
        FT23_32_1  = li.1.FT23_32
        FT23_32_2  = li.2.FT23_32
        FT23_32_D  = li.1.FT23_32 - li.2.FT23_32
        
        FT23_42_1  = li.1.FT23_42
        FT23_42_2  = li.2.FT23_42
        FT23_42_D  = li.1.FT23_42 - li.2.FT23_42
        
        FT23_50_1  = li.1.FT23_50
        FT23_50_2  = li.2.FT23_50
        FT23_50_D  = li.1.FT23_50 - li.2.FT23_50
        
        FT23_32U_1 = li.1.FT23_32UF
        FT23_32U_2 = li.2.FT23_32UF
        FT23_32U_D = li.1.FT23_32UF - li.2.FT23_32UF
        
        FT23_42U_1 = li.1.FT23_42UF
        FT23_42U_2 = li.2.FT23_42UF
        FT23_42U_D = li.1.FT23_42UF - li.2.FT23_42UF
        
        FT23_50U_1 = li.1.FT23_50UF
        FT23_50U_2 = li.2.FT23_50UF
        FT23_50U_D = li.1.FT23_50UF - li.2.FT23_50UF
        
        TSP_2015_1 = li.1.TSPD_2015
        TSP_2015_2 = li.2.TSPD_2015
        
        TSP_2019_1 = li.1.TSPD_2019
        TSP_2019_2 = li.2.TSPD_2019
        
        TSP_2021_1 = li.1.TSPD_2021
        TSP_2021_2 = li.2.TSPD_2021
        
        TSP_2023_1 = li.1.TSPD_2023
        TSP_2023_2 = li.2.TSPD_2023
        
        TSP23_32_1 = li.1.TSPD23_32
        TSP23_32_2 = li.2.TSPD23_32
        
        TSP23_42_1 = li.1.TSPD23_42
        TSP23_42_2 = li.2.TSPD23_42
        
        TSP23_50_1 = li.1.TSPD23_50
        TSP23_50_2 = li.2.TSPD23_50
        
        
        HOT_2015_1 = li.1.HOT_2015
        HOT_2015_2 = li.2.HOT_2015
        
        HOT_2019_1 = li.1.HOT_2019
        HOT_2019_2 = li.2.HOT_2019
        
        HOT_2021_1 = li.1.HOT_2021
        HOT_2021_2 = li.2.HOT_2021
        
        HOT_2023_1 = li.1.HOT_2023
        HOT_2023_2 = li.2.HOT_2023
        
        HOT23_32_1 = li.1.HOT23_32
        HOT23_32_2 = li.2.HOT23_32
        
        HOT23_42_1 = li.1.HOT23_42
        HOT23_42_2 = li.2.HOT23_42
        
        HOT23_50_1 = li.1.HOT23_50
        HOT23_50_2 = li.2.HOT23_50
        
        
        REL_2015_1 = li.1.REL_2015
        REL_2015_2 = li.2.REL_2015
        
        REL_2019_1 = li.1.REL_2019
        REL_2019_2 = li.2.REL_2019
        
        REL_2021_1 = li.1.REL_2021
        REL_2021_2 = li.2.REL_2021
        
        REL_2023_1 = li.1.REL_2023
        REL_2023_2 = li.2.REL_2023
        
        REL23_32_1 = li.1.REL23_32
        REL23_32_2 = li.2.REL23_32
        
        REL23_42_1 = li.1.REL23_42
        REL23_42_2 = li.2.REL23_42
        
        REL23_50_1 = li.1.REL23_50
        REL23_50_2 = li.2.REL23_50
        
        
        OP_2019_1  = li.1.OP_2019
        OP_2019_2  = li.2.OP_2019
        
        OP_2021_1  = li.1.OP_2021
        OP_2021_2  = li.2.OP_2021
        
        OP_2023_1  = li.1.OP_2023
        OP_2023_2  = li.2.OP_2023
        
        OP23_32_1  = li.1.OP23_32
        OP23_32_2  = li.2.OP23_32
        
        OP23_42_1  = li.1.OP23_42
        OP23_42_2  = li.2.OP23_42
        
        OP23_50_1  = li.1.OP23_50
        OP23_50_2  = li.2.OP23_50
        
        OP23_32U_1 = li.1.OP23_32UF
        OP23_32U_2 = li.2.OP23_32UF
        
        OP23_42U_1 = li.1.OP23_42UF
        OP23_42U_2 = li.2.OP23_42UF
        
        OP23_50U_1 = li.1.OP23_50UF
        OP23_50U_2 = li.2.OP23_50UF

    ENDPHASE
  
ENDRUN


*(DEL TPPL*)
