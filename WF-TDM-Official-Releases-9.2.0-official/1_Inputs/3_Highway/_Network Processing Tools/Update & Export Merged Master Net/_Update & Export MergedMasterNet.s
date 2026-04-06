
;-------------------------------------------------------------------------------------------------------------
;GLOBAL VARIABLES
;-------------------------------------------------------------------------------------------------------------

;parameters
UsedZones = 9999


;choose which sections to run
RunUpdateNet = 1
RunExportNet = 1


;Master Network input variables
Input_Net_Prefix = '_orig_data\MasterNet - 2022-09-19a'
Input_Net_Geom   = '_orig_data\GIS\MasterNet - 2022-09-19 - Link.shp'


;Master Network output variables
MasterNet_Prefix      = 'MasterNet - 2022-09-19a'
MasterNet_Prefix_v832 = 'MasterNet_v832 - 2022-09-19a'
MasterNet_Prefix_v9   = 'MasterNet_v9 - 2022-09-19a'


;note: update field lists in Link and Node shapefile output in STEP 1


;node ranges for MAG area
;  note: the following are the node ranges that make up the MAG area (v9 node schema)
;      Internal TAZ  = 2217-3546
;      External TAZ  = 3616-3629
;      Highway Nodes = 50000-89999
;      Donut Area    = 95000-99999
;      v832 only TAZ = 801789-802873  (FLG_NEWNET=10)
;      v832 only Ext = 802874-802881  (FLG_NEWNET=11)
MAG_Node_Range = '2217-3546, 3616-3629, 50000-89999, 95000-99999, 801789-802873, 802874-802881'




;-------------------------------------------------------------------------------------------------------------
;STEP 1 - Update Network
;-------------------------------------------------------------------------------------------------------------

