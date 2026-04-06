
;System
    ;In case TP+ crashes during batch, this will halt process & help identify error.
    *(ECHO model crashed > 05_RemoveManagedLanes.txt)



;get start time
ScriptStartTime = currenttime()




;set controls for which block file to read
if (RunPM1hr=1)
    PM1Y = ' '
else
    PM1Y = ';'
endif




RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI LINKI = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Summary.net'

    FILEO NETO  = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVonlyTMP.net'

    ARRAY _N = 1000000
    ARRAY _X = 1000000
    ARRAY _Y = 1000000

    PHASE = INPUT FILEI = ni.1
        _index     = _index + 1
        _N[_index] = N
        _X[_index] = X
        _Y[_index] = Y
    ENDPHASE
  

    PHASE = LINKMERGE
        if (!(FT == 37-38))  ;delete anything that's not HOV
            delete
        else
            LOOP _ind = 1,_index  ;links do not have XY naturally, so add it in
                if (li.1.A = _N[_ind])
                    AX = _X[_ind]
                    AY = _Y[_ind]
                endif

                if (li.1.B = _N[_ind])
                    BX = _X[_ind]
                    BY = _Y[_ind]
                endif    
            ENDLOOP
        endif    
    ENDPHASE
ENDRUN




; ******************************************************************************
; Purpose:  HOV only
; ******************************************************************************
RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI LINKI = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVonlyTMP.net'

    FILEO NETO  = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVonly.net'

    ARRAY _LA         = 1000000
    ARRAY _LB         = 1000000
    ARRAY _VectorQuad = 1000000
  
    PHASE = INPUT FILEI = li.1
        _index      = _index + 1
        _LA[_index] = A
        _LB[_index] = B
        _Xdif       = BX - AX
        _Ydif       = BY - AY
     
        ;To match HOV and mainline companions, it is necessary to 
        ;identify that each link is generally aimed in the same direction (ID 8 directions)
        if     (_Xdif >= 0 && _Ydif >  0)  
            if (_Ydif <  _Xdif)   _VectorQuad[_index] = 1
            if (_Ydif >= _Xdif)   _VectorQuad[_index] = 2
        elseif (_Xdif <  0 && _Ydif >  0)
            if (-_Ydif <  _Xdif)   _VectorQuad[_index] = 3
            if (-_Ydif >= _Xdif)   _VectorQuad[_index] = 4
        elseif (_Xdif <  0 && _Ydif <= 0)
            if (-_Ydif <  -_Xdif)   _VectorQuad[_index] = 5
            if (-_Ydif >= -_Xdif)   _VectorQuad[_index] = 6
        elseif (_Xdif >  0 && _Ydif <  0)
            if (_Ydif <  -_Xdif)   _VectorQuad[_index] = 7
            if (_Ydif >= -_Xdif)   _VectorQuad[_index] = 8
        endif
    ENDPHASE


	PHASE = LINKMERGE
        LOOP _ind = 1,_index
            if (li.1.A = _LA[_ind] && li.1.B = _LB[_ind])
                VectorQuad = _VectorQuad[_ind]
            endif
        ENDLOOP
    ENDPHASE
ENDRUN




; ******************************************************************************
; Purpose:  Add AX, etc to link data
; ******************************************************************************
:StepFWY
RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI LINKI = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Summary.net'

    FILEO NETO  = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_FwyOnlyTMP.net'
  
    ARRAY _N = 1000000
    ARRAY _X = 1000000
    ARRAY _Y = 1000000

    PHASE = INPUT FILEI = ni.1
        _index     = _index + 1
        _N[_index] = N
        _X[_index] = X
        _Y[_index] = Y
    ENDPHASE


    PHASE = LINKMERGE
        if (!(FT == 20-26,28-36,40-42))  ;Delete anything that's not part of the main freeway system (even HOV)
            delete
        else
            LOOP _ind = 1,_index  ;links do not have XY naturally, so add it in
                if (li.1.A = _N[_ind])
                    AX = _X[_ind]
                    AY = _Y[_ind]
                endif

                if (li.1.B = _N[_ind])
                    BX = _X[_ind]
                    BY = _Y[_ind]
                endif
            ENDLOOP
        endif
    ENDPHASE
ENDRUN




