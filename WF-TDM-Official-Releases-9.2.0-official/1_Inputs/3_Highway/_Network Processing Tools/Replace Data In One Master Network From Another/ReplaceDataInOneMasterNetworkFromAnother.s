RUN PGM=NETWORK MSG='Replace Data in One Master Network from Another'

;NETWORK 1 IS HAS UPDATED DATA
FILEI NETI[1] = '..\..\MasterNet_v9 - 2023-12-19.net'

;NETWORK 2 IS BASE NETWORK (GEOMETRY)
FILEI NETI[2] = '..\..\MasterNet_v9 - 2023-12-22.net'

MERGE RECORD=F

FILEO NETO = '..\..\MasterNet_v9 - 2024-01-02.net',
    INCLUDE=DISTEXCEPT,
            EXTERNAL  ,
            LINKID    ,
            MAG_LINK  ,
            STREET    ,
            HOTZN     ,
            SEL_LINK  ,
            ONEWAY    ,
            DIRECTION ,
            SFAC_BASE ,
            SFAC_FUT  ,
            CFAC_BASE ,
            CFAC_FUT  ,
            TRKRST2015,
            TRKRST2023,
            TAZID     ,
            SEGID     ,
            SGX_2021  ,
            SGX_2023  ,
            SGX_2028  ,
            SGX23_32  ,
            SGX23_42  ,
            SGX23_50  ,
            SGX23_32UF,
            SGX23_42UF,
            SGX23_50UF,
            LN_2015   ,
            LN_2019   ,
            LN_2021   ,
            LN_2023   ,
            LN_2028   ,
            LN23_32   ,
            LN23_42   ,
            LN23_50   ,
            LN23_32UF ,
            LN23_42UF ,
            LN23_50UF ,
            LN23_50UFM,
            FT_2015   ,
            FT_2019   ,
            FT_2021   ,
            FT_2023   ,
            FT_2028   ,
            FT23_32   ,
            FT23_42   ,
            FT23_50   ,
            FT23_32UF ,
            FT23_42UF ,
            FT23_50UF ,
            TSPD_2015 ,
            TSPD_2019 ,
            TSPD_2021 ,
            TSPD_2023 ,
            TSPD_2028 ,
            TSPD23_32 ,
            TSPD23_42 ,
            TSPD23_50 ,
            TSPD23_32U,
            TSPD23_42U,
            TSPD23_50U,
            TSPD_AVE  ,
            TRNSPD_PTC,
            TRNSPD_MIS,
            TRNSPD_MED,
            TRNSPD_HIG,
            TRNSPD_HII,
            HOT_2015  ,
            HOT_2019  ,
            HOT_2021  ,
            HOT_2023  ,
            HOT_2028  ,
            HOT23_32  ,
            HOT23_42  ,
            HOT23_50  ,
            HOT23_32UF,
            HOT23_42UF,
            HOT23_50UF,
            REL_2015  ,
            REL_2019  ,
            REL_2021  ,
            REL_2023  ,
            REL_2028  ,
            REL23_32  ,
            REL23_42  ,
            REL23_50  ,
            REL23_32UF,
            REL23_42UF,
            REL23_50UF,
            OP_2019   ,
            OP_2021   ,
            OP_2023   ,
            OP_2028   ,
            OP23_32   ,
            OP23_42   ,
            OP23_50   ,
            OP23_32UF ,
            OP23_42UF ,
            OP23_50UF ,
            GIS23_32  ,
            GIS23_42  ,
            GIS23_50   

