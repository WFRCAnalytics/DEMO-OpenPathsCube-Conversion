# Description:
#     This script creates files used to update the following fields on the highway network
#         - DISTANCE
#         - DIRECTION
#         - TAZID (links & nodes)
#         - HOT_ZONEID (links & nodes)
#     This script also creates the transit walk buffer file
#
#     Date Edited: 03/13/2024

# ============================================================================================================
# System setup
# ============================================================================================================
# print to console
print("")
print("Running Python Script: 'ip_UpdateNetwork_WalkBuffers.py'")
print("")
print("")
print("System setup...")


# ----------------------------------------------------------------------------------------
# import libraries
# ----------------------------------------------------------------------------------------
# print to console
print("")
print("    load python libraries")


# ------------------------------------------------------------------------------
# print to console
print("        importing system libraries")

# begin system library import
import time

# get time (in seconds)
time_begin = time.time()
time_begin_SysSetup = time.time()

# finish system library import
import os, sys, traceback
import importlib.machinery
from dbfread import DBF
import numpy as np
import math
import _global_scripts as gs
# ------------------------------------------------------------------------------
# print to console
print("        importing Pandas")

# import Pandas
import pandas as pd


# ------------------------------------------------------------------------------
# print to console
print("        importing GeoPandas and Shapely")

# import GeoPandas
import geopandas as gpd
import shapely

# ----------------------------------------------------------------------------------------
# Define Functions
# ----------------------------------------------------------------------------------------
# print to console
print("")
print("    define functions")

# import functions related to this script
import _updatenet_scripts as us


# calculate elapsed time -------------------------------------------------------
time_end_SysSetup     = time.time()
time_elapsed_SysSetup = time_end_SysSetup - time_begin_SysSetup
gs.printElapsedTime(time_end_SysSetup, time_begin_SysSetup)


# suppress warnings
import warnings
pd.options.mode.chained_assignment = None
warnings.simplefilter(action='ignore', category=FutureWarning)


