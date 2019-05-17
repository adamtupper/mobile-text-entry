# Perform Friedman test analyses for NASA-TLX responses.
#
# User must provide the path to the CSV file containing the responses.
#
# Author: Adam Tupper
# Since: 17/05/19

#!/usr/bin/env Rscript

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
