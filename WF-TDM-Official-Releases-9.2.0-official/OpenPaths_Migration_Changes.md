# OpenPaths CUBE Migration — Change Documentation

**Model:** Wasatch Front TDM (WF-TDM) v9.2.0-official  
**Migration:** CUBE 6.5 → OpenPaths CUBE  
**Date:** 2025  
**Scope:** Four compatibility issues identified and resolved:  
1. CUBE Cluster syntax (deprecated in OpenPaths CUBE)  
2. ESRI Shapefile I/O (removed from OpenPaths CUBE Voyager)  
3. `Cluster.EXE` invocations in scenario control files (executable no longer exists)  
4. UTF-8 BOM encoding on Voyager script files (causes fatal PILOT parse error)

Reference documentation:  
- Cluster syntax: https://docs.bentley.com/LiveContent/web/OpenPaths-v2025.1/Help/en/topics/2867622/GUID-F670065E-ACE6-477D-985A-7B3DAC77BA3B.html  
- ESRI format handling: https://docs.bentley.com/LiveContent/web/OpenPaths-v2025.1/Help/en/topics/2867622/handling_esri_formats.html

---

## TOPIC 1 — CUBE Cluster Syntax

### Background

CUBE 6.5 used a three-part pattern to distribute script work across CPU cores using Cluster:

```
; Header process (PROCESSID=ClusterNodeID, PROCESSNUM=1 implied)
DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@

; Worker processes
DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2

; Synchronization barrier
WAIT4FILES FILES="ClusterNodeID2.Script.End", ..."ClusterNodeIDN.Script.End"
```

OpenPaths CUBE replaces this with:
- `DistributeIntrastep MaxProcesses=@CoresAvailable@` — replaces `DistributeINTRASTEP PROCESSID=...`
- `DistributeMULTISTEP Alias='<name>'` — replaces `DistributeMULTISTEP PROCESSID=... PROCESSNUM=...`
- `BARRIER IDLIST='<name1>','<name2>',...` — replaces `WAIT4FILES FILES="..."`

---

### 1a. DistributeINTRASTEP — Global Replace (All .s and .block files)

**Old pattern:**
```
DistributeINTRASTEP PROCESSID=ClusterNodeID, PROCESSLIST=2-@CoresAvailable@
```
**New pattern:**
```
DistributeIntrastep MaxProcesses=@CoresAvailable@
```

**Files affected (44 total occurrences replaced):**

| File | Path |
|------|------|
| `1_Distribution.s` | `2_ModelScripts/3_Distribute/` |
| `4_TLF_Distrib_PA.s` | `2_ModelScripts/3_Distribute/` |
| `2_FFSkim.s` | `2_ModelScripts/0_InputProcessing/c_NetworkProcessing/` |
| `05_Skim_Tran.s` | `2_ModelScripts/4_ModeChoice/` |
| `07_HBW_dest_choice.s` | `2_ModelScripts/4_ModeChoice/` |
| `11_MC_HBW_HBO_NHB_HBC.s` | `2_ModelScripts/4_ModeChoice/` |
| `12_EstimateHBSchModeShare.s` | `2_ModelScripts/4_ModeChoice/` |
| `14_AsnTran.s` | `2_ModelScripts/4_ModeChoice/` |
| `16_SharesReport.s` | `2_ModelScripts/4_ModeChoice/` |
| `18_SumToDistricts_FinalTripTables.s` | `2_ModelScripts/4_ModeChoice/` |
| `01_Convert_PA_to_OD.s` | `2_ModelScripts/5_AssignHwy/` |
| `02_Assign_AM_MD_PM_EV.s` | `2_ModelScripts/5_AssignHwy/` |
| `07_PerformFinalNetSkim.s` | `2_ModelScripts/5_AssignHwy/` |
| `09_TAZ_Based_Metrics.s` | `2_ModelScripts/5_AssignHwy/` |
| `TAZ_Based_Metrics - create temp matrices.block` | `2_ModelScripts/5_AssignHwy/block/` |

---

### 1b. DistributeMULTISTEP + WAIT4FILES → BARRIER (Script-by-Script)

