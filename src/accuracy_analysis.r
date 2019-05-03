# Perform multifactor ANOVA  and pairwise t-test analyses for accuracy.
#
# User must provide the path to the TEMA log directory.
#
# Author: Adam Tupper
# Since: 03/05/19

#!/usr/bin/env Rscript

library(ez)
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

# Remove trials 1-5 for each technique and participant and calculate means
log_data = log_data[!(log_data$trial %in% c(1, 2, 3, 4, 5)),]
summarised_data = ddply(log_data, c("participant_id", "interface", "posture"), summarise, mean_uncor_error=mean(uncor_error))

# Multifactor ANOVA
ezANOVA(data=summarised_data, dv=mean_uncor_error, within=.(interface, posture), wid=participant_id)

# Pairwise t-tests
pairwise.t.test(summarised_data$mean_uncor_error, summarised_data$interface, p.adj="bonf", paired=T)
pairwise.t.test(summarised_data$mean_uncor_error, summarised_data$posture, p.adj="bonf", paired=T)
