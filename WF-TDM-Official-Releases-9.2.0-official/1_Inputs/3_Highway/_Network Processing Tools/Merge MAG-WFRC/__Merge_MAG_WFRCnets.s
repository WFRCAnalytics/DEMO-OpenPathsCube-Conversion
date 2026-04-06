
;Note: before snapping networks, first align data in the two networks into a consistent set of Link and Node fields.

;inputs
currentMAG     = 'E:\GitHub\WF-TDM-v9x\1_Inputs\3_Highway\WFv901_MasterNet_20240419.net'
currentWFRC    = 'E:\GitHub\WF-TDM-v9x\1_Inputs\3_Highway\WFv910_MasterNet_20240418.net'
New_Master_Net = 'E:\GitHub\WF-TDM-v9x\1_Inputs\3_Highway\WFv910_MasterNet_20240429.net'

UsedZones      = 3629


;Remove WFRC from the MAG network
RUN PGM=NETWORK
FILEI NETI = '@currentMAG@'

FILEO NETO  = 'temp\temp_MAG.net'

FILEO LINKO = 'temp\temp_MAG_Links.dbf'

FILEO NODEO = 'temp\temp_MAG_Nodes.dbf'
    
    ZONES = @UsedZones@
    
    
    PHASE=NODEMERGE

        MAG_Node = 0

        ;identify MAG nodes
        if (ni.1.Y < 4476410)
            MAG_Node = 1
        elseif (ni.1.X > 421500 & ni.1.Y < 4478680)    ;point of mountain
            MAG_Node = 1
        elseif (ni.1.X > 426000 & ni.1.Y < 4481100)    ;small corner of Alpine
            MAG_Node = 1
        elseif (ni.1.X > 441700 & ni.1.Y < 4488000)    ;Tibble Fork Canyon
            MAG_Node = 1
        endif
        
        ;delete non-MAG nodes
        if (MAG_Node=0)  DELETE
        
        ;populate data
        GEOGKEY    = n.1.GEOGKEY   ,
        EXTERNAL   = n.1.EXTERNAL  ,
        HOTZN      = n.1.HOTZN     ,
        TAZID      = n.1.TAZID     ,
        NODENAME   = n.1.NODENAME  ,
        PNR_2015   = n.1.PNR_2015  ,
        PNR_2019   = n.1.PNR_2019  ,
        PNR_2021   = n.1.PNR_2021  ,
        PNR_2023   = n.1.PNR_2023  ,
        PNR_2028   = n.1.PNR_2028  ,
        PNR23_32   = n.1.PNR23_32  ,
        PNR23_42   = n.1.PNR23_42  ,
        PNR23_50   = n.1.PNR23_50  ,
        PNR23_32UF = n.1.PNR23_32UF,
        PNR23_42UF = n.1.PNR23_42UF,
        PNR23_50UF = n.1.PNR23_50UF,
        FARZN_2015 = n.1.FARZN_2015,
        FARZN_2019 = n.1.FARZN_2019,
        FARZN_2021 = n.1.FARZN_2021,
        FARZN_2023 = n.1.FARZN_2023,
        FARZN_2028 = n.1.FARZN_2028,
        FARZN23_32 = n.1.FARZN23_32,
        FARZN23_42 = n.1.FARZN23_42,
        FARZN23_50 = n.1.FARZN23_50,
        FARE23_32U = n.1.FARE23_32U,
        FARE23_42U = n.1.FARE23_42U,
        FARE23_50U = n.1.FARE23_50U
        
    ENDPHASE
    
    
    PHASE=LINKMERGE
        if (A.MAG_Node=1 & B.MAG_Node=1)
            MAG_Link  = 1
            WFRC_Link = 0
        else
            MAG_Link  = 0
            WFRC_Link = 1
        endif
        
        ;delete WFRC links
        if (WFRC_Link=1)  DELETE
        
        ;populate data
        DISTANCE   = li.1.DISTANCE
        DISTEXCEPT = li.1.DISTEXCEPT
        EXTERNAL   = li.1.EXTERNAL
        LINKID     = li.1.LINKID
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
        OP_2015    = li.1.OP_2015
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
        SEGID      = li.1.SEGID
        SGX_2015   = li.1.SGX_2015
        SGX_2019   = li.1.SGX_2019
        SGX_2021   = li.1.SGX_2021
        SGX_2023   = li.1.SGX_2023
        SGX_2028   = li.1.SGX_2028
        SGX23_32   = li.1.SGX23_32
        SGX23_42   = li.1.SGX23_42
        SGX23_50   = li.1.SGX23_50
        SGX23_32UF = li.1.SGX23_32UF
        SGX23_42UF = li.1.SGX23_42UF
        SGX23_50UF = li.1.SGX23_50UF
        GIS23_32   = li.1.GIS23_32
        GIS23_42   = li.1.GIS23_42
        GIS23_50   = li.1.GIS23_50
        
    ENDPHASE
    
