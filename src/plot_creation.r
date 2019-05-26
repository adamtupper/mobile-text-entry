# Plot the speed, accuracy and NASA-TLX results.
#
# Author: Adam Tupper
# Since: 26/05/19

#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)
library(vwr)
library(gridExtra)

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
  theme_bw() +
  geom_col(position="dodge") +
  geom_errorbar(aes(ymin=mean_wpm - sd_wpm, ymax=mean_wpm + sd_wpm), width=0.2, position=position_dodge(0.9)) +
  scale_fill_manual(name="Interface",
                    labels=c("SGK", "STK"),
                    values=c(cbp[3], cbp[7])) +
  labs(title="Entry Rates by Posture and Interface", x="Posture", y="Mean Entry Rate (WPM)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1))
  
ggplot(condition_data, aes(posture, mean_cer, fill=interface)) +
  theme_bw() +
  geom_col(position="dodge") +
  geom_errorbar(aes(ymin=pmax(mean_cer - sd_cer, 0), ymax=mean_cer + sd_cer), width=0.2, position=position_dodge(0.9)) +
  scale_fill_manual(name="Interface",
                    labels=c("SGK", "STK"),
                    values=c(cbp[3], cbp[7])) +
  labs(title="Error Rates by Posture and Interface", x="Posture", y="Mean Error Rate (CER)") +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1))

# Plot NASA-TLX Results
cbp <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
tlx_condition_data = ddply(tlx_data,
                           c("interface"),
                           summarise,
                           mean_mental_demand=mean(mental_demand),
                           sd_mental_demand=sd(mental_demand),
                           mean_physical_demand=sd(physical_demand),
                           sd_physical_demand=sd(physical_demand),
                           mean_temporal_demand=mean(temporal_demand),
                           sd_temporal_demand=sd(temporal_demand),
                           mean_performance=mean(performance),
                           sd_performance=sd(performance),
                           mean_effort=mean(effort),
                           sd_effort=sd(effort),
                           mean_frustration=mean(frustration),
                           sd_frustration=sd(frustration))

plot_mental_demand = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_mental_demand), color=cbp[2], fill=cbp[2]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_mental_demand - sd_mental_demand, 0),
                    ymax=(mean_mental_demand + sd_mental_demand)),
                width=0.2) +
  labs(title="Mental Demand", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

plot_physical_demand = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_physical_demand), color=cbp[3], fill=cbp[3]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_physical_demand - sd_physical_demand, 0),
                    ymax=(mean_physical_demand + sd_physical_demand)),
                width=0.2) +
  labs(title="Physical Demand", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

plot_temporal_demand = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_temporal_demand), color=cbp[4], fill=cbp[4]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_temporal_demand - sd_temporal_demand, 0),
                    ymax=(mean_temporal_demand + sd_temporal_demand)),
                width=0.2) +
  labs(title="Rushed/Hurried", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

plot_performance = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_performance), color=cbp[6], fill=cbp[6]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_performance - sd_performance, 0),
                    ymax=(mean_performance + sd_performance)),
                width=0.2) +
  labs(title="Perceived Performance", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

plot_effort = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_effort), color=cbp[7], fill=cbp[7]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_effort - sd_effort, 0),
                    ymax=pmin(mean_effort + sd_effort, 20)),
                width=0.2) +
  labs(title="Effort", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

plot_frustration = ggplot(tlx_condition_data) +
  geom_col(aes(interface, mean_frustration), color=cbp[8], fill=cbp[8]) +
  geom_errorbar(aes(x=interface,
                    ymin=pmax(mean_frustration - sd_frustration, 0),
                    ymax=(mean_frustration + sd_frustration)),
                width=0.2) +
  labs(title="Frustration", x="Condition", y="Mean Score (Lower is Better)") +
  theme_bw() +
  theme(plot.title=element_text(hjust=0.5, vjust=0.5),
        legend.position = c(0.01, 0.99), 
        legend.justification = c(0, 1)) +
  ylim(0, 20)

grid.arrange(plot_mental_demand,
             plot_physical_demand,
             plot_temporal_demand,
             plot_performance,
             plot_effort,
             plot_frustration,
             ncol=2)
