# Description:
#     This script converts scenario attributes to a json file used to configure the vizTool data
#
#     Date Edited: 08/16/2024


# ============================================================================================================
# System setup
# ============================================================================================================
print("\nRunning Python Script: 'vt_CreateScnJsons.py'")
print("\n\nSystem setup...")
print("\n    load python libraries")

import time
time_begin = time.time()
time_begin_SysSetup = time.time()
import os, sys, traceback
import importlib.machinery
import json
import geopandas as gpd
from pathlib import Path

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)
import _global_scripts as gs


# ----------------------------------------------------------------------------------------
# Define Functions
# ----------------------------------------------------------------------------------------
print("\n    define functions")

# function that will either append or replace data within the scenarios.json file
def append_update(data, jsonGroupName, jsonVarName, jsonGroup):
    updated=False
    for existing in data[jsonGroupName]:
        if existing[jsonVarName] == jsonGroup[jsonVarName]:
            existing.update(jsonGroup)
            updated = True
            break
    
    if not updated:
        data[jsonGroupName].append(jsonGroup)
    
def update_scenarios(data, include_in_all_trends, default_trend):
    for scenario in data['scenarios']:
        if scenario['scnGroup'] in include_in_all_trends:
            # Get all scnGroups for the modVersion
            modVersion = scenario['modVersion']
            scnTrendCodes = list(set(
                [scn['scnGroup']
                for scn in data['scenarios']
                if scn['modVersion'] == modVersion and scn['scnGroup'] not in include_in_all_trends]
            ))
            # Use default_trend if scnTrendCodes is empty
            scenario['scnTrendCodes'] = scnTrendCodes if scnTrendCodes else [default_trend]
        else:
            # Convert to list if not already and ensure default_trend if empty
            scenario['scnTrendCodes'] = (
                [scenario['scnTrendCodes']] 
                if isinstance(scenario['scnTrendCodes'], str) 
                else scenario['scnTrendCodes']
            )
            if not scenario['scnTrendCodes']:  # Use default_trend if empty
                scenario['scnTrendCodes'] = [default_trend]

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
    out_Log_txt          = "py_LogFile - vt_CreateScnJsons.txt"
    
    # create global variables from input file
    dir_ScriptLaunch = os.getcwd()

    # create path to global variables input file
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, "_Log", in_GlobalVar_txt)
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()

    # create global parameters
    ParentDir      = GlobalVars.ParentDir
    ScenarioDir    = GlobalVars.ScenarioDir
    ModelVersion   = GlobalVars.ModelVersion
    ScenarioGroup  = GlobalVars.ScenarioGroup
    RunYear        = int(GlobalVars.RunYear)
    TAZ_Name       = GlobalVars.TAZ_DBF.replace(".dbf", "")
    Segments_Name  = GlobalVars.Segments_DBF.replace(".dbf", "")
    
    # create global inputs
    in_TAZ_shp_name       = GlobalVars.TAZ_DBF.replace(".dbf", ".shp")
    in_Segments_shp_name  = GlobalVars.Segments_DBF.replace(".dbf", ".shp")
    TAZ_Geo_Name          = in_TAZ_shp_name.replace(".shp", "")
    Segments_Geo_Name     = in_Segments_shp_name.replace(".shp", "")
    
    #define vizTool scripts path
    vizscripts_path = ParentDir + "2_ModelScripts\_Python\py-vizTool"
    
    #set input paths
    in_corridors_folder = os.path.join(ParentDir, r"1_Inputs\6_Segment\\Corridors")

    # define output path
    output_path       = os.path.join(ParentDir, r"Scenarios\.vizTool\config")
    
    # ----------------------------------------------------------------------------------------
    # specify scenario variables
    # ----------------------------------------------------------------------------------------
    print("\n    read in scenario configuration")

    # read in viztool config file and get scenario variables
    with open(os.path.join(ParentDir, r"2_ModelScripts\_Python\py-vizTool\configs\scenarios.json")) as file:
        config_data = json.load(file)
    
    # define scenario variables
    file_name              = config_data.get("fileName")
    start_new              = config_data.get("startNew")
    initial_select         = config_data.get("initialSelect")
    initial_select_compare = config_data.get("initialSelectCompare")
    include_in_all_trends  = config_data.get("includeInAllTrends")
    default_trend          = config_data.get("defaultTrend")
    
    # set output path
    scenarios_json_path = os.path.join(output_path, file_name)

    # define geojson names
    geojsons = {
        "taz"        : TAZ_Name                 + ".geojson",
        "distSml"    : TAZ_Name      + "__DSML" + ".geojson",
        "distMed"    : TAZ_Name      + "__DMED" + ".geojson",
        "distLrg"    : TAZ_Name      + "__DLRG" + ".geojson",
        "distSup"    : TAZ_Name      + "__DSUP" + ".geojson",
        "subarea"    : TAZ_Name      + "__SAID" + ".geojson",
        "planarea"   : TAZ_Name      + "__PLAN" + ".geojson",
        "city"       : TAZ_Name      + "__CITY" + ".geojson",
        "citygroup"  : TAZ_Name      + "__CTGP" + ".geojson",
        "segment"    : Segments_Name            + ".geojson",
        "stop"       : Segments_Name + "__STOP" + ".geojson",
    }

    # add corridor geojsons

    # Load JSON configuration
    with open(vizscripts_path + "\\configs\\corridors.json") as f:
        corridors_data = json.load(f)

    # Process each corridor group and add to geojsons
    for corridor_group in corridors_data:
        corridor_group_id = corridor_group['corridorGroupId']
        corridor_group_alias = corridor_group['alias']
        
        # Generate filenames as needed
        out_filename_segment_corridors_key = f"{Segments_Geo_Name}__CORR_{corridor_group_id}_KEY.json"
        out_filename_corridors = f"{Segments_Geo_Name}__CORR_{corridor_group_id}.geojson"
        
        # Add new entry to geojsons dictionary
        geojsons[f"corr{corridor_group_id}"] = out_filename_corridors


    # taz keys
    taz = {
        "distSml"    : TAZ_Name      + "__DSML_KEY" + ".json",
        "distMed"    : TAZ_Name      + "__DMED_KEY" + ".json",
        "distLrg"    : TAZ_Name      + "__DLRG_KEY" + ".json",
        "distSup"    : TAZ_Name      + "__DSUP_KEY" + ".json",
        "subarea"    : TAZ_Name      + "__SAID_KEY" + ".json",
        "planarea"   : TAZ_Name      + "__PLAN_KEY" + ".json",
        "city"       : TAZ_Name      + "__CITY_KEY" + ".json",
        "citygroup"  : TAZ_Name      + "__CTGP_KEY" + ".json",
    }

    # taz keys
    distSml = {
        "distMed"    : TAZ_Name      + "__DSML__DMED_KEY" + ".json",
        "distLrg"    : TAZ_Name      + "__DSML__DLRG_KEY" + ".json",
        "distSup"    : TAZ_Name      + "__DSML__DSUP_KEY" + ".json",
        "subarea"    : TAZ_Name      + "__DSML__SAID_KEY" + ".json",
        "planarea"   : TAZ_Name      + "__DSML__PLAN_KEY" + ".json",
    }

    # segment keys
    segment = {
        "taz"        : Segments_Name + "__TAZ_KEY"  + ".json",
        "distSml"    : Segments_Name + "__DSML_KEY" + ".json",
        "distMed"    : Segments_Name + "__DMED_KEY" + ".json",
        "distLrg"    : Segments_Name + "__DLRG_KEY" + ".json",
        "distSup"    : Segments_Name + "__DSUP_KEY" + ".json",
        "city"       : Segments_Name + "__CITY_KEY" + ".json",
        "subarea"    : Segments_Name + "__SAID_KEY" + ".json",
        "planarea"   : Segments_Name + "__PLAN_KEY" + ".json",
        "citygroup"  : Segments_Name + "__CTGP_KEY" + ".json",
    }

    # stop keys
    stop = {
        "taz"        : Segments_Name + "__STOP__TAZ_KEY"  + ".json",
        "distSml"    : Segments_Name + "__STOP__DSML_KEY" + ".json",
        "distMed"    : Segments_Name + "__STOP__DMED_KEY" + ".json",
        "distLrg"    : Segments_Name + "__STOP__DLRG_KEY" + ".json",
        "distSup"    : Segments_Name + "__STOP__DSUP_KEY" + ".json",
        "city"       : Segments_Name + "__STOP__CITY_KEY" + ".json",
        "subarea"    : Segments_Name + "__STOP__SAID_KEY" + ".json",
        "planarea"   : Segments_Name + "__STOP__PLAN_KEY" + ".json",
        "citygroup"  : Segments_Name + "__STOP__CTGP_KEY" + ".json",
    }

    # Load JSON configuration
    with open(vizscripts_path + "\\configs\\corridors.json") as f:
        corridors_data = json.load(f)

    # Process each corridor group and add to geojsons
    for corridor_group in corridors_data:
        corridor_group_id = corridor_group['corridorGroupId']
        corridor_group_alias = corridor_group['alias']
        
        # Add new entry to geojsons dictionary
        segment[f"corr{corridor_group_id}"] = f"{Segments_Geo_Name}__CORR_{corridor_group_id}_KEY.json"
        stop[f"corr{corridor_group_id}"] = f"{Segments_Geo_Name}__STOP__CORR_{corridor_group_id}_KEY.json"

    # ----------------------------------------------------------------------------------------
    # update log file
    # ----------------------------------------------------------------------------------------
    # begin Log file
    path_out_Log_txt = os.path.join(ParentDir, ScenarioDir, "_Log", out_Log_txt)
    logFile = open(path_out_Log_txt, 'w')
    
    # calculate elapsed time
    logFile.write("\nRunning Python Script: 'vt_CreateGeojsons.py'")
    logFile.write("\n\nSystem setup...")
    logFile.write("\n    load python libraries")
    logFile.write("\n    define functions")
    gs.logElapsedTime(time_end_SysSetup, time_begin_SysSetup, logFile)

    logFile.write("\n\nSpecifying Global Parameters & Input-Output Files...")
    logFile.write("\n    read in scenario configuration")
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    
    # ============================================================================================================
    # Compile Data for Scenario Json
    # ============================================================================================================
    # print to console & log file
    print("\n\nCompiling Data for Scenario Json...")
    logFile.write("\n\nCompiling Data for Scenario Json...")
    
    # get time (in seconds)
    time_begin_Scnjsons = time.time()

    # set the data variable to something new, or what already exists to allow for new scenario data to be stored
    if ((os.path.exists(scenarios_json_path)) & (start_new==False)):
        with open(scenarios_json_path, 'r') as file:
            data = json.load(file)
    else:
        # Initialize data if the file does not exist
        data = {
            "$schema": "./schema/scenario-schema.json",
            "initial_select": [],
            "initial_select_compare": [],
            "models": [],
            "trends": [],
            "scenarios": []
        }
    
    # ----------------------------------------------------------------------------------------
    # Set initial_select and initial_select_compare json groups
    # ----------------------------------------------------------------------------------------
    print("\n    set initial_select and initial_select_compare json groups")
    logFile.write("\n    set initial_select and initial_select_compare json groups")

    # set the intial_select and initial_select_compare json groups
    if initial_select == "":
        is_modVersion, is_scnGroup, is_scnYear = ModelVersion, ScenarioGroup, RunYear
    else:
        is_modVersion, is_scnGroup, is_scnYear = initial_select.split("__")
        is_scnYear = int(is_scnYear)    
    
    if initial_select_compare == "":
        isc_modVersion, isc_scnGroup, isc_scnYear = ModelVersion, ScenarioGroup, RunYear
    else:
        isc_modVersion, isc_scnGroup, isc_scnYear = initial_select_compare.split("__")
        isc_scnYear = int(isc_scnYear)
    
    # store the intial_select and initial_select_compare json group
    data["initial_select"] = [{
        "modVersion": is_modVersion, 
        "scnGroup": is_scnGroup, 
        "scnYear": is_scnYear
    }]
    
    data["initial_select_compare"] = [{
        "modVersion": isc_modVersion, 
        "scnGroup": isc_scnGroup, 
        "scnYear": isc_scnYear
    }]
    
    # ----------------------------------------------------------------------------------------
    # Set model json group
    # ----------------------------------------------------------------------------------------
    print("\n    set model json group")
    logFile.write("\n    set model json group")
    
    keys = {
        "taz"     : taz,
        "distSml" : distSml,
        "segment" : segment,
        "stop"    : stop
    }

    # set and store the model json group
    model = {
        "modVersion": ModelVersion, 
        "geojsons"  : geojsons,
        "keys"      : keys
    }
    append_update(data, "models", "modVersion", model)
    
    # ----------------------------------------------------------------------------------------
    # Set trend json group
    # ----------------------------------------------------------------------------------------
    print("\n    set trend json group")
    logFile.write("\n    set trend json group")

    # set and store the trend json group
    if ScenarioGroup in include_in_all_trends:
        if default_trend != "":
            trend = {
                "scnTrendCode": default_trend, 
                "alias": default_trend, 
                "displayByDefault": True
            }
            append_update(data, "trends", "scnTrendCode", trend)
        else:
            trend = {}
    else:
        trend = {
            "scnTrendCode": ScenarioGroup, 
            "alias": ScenarioGroup, 
            "displayByDefault": True
        }
        append_update(data, "trends", "scnTrendCode", trend)
    
    # ----------------------------------------------------------------------------------------
    # Set scenario json group
    # ----------------------------------------------------------------------------------------
    print("\n    set scenario json group")
    logFile.write("\n    set scenario json group")

    # set and store the scenario json group
    scnCode = ModelVersion +'__'+ ScenarioGroup +'__'+  str(RunYear)
    scenarios = {
        "modVersion": ModelVersion,
        "scnGroup": ScenarioGroup,
        "scnYear": RunYear,
        "scnCode": scnCode,
        "alias": ScenarioGroup + ' ' + str(RunYear),
        "scnTrendCodes": ScenarioGroup
    }
    append_update(data, "scenarios", "scnCode", scenarios)
    update_scenarios(data, include_in_all_trends, default_trend )
    
    # ----------------------------------------------------------------------------------------
    # output file
    # ----------------------------------------------------------------------------------------
    print("\n    output file")
    logFile.write("\n    output file")
    
    json_data = json.dumps(data, indent=4)
    with open(scenarios_json_path, 'w') as file:
        file.write(json_data)
    
    # calculate elapsed time
    time_end_Scnjsons = time.time()
    gs.printElapsedTime(time_end_Scnjsons, time_begin_Scnjsons)
    gs.logElapsedTime(time_end_Scnjsons, time_begin_Scnjsons, logFile)
    logFile.close()
    
    
    
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
    