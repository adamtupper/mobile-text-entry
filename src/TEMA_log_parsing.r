# Functions to parse the TEMA log files.
#
# Author: Adam Tupper
# Since: 02/05/19

library(tools)
library(vwr)

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
                  "num_bksp",
                  "num_del_chars",
                  "total_error",
                  "cor_error",
                  "uncor_error")
  
  # Add participant, session and technique information from filename
  filename = file_path_sans_ext(basename(log_file_path))
  filename_components = strsplit(filename, '_')[[1]]
  log_data['participant_id'] = as.factor(filename_components[1])
  log_data['session_id'] = as.factor(filename_components[2])
  log_data['interface'] = as.factor(filename_components[3])
  log_data['posture'] = as.factor(filename_components[4])
  log_data['trial'] = as.factor(seq(1, nrow(log_data)))
  log_data['condition'] = as.factor(paste(filename_components[3], filename_components[4], sep=""))
  log_data['cer'] = levenshtein.distance(log_data$transcribed, log_data$presented) / nchar(log_data$presented)
  
  # Remove first 5 trials (familiarisation)
  log_data = log_data[!(log_data$trial %in% c(1, 2, 3, 4, 5)),]
  
  # Filter outliers (> 3 sd)
  sd_wpm = sd(log_data$wpm)
  sd_cer = sd(log_data$cer)
  log_data = log_data[!(log_data$wpm > log_data$wpm + 3*sd_wpm),]
  log_data = log_data[!(log_data$cer > log_data$cer + 3*sd_cer),]
  
  log_data
}


combine_TEMA_stats_logs = function(log_dir) {
  log_files = list.files(log_dir, pattern="*_stats.tema", full.names=TRUE, recursive=FALSE)
  
  log_data = lapply(log_files, parse_TEMA_stats_log)
  log_data = do.call(rbind, log_data)
  log_data
}

# Test
# LOG_DIR = "TEMA-logs/pilot"
# log_data = combine_TEMA_stats_logs(LOG_DIR)
# log_data
