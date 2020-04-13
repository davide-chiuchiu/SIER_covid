library(readxl)
library(tidyverse)
library(lubridate)

# Go to working directory
setwd("~/Documents/SIER_covid/Containment_data")

# File to open to process containment informations
containment_measures <- 'containment_infos.xlsx'

# import excel file
containment_measures_europe <- read_excel(containment_measures)

containment_measures_europe %>%
  ggplot(aes(x = Date)) + 
  geom_bar() +
  facet_wrap(~ Measure)

summarize_intervention <- containment_measures_europe %>%
  group_by(Measure) %>%
  summarize(Median_implementation_date = median(Date, na.rm = TRUE)) %>%
  arrange(Median_implementation_date) %>%
  mutate(Measure = as.factor(Measure))

R0_suppression <- data.frame(Measure                 = c('Case isolation',    'Public events ban', 'School closure',    'Lockdown',         'Social distancing'), 
                             R0_reduction_lower_est  = c(0.23201856148492084, 0.23201856148492084, 0.23201856148492084, 1.3921113689095108, 0.23201856148492084), 
                             R0_reduction_median_est = c(8.352668213457079,   7.192575406032482,   15.545243619489561,  45.93967517401393,  6.496519721577727),
                             R0_reduction_upper_est  = c(23.201856148491885,  25.754060324825986,  44.54756380510442,   87.70301624129932,  24.129930394431554))


summarize_intervention <- summarize_intervention %>%
  left_join(R0_suppression, by = 'Measure')


