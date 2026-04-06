import pandas as pd
import numpy as np
import geopandas as gpd
from shapely.geometry import LineString, MultiLineString
import math


# ============================================================================================================
# TAZID Functions
# ============================================================================================================
def calcTAZID_Link(TAZID, A, B, UsedZones):
    if A <= UsedZones:
        return A
    elif B <= UsedZones:
        return B
    else:
        return TAZID


def calcTAZID_Node(TAZID, N, UsedZones):
    if N <= UsedZones:
        return N
    else:
        return TAZID


# ============================================================================================================
# Scenario Network Functions
# ============================================================================================================
# Function to determine exact cardinal direction based on the geometry of the line
def determine_link_direction(geometry):
    # LineString
    if isinstance(geometry, LineString):
        start_point = geometry.coords[0]
        end_point = geometry.coords[-1]
    # MultiLineString
    elif isinstance(geometry, MultiLineString):
        first_line = geometry.geoms[0]
        start_point = first_line.coords[0]
        last_line = geometry.geoms[-1]
        end_point = last_line.coords[-1]
    else:
        return None

    # Calculate the angle (in degrees) between the start and end points
    dx = end_point[0] - start_point[0]  # Longitude difference
    dy = end_point[1] - start_point[1]  # Latitude difference
    angle = math.degrees(math.atan2(dy, dx))

    # Normalize angle to a range of [0, 360] degrees
    if angle < 0:
        angle += 360

    # Determine the direction based on the angle (0 degrees along x axis as horizontal line to the right)
    if 0 <= angle < 45 or 315 <= angle < 360: 
        return 'EB'  # Eastbound
    elif 45 <= angle < 135:
        return 'NB'  # Northbound
    elif 135 <= angle < 225:
        return 'WB'  # Westbound
    elif 225 <= angle < 315:
        return 'SB'  # Southbound


# Function to calculate distance from centroid of link to nearest segment
def calculate_distance_to_segment(centroid, seg_seg_id, gdf_segments):
    # Get the line segment that matches the SEG_SEGID from the joined dataset
    if pd.isna(seg_seg_id):
        return float('nan')
    
    matching_segments = gdf_segments[gdf_segments['SEG_SEGID'] == seg_seg_id]

    # Find the matching segment by SEG_SEGID
    if matching_segments.empty:
        return float('nan')
    else:
        # Return the distance to the first matching segment
        return centroid.distance(matching_segments.iloc[0]['geometry'])


# Function to sort segids for freeways
def freeway_sorting_key(seg_seg_id):
    if pd.isna(seg_seg_id):
        return 1 
    if seg_seg_id.startswith(('MAG', 'UTA', 'WFRC')):
        return 2 
    return 0 


# Function to sort segids for arterials
def nonfreeway_sorting_key(seg_seg_id):
    if pd.isna(seg_seg_id):
        return 1 
    if seg_seg_id.startswith(('UTA')):
        return 2 
    return 0 


def make_duplicates_report(gdf_dir_centroids_sorted, path_report, create_new_report):
    # Mark which one will be selected for the report
    gdf_dir_centroids_sorted['selected'] = 'False'
    gdf_dir_centroids_sorted.loc[~gdf_dir_centroids_sorted.duplicated(subset=['LINKID']), 'selected'] = 'True'
    
    # Filter duplicates where 'NET_SEGID' is NaN
    duplicates = gdf_dir_centroids_sorted[
        gdf_dir_centroids_sorted['NET_SEGID'].isna() & gdf_dir_centroids_sorted.duplicated(subset=['LINKID'], keep=False)
    ]
    
    # Select relevant columns for the report
    duplicates = duplicates[['PLANAREA','LINKID', 'FTTYPE', 'FT', 'NET_SEGID', 'SEG_SEGID', 'dist', 'sort_key', 'selected']]
    
    # Determine the mode for writing to the CSV file
    mode = 'w' if create_new_report else 'a'
    
    # Write the duplicates to the CSV file
    duplicates.to_csv(path_report, mode=mode, header=create_new_report, index=False)


