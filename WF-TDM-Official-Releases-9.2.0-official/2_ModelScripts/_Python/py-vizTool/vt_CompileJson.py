# Description:
#     This script creates the json files to be used in the vizTool
#
#     Date Edited: 08/20/2024

# ============================================================================================================
# System setup
# ============================================================================================================
print("\nRunning Python Script: 'vt_CompileJsons.py'")
print("\n\nSystem setup...")
print("\n    load python libraries")

import sys, os, time, traceback
time_begin = time.time()
time_begin_SysSetup = time.time()
import pandas as pd
import importlib.machinery
import json
import numpy as np
import time


parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)
import _global_scripts as gs
import _json_scripts as js

# calculate elapsed time
time_end_SysSetup = time.time()
gs.printElapsedTime(time_end_SysSetup, time_begin_SysSetup)


# ============================================================================================================
# Debug Setup and Launch Location (LAUNCH LOCATION SHOULD BE MOVED TO ARGUMENT OF PYTHON CALL)
# ============================================================================================================
debug = False
#debug = True

if not debug:
    dir_ScriptLaunch = os.getcwd()
else:
    dir_ScriptLaunch = r"D:\GitHub\WF-TDM-v9x\Scenarios\WF TDM v910-Task2\Needs_2050"

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
    out_Log_txt_base     = "py_LogFile - vt_CompileJson"
    out_Filenames_csv    = "py_Filenames - vt_GeoJsons.csv"

    # create path to global variables input file
    path_in_GlobalVar_txt = os.path.join(dir_ScriptLaunch, "_Log", in_GlobalVar_txt)
    
    # create variables from input file global variables
    GlobalVars = importlib.machinery.SourceFileLoader('data', path_in_GlobalVar_txt).load_module()

    # create global parameters
    jsonId        = GlobalVars.jsonId
    ParentDir     = GlobalVars.ParentDir
    ScenarioDir   = GlobalVars.ScenarioDir
    ModelVersion  = GlobalVars.ModelVersion
    ScenarioGroup = GlobalVars.ScenarioGroup
    RunYear       = GlobalVars.RunYear
    
    # specifiy inputs
    print("\n    define input/output locations")
    input_file = GlobalVars.inputFile
    
    # define scenario
    _scenarioCode = ModelVersion + '__' + ScenarioGroup + '__' + str(RunYear)

    # define output path
    output_path = os.path.join(ParentDir, r"Scenarios\\.vizTool\\scenario-data\\" + _scenarioCode + "\\")
    
    # Ensure output path exists
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    
    #define vizTool scripts path
    vizscripts_path = ParentDir + "2_ModelScripts\_Python\py-vizTool"
    
    # ----------------------------------------------------------------------------------------
    # begin log file
    # ----------------------------------------------------------------------------------------
    out_Log_txt = out_Log_txt_base + '-' + jsonId + '.txt'
    path_out_Log_txt = os.path.join(ParentDir, ScenarioDir, "_Log", out_Log_txt)
    logFile = open(path_out_Log_txt, 'w')
    
    # calculate elapsed time
    logFile.write("\n\nRunning Python Script: 'vt_CompileJson.py'")

    if debug:
        print("--------------------------------------------------------------------------------------")
        print("DEBUG MODE ON... IF RUNNING ACTUAL MODEL, PLEASE TURN OFF DEBUG MODE IN PYTHON SCRIPT!")
        print("--------------------------------------------------------------------------------------")

        logFile.write("--------------------------------------------------------------------------------------")
        logFile.write("DEBUG MODE ON... IF RUNNING ACTUAL MODEL, PLEASE TURN OFF DEBUG MODE IN PYTHON SCRIPT!")
        logFile.write("--------------------------------------------------------------------------------------")

        time.sleep(10)  # Pause for 10 seconds
        
    logFile.write("\n\nSystem setup...")
    logFile.write("\n    load python libraries")
    gs.logElapsedTime(time_end_SysSetup, time_begin_SysSetup, logFile)
    
    logFile.write("\n\nSpecifying Global Parameters & Input-Output Files...")
    logFile.write("\n    define input/output locations")
    
    time_end_GlobalParam = time.time()
    gs.printElapsedTime(time_end_GlobalParam, time_begin_GlobalParam)
    gs.logElapsedTime(time_end_GlobalParam, time_begin_GlobalParam, logFile)
    
    
    # ============================================================================================================
    # Config Parameters and Other Inputs
    # ============================================================================================================
    print("\n\nSpecifying vizTool Config Parameters and Inputs...")
    print("\n    read " + vizscripts_path + "\\configs\\" + jsonId + ".json")
    logFile.write("\n\nSpecifying vizTool Config Parameters and Inputs...")
    logFile.write("\n    read " + vizscripts_path + "\\configs\\" + jsonId + ".json")
    
    # get time (in seconds) 
    time_begin_ConfigParam = time.time()

    # read in viztool config file and get json variables
    with open(vizscripts_path + "\\configs\\" + jsonId + ".json") as file:
        config_data = json.load(file)

    # read output file name & create path for it
    output_file_name = config_data.get("outputFileName")
    output_file = os.path.join(output_path, output_file_name)
    
    # define config parameters
    print("\n    read in config params")
    logFile.write("\n    read in config params")
    
    group_csv               = config_data.get("groupCsv"                 , False) # aggregate by col column values
    some_atts_have_dup_data = config_data.get("someAttsHaveDuplicateData", False) # when duplication of data in rows, duplicates for repetive column keys are removed
    filter_col              = config_data.get("filterCol"                , ""   ) # column to filter
    filter_val              = config_data.get("filterVal"                , ""   ) # value to filter 
    id_col                  = config_data.get("idCol"                    , ""   ) # id column
    single_col_att_val      = config_data.get("tdmCsvSingleColumnForAtts", False) # if attributes are listed in a column
    key_file                = config_data.get("keyFile"                  , False) # info to access file with a key lookup for id
    
    # ----------------------------------------------------------------------------------------
    # Set attributes and filters
    # ----------------------------------------------------------------------------------------
    print("\n    set attributes and filters")
    logFile.write("\n    set attributes and filters")
    
    attributes_df = pd.DataFrame(config_data.get("attributes", []))
    filters_df    = pd.DataFrame(config_data.get("filters", [])).fillna("")

    # Get a list of the filters that have their own csv columns
    # Check if 'filterLocation' column exists and filter accordingly
    if 'filterLocation' in filters_df.columns:
        # Check if there are any rows with 'filterLocation' == 'long'
        filters_own_col_lst = filters_df[filters_df['filterLocation'] == 'long']['filterCode'].tolist()
    else:
        # If the 'filterLocation' column does not exist, return an empty list
        filters_own_col_lst = []

    # ----------------------------------------------------------------------------------------
    # Column keys and melt parameters
    # ----------------------------------------------------------------------------------------
    print("\n    create column keys and met parameters dataframe")
    logFile.write("\n    create column keys and met parameters dataframe")
    
    # Initialize an empty list to store rows
    rows = []
    
    # if single column attributes and values then there is no need for colkeys and melt parameters
    if single_col_att_val:
        
        # Check if 'wideFilterSettings' exists and is a list
        if "wideFilterSettings" in single_col_att_val and isinstance(single_col_att_val["wideFilterSettings"], list) and len(single_col_att_val["wideFilterSettings"]) > 0:
            # Process the 'wideFilterSettings' column
            wideFilterSettings = single_col_att_val["wideFilterSettings"]
            
            for setting in wideFilterSettings:
                row = {
                    "tdmCsvColumn": setting["tdmCsvColumn"]
                }
                
                # Loop through filter settings to add filter values
                for filter_setting in setting["filterSettings"]:
                    filter_code = filter_setting["filterCode"]
                    filter_value = filter_setting.get("filterValue", filter_setting.get("fValue", None))
                    row[filter_code] = filter_value
                
                rows.append(row)
        
    else:
        
        # Loop through each row of the DataFrame using .iterrows()
        for index, attribute in attributes_df.iterrows():
            a_code = attribute["attributeCode"]
            
            # Check if 'wideFilterSettings' exists and is a list
            if "wideFilterSettings" in attribute and isinstance(attribute["wideFilterSettings"], list) and len(attribute["wideFilterSettings"]) > 0:
                # Process the 'wideFilterSettings' column
                wideFilterSettings = attribute["wideFilterSettings"]
                
                for setting in wideFilterSettings:
                    row = {
                        "attributeCode": a_code,
                        "tdmCsvColumn": setting["tdmCsvColumn"]
                    }
                    
                    # Loop through filter settings to add filter values
                    for filter_setting in setting["filterSettings"]:
                        filter_code = filter_setting["filterCode"]
                        filter_value = filter_setting.get("filterValue", filter_setting.get("fValue", None))
                        row[filter_code] = filter_value
                    
                    rows.append(row)
                    
            else:
                # If 'wideFilterSettings' does not exist or is empty, use 'tdmCsvColumn' directly
                row = {
                    "attributeCode": a_code,
                    "tdmCsvColumn": attribute["tdmCsvColumn"]
                }
                
                rows.append(row)
                
    # Convert list of rows into a DataFrame
    col_keys_and_melt_params_df = pd.DataFrame(rows)
    
    # Replace nan with None... maybe not needed but doing it anyway to match old config files\
    col_keys_and_melt_params_df = col_keys_and_melt_params_df.where(pd.notna(col_keys_and_melt_params_df), None)
    
    # print elapsed time
    time_end_ConfigParam = time.time()
    gs.printElapsedTime(time_end_ConfigParam, time_begin_ConfigParam)
    gs.logElapsedTime(time_end_ConfigParam, time_begin_ConfigParam, logFile)
    
    
    # ============================================================================================================
    # Reorganize and Generate Json Data for Routes
    # ============================================================================================================
    if (jsonId=='transitroutes'):
        print("\n\Generating Route Json Data...")
        print("\n    convert csv to json")
        logFile.write("\n\Generating Route Json Data...")
        logFile.write("\n    convert csv to json")

        # get time (in seconds) 
        time_begin_Routes = time.time()

        # Read the CSV into a dataframe, rename, drop duplicates, and save to a json file
        df = pd.read_csv(input_file, usecols=["Name","LongName","Mode"])
        df.rename(columns={'Name':'RouteName','LongName':'RouteLongName'}, inplace=True)
        df = df.drop_duplicates()
        df.to_json(output_file, orient='records')
        
        # print elapsed time
        time_end_Routes = time.time()
        gs.printElapsedTime(time_end_Routes, time_begin_Routes)
        gs.logElapsedTime(time_end_Routes, time_begin_Routes, logFile)
    
    
    # ============================================================================================================
    # Reorganize and Generate Json Data for All Others
    # ============================================================================================================
    else:
        # ----------------------------------------------------------------------------------------
        # Reorganize Json Data
        # ----------------------------------------------------------------------------------------
        print("\n\nReorganizing Json Data...")
        print("\n    read csv input file: '" + input_file +"'")
        logFile.write("\n\nReorganizing Json Data...")
        logFile.write("\n    read in csv input file: '" + input_file +"'")
        
        # get time (in seconds) 
        time_begin_Reorganize = time.time()
        
        # Read the CSV into a dataframe and filter
        print("\n    filter dataframe"); logFile.write("\n    filter dataframe")
        df = pd.read_csv(input_file)
        df = js.filter_df(df, filter_col, filter_val, logFile)

        # Add id_col to dataframe if key file
        if key_file:
            filenames_df = pd.read_csv(os.path.join(ParentDir, ScenarioDir, "_Log", out_Filenames_csv))
            key_filename = filenames_df.loc[filenames_df['fileCode'] == key_file['fileCode'], 'filename'].iloc[0]
            key_df = pd.read_csv(key_filename)
            df = pd.merge(df, key_df, on=(key_file['keyCols']))

        # Copy dataframe, set dummyVal, and rename various columns
        print("\n    rename dataframe"); logFile.write("\n    rename dataframe")
        df['dummyVal'] = ''
        df = js.rename_df(df, filters_df, logFile)

        # Group and Sum based on duplicate index values
        print("\n    group and sum csv columns"); logFile.write("\n    group and sum csv columns")
        df = js.group_csv_df(df, group_csv, id_col, attributes_df, filters_own_col_lst, logFile)

        # Reorganize the data if the attributes are stuck inside one singular column
        print("\n    melt dataframe"); logFile.write("\n    melt dataframe")
        melt_with_keys_df = js.melt_df(df, single_col_att_val, id_col, filters_own_col_lst, col_keys_and_melt_params_df, logFile)

        if debug: melt_with_keys_df.to_csv(os.path.join(ParentDir, ScenarioDir, '_Log/_debug/debug_melt_with_keys_df_before_duplicates.csv'), index=False)

        # Remove Deuplicate data in the dataframe if then exist
        print("\n    remove duplicates from dataframe"); logFile.write("\n    remove duplicates from dataframe")
        melt_with_keys_df = js.remove_duplicates(melt_with_keys_df, attributes_df, some_atts_have_dup_data, logFile)

        # Define index columns
        index_cols = [col for col in melt_with_keys_df.columns if col not in ['attributeCode','val','tdmCsvColumn']]

        # Double check for duplicates before pivoting
        print("\n    double check for duplicates"); logFile.write("\n    double check for duplicates")
        melt_with_keys_df = js.double_check_duplicates(melt_with_keys_df, index_cols, debug, logFile, ParentDir, ScenarioDir)

        if debug: melt_with_keys_df.to_csv(os.path.join(ParentDir, ScenarioDir, '_Log/_debug/debug_melt_with_keys_df_before_pivot.csv'), index=False)

        # Pivot dataframe
        print("\n    pivot dataframe"); logFile.write("\n    pivot dataframe")
        melt_with_keys_pivot_atts_df = js.pivot_df(melt_with_keys_df, index_cols, logFile)

        # Drop unneeded columns from dataframe
        print("\n    drop unneeded columns "); logFile.write("\n    drop unneeded columns")
        melt_with_keys_pivot_atts_df = js.drop_columns(melt_with_keys_pivot_atts_df, True, logFile)
        
        # Convert all int64 columns to Python int
        int_columns = melt_with_keys_pivot_atts_df.select_dtypes(include=['int64']).columns
        melt_with_keys_pivot_atts_df[int_columns] = melt_with_keys_pivot_atts_df[int_columns].astype(int)

        # Assign final varaible
        data_with_keys_df = melt_with_keys_pivot_atts_df

        # print elapsed time
        time_end_Reorganize = time.time()
        gs.printElapsedTime(time_end_Reorganize, time_begin_Reorganize)
        gs.logElapsedTime(time_end_Reorganize, time_begin_Reorganize, logFile)

        
        # ----------------------------------------------------------------------------------------
        # Generate Json Data
        # ----------------------------------------------------------------------------------------
        print("\n\nGenerate Json Data...")
        print("\n    run generate_scenario_json function")
        logFile.write("\n\nGenerate Json Data...")
        logFile.write("\n    run generate_scenario_json function")
        
        # get time (in seconds) 
        time_begin_Generate = time.time()
        
        # create lookup for fast finding of rounding decimals
        # Check if 'roundingDecimals' column exists, if not create it with default value 0
        if 'roundingDecimals' not in attributes_df.columns:
            attributes_df['roundingDecimals'] = 0
        else:
            # If the column exists, fill NaN values with 0 and convert to integer
            attributes_df['roundingDecimals'] = attributes_df['roundingDecimals'].fillna(0).astype(int)
        round_decimals_lookup = attributes_df.set_index('attributeCode')['roundingDecimals'].to_dict()
        
        # create json filters list
        filters_with_options_df = js.get_json_filters(data_with_keys_df, filters_df, logFile)
        
        # get list of fitler groups (any column that begins with f)
        f_cols_lst = [col for col in data_with_keys_df.columns if col.startswith('f')]
        data_with_keys_df[f_cols_lst] = data_with_keys_df[f_cols_lst].fillna('')
        
        # get list of unique filter group combinations
        combinations_lst = js.get_lst_combinations(data_with_keys_df, f_cols_lst, logFile)
        
        # initilize looping variables
        filter_a_codes_df = pd.DataFrame()
        json_data_combined = {}
        
        # loop through all combinations in list
        print("\n    loop through all filter combinations"); logFile.write("\n    loop through all filter combinations")
        for combination in combinations_lst:
            # create string of column names with a 1 for a given combination
            filter_cols_with_value_1 = [col for idx, col in enumerate(f_cols_lst) if combination[idx] == 1]
            filter_combo_str = '_'.join(filter_cols_with_value_1)

            filter_descriptions = filters_df[filters_df['filterCode'].isin(filter_cols_with_value_1)]['filterDescription'].to_list()

            print("\n\n    filter combo: " + str(filter_descriptions)); logFile.write("\n\n    filter combo: " + str(filter_descriptions))
            
            # filter df
            filtered_noNA_df = js.get_filtered_df(combination, data_with_keys_df, f_cols_lst)

            # create an attribute/filter group list
            filter_a_codes_df = js.get_a_cols(filtered_noNA_df, filter_combo_str, filter_a_codes_df)
            
            # Get the list of attributeCode values that match the filter_combo_str
            attribute_codes_list = filter_a_codes_df[filter_a_codes_df['filterGroup'] == filter_combo_str]['attributeCode'].to_list()

            # Filter the attributes_df based on the attributeCode list and extract the corresponding attributeDescription values
            attribute_descriptions = attributes_df[attributes_df['attributeCode'].isin(attribute_codes_list)]['attributeDescription'].to_list()

            print("\n        attributes: " + str(attribute_descriptions)); logFile.write("\n        attributes: " + str(attribute_descriptions))

            # drop empty filter columns
            df2 = js.drop_empty_f_cols(filtered_noNA_df)
            
            # get unique filter values
            f_cols_remain = [col for col in df2.columns if col.startswith('f')]
            filter_options_df = js.drop_duplicate_f_cols(df2, f_cols_remain)
            
            # loop through filter option rows
            print("\n        looping through all rows for filter group...\n"); logFile.write("\n        looping through all rows for filter group...\n")
            for count, (index, row) in enumerate(filter_options_df.iterrows(), start=1):
                        
                # Applying the function to each element and joining with '_'
                filter_row_index = '_'.join(row.apply(js.convert_to_int_if_whole_number).values)
                
                # Create filter condition
                filtered_df2 = js.create_filter_condition(row, filter_options_df, df2, f_cols_remain)
                
                # initilize looping variables
                noI_df2 = filtered_df2.reset_index()
                json_data_for_filter_option = {}
                
                # Loop through individual filter option rows
                js.progress_bar(count, len(filter_options_df))
                for index, row in noI_df2.iterrows():
                    
                    # get row dictionary for columns that start with 'a'
                    row_dict = js.get_row_dict(row, noI_df2, round_decimals_lookup)
                    
                    # Get filter option for json data
                    json_data_for_filter_option = js.get_filter_option_json_data(row, id_col, row_dict, json_data_for_filter_option)
                    
                json_data_combined.update({filter_row_index: json_data_for_filter_option})
        
        
        # Define final JSON structure
        print("\n\n    define final JSON structure"); logFile.write("\n\n    define final JSON structures")
        json_scenario_details = _scenarioCode
        attributes_with_filter_df = pd.DataFrame.merge(attributes_df, filter_a_codes_df, on='attributeCode').fillna("")
        json_attributes = attributes_with_filter_df.to_dict(orient='records')
        json_filters = filters_with_options_df.to_dict(orient='records')


        # Convert numpy data types to Python native types recursively
        def convert_to_native(obj):
            if isinstance(obj, np.integer):
                return int(obj)
            elif isinstance(obj, np.floating):
                return float(obj)
            elif isinstance(obj, np.ndarray):
                return obj.tolist()  # Convert arrays to lists
            elif isinstance(obj, dict):
                return {key: convert_to_native(value) for key, value in obj.items()}
            elif isinstance(obj, list):
                return [convert_to_native(element) for element in obj]
            return obj

        # Construct final JSON structure and convert numpy types
        json_scenario = convert_to_native({
            'scenarioCode': json_scenario_details,
            'attributes': json_attributes,
            'filters': json_filters,
            'data': json_data_combined
        })

        # Write out JSON output
        with open(output_file, 'w') as file:
            json.dump(json_scenario, file, separators=(',', ':'))
        
        # print elapsed time
        time_end_Generate = time.time()
        gs.printElapsedTime(time_end_Generate, time_begin_Generate)
        gs.logElapsedTime(time_end_Generate, time_begin_Generate, logFile)
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
    print(" ============================================================================================================")
    print("*** There was an error running this script")
    print("Please check '" + ScenarioDir + "\\_Log\\" + out_Log_txt + "' for error messages.")
    print("PYTHON ERRORS:\n")
    print("Traceback info:\n")
    print(msg_error_traceback)
    print("Error Info:")
    print(msg_error_system)
    
    
    
    # pause console to check printed messages
    input("Press Enter to continue...")
    
    
    # exit python & hand control back to Cube
    sys.exit(1)