; ******************************************************************************
; Purpose:  Fwy only
; ******************************************************************************
RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI LINKI = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_FwyOnlyTMP.net'

    FILEO NETO  = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_FWYonly.net'
 
    ARRAY _LA         = 1000000
    ARRAY _LB         = 1000000
    ARRAY _VectorQuad = 1000000
  
    PHASE = INPUT FILEI = li.1
        _index      = _index + 1
        _LA[_index] = A
        _LB[_index] = B
        _Xdif       = BX - AX
        _Ydif       = BY - AY
     
     ;To match HOV and mainline companions, it is necessary to 
     ;identify that each link is generally aimed in the same direction (ID 8 directions)
        if (ft = 22-26,32-36)
            if     (_Xdif >= 0 && _Ydif >  0)
                if (_Ydif <  _Xdif)   _VectorQuad[_index] = 1
                if (_Ydif >= _Xdif)   _VectorQuad[_index] = 2
            elseif (_Xdif <  0 && _Ydif >  0)
                if (-_Ydif <  _Xdif)   _VectorQuad[_index] = 3
                if (-_Ydif >= _Xdif)   _VectorQuad[_index] = 4
            elseif (_Xdif <  0 && _Ydif <= 0)
                if (-_Ydif <  -_Xdif)   _VectorQuad[_index] = 5
                if (-_Ydif >= -_Xdif)   _VectorQuad[_index] = 6
            elseif (_Xdif >  0 && _Ydif <  0)
                if (_Ydif <  -_Xdif)   _VectorQuad[_index] = 7
                if (_Ydif >= -_Xdif)   _VectorQuad[_index] = 8
            endif
        endif
    ENDPHASE


    PHASE = LINKMERGE
        if (ft = 22-26,32-36)
            LOOP _ind = 1,_index
                if (li.1.A = _LA[_ind] && li.1.B = _LB[_ind])
                    VectorQuad = _VectorQuad[_ind]
                endif
            ENDLOOP
        endif
    ENDPHASE
ENDRUN




