# Description:
#     This script converts the following files to geogson in order to view in the vizTool
#         - TAZ
#         - Segments
#         - Districts (Small, Medium, Large, Super)
#         - Subarea
#
#     Date Edited: 08/15/2024


# ============================================================================================================
# System setup
# ============================================================================================================
print("\nRunning Python Script: 'vt_CreateGeoJsons.py'")
print("\n\nSystem setup...")
print("\n    load python libraries")

import time
time_begin = time.time()
time_begin_SysSetup = time.time()
import os, sys, traceback
import importlib.machinery
from dbfread import DBF
import geopandas as gpd
import shapely
from filelock import FileLock, Timeout
from shapely.geometry import LineString, MultiLineString, Point, Polygon, MultiPolygon
import pandas as pd
import json
from pathlib import Path

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)
import _global_scripts as gs


# ============================================================================================================
# Debug Setup and Launch Location (LAUNCH LOCATION SHOULD BE MOVED TO ARGUMENT OF PYTHON CALL)
# ============================================================================================================
debug = False
#debug = True

if not debug:
    dir_ScriptLaunch = os.getcwd()
else:
    dir_ScriptLaunch = r"Z:\GitHub\WF-TDM-v9x\Scenarios\v910_20241007\BY_2019"

# ----------------------------------------------------------------------------------------
# Define Functions
# ----------------------------------------------------------------------------------------
print("\n    define functions")

# function that reads in shapefile and saves it to a geodataframe
def read_in_shp(shp_path):
    gdf = gpd.read_file(shp_path)
    return gdf

def dissolve_gdf(gdf, id_field, other_fields=None):

    if other_fields:
        # If other_fields is single field, convert to list
        if not isinstance(other_fields, list):
            other_fields = [other_fields]
        for field in other_fields:
            gdf[f'first_{field}'] = gdf.groupby(id_field)[field].transform('first')
        gdf = gdf[[id_field] + [f'first_{field}' for field in other_fields] + ['geometry']]

        # Dissolve by the specified field
        dissolved = gdf.dissolve(by=id_field).reset_index()

        # Rename the 'first_other_field' columns back to original names
        dissolved.rename(columns={f'first_{field}': field for field in other_fields}, inplace=True)

    else:
        # Dissolve based on one field
        gdf = gdf[[id_field,'geometry']]
        dissolved = gdf.dissolve(by=id_field).reset_index()

    return dissolved

# function that converts a geodataframe to geojson format
def create_geojson(gdf, geojson_path, tolerance=0.0001):
    
    # lock file to allow running scripts concurrently
    lock = FileLock(f"{geojson_path}.lock", timeout=10)
    
    # get just the filename for logging
    geojson_filename = Path(geojson_path).name

    # wait to acquire the lock
    try:
        with lock:
            print(f"\n        Acquired lock. Proceeding to create GeoJSON: " + geojson_filename)
            logFile.write(f"\n        Acquired lock. Proceeding to create GeoJSON " + geojson_filename)
            gdf = gdf.to_crs(epsg=4326)
            gdf['geometry'] = gdf['geometry'].simplify(tolerance, preserve_topology=True)
            gdf.to_file(geojson_path, driver='GeoJSON')
    except Timeout:
        print(f"\n        Failed to acquire lock. The file may be in use by another process: " + geojson_filename)
        logFile.write(f"\n        Failed to acquire lock. The file may be in use by another process: " + geojson_filename)



# calculate elapsed time
time_end_SysSetup = time.time()
gs.printElapsedTime(time_end_SysSetup, time_begin_SysSetup)



