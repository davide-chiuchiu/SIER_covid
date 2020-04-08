library(data.table)
library(tidyverse)
library(lubridate)
library(gridExtra)


# Go to working directory
setwd("~/Documents/SIER_covid/Data_from_online_SEIR")

# file names
no_mitigation       <- 'covid.results.deterministic_no_mitigation.csv'
moderate_mitigation <- 'covid.results.deterministic_moderate_mitigation.csv'
strong_mitigation   <- 'covid.results.deterministic_strong_mitigation.csv'

# load data from csv and append them in the covid_dataframe
covid_no_mitigation <- fread(no_mitigation) %>%
  mutate(mitigation_type = 'No mitigation')
covid_moderate_mitigation <- fread(moderate_mitigation) %>%
  mutate(mitigation_type = 'Moderate mitigation')
covid_strong_mitigation <- fread(strong_mitigation) %>%
  mutate(mitigation_type = 'Strong mitigation')

covid_dataframe <- bind_rows(covid_no_mitigation, covid_moderate_mitigation, covid_strong_mitigation) %>%
                    mutate(time = ymd(time), mitigation_type = as_factor(mitigation_type)) %>%
                    # gather data to ease plot
                    gather(key = "observable", value = "counts", c(infectious, ICU, overflow))

# Renaming of observables for plot purposes
covid_dataframe$observable[covid_dataframe$observable == 'overflow'] <- 'ICU overflow'
covid_dataframe$observable[covid_dataframe$observable == 'ICU'] <- 'ICU occupants'

# summary of hospitalized, critical and fatalities
proto_summary_cases <- covid_dataframe %>%
                      group_by(mitigation_type) %>%
                      summarize(total_hospitalized = max(cumulative_hospitalized), total_critical_infections = max(cumulative_critical), total_deceased = max(cumulative_fatality)) 
summary_cases <- proto_summary_cases%>%
                 gather(key = 'totals', value = 'total_nums', total_hospitalized:total_deceased)


# plot of data
covid_dataframe %>% ggplot(aes(x = time, y = counts, color = observable)) +
  geom_hline(aes(yintercept= 100, linetype = "ICU beds")) +
  geom_hline(aes(yintercept= 8199, linetype = "Total hospital beds")) +
  geom_line() +
  facet_wrap( ~ mitigation_type ) +
  scale_y_log10()

summary_cases %>% ggplot(aes(x = mitigation_type, y = total_nums)) +
  geom_col() +
  facet_wrap( ~ totals ) + 
  scale_y_log10() +
  coord_flip()

pdf("summary_totalss.pdf", height=11, width=10)
grid.table(proto_summary_cases)
dev.off()