if (RunUpdateNet=1)
    
    ;copy VPR files --------------------------------------------------------------------------------
    RUN PGM=MATRIX  MSG='Set Up: create ouput folders'
        
        ZONES = 1
        
        PRINT FILE='_CopyVPR.bat',
            LIST='\n',
                 '\nif NOT EXIST "GIS"   MKDIR "GIS"',
                 '\n',
                 '\nif NOT EXIST "@MasterNet_Prefix@.vpr"   COPY "@Input_Net_Prefix@.vpr"   "@MasterNet_Prefix@.vpr"',
                 '\n'  
        
    ENDRUN
    
    
    ;run batch files
    *(_CopyVPR.bat)
    
    
    
    ;update link/node field order & data and save as Link and Node shapefiles ----------------------
    RUN PGM=NETWORK  MSG='Update fields and export Link and Node shapefiles'
    FILEI NETI[1]  = '@Input_Net_Prefix@.net'
    FILEI GEOMI[1] = '@Input_Net_Geom@'
    
    
    ;note: put fields in order you'd wish them to appear in Master Network,
    ;      text fields identified with () and integer of field width
    FILEO NODEO = 'GIS\@MasterNet_Prefix@ - Node.shp',
        FORMAT=SHP,
        INCLUDE=N            ,
                X            ,
                Y            ,
                GEOGKEY(20)  ,
                EXTERNAL     ,
                N_V9         ,
                EXT_V9       ,
                FLG_NEWNET   ,
                MAG_NODE     ,
                UNCON        ,
                HOTZN        ,
                TAZID        ,
                NODENAME(30) ,
                PNR_2015     ,
                PNR_2019     ,
                PNR_2021     ,
                PNR_2023     ,
                PNR_2024     ,
                PNR_2028     ,
                PNR23_32     ,
                PNR23_42     ,
                PNR23_50     ,
                PNR23_32UF   ,
                PNR23_42UF   ,
                PNR23_50UF   ,
                FARZN_2015   ,
                FARZN_2019   ,
                FARZN_2021   ,
                FARZN_2023   ,
                FARZN_2024   ,
                FARZN_2028   ,
                FARZN23_32   ,
                FARZN23_42   ,
                FARZN23_50   ,
                FARE23_32U   ,
                FARE23_42U   ,
                FARE23_50U   ,
                PNR19_30     ,
                PNR19_40     ,
                PNR19_50     ,
                FARZN19_30   ,
                FARZN19_40   ,
                FARZN19_50   ,
                SORT_N       
    
    
    ;note: put fields in order you'd wish them to appear in Master Network,
    ;      text fields identified with () and integer of field width
    FILEO LINKO = 'GIS\@MasterNet_Prefix@ - Link.shp',
        FORMAT=SHP,
        INCLUDE=A             ,
                B             ,
                DISTANCE      ,
                DISTEXCEPT    ,
                EXTERNAL      ,
                LINKID(17)    ,
                A_V9          ,
                B_V9          ,
                DISTX_V9      ,
                EXT_V9        ,
                LNKID_V9(17)  ,
                FLG_NEWNET    ,
                MAG_LINK      ,
                STREET(30)    ,
                HOTZN         ,
                SEL_LINK      ,
                ONEWAY        ,
                DIRECTION(5)  ,
                SFAC_BASE     ,
                SFAC_FUT      ,
                CFAC_BASE     ,
                CFAC_FUT      ,
                TRKRST2015    ,
                TRKRST2023    ,
                TAZID         ,
                SEGID(30)     ,
                SEGEX_RTP(35) ,
                SEGEX_NEED(35),
                LN_2015       ,
                LN_2019       ,
                LN_2021       ,
                LN_2023       ,
                LN_2024       ,
                LN_2028       ,
                LN23_32       ,
                LN23_42       ,
                LN23_50       ,
                LN23_32UF     ,
                LN23_42UF     ,
                LN23_50UF     ,
                FT_2015       ,
                FT_2019       ,
                FT_2021       ,
                FT_2023       ,
                FT_2024       ,
                FT_2028       ,
                FT23_32       ,
                FT23_42       ,
                FT23_50       ,
                FT23_32UF     ,
                FT23_42UF     ,
                FT23_50UF     ,
                TSPD_2015     ,
                TSPD_2019     ,
                TSPD_2021     ,
                TSPD_2023     ,
                TSPD_2024     ,
                TSPD_2028     ,
                TSPD23_32     ,
                TSPD23_42     ,
                TSPD23_50     ,
                TSPD23_32U    ,
                TSPD23_42U    ,
                TSPD23_50U    ,
                TSPD_AVE      ,
                TRNSPD_PTC    ,
                TRNSPD_MIS    ,
                TRNSPD_MED    ,
                TRNSPD_HIG    ,
                TRNSPD_HII    ,
                HOT_2015      ,
                HOT_2019      ,
                HOT_2021      ,
                HOT_2023      ,
                HOT_2024      ,
                HOT_2028      ,
                HOT23_32      ,
                HOT23_42      ,
                HOT23_50      ,
                HOT23_32UF    ,
                HOT23_42UF    ,
                HOT23_50UF    ,
                REL_2015      ,
                REL_2019      ,
                REL_2021      ,
                REL_2023      ,
                REL_2024      ,
                REL_2028      ,
                REL23_32      ,
                REL23_42      ,
                REL23_50      ,
                REL23_32UF    ,
                REL23_42UF    ,
                REL23_50UF    ,
                OP_2019       ,
                OP_2021       ,
                OP_2023       ,
                OP_2024       ,
                OP_2028       ,
                OP23_32       ,
                OP23_42       ,
                OP23_50       ,
                OP23_32UF     ,
                OP23_42UF     ,
                OP23_50UF     ,
                GIS23_32      ,
                GIS23_42      ,
                GIS23_50      ,
                SCRN_LRG      ,
                SCRN_SML      ,
                FC_ID         ,
                SA_ID         ,
                LN19_30       ,
                LN19_40       ,
                LN19_50       ,
                LN19_30UF     ,
                LN19_40UF     ,
                LN19_50UF     ,
                LN19_50NNR    ,
                FT19_30       ,
                FT19_40       ,
                FT19_50       ,
                FT19_30UF     ,
                FT19_40UF     ,
                FT19_50UF     ,
                FT19_50NNR    ,
                TSPD19_30     ,
                TSPD19_40     ,
                TSPD19_50     ,
                TSPD19_30U    ,
                TSPD19_40U    ,
                TSPD19_50U    ,
                HOT19_30      ,
                HOT19_40      ,
                HOT19_50      ,
                REL19_30      ,
                REL19_40      ,
                REL19_50      ,
                OP19_30       ,
                OP19_40       ,
                OP19_50       ,
                OP19_30UF     ,
                OP19_40UF     ,
                OP19_50UF     ,
                OP19_50NNR    ,
                GIS19_30      ,
                GIS19_40      ,
                GIS19_50      ,
                SORT_L        
    
    
    
        ZONES = @UsedZones@
        
        
        
        ;define arrays
        ARRAY _Update_Nv832   = 9999999,
              _Update_Nv9     = 9999999,
              _Update_MAGNode = 9999999
        
        
        
        PHASE=INPUT, FILEI=ni.1
            
            ;ensure v832 highway nodes have a valid node number ------------------------------------
            ;  note: The Merged Master Network uses v832 node scheme.  To avoid N value duplication,
            ;        make all unique v9 TAZ (FLG_NEWNET=20-21) are in the 900k range (N = N_v9 + 900k).
            ;        These nodes will be used when v9 Master Network is exported but will be deleted 
            ;        when the v832 Master Network is exported.
            _old_node = N
            
            if (FLG_NEWNET=20-21)  N = N_V9 + 900000
            
            _Update_Nv832[_old_node] = N
            
            
            ;ensure v9 highway nodes have a valid node number --------------------------------------
            ;  note: Before the unique v832 nodes (FLG_NEWNET=10-11) can be deleted when exporting
            ;        the v9 Master Network, all nodes are shifted to use the v9 node scheme.  To avoid
            ;        N value duplication, make all unique v832 TAZ are in the 800k range (N_v9 = N + 800k).
            ;        After conversion from the v832 node scheme to the v9 node scheme, these nodes are
            ;        deleted when the v9 Master Network is exported.
            if (FLG_NEWNET=10-11)  N_v9 = N + 800000
            
            
            ;update N_v9 highway node number
            ;  note: v832 & v9 use the same node number for all highway & transit nodes
            if (N>=10000 & N<100000)  N_V9 = N
            
            
            ;populate v9 node array with updated values (used to update link A & B fields)
            _Update_Nv9[N] = N_V9
            
        ENDPHASE
        
        
        PHASE=INPUT, FILEI=li.1
            
            ;update A & B fields with new node number ----------------------------------------------
            A    = _Update_Nv832[A]
            B    = _Update_Nv832[B]
            
            A_v9 = _Update_Nv9[A]
            B_v9 = _Update_Nv9[B]
            
        ENDPHASE
        
        
        
        PHASE=NODEMERGE
            
            ;update GEOGKEY ------------------------------------------------------------------------
            _XCoord = LTRIM(STR(INT(ni.1.X), 10, 0))
            _YCoord = LTRIM(STR(INT(ni.1.Y), 10, 0))
            GEOGKEY = _XCoord + '_' + _YCoord
            
            
            
            ;update MAG_NODE -----------------------------------------------------------------------
            if (ni.1.N_v9=@MAG_Node_Range@)  ;v9 MAG Node ranges
                MAG_NODE = 1
                
            else
                MAG_NODE = 0
                
            endif  ;ni.1.N_v9=@MAG_Node_Range@
            
            
            _Update_MAGNode[N] = MAG_NODE
            
        ENDPHASE
        
        
        
        PHASE=LINKMERGE
            
            ;update LINKID & LNKID_v9 --------------------------------------------------------------
            _ANode  = LTRIM(STR(li.1.A, 10, 0))
            _BNode  = LTRIM(STR(li.1.B, 10, 0))
            LINKID  = _ANode + '_' + _BNode
            
            _ANode   = LTRIM(STR(li.1.A_v9, 10, 0))
            _BNode   = LTRIM(STR(li.1.B_v9, 10, 0))
            LNKID_v9 = _ANode + '_' + _BNode
            
            
            
            ;update MAG_LINK -----------------------------------------------------------------------
            if (_Update_MAGNode[li.1.A]=1 & _Update_MAGNode[li.1.B]=1)  ;must have MAG_NODE=1 for both A & B
                MAG_LINK = 1
                
            else
                MAG_LINK = 0
                
            endif  ;_Update_MAGNode[li.1.A]=1 & _Update_MAGNode[li.1.B]=1
            
            
            
            ;update DIRECTION --------------------------------------------------------------------------
            ;calculate angle of link
            ;  note: angles are calculated from due north in degrees from the A node of the link and
            ;        proceed counter-clockwise
            _Angle = _L.S_Angle
            
            ;assign the cardinal direction
            if (_Angle<=45)
                DIRECTION = 'NB'
                
            elseif (_Angle<=135)
                DIRECTION = 'WB'
                
            elseif (_Angle<=225)
                DIRECTION = 'SB'
                
            elseif (_Angle<=315)
                DIRECTION = 'EB'
                
            elseif (_Angle<=360)
                DIRECTION = 'NB'
                
            endif  ;_Angle
            
        ENDPHASE
        
    ENDRUN
    
    
    
    ;create updated Master Network
    RUN PGM=NETWORK  MSG='Create updated Master Network'
    FILEI LINKI[1] = 'GIS\@MasterNet_Prefix@ - Link.dbf'
    FILEI NODEI[1] = 'GIS\@MasterNet_Prefix@ - Node.dbf'
    
    FILEO NETO = '@MasterNet_Prefix@.net'
    
        ZONES = @UsedZones@
        
    ENDRUN