Each script's worker processes were assigned unique `Alias=` names and `WAIT4FILES` was replaced with `BARRIER IDLIST=` listing those aliases. Details per script:

#### `3_Distribute/1_Distribution.s`

Two separate parallel groups in this script:

**Group 1 — Distribution loop:**
- Old: `DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2`, `...PROCESSNUM=3`, `...PROCESSNUM=4`
- New: `DistributeMULTISTEP Alias='Distrib_Proc2'`, `Alias='Distrib_Proc3'`, `Alias='Distrib_Proc4'`
- Old: `WAIT4FILES FILES="ClusterNodeID2.Script.End","ClusterNodeID3.Script.End","ClusterNodeID4.Script.End"`
- New: `BARRIER IDLIST='Distrib_Proc2','Distrib_Proc3','Distrib_Proc4'`

**Group 2 — Final network:**
- Old: `DistributeMULTISTEP PROCESSID=ClusterNodeID PROCESSNUM=2`
- New: `DistributeMULTISTEP Alias='FinNet_Proc2'`
- Old: `WAIT4FILES FILES="ClusterNodeID2.Script.End"`
- New: `BARRIER IDLIST='FinNet_Proc2'`

#### `3_Distribute/4_TLF_Distrib_PA.s`
- PROCESSNUM=2,3 → Aliases `TLF_Proc2`, `TLF_Proc3`
- `WAIT4FILES` → `BARRIER IDLIST='TLF_Proc2','TLF_Proc3'`

#### `4_ModeChoice/05_Skim_Tran.s`
- PROCESSNUM=2,3,4 → Aliases `SkimTran_Proc2`, `SkimTran_Proc3`, `SkimTran_Proc4`
- `WAIT4FILES` → `BARRIER IDLIST='SkimTran_Proc2','SkimTran_Proc3','SkimTran_Proc4'`

#### `4_ModeChoice/11_MC_HBW_HBO_NHB_HBC.s`
- PROCESSNUM=2–8 → Aliases `MC11_Proc2` through `MC11_Proc8`
- `WAIT4FILES` (7 files) → `BARRIER IDLIST='MC11_Proc2','MC11_Proc3','MC11_Proc4','MC11_Proc5','MC11_Proc6','MC11_Proc7','MC11_Proc8'`

#### `4_ModeChoice/14_AsnTran.s`
- PROCESSNUM=2,3,4 → Aliases `AsnTran_Proc2`, `AsnTran_Proc3`, `AsnTran_Proc4`
- `WAIT4FILES` → `BARRIER IDLIST='AsnTran_Proc2','AsnTran_Proc3','AsnTran_Proc4'`

#### `4_ModeChoice/16_SharesReport.s`
- PROCESSNUM=2,3,4,5 → Aliases `Shares_Proc2`, `Shares_Proc3`, `Shares_Proc4`, `Shares_Proc5`
- `WAIT4FILES` → `BARRIER IDLIST='Shares_Proc2','Shares_Proc3','Shares_Proc4','Shares_Proc5'`

#### `4_ModeChoice/18_SumToDistricts_FinalTripTables.s`
- PROCESSNUM=2,3,4,5 → Aliases `SumDistr_Proc2`, `SumDistr_Proc3`, `SumDistr_Proc4`, `SumDistr_Proc5`
- `WAIT4FILES` → `BARRIER IDLIST='SumDistr_Proc2','SumDistr_Proc3','SumDistr_Proc4','SumDistr_Proc5'`

#### `5_AssignHwy/09_TAZ_Based_Metrics.s`
- PROCESSNUM=2–12 → Descriptive aliases by metric type and time period:
  - `TAZMet_PMT_AM`, `TAZMet_PMT_MD`, `TAZMet_PMT_PM`, `TAZMet_PMT_EV`
  - `TAZMet_PHT_AM`, `TAZMet_PHT_MD`, `TAZMet_PHT_PM`, `TAZMet_PHT_EV`
  - `TAZMet_PHTFF_AM`, `TAZMet_PHTFF_MD`, `TAZMet_PHTFF_PM`
- `WAIT4FILES` (11 files) → `BARRIER IDLIST=` with all 11 aliases

---

## TOPIC 2 — ESRI Shapefile I/O