; ******************************************************************************
; Purpose:  Merge the HOV data over to the companion fwy link
; ******************************************************************************
:StepJoin
RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI NETI[1] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_FWYonly.net'
    FILEI NETI[2] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVonly.net'

    FILEO NETO    = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVFWYjoinedTMP.net'

    ARRAY _A             = 1000000
    ARRAY _B             = 1000000
    ARRAY _AX            = 1000000
    ARRAY _BX            = 1000000
    ARRAY _AY            = 1000000
    ARRAY _BY            = 1000000
    ARRAY _VectorQuadHOV = 1000000

    ARRAY _AMVOL         = 1000000
    ARRAY _MDVOL         = 1000000
    ARRAY _PMVOL         = 1000000
    ARRAY _EVVOL         = 1000000
    ARRAY _DYVOL         = 1000000
    ARRAY _AM_VC         = 1000000
    ARRAY _PM_VC         = 1000000

    PHASE = INPUT FILEI = li.2
        _LCount                 = _LCount+1
        _A[_LCount]             = A
        _B[_LCount]             = B
        _AX[_LCount]            = AX
        _AY[_LCount]            = AY
        _BX[_LCount]            = BX
        _BY[_LCount]            = BY
        _AMVOL[_LCount]         = AM_VOL
        _MDVOL[_LCount]         = MD_VOL
        _PMVOL[_LCount]         = PM_VOL
        _EVVOL[_LCount]         = EV_VOL
        _DYVOL[_LCount]         = DY_VOL
        _AM_VC[_LCount]         = AM_VC
        _PM_VC[_LCount]         = PM_VC
        _VectorQuadHOV[_LCount] = VectorQuad
    ENDPHASE


    PHASE = LINKMERGE
        if (li.1.ft = 22-26,32-36)
            LOOP _ind = 1,_LCount

                ;determine the hypotenuse distance between the A of the mainline and A of the HOV link
                _AXmeter = _AX[_ind] - LI.1.AX
                _AYmeter = _AY[_ind] - LI.1.AY
                _AhypotMeter = sqrt(pow(_AXmeter,2) + pow(_AYmeter,2))
                _AhypotMiles = _AhypotMeter / 1609.344  ;miles = meters / meters per mile

                ;determine the hypotenuse distance between the B of the mainline and B of the HOV link
                _BXmeter = _BX[_ind] - LI.1.BX
                _BYmeter = _BY[_ind] - LI.1.BY
                _BhypotMeter = sqrt(pow(_BXmeter,2) + pow(_BYmeter,2))
                _BhypotMiles = _BhypotMeter / 1609.344  ;miles = meters / meters per mile

                ;if links are close and aimed in the same direction, then they can be considered matches.
                ;Some links barely fall into different vector bins, (either horiz., vert., or y=x), so
                ;Check rise over run, if small, must be parallel
                _XdifF = (LI.1.AX - LI.1.BX)
                _YdifF = (LI.1.AY - LI.1.BY)
                if (_YdifF<>0) _XYratF= _XdifF / _YdifF
                if (_XdifF<>0) _YXratF= _YdifF / _XdifF

                _XdifH = (_AX[_ind] - _BX[_ind])
                _YdifH = (_AY[_ind] - _BY[_ind])
                if (_YdifH<>0) _XYratH= _XdifH / _YdifH
                if (_XdifH<>0) _YXratH= _YdifH / _XdifH

                _flagParallel = 0
                if ((_XYratF <= .02) && (_XYratH <= .02))         _flagParallel = 1
                if ((_YXratF <= .02) && (_YXratH <= .02))         _flagParallel = 1

                _tmp = abs( _XYratF - _XYratH)
                ;_AYdif = abs(_AY[_ind] - LI.1.AY)
                ;_BXdif = abs(_BX[_ind] - LI.1.BX)
                ;_BYdif = abs(_BY[_ind] - LI.1.BY)

                if ((_AhypotMiles < .10) && (_BhypotMiles < .10))  ;if A and B of both links are close to each other
                    _flag = 0
                    if (_tmp < .10)  ;if the ratio of slopes is similar
                        _flag = 1
                    elseif (li.1.VectorQuad = _VectorQuadHOV[_ind])  ;if they're in the same general direction
                        _flag = 1
                    elseif (_flagParallel = 1)  ;if they are either vertical or horizontal
                        _flag = 1
                    endif

                    if (_flag = 1)  ; if they passed, write the data from the managed lane to its companion.
                        ;print csv=t, file=tmp2.csv, APPEND=F  form=12.2 list= LI.1.A, LI.1.B, _A[_ind],_B[_ind], _ind, _AhypotMiles, _BhypotMiles, li.1.VectorQuad, _VectorQuadHOV[_ind],  _XYratF, _XYratH, _tmp

                        ; debugging print
                        ;print csv=t, file=tmp2.csv, APPEND=F  form=12.2 list= 
                        ;  LI.1.A, LI.1.B, _A[_ind],_B[_ind], 
                        ;_AhypotMiles, _BhypotMiles, li.1.VectorQuad, _VectorQuadHOV[_ind], 
                        ;LI.1.AX, LI.1.BX, _XdifF,
                        ;LI.1.AY, LI.1.BY, _YdifF, _XYratF,
                        ;_AX[_ind], _BX[_ind], _XdifH, 
                        ;_AY[_ind], _BY[_ind], _YdifH, _XYratH, _tmp  

                        MNGA = _A[_ind]
                        MNGB = _B[_ind]
                        AM_MNG = _AMVOL[_ind]
                        MD_MNG = _MDVOL[_ind]
                        PM_MNG = _PMVOL[_ind]
                        EV_MNG = _EVVOL[_ind]
                        DY_MNG = _DYVOL[_ind]
                        AM_VC_MNG = _AM_VC[_ind]
                        PM_VC_MNG = _PM_VC[_ind]
                    endif
                endif
            ENDLOOP
        endif ;if fwy links
    ENDPHASE
ENDRUN




