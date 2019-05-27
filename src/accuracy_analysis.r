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
summarised_data = ddply(log_data, c("participant_id", "interface", "posture"), summarise, mean_cer=mean(cer))

# Multifactor ANOVA
ezANOVA(data=summarised_data, dv=mean_cer, within=.(interface, posture), wid=participant_id)

# Pairwise t-tests
pairwise.t.test(summarised_data$mean_cer, summarised_data$interface, p.adj="bonf", paired=T)
pairwise.t.test(summarised_data$mean_cer, summarised_data$posture, p.adj="bonf", paired=T)

# Print summary statistics
interface_posture_means = ddply(log_data, c("interface", "posture"), summarise, mean_cer=mean(cer), sd_cer=sd(cer))
interface_means = ddply(log_data, c("interface"), summarise, mean_cer=mean(cer), sd_cer=sd(cer))
posture_means = ddply(log_data, c("posture"), summarise, mean_cer=mean(cer), sd_cer=sd(cer))

cat("\n")
print(interface_posture_means)
cat("\n")
print(interface_means)
cat("\n")
print(posture_means)