### Background

OpenPaths CUBE's Voyager engine no longer supports reading or writing ESRI shapefiles directly. The affected keywords are:
- `FILEI GEOMI[n] = '*.shp'` — reading shapefile geometry into a network run (removed entirely; geometry must now be embedded in the `.net` file)
- `FILEO NODEO/LINKO = '*.shp', FORMAT=SHP` — writing output as a shapefile (changed to DBF format)

Python scripts that read Voyager-exported shapefiles via `geopandas.read_file()` must also be updated.

---

### 2a. `0_InputProcessing/c_NetworkProcessing/1_NetProcessor.s`

This script processes the master network and creates GIS output files. All shapefile references were updated.

#### FILEI GEOMI removals

**Run 1 (initial master net export):**  
Removed:
```
FILEI GEOMI[1] = '@ParentDir@1_Inputs\3_Highway\@MasterLinkShp@'
```
*Reason: `@MasterLinkShp@` pointed to a static `.shp` file for link geometry. OpenPaths CUBE cannot read shapefiles. Geometry must now be embedded in the `.net` file — see Data Migration Note below.*

**Run 2 (scenario network creation):**  
Removed:
```
FILEI GEOMI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Link.shp'
```
*Same reason as above.*

#### FILEO FORMAT=SHP → DBF changes

**Temp export (for Python processing):**
- `FILEO NODEO = '...Master_Node_tmp0.shp', FORMAT=SHP,` → `FILEO NODEO = '...Master_Node_tmp0.dbf',`
- `FILEO LINKO = '...Master_Link_tmp0.shp', FORMAT=SHP,` → `FILEO LINKO = '...Master_Link_tmp0.dbf',`

**Inline Python PRINT block (variable definitions passed to Python):**
- `Master_Link_shp = r"Master_Link_tmp0.shp"` → `Master_Link_dbf = r"Master_Link_tmp0.dbf"`
- `Master_Node_shp = r"Master_Node_tmp0.shp"` → `Master_Node_dbf = r"Master_Node_tmp0.dbf"`

**Updated master network GIS output:**
- `FILEO NODEO = '...UpdatedMasterNet\GIS\@MasterPrefix@ - Node.shp', FORMAT=SHP` → `FILEO NODEO = '...Node.dbf'`
- `FILEO LINKO = '...UpdatedMasterNet\GIS\@MasterPrefix@ - Link.shp', FORMAT=SHP` → `FILEO LINKO = '...Link.dbf'`

**Scenario network GIS output:**
- `FILEO LINKO = '...ScenarioNet\@RID@ - Link.shp', FORMAT=SHP` → `FILEO LINKO = '...@RID@ - Link.dbf'`
- `FILEO NODEO = '...ScenarioNet\@RID@ - Node.shp', FORMAT=SHP` → `FILEO NODEO = '...@RID@ - Node.dbf'`

---

### 2b. `5_AssignHwy/04_SummarizeLoadedNetworks.s`

This script summarizes loaded assignment networks and writes GIS output.

#### FILEI GEOMI removals (2 occurrences)

Both NETWORK runs in this script had:
```
FILEI GEOMI[1] = '@ParentDir@@ScenarioDir@0_InputProcessing\UpdatedMasterNet\GIS\@MasterPrefix@ - Link.shp'
```
Both were removed.

#### FILEO FORMAT=SHP → DBF changes

- `FILEO LINKO = '...Scenarios\@RID@\2b_Shapefiles\@RID@_Assigned.shp', FORMAT=SHP,` →  
  `FILEO LINKO = '...@RID@_Assigned.dbf',`
- `FILEO LINKO = '...5_AssignHwy\2b_Shapefiles\@RID@_Summary.shp', FORMAT=SHP,` →  
  `FILEO LINKO = '...@RID@_Summary.dbf',`  
  *(This reference was missed in the initial migration pass and was identified by a `F(718): GDB Network function unavailable` fatal error during the first full model run.)*

---

### 2c. `6_REMM/3_output_LinkVolumeTAZlevel.s`

This script writes REMM output network files. Both NETWORK runs had `FILEI GEOMI` and `FILEO FORMAT=SHP` references that were missed in the initial migration pass. Identified via `F(718)` error during the first full model run.

