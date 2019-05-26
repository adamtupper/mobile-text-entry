# Plot the speed, accuracy and NASA-TLX results.
#
# Author: Adam Tupper
# Since: 26/05/19

#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)
library(vwr)

source("src/TEMA_log_parsing.r")

# Load data
log_dir = "TEMA-logs/study/"
tlx_response_file = "NASA_TLX_responses.csv"
log_data = combine_TEMA_stats_logs(log_dir)
tlx_data = read.csv(tlx_response_file)

# Plot mean entry and error rates by trial for each condition
trial_data = ddply(log_data, c("trial", "condition"), summarise, mean_wpm=mean(wpm), mean_cer=mean(cer))

ggplot(trial_data, aes(trial, mean_wpm)) +
  geom_line(aes(group=condition, colour=condition)) +
  scale_color_discrete(name="Condtion") +
  labs(title="Entry Rates by Condition and Trial", x="Trial", y="Mean Entry Rate (WPM)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5))

ggplot(trial_data, aes(trial, mean_cer)) +
  geom_line(aes(group=condition, colour=condition)) +
  scale_color_discrete(name="Condtion") +
  labs(title="Error Rates by Condition and Trial", x="Trial", y="Mean Error Rate (CER)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5))

# Plot mean entry rates and error rates for each condition
condition_data = ddply(log_data,
                       c("posture", "interface"),
                       summarise,
                       mean_wpm=mean(wpm),
                       sd_wpm=sd(wpm),
                       mean_cer=mean(cer),
                       sd_cer=sd(cer))

ggplot(condition_data, aes(posture, mean_wpm, fill=interface)) +
  geom_col(position="dodge") +
  geom_errorbar(aes(ymin=mean_wpm - sd_wpm, ymax=mean_wpm + sd_wpm), width=0.2, position=position_dodge(0.9)) +
  scale_fill_discrete(name="Interface",
                      labels=c("SGK", "STK")) +
  labs(title="Entry Rates by Posture and Interface", x="Posture", y="Mean Entry Rate (WPM)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1))
  
ggplot(condition_data, aes(posture, mean_cer, fill=interface)) +
  geom_col(position="dodge") +
  geom_errorbar(aes(ymin=max(mean_cer - sd_cer, 0), ymax=mean_cer + sd_cer), width=0.2, position=position_dodge(0.9)) +
  scale_fill_discrete(name="Interface",
                      labels=c("SGK", "STK")) +
  labs(title="Error Rates by Posture and Interface", x="Posture", y="Mean Error Rate (CER)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1))
