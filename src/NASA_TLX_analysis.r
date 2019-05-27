# Perform Friedman test analyses for NASA-TLX responses.
#
# User must provide the path to the CSV file containing the responses.
#
# Author: Adam Tupper
# Since: 17/05/19

#!/usr/bin/env Rscript

library(plyr)

# Check for responses file in command line arguments
args = commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  stop("The CSV file contatins the NASA-TLX responses must be supplied.", call.=FALSE)
} else {
  data_file = args[1]
}

# Load responses into dataframe
responses_df = read.csv(data_file)
responses_df$participant = as.factor(responses_df$participant)

# Perform Friedman tests
friedman.test(mental_demand ~ interface | participant, responses_df)
friedman.test(physical_demand ~ interface | participant, responses_df)
friedman.test(temporal_demand ~ interface | participant, responses_df)
friedman.test(performance ~ interface | participant, responses_df)
friedman.test(effort ~ interface | participant, responses_df)
friedman.test(frustration ~ interface | participant, responses_df)

# Pairwise Wilcoxon Signed Ranks Tests
pairwise.wilcox.test(responses_df$physical_demand, responses_df$interface, p.adjust.method="bonf", paired=TRUE)
pairwise.wilcox.test(responses_df$frustration, responses_df$interface, p.adjust.method="bonf", paired=TRUE)

# Print summary statistics
mental_demand_means = ddply(responses_df, c("interface"), summarise,
                       mean_mental_demand=mean(mental_demand), sd_mental_demand=sd(mental_demand))
physical_demand_means = ddply(responses_df, c("interface"), summarise,
                              mean_physical_demand=mean(physical_demand), sd_physical_demand=sd(physical_demand))
temporal_demand_means = ddply(responses_df, c("interface"), summarise,
                              mean_temporal_demand=mean(temporal_demand), sd_temporal_demand=sd(temporal_demand))
performance_means = ddply(responses_df, c("interface"), summarise,
                          mean_performance=mean(performance), sd_performance=sd(performance))
effort_means = ddply(responses_df, c("interface"), summarise,
                     mean_effort=mean(effort), sd_effort=sd(effort))
frustration_means = ddply(responses_df, c("interface"), summarise,
                          mean_frustration=mean(frustration), sd_frustration=sd(frustration))

cat("\n")
print(mental_demand_means)
cat("\n")
print(physical_demand_means)
cat("\n")
print(temporal_demand_means)
cat("\n")
print(performance_means)
cat("\n")
print(effort_means)
cat("\n")
print(frustration_means)