PHASE=LINKMERGE

    ;FROM NETWORK 1
    DISTEXCEPT = li.1.DISTEXCEPT
    EXTERNAL   = li.1.EXTERNAL
    LINKID     = li.1.LINKID
    MAG_LINK   = li.1.MAG_LINK
    STREET     = li.1.STREET
    HOTZN      = li.1.HOTZN
    SEL_LINK   = li.1.SEL_LINK
    ONEWAY     = li.1.ONEWAY
    DIRECTION  = li.1.DIRECTION
    SFAC_BASE  = li.1.SFAC_BASE
    SFAC_FUT   = li.1.SFAC_FUT
    CFAC_BASE  = li.1.CFAC_BASE
    CFAC_FUT   = li.1.CFAC_FUT
    TRKRST2015 = li.1.TRKRST2015
    TRKRST2023 = li.1.TRKRST2023
    TAZID      = li.1.TAZID

    ;FROM NETWORK 2
    SEGID      = li.2.SEGID
    SGX_2021   = li.2.SGX_2021
    SGX_2023   = li.2.SGX_2023
    SGX_2028   = li.2.SGX_2028
    SGX23_32   = li.2.SGX23_32
    SGX23_42   = li.2.SGX23_42
    SGX23_50   = li.2.SGX23_50
    SGX23_32UF = li.2.SGX23_32UF
    SGX23_42UF = li.2.SGX23_42UF
    SGX23_50UF = li.2.SGX23_50UF

    ;FROM NETWORK 1
    LN_2015    = li.1.LN_2015
    LN_2019    = li.1.LN_2019
    LN_2021    = li.1.LN_2021
    LN_2023    = li.1.LN_2023
    LN_2028    = li.1.LN_2028
    LN23_32    = li.1.LN23_32
    LN23_42    = li.1.LN23_42
    LN23_50    = li.1.LN23_50
    LN23_32UF  = li.1.LN23_32UF
    LN23_42UF  = li.1.LN23_42UF
    LN23_50UF  = li.1.LN23_50UF
    LN23_50UFM = li.1.LN23_50UFM
    FT_2015    = li.1.FT_2015
    FT_2019    = li.1.FT_2019
    FT_2021    = li.1.FT_2021
    FT_2023    = li.1.FT_2023
    FT_2028    = li.1.FT_2028
    FT23_32    = li.1.FT23_32
    FT23_42    = li.1.FT23_42
    FT23_50    = li.1.FT23_50
    FT23_32UF  = li.1.FT23_32UF
    FT23_42UF  = li.1.FT23_42UF
    FT23_50UF  = li.1.FT23_50UF
    TSPD_2015  = li.1.TSPD_2015
    TSPD_2019  = li.1.TSPD_2019
    TSPD_2021  = li.1.TSPD_2021
    TSPD_2023  = li.1.TSPD_2023
    TSPD_2028  = li.1.TSPD_2028
    TSPD23_32  = li.1.TSPD23_32
    TSPD23_42  = li.1.TSPD23_42
    TSPD23_50  = li.1.TSPD23_50
    TSPD23_32U = li.1.TSPD23_32U
    TSPD23_42U = li.1.TSPD23_42U
    TSPD23_50U = li.1.TSPD23_50U
    TSPD_AVE   = li.1.TSPD_AVE
    TRNSPD_PTC = li.1.TRNSPD_PTC
    TRNSPD_MIS = li.1.TRNSPD_MIS
    TRNSPD_MED = li.1.TRNSPD_MED
    TRNSPD_HIG = li.1.TRNSPD_HIG
    TRNSPD_HII = li.1.TRNSPD_HII
    HOT_2015   = li.1.HOT_2015
    HOT_2019   = li.1.HOT_2019
    HOT_2021   = li.1.HOT_2021
    HOT_2023   = li.1.HOT_2023
    HOT_2028   = li.1.HOT_2028
    HOT23_32   = li.1.HOT23_32
    HOT23_42   = li.1.HOT23_42
    HOT23_50   = li.1.HOT23_50
    HOT23_32UF = li.1.HOT23_32UF
    HOT23_42UF = li.1.HOT23_42UF
    HOT23_50UF = li.1.HOT23_50UF
    REL_2015   = li.1.REL_2015
    REL_2019   = li.1.REL_2019
    REL_2021   = li.1.REL_2021
    REL_2023   = li.1.REL_2023
    REL_2028   = li.1.REL_2028
    REL23_32   = li.1.REL23_32
    REL23_42   = li.1.REL23_42
    REL23_50   = li.1.REL23_50
    REL23_32UF = li.1.REL23_32UF
    REL23_42UF = li.1.REL23_42UF
    REL23_50UF = li.1.REL23_50UF
    OP_2019    = li.1.OP_2019
    OP_2021    = li.1.OP_2021
    OP_2023    = li.1.OP_2023
    OP_2028    = li.1.OP_2028
    OP23_32    = li.1.OP23_32
    OP23_42    = li.1.OP23_42
    OP23_50    = li.1.OP23_50
    OP23_32UF  = li.1.OP23_32UF
    OP23_42UF  = li.1.OP23_42UF
    OP23_50UF  = li.1.OP23_50UF
    GIS23_32   = li.1.GIS23_32
    GIS23_42   = li.1.GIS23_42
    GIS23_50   = li.1.GIS23_50
    
ENDPHASE

ENDRUN