endif  ;RunUpdateNet=1




;-------------------------------------------------------------------------------------------------------------
;STEP 2 - Export v832 & v9 Master Network
;-------------------------------------------------------------------------------------------------------------

if (RunExportNet=1)
    
    ;create v832 & v9 folders ----------------------------------------------------------------------
    RUN PGM=MATRIX  MSG='Set Up: create ouput folders'
        
        ZONES = 1
        
        PRINT FILE='_CreateFolders.bat',
            LIST='\n',
                 '\nif NOT EXIST "@MasterNet_Prefix_v832@"       MKDIR "@MasterNet_Prefix_v832@"'    ,
                 '\nif NOT EXIST "@MasterNet_Prefix_v832@\GIS"   MKDIR "@MasterNet_Prefix_v832@\GIS"',
                 '\n',
                 '\nif NOT EXIST "@MasterNet_Prefix_v9@"         MKDIR "@MasterNet_Prefix_v9@"'      ,
                 '\nif NOT EXIST "@MasterNet_Prefix_v9@\GIS"     MKDIR "@MasterNet_Prefix_v9@\GIS"'  ,
                 '\n',
                 '\nif NOT EXIST "@MasterNet_Prefix_v832@\@MasterNet_Prefix_v832@.vpr"   COPY "@MasterNet_Prefix@.vpr"   "@MasterNet_Prefix_v832@\@MasterNet_Prefix_v832@.vpr"',
                 '\nif NOT EXIST "@MasterNet_Prefix_v9@\@MasterNet_Prefix_v9@.vpr"       COPY "@MasterNet_Prefix@.vpr"   "@MasterNet_Prefix_v9@\@MasterNet_Prefix_v9@.vpr"'    ,
                 '\n'
        
    ENDRUN
    
    
    ;run batch files
    *(_CreateFolders.bat)
    
    
    
    ;export v832 master network --------------------------------------------------------------------
    RUN PGM=NETWORK  MSG='Export v832 Network'
    FILEI NETI[1]  = '@MasterNet_Prefix@.net'
    FILEI GEOMI[1] = 'GIS\@MasterNet_Prefix@ - Link.shp'
    
    FILEO NETO = '@MasterNet_Prefix_v832@\@MasterNet_Prefix_v832@.net',
        EXCLUDE=A_v9     ,
                B_v9     ,
                DISTX_v9 ,
                EXT_v9   ,
                LNKID_v9 ,
                N_V9     ,
                EXT_v9   
    
    FILEO NODEO = '@MasterNet_Prefix_v832@\GIS\@MasterNet_Prefix_v832@ - Node.shp',
        EXCLUDE=N_V9     ,
                EXT_v9   ,
        FORMAT=SHP,
        FORM=10.0,
        VARFORM=X(17.5)      ,
                Y(17.5)      ,
                GEOGKEY(17)  ,
                NODENAME(30) 
    
    FILEO LINKO = '@MasterNet_Prefix_v832@\GIS\@MasterNet_Prefix_v832@ - Link.shp',
        EXCLUDE=A_v9     ,
                B_v9     ,
                DISTX_v9 ,
                EXT_v9   ,
                LNKID_v9 ,
        FORMAT=SHP,
        FORM=10.0,
        VARFORM=DISTANCE(15.5)   ,
                DISTEXCEPT(10.2) ,
                LINKID(17)       ,
                STREET(30)       ,
                DIRECTION(5)     ,
                SEGID(30)        ,
                SEGEX_RTP(35)    ,
                SEGEX_Need(35)   
        
        
        ZONES = @UsedZones@
        
        
        ;remove v9 network nodes/links
        PHASE=NODEMERGE
            if (ni.1.FLG_NEWNET=20-23)  DELETE
        ENDPHASE
        
        PHASE=LINKMERGE
            if (li.1.FLG_NEWNET=20-23)  DELETE
        ENDPHASE
        
    ENDRUN
    
    
    
    ;export v9 master network ----------------------------------------------------------------------
    RUN PGM=NETWORK  MSG='Export v9 Network'
    FILEI NETI[1]  = '@MasterNet_Prefix@.net'
    FILEI GEOMI[1] = 'GIS\@MasterNet_Prefix@ - Link.shp'
    
    FILEO NETO = '@MasterNet_Prefix_v9@\@MasterNet_Prefix_v9@.net',
        EXCLUDE=A_v9     ,
                B_v9     ,
                DISTX_v9 ,
                EXT_v9   ,
                LNKID_v9 ,
                N_V9     ,
                EXT_v9   
    
    FILEO NODEO = '@MasterNet_Prefix_v9@\GIS\@MasterNet_Prefix_v9@ - Node.shp',
        EXCLUDE=N_V9     ,
                EXT_v9   ,
        FORMAT=SHP,
        FORM=10.0,
        VARFORM=X(17.5)      ,
                Y(17.5)      ,
                GEOGKEY(17)  ,
                NODENAME(30) 
    
    FILEO LINKO = '@MasterNet_Prefix_v9@\GIS\@MasterNet_Prefix_v9@ - Link.shp',
        EXCLUDE=A_v9     ,
                B_v9     ,
                DISTX_v9 ,
                EXT_v9   ,
                LNKID_v9 ,
        FORMAT=SHP,
        FORM=10.0,
        VARFORM=DISTANCE(15.5)   ,
                DISTEXCEPT(10.2) ,
                LINKID(17)       ,
                STREET(30)       ,
                DIRECTION(5)     ,
                SEGID(30)        ,
                SEGEX_RTP(35)    ,
                SEGEX_Need(35)   
        
        
        ZONES = @UsedZones@
        
        
        ;copy v9 node/link data into "primary" fields
        PHASE=INPUT FILEI=ni.1
            
            if (FLG_NEWNET=10-13)
                DELETE
                
            else
                N        = N_V9
                EXTERNAL = EXT_v9
                
            endif  ;FLG_NEWNET=10-13
            
        ENDPHASE
        
        
        PHASE=INPUT FILEI=li.1
            
            if (FLG_NEWNET=10-13)
                DELETE
            
            else
                A          = A_v9
                B          = B_v9
                DISTEXCEPT = DISTX_v9
                EXTERNAL   = EXT_v9
                LINKID     = LNKID_v9
                
            endif  ;FLG_NEWNET=10-13
            
        ENDPHASE
        
    ENDRUN

endif  ;RunExportNet=1




;-------------------------------------------------------------------------------------------------------------
;File Clean Up
;-------------------------------------------------------------------------------------------------------------

    *(DEL *.PRN, *.bat)