# function that grabs the segid from the buffer and merges it to centroid of link
def get_segid_from_buffer(gdf_dir_links, gdf_dir_segs, gdf_Segments, ft_type, create_new_report, path_report):
    # calculate links centroids for directional links
    gdf_dir_links['centroid'] = gdf_dir_links.geometry.centroid
    gdf_dir_links_centroids = gdf_dir_links.set_geometry('centroid')
    
    # merge with segment buffer
    gdf_dir_centroids_joined = gpd.sjoin(gdf_dir_links_centroids, gdf_dir_segs, how='left', op='within')
    
    # Note: Many links fall within multiple segment buffers. To decide which to keep, calculate distance to possible segments, and choose closest value.
    # Apply the distance calculation
    gdf_dir_centroids_joined['dist'] = gdf_dir_centroids_joined.apply(
        lambda row: calculate_distance_to_segment(
            row.centroid,            # Centroid geometry
            row['SEG_SEGID'],        # SEG_SEGID from the joined dataset
            gdf_Segments             # GeoDataFrame of original segments
        ), axis=1
    )
    
    # sort duplicates to put ones to keep at top before duplicated
    if (ft_type=='Freeway'):
        # sort by sorting key in order to put 'UTA', 'WFRC', and 'MAG' based segments at the bottom of the order, since most freeways don't include these types of segments
        gdf_dir_centroids_joined['FTTYPE'] = 'Freeway'
        gdf_dir_centroids_joined['sort_key'] = gdf_dir_centroids_joined['SEG_SEGID'].apply(freeway_sorting_key)
        gdf_dir_centroids_sorted = gdf_dir_centroids_joined.sort_values(by=['LINKID', 'sort_key','dist'])
    else:
        gdf_dir_centroids_joined['FTTYPE'] = 'Non-Freeway'
        gdf_dir_centroids_joined['sort_key'] = gdf_dir_centroids_joined['SEG_SEGID'].apply(nonfreeway_sorting_key)
        gdf_dir_centroids_sorted= gdf_dir_centroids_joined.sort_values(by=['LINKID', 'sort_key','dist'])
    
    # make report for links that fall within more than one buffer
    make_duplicates_report(gdf_dir_centroids_sorted, path_report, create_new_report)
    
    # drop duplicates based on 'linkid', keeping the first (which has the shortest distance)
    gdf_dir_centroids_final = gdf_dir_centroids_sorted.drop_duplicates(subset=['LINKID'], keep='first')
    
    # merge joined attributes back onto links
    gdf_dir_links_joined = gdf_dir_links.merge(
        gdf_dir_centroids_final[['SEG_SEGID', 'SEG_DIR', 'FTTYPE']], 
        left_index=True, right_index=True, 
        how='left'
    )
    
    # fill in network 'SEGID' gaps with buffered segment 'SEGID's
    gdf_dir_links_joined['SEGID'] = gdf_dir_links_joined.apply(
        lambda row: row['NET_SEGID'] if pd.notna(row['NET_SEGID']) else row['SEG_SEGID'], 
        axis=1
    )
    
    # drop unneeded columns
    gdf_dir_links_final = gdf_dir_links_joined.drop(columns={'SEG_SEGID', 'SEG_DIR'})
    
    return gdf_dir_links_final


# Function to generate report for mismatched segments
def make_mismatch_report(df, output_file):
    # add notes based on certain conditions
    def find_mismatches(row):
        if pd.isnull(row['NET_SEGID']) and not pd.isnull(row['SEG_SEGID']):
            return "No network segid found where Segment segid exists"
        elif not pd.isnull(row['NET_SEGID']) and pd.isnull(row['SEG_SEGID']):
            return "Network segid found where no Segment segid exists"
        elif pd.isnull(row['NET_SEGID']) and pd.isnull(row['SEG_SEGID']):
            return "Neither Network segid or Segment segid exists"
        elif row['NET_SEGID'] != row['SEG_SEGID']:
            return "MisMatch between network segid and Segment segid"
        return None

    # Apply the function to the dataframe
    df['NOTES'] = df.apply(find_mismatches, axis=1)
    mismatch_df = df[df['NOTES'].notnull()]
    mismatch_report = mismatch_df[['PLANAREA','LINKID', 'FTTYPE', 'FT', 'NET_SEGID', 'SEG_SEGID', 'NOTES']]

    # Write the mismatch report to a CSV file
    mismatch_report.to_csv(output_file, index=False)


# Function to update direction to link direction if the link direction matches the segment direction
def update_direction(row):
    if row['DIRECTION'] == 'NB/SB':
        if row['NET_DIR'] in ['NB', 'SB']:
            return row['NET_DIR']
        elif row['NET_DIR'] in ['EB', 'WB']:
            return np.nan
    
    elif row['DIRECTION'] == 'EB/WB':
        if row['NET_DIR'] in ['EB', 'WB']:
            return row['NET_DIR']
        elif row['NET_DIR'] in ['NB', 'SB']:
            return np.nan 
    
    # Return the original direction if no conditions match
    return row['DIRECTION']



# Function that calculates segment direction by using neighboring link when current link direction doesn't match segment direction
def fill_directions(group, direction_col, net_dir_col):
    # Ensure the direction column exists in the DataFrame
    if direction_col not in group.columns:
        raise ValueError(f"Column '{direction_col}' does not exist in the DataFrame.")
    
    for i, row in group.iterrows():
        if pd.isna(row[direction_col]):
            # Get the SEG_DIR value for the current link
            seg_dir = row['SEG_DIR']
            
            # Determine valid NET_DIR values based on SEG_DIR
            if seg_dir in ['NB/SB', 'EB/WB']:
                valid_net_dirs = {
                    'NB/SB': ['NB', 'SB'],
                    'EB/WB': ['EB', 'WB']
                }[seg_dir]
                
                # Look for a neighbor link where A of one matches B of the other or vice versa
                match_row = group[
                    ((group['A'] == row['B']) | (group['B'] == row['A'])) & 
                    (group[net_dir_col].notna()) & 
                    (group[net_dir_col].isin(valid_net_dirs)) &  # Ensure the NET_DIR is valid for SEG_DIR
                    ((group['A'] != row['B']) | (group['B'] != row['A']))  # Exclude reverse links
                ]
                
                # If a match is found, update the specified direction column with the match's NET_DIR
                if not match_row.empty:
                    group.at[i, direction_col] = match_row[net_dir_col].values[0]
                else:
                    group.at[i, direction_col] = np.nan
            else:
                group.at[i, direction_col] = np.nan
    
    return group
