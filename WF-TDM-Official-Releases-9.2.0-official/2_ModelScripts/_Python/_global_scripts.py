
import pandas as pd
import numpy as np


# ============================================================================================================
# Time Functions
# ============================================================================================================
def calcHours(in_time):
    return int(in_time // 3600)

def calcMinutes(in_time):
    return int((in_time % 3600) // 60)

def calcSeconds(in_time):
    return round(in_time % 60, 1)

def ElapsedTime(in_time):
    _hours   = int(in_time // 3600)
    _minutes = int((in_time % 3600) // 60)
    _seconds = round(in_time % 60, 1)
    
    return "{}:{}:{}".format(
        str(_hours).zfill(2), 
        str(_minutes).zfill(2), 
        str(_seconds).zfill(4)
    )

def logElapsedTime(time_end, time_begin, logFile):
    time_elapsed = time_end - time_begin
    time_elapsed_txt = ElapsedTime(time_elapsed)
    logFile.write("\n    done -- elapsed time: "  +  time_elapsed_txt)

def printElapsedTime(time_end, time_begin):
    time_elapsed = time_end - time_begin
    time_elapsed_txt = ElapsedTime(time_elapsed)
    print("\n    done -- elapsed time: "  +  time_elapsed_txt)