ENDRUN



;Remove MAG from the WFRC network
RUN PGM=NETWORK
FILEI NETI = '@currentWFRC@'

FILEO NETO  = 'temp\temp_WFRC.net'

FILEO LINKO = 'temp\temp_WFRC_Links.dbf'
            
FILEO NODEO = 'temp\temp_WFRC_Nodes.dbf'    
    
    ZONES = @UsedZones@
    
    
    PHASE=NODEMERGE

        WFRC_Node = 1

        ;identify WFRC nodes
        if (ni.1.Y < 4476410)
            WFRC_Node = 0
        elseif (ni.1.X > 421500 & ni.1.Y < 4478680)    ;point of mountain
            WFRC_Node = 0
        elseif (ni.1.X > 426000 & ni.1.Y < 4481100)    ;small corner of Alpine
            MAG_Node = 1
        elseif (ni.1.X > 441700 & ni.1.Y < 4488000)    ;Tibble Fork Canyon
            WFRC_Node = 0
        endif
        
        ;delete non-WFRC nodes
        if (WFRC_Node=0)  DELETE
        
        ;populate data
        GEOGKEY    = n.1.GEOGKEY   
        EXTERNAL   = n.1.EXTERNAL  
        HOTZN      = n.1.HOTZN     
        TAZID      = n.1.TAZID     
        NODENAME   = n.1.NODENAME  
        PNR_2015   = n.1.PNR_2015  
        PNR_2019   = n.1.PNR_2019  
        PNR_2021   = n.1.PNR_2021  
        PNR_2023   = n.1.PNR_2023  
        PNR_2028   = n.1.PNR_2028  
        PNR23_32   = n.1.PNR23_32  
        PNR23_42   = n.1.PNR23_42  
        PNR23_50   = n.1.PNR23_50  
        PNR23_32UF = n.1.PNR23_32UF
        PNR23_42UF = n.1.PNR23_42UF
        PNR23_50UF = n.1.PNR23_50UF
        FARZN_2015 = n.1.FARZN_2015
        FARZN_2019 = n.1.FARZN_2019
        FARZN_2021 = n.1.FARZN_2021
        FARZN_2023 = n.1.FARZN_2023
        FARZN_2028 = n.1.FARZN_2028
        FARZN23_32 = n.1.FARZN23_32
        FARZN23_42 = n.1.FARZN23_42
        FARZN23_50 = n.1.FARZN23_50
        FARE23_32U = n.1.FARE23_32U
        FARE23_42U = n.1.FARE23_42U
        FARE23_50U = n.1.FARE23_50U
        
    ENDPHASE
    
    PHASE=LINKMERGE
        if (A.WFRC_Node=1 | B.WFRC_Node=1)
            MAG_Link  = 0
            WFRC_Link = 1
        else
            MAG_Link  = 1
            WFRC_Link = 0
        endif
        
        ;delete MAG links
        if (MAG_Link=1)  DELETE
        
        ;populate data
        DISTANCE   = li.1.DISTANCE
        DISTEXCEPT = li.1.DISTEXCEPT
        EXTERNAL   = li.1.EXTERNAL
        LINKID     = li.1.LINKID
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
        OP_2015    = li.1.OP_2015
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
        SEGID      = li.1.SEGID
        SGX_2015   = li.1.SGX_2015
        SGX_2019   = li.1.SGX_2019
        SGX_2021   = li.1.SGX_2021
        SGX_2023   = li.1.SGX_2023
        SGX_2028   = li.1.SGX_2028
        SGX23_32   = li.1.SGX23_32
        SGX23_42   = li.1.SGX23_42
        SGX23_50   = li.1.SGX23_50
        SGX23_32UF = li.1.SGX23_32UF
        SGX23_42UF = li.1.SGX23_42UF
        SGX23_50UF = li.1.SGX23_50UF
        GIS23_32   = li.1.GIS23_32
        GIS23_42   = li.1.GIS23_42
        GIS23_50   = li.1.GIS23_50

    ENDPHASE
    
ENDRUN


;combine WFRC & MAG networks to one regional network
RUN PGM=NETWORK
FILEI LINKI[1] = 'temp\temp_MAG_Links.dbf'
FILEI NODEI[1] = 'temp\temp_MAG_Nodes.dbf'

FILEI LINKI[2] = 'temp\temp_WFRC_Links.dbf'
FILEI NODEI[2] = 'temp\temp_WFRC_Nodes.dbf'

FILEO NETO = '@New_Master_Net@'

    ZONES = @UsedZones@
    
    MERGE RECORD=T
    
ENDRUN


;*(DEL _temp*.*)