; ******************************************************************************
; Purpose:  Upon review of the HOVFWYjoinedTMP net, and confirmed to work properly,
; remove the HOV links and update the main volume fields.
; ******************************************************************************
RUN PGM=NETWORK  MSG='Final Assign: remove managed lanes'
    FILEI NETI[1] = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__Summary.net'	
    FILEI NETI[2] = '@ParentDir@@ScenarioDir@Temp\5_AssignHwy\@RID@__Summary_HOVFWYjoinedTMP.net'

    FILEO NETO    = '@ParentDir@@ScenarioDir@5_AssignHwy\2a_Networks\@RID@__MNG_Removed.net',
	    EXCLUDE=Vectorquad, MngA, MngB, AX, AY, BX, BY,
		        AM_VMT, MD_VMT, PM_VMT, EV_VMT, DY_VMT,
		        AM_VHT, MD_VHT, PM_VHT, EV_VHT, DY_VHT,
		        DY_VOL2WY,
		        DY_1K_2WY,
		        byGenPurp_,
            AM_PER,      MD_PER,      PM_PER,      EV_PER,      DY_PER,      @PM1Y@ PM1_PER   ,
            AM_EXT,      MD_EXT,      PM_EXT,      EV_EXT,      DY_EXT,      @PM1Y@ PM1_EXT   ,
            AM_CV ,      MD_CV ,      PM_CV ,      EV_CV ,      DY_CV ,      @PM1Y@ PM1_CV    ,
            AM_TRK,      MD_TRK,      PM_TRK,      EV_TRK,      DY_TRK,      @PM1Y@ PM1_TRK   ,
            AM_TOT_GPR,  MD_TOT_GPR,  PM_TOT_GPR,  EV_TOT_GPR,  DY_TOT_GPR,  @PM1Y@ P1_TOT_GPR,
		        byGenVeh__,
            AM_DA_NON ,  MD_DA_NON ,  PM_DA_NON ,  EV_DA_NON ,  DY_DA_NON ,  @PM1Y@ PM1_DA_NON,
            AM_SR_NON ,  MD_SR_NON ,  PM_SR_NON ,  EV_SR_NON ,  DY_SR_NON ,  @PM1Y@ PM1_SR_NON,
            AM_HOV    ,  MD_HOV    ,  PM_HOV    ,  EV_HOV    ,  DY_HOV    ,  @PM1Y@ PM1_HOV   ,
            AM_TOL    ,  MD_TOL    ,  PM_TOL    ,  EV_TOL    ,  DY_TOL    ,  @PM1Y@ PM1_TOL   ,
            AM_TOT_GVH,  MD_TOT_GVH,  PM_TOT_GVH,  EV_TOT_GVH,  DY_TOT_GVH   @PM1Y@, P1_TOT_GVH
            

    MERGE RECORD = F


    PHASE = LINKMERGE
        if (li.1.ft = 37-39)
            delete
        else
            AM_GP  = li.1.AM_VOL
            MD_GP  = li.1.MD_VOL
            PM_GP  = li.1.PM_VOL
            EV_GP  = li.1.EV_VOL
            DY_GP  = li.1.DY_VOL

            AM_MNG = li.2.AM_MNG
            MD_MNG = li.2.MD_MNG
            PM_MNG = li.2.PM_MNG
            EV_MNG = li.2.EV_MNG
            DY_MNG = li.2.DY_MNG

            AM_VOL = li.1.AM_VOL + li.2.AM_MNG
            MD_VOL = li.1.MD_VOL + li.2.MD_MNG
            PM_VOL = li.1.PM_VOL + li.2.PM_MNG
            EV_VOL = li.1.EV_VOL + li.2.EV_MNG
            DY_VOL = li.1.DY_VOL + li.2.DY_MNG
            
            if (li.2.DY_MNG>0)  DY_1K = ROUND(DY_VOL/1000)

            ;Compute capture rate (those who used HOV lanes as a share of those eligible - note: doesn't apply when TOL is the option because "eligible" is everyone)
            if (li.2.AM_MNG > 0) AM_HOVPCTE = round((li.2.AM_MNG / (li.2.AM_MNG + li.1.AM_SR_NON))*100)/100
            if (li.2.PM_MNG > 0) PM_HOVPCTE = round((li.2.PM_MNG / (li.2.PM_MNG + li.1.PM_SR_NON))*100)/100

            AM_VC_MNG = li.2.AM_VC_MNG
            PM_VC_MNG = li.2.PM_VC_MNG
        endif
    ENDPHASE
ENDRUN




;print timestamp
RUN PGM=MATRIX
    
    ZONES = 1
    
    ScriptEndTime = currenttime()
    ScriptRunTime = ScriptEndTime - @ScriptStartTime@
    
    PRINT FILE='@ParentDir@@ScenarioDir@_Log\_RunTime - @RID@.txt',
        APPEND=T,
        LIST='\n    Remove Managed Lanes               ', formatdatetime(@ScriptStartTime@, 40, 0, 'yyyy-mm-dd,  hh:nn:ss'), 
                 ',  ', formatdatetime(ScriptRunTime, 40, 0, 'hhh:nn:ss')
    
ENDRUN




*(del 05_RemoveManagedLanes.txt)