#### FILEI GEOMI removals (2 occurrences)

Both NETWORK runs had:
```
FILEI GEOMI[1] = '@ParentDir@1_Inputs\3_Highway\@MasterLinkShp@'
```
Both were removed.

#### FILEO FORMAT=SHP → DBF changes

- `FILEO LINKO = '...6_REMM\FreewayExits.shp', FORMAT=SHP,` → `FILEO LINKO = '...FreewayExits.dbf',`
- `FILEO LINKO = '...6_REMM\volumeshapefile.shp', FORMAT=SHP,` → `FILEO LINKO = '...volumeshapefile.dbf',`

---

### 2d. `_Python/ip_UpdateNetwork_WalkBuffers.py`

This Python script reads the temp master node/link files exported by Voyager (from `1_NetProcessor.s`) to compute DISTANCE, TAZID, and HOT_ZONEID fields and to generate the walk buffer file.

#### Variable name changes

| Old | New |
|-----|-----|
| `in_Link_shp = GlobalVars.Master_Link_shp` | `in_Link_dbf = GlobalVars.Master_Link_dbf` |
| `in_Node_shp = GlobalVars.Master_Node_shp` | `in_Node_dbf = GlobalVars.Master_Node_dbf` |
| `path_in_Link_shp = os.path.join(...)` | `path_in_Link_dbf = os.path.join(...)` |
| `path_in_Node_shp = os.path.join(...)` | `path_in_Node_dbf = os.path.join(...)` |

All `print()` and `logFile.write()` messages referencing these variables were updated accordingly.

#### File reading — replaced `geopandas.read_file()` with DBF read + GeoDataFrame reconstruction

**Old code:**
```python
gdf_Master_link = gpd.read_file(path_in_Link_shp)
gdf_Master_node = gpd.read_file(path_in_Node_shp)
```

**New code (node read first, then link — node X,Y are required to reconstruct link geometry):**
```python
# Read node DBF and reconstruct GeoDataFrame from X,Y columns
InputDBF_MasterNode = DBF(path_in_Node_dbf)
df_Master_node = pd.DataFrame(iter(InputDBF_MasterNode))
gdf_Master_node = gpd.GeoDataFrame(
    df_Master_node,
    geometry=gpd.points_from_xy(df_Master_node['X'], df_Master_node['Y']),
    crs=gdf_TAZ.crs
)

# Read link DBF and reconstruct GeoDataFrame using straight-line A/B node geometry
InputDBF_MasterLink = DBF(path_in_Link_dbf)
df_Master_link = pd.DataFrame(iter(InputDBF_MasterLink))
df_A = df_Master_node[['N', 'X', 'Y']].rename(columns={'N': 'A', 'X': 'AX', 'Y': 'AY'})
df_B = df_Master_node[['N', 'X', 'Y']].rename(columns={'N': 'B', 'X': 'BX', 'Y': 'BY'})
df_Master_link = df_Master_link.merge(df_A, on='A', how='left')
df_Master_link = df_Master_link.merge(df_B, on='B', how='left')
from shapely.geometry import LineString
geoms = [LineString([(row.AX, row.AY), (row.BX, row.BY)]) for _, row in df_Master_link.iterrows()]
gdf_Master_link = gpd.GeoDataFrame(df_Master_link, geometry=geoms, crs=gdf_TAZ.crs)
```

**Important design note — geometry accuracy:**  
The original code read shapefile geometry that included shape points (intermediate vertices along curved road alignments). Since `FILEI GEOMI` has been removed from Voyager, the DBF output no longer contains shape-point geometry. The reconstructed link `LineString` connects only the A-node and B-node endpoints, resulting in a straight-line approximation.

Downstream impacts:
- **`DISTANCE` field** (`gdf_Master_link.geometry.length / 1609.34`): Will use straight-line distance, which is slightly shorter than the true road distance. Error is typically 1–5% depending on road curvature. Links are short enough that this is an acceptable approximation for TAZ spatial assignment purposes. Skim-based distances are unaffected (those come from the assignment network, not this field).
- **Link midpoint calculation** (`gdf_Master_link.geometry.centroid`): Centroid of a straight-line segment is the midpoint between A and B nodes. This is used for TAZID spatial join and is functionally equivalent to the shape-point centroid for most links.

