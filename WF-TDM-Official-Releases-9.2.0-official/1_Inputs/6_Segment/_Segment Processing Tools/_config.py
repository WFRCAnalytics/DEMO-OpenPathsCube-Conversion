# segments
fnWfSegments  = 'data/Segments/WFv910_Segments.shp'

# master network link shapefile
fnWfTdm = 'data/MasterNet/WFv901_MasterNet.shp'

fnExemptionsNotInTdm = 'params/segid-exemptions-notInTdm.csv'
fnExemptionsNotInSegments = 'params/segid-exemptions-notInSegments.csv'

countiesService = 'https://services1.arcgis.com/99lidPhWCzftIe9K/arcgis/rest/services/UtahCountyBoundaries/FeatureServer/0/query'

aadtUnroundedService = "https://services.arcgis.com/pA2nEVnB6tquxgOW/ArcGIS/rest/services/AADT_Unrounded/FeatureServer/1/query"
utmzone12n = 26912 # NAD83 / UTM zone 12N

# wasastch front tdm
utm_x_min = 383000
utm_x_max = 507000
utm_y_min = 4405000
utm_y_max = 4606000

# max join distance (meters)
maxjoindistance = 2

geoKeysByCounty = {
     3: {'CO_NAME': 'Box Elder' , 'SUBAREAID': 1, 'PLANAREA':'WFRC'},
    11: {'CO_NAME': 'Davis'     , 'SUBAREAID': 1, 'PLANAREA':'WFRC'},
    23: {'CO_NAME': 'Juab'      , 'SUBAREAID': 1, 'PLANAREA':'MAG' }, # one MAG segment in Juab!
    35: {'CO_NAME': 'Salt Lake' , 'SUBAREAID': 1, 'PLANAREA':'WFRC'},
    49: {'CO_NAME': 'Utah'      , 'SUBAREAID': 1, 'PLANAREA':'MAG' },
    57: {'CO_NAME': 'Weber'     , 'SUBAREAID': 1, 'PLANAREA':'WFRC'}
}

fnFactorGeos = '../Factor_Geographies/WFv900_FactorGeographies.shp'
fnTaz = '../../1_TAZ/WFv900_TAZ.shp'
fnUrbanizationCsv = 'data/Urbanization/Urbanization.csv' # use base year
fnWfTdmCsv = 'data/MasterNet/WFv910_MasterNet.csv'

fnCcsFactors                             = 'data/Factors/CCS_Factors_AllGroupings.csv'
fnCCSFactorsGeoAtypeVolLookup            = 'data/Factors/CCSFactors_GeoAtypeVol_Lookup.csv'
fnVolumeGroups                           = 'data/Factors/params/volume_groups.csv'
fnFacGrpVolClassToVolGrp                 = 'data/Factors/params/facgroup_volume_class_to_volume_group.csv'
fnStationGrpToFacGrpFields               = 'data/Factors/params/station_group_to_facgroup.csv'
fnStationGrpToFacGrpFieldsFacGeoOverride = 'data/Factors/params/station_group_to_facgroup_facgeo_overrides.csv'
fnFacATGrpToAreaType                     = 'data/Factors/params/area_type_group_to_area_type.csv'
fnATOverride                             = 'data/Factors/params/area_type_overrides_segments.csv'
fnFTGroupOverride                        = 'data/Factors/params/functional_type_group_overrides.csv'
fnInterpolate                            = 'data/Factors/params/segment_factors_interpolate.csv'

dFactorGroupsToPublish = {
                           'SEASONGROUP': ['Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'Year'     ,'M01-Jan'  ,'M02-Feb'  ,'M03-Mar'  ,'M04-Apr'  ,'M05-May'  ,'M06-Jun'  ,'M07-Jul'  ,'M08-Aug'  ,'M09-Sep'  ,'M10-Oct'  ,'M11-Nov'  ,'M12-Dec'  ,'S01-Winter','S02-Spring','S03-Summer','S04-Fall' ,'Year'     ,'Year'     ],
                           'YEARGROUP'  : ['2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019','2015-2019' ,'2015-2019' ,'2015-2019' ,'2015-2019','2015-2019','2015-2019'],
                           'FACTORNAME' : ['FAC_MON'  ,'FAC_TUE'  ,'FAC_WED'  ,'FAC_THU'  ,'FAC_FRI'  ,'FAC_SAT'  ,'FAC_SUN'  ,'FAC_WDAVG','FAC_WEAVG','FAC_WEMAX','FAC_JAN'  ,'FAC_FEB'  ,'FAC_MAR'  ,'FAC_APR'  ,'FAC_MAY'  ,'FAC_JUN'  ,'FAC_JUL'  ,'FAC_AUG'  ,'FAC_SEP'  ,'FAC_OCT'  ,'FAC_NOV'  ,'FAC_DEC'  ,'FAC_WIN'   ,'FAC_SPR'   ,'FAC_SUM'   ,'FAC_FAL'  ,'FAC_MAXMO','FAC_MAX'  ]
                         }

dStationGroupsToPublish = {'STATIONGROUP': ['CO0',
                                            'CO1',
                                            'CO2',
                                            'CO3',
                                            'CO7',
                                            'CO4',
                                            'CO5',
                                            'CO6',
                                            'CO8',
                                            'CO9',
                                            'COA',
                                            'COB',
                                            'COC',
                                            'COD',
                                            'COY',
                                            'COE',
                                            'COZ',
                                            'COF',
                                            'COG',
                                            'COH',
                                            'COI',
                                            'COJ',
                                            'COK',
                                            'COL',
                                            'COM',
                                            'CON',
                                            'COO',
                                            'COP',
                                            'COQ',
                                            'COR',
                                            'COS',
                                            'COT',
                                            'COU',
                                            'XX3',
                                            'COV',
                                            'COW',
                                            'COX']}