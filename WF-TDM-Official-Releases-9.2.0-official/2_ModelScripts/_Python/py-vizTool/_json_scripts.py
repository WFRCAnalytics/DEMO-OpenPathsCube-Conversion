import json
import sys
import pandas as pd
import numpy as np
import os


# ============================================================================================================
# Global Json Functions
# ============================================================================================================
def progress_bar(iteration, total, length=50):
    percent = f"{100 * (iteration / float(total)):.1f}"
    filled_length = int(length * iteration // total)
    bar = "█" * filled_length + '-' * (length - filled_length)
    sys.stdout.write(f'\r|{bar}| {percent}% Complete')
    sys.stdout.flush()

# Define a function to convert to binary
def is_empty_or_not(value):
        return 0 if value == '' else 1


# Define a function to convert to an integer if it is a whole number
def convert_to_int_if_whole_number(value):
    try:
        float_val = float(value)
        if float_val.is_integer():
            return str(int(float_val))
        else:
            return str(float_val)
    except ValueError:
        return str(value)


# Define a function to round if numeric value
def round_if_numeric(x, decimals):
    if isinstance(x, (float, int)):
        return np.round(x, decimals)
    return x


# Defin a function to convert int64 to int
def convert_int64_to_int(data):
    if isinstance(data, dict):
        return {k: convert_int64_to_int(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [convert_int64_to_int(item) for item in data]
    elif isinstance(data, (np.integer, np.int64)):
        return int(data)
    else:
        return data



# ============================================================================================================
# Reorganize Json Functions
# ============================================================================================================
# Filter Function
def filter_df(df, filter_col, filter_val, logFile):
    if filter_col != "" and filter_val != "":
        print("\n        filtering..."); logFile.write("\n        filtering...")
        for col, val in zip(filter_col, filter_val):
            df = df[df[col] == val]
    return df


# Rename Function
def rename_df(_df, dfFilters, logFile):
    # Rename columns where some dataframes use different TAZID and SegID field names
    if "Z" in _df.columns:
        print("\n        renaming 'Z'..."); logFile.write("\n        renaming 'Z'...")
        _df.rename(columns={"Z": "TAZID"}, inplace=True)

    if "SEGID" in _df.columns:
        print("\n        renaming 'SEGID'..."); logFile.write("\n        renaming 'SEGID'...")
        _df.rename(columns={"SEGID": "SegID"}, inplace=True)

    # Rename columns based on dfFilters if 'tdmCsvColumn' is present
    if 'tdmCsvColumn' in dfFilters.columns:
        print("\n        renaming based on filters..."); logFile.write("\n        renaming based on filters...")
        rename_dict = dfFilters[dfFilters['filterLocation'] == 'long'].set_index('tdmCsvColumn')['filterCode'].dropna().to_dict()
        _df.rename(columns=rename_dict, inplace=True)
        
    return _df


# Melt Function
def melt_df(_df, single_col_att_val, id_col, filters_own_col_lst, col_keys_and_melt_params, logFile):

    if id_col:
        id_vars = [id_col] + filters_own_col_lst
    else:
        id_vars = filters_own_col_lst

    # Reorganize the data if the attributes are stuck inside one singular column
    if single_col_att_val:
        print('\n        single column attribute value...'); logFile.write('\n        single column attribute value...')

        melt_with_keys_df = (
            _df.rename(columns={single_col_att_val['tdmCsvColumn']: 'attributeCode'})
            .assign(attributeCode=lambda x: 'a' + x['attributeCode'].astype(str))
            .melt(id_vars=id_vars + ['attributeCode'], value_vars=col_keys_and_melt_params['tdmCsvColumn'].tolist(), var_name='tdmCsvColumn', value_name='val')
            .merge(col_keys_and_melt_params, on='tdmCsvColumn', how='left')
            .drop(columns=['tdmCsvColumn'])
        )

    # Melt the data, meaning make the dataframe long instead of wide
    else:
        print('\n        no single column attribute value...'); logFile.write('\n        no single column attribute value...')

        _df_melt = _df.melt(id_vars=id_vars, value_vars=col_keys_and_melt_params['tdmCsvColumn'].tolist(), var_name='tdmCsvColumn', value_name='val')
        melt_with_keys_df = pd.DataFrame.merge(_df_melt, col_keys_and_melt_params, on='tdmCsvColumn')
    
    return melt_with_keys_df


# Remove Duplicates Function
def remove_duplicates(melt_with_keys_df, attributes_df, some_atts_have_dup_data, logFile):
    if some_atts_have_dup_data:
        print('\n        clearing out duplicate filter data...'); logFile.write("\n        clearing out duplicate filter data...")

        # Merge to get which attributes have duplicate data
        _dfJ = pd.merge(melt_with_keys_df, attributes_df[['attributeCode', 'removeDuplicateFilterData']], on='attributeCode', how='left')

        # Iterate over each row to process the removeDuplicateFilterData
        for index, rowJ in _dfJ.iterrows():
            filters_to_noneify = rowJ['removeDuplicateFilterData']

            # Check if columns_to_remove is a list (i.e., valid and not NaN)
            if isinstance(filters_to_noneify, list):
                # Replace the specified columns with None
                for col in filters_to_noneify:
                    if col in _dfJ.columns:
                        _dfJ.at[index, col] = None
        
        # Drop unnecessary columns and remove duplicates
        _dfJ.drop(columns=['removeDuplicateFilterData'], inplace=True)
        _dfJ = _dfJ.drop_duplicates().fillna("")
        
        # Update the original DataFrame
        melt_with_keys_df = _dfJ
        
    else:
        print('\n        no atts with duplicate data defined...'); logFile.write("\n        no atts with duplicate data defined...")
    
    return melt_with_keys_df


# Group and Aggregate Function
def group_csv_df(melt_with_keys_df, group_csv, id_col, attributes_df, filters_own_col_lst, logFile):

    # Define index columns
    index_cols = [col for col in melt_with_keys_df.columns if col not in ['attributeCode','val','tdmCsvColumn']]


    # Check if there are any group attributes specified
    if group_csv:
        print('\n        grouping and aggregating...'); logFile.write("\n        grouping and aggregating...")

        # Cumulative dictionary to store all aggregation operations
        cumulative_agg_dict = {}

        # Get list of all csv columns for all attributes
        att_col_all_lst = []
        for _, row in attributes_df.iterrows():
            # Check if 'tdmCsvColumn' exists and is not null
            if 'tdmCsvColumn' in row and pd.notna(row['tdmCsvColumn']):
                att_col_all_lst.append(row['tdmCsvColumn'])
            else:
                # Check for 'wideFilterSettings' column existence and non-null values
                wide_filter_settings = row.get('wideFilterSettings')
                
                # Check if wide_filter_settings is not null and is a list
                if wide_filter_settings and isinstance(wide_filter_settings, list):
                    # Iterate through the list of settings
                    for setting in wide_filter_settings:
                        if 'tdmCsvColumn' in setting:
                            att_col_all_lst.append(setting['tdmCsvColumn'])

        att_col_non_agg_lst = att_col_all_lst

        # Loop through each group attribute specification
        for group_op in group_csv:
            agg_operation = group_op.get('aggOperation', 'sum')  # Default to 'sum' if not specified
            agg_atts = group_op.get('aggAtts', [])

            agg_fields = []

            for att in agg_atts:
                # Filter the DataFrame to get the specific attribute
                attribute = attributes_df[attributes_df['attributeCode'] == att]
                
                if not attribute.empty:
                    # Assuming each attributeCode is unique, we take the first row
                    attribute_row = attribute.iloc[0]
                          
                    if 'tdmCsvColumn' in attribute_row and pd.notna(attribute_row['tdmCsvColumn']):
                        agg_fields.append(attribute_row['tdmCsvColumn'])
                    else:
                        # Check for 'wideFilterSettings' column existence and non-null values
                        wide_filter_settings = attribute_row.get('wideFilterSettings')
                        
                        # Check if wide_filter_settings is not null and is a list
                        if wide_filter_settings and isinstance(wide_filter_settings, list):
                            # Iterate through the list of settings
                            for setting in wide_filter_settings:
                                if 'tdmCsvColumn' in setting:
                                    agg_fields.append(setting['tdmCsvColumn'])

            if not agg_fields:
                print(f'\n        No aggregation fields specified for operation {agg_operation}.'); logFile.write(f"\n        No aggregation fields specified for operation {agg_operation}.")
                continue  # Skip if no fields are specified for aggregation

            # Update the cumulative aggregation dictionary
            for field in agg_fields:
                if field in cumulative_agg_dict:
                    print(f'\n        Field {field} already has an aggregation operation. Skipping to prevent overwrite.')
                    logFile.write(f"\n        Field {field} already has an aggregation operation. Skipping to prevent overwrite.")
                    continue  # Skip fields that already have an aggregation operation
                cumulative_agg_dict[field] = (field, agg_operation)
                att_col_non_agg_lst.remove(field)

            print(f'\n        prepared to apply {agg_operation} to fields: {agg_fields}')
            logFile.write(f"\n        prepared to apply {agg_operation} to fields: {agg_fields}")

        # Create index that intcludes id plus any attributes that aren't being aggregated and any columns that have filters
        _index_cols = [id_col] + att_col_non_agg_lst + filters_own_col_lst

        # Group by all columns except those in 'aggFields', and apply all aggregations
        melt_with_keys_df = melt_with_keys_df.groupby(_index_cols, as_index=False).agg(**cumulative_agg_dict)

        print(f'\n        Applied cumulative aggregations')
        logFile.write(f"\n        Applied cumulative aggregations")

    else: 
        print('\n        nothing to group...'); logFile.write("\n        nothing to group...")

    return melt_with_keys_df




# Double Check Duplicates Function
def double_check_duplicates(melt_with_keys_df, index_cols, debug, logFile, ParentDir, ScenarioDir):
    # Check for duplicates before pivoting
    duplicates = melt_with_keys_df.duplicated(subset=index_cols + ['attributeCode'], keep=False)

    # Print error if duplicates found
    if duplicates.any():

        print("\n        duplicates found in the df based on the specified keys:"); logFile.write("\n        duplicates found in the df based on the specified keys:")
        print("\n           " + str(index_cols)); logFile.write("\n           " + str(index_cols))

        # print duplicates to a csv file
        if debug: 
            print("\n        debug file output to:v'debug_duplicates.csv'"); logFile.write("\n        debug file output to: 'debug_duplicates.csv'")

            melt_with_keys_df[duplicates].to_csv(os.path.join(ParentDir, ScenarioDir, '_Log/_debug/debug_duplicates.csv'), index=False)
        
        # Optional: Raise an error or handle as needed
        raise ValueError("Cannot pivot because of duplicate key combinations.")
    
    else:
        print("\n        no duplicates...")

    return melt_with_keys_df


# Pivot Function
def pivot_df(melt_with_keys_df, index_cols, logFile):
    print('\n        pivoting df...'); logFile.write("\n        pivoting df...")

    # If no duplicates, proceed with pivoting
    melt_with_keys_df_pivot_atts = melt_with_keys_df.pivot(index=index_cols, columns='attributeCode', values='val')
    
    melt_with_keys_df_pivot_atts.columns.name = None
    melt_with_keys_df_pivot_atts.reset_index(inplace=True)

    return melt_with_keys_df_pivot_atts


# Drop Columns Function
def drop_columns(melt_with_keys_df_pivot_atts, debug, logFile):
    # Check if the columns exist before dropping them
    columns_to_drop = ['roundingDecimals', 'displayName']
    existing_columns_to_drop = [col for col in columns_to_drop if col in melt_with_keys_df_pivot_atts.columns]

    # Drop unneeded columns
    if existing_columns_to_drop:
        print("\n        dropping columns..."); logFile.write("\n        dropping columns...")
        melt_with_keys_df_pivot_atts.drop(columns=existing_columns_to_drop, inplace=True)

        if debug:
                 #Export to csv for debugging
                melt_with_keys_df_pivot_atts.to_csv("debug.csv", index=False)
    else:
        print("\n        no columns to drop..."); logFile.write("\n        no columns to drop...")
    
    return melt_with_keys_df_pivot_atts



# ============================================================================================================
# Generate Json Functions
# ============================================================================================================
# Json Filter Function
def get_json_filters(df_data_with_keys, dfFilters, logFile):
    # add options to _dfFiltersWithOptions
    _dfFiltersWithOptions = dfFilters

    # For each filterCode, get the unique values from dfData, and join to dfFilters
    formatted_lists = []
    
    # Loop through each filterCode in the 'filterCode' column of dfFilters
    for filterCode in dfFilters['filterCode']:
        # Check if filterCode is a valid column in df_data_with_keys
        if filterCode in df_data_with_keys.columns:
            # Get unique values, excluding NaNs
            unique_values = [x for x in df_data_with_keys[filterCode].unique() if pd.notna(x)]
            formatted_lists.append(unique_values)
        else:
            print(f"\n        {filterCode} is not a valid column..."); logFile.write(f"\n        {filterCode} is not a valid column...")
    
    _dfFiltersWithOptions['fOptions'] = formatted_lists

    return _dfFiltersWithOptions


# List Combinations Function
def get_lst_combinations(df_data_with_keys, fCols, logFile):

    # Drop duplicates
    _dfFilters = df_data_with_keys[fCols].drop_duplicates()
    
    # Convert the values to binary form, so 1 where there is a value and 0 elsewhere
    binary_dfFilters = _dfFilters.applymap(lambda x: 0 if x=='' else 1)
    
    # Get unique rows of combinations
    unique_combinations = binary_dfFilters.drop_duplicates()
    
    # Convert the unique combinations to a list of tuples
    lstCombinations = list(unique_combinations.itertuples(index=False, name=None))

    return lstCombinations


# Filter Function
def get_filtered_df(combination, df_data_with_keys, fCols):
    # Initialize the condition as True for all rows
    condition = pd.Series([True] * len(df_data_with_keys), index=df_data_with_keys.index)

    # Apply the condition programmatically for each column in the list
    for col, comb_value in zip(fCols, combination):
        condition &= df_data_with_keys[col].apply(is_empty_or_not) == comb_value

    _filtered_df = df_data_with_keys[condition]

    # Remove columns where all values are NaN
    _filtered_df_noNA = _filtered_df.dropna(axis=1, how='all')

    return _filtered_df_noNA


# Acols Function
def get_a_cols(_filtered_df_noNA, _strFilterGroup, filter_a_codes_df):
    # Get list of columns that begin with "a", create a dataframe the filter group for all possible combinations
    aCols = [col for col in _filtered_df_noNA.columns if col.startswith('a')]
    new_data = pd.DataFrame([{"filterGroup": _strFilterGroup, 'attributeCode': aCols}])
    new_data = new_data.explode('attributeCode').reset_index(drop=True)
    filter_a_codes_df = pd.concat([filter_a_codes_df, new_data], ignore_index=True)

    return filter_a_codes_df


# Drop Empty Function
def drop_empty_f_cols(_filtered_df_noNA):
    _fColsToDrop = [col for col in _filtered_df_noNA.columns if col.startswith('f') and (_filtered_df_noNA[col] == '').all()]

    # Drop the identified columns - only have fCols with values
    _df2 = _filtered_df_noNA.drop(columns=_fColsToDrop)

    return _df2


# Drop Duplicate Function
def drop_duplicate_f_cols(_df2, _fColsRemain):
    if _fColsRemain:
        _dfFilterOptions = _df2[_fColsRemain].drop_duplicates()
    else:
        # add dummy row for no filter
        _dfFilterOptions = pd.DataFrame({'nofilter': ['']})
    
    return _dfFilterOptions


# Create Filter Condition Function
def create_filter_condition(row, _dfFilterOptions, _df2, _fColsRemain):
    final_condition = ""
    if _fColsRemain != []:
        # Dynamically construct the filter condition
        shared_columns = set(_dfFilterOptions.columns) & set(_df2.columns)
        conditions = (_df2[col].isin([row[col]]) for col in shared_columns)
        final_condition = next(conditions)
       
        for condition in conditions:
            final_condition &= condition
         
        filtered_df2 = _df2[final_condition].copy()
        filtered_df2.drop(columns=_fColsRemain, inplace=True)
    else: # no filter condition
        filtered_df2 =  _df2

    return filtered_df2


# Row Dict Function
def get_row_dict(row, _df2noI, round_decimals_lookup):
    # Initialize an empty dictionary for the row
    row_dict = {}

    # Loop through each column that starts with 'a'
    for col in _df2noI.columns[_df2noI.columns.str.startswith('a')]:
        value = row[col]

        # Skip if NaN
        if pd.isna(value):
            continue
        
        # Check if the value is numeric
        if isinstance(value, (int, float)):
            value = round(value, round_decimals_lookup[col])
            # only write out values that are non-zero
            if value != 0:
                # Check if the float value is equivalent to an integer
                if value.is_integer():
                    row_dict[col] = int(value)
                else:
                    row_dict[col] = value

        else:
            # If not numeric, add to row_dict without comparison
            row_dict[col] = value

    return row_dict


# Filter Option Function
def get_filter_option_json_data(row, id_col, row_dict, jsonDataForFilterOption):
    # If row_dict is not empty, add it to jsonDataCombined with id_col as the key
    if row_dict:
        if id_col == 'TAZID' or id_col == 'SUBAREAID' or id_col == 'DISTSML' or id_col == 'DISTSML2':
            jsonDataForFilterOption[int(row[id_col])] = row_dict
        elif id_col =='':
            jsonDataForFilterOption['_'] = row_dict
        else:
            jsonDataForFilterOption[row[id_col]] = row_dict

    return jsonDataForFilterOption