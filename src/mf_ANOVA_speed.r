# Perform a multifactor ANOVA analysis for speed.
#
# User must provide the path to the TEMA log directory.
#
# Author: Adam Tupper
# Since: 03/05/19

#!/usr/bin/env Rscript

library(ezANOVA)
library(plyr)

source("src/TEMA_log_parsing.r")

# Check for log directory in command line arguments
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("The path to the TEMA log directory must be supplied.", call.=FALSE)
} else {
  log_dir = args[1]
}

# Parse and combine log files into a dataframe
log_data = combine_TEMA_stats_logs(log_dir)

# Remove trials 1-5 for each technique and participant
log_data = log_data[!(log_data$trial %in% c(1, 2, 3, 4, 5))]