try:
    
    # ============================================================================================================
    # Global Parameters
    # ============================================================================================================
    print("")
    print("")
    print("Specifying Global Parameters & Input-Output Files...")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_GlobalParam = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # specify global parameters file & output files
    # ----------------------------------------------------------------------------------------
    # identify key variables -------------------------------------------------------
    # specify input & output files
    in_GlobalVar_txt      = "py_Variables - ip_GlobalVars.txt"
    
    out_Log_txt           = "py_LogFile - ip_UpdateNetwork_WalkBuffers.txt"
    
    out_Master_Link_csv   = "Updated_Master_Link.csv"
    out_Master_Node_csv   = "Updated_Master_Node.csv"
    
    out_Toll_Link_csv     = "Toll_Link.csv"
    out_Toll_Node_csv     = "Toll_Node.csv"
    
    out_Transit_Link_shp  = "Transit_Link.shp"
    out_Transit_Node_shp  = "Transit_Node.shp"
    
    out_WalkBuffer_shp    = "WalkBuffer.shp"

    out_Scenario_Link_csv = "Scenario_Link_Direction.csv"
    out_report1_csv       = "py_Debug - ip_duplicated-segments.csv"
    out_report2_csv       = "py_Debug - ip_mismatched-segments.csv"
    out_report3_csv       = "py_Debug - ip_mismatched-direction.csv"
    
    
    # set buffer distance in miles
    BuffDist_local    = 0.4
    BuffDist_premium  = 0.4

    # set buffer distance in meters
    BuffDist_segments = 50

    # set max number of looping iterations if convergence isn't reached for segment direction
    MaxIters = 12
    
    
    # create global variables from input file --------------------------------------
    # get path to script launch point (i.e. location of 'HailMary.s' or '*.ipynb')
    dir_ScriptLaunch = os.getcwd()
    
    # create path to global variables input file
    # note: if running in jupyter notebooks
    #       1) uncomment 2nd line
    #       2) copy input global variables file to .ipynb location
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, "_Log", in_GlobalVar_txt)
    #path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, in_GlobalVar_txt)
    
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()
    
    UsedZones   = GlobalVars.UsedZones
    ParentDir   = GlobalVars.ParentDir
    ScenarioDir = GlobalVars.ScenarioDir
    
    in_TAZ_shp  = GlobalVars.TAZ_shp
    in_Toll_shp = GlobalVars.TollZoneID_shp
    TollZnField = GlobalVars.TollZoneField
    in_Link_shp = GlobalVars.Master_Link_shp
    in_Node_shp = GlobalVars.Master_Node_shp
    in_Tran_dbf = GlobalVars.Transit_dbf
    in_Segs_shp = GlobalVars.Segment_dbf.replace(".dbf", ".shp")
    
    
    # create output folders --------------------------------------------------------
    # create path to folders
    path_outfolder_MasterNet     = os.path.join(ParentDir, ScenarioDir, "0_InputProcessing\\UpdatedMasterNet")
    path_outfolder_MasterNet_GIS = os.path.join(ParentDir, ScenarioDir, "0_InputProcessing\\UpdatedMasterNet\\GIS")
    path_outfolder_Transit       = os.path.join(ParentDir, ScenarioDir, "0_InputProcessing\\Transit")
    path_outfolder_WalkBuffer    = os.path.join(ParentDir, ScenarioDir, "0_InputProcessing\\WalkBuffer")
    path_outfolder_ScenarioNet   = os.path.join(ParentDir, ScenarioDir, "0_InputProcessing\\ScenarioNet")
    
    
    # create folders
    os.makedirs(path_outfolder_MasterNet,     exist_ok=True)
    os.makedirs(path_outfolder_MasterNet_GIS, exist_ok=True)
    os.makedirs(path_outfolder_Transit,       exist_ok=True)
    os.makedirs(path_outfolder_WalkBuffer,    exist_ok=True)
    os.makedirs(path_outfolder_ScenarioNet,   exist_ok=True)
    
    
    # begin Log file ---------------------------------------------------------------
    # create path to log file & open log file for writing
    path_out_Log_txt = os.path.join(ParentDir, ScenarioDir, "_Log", out_Log_txt)
    
    logFile = open(path_out_Log_txt, 'w')
    
    
    # print previous sections to log file (since log had not yet been defined)
    logFile.write("\n")
    logFile.write("Running Python Script: 'ip_UpdateNetwork_WalkBuffers.py'\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("System setup...\n")
    logFile.write("\n")
    logFile.write("    load python libraries\n")
    logFile.write("        importing system libraries\n")
    logFile.write("        importing Pandas\n")
    logFile.write("        importing GeoPandas and Shapely\n")
    logFile.write("\n")
    logFile.write("    define functions\n")
    logFile.write("\n")
    logFile.write("    done\n")
    logFile.write("    elapsed time: "  +  str(time_elapsed_SysSetup)  +  "\n")
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Specifying Global Parameters & Input-Output Files...\n")
    
    
    # print info for this section to console & log file ----------------------------
    # print to console
    print("")
    print("    global parameters")
    print("        from '" + in_GlobalVar_txt + "'")
    print("             UsedZones        = "               +  str(UsedZones))
    print("             ParentDir        = '"              +  ParentDir    +  "'")
    print("             ScenarioDir      = ParentDir + '"  +  ScenarioDir  +  "'")
    print("")
    print("        other")
    print("             dir_ScriptLaunch  = '"              +  dir_ScriptLaunch  +  "'")
    print("             BuffDist_local    = "               +  str(BuffDist_local) + "miles")
    print("             BuffDist_premium  = "               +  str(BuffDist_premium) + "miles")
    print("             BuffDist_segments = "               +  str(BuffDist_segments) + "meters")
    print("")
    print("    input files")
    print("        from '" + in_GlobalVar_txt + "'")
    print("             TAZ_shp          = ParentDir   + '1_Inputs\\1_TAZ\\"      +  in_TAZ_shp   +  "'")
    print("             TollZoneID_shp   = ParentDir   + '1_Inputs\\3_Highway\\"  +  in_Toll_shp  +  "'")
    print("                 (TollZoneField = '"  +  TollZnField  +  "')")
    print("")
    print("             Master_Link_shp  = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Link_shp  +  "'")
    print("             Master_Node_shp  = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Node_shp  +  "'")
    print("             Transit_dbf      = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Tran_dbf  +  "'")
    print("")
    print("    output files")
    print("        out_Log_txt           = ScenarioDir + '"                                 +  out_Log_txt          +  "'")
    print("        out_Transit_Link_shp  = ScenarioDir + '0_InputProcessing\\Transit\\"     +  out_Transit_Link_shp +  "'")
    print("        out_Transit_Node_shp  = ScenarioDir + '0_InputProcessing\\Transit\\"     +  out_Transit_Node_shp +  "'")
    print("        out_WalkBuffer_shp    = ScenarioDir + '0_InputProcessing\\WalkBuffer\\"  +  out_WalkBuffer_shp   +  "'")
    print("")
    print("        out_Master_Link_csv   = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Master_Link_csv  +  "'")
    print("        out_Master_Node_csv   = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Master_Node_csv  +  "'")
    print("        out_Toll_Link_csv     = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Toll_Link_csv    +  "'")
    print("        out_Toll_Node_csv     = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Toll_Node_csv    +  "'")
    print("")
    print("        out_Scenario_Link_csv = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Scenario_Link_csv  +  "'")
    print("        out_report1_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report1_csv        +  "'")
    print("        out_report2_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report2_csv        +  "'")
    print("        out_report3_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report3_csv        +  "'")
    
    
    # print to log file
    logFile.write("\n")
    logFile.write("    global parameters\n")
    logFile.write("        from '" + in_GlobalVar_txt + "'\n")
    logFile.write("             UsedZones        = "               +  str(UsedZones)  +  "\n")
    logFile.write("             ParentDir        = '"              +  ParentDir       +  "'\n")
    logFile.write("             ScenarioDir      = ParentDir + '"  +  ScenarioDir     +  "'\n")
    logFile.write("\n")
    logFile.write("        other\n")
    logFile.write("             dir_ScriptLaunch = '"              +  dir_ScriptLaunch       +  "'\n")
    logFile.write("             BuffDist_local   = "               +  str(BuffDist_local)    +  "\n")
    logFile.write("             BuffDist_premium = "               +  str(BuffDist_premium)  +  "\n")
    logFile.write("\n")
    logFile.write("    input files\n")
    logFile.write("        from '" + in_GlobalVar_txt + "'\n")
    logFile.write("             TAZ_shp          = ParentDir   + '1_Inputs\\1_TAZ\\"      +  in_TAZ_shp   +  "'\n")
    logFile.write("             TollZoneID_shp   = ParentDir   + '1_Inputs\\3_Highway\\"  +  in_Toll_shp  +  "'\n")
    logFile.write("                 (TollZoneField = '"  +  TollZnField  +  "')\n")
    logFile.write("\n")
    logFile.write("             Master_Link_shp  = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Link_shp  +  "'\n")
    logFile.write("             Master_Node_shp  = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Node_shp  +  "'\n")
    logFile.write("             Transit_dbf      = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  in_Tran_dbf  +  "'\n")
    logFile.write("\n")
    logFile.write("    output files\n")
    logFile.write("        out_Log_txt           = ScenarioDir + '"                                 +  out_Log_txt          +  "'\n")
    logFile.write("        out_Transit_Link_shp  = ScenarioDir + '0_InputProcessing\\Transit\\"     +  out_Transit_Link_shp +  "'\n")
    logFile.write("        out_Transit_Node_shp  = ScenarioDir + '0_InputProcessing\\Transit\\"     +  out_Transit_Node_shp +  "'\n")
    logFile.write("        out_WalkBuffer_shp    = ScenarioDir + '0_InputProcessing\\WalkBuffer\\"  +  out_WalkBuffer_shp   +  "'\n")
    logFile.write("\n")
    logFile.write("        out_Master_Link_csv   = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Master_Link_csv  +  "'\n")
    logFile.write("        out_Master_Node_csv   = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Master_Node_csv  +  "'\n")
    logFile.write("        out_Toll_Link_csv     = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Toll_Link_csv    +  "'\n")
    logFile.write("        out_Toll_Node_csv     = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Toll_Node_csv    +  "'\n")
    logFile.write("\n")
    logFile.write("        out_Scenario_Link_csv = ScenarioDir + 'Temp\\0_InputProcessing\\"  +  out_Scenario_Link_csv  +  "'\n")
    logFile.write("        out_report1_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report1_csv        +  "'\n")
    logFile.write("        out_report2_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report2_csv        +  "'\n")
    logFile.write("        out_report3_csv       = ScenarioDir + '_Log\\_debug\\"             +  out_report3_csv        +  "'\n")
    
    
    # ----------------------------------------------------------------------------------------
    # read global variables into python
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    Reading input file global variables...")
    
    logFile.write("\n")
    logFile.write("    Reading input file global variables...\n")
    
    
    # set paths & read input files -------------------------------------------------
    # create path to input file global variables 
    path_in_TAZ_shp  = os.path.join(ParentDir, "1_Inputs\\1_TAZ", in_TAZ_shp)
    path_in_Toll_shp = os.path.join(ParentDir, "1_Inputs\\3_Highway", in_Toll_shp)
    path_in_Link_shp = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", in_Link_shp)
    path_in_Node_shp = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", in_Node_shp)
    path_in_Tran_dbf = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", in_Tran_dbf)
    path_in_Segs_shp = os.path.join(ParentDir, "1_Inputs\\6_Segment", in_Segs_shp)
    
    
    # read in data & print to console & log file
    print("        reading '"  +  in_TAZ_shp   +  "' into GeoDataFrame")
    logFile.write("        reading '"  +  in_TAZ_shp   +  "' into GeoDataFrame\n")
    
    gdf_TAZ  = gpd.read_file(path_in_TAZ_shp)
    
    
    print("        reading '"  +  in_Toll_shp  +  "' into GeoDataFrame")
    logFile.write("        reading '"  +  in_Toll_shp  +  "' into GeoDataFrame\n")
    gdf_Toll = gpd.read_file(path_in_Toll_shp)
    
    
    print("        reading '"  +  in_Link_shp  +  "' into GeoDataFrame")
    logFile.write("        reading '"  +  in_Link_shp  +  "' into GeoDataFrame\n")
    gdf_Master_link = gpd.read_file(path_in_Link_shp)
    
    
    print("        reading '"  +  in_Node_shp  +  "' into GeoDataFrame")
    logFile.write("        reading '"  +  in_Node_shp  +  "' into GeoDataFrame\n")
    gdf_Master_node = gpd.read_file(path_in_Node_shp)
    
    
    print("        reading '"  +  in_Tran_dbf  +  "' into DataFrame")
    logFile.write("        reading '"  +  in_Tran_dbf  +  "' into DataFrame\n")
    
    # read in transit link data from dbf file & convert dbf input file to pandas DataFrame
    InputDBF_TransitLink = DBF(path_in_Tran_dbf)
    df_TransitLinks = pd.DataFrame(iter(InputDBF_TransitLink))
    
    
    print("        reading '"  +  in_Segs_shp  +  "' into DataFrame")
    logFile.write("        reading '"  +  in_Segs_shp  +  "' into DataFrame\n")
    gdf_Segments = gpd.read_file(path_in_Segs_shp)
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    
    
    # ============================================================================================================
    # Update Master Net
    # ============================================================================================================
    # print to console & log file
    print("")
    print("")
    print("Updating Master Net...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Updating Master Net...\n")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_MasterNet = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # update Master Net link distance
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    update Master Net link DISTANCE field (calculating distance in miles)")
    
    logFile.write("\n")
    logFile.write("    update Master Net link DISTANCE field (calculating distance in miles)\n")
    
    
    # update link distance field
    gdf_Master_link["DISTANCE"] = gdf_Master_link.geometry.length / 1609.34
    
    
    
    # ----------------------------------------------------------------------------------------
    # calculate Master Net link midpoint
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    calculate Master Net link midpoints")
    
    logFile.write("\n")
    logFile.write("    calculate Master Net link midpoints\n")
    
    
    # copy Master Net link gdf & reset link geometry to midpoint
    gdf_Master_link_mid = gdf_Master_link.copy()
    gdf_Master_link_mid = gdf_Master_link_mid.set_geometry(gdf_Master_link_mid.geometry.centroid)
    
    
    # ----------------------------------------------------------------------------------------
    # update TAZID -- Links
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    update Master Net link TAZID")
    
    logFile.write("\n")
    logFile.write("    update Master Net link TAZID\n")
    
    
    # spatial join -------------------------------------------------------------
    # print to console & log file
    print("        spatial join TAZ to link midpoints")
    logFile.write("        spatial join TAZ to link midpoints\n")
    
    
    # spatial join Master Net link midpoints & TAZ
    gdf_Master_link_mid_joinTAZ = gpd.sjoin_nearest(
        gdf_Master_link_mid, 
        gdf_TAZ, 
        distance_col='nearest_dist'
    )
    
    # drop duplicates where TAZ are equidistant from the link midpoint by keeping the first occurence
    gdf_Master_link_mid_joinTAZ_unique = gdf_Master_link_mid_joinTAZ.drop_duplicates(
        subset='LINKID',
        keep='first',
        ignore_index=True
    )
    
    
    # update TAZID field -------------------------------------------------------
    # print to console & log file
    print("        update TAZID field")
    logFile.write("        update TAZID field\n")
    
    
    # set TAZID to be A or B node number if A or B value is <= UsedZones, otherwise use joined TAZID
    #   note: calls 'calcTAZID_Link' function
    gdf_Master_link_mid_joinTAZ_TAZID = gdf_Master_link_mid_joinTAZ_unique.copy()
    
    gdf_Master_link_mid_joinTAZ_TAZID["TAZID_left"] = gdf_Master_link_mid_joinTAZ_TAZID.apply(
        lambda row: us.calcTAZID_Link(row["TAZID_right"], row["A"], row["B"], UsedZones), 
        axis=1
    )
    
    # select columns to include in table-join
    df_Master_link_mid_joinTAZ_TAZID = gdf_Master_link_mid_joinTAZ_TAZID[
        ['LINKID',
         'TAZID_left']
    ]
    
    
    # merge updated TAZID field to Master Net link gdf
    gdf_Master_link_TAZID = pd.DataFrame.merge(
        gdf_Master_link,
        df_Master_link_mid_joinTAZ_TAZID,
        how="left",
        left_on='LINKID',
        right_on='LINKID'
    )
    
    # update TAZID field
    gdf_Master_link_TAZID['TAZID'] = gdf_Master_link_TAZID['TAZID_left']
    
    
    # create output csv --------------------------------------------------------
    # print to console & log file
    print("        create output csv")
    logFile.write("        create output csv\n")
    
    
    # create final updated Master link gdf
    gdf_Master_link_final = gdf_Master_link_TAZID.drop(columns='TAZID_left')
    
    
    # create final DataFrame & add ';' to first field name
    df_Master_link_final = gdf_Master_link_final[
        ['A',
         'B',
         'DISTANCE',
         'LINKID',
         'TAZID']
    ].rename(
        columns={
            'A': ';A'
        }
    )
    
    # sort data
    df_Master_link_final = df_Master_link_final.sort_values(
        by=[';A', 'B'],
        ascending=[True, True],
        ignore_index=True
    )
    
    
    # write data to csv file
    path_out_Master_Link_csv = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", out_Master_Link_csv)
    
    df_Master_link_final.to_csv(
        path_out_Master_Link_csv,
        index=False
    )
    
    
    # ----------------------------------------------------------------------------------------
    # update TAZID -- Nodes
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    update Master Net Node TAZID")
    
    logFile.write("\n")
    logFile.write("    update Master Net Node TAZID\n")
    
    
    # spatial join -------------------------------------------------------------
    # print to console & log file
    print("        spatial join TAZ to nodes")
    logFile.write("        spatial join TAZ to nodes\n")
    
    
    # spatial join Master Net nodes & TAZ
    gdf_Master_node_joinTAZ = gpd.sjoin_nearest(
        gdf_Master_node, 
        gdf_TAZ, 
        distance_col='nearest_dist'
    )
    
    # drop duplicates where TAZ are equidistant from the node by keeping the first occurence
    gdf_Master_node_joinTAZ_unique = gdf_Master_node_joinTAZ.drop_duplicates(
        subset='N',
        keep='first',
        ignore_index=True
    )
    
    
    # update TAZID field -------------------------------------------------------
    # print to console & log file
    print("        update TAZID field")
    logFile.write("        update TAZID field\n")
    
    
    # set TAZID to be node number if N value is <= UsedZones, otherwise use joined TAZID
    #   note: calls 'calcTAZID_Node' function
    gdf_Master_node_joinTAZ_TAZID = gdf_Master_node_joinTAZ_unique.copy()
    
    gdf_Master_node_joinTAZ_TAZID["TAZID_left"] = gdf_Master_node_joinTAZ_TAZID.apply(
        lambda row: us.calcTAZID_Node(row["TAZID_right"], row["N"], UsedZones), 
        axis=1
    )
    
    # select columns to include in table-join
    df_Master_node_joinTAZ_TAZID = gdf_Master_node_joinTAZ_TAZID[
        ['N',
         'TAZID_left']
    ]
    
    
    # merge updated TAZID field to Master Net node gdf
    gdf_Master_node_TAZID = pd.DataFrame.merge(
        gdf_Master_node,
        df_Master_node_joinTAZ_TAZID,
        how="left",
        left_on='N',
        right_on='N'
    )
    
    # update TAZID field
    gdf_Master_node_TAZID['TAZID'] = gdf_Master_node_TAZID['TAZID_left']
    
    
    # create output csv --------------------------------------------------------
    # print to console & log file
    print("        create output csv")
    logFile.write("        create output csv\n")
    
    
    # create final updated Master node gdf
    gdf_Master_node_final = gdf_Master_node_TAZID.drop(columns='TAZID_left')
    
    
    # create final DataFrame & add ';' to first field name
    df_Master_node_final = gdf_Master_node_final[
        ['N',
         'X',
         'Y',
         'TAZID']
    ].rename(
        columns={
            'N': ';N'
        }
    )
    
    # sort data
    df_Master_node_final = df_Master_node_final.sort_values(
        by=';N',
        ascending=True,
        ignore_index=True
    )
    
    
    # write data to csv file
    path_out_node_csv = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", out_Master_Node_csv)
    
    df_Master_node_final.to_csv(
        path_out_node_csv,
        index=False
    )
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_MasterNet     = time.time()
    gs.printElapsedTime(time_end_MasterNet, time_begin_MasterNet)
    gs.logElapsedTime(time_end_MasterNet, time_begin_MasterNet, logFile)
    
    
    
    # ============================================================================================================
    # Preparing Files for Scenario Net Update
    # ============================================================================================================
    # print to console & log file
    print("")
    print("")
    print("Preparing Files for Scenario Net Update...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Preparing Files for Scenario Net Update...\n")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_ScenarioNet = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # Initialize Segments Dataset
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    initialize and buffer segment dataset")
    
    logFile.write("\n")
    logFile.write("    initialize and buffer segment dataset\n")
    
    #initialize segment df
    gdf_Segments = gdf_Segments.rename(columns={'DIRECTION':'SEG_DIR', 'SEGID':'SEG_SEGID'})
    gdf_Segments = gdf_Segments[['SEG_SEGID', 'SEG_DIR', 'BMP', 'EMP', 'geometry']]
    
    # create a 50 meter buffer around the segments
    gdf_Segments_Buffer = gdf_Segments[['SEG_SEGID', 'SEG_DIR','geometry']]
    gdf_Segments_Buffer['geometry'] = gdf_Segments_Buffer['geometry'].buffer(BuffDist_segments)
    
    # divide segment buffers to N/S and E/W directions
    gdf_Segments_Buffer_NS = gdf_Segments_Buffer[gdf_Segments_Buffer['SEG_DIR'] == 'NB/SB']
    gdf_Segments_Buffer_EW = gdf_Segments_Buffer[gdf_Segments_Buffer['SEG_DIR'] == 'EB/WB']
    
    # print to console & log file
    print("")
    print("    initialize scenario link dataset an calculate link direction")
    
    logFile.write("\n")
    logFile.write("    initialize scenario link dataset an calculation link direction\n")
    
    # initialize scenario link dataframe
    planarea_taz = pd.DataFrame(gdf_TAZ[['TAZID','PLANAREA']])
    gdf_Master_link_sn = pd.merge(gdf_Master_link_final,planarea_taz,on='TAZID',how='left')
    gdf_Master_link_sn
    
    # determine direction
    gdf_Scearnio_Link = gdf_Master_link_sn.copy()
    gdf_Scearnio_Link = gdf_Scearnio_Link.rename(columns={'SEGID':'NET_SEGID'})
    gdf_Scearnio_Link['NET_DIR'] = gdf_Scearnio_Link['geometry'].apply(us.determine_link_direction)
    
    
    # ----------------------------------------------------------------------------------------
    # Merge Freeway Links and Segment Buffer
    # ---------------------------------------------------------------------------------------- 
    # print to console & log file
    print("")
    print("    merge freeway links and segment buffer")
    
    logFile.write("\n")
    logFile.write("    merge freeway links and segment buffer\n")
    
    # filter to freeway links only
    gdf_freeway_links = gdf_Scearnio_Link[
        ((gdf_Master_link_final['FT'].between(21, 27)) | 
         (gdf_Master_link_final['FT'].between(31, 38)) | 
         (gdf_Master_link_final['FT'] == 40))
    ]
    
    # divide freeway links into N/S and E/W directions
    gdf_freeway_ew_links = gdf_freeway_links[gdf_freeway_links['NET_DIR'].isin(['EB', 'WB'])]
    gdf_freeway_ns_links = gdf_freeway_links[gdf_freeway_links['NET_DIR'].isin(['NB', 'SB'])]
    
    # calculate segid from segment buffer using function
    path_out_report1_csv = os.path.join(ParentDir, ScenarioDir,'_Log\\_debug\\', out_report1_csv)
    gdf_ns_freeways_joined = us.get_segid_from_buffer(gdf_freeway_ns_links, gdf_Segments_Buffer_NS, gdf_Segments, 'Freeway', True , path_out_report1_csv)
    gdf_ew_freeways_joined = us.get_segid_from_buffer(gdf_freeway_ew_links, gdf_Segments_Buffer_EW, gdf_Segments, 'Freeway', False, path_out_report1_csv)
    
    # concatenate N/S and E/W datasets
    gdf_freeway_links_pro = pd.concat([gdf_ns_freeways_joined, gdf_ew_freeways_joined], ignore_index=True)
    
    # merge original segment attributes onto merge freeway dataset
    df_Segments = pd.DataFrame(gdf_Segments).drop(columns={'geometry'})
    gdf_freeway_links_pro = gdf_freeway_links_pro.merge(
        df_Segments, 
        left_on='SEGID', 
        right_on='SEG_SEGID', 
        how='left'
    )
    
    # calculate temporary direction field as a mix of segment direction and network direction
    gdf_freeway_links_pro['DIRECTION'] =  gdf_freeway_links_pro.apply(
        lambda row: row['SEG_DIR'] if pd.notna(row['SEG_DIR']) else row['NET_DIR'], 
        axis=1
    )
    
    # drop columns
    gdf_freeway_links_report = gdf_freeway_links_pro[['PLANAREA','LINKID','FTTYPE','FT','NET_SEGID','SEG_SEGID']]
    gdf_freeway_links_final = gdf_freeway_links_pro.drop(columns={'SEG_SEGID','centroid', 'NET_SEGID'})
    
    
    # ----------------------------------------------------------------------------------------
    # Merge Non-Freeway Links and Segment Buffer
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    merge non-freeway links and segment buffer")
    
    logFile.write("\n")
    logFile.write("    non-merge freeway links and segment buffer\n")
    
    gdf_nonfreeway_links = gdf_Scearnio_Link[
        ~(
            (gdf_Master_link_final['FT'].between(21, 27)) | 
            (gdf_Master_link_final['FT'].between(31, 38)) | 
            (gdf_Master_link_final['FT'] == 40)           | 
            (gdf_Master_link_final['FT'] == 1)
        )
    ]
    
    # divide freeway links into N/S and E/W directions
    gdf_nonfreeway_ew_links = gdf_nonfreeway_links[gdf_nonfreeway_links['NET_DIR'].isin(['EB', 'WB'])]
    gdf_nonfreeway_ns_links = gdf_nonfreeway_links[gdf_nonfreeway_links['NET_DIR'].isin(['NB', 'SB'])]
    
    # get segid from buffer for non-freeway links (for reporting purposes)
    gdf_ns_nonfreeway_joined = us.get_segid_from_buffer(gdf_nonfreeway_ns_links, gdf_Segments_Buffer_NS, gdf_Segments, 'Arterial', False, path_out_report1_csv)
    gdf_ew_nonfreeway_joined = us.get_segid_from_buffer(gdf_nonfreeway_ew_links, gdf_Segments_Buffer_EW, gdf_Segments, 'Arterial', False, path_out_report1_csv)
    
    # get final attributes for non-freeway links
    gdf_nonfreeway_links_final = gdf_nonfreeway_links.merge(
        df_Segments, 
        left_on='NET_SEGID', 
        right_on='SEG_SEGID', 
        how='left'
    )
    
    # calculate temporary direction field as a mix of segment direction and network direction
    gdf_nonfreeway_links_final['DIRECTION'] =  gdf_nonfreeway_links_final.apply(
        lambda row: row['SEG_DIR'] if pd.notna(row['SEG_DIR']) else row['NET_DIR'], 
        axis=1
    )
    
    # set FTTYPE values to distiguish between freeways and non-freeways
    gdf_nonfreeway_links_final['FTTYPE'] = 'Non-Freeway'
    
    # determine SEGID column to be used in processing
    gdf_nonfreeway_links_final = gdf_nonfreeway_links_final.rename(columns={'NET_SEGID':'SEGID'}).drop(columns={'SEG_SEGID'})
    
    
    # ----------------------------------------------------------------------------------------
    # Concatenate Updated Freeway and Non-Freeway Links
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    concatenate updated freeway and non-freeway links")
    
    logFile.write("\n")
    logFile.write("    concatenate updated freeway and non-freeway links\n")
    
    # get centroid connectors
    gdf_centconnector_links = gdf_Scearnio_Link[((gdf_Master_link_final['FT'] == 1))]
    gdf_centconnector_links['FTTYPE'] = 'Centroid Connectors'
    gdf_centconnector_links
    
    gdf_links_w_segids = pd.concat([gdf_freeway_links_final, gdf_nonfreeway_links_final, gdf_centconnector_links], ignore_index=True)
    
    
    # ----------------------------------------------------------------------------------------
    # Write output Report for Mismatched SEGIDs
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    write out output report of mismatched segids between segments and links")
    
    logFile.write("\n")
    logFile.write("    write out output report of mismatched segids between segments and links\n")
    
    # join nonfreeway variables that underwent joining with segment buffer
    gdf_nonfreeway_links_report = pd.concat([gdf_ns_nonfreeway_joined, gdf_ew_nonfreeway_joined], ignore_index=True)
    
    # merge original segment attributes onto merge freeway dataset
    gdf_nonfreeway_links_report = gdf_nonfreeway_links_report.merge(
        df_Segments, 
        left_on='SEGID', 
        right_on='SEG_SEGID', 
        how='left'
    )
    
    # calculate temporary direction field as a mix of segment direction and network direction
    gdf_nonfreeway_links_report['DIRECTION'] =  gdf_nonfreeway_links_report.apply(
        lambda row: row['SEG_DIR'] if pd.notna(row['SEG_DIR']) else row['NET_DIR'], 
        axis=1
    )
    
    # drop unneeded columns
    gdf_nonfreeway_links_report = gdf_nonfreeway_links_report[['PLANAREA','LINKID','FTTYPE','FT','NET_SEGID','SEG_SEGID']]
    
    # join reporting variables
    report_links = pd.concat([gdf_freeway_links_report, gdf_nonfreeway_links_report], ignore_index=True)
    
    # generate report in scenario directory
    path_out_report2_csv = os.path.join(ParentDir, ScenarioDir,'_Log\\_debug\\', out_report2_csv)
    us.make_mismatch_report(report_links, path_out_report2_csv)
    
    
    # ----------------------------------------------------------------------------------------
    # Update Direction based on overarching Segment Direction
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    update link direction based off overarching segment direction")
    
    logFile.write("\n")
    logFile.write("    update link direction based off overarching segment direction\n")
    
    gdf_direction = gdf_links_w_segids.copy()
    gdf_direction['DIRECTION'] = gdf_direction.apply(us.update_direction, axis=1)
    
    # get smaller dataframe to make it easier to work with
    df_direction = pd.DataFrame(gdf_direction)[['PLANAREA','A','B','LINKID','FTTYPE','FT','SEGID','NET_DIR','SEG_DIR','DIRECTION']]
    
    # set initial looping variables
    df_direction['DIRECTION2'] = df_direction['DIRECTION']
    previous_na_count = df_direction['DIRECTION'].isna().sum()  # Initial count of NaNs in the starting column
    last_col = 'DIRECTION'
    
    # loop through, using the fill_directions function, to determine missing directions; loop until functions stops improving answers or it hits 12 iterations
    for i in range(2, MaxIters + 2):
        current_col = f'DIRECTION{i}'
        next_col = f'DIRECTION{i+1}'
        
        # Apply the fill_directions function and create the next column
        df_direction[next_col] = df_direction[current_col]
        df_direction = df_direction.groupby('SEGID', group_keys=False).apply(lambda g: us.fill_directions(g, next_col, current_col))
        
        # Check if the number of NaNs in the new column matches the previous column
        current_na_count = df_direction[next_col].isna().sum()
        if current_na_count == previous_na_count:
            break
        
        previous_na_count = current_na_count  # Update the previous NA count
        last_col = next_col  # Update the last column
    
    # drop intermediate columns & rename
    columns_to_drop = [f'DIRECTION{j}' for j in range(2, i + 2)] + ['DIRECTION']
    if last_col in columns_to_drop:
        columns_to_drop.remove(last_col)
    df_direction.drop(columns=columns_to_drop, inplace=True)
    df_direction.rename(columns={last_col: 'DIRECTION_FINAL'}, inplace=True)
    
    # fill last remaining na values with link direction (later print report of these values)
    df_direction_final = df_direction.copy()
    df_direction_final['DIRECTION_FINAL'] = df_direction_final['DIRECTION_FINAL'].fillna(df_direction_final['NET_DIR'])
    df_direction_final = df_direction_final[['LINKID','DIRECTION_FINAL']]
    
    # create final geodataframe with updated DIRECTION field
    gdf_links_w_direction = gdf_links_w_segids.merge(df_direction_final, on='LINKID', how='left')
    gdf_links_w_direction['DIRECTION'] = gdf_links_w_direction['DIRECTION_FINAL'].fillna(gdf_links_w_direction['DIRECTION'])
    gdf_links_w_direction['DIRECTION'] = gdf_links_w_direction['DIRECTION'].fillna(gdf_links_w_direction['NET_DIR'])
    gdf_links_w_direction = gdf_links_w_direction[['A','B','DISTANCE','LINKID','LANES','FT','DIRECTION','SEGID','geometry']]
    gdf_links_w_direction
    
    #save final output to temp folder
    path_out_Scenario_Link_csv = os.path.join(ParentDir, ScenarioDir,"Temp\\0_InputProcessing", out_Scenario_Link_csv)
    df_links_w_direction = pd.DataFrame(gdf_links_w_direction).drop(columns={'geometry'})
    df_links_w_direction.to_csv(path_out_Scenario_Link_csv, index=False)
    
    
    # ----------------------------------------------------------------------------------------
    # Write output Report for Mismatched Direction
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    write out output report of links with mismatched segids direction")
    
    logFile.write("\n")
    logFile.write("    write out output report of links with mismatched segids direction\n")
    
    # Filter rows where 'DIRECTION_FINAL' is empty (NaN)
    missing_direction_df = df_direction[df_direction['DIRECTION_FINAL'].isna()]
    
    # Create a report with the desired columns and add the 'NOTES' column
    report_df = missing_direction_df[['PLANAREA','LINKID', 'FTTYPE', 'SEGID']].copy()
    report_df['NOTES'] = "Network Alightment Error; mismatch between segment direction and link direction"
    
    # Save the report to a CSV file
    path_out_report3_csv = os.path.join(ParentDir, ScenarioDir,'_Log\\_debug\\', out_report3_csv)
    report_df.to_csv(path_out_report3_csv, index=False)
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_ScenarioNet     = time.time()
    gs.printElapsedTime(time_end_ScenarioNet, time_begin_ScenarioNet)
    gs.logElapsedTime(time_end_ScenarioNet, time_begin_ScenarioNet, logFile)
    
    
    
    # ============================================================================================================
    # Update Toll Zone ID
    # ============================================================================================================
    # print to console & log file
    print("")
    print("")
    print("Creating Toll Zone ID Update Files...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Creating Toll Zone ID Update Files...\n")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_TollZone = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # update Toll Zone ID -- links
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    create link Toll Zone ID update file")
    
    logFile.write("\n")
    logFile.write("    create link Toll Zone ID update file\n")
    
    
    # selecting eligible toll links ------------------------------------------------
    # print to console & log file
    print("        select eligible Toll links")
    logFile.write("        select eligible Toll links\n")
    
    
    # define eligible toll link selection criteria (i.e. scenario freeway links)
    sel_TollLinks = (gdf_Master_link_final['LANES']>0) & (gdf_Master_link_final['FT']>=20) & (gdf_Master_link_final['FT']<=42)
    
    # create toll link gdf
    gdf_Toll_link = gdf_Master_link_final[sel_TollLinks]
    
    
    # creating toll link midpoints -------------------------------------------------
    # print to console & log file
    print("        create link midpoints")
    logFile.write("        create link midpoints\n")
    
    # reset link geometry to midpoint
    gdf_Toll_link_mid = gdf_Toll_link.copy()
    
    gdf_Toll_link_mid = gdf_Toll_link_mid.set_geometry(gdf_Toll_link_mid.geometry.centroid)
    
    
    # spatial join -----------------------------------------------------------------
    # print to console & log file
    print("        spatial join '" + in_Toll_shp + "' to link midpoints")
    logFile.write("        spatial join '" + in_Toll_shp + "' to link midpoints\n")
    
    # spatial join toll link midpoints & Toll Zone shapefile
    gdf_Toll_link_mid_joinToll = gpd.sjoin(
        gdf_Toll_link_mid, 
        gdf_Toll, 
        how="left", 
        op="within"
    )
    
    # drop duplicates where TAZ are equidistant from the link midpoint by keeping the first occurence
    gdf_Toll_link_mid_joinToll_unique = gdf_Toll_link_mid_joinToll.drop_duplicates(
        subset='LINKID',
        keep='first',
        ignore_index=True
    )
    
    
    # update HOT_ZONEID ------------------------------------------------------------
    # print to console & log file
    print("        update HOT_ZONEID")
    logFile.write("        update HOT_ZONEID\n")
    
    # update HOT_ZONEID field
    gdf_Toll_link_mid_joinToll_TollID = gdf_Toll_link_mid_joinToll_unique.copy()
    
    gdf_Toll_link_mid_joinToll_TollID['HOT_ZONEID'] = gdf_Toll_link_mid_joinToll_TollID[TollZnField]
    
    
    # write data to csv file -------------------------------------------------------
    # print to console & log file
    print("        create toll zone link csv")
    logFile.write("        create toll zone link csv\n")
    
    
    # create final DataFrame & add ';' to first field name
    df_Toll_link_final = gdf_Toll_link_mid_joinToll_TollID[
        ['A',
         'B',
         'HOT_ZONEID']
    ].rename(
        columns={
            'A': ';A'
        }
    )
    
    # sort data
    df_Toll_link_final = df_Toll_link_final.sort_values(
        by=[';A', 'B'],
        ascending=[True, True],
        ignore_index=True
    )
    
    
    # write out csv file
    path_out_Toll_Link_csv = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", out_Toll_Link_csv)
    
    df_Toll_link_final.to_csv(
        path_out_Toll_Link_csv,
        index=False
    )
    
    
    # ----------------------------------------------------------------------------------------
    # update Toll Zone ID -- nodes
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    create node Toll Zone ID update file")
    
    logFile.write("\n")
    logFile.write("    create node Toll Zone ID update file\n")
    
    
    # selecting eligible toll nodes ------------------------------------------------
    # print to console & log file
    print("        select eligible Master Net nodes")
    logFile.write("        select eligible Master Net nodes\n")
    
    # define eligible toll link selection criteria
    sel_TollNodes = (gdf_Master_node_final['N']>UsedZones)
    
    # create toll node gdf
    gdf_Toll_node = gdf_Master_node_final[sel_TollNodes]
    
    
    # spatial join -----------------------------------------------------------------
    # print to console & log file
    print("        spatial join '" + in_Toll_shp + "' to nodes")
    logFile.write("        spatial join '" + in_Toll_shp + "' to nodes\n")
    
    # spatial join toll nodes & Toll Zone shapefile
    gdf_Toll_node_joinToll = gpd.sjoin(
        gdf_Toll_node, 
        gdf_Toll, 
        how="left", 
        op="within"
    )
    
    # drop duplicates where TAZ are equidistant from the link midpoint by keeping the first occurence
    gdf_Toll_node_joinToll_unique = gdf_Toll_node_joinToll.drop_duplicates(
        subset='N',
        keep='first',
        ignore_index=True
    )
    
    
    # update HOT_ZONEID ------------------------------------------------------------
    # print to console & log file
    print("        update HOT_ZONEID")
    logFile.write("        update HOT_ZONEID\n")
    
    # update HOT_ZONEID field
    gdf_Toll_node_joinToll_TollID = gdf_Toll_node_joinToll_unique.copy()
    
    gdf_Toll_node_joinToll_TollID['HOT_ZONEID'] = gdf_Toll_node_joinToll_TollID[TollZnField]
    
    
    # write data to csv file -------------------------------------------------------
    # print to console & log file
    print("        create toll zone node csv")
    logFile.write("        create toll zone node csv\n")
    
    
    # create final DataFrame & add ';' to first field name
    df_Toll_node_final = gdf_Toll_node_joinToll_TollID[
        ['N',
         'X',
         'Y',
         'HOT_ZONEID']
    ].rename(
        columns={
            'N': ';N'
        }
    )
    
    # sort data
    df_Toll_node_final = df_Toll_node_final.sort_values(
        by=[';N'],
        ascending=[True],
        ignore_index=True
    )
    
    
    # write out csv file
    path_out_Toll_Node_csv = os.path.join(ParentDir, ScenarioDir, "Temp\\0_InputProcessing", out_Toll_Node_csv)
    
    df_Toll_node_final.to_csv(
        path_out_Toll_Node_csv,
        index=False
    )
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_TollZone     = time.time()
    gs.printElapsedTime(time_end_TollZone, time_begin_TollZone)
    gs.logElapsedTime(time_end_TollZone, time_begin_TollZone, logFile)
    
    
    
    # ============================================================================================================
    # Create Transit Shapefiles
    # ============================================================================================================
    # print to console & log file
    print("")
    print("")
    print("Creating Transit Shapefiles...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Creating Transit Shapefiles...\n")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_TransitShp = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # create Transit link shapefile
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    create Transit link shapefile")
    
    logFile.write("\n")
    logFile.write("    create Transit link shapefile\n")
    
    
    # join updated Master link data to Transit link data ---------------------------
    # print to console & log file
    print("        join updated Master link data to Transit link data")
    logFile.write("        join updated Master link data to Transit link data\n")
    
    
    # merge updated Master Net link data to Transit link df
    df_TransitLinks_Master = pd.DataFrame.merge(
        df_TransitLinks,
        gdf_Master_link_final,
        how="left",
        left_on=['A', 'B'],
        right_on=['A', 'B']
    )
    
    
    # filter data to only include transit modes & select fields --------------------
    # print to console & log file
    print("        filter data to only include transit modes & select fields")
    logFile.write("        filter data to only include transit modes & select fields\n")
    
    
    # only include transit modes
    df_TransitLinks_Master_Filter = df_TransitLinks_Master[
        (df_TransitLinks_Master.MODE>=1) & 
        (df_TransitLinks_Master.MODE<=9)
    ]
    
    # only include select fields
    df_TransitLinks_Master_Filter = df_TransitLinks_Master_Filter[
        ['A',
         'B',
         'LINKID',
         'MODE',
         'OPERATOR',
         'NAME',
         'LONGNAME',
         'LINKSEQ',
         'STOPA',
         'STOPB',
         'DISTANCE',
         'TAZID',
         'LANES',
         'FT',
         'geometry']
    ]
    
    
    # remove the '-' character from end of reverse route names ---------------------
    # print to console & log file
    print("        remove the '-' character from end of reverse route names")
    logFile.write("        remove the '-' character from end of reverse route names\n")
    
    
    # remove the '-' character from end route name
    df_TransitLinks_Master_Filter_Rename = df_TransitLinks_Master_Filter.copy()
    
    df_TransitLinks_Master_Filter_Rename['NAME'] = df_TransitLinks_Master_Filter_Rename['NAME'].apply(
        lambda x: x[:-1] if x.endswith('-') else x
    )
    
    
    # create Transit link shapefile ------------------------------------------------
    # print to console & log file
    print("        create Transit link shapefile")
    logFile.write("        create Transit link shapefile\n")
    
    
    # use merged geometry to create gdf
    gdf_Transit_Link = gpd.GeoDataFrame(df_TransitLinks_Master_Filter_Rename)
    
    
    # set TAZID, LANES & FT fields back to integer
    gdf_Transit_Link['TAZID'] = gdf_Transit_Link['TAZID'].astype(int)
    gdf_Transit_Link['LANES'] = gdf_Transit_Link['LANES'].astype(int)
    gdf_Transit_Link['FT']    = gdf_Transit_Link['FT'].astype(int)
    
    
    # export to shapefile
    path_out_Transit_Link_shp = os.path.join(path_outfolder_Transit, out_Transit_Link_shp)
    
    gdf_Transit_Link.to_file(
        path_out_Transit_Link_shp,
        driver='ESRI Shapefile'
    )
    
    
    # remove geometry from transit link gdf
    df_Transit_Link = gdf_Transit_Link.drop(columns='geometry')
    
    
    # ----------------------------------------------------------------------------------------
    # create Transit node shapefile
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("")
    print("    create Transit node shapefile")
    
    logFile.write("\n")
    logFile.write("    create Transit node shapefile\n")
    
    
    # process Transit link data for Transit node extraction ------------------------
    # print to console & log file
    print("        process Transit link data for Transit node extraction")
    logFile.write("        process Transit link data for Transit node extraction\n")
    
    
    # add stops by mode columns
    df_Transit_Link_Stops = df_Transit_Link.copy()
    
    df_Transit_Link_Stops['STOP4'] = 0
    df_Transit_Link_Stops['STOP5'] = 0
    df_Transit_Link_Stops['STOP6'] = 0
    df_Transit_Link_Stops['STOP7'] = 0
    df_Transit_Link_Stops['STOP8'] = 0
    df_Transit_Link_Stops['STOP9'] = 0
    
    
    # extract A & B node data from links -------------------------------------------
    # print to console & log file
    print("        extract A & B node data from links")
    logFile.write("        extract A & B node data from links\n")
    
    
    # filter & rename columns
    df_Transit_Node_A = df_Transit_Link_Stops[
        ['A',
         'MODE',
         'OPERATOR',
         'NAME',
         'LONGNAME',
         'STOPA',
         'STOP4',
         'STOP5',
         'STOP6',
         'STOP7',
         'STOP8',
         'STOP9']
    ].rename(
        columns={
            'A'    : 'N',
            'STOPA': 'STOP'
        }
    )
    
    df_Transit_Node_B = df_Transit_Link_Stops[
        ['B',
         'MODE',
         'OPERATOR',
         'NAME',
         'LONGNAME',
         'STOPB',
         'STOP4',
         'STOP5',
         'STOP6',
         'STOP7',
         'STOP8',
         'STOP9']
    ].rename(
        columns={
            'B'    : 'N',
            'STOPB': 'STOP'
        }
    )
    
    
    # combine data
    df_Transit_Node_combined= pd.concat(
        [df_Transit_Node_A,
         df_Transit_Node_B]
    )
    
    
    # keep only unique records
    df_Transit_Node_combined_unique = df_Transit_Node_combined.drop_duplicates(
        subset=['N', 'NAME'],
        keep='first',
        ignore_index=True
    )
    
    
    # calculate stop by mode columns -----------------------------------------------
    # print to console & log file
    print("        calculate stop by mode columns")
    logFile.write("        calculate stop by mode columns\n")
    
    
    # filter & rename columns
    df_Transit_Node_CalcStop = df_Transit_Node_combined_unique.copy()
    
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==4) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP4'] = 1
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==5) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP5'] = 1
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==6) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP6'] = 1
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==7) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP7'] = 1
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==8) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP8'] = 1
    df_Transit_Node_CalcStop.loc[(df_Transit_Node_CalcStop['MODE']==9) & (df_Transit_Node_CalcStop['STOP']==1), 'STOP9'] = 1
    
    
    # join updated Master node data to Transit node data ---------------------------
    # print to console & log file
    print("        join updated Master node data to Transit node data")
    logFile.write("        join updated Master node data to Transit node data\n")
    
    
    # merge updated Master Net node data to Transit node df
    df_Transit_Node_CalcStop_Master = pd.DataFrame.merge(
        df_Transit_Node_CalcStop,
        gdf_Master_node_final,
        how="left",
        left_on=['N'],
        right_on=['N']
    )
    
    df_Transit_Node_CalcStop_Master_Filter = df_Transit_Node_CalcStop_Master[
        ['N',
         'MODE',
         'OPERATOR',
         'NAME',
         'LONGNAME',
         'STOP',
         'STOP4',
         'STOP5',
         'STOP6',
         'STOP7',
         'STOP8',
         'STOP9',
         'X',
         'Y',
         'TAZID',
         'geometry']
    ]
    
    
    # create Transit node shapefile ------------------------------------------------
    # print to console & log file
    print("        create Transit node shapefile")
    logFile.write("        create Transit node shapefile\n")
    
    
    # use merged geometry to create gdf
    gdf_Transit_Node_ByRoute = gpd.GeoDataFrame(df_Transit_Node_CalcStop_Master_Filter)
    
    
    # export to shapefile
    path_out_Transit_Node_shp = os.path.join(path_outfolder_Transit, out_Transit_Node_shp)
    
    gdf_Transit_Node_ByRoute.to_file(
        path_out_Transit_Node_shp,
        driver='ESRI Shapefile'
    )
    
    
    # remove geometry from transit node gdf
    df_Transit_Node_ByRoute = gdf_Transit_Node_ByRoute.drop(columns='geometry')
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_TransitShp     = time.time()
    gs.printElapsedTime(time_end_TransitShp, time_begin_TransitShp)
    gs.logElapsedTime(time_end_TransitShp, time_begin_TransitShp, logFile)
    
    
    
    # ============================================================================================================
    # Create Walk Buffer File
    # ============================================================================================================
    
    # print to console & log file
    print("")
    print("")
    print("Creating Walk Buffer File...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("Creating Walk Buffer Update File...\n")
    
    
    # get time (in seconds) --------------------------------------------------------
    time_begin_WalkBuff = time.time()
    
    
    # ----------------------------------------------------------------------------------------
    # create local bus buffer
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("    create local bus buffer")
    logFile.write("    create local bus buffer\n")
    
    
    # filter Transit links for local bus -------------------------------------------
    # print to console & log file
    print("        filter Transit links for local bus")
    logFile.write("        filter Transit links for local bus\n")
    
    
    #filter data to only include local bus mode
    gdf_Transit_LocalRoutes = gdf_Transit_Link[gdf_Transit_Link['MODE']==4]
    
    
    # remove duplicate links -------------------------------------------------------
    # print to console & log file
    print("        remove duplicate links")
    logFile.write("        remove duplicate links\n")
    
    
    # filter data to only include local bus mode
    gdf_Transit_Local = gdf_Transit_LocalRoutes.drop_duplicates(
        subset=['A', 'B'],
        keep='first',
        ignore_index=True
    )
    
    # include relevant fields
    gdf_Transit_Local = gdf_Transit_Local[
        ['A',
    	 'B',
    	 'LINKID',
    	 'MODE',
    	 'DISTANCE',
    	 'TAZID',
    	 'LANES',
    	 'FT',
    	 'geometry']
    ]
    
    
    # create local bus buffer ------------------------------------------------------
    # print to console & log file
    print("        create local bus buffer")
    logFile.write("        create local bus buffer\n")
    
    
    # set buffer distance in meters (coordinate system is in meters: 1609.344m = 1mi)
    meters_to_buffer_local = BuffDist_local * 1609.344
    
    # create buffer (note: buffer does not retain original gdf attributes)
    gdf_Transit_Local_buffer = gdf_Transit_Local.copy()
    
    gdf_Transit_Local_buffer['geometry'] = gdf_Transit_Local.buffer(meters_to_buffer_local)
    #buffer_Local = gdf_Transit_Mode4.buffer(meters_to_buffer, join_style=1, cap_style=1)
    
    
    # dissolve local bus buffer ----------------------------------------------------
    # print to console & log file
    print("        dissolve local bus buffer")
    print("")
    
    logFile.write("        dissolve local bus buffer\n")
    logFile.write("\n")
    
    
    # dissolve buffer & add 'WaldBuff' field
    gdf_Transit_Local_buffer_dissolve = gdf_Transit_Local_buffer.dissolve()
    
    gdf_Transit_Local_buffer_dissolve['WalkBuff'] = 1
    
    gdf_Transit_Local_buffer_dissolve = gdf_Transit_Local_buffer_dissolve[
        ['WalkBuff',
         'geometry']
    ]
    
    
    # ----------------------------------------------------------------------------------------
    # create premium modes buffer
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("    create premium modes buffer")
    logFile.write("    create premium modes buffer\n")
    
    
    # filter Transit nodes for premium mode stops ----------------------------------
    # print to console & log file
    print("        filter Transit nodes for premium mode stops")
    logFile.write("        filter Transit nodes for premium mode stops\n")
    
    
    # filter data to only include local bus mode
    gdf_Transit_PremiumRoutes = gdf_Transit_Node_ByRoute[gdf_Transit_Node_ByRoute['MODE']>4]
    
    # filter data to only include stop nodes
    gdf_Transit_Stop_PremiumRoutes = gdf_Transit_PremiumRoutes[gdf_Transit_PremiumRoutes['STOP']==1]
    
    
    # remove duplicate stop nodes --------------------------------------------------
    # print to console & log file
    print("        remove duplicate stop nodes")
    logFile.write("        remove duplicate stop nodes\n")
    
    
    #filter data to only include local bus mode
    gdf_Transit_Stop_Premium = gdf_Transit_Stop_PremiumRoutes.drop_duplicates(
        subset='N',
        keep='first',
        ignore_index=True
    )
    
    gdf_Transit_Stop_Premium = gdf_Transit_Stop_Premium[
        ['N',
    	 'STOP',
    	 'X',
    	 'Y',
    	 'TAZID',
    	 'geometry']
    ]
    
    
    # create premium modes buffer --------------------------------------------------
    # print to console & log file
    print("        create premium modes buffer")
    logFile.write("        create premium modes buffer\n")
    
    
    # set buffer distance in meters (coordinate system is in meters: 1609.344m = 1mi)
    meters_to_buffer_premium = BuffDist_premium * 1609.344
    
    # create buffer (note: buffer does not retain original gdf attributes)
    gdf_Transit_Premium_buffer = gdf_Transit_Stop_Premium.copy()
    
    gdf_Transit_Premium_buffer['geometry'] = gdf_Transit_Premium_buffer.buffer(meters_to_buffer_premium)
    
    
    # dissolve premium modes buffer ------------------------------------------------
    # print to console & log file
    print("        dissolve premium modes buffer")
    print("")
    
    logFile.write("        dissolve premium modes buffer\n")
    logFile.write("\n")
    
    
    # dissolve buffer & add 'WaldBuff' field
    gdf_Transit_Premium_buffer_dissolve = gdf_Transit_Premium_buffer.dissolve()
    
    gdf_Transit_Premium_buffer_dissolve['WalkBuff'] = 1
    
    gdf_Transit_Premium_buffer_dissolve = gdf_Transit_Premium_buffer_dissolve[
        ['WalkBuff',
         'geometry']
    ]
    
    
    # ----------------------------------------------------------------------------------------
    # create combined local bus & premium modes buffer
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("    create combined local bus & premium modes buffer")
    logFile.write("    create combined local bus & premium modes buffer\n")
    
    # combine local bus & premium modes buffers ------------------------------------
    # print to console & log file
    print("        combine local bus & premium modes buffers")
    logFile.write("        combine local bus & premium modes buffers\n")
    
    
    # union local bus & premium modes buffers
    gdf_Transit_Combined_buffer = gdf_Transit_Local_buffer.overlay(gdf_Transit_Premium_buffer, how='union')
    
    
    # dissolve combined buffers ----------------------------------------------------
    # print to console & log file
    print("        dissolve combined buffers")
    print("")
    
    logFile.write("        dissolve combined buffers\n")
    logFile.write("\n")
    
    
    # round before dissolving buffer to avoid floating point errors (9th decimal is too precise and causes overlap error)
    gdf_Transit_Combined_buffer["geometry"] = gdf_Transit_Combined_buffer["geometry"].apply(lambda x: shapely.wkt.loads(shapely.wkt.dumps(x, rounding_precision=8)))

    # add additional buffer in case of duplicated geometries
    gdf_Transit_Combined_buffer['geometry'] = gdf_Transit_Combined_buffer['geometry'].buffer(1e-9)
    
    # dissolve buffer & add 'WalkBuff' field
    gdf_Transit_Combined_buffer_dissolve = gdf_Transit_Combined_buffer.dissolve()
    
    gdf_Transit_Combined_buffer_dissolve['WalkBuff'] = 1
    
    gdf_Transit_Combined_buffer_dissolve = gdf_Transit_Combined_buffer_dissolve[
        ['WalkBuff',
         'geometry']
    ]
    
    
    # ----------------------------------------------------------------------------------------
    # calculate Walk Buffer percent
    # ----------------------------------------------------------------------------------------
    # print to console & log file
    print("    calculate Walk Buffer percent")
    logFile.write("    calculate Walk Buffer percent\n")
    
    
    # calculate TAZ area -----------------------------------------------------------
    # print to console & log file
    print("        calculate TAZ area")
    logFile.write("        calculate TAZ area\n")
    
    
    # intersect TAZ & buffer
    gdf_TAZ_Area = gdf_TAZ.copy()
    
    gdf_TAZ_Area['AreaTAZ'] = gdf_TAZ['geometry'].area
    
    
    # intersect TAZ & local bus buffer ---------------------------------------------
    # print to console & log file
    print("        intersect TAZ & local bus buffer")
    logFile.write("        intersect TAZ & local bus buffer\n")
    
    
    # intersect TAZ & buffer
    gdf_TAZ_Local_intersect = gdf_TAZ_Area.overlay(gdf_Transit_Local_buffer_dissolve, how='intersection')
    
    
    # calculate local bus Walk Buffer percent --------------------------------------
    # print to console & log file
    print("        calculate local bus Walk Buffer percent")
    logFile.write("        calculate local bus Walk Buffer percent\n")
    
    
    # calculate area of intersected polygon
    gdf_WalkBuffer_Local = gdf_TAZ_Local_intersect.copy()
    
    gdf_WalkBuffer_Local['AreaLocal'] = gdf_WalkBuffer_Local['geometry'].area
    
    
    # calculate walk %
    gdf_WalkBuffer_Local['WalkLocal'] = 0.0
    
    gdf_WalkBuffer_Local.loc[gdf_WalkBuffer_Local['AreaTAZ']>0, 'WalkLocal'] = \
        gdf_WalkBuffer_Local['AreaLocal'] / gdf_WalkBuffer_Local['AreaTAZ'] * 100
    
    # round to 1 decimal place
    gdf_WalkBuffer_Local['WalkLocal'] = gdf_WalkBuffer_Local['WalkLocal'].round(0)
    
    
    # select fields
    df_WalkBuffer_Local = gdf_WalkBuffer_Local[
        ['TAZID',
         'AreaTAZ',
         'WalkBuff',
         'AreaLocal',
         'WalkLocal']
    ]
    
    
    # intersect TAZ & premium modes buffer -----------------------------------------
    # print to console & log file
    print("        intersect TAZ & premium modes buffer")
    logFile.write("        intersect TAZ & premium modes buffer\n")
    
    
    # intersect TAZ & buffer
    gdf_TAZ_Premium_intersect = gdf_TAZ_Area.overlay(gdf_Transit_Premium_buffer_dissolve, how='intersection')
    
    
    # calculate premium modes Walk Buffer percent ----------------------------------
    # print to console & log file
    print("        calculate premium modes Walk Buffer percent")
    logFile.write("        calculate premium modes Walk Buffer percent\n")
    
    
    # calculate area of intersected polygon
    gdf_WalkBuffer_Premium = gdf_TAZ_Premium_intersect.copy()
    
    gdf_WalkBuffer_Premium['AreaPrem'] = gdf_WalkBuffer_Premium['geometry'].area
    
    
    # calculate walk %
    gdf_WalkBuffer_Premium['WalkPrem'] = 0.0
    
    gdf_WalkBuffer_Premium.loc[gdf_WalkBuffer_Premium['AreaTAZ']>0, 'WalkPrem'] = \
        gdf_WalkBuffer_Premium['AreaPrem'] / gdf_WalkBuffer_Premium['AreaTAZ'] * 100
    
    # round to 1 decimal place
    gdf_WalkBuffer_Premium['WalkPrem'] = gdf_WalkBuffer_Premium['WalkPrem'].round(0)
    
    
    # select fields
    df_WalkBuffer_Premium = gdf_WalkBuffer_Premium[
        ['TAZID',
         'AreaTAZ',
         'WalkBuff',
         'AreaPrem',
         'WalkPrem']
    ]
    
    
    # intersect TAZ & combined buffers ---------------------------------------------
    # print to console & log file
    print("        intersect TAZ & combined buffers")
    logFile.write("        intersect TAZ & combined buffers\n")
    
    
    # intersect TAZ & buffer
    gdf_TAZ_Combined_intersect = gdf_TAZ_Area.overlay(gdf_Transit_Combined_buffer_dissolve, how='intersection')
    
    
    # calculate combined Walk Buffer percent ---------------------------------------
    # print to console & log file
    print("        calculate combined Walk Buffer percent")
    logFile.write("        calculate combined Walk Buffer percent\n")
    
    
    # calculate area of intersected polygon
    gdf_WalkBuffer_Combined = gdf_TAZ_Combined_intersect.copy()
    
    gdf_WalkBuffer_Combined['AreaComb'] = gdf_WalkBuffer_Combined['geometry'].area
    
    
    # calculate walk %
    gdf_WalkBuffer_Combined['WalkComb'] = 0.0
    
    gdf_WalkBuffer_Combined.loc[gdf_WalkBuffer_Combined['AreaTAZ']>0, 'WalkComb'] = \
        gdf_WalkBuffer_Combined['AreaComb'] / gdf_WalkBuffer_Combined['AreaTAZ'] * 100
    
    # round to 1 decimal place
    gdf_WalkBuffer_Combined['WalkComb'] = gdf_WalkBuffer_Combined['WalkComb'].round(0)
    
    
    # select fields
    df_WalkBuffer_Combined = gdf_WalkBuffer_Combined[
        ['TAZID',
         'AreaTAZ',
         'WalkBuff',
         'AreaComb',
         'WalkComb']
    ]
    
    # create final Walk Buffer shapefile -------------------------------------------
    # print to console & log file
    print("        create final Walk Buffer shapefile")
    logFile.write("        create final Walk Buffer shapefile\n")
    
    
    # process TAZ gdf & combined, local bus, & premium modes buffer df for final Walk Buffer merge
    gdf_TAZ_Area_temp = gdf_TAZ_Area[
        ['TAZID',
         'WALK100',
         'AreaTAZ',
         'geometry']
    ]
    
    df_WalkBuffer_Combined_temp = df_WalkBuffer_Combined[
        ['TAZID',
         'WalkComb',
         'AreaComb']
    ]
    
    df_WalkBuffer_Local_temp = df_WalkBuffer_Local[
        ['TAZID',
         'WalkLocal',
         'AreaLocal']
    ]
    
    df_WalkBuffer_Premium_temp = df_WalkBuffer_Premium[
        ['TAZID',
         'WalkPrem',
         'AreaPrem']
    ]
    
    
    # merge buffer data to TAZ
    gdf_TAZ_WalkBuffer = pd.DataFrame.merge(
        gdf_TAZ_Area_temp,
        df_WalkBuffer_Combined_temp,
        how="left",
        left_on='TAZID',
        right_on='TAZID'
    )
    
    gdf_TAZ_WalkBuffer = pd.DataFrame.merge(
        gdf_TAZ_WalkBuffer,
        df_WalkBuffer_Local_temp,
        how="left",
        left_on='TAZID',
        right_on='TAZID'
    )
    
    gdf_TAZ_WalkBuffer = pd.DataFrame.merge(
        gdf_TAZ_WalkBuffer,
        df_WalkBuffer_Premium_temp,
        how="left",
        left_on='TAZID',
        right_on='TAZID'
    )
    
    
    # fill na data
    gdf_TAZ_WalkBuffer = gdf_TAZ_WalkBuffer.fillna(0)
    
    
    # calculate final walk % field
    gdf_TAZ_WalkBuffer['WalkPct'] = gdf_TAZ_WalkBuffer['WalkComb']
    gdf_TAZ_WalkBuffer.loc[gdf_TAZ_WalkBuffer['WALK100']>0, 'WalkPct'] = gdf_TAZ_WalkBuffer['WALK100']
    
    
    # write out final Walk Buffer table & shapefile
    gdf_TAZ_WalkBuffer = gdf_TAZ_WalkBuffer[
        ['TAZID',
         'WalkPct',
         'WALK100',
         'WalkComb',
         'WalkLocal',
         'WalkPrem',
         'AreaTAZ',
         'AreaComb',
         'AreaLocal',
         'AreaPrem',
         'geometry']
    ]
    
    
    # export to shapefile
    path_out_WalkBuffer_shp = os.path.join(path_outfolder_WalkBuffer, out_WalkBuffer_shp)
    
    gdf_TAZ_WalkBuffer.to_file(
        path_out_WalkBuffer_shp,
        driver='ESRI Shapefile'
    )
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end_WalkBuff     = time.time()
    gs.printElapsedTime(time_end_WalkBuff, time_begin_WalkBuff)
    gs.logElapsedTime(time_end_WalkBuff, time_begin_WalkBuff, logFile)
    
    
    
    # ============================================================================================================
    # Finish Script
    # ============================================================================================================
    #print to console & log file
    print("\n")
    print("")
    print("All Finished...")
    
    logFile.write("\n")
    logFile.write("\n")
    logFile.write("All Finished..." + "\n")
    
    
    # calculate elapsed time -------------------------------------------------------
    time_end     = time.time()
    time_elapsed = time_end - time_begin
    
    # format elapsed time (convert to string formated as 'HH:MM:SS.S')
    time_elapsed_txt = gs.ElapsedTime(time_elapsed)
    
    
    # format time stamps (convert to a string tuple formated as 'YYYY-MM-DD, HH:MM:SS')
    time_begin_txt = time.strftime('%Y-%m-%d, %H:%M:%S', time.localtime(time_begin))
    time_end_txt   = time.strftime('%Y-%m-%d, %H:%M:%S', time.localtime(time_end  ))
    
    
    # print to console & log file
    print("")
    print("    Start   Time: "  +  time_begin_txt)
    print("    End     Time: "  +  time_end_txt)
    print("    Elapsed Time: "  +  time_elapsed_txt)
    print("")
    
    logFile.write("\n")
    logFile.write("    Start   Time: "  +  time_begin_txt    +  "\n")
    logFile.write("    End     Time: "  +  time_end_txt      +  "\n")
    logFile.write("    Elapsed Time: "  +  time_elapsed_txt  +  "\n")
    logFile.write("\n")
    
    
    #close log file ----------------------------------------------------------------
    logFile.close()
    
    
    # pause console to check printed messages --------------------------------------
    #input("Press Enter to continue...")
    
    
    
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
    print("Please check '" + ScenarioDir + out_Log_txt + "' for error messages.")
    print("")
    print("")
    
    
    # pause console to check printed messages
    input("Press Enter to continue...")
    
    
    # exit python & hand control back to Cube
    sys.exit(1)
