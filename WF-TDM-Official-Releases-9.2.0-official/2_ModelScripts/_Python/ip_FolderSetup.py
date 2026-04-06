# Description:
#     This script sets up the model by creating the scenario directories
#
#     Date Edited: 08/16/2024


# ============================================================================================================
# System setup
# ============================================================================================================
print("\nRunning Python Script: 'ip_FolderSetup.py'")
print("\n\nSystem setup...")
print("\n    load python libraries")

import time
time_begin = time.time()
time_begin_SysSetup = time.time()
import os, sys, traceback
import importlib.machinery
import shutil
import glob
import _global_scripts as gs


# ----------------------------------------------------------------------------------------
# Define Functions
# ----------------------------------------------------------------------------------------
print("\n    define functions")

# function that will check if a file exists, and if not, copy over the file
def check_and_copy(target_file, src_file):
    try:
        if not os.path.exists(target_file):
            shutil.copy(src_file, target_file)
            print(f"Copied {src_file} to {target_file}")
        else:
            print(f"{target_file} already exists")
    except Exception as e:
        print(f"Error copying {src_file} to {target_file}: {e}")

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
    in_GlobalVar_txt     = "_CreateOutputFolders.txt"
    out_Log_txt          = "py_LogFile - ip_FolderSetup.txt"
    
    # create global variables from input file
    dir_ScriptLaunch = os.getcwd()
    #dir_ScriptLaunch = r"D:\GitHub\WF-TDM-v9x\Scenarios\WF TDM v910-Task2\BY_2019"
    
    # create path to global variables input file
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, in_GlobalVar_txt)
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()

    # create global parameters
    ParentDir         = GlobalVars.ParentDir
    ScenarioDir       = GlobalVars.ScenarioDir
    RID               = GlobalVars.RID
    ModelVersion      = GlobalVars.ModelVersion
    ScenarioGroup     = GlobalVars.ScenarioGroup
    RunYear           = GlobalVars.RunYear
    Run_vizTool       = GlobalVars.Run_vizTool
    
    # ----------------------------------------------------------------------------------------
    # update log file
    # ----------------------------------------------------------------------------------------
    # begin Log file
    path_Log_dir = os.path.join(ParentDir, ScenarioDir, "_Log")
    path_out_Log_txt = os.path.join(path_Log_dir, out_Log_txt)
    os.makedirs(path_Log_dir, exist_ok=True)
    logFile = open(path_out_Log_txt, 'w')
    
    # calculate elapsed time
    logFile.write("\nRunning Python Script: 'ip_FolderSetup.py'")
    logFile.write("\n\nSystem setup...")
    logFile.write("\n    load python libraries")
    logFile.write("\n    define functions")
    gs.logElapsedTime(time_end_SysSetup, time_begin_SysSetup, logFile)

    logFile.write("\n\nSpecifying Global Parameters...")
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    
    # ============================================================================================================
    # Create Folders for Scenario
    # ============================================================================================================
    # print to console & log file
    print("\n\nCreating Folders for Scenario...")
    logFile.write("\n\nCreating Folders for Scenario...")
    
    # get time (in seconds)
    time_begin_Folders = time.time()
    
    # ----------------------------------------------------------------------------------------
    # define list of directories and folders to copy/create
    # ----------------------------------------------------------------------------------------
    print("\n    define list of directories and folders to copy/create")
    logFile.write("\n    define list of directories and folders to copy/create")

    # list of directories
    directories = [
        f"{ParentDir}{ScenarioDir}\\_Log",
        f"{ParentDir}{ScenarioDir}\\_Log\\_debug",
        
        f"{ParentDir}{ScenarioDir}\\0_InputProcessing",
        f"{ParentDir}{ScenarioDir}\\0_InputProcessing\\ScenarioNet",
        f"{ParentDir}{ScenarioDir}\\0_InputProcessing\\UpdatedMasterNet",
        f"{ParentDir}{ScenarioDir}\\0_InputProcessing\\WalkBuffer",
        f"{ParentDir}{ScenarioDir}\\0_InputProcessing\\Transit",
        
        f"{ParentDir}{ScenarioDir}\\1_HHDisag_AutoOwn",
        
        f"{ParentDir}{ScenarioDir}\\2_TripGen",
        
        f"{ParentDir}{ScenarioDir}\\3_Distribute",
        f"{ParentDir}{ScenarioDir}\\3_Distribute\\SumToDistricts",
        f"{ParentDir}{ScenarioDir}\\3_Distribute\\TLF",
        
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\1a_Skims",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\1b_EnumeratedRoutes",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\1c_Reports",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\2_DetailedTripMatrices",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\3_TransitAssign",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\4_Shares",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\5_DistrictSummary",
        f"{ParentDir}{ScenarioDir}\\4_ModeChoice\\NTL",
        
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\0_ConvergeReports",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\1_ODTables",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\2a_Networks",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\2b_Shapefiles",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\3_SelectLink",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\4_Summaries",
        f"{ParentDir}{ScenarioDir}\\5_AssignHwy\\5_FinalNetSkims",
        
        f"{ParentDir}{ScenarioDir}\\6_REMM",
        
        f"{ParentDir}{ScenarioDir}\\7_PostProcessing",
        
        f"{ParentDir}{ScenarioDir}\\Temp",
        f"{ParentDir}{ScenarioDir}\\Temp\\0_InputProcessing",
        f"{ParentDir}{ScenarioDir}\\Temp\\1_HHDisag_AutoOwn",
        f"{ParentDir}{ScenarioDir}\\Temp\\2_TripGen",
        f"{ParentDir}{ScenarioDir}\\Temp\\3_Distribute",
        f"{ParentDir}{ScenarioDir}\\Temp\\4_ModeChoice",
        f"{ParentDir}{ScenarioDir}\\Temp\\5_AssignHwy",
        f"{ParentDir}{ScenarioDir}\\Temp\\6_REMM",
        f"{ParentDir}{ScenarioDir}\\Temp\\7_PostProcessing"
    ]
    
    #list of files to copy
    copy_files = [
        (f"{ParentDir}{ScenarioDir}0_InputProcessing/default.vpr"       , f"{ParentDir}1_Inputs/3_Highway/_Preset VPR/ScenarioNet.VPR"                         ),
        (f"{ParentDir}{ScenarioDir}3_Distribute/default.vpr"            , f"{ParentDir}1_Inputs/3_Highway/_Preset VPR/LoadedNet.VPR"                           ),
        (f"{ParentDir}{ScenarioDir}5_AssignHwy/2a_Networks/default.vpr" , f"{ParentDir}1_Inputs/3_Highway/_Preset VPR/LoadedNet.VPR"                           ),
        
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_2_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_3_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_4_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_5_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_6_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_7_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_8_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_9_convg.VPR" , f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
        (f"{ParentDir}{ScenarioDir}Temp/3_Distribute/{RID}_10_convg.VPR", f"{ParentDir}2_ModelScripts/_CopyToFolders/Distrib_ConvVPR/UnloadedPrefix_N_convg.VPR"),
         
        (f"{ParentDir}{ScenarioDir}0_InputProcessing/_Urbanization.mxd" , f"{ParentDir}2_ModelScripts/_CopyToFolders/ArcMap_mxd/_Urbanization_ArcMap103.mxd"    ),
        (f"{ParentDir}{ScenarioDir}0_InputProcessing/_WalkBuffer.mxd"   , f"{ParentDir}2_ModelScripts/_CopyToFolders/ArcMap_mxd/_WalkBuffer_ArcMap103.mxd"      )
    ]
    
    # ----------------------------------------------------------------------------------------
    # create and copy folders/directories
    # ----------------------------------------------------------------------------------------
    print("\n    copy and create model scenario directories")
    logFile.write("\n    copy and create model scenario directories")
    
    
    # Create directories if they do not exist
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    
    # Process each task
    for target, src in copy_files:
        check_and_copy(target, src)
    
    # calculate elapsed time
    time_end_Folders = time.time()
    gs.printElapsedTime(time_end_Folders, time_begin_Folders)
    gs.logElapsedTime(time_end_Folders, time_begin_Folders, logFile)
    
    
    # ============================================================================================================
    # Create Folders for vizTool 
    # ============================================================================================================
    if Run_vizTool==1:

        # print to console & log file
        print("\n\nCreating Folders for vizTool...")
        logFile.write("\n\nCreating Folders for vizTool...")

        # get time (in seconds)
        time_begin_vizFolders = time.time()

        # ----------------------------------------------------------------------------------------
        # define list of directories and folders to copy/create
        # ----------------------------------------------------------------------------------------
        print("\n    define list of directories and folders to copy/create")
        logFile.write("\n    define list of directories and folders to copy/create")

        # list of directories
        viz_directories = [
            f"{ParentDir}Scenarios\\.vizTool"                                                           ,
            f"{ParentDir}Scenarios\\.vizTool\\app"                                                      ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\layouts"                                             ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\scenarios"                                           ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\templates"                                           ,
            f"{ParentDir}Scenarios\\.vizTool\\app\widgets"                                              ,
            f"{ParentDir}Scenarios\\.vizTool\\config"                                                   ,
            f"{ParentDir}Scenarios\\.vizTool\\config\\schema"                                           ,
            f"{ParentDir}Scenarios\\.vizTool\\scenario-data"                                            ,
            f"{ParentDir}Scenarios\\.vizTool\\geo-data"                                                 ,
            f"{ParentDir}Scenarios\\.vizTool\\geo-data\\keys"                                           ,
            f"{ParentDir}Scenarios\\.vizTool\\scenario-data\\{ModelVersion}__{ScenarioGroup}__{RunYear}"
        ]

        viz_copy_target = [
            f"{ParentDir}Scenarios\\.vizTool"                  ,
            f"{ParentDir}Scenarios\\.vizTool\\app"             ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\layouts"    ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\scenarios"  ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\templates"  ,
            f"{ParentDir}Scenarios\\.vizTool\\app\\widgets"    ,

        ]

        viz_copy_source = [
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool"                 ,
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\app"            ,
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\app\\layouts"   ,
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\app\\scenarios" ,
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\app\\templates" ,
            f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\app\\widgets"   
        ]

        #list of files to copy
        viz_copy_files = [
            (f"{ParentDir}Scenarios\\.vizTool\\config\\aggregators.json"             , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\aggregators.json"            ),
            (f"{ParentDir}Scenarios\\.vizTool\\config\\app.json"                     , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\app.json"                    ),
            (f"{ParentDir}Scenarios\\.vizTool\\config\\attributes.json"              , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\attributes.json"             ),
            (f"{ParentDir}Scenarios\\.vizTool\\config\\dividers.json"                , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\dividers.json"               ),
            (f"{ParentDir}Scenarios\\.vizTool\\config\\filters.json"                 , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\filters.json"                ),
            (f"{ParentDir}Scenarios\\.vizTool\\config\\schema\\scenario-schema.json" , f"{ParentDir}2_ModelScripts\\_CopyToFolders\\vizTool\\config\\schema\\scenario-schema.json")
        ]

        # ----------------------------------------------------------------------------------------
        # create and copy folders/directories
        # ----------------------------------------------------------------------------------------
        print("\n    copy and create model scenario directories")
        logFile.write("\n    copy and create model scenario directories")

        # Create directories if they do not exist
        for directory in viz_directories:
            os.makedirs(directory, exist_ok=True)

        # Copy files in directories with wildcard patterns
        for target_dir, source_dir in zip(viz_copy_target, viz_copy_source):
            if os.path.isdir(source_dir):
                for filename in os.listdir(source_dir):
                    src_file = os.path.join(source_dir, filename)
                    target_file = os.path.join(target_dir, filename)
                    check_and_copy(target_file, src_file)
            else:
                print(f"Source directory {source_dir} does not exist")

        # Process each task
        for target, src in viz_copy_files:
            check_and_copy(target, src)

        # calculate elapsed time
        time_end_vizFolders = time.time()
        gs.printElapsedTime(time_end_vizFolders, time_begin_vizFolders)
        gs.logElapsedTime(time_end_vizFolders, time_begin_vizFolders, logFile)

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
    