---

## TOPIC 3 — Cluster.EXE Invocations in Scenario Control Files

### Background

CUBE 6.5 required launching a separate `Cluster.EXE` process to manage distributed worker nodes. OpenPaths CUBE handles parallelism natively and `Cluster.EXE` no longer exists. Calling it causes an immediate fatal crash before `ONRUNERRORGOTO` is set, so no error handler can catch it.

### Files Modified

#### `Scenarios\by_test\1ControlCenter - BY_2019.block`

The `START` call (line ~173) fires during the PILOT pre-processing phase, before any error handler is active:

**Old:**
```
*(Cluster.EXE  ClusterNodeID 2-16 START EXIT)
```
**New:** Commented out:
```
;*(Cluster.EXE  ClusterNodeID 2-16 START EXIT)   ;NOT USED in OpenPaths CUBE
```

The `DISTRIBUTE MULTISTEP=T INTRASTEP=T` line directly above it is preserved — OpenPaths CUBE still uses this global flag to enable distributed processing.

> **Note:** All other scenario block files (`1ControlCenter - *.block`) contain the same `Cluster.EXE START` line and must be updated before those scenarios are run.

#### `Scenarios\by_test\_HailMary.s`

Two `CLOSE EXIT` calls at `:ENDMODEL` and `:ONERROR` were commented out:

**Old:**
```
if (UseCubeCluster=1)
    *(Cluster.EXE  ClusterNodeID 2-100 CLOSE EXIT)
endif
```
**New:** Entire block commented out at both locations.

---

## TOPIC 4 — UTF-8 BOM Encoding on Voyager Script Files

### Background

PowerShell 5.1 writes files as UTF-8 **with BOM** (byte order mark: `0xEF 0xBB 0xBF`) by default when using `Set-Content` or `-replace` pipeline operations. Voyager's PILOT preprocessor does not recognize the BOM and raises a fatal `F(017): is invalid control type` error, preventing the model from running entirely.

This was introduced during the global `DistributeINTRASTEP` find-and-replace step of the migration (Topic 1), which used PowerShell to rewrite the affected files.

### Fix

The BOM (first 3 bytes) was stripped from all affected files using PowerShell's `[System.IO.File]::ReadAllBytes` / `WriteAllBytes` to perform a byte-level rewrite without re-encoding.

### Files Fixed (19 total)

| File | Path |
|------|------|
| `2_FFSkim.s` | `0_InputProcessing/c_NetworkProcessing/` |
| `1_Distribution.s` | `3_Distribute/` |
| `4_TLF_Distrib_PA.s` | `3_Distribute/` |
| `02_Segmnt_TransitAccessMarkets.s` | `4_ModeChoice/` |
| `03_Skim_auto.s` | `4_ModeChoice/` |
| `05_Skim_Tran.s` | `4_ModeChoice/` |
| `06_HBW_logsums.s` | `4_ModeChoice/` |
| `07_HBW_dest_choice.s` | `4_ModeChoice/` |
| `08_TripTablesByPeriod.s` | `4_ModeChoice/` |
| `09_Segmnt_PA_HBbyMC.s` | `4_ModeChoice/` |
| `10_ConvertSomeXI2HBW.s` | `4_ModeChoice/` |
| `11_MC_HBW_HBO_NHB_HBC.s` | `4_ModeChoice/` |
| `12_EstimateHBSchModeShare.s` | `4_ModeChoice/` |
| `16_SharesReport.s` | `4_ModeChoice/` |
| `TAZ_Based_Metrics - create temp matrices.block` | `5_AssignHwy/block/` |
| `01_Convert_PA_to_OD.s` | `5_AssignHwy/` |
| `02_Assign_AM_MD_PM_EV.s` | `5_AssignHwy/` |
| `07_PerformFinalNetSkim.s` | `5_AssignHwy/` |
| `1_VMTproducedByTAZ.s` | `7_PostProcessing/` |

### Prevention