try:
    
    # ============================================================================================================
    # Global Parameters
    # ============================================================================================================
    print("\n\nSpecifying Global Parameters & Input-Output Files...")
    
    # get time (in seconds) 
    time_begin_GlobalParam = time.time()
    
    # ----------------------------------------------------------------------------------------
    # specify global parameters
    # ----------------------------------------------------------------------------------------
    in_GlobalVar_txt     = "py_Variables - vt_JsonVars.txt"
    out_Log_txt          = "py_LogFile - vt_CreateGeoJsons.txt"
    out_Filenames_csv    = "py_FileNames - vt_GeoJsons.csv"
    
    # create path to global variables input file
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, "_Log", in_GlobalVar_txt)
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()

    # create global parameters
    ParentDir    = GlobalVars.ParentDir
    ScenarioDir  = GlobalVars.ScenarioDir
    ModelVersion = GlobalVars.ModelVersion
    
    # create global inputs
    in_TAZ_shp_name       = GlobalVars.TAZ_DBF.replace(".dbf", ".shp")
    in_Segments_shp_name  = GlobalVars.Segments_DBF.replace(".dbf", ".shp")
    TAZ_Geo_Name          = in_TAZ_shp_name.replace(".shp", "")
    Segments_Geo_Name     = in_Segments_shp_name.replace(".shp", "")
    
    #define vizTool scripts path
    vizscripts_path = ParentDir + "2_ModelScripts\_Python\py-vizTool"
    
    
    # ----------------------------------------------------------------------------------------
    # set input/output paths
    # ----------------------------------------------------------------------------------------
    #set input paths
    in_TAZ_SHP          = os.path.join(ParentDir, r"1_Inputs\1_TAZ", in_TAZ_shp_name)
    in_Segments_SHP     = os.path.join(ParentDir, r"1_Inputs\6_Segment", in_Segments_shp_name)
    in_corridors_folder = os.path.join(ParentDir, r"1_Inputs\6_Segment\\Corridors")

    # set output paths
    out_folder = os.path.join(ParentDir, r"Scenarios\\.vizTool\\geo-data\\")

    out_TAZ_GEO           = os.path.join(out_folder + TAZ_Geo_Name                           + ".geojson")
    out_DSML_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__DSML"           + ".geojson")
    out_DMED_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__DMED"           + ".geojson")
    out_DLRG_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__DLRG"           + ".geojson")
    out_DSUP_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__DSUP"           + ".geojson")
    out_PLAN_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__PLAN"           + ".geojson")
    out_SAID_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__SAID"           + ".geojson")
    out_CITY_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__CITY"           + ".geojson")
    out_CTGP_GEO          = os.path.join(out_folder + TAZ_Geo_Name      + "__CTGP"           + ".geojson")
    out_STOP_GEO          = os.path.join(out_folder + Segments_Geo_Name + "__STOP"           + ".geojson")
    out_SEG_GEO           = os.path.join(out_folder + Segments_Geo_Name                      + ".geojson")


    # set output paths
    key_folder = os.path.join(ParentDir, r"Scenarios\\.vizTool\\geo-data\\keys\\")

    out_STOP_KEY          = os.path.join(key_folder + Segments_Geo_Name + "__STOP_KEY"       +     ".csv")
    out_TAZ_DSML_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML_KEY"       +    ".json")
    out_TAZ_DMED_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__DMED_KEY"       +    ".json")
    out_TAZ_DLRG_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__DLRG_KEY"       +    ".json")
    out_TAZ_DSUP_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__DSUP_KEY"       +    ".json")
    out_TAZ_PLAN_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__PLAN_KEY"       +    ".json")
    out_TAZ_SAID_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__SAID_KEY"       +    ".json")
    out_TAZ_CITY_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__CITY_KEY"       +    ".json")
    out_TAZ_CTGP_KEY      = os.path.join(key_folder + TAZ_Geo_Name      + "__CTGP_KEY"       +    ".json")
    out_TAZ_DSML_DMED_KEY = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML__DMED_KEY" +    ".json")
    out_TAZ_DSML_DLRG_KEY = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML__DLRG_KEY" +    ".json")
    out_TAZ_DSML_DSUP_KEY = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML__DSUP_KEY" +    ".json")
    out_TAZ_DSML_PLAN_KEY = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML__PLAN_KEY" +    ".json")
    out_TAZ_DSML_SAID_KEY = os.path.join(key_folder + TAZ_Geo_Name      + "__DSML__SAID_KEY" +    ".json")
    out_SEG_KEY           = os.path.join(key_folder + Segments_Geo_Name + "_KEY"             +    ".json")
    out_SEG_TAZ_KEY       = os.path.join(key_folder + Segments_Geo_Name + "__TAZ_KEY"        +    ".json")
    out_SEG_DSML_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__DSML_KEY"       +    ".json")
    out_SEG_DMED_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__DMED_KEY"       +    ".json")
    out_SEG_DLRG_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__DLRG_KEY"       +    ".json")
    out_SEG_DSUP_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__DSUP_KEY"       +    ".json")
    out_SEG_PLAN_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__PLAN_KEY"       +    ".json")
    out_SEG_SAID_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__SAID_KEY"       +    ".json")
    out_SEG_CITY_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__CITY_KEY"       +    ".json")
    out_SEG_CTGP_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__CTGP_KEY"       +    ".json")
    out_STOP_TAZ_KEY      = os.path.join(key_folder + Segments_Geo_Name + "__STOP__TAZ_KEY"  +    ".json")
    out_STOP_DSML_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__DSML_KEY" +    ".json")
    out_STOP_DMED_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__DMED_KEY" +    ".json")
    out_STOP_DLRG_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__DLRG_KEY" +    ".json")
    out_STOP_DSUP_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__DSUP_KEY" +    ".json")
    out_STOP_PLAN_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__PLAN_KEY" +    ".json")
    out_STOP_SAID_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__SAID_KEY" +    ".json")
    out_STOP_CITY_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__CITY_KEY" +    ".json")
    out_STOP_CTGP_KEY     = os.path.join(key_folder + Segments_Geo_Name + "__STOP__CTGP_KEY" +    ".json")

    print("\n    create output folder if needed")
    os.makedirs(out_folder,     exist_ok=True)
    
    # begin Log file
    path_out_Log_txt = os.path.join(ParentDir, ScenarioDir, "_Log", out_Log_txt)
    logFile = open(path_out_Log_txt, 'w')
    
    # calculate elapsed time
    logFile.write("\nRunning Python Script: 'vt_CreateGeoJsons.py'")

    if debug:
        print("\n--------------------------------------------------------------------------------------")
        print("DEBUG MODE ON... IF RUNNING ACTUAL MODEL, PLEASE TURN OFF DEBUG MODE IN PYTHON SCRIPT!")
        print("--------------------------------------------------------------------------------------")

        logFile.write("\n--------------------------------------------------------------------------------------")
        logFile.write("DEBUG MODE ON... IF RUNNING ACTUAL MODEL, PLEASE TURN OFF DEBUG MODE IN PYTHON SCRIPT!")
        logFile.write("--------------------------------------------------------------------------------------")

        time.sleep(10)  # Pause for 10 seconds

    logFile.write("\n\nSystem setup...")
    logFile.write("\n    load python libraries")
    logFile.write("\n    define functions")
    gs.logElapsedTime(time_end_SysSetup, time_begin_SysSetup, logFile)

    logFile.write("\n\nSpecifying Global Parameters & Input-Output Files...")
    logFile.write("\n    create output folder if needed")
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    # write out filenames for use in other scripts
    pd.DataFrame([
        ["stopkey" , out_STOP_KEY     ]
    ], columns=(["fileCode", "filename"])).to_csv(os.path.join(ParentDir, ScenarioDir, "_Log", out_Filenames_csv), index=False)
    
    # ============================================================================================================
    # Create and Save Geojsons
    # ============================================================================================================
    # print to console & log file
    print("\n\nSaving TAZ Geodataframes as Geojsons...")
    logFile.write("\n\nSaving TAZ Geodataframes as Geojsons...")

    # get time (in seconds)
    time_begin_Geojsons = time.time()
    
    # Perform the conversions
    print("\n    convert and save TAZ Geojson")
    logFile.write("\n    convert and save TAZ Geojson")
    taz_gdf  = read_in_shp(in_TAZ_SHP)
    create_geojson(taz_gdf[['TAZID','geometry']], out_TAZ_GEO)
    
    print("\n    dissolve then save Small Districts Geojson")
    logFile.write("\n    dissolve then save Small Districts Geojson")
    # Small districts has more fields, because small districts will serve as base geometry for OD data (instead of TAZ). CITY_NAME is excluded because it is the only one that doesn't nest.
    dsml_gdf = dissolve_gdf(taz_gdf, "DISTSML", ["DSML_NAME","DISTMED","DISTLRG","DISTSUPER","PLANAREA","SUBAREAID"])
    create_geojson(dsml_gdf[['DISTSML','DSML_NAME','geometry']], out_DSML_GEO)
    
    print("\n    dissolve then save Medium Districts Geojson")
    logFile.write("\n    dissolve then save Medium Districts Geojson")
    dmed_gdf = dissolve_gdf(taz_gdf, "DISTMED", "DMED_NAME")
    create_geojson(dmed_gdf, out_DMED_GEO)
    
    print("\n    dissolve then save Large Districts Geojson")
    logFile.write("\n    dissolve then save Large Districts Geojson")
    dlrg_gdf = dissolve_gdf(taz_gdf, "DISTLRG", "DLRG_NAME")
    create_geojson(dlrg_gdf, out_DLRG_GEO)
    
    print("\n    dissolve then save Super Districts Geojson")
    logFile.write("\n    dissolve then save Super Districts Geojson")
    dsup_gdf = dissolve_gdf(taz_gdf, "DISTSUPER", "DSUP_NAME")
    create_geojson(dsup_gdf, out_DSUP_GEO)
    
    print("\n    dissolve then save City Geojson")
    logFile.write("\n    dissolve then save City Geojson")
    city_gdf = dissolve_gdf(taz_gdf, "CITY_NAME")
    create_geojson(city_gdf, out_CITY_GEO)
    
    print("\n    dissolve then save Plan Area Geojson")
    logFile.write("\n    dissolve then save Plan Area Geojson")
    plan_gdf = dissolve_gdf(taz_gdf, "PLANAREA")
    create_geojson(plan_gdf, out_PLAN_GEO)
    
    print("\n    dissolve then save City Group Geojson")
    logFile.write("\n    dissolve then save City Group Geojson")
    ctgp_gdf = dissolve_gdf(taz_gdf, "CITYGRP")
    create_geojson(ctgp_gdf, out_CTGP_GEO)
    
    print("\n    dissolve then save Subarea Geojson")
    logFile.write("\n    dissolve then save Subareas Geojson")
    said_gdf = dissolve_gdf(taz_gdf, "SUBAREAID")
    create_geojson(said_gdf, out_SAID_GEO)

    # Export key JSONs
    taz_gdf [['TAZID'  ,'DISTSML'  ]].to_json(out_TAZ_DSML_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'DISTMED'  ]].to_json(out_TAZ_DMED_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'DISTLRG'  ]].to_json(out_TAZ_DLRG_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'DISTSUPER']].to_json(out_TAZ_DSUP_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'PLANAREA' ]].to_json(out_TAZ_PLAN_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'SUBAREAID']].to_json(out_TAZ_SAID_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'CITY_NAME']].to_json(out_TAZ_CITY_KEY     , orient="records", indent=2)
    taz_gdf [['TAZID'  ,'CITYGRP'  ]].to_json(out_TAZ_CTGP_KEY     , orient="records", indent=2)
    dsml_gdf[['DISTSML','DISTMED'  ]].to_json(out_TAZ_DSML_DMED_KEY, orient="records", indent=2)
    dsml_gdf[['DISTSML','DISTLRG'  ]].to_json(out_TAZ_DSML_DLRG_KEY, orient="records", indent=2)
    dsml_gdf[['DISTSML','DISTSUPER']].to_json(out_TAZ_DSML_DSUP_KEY, orient="records", indent=2)
    dsml_gdf[['DISTSML','PLANAREA' ]].to_json(out_TAZ_DSML_PLAN_KEY, orient="records", indent=2)
    dsml_gdf[['DISTSML','SUBAREAID']].to_json(out_TAZ_DSML_SAID_KEY, orient="records", indent=2)

    # calculate elapsed time
    time_end_Geojsons = time.time()
    gs.printElapsedTime(time_end_Geojsons, time_begin_Geojsons)
    gs.logElapsedTime(time_end_Geojsons, time_begin_Geojsons, logFile)

    
    # ============================================================================================================
    # Create Segments and Stops Geojsons
    # ============================================================================================================
    # print to console & log file
    print("\nSaving Segment Geodataframe as Geojson and Generating Stops Geojson...")
    logFile.write("\n\nSaving Segment Geodataframe as Geojson and Generating Stops Geojson...")

    # get time (in seconds)
    time_begin_Stops = time.time()

    print("\n    convert and save Segments Geojson")
    logFile.write("\n    convert and save Segments Geojson")

    seg_gdf  = read_in_shp(in_Segments_SHP)
    seg_gdf = seg_gdf[["SEGID","geometry"]]

    # Join with TAZ to get ID fields
    seg_gdf['midpoint'] = seg_gdf.geometry.interpolate(0.5, normalized=True)
    midpoint_gdf = gpd.GeoDataFrame(seg_gdf.drop(columns='geometry'), geometry=seg_gdf['midpoint'])
    midpoint_with_taz_gdf = gpd.sjoin(midpoint_gdf, taz_gdf, how='left', predicate='within')
    seg_with_taz_gdf = seg_gdf.merge(midpoint_with_taz_gdf.drop(columns='geometry'), on='SEGID', how='left')
    
    # Export key JSONs
    seg_with_taz_gdf[['SEGID','TAZID'    ]].to_json(out_SEG_TAZ_KEY , orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','DISTSML'  ]].to_json(out_SEG_DSML_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','DISTMED'  ]].to_json(out_SEG_DMED_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','DISTLRG'  ]].to_json(out_SEG_DLRG_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','DISTSUPER']].to_json(out_SEG_DSUP_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','PLANAREA' ]].to_json(out_SEG_PLAN_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','SUBAREAID']].to_json(out_SEG_SAID_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','CITY_NAME']].to_json(out_SEG_CITY_KEY, orient="records", indent=2)
    seg_with_taz_gdf[['SEGID','CITYGRP'  ]].to_json(out_SEG_CTGP_KEY, orient="records", indent=2)

    # Export Segment GeoJSON
    seg_gdf = seg_gdf.drop(columns=(['midpoint']))
    create_geojson(seg_gdf, out_SEG_GEO)

    print("\n    generate and save Segments Stop Geojson")
    logFile.write("\n    generate and save Segments Stop Geojson")

    # project to local crs for calcs
    seg_gdf = seg_gdf.to_crs(epsg=26912)

    end_locations_to_directions_df = pd.DataFrame([
        ["E","WB"],
        ["W","EB"],
        ["N","SB"],
        ["S","NB"]
    ], columns=("END_LOCATION","DIRECTION"))

    # Function to determine DIRECTION endpoints for a LineString or MultiLineString
    def get_endpoints_with_end_point_location(row):
        def extract_endpoints(geometry, SEGID):
            endpoints = []
            start_coords = geometry.coords[0]
            end_coords = geometry.coords[-1]
            start = Point(start_coords)
            end = Point(end_coords)
            
            # East-West DIRECTION
            if start_coords[0] < end_coords[0]:
                endpoints.append((start, f"{SEGID}__W"))
                endpoints.append((end, f"{SEGID}__E"))
            else:
                endpoints.append((end, f"{SEGID}__W"))
                endpoints.append((start, f"{SEGID}__E"))
            
            # North-South DIRECTION
            if start_coords[1] < end_coords[1]:
                endpoints.append((start, f"{SEGID}__S"))
                endpoints.append((end, f"{SEGID}__N"))
            else:
                endpoints.append((end, f"{SEGID}__S"))
                endpoints.append((start, f"{SEGID}__N"))
            
            return endpoints

        SEGID = row['SEGID']
        geometry = row.geometry
        endpoints = []

        if isinstance(geometry, LineString):
            endpoints = extract_endpoints(geometry, SEGID)
        elif isinstance(geometry, MultiLineString):
            for line in geometry.geoms:
                endpoints.extend(extract_endpoints(line, SEGID))

        return endpoints

    # Extract endpoints from each geometry with end location information
    endpoints = []
    for idx, row in seg_gdf.iterrows():
        endpoints.extend(get_endpoints_with_end_point_location(row))

    # Create a DataFrame for endpoints
    endpoints_df = pd.DataFrame(endpoints, columns=['geometry', 'SEG_END'])
    endpoints_gdf = gpd.GeoDataFrame(endpoints_df, geometry='geometry', crs=seg_gdf.crs)

    def round_to_nearest_20_meters(x, y):
        rounded_x = round(x / 20) * 20
        rounded_y = round(y / 20) * 20
        return rounded_x, rounded_y

    # Apply the rounding function to each geometry
    endpoints_gdf['geometry'] = endpoints_gdf['geometry'].apply(
        lambda point: Point(round_to_nearest_20_meters(point.x, point.y))
    )

    # Apply the rounding function and create the 'x_y' ID
    endpoints_gdf['STOPID'] = endpoints_gdf['geometry'].apply(
        lambda geom: (int(geom.x), int(geom.y))
    )
    endpoints_gdf['STOPID'] = endpoints_gdf['STOPID'].apply(
        lambda coords: f"{coords[0]}_{coords[1]}"
    )

    endpoints_df = endpoints_gdf.drop(columns=(['geometry']))

    # Create stops_gdf by dropping duplicates based on 'STOPID'
    stops_gdf = endpoints_gdf.drop(columns=(['SEG_END'])).drop_duplicates(subset=['STOPID']).reset_index(drop=True)

    # Spatial Join to TAZs to get aggregation fields

    # Perform the initial spatial join
    stops_with_taz_gdf = gpd.sjoin(stops_gdf, taz_gdf, how='left', predicate='within')

    # Identify stops with no TAZ (null values)
    null_stops = stops_with_taz_gdf[stops_with_taz_gdf['TAZID'].isnull()].copy()  # Use .copy() to ensure it's a new DataFrame

    # If there are any nulls, find nearest TAZ for those stops
    if not null_stops.empty:
        # Use spatial index for efficient nearest-neighbor search
        taz_gdf['geometry_centroid'] = taz_gdf.geometry.centroid
        null_stops['geometry_centroid'] = null_stops.geometry.centroid
        
        # Iterate over each stop with no TAZ and find the nearest TAZ
        for idx, stop in null_stops.iterrows():
            # Compute distances to all TAZ centroids and find the nearest one
            distances = taz_gdf['geometry_centroid'].distance(stop['geometry_centroid'])
            nearest_taz_index = distances.idxmin()
            nearest_taz = taz_gdf.loc[nearest_taz_index]
            
            # Update the row in the original DataFrame using the original index with .loc
            original_idx = stop.name
            for field in ['TAZID', 'DISTSML', 'DISTMED', 'DISTLRG', 'DISTSUPER', 'DSUP_NAME', 'CITY_NAME', 'PLANAREA', 'SUBAREAID']:
                stops_with_taz_gdf.loc[original_idx, field] = nearest_taz[field]

    # Clean up by dropping centroid columns
    stops_with_taz_gdf.drop(columns=['geometry_centroid'], inplace=True, errors='ignore')
    taz_gdf.drop(columns=['geometry_centroid'], inplace=True, errors='ignore')

    # Export key JSONs
    stops_with_taz_gdf[['STOPID','TAZID'    ]].to_json(out_STOP_TAZ_KEY , orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','DISTSML'  ]].to_json(out_STOP_DSML_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','DISTMED'  ]].to_json(out_STOP_DMED_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','DISTLRG'  ]].to_json(out_STOP_DLRG_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','DISTSUPER']].to_json(out_STOP_DSUP_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','PLANAREA' ]].to_json(out_STOP_PLAN_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','SUBAREAID']].to_json(out_STOP_SAID_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','CITY_NAME']].to_json(out_STOP_CITY_KEY, orient="records", indent=2)
    stops_with_taz_gdf[['STOPID','CITYGRP'  ]].to_json(out_STOP_CTGP_KEY, orient="records", indent=2)

    # export geojson
    create_geojson(stops_with_taz_gdf[['STOPID','geometry']], out_STOP_GEO)

    # print to console & log file
    print("\n    create Stops Key Csv...")
    logFile.write("\n    create Stops Key Csv...")

    endpoints_df[['SEGID','END_LOCATION']] = endpoints_df['SEG_END'].str.rsplit('__',expand=True)
    endpoints_df_with_direction = pd.merge(endpoints_df.drop(columns=['SEG_END']), end_locations_to_directions_df, on="END_LOCATION").drop(columns=["END_LOCATION"])

    endpoints_df_with_direction.rename(columns={'SEGID':'SegID','DIRECTION':'Direction'}, inplace=True)

    # Save the DataFrame to a CSV file
    endpoints_df_with_direction.to_csv(out_STOP_KEY, index=False)
    
    # ============================================================================================================
    # Create Corridors
    # ============================================================================================================
    # print to console & log file
    print("\n    create Corridors geojson...")
    logFile.write("\n    create Corridors geojson...")
    
    # Load JSON configuration
    with open(vizscripts_path + "\\configs\\corridors.json") as f:
        corridors_data = json.load(f)

    # Load segments_gdf (your segment polylines data)
    seg_gdf = seg_gdf.to_crs(epsg=26912)  # Convert to EPSG:26912
    stops_gdf = stops_gdf.to_crs(epsg=26912)  # Convert to EPSG:26912

    # Process each corridor group and file
    for corridor_group in corridors_data:

        # Initialize list to store processed GeoDataFrames
        all_segments_joined_to_corridors = []
        all_corridors = []

        all_stops_joined_to_corridors = []

        corridor_group_id = corridor_group['corridorGroupId']
        corridor_group_alias = corridor_group['alias']

        print("\n        create " + corridor_group_alias + " Geojsons")
        logFile.write("\n        create " + corridor_group_alias + " Geojsons")
        
        for file_info in corridor_group['files']:
            filename = os.path.join(in_corridors_folder, file_info['filename'])
            buffer_dist               = file_info.get('bufferDistMeters', 20) # Default to 20 if not specified
            corridor_id_field         = file_info.get('idField'         , '') # Get key field name
            corridor_label_expression = file_info.get('labelExpression' , '') # Get label expression to be unpacked
            filter_condition          = file_info.get('filter'          , '') # Optional filter
            filepath = Path(filename)
            
            # Check if file exists
            if filepath.is_file():
                # Load file based on its type
                if filepath.suffix == '.geojson' or filepath.suffix == '.shp':
                    gdf = gpd.read_file(filename)
                    
                    # Convert CRS to EPSG:26912
                    gdf = gdf.to_crs(epsg=26912)
                    
                    value_field = corridor_group_id + "_ID"
                    label_field = corridor_group_id + "_NAME"
                    
                    # Create label field
                    gdf[label_field] = gdf.apply(lambda row: corridor_label_expression.format(**row), axis=1)

                    # Rename value field
                    gdf = gdf.rename(columns={corridor_id_field: value_field})

                    # Apply filter if specified
                    if filter_condition:
                        gdf = gdf.query(filter_condition)

                    # reduce columns
                    gdf = gdf[[value_field, label_field, 'geometry']]

                    # keep an array of corridors
                    all_corridors.append(gdf)

                    # Buffer by the specified distance (creating a temporary buffer geometry)
                    gdf_buffered = gdf.copy()
                    gdf_buffered['geometry'] = gdf.buffer(buffer_dist)

                    # Debug output
                    if debug:
                        gdf_buffered.to_crs(epsg=4326).to_file(filepath.stem + '_temp.geojson', driver="GeoJSON")

                    # Spatial join: find all segments fully contained within each buffered feature
                    joined_gdf = gpd.sjoin(seg_gdf, gdf_buffered, how='inner', predicate='within')
                    joined_stops_gdf = gpd.sjoin(stops_gdf, gdf_buffered, how='inner', predicate='within')

                    # Reduce columns to include only desired fields
                    joined_df = joined_gdf[['SEGID', value_field]]
                    joined_stops_df = joined_stops_gdf[['STOPID', value_field]]

                    # Append joined GeoDataFrame to the list
                    all_segments_joined_to_corridors.append(joined_df)
                    all_stops_joined_to_corridors.append(joined_stops_df)
                else:
                    print(f"Unsupported file type for {filename}. Skipping.")
            else:
                print(f"File {filename} not found.")

        if all_segments_joined_to_corridors != [] and all_corridors != []:

            # Concatenate all processed features into a single GeoDataFrame
            all_segments_joined_to_corridors_df = pd.DataFrame(pd.concat(all_segments_joined_to_corridors, ignore_index=True))
            merged_corridors_gdf = gpd.GeoDataFrame(pd.concat(all_corridors, ignore_index=True), geometry="geometry")

            out_filename_segment_corridors_key = os.path.join(key_folder, f"{Segments_Geo_Name}__CORR_{corridor_group_id}_KEY.json")
            out_filename_corridors = os.path.join(out_folder, f"{Segments_Geo_Name}__CORR_{corridor_group_id}.geojson")

            all_segments_joined_to_corridors_df.to_json(out_filename_segment_corridors_key, orient="records", indent=2)
            create_geojson(merged_corridors_gdf, out_filename_corridors)

        if all_stops_joined_to_corridors != []:

            # Concatenate all processed features into a single GeoDataFrame
            all_stops_joined_to_corridors_df = pd.DataFrame(pd.concat(all_stops_joined_to_corridors, ignore_index=True))
            out_filename_stops_corridors_key = os.path.join(key_folder, f"{Segments_Geo_Name}__STOP__CORR_{corridor_group_id}_KEY.json")
            all_stops_joined_to_corridors_df.to_json(out_filename_stops_corridors_key, orient="records", indent=2)

    # calculate elapsed time
    time_end_Stops = time.time()
    gs.printElapsedTime(time_end_Stops, time_begin_Stops)
    gs.logElapsedTime(time_end_Stops, time_begin_Stops, logFile)

except:
    
    # print error message to log file if something doesn't work
    tb = sys.exc_info()[2]
    msg_error_traceback  = traceback.format_tb(tb)[0]
    msg_error_system     = str(sys.exc_info())
    msg_error_GeoPandas  = str(sys.exc_info()[1])
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write(" ============================================================================================================\n")
    logFile.write("There was an error running this script...\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("PYTHON ERRORS:\n")
    logFile.write("\n")
    logFile.write("    Traceback info:\n")
    logFile.write("\n")
    logFile.write(msg_error_traceback + "\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("    Error Info:\n")
    logFile.write("\n")
    logFile.write(msg_error_system + "\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("    Geopandas Error Info:\n")
    logFile.write("\n")
    logFile.write(msg_error_GeoPandas + "\n")
    logFile.write("\n")
    
    
    # print to console
    print("")
    print("")
    print("")
    print(" ============================================================================================================")
    print("*** There was an error running this script")
    print("Please check '" + ScenarioDir + "\\0_InputProcessing\\_Log\\" + out_Log_txt + "' for error messages.")
    print("")
    print("")
    
    
    # pause console to check printed messages
    input("Press Enter to continue...")
    
    
    # exit python & hand control back to Cube
    sys.exit(1)
    








