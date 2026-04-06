# Description:
#     This script calculates additional ATO metrics.
#
#     Date Edited: 05/19/2025


# ============================================================================================================
# System setup
# ============================================================================================================
print("\nRunning Python Script: 'as_AccessToOpportunity.py'")
print("\n\nSystem setup...")
print("\n    load python libraries")

import time
time_begin = time.time()
time_begin_SysSetup = time.time()
import os, sys, traceback
import importlib.machinery
import pandas as pd
import geopandas as gpd
import _global_scripts as gs


# ----------------------------------------------------------------------------------------
# Define Functions
# ----------------------------------------------------------------------------------------
print("\n    define functions")

#compute geo‐avgrages for any one aggregated DataFrame
def compute_avg(df, group_col, sum_cols):
    # group & sum
    sub = df.groupby(group_col)[sum_cols].sum().reset_index()
    # compute the “geo avgrage” metrics
    sub['act_Job_byAuto_geo_avg']  = sub['act_Job_byAuto'] / sub['HH']
    sub['act_Job_byTran_geo_avg']  = sub['act_Job_byTran'] / sub['HH']
    sub['act_Job_byBike_geo_avg']  = sub['act_Job_byBike'] / sub['HH']
    sub['act_Job_byWalk_geo_avg']  = sub['act_Job_byWalk'] / sub['HH']
    sub['act_HH_byAuto_geo_avg']   = sub['act_HH_byAuto']  / sub['Job']
    sub['act_HH_byTran_geo_avg']   = sub['act_HH_byTran']  / sub['Job']
    sub['act_HH_byBike_geo_avg']   = sub['act_HH_byBike']  / sub['Job']
    sub['act_HH_byWalk_geo_avg']   = sub['act_HH_byWalk']  / sub['Job']
    return sub

# calculate elapsed time
time_end_SysSetup = time.time()
gs.printElapsedTime(time_end_SysSetup, time_begin_SysSetup)