When making future edits to Voyager `.s` or `.block` files via PowerShell, use UTF-8 **without BOM**:
```powershell
# Safe: byte-level replacement (no re-encoding)
[System.IO.File]::WriteAllBytes($path, $newBytes)

# Safe: explicit UTF-8 no-BOM encoding
$content | Set-Content $path -Encoding UTF8  # PowerShell 7+
[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
```

---

## DATA MIGRATION NOTE (Action Required Before Running Model)

**This is a one-time data preparation step required before the updated model can run correctly.**

### Issue

The `FILEI GEOMI` statements that were removed from `1_NetProcessor.s` and `04_SummarizeLoadedNetworks.s` previously loaded link shape-point geometry from a static ESRI shapefile (`@MasterLinkShp@`) into the Voyager network runs. This geometry was used to:
1. Display links with accurate road geometry in the Cube network viewer
2. Export shapefiles with shape-point geometry for downstream GIS use

In OpenPaths CUBE, geometry must be embedded directly in the `.net` file rather than loaded from a separate shapefile.

### Required Action

Use the **OpenPaths CUBE Convert utility** to embed the geometry from the existing master shapefile into the master network `.net` file:

1. Open **OpenPaths CUBE** → **Cube Convert**
2. Select the current master network file:  
   `1_Inputs\3_Highway\WFv920_MasterNet.net`  
   (or the equivalent `.net` file referenced by `@MasterNetFile@`)
3. Import geometry from the existing shapefile:  
   `1_Inputs\3_Highway\<MasterLinkShp>.shp`  
   (the file previously referenced by `@MasterLinkShp@` in the scenario variables)
4. Save the updated `.net` file (with embedded geometry)

After this step, Voyager network runs will use geometry embedded in the `.net` file, and the `FILEI GEOMI` references are no longer needed.

> **Note:** The static input shapefiles in `1_Inputs\3_Highway\` and `1_Inputs\1_TAZ\` that are read directly by Python scripts via `geopandas.read_file()` (e.g., `WFv910_TAZ.shp`, toll zone shapefile) are **not affected** by this migration — Python's geopandas can still read ESRI shapefiles directly. Only Voyager-side `FILEI GEOMI` was removed.

---

## Summary of All Modified Files

| File | Change Type | Location |
|------|------------|----------|
| `0_InputProcessing/c_NetworkProcessing/2_FFSkim.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `0_InputProcessing/c_NetworkProcessing/1_NetProcessor.s` | DistributeINTRASTEP + GEOMI + FORMAT=SHP | `2_ModelScripts/` |
| `3_Distribute/1_Distribution.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `3_Distribute/4_TLF_Distrib_PA.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `4_ModeChoice/05_Skim_Tran.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `4_ModeChoice/07_HBW_dest_choice.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `4_ModeChoice/11_MC_HBW_HBO_NHB_HBC.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `4_ModeChoice/12_EstimateHBSchModeShare.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `4_ModeChoice/14_AsnTran.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `4_ModeChoice/16_SharesReport.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `4_ModeChoice/18_SumToDistricts_FinalTripTables.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `5_AssignHwy/01_Convert_PA_to_OD.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `5_AssignHwy/02_Assign_AM_MD_PM_EV.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `5_AssignHwy/04_SummarizeLoadedNetworks.s` | GEOMI + FORMAT=SHP (2 passes) | `2_ModelScripts/` |
| `6_REMM/3_output_LinkVolumeTAZlevel.s` | GEOMI + FORMAT=SHP | `2_ModelScripts/` |
| `5_AssignHwy/07_PerformFinalNetSkim.s` | DistributeINTRASTEP | `2_ModelScripts/` |
| `5_AssignHwy/09_TAZ_Based_Metrics.s` | DistributeINTRASTEP + DistributeMULTISTEP + WAIT4FILES | `2_ModelScripts/` |
| `5_AssignHwy/block/TAZ_Based_Metrics - create temp matrices.block` | DistributeINTRASTEP | `2_ModelScripts/` |
| `_Python/ip_UpdateNetwork_WalkBuffers.py` | Shapefile read → DBF read + GeoDataFrame reconstruction | `2_ModelScripts/` |
