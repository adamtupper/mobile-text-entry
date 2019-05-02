# Functions to parse the TEMA log files.
#
# Author: Adam Tupper
# Since: 02/05/19

library(tools)

TEMP = "TEMA-logs/pilot/0_0_Gesture1F_stats.tema"

parse_TEMA_stats_log = function(log_file_path) {
  # Read log file and remove timestamp lines
  lines = readLines(log_file_path)
  lines = lines[-1]
  lines = lines[-length(lines)]
  
  # Read remaining lines into a dataframe
  log_data = read.csv(textConnection(lines), sep='\t', comment.char='', stringsAsFactors=FALSE)
  names(log_data) = c("presented",
                  "transcribed",
                  "presented_characters",
                  "transcribed_characters",
                  "input_time",
                  "pause_time",
                  "total_time",
                  "wpm",
                  "msd",
                  "numBksp",
                  "numDelChars",
                  "total_error",
                  "cor_error",
                  "uncor_error")
  
  # Add participant, session and technique information from filename
  filename = file_path_sans_ext(basename(log_file_path))
  filename_components = strsplit(filename, '_')[[1]]
  log_data['participant_id'] = as.integer(filename_components[1])
  log_data['session_id'] = as.integer(filename_components[2])
  log_data['technique_code'] = as.factor(filename_components[3])
  
  log_data
}

log_data = parse_TEMA_stats_log(TEMP)
log_data