try:
    # ============================================================================================================
    # Global Parameters
    # ============================================================================================================
    print("\n\nSpecifying Global Parameters...")
    
    # get time (in seconds) 
    time_begin_GlobalParam = time.time()
    
    # ----------------------------------------------------------------------------------------
    # specify global parameters
    # ----------------------------------------------------------------------------------------
    in_GlobalVar_txt     = "py_Variables - as_AccessToOpportunityVars.txt"
    out_Log_txt          = "py_LogFile - as_AccessToOpportunity.txt"
    
    # create global variables from input file
    dir_ScriptLaunch = os.getcwd()
    #dir_ScriptLaunch = r"E:\GitHub\WF-TDM-v9x\Scenarios\v910-official\BY_2019"
    
    # create path to global variables input file
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, "_Log", in_GlobalVar_txt)
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()
    
    # create global parameters
    ParentDir         = GlobalVars.ParentDir
    ScenarioDir       = GlobalVars.ScenarioDir
    RID               = GlobalVars.RID
    ModelVersion      = GlobalVars.ModelVersion
    ScenarioGroup     = GlobalVars.ScenarioGroup
    RunYear           = GlobalVars.RunYear
    in_TAZ_shp        = GlobalVars.TAZ_DBF.replace(".dbf", ".shp")
    in_ATO_csv        = GlobalVars.ATO_CSV
    
    # define paths
    path_taz_shp      = os.path.join(ParentDir, r'1_Inputs\1_TAZ', in_TAZ_shp)
    out_ATO_csv       = os.path.join(ParentDir, ScenarioDir, '5_AssignHwy//4_Summaries//' + RID + '_Access_to_Opportunity_expanded.csv')
    
    
    # ----------------------------------------------------------------------------------------
    # update log file
    # ----------------------------------------------------------------------------------------
    # begin Log file
    path_Log_dir = os.path.join(ParentDir, ScenarioDir, "_Log")
    path_out_Log_txt = os.path.join(path_Log_dir, out_Log_txt)
    os.makedirs(path_Log_dir, exist_ok=True)
    logFile = open(path_out_Log_txt, 'w')
    
    # calculate elapsed time
    logFile.write("\nRunning Python Script: 'as_AccessToOpportunity.py'")
    logFile.write("\n\nSystem setup...")
    logFile.write("\n    load python libraries")
    logFile.write("\n    define functions")
    gs.logElapsedTime(time_end_SysSetup, time_begin_SysSetup, logFile)
    
    logFile.write("\n\nSpecifying Global Parameters...")
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    
    # ============================================================================================================
    # Calculate additional ATO Metrics (Geography avgrages)
    # ============================================================================================================
    # print to console & log file
    print("\n\nCalculate additional ATO Metrics...")
    logFile.write("\n\nCalculate additional ATO Metrics...")
    
    # get time (in seconds)
    time_begin_AtoCalc = time.time()
    
    # ----------------------------------------------------------------------------------------
    # read in ATO csv and TAZ dbf
    # ----------------------------------------------------------------------------------------
    print("\n    read in ATO csv and TAZ dbf")
    logFile.write("\n    read in ATO csv and TAZ dbf")
    
    # read in taz shapefile & convert to df
    gdf_taz = gpd.read_file(path_taz_shp)[['TAZID','PLANAREA','CO_NAME','CITYGRP']]
    gdf_taz = pd.DataFrame(gdf_taz)
    
    # read in ato csv
    df_ato = pd.read_csv(in_ATO_csv)
    
    # ----------------------------------------------------------------------------------------
    # calculate geography avgrages dictionary
    # ----------------------------------------------------------------------------------------
    print("\n    calculate geography avgrages dictionary")
    logFile.write("\n    calculate geography avgrages dictionary")
    
    # merge taz shapefile
    df_ato_geos = df_ato.merge(gdf_taz, on='TAZID', how='left')
    
    # list of metrics to sum
    sum_cols = ['HH','act_Job_byAuto','act_Job_byTran','act_Job_byBike','act_Job_byWalk','Job','act_HH_byAuto','act_HH_byTran','act_HH_byBike','act_HH_byWalk']
    
    # build the geography avgrage dictionary
    group_to_metric = {}
    group_cols = ['PLANAREA','CO_NAME','CITYGRP']
    for grp in group_cols:
        df_grp = compute_avg(df_ato_geos, grp, sum_cols)
        avg_cols = [c for c in df_grp.columns if c.endswith('_geo_avg')]

        for _, row in df_grp.iterrows():
            val = row[grp].replace(' ', '_')
            for col in avg_cols:
                metric = col[:-len('_geo_avg')].replace('act_', '')
                key = f"{metric}_rel_{val}"
                group_to_metric[key] = row[col]
    
    # compute the “Region” totals and geo‐avgrages
    region_sum = df_ato_geos[sum_cols].sum()
    region_df = pd.DataFrame([region_sum])
    
    region_df['act_Job_byAuto_geo_avg']  = region_df['act_Job_byAuto']  / region_df['HH']
    region_df['act_Job_byTran_geo_avg']  = region_df['act_Job_byTran']  / region_df['HH']
    region_df['act_Job_byBike_geo_avg']  = region_df['act_Job_byBike']  / region_df['HH']
    region_df['act_Job_byWalk_geo_avg']  = region_df['act_Job_byWalk']  / region_df['HH']
    region_df['act_HH_byAuto_geo_avg']   = region_df['act_HH_byAuto']   / region_df['Job']
    region_df['act_HH_byTran_geo_avg']   = region_df['act_HH_byTran']   / region_df['Job']
    region_df['act_HH_byBike_geo_avg']   = region_df['act_HH_byBike']   / region_df['Job']
    region_df['act_HH_byWalk_geo_avg']   = region_df['act_HH_byWalk']   / region_df['Job']
    
    region_avg_cols = [c for c in region_df.columns if c.endswith('_geo_avg')]
    for col in region_avg_cols:
        metric = col[:-len('_geo_avg')]
        metric = metric.replace('act_', '')
        key = f"{metric}_rel_Region"
        group_to_metric[key] = region_df.at[0, col]
    
    # ----------------------------------------------------------------------------------------
    # apply geography avgrages dictionary to calculate new ato metrics
    # ----------------------------------------------------------------------------------------
    print("\n    apply geography avgrages dictionary to calculate new ato metrics")
    logFile.write("\n    apply geography avgrages dictionary to calculate new ato metrics")
    
    df_ato_avg = df_ato.copy()
    
    # build a dict of all new series
    new_cols = {}
    for key, avg_value in group_to_metric.items():
        if "_rel_" not in key:
            continue
    
        metric, suffix = key.split("_rel_", 1)

        if metric not in df_ato_avg.columns:
            continue
    
        new_cols[key] = df_ato_avg[metric] / avg_value
    
    # turn that dict into a DataFrame & concatenate
    new_cols_df = pd.DataFrame(new_cols, index=df_ato_avg.index)
    df_ato_avg = pd.concat([df_ato_avg, new_cols_df], axis=1)
    
    # output expanded ato csv
    df_ato_avg.to_csv(out_ATO_csv, index=False)
    
    
    # calculate elapsed time
    time_end_AtoCalc = time.time()
    gs.printElapsedTime(time_end_AtoCalc, time_begin_AtoCalc)
    gs.logElapsedTime(time_end_AtoCalc, time_begin_AtoCalc, logFile)
    
    #close logFile
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
    print("Please check '" + ScenarioDir + "\\_Log\\" + out_Log_txt + "' for error messages.")
    print("")
    print("")
    
    
    # pause console to check printed messages
    input("Press Enter to continue...")
    
    
    # exit python & hand control back to Cube
    sys.exit(1)
    