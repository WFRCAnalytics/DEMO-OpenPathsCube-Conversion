; Instructions for comparing 2 assignments and displaying the differences:
;
; 1.  Copy the two summary networks to this script's location.
; 2.  Identify the names of the networks to be compared below.
; 3.  The script will subtract Net2 lanes, volumes, etc. from Net1, so name 
;     the nets such that the differences will make sense to you.
; 4.  After the script is run, the "default.vpr" file in the Output folder
;     is predefined to display the various differences.  If you don't like
;     the colors, comparisions, or ranges, then make a new set and overwrite
;     the "default.vpr" display settings file.


;***** Note: Displays work best if net_compare is the higher capacity network.

net_1  = 'rv_v9_RTP_SE32_Net32__Assigned.net'                       ;higher capacity network
net_2     = 'og_v9_RTP_SE32_Net32__Assigned_withNewSegIds.net'      ;lower capacity network

compared_net = 'rv_og_v9_RTP_SE32_Net32__Assigned.net' ; net will be placed in Output folder

*(DEL *.PRN)

;******************************************
RUN PGM=NETWORK
  NETI[1] = @net_1@
  NETO    = .\tmpa.net,    INCLUDE = A, B, DISTANCE, SEGID, AREATYPE, FT, X, Y, 
    Lanes, FF_SPD, AM_VC, AM_SPD, AM_TIME, PM_VC, PM_SPD, PM_TIME, DY_VOL, AM_VOL, MD_VOL, PM_VOL, EV_VOL, DY_TRK, DY_CV
ENDRUN

;******************************************
RUN PGM=NETWORK
  NETI[1] = @net_2@
  NETO    = .\tmpb.net,    INCLUDE = A, B, DISTANCE, SEGID, AREATYPE, FT, X, Y, 
    Lanes, FF_SPD, AM_VC, AM_SPD, AM_TIME, PM_VC, PM_SPD, PM_TIME, DY_VOL, AM_VOL, MD_VOL, PM_VOL, EV_VOL, DY_TRK, DY_CV
ENDRUN

;******************************************
RUN PGM=NETWORK
  NETI[1] = tmpa.net
  NETI[2] = tmpb.net
  NETO    = Output_Assign\@compared_net@,    INCLUDE = A, B, DISTANCE, SEGID, X, Y,
    Lanes1, Lanes2, Lane_1M2, AT1, AT2, AT_1M2, FT1, FT2, FT_1M2, FFSPD1, FFSPD2, FFSPD_1M2, 
    AMV1, AMV2, AMV_1M2, AMV_PCT,
    MDV1, MDV2, MDV_1M2, MDV_PCT,
    PMV1, PMV2, PMV_1M2, PMV_PCT,
    EVV1, EVV2, EVV_1M2, EVV_PCT,
    DYV1, DYV2, DYV_1M2, DYV_PCT,
    DYTrk1, DYTrk2, DYTrk_1M2, DYTrk_PCT,
    DYCV1, DYCV2, DYCV_1M2, DYCV_PCT,
    AMVC1, AMVC2, AMVC_1M2, AMSPD1, AMSPD2, AMSPD_1M2, AMTIME1, AMTIME2, AMTIME_1M2,
    PMVC1, PMVC2, PMVC_1M2, PMSPD1, PMSPD2, PMSPD_1M2, PMTIME1, PMTIME2, PMTIME_1M2
    
  MERGE RECORD=T  ;Make sure any new links in one or the other are added to the compare net


  PHASE=LINKMERGE

    AT1 = LI.1.AREATYPE
    AT2 = LI.2.AREATYPE
    AT_1M2 = AT1 - AT2

    FT1 = LI.1.FT
    FT2 = LI.2.FT
    FT_1M2 = FT1 - FT2
    
    Lanes1   = LI.1.LANES
    Lanes2   = LI.2.LANES
    Lane_1M2 = Lanes1 - Lanes2
   
    FFSPD1    = LI.1.FF_SPD    
    FFSPD2    = LI.2.FF_SPD    
    FFSPD_1M2 = FFSPD1 - FFSPD2
    
    AMV1 = LI.1.AM_VOL
    AMV2 = LI.2.AM_VOL
    AMV_1M2 = AMV1 - AMV2     ;*************** Compare AM_VOL
           
    AMV_PCT = 0
    if (AMV2 > 0)
      AMV_PCT = ((AMV1/AMV2) - 1) * 100
    endif  
    
    MDV1 = LI.1.MD_VOL
    MDV2 = LI.2.MD_VOL
    MDV_1M2 = MDV1 - MDV2     ;*************** Compare MD_VOL
      
    MDV_PCT = 0
    if (MDV2 > 0)
      MDV_PCT = ((MDV1/MDV2) - 1) * 100
    endif    
    
    PMV1 = LI.1.PM_VOL
    PMV2 = LI.2.PM_VOL
    PMV_1M2 = PMV1 - PMV2     ;*************** Compare PM_VOL
    
    PMV_PCT = 0
    if (PMV2 > 0)
      PMV_PCT = ((PMV1/PMV2) - 1) * 100
    endif

    EVV1 = LI.1.EV_VOL
    EVV2 = LI.2.EV_VOL
    EVV_1M2 = EVV1 - EVV2     ;*************** Compare EV_VOL
    
    EVV_PCT = 0
    if (EVV2 > 0)
      EVV_PCT = ((EVV1/EVV2) - 1) * 100
    endif
    
    DYV1 = LI.1.DY_VOL
    DYV2 = LI.2.DY_VOL
    DYV_1M2 = DYV1 - DYV2     ;*************** Compare DY_VOL
    
    DYV_PCT = 0
    if (DYV2 > 0)    
      DYV_PCT = ((DYV1/DYV2) - 1) * 100
    endif
    
    DYTrk1 = LI.1.DY_TRK
    DYTrk2 = LI.2.DY_TRK
    DYTrk_1M2 = DYTrk1 - DYTrk2     ;*************** Compare MD_VOL
    
    DYTrk_PCT = 0
    if (DYTrk2 > 0)    
      DYTrk_PCT = ((DYTrk1/DYTrk2) - 1) * 100
    endif
    
    DYCV1 = LI.1.DY_CV
    DYCV2 = LI.2.DY_CV
    DYCV_1M2 = DYCV1 - DYCV2     ;*************** Compare MD_VOL
    
    DYCV_PCT = 0
    if (DYCV2 > 0)    
      DYCV_PCT = ((DYCV1/DYCV2) - 1) * 100
    endif

    AMVC1    = LI.1.AM_VC
    AMVC2    = LI.2.AM_VC
    AMVC_1M2 = AMVC1 - AMVC2
                               
    AMSPD1    = LI.1.AM_SPD    
    AMSPD2    = LI.2.AM_SPD    
    AMSPD_1M2 = AMSPD1 - AMSPD2

    AMTIME1   = LI.1.AM_TIME
    AMTIME2   = LI.2.AM_TIME
    AMTIME_1M2= AMTIME1 - AMTIME2

    PMVC1    = LI.1.PM_VC
    PMVC2    = LI.2.PM_VC
    PMVC_1M2 = PMVC1 - PMVC2
                               
    PMSPD1    = LI.1.PM_SPD    
    PMSPD2    = LI.2.PM_SPD    
    PMSPD_1M2 = PMSPD1 - PMSPD2

    PMTIME1   = LI.1.PM_TIME
    PMTIME2   = LI.2.PM_TIME
    PMTIME_1M2= PMTIME1 - PMTIME2

  ENDPHASE
  
ENDRUN


*(del TPPL*)
*(del tmp